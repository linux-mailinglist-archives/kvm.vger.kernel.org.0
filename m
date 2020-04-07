Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5421A0404
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 03:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDGBH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 21:07:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29702 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726659AbgDGBHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 21:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586221674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=FoIXAgI5OWoA2jtao11ABKn7i0yKHhLWShNWQidugju9gptmfDJxOgQuxG7GoF8Uw99NWi
        3NrEIjJwI9EMVTpRKt+jfiK8Na2Q5Z4/PUEXpIHif0/qmyIOiUpOIq6obboECVIAJeQwdA
        mcz1p8bM7T5bk/xcbFGciGK4MIQSLLI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-BLxZWCsaPZSa0tmgwk5y8g-1; Mon, 06 Apr 2020 21:07:50 -0400
X-MC-Unique: BLxZWCsaPZSa0tmgwk5y8g-1
Received: by mail-wr1-f70.google.com with SMTP id 91so864874wro.1
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 18:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=AI0wjgAFO1rFAjFQERpfdWO4InUieslzYRdn/4YBb4NuVlqZd80rhxXqJWYI8Tn3zr
         ZHTI8mupt+cryqrMXZ7uXwwe4NkI+gKWxXI5GgNp+uXAsV35UlL4DrUHntEKpztw0vsI
         /7dutoremu9XihvGhOIahQRn1zaDOxdnhe61QLChF4dNkwYfw+aJ2BCcite8/dq+Ne5I
         gmUOGpnR0omg9mEezAUfEtKFkXwOhHHUG10HXBT5V8ENHWxhTe5F3oLNEueR1c0b6oii
         UtG0Bp5SUhzew3E7beMi+bgbUbOdkhLWcZZax5nXd/hysJ+WvRpHGO1iGARv4NI7Hpwy
         jJAg==
X-Gm-Message-State: AGi0PuY8VJolNDHNuzNiLzvz1obiYGC/VsHvjnulZ4yD8nfhsx7Yg51F
        LbQGizI5V3SEEhJmP/w0qyVsVQCeL7oYwplQFI5C9kuK4uHya+f/WUkV+2TV0jHLevnJrZkTfgT
        1kUW9NsO8YGL3
X-Received: by 2002:adf:f98b:: with SMTP id f11mr1998832wrr.259.1586221669692;
        Mon, 06 Apr 2020 18:07:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ7vAsHxvjmiu+bo7NHbyExOgBSbxXMZd7IkvuAC9tnfoRSEzkPJmWDYEX8+2JgtuNqELnN8w==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr1998816wrr.259.1586221669436;
        Mon, 06 Apr 2020 18:07:49 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id j11sm28630487wrt.14.2020.04.06.18.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 18:07:48 -0700 (PDT)
Date:   Mon, 6 Apr 2020 21:07:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v7 10/19] vhost: force spec specified alignment on types
Message-ID: <20200407010700.446571-11-mst@redhat.com>
References: <20200407010700.446571-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407010700.446571-1-mst@redhat.com>
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

