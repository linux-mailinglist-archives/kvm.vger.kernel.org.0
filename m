Return-Path: <kvm+bounces-29217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A699B9A567D
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38DF828295D
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A5719ABA3;
	Sun, 20 Oct 2024 19:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="HDg2Lkjc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D37199FA0
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453680; cv=none; b=qeGfL+7uB+xkvqxF4bSB2y4wchYy+urp2tCLUl7utH59MpS6b7BJk1/vL5qjw4YykjNUPZkIrUkZ1SHXtVwAGKL3twKQ8FdHq634F9a7z3ygKI0/GCMrmpRzEkBOhPsys45aLilD3L84DHZ4b3ZuEW/8+4zVuUgmWAODi7ALAzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453680; c=relaxed/simple;
	bh=T7tELBxGh11eBMeGnumK1jZo8RzYWiaMFUM5/ysdGAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qto39ki3Pos0G9DkeKPZA5f8vEQAC8+skD+PhofjLwLWShKBiWUQfIdESIlB2UKy4tobaAX/z95j7EzrHpjB3N2twTgaIiQa33UfsbVdiFBOP/pxC2eIkA6HfXtzgyW8/WuBMcOop70CpKJvB9bP7mVgsTPaHWmYQsQLOx3zd9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=HDg2Lkjc; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e30116efc9so3126650a91.2
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453678; x=1730058478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KS7Zu5aP5OUy3H1PVCUGTrOwGn7CBou3wja5LgjZ/J0=;
        b=HDg2Lkjcy3LPRlU4llUeZML7Gg53MVKBPt609ChaOnbjMeCZhwdyMTZir7IoDDNoiG
         AxVlLAQ71bI1FprfIRua1MkhU8Ta3lyHF7bEevUmmQP3G+h3VbYpCahQgi+X0kq9796X
         HFAkQ0WsBXQtqIh2TGSOMDiEUF3edQaSmAVMnA1qtabgpyF/WuQmMiIEFSt0PHtYt+8G
         s7I5Fzl1Y0gcL8SQBhgzZcNzW3/pUc78TqROcD5mT1ZkohpZWO7Drg3JkMRkAmncGKY4
         s4ut793bxGVeRlI8K1rUP2IrqSe2YjQkma7RLLh1B+LTOLgYUE47mYdIMavjWn1HMl/8
         mrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453678; x=1730058478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KS7Zu5aP5OUy3H1PVCUGTrOwGn7CBou3wja5LgjZ/J0=;
        b=KeKWRD0tKGHL3DpV3tHc0FAYs3Z9g6Rxa9oFCOo7pPF2SFPfavhhVnjEs7pLzeBAUF
         thnYmZsOdf0ql16LHchruFK+gOzqyR02mfNyPhnFW7HzQ2aP2XmRUZRtKde8dsErav3E
         cL3UTCbPWqIneP5YtdfDUvSzSmZ1kh3LDMY43BesUELwlSVPwpfbI722kl5w/3btDpRF
         v3Vr/8j28s9YuCVTWtfXuGadUPfU3G0p96kO1IP4BGXzyfaPzhHNFl46dh4GkBzbRUKg
         AzItdEC8LDtS36sD8wNbFF71VSxuIv7oQwptbCPRVQ6n4sTAdAn+czxQCSiVDU2Qdipd
         16/w==
X-Forwarded-Encrypted: i=1; AJvYcCWbpHcvV2iNq1OA863gd5g3J2AiKAhj22Hn1O4MQ1eSZw2t5bFabVRLWz1MgbvuDf32N9U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg7hYQ7ICcv8IUi2dI/GuRgRFyQ6KO+IIXbHW/Hj3rxVq6oIJm
	VF9M/dZqnIei2Gc+WcfLsAQqtRcAMAIRYDIv7pVrv7C33qQZxj7+09F8gjAMsZhbCm/X/+CWFJC
	c/AiZHQ==
X-Google-Smtp-Source: AGHT+IGnS7/U9pCy/yFTaLxnb90oRcnjeE7u+Mb775msHzTrrMgFD70FOBbx5TY/apdqG3+0xp0q3g==
X-Received: by 2002:a17:90a:f002:b0:2e2:cd22:b092 with SMTP id 98e67ed59e1d1-2e5617572e6mr11026433a91.16.1729453677600;
        Sun, 20 Oct 2024 12:47:57 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:47:56 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 07/13] RISC-V: Add defines for the SBI nested acceleration extension
Date: Mon, 21 Oct 2024 01:17:28 +0530
Message-ID: <20241020194734.58686-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241020194734.58686-1-apatel@ventanamicro.com>
References: <20241020194734.58686-1-apatel@ventanamicro.com>
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
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 120 +++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 98f631b051db..6c82318065cf 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -34,6 +34,7 @@ enum sbi_ext_id {
 	SBI_EXT_PMU = 0x504D55,
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
+	SBI_EXT_NACL = 0x4E41434C,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -281,6 +282,125 @@ struct sbi_sta_struct {
 
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
2.43.0


