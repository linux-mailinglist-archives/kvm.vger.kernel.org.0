Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6376FD684
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 08:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbjEJGHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 02:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbjEJGGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 02:06:53 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F046A5;
        Tue,  9 May 2023 23:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683698810; x=1715234810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GGn29ECvpJmP0AgZ1txYL5FeRblJ2sgJYL8H57x43AY=;
  b=fN0+jb4XQNHo381K0M55dH2juNq1s1r5JEbljlEFVJ516KSbGcWhib9w
   751AKvfyxzW5+U9SYs9h5Z3c0B/GHc82F84xh4JVEp5LhdYD279CS5yOH
   JPLX+8COyN2TDB49m9+/K2fmjEVrHFe0ZFrsUa3oGJxn99dwhluuKn/GU
   2iUi+B6N9zrBFzRUPjOP5DP0A1kagbfpeS2pTldjrCzVjpUOXe19dO963
   PqXBUG9n4Ucpx1dErSJ46seNuesB0JMTJJDYbuayn/KRggO0SIndnbp/g
   D1cqsulq8gXnBE/VnPnzUshV6wWKKlUkntimZu757DfYjXPbmHnO80G7+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348969275"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348969275"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="768803128"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="768803128"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.238.8.90])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 23:06:48 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hu@linux.intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v8 5/6] KVM: x86: Untag address when LAM applicable
Date:   Wed, 10 May 2023 14:06:10 +0800
Message-Id: <20230510060611.12950-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230510060611.12950-1-binbin.wu@linux.intel.com>
References: <20230510060611.12950-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Untag address for 64-bit memory/MMIO operand in instruction emulations
and VMExit handlers when LAM is applicable.

For instruction emulation, untag address in __linearize() before
canonical check. LAM doesn't apply to addresses used for instruction
fetches or to those that specify the targets of jump and call instructions,
use X86EMUL_F_SKIPLAM to skip LAM untag.

For VMExit handlers related to 64-bit linear address:
- Cases need to untag address
  Operand(s) of VMX instructions and INVPCID.
  Operand(s) of SGX ENCLS.
- Cases LAM doesn't apply to
  Operand of INVLPG.
  Linear address in INVPCID descriptor (no change needed).
  Linear address in INVVPID descriptor (it has been confirmed, although it is
  not called out in LAM spec, no change needed).

Note:
LAM doesn't apply to the writes to control registers or MSRs.
LAM masking applies before paging, so the faulting linear address in CR2
doesn't contain the metadata.
The guest linear address saved in VMCS doesn't contain metadata.

Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c     | 15 ++++++++++++---
 arch/x86/kvm/kvm_emulate.h |  2 ++
 arch/x86/kvm/vmx/nested.c  |  2 ++
 arch/x86/kvm/vmx/sgx.c     |  1 +
 arch/x86/kvm/x86.c         |  7 +++++++
 5 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9508836e8a35..7cacba2f7616 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -703,6 +703,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	*max_size = 0;
 	switch (mode) {
 	case X86EMUL_MODE_PROT64:
+		ctxt->ops->untag_addr(ctxt, (u64 *)&la, flags);
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
 		if (!__is_canonical_address(la, va_bits))
@@ -774,7 +775,11 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 	unsigned max_size;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = dst };
-	u32 flags = X86EMUL_F_FETCH;
+	/*
+	 * LAM doesn't apply to addresses that specify the targets of jump and
+	 * call instructions.
+	 */
+	u32 flags = X86EMUL_F_FETCH | X86EMUL_F_SKIPLAM;
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
@@ -903,7 +908,8 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = ctxt->eip + cur_size };
-	u32 flags = X86EMUL_F_FETCH;
+	/* LAM doesn't apply to addresses used for instruction fetches */
+	u32 flags = X86EMUL_F_FETCH | X86EMUL_F_SKIPLAM;
 
 	/*
 	 * We do not know exactly how many bytes will be needed, and
@@ -3448,8 +3454,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	ulong linear;
+	unsigned max_size;
 
-	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
+	/* LAM doesn't apply to invlpg */
+	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1,
+			 X86EMUL_F_SKIPLAM, ctxt->mode, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->ops->invlpg(ctxt, linear);
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c2091e24a6b9..56fe18ddbabd 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -230,6 +230,8 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+
+	void (*untag_addr)(struct x86_emulate_ctxt *ctxt, u64 *addr, u32 flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 11b12a75ca91..347e4e713fa2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4981,6 +4981,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		else
 			*ret = off;
 
+		vmx_untag_addr(vcpu, (u64 *)ret, 0);
 		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
@@ -5798,6 +5799,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
+		/* LAM doesn't apply to the address in descriptor of invvpid */
 		if (!operand.vpid ||
 		    is_noncanonical_address(operand.gla, vcpu))
 			return nested_vmx_fail(vcpu,
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 0574030b071f..f6c4ef351885 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -37,6 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 	if (!IS_ALIGNED(*gva, alignment)) {
 		fault = true;
 	} else if (likely(is_64_bit_mode(vcpu))) {
+		vmx_untag_addr(vcpu, (u64 *)gva, 0);
 		fault = is_noncanonical_address(*gva, vcpu);
 	} else {
 		*gva &= 0xffffffff;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f0059a1e9ac8..0a2c7d483822 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8283,6 +8283,11 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static void emulator_untag_addr(struct x86_emulate_ctxt *ctxt, u64 *addr, u32 flags)
+{
+	static_call(kvm_x86_untag_addr)(emul_to_vcpu(ctxt), addr, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8328,6 +8333,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.untag_addr          = emulator_untag_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
@@ -13354,6 +13360,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
+		/* LAM doesn't apply to the address in descriptor of invpcid */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
 			kvm_inject_gp(vcpu, 0);
-- 
2.25.1

