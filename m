Return-Path: <kvm+bounces-66691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E7ECDDDC5
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 15:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4BF1301EFB4
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 14:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE57D248F7C;
	Thu, 25 Dec 2025 14:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="cgXmgCk9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5CB1684B4;
	Thu, 25 Dec 2025 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766673129; cv=none; b=MuGu4xcLgVimh+v4O5xnqtkqggDWNbC+dwkPlI4WNL+lFYIuF1QT6C3aLl89HzmPwfBEp3CyWVJcw5NU2H6+18RI8JjDIumhXAEaBzGG5NFykWyLoA+S3rEpAnqLyG0NrDHBH5rf2Wpr7zQD+qiqpjqiyNbwniax2dwgRAotKRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766673129; c=relaxed/simple;
	bh=gP2JcycdLSBY+BoKEzv/oBxHnxcGgKEkskGCVtpp1Hc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YL5X5JdSZlkBe66a3IoeUfYtTYiVSKRf4jfe0mxUyq9yPb0Gwzks+f3mv1EPPwynWfKhKa9HyT5l4X1z89GdfIp9ZiqUuIiMnz1CTdajI1w04UZyIOCQSxLgRV7mTIOXyAjNG9U/IAAiqQONuOgU/TbbOr0i9DJ1BBFU5Boo5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=cgXmgCk9; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2e90b931f;
	Thu, 25 Dec 2025 22:31:54 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: jgg@ziepe.ca
Cc: yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	brett.creeley@amd.com,
	alex@shazbot.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] vfio/pds: Fix memory leak in pds_vfio_dirty_enable()
Date: Thu, 25 Dec 2025 14:31:50 +0000
Message-Id: <20251225143150.1117366-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b55ec66ce03a1kunm8556cb3653a3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZQkpKVktITEJCTUhOQkpCSFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=cgXmgCk9TulyTSod9BsbcL7nLj2Ld7/GQ4odstXU3KHgjnp/7tEWEfrB7yuotEqmuzyuHUWG5G5EeWVSl8ygWnRqntxNsZPab8/4fsuaM4F1/jubqnH491CwQDYTqqpFY6G+nD2gpHlK6em8Nbn4GRYTH84fPSIuIRR/HiBgQSw=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=FRpWnB3JXKOe8+EG9U0c29yXRNuZlvgoBQogwEH901U=;
	h=date:mime-version:subject:message-id:from;

pds_vfio_dirty_enable() allocates memory for region_info. If
interval_tree_iter_first() returns NULL, the function returns -EINVAL
immediately without freeing the allocated memory, causing a memory leak.

Fix this by jumping to the out_free_region_info label to ensure
region_info is freed.

Fixes: 2e7c6feb4ef52 ("vfio/pds: Add multi-region support")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/vfio/pci/pds/dirty.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 481992142f79..4915a7c1c491 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -292,8 +292,11 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 	len = num_ranges * sizeof(*region_info);
 
 	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
-	if (!node)
-		return -EINVAL;
+	if (!node) {
+		err = -EINVAL;
+		goto out_free_region_info;
+	}
+
 	for (int i = 0; i < num_ranges; i++) {
 		struct pds_lm_dirty_region_info *ri = &region_info[i];
 		u64 region_size = node->last - node->start + 1;
-- 
2.34.1


