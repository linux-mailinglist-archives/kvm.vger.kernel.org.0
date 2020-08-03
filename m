Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696B323AEC0
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 23:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgHCVAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 17:00:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729206AbgHCVAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 17:00:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596488420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f1A99Kan+ToYvUmOMuODkd0BFkRSjBNq3WkT2nA5570=;
        b=I2Cy6OZFp44adUcSURPKsc2f308oqyHjBVbCF86tsq9zgdzWGr2757+z7888M6qjHFWpXd
        F4SNu6cg0fdfb0DjLU+qbBUWLK69LtYVJlt4ScUYhLO22EX9Sf5FWHpB/irckFQuaOsZKT
        AjB6qe0WS4AcODfnwhzh+cxf7z9gbdA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-MIW-VOxgMZ6-40XLWko8wA-1; Mon, 03 Aug 2020 17:00:16 -0400
X-MC-Unique: MIW-VOxgMZ6-40XLWko8wA-1
Received: by mail-qk1-f200.google.com with SMTP id 1so13762517qki.22
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 14:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f1A99Kan+ToYvUmOMuODkd0BFkRSjBNq3WkT2nA5570=;
        b=HRWMukSTCwRX+m8fcneTiwFm+1nGEOhtVyY2+yWZ+PGCe0f2d1/Dg6hyqqHS9PwVkp
         6tvFqnj4ZvgG9Cah9K/92Jt68hApaWW6yCPp68pdJ+unQdOUXqjkdVdkvzGAkmmJhGfY
         DvcZAzd0voTizQc9IMPD76Jp5HDYyANU/cmvXVr5S+rDUJG/j2HMrukJmZO08NdGqQJ9
         L2tT/YlaLRxfgcYOU94AUpKagkdv5nU2KKf7NbkWW3S5+xRN8rc0+S90e93or0KGA/3d
         AsP5bD9Q1tGWRj81nGYWbkYqUQa7KBHXAxrZ3tmPfjdTjLRcfyzSEAkynBXnAGzUPjDK
         oK3g==
X-Gm-Message-State: AOAM530jibLmkD5a+U8eIePZ6bo6yxiWljeI3I7Nf7tCOElSXs/LPQ94
        Q0I3fS7ofsqLC8+qzIleCJS5RRoy7gnLn3EBGG8LSWbsHxmwyZ1V+qSM4yX7/+a2lFjfgDEPLbx
        8L66nF/Jwn4r5
X-Received: by 2002:ae9:f409:: with SMTP id y9mr17081844qkl.383.1596488415784;
        Mon, 03 Aug 2020 14:00:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOLsF2kRKHhVMrVuK1ExTkYEV3u00bvHZC77i72ooYLjKbjM4TmW/w7ndizuS2cvXbLFA8ag==
X-Received: by 2002:ae9:f409:: with SMTP id y9mr17081819qkl.383.1596488415580;
        Mon, 03 Aug 2020 14:00:15 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id x137sm20654324qkb.47.2020.08.03.14.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:00:15 -0700 (PDT)
Date:   Mon, 3 Aug 2020 17:00:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 20/24] vhost/vdpa: switch to new helpers
Message-ID: <20200803205814.540410-21-mst@redhat.com>
References: <20200803205814.540410-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803205814.540410-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For new helpers handling legacy features to be effective,
vhost needs to invoke them. Tie them in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vdpa.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 18869a35d408..3674404688f5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -118,9 +118,8 @@ static irqreturn_t vhost_vdpa_config_cb(void *private)
 static void vhost_vdpa_reset(struct vhost_vdpa *v)
 {
 	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 
-	ops->set_status(vdpa, 0);
+	vdpa_reset(vdpa);
 }
 
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
@@ -196,7 +195,6 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 				  struct vhost_vdpa_config __user *c)
 {
 	struct vdpa_device *vdpa = v->vdpa;
-	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa_config config;
 	unsigned long size = offsetof(struct vhost_vdpa_config, buf);
 	u8 *buf;
@@ -209,7 +207,7 @@ static long vhost_vdpa_get_config(struct vhost_vdpa *v,
 	if (!buf)
 		return -ENOMEM;
 
-	ops->get_config(vdpa, config.off, buf, config.len);
+	vdpa_get_config(vdpa, config.off, buf, config.len);
 
 	if (copy_to_user(c->buf, buf, config.len)) {
 		kvfree(buf);
@@ -282,7 +280,7 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 	if (features & ~vhost_vdpa_features[v->virtio_id])
 		return -EINVAL;
 
-	if (ops->set_features(vdpa, features))
+	if (vdpa_set_features(vdpa, features))
 		return -EINVAL;
 
 	return 0;
-- 
MST

