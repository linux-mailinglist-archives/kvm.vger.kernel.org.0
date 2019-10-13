Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2BED552A
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 10:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfJMII2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 04:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbfJMIIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 04:08:19 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CBAEF37E80
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 08:08:18 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id r19so14498839qtk.15
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 01:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3CYitd93iDHtPl2boSl3Eyofj0PvtzXYhyw7uXbmPmo=;
        b=pqMcwAbxX65J4dHfrIsQ7xzNHfG9M4DorCkJ+IqT/tmxW2+2X+AqdKrPwYLv41W8rc
         8RFjI4GFabsN8S8kZrPu0qGimdkzyeAoTFfP/YKQAXMxqwfPOrRTwDEjh49mgwzfQxUZ
         MgYk5v3JSwd+mvgVAIherIVLilKNccvfwzsu7XxMa//aznT3HLorrRDVZ5LEYwnG73tu
         C5Pbvi1m13/EUU7+X+mBfbRi4kcTddFMs5FBXlx5gZr3MJqwNYfFSGOViQOkbOcsyIyu
         ykBGysEh9TDZAfb+Lp2hoiDK92e/m5Dm+9i7MWeyGW+pmlPX0a7TGIA9IAcaP14qLVUt
         kAsA==
X-Gm-Message-State: APjAAAW+52vw/B3HoJKDjAwrBj4SJcRC8jABxhyWq5dZKGdFQcQsl+Yf
        pInCciRasSFugPzWOFFTIsQep7nRcKQLKommFsYOYfD3HUiCSc4mbR8Mw0e+EmxNDwB9Tvh972p
        1C7y4UGbtMBeT
X-Received: by 2002:a37:9d10:: with SMTP id g16mr24681935qke.29.1570954098118;
        Sun, 13 Oct 2019 01:08:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyaJ+QpLI1pMBCIJvuv7x0tuYvQpGl6FL4TAAJwm3gJXchv9/ST+/UasjDNh9TYNk8GtdJuXQ==
X-Received: by 2002:a37:9d10:: with SMTP id g16mr24681925qke.29.1570954097874;
        Sun, 13 Oct 2019 01:08:17 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id f10sm6455018qtj.3.2019.10.13.01.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 01:08:17 -0700 (PDT)
Date:   Sun, 13 Oct 2019 04:08:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v3 4/4] vhost/net: add an option to test new code
Message-ID: <20191013080742.16211-5-mst@redhat.com>
References: <20191013080742.16211-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013080742.16211-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a writeable module parameter that tests
the new code. Note: no effort was made to ensure
things work correctly if the parameter is changed
while the device is open. Make sure to
close the device before changing its value.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 1a2dd53caade..122b666ec1f2 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -35,6 +35,9 @@
 
 #include "vhost.h"
 
+static int newcode = 0;
+module_param(newcode, int, 0644);
+
 static int experimental_zcopytx = 0;
 module_param(experimental_zcopytx, int, 0444);
 MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
@@ -565,8 +568,14 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 	struct vhost_virtqueue *rvq = &rnvq->vq;
 	struct vhost_virtqueue *tvq = &tnvq->vq;
 
-	int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				  out_num, in_num, NULL, NULL);
+	int r;
+
+	if (newcode)
+		r = vhost_get_vq_desc_batch(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+					    out_num, in_num, NULL, NULL);
+	else
+		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+				      out_num, in_num, NULL, NULL);
 
 	if (r == tvq->num && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
@@ -575,8 +584,12 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
 
-		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				      out_num, in_num, NULL, NULL);
+		if (newcode)
+			r = vhost_get_vq_desc_batch(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+						    out_num, in_num, NULL, NULL);
+		else
+			r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+					      out_num, in_num, NULL, NULL);
 	}
 
 	return r;
@@ -1046,9 +1059,14 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			r = -ENOBUFS;
 			goto err;
 		}
-		r = vhost_get_vq_desc(vq, vq->iov + seg,
-				      ARRAY_SIZE(vq->iov) - seg, &out,
-				      &in, log, log_num);
+		if (newcode)
+			r = vhost_get_vq_desc_batch(vq, vq->iov + seg,
+						    ARRAY_SIZE(vq->iov) - seg, &out,
+						    &in, log, log_num);
+		else
+			r = vhost_get_vq_desc(vq, vq->iov + seg,
+					      ARRAY_SIZE(vq->iov) - seg, &out,
+					      &in, log, log_num);
 		if (unlikely(r < 0))
 			goto err;
 
-- 
MST

