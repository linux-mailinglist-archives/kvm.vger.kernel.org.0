Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07789165E37
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgBTNGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728173AbgBTNGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epBBiJe/BiipnhOxinjfU345ql1651dsm1KJ2Eg1l+8=;
        b=bfjYoYQIdvSUNJgcPnZ+No7RJ0AOQUmt/GNL1KJR5bYTbYtEcQ/b8PYDmPmpp8p0XSy4LT
        O53drFKihzHqfpQAF2n1Qf+4uMGT0x5yZIiSL1z6dwOPqEzrARgcv4a5/gp2tCxIzK/Z6t
        WAOVEanOnP9y+U02rKOsYk03yOxaA+0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-2uZLGHPBMuqj9zUDjaCzNA-1; Thu, 20 Feb 2020 08:06:48 -0500
X-MC-Unique: 2uZLGHPBMuqj9zUDjaCzNA-1
Received: by mail-wr1-f69.google.com with SMTP id v17so1691267wrm.17
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epBBiJe/BiipnhOxinjfU345ql1651dsm1KJ2Eg1l+8=;
        b=aXRPvLdjYN6+CCGkYvnWDXbvJZDhlfT1QMgKTcGVhaoDPtCEWGziZf2p3X+bwMwDyo
         FQ5L8Sk5RYe7sfNCG9Uf3lCwusBJJmvafRN7EuwxdozjYAlsOWuBvRQFSB3LAzc426+K
         PHKI6cqrJSKBtRZnlmE2cZ7DSXFqQOolPfq4ENOIViMYRashvpsN8T10ZgP5Th3hO545
         qlQvNmrbM/NZCccoMrSif9CiXqIu0QeU2voQ2s92JsDVjSfivJJ6F+/nDRDgbUlkS+sG
         RasaYR7qqpjRq3Mo9HiwAlcf+tb2euZTz6vIarKWy+NfFqv1sIBax5USUN3cgBSUifAF
         BOjQ==
X-Gm-Message-State: APjAAAVApOnlg2XirYaMlIIthjTvcrKPQBh9C1b+sfECexxDa1rtUK6+
        9WySm4fqgn9MGZSjQE6X45dr3/u7Zxwa4BbQnEikNh0LCTy3RacntO1LkTT0/oOFuAZUHqka95W
        cTU9/G7BqcUHa
X-Received: by 2002:a05:600c:295d:: with SMTP id n29mr4504811wmd.101.1582204006819;
        Thu, 20 Feb 2020 05:06:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyzyX5Y7gdzaTOQjQ/rcWnepNEp6tk5YfOUODjdV1i7lhwV6s1r0NC2sbtsj+sn6/vQEc+xMg==
X-Received: by 2002:a05:600c:295d:: with SMTP id n29mr4504765wmd.101.1582204006470;
        Thu, 20 Feb 2020 05:06:46 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:45 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 14/20] hw/virtio: Let vhost_memory_map() use a boolean 'is_write' argument
Date:   Thu, 20 Feb 2020 14:05:42 +0100
Message-Id: <20200220130548.29974-15-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'is_write' argument is either 0 or 1.
Convert it to a boolean type.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/virtio/vhost.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 9edfadc81d..0d226dae10 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -294,7 +294,7 @@ static int vhost_dev_has_iommu(struct vhost_dev *dev)
 }
 
 static void *vhost_memory_map(struct vhost_dev *dev, hwaddr addr,
-                              hwaddr *plen, int is_write)
+                              hwaddr *plen, bool is_write)
 {
     if (!vhost_dev_has_iommu(dev)) {
         return cpu_physical_memory_map(addr, plen, is_write);
@@ -1012,21 +1012,21 @@ static int vhost_virtqueue_start(struct vhost_dev *dev,
 
     vq->desc_size = s = l = virtio_queue_get_desc_size(vdev, idx);
     vq->desc_phys = a;
-    vq->desc = vhost_memory_map(dev, a, &l, 0);
+    vq->desc = vhost_memory_map(dev, a, &l, false);
     if (!vq->desc || l != s) {
         r = -ENOMEM;
         goto fail_alloc_desc;
     }
     vq->avail_size = s = l = virtio_queue_get_avail_size(vdev, idx);
     vq->avail_phys = a = virtio_queue_get_avail_addr(vdev, idx);
-    vq->avail = vhost_memory_map(dev, a, &l, 0);
+    vq->avail = vhost_memory_map(dev, a, &l, false);
     if (!vq->avail || l != s) {
         r = -ENOMEM;
         goto fail_alloc_avail;
     }
     vq->used_size = s = l = virtio_queue_get_used_size(vdev, idx);
     vq->used_phys = a = virtio_queue_get_used_addr(vdev, idx);
-    vq->used = vhost_memory_map(dev, a, &l, 1);
+    vq->used = vhost_memory_map(dev, a, &l, true);
     if (!vq->used || l != s) {
         r = -ENOMEM;
         goto fail_alloc_used;
-- 
2.21.1

