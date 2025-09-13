Return-Path: <kvm+bounces-57497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB14B561D2
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 17:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA8F11B25999
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 15:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235CA2F28F2;
	Sat, 13 Sep 2025 15:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="iGdsm5Ua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D9119E98C;
	Sat, 13 Sep 2025 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757777532; cv=none; b=Jp3yxbLJ8QPDap8OGQkMciK3s/yu/byNod9uz5hlj6KWmRbYXVkNjFuOmPxyae874PstMw4uHBLKgn814lCKkrD8I0NEaLaPCIyzrAEv6rtFtWS7DV1s1U0hE6v+xfgCiqZggUd4IBSzs5sqxgF+FLgQnM8Q5zbM4gqDHl6JFBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757777532; c=relaxed/simple;
	bh=TBfdcMiQonrtQcFEM0J7fs7KepDjCbzU2TgkLxqV1/M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IGfvL0yePBbNd20izug2DuP95JXmi51GK7OsOuWoIDojyT5Tw5OtrHYt6cpAoxvCKY5mpdI3wKhtV9JZGqsOmUKYC8VezHPvGhD+NZNbc7FLWff7tlz1jzAJyXE+AP1h0yWwTPkAkSubejvXONYMsyaSPvm7ZE5dAQ0Kku0Xe0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=iGdsm5Ua; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 22b0da691;
	Sat, 13 Sep 2025 23:31:57 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: jgg@ziepe.ca
Cc: yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	brett.creeley@amd.com,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH V2] vfio/pds: replace bitmap_free with vfree
Date: Sat, 13 Sep 2025 15:31:54 +0000
Message-Id: <20250913153154.1028835-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9943b45b3003a1kunm3b7c7b9d32b33a
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSENDVklLTkNJSUNOSExNH1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=iGdsm5Ua9G4VMuJua4zcPaC0tLCCofe2qMtwmSkXSc01VgtU9wsTU4UEOzr07BbA55cWVcGGyuTUugS2KnGiPmyBe3yb1VSAlO+RvD5KkGqaJOdOVzqEJAO6g7RSS9lkMv4pUfJaRAI1nidKm7xZTU70RaOtv7mOy4Uv7MnoKqg=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=r5mWJk/Ysllkg7QlCphqR+IJ9ALHc3igH8VzjEuhodU=;
	h=date:mime-version:subject:message-id:from;

host_seq_bmp is allocated with vzalloc but is currently freed with
bitmap_free, which uses kfree internally. This mismach prevents the
resource from being released properly and may result in memory leaks
or other issues.

Fix this by freeing host_seq_bmp with vfree to match the vzalloc
allocation.

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---

Changes in v2:
- Fix the incorrect description in the commit log.
- Add "Fixes" tag accordingly.

 drivers/vfio/pci/pds/dirty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index c51f5e4c3dd6..481992142f79 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -82,7 +82,7 @@ static int pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_region *region,
 
 	host_ack_bmp = vzalloc(bytes);
 	if (!host_ack_bmp) {
-		bitmap_free(host_seq_bmp);
+		vfree(host_seq_bmp);
 		return -ENOMEM;
 	}
 
-- 
2.34.1


