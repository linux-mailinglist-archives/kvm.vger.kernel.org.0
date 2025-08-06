Return-Path: <kvm+bounces-54130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CAD1B1CA3C
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 041033BEDE8
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 17:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96F627A92B;
	Wed,  6 Aug 2025 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7UbPqGg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006029B22F
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499814; cv=none; b=pQdWrnG2l4SyTv5HVmB/e/0WB1TIhrO2an92gsEXk4d7lcdzhFxZcugvPBU4hk5dxFQUWDFj5aBiJP9ZB6HXeV2SQrOr76C7ad3cH6wUAMBGz5Jmad3HfUkRFc6F7jnL5YlItITqqc1qscvaNdPhRSjJyh6z18ONOJUCDfk8PFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499814; c=relaxed/simple;
	bh=R9E2CXDi0Ci1uMDw2pUbtnv9Gjct9iSM/Rkm4hV2jXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1msi+FXYwl5odJA7uQwDt7d92BNSncf1z7vqgs8VXIXr0Y7QQ9quBHmLt/itsObM4j24RbSq+5Nmr5GwdbEUtuIAHvkuAOAVgBlCdi2ONZP13rb42fU3TGivCGTE+DZc7dARXkBA9ePJVBi+x4M5tQl7UFf+qkwRUcAkyd9wPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B7UbPqGg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754499811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOB1iUxGdN/YU3HdC/MxEaPJYHZj91g8Oi9O0xUCn9c=;
	b=B7UbPqGg/Jw7em/A9cdS57wLa8EWnQml1k8n/FT/zcRLOsh4srzkhc3GBIzYw05HktHmrF
	yQt9BNsiNnSQS1BmzJjVhX61s8hbP6udf1IxK94Bd5OXYyjS+tbuG7oYNJk957kuIsbF42
	C+FrhN5mq8PbzmIgYysqO+paCLNcfEg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-Ep4MHr24Nci2mqbrnOwGsA-1; Wed,
 06 Aug 2025 13:03:27 -0400
X-MC-Unique: Ep4MHr24Nci2mqbrnOwGsA-1
X-Mimecast-MFC-AGG-ID: Ep4MHr24Nci2mqbrnOwGsA_1754499806
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 546091800446;
	Wed,  6 Aug 2025 17:03:26 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.66.8])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 22DBE180035C;
	Wed,  6 Aug 2025 17:03:24 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com
Subject: [PATCH 1/2] vfio/fsl-mc: Mark for removal
Date: Wed,  6 Aug 2025 11:03:11 -0600
Message-ID: <20250806170314.3768750-2-alex.williamson@redhat.com>
In-Reply-To: <20250806170314.3768750-1-alex.williamson@redhat.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The driver has been orphaned for more than a year, mark it for removal.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 MAINTAINERS                       | 2 +-
 drivers/vfio/fsl-mc/Kconfig       | 5 ++++-
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c0b444e5fd5a..25a520467dec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26033,7 +26033,7 @@ F:	include/uapi/linux/vfio.h
 
 VFIO FSL-MC DRIVER
 L:	kvm@vger.kernel.org
-S:	Orphan
+S:	Obsolete
 F:	drivers/vfio/fsl-mc/
 
 VFIO HISILICON PCI DRIVER
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index 7d1d690348f0..43c145d17971 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -2,9 +2,12 @@ menu "VFIO support for FSL_MC bus devices"
 	depends on FSL_MC_BUS
 
 config VFIO_FSL_MC
-	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
+	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices (DEPRECATED)"
 	select EVENTFD
 	help
+	  The vfio-fsl-mc driver is deprecated and will be removed in a
+	  future kernel release.
+
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
 	  (Management Complex) devices. This is required to passthrough
 	  fsl-mc bus devices using the VFIO framework.
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index f65d91c01f2e..76ccbab0e3d6 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -537,6 +537,8 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
 	struct device *dev = &mc_dev->dev;
 	int ret;
 
+	dev_err_once(dev, "DEPRECATION: vfio-fsl-mc is deprecated and will be removed in a future kernel release\n");
+
 	vdev = vfio_alloc_device(vfio_fsl_mc_device, vdev, dev,
 				 &vfio_fsl_mc_ops);
 	if (IS_ERR(vdev))
-- 
2.50.1


