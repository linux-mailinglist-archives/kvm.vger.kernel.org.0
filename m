Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF119FFD3
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 23:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgDFVCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 17:02:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34279 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbgDFVCM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 17:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586206931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=XmIRmsiUZ3I7KTvTmU6YIlZygfvw1JUzx7vTeNey3LWmMGJuK063rnD2YNpb8nG2LgfW1E
        MX2g9E0xGPawA0p1g7z1IhsmxUHWYxiXNh9eS9MkH7aMbm5O4FuvRysOEwS0K2N7ncr/hb
        +Z4CFQ6T/Njq1WxLIlMrqH7qgbFTNJc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-TKcM3NOlNbqHxO3ajLTgdw-1; Mon, 06 Apr 2020 17:02:07 -0400
X-MC-Unique: TKcM3NOlNbqHxO3ajLTgdw-1
Received: by mail-wr1-f71.google.com with SMTP id c8so512654wru.20
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 14:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+P99eoGOE59dzJri6nDdYTRF/iHp1rUM821OiEBSWI=;
        b=pwCmTK+LHt8OQHZmhky794f8Qa4Gm/fMXY5OZkzQMGPePQLDMUMEuSY4w0t8ZctWOm
         GmNTPCkrFhQExg47MeIyq1oiG0PEV62K+xa/moY3bZiyRyXL0HBR/m+qjfFfKT26gOEt
         Zxi9MJrQFg5EoE1axqePlwu1dDc9LlmU8mfBj0dQVBlcNjI1ChP6PhfU8Uis/Z6NvWG0
         dJ0kKQ5h7x80cGpOppJNp+Y7L0XBU6C8X0t2N9l3NHo76JBkoCtDEG/wNYw1F+BljogV
         RVoZA7lMg0rQJGvgordyh1t04K6D3DsaE32XP1+wcspE2PWLDOzSHgwakErN7DyfAT/h
         0EvQ==
X-Gm-Message-State: AGi0PuYYu9jJJe4Zx9Vknr8jrqHWoi70CNyvlniIdiLvwjwfkHQrNAzk
        Ygqcw2q7XAdVKkvZrQVof3H1/QnA8a5xvrXDD8VfKy7bCDJ0HINBxBpkiXderH1l36gWOjyl4P9
        5PlOTgkLMedA/
X-Received: by 2002:a1c:3589:: with SMTP id c131mr1302285wma.116.1586206926216;
        Mon, 06 Apr 2020 14:02:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypLupa6V8Ag++nWn1lmvVOFBGbVp+NnLiKBe5TZlJuWBjL147oyGdoSjF8DsSNg7neOpqnwMaw==
X-Received: by 2002:a1c:3589:: with SMTP id c131mr1302258wma.116.1586206925856;
        Mon, 06 Apr 2020 14:02:05 -0700 (PDT)
Received: from redhat.com (bzq-79-176-51-222.red.bezeqint.net. [79.176.51.222])
        by smtp.gmail.com with ESMTPSA id v9sm17395464wrv.18.2020.04.06.14.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 14:02:05 -0700 (PDT)
Date:   Mon, 6 Apr 2020 17:02:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v4 06/12] vhost: force spec specified alignment on types
Message-ID: <20200406210108.148131-7-mst@redhat.com>
References: <20200406210108.148131-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406210108.148131-1-mst@redhat.com>
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

