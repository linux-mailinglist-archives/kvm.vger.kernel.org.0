Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714D2757EDA
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbjGROAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjGROAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:00:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4C51BF1;
        Tue, 18 Jul 2023 07:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689688813; x=1721224813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=eJh02u55Iq9hH4SpIMmLkWcnyfdfBdoH4sJ4Pj2PV2M=;
  b=K/fKy8QarUoPbEpPYjNNkN494Fo4LzdB/wmzmh6KlmFkdYEpAU+zj6PB
   QU612QsDnTu+WTVZ02DvFgqBsjXFlK03O8ho8FN94sTvgI1VODAATSIm0
   iRzCh93utYVQbrjb2tsaUXgJm5R5jTeZconVQlBpmTz43L2isSpGLLM9B
   jFdj+zGJh5jBBRgEEKhXamvTsHHDf/qosSuMRRyonmFc0PztqzmSSvr4c
   Tglwrof6LdRB6oE1zmTjTZ6r9RdqOwasD9OULOe6I/j4DGgScn+KmqxRv
   z74v6MaHjLePmLQ38i7jHUPMeym9w17yzIuzeUFe3KmV6Nnl7gksZTpBf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="363676144"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="363676144"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10775"; a="1054291161"
X-IronPort-AV: E=Sophos;i="6.01,214,1684825200"; 
   d="scan'208";a="1054291161"
Received: from arthur-vostro-3668.sh.intel.com ([10.238.200.123])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2023 06:58:52 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v2 5/8] KVM: emulator: Add emulation of LASS violation checks on linear address
Date:   Tue, 18 Jul 2023 21:18:41 +0800
Message-Id: <20230718131844.5706-6-guang.zeng@intel.com>
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

When enabled Intel CPU feature Linear Address Space Separation (LASS),
KVM emulator will take LASS violation check on every access to guest
memory by a linear address.

We defined a new function prototype in kvm_x86_ops for emulator to
construct the interface to identify whether a LASS violation occurs.
It can have further practical implementation according to vendor
specific requirements.

Emulator will use the passed (address, size) pair and instruction
operation type (flags) to enforce LASS protection when KVM emulates
instruction fetch, data access including implicit data access to a
system data structure.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/emulate.c             | 11 +++++++++++
 arch/x86/kvm/kvm_emulate.h         |  2 ++
 arch/x86/kvm/x86.c                 | 10 ++++++++++
 5 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..a301f0a46381 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
-KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
+KVM_X86_OP_OPTIONAL_RET0(is_lass_violation)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..791f0dd48cd9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1731,6 +1731,9 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	bool (*is_lass_violation)(struct kvm_vcpu *vcpu, unsigned long addr,
+				  unsigned int size, unsigned int flags);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 9b4b3ce6d52a..2289a4ad21be 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -742,6 +742,10 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 		}
 		break;
 	}
+
+	if (ctxt->ops->is_lass_violation(ctxt, *linear, size, flags))
+		goto bad;
+
 	if (la & (insn_alignment(ctxt, size) - 1))
 		return emulate_gp(ctxt, 0);
 	return X86EMUL_CONTINUE;
@@ -848,6 +852,9 @@ static inline int jmp_rel(struct x86_emulate_ctxt *ctxt, int rel)
 static int linear_read_system(struct x86_emulate_ctxt *ctxt, ulong linear,
 			      void *data, unsigned size)
 {
+	if (ctxt->ops->is_lass_violation(ctxt, linear, size, X86EMUL_F_IMPLICIT))
+		return emulate_gp(ctxt, 0);
+
 	return ctxt->ops->read_std(ctxt, linear, data, size, &ctxt->exception, true);
 }
 
@@ -855,6 +862,10 @@ static int linear_write_system(struct x86_emulate_ctxt *ctxt,
 			       ulong linear, void *data,
 			       unsigned int size)
 {
+	if (ctxt->ops->is_lass_violation(ctxt, linear, size,
+					 X86EMUL_F_IMPLICIT | X86EMUL_F_FETCH))
+		return emulate_gp(ctxt, 0);
+
 	return ctxt->ops->write_std(ctxt, linear, data, size, &ctxt->exception, true);
 }
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index c944055091e1..6f0996d0da56 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -232,6 +232,8 @@ struct x86_emulate_ops {
 	int (*leave_smm)(struct x86_emulate_ctxt *ctxt);
 	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
 	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
+	bool (*is_lass_violation)(struct x86_emulate_ctxt *ctxt, unsigned long addr,
+				  unsigned int size, unsigned int flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04b57a336b34..6448ff706539 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8287,6 +8287,15 @@ static void emulator_vm_bugged(struct x86_emulate_ctxt *ctxt)
 		kvm_vm_bugged(kvm);
 }
 
+static bool emulator_is_lass_violation(struct x86_emulate_ctxt *ctxt,
+				       unsigned long addr,
+				       unsigned int size,
+				       unsigned int flags)
+{
+	return static_call(kvm_x86_is_lass_violation)(emul_to_vcpu(ctxt),
+						      addr, size, flags);
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8332,6 +8341,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.leave_smm           = emulator_leave_smm,
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
+	.is_lass_violation   = emulator_is_lass_violation,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.27.0

