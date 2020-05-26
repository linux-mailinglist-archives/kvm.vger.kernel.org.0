Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7361AD81C
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 10:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgDQH7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 03:59:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58082 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729112AbgDQH7o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 03:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587110382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=pttTsXfJsO5qd96fUX4GjjyN7BeuHWmaGEZtAEZg4sw=;
        b=e95iTkLHqziq04e8cy8zr6wrbYPcnJUpfdkK+Ed9TORbj18pp5butqPNjwUhYgSJXGKnog
        dll6KB4+D1A9PHUwFcBA48ZLMt29VsCRZAIoSR3jme41jQk/beHvw6NHzlkQ69MHoHE8Gl
        BaWVAHUSD6ZUE3jo+RhKVvdgdcj+ETs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-F5g3znBZMXu1bPCwuQep4w-1; Fri, 17 Apr 2020 03:59:39 -0400
X-MC-Unique: F5g3znBZMXu1bPCwuQep4w-1
Received: by mail-wr1-f72.google.com with SMTP id y1so605086wrp.5
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 00:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=pttTsXfJsO5qd96fUX4GjjyN7BeuHWmaGEZtAEZg4sw=;
        b=EI6FiF1/EE9BZHgJ2oKbj0O5gN3fH8GDtmCiLzbARD5edzk0jpm0gdIXWnTb/BUbdR
         SrMEwAbFHDfQdy+zqkiWTYC4JNJ69tmavFSvgbptlg2A2inzMejmeKKyos5Cclw8jZlo
         i+S7lEcxAYLsJUeAC+PQLEoPaFDSS0qp3N1+djahuIIlwfvXtiCzUCFGiC3OT2x+CDJy
         Go+EkFGBCe+axzLMyuLjf0zE/N6prBsb7L7N3BBRxfYf1IwqdR/NhtXuDZFn4eR2g95o
         W1wG+co40NWKWoK+0Qdlv7CK76srkLida4G+3Y4P5X2VFieqkLyKNIUVy5RkmoalnCn+
         6hQw==
X-Gm-Message-State: AGi0PuaiXSH3QXzaiVz6ZqH56UoLIyRy6Q4h+I1Kn7Sew8Rmm2imXzjH
        xLjAkGEKekRqjqd/Z8TpeG4Gbr41/duaLlaHksCT4rrxZJgBi+W/uWK9LZlYGkkGw9cf3Oa6oQM
        /X0G4S20efkFC
X-Received: by 2002:a1c:9d84:: with SMTP id g126mr1898736wme.184.1587110378073;
        Fri, 17 Apr 2020 00:59:38 -0700 (PDT)
X-Google-Smtp-Source: APiQypL7JfXhE5vFVj1kJeWaNlkc8YDs13yjfj3N/sFo8oSVy/wgjrWfOFrSOQ9Dg05aWCm/T5Fq4A==
X-Received: by 2002:a1c:9d84:: with SMTP id g126mr1898718wme.184.1587110377796;
        Fri, 17 Apr 2020 00:59:37 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id o28sm16416939wra.84.2020.04.17.00.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 00:59:37 -0700 (PDT)
Date:   Fri, 17 Apr 2020 03:59:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v9] virtio: force spec specified alignment on types
Message-ID: <20200417075551.12291-1-mst@redhat.com>
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

Note that userspace that allocates the memory is actually OK and does
not need to be fixed, but userspace that gets it from guest or another
process does need to be fixed. The later doesn't generally talk to the
kernel so while it might be buggy it's not talking to the kernel in the
buggy way - it's just using the header in the buggy way - so fixing
header and asking userspace to recompile is the best we can do.

I verified that the produced kernel binary on x86 is exactly identical
before and after the change.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I am still not sure this is even needed. Does compiler make
optimizations based on ABI alignment assumptions?


Changes from v8:
	- better commit log
	- go back to vring in UAPI

 drivers/vhost/vhost.h            |  6 ++---
 include/uapi/linux/virtio_ring.h | 38 +++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 13 deletions(-)

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
diff --git a/include/uapi/linux/virtio_ring.h b/include/uapi/linux/virtio_ring.h
index 9223c3a5c46a..177227f0d9cd 100644
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
@@ -135,6 +125,34 @@ struct vring {
 #define VRING_USED_ALIGN_SIZE 4
 #define VRING_DESC_ALIGN_SIZE 16
 
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
 #ifndef VIRTIO_RING_NO_LEGACY
 
 /* The standard layout for the ring is a continuous chunk of memory which looks
-- 
MST

