Return-Path: <kvm+bounces-57413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C15DB552A8
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9814F18908D9
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27C3212568;
	Fri, 12 Sep 2025 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="jcbKXfSE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57610306489;
	Fri, 12 Sep 2025 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757689473; cv=none; b=d1xW6L2VEYtnVjjf+k4BKMT8ECrLV1gRkH+1WslpOpib0+5rqrgfhwaKOIiESjI17IR5MsPPkYFY3gRGK+3Pb/1AbcJJaIwj/HkTTfwRY6UZrnIaz9EV6/X4/RpK0xswnujB83sp/a88KA9Le3VR/TsPBPVVL8uXFdZl7Nlf/d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757689473; c=relaxed/simple;
	bh=XGL64NNi6TaH/AkBDUnkiTBSXhwNdkQxWPbDvlaZBk0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jhZMOGSmojcqVYBlSTHCDKN87ZfQLVe9D/NnSJHlk3BKZtvHs7Glw7Z2YmRRxUXgupRXov6Iue9jBtHOlU4CNi1T20Cqigb+aiLV4fbIjQ/jSqxEVpU2WJSzTY8XdQoIEO1vViVIQjukA24FWV1StUOZkEPUi3oha2hzuHtgYTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=jcbKXfSE; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Received: from LAPTOP-N070L597.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 22a119306;
	Fri, 12 Sep 2025 23:04:21 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: brett.creeley@amd.com
Cc: jgg@ziepe.ca,
	yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com,
	alex.williamson@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] vfio/pds: replace bitmap_free with vfree
Date: Fri, 12 Sep 2025 15:04:18 +0000
Message-Id: <20250912150418.129306-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a993e74b98303a1kunm5608525b2a1f75
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHh5PVk4eGEwdT0pCTUhOS1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZS1VLVUtVS1kG
DKIM-Signature: a=rsa-sha256;
	b=jcbKXfSEuUg7t9cXzTaOcQsVCKh6+Xjvlt77+XXn3dmREjSSVNBZ9NW0druG64vw9MyjzvbV9A9p8S9Bc+TC6UTrB30yhAnZtqddzkixZCqPqnRa3Gw6ob1c65eC4BVWqZ1o3cBkPkwXjyK/WwbokxwapzJP2WwomF6iA3o4eGI=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=07KwbvMf5FzS48nluqd6fO5k3J0q2pzbe1zWajGuFmQ=;
	h=date:mime-version:subject:message-id:from;

host_ack_bmp is allocated with vzalloc but is currently freed via
bitmap_free (which ends up using kfree).  This is incorrect as
allocation and deallocation functions should be paired.

Using mismatched alloc/free may lead to undefined behavior, memory leaks,
or system instability.

This patch fixes the mismatch by freeing host_ack_bmp with vfree to
match the vzalloc allocation.

Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
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


