Return-Path: <kvm+bounces-33026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E959E3AD9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF989B2B471
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 12:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC5C1C4A10;
	Wed,  4 Dec 2024 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFomIgrP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9282203704
	for <kvm@vger.kernel.org>; Wed,  4 Dec 2024 12:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316918; cv=none; b=rbYL9ttc89S/H1AWAAdh8hyTphpl0/+oj93PVCy15nsar40b1O/RF+WfcxSKiVhrSO2X25wsbn31r+bU6MC3/oE7rNXgOEhSK14nz0TAHZ7NDTHwG4durHO/gWcKq5hoKfJVvws2WAFM9S2vCzpU0KOden8P1Gqv3Iu3NPoAEA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316918; c=relaxed/simple;
	bh=+kw0hVN/R7EKfAHQdf+parzKCkCR3tVH/e099GIq3Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us9O66wxvxh+TDjlD2ZoGXm8Iezf1hxewyIgDh4wVHJYuJHKNpFH5h6uXnlr20m6oclDyAkDtZKQxEp3/HfgItHZ6PYEPq/nfyKwR08tQMZkPjg0MZKaVuTXX8yeyRu2+3ECT9NbpG9QG3MATiO7Hut2BINuhLWeQEIinMInoPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFomIgrP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=na4vd6mThSkzeb6NVT06w3pd7mJ97fz8U44/x2n2hr0=;
	b=ZFomIgrPWyEqZA16QxQVbj5dj3zEpDpCeIbOYVdI+NAfyp9xYxh3X1AhNtLFyvnkbmEFEG
	Ex+Ys+DGTrpYQ6Euf8ZYRt2/fYi0lk3/4jzIuFgcQGOHAubOrQFxlxz+Vmm9AyzuVyC0oH
	Ot1SRxkma+T7Dz9WZpZHjMSYaHBpWzg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-9BvXodZ3N8SXRUFAqMX1kA-1; Wed, 04 Dec 2024 07:55:15 -0500
X-MC-Unique: 9BvXodZ3N8SXRUFAqMX1kA-1
X-Mimecast-MFC-AGG-ID: 9BvXodZ3N8SXRUFAqMX1kA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-434a51e44d0so55173055e9.3
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2024 04:55:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316913; x=1733921713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=na4vd6mThSkzeb6NVT06w3pd7mJ97fz8U44/x2n2hr0=;
        b=nktXKG7C994JIC2KWhRZFuxpfiE/oqDCXQsuW8XFK66p8bkYXjUpgLB7DkIo/5Bgyx
         r8xmS6fcUl2LN0vNQokRTCfECWcBY5+/DWyJoV1SR6R/5YRrSd4QHcJ49rKSLPg2GSIv
         M0r8LT7gaTmkCPP/Cl+wCi6ZHSWAB4BFDSQmftKT2VICzsEuCBZdDrIWB1tcL4JPrbhM
         o/YTgVvbDG02QIDrm5WyG/T/DWfMOp+ocsENeWFDANF1lBrgEVJROI5ZLZjsaRmwX5x3
         Ux5JWQ5VbOVAYSbKVvr/uhydmVjAru1WlXRf8V2784/a9l5uo5zeWiTd+kaqJE6U/PO1
         f2qA==
X-Forwarded-Encrypted: i=1; AJvYcCWWJu/zBCPBMOEONX6Tbnr3A13fDt+5OQtxnzRij0ll9uaox9qPsNPW88k+cu3cOMnBSaU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXV75VAAz5dj68OffWhAE8/MolYlbNzWSkgb4JUguTyDeIWrdA
	cpICfCH3jIStJv5HPaISUtNAxdaawn0WkVH8vf8S4yn7O2DLzZsHzFdsHwE9JynILBHFhhwQ+zd
	TMyY20uVo+cM2WCNvSssznb9m5pv5qfoOXuXDwzZnOw6DoGYo+A==
X-Gm-Gg: ASbGncsQUj/7eeuFpmOxjK9zCwnIy74Zcp6Oid7GreB8KRZgzjIUJUBpFCdcGnvT9xN
	/ZiGSdRCEyVOixomoqbY4W1/0PVtvTxH6jpEJxgRbYJxNNCgprAT1YSkKijpzt5CJYAroNvJlZ/
	TU/VC8Sv+hIgiCY9k00dc+p17HLF0DgT2djX5zLZd2BfYf0rPowTccTcZb+UdH+b+wxhl5liKW0
	5wtGkQtBltf8YjqcOn5TOIUUnINmWvmDJLys/aSrVJuDxnXmSxYUHjIdOUfieO3Y/q5QK2Wl0qU
	jstm3Zy4/qXl2awG7aHqj4vemhI531ubm/M=
X-Received: by 2002:a05:600c:3550:b0:434:a781:f5d5 with SMTP id 5b1f17b1804b1-434d0a15047mr62644285e9.30.1733316913739;
        Wed, 04 Dec 2024 04:55:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdVB6YFjtubaQuZKYqVl7K3swrZVKNM9mWRen9YVYSXicgBrRTJ3zdugRU4fK2CCWYQJl/Fg==
X-Received: by 2002:a05:600c:3550:b0:434:a781:f5d5 with SMTP id 5b1f17b1804b1-434d0a15047mr62643915e9.30.1733316913375;
        Wed, 04 Dec 2024 04:55:13 -0800 (PST)
Received: from localhost (p200300cbc70be10038d68aa111b0a20a.dip0.t-ipconnect.de. [2003:cb:c70b:e100:38d6:8aa1:11b0:a20a])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-385df488559sm15210226f8f.63.2024.12.04.04.55.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 04:55:12 -0800 (PST)
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
Subject: [PATCH v2 09/12] virtio-mem: mark device ready before registering callbacks in kdump mode
Date: Wed,  4 Dec 2024 13:54:40 +0100
Message-ID: <20241204125444.1734652-10-david@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241204125444.1734652-1-david@redhat.com>
References: <20241204125444.1734652-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.47.1


