Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC14B1F0BCC
	for <lists+kvm@lfdr.de>; Sun,  7 Jun 2020 16:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgFGOLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jun 2020 10:11:42 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726707AbgFGOLj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Jun 2020 10:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JQR7Mpm9OBikwgtvyKeD/N9hz5sz6YikG7pS21JFzQo=;
        b=bpROrwDoGrfk/f22tIGoDnQQdwnk3dxKKY6ASNFC9bLdHKR2BIsIV9HUP8aHfl+lxSLj8p
        RNxpjQgPKpXmXnmplaF0TBCaL6KgC7a7hxanY8Z4wYpF2oVs30+c7d3GZGckHKsPGvSBBD
        ChUEd8+Sy3PtHlMiEzeVo3I6YPrUO18=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-bf8PShM9PHSyGHDQZLlB-A-1; Sun, 07 Jun 2020 10:11:35 -0400
X-MC-Unique: bf8PShM9PHSyGHDQZLlB-A-1
Received: by mail-wr1-f70.google.com with SMTP id o1so6011447wrm.17
        for <kvm@vger.kernel.org>; Sun, 07 Jun 2020 07:11:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JQR7Mpm9OBikwgtvyKeD/N9hz5sz6YikG7pS21JFzQo=;
        b=gK9tyIm3HRkrfgg49JTY5w9Ur+swT1ceApP+3bt1+b3nj4E9Nk9cnxuJv7kZ7JS8hk
         0VUx/W4jl3MtNruTgxN4nK9nLeuzatmalcJjAIpc2QczKZ9ED0rsku8ZLHFTjHsW0tf0
         SY1nko6/tyXIQS+pjLzz/tLpb443ngMwLrrvU08/dIiwv9LSiyHtuJQITjecAsp8Kh43
         Fqw6L6WZ/dvL2LIoM9Vq1J2AirY7yjNR0h++2zkCfGE7mDhOt9S6AsMNYE9h1f2RCMiU
         EBV7pHkBS3AEjF7rv6/6o/HgukyWyp8d9Bm1gmxXZ6f65Vl9j8vV3V7tKUnA3phQfByy
         HM/Q==
X-Gm-Message-State: AOAM531vs1LCKLp3Xtk3lJJptucrqZgXS1iJrgE4npnjna6LP7zx/rRn
        vwsejMyjErxpPz+TXlHLL1VwIiBmasPjPWoxcvKFkAcd8B5AqUotqvpilrPFHBxY8ji+kOwpl3w
        K5FeNfmhTFT3Q
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr18094717wrj.333.1591539094201;
        Sun, 07 Jun 2020 07:11:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqzRAoAIzc/LlIJf21AHME4RusNkUCf33IpFFYIMKnPoUw8fHgwURZWyZ6ZiKcq55sRTypMg==
X-Received: by 2002:adf:dc8e:: with SMTP id r14mr18094706wrj.333.1591539094004;
        Sun, 07 Jun 2020 07:11:34 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id k17sm18626832wmj.15.2020.06.07.07.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:33 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 04/13] vhost: cleanup fetch_buf return code handling
Message-ID: <20200607141057.704085-5-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return code of fetch_buf is confusing, so callers resort to
tricks to get to sane values. Let's switch to something standard:
0 empty, >0 non-empty, <0 error.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3b0609801381..5075505cfe55 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2189,6 +2189,8 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
 	return 0;
 }
 
+/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
 static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	unsigned int i, head, found = 0;
@@ -2205,7 +2207,7 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
 		/* If we already have work to do, don't bother re-checking. */
 		if (likely(vq->ndescs))
-			return vq->num;
+			return 0;
 
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
@@ -2224,7 +2226,7 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 		 * invalid.
 		 */
 		if (vq->avail_idx == last_avail_idx)
-			return vq->num;
+			return 0;
 
 		/* Only get avail ring entries after they have been
 		 * exposed by guest.
@@ -2294,12 +2296,14 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	/* On success, increment avail index. */
 	vq->last_avail_idx++;
 
-	return 0;
+	return 1;
 }
 
+/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
 static int fetch_descs(struct vhost_virtqueue *vq)
 {
-	int ret = 0;
+	int ret;
 
 	if (unlikely(vq->first_desc >= vq->ndescs)) {
 		vq->first_desc = 0;
@@ -2309,10 +2313,14 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	if (vq->ndescs)
 		return 0;
 
-	while (!ret && vq->ndescs <= vhost_vq_num_batch_descs(vq))
-		ret = fetch_buf(vq);
+	for (ret = 1;
+	     ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
+	     ret = fetch_buf(vq))
+		;
 
-	return vq->ndescs ? 0 : ret;
+	/* On success we expect some descs */
+	BUG_ON(ret > 0 && !vq->ndescs);
+	return ret;
 }
 
 /* This looks in the virtqueue and for the first available buffer, and converts
@@ -2331,7 +2339,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	int ret = fetch_descs(vq);
 	int i;
 
-	if (ret)
+	if (ret <= 0)
 		return ret;
 
 	/* Now convert to IOV */
-- 
MST

