Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBD871A20C
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbjFAPFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 11:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbjFAPFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 11:05:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EF51B4;
        Thu,  1 Jun 2023 08:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685631852; x=1717167852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nkbSB1DqlVzA+xpxNo2W+YNwCLxOpYOI0OFu6SLFydQ=;
  b=b0ZuWlF8w5KCkq7mD60MOe+E9CdBnbTyPFqr+o6itALECBhv89e/iMKU
   NDUnk4BXLYmGK6g4O4w0A5l4RkJdpo1uQtSx5kHQV9dR/QAs8k1ZfOOYI
   +dGrfAHejz8Tq8gcniuONm25Qy69qGfuqOByOXayr9TC1sgm4n4jYIhUp
   9/Jl6hwbXXiNuxeLZWlU8RAS2v5+M9ipoWZOIXvU/posPpbqDQhEH2ryS
   Oc93onZ5T917N13QXu8STUu8XLyMlP5Gt511ymUhVCeINkq8v8W+5uyth
   2xhSqz4OaQAZIFEVCQiErnk32tKqALZgOsf1PYGaSxTP4cwg1/shMkTQD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="383853468"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="383853468"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="657828251"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="657828251"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 08:02:51 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v1 5/6] KVM: x86: LASS protection on KVM emulation
Date:   Thu,  1 Jun 2023 22:23:08 +0800
Message-Id: <20230601142309.6307-6-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230601142309.6307-1-guang.zeng@intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do LASS violation check for instructions emulated by KVM. Note that for
instructions executed in the guest directly, hardware will perform the
check.

Not all instruction emulation leads to accesses to guest linear addresses
because 1) some instructions like CPUID, RDMSR, don't take memory as
operands 2) instruction fetch in most cases is already done inside the
guest.

Four cases in which KVM uses a linear address to access guest memory:
- KVM emulates instruction fetches or data accesses
- KVM emulates implicit data access to a system data structure
- VMX instruction emulation
- SGX ENCLS instruction emulation

LASS violation check applies to these linear addresses so as to enforce
mode-based protections as hardware behaves.

As exceptions, the target memory address of emulation of invlpg, branch
and call instructions doesn't require LASS violation check.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/kvm/emulate.c    | 30 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/sgx.c    |  4 ++++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9508836e8a35..ed5191fa2079 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -698,6 +698,7 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 	u8  va_bits;
 	bool fetch = !!(flags & X86EMUL_F_FETCH);
 	bool write = !!(flags & X86EMUL_F_WRITE);
+	u64 access = fetch ? PFERR_FETCH_MASK : 0;
 
 	la = seg_base(ctxt, addr.seg) + addr.ea;
 	*max_size = 0;
@@ -743,6 +744,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 		}
 		break;
 	}
+
+	if (ctxt->ops->check_lass(ctxt, access, *linear, flags))
+		goto bad;
+
 	if (la & (insn_alignment(ctxt, size) - 1))
 		return emulate_gp(ctxt, 0);
 	return X86EMUL_CONTINUE;
@@ -774,7 +779,11 @@ static inline int assign_eip(struct x86_emulate_ctxt *ctxt, ulong dst)
 	unsigned max_size;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = dst };
-	u32 flags = X86EMUL_F_FETCH;
+	/*
+	 * LASS doesn't apply to addresses that specify the targets of jump and
+	 * call instructions.
+	 */
+	u32 flags = X86EMUL_F_FETCH | X86EMUL_F_SKIPLASS;
 
 	if (ctxt->op_bytes != sizeof(unsigned long))
 		addr.ea = dst & ((1UL << (ctxt->op_bytes << 3)) - 1);
@@ -853,6 +862,13 @@ static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
 static int linear_read_system(struct x86_emulate_ctxt *ctxt, ulong linear,
 			      void *data, unsigned size)
 {
+	if (ctxt->ops->check_lass(ctxt, PFERR_IMPLICIT_ACCESS, linear, 0)) {
+		ctxt->exception.vector = GP_VECTOR;
+		ctxt->exception.error_code = 0;
+		ctxt->exception.error_code_valid = true;
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+
 	return ctxt->ops->read_std(ctxt, linear, data, size, &ctxt->exception, true);
 }
 
@@ -860,6 +876,13 @@ static int linear_write_system(struct x86_emulate_ctxt *ctxt,
 			       ulong linear, void *data,
 			       unsigned int size)
 {
+	if (ctxt->ops->check_lass(ctxt, PFERR_IMPLICIT_ACCESS, linear, 0)) {
+		ctxt->exception.vector = GP_VECTOR;
+		ctxt->exception.error_code = 0;
+		ctxt->exception.error_code_valid = true;
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+
 	return ctxt->ops->write_std(ctxt, linear, data, size, &ctxt->exception, true);
 }
 
@@ -3448,8 +3471,11 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 {
 	int rc;
 	ulong linear;
+	unsigned max_size;
 
-	rc = linearize(ctxt, ctxt->src.addr.mem, 1, false, &linear);
+	/* LASS doesn't apply to the memory address for invlpg */
+	rc = __linearize(ctxt, ctxt->src.addr.mem, &max_size, 1,
+			 X86EMUL_F_SKIPLASS, ctxt->mode, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		ctxt->ops->invlpg(ctxt, linear);
 	/* Disable writeback. */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e35cf0bd0df9..bb1c3fa13c13 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4986,6 +4986,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 * destination for long mode!
 		 */
 		exn = is_noncanonical_address(*ret, vcpu);
+
+		if (!exn)
+			exn = vmx_check_lass(vcpu, 0, *ret, 0);
 	} else {
 		/*
 		 * When not in long mode, the virtual/linear address is
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 2261b684a7d4..3825275827eb 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -46,6 +46,10 @@ static int sgx_get_encls_gva(struct kvm_vcpu *vcpu, unsigned long offset,
 			((s.base != 0 || s.limit != 0xffffffff) &&
 			(((u64)*gva + size - 1) > s.limit + 1));
 	}
+
+	if (!fault && is_long_mode(vcpu))
+		fault = vmx_check_lass(vcpu, 0, *gva, 0);
+
 	if (fault)
 		kvm_inject_gp(vcpu, 0);
 	return fault ? -EINVAL : 0;
-- 
2.27.0

