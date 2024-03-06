Return-Path: <kvm+bounces-11198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 600EF8741C3
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 115101F233C7
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 21:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB481CAB1;
	Wed,  6 Mar 2024 21:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TSAwVOCL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EF31C6B9
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 21:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759710; cv=none; b=JYO/a7qB5H4wrc3V8WbWDt507rP9qW77aHHqMt2qAeZbesSLTWPbi50nRKMrIZSore5VP76cwIZmtXXgkCn04jATdjk0tuPUoG2bHqkQXwm1yL4mX20/HI2Ywajgghot+Y06f/zqPNh//lVxU2j/t3COTKKy8/SAM+aGtb+tstU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759710; c=relaxed/simple;
	bh=DcVKXTML5ywo+4G+K2NpqKcgjW37poRbZY0R6kODpyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgJoKCOIwKa/PmAabCZOCXxbkc79JUm8FP+Or9d6MwrQvmM4R4Hzq/ue4nZrGhxk9YpKCkm/N0LJk9+OgmC03OWN+1kVCC/dQvctzF5z6poUkBFN0YNrpI+E2D8wQezyysBULObhM9gno06ft5K3ZnIKowHkEAOmDmQgXZ58gJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TSAwVOCL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709759707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uvV/nDuM+sweXjvIC5LuTFavoYDPU4njYTvMMtNtIIo=;
	b=TSAwVOCL7J3JIlOOuK/810LMfmssxzT1U6v3jZDaMt2+az2dlNmNZvNCnI0xuQsirYnlOR
	kZxoBgadm76jBR+BpaXZGw8hdeBvLfrj+9MuSBSrZxrGjTtuDi4se/BAAnJLQdqIVlweob
	L9ZfZ3JaocG4I18mZl+A6ThKWkscFW4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-Q7XHd1CCMGiyPq3ivckN0w-1; Wed,
 06 Mar 2024 16:15:04 -0500
X-MC-Unique: Q7XHd1CCMGiyPq3ivckN0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6DCC1C05158;
	Wed,  6 Mar 2024 21:15:03 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.99])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E05B537F6;
	Wed,  6 Mar 2024 21:15:02 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	kevin.tian@intel.com,
	diana.craciun@oss.nxp.com
Subject: [PATCH 7/7] vfio/fsl-mc: Block calling interrupt handler without trigger
Date: Wed,  6 Mar 2024 14:14:42 -0700
Message-ID: <20240306211445.1856768-8-alex.williamson@redhat.com>
In-Reply-To: <20240306211445.1856768-1-alex.williamson@redhat.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
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
2.43.2


