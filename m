Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BB9757EDE
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjGROBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjGROAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180CE10FF;
        Tue, 18 Jul 2023 07:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688827; x=1721224827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=FjO1js6m8X5U2Hjn/Wte4F1bCdmgu0s821wN9N/Sqeo=;
  b=EiA1Yjl+xfSctM8Dm1jN4qKxqqU/ZGHySOCq39KED7bJO484BIGIk4KN
   nlhGUBd5lsFuXFis3YOju0YoV7nCUKE7kco0NqNXiKGUQxh9SXyrYkZm+
   RB1Pud1hQkbht+4Y/WkK0oFAXSuxeVmeI5Q4n0ggfABswInCD8PufQmp2
   UD7+CI5YBOYIP3kf3i7YWEB64nC6X22516SrQWKUIEO7AaTgJZwsMCDCj
   6Re5qIeFpxTUSh0Ak6ZTUMIStKFfQlB9tEOrxq1zE3Ib3XxV37FK3POLC
   Z+3WOIXldW1uEXaZBKRF00L/PeVapDJ0b6Hy8it2IR5Bz36ea4H4G+1xU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676178"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676178"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291180"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291180"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:55 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 6/8] KVM: VMX: Implement and apply vmx_is_lass_violation() for LASS protection
Date:   Tue, 18 Jul 2023 21:18:42 +0800
Message-Id: <20230718131844.5706-7-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230718131844.5706-1-guang.zeng@intel.com>
References: <20230718131844.5706-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement and wire up vmx_is_lass_violation() in kvm_x86_ops for VMX.

LASS violation check takes effect in KVM emulation of instruction fetch
and data access including implicit access when vCPU is running in long
mode, and also involved in emulation of VMX instruction and SGX ENCLS
instruction to enforce the mode-based protections before paging.

But the target memory address of emulation of TLB invalidation and branch
instructions aren't subject to LASS as exceptions.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  3 ++-
 arch/x86/kvm/vmx/sgx.c    |  4 ++++
 arch/x86/kvm/vmx/vmx.c    | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e35cf0bd0df9..72e78566a3b6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4985,7 +4985,8 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
 		 */
-		exn = is_noncanonical_address(*ret, vcpu);
+		exn = is_noncanonical_address(*ret, vcpu) ||
+		      vmx_is_lass_violation(vcpu, *ret, len, 0);
 	} else {
 		/*
 		 * When not in long mode, the virtual/linear address is
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 2261b684a7d4..f8de637ce634 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -46,6 +46,10 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 			((s.base != 0 || s.limit != 0xffffffff) &&
 			(((u64)*gva + size - 1) > s.limit + 1));
 	}
+
+	if (!fault)
+		fault = vmx_is_lass_violation(vcpu, *gva, size, 0);
+
 	if (fault)
 		kvm_inject_gp(vcpu, 0);
 	return fault ? -EINVAL : 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..15a7c6e7a25d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8127,6 +8127,40 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
+			   unsigned int size, unsigned int flags)
+{
+	const bool is_supervisor_address = !!(addr & BIT_ULL(63));
+	const bool implicit = !!(flags & X86EMUL_F_IMPLICIT);
+	const bool fetch = !!(flags & X86EMUL_F_FETCH);
+	const bool is_wraparound_access = size ? (addr + size - 1) < addr : false;
+
+	if (!kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || !is_long_mode(vcpu))
+		return false;
+
+	/*
+	 * INVTLB isn't subject to LASS, e.g. to allow invalidating userspace
+	 * addresses without toggling RFLAGS.AC.  Branch targets aren't subject
+	 * to LASS in order to simplifiy far control transfers (the subsequent
+	 * fetch will enforce LASS as appropriate).
+	 */
+	if (flags & (X86EMUL_F_BRANCH | X86EMUL_F_INVTLB))
+		return false;
+
+	if (!implicit && vmx_get_cpl(vcpu) == 3)
+		return is_supervisor_address;
+
+	/* LASS is enforced for supervisor-mode access iff SMAP is enabled. */
+	if (!fetch && !kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP))
+		return false;
+
+	/* Like SMAP, RFLAGS.AC disables LASS checks in supervisor mode. */
+	if (!fetch && !implicit && (kvm_get_rflags(vcpu) & X86_EFLAGS_AC))
+		return false;
+
+	return is_wraparound_access ? true : !is_supervisor_address;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8266,6 +8300,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+	.is_lass_violation = vmx_is_lass_violation,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9e66531861cf..c1e541a790bb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -433,6 +433,9 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+bool vmx_is_lass_violation(struct kvm_vcpu *vcpu, unsigned long addr,
+			   unsigned int size, unsigned int flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
-- 
2.27.0

