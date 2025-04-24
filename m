Return-Path: <kvm+bounces-44166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9504A9B0AE
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29DF17A90CB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F25290BBA;
	Thu, 24 Apr 2025 14:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c+72HnD5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CAD28EA4A
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504058; cv=none; b=azEBZfZeFPTn4kS3IFIVZEdK0UF/T4NV6dYXcLX8y9QDUl8iSClvbBEtI4gC+qPgfiX+2cKYjc99UpU5BMF0+utrjTOLu8yfI9EoBgo3zbGKufNHB+o4uIYnr3080n/mB1vFc6B1tQyk10mXPtJ4WbRygxp6IrA0KS+Ufwjo+9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504058; c=relaxed/simple;
	bh=stGjEAXhqZzqZDA4Zy4FUNW4LEqqvQTzHgd1ovyETPw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uvogchsra3HzCWmBUt0A82pV6p9gfWKorpkfkexxBusLiCl0n/N0g6l+WnYiumugOt3kaU80npDfREaE/piukCRMkaIqfJSx1VDSA8NyZJwkzfo4SQTlz5K/9j0nWClO8sgL+qGB1QiAAN+5/OpI4NRlXlRnePregiAGPE3g89w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=c+72HnD5; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39c0dfba946so793803f8f.3
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504053; x=1746108853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbjrAsGjkzHb8tCUfbOmumB9MeDC4bmSUl/RmrD2cWk=;
        b=c+72HnD5/D8MG9G0SFJbb1Xi+Ip2linbgO0v5+sPWmdtg1xKGVY7/JTb31iY2U6w/P
         aZcID0zyLXbxvVi+6sg2TtcXxCuM5XboTHBF7kUs70fVR9oaO7HME799SG71ZxFgG7ZN
         yR4fh4IYnHQUH7kZ+7ooo+vuG4xLT7Wf/7r8WDXkSX2j0WDMln6VE3MPhoKJDCLDjPvr
         YN13BfURiLm/PPd0CtVivdhZ8tGPV/YZUglcfVPiVZh2vyXBRMTopr5eY0uNbdSUsmHO
         Q1SmJPQsl3ozkuSBpqvOradrt/k/hxe1iiTTzCH8w2SZVTew6fGj+GPLahoyvvlqpw8F
         732w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504053; x=1746108853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbjrAsGjkzHb8tCUfbOmumB9MeDC4bmSUl/RmrD2cWk=;
        b=gZZE2nuGjiBuhRZ/WobXrb72A+FQv8wrJQr2WT+Y3wQlZLGs2wZQraDZf16C3GD2O8
         afpZdww5+a/B7H6iC9ucNUcToNCIoiZKLhXKuzyowLTecBjYWWsHkT7BI7zMNUovsRvv
         FXFvEpE1/wdfrYYTXsyy5TRXqmquwa/tL60/b4JL+jOOAfKFxFU6SrSiBwea/wsF12jk
         qczO3nuWMOS8tyRskOASN22Jckw6QFmj/vp13TGEExFTTLO4wGXvc630uHjKhJ5XCBHm
         weECsPmIiz3KgTwu0wwhnkcFlU/1vADInHqiScmrExIjq70D2u4k2RMK/NHIdFRaaNE6
         XqOg==
X-Forwarded-Encrypted: i=1; AJvYcCWcGb5swEPCZSCspjBz/yAAu3wgaucI9DlyBIVycHDU4EHpwKSf0F2PXv2ROuoMFwfYEMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHpKPFKamCTh4KGSdhlYsgPeVmskZncTbZZPlwzFeYbrq8gOIr
	tVgQDYGkU5sYtvzQlUoZXWePh5camjHhdLVUHr5LeS0vxoOD5xXiJ2z7vznyM5o=
X-Gm-Gg: ASbGncvC6BEKHc6WySZwzAArmYvbFzsRcNzeevueB2jFGjSCbETK28WBifjzucjjk2e
	xYI3EpG2e5T3eZjf8YxHnZsyICIc7hbVleOgNiNlp9w7en0D4cZRIRx62R/CtSCAc6+i4l6BLL2
	vytWPltK9+Qc7Qdn0RfWGqsMmErBTvwe9OUcxY3Z+8ZXCoZ0CZtBD05P2F7OKWdCh+owhhmvEiQ
	APpdtxc+BklBTbVCMDB5u0+omqztkmAGKRHDW4jtQIluDgIJhyvbSBaaz+bJ+FLPAuXKhQFT12k
	UyAP1tifHLk1G3IO6qojN5ijbvXZZ+Panww3Y3uMPFU4d2Hvr+l5FJ9apu1MUjSZ6VwDd/3RN4T
	bF09y1fp4FPdD9NBJ
X-Google-Smtp-Source: AGHT+IGxrh9LsxSTvY+9a9cBpLnjZelejrN6GQ8nRlvgc6+sGPLvZ+HV3GV5bjEoSe2VS8MsJ3m6Aw==
X-Received: by 2002:a05:6000:4202:b0:391:40bd:6222 with SMTP id ffacd0b85a97d-3a06cf5c719mr2302063f8f.22.1745504053364;
        Thu, 24 Apr 2025 07:14:13 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:12 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Srivatsa Vaddagiri <quic_svaddagiri@quicinc.com>
Subject: [RFC PATCH 21/34] gunyah: Add hypercalls for demand paging
Date: Thu, 24 Apr 2025 15:13:28 +0100
Message-Id: <20250424141341.841734-22-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

Three hypercalls are needed to support demand paging.
In create page mappings for a virtual machine's address space, memory
must be moved to a memory extent that is allowed to be mapped into that
address space. Memory extents are Gunyah's implementation of access
control. Once the memory is moved to the proper memory extent, the
memory can be mapped into the VM's address space. Implement the
bindings to perform those hypercalls.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagiri@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/gunyah/gunyah_hypercall.c | 87 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/gunyah.h      | 22 +++++++
 include/linux/gunyah.h               | 56 ++++++++++++++++++
 3 files changed, 165 insertions(+)

diff --git a/arch/arm64/gunyah/gunyah_hypercall.c b/arch/arm64/gunyah/gunyah_hypercall.c
index fee21df42c17..38403dc28c66 100644
--- a/arch/arm64/gunyah/gunyah_hypercall.c
+++ b/arch/arm64/gunyah/gunyah_hypercall.c
@@ -39,6 +39,9 @@ EXPORT_SYMBOL_GPL(arch_is_gunyah_guest);
 #define GUNYAH_HYPERCALL_HYP_IDENTIFY		GUNYAH_HYPERCALL(0x8000)
 #define GUNYAH_HYPERCALL_MSGQ_SEND		GUNYAH_HYPERCALL(0x801B)
 #define GUNYAH_HYPERCALL_MSGQ_RECV		GUNYAH_HYPERCALL(0x801C)
+#define GUNYAH_HYPERCALL_ADDRSPACE_MAP		GUNYAH_HYPERCALL(0x802B)
+#define GUNYAH_HYPERCALL_ADDRSPACE_UNMAP	GUNYAH_HYPERCALL(0x802C)
+#define GUNYAH_HYPERCALL_MEMEXTENT_DONATE	GUNYAH_HYPERCALL(0x8061)
 #define GUNYAH_HYPERCALL_VCPU_RUN		GUNYAH_HYPERCALL(0x8065)
 /* clang-format on */
 
@@ -114,6 +117,90 @@ enum gunyah_error gunyah_hypercall_msgq_recv(u64 capid, void *buff, size_t size,
 }
 EXPORT_SYMBOL_GPL(gunyah_hypercall_msgq_recv);
 
+/**
+ * gunyah_hypercall_addrspace_map() - Add memory to an address space from a memory extent
+ * @capid: Address space capability ID
+ * @extent_capid: Memory extent capability ID
+ * @vbase: location in address space
+ * @extent_attrs: Attributes for the memory
+ * @flags: Flags for address space mapping
+ * @offset: Offset into memory extent (physical address of memory)
+ * @size: Size of memory to map; must be page-aligned
+ */
+enum gunyah_error gunyah_hypercall_addrspace_map(u64 capid, u64 extent_capid, u64 vbase,
+					u32 extent_attrs, u32 flags, u64 offset, u64 size)
+{
+	struct arm_smccc_1_2_regs args = {
+		.a0 = GUNYAH_HYPERCALL_ADDRSPACE_MAP,
+		.a1 = capid,
+		.a2 = extent_capid,
+		.a3 = vbase,
+		.a4 = extent_attrs,
+		.a5 = flags,
+		.a6 = offset,
+		.a7 = size,
+		/* C language says this will be implictly zero. Gunyah requires 0, so be explicit */
+		.a8 = 0,
+	};
+	struct arm_smccc_1_2_regs res;
+
+	arm_smccc_1_2_hvc(&args, &res);
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_addrspace_map);
+
+/**
+ * gunyah_hypercall_addrspace_unmap() - Remove memory from an address space
+ * @capid: Address space capability ID
+ * @extent_capid: Memory extent capability ID
+ * @vbase: location in address space
+ * @flags: Flags for address space mapping
+ * @offset: Offset into memory extent (physical address of memory)
+ * @size: Size of memory to map; must be page-aligned
+ */
+enum gunyah_error gunyah_hypercall_addrspace_unmap(u64 capid, u64 extent_capid, u64 vbase,
+					u32 flags, u64 offset, u64 size)
+{
+	struct arm_smccc_1_2_regs args = {
+		.a0 = GUNYAH_HYPERCALL_ADDRSPACE_UNMAP,
+		.a1 = capid,
+		.a2 = extent_capid,
+		.a3 = vbase,
+		.a4 = flags,
+		.a5 = offset,
+		.a6 = size,
+		/* C language says this will be implictly zero. Gunyah requires 0, so be explicit */
+		.a7 = 0,
+	};
+	struct arm_smccc_1_2_regs res;
+
+	arm_smccc_1_2_hvc(&args, &res);
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_addrspace_unmap);
+
+/**
+ * gunyah_hypercall_memextent_donate() - Donate memory from one memory extent to another
+ * @options: donate options
+ * @from_capid: Memory extent capability ID to donate from
+ * @to_capid: Memory extent capability ID to donate to
+ * @offset: Offset into memory extent (physical address of memory)
+ * @size: Size of memory to donate; must be page-aligned
+ */
+enum gunyah_error gunyah_hypercall_memextent_donate(u32 options, u64 from_capid, u64 to_capid,
+					    u64 offset, u64 size)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_hvc(GUNYAH_HYPERCALL_MEMEXTENT_DONATE, options, from_capid, to_capid,
+				offset, size, 0, &res);
+
+	return res.a0;
+}
+EXPORT_SYMBOL_GPL(gunyah_hypercall_memextent_donate);
+
 /**
  * gunyah_hypercall_vcpu_run() - Donate CPU time to a vcpu
  * @capid: capability ID of the vCPU to run
diff --git a/arch/arm64/include/asm/gunyah.h b/arch/arm64/include/asm/gunyah.h
index 29079d1a4df2..4adf24977fd1 100644
--- a/arch/arm64/include/asm/gunyah.h
+++ b/arch/arm64/include/asm/gunyah.h
@@ -32,4 +32,26 @@ static inline int arch_gunyah_fill_irq_fwspec_params(u32 virq,
 	}
 	return 0;
 }
+
+enum arch_gunyah_memtype {
+	/* clang-format off */
+	GUNYAH_MEMTYPE_DEVICE_nGnRnE	= 0,
+	GUNYAH_DEVICE_nGnRE		= 1,
+	GUNYAH_DEVICE_nGRE		= 2,
+	GUNYAH_DEVICE_GRE		= 3,
+
+	GUNYAH_NORMAL_NC	= 0b0101,
+	GUNYAH_NORMAL_ONC_IWT	= 0b0110,
+	GUNYAH_NORMAL_ONC_IWB	= 0b0111,
+	GUNYAH_NORMAL_OWT_INC	= 0b1001,
+	GUNYAH_NORMAL_WT	= 0b1010,
+	GUNYAH_NORMAL_OWT_IWB	= 0b1011,
+	GUNYAH_NORMAL_OWB_INC	= 0b1101,
+	GUNYAH_NORMAL_OWB_IWT	= 0b1110,
+	GUNYAH_NORMAL_WB	= 0b1111,
+	/* clang-format on */
+};
+
+#define ARCH_GUNYAH_DEFAULT_MEMTYPE	GUNYAH_NORMAL_WB
+
 #endif
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index fa6e3fd4bee1..2648d3a623de 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -270,6 +270,62 @@ enum gunyah_error gunyah_hypercall_msgq_send(u64 capid, size_t size, void *buff,
 enum gunyah_error gunyah_hypercall_msgq_recv(u64 capid, void *buff, size_t size,
 					     size_t *recv_size, bool *ready);
 
+#define GUNYAH_ADDRSPACE_SELF_CAP 0
+
+enum gunyah_pagetable_access {
+	/* clang-format off */
+	GUNYAH_PAGETABLE_ACCESS_NONE		= 0,
+	GUNYAH_PAGETABLE_ACCESS_X		= 1,
+	GUNYAH_PAGETABLE_ACCESS_W		= 2,
+	GUNYAH_PAGETABLE_ACCESS_R		= 4,
+	GUNYAH_PAGETABLE_ACCESS_RX		= 5,
+	GUNYAH_PAGETABLE_ACCESS_RW		= 6,
+	GUNYAH_PAGETABLE_ACCESS_RWX		= 7,
+	/* clang-format on */
+};
+
+/* clang-format off */
+#define GUNYAH_MEMEXTENT_MAPPING_USER_ACCESS		GENMASK_ULL(2, 0)
+#define GUNYAH_MEMEXTENT_MAPPING_KERNEL_ACCESS		GENMASK_ULL(6, 4)
+#define GUNYAH_MEMEXTENT_MAPPING_TYPE			GENMASK_ULL(23, 16)
+/* clang-format on */
+
+enum gunyah_memextent_donate_type {
+	/* clang-format off */
+	GUNYAH_MEMEXTENT_DONATE_TO_CHILD		= 0,
+	GUNYAH_MEMEXTENT_DONATE_TO_PARENT		= 1,
+	GUNYAH_MEMEXTENT_DONATE_TO_SIBLING		= 2,
+	GUNYAH_MEMEXTENT_DONATE_TO_PROTECTED		= 3,
+	GUNYAH_MEMEXTENT_DONATE_FROM_PROTECTED		= 4,
+	/* clang-format on */
+};
+
+enum gunyah_addrspace_map_flag_bits {
+	/* clang-format off */
+	GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL	= 0,
+	GUNYAH_ADDRSPACE_MAP_FLAG_PRIVATE	= 1,
+	GUNYAH_ADDRSPACE_MAP_FLAG_VMMIO		= 2,
+	GUNYAH_ADDRSPACE_MAP_FLAG_NOSYNC	= 31,
+	/* clang-format on */
+};
+
+enum gunyah_error gunyah_hypercall_addrspace_map(u64 capid, u64 extent_capid,
+						 u64 vbase, u32 extent_attrs,
+						 u32 flags, u64 offset,
+						 u64 size);
+enum gunyah_error gunyah_hypercall_addrspace_unmap(u64 capid, u64 extent_capid,
+						   u64 vbase, u32 flags,
+						   u64 offset, u64 size);
+
+/* clang-format off */
+#define GUNYAH_MEMEXTENT_OPTION_TYPE_MASK	GENMASK_ULL(7, 0)
+#define GUNYAH_MEMEXTENT_OPTION_NOSYNC		BIT(31)
+/* clang-format on */
+
+enum gunyah_error gunyah_hypercall_memextent_donate(u32 options, u64 from_capid,
+						    u64 to_capid, u64 offset,
+						    u64 size);
+
 struct gunyah_hypercall_vcpu_run_resp {
 	union {
 		enum {
-- 
2.39.5


