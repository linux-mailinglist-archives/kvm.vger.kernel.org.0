Return-Path: <kvm+bounces-27036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF8C97AE23
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC4BDB2820E
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4906D170A12;
	Tue, 17 Sep 2024 09:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B8RNNNoz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0811016D332
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 09:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565960; cv=none; b=hwBLZp2W3bANgnTfi13WDhaSgEHRSvRkFrjJBq+X+q5c/YBZMygoNYJVK89tBFux+XcRExeVbL2SyM42VGEaT7uztE1FHftyq2e4z6B+HbfwjQQZGiHkFB5x7i3NShKIhPUiPEBt+NCfVUYM2/ZaBNwQwrAxm0DyJnlCYlflJ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565960; c=relaxed/simple;
	bh=nXSFRm5EggAjXzaZJlUbYnL6NsfIlysuS1hkMsyj8hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euDRQTlgB5sM/pfwxznGxopq54b6UKr53mE6ubvFBgHipMAkzc6xK4fRDAiGepHBytNaD6lmNAL+2hzqiCIeA2sqb4CdAJq/guV1IDS/d7Nyvje6PFWC91D0jnAFiowrlwPWoUx5i4vLkchdhUzpYEApjF7VkkHwbnN2iGuXlC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B8RNNNoz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726565957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FFwP7NucSuTkSHwGEdDxPI8XV0NW9fB3DoBDL5pk6ro=;
	b=B8RNNNozXthh6HtGLTbyVbazWs32hTIfr7/OhUlt4nwyu9p7N2OOZYtdjfpg9lx3cSM3yn
	cYn4uojFs5+xlBRLMW5rt6ihd7QIwEAnS3wy7jqndbrSkJ3UV0DXbcurDixBmUkuMxkxrt
	sXvf/rg+vb9pYkmoBP17t5Fszmpxeek=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81--UrbarYZOg6i5bf_PQ73tA-1; Tue,
 17 Sep 2024 05:39:13 -0400
X-MC-Unique: -UrbarYZOg6i5bf_PQ73tA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47A08195608B;
	Tue, 17 Sep 2024 09:39:12 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F72130001A1;
	Tue, 17 Sep 2024 09:39:08 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	treding@nvidia.com,
	vbhadram@nvidia.com,
	jonathanh@nvidia.com,
	mperttunen@nvidia.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	clg@redhat.com,
	alexandre.torgue@foss.st.com,
	joabreu@synopsys.com
Cc: msalter@redhat.com
Subject: [RFC PATCH v2 3/6] vfio-platform: Move region initialization to vfio_platform_init_common
Date: Tue, 17 Sep 2024 11:38:11 +0200
Message-ID: <20240917093851.990344-4-eric.auger@redhat.com>
In-Reply-To: <20240917093851.990344-1-eric.auger@redhat.com>
References: <20240917093851.990344-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

We plan to introduce a new reset module init() callback. This latter
would need to have vdev->regions populated. At the moment this latter
is allocated and populated later on device open.

Call vfio_platform_regions_init() in vfio_platform_init_common()
instead.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 976864d2e2f0..cd0f2ebff586 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -243,7 +243,6 @@ void vfio_platform_close_device(struct vfio_device *core_vdev)
 			ret, extra_dbg ? extra_dbg : "");
 	}
 	pm_runtime_put(vdev->device);
-	vfio_platform_regions_cleanup(vdev);
 	vfio_platform_irq_cleanup(vdev);
 }
 EXPORT_SYMBOL_GPL(vfio_platform_close_device);
@@ -255,13 +254,9 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
 	const char *extra_dbg = NULL;
 	int ret;
 
-	ret = vfio_platform_regions_init(vdev);
-	if (ret)
-		return ret;
-
 	ret = vfio_platform_irq_init(vdev);
 	if (ret)
-		goto err_irq;
+		return ret;
 
 	ret = pm_runtime_get_sync(vdev->device);
 	if (ret < 0)
@@ -280,8 +275,6 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
 err_rst:
 	pm_runtime_put(vdev->device);
 	vfio_platform_irq_cleanup(vdev);
-err_irq:
-	vfio_platform_regions_cleanup(vdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_open_device);
@@ -658,12 +651,17 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
 		return ret;
 
 	vdev->device = dev;
+	ret = vfio_platform_regions_init(vdev);
+	if (ret)
+		return ret;
+
 	mutex_init(&vdev->igate);
 
 	ret = vfio_platform_get_reset(vdev);
 	if (ret && vdev->reset_required) {
 		dev_err(dev, "No reset function found for device %s\n",
 			vdev->name);
+		vfio_platform_regions_cleanup(vdev);
 		return ret;
 	}
 
@@ -674,6 +672,7 @@ EXPORT_SYMBOL_GPL(vfio_platform_init_common);
 void vfio_platform_release_common(struct vfio_platform_device *vdev)
 {
 	vfio_platform_put_reset(vdev);
+	vfio_platform_regions_cleanup(vdev);
 }
 EXPORT_SYMBOL_GPL(vfio_platform_release_common);
 
-- 
2.41.0


