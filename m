Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19402750C2C
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbjGLPRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbjGLPRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598821727
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B30061834
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 15:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB0EC433C8;
        Wed, 12 Jul 2023 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689175022;
        bh=l5Sx8dUxSzv+iOJBkB0NoAOXwahjxTk26BakAr+Svzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwQAbeijS6LK/TIC7LQIGJvjJ2uVnStxYCbelUKIiOPWSWimBwD09AnmK49aXj3Cn
         6SyuUDbskKKFKYoHNd2kw/xdifxCAza+iMFlKcNJ4+rE1itetKYhnf0Uu1xR4V0Ktt
         TjjcW3BbFwozniWGNaq+LQuG4cRQ6YH9ifJTHz6TY3u4dy1x5jATvSJT42mtpkRS+l
         Tjr5+pmC1hAP1aPhcOX6Sa3dXtQbcfQWmErCq08xqTlwpivMfNw5HrHkYvcDlcbFb0
         uQr6YE8qSQrUaJHG4Ugmrdp/wR8N8dY3srs7n93I1xddcKR3kg231WuA9wo3rWVo8f
         j0tXYXHb9QE6Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIp-00CUNF-NK;
        Wed, 12 Jul 2023 15:58:51 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 15/27] KVM: arm64: nv: Add trap forwarding infrastructure
Date:   Wed, 12 Jul 2023 15:57:58 +0100
Message-Id: <20230712145810.3864793-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
References: <20230712145810.3864793-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
and checked each time we trap a system register while running
a L2 guest.

Add the basic infrastructure for now, while additional patches will
implement configuration registers.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h   |   1 +
 arch/arm64/include/asm/kvm_nested.h |   2 +
 arch/arm64/kvm/emulate-nested.c     | 210 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |   6 +
 arch/arm64/kvm/trace_arm.h          |  19 +++
 5 files changed, 238 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1200f29282ba..e498cca78a8d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -986,6 +986,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
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
index b96662029fb1..5bab2e85d70c 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -14,6 +14,216 @@
 
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
+/*
+ * Bit assignment for the trap controls. We use a 64bit word with the
+ * following layout for each trapped sysreg:
+ *
+ * [9:0]	enum coarse_grain_trap_id (10 bits)
+ * [13:10]	enum fgt_group_id (4 bits)
+ * [19:14]	bit number in the FGT register (6 bits)
+ * [20]		trap polarity (1 bit)
+ * [62:21]	Unused (42 bits)
+ * [63]		RES0 - Must be zero, as lost on insertion in the xarray
+ */
+union trap_config {
+	u64	val;
+	struct {
+		unsigned long	cgt:10;	/* Coarse trap id */
+		unsigned long 	fgt:4;	/* Fing Grained Trap id */
+		unsigned long	bit:6;	/* Bit number */
+		unsigned long	pol:1;	/* Polarity */
+		unsigned long	unk:42;	/* Unknown */
+		unsigned long	mbz:1;	/* Must Be Zero */
+	};
+};
+
+struct encoding_to_trap_config {
+	const u32			encoding;
+	const u32			end;
+	const union trap_config		tc;
+};
+
+#define SR_RANGE_TRAP(sr_start, sr_end, trap_id)			\
+	{								\
+		.encoding	= sr_start,				\
+		.end		= sr_end,				\
+		.tc		= {					\
+			.cgt		= trap_id,			\
+		},							\
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
+static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
+};
+
+static DEFINE_XARRAY(sr_forward_xa);
+
+static union trap_config get_trap_config(u32 sysreg)
+{
+	return (union trap_config) {
+		.val = xa_to_value(xa_load(&sr_forward_xa, sysreg)),
+	};
+}
+
+void __init populate_nv_trap_config(void)
+{
+	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
+		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
+		void *prev;
+
+		prev = xa_store_range(&sr_forward_xa, cgt->encoding, cgt->end,
+				      xa_mk_value(cgt->tc.val), GFP_KERNEL);
+		WARN_ON(prev);
+	}
+
+	kvm_info("nv: %ld coarse grained trap handlers\n",
+		 ARRAY_SIZE(encoding_to_cgt));
+
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
+static enum trap_behaviour compute_behaviour(struct kvm_vcpu *vcpu,
+					     const union trap_config tc)
+{
+	enum trap_behaviour b = BEHAVE_HANDLE_LOCALLY;
+
+	return __do_compute_behaviour(vcpu, tc.cgt, b);
+}
+
+bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
+{
+	union trap_config tc;
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
+	tc = get_trap_config(sysreg);
+
+	b = compute_behaviour(vcpu, tc);
+
+	if (((b & BEHAVE_FORWARD_READ) && is_read) ||
+	    ((b & BEHAVE_FORWARD_WRITE) && !is_read))
+		goto inject;
+
+	return false;
+
+inject:
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
index f88cd1390998..cc10ecaff98a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3177,6 +3177,9 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
+	if (__check_nv_sr_forward(vcpu))
+		return 1;
+
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
@@ -3594,5 +3597,8 @@ int __init kvm_sys_reg_table_init(void)
 	if (!first_idreg)
 		return -EINVAL;
 
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

