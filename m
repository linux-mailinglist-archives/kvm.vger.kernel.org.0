Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB3D19F619
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 14:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgDFMvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 08:51:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728143AbgDFMvD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 08:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586177462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7A/JZx9mU7o1VoLWOXJ3u/SJqb7Gm6YpvdN2hJBccMY=;
        b=eMHmHx30CqfaGnkyucLNlUoVZj2nZjiM/6Xu7BH02W7aJDgBJ1xzgp5XElhM7+lnQLi0QG
        Rop0oxdvVCzNj+oLsijnERqJ44qDakQ/tftvCDQ3iJ+Nuf0eozgiHk2UOE09RGXMCjc/uf
        +s8kkJoSdB7yTi0/vctv8lEdZMqXj8U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-xf0bgGLnMeC5pb-ZfV13ig-1; Mon, 06 Apr 2020 08:50:59 -0400
X-MC-Unique: xf0bgGLnMeC5pb-ZfV13ig-1
Received: by mail-wr1-f69.google.com with SMTP id h14so8291058wrr.12
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 05:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7A/JZx9mU7o1VoLWOXJ3u/SJqb7Gm6YpvdN2hJBccMY=;
        b=Ucci1PZ6YFV+S707+Qf4CWycW4KXKlJ0cNX03HOJaQoaAuz0Lot6qYjVDmHDiB7U29
         3VKVOR9KCOnEuZD4ZTi5Vdz0kduJf7Ca/Mz4XQtmXDL+vC1fLwsdBb4vW7VZe/nFQbvs
         jfpy5XJVMt/MMpzOGB7HP0I31Q6cF5pW7R9/rMyB+LStVkGz8YKkniPIaEcr75whokC1
         6rw2S0Hikzx8n+I9pVsUKTVeq00oW4tcndfY1P7Lw8uCi/bmgr2E0sAZBYaq4RvQw729
         S+AsDD2w7aL44lqKmwTTsY7iVyRJ0n2Jm80iqC+LQDeOWfy4Pm8/AA6R95Y9ieNT7ZIh
         NExQ==
X-Gm-Message-State: AGi0PuZgeAdVkZAvde8cQqsSWyqPXDQ+FNRN/3hFzmVKYsQ76bfWniuc
        gXSXev90KVTsG/0RT4a/wdpQkgGLqdyZLLuVneSuxGI9U0ocqF9IfZYDjBFZEnuwWOBvYlrU3vZ
        j/yQh8nwRwfqP
X-Received: by 2002:adf:81b6:: with SMTP id 51mr17298391wra.229.1586177457395;
        Mon, 06 Apr 2020 05:50:57 -0700 (PDT)
X-Google-Smtp-Source: APiQypI7/DS77HBZ8L/FNXyj60fPbTTo/BHYI/NHwMQ/9pXpk2TSq6zGsv9CKDz2v5JeoEWm2YjQcw==
X-Received: by 2002:adf:81b6:: with SMTP id 51mr17298368wra.229.1586177457169;
        Mon, 06 Apr 2020 05:50:57 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id y22sm7895262wma.0.2020.04.06.05.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 05:50:56 -0700 (PDT)
Date:   Mon, 6 Apr 2020 08:50:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost: force spec specified alignment on types
Message-ID: <20200406124931.120768-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ring element addresses are passed between components with different
alignments assumptions. Thus, if guest/userspace selects a pointer and
host then gets and dereferences it, we might need to decrease the
compiler-selected alignment to prevent compiler on the host from
assuming pointer is aligned.

This actually triggers on ARM with -mabi=apcs-gnu - which is a
deprecated configuration, but it seems safer to handle this
generally.

I verified that the produced binary is exactly identical on x86.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is my preferred way to handle the ARM incompatibility issues
(in preference to kconfig hacks).
I will push this into next now.
Comments?

 drivers/vhost/vhost.h            |  6 ++---
 include/uapi/linux/virtio_ring.h | 41 ++++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index cc82918158d2..a67bda9792ec 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -74,9 +74,9 @@ struct vhost_virtqueue {
 	/* The actual ring of buffers. */
 	struct mutex mutex;
 	unsigned int num;
-	struct vring_desc __user *desc;
-	struct vring_avail __user *avail;
-	struct vring_used __user *used;
+	vring_desc_t __user *desc;
+	vring_avail_t __user *avail;
+	vring_used_t __user *used;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
 
 	struct vhost_desc *descs;
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 559f42e73315..cd6e0b2eaf2f 100644
--- a/include/uapi/linux/virtio_ring.h
+++ b/include/uapi/linux/virtio_ring.h
@@ -118,16 +118,6 @@ struct vring_used {
 	struct vring_used_elem ring[];
 };
 
-struct vring {
-	unsigned int num;
-
-	struct vring_desc *desc;
-
-	struct vring_avail *avail;
-
-	struct vring_used *used;
-};
-
 /* Alignment requirements for vring elements.
  * When using pre-virtio 1.0 layout, these fall out naturally.
  */
@@ -164,6 +154,37 @@ struct vring {
 #define vring_used_event(vr) ((vr)->avail->ring[(vr)->num])
 #define vring_avail_event(vr) (*(__virtio16 *)&(vr)->used->ring[(vr)->num])
 
+/*
+ * The ring element addresses are passed between components with different
+ * alignments assumptions. Thus, we might need to decrease the compiler-selected
+ * alignment, and so must use a typedef to make sure the __aligned attribute
+ * actually takes hold:
+ *
+ * https://gcc.gnu.org/onlinedocs//gcc/Common-Type-Attributes.html#Common-Type-Attributes
+ *
+ * When used on a struct, or struct member, the aligned attribute can only
+ * increase the alignment; in order to decrease it, the packed attribute must
+ * be specified as well. When used as part of a typedef, the aligned attribute
+ * can both increase and decrease alignment, and specifying the packed
+ * attribute generates a warning.
+ */
+typedef struct vring_desc __attribute__((aligned(VRING_DESC_ALIGN_SIZE)))
+	vring_desc_t;
+typedef struct vring_avail __attribute__((aligned(VRING_AVAIL_ALIGN_SIZE)))
+	vring_avail_t;
+typedef struct vring_used __attribute__((aligned(VRING_USED_ALIGN_SIZE)))
+	vring_used_t;
+
+struct vring {
+	unsigned int num;
+
+	vring_desc_t *desc;
+
+	vring_avail_t *avail;
+
+	vring_used_t *used;
+};
+
 static inline void vring_init(struct vring *vr, unsigned int num, void *p,
 			      unsigned long align)
 {
-- 
MST

