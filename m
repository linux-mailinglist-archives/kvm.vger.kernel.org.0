Return-Path: <kvm+bounces-11195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F208741BC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 22:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AD10283F2C
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 21:16:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6AA91BF50;
	Wed,  6 Mar 2024 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJp5euWW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D432199B8
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 21:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709759705; cv=none; b=OGJ3fUMhcptdvvVi98NQazZWjRitIHsxVnQlwDrgY/y0Rtkve7ykZk3CsHY5BJKSM4VvKuAYkrjT/iiYdpAVUqcprLhxGN8NfO9v1u6rl3o7uxlRmLtwoXB4B08DIV1hMxiF4SrdWAXXzj1790A3Qf7jz7Yn6KjRfq8m9ELVyzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709759705; c=relaxed/simple;
	bh=D2yIXi1cNFatDN4AMLhc2EG0QIC82n7Rj5sVvpduZxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFIPfxy7rcPH+/jJ2rS//nEK91gO5Eqbd+1P5SyGDhMiLEpO1yqIEEkVb1opmRjaVSPzOHMF0jVyCzlmApTuHccuu4QhXjpt6hH6TnRo/JfUYF3tzoUP1g9vbYzHfqUhQSjjYhib4e7U5fPNG1MTvVJlGoojXQ/65xH9CRcNBiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJp5euWW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709759703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDfr6JApE6M6vR70p+7pNdv7yPYVrak+rCur7geADS4=;
	b=DJp5euWWYeXPqM0KXSPhWPTfGID9YLnNU8OZJaJfbpfdxG11inW7WsydaAnBRNN2g0wgV1
	pPZPyGfiCcTeTH4pa+mjqLwxBow1ZuY8DJXhI6XooXE1mnYxAQwteMpq9ZOe5B06D/jvgE
	j+OxGEN2Wv/uFsICpBZGjpGCjq6mLYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-VTUcXdvKPTWljKjpHOEn7g-1; Wed, 06 Mar 2024 16:14:59 -0500
X-MC-Unique: VTUcXdvKPTWljKjpHOEn7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7502185A781;
	Wed,  6 Mar 2024 21:14:58 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.99])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC3A237FC;
	Wed,  6 Mar 2024 21:14:57 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	eric.auger@redhat.com,
	clg@redhat.com,
	reinette.chatre@intel.com,
	linux-kernel@vger.kernel.org,
	kevin.tian@intel.com
Subject: [PATCH 3/7] vfio: Introduce interface to flush virqfd inject workqueue
Date: Wed,  6 Mar 2024 14:14:38 -0700
Message-ID: <20240306211445.1856768-4-alex.williamson@redhat.com>
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

In order to synchronize changes that can affect the thread callback,
introduce an interface to force a flush of the inject workqueue.  The
irqfd pointer is only valid under spinlock, but the workqueue cannot
be flushed under spinlock.  Therefore the flush work for the irqfd is
queued under spinlock.  The vfio_irqfd_cleanup_wq workqueue is re-used
for queuing this work such that flushing the workqueue is also ordered
relative to shutdown.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/virqfd.c | 21 +++++++++++++++++++++
 include/linux/vfio.h  |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
index 29c564b7a6e1..532269133801 100644
--- a/drivers/vfio/virqfd.c
+++ b/drivers/vfio/virqfd.c
@@ -101,6 +101,13 @@ static void virqfd_inject(struct work_struct *work)
 		virqfd->thread(virqfd->opaque, virqfd->data);
 }
 
+static void virqfd_flush_inject(struct work_struct *work)
+{
+	struct virqfd *virqfd = container_of(work, struct virqfd, flush_inject);
+
+	flush_work(&virqfd->inject);
+}
+
 int vfio_virqfd_enable(void *opaque,
 		       int (*handler)(void *, void *),
 		       void (*thread)(void *, void *),
@@ -124,6 +131,7 @@ int vfio_virqfd_enable(void *opaque,
 
 	INIT_WORK(&virqfd->shutdown, virqfd_shutdown);
 	INIT_WORK(&virqfd->inject, virqfd_inject);
+	INIT_WORK(&virqfd->flush_inject, virqfd_flush_inject);
 
 	irqfd = fdget(fd);
 	if (!irqfd.file) {
@@ -213,3 +221,16 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
 	flush_workqueue(vfio_irqfd_cleanup_wq);
 }
 EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
+
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&virqfd_lock, flags);
+	if (*pvirqfd && (*pvirqfd)->thread)
+		queue_work(vfio_irqfd_cleanup_wq, &(*pvirqfd)->flush_inject);
+	spin_unlock_irqrestore(&virqfd_lock, flags);
+
+	flush_workqueue(vfio_irqfd_cleanup_wq);
+}
+EXPORT_SYMBOL_GPL(vfio_virqfd_flush_thread);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 89b265bc6ec3..8b1a29820409 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -356,6 +356,7 @@ struct virqfd {
 	wait_queue_entry_t		wait;
 	poll_table		pt;
 	struct work_struct	shutdown;
+	struct work_struct	flush_inject;
 	struct virqfd		**pvirqfd;
 };
 
@@ -363,5 +364,6 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
 		       void (*thread)(void *, void *), void *data,
 		       struct virqfd **pvirqfd, int fd);
 void vfio_virqfd_disable(struct virqfd **pvirqfd);
+void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
 
 #endif /* VFIO_H */
-- 
2.43.2


