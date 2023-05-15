Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754277038AF
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbjEOReI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244275AbjEORds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B331491D
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D623562D56
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8839AC433D2;
        Mon, 15 May 2023 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684171887;
        bh=QgkkzL7UoeUjp0ClcPU82j2iDGtiQBtIU1l3pnC+VR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEHIU12scjEZVoUbCMETsqMIwg9MULK3NIAQMlfpNNLGdmdH4b/Y6h2I5qGBrvoMF
         VH77Byr0ot4xpvchheIF99/H5P0EMUscLoBy2WR1bsF6IwP2EtLdKWyOM6/CfSlzb/
         HccZEvo9sHE5vg0TabQk+WwDa4RIfdt6kCW57mH8Bs16HUmWrBpD0eyAvV3n2wLEOr
         MN6sEPS0kaXI8J8kDgFIJSoIuE6DllYlvapTcybrmoxwZm78Y/7DyOO3UC/2QYhclM
         Gs4F/6InTdXbQyTu1WV0p/Rbe2UKIzYwSDYzSWAiGtl8nHhK9fHerXPQMO4d8b56it
         teF2Jfr7hTl5g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2f-00FJAF-Kz;
        Mon, 15 May 2023 18:31:25 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v10 09/59] KVM: arm64: nv: Add trap forwarding infrastructure
Date:   Mon, 15 May 2023 18:30:13 +0100
Message-Id: <20230515173103.1017669-10-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A significant part of what a NV hypervisor needs to do is to decide
whether a trap from a L2+ guest has to be forwarded to a L1 guest
or handled locally. This is done by checking for the trap bits that
the guest hypervisor has set and acting accordingly, as described by
the architecture.

A previous approach was to sprinkle a bunch of checks in all the
system register accessors, but this is pretty error prone and doesn't
help getting an overview of what is happening.

Instead, implement a set of global tables that describe a trap bit,
combinations of trap bits, behaviours on trap, and what bits must
be evaluated on a system register trap.

Although this is painful to describe, this allows to specify each
and every control bit in a static manner. To make it efficient,
the table is inserted in an xarray that is global to the system,
and checked each time we trap a system register.

Add the basic infrastructure for now, while additional patches will
implement configuration registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |   1 +
 arch/arm64/include/asm/kvm_nested.h |   2 +
 arch/arm64/kvm/emulate-nested.c     | 175 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |   6 +
 arch/arm64/kvm/trace_arm.h          |  19 +++
 5 files changed, 203 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f2e3b5889f8b..65810618cb42 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -960,6 +960,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
 int __init kvm_sys_reg_table_init(void);
+void __init populate_nv_trap_config(void);
 
 bool lock_all_vcpus(struct kvm *kvm);
 void unlock_all_vcpus(struct kvm *kvm);
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 8fb67f032fd1..fa23cc9c2adc 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -11,6 +11,8 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
+
 struct sys_reg_params;
 struct sys_reg_desc;
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index b96662029fb1..a923f7f47add 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -14,6 +14,181 @@
 
 #include "trace.h"
 
+enum trap_behaviour {
+	BEHAVE_HANDLE_LOCALLY	= 0,
+	BEHAVE_FORWARD_READ	= BIT(0),
+	BEHAVE_FORWARD_WRITE	= BIT(1),
+	BEHAVE_FORWARD_ANY	= BEHAVE_FORWARD_READ | BEHAVE_FORWARD_WRITE,
+};
+
+struct trap_bits {
+	const enum vcpu_sysreg		index;
+	const enum trap_behaviour	behaviour;
+	const u64			value;
+	const u64			mask;
+};
+
+enum coarse_grain_trap_id {
+	/* Indicates no coarse trap control */
+	__RESERVED__,
+
+	/*
+	 * The first batch of IDs denote coarse trapping that are used
+	 * on their own instead of being part of a combination of
+	 * trap controls.
+	 */
+
+	/*
+	 * Anything after this point is a combination of trap controls,
+	 * which all must be evaluated to decide what to do.
+	 */
+	__MULTIPLE_CONTROL_BITS__,
+
+	/*
+	 * Anything after this point requires a callback evaluating a
+	 * complex trap condition. Hopefully we'll never need this...
+	 */
+	__COMPLEX_CONDITIONS__,
+};
+
+static const struct trap_bits coarse_trap_bits[] = {
+};
+
+#define MCB(id, ...)					\
+	[id - __MULTIPLE_CONTROL_BITS__]	=	\
+		(const enum coarse_grain_trap_id []){	\
+			__VA_ARGS__ , __RESERVED__	\
+		}
+
+static const enum coarse_grain_trap_id *coarse_control_combo[] = {
+};
+
+typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
+
+#define CCC(id, fn)	[id - __COMPLEX_CONDITIONS__] = fn
+
+static const complex_condition_check ccc[] = {
+};
+
+struct encoding_to_trap_configs {
+	const u32			encoding;
+	const u32			end;
+	const enum coarse_grain_trap_id	id;
+};
+
+#define SR_RANGE_TRAP(sr_start, sr_end, trap_id)			\
+	{								\
+		.encoding	= sr_start,				\
+		.end		= sr_end,				\
+		.id		= trap_id,				\
+	}
+
+#define SR_TRAP(sr, trap_id)		SR_RANGE_TRAP(sr, sr, trap_id)
+
+/*
+ * Map encoding to trap bits for exception reported with EC=0x18.
+ * These must only be evaluated when running a nested hypervisor, but
+ * that the current context is not a hypervisor context. When the
+ * trapped access matches one of the trap controls, the exception is
+ * re-injected in the nested hypervisor.
+ */
+static const struct encoding_to_trap_configs encoding_to_traps[] __initdata = {
+};
+
+static DEFINE_XARRAY(sr_forward_xa);
+
+void __init populate_nv_trap_config(void)
+{
+	for (int i = 0; i < ARRAY_SIZE(encoding_to_traps); i++) {
+		const struct encoding_to_trap_configs *ett = &encoding_to_traps[i];
+		void *prev;
+
+		prev = xa_store_range(&sr_forward_xa, ett->encoding, ett->end,
+				      xa_mk_value(ett->id), GFP_KERNEL);
+		WARN_ON(prev);
+	}
+
+	kvm_info("nv: %ld trap handlers\n", ARRAY_SIZE(encoding_to_traps));
+}
+
+static const enum coarse_grain_trap_id get_trap_config(u32 sysreg)
+{
+	return xa_to_value(xa_load(&sr_forward_xa, sysreg));
+}
+
+static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
+					 const struct trap_bits *tb)
+{
+	enum trap_behaviour b = BEHAVE_HANDLE_LOCALLY;
+	u64 val;
+
+	val = __vcpu_sys_reg(vcpu, tb->index);
+	if ((val & tb->mask) == tb->value)
+		b |= tb->behaviour;
+
+	return b;
+}
+
+static enum trap_behaviour __do_compute_behaviour(struct kvm_vcpu *vcpu,
+						  const enum coarse_grain_trap_id id,
+						  enum trap_behaviour b)
+{
+	switch (id) {
+		const enum coarse_grain_trap_id *cgids;
+
+	case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
+		if (likely(id != __RESERVED__))
+			b |= get_behaviour(vcpu, &coarse_trap_bits[id]);
+		break;
+	case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
+		/* Yes, this is recursive. Don't do anything stupid. */
+		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
+		for (int i = 0; cgids[i] != __RESERVED__; i++)
+			b |= __do_compute_behaviour(vcpu, cgids[i], b);
+		break;
+	default:
+		if (ARRAY_SIZE(ccc))
+			b |= ccc[id -  __COMPLEX_CONDITIONS__](vcpu);
+		break;
+	}
+
+	return b;
+}
+
+static enum trap_behaviour compute_behaviour(struct kvm_vcpu *vcpu, u32 sysreg)
+{
+	const enum coarse_grain_trap_id id = get_trap_config(sysreg);
+	enum trap_behaviour b = BEHAVE_HANDLE_LOCALLY;
+
+	return __do_compute_behaviour(vcpu, id, b);
+}
+
+bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
+{
+	enum trap_behaviour b;
+	bool is_read;
+	u32 sysreg;
+	u64 esr;
+
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		return false;
+
+	esr = kvm_vcpu_get_esr(vcpu);
+	sysreg = esr_sys64_to_sysreg(esr);
+	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
+
+	b = compute_behaviour(vcpu, sysreg);
+
+	if (!((b & BEHAVE_FORWARD_READ) && is_read) &&
+	    !((b & BEHAVE_FORWARD_WRITE) && !is_read))
+		return false;
+
+	trace_kvm_forward_sysreg_trap(vcpu, sysreg, is_read);
+
+	kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+	return true;
+}
+
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 {
 	u64 mode = spsr & PSR_MODE_MASK;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 71b12094d613..77f8bc64148a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2955,6 +2955,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
+	if (__check_nv_sr_forward(vcpu))
+		return 1;
+
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
@@ -3363,5 +3366,8 @@ int __init kvm_sys_reg_table_init(void)
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
 		invariant_sys_regs[i].reset(NULL, &invariant_sys_regs[i]);
 
+	if (kvm_get_mode() == KVM_MODE_NV)
+		populate_nv_trap_config();
+		
 	return 0;
 }
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 6ce5c025218d..1f0f3f653606 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -364,6 +364,25 @@ TRACE_EVENT(kvm_inject_nested_exception,
 		  __entry->hcr_el2)
 );
 
+TRACE_EVENT(kvm_forward_sysreg_trap,
+	    TP_PROTO(struct kvm_vcpu *vcpu, u32 sysreg, bool is_read),
+	    TP_ARGS(vcpu, sysreg, is_read),
+
+	    TP_STRUCT__entry(
+		__field(struct kvm_vcpu *, vcpu)
+		__field(u32,		   sysreg)
+		__field(bool,		   is_read)
+	    ),
+
+	    TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->sysreg = sysreg;
+		__entry->is_read = is_read;
+	    ),
+
+	    TP_printk("%c %x", __entry->is_read ? 'R' : 'W', __entry->sysreg)
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.34.1

