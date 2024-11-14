Return-Path: <kvm+bounces-31862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E369C8F93
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 17:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6BFB1F2148C
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 16:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3ACB19259E;
	Thu, 14 Nov 2024 16:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cX1cxQMB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B78F18CC02
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 16:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731601138; cv=none; b=PxrAy801PMrTtANSIHrZgDYZ4cXuHfaK8mVjGWzAny/ZjilQdUOj+zoQNPzD46E8JIaMii7VzQV5vQov5Cmh12jMTbcfgcYkUWCikKE3RPvs3r2kxGjLrfDer+2lq8oVsB9LCXePXTS39+2ND/R/2IkoiaNbDcHJt54My37eqkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731601138; c=relaxed/simple;
	bh=mSKDSl3GLSiOekZPsY51mXQ0nJSnVkEWku0uYPCWFJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stXE6GQQZKsklgXyojQ1ZGtzrgEVACNq0W/fdgFwrSbICjWKeoztx7GK+xrt0mO6fza2rsKgaHgc/KCdD9Ck6Jaw9X9W7urwyzbMXVzOjMFODQWFPrsEAJ5jsqV+neIOZT1Qym+zG5gCORYvaV4TuTfT8OnXVHg4n67trjjZLow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cX1cxQMB; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-431695fa98bso6928705e9.3
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 08:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1731601135; x=1732205935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yp1usq1fK4gxtiGD08iHEFdZ4WeofRrQEoktS1P9VL0=;
        b=cX1cxQMBXTX7F9Pk1bIKY5KFFO+cqFpldRJ0lomT6vn9gErKBKfgcwR37xmzgzv4Ac
         ft9msctJoHzZ5ZwBTJyCQMGfTVJl392hQV2DlkNW8ZYNNJ+sPSTDfWSd0MvOZBAthhIf
         r614Az7ZO4s4f/5kcswtsFhEWcZ3bLKaVGu2YUC/6eWZJk4y5D8IMrr2/Isg4KrJvObz
         CMIcQgCnbb2Oriws2LLjcqiuFLlWEaLn/OzvcN7fvoMT/BLkYEKRLd++eiZBnAqM4/u8
         bBummUMtP2lIeR8rjhE4srp+WPd+7oGnW31Mg0CkuZ9UuE8XUtbdv+Zjx5FxiN4wpv+K
         OphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731601135; x=1732205935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yp1usq1fK4gxtiGD08iHEFdZ4WeofRrQEoktS1P9VL0=;
        b=xJwTj/nukJ4uFOLda6ITJcxQJPV8HvbOuOthu/AwJnhdMvSDqFjpe8K2nNk4qO/RIA
         kuG7XmzvGc7SWKRI+AJrp1mikTL1lVgcDOA3viGf8MjfkmsPs0VtlkejKF8ZLBJZyRhF
         ogG0GMbRstZwyCqDWtHLrubYzYnu9vL5mgWnRR7dMcuXBvlqSoLRDvayxf7KfjUwmU8b
         tIWCSKBMe7OqCTtGBXLbjvp4yxWPTbCoHhqlgpC2OQeUnt8iJ7xg6Gn4luFnl1ih+lKH
         sK7el465eU+l++ft1E/sqItzOaZcH+BmHpeHEFSFC/cONuR0HSKXt884JLpj1t/thzb6
         X6PQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5yxyjjsj60mBtPcnXBxZKyrLh8GxEKndUwrjnZQl7AhgiTo9YSKVsct+0YQLkx5pTy4s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjS9Oro5x/OKLBO7tKCK1YWn+rriZaNYD3E24zumFSOgLOszfw
	j9cFC13ccRqsDRUTUDD1fwL4yaZ7zGoSkB/A7KwBG0lY5e+LZ7IFC4w4Efg+0tM=
X-Google-Smtp-Source: AGHT+IFyYvgOotPy1xBLjJZdRQpK5gbKBNQ63i5f7cylok3AbHGEDqsRn2z3h347XR748S8k1vlXxg==
X-Received: by 2002:a05:600c:3ca4:b0:42c:a6da:a149 with SMTP id 5b1f17b1804b1-432b751839dmr220940445e9.25.1731601135291;
        Thu, 14 Nov 2024 08:18:55 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27fc8esm29713515e9.21.2024.11.14.08.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 08:18:54 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: iommu@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: tjeznach@rivosinc.com,
	zong.li@sifive.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	tglx@linutronix.de,
	alex.williamson@redhat.com,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [RFC PATCH 06/15] iommu/riscv: support GSCID and GVMA invalidation command
Date: Thu, 14 Nov 2024 17:18:51 +0100
Message-ID: <20241114161845.502027-23-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241114161845.502027-17-ajones@ventanamicro.com>
References: <20241114161845.502027-17-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zong Li <zong.li@sifive.com>

This patch adds a ID Allocator for GSCID and a wrap for setting up
GSCID in IOTLB invalidation command.

Set up iohgatp to enable second stage table and flush stage-2 table if
the GSCID is set.

The GSCID of domain should be freed when release domain. GSCID will be
allocated for parent domain in nested IOMMU process.

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 drivers/iommu/riscv/iommu-bits.h |  7 +++++++
 drivers/iommu/riscv/iommu.c      | 32 ++++++++++++++++++++++++++------
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index 98daf0e1a306..d72b982cf9bf 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -715,6 +715,13 @@ static inline void riscv_iommu_cmd_inval_vma(struct riscv_iommu_command *cmd)
 	cmd->dword1 = 0;
 }
 
+static inline void riscv_iommu_cmd_inval_gvma(struct riscv_iommu_command *cmd)
+{
+	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CMD_IOTINVAL_OPCODE) |
+		      FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IOTINVAL_FUNC_GVMA);
+	cmd->dword1 = 0;
+}
+
 static inline void riscv_iommu_cmd_inval_set_addr(struct riscv_iommu_command *cmd,
 						  u64 addr)
 {
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 9d7945dc3c24..ef38a1bb3eca 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -45,6 +45,10 @@
 static DEFINE_IDA(riscv_iommu_pscids);
 #define RISCV_IOMMU_MAX_PSCID		(BIT(20) - 1)
 
+/* IOMMU GSCID allocation namespace. */
+static DEFINE_IDA(riscv_iommu_gscids);
+#define RISCV_IOMMU_MAX_GSCID		(BIT(16) - 1)
+
 /* Device resource-managed allocations */
 struct riscv_iommu_devres {
 	void *addr;
@@ -801,6 +805,7 @@ struct riscv_iommu_domain {
 	struct list_head bonds;
 	spinlock_t lock;		/* protect bonds list updates. */
 	int pscid;
+	int gscid;
 	bool amo_enabled;
 	int numa_node;
 	unsigned int pgd_mode;
@@ -954,15 +959,20 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 
 		/*
 		 * IOTLB invalidation request can be safely omitted if already sent
-		 * to the IOMMU for the same PSCID, and with domain->bonds list
+		 * to the IOMMU for the same PSCID/GSCID, and with domain->bonds list
 		 * arranged based on the device's IOMMU, it's sufficient to check
 		 * last device the invalidation was sent to.
 		 */
 		if (iommu == prev)
 			continue;
 
-		riscv_iommu_cmd_inval_vma(&cmd);
-		riscv_iommu_cmd_inval_set_pscid(&cmd, domain->pscid);
+		if (domain->gscid) {
+			riscv_iommu_cmd_inval_gvma(&cmd);
+			riscv_iommu_cmd_inval_set_gscid(&cmd, domain->gscid);
+		} else {
+			riscv_iommu_cmd_inval_vma(&cmd);
+			riscv_iommu_cmd_inval_set_pscid(&cmd, domain->pscid);
+		}
 		if (len && len < RISCV_IOMMU_IOTLB_INVAL_LIMIT) {
 			for (iova = start; iova < end; iova += PAGE_SIZE) {
 				riscv_iommu_cmd_inval_set_addr(&cmd, iova);
@@ -1039,6 +1049,7 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
 
 		WRITE_ONCE(dc->fsc, new_dc->fsc);
 		WRITE_ONCE(dc->ta, new_dc->ta & RISCV_IOMMU_PC_TA_PSCID);
+		WRITE_ONCE(dc->iohgatp, new_dc->iohgatp);
 		/* Update device context, write TC.V as the last step. */
 		dma_wmb();
 		WRITE_ONCE(dc->tc, tc);
@@ -1287,8 +1298,10 @@ static void riscv_iommu_free_paging_domain(struct iommu_domain *iommu_domain)
 
 	WARN_ON(!list_empty(&domain->bonds));
 
-	if ((int)domain->pscid > 0)
+	if (domain->pscid > 0)
 		ida_free(&riscv_iommu_pscids, domain->pscid);
+	if (domain->gscid > 0)
+		ida_free(&riscv_iommu_gscids, domain->gscid);
 
 	riscv_iommu_pte_free(domain, _io_pte_entry(pfn, _PAGE_TABLE), NULL);
 	kfree(domain);
@@ -1320,8 +1333,15 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
 	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
 		return -ENODEV;
 
-	dc.fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
-		 FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
+	if (domain->gscid) {
+		dc.iohgatp = FIELD_PREP(RISCV_IOMMU_DC_IOHGATP_MODE, domain->pgd_mode) |
+			     FIELD_PREP(RISCV_IOMMU_DC_IOHGATP_GSCID, domain->gscid) |
+			     FIELD_PREP(RISCV_IOMMU_DC_IOHGATP_PPN, virt_to_pfn(domain->pgd_root));
+	} else {
+		dc.fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
+			 FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
+	}
+
 	dc.ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
 			   RISCV_IOMMU_PC_TA_V;
 
-- 
2.47.0


