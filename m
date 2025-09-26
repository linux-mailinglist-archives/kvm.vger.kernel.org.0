Return-Path: <kvm+bounces-58862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E062EBA36D4
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:03:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFD8D1C21E2C
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080FB2F5A31;
	Fri, 26 Sep 2025 11:03:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6395D2F4A00;
	Fri, 26 Sep 2025 11:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758884596; cv=none; b=aEZoxegxfXzc2Q3Nsf23T+sOrm96ukp9d09BrYvTyL9mwClPP2N/XVEcEIwZcLT8HJTd1MJacllN3ws4knOWjNVJPxxdhZQD2/18TYRQdxFooEsdMQy7/vGESFwJQoFAlzEJNAkbh3jB8cWPDkvCIPrhddlDd+QWRmK3M8IiJmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758884596; c=relaxed/simple;
	bh=4TdQHtiq9emV62jMm3NPesbu3ZLRf3BP8d8M+m1nz9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtpLfK4P+Rofy8WKtps+W9O51MUEmgs9fEs5GCy4km+OVCq9VlKe/wBjh/j46mZQq20aIKAEOQ8u2pP3drVGJPRllzBzUDuEq7DunDAilxD9cCFMIkBYN0j16kL/JYlTGxIYBoVqGeuuoUfTYFyPvwb1iIyYGDjN4rAzFSUlEs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB797168F;
	Fri, 26 Sep 2025 04:03:04 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 378FB3F66E;
	Fri, 26 Sep 2025 04:03:08 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH 1/5] arm64: RME: Add SMC definitions introduced in RMM v1.1
Date: Fri, 26 Sep 2025 12:02:50 +0100
Message-ID: <20250926110254.55449-2-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250926110254.55449-1-steven.price@arm.com>
References: <20250926110254.55449-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM v1.1 adds a bunch of new SMCs for planes and device assignment.
Add the new SMC definitions including wrapper functions.

The definitions are based on DEN0137 version 1.1-alp14.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/rmi_cmds.h | 1104 +++++++++++++++++++++++++++--
 arch/arm64/include/asm/rmi_smc.h  |  121 +++-
 2 files changed, 1146 insertions(+), 79 deletions(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index ef53147c1984..cfeddf4a6ed1 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -142,6 +142,244 @@ static inline int rmi_granule_undelegate(unsigned long phys)
 	return res.a0;
 }
 
+/**
+ * rmi_mec_set_private() - Change state of a MEC to private
+ * @mecid: Memory Encryption Context Idenifier
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_mec_set_private(unsigned long mecid)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_MEC_SET_PRIVATE, mecid, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_mec_set_shared() - Change state of a MEC to shared
+ * @mecid: Memory Encryption Context Identifier
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_mec_set_shared(unsigned long mecid)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_MEC_SET_SHARED, mecid, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_abort() - Abort device communication associated with a PDEV
+ * @pdev_ptr: PA of the PDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_abort(unsigned long pdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_ABORT, pdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_aux_count() - Get number of auxiliary granules required for a PDEV
+ * @flags: PDEV flags
+ * @out_aux_count: Number of auxiliary granules required
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_aux_count(unsigned long flags,
+				     unsigned long *out_aux_count)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_AUX_COUNT, flags, &res);
+
+	*out_aux_count = res.a1;
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_communicate() - Perform device communication associated with a PDEV
+ * @pdev_ptr: PA of the PDEV
+ * @data_ptr: PA of the communication data structure
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_communicate(unsigned long pdev_ptr,
+				       unsigned long data_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_COMMUNICATE, pdev_ptr, data_ptr,
+			     &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_create() - Create a PDEV
+ * @pdev_ptr: PA of the PDEV
+ * @params_ptr: PA of PDEV parameters
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_create(unsigned long pdev_ptr,
+				  unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_CREATE, pdev_ptr, params_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_destroy() - Destroy a PDEV
+ * @pdev_ptr: PA of the PDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_destroy(unsigned long pdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_DESTROY, pdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_get_state() - Get state of a PDEV
+ * @pdev_ptr: PA of the PDEV
+ * @out_state: PDEV state
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_get_state(unsigned long pdev_ptr,
+				     unsigned long *out_state)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_GET_STATE, pdev_ptr, &res);
+
+	*out_state = res.a1;
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_ide_key_refresh() - Refresh keys ina n IDE connection
+ * @pdev_ptr: PA of the PDEV
+ * @coh: Select coherent or non-coherent IDE stream
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_ide_key_refresh(unsigned long pdev_ptr,
+					   unsigned long coh)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_IDE_KEY_REFRESH, pdev_ptr, coh, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_ide_reset() - Reset the IDE link of a PDEV
+ * @pdev_ptr: PA of the PDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_ide_reset(unsigned long pdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_IDE_RESET, pdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_p2p_connect() - Create a P2P stream between two PDEVs
+ * @stream_ptr: PA of the P2P_STREAM object
+ * @pdev_1_ptr: PA of the first PDEV object
+ * @pdev_2_ptr: PA of the second PDEV object
+ * @ide_sid: IDE stream ID
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_p2p_connect(unsigned long stream_ptr,
+				       unsigned long pdev_1_ptr,
+				       unsigned long pdev_2_ptr,
+				       unsigned long ide_sid)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_P2P_CONNECT, stream_ptr,
+			     pdev_1_ptr, pdev_2_ptr, ide_sid, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_p2p_disconnect() - Destroy a P2P stream between two PDEVs
+ * @stream_ptr: PA of the P2P_STREAM object
+ * @pdev_1_ptr: PA of the first PDEV object
+ * @pdev_2_ptr: PA of the second PDEV object
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_p2p_disconnect(unsigned long stream_ptr,
+					  unsigned long pdev_1_ptr,
+					  unsigned long pdev_2_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_P2P_DISCONNECT, stream_ptr,
+			     pdev_1_ptr, pdev_2_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_set_pubkey() - Provide public key associated with a PDEV
+ * @pdev_ptr: PA of the PDEV
+ * @params_ptr: PA of the key parameters
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_set_pubkey(unsigned long pdev_ptr,
+				      unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_SET_PUBKEY, pdev_ptr, params_ptr,
+			     &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_pdev_stop() - Stop a PDEV
+ * @pdev_ptr: PA of the PDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_pdev_stop(unsigned long pdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STOP, pdev_ptr, &res);
+
+	return res.a0;
+}
+
 /**
  * rmi_psci_complete() - Complete pending PSCI command
  * @calling_rec: PA of the calling REC
@@ -165,6 +403,76 @@ static inline int rmi_psci_complete(unsigned long calling_rec,
 	return res.a0;
 }
 
+/**
+ * rmi_psmmu_irq_notify() - Notify the RM of an SMMU interrupt
+ * @psmmu: PA of the PSMMU
+ * @irq: SMMU IRQ
+ * @out_action: Action required by host
+ * @out_rd: PA of RD
+ * @out_vsmmu: PA of VSMMU
+ * @out_msi_addr: MSI address
+ * @out_msi_data: MSI data
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_psmmu_irq_notify(unsigned long psmmu,
+				       unsigned long irq,
+				       unsigned long *out_action,
+				       unsigned long *out_rd,
+				       unsigned long *out_vsmmu,
+				       unsigned long *out_msi_addr,
+				       unsigned long *out_msi_data)
+{
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_PSMMU_IRQ_NOTIFY,
+		psmmu,
+		irq
+	};
+
+	arm_smccc_1_2_smc(&regs, &regs);
+
+	*out_action = regs.a1;
+	*out_rd = regs.a2;
+	*out_vsmmu = regs.a3;
+	*out_msi_addr = regs.a4;
+	*out_msi_data = regs.a5;
+
+	return regs.a0;
+}
+
+/**
+ * rmi_psmmu_msi_config() - Program the MSI config for SMMU
+ * @psmmu: PA of PSMMU
+ * @gerr_addr: MSI address of the GERROR interrupt
+ * @gerr_data: MSI data of the GERROR interrupt
+ * @eventq_addr: MSI address of the EVENTQ interrupt
+ * @eventq_data: MSI data of the EVENTQ interrupt
+ * @priq_addr: MSI address of the PRIQ interrupt
+ * @priq_data: MSI data of the PRIQ interrupt
+ *
+ * Programs the MSI configuration for the realm side of the physical SMMU.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_psmmu_msi_config(unsigned long psmmu,
+				       unsigned long gerr_addr,
+				       unsigned long gerr_data,
+				       unsigned long eventq_addr,
+				       unsigned long eventq_data,
+				       unsigned long priq_addr,
+				       unsigned long priq_data)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PSMMU_MSI_CONFIG, psmmu,
+			     gerr_data, gerr_data,
+			     eventq_addr, eventq_data,
+			     priq_addr, priq_data,
+			     &res);
+
+	return res.a0;
+}
+
 /**
  * rmi_realm_activate() - Active a realm
  * @rd: PA of the RD
@@ -297,49 +605,51 @@ static inline int rmi_rec_enter(unsigned long rec, unsigned long run_ptr)
 }
 
 /**
- * rmi_rtt_create() - Creates an RTT
+ * rmi_rtt_aux_create() - Creates an auxiliary RTT
  * @rd: PA of the RD
  * @rtt: PA of the target RTT
  * @ipa: Base of the IPA range described by the RTT
- * @level: Depth of the RTT within the tree
- *
- * Creates an RTT (Realm Translation Table) at the specified level for the
- * translation of the specified address within the realm.
+ * @level: RTT level
+ * @index: RTT tree index
  *
  * Return: RMI return code
  */
-static inline int rmi_rtt_create(unsigned long rd, unsigned long rtt,
-				 unsigned long ipa, long level)
+static inline int rmi_rtt_aux_create(unsigned long rd,
+				     unsigned long rtt,
+				     unsigned long ipa,
+				     long level,
+				     unsigned long index)
 {
 	struct arm_smccc_res res;
 
-	arm_smccc_1_1_invoke(SMC_RMI_RTT_CREATE, rd, rtt, ipa, level, &res);
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_AUX_CREATE, rd, rtt, ipa, level, index,
+			     &res);
 
 	return res.a0;
 }
 
 /**
- * rmi_rtt_destroy() - Destroy an RTT
+ * rmi_rtt_aux_destroy() - Destroys an auxiliary RTT
  * @rd: PA of the RD
- * @ipa: Base of the IPA range described by the RTT
- * @level: Depth of the RTT within the tree
- * @out_rtt: Pointer to write the PA of the RTT which was destroyed
- * @out_top: Pointer to write the top IPA of non-live RTT entries
+ * @ipa: Base of the IPA range describe dby the RTT
+ * @level: RTT level
+ * @index: RTT tree index
+ * @out_rtt: PA of the RTT which was destroyed
+ * @out_top: Top IPA of non-live RTT entries
  *
- * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
- * table are in ASSIGNED or TABLE state.
- *
- * Return: RMI return code.
+ * Return: RMI return code
  */
-static inline int rmi_rtt_destroy(unsigned long rd,
-				  unsigned long ipa,
-				  long level,
-				  unsigned long *out_rtt,
-				  unsigned long *out_top)
+static inline int rmi_rtt_aux_destroy(unsigned long rd,
+				      unsigned long ipa,
+				      long level,
+				      unsigned long index,
+				      unsigned long *out_rtt,
+				      unsigned long *out_top)
 {
 	struct arm_smccc_res res;
 
-	arm_smccc_1_1_invoke(SMC_RMI_RTT_DESTROY, rd, ipa, level, &res);
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_AUX_DESTROY, rd, ipa, level, index,
+			     &res);
 
 	if (out_rtt)
 		*out_rtt = res.a1;
@@ -350,23 +660,24 @@ static inline int rmi_rtt_destroy(unsigned long rd,
 }
 
 /**
- * rmi_rtt_fold() - Fold an RTT
+ * rmi_rtt_aux_fold() - Destroy a homogeneous auxility RTT
  * @rd: PA of the RD
  * @ipa: Base of the IPA range described by the RTT
- * @level: Depth of the RTT within the tree
- * @out_rtt: Pointer to write the PA of the RTT which was destroyed
- *
- * Folds an RTT. If all entries with the RTT are 'homogeneous' the RTT can be
- * folded into the parent and the RTT destroyed.
+ * @level: RTT level
+ * @index: RTT tree index
+ * @out_rtt: PA of the RTT which was destroyed
  *
  * Return: RMI return code
  */
-static inline int rmi_rtt_fold(unsigned long rd, unsigned long ipa,
-			       long level, unsigned long *out_rtt)
+static inline int rmi_rtt_aux_fold(unsigned long rd,
+				   unsigned long ipa,
+				   long level,
+				   unsigned long index,
+				   unsigned long *out_rtt)
 {
 	struct arm_smccc_res res;
 
-	arm_smccc_1_1_invoke(SMC_RMI_RTT_FOLD, rd, ipa, level, &res);
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_AUX_FOLD, rd, ipa, level, index, &res);
 
 	if (out_rtt)
 		*out_rtt = res.a1;
@@ -375,75 +686,254 @@ static inline int rmi_rtt_fold(unsigned long rd, unsigned long ipa,
 }
 
 /**
- * rmi_rtt_init_ripas() - Set RIPAS for new realm
+ * rmi_rtt_aux_map_protected() - Create a protected mapping in an aux RTT
  * @rd: PA of the RD
- * @base: Base of target IPA region
- * @top: Top of target IPA region
- * @out_top: Top IPA of range whose RIPAS was modified
- *
- * Sets the RIPAS of a target IPA range to RAM, for a realm in the NEW state.
+ * @ipa: IPA in the target realm
+ * @index: RTT tree index
+ * @out_state: State of RTT entry which caused command to fail
+ * @out_ripas: RIPAS of RTT entry which caused command to fail
  *
  * Return: RMI return code
  */
-static inline int rmi_rtt_init_ripas(unsigned long rd, unsigned long base,
-				     unsigned long top, unsigned long *out_top)
+static inline int rmi_rtt_aux_map_protected(unsigned long rd,
+					    unsigned long ipa,
+					    unsigned long index,
+					    unsigned long *out_state,
+					    unsigned long *out_ripas)
 {
-	struct arm_smccc_res res;
+	struct arm_smccc_1_2_regs regs = {
+		SMC_RMI_RTT_AUX_MAP_PROTECTED,
+		rd, ipa, index
+	};
 
-	arm_smccc_1_1_invoke(SMC_RMI_RTT_INIT_RIPAS, rd, base, top, &res);
+	arm_smccc_1_2_smc(&regs, &regs);
 
-	if (out_top)
-		*out_top = res.a1;
+	if (out_state)
+		*out_state = regs.a1;
+	if (out_ripas)
+		*out_ripas = regs.a2;
 
-	return res.a0;
+	return regs.a0;
 }
 
 /**
- * rmi_rtt_map_unprotected() - Map NS granules into a realm
+ * rmi_rtt_aux_map_unprotected() - Create an unprotected mapping in an aux RTT
  * @rd: PA of the RD
- * @ipa: Base IPA of the mapping
- * @level: Depth within the RTT tree
- * @desc: RTTE descriptor
- *
- * Create a mapping from an Unprotected IPA to a Non-secure PA.
+ * @ipa: IPA in the target realm
+ * @index: RTT tree index
  *
  * Return: RMI return code
  */
-static inline int rmi_rtt_map_unprotected(unsigned long rd,
-					  unsigned long ipa,
-					  long level,
-					  unsigned long desc)
+static inline int rmi_rtt_aux_map_unprotected(unsigned long rd,
+					      unsigned long ipa,
+					      unsigned long index)
 {
 	struct arm_smccc_res res;
 
-	arm_smccc_1_1_invoke(SMC_RMI_RTT_MAP_UNPROTECTED, rd, ipa, level,
-			     desc, &res);
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_AUX_MAP_UNPROTECTED, rd, ipa, index,
+			     &res);
 
 	return res.a0;
 }
 
 /**
- * rmi_rtt_read_entry() - Read an RTTE
+ * rmi_rtt_aux_unmap_protected() - Remove a protected mapping in an aux RTT
  * @rd: PA of the RD
- * @ipa: IPA for which to read the RTTE
- * @level: RTT level at which to read the RTTE
- * @rtt: Output structure describing the RTTE
- *
- * Reads a RTTE (Realm Translation Table Entry).
+ * @ipa: IPA in the target realm
+ * @index: RTT tree index
+ * @out_top: Top IPA of non-live RTT entry
  *
  * Return: RMI return code
  */
-static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long ipa,
-				     long level, struct rtt_entry *rtt)
+static inline int rmi_rtt_aux_unmap_protected(unsigned long rd,
+					      unsigned long ipa,
+					      unsigned long index,
+					      unsigned long *out_top)
 {
-	struct arm_smccc_1_2_regs regs = {
-		SMC_RMI_RTT_READ_ENTRY,
-		rd, ipa, level
-	};
+	struct arm_smccc_res res;
 
-	arm_smccc_1_2_invoke(&regs, &regs);
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_AUX_UNMAP_PROTECTED, rd, ipa, index,
+			     &res);
 
-	rtt->walk_level = regs.a1;
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_aux_unmap_unprotected() - Remove an unprotected mapping in an aux RTT
+ * @rd: PA of the RD
+ * @ipa: IPA in the target realm
+ * @index: RTT tree index
+ * @out_top: Top IPA of non-live RTT entry
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_aux_unmap_unprotected(unsigned long rd,
+						unsigned long ipa,
+						unsigned long index,
+						unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_AUX_UNMAP_UNPROTECTED, rd, ipa, index,
+			     &res);
+
+	if (out_top)
+		*out_top = res.a1;
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
+ * Creates an RTT (Realm Translation Table) at the specified level for the
+ * translation of the specified address within the realm.
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
+ * Destroys an RTT. The RTT must be non-live, i.e. none of the entries in the
+ * table are in ASSIGNED or TABLE state.
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
+	if (out_rtt)
+		*out_rtt = res.a1;
+	if (out_top)
+		*out_top = res.a2;
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
+	if (out_rtt)
+		*out_rtt = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_init_ripas() - Set RIPAS for new realm
+ * @rd: PA of the RD
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Top IPA of range whose RIPAS was modified
+ *
+ * Sets the RIPAS of a target IPA range to RAM, for a realm in the NEW state.
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
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
+}
+
+/**
+ * rmi_rtt_map_unprotected() - Map NS granules into a realm
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
+	arm_smccc_1_2_invoke(&regs, &regs);
+
+	rtt->walk_level = regs.a1;
 	rtt->state = regs.a2 & 0xFF;
 	rtt->desc = regs.a3;
 	rtt->ripas = regs.a4 & 0xFF;
@@ -478,6 +968,38 @@ static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
 	return res.a0;
 }
 
+/**
+ * rmi_rtt_set_s2ap() - Change the S2AP of a target IPA range
+ * @rd: PA of the RD
+ * @rec_ptr: PA of the target REC
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Top IPA of range whose S2AP was modified
+ * @out_rtt_tree: Index of RTT tree in which base alignment check failed
+ *
+ * Completes a request made by the realm to change the S2AP of a target IPA
+ * range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_rtt_set_s2ap(unsigned long rd, unsigned long rec_ptr,
+				   unsigned long base, unsigned long top,
+				   unsigned long *out_top,
+				   unsigned long *out_rtt_tree)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_S2AP, rd, rec_ptr, base, top,
+			     &res);
+
+	if (out_top)
+		*out_top = res.a1;
+	if (out_rtt_tree)
+		*out_rtt_tree = res.a2;
+
+	return res.a0;
+}
+
 /**
  * rmi_rtt_unmap_unprotected() - Remove a NS mapping
  * @rd: PA of the RD
@@ -505,4 +1027,444 @@ static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
 	return res.a0;
 }
 
+/**
+ * rmi_vdev_abort() - Abort device communication associated with a VDEV
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_abort(unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_ABORT, vdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_aux_count() - Get number of aux granules required for a VDEV
+ * @pdev_flags: PDEV flags
+ * @vdev_flags: VDEV flags
+ * @out_aux_count: Number of auxiliary granules required
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_aux_count(unsigned long pdev_flags,
+				     unsigned long vdev_flags,
+				     unsigned long *out_aux_count)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_AUX_COUNT, pdev_flags, vdev_flags,
+			     &res);
+
+	*out_aux_count = res.a1;
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_communicate() - Perform device communication with a VDEV
+ * @pdev_ptr: PA of the PDEV
+ * @vdev_ptr: PA of the VDEV
+ * @data_ptr: PA of the comms data structure
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_communicate(unsigned long pdev_ptr,
+				       unsigned long vdev_ptr,
+				       unsigned long data_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_COMMUNICATE, pdev_ptr, vdev_ptr,
+			     data_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_complete() - Complete a pending VDEV request
+ * @rec_ptr: PA of the REC
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_complete(unsigned long rec_ptr,
+				    unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_COMPLETE, rec_ptr, vdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_create() - Create a VDEV
+ * @rd: PA of the RD
+ * @pdev_ptr: PA of the PDEV
+ * @vdev_ptr: PA of the VDEV
+ * @params_ptr: PA of VDEV parameters
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_create(unsigned long rd,
+				  unsigned long pdev_ptr,
+				  unsigned long vdev_ptr,
+				  unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_CREATE, rd, pdev_ptr, vdev_ptr,
+			     params_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_destroy() - Destroy a VDEV
+ * @rd: PA of the RD
+ * @pdev_ptr: PA of the PDEV
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_destroy(unsigned long rd,
+				   unsigned long pdev_ptr,
+				   unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_DESTROY, rd, pdev_ptr, vdev_ptr,
+			     &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_get_interface_report() - Get VDEV interface report
+ * @rd: PA of the RD
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_get_interface_report(unsigned long rd,
+						unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_GET_INTERFACE_REPORT, rd, vdev_ptr,
+			     &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_get_measurements() - Get VDEV measurements
+ * @rd: PA of the RD
+ * @vdev_ptr: PA of the VDEV
+ * @params_ptr: PA of VDEV parameters
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_get_measurements(unsigned long rd,
+					    unsigned long vdev_ptr,
+					    unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_GET_MEASUREMENTS, rd, vdev_ptr,
+			     params_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_get_state() - Get state of a VDEV
+ * @vdev_ptr: PA of the VDEV
+ * @out_state: VDEV state
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_get_state(unsigned long vdev_ptr,
+				     unsigned long *out_state)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_GET_STATE, vdev_ptr, &res);
+
+	*out_state = res.a1;
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_lock() - Lock VDEV
+ * @rd: PA of the RD
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_lock(unsigned long rd,
+				unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_LOCK, rd, vdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_map() - Maps device memory
+ * @rd: PA of the RD for the target realm
+ * @vdev_ptr: PA of the VDEV
+ * @ipa: IPA at which the memory will be mapped in the target realm
+ * @level: RTT level
+ * @addr: PA of the target device memory
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_map(unsigned long rd, unsigned long vdev_ptr,
+			       unsigned long ipa, long level,
+			       unsigned long addr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_MAP, rd, vdev_ptr, ipa, level, addr,
+			     &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_p2p_bind() - Create a P2P binding between two VDEVs
+ * @stream_ptr: PA of the P2P_STREAM object
+ * @rd: PA of the RD
+ * @rec_ptr: PA of the target REC
+ * @pdev_1_ptr: PA of the first PDEV object
+ * @pdev_2_ptr: PA of the second PDEV object
+ * @vdev_1_ptr: PA of the first VDEV object
+ * @vdev_2_ptr: PA of the second VDEV object
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_p2p_bind(unsigned long stream_ptr,
+				    unsigned long rd,
+				    unsigned long rec_ptr,
+				    unsigned long pdev_1_ptr,
+				    unsigned long pdev_2_ptr,
+				    unsigned long vdev_1_ptr,
+				    unsigned long vdev_2_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_P2P_BIND, stream_ptr, rd, rec_ptr,
+			     pdev_1_ptr, pdev_2_ptr,
+			     vdev_1_ptr, vdev_2_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_p2p_unbind() - Remove a P2P binding between two VDEVs
+ * @stream_ptr: PA of the P2P_STREAM object
+ * @rd: PA of the RD
+ * @rec_ptr: PA of the target REC
+ * @pdev_1_ptr: PA of the first PDEV object
+ * @pdev_2_ptr: PA of the second PDEV object
+ * @vdev_1_ptr: PA of the first VDEV object
+ * @vdev_2_ptr: PA of the second VDEV object
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_p2p_unbind(unsigned long stream_ptr,
+				      unsigned long rd,
+				      unsigned long rec_ptr,
+				      unsigned long pdev_1_ptr,
+				      unsigned long pdev_2_ptr,
+				      unsigned long vdev_1_ptr,
+				      unsigned long vdev_2_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_P2P_UNBIND, stream_ptr, rd, rec_ptr,
+			     pdev_1_ptr, pdev_2_ptr,
+			     vdev_1_ptr, vdev_2_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_start() - Start a VDEV
+ * @rd: PA of the RD
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_start(unsigned long rd, unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_START, rd, vdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_unlock() - Unlock a VDEV
+ * @rd: PA of the RD
+ * @vdev_ptr: PA of the VDEV
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_unlock(unsigned long rd, unsigned long vdev_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_UNLOCK, rd, vdev_ptr, &res);
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_unmap() - Unmap device memory
+ * @rd: PA of the RD which owns the target device memory
+ * @vdev_ptr: PA of the VDEV
+ * @ipa: IPA at which the memory is mapped in the target realm
+ * @level: RTT level
+ * @out_pa: PA of the device memory which was unmapped
+ * @out_top: Top IPA of non-live RTT entries
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_unmap(unsigned long rd, unsigned long vdev_ptr,
+				 unsigned long ipa, long level,
+				 unsigned long *out_pa, unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_UNMAP, rd, vdev_ptr, ipa, level,
+			     &res);
+
+	if (out_pa)
+		*out_pa = res.a1;
+	if (out_top)
+		*out_top = res.a2;
+
+	return res.a0;
+}
+
+/**
+ * rmi_vdev_validate_mapping() - Complete a request to valid mappings
+ * @rd: PA of the RD for the target realm
+ * @rec_ptr: PA of the target REC
+ * @pdev_ptr: PA of the PDEV
+ * @vdev_ptr: PA of the VDEV
+ * @base: Base of target IPA region
+ * @top: Top of target IPA region
+ * @out_top: Top IPA of range whose RIPAS was modified
+ *
+ * Completes a request made by the realm to validate mappings to device memory
+ * from a target IPA range.
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vdev_validate_mapping(unsigned long rd,
+					    unsigned long rec_ptr,
+					    unsigned long pdev_ptr,
+					    unsigned long vdev_ptr,
+					    unsigned long base,
+					    unsigned long top,
+					    unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_VALIDATE_MAPPING, rd, rec_ptr,
+			     pdev_ptr, vdev_ptr, base, top, &res);
+
+	if (out_top)
+		*out_top = res.a1;
+
+	return res.a0;
+}
+
+/** rmi_vsmmu_create() - Create a VSMMU
+ * @rd: PA of the RD
+ * @vsmmu_ptr: PA of the VSMMU
+ * @params_ptr: PA of VSMMU parameters
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vsmmu_create(unsigned long rd,
+				   unsigned long vsmmu_ptr,
+				   unsigned long params_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VSMMU_CREATE, rd, vsmmu_ptr,
+			     params_ptr, &res);
+
+	return res.a0;
+}
+
+/** rmi_vsmmu_destroy() - Destroy a VSMMU
+ * @rd: PA of the RD
+ * @vsmmu_ptr: PA of the VSMMU
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vsmmu_destroy(unsigned long rd,
+				    unsigned long vsmmu_ptr)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VSMMU_DESTROY, rd, vsmmu_ptr, &res);
+
+	return res.a0;
+}
+
+/** rmi_vsmmu_map() - Create a VSMMU mapping
+ * @rd: PA of the RD
+ * @vsmmu_ptr: PA of the VSMMU
+ * @ipa: IPA at which to create the mapping
+ * @level: RTT level
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vsmmu_map(unsigned long rd,
+				unsigned long vsmmu_ptr,
+				unsigned long ipa,
+				long level)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VSMMU_MAP, rd, vsmmu_ptr, ipa, level,
+			     &res);
+
+	return res.a0;
+}
+
+/** rmi_vsmmu_unmap() - Remove a VSMMU mapping
+ * @rd: PA of the RD
+ * @ipa: IPA at which to remove the mapping
+ * @vsmmu_ptr: PA of the VSMMU
+ * @out_top: Top IPA of non-live RTT entries
+ *
+ * Return: RMI return code
+ */
+static inline int rmi_vsmmu_unmap(unsigned long rd,
+				  unsigned long ipa,
+				  unsigned long vsmmu_ptr,
+				  unsigned long *out_top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VSMMU_UNMAP, rd, ipa, vsmmu_ptr, &res);
+
+	if (out_top)
+		*out_top = res.a1;
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 1000368f1bca..11d45d2c0c52 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -24,7 +24,7 @@
 #define SMC_RMI_DATA_CREATE		SMC_RMI_CALL(0x0153)
 #define SMC_RMI_DATA_CREATE_UNKNOWN	SMC_RMI_CALL(0x0154)
 #define SMC_RMI_DATA_DESTROY		SMC_RMI_CALL(0x0155)
-
+#define SMC_RMI_PDEV_AUX_COUNT		SMC_RMI_CALL(0x0156)
 #define SMC_RMI_REALM_ACTIVATE		SMC_RMI_CALL(0x0157)
 #define SMC_RMI_REALM_CREATE		SMC_RMI_CALL(0x0158)
 #define SMC_RMI_REALM_DESTROY		SMC_RMI_CALL(0x0159)
@@ -34,19 +34,63 @@
 #define SMC_RMI_RTT_CREATE		SMC_RMI_CALL(0x015d)
 #define SMC_RMI_RTT_DESTROY		SMC_RMI_CALL(0x015e)
 #define SMC_RMI_RTT_MAP_UNPROTECTED	SMC_RMI_CALL(0x015f)
-
+#define SMC_RMI_VDEV_AUX_COUNT		SMC_RMI_CALL(0x0160)
 #define SMC_RMI_RTT_READ_ENTRY		SMC_RMI_CALL(0x0161)
 #define SMC_RMI_RTT_UNMAP_UNPROTECTED	SMC_RMI_CALL(0x0162)
-
+#define SMC_RMI_VDEV_VALIDATE_MAPPING	SMC_RMI_CALL(0x0163)
 #define SMC_RMI_PSCI_COMPLETE		SMC_RMI_CALL(0x0164)
 #define SMC_RMI_FEATURES		SMC_RMI_CALL(0x0165)
 #define SMC_RMI_RTT_FOLD		SMC_RMI_CALL(0x0166)
 #define SMC_RMI_REC_AUX_COUNT		SMC_RMI_CALL(0x0167)
 #define SMC_RMI_RTT_INIT_RIPAS		SMC_RMI_CALL(0x0168)
 #define SMC_RMI_RTT_SET_RIPAS		SMC_RMI_CALL(0x0169)
+#define SMC_RMI_VSMMU_CREATE		SMC_RMI_CALL(0x016a)
+#define SMC_RMI_VSMMU_DESTROY		SMC_RMI_CALL(0x016b)
+#define SMC_RMI_VSMMU_MAP		SMC_RMI_CALL(0x016c)
+#define SMC_RMI_VSMMU_UNMAP		SMC_RMI_CALL(0x016d)
+#define SMC_RMI_PSMMU_MSI_CONFIG	SMC_RMI_CALL(0x016e)
+#define SMC_RMI_PSMMU_IRQ_NOTIFY	SMC_RMI_CALL(0x016f)
+
+#define SMC_RMI_PDEV_P2P_CONNECT	SMC_RMI_CALL(0x0171)
+#define SMC_RMI_VDEV_MAP		SMC_RMI_CALL(0x0172)
+#define SMC_RMI_VDEV_UNMAP		SMC_RMI_CALL(0x0173)
+#define SMC_RMI_PDEV_ABORT		SMC_RMI_CALL(0x0174)
+#define SMC_RMI_PDEV_COMMUNICATE	SMC_RMI_CALL(0x0175)
+#define SMC_RMI_PDEV_CREATE		SMC_RMI_CALL(0x0176)
+#define SMC_RMI_PDEV_DESTROY		SMC_RMI_CALL(0x0177)
+#define SMC_RMI_PDEV_GET_STATE		SMC_RMI_CALL(0x0178)
+#define SMC_RMI_PDEV_IDE_RESET		SMC_RMI_CALL(0x0179)
+#define SMC_RMI_PDEV_IDE_KEY_REFRESH	SMC_RMI_CALL(0x017a)
+#define SMC_RMI_PDEV_SET_PUBKEY		SMC_RMI_CALL(0x017b)
+#define SMC_RMI_PDEV_STOP		SMC_RMI_CALL(0x017c)
+#define SMC_RMI_RTT_AUX_CREATE		SMC_RMI_CALL(0x017d)
+#define SMC_RMI_RTT_AUX_DESTROY		SMC_RMI_CALL(0x017e)
+#define SMC_RMI_RTT_AUX_FOLD		SMC_RMI_CALL(0x017f)
+#define SMC_RMI_RTT_AUX_MAP_PROTECTED	SMC_RMI_CALL(0x0180)
+#define SMC_RMI_RTT_AUX_MAP_UNPROTECTED	SMC_RMI_CALL(0x0181)
+#define SMC_RMI_PDEV_P2P_DISCONNECT	SMC_RMI_CALL(0x0182)
+#define SMC_RMI_RTT_AUX_UNMAP_PROTECTED	SMC_RMI_CALL(0x0183)
+#define SMC_RMI_RTT_AUX_UNMAP_UNPROTECTED SMC_RMI_CALL(0x0184)
+#define SMC_RMI_VDEV_ABORT		SMC_RMI_CALL(0x0185)
+#define SMC_RMI_VDEV_COMMUNICATE	SMC_RMI_CALL(0x0186)
+#define SMC_RMI_VDEV_CREATE		SMC_RMI_CALL(0x0187)
+#define SMC_RMI_VDEV_DESTROY		SMC_RMI_CALL(0x0188)
+#define SMC_RMI_VDEV_GET_STATE		SMC_RMI_CALL(0x0189)
+#define SMC_RMI_VDEV_UNLOCK		SMC_RMI_CALL(0x018a)
+#define SMC_RMI_RTT_SET_S2AP		SMC_RMI_CALL(0x018b)
+#define SMC_RMI_MEC_SET_SHARED		SMC_RMI_CALL(0x018c)
+#define SMC_RMI_MEC_SET_PRIVATE		SMC_RMI_CALL(0x018d)
+#define SMC_RMI_VDEV_COMPLETE		SMC_RMI_CALL(0x018e)
+
+#define SMC_RMI_VDEV_GET_INTERFACE_REPORT SMC_RMI_CALL(0x01d0)
+#define SMC_RMI_VDEV_GET_MEASUREMENTS	SMC_RMI_CALL(0x01d1)
+#define SMC_RMI_VDEV_LOCK		SMC_RMI_CALL(0x01d2)
+#define SMC_RMI_VDEV_START		SMC_RMI_CALL(0x01d3)
+#define SMC_RMI_VDEV_P2P_BIND		SMC_RMI_CALL(0x01d4)
+#define SMC_RMI_VDEV_P2P_UNBIND		SMC_RMI_CALL(0x01d5)
 
 #define RMI_ABI_MAJOR_VERSION	1
-#define RMI_ABI_MINOR_VERSION	0
+#define RMI_ABI_MINOR_VERSION	1
 
 #define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
 #define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
@@ -64,11 +108,15 @@
 #define RMI_ERROR_REALM		2
 #define RMI_ERROR_REC		3
 #define RMI_ERROR_RTT		4
+#define RMI_ERROR_NOT_SUPPORTED	5
+#define RMI_ERROR_DEVICE	6
+#define RMI_ERROR_RTT_AUX	7
 
 enum rmi_ripas {
 	RMI_EMPTY = 0,
 	RMI_RAM = 1,
 	RMI_DESTROYED = 2,
+	RMI_DEV = 3,
 };
 
 #define RMI_NO_MEASURE_CONTENT	0
@@ -86,11 +134,31 @@ enum rmi_ripas {
 #define RMI_FEATURE_REGISTER_0_HASH_SHA_512	BIT(33)
 #define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS	GENMASK(37, 34)
 #define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER	GENMASK(41, 38)
-#define RMI_FEATURE_REGISTER_0_Reserved		GENMASK(63, 42)
+#define RMI_FEATURE_REGISTER_0_DA		BIT(42)
+#define RMI_FEATURE_REGISTER_0_RTT_PLANE	GENMASK(44, 43)
+#define RMI_FEATURE_REGISTER_0_MAX_NUM_AUX_PLANES GENMASK(48, 45)
+#define RMI_FEATURE_REGISTER_0_RTT_S2AP_INDIRECT BIT(49)
+#define RMI_FEATURE_REGISTER_0_Reserved		GENMASK(63, 50)
+
+#define RMI_RTT_PLANE_AUX		0
+#define RMI_RTT_PLANE_AUX_SINGLE	1
+#define RMI_RTT_PLANE_SINGLE		2
 
 #define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
 #define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
 #define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
+#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
+#define RMI_REALM_PARAM_FLAG_LFA_POLICY		GENMASK(6, 5)
+
+#define RMI_REALM_PARAM_FLAG1_RTT_TREE_PP	BIT(0)
+#define RMI_REALM_PARAM_FLAG1_RTT_S2AP_ENCODING	BIT(1)
+#define RMI_REALM_PARAM_FLAG1_ATS		BIT(2)
+
+#define RMI_BASE_PERM_NOACCESS_INDEX	0
+#define RMI_BASE_PERM_RO_INDEX		1
+#define RMI_BASE_PERM_WO_INDEX		2
+#define RMI_BASE_PERM_RW_INDEX		3
+#define RMI_BASE_PERM_RW_puX_INDEX	4
 
 /*
  * Note many of these fields are smaller than u64 but all fields have u64
@@ -106,11 +174,15 @@ struct realm_params {
 			u64 num_wps;
 			u64 pmu_num_ctrs;
 			u64 hash_algo;
+			u64 num_aux_planes;
 		};
 		u8 padding0[0x400];
 	};
 	union { /* 0x400 */
-		u8 rpv[64];
+		struct {
+			u8 rpv[64];
+			u64 ats_plane;
+		};
 		u8 padding1[0x400];
 	};
 	union { /* 0x800 */
@@ -119,8 +191,18 @@ struct realm_params {
 			u64 rtt_base;
 			s64 rtt_level_start;
 			u64 rtt_num_start;
+			u64 flags1;
+			u64 mecid;
 		};
-		u8 padding2[0x800];
+		u8 padding2[0x700];
+	};
+	union { /* 0xf00 */
+		u16 aux_vmid[3];
+		u8 padding3[0x80];
+	};
+	union { /* 0xf80 */
+		u64 aux_rtt_base[3];
+		u8 padding4[0x80];
 	};
 };
 
@@ -165,6 +247,9 @@ struct rec_params {
 #define REC_ENTER_FLAG_TRAP_WFI		BIT(2)
 #define REC_ENTER_FLAG_TRAP_WFE		BIT(3)
 #define REC_ENTER_FLAG_RIPAS_RESPONSE	BIT(4)
+#define REC_ENTER_FLAG_S2AP_RESPONSE	BIT(5)
+#define REC_ENTER_FLAG_DEV_MEM_RESPONSE	BIT(6)
+#define REC_ENTER_FLAG_FORCE_P0		BIT(7)
 
 #define REC_RUN_GPRS			31
 #define REC_MAX_GIC_NUM_LRS		16
@@ -204,6 +289,10 @@ struct rec_enter {
 #define RMI_EXIT_RIPAS_CHANGE		0x04
 #define RMI_EXIT_HOST_CALL		0x05
 #define RMI_EXIT_SERROR			0x06
+#define RMI_EXIT_S2AP_CHANGE		0x07
+#define RMI_EXIT_VDEV_REQUEST		0x08
+#define RMI_EXIT_VDEV_COMM		0x09
+#define RMI_EXIT_DEV_MEM_MAP		0x0a
 
 struct rec_exit {
 	union { /* 0x000 */
@@ -215,6 +304,8 @@ struct rec_exit {
 			u64 esr;
 			u64 far;
 			u64 hpfar;
+			u64 rtt_tree;
+			s64 rtt_level;
 		};
 		u8 padding1[0x100];
 	};
@@ -246,11 +337,25 @@ struct rec_exit {
 			u64 ripas_top;
 			u8 ripas_value;
 			u8 padding8[7];
+			u64 padding_518;
+			u64 s2ap_base;
+			u64 s2ap_top;
+			u64 vdev_id;
 		};
 		u8 padding5[0x100];
 	};
 	union { /* 0x600 */
-		u16 imm;
+		struct {
+			u16 imm;
+			u16 padding_602;
+			u32 padding_604;
+			u64 plane;
+			u64 vdev;
+			u64 vdev_action;
+			u64 dev_mem_base;
+			u64 dev_mem_top;
+			u64 dev_mem_pa;
+		};
 		u8 padding6[0x100];
 	};
 	union { /* 0x700 */
-- 
2.43.0


