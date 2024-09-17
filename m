Return-Path: <kvm+bounces-27037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B179197AE1E
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 11:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73A52B23010
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 09:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200AD1714CB;
	Tue, 17 Sep 2024 09:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FsiOrZ+9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FB215E5DC
	for <kvm@vger.kernel.org>; Tue, 17 Sep 2024 09:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565965; cv=none; b=gMt0U39mNSQEx9PIgUvCEKAgpCGZj0DxB+to2WBz5hKnX9PD2DFYXqj4sdM0b5e4V0RKlfTWMLrnzjB3nvbq5na1Dzyhsk/yykNjaVNHlVXP3v+VqB/QZBvW68IkxRBtDrTgqaOzkaSmW33Cq7CD9oSY62xtepGyZwK6AGeI2hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565965; c=relaxed/simple;
	bh=0RDnGkcH5gBUXPSkOdE1ySzJO4gf/kusKNj3cc3gv2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdHIBIsufckpnYW4yKR+wiw5M3Nii6D2utm+6PPth/pFwyNAmj+qujnU0ziqFfYYCZvToFnl+GJv1XHKR47lBR8Wn/zdC8C4H0lZFLk9FDRAdjGGx6RmRumCvZ0+FgkIkSoaPOUU9Nb/WIjfbF64GHG5poiIiBS2CDy2rIavL9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FsiOrZ+9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726565962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kp4U5UOayVdGnJFTxBOBON9W0uurDj22AVgPaFZSSVo=;
	b=FsiOrZ+98iVvNmTGt2cH45ScjffpTTv1eZi+Ami9cuqD2yIuE7yNLBP4bn2gjuMu2Hng/1
	GYIZsa6LvPuznsmKFpkRzYCBeZE2Bzv3gchEG6gu5PfsRFl+rbuI+kuvdPe5SpezyaeuUr
	G7ia8BJKgefcu7BNm5BYuFyU2kzpIdo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-xuKen4ggP-yPwqEtwt7wAQ-1; Tue,
 17 Sep 2024 05:39:19 -0400
X-MC-Unique: xuKen4ggP-yPwqEtwt7wAQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E74D61956048;
	Tue, 17 Sep 2024 09:39:17 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0D4D30001A1;
	Tue, 17 Sep 2024 09:39:12 +0000 (UTC)
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
Subject: [RFC PATCH v2 4/6] vfio_platform: reset: Introduce new init and release callbacks
Date: Tue, 17 Sep 2024 11:38:12 +0200
Message-ID: <20240917093851.990344-5-eric.auger@redhat.com>
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

Some devices may require resources such as clocks and resets
which cannot be handled in the vfio_platform agnostic code. Let's
add 2 new callbacks to handle those resources. Those new callbacks
are optional, as opposed to the reset callback. In case they are
implemented, both need to be.

They are not implemented by the existing reset modules.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/platform/vfio_platform_common.c  | 23 ++++++++++++++++++-
 drivers/vfio/platform/vfio_platform_private.h |  6 +++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index cd0f2ebff586..8d40ca452bbb 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -228,6 +228,23 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
 	return -EINVAL;
 }
 
+static void vfio_platform_reset_module_release(struct vfio_platform_device *vpdev)
+{
+	if (VFIO_PLATFORM_IS_ACPI(vpdev))
+		return;
+	if (vpdev->of_reset_ops && vpdev->of_reset_ops->release)
+		vpdev->of_reset_ops->release(vpdev);
+}
+
+static int vfio_platform_reset_module_init(struct vfio_platform_device *vpdev)
+{
+	if (VFIO_PLATFORM_IS_ACPI(vpdev))
+		return 0;
+	if (vpdev->of_reset_ops && vpdev->of_reset_ops->init)
+		return vpdev->of_reset_ops->init(vpdev);
+	return 0;
+}
+
 void vfio_platform_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_platform_device *vdev =
@@ -665,12 +682,16 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
 		return ret;
 	}
 
-	return 0;
+	ret = vfio_platform_reset_module_init(vdev);
+	if (ret)
+		vfio_platform_put_reset(vdev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_init_common);
 
 void vfio_platform_release_common(struct vfio_platform_device *vdev)
 {
+	vfio_platform_reset_module_release(vdev);
 	vfio_platform_put_reset(vdev);
 	vfio_platform_regions_cleanup(vdev);
 }
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 333aefe2a1fc..33183addd235 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -74,9 +74,13 @@ struct vfio_platform_device {
  * struct vfio_platform_of_reset_ops - reset ops
  *
  * @reset:	reset function (required)
+ * @init:	Called on device attach (optional)
+ * @release:	Called on device detach (optional)
  */
 struct vfio_platform_of_reset_ops {
 	int (*reset)(struct vfio_platform_device *vdev);
+	int (*init)(struct vfio_platform_device *vdev);
+	void (*release)(struct vfio_platform_device *vdev);
 };
 
 
@@ -129,6 +133,8 @@ __vfio_platform_register_reset(&__ops ## _node)
 MODULE_ALIAS("vfio-reset:" compat);				\
 static int __init reset ## _module_init(void)			\
 {								\
+	if (!!ops.init ^ !!ops.release)				\
+		return -EINVAL;					\
 	vfio_platform_register_reset(compat, ops);		\
 	return 0;						\
 };								\
-- 
2.41.0


