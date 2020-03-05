Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2880179D64
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 02:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgCEBeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 20:34:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:31873 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgCEBel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 20:34:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 17:34:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="234301753"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2020 17:34:39 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor and Centaur classes
Date:   Wed,  4 Mar 2020 17:34:34 -0800
Message-Id: <20200305013437.8578-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305013437.8578-1-sean.j.christopherson@intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the masking in the out-of-range CPUID logic to handle the
Hypervisor sub-classes, as well as the Centaur class if the guest
virtual CPU vendor is Centaur.

Masking against 0x80000000 only handles basic and extended leafs, which
results in Hypervisor range checks being performed against the basic
CPUID class, and Centuar range checks being performed against the
Extended class.  E.g. if CPUID.0x40000000.EAX returns 0x4000000A and
there is no entry for CPUID.0x40000006, then function 0x40000006 would
be incorrectly reported as out of bounds.

While there is no official definition of what constitutes a class, the
convention established for Hypervisor classes effectively uses bits 31:8
as the mask by virtue of checking for different bases in increments of
0x100, e.g. KVM advertises its CPUID functions starting at 0x40000100
when HyperV features are advertised at the default base of 0x40000000.

The bad range check doesn't cause functional problems for any known VMM
because out-of-range semantics only come into play if the exact entry
isn't found, and VMMs either support a very limited Hypervisor range,
e.g. the official KVM range is 0x40000000-0x40000001 (effectively no
room for undefined leafs) or explicitly defines gaps to be zero, e.g.
Qemu explicitly creates zeroed entries up to the Cenatur and Hypervisor
limits (the latter comes into play when providing HyperV features).

The bad behavior can be visually confirmed by dumping CPUID output in
the guest when running Qemu with a stable TSC, as Qemu extends the limit
of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
without defining zeroed entries for 0x40000002 - 0x4000000f.

Note, documentation of Centaur/VIA CPUs is hard to come by.  Designating
0xc0000000 - 0xcfffffff as the Centaur class is a best guess as to the
behavior of a real Centaur/VIA CPU.

Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I don't particularly like the "!basic" check in cpuid_function_in_range(),
but it's semantically correct, it's just weird when verbalizing the logic.
E.g. "all functions are in range if there are no ranges".  I thought about
renaming and inverting the function so that the logic would read "all
functions are out of range if there are no ranges", but that added churn
without tangible value.

I could have buried the check in the Centaur leaf handling, which is why
it exists in this patch, but I didn't like the resulting code and the
whole weirdness goes away once the code is refactored to put all the
logic into a single helper.

 arch/x86/include/asm/kvm_emulate.h | 11 ++++++
 arch/x86/kvm/cpuid.c               | 54 ++++++++++++++++++++++++++----
 2 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 2754972c36e6..0fb41a2c972f 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -393,6 +393,10 @@ struct x86_emulate_ctxt {
 #define X86EMUL_CPUID_VENDOR_GenuineIntel_ecx 0x6c65746e
 #define X86EMUL_CPUID_VENDOR_GenuineIntel_edx 0x49656e69
 
+#define X86EMUL_CPUID_VENDOR_CentaurHauls_ebx 0x746e6543
+#define X86EMUL_CPUID_VENDOR_CentaurHauls_ecx 0x736c7561
+#define X86EMUL_CPUID_VENDOR_CentaurHauls_edx 0x48727561
+
 static inline bool is_guest_vendor_intel(u32 ebx, u32 ecx, u32 edx)
 {
 	return ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
@@ -417,6 +421,13 @@ static inline bool is_guest_vendor_hygon(u32 ebx, u32 ecx, u32 edx)
 	       edx == X86EMUL_CPUID_VENDOR_HygonGenuine_edx;
 }
 
+static inline bool is_guest_vendor_centaur(u32 ebx, u32 ecx, u32 edx)
+{
+	return ebx == X86EMUL_CPUID_VENDOR_CentaurHauls_ebx &&
+	       ecx == X86EMUL_CPUID_VENDOR_CentaurHauls_ecx &&
+	       edx == X86EMUL_CPUID_VENDOR_CentaurHauls_edx;
+}
+
 enum x86_intercept_stage {
 	X86_ICTP_NONE = 0,   /* Allow zero-init to not match anything */
 	X86_ICPT_PRE_EXCEPT,
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5a9891cb2bc6..dd3c91ffae11 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -985,16 +985,58 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 /*
- * If the basic or extended CPUID leaf requested is higher than the
- * maximum supported basic or extended leaf, respectively, then it is
- * out of range.
+ * Intel CPUID semantics treats any query for an out-of-range leaf as if the
+ * highest basic leaf (i.e. CPUID.0H:EAX) were requested.  AMD CPUID semantics
+ * returns all zeroes for any undefined leaf, whether or not the leaf is in
+ * range.  Centaur/VIA follows Intel semantics.
+ *
+ * A leaf is considered out-of-range if its function is higher than the maximum
+ * supported leaf of its associated class or if its associated class does not
+ * exist.
+ *
+ * There are three primary classes to be considered, with their respective
+ * ranges described as "<base> - <top>[,<base2> - <top2>] inclusive.  A primary
+ * class exists if a guest CPUID entry for its <base> leaf exists.  For a given
+ * class, CPUID.<base>.EAX contains the max supported leaf for the class.
+ *
+ *  - Basic:      0x00000000 - 0x3fffffff, 0x50000000 - 0x7fffffff
+ *  - Hypervisor: 0x40000000 - 0x4fffffff
+ *  - Extended:   0x80000000 - 0xffffffff
+ *
+ * The Hypervisor class is further subdivided into sub-classes that each act as
+ * their own indepdent class associated with a 0x100 byte range.  E.g. if Qemu
+ * is advertising support for both HyperV and KVM, the resulting Hypervisor
+ * CPUID sub-classes are:
+ *
+ *  - HyperV:     0x40000000 - 0x400000ff
+ *  - KVM:        0x40000100 - 0x400001ff
+ *
+ * If the guest vendor is Centaur, a fourth top-level class is defined and
+ * effectively steals its range from the Extended class.  I.e. the primary
+ * classes for a Centaur guest CPU become:
+ *
+ *  - Basic:      0x00000000 - 0x3fffffff, 0x50000000 - 0x7fffffff
+ *  - Hypervisor: 0x40000000 - 0x4fffffff
+ *  - Extended:   0x80000000 - 0xbfffffff, 0xd0000000 - 0xffffffff
+ *  - Centaur:    0xc0000000 - 0xcfffffff
  */
 static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
 {
-	struct kvm_cpuid_entry2 *max;
+	struct kvm_cpuid_entry2 *basic, *class;
 
-	max = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
-	return max && function <= max->eax;
+	basic = kvm_find_cpuid_entry(vcpu, 0, 0);
+	if (!basic)
+		return true;
+
+	if (function >= 0x40000000 && function <= 0x4fffffff)
+		class = kvm_find_cpuid_entry(vcpu, function & 0xffffff00, 0);
+	else if (function >= 0xc0000000 && function <= 0xcfffffff &&
+		 is_guest_vendor_centaur(basic->ebx, basic->ecx, basic->edx))
+		class = kvm_find_cpuid_entry(vcpu, function & 0xc0000000, 0);
+	else
+		class = kvm_find_cpuid_entry(vcpu, function & 0x80000000, 0);
+
+	return class && function <= class->eax;
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
-- 
2.24.1

