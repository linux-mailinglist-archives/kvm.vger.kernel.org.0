Return-Path: <kvm+bounces-54363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E63BCB1FF00
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 08:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D4701897B1F
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 06:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0E329994B;
	Mon, 11 Aug 2025 06:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="EGRzsG7f"
X-Original-To: kvm@vger.kernel.org
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952BB21A92F;
	Mon, 11 Aug 2025 06:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754892678; cv=none; b=OlMywI5WTn12fqtn6+Gun17d3kMus7ZgU8ZIPnqtAksY5///9XoGSaC9aQd2rEAOyzGMTsIXF9YqPiYlbP7DLXWdexYwYQXYLn4IDi+d5FJyeEYYsDpE+zH02EZ8cTj50x+A6rcxjWUycOQGnLSt2qRgOGCLbkxFzlFxC5APL24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754892678; c=relaxed/simple;
	bh=wvqy4UJ6IUTFndqB+XoDiJyOKD1YlqbUlQRCilku3zU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m7xYPD8f/KewjLm9yfq2gl/N5X9n7WWiay/OZ4/ea4KPQxRk0LjFLMcMNQGGJkunWFzRM13xf0TuYbltGB5Myq6vJ3ZkK9OQC1pMPxh0+P4ZgQJvcv4x2k4OWMZdsojMTv2KFtV/rhGSPpDOdjOvZS5iMQzACaA67tYtDUf7d+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=EGRzsG7f; arc=none smtp.client-ip=115.124.30.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1754892673; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=DZN23X/8T7TOOtz+3clkVBeibPzLGB2AE7hvZ+c8lTI=;
	b=EGRzsG7foeIaWEDoJ3yy88g2Igmr+oiYKli+1AI6pQoi8NHmUNzmfF4PklComf+JsxtxEB/F4hnY4DfayApGoF3lgpSmn6fLDezYD5bzR4XzPT8+WwLy9+YuDfZ14M5lkvE8hsWYq300Pr6o+Rx9pYEZShwcTO8UTJoMspM1Pqc=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WlP-v89_1754892670 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 11 Aug 2025 14:11:11 +0800
From: fangyu.yu@linux.alibaba.com
To: anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	atishp@atishpatra.org,
	tjeznach@rivosinc.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	sunilvl@ventanamicro.com,
	rafael.j.wysocki@intel.com,
	tglx@linutronix.de,
	ajones@ventanamicro.com
Cc: guoren@linux.alibaba.com,
	guoren@kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [RFC PATCH 1/6] RISC-V: Add more elements to irqbypass vcpu_info
Date: Mon, 11 Aug 2025 14:10:59 +0800
Message-Id: <20250811061104.10326-2-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
References: <20250811061104.10326-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

To support MRIF mode, we need to add more elements to
let the iommu driver get the ppn of MRIF.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/include/asm/irq.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/include/asm/irq.h b/arch/riscv/include/asm/irq.h
index 8588667cbb5f..6293ac00e051 100644
--- a/arch/riscv/include/asm/irq.h
+++ b/arch/riscv/include/asm/irq.h
@@ -30,6 +30,9 @@ struct riscv_iommu_vcpu_info {
 	u32 group_index_shift;
 	u64 gpa;
 	u64 hpa;
+	u32 host_irq;
+	bool mrif;
+	struct msi_msg *host_msg;
 };
 
 #ifdef CONFIG_ACPI
-- 
2.49.0


