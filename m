Return-Path: <kvm+bounces-14508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87E038A2C79
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:36:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4329C284414
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0235732E;
	Fri, 12 Apr 2024 10:35:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E195730A
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918104; cv=none; b=UG/+zyPc0Xtt+LlNlETet5ANA0x2uG6AwPeI9l1/lIdrn+qi8GJ0YCSAhs4qJpuBXCf5am3vx6Tha+c/r5wFXk+DhKV9EGAL5yfl06yHJzQW6GPEMlSSViTknjthIMvwWMHQMidbIVRNhChqY+m5uOt+zF6otpvTDI10IOqyqFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918104; c=relaxed/simple;
	bh=4Nfj5hNAa8ixDtOo6n7yIoeEyBJXsjqRgmSmNRe+SvU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dCPMgNq1nT2UMAg2kprQgJ0WwdHEtOYIBE7Es5xvUhEW7d0sgT9rj341XQudOxV6ZEl6er8bVI2maQBx2KGDFav647Md23CnKGLHa0g/SO77V3qCpYIjjAKMy4cvZSSFnqAPp9zOqxdi38pKYh8DsiDpqRKqwFbuq24HwTU5RZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 845DD339;
	Fri, 12 Apr 2024 03:35:32 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8E2093F64C;
	Fri, 12 Apr 2024 03:35:01 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 22/33] arm: gic-v3-its: Use shared pages wherever needed
Date: Fri, 12 Apr 2024 11:33:57 +0100
Message-Id: <20240412103408.2706058-23-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GICv3-ITS is emulated by the host and thus we should allocate shared pages for
access by the host. Make sure the allocations are shared.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/gic-v3.c       | 6 ++++--
 lib/arm64/gic-v3-its.c | 6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
index 2f7870ab..813cd5a6 100644
--- a/lib/arm/gic-v3.c
+++ b/lib/arm/gic-v3.c
@@ -171,7 +171,9 @@ void gicv3_lpi_alloc_tables(void)
 	u64 prop_val;
 	int cpu;
 
-	gicv3_data.lpi_prop = alloc_pages(order);
+	assert(gicv3_redist_base());
+
+	gicv3_data.lpi_prop = alloc_pages_shared(order);
 
 	/* ID bits = 13, ie. up to 14b LPI INTID */
 	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
@@ -186,7 +188,7 @@ void gicv3_lpi_alloc_tables(void)
 
 		writeq(prop_val, ptr + GICR_PROPBASER);
 
-		gicv3_data.lpi_pend[cpu] = alloc_pages(order);
+		gicv3_data.lpi_pend[cpu] = alloc_pages_shared(order);
 		pend_val = (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
 		writeq(pend_val, ptr + GICR_PENDBASER);
 	}
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index 2c69cfda..07dbeb81 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -54,7 +54,7 @@ static void its_baser_alloc_table(struct its_baser *baser, size_t size)
 	void *reg_addr = gicv3_its_base() + GITS_BASER + baser->index * 8;
 	u64 val = readq(reg_addr);
 
-	baser->table_addr = alloc_pages(order);
+	baser->table_addr = alloc_pages_shared(order);
 
 	val |= virt_to_phys(baser->table_addr) | GITS_BASER_VALID;
 
@@ -70,7 +70,7 @@ static void its_cmd_queue_init(void)
 	unsigned long order = get_order(SZ_64K >> PAGE_SHIFT);
 	u64 cbaser;
 
-	its_data.cmd_base = alloc_pages(order);
+	its_data.cmd_base = alloc_pages_shared(order);
 
 	cbaser = virt_to_phys(its_data.cmd_base) | (SZ_64K / SZ_4K - 1) | GITS_CBASER_VALID;
 
@@ -123,7 +123,7 @@ struct its_device *its_create_device(u32 device_id, int nr_ites)
 	new->nr_ites = nr_ites;
 
 	n = (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
-	new->itt = alloc_pages(get_order(n));
+	new->itt = alloc_pages_shared(get_order(n));
 
 	its_data.nr_devices++;
 	return new;
-- 
2.34.1


