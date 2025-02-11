Return-Path: <kvm+bounces-37840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7241DA30AB3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:47:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22164166B9C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 11:47:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F011FE46E;
	Tue, 11 Feb 2025 11:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.com header.i=@yandex-team.com header.b="doARputU"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423911FBE8D;
	Tue, 11 Feb 2025 11:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739274437; cv=none; b=gOBo8Spe94AzjDt5LxXm3x2RCSGpTGqRDbMvKT8HmI3voh6qXXZ9jRNyvM/gSqdbDyslm0aUkoRC7HKE5RSXJmDDvOuykrTe4yAn9zqjcVLiBEA8+BDYX6vGv86S653buten466qKII5M0+LrvcJq3zIDPqRS7pMF/K7uMQszSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739274437; c=relaxed/simple;
	bh=SROuA7Ts6Pt/QgjFlVQnZ/dl8jmv1HSWGopcH/p/NDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH61+bVUM33HM8Nf4P7+BSvu6fP4+98r0eh9R5jPREda2GPL3gpo3zwF+6o4ONZgnzOWAql1zwgnI9Y6KATTKvGZ/R1xv/sM5617zzski8cyt5Gxuv6SGWRLkGylx2Yp2livI0VjV7kYAgfMfVgb/09g1Od6TTFXpn6joaTgV7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.com; spf=pass smtp.mailfrom=yandex-team.com; dkim=pass (1024-bit key) header.d=yandex-team.com header.i=@yandex-team.com header.b=doARputU; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.com
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:1286:0:640:6f2b:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id BB47F60CBC;
	Tue, 11 Feb 2025 14:46:02 +0300 (MSK)
Received: from dellarbn.yandex.net (unknown [10.214.35.248])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id njMaW61IYa60-f300HgHw;
	Tue, 11 Feb 2025 14:46:02 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1739274362;
	bh=N/f4M/1YdrDaXLy1gcP2Kg22i5sVeuoh7Qx0Xv+wu0U=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=doARputUw27HsyLKkbE04O5ibJYLITuopDPsmuZ9aczHNvBTKndE0yZghx202ewCN
	 R0AlGAPmGGvsezMwhUJQ/uepQErBEbYbxzVqcsT+vv5AwhPpqZC4vKmvEML7VbEde/
	 eXAmQ0zBtCojSSOabGstArsm3ER7ferxhDM5F2Bk=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.com
From: Andrey Ryabinin <arbn@yandex-team.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	intel-gvt-dev@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Andrey Ryabinin <arbn@yandex-team.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] vfio: Release KVM pointer after the first device open.
Date: Tue, 11 Feb 2025 12:45:44 +0100
Message-ID: <20250211114544.17845-2-arbn@yandex-team.com>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250211114544.17845-1-arbn@yandex-team.com>
References: <20250211114544.17845-1-arbn@yandex-team.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 2b48f52f2bff ("vfio: fix deadlock between group lock and kvm lock")
made vfio_device to hold KVM struct up until device's close() call.

This lead to a unrleased KVM struct which holds KVM kthreads and related
cgroups after VM with VFIO device migrates to from one KVM instance to
another on the same host.

Since all drivers, that require 'kvm' (vfio-ap/intel_vgp/vfio-pci zdev)
already handle 'kvm' pointer by themselves we can just drop 'kvm' reference
right after first vfio_df_open() call. This will release 'kvm' struct
and dependent resources for drivers that don't require it after KVM
detached from a device (KVM_DEV_VFIO_FILE_DEL).

Fixes: 2b48f52f2bff ("vfio: fix deadlock between group lock and kvm lock")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vfio/device_cdev.c | 11 ++++++-----
 drivers/vfio/group.c       | 31 ++++++++++++++-----------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index bb1817bd4ff3..339b69c43300 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -103,14 +103,16 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 	/*
 	 * Before the device open, get the KVM pointer currently
 	 * associated with the device file (if there is) and obtain
-	 * a reference.  This reference is held until device closed.
+	 * a reference and release it right after vfio_df_open() bellow.
+	 * The device driver wishes to use KVM must obtain a reference and
+	 * release it on close.
 	 * Save the pointer in the device for use by drivers.
 	 */
 	vfio_df_get_kvm_safe(df);
-
 	ret = vfio_df_open(df);
+	vfio_device_put_kvm(device);
 	if (ret)
-		goto out_put_kvm;
+		goto out_put_iommufd;
 
 	ret = copy_to_user(&arg->out_devid, &df->devid,
 			   sizeof(df->devid)) ? -EFAULT : 0;
@@ -128,8 +130,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 
 out_close_device:
 	vfio_df_close(df);
-out_put_kvm:
-	vfio_device_put_kvm(device);
+out_put_iommufd:
 	iommufd_ctx_put(df->iommufd);
 	df->iommufd = NULL;
 out_unlock:
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 49559605177e..872cfd795f99 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -175,15 +175,6 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 
 	mutex_lock(&device->dev_set->lock);
 
-	/*
-	 * Before the first device open, get the KVM pointer currently
-	 * associated with the group (if there is one) and obtain a reference
-	 * now that will be held until the open_count reaches 0 again.  Save
-	 * the pointer in the device for use by drivers.
-	 */
-	if (device->open_count == 0)
-		vfio_device_group_get_kvm_safe(device);
-
 	df->iommufd = device->group->iommufd;
 	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count == 0) {
 		/*
@@ -196,12 +187,23 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 			ret = -EPERM;
 		else
 			ret = 0;
-		goto out_put_kvm;
+		goto out_iommufd;
 	}
 
+	/*
+	 * Before the first device open, get the KVM pointer currently
+	 * associated with the group (if there is one) and obtain a reference
+	 * now that will be released right after vfio_df_open() bellow.
+	 * The device driver wishes to use KVM must obtain a reference and
+	 * release it on close.
+	 */
+	if (device->open_count == 0)
+		vfio_device_group_get_kvm_safe(device);
+
 	ret = vfio_df_open(df);
+	vfio_device_put_kvm(device);
 	if (ret)
-		goto out_put_kvm;
+		goto out_iommufd;
 
 	if (df->iommufd && device->open_count == 1) {
 		ret = vfio_iommufd_compat_attach_ioas(device, df->iommufd);
@@ -221,10 +223,8 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 
 out_close_device:
 	vfio_df_close(df);
-out_put_kvm:
+out_iommufd:
 	df->iommufd = NULL;
-	if (device->open_count == 0)
-		vfio_device_put_kvm(device);
 	mutex_unlock(&device->dev_set->lock);
 out_unlock:
 	mutex_unlock(&device->group->group_lock);
@@ -241,9 +241,6 @@ void vfio_df_group_close(struct vfio_device_file *df)
 	vfio_df_close(df);
 	df->iommufd = NULL;
 
-	if (device->open_count == 0)
-		vfio_device_put_kvm(device);
-
 	mutex_unlock(&device->dev_set->lock);
 	mutex_unlock(&device->group->group_lock);
 }
-- 
2.45.3


