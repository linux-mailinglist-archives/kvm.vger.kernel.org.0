Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643021EBCA7
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgFBNIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 09:08:18 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42295 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728090AbgFBNGK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 09:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXfjPrDyqejhZJQKUWL2cxT5rK4Jnqa149Nn7T1gq18=;
        b=fSexiHW9l09yNuKon60LwwEn3hNOIHwld2GdSwkkeMqZKklg3vWr1LDJtLD3mFCDQF3o8f
        ZsLUfw9BBx8DygUvOh5pdqsvC0sCUC/6ZWepBzN3pwqaxbiJx88k3dWWBkYAG1/3j/7jP2
        RmBZegbTUHIvfAL0yMl/BKc8Il6IpKg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-N5SHqwMDNlOYtW2x2ScQxA-1; Tue, 02 Jun 2020 09:06:07 -0400
X-MC-Unique: N5SHqwMDNlOYtW2x2ScQxA-1
Received: by mail-wr1-f71.google.com with SMTP id p10so1372410wrn.19
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 06:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EXfjPrDyqejhZJQKUWL2cxT5rK4Jnqa149Nn7T1gq18=;
        b=YcV62rWYv3OnluHMY4AORgGtdP1jZPIi01Zb9sAtMnklniKDVY9Lk4dypOqR3754KT
         F2dHcyHpOLC84kxTix87f1DUlNWgtJkeYEkvGFUf5tWmktE1hOiYTVnChB+DikixZUsk
         gDGykk4aZc487GQh94UMddPKIbCUD8q1JR6S4eNJgIi/oAIJWBNKzrO+ilbbPGr92ioC
         57woToGbwvzK7+Ko4H2q2W4XhCXT1ypzJWi9ARNW+H9Z8oo7dwaP8YCxFoz3Mvmamf0P
         +hLOeGYzeFNkvsSTrafLtzLv7ExnkpjwOx6czSUdK9YCjvgjO4/q2MRvOpWSAbWQUsOV
         gIlg==
X-Gm-Message-State: AOAM530cB/IhZD69uAjWihD+WUmwjEpiW2ds1ZcZ/AQ4EBq1k5LPyDSt
        j6EhLrsHVneW05K3ZVkn8cqTomwFis+WoUsIJMsWanoI7SrwWwcraF7L2zTM/wng5dnVJHy3Y3F
        dx3e/+EML2UXK
X-Received: by 2002:a5d:6391:: with SMTP id p17mr28295029wru.118.1591103165836;
        Tue, 02 Jun 2020 06:06:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycUSkpBa2fgUPLZAf/ybOapg7EllouqLaj5tY/W/L7i8gJ0j5W3iBZNA/fqWHGkhJHN82J9A==
X-Received: by 2002:a5d:6391:: with SMTP id p17mr28295007wru.118.1591103165610;
        Tue, 02 Jun 2020 06:06:05 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id m129sm3760525wmf.2.2020.06.02.06.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:05 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 04/13] vhost: cleanup fetch_buf return code handling
Message-ID: <20200602130543.578420-5-mst@redhat.com>
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

Return code of fetch_buf is confusing, so callers resort to
tricks to get to sane values. Let's switch to something standard:
0 empty, >0 non-empty, <0 error.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index aca2a5b0d078..bd52b44b0d23 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2146,6 +2146,8 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
 	return 0;
 }
 
+/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
 static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	unsigned int i, head, found = 0;
@@ -2162,7 +2164,7 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
 		/* If we already have work to do, don't bother re-checking. */
 		if (likely(vq->ndescs))
-			return vq->num;
+			return 0;
 
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
@@ -2181,7 +2183,7 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 		 * invalid.
 		 */
 		if (vq->avail_idx == last_avail_idx)
-			return vq->num;
+			return 0;
 
 		/* Only get avail ring entries after they have been
 		 * exposed by guest.
@@ -2251,12 +2253,14 @@ static int fetch_buf(struct vhost_virtqueue *vq)
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
@@ -2266,10 +2270,14 @@ static int fetch_descs(struct vhost_virtqueue *vq)
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
@@ -2288,7 +2296,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	int ret = fetch_descs(vq);
 	int i;
 
-	if (ret)
+	if (ret <= 0)
 		return ret;
 
 	/* Now convert to IOV */
-- 
MST

