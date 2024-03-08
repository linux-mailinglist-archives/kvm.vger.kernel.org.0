Return-Path: <kvm+bounces-11411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4DA876DB9
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 00:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD124282FFA
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7558E4C61F;
	Fri,  8 Mar 2024 23:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fcbz8QJb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34DC3BBD5
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 23:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709939175; cv=none; b=kPttnSJkkqnRxTyB2b/qyEhiEEqI5J7kxUiEXHx5T79uKqK9HwWLwkiO7U0AxTCdYgQD7sxP0j0fPGFclG/fLfEo7VXWgwvxgbS+qxR2eb0LxXNisRBZ6D0kPX9a64r8kRhfzbaXDo6wFtW8n5r6B0c6lmuRPXX6PxFxZvFWHA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709939175; c=relaxed/simple;
	bh=heT93CNz8M4GwBdCOZkIHxkdserSfvqS5SdZ6rnGMbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3eQWmv5L4rJdoc93hHfCyPdUebQFxZGYe2UYOYLKoySJSqUTYpPNesWBbpxZvzfvz4aQulkqgQoVXTFxPOPiHvxD333n4PFDiTyL2KKpsZTlLbpiFR5jThEK3O++w2Kod5Gfyhp5EE/vIDeHhAndlDKNu9xgp9C205SuwnSpgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fcbz8QJb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709939171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s1fqiArHyLhCU0d5Vyof/5+mbhO22X+BF7PWrc8qFrE=;
	b=Fcbz8QJb2oaTsiRp0WLUWZd+hEetRgLUOkPi04iVrSVWwzUFbX8MQ6G/Y4VFcSX/1Ptyo6
	+/QSwTEdIQQP/71xN5Sb/7peNgLFmh8toN6ceBcKXpVCl5ph2z5TdH0iGyBVQjB6AOdnWk
	kpaLwioWFlHYHYE55y3iitkeekMNs94=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-7t25bQA-P66lx1ZIL_U-7g-1; Fri, 08 Mar 2024 18:06:06 -0500
X-MC-Unique: 7t25bQA-P66lx1ZIL_U-7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B9408007A2;
	Fri,  8 Mar 2024 23:06:06 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.8.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4112A37FD;
	Fri,  8 Mar 2024 23:06:04 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	kevin.tian@intel.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/7] vfio/pci: Disable auto-enable of exclusive INTx IRQ
Date: Fri,  8 Mar 2024 16:05:22 -0700
Message-ID: <20240308230557.805580-2-alex.williamson@redhat.com>
In-Reply-To: <20240308230557.805580-1-alex.williamson@redhat.com>
References: <20240308230557.805580-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Currently for devices requiring masking at the irqchip for INTx, ie.
devices without DisINTx support, the IRQ is enabled in request_irq()
and subsequently disabled as necessary to align with the masked status
flag.  This presents a window where the interrupt could fire between
these events, resulting in the IRQ incrementing the disable depth twice.
This would be unrecoverable for a user since the masked flag prevents
nested enables through vfio.

Instead, invert the logic using IRQF_NO_AUTOEN such that exclusive INTx
is never auto-enabled, then unmask as required.

Cc: stable@vger.kernel.org
Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 237beac83809..136101179fcb 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -296,8 +296,15 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 
 	ctx->trigger = trigger;
 
+	/*
+	 * Devices without DisINTx support require an exclusive interrupt,
+	 * IRQ masking is performed at the IRQ chip.  The masked status is
+	 * protected by vdev->irqlock. Setup the IRQ without auto-enable and
+	 * unmask as necessary below under lock.  DisINTx is unmodified by
+	 * the IRQ configuration and may therefore use auto-enable.
+	 */
 	if (!vdev->pci_2_3)
-		irqflags = 0;
+		irqflags = IRQF_NO_AUTOEN;
 
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, vdev);
@@ -308,13 +315,9 @@ static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 		return ret;
 	}
 
-	/*
-	 * INTx disable will stick across the new irq setup,
-	 * disable_irq won't.
-	 */
 	spin_lock_irqsave(&vdev->irqlock, flags);
-	if (!vdev->pci_2_3 && ctx->masked)
-		disable_irq_nosync(pdev->irq);
+	if (!vdev->pci_2_3 && !ctx->masked)
+		enable_irq(pdev->irq);
 	spin_unlock_irqrestore(&vdev->irqlock, flags);
 
 	return 0;
-- 
2.44.0


