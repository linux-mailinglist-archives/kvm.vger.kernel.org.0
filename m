Return-Path: <kvm+bounces-40806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE820A5D2F2
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 00:07:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4190D7A9F55
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 23:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8AD23236A;
	Tue, 11 Mar 2025 23:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkLh37tn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541C81EB182
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 23:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741734416; cv=none; b=OCotYeF5rD3WrIzmv5vS3WAl/xZvbc6VVCYHyryGVPC2i1Ml2NW/zvDHuD+xNLfXPTUOOt941ONygDC054l6ScRAOyCtb+t48GbGtJq++W/MwhflwUFHkYZucRaexd3qByWY6qRapWFqB4NvLYlO9oE6l3RRe2re1IwnIdc1Ma4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741734416; c=relaxed/simple;
	bh=GInwDmFL+E4z2399FYRzvd/glorN/tCGAxAkWya2/xI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hd83iyvblagJbOFCLAo+RRpUwFNussVN2LcTOhrdls4L4nOWbGm7n+xgfNyQY4gQ45qOQRJ560LMwYn4bmRydT62KpwQFJdtEqwhOJKdilnky1986iptU8IqMwe2+X8/gxXK2UqfTWJHEZbvT5SGt+6YlZWSO8kRUe/EGBJMBlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkLh37tn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741734413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=a9noPpACO8ciZYTyT2h1cwf9R2LqOK9Qrm+1carctfA=;
	b=BkLh37tnBm+LR37lJjFuCVOJdRPyoDN7X9L/sZbxttlEkl64gHb75d17NACNL/VtxfT7sx
	izcvGoYp8OMmyxsZ2XEvfpzPxG+UmKTXOgxfPdDRCA5b5g3TZ4NJKR4bsqlbIDNYuii2Wn
	mDSnsJvQoZco1u1Hm5Xk3T3jt/spEeg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-te1cw0KaOxCAsNZMuGJNeA-1; Tue,
 11 Mar 2025 19:06:51 -0400
X-MC-Unique: te1cw0KaOxCAsNZMuGJNeA-1
X-Mimecast-MFC-AGG-ID: te1cw0KaOxCAsNZMuGJNeA_1741734411
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 170EA195608F
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 23:06:51 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.65.243])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 532AF1801751;
	Tue, 11 Mar 2025 23:06:49 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org
Subject: [PATCH] vfio/pci: Handle INTx IRQ_NOTCONNECTED
Date: Tue, 11 Mar 2025 17:06:21 -0600
Message-ID: <20250311230623.1264283-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Some systems report INTx as not routed by setting pdev->irq to
IRQ_NOTCONNECTED, resulting in a -ENOTCONN error when trying to
setup eventfd signaling.  Include this in the set of conditions
for which the PIN register is virtualized to zero.

Additionally consolidate vfio_pci_get_irq_count() to use this
virtualized value in reporting INTx support via ioctl and sanity
checking ioctl paths since pdev->irq is re-used when the device
is in MSI mode.

The combination of these results in both the config space of the
device and the ioctl interface behaving as if the device does not
support INTx.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Testing is welcome on systems that actually implement this form
of reporting an unrouted INTx, I don't have access to such as
system and have only tested mimicking the behavior with a quirk
to write the LINE register to 0xff and hack to mask the GSI info
for a device.

 drivers/vfio/pci/vfio_pci_config.c |  3 ++-
 drivers/vfio/pci/vfio_pci_core.c   | 10 +---------
 drivers/vfio/pci/vfio_pci_intrs.c  |  2 +-
 3 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 94142581c98c..14437396d721 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1814,7 +1814,8 @@ int vfio_config_init(struct vfio_pci_core_device *vdev)
 					cpu_to_le16(PCI_COMMAND_MEMORY);
 	}
 
-	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx)
+	if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) || vdev->nointx ||
+	    vdev->pdev->irq == IRQ_NOTCONNECTED)
 		vconfig[PCI_INTERRUPT_PIN] = 0;
 
 	ret = vfio_cap_init(vdev);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 586e49efb81b..c857630f447b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -727,15 +727,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
-		u8 pin;
-
-		if (!IS_ENABLED(CONFIG_VFIO_PCI_INTX) ||
-		    vdev->nointx || vdev->pdev->is_virtfn)
-			return 0;
-
-		pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);
-
-		return pin ? 1 : 0;
+		return vdev->vconfig[PCI_INTERRUPT_PIN] ? 1 : 0;
 	} else if (irq_type == VFIO_PCI_MSI_IRQ_INDEX) {
 		u8 pos;
 		u16 flags;
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 8382c5834335..565966351dfa 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -259,7 +259,7 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 	if (!is_irq_none(vdev))
 		return -EINVAL;
 
-	if (!pdev->irq)
+	if (!pdev->irq || pdev->irq == IRQ_NOTCONNECTED)
 		return -ENODEV;
 
 	name = kasprintf(GFP_KERNEL_ACCOUNT, "vfio-intx(%s)", pci_name(pdev));
-- 
2.48.1


