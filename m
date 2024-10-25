Return-Path: <kvm+bounces-29733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16EE89B07DE
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 17:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93FACB29483
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 15:20:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8352021A4DA;
	Fri, 25 Oct 2024 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFgtw71n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF20621A4D1
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 15:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729869288; cv=none; b=QeWV6OuMCLN/o3+qaj8e1qgcJlbwwohTU4ht1flSAyxjIYbUj9gNsB0O9ns7BwLqjb484O16wrhqZmcjsGHCTqy7CQourEaOPKy96f1RWpPafULID50rIHvI2PHVDwzPYXzGx0MetcOh1C8HQ4elml9IcC3aVCGfEI9QAFQVAPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729869288; c=relaxed/simple;
	bh=Lbj/6ZDYkPFZxCNambrPjgDOlmbT2PYTi20WVpcLMzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qe0Grxoq6g19LEkGAxJlJZGkshB4uTRL/HGdXG6wofTO52oCl9EUH//77STpO8RL6y17xbNwM/dFnvP6dNRiAtKaBSK/jgefJHQGivgwTVP5gtKvjcP96YbzdaUakaUiERs4gFpQAhl/Pswvm5rJ6NUj/kJhUBTlFwaCJ3R/MYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFgtw71n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729869285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ACGdF21cKkvnMHoeXpjOJK7M5S4ojlG1Lcv7sY6UCa8=;
	b=AFgtw71nPiM9DTCs2WzBEGHUojiPIA+/1CrckALFoVmNCNE69+YKM77B8+ldk9gKAkMibx
	TWh6o+YKknz5g7kg3IDp0tSB+rkSs/e2ZVEawzDEIQcmSQNPun1K4Ji8iCGp2i8ZtnOKmg
	JinW6n3dMKayabFiZC0BfZvBgAanMbc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-JyKffLwLP4WOg7IrO6F-yg-1; Fri,
 25 Oct 2024 11:12:58 -0400
X-MC-Unique: JyKffLwLP4WOg7IrO6F-yg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC5061955F35;
	Fri, 25 Oct 2024 15:12:53 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.65.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93CD030001A7;
	Fri, 25 Oct 2024 15:12:45 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kexec@lists.infradead.org,
	David Hildenbrand <david@redhat.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v1 08/11] virtio-mem: mark device ready before registering callbacks in kdump mode
Date: Fri, 25 Oct 2024 17:11:30 +0200
Message-ID: <20241025151134.1275575-9-david@redhat.com>
In-Reply-To: <20241025151134.1275575-1-david@redhat.com>
References: <20241025151134.1275575-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

After the callbacks are registered we may immediately get a callback. So
mark the device ready before registering the callbacks.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/virtio/virtio_mem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index b0b871441578..126f1d669bb0 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2648,6 +2648,7 @@ static int virtio_mem_init_hotplug(struct virtio_mem *vm)
 	if (rc)
 		goto out_unreg_pm;
 
+	virtio_device_ready(vm->vdev);
 	return 0;
 out_unreg_pm:
 	unregister_pm_notifier(&vm->pm_notifier);
@@ -2729,6 +2730,8 @@ static bool virtio_mem_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 
 static int virtio_mem_init_kdump(struct virtio_mem *vm)
 {
+	/* We must be prepared to receive a callback immediately. */
+	virtio_device_ready(vm->vdev);
 #ifdef CONFIG_PROC_VMCORE
 	dev_info(&vm->vdev->dev, "memory hot(un)plug disabled in kdump kernel\n");
 	vm->vmcore_cb.pfn_is_ram = virtio_mem_vmcore_pfn_is_ram;
@@ -2870,8 +2873,6 @@ static int virtio_mem_probe(struct virtio_device *vdev)
 	if (rc)
 		goto out_del_vq;
 
-	virtio_device_ready(vdev);
-
 	/* trigger a config update to start processing the requested_size */
 	if (!vm->in_kdump) {
 		atomic_set(&vm->config_changed, 1);
-- 
2.46.1


