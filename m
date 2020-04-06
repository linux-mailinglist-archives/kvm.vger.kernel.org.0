Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950241A0122
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 00:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDFW1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 18:27:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33446 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgDFW0r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 18:26:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586212007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=U/vFF5VpXdmJuvhGVtoAcxNjDn8Yk87a3t6GmWVVKJW6gY9fo+Ei6MevQc/8I0qh4LitRW
        /zglA5B++K0mdu5RAIDy8DsuK6jbwy+qzP/Astl6XkayEHxVRHXn8SOwCTRO+UCtJwehfB
        YFxDE5HwoaAnl6IzJEPcXMQ2g8a+rGg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-lKOMMDdFMCmSjOxjQhxSVQ-1; Mon, 06 Apr 2020 18:26:43 -0400
X-MC-Unique: lKOMMDdFMCmSjOxjQhxSVQ-1
Received: by mail-wm1-f69.google.com with SMTP id d134so317047wmd.0
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 15:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=R3dMc8xPkT10pW+4/SeNIwD7e9E3nkci2XqcIBa68B3H+PAHcNMSuzoV36msVDcvqO
         4NRO6v+XfbeQb02d8Rflsi6IE7LK/O6Cci7iv/Sgv0YXlRZh0RrC+5GBChniMPVIXqPu
         g9l7qk66pt+tjmmv4+bJ/7Ibq0/yPw+uFImSWN60FLa+q90NZGCmBkBisJV3qOgGdDkC
         stqSgwJBSeTbYo5ATg3r/qD1FHG3qGBfYewV5uVvqmM1vnQjOZFvjcic8WPvbgZDvO2Z
         m5x+4wyHrfyWsxYH+tOQlVW/44b4O1DvjBb/v4TjZprBaY3iQF3ZnDPBjfCJRzZn+3Vg
         65mw==
X-Gm-Message-State: AGi0PubA7deBXQhETwAQu3H12oLQJSan0QA/rTG+4do7F/OQrPzTSFGC
        KjZhWpmMC3vRQEkW48MG1+aCxa8gibBBqI/hItKc+qo6v6H0fvzmWf6X3+JXeK8xBOUst8PKyKi
        BXw5HuoQ6c8wP
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr1618541wml.55.1586212002445;
        Mon, 06 Apr 2020 15:26:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypJbM6FeH7VkbvEqYuHfim8CWxiQKaSSyipP1ZEG1ds7M2SyHjKH/nl5jukff0ySxHyaH4YMVA==
X-Received: by 2002:a7b:ca47:: with SMTP id m7mr1618523wml.55.1586212002230;
        Mon, 06 Apr 2020 15:26:42 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id h2sm1186449wmb.16.2020.04.06.15.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 15:26:41 -0700 (PDT)
Date:   Mon, 6 Apr 2020 18:26:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v6 06/12] vhost: force spec specified alignment on types
Message-ID: <20200406222507.281867-7-mst@redhat.com>
References: <20200406222507.281867-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406222507.281867-1-mst@redhat.com>
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
 drivers/vhost/vhost.h       |  6 +++---
 include/linux/virtio_ring.h | 24 +++++++++++++++++++++---
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f8403bd46b85..60cab4c78229 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -67,9 +67,9 @@ struct vhost_virtqueue {
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
 	struct file *kick;
 	struct eventfd_ctx *call_ctx;
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 11680e74761a..c3f9ca054250 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -60,14 +60,32 @@ static inline void virtio_store_mb(bool weak_barriers,
 struct virtio_device;
 struct virtqueue;
 
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
+typedef struct vring_desc __aligned(VRING_DESC_ALIGN_SIZE) vring_desc_t;
+typedef struct vring_avail __aligned(VRING_AVAIL_ALIGN_SIZE) vring_avail_t;
+typedef struct vring_used __aligned(VRING_USED_ALIGN_SIZE) vring_used_t;
+
 struct vring {
 	unsigned int num;
 
-	struct vring_desc *desc;
+	vring_desc_t *desc;
 
-	struct vring_avail *avail;
+	vring_avail_t *avail;
 
-	struct vring_used *used;
+	vring_used_t *used;
 };
 
 /*
-- 
MST

