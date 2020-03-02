Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E0017646C
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBT5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:57:41 -0500
Received: from mga05.intel.com ([192.55.52.43]:30422 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbgCBT5j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:57:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:57:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="438404982"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 02 Mar 2020 11:57:38 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 3/6] KVM: x86: Add dedicated emulator helper for grabbing CPUID.maxphyaddr
Date:   Mon,  2 Mar 2020 11:57:33 -0800
Message-Id: <20200302195736.24777-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302195736.24777-1-sean.j.christopherson@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to retrieve cpuid_maxphyaddr() instead of manually
calculating the value in the emulator via raw CPUID output.  In addition
to consolidating logic, this also paves the way toward simplifying
kvm_cpuid(), whose somewhat confusing return value exists purely to
support the emulator's maxphyaddr calculation.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  1 +
 arch/x86/kvm/emulate.c             | 10 +---------
 arch/x86/kvm/x86.c                 |  6 ++++++
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index bf5f5e476f65..ded06515d30f 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -222,6 +222,7 @@ struct x86_emulate_ops {
 
 	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
 			  u32 *ecx, u32 *edx, bool check_limit);
+	int (*get_cpuid_maxphyaddr)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index dd19fb3539e0..bf02ed51e90f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4244,16 +4244,8 @@ static int check_cr_write(struct x86_emulate_ctxt *ctxt)
 
 		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
 		if (efer & EFER_LMA) {
-			u64 maxphyaddr;
-			u32 eax, ebx, ecx, edx;
+			int maxphyaddr = ctxt->ops->get_cpuid_maxphyaddr(ctxt);
 
-			eax = 0x80000008;
-			ecx = 0;
-			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
-						 &edx, false))
-				maxphyaddr = eax & 0xff;
-			else
-				maxphyaddr = 36;
 			rsvd = rsvd_bits(maxphyaddr, 63);
 			if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PCIDE)
 				rsvd &= ~X86_CR3_PCID_NOFLUSH;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddd1d296bd20..5467ee71c25b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6209,6 +6209,11 @@ static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
 	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, check_limit);
 }
 
+static int emulator_get_cpuid_maxphyaddr(struct x86_emulate_ctxt *ctxt)
+{
+	return cpuid_maxphyaddr(emul_to_vcpu(ctxt));
+}
+
 static bool emulator_guest_has_long_mode(struct x86_emulate_ctxt *ctxt)
 {
 	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_LM);
@@ -6301,6 +6306,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.fix_hypercall       = emulator_fix_hypercall,
 	.intercept           = emulator_intercept,
 	.get_cpuid           = emulator_get_cpuid,
+	.get_cpuid_maxphyaddr= emulator_get_cpuid_maxphyaddr,
 	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
-- 
2.24.1

