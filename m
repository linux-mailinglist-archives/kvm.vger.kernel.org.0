Return-Path: <kvm+bounces-55664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7012B34975
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CF8D169ED9
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A97C3090FE;
	Mon, 25 Aug 2025 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avxw5SUP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD113074AD
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756144702; cv=none; b=U8NsBmbTDO2InlDF6LiXI1aU7k2rAGC1LCU20SjWYC7BkDYmrZSkKi2ndgr3BiafgBFxHrScz21vvkvOZ8CdMcMYwfo8ZZBPgFJUNHjGq8x60BCkhMOy5yu+LHuCu9+fseQ4lgxOdETGGGYetDrmrm1mqm2ihm/RQCugFtbsA3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756144702; c=relaxed/simple;
	bh=vvpgtWljO8g6vfNNR0LWQZBdjUNnUNFUTTB/KCXqhL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE20sZgQ9uccRRwzkCp1yCcRj/qawqDxVMxhStlCelrLURxp8TTv7Zfi5xS6YmDhbWyRC8ztgVp+lkJpZ7pDnGof9Cq7A0PdvMADfBO6cPQdClZCaFi3lic01FWWFq5BHTEpoHLYsHXxO8cZgOFHTYYU01CxnJy7t+7HMwio4Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avxw5SUP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756144699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kb7doY5fJO02puqXf/U89W3nBNVd9MZqu9tZVFDvwsU=;
	b=avxw5SUPkblEBHW6d4AWoBYyhDCyleq9jHo6AN9tRLyQuqx/yFb08YKA7GrBSucHuROMou
	B5Grthr203x/mSP8LA/+idnfhye77RCo5kYBTASshga0sYK+hRpiEwe0ZHXvCModGDiXFY
	lh5SHWWk2AhrQWtbQfDBTcwajDiJX0A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-y6kU7nU5NEm67Nubwr0bJQ-1; Mon,
 25 Aug 2025 13:58:17 -0400
X-MC-Unique: y6kU7nU5NEm67Nubwr0bJQ-1
X-Mimecast-MFC-AGG-ID: y6kU7nU5NEm67Nubwr0bJQ_1756144696
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A04B19541A4;
	Mon, 25 Aug 2025 17:58:16 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.64.176])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E914C1800446;
	Mon, 25 Aug 2025 17:58:14 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eric.auger@redhat.com,
	smostafa@google.com,
	praan@google.com
Subject: [PATCH 1/2] vfio/amba: Mark for removal
Date: Mon, 25 Aug 2025 11:58:00 -0600
Message-ID: <20250825175807.3264083-2-alex.williamson@redhat.com>
In-Reply-To: <20250825175807.3264083-1-alex.williamson@redhat.com>
References: <20250825175807.3264083-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

vfio-amba has only been touched to keep up with the rest of the code
base for the past 10 years.  We have no basis to believe that it's
currently tested or used.  Mark it for deprecation.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/platform/Kconfig     | 5 ++++-
 drivers/vfio/platform/vfio_amba.c | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 88fcde51f024..c6be29b2c24b 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -17,10 +17,13 @@ config VFIO_PLATFORM
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
-- 
2.50.1


