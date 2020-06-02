Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753D31EBC79
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgFBNGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:06:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60393 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728420AbgFBNGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 09:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uCok80LFYJ4Lm/PMCty2sCIaVjds7Ty5xQFab3NSrrY=;
        b=CXlEKRXcoXu6IEYRXOOHHDlJiBTwppsi/rF8buf6VhPYxCGtsMhk4ltZ/tIkQYYjuQfLA2
        GMVbRFz6Gh6R6593Y25H2fF5lywPI4VrI85uyfT/O7qM7oXo2ltVyqKcQhpu/EVF03sbOK
        XtCqc42Y6OM80OBnM5FG2fxu7QKFdVA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-GdGI3DjZPfiVEi6I81QY8g-1; Tue, 02 Jun 2020 09:06:28 -0400
X-MC-Unique: GdGI3DjZPfiVEi6I81QY8g-1
Received: by mail-wr1-f69.google.com with SMTP id w4so1379375wrl.13
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uCok80LFYJ4Lm/PMCty2sCIaVjds7Ty5xQFab3NSrrY=;
        b=W78pNeiXQydp0AAhcdecoXRcamayRvq9Z08hV6tx7ZmT9okXFDLvSQAGcBgL5xJN4M
         Z2uyyhC7LpHCn97fI8i5pXN/P+3BsjUdTRNQxSEw4JznBGm43gA8ZQ1yX/1xgrMtWemn
         86TaFYhhaPQQEdnvx0+0wFcqtx0WGOOmasJdGhFmupKOEkUi4LIWpXf5dkK16IV6PDsb
         l7gKeglh0ocPsX9/QmmNIJri3Q8dtJhl/TiCcyc5Oy7yVtXP/VM5JQywhPpLmMJVIsrI
         Rx1clRHZINbzMOIeURyMYGk70TWbBwtao/xoyqipsvZuXE202b0IHSDEwC1sxV34mxMx
         WZCQ==
X-Gm-Message-State: AOAM532SA+qGQQEaDSWlMHhKdil2jL1oRozAYcxbhWD3mkQHWVRNW1wE
        wEW9MvUPLbtHh+ORdgFRU9B93E4oAVO1Adw7AGsQdSxwvoagBROQrETqHCKtgMHCRDRsTUq/hZD
        9JPx3iYBrWcHw
X-Received: by 2002:adf:a350:: with SMTP id d16mr27202896wrb.237.1591103187035;
        Tue, 02 Jun 2020 06:06:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSMYsr9uLo9HwO9qp8x9NdNINKCKw+Yq/4jaF7d1uMiQ2jKEDbPOfPn52lZ3rMs5ZJSOurmQ==
X-Received: by 2002:adf:a350:: with SMTP id d16mr27202884wrb.237.1591103186812;
        Tue, 02 Jun 2020 06:06:26 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id n23sm3456907wmc.0.2020.06.02.06.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:26 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 13/13] vhost: drop head based APIs
Message-ID: <20200602130543.578420-14-mst@redhat.com>
References: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Everyone's using buf APIs, no need for head based ones anymore.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 36 ++++++++----------------------------
 drivers/vhost/vhost.h | 12 ------------
 2 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index be822f0c9428..412923cc96df 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2256,12 +2256,12 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	return 1;
 }
 
-/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
+/* Revert the effect of fetch_buf. Useful for error handling. */
+static
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
 	vq->last_avail_idx -= n;
 }
-EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
 /* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
  * A negative code is returned on error. */
@@ -2421,8 +2421,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
+static
 int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 		     unsigned count)
 {
@@ -2456,10 +2455,8 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	return r;
 }
-EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
+static
 int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 {
 	struct vring_used_elem heads = {
@@ -2469,14 +2466,17 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 
 	return vhost_add_used_n(vq, &heads, 1);
 }
-EXPORT_SYMBOL_GPL(vhost_add_used);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using vhost_signal. */
 int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
 {
 	return vhost_add_used(vq, buf->id, buf->in_len);
 }
 EXPORT_SYMBOL_GPL(vhost_put_used_buf);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using vhost_signal. */
 int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
 			  struct vhost_buf *bufs, unsigned count)
 {
@@ -2537,26 +2537,6 @@ void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_signal);
 
-/* And here's the combo meal deal.  Supersize me! */
-void vhost_add_used_and_signal(struct vhost_dev *dev,
-			       struct vhost_virtqueue *vq,
-			       unsigned int head, int len)
-{
-	vhost_add_used(vq, head, len);
-	vhost_signal(dev, vq);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
-
-/* multi-buffer version of vhost_add_used_and_signal */
-void vhost_add_used_and_signal_n(struct vhost_dev *dev,
-				 struct vhost_virtqueue *vq,
-				 struct vring_used_elem *heads, unsigned count)
-{
-	vhost_add_used_n(vq, heads, count);
-	vhost_signal(dev, vq);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
-
 /* return true if we're sure that avaiable ring is empty */
 bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 6c10e99ff334..4fcf59153fc7 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -195,11 +195,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
-int vhost_get_vq_desc(struct vhost_virtqueue *,
-		      struct iovec iov[], unsigned int iov_count,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num);
-void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
 			struct iovec iov[], unsigned int iov_count,
 			unsigned int *out_num, unsigned int *in_num,
@@ -207,13 +202,6 @@ int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
 void vhost_discard_avail_bufs(struct vhost_virtqueue *,
 			      struct vhost_buf *, unsigned count);
 int vhost_vq_init_access(struct vhost_virtqueue *);
-int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-		     unsigned count);
-void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
-			       unsigned int id, int len);
-void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *heads, unsigned count);
 int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
 int vhost_put_used_n_bufs(struct vhost_virtqueue *,
 			  struct vhost_buf *bufs, unsigned count);
-- 
MST

