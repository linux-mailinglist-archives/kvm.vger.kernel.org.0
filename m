Return-Path: <kvm+bounces-54131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B92F8B1CA3D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 19:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6568218C497D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 17:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7321D2980AC;
	Wed,  6 Aug 2025 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WFPiyTCh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C229E0E1
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499816; cv=none; b=iNvT7AA/e4YzH+u7dCRyv7C3ko3FMhNf6QxCVikTCrd5L3gg+Z2v2acfNNo3GF7HTAy8WLuoG9fZ1MMdXMU6J0jKF4pzS/lD6GMgJvKT6O0O9h646WAGJ+Y3E5pXGrae0wg+3VyOYAFIwKQAv1cGKyyJdjn5EXj8CQS2jNKsrWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499816; c=relaxed/simple;
	bh=CPMxbRh94JnxO0mzoXMokg9I8ngrGZNcga7wtw2hpsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os5PEdFbxKk5p/V3ZI3OzXH+qF/EMjDxXk+1aZPDbVLWI9BQJ3OLuFqIHqVjgKe+iV1FS1x1fRvHhammPeEbGEI1wiFiL8CW85L97ROcrhzbnlCZ1lVJ3WmmWDGofeDT5n9pGKGh24pm3N5S80N2FvrC90tm19zDSiesRs/dTI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WFPiyTCh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754499813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SKoJ2BjIBdkoXAWIkYom3NLmTCzDnSKGDSQwCAIp9+w=;
	b=WFPiyTChiB5vWdVM+tBJ8QNBXA+thy8M6ln1pz8Oo6n1ttw9DVjjosS0ZsvB/3tdGA/rBw
	8RaDveTS4onO22rXyCiXGwhFpxrBv8NwyJLWRWNcGMcKgY5fKF4moFRJ76rcbyRsBpDo+Q
	Te5CHCrHqR0hrV0lHP0oneyIzCobL4s=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-576-aFp54YT8MGC5REStw6UzYg-1; Wed,
 06 Aug 2025 13:03:29 -0400
X-MC-Unique: aFp54YT8MGC5REStw6UzYg-1
X-Mimecast-MFC-AGG-ID: aFp54YT8MGC5REStw6UzYg_1754499808
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7C19195608D;
	Wed,  6 Aug 2025 17:03:27 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.66.8])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB099180035C;
	Wed,  6 Aug 2025 17:03:26 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com
Subject: [PATCH 2/2] vfio/platform: Mark for removal
Date: Wed,  6 Aug 2025 11:03:12 -0600
Message-ID: <20250806170314.3768750-3-alex.williamson@redhat.com>
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

vfio-platform hasn't had a meaningful contribution in years.  In-tree
hardware support is predominantly only for devices which are long since
e-waste.  QEMU support for platform devices is slated for removal in
QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
driver and difficulties supporting new devices at KVM Forum 2024,
gaining some support for removal, some disagreement, but garnering no
new hardware support, leaving the driver in a state where it cannot
be tested.

Mark as obsolete and subject to removal.

Link: https://lore.kernel.org/all/20250731121947.1346927-1-clg@redhat.com/
Link: https://www.youtube.com/watch?v=Q5BOSbtwRr8
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 MAINTAINERS                           |  2 +-
 drivers/vfio/platform/Kconfig         | 10 ++++++++--
 drivers/vfio/platform/reset/Kconfig   |  6 +++---
 drivers/vfio/platform/vfio_amba.c     |  2 ++
 drivers/vfio/platform/vfio_platform.c |  2 ++
 5 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 25a520467dec..c19b60032aa3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26084,7 +26084,7 @@ F:	drivers/vfio/pci/pds/
 VFIO PLATFORM DRIVER
 M:	Eric Auger <eric.auger@redhat.com>
 L:	kvm@vger.kernel.org
-S:	Maintained
+S:	Obsolete
 F:	drivers/vfio/platform/
 
 VFIO QAT PCI DRIVER
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 88fcde51f024..a8bde833e9e5 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -7,9 +7,12 @@ config VFIO_PLATFORM_BASE
 	select VFIO_VIRQFD
 
 config VFIO_PLATFORM
-	tristate "Generic VFIO support for any platform device"
+	tristate "Generic VFIO support for any platform device (DEPRECATED)"
 	select VFIO_PLATFORM_BASE
 	help
+	  The vfio-platform driver is deprecated and will be removed in a
+	  future kernel release.
+
 	  Support for platform devices with VFIO. This is required to make
 	  use of platform devices present on the system using the VFIO
 	  framework.
@@ -17,10 +20,13 @@ config VFIO_PLATFORM
 	  If you don't know what to do here, say N.
 
 config VFIO_AMBA
-	tristate "VFIO support for AMBA devices"
+	tristate "VFIO support for AMBA devices (DEPRECATED)"
 	depends on ARM_AMBA || COMPILE_TEST
 	select VFIO_PLATFORM_BASE
 	help
+	  The vfio-amba driver is deprecated and will be removed in a
+	  future kernel release.
+
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
 	  framework.
diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
index dcc08dc145a5..70af0dbe293b 100644
--- a/drivers/vfio/platform/reset/Kconfig
+++ b/drivers/vfio/platform/reset/Kconfig
@@ -1,21 +1,21 @@
 # SPDX-License-Identifier: GPL-2.0-only
 if VFIO_PLATFORM
 config VFIO_PLATFORM_CALXEDAXGMAC_RESET
-	tristate "VFIO support for calxeda xgmac reset"
+	tristate "VFIO support for calxeda xgmac reset (DEPRECATED)"
 	help
 	  Enables the VFIO platform driver to handle reset for Calxeda xgmac
 
 	  If you don't know what to do here, say N.
 
 config VFIO_PLATFORM_AMDXGBE_RESET
-	tristate "VFIO support for AMD XGBE reset"
+	tristate "VFIO support for AMD XGBE reset (DEPRECATED)"
 	help
 	  Enables the VFIO platform driver to handle reset for AMD XGBE
 
 	  If you don't know what to do here, say N.
 
 config VFIO_PLATFORM_BCMFLEXRM_RESET
-	tristate "VFIO support for Broadcom FlexRM reset"
+	tristate "VFIO support for Broadcom FlexRM reset (DEPRECATED)"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	default ARCH_BCM_IPROC
 	help
diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index ff8ff8480968..9f5c527baa8a 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -70,6 +70,8 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
 	struct vfio_platform_device *vdev;
 	int ret;
 
+	dev_err_once(&adev->dev, "DEPRECATION: vfio-amba is deprecated and will be removed in a future kernel release\n");
+
 	vdev = vfio_alloc_device(vfio_platform_device, vdev, &adev->dev,
 				 &vfio_amba_ops);
 	if (IS_ERR(vdev))
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index 512533501eb7..48a49b14164a 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -59,6 +59,8 @@ static int vfio_platform_probe(struct platform_device *pdev)
 	struct vfio_platform_device *vdev;
 	int ret;
 
+	dev_err_once(&pdev->dev, "DEPRECATION: vfio-platform is deprecated and will be removed in a future kernel release\n");
+
 	vdev = vfio_alloc_device(vfio_platform_device, vdev, &pdev->dev,
 				 &vfio_platform_ops);
 	if (IS_ERR(vdev))
-- 
2.50.1


