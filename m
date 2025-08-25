Return-Path: <kvm+bounces-55665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3B4B34978
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 19:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A2D6188B43F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119DD309DD8;
	Mon, 25 Aug 2025 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eFCmlNSQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7893093A5
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756144705; cv=none; b=XXohYR2+vjTeOQ7aKjxK/VZ2Zlm18xIT8SjopwzA4dJtvcE5NxWyY4TzqysihZeizLAXjBM7rGQPIwqDu2Vv1wIhGAYMMz6X2xlRjc2igJLgGF3tCMfpHNIlYHajLMC2e8Aq3+m4FHLGwQ0okfzJDny2RB+2w4zArAwRaVZoNW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756144705; c=relaxed/simple;
	bh=9tQhpKFrcKVl8eNWr9WDsA9HaILG0i5qT4KrmJKG/os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzmKkCQ7O/XdCupyDh9r+l8WrWftfyYsbF891+Y+rqIP/de933ddPksOee3MSzcqmTT+Uag6FiXoWfx8flZKcOe0FbbK+ZNMyN913Gajl5FPEBctpc05SxaL2IIvkNHe0C9GgH1taoYXCVGXSX26nZuedV6cY1Aa4QbfqNiTIck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eFCmlNSQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756144702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6nCXbyTRhRumkJuo6IKUQ8YReJ5IEnvwLFxxcUye5V4=;
	b=eFCmlNSQNFau2TNqcOyOOf4wvWUKhHMiEb/tT4Rd1KZLDVBIab+jbDR30xmua2U1NQSYRE
	IbLCZ1Gz+EA2Nb16HDDGv9LqM0BJbCVOLJlYjDMTyVqBtROr4R8Tq9c1Foz00ORfvHhvcp
	hjxKWjczzsMWO/ciYxmAH8mw/Hsthpo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-344-M8Ck-cJbPOWkThjfbaCXDA-1; Mon,
 25 Aug 2025 13:58:19 -0400
X-MC-Unique: M8Ck-cJbPOWkThjfbaCXDA-1
X-Mimecast-MFC-AGG-ID: M8Ck-cJbPOWkThjfbaCXDA_1756144698
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AEAA180028C;
	Mon, 25 Aug 2025 17:58:18 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.64.176])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9BEF8180028A;
	Mon, 25 Aug 2025 17:58:16 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eric.auger@redhat.com,
	smostafa@google.com,
	praan@google.com
Subject: [PATCH 2/2] vfio/platform: Mark reset drivers for removal
Date: Mon, 25 Aug 2025 11:58:01 -0600
Message-ID: <20250825175807.3264083-3-alex.williamson@redhat.com>
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

While vfio-platform itself is on a reprieve from being removed[1],
these reset drivers don't support any current hardware, are not being
tested, and suggest a level of support that doesn't really exist.
Mark them for removal to surface any remaining user such that we can
potentially drop them and simplify the code if none appear.

Link: https://lore.kernel.org/all/20250806170314.3768750-3-alex.williamson@redhat.com [1]
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/platform/reset/Kconfig                      | 6 +++---
 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c      | 2 ++
 drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c    | 2 ++
 drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c | 2 ++
 4 files changed, 9 insertions(+), 3 deletions(-)

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
diff --git a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
index abdca900802d..45f386a042a9 100644
--- a/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
+++ b/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
@@ -52,6 +52,8 @@ static int vfio_platform_amdxgbe_reset(struct vfio_platform_device *vdev)
 	u32 dma_mr_value, pcs_value, value;
 	unsigned int count;
 
+	dev_err_once(vdev->device, "DEPRECATION: VFIO AMD XGBE platform reset is deprecated and will be removed in a future kernel release\n");
+
 	if (!xgmac_regs->ioaddr) {
 		xgmac_regs->ioaddr =
 			ioremap(xgmac_regs->addr, xgmac_regs->size);
diff --git a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
index 1131ebe4837d..51c9d156f307 100644
--- a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
+++ b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
@@ -72,6 +72,8 @@ static int vfio_platform_bcmflexrm_reset(struct vfio_platform_device *vdev)
 	int rc = 0, ret = 0, ring_num = 0;
 	struct vfio_platform_region *reg = &vdev->regions[0];
 
+	dev_err_once(vdev->device, "DEPRECATION: VFIO Broadcom FlexRM platform reset is deprecated and will be removed in a future kernel release\n");
+
 	/* Map FlexRM ring registers if not mapped */
 	if (!reg->ioaddr) {
 		reg->ioaddr = ioremap(reg->addr, reg->size);
diff --git a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
index 63cc7f0b2e4a..a298045a8e19 100644
--- a/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
+++ b/drivers/vfio/platform/reset/vfio_platform_calxedaxgmac.c
@@ -50,6 +50,8 @@ static int vfio_platform_calxedaxgmac_reset(struct vfio_platform_device *vdev)
 {
 	struct vfio_platform_region *reg = &vdev->regions[0];
 
+	dev_err_once(vdev->device, "DEPRECATION: VFIO Calxeda xgmac platform reset is deprecated and will be removed in a future kernel release\n");
+
 	if (!reg->ioaddr) {
 		reg->ioaddr =
 			ioremap(reg->addr, reg->size);
-- 
2.50.1


