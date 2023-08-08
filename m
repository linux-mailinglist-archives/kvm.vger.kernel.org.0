Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF42774B54
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbjHHUpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbjHHUoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08121F1DA3
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 09:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9859624BF
        for <kvm@vger.kernel.org>; Tue,  8 Aug 2023 11:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307C6C433C7;
        Tue,  8 Aug 2023 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691495297;
        bh=P5QdydtrQ8ywkerynyO9hTpNrICi0GcHa42zU2NtgRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+m24eBnftW/N0vSctu431SM8OyWQ4t8tn751eoP5gLu4IKO/QiJ58/BUXDJStMx5
         jRaQM/ZpbYrn/MD5i6HjSYG2cSlCxKLoSCUYj2pWj+SGuXq+tN2ozu0UOh53oxE6FR
         /4lILddIWgKL63lDC94Bjhiz8U+CqcBr1Mk9ZQXcZHfHVzVYCxj/3PJ/Fj2PSMUUH5
         QnQD4p6jupcYckfirayopRgIW+OgEbgDJhp3lnWK8qBTFYrnUAsLKWcHnBO+rZivL8
         6Zzf+xy2rYo1+LW/keDqWBRjSRHpOb5uC0qReCWpOutHNH5TrJ30Sx6SqOzo1cLywL
         yNURUbzUWUc6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qTLBH-0037Ph-Co;
        Tue, 08 Aug 2023 12:47:19 +0100
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
Subject: [PATCH v3 14/27] KVM: arm64: nv: Add trap forwarding infrastructure
Date:   Tue,  8 Aug 2023 12:46:58 +0100
Message-Id: <20230808114711.2013842-15-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808114711.2013842-1-maz@kernel.org>
References: <20230808114711.2013842-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
 arch/arm64/kvm/emulate-nested.c     | 262 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |   6 +
 arch/arm64/kvm/trace_arm.h          |  26 +++
 5 files changed, 297 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 721680da1011..cb1c5c54cedd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -988,6 +988,7 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu);
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
 int __init kvm_sys_reg_table_init(void);
+int __init populate_nv_trap_config(void);
 
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
index b96662029fb1..1b1148770d45 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -14,6 +14,268 @@
 
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
+enum trap_group {
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
+
+	/* Must be last */
+	__NR_TRAP_GROUP_IDS__
+};
+
+static const struct trap_bits coarse_trap_bits[] = {
+};
+
+#define MCB(id, ...)					\
+	[id - __MULTIPLE_CONTROL_BITS__]	=	\
+		(const enum trap_group []){		\
+			__VA_ARGS__, __RESERVED__	\
+		}
+
+static const enum trap_group *coarse_control_combo[] = {
+};
+
+typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
+
+#define CCC(id, fn)				\
+	[id - __COMPLEX_CONDITIONS__] = fn
+
+static const complex_condition_check ccc[] = {
+};
+
+/*
+ * Bit assignment for the trap controls. We use a 64bit word with the
+ * following layout for each trapped sysreg:
+ *
+ * [9:0]	enum trap_group (10 bits)
+ * [13:10]	enum fgt_group_id (4 bits)
+ * [19:14]	bit number in the FGT register (6 bits)
+ * [20]		trap polarity (1 bit)
+ * [62:21]	Unused (42 bits)
+ * [63]		RES0 - Must be zero, as lost on insertion in the xarray
+ */
+#define TC_CGT_BITS	10
+#define TC_FGT_BITS	4
+
+union trap_config {
+	u64	val;
+	struct {
+		unsigned long	cgt:TC_CGT_BITS; /* Coarse trap id */
+		unsigned long	fgt:TC_FGT_BITS; /* Fing Grained Trap id */
+		unsigned long	bit:6;		 /* Bit number */
+		unsigned long	pol:1;		 /* Polarity */
+		unsigned long	unk:42;		 /* Unknown */
+		unsigned long	mbz:1;		 /* Must Be Zero */
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
+static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
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
+int __init populate_nv_trap_config(void)
+{
+	int ret = 0;
+
+	BUILD_BUG_ON(sizeof(union trap_config) != sizeof(void *));
+	BUILD_BUG_ON(__NR_TRAP_GROUP_IDS__ > BIT(TC_CGT_BITS));
+
+	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
+		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
+		void *prev;
+
+		prev = xa_store_range(&sr_forward_xa, cgt->encoding, cgt->end,
+				      xa_mk_value(cgt->tc.val), GFP_KERNEL);
+
+		if (prev) {
+			kvm_err("Duplicate CGT for (%d, %d, %d, %d, %d)\n",
+				sys_reg_Op0(cgt->encoding),
+				sys_reg_Op1(cgt->encoding),
+				sys_reg_CRn(cgt->encoding),
+				sys_reg_CRm(cgt->encoding),
+				sys_reg_Op2(cgt->encoding));
+			ret = -EINVAL;
+		}
+	}
+
+	kvm_info("nv: %ld coarse grained trap handlers\n",
+		 ARRAY_SIZE(encoding_to_cgt));
+
+	for (int id = __MULTIPLE_CONTROL_BITS__;
+	     id < (__COMPLEX_CONDITIONS__ - 1);
+	     id++) {
+		const enum trap_group *cgids;
+
+		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
+
+		for (int i = 0; cgids[i] != __RESERVED__; i++) {
+			if (cgids[i] >= __MULTIPLE_CONTROL_BITS__) {
+				kvm_err("Recursive MCB %d/%d\n", id, cgids[i]);
+				ret = -EINVAL;
+			}
+		}
+	}
+
+	if (ret)
+		xa_destroy(&sr_forward_xa);
+
+	return ret;
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
+static enum trap_behaviour __do_compute_trap_behaviour(struct kvm_vcpu *vcpu,
+						       const enum trap_group id,
+						       enum trap_behaviour b)
+{
+	switch (id) {
+		const enum trap_group *cgids;
+
+	case __RESERVED__ ... __MULTIPLE_CONTROL_BITS__ - 1:
+		if (likely(id != __RESERVED__))
+			b |= get_behaviour(vcpu, &coarse_trap_bits[id]);
+		break;
+	case __MULTIPLE_CONTROL_BITS__ ... __COMPLEX_CONDITIONS__ - 1:
+		/* Yes, this is recursive. Don't do anything stupid. */
+		cgids = coarse_control_combo[id - __MULTIPLE_CONTROL_BITS__];
+		for (int i = 0; cgids[i] != __RESERVED__; i++)
+			b |= __do_compute_trap_behaviour(vcpu, cgids[i], b);
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
+static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
+						  const union trap_config tc)
+{
+	enum trap_behaviour b = BEHAVE_HANDLE_LOCALLY;
+
+	return __do_compute_trap_behaviour(vcpu, tc.cgt, b);
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
+	/*
+	 * A value of 0 for the whole entry means that we know nothing
+	 * for this sysreg, and that it cannot be forwareded. In this
+	 * situation, let's cut it short.
+	 *
+	 * Note that ultimately, we could also make use of the xarray
+	 * to store the index of the sysreg in the local descriptor
+	 * array, avoiding another search... Hint, hint...
+	 */
+	if (!tc.val)
+		return false;
+
+	b = compute_trap_behaviour(vcpu, tc);
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
index f5baaa508926..dfd72b3a625f 100644
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
index 6ce5c025218d..8ad53104934d 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -364,6 +364,32 @@ TRACE_EVENT(kvm_inject_nested_exception,
 		  __entry->hcr_el2)
 );
 
+TRACE_EVENT(kvm_forward_sysreg_trap,
+	    TP_PROTO(struct kvm_vcpu *vcpu, u32 sysreg, bool is_read),
+	    TP_ARGS(vcpu, sysreg, is_read),
+
+	    TP_STRUCT__entry(
+		__field(u64,	pc)
+		__field(u32,	sysreg)
+		__field(bool,	is_read)
+	    ),
+
+	    TP_fast_assign(
+		__entry->pc = *vcpu_pc(vcpu);
+		__entry->sysreg = sysreg;
+		__entry->is_read = is_read;
+	    ),
+
+	    TP_printk("%llx %c (%d,%d,%d,%d,%d)",
+		      __entry->pc,
+		      __entry->is_read ? 'R' : 'W',
+		      sys_reg_Op0(__entry->sysreg),
+		      sys_reg_Op1(__entry->sysreg),
+		      sys_reg_CRn(__entry->sysreg),
+		      sys_reg_CRm(__entry->sysreg),
+		      sys_reg_Op2(__entry->sysreg))
+);
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.34.1

