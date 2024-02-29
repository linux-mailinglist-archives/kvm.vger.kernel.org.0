Return-Path: <kvm+bounces-10463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E7EC486C4A2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F2D11F23F5A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65D45810B;
	Thu, 29 Feb 2024 09:12:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4822257894
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 09:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709197973; cv=none; b=gTitFrSHfwg+3yk/iLCZr5b+U76bVioE9SMAH11empn70MdwmXUqz5AQmKtxS1XoZha8xvZ41w42LQvjIu/9aPA+glSC+GfpZl+iy9GEyA6oSxMjL7qmsaTMOxgWqGdmTIoK6AgX4xg1rXRJ+MdopgY0d/VACXuuwRcx0TfPlQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709197973; c=relaxed/simple;
	bh=XNGqeH95Uip5LZfw5a6EZ2fwARcCDtnw01gViFoZCk8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PoC6LSg3e9P2ApmryUpbkVI//rmhx5vbz/vDH8HHFI592rehKhWeNn8cysH2ZstY/WP8Z5XvMQymx/OxYn8RULK8PrZhxC2gXMi4vnrzTM3WVJzS5yWWDQSdo7R87ccn47SieI6/P6+Y2gRW+rLDP9f/HT675L0fAzYx036k7PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4TllkW6M5jz6K6FS;
	Thu, 29 Feb 2024 17:08:19 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (unknown [7.191.163.240])
	by mail.maildlp.com (Postfix) with ESMTPS id 7B67F141017;
	Thu, 29 Feb 2024 17:12:47 +0800 (CST)
Received: from A2303104131.china.huawei.com (10.202.227.28) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 09:12:21 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<kevin.tian@intel.com>, <linuxarm@huawei.com>, <liulongfang@huawei.com>,
	<bcreeley@amd.com>
Subject: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Date: Thu, 29 Feb 2024 09:11:52 +0000
Message-ID: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)

The deferred_reset logic was added to vfio migration drivers to prevent
a circular locking dependency with respect to mm_lock and state mutex.
This is mainly because of the copy_to/from_user() functions(which takes
mm_lock) invoked under state mutex. But for HiSilicon driver, the only
place where we now hold the state mutex for copy_to_user is during the
PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
updated the data and perform copy_to_user without state mutex. By this,
we can get rid of the deferred_reset logic.

Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 48 +++++--------------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  6 +--
 2 files changed, 14 insertions(+), 40 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 4d27465c8f1a..9a3e97108ace 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -630,25 +630,11 @@ static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vde
 	}
 }
 
-/*
- * This function is called in all state_mutex unlock cases to
- * handle a 'deferred_reset' if exists.
- */
-static void
-hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+static void hisi_acc_vf_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
-again:
-	spin_lock(&hisi_acc_vdev->reset_lock);
-	if (hisi_acc_vdev->deferred_reset) {
-		hisi_acc_vdev->deferred_reset = false;
-		spin_unlock(&hisi_acc_vdev->reset_lock);
-		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
-		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
-		hisi_acc_vf_disable_fds(hisi_acc_vdev);
-		goto again;
-	}
-	mutex_unlock(&hisi_acc_vdev->state_mutex);
-	spin_unlock(&hisi_acc_vdev->reset_lock);
+	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+	hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 }
 
 static void hisi_acc_vf_start_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
@@ -804,8 +790,10 @@ static long hisi_acc_vf_precopy_ioctl(struct file *filp,
 
 	info.dirty_bytes = 0;
 	info.initial_bytes = migf->total_length - *pos;
+	mutex_unlock(&migf->lock);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
 
-	ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+	return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
 out:
 	mutex_unlock(&migf->lock);
 	mutex_unlock(&hisi_acc_vdev->state_mutex);
@@ -1071,7 +1059,7 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
 			break;
 		}
 	}
-	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
 	return res;
 }
 
@@ -1092,7 +1080,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	*curr_state = hisi_acc_vdev->mig_state;
-	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
 	return 0;
 }
 
@@ -1104,21 +1092,9 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 				VFIO_MIGRATION_STOP_COPY)
 		return;
 
-	/*
-	 * As the higher VFIO layers are holding locks across reset and using
-	 * those same locks with the mm_lock we need to prevent ABBA deadlock
-	 * with the state_mutex and mm_lock.
-	 * In case the state_mutex was taken already we defer the cleanup work
-	 * to the unlock flow of the other running context.
-	 */
-	spin_lock(&hisi_acc_vdev->reset_lock);
-	hisi_acc_vdev->deferred_reset = true;
-	if (!mutex_trylock(&hisi_acc_vdev->state_mutex)) {
-		spin_unlock(&hisi_acc_vdev->reset_lock);
-		return;
-	}
-	spin_unlock(&hisi_acc_vdev->reset_lock);
-	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
+	mutex_lock(&hisi_acc_vdev->state_mutex);
+	hisi_acc_vf_reset(hisi_acc_vdev);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
 }
 
 static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index dcabfeec6ca1..5bab46602fad 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -98,8 +98,8 @@ struct hisi_acc_vf_migration_file {
 
 struct hisi_acc_vf_core_device {
 	struct vfio_pci_core_device core_device;
-	u8 match_done:1;
-	u8 deferred_reset:1;
+	u8 match_done;
+
 	/* For migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
@@ -109,8 +109,6 @@ struct hisi_acc_vf_core_device {
 	struct hisi_qm vf_qm;
 	u32 vf_qm_state;
 	int vf_id;
-	/* For reset handler */
-	spinlock_t reset_lock;
 	struct hisi_acc_vf_migration_file *resuming_migf;
 	struct hisi_acc_vf_migration_file *saving_migf;
 };
-- 
2.34.1


