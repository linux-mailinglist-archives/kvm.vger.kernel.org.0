Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38FBD55FD
	for <lists+kvm@lfdr.de>; Sun, 13 Oct 2019 13:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfJMLmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Oct 2019 07:42:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729322AbfJMLmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:23 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8E2D5AFF8
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 11:42:22 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id y10so14896636qti.1
        for <kvm@vger.kernel.org>; Sun, 13 Oct 2019 04:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3CYitd93iDHtPl2boSl3Eyofj0PvtzXYhyw7uXbmPmo=;
        b=ipJxXduSVe/baFUl2FmIAPd4XDlDNLNvvKoGg5T0pYb/QHpxBUsbXVTsz4oo27l8Xi
         r+EnT96VYTVwhfcxcxG/F8JaWzQFM12UWx5Vl+7c/WrAXXu/WUEoSAjDwv4uG4GuCw4Y
         FE7m35PaWVOLlf2oFbL6a5wMuurWlbdwYGHpPKGgFE7z5UpRelu+wJZzj0QAuzh0y67F
         jCfhobHIvvtudwZX2OXQs2U4CI2z+p+ookbkksk/IVaO/pGeJz9tehCFsvflWUviGbUr
         f8C0WemQ+ihsqQw3xiDBo6S8x1u/4HVL21cmIkqStm1lRevbailrZllL+CIlb/H9XxRa
         0rLw==
X-Gm-Message-State: APjAAAVPMxXA1fbPP2Tqv/yla9sDU15Xidt+9S+ZGIQPR3e5el3GhLAJ
        Ng+3imXCc45E01FHH5BiBF5CuSnKOeAwSZvu3yHADNY0SfAwL59G+I6aDg0ZmVLCXN4CM+Fx9IB
        n3pjVXDW9xgI+
X-Received: by 2002:aed:35a7:: with SMTP id c36mr27529129qte.200.1570966942034;
        Sun, 13 Oct 2019 04:42:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz4LMbkCfrdcYhEI8OeObeDJu5LuXPSdwMN3Yqhx4D0fr8hIGkuB2w8tDSXR79T7N+Kluf9Qg==
X-Received: by 2002:aed:35a7:: with SMTP id c36mr27529117qte.200.1570966941851;
        Sun, 13 Oct 2019 04:42:21 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id e42sm10005404qte.26.2019.10.13.04.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:21 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:42:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 4/5] vhost/net: add an option to test new code
Message-ID: <20191013113940.2863-5-mst@redhat.com>
References: <20191013113940.2863-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013113940.2863-1-mst@redhat.com>
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

