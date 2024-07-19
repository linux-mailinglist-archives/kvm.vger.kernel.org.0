Return-Path: <kvm+bounces-21946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F90937A73
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFD61B2157F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8130D146592;
	Fri, 19 Jul 2024 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cEv+zqK4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2609F14882E
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405391; cv=none; b=QUo4T1FBwr3HkwfllC6hDwoNYQIOHcwHj1/Ac28zG9ck8vrvRToYn2a27lwEr82Q7PSkSHd+ZkRdpuN6WZRxD9qE8cQ0JFQr5cUxg9Lkv2EEWvRzt6lBcq5Nk5sBa5Hz2zrRUwx93cKWY4BmybrYQvtGSk/q3ueAW/2IGijvhqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405391; c=relaxed/simple;
	bh=Pr/juHFdmJnTNfP/VZdFjm8yQzBa5nIWv27Ove8eodM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rJ/vYETIK9EHt60SHX7H86k9XR8SH79vDeQuseIlXFtMe1QHee9Y/ld6EuNjyxyj1EL27WuzxFpWyrpVjl4vJ6/KwUeyyJkzY70YhR+Pdc985X4ayiPhIJ57LYBa46SL1RWvGlyuq8pE7CiIgmileEnU+dBF0l6jsFETm26/DAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cEv+zqK4; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fc5239faebso17610715ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405389; x=1722010189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r2Ojl6CxNtzijt64bsbd3hW1xSapMUpvDVQohCtRHds=;
        b=cEv+zqK47UZ/1SjOc7x8wYwugoc8ZA8sjaPIzTP1hIgm9XQcVL+eE/5WQh6UQHgX6o
         kkFa095J3+42Jhbp7Bo32FprhYZVsHZbXCGDo87nOlx824vzs2zXpj4jyTI9kwTcafPc
         VgQYepq5V0Tb50PoiVfZ0/zp03GkW/p+siLnn2rbhfSXI7AlWrp2SPjmGua5ouCEODKJ
         QfA/3Fn41GglfTIh1hDgKAtSQqGVsmyhKkCu8XbyRl7LHvaXLYR9RkAL1tu+mhbZQ375
         2ZoCNfY5QT2RZaEE0ILVg63430Hik/BklKL6QZrhTXue5d91LKKKAm6p+pQVfjpbkFIg
         YwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405389; x=1722010189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r2Ojl6CxNtzijt64bsbd3hW1xSapMUpvDVQohCtRHds=;
        b=qiFlmzJ+dYX7WG28rkgd+tO+8+RJ9uhpLw7dWfc9JHAIGWvyrXZ/QNiKT7gdOFCI7B
         vd2bCK7RbEtxDwscL9Os1VY/00GSSE+rdBfPCpa6irtJu5N8aCtMV9VMGeY3yI84o7mB
         G1uB7XhcsA1ORgb9vQvO8qkNbXiocKV8wjRUXOXnKAhnijfebFquwrqB85Czs2BN801k
         ok3r7UJ8+/3RSVoUBxdoBSRwhzKqOiCEjO1owrdgrjLMZqLsDrQFr57pq5ZHdZ998OlX
         ICzfshBDibXoLdrAeQ4OjjWrmndGudHCbgjeJCDkYm62n+NtwVUpcDIoeMt3TGPwem37
         L2sg==
X-Forwarded-Encrypted: i=1; AJvYcCX8c9OJYFnr8bV72Adgy/OgcHw9URs3DdgYqoPaoaQlKOWuFJpxhet9Kw3F9XOIHtQwLCsk2XqD10VQV/1ccRLlw2cr
X-Gm-Message-State: AOJu0YwnTx4rW1k49zevMBauuiKod0PrE7TFaXszKRJuT8g+cTv51XVR
	FOVzCQgBVglVkpYpn2h6Jf3QBtKYSM8BBYxese0/QcaUFSHvQ6wJS+NaJjHgfBc=
X-Google-Smtp-Source: AGHT+IFJHVb5AztA8Bz3SXW38j/FW4FxxQCuUsU/Eh5eRydXFkn3S1MMglCigkpjrto6nPgWyi46Gw==
X-Received: by 2002:a17:903:22c9:b0:1fb:7b96:8467 with SMTP id d9443c01a7336-1fd7463c9d4mr3651825ad.63.1721405389316;
        Fri, 19 Jul 2024 09:09:49 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:48 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 07/13] RISC-V: Add defines for the SBI nested acceleration extension
Date: Fri, 19 Jul 2024 21:39:07 +0530
Message-Id: <20240719160913.342027-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add defines for the new SBI nested acceleration extension which was
ratified as part of the SBI v2.0 specification.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/sbi.h | 120 +++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 1079e214fe85..7c9ec953c519 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -33,6 +33,7 @@ enum sbi_ext_id {
 	SBI_EXT_PMU = 0x504D55,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
+	SBI_EXT_NACL = 0x4E41434C,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -279,6 +280,125 @@ struct sbi_sta_struct {
 
 #define SBI_SHMEM_DISABLE		-1
 
+enum sbi_ext_nacl_fid {
+	SBI_EXT_NACL_PROBE_FEATURE = 0x0,
+	SBI_EXT_NACL_SET_SHMEM = 0x1,
+	SBI_EXT_NACL_SYNC_CSR = 0x2,
+	SBI_EXT_NACL_SYNC_HFENCE = 0x3,
+	SBI_EXT_NACL_SYNC_SRET = 0x4,
+};
+
+enum sbi_ext_nacl_feature {
+	SBI_NACL_FEAT_SYNC_CSR = 0x0,
+	SBI_NACL_FEAT_SYNC_HFENCE = 0x1,
+	SBI_NACL_FEAT_SYNC_SRET = 0x2,
+	SBI_NACL_FEAT_AUTOSWAP_CSR = 0x3,
+};
+
+#define SBI_NACL_SHMEM_ADDR_SHIFT	12
+#define SBI_NACL_SHMEM_SCRATCH_OFFSET	0x0000
+#define SBI_NACL_SHMEM_SCRATCH_SIZE	0x1000
+#define SBI_NACL_SHMEM_SRET_OFFSET	0x0000
+#define SBI_NACL_SHMEM_SRET_SIZE	0x0200
+#define SBI_NACL_SHMEM_AUTOSWAP_OFFSET	(SBI_NACL_SHMEM_SRET_OFFSET + \
+					 SBI_NACL_SHMEM_SRET_SIZE)
+#define SBI_NACL_SHMEM_AUTOSWAP_SIZE	0x0080
+#define SBI_NACL_SHMEM_UNUSED_OFFSET	(SBI_NACL_SHMEM_AUTOSWAP_OFFSET + \
+					 SBI_NACL_SHMEM_AUTOSWAP_SIZE)
+#define SBI_NACL_SHMEM_UNUSED_SIZE	0x0580
+#define SBI_NACL_SHMEM_HFENCE_OFFSET	(SBI_NACL_SHMEM_UNUSED_OFFSET + \
+					 SBI_NACL_SHMEM_UNUSED_SIZE)
+#define SBI_NACL_SHMEM_HFENCE_SIZE	0x0780
+#define SBI_NACL_SHMEM_DBITMAP_OFFSET	(SBI_NACL_SHMEM_HFENCE_OFFSET + \
+					 SBI_NACL_SHMEM_HFENCE_SIZE)
+#define SBI_NACL_SHMEM_DBITMAP_SIZE	0x0080
+#define SBI_NACL_SHMEM_CSR_OFFSET	(SBI_NACL_SHMEM_DBITMAP_OFFSET + \
+					 SBI_NACL_SHMEM_DBITMAP_SIZE)
+#define SBI_NACL_SHMEM_CSR_SIZE		((__riscv_xlen / 8) * 1024)
+#define SBI_NACL_SHMEM_SIZE		(SBI_NACL_SHMEM_CSR_OFFSET + \
+					 SBI_NACL_SHMEM_CSR_SIZE)
+
+#define SBI_NACL_SHMEM_CSR_INDEX(__csr_num)	\
+		((((__csr_num) & 0xc00) >> 2) | ((__csr_num) & 0xff))
+
+#define SBI_NACL_SHMEM_HFENCE_ENTRY_SZ		((__riscv_xlen / 8) * 4)
+#define SBI_NACL_SHMEM_HFENCE_ENTRY_MAX		\
+		(SBI_NACL_SHMEM_HFENCE_SIZE /	\
+		 SBI_NACL_SHMEM_HFENCE_ENTRY_SZ)
+#define SBI_NACL_SHMEM_HFENCE_ENTRY(__num)	\
+		(SBI_NACL_SHMEM_HFENCE_OFFSET +	\
+		 (__num) * SBI_NACL_SHMEM_HFENCE_ENTRY_SZ)
+#define SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(__num)	\
+		SBI_NACL_SHMEM_HFENCE_ENTRY(__num)
+#define SBI_NACL_SHMEM_HFENCE_ENTRY_PNUM(__num)\
+		(SBI_NACL_SHMEM_HFENCE_ENTRY(__num) + (__riscv_xlen / 8))
+#define SBI_NACL_SHMEM_HFENCE_ENTRY_PCOUNT(__num)\
+		(SBI_NACL_SHMEM_HFENCE_ENTRY(__num) + \
+		 ((__riscv_xlen / 8) * 3))
+
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_BITS	1
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_SHIFT	\
+		(__riscv_xlen - SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_BITS)
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_MASK	\
+		((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_BITS) - 1)
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_PEND		\
+		(SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_MASK << \
+		 SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_SHIFT)
+
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_BITS	3
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_SHIFT \
+		(SBI_NACL_SHMEM_HFENCE_CONFIG_PEND_SHIFT - \
+		 SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_BITS)
+
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_BITS	4
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_SHIFT	\
+		(SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD1_SHIFT - \
+		 SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_BITS)
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_MASK	\
+		((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_BITS) - 1)
+
+#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA		0x0
+#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_ALL	0x1
+#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID	0x2
+#define SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID_ALL 0x3
+#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA		0x4
+#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ALL	0x5
+#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID	0x6
+#define SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID_ALL 0x7
+
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_BITS	1
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_SHIFT \
+		(SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_SHIFT - \
+		 SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_BITS)
+
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_BITS	7
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_SHIFT \
+		(SBI_NACL_SHMEM_HFENCE_CONFIG_RSVD2_SHIFT - \
+		 SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_BITS)
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_MASK	\
+		((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_BITS) - 1)
+#define SBI_NACL_SHMEM_HFENCE_ORDER_BASE	12
+
+#if __riscv_xlen == 32
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS	9
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_BITS	7
+#else
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS	16
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_BITS	14
+#endif
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_SHIFT	\
+				SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_MASK	\
+		((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_BITS) - 1)
+#define SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_MASK	\
+		((1UL << SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_BITS) - 1)
+
+#define SBI_NACL_SHMEM_AUTOSWAP_FLAG_HSTATUS	BIT(0)
+#define SBI_NACL_SHMEM_AUTOSWAP_HSTATUS		((__riscv_xlen / 8) * 1)
+
+#define SBI_NACL_SHMEM_SRET_X(__i)		((__riscv_xlen / 8) * (__i))
+#define SBI_NACL_SHMEM_SRET_X_LAST		31
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
-- 
2.34.1


