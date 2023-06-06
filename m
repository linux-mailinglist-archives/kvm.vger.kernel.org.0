Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78B3723D04
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 11:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbjFFJTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 05:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbjFFJTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 05:19:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18A5109;
        Tue,  6 Jun 2023 02:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686043142; x=1717579142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aY9vZ7OdAvetDBnIgQIM1XblN5ppn5oA9IdqqTFNP8k=;
  b=EN1XQAytffK1SHHGCPx3WAZ7ltespkp/Dl4zfsiTL7OIWLw3dgG9eYbM
   VOoPfQG75InzLaJjYdiGQ+Y36aefjBO5SyfHLG+ZxjwHwPZpEctGBgjrw
   ycnJOB/Xu1561jIsUrmChs3CocaL94lf3J5u0Bxj9Pp2uunyHp4MnLwHn
   BBsMJVe+eZUTXXgHepowiA8rxLmHLBZWY0vCdcTdrGtCUwKaLYQmWeGbl
   n87ci23bpne2dZEwrEqW9GvniE2GYfIQwAiCCG4/EXjG+n5uK6sfKPTzk
   4PRAzLBi0crSquO5KM7CPBfvy9ddXCvo//+I0y/sI1wPxWodZ8O91998I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="341252854"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="341252854"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:19:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883263683"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="883263683"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.249.170.159])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 02:18:59 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, binbin.wu@linux.intel.com
Subject: [PATCH v9 5/6] KVM: x86: Untag address when LAM applicable
Date:   Tue,  6 Jun 2023 17:18:41 +0800
Message-Id: <20230606091842.13123-6-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230606091842.13123-1-binbin.wu@linux.intel.com>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
  BASEADDR specified in SESC of ECREATE (no change needed).

Note:
LAM doesn't apply to the writes to control registers or MSRs.
LAM masking applies before paging, so the faulting linear address in CR2
doesn't contain the metadata.
The guest linear address saved in VMCS doesn't contain metadata.

Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c     | 16 +++++++++++++---
 arch/x86/kvm/kvm_emulate.h |  2 ++
 arch/x86/kvm/vmx/nested.c  |  2 ++
 arch/x86/kvm/vmx/sgx.c     |  1 +
 arch/x86/kvm/x86.c         |  7 +++++++
 5 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e89afc39e56f..c135adb26f1e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -701,6 +701,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	*max_size = 0;
 	switch (mode) {
 	case X86EMUL_MODE_PROT64:
+		ctxt->ops->untag_addr(ctxt, &la, flags);
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
 		if (!__is_canonical_address(la, va_bits))
@@ -771,8 +772,12 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
+	/*
+	 * LAM doesn't apply to addresses that specify the targets of jump and
+	 * call instructions.
+	 */
 	rc = __linearize(ctxt, addr, &max_size, 1, ctxt->mode, &linear,
-			 X86EMUL_F_FETCH);
+			 X86EMUL_F_FETCH | X86EMUL_F_SKIPLAM);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
@@ -907,9 +912,11 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	 * __linearize is called with size 0 so that it does not do any
 	 * boundary check itself.  Instead, we use max_size to check
 	 * against op_size.
+	 *
+	 * LAM doesn't apply to addresses used for instruction fetches.
 	 */
 	rc = __linearize(ctxt, addr, &max_size, 0, ctxt->mode, &linear,
-			 X86EMUL_F_FETCH);
+			 X86EMUL_F_FETCH | X86EMUL_F_SKIPLAM);
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
 
@@ -3442,8 +3449,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	ulong linear;
+	unsigned max_size;
 
-	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
+	/* LAM doesn't apply to invlpg */
+	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, ctxt->mode,
+		&linear, X86EMUL_F_SKIPLAM);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->ops->invlpg(ctxt, linear);
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c2091e24a6b9..3875ab175cd2 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -230,6 +230,8 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+
+	void (*untag_addr)(struct x86_emulate_ctxt *ctxt, gva_t *addr, u32 flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 11b12a75ca91..6c8dab9999f2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4981,6 +4981,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		else
 			*ret = off;
 
+		vmx_untag_addr(vcpu, ret, 0);
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
index 2261b684a7d4..b4faa94bace7 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -37,6 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 	if (!IS_ALIGNED(*gva, alignment)) {
 		fault = true;
 	} else if (likely(is_64_bit_mode(vcpu))) {
+		vmx_untag_addr(vcpu, gva, 0);
 		fault = is_noncanonical_address(*gva, vcpu);
 	} else {
 		*gva &= 0xffffffff;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 709fc920f378..ed2dca55573b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8296,6 +8296,11 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static void emulator_untag_addr(struct x86_emulate_ctxt *ctxt, gva_t *addr, u32 flags)
+{
+	static_call(kvm_x86_untag_addr)(emul_to_vcpu(ctxt), addr, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8341,6 +8346,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.untag_addr          = emulator_untag_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
@@ -13367,6 +13373,7 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
+		/* LAM doesn't apply to the address in descriptor of invpcid */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
 			kvm_inject_gp(vcpu, 0);
-- 
2.25.1

