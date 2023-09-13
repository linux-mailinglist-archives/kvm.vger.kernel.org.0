Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B294279ED62
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjIMPkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjIMPkY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9907C2688;
        Wed, 13 Sep 2023 08:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619607; x=1726155607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sYP49dK2oxOTpf79bU0UCRFF7UdZvsCCVBsOgfbJ9K4=;
  b=nCPa2Pan4mHp/L02eabeqOEjY5Su4UEYiBcZ6lRnnSW2TfSskIHbMcBj
   /E0f4uC8miicwefuwXIlZcmf0HrU/K7lyastpYZgMXoVgluwYG8ZZnbjF
   BVA5UjYLqkYZBUydJVOpCf8Gs4ZjLznLseoZd/WQfOJIRtV0u/40XGza+
   2a0ZGDLaYHeEiSY7AxZpXuli1UZMMjqqeJmoq4riTIEphb9f72i+3Te1s
   IdVALYmEVgkJcaRCdrPjetYoCGBJ2uNiOM0DIrtiaiAGduD0iKie1YRlV
   HuswHhU6joLuReSHQe9eKL3QNKOm3pI8qM3vUzLLXRQ2n2gECe9MNQQla
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030232"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030232"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852187"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852187"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:03 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 09/16] KVM: x86: Untag address for vmexit handlers when LAM applicable
Date:   Wed, 13 Sep 2023 20:42:20 +0800
Message-Id: <20230913124227.12574-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add and call vmx_get_untagged_addr() for 64-bit memory operand in vmexit
handlers when LAM is applicable. Also wire get_untagged_addr() interface.

As of now, vmx_get_untagged_addr() doesn't do untag yet.

For vmexit handlers related to 64-bit linear address:
- Cases need to untag address (handled in get_vmx_mem_address())
  Operand(s) of VMX instructions and INVPCID.
  Operand(s) of SGX ENCLS.
- Cases LAM doesn't apply to (no change needed)
  Operand of INVLPG.
  Linear address in INVPCID descriptor.
  Linear address in INVVPID descriptor.
  BASEADDR specified in SESC of ECREATE.

Note:
LAM doesn't apply to the writes to control registers or MSRs.
LAM masking applies before paging, so the faulting linear address in CR2
doesn't contain the metadata.
The guest linear address saved in VMCS doesn't contain metadata.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 5 +++++
 arch/x86/kvm/vmx/sgx.c    | 1 +
 arch/x86/kvm/vmx/vmx.c    | 7 +++++++
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 arch/x86/kvm/x86.c        | 4 ++++
 5 files changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51622878d6e4..4ba46e1b29d2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4980,6 +4980,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		else
 			*ret = off;
 
+		*ret = vmx_get_untagged_addr(vcpu, *ret, 0);
 		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
@@ -5797,6 +5798,10 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
+		/*
+		 * LAM doesn't apply to addresses that are inputs to TLB
+		 * invalidation.
+		 */
 		if (!operand.vpid ||
 		    is_noncanonical_address(operand.gla, vcpu))
 			return nested_vmx_fail(vcpu,
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 3e822e582497..6fef01e0536e 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -37,6 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 	if (!IS_ALIGNED(*gva, alignment)) {
 		fault = true;
 	} else if (likely(is_64_bit_mode(vcpu))) {
+		*gva = vmx_get_untagged_addr(vcpu, *gva, 0);
 		fault = is_noncanonical_address(*gva, vcpu);
 	} else {
 		*gva &= 0xffffffff;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6eba8c08eff6..b572cfe27342 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8209,6 +8209,11 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags)
+{
+	return gva;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -8349,6 +8354,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.get_untagged_addr = vmx_get_untagged_addr,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..45cee1a8bc0a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -420,6 +420,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e03313287816..4c2cdfcae79d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13396,6 +13396,10 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
+		/*
+		 * LAM doesn't apply to addresses that are inputs to TLB
+		 * invalidation.
+		 */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
 			kvm_inject_gp(vcpu, 0);
-- 
2.25.1

