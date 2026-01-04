Return-Path: <kvm+bounces-66981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E625CF0B11
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 08:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E09FF3014135
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 07:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21B82E9EAE;
	Sun,  4 Jan 2026 07:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="V46jC0tb"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84262E3387;
	Sun,  4 Jan 2026 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767510525; cv=none; b=P4YSQ1dDNCOjn/qruwbjXakVK71kQ2RSx2wUVWO0Yr78ITGcP13yHbLnfgfE+ygTuOJEsAsF2kgFMbpSRE4L1R8CO0+i/b2eD46y926zQKaRCMoPhCWn/SlMbWf2TPhiaNnGl0Dg7EDcmuHsXGn/DPOluMlfOyXb2uCi12Rswxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767510525; c=relaxed/simple;
	bh=JoxFw5TFuh4buXBOcI2mMUGwcOmU9+r4ndtF1cb07l8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lpjl8dHUSneIKVB/upczdjPSeChwzzzXDRkiqXhL5mK9YUtezjSwz9jPPAXRCzWma1Gmp8+D0QGJAsTCCAiUMzidGR6CrC3w4d8yVIINIIF70puPX9nVi7tnOPekP5Phgy0LlBDCe5bOh3j/xHYMWFuvbw/Q09OlYd9ncVfpIEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=V46jC0tb; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mJA4sbXf/bjLcZSjxOe5Xvex+B0nnqAwSKeicW7m7vo=;
	b=V46jC0tbhsONdmCSB+Bth2ZlmJdDpNyR8ELRXv4X3UgqtBcO+rLks1JUtoyXmNMx1mmpRrkbn
	kNIQHOrFjC9JwLSjTMvAhRl7s2GnAzEpx8UkQaM6F1hqIeJ0tHpWRQ2w7bKmNk6s6cpL6jXHJxT
	KE1lyDjVYKi/pixN+qHRTGk=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dkT3C3Mb7zRhs9;
	Sun,  4 Jan 2026 15:05:27 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 4BDDA40569;
	Sun,  4 Jan 2026 15:08:41 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sun, 4 Jan
 2026 15:08:40 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 3/4] hisi_acc_vfio_pci: resolve duplicate migration states
Date: Sun, 4 Jan 2026 15:07:05 +0800
Message-ID: <20260104070706.4107994-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260104070706.4107994-1-liulongfang@huawei.com>
References: <20260104070706.4107994-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

In special scenarios involving duplicate migrations, after the
first migration is completed, if the original VF device is used
again and then migrated to another destination, the state indicating
data migration completion for the VF device is not reset.
This results in the second migration to the destination being skipped
without performing data migration.
After the modification, it ensures that a complete data migration
is performed after the subsequent migration.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index e782c2274871..394f1952a7ed 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1583,6 +1583,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 		}
 		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
 		hisi_acc_vdev->dev_opened = true;
+		hisi_acc_vdev->match_done = 0;
 		mutex_unlock(&hisi_acc_vdev->open_mutex);
 	}
 
-- 
2.24.0


