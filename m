Return-Path: <kvm+bounces-51197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC8EAEFCC9
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3567E3BA6BC
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B20C277035;
	Tue,  1 Jul 2025 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="LessPWv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1743C47B;
	Tue,  1 Jul 2025 14:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751380841; cv=none; b=il65cbEGJfqeP10ZlEUBEZRKp5lcCxWghwHFnY2B0GJbag+gQc3j4JhE9RpzP+QqTjYkgcH458R2vKO66C+WElxa9T7am7F7hx/DRcmVsSDr0dCHlST84RXqLUxySmteZp7pw5FZ3ScDBHyrQG62gfMu+LP3eAzceluXQ3mTKOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751380841; c=relaxed/simple;
	bh=Z6lfxGszJ1cLakxoBE88AW/HR4tCyAyO2rK/twgLHek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pHad3POrhXvSDtK463fYnRD/I+s0SUhMqcXFAkhtZjG1veJbG8m4xpQrvyMY64ebsxqNE9BElEvfLqJmAV4wOsjQA09m1O5dKroMbMNYTyTwalhwTXFK2J2lJldLQwddK1RwO5fTmVFWv39GsrCbnl63crxX7bf0jx7bV6SBwBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=LessPWv8; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost.localdomain (unknown [178.69.224.101])
	by mail.ispras.ru (Postfix) with ESMTPSA id ABDB54076740;
	Tue,  1 Jul 2025 14:40:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru ABDB54076740
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1751380833;
	bh=s5hNOu3pWE1B3tS5Rh/Lw6+sDyvuIKAP21abiNNJa4A=;
	h=From:To:Cc:Subject:Date:From;
	b=LessPWv8CTzmAP1udvVER9uBvXTtLW68A7pm899vaRHlKyZCeb+BEk3847fuuUDGc
	 4B/4KHX72uGN5OwTxPdr1DHjnEYtl4OgN2uSTQgwkcAXUHGq7i5rmgbM3radzw6ghu
	 iQLgrOptPbSkXGZy0Lr9ZiwFtqQHwoC1y1GPIRJ4=
From: Artem Sadovnikov <a.sadovnikov@ispras.ru>
To: kvm@vger.kernel.org
Cc: Artem Sadovnikov <a.sadovnikov@ispras.ru>,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH v2] vfio/mlx5: fix possible overflow in tracking max message size
Date: Tue,  1 Jul 2025 14:40:17 +0000
Message-ID: <20250701144017.2410-2-a.sadovnikov@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
used as power of 2 for max_msg_size. This can lead to multiplication
overflow between max_msg_size (u32) and integer constant, and afterwards
incorrect value is being written to rq_size.

Fix this issue by extending integer constant to u64 type.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
---
Changes from v1:
- The constant type was changed instead of variable type.
- The patch name was accidentally cut and is now fixed.
- LKML: https://lore.kernel.org/all/20250629095843.13349-1-a.sadovnikov@ispras.ru/
---
 drivers/vfio/pci/mlx5/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5b919a0b2524..a92b095b90f6 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1523,8 +1523,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
 	max_msg_size = (1ULL << log_max_msg_size);
 	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
-	if (rq_size < 4 * max_msg_size)
-		rq_size = 4 * max_msg_size;
+	if (rq_size < 4ULL * max_msg_size)
+		rq_size = 4ULL * max_msg_size;
 
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
-- 
2.43.0


