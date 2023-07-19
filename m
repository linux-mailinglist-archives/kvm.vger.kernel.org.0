Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154EB7598B7
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 16:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjGSOm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 10:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjGSOmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 10:42:18 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F6C1998;
        Wed, 19 Jul 2023 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689777718; x=1721313718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9tzdyr8Nwdr2cDr+oF8CF+gOivnvV07tHfnZIWKdZDg=;
  b=nBhJr0DItiSUkexKF+sEQiWt8As29OF53020ZcXFqAFQK8CHnq3XympW
   AAoRp8LGc1VNjFKLjYKgyUyENMUF8ROaEsmEiw1kvz7+vLdpYRS8pL9B4
   XYj3479vDIScrkixVT17Tdqo3K1XuHhd1gQdV0olOw6woeBtX2Z1pPImN
   y/7vvQ3wh6BH2prLCtU0SgRQvXC97ZEZBZ8fA31dF4D3UItJgA2QccL2i
   9gblQDORTQL0h8tole4z0nvjlEBiNDZjVCt4M1eTjw78yqUMO0hG2Y/Pu
   yijg/Wy6q3vOgX1rWD27z/SB0eDewRuwqSGXjqlCU1eHpSdmRh17XT1fc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="346788214"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="346788214"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="867503344"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.173.69])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 07:41:55 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v10 8/9] KVM: x86: Untag address for vmexit handlers when LAM applicable
Date:   Wed, 19 Jul 2023 22:41:30 +0800
Message-Id: <20230719144131.29052-9-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719144131.29052-1-binbin.wu@linux.intel.com>
References: <20230719144131.29052-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Untag address for 64-bit memory operand in VMExit handlers when LAM is applicable.

For VMExit handlers related to 64-bit linear address:
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
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/sgx.c    | 1 +
 arch/x86/kvm/vmx/vmx.c    | 3 +--
 arch/x86/kvm/vmx/vmx.h    | 2 ++
 arch/x86/kvm/x86.c        | 1 +
 5 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76c9904c6625..bd2c8936953a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4980,6 +4980,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		else
 			*ret = off;
 
+		*ret = vmx_get_untagged_addr(vcpu, *ret, 0);
 		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
@@ -5797,6 +5798,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
+		/* LAM doesn't apply to the address in descriptor of invvpid */
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
index abf6d42672cd..f18e610c4363 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8177,8 +8177,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
-static gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
-			    unsigned int flags)
+gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags)
 {
 	unsigned long cr3_bits;
 	int lam_bit;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 32384ba38499..6fb612355769 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -421,6 +421,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+
 static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 					     int type, bool value)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 339a113b45af..d2a0cdfb77a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13370,6 +13370,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
+		/* LAM doesn't apply to the address in descriptor of invpcid */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
 			kvm_inject_gp(vcpu, 0);
-- 
2.25.1

