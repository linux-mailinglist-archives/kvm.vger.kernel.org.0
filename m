Return-Path: <kvm+bounces-11415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C16F6876DC5
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 00:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62917B2277A
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79997604DA;
	Fri,  8 Mar 2024 23:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hd8ZV/ak"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D87054775
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 23:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709939180; cv=none; b=LG+JSnYj4oSKqw2lIgX3kXqI34+gP5XFE2+LgkQOcPfb9Xr6RWr8qSY74vjjJhyYq5eol1JIolsVovvVkq1OXJiUFYU6HWNRlLEcMIihpr4Rw1+mE4AjU1NfT6wU/Fjxtds8I6unxzNujg6D9wpUAQjcoJ72pkPb+nm/T2zAlE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709939180; c=relaxed/simple;
	bh=xI6bQYs7D7L/1GayJOzEXbmk72qf1CYrvd8eI1QF5Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwQGYsmkIqClpOkTOCAufpLnmKRVZX1ESUVUJsnCYKjFL9Z2UoSXqrackwX8bjjysygk0kP/P4OG8gsNo0gxuXxn2iKxD50Rw9LGntt+MiuLjJtChMc3pZL/KLE4d0kRR0OJ57GchbTxOSRINZNOeZHJQrA44WYPnSRewYhita8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hd8ZV/ak; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709939178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N8jD+utIUIWsnb+QHB/Vd0dznqOHt9b4raUNDQiHScE=;
	b=hd8ZV/akANlZ5jRea7Y/r0DwDAQ5Y/fwXs+OaxArfPZRyfGf8DffQCGshvNthSV1jBfOnD
	6OsMveef3rxE38oXYa4pXmljuNmZnXcHQLXavvMR8ULU+wJxfz2J4pThHIekFO2U0i1XKv
	NFIAwwZLozPDezz1ulV5VnefTfexQUI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-YgeSMQxMPHK209lCwn6AMQ-1; Fri, 08 Mar 2024 18:06:14 -0500
X-MC-Unique: YgeSMQxMPHK209lCwn6AMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66973185A781;
	Fri,  8 Mar 2024 23:06:14 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.8.4])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C8CD47CB;
	Fri,  8 Mar 2024 23:06:13 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	kevin.tian@intel.com,
	diana.craciun@oss.nxp.com,
	stable@vger.kernel.org
Subject: [PATCH v2 7/7] vfio/fsl-mc: Block calling interrupt handler without trigger
Date: Fri,  8 Mar 2024 16:05:28 -0700
Message-ID: <20240308230557.805580-8-alex.williamson@redhat.com>
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

The eventfd_ctx trigger pointer of the vfio_fsl_mc_irq object is
initially NULL and may become NULL if the user sets the trigger
eventfd to -1.  The interrupt handler itself is guaranteed that
trigger is always valid between request_irq() and free_irq(), but
the loopback testing mechanisms to invoke the handler function
need to test the trigger.  The triggering and setting ioctl paths
both make use of igate and are therefore mutually exclusive.

The vfio-fsl-mc driver does not make use of irqfds, nor does it
support any sort of masking operations, therefore unlike vfio-pci
and vfio-platform, the flow can remain essentially unchanged.

Cc: Diana Craciun <diana.craciun@oss.nxp.com>
Cc: stable@vger.kernel.org
Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
index d62fbfff20b8..82b2afa9b7e3 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
@@ -141,13 +141,14 @@ static int vfio_fsl_mc_set_irq_trigger(struct vfio_fsl_mc_device *vdev,
 	irq = &vdev->mc_irqs[index];
 
 	if (flags & VFIO_IRQ_SET_DATA_NONE) {
-		vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (irq->trigger)
+			eventfd_signal(irq->trigger);
 
 	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
 		u8 trigger = *(u8 *)data;
 
-		if (trigger)
-			vfio_fsl_mc_irq_handler(hwirq, irq);
+		if (trigger && irq->trigger)
+			eventfd_signal(irq->trigger);
 	}
 
 	return 0;
-- 
2.44.0


