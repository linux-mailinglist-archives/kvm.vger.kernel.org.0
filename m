Return-Path: <kvm+bounces-14437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68EE68A29B5
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:49:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA6D51F2249B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02ADC6995D;
	Fri, 12 Apr 2024 08:43:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F76626A0;
	Fri, 12 Apr 2024 08:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911415; cv=none; b=caI7HPionsHKiJDTX/ErFwfnT5OgD2/+TU6VVJqcxhLwfcrqq1Hc5u+8s6G+xchtHAlTQc8+762Ovmh4UAp5OEAsx3LTk9LM9tmfMOGDcGKKcJMPofvIcNfTN2XoQw7HqW8RGvyXkLunrzrQgFROC5T61FITRu6wVuF03FOgyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911415; c=relaxed/simple;
	bh=/FPLsr14dUXiSMYSlHJAx1yCnOXEoNBgI2/rNu/lGlw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ojLKAG78sE2DUecFac9vthd8Trbnhgc4h8Y5wFg8efYZR6aHdau1B5qr9+LxpDIgQmj+fg9LWemV+e3lmPpBp+RvvLbrWYyJg9rD1Si+tr7Yl+MxofiidwuUB+YOZOgMGOkTI4PH5zwE5mDSuAun5mW8uGCHBmQI6Om6P2kU20o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 781CC113E;
	Fri, 12 Apr 2024 01:44:01 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BE853F6C4;
	Fri, 12 Apr 2024 01:43:30 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 06/43] arm64: RME: Add wrappers for RMI calls
Date: Fri, 12 Apr 2024 09:42:32 +0100
Message-Id: <20240412084309.1733783-7-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The wrappers make the call sites easier to read and deal with the
boiler plate of handling the error codes from the RMM.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/rmi_cmds.h | 509 ++++++++++++++++++++++++++++++
 1 file changed, 509 insertions(+)
 create mode 100644 arch/arm64/include/asm/rmi_cmds.h

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
new file mode 100644
index 000000000000..c21414127e8e
--- /dev/null
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -0,0 +1,509 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __ASM_RMI_CMDS_H
+#define __ASM_RMI_CMDS_H
+
+#include <linux/arm-smccc.h>
+
+#include <asm/rmi_smc.h>
+
+struct rtt_entry {
+	unsigned long walk_level;
+	unsigned long desc;
+	int state;
+	int ripas;
+};
+
+/**
+ * rmi_data_create() - Create a Data Granule
+ * @rd: PA of the RD
+ * @data: PA of the target granule
+ * @ipa: IPA at which the granule will be mapped in the guest
+ * @src: PA of the source granule
+ * @flags: RMI_MEASURE_CONTENT if the contents should be measured
+ *
+ * Create a new Data Granule, copying contents from a Non-secure Granule.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_data_create(unsigned long rd, unsigned long data,
+				  unsigned long ipa, unsigned long src,
+				  unsigned long flags)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE, rd, data, ipa, src,
+			     flags, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_data_create_unknown() - Create a Data Granule with unknown contents
+ * @rd: PA of the RD
+ * @data: PA of the target granule
+ * @ipa: IPA at which the granule will be mapped in the guest
+ *
+ * Create a new Data Granule with unknown contents
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_data_create_unknown(unsigned long rd,
+					  unsigned long data,
+					  unsigned long ipa)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_DATA_CREATE_UNKNOWN, rd, data, ipa, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_data_destroy() - Destroy a Data Granule
+ * @rd: PA of the RD
+ * @ipa: IPA at which the granule is mapped in the guest
+ * @data_out: PA of the granule which was destroyed
+ * @top_out: Top IPA of non-live RTT entries
+ *
+ * Transitions the granule to DESTROYED state, the address cannot be used by
+ * the guest for the lifetime of the Realm.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_data_destroy(unsigned long rd, unsigned long ipa,
+				   unsigned long *data_out,
+				   unsigned long *top_out)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, ipa, &res);
+
+	*data_out = res.a1;
+	*top_out = res.a2;
+
+	return res.a0;
+}
+
+/**
+ * rmi_features() - Read feature register
+ * @index: Feature register index
+ * @out: Feature register value is written to this pointer
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_features(unsigned long index, unsigned long *out)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
+
+	*out = res.a1;
+	return res.a0;
+}
+
+/**
+ * rmi_granule_delegate() - Delegate a Granule
+ * @phys: PA of the Granule
+ *
+ * Delegate a Granule for use by the Realm World.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_granule_delegate(unsigned long phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_DELEGATE, phys, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_granule_undelegate() - Undelegate a Granule
+ * @phys: PA of the Granule
+ *
+ * Undelegate a Granule to allow use by the Normal World. Will fail if the
+ * Granule is in use.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_granule_undelegate(unsigned long phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_GRANULE_UNDELEGATE, phys, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_psci_complete() - Complete pending PSCI command
+ * @calling_rec: PA of the calling REC
+ * @target_rec: PA of the target REC
+ * @status: Status of the PSCI request
+ *
+ * Completes a pending PSCI command which was called with an MPIDR argument, by
+ * providing the corresponding REC.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_psci_complete(unsigned long calling_rec,
+				    unsigned long target_rec,
+				    unsigned long status)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSCI_COMPLETE, calling_rec, target_rec,
+			     status, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_activate() - Active a Realm
+ * @rd: PA of the RD
+ *
+ * Mark a Realm as Active signalling that creation is complete and allowing
+ * execution of the Realm.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_activate(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_ACTIVATE, rd, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_create() - Create a Realm
+ * @rd: PA of the RD
+ * @params_ptr: PA of Realm parameters
+ *
+ * Create a new Realm using the given parameters.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_create(unsigned long rd, unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_CREATE, rd, params_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_realm_destroy() - Destroy a Realm
+ * @rd: PA of the RD
+ *
+ * Destroys a Realm, all objects belonging to the Realm must be destroyed first.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_realm_destroy(unsigned long rd)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rec_aux_count() - Get number of auxiliary Granules required
+ * @rd: PA of the RD
+ * @aux_count: Number of pages written to this pointer
+ *
+ * A REC may require extra auxiliary pages to be delegateed for the RMM to
+ * store metadata (not visible to the normal world) in. This function provides
+ * the number of pages that are required.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_aux_count(unsigned long rd, unsigned long *aux_count)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_AUX_COUNT, rd, &res);
+
+	*aux_count = res.a1;
+	return res.a0;
+}
+
+/**
+ * rmi_rec_create() - Create a REC
+ * @rd: PA of the RD
+ * @rec: PA of the target REC
+ * @params_ptr: PA of REC parameters
+ *
+ * Create a REC using the parameters specified in the struct rec_params pointed
+ * to by @params_ptr.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_create(unsigned long rd, unsigned long rec,
+				 unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_CREATE, rd, rec, params_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rec_destroy() - Destroy a REC
+ * @rec: PA of the target REC
+ *
+ * Destroys a REC. The REC must not be running.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_destroy(unsigned long rec)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_DESTROY, rec, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rec_enter() - Enter a REC
+ * @rec: PA of the target REC
+ * @run_ptr: PA of RecRun structure
+ *
+ * Starts (or continues) execution within a REC.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_REC_ENTER, rec, run_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_create() - Creates an RTT
+ * @rd: PA of the RD
+ * @rtt: PA of the target RTT
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: Depth of the RTT within the tree
+ *
+ * Creates an RTT (Realm Translation Table) at the specified address and level
+ * within the realm.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_create(unsigned long rd, unsigned long rtt,
+				 unsigned long ipa, long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rd, rtt, ipa, level, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_destroy() - Destroy an RTT
+ * @rd: PA of the RD
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: Depth of the RTT within the tree
+ * @out_rtt: Pointer to write the PA of the RTT which was destroyed
+ * @out_top: Pointer to write the top IPA of non-live RTT entries
+ *
+ * Destroys an RTT. The RTT must be empty.
+ *
+ * Return: RMI return code.
+ */
+static inline int rmi_rtt_destroy(unsigned long rd,
+				  unsigned long ipa,
+				  long level,
+				  unsigned long *out_rtt,
+				  unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rd, ipa, level, &res);
+
+	*out_rtt = res.a1;
+	*out_top = res.a2;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_fold() - Fold an RTT
+ * @rd: PA of the RD
+ * @ipa: Base of the IPA range described by the RTT
+ * @level: Depth of the RTT within the tree
+ * @out_rtt: Pointer to write the PA of the RTT which was destroyed
+ *
+ * Folds an RTT. If all entries with the RTT are 'homogeneous' the RTT can be
+ * folded into the parent and the RTT destroyed.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_fold(unsigned long rd, unsigned long ipa,
+			       long level, unsigned long *out_rtt)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rd, ipa, level, &res);
+
+	*out_rtt = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_init_ripas() - Set RIPAS for new Realm
+ * @rd: PA of the RD
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Top IPA of range whose RIPAS was modified
+ *
+ * Sets the RIPAS of a target IPA range to RAM, for a Realm in the NEW state.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long base,
+				     unsigned long top, unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, base, top, &res);
+
+	*out_top = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_map_unprotected() - Map NS pages into a Realm
+ * @rd: PA of the RD
+ * @ipa: Base IPA of the mapping
+ * @level: Depth within the RTT tree
+ * @desc: RTTE descriptor
+ *
+ * Create a mapping from an Unprotected IPA to a Non-secure PA.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_map_unprotected(unsigned long rd,
+					  unsigned long ipa,
+					  long level,
+					  unsigned long desc)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, ipa, level,
+			     desc, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_read_entry() - Read an RTTE
+ * @rd: PA of the RD
+ * @ipa: IPA for which to read the RTTE
+ * @level: RTT level at which to read the RTTE
+ * @rtt: Output structure describing the RTTE
+ *
+ * Reads a RTTE (Realm Translation Table Entry).
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long ipa,
+				     long level, struct rtt_entry *rtt)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_READ_ENTRY,
+		rd, ipa, level
+	};
+
+	arm_smccc_1_2_smc(&regs, &regs);
+
+	rtt->walk_level = regs.a1;
+	rtt->state = regs.a2 & 0xFF;
+	rtt->desc = regs.a3;
+	rtt->ripas = regs.a4;
+
+	return regs.a0;
+}
+
+/**
+ * rmi_rtt_set_ripas() - Set RIPAS for an running realm
+ * @rd: PA of the RD
+ * @rec: PA of the REC making the request
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Pointer to write top IPA of range whose RIPAS was modified
+ *
+ * Completes a request made by the Realm to change the RIPAS of a target IPA
+ * range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
+				    unsigned long base, unsigned long top,
+				    unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, base, top, &res);
+
+	*out_top = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_unmap_unprotected() - Remove a NS mapping
+ * @rd: PA of the RD
+ * @ipa: Base IPA of the mapping
+ * @level: Depth within the RTT tree
+ * @out_top: Pointer to write top IPA of non-live RTT entries
+ *
+ * Removes a mapping at an Unprotected IPA.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
+					    unsigned long ipa,
+					    long level,
+					    unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, ipa,
+			     level, &res);
+
+	*out_top = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_get_phys() - Get the PA from a RTTE
+ * @rtt: The RTTE
+ *
+ * Return: the physical address from a RTT entry.
+ */
+static inline phys_addr_t rmi_rtt_get_phys(struct rtt_entry *rtt)
+{
+	return rtt->desc & GENMASK(47, 12);
+}
+
+#endif
-- 
2.34.1


