Return-Path: <kvm+bounces-1538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 583DC7E8FFC
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 14:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30CB8280E19
	for <lists+kvm@lfdr.de>; Sun, 12 Nov 2023 13:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C2511C89;
	Sun, 12 Nov 2023 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvIZDhET"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3746CCA51;
	Sun, 12 Nov 2023 13:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A23C433CD;
	Sun, 12 Nov 2023 13:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699795438;
	bh=OgUO47nzRbf6nmGJSZaeT0emMlcSWzNVcL5bEtyOJ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvIZDhETzL6dRrjwWZJy+ZXpkVaPvhRn1R0mx82oTcu5H97pHUykUvLxqtiVK4j+0
	 4m5tIhvTyFGsyfuHRQtJk1tDe8CZYGEuMzzZddyYaoKmGTjrEPdq6mM6mDHh/d0wdW
	 POWEIiGNL7xVCXLPCrYcfmnePulAdNRkcgo770rC2IrTwlOLtmZGTRkUddMC4ZUR4L
	 sLJt+V+K0mRkDZXZ/ok3XL4LsS1S9C3ww27glAMWLRPCpP3SQ5bgqo1iJx2GttvQ0r
	 gmurDDuw1leiRr1Db/hG4sMvuG2x7UYIx3Cf7sCcrlV/AL3Fi0BzIcEtjMldaHq4Kb
	 UjubIGLCtUkKw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Si-Wei Liu <si-wei.liu@oracle.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Lei Yang <leiyang@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.5 6/7] vhost-vdpa: clean iotlb map during reset for older userspace
Date: Sun, 12 Nov 2023 08:23:38 -0500
Message-ID: <20231112132347.174334-6-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231112132347.174334-1-sashal@kernel.org>
References: <20231112132347.174334-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.11
Content-Transfer-Encoding: 8bit

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit bc91df5c70ac720eca18bd1f4a288f2582713d3e ]

Using .compat_reset op from the previous patch, the buggy .reset
behaviour can be kept as-is on older userspace apps, which don't ack the
IOTLB_PERSIST backend feature. As this compatibility quirk is limited to
those drivers that used to be buggy in the past, it won't affect change
the behaviour or affect ABI on the setups with API compliant driver.

The separation of .compat_reset from the regular .reset allows
vhost-vdpa able to know which driver had broken behaviour before, so it
can apply the corresponding compatibility quirk to the individual driver
whenever needed.  Compared to overloading the existing .reset with
flags, .compat_reset won't cause any extra burden to the implementation
of every compliant driver.

[mst: squashed in two fixup commits]

Message-Id: <1697880319-4937-6-git-send-email-si-wei.liu@oracle.com>
Message-Id: <1698102863-21122-1-git-send-email-si-wei.liu@oracle.com>
Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
Message-Id: <1698275594-19204-1-git-send-email-si-wei.liu@oracle.com>
Reported-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c         | 20 ++++++++++++++++----
 drivers/virtio/virtio_vdpa.c |  2 +-
 include/linux/vdpa.h         |  7 +++++--
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b43e8680eee8d..fb934a7e68bfb 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -210,13 +210,24 @@ static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
 	irq_bypass_unregister_producer(&vq->call_ctx.producer);
 }
 
-static int vhost_vdpa_reset(struct vhost_vdpa *v)
+static int _compat_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
+	u32 flags = 0;
 
-	v->in_batch = 0;
+	if (v->vdev.vqs) {
+		flags |= !vhost_backend_has_feature(v->vdev.vqs[0],
+						    VHOST_BACKEND_F_IOTLB_PERSIST) ?
+			 VDPA_RESET_F_CLEAN_MAP : 0;
+	}
+
+	return vdpa_reset(vdpa, flags);
+}
 
-	return vdpa_reset(vdpa);
+static int vhost_vdpa_reset(struct vhost_vdpa *v)
+{
+	v->in_batch = 0;
+	return _compat_vdpa_reset(v);
 }
 
 static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
@@ -295,7 +306,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 			vhost_vdpa_unsetup_vq_irq(v, i);
 
 	if (status == 0) {
-		ret = vdpa_reset(vdpa);
+		ret = _compat_vdpa_reset(v);
 		if (ret)
 			return ret;
 	} else
@@ -1272,6 +1283,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 	vhost_vdpa_free_domain(v);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
+	v->vdev.vqs = NULL;
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 06ce6d8c2e004..8d63e5923d245 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -100,7 +100,7 @@ static void virtio_vdpa_reset(struct virtio_device *vdev)
 {
 	struct vdpa_device *vdpa = vd_get_vdpa(vdev);
 
-	vdpa_reset(vdpa);
+	vdpa_reset(vdpa, 0);
 }
 
 static bool virtio_vdpa_notify(struct virtqueue *vq)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index db1b0eaef4eb7..c287382b0a80b 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -481,14 +481,17 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
 	return vdev->dma_dev;
 }
 
-static inline int vdpa_reset(struct vdpa_device *vdev)
+static inline int vdpa_reset(struct vdpa_device *vdev, u32 flags)
 {
 	const struct vdpa_config_ops *ops = vdev->config;
 	int ret;
 
 	down_write(&vdev->cf_lock);
 	vdev->features_valid = false;
-	ret = ops->reset(vdev);
+	if (ops->compat_reset && flags)
+		ret = ops->compat_reset(vdev, flags);
+	else
+		ret = ops->reset(vdev);
 	up_write(&vdev->cf_lock);
 	return ret;
 }
-- 
2.42.0


