Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2953C6D624C
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 15:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbjDDNJo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 09:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbjDDNJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 09:09:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930411BE6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 06:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680613780; x=1712149780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AO+S72K+4y49T1asUpYGvxgUT+1zI3bcnbJrnZhKtOQ=;
  b=aCjKOT5JxNWqvyc8NPpErzEOgFUU+ch5qo2MbyAlZJ/SMfJEqd4doW0d
   G/ptjEFzN87bl/8UXe0D+KX/LNBK1R87sBWztb/R6ExZ5cm/O2q6T3+4m
   rtMekAiVBliXlRZ7uP93dWQboGKeTETNrR0nkvubFH3IGLeA+0slF4dEZ
   fBOE7t60jXFcGLK5B+tPvynSX9cYpyFTHBWU4WhsG8gc8AR1rCSDGsIYE
   ZjagsR8SwOquyvUEXsh+OsMngC0ayxKKJ8GEGCCu+CgqVX4yfI1XTjtxd
   ibb/BNcqKKch7ki1+axy3v9XkRAVrbUCpp/MzMuXkLGJ/N60TBdSOiMfN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="326193437"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="326193437"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="750902104"
X-IronPort-AV: E=Sophos;i="5.98,317,1673942400"; 
   d="scan'208";a="750902104"
Received: from binbinwu-mobl.ccr.corp.intel.com ([10.254.215.140])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 06:09:38 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com
Cc:     binbin.wu@linux.intel.com, kai.huang@intel.com, chao.gao@intel.com,
        xuelian.guo@intel.com, robert.hu@linux.intel.com
Subject: [PATCH v7 4/5] KVM: x86: Untag address when LAM applicable
Date:   Tue,  4 Apr 2023 21:09:22 +0800
Message-Id: <20230404130923.27749-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230404130923.27749-1-binbin.wu@linux.intel.com>
References: <20230404130923.27749-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Untag address for 64-bit memory/mmio operand in instruction emulations
and vmexit handlers when LAM is applicable.

For instruction emulation, untag address in __linearize() before
canonical check. LAM doesn't apply to instruction fetch and invlpg,
use KVM_X86_UNTAG_ADDR_SKIP_LAM to skip LAM untag.

For vmexit handlings related to 64-bit linear address:
- Cases need to untag address
  Operand(s) of VMX instructions and INVPCID
  Operand(s) of SGX ENCLS
  Linear address in INVVPID descriptor.
- Cases LAM doesn't apply to (no change needed)
  Operand of INVLPG
  Linear address in INVPCID descriptor

Co-developed-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c     | 23 ++++++++++++++++++-----
 arch/x86/kvm/kvm_emulate.h |  2 ++
 arch/x86/kvm/vmx/nested.c  |  4 ++++
 arch/x86/kvm/vmx/sgx.c     |  1 +
 arch/x86/kvm/x86.c         | 10 ++++++++++
 5 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a20bec931764..b7df465eccf2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -688,7 +688,8 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 				       struct segmented_address addr,
 				       unsigned *max_size, unsigned size,
 				       bool write, bool fetch,
-				       enum x86emul_mode mode, ulong *linear)
+				       enum x86emul_mode mode, ulong *linear,
+				       u64 untag_flags)
 {
 	struct desc_struct desc;
 	bool usable;
@@ -701,6 +702,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	*max_size = 0;
 	switch (mode) {
 	case X86EMUL_MODE_PROT64:
+		la = ctxt->ops->untag_addr(ctxt, la, untag_flags);
 		*linear = la;
 		va_bits = ctxt_virt_addr_bits(ctxt);
 		if (!__is_canonical_address(la, va_bits))
@@ -758,7 +760,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 {
 	unsigned max_size;
 	return __linearize(ctxt, addr, &max_size, size, write, false,
-			   ctxt->mode, linear);
+			   ctxt->mode, linear, 0);
 }
 
 static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
@@ -771,7 +773,12 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
-	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode, &linear);
+	/*
+	 * LAM does not apply to addresses used for instruction fetches
+	 * or to those that specify the targets of jump and call instructions
+	 */
+	rc = __linearize(ctxt, addr, &max_size, 1, false, true, ctxt->mode,
+	                 &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->_eip = addr.ea;
 	return rc;
@@ -906,9 +913,12 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	 * __linearize is called with size 0 so that it does not do any
 	 * boundary check itself.  Instead, we use max_size to check
 	 * against op_size.
+	 *
+	 * LAM does not apply to addresses used for instruction fetches
+	 * or to those that specify the targets of jump and call instructions
 	 */
 	rc = __linearize(ctxt, addr, &max_size, 0, false, true, ctxt->mode,
-			 &linear);
+			 &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
 
@@ -3433,8 +3443,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	ulong linear;
+	unsigned max_size;
 
-	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
+	/* skip untag for invlpg since LAM is not applied to invlpg */
+	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1, false, false,
+			 ctxt->mode, &linear, KVM_X86_UNTAG_ADDR_SKIP_LAM);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->ops->invlpg(ctxt, linear);
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index ab65f3a47dfd..8d9f782adccb 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -225,6 +225,8 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+
+	u64 (*untag_addr)(struct x86_emulate_ctxt *ctxt, u64 addr, u64 flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d35bda9610e2..48cca88bfd37 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4970,6 +4970,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		else
 			*ret = off;
 
+		*ret = vmx_untag_addr(vcpu, *ret, 0);
 		/* Long mode: #GP(0)/#SS(0) if the memory address is in a
 		 * non-canonical form. This is the only check on the memory
 		 * destination for long mode!
@@ -5787,6 +5788,9 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
+		/* invvpid is not valid in compatibility mode */
+		if (is_long_mode(vcpu))
+			operand.gla = vmx_untag_addr(vcpu, operand.gla, 0);
 		if (!operand.vpid ||
 		    is_noncanonical_address(operand.gla, vcpu))
 			return nested_vmx_fail(vcpu,
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 0574030b071f..527f1a902c65 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -37,6 +37,7 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 	if (!IS_ALIGNED(*gva, alignment)) {
 		fault = true;
 	} else if (likely(is_64_bit_mode(vcpu))) {
+		*gva = vmx_untag_addr(vcpu, *gva, 0);
 		fault = is_noncanonical_address(*gva, vcpu);
 	} else {
 		*gva &= 0xffffffff;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aca255e69d0d..18ad38649714 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8218,6 +8218,11 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static u64 emulator_untag_addr(struct x86_emulate_ctxt *ctxt, u64 addr, u64 flags)
+{
+	return static_call(kvm_x86_untag_addr)(emul_to_vcpu(ctxt), addr, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8263,6 +8268,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.untag_addr          = emulator_untag_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
@@ -13260,6 +13266,10 @@ int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva)
 
 	switch (type) {
 	case INVPCID_TYPE_INDIV_ADDR:
+		/*
+		 * LAM doesn't apply to the linear address in the descriptor,
+		 * still need to be canonical
+		 */
 		if ((!pcid_enabled && (operand.pcid != 0)) ||
 		    is_noncanonical_address(operand.gla, vcpu)) {
 			kvm_inject_gp(vcpu, 0);
-- 
2.25.1

