Return-Path: <kvm+bounces-11413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0B0876DC1
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 00:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC53228239A
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AF34BA88;
	Fri,  8 Mar 2024 23:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LDwwbYJl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F424CB24
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 23:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709939178; cv=none; b=o/Q2YQsloAA4grKZd8033/rPK0COr3UvjdWU830gK22eTm2m+/cgptRYNauqoLfVgSkVhe9lW+vJu2G3s85F1c2dQ/g01nyo9TtX25TYNo0057PAC4PiPEE0VERd/u/v6esirMUQ4xJfxumYoSkB14PnCF90/qxOxpCnNd6k0Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709939178; c=relaxed/simple;
	bh=xe/gkZ/Xvg/uXlto0Dtj8eqOvEjluTFaDYjfd6lHxrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5WnDs/Y3YpYJcVpVahkhUGGlUM8AkLbL1WygDqG0oZxoKYvcENY3L/FHNOz1GdyBCR+/+U6qrJu+F137+fNRN3Xc63t64WdAJsrOcTGzYuh4p6a++SHT30sLQHy/E5dV2eaYO4vTUGcQifYeVd/NoMO0gaF2wVOKnvntiEstnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LDwwbYJl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709939175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1dEKfErNXa51Ijqh6RZq2oy2pBONTNUJTZpcaMjJ9JU=;
	b=LDwwbYJl23kPdgPzkwQZx80azGl4pzvjIk2jKMPCxmKsE819Dp85PAbY0YJvbJn9BzyU4d
	jFU/qVLjJtQHOq7YxwHeMCgDHhpIGDQmLn4Hz/nSBp5sUk2xhbtZTP1ARIe9zIknDHCZSu
	ANsj9taBiDPEO5CK3ec/vcuI7OPDckI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-AtEUu7PaO76Jg_z-aNWO4g-1; Fri,
 08 Mar 2024 18:06:12 -0500
X-MC-Unique: AtEUu7PaO76Jg_z-aNWO4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A37EB3801F50;
	Fri,  8 Mar 2024 23:06:11 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.8.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B69F47CB;
	Fri,  8 Mar 2024 23:06:10 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	kevin.tian@intel.com,
	stable@vger.kernel.org
Subject: [PATCH v2 5/7] vfio/platform: Disable virqfds on cleanup
Date: Fri,  8 Mar 2024 16:05:26 -0700
Message-ID: <20240308230557.805580-6-alex.williamson@redhat.com>
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

irqfds for mask and unmask that are not specifically disabled by the
user are leaked.  Remove any irqfds during cleanup

Cc: Eric Auger <eric.auger@redhat.com>
Cc: stable@vger.kernel.org
Fixes: a7fa7c77cf15 ("vfio/platform: implement IRQ masking/unmasking via an eventfd")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/platform/vfio_platform_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index 61a1bfb68ac7..e5dcada9e86c 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -321,8 +321,11 @@ void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev)
 {
 	int i;
 
-	for (i = 0; i < vdev->num_irqs; i++)
+	for (i = 0; i < vdev->num_irqs; i++) {
+		vfio_virqfd_disable(&vdev->irqs[i].mask);
+		vfio_virqfd_disable(&vdev->irqs[i].unmask);
 		vfio_set_trigger(vdev, i, -1, NULL);
+	}
 
 	vdev->num_irqs = 0;
 	kfree(vdev->irqs);
-- 
2.44.0


