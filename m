Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0351F66DA
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 13:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbgFKLfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 07:35:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39230 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728110AbgFKLek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 07:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=aQNpekBut2PKhl/aIu//tCUiUfNjTnX+eEbdD/F56exs6eGi3FDEq5fK5Xotw1AsQ4Z1W2
        glfNiZkth+CjGnsJp5PtDUByFGLYvgf5PeW/UX+hUMxUwZ18Vvc2fMgskB/Z47M1+U0H27
        X7+1s1njrDDBf38ewFVF+XQfQDb05yI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-KgchAo55MR-uiztxVIckOQ-1; Thu, 11 Jun 2020 07:34:37 -0400
X-MC-Unique: KgchAo55MR-uiztxVIckOQ-1
Received: by mail-wr1-f72.google.com with SMTP id w4so2454481wrl.13
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 04:34:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=ELJ+cH/vQIZBSodprJvvnPiPYADJ7Z+sdOKVgyExW+6pK3YzDqMY0DgX+vl5sDsjWh
         NZRAmQK9SrKIHi8hFt9G4zVQOBlBmFwQ+ERXo7S1hH8yLFEox2ax3TL8zvuzYpHfILQt
         d+PzR+cDRHQU+1EgulPIPJdWcoIkf85zbukI/TZ6cE4OTpIG2qw4ggSRoBs1bjiVGe3a
         7EnDbsEIhOXtYtwEPOqUNTL5Pnu5HRDphCuBEqpdqVjqaMFTXwOZG4+ncXzkRjYbhjk5
         erJaIDMvoR/bHLPbK0UA7ifVlI6DJl8YI4TXUeXN4A3MIEOVXLlzCdeeE1KAJDi5vnOh
         mjRw==
X-Gm-Message-State: AOAM532LQ/jyP+ibM5LDz4HuwrVAANuZ73VhiQcEKZQnM/v/ReBuYX/u
        7is41bpRG1StT6zS6Y3DEYJAHpFG89sstcsQc4s223Xjgm5zwE742N8AjqDp4N9aPP/Y9HfQcQC
        sZwKGj4qrf7Nk
X-Received: by 2002:a5d:6acf:: with SMTP id u15mr9625707wrw.277.1591875276456;
        Thu, 11 Jun 2020 04:34:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2zXWmmSHCI3WrhXi4UlhJiH0TBT9f7dUAngUHj4AqaFD4pDWyqbUiTnBy/EttZUS7AWNdGA==
X-Received: by 2002:a5d:6acf:: with SMTP id u15mr9625677wrw.277.1591875276191;
        Thu, 11 Jun 2020 04:34:36 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id h12sm4550238wro.80.2020.06.11.04.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:35 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 08/11] vhost/test: convert to the buf API
Message-ID: <20200611113404.17810-9-mst@redhat.com>
References: <20200611113404.17810-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611113404.17810-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 7d69778aaa26..12304eb8da15 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -44,9 +44,10 @@ static void handle_vq(struct vhost_test *n)
 {
 	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
 	unsigned out, in;
-	int head;
+	int ret;
 	size_t len, total_len = 0;
 	void *private;
+	struct vhost_buf buf;
 
 	mutex_lock(&vq->mutex);
 	private = vhost_vq_get_backend(vq);
@@ -58,15 +59,15 @@ static void handle_vq(struct vhost_test *n)
 	vhost_disable_notify(&n->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					 ARRAY_SIZE(vq->iov),
-					 &out, &in,
-					 NULL, NULL);
+		ret = vhost_get_avail_buf(vq, &buf, vq->iov,
+					  ARRAY_SIZE(vq->iov),
+					  &out, &in,
+					  NULL, NULL);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
+		if (unlikely(ret < 0))
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&n->dev, vq))) {
 				vhost_disable_notify(&n->dev, vq);
 				continue;
@@ -78,13 +79,14 @@ static void handle_vq(struct vhost_test *n)
 			       "out %d, int %d\n", out, in);
 			break;
 		}
-		len = iov_length(vq->iov, out);
+		len = buf.out_len;
 		/* Sanity check */
 		if (!len) {
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		vhost_put_used_buf(vq, &buf);
+		vhost_signal(&n->dev, vq);
 		total_len += len;
 		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
-- 
MST

