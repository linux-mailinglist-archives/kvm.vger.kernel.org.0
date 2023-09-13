Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F4079ED72
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjIMPlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 11:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjIMPkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 11:40:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174961BE6;
        Wed, 13 Sep 2023 08:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694619621; x=1726155621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tm5lF+aKFhqM/DPUGls85DQCL8Atbn1iSe94eDkvCXk=;
  b=EIJkn7tYroxUMtLuiTjNtygYk3rzTtUsKKVxczlz/2thaFDfdS4zU29R
   nVM/oLVESINrwNki3OiJ/Nz02DhrNBuK+P+RQQ/ITSN137kEbOyJtdANb
   kuK5IgmYcgO1+43ZFiC+PyNzVVyt4RoFFoH4irR6rzLBl5ZpfjH9H7Ncq
   QOCZan5USTppJDtZrnGBB7WZHh4NUVxq7LYnReZfEA+UM+Sd+WaQUFLi7
   sPt81awbYeUgLlXan5awUuXkE73WKgRLlGkbml7+BhazKoYqfKJ1nHDlQ
   U21hUTJyVlto+CZPmCx7AKJaA5IsN4uYKG91CRPcZpO8IZmJ8qPNTU+IS
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="376030297"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="376030297"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="867852264"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="867852264"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO binbinwu-mobl.sh.intel.com) ([10.93.2.44])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 08:40:17 -0700
From:   Binbin Wu <binbin.wu@linux.intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        kai.huang@intel.com, David.Laight@ACULAB.COM,
        robert.hu@linux.intel.com, guang.zeng@intel.com,
        binbin.wu@linux.intel.com
Subject: [PATCH v11 14/16] KVM: emulator: Add emulation of LASS violation checks on linear address
Date:   Wed, 13 Sep 2023 20:42:25 +0800
Message-Id: <20230913124227.12574-15-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913124227.12574-1-binbin.wu@linux.intel.com>
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zeng Guang <guang.zeng@intel.com>

When Intel Linear Address Space Separation (LASS) is enabled, the
processor applies a LASS violation check to every access to a linear
address. To align with hardware behavior, KVM needs to perform the
same check in instruction emulation.

Define a new function in x86_emulator_ops to perform the LASS violation
check in KVM emulator. The function accepts an address and a size, which
delimit the memory access, and a flag, which provides extra information
about the access that is necessary for LASS violation checks, e.g., whether
the access is an instruction fetch or implicit access.

emulator_is_lass_violation() is just a placeholder. it will be wired up
to VMX/SVM implementation by a later patch.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Tested-by: Xuelian Guo <xuelian.guo@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  3 ++-
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/emulate.c             | 11 +++++++++++
 arch/x86/kvm/kvm_emulate.h         |  3 +++
 arch/x86/kvm/x86.c                 | 10 ++++++++++
 5 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 179931b73876..fc9945e80177 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -133,8 +133,9 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
-KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
 KVM_X86_OP(get_untagged_addr)
+KVM_X86_OP_OPTIONAL_RET0(is_lass_violation)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d4e3657b840a..3e73fc45c8e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1754,6 +1754,9 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+
+	bool (*is_lass_violation)(struct kvm_vcpu *vcpu, unsigned long addr,
+				  unsigned int size, unsigned int flags);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7af58b8d57ac..cbd08daeae9e 100644
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
+					 X86EMUL_F_IMPLICIT | X86EMUL_F_WRITE))
+		return emulate_gp(ctxt, 0);
+
 	return ctxt->ops->write_std(ctxt, linear, data, size, &ctxt->exception, true);
 }
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 26f402616604..a76baa51fa16 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -234,6 +234,9 @@ struct x86_emulate_ops {
 
 	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
 				   unsigned int flags);
+
+	bool (*is_lass_violation)(struct x86_emulate_ctxt *ctxt, unsigned long addr,
+				  unsigned int size, unsigned int flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c2cdfcae79d..58d7a9241630 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8317,6 +8317,15 @@ static gva_t emulator_get_untagged_addr(struct x86_emulate_ctxt *ctxt,
 	return static_call(kvm_x86_get_untagged_addr)(emul_to_vcpu(ctxt), addr, flags);
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
@@ -8362,6 +8371,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 	.get_untagged_addr   = emulator_get_untagged_addr,
+	.is_lass_violation   = emulator_is_lass_violation,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
-- 
2.25.1

