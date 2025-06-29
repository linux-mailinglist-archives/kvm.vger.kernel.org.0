Return-Path: <kvm+bounces-51047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B631CAECC0A
	for <lists+kvm@lfdr.de>; Sun, 29 Jun 2025 11:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 356C73B7808
	for <lists+kvm@lfdr.de>; Sun, 29 Jun 2025 09:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627642192EE;
	Sun, 29 Jun 2025 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="Jxd7fEU8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF21CA84;
	Sun, 29 Jun 2025 09:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751191138; cv=none; b=Jn6bbqnVREi6P4MmXR7vBvmb/jyTDXFoY+yPk9kdZEHg5njQ9RJG3LZIB7IsCC5oBlI2ym0VbcpoT/MkbMC9upC3TagoEotGlxtG0UKcu6kTzCsLBciG0i9quFJ05+TIeRoOX14btvY60tMajlNqKFNWiADHck55Uec1DDidDsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751191138; c=relaxed/simple;
	bh=Hrliv2JoxVWlcymdZiOGwuH3Ex9wLHlVPK+l3T68CRs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TrGmngYeN3FC410l333sRC9+0Qzhehjde8VxsH0naZVAJinyP13M/RkCve+voRg6Qmi0i6QqeVyz7JQU4gH6mnhlaX8Gtdul5GHMWk0SEy/SKFyS74koGvLcSyQqSOjoQQexeKQQf9PTE+H6jxPeN/91KaHGD0+UEp3LN0FaivQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=Jxd7fEU8; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost.localdomain (unknown [178.69.224.101])
	by mail.ispras.ru (Postfix) with ESMTPSA id 29345552F52C;
	Sun, 29 Jun 2025 09:58:45 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 29345552F52C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1751191125;
	bh=4Wj/utsZiTg4gXT3s/0BCZb3A7rSjIgTPBKJ1fLaEF8=;
	h=From:To:Cc:Subject:Date:From;
	b=Jxd7fEU8OMgfM24/d92RvB8OT/rmUP/Ah9DbQf8/2s8GkoPOs+UIEM8QSkxnMXcsb
	 P689vNzP1lVaI55hYu4LjjljiThBLc08+C31zE/Aig1KcIRF4t7cayezBq0XQtXcGP
	 JYNIWNzEMib0TfLcrKmAKtZIfeHd21jEGeVA6wmY=
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
Subject: [PATCH] vfio/mlx5: fix possible overflow in tracking max
Date: Sun, 29 Jun 2025 09:58:43 +0000
Message-ID: <20250629095843.13349-1-a.sadovnikov@ispras.ru>
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

Fix this issue by extending max_msg_size up to u64 so multiplication will
be extended to u64.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
---
 drivers/vfio/pci/mlx5/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5b919a0b2524..0bdaf1d23a78 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1503,7 +1503,7 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_core_dev *mdev;
 	u32 log_max_msg_size;
-	u32 max_msg_size;
+	u64 max_msg_size;
 	u64 rq_size = SZ_2M;
 	u32 max_recv_wr;
 	int err;
-- 
2.43.0


