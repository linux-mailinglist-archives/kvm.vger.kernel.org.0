Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614D5179D67
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 02:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCEBeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 20:34:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:31873 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbgCEBel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 20:34:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 17:34:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,516,1574150400"; 
   d="scan'208";a="234301764"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 04 Mar 2020 17:34:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pu Wen <puwen@hygon.cn>
Subject: [PATCH v2 7/7] KVM: x86: Refactor kvm_cpuid() param that controls out-of-range logic
Date:   Wed,  4 Mar 2020 17:34:37 -0800
Message-Id: <20200305013437.8578-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305013437.8578-1-sean.j.christopherson@intel.com>
References: <20200305013437.8578-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invert and rename the kvm_cpuid() param that controls out-of-range logic
to better reflect the semantics of the affected callers, i.e. callers
that bypass the out-of-range logic do so because they are looking up an
exact guest CPUID entry, e.g. to query the maxphyaddr.

Similarly, rename kvm_cpuid()'s internal "found" to "exact" to clarify
that it tracks whether or not the exact requested leaf was found, as
opposed to any usable leaf being found.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_emulate.h |  2 +-
 arch/x86/kvm/cpuid.c               | 14 +++++++-------
 arch/x86/kvm/cpuid.h               |  2 +-
 arch/x86/kvm/emulate.c             |  8 ++++----
 arch/x86/kvm/svm.c                 |  2 +-
 arch/x86/kvm/x86.c                 |  5 +++--
 6 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 0fb41a2c972f..e20d16bd81d3 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -221,7 +221,7 @@ struct x86_emulate_ops {
 			 enum x86_intercept_stage stage);
 
 	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt, u32 *eax, u32 *ebx,
-			  u32 *ecx, u32 *edx, bool check_limit);
+			  u32 *ecx, u32 *edx, bool exact_only);
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e4f104c7ace8..d8a190d5dac0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1062,16 +1062,16 @@ get_out_of_range_cpuid_entry(struct kvm_vcpu *vcpu, u32 *fn_ptr, u32 index)
 }
 
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
-	       u32 *ecx, u32 *edx, bool check_limit)
+	       u32 *ecx, u32 *edx, bool exact_only)
 {
 	u32 orig_function = *eax, function = *eax, index = *ecx;
 	struct kvm_cpuid_entry2 *entry;
-	bool found;
+	bool exact;
 
 	entry = kvm_find_cpuid_entry(vcpu, function, index);
-	found = entry;
+	exact = !!entry;
 
-	if (!entry && check_limit)
+	if (!entry && !exact_only)
 		entry = get_out_of_range_cpuid_entry(vcpu, &function, index);
 
 	if (entry) {
@@ -1102,8 +1102,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
-	return found;
+	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, exact);
+	return exact;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
 
@@ -1116,7 +1116,7 @@ int kvm_emulate_cpuid(struct kvm_vcpu *vcpu)
 
 	eax = kvm_rax_read(vcpu);
 	ecx = kvm_rcx_read(vcpu);
-	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
+	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
 	kvm_rax_write(vcpu, eax);
 	kvm_rbx_write(vcpu, ebx);
 	kvm_rcx_write(vcpu, ecx);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 332068db0fc2..917ee014af55 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -23,7 +23,7 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries);
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
-	       u32 *ecx, u32 *edx, bool check_limit);
+	       u32 *ecx, u32 *edx, bool exact_only);
 
 int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7391e1471e53..d54e259fbbfd 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2711,7 +2711,7 @@ static bool vendor_intel(struct x86_emulate_ctxt *ctxt)
 	u32 eax, ebx, ecx, edx;
 
 	eax = ecx = 0;
-	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
+	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
 	return is_guest_vendor_intel(ebx, ecx, edx);
 }
 
@@ -2729,7 +2729,7 @@ static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt)
 
 	eax = 0x00000000;
 	ecx = 0x00000000;
-	ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
+	ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
 	/*
 	 * remark: Intel CPUs only support "syscall" in 64bit longmode. Also a
 	 * 64bit guest with a 32bit compat-app running will #UD !! While this
@@ -3980,7 +3980,7 @@ static int em_cpuid(struct x86_emulate_ctxt *ctxt)
 
 	eax = reg_read(ctxt, VCPU_REGS_RAX);
 	ecx = reg_read(ctxt, VCPU_REGS_RCX);
-	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, true);
+	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
 	*reg_write(ctxt, VCPU_REGS_RAX) = eax;
 	*reg_write(ctxt, VCPU_REGS_RBX) = ebx;
 	*reg_write(ctxt, VCPU_REGS_RCX) = ecx;
@@ -4250,7 +4250,7 @@ static int check_cr_write(struct x86_emulate_ctxt *ctxt)
 			eax = 0x80000008;
 			ecx = 0;
 			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
-						 &edx, false))
+						 &edx, true))
 				maxphyaddr = eax & 0xff;
 			else
 				maxphyaddr = 36;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 48c9390011d0..fbe5252be3d9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2171,7 +2171,7 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	}
 	init_vmcb(svm);
 
-	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true);
+	kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, false);
 	kvm_rdx_write(vcpu, eax);
 
 	if (kvm_vcpu_apicv_active(vcpu) && !init_event)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a4836ed1230..3e44fac4fb09 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6205,9 +6205,10 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
 }
 
 static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
-			u32 *eax, u32 *ebx, u32 *ecx, u32 *edx, bool check_limit)
+			      u32 *eax, u32 *ebx, u32 *ecx, u32 *edx,
+			      bool exact_only)
 {
-	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, check_limit);
+	return kvm_cpuid(emul_to_vcpu(ctxt), eax, ebx, ecx, edx, exact_only);
 }
 
 static bool emulator_guest_has_long_mode(struct x86_emulate_ctxt *ctxt)
-- 
2.24.1

