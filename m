Return-Path: <kvm+bounces-57590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7111B58186
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70C92204BCF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C9ED26F471;
	Mon, 15 Sep 2025 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XWXu9U6b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2436226CE0F
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952218; cv=none; b=Bei1W7pzCt5B9MR/7dGMWD2Cevkri85aqcE5LmEZZ5G+zYGOi/lYYjiZmBYYLThs4nqVJ62N6pb8fnH1QNLS1JvdWbeHADNgGpcotjHgyxYhxsOfNmcat+PwjPMcxdYDUXyLlz239kUmDM4od/rNRfQ13QTeErdYiyYLKvN9HWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952218; c=relaxed/simple;
	bh=lz+21+pXWAdvl2nNDlkXW3ZFI2U/V3++gCtr1F/cu+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtvO/ilqxMjYJaPApfF/MdV4Qx6AXcxRHdnmulSQyyhlFqS6EEd5bCTOaDsioNX4d4rQ2fXZ5tAgKuu10mS9lRj7KPerjFQLgxWmRAi5ZtGFAKScAUQ7h/zopWGIN+3ynNzmdpP9FTF9JN6OJ5Jz9jY5T7tFzevltcjoK6ijdJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XWXu9U6b; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757952216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zyjSpWLvfqnwtpmHwJJOxa1B89j7LM2tZ53OHGLbRxs=;
	b=XWXu9U6bW2enupMkUM2bl9WOuePWzc5rRC7eQxF0xHUJCnrjrDtCdrkQgOFGeJ7/PjcQkD
	7V1+rq6s0eeUzbImCanfbbKQvK30A7EbNCtmbvr+gC+rPyN1ad1rcbKKDrRiHy4A6Kdz7M
	uyUws29aY2hOQMkMT4byl4e+T4EUSt4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-hMtJl8PGP8Sy0MG_2IwJgw-1; Mon, 15 Sep 2025 12:03:32 -0400
X-MC-Unique: hMtJl8PGP8Sy0MG_2IwJgw-1
X-Mimecast-MFC-AGG-ID: hMtJl8PGP8Sy0MG_2IwJgw_1757952211
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-afcb72a8816so328123566b.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757952211; x=1758557011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyjSpWLvfqnwtpmHwJJOxa1B89j7LM2tZ53OHGLbRxs=;
        b=USSjGU97gi8RHFTEaeFedB+95wfheylMFa6NLe2S/+kCg0sL+9VV0+5AJJXIkjF2OQ
         idLN6praBNzVY1s3kV5NFX2lSNS9s+NyfA/0Gi1chyXi9w/iV4drHpNMh0DS7JpwZQZy
         xKzAj5/z3NnQs/yF5ZImOMzZIJ4WI0c0JDcSIOJobavUXs7Qq9RSTFqsUFJOrLMmZLm0
         jou3bn3HOLqbfUILRcfYyobFIK4KjfR0718rE0aYBBg+vDXyLYPqZw6yvf4FOz8O/aDR
         b1cN23h06JOLPdN3P4X0XzjYRv3a3HzcgeAMkiyQ2NDOnyDyFV7sb/bm79gFoRMKrbCv
         hwdw==
X-Forwarded-Encrypted: i=1; AJvYcCWTLIdDbM3CHQiFVA3FupL44/wRqCb3JrgsUqPT0aiwq6t+mraCttGj33iY1FE42I8lkFs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5ON6h5tPZAL94AMhV6g+mwyNaqrO6Ab6gvY/WFG/+ZNQhI5Bb
	TgpIckkrGH1kMWsoIFex9J60AbDUuwW+jc3+Xv2KXhdAonilEMd3L3N/TnS1PQn8KtgjPYDVQpw
	rdmXZoJlmanIivwNMn9gerGt+PaCaMUFI2usTvaEs4SHylr4DUaWMcQ==
X-Gm-Gg: ASbGnctjmycYRgcSV3xm9CeuoIo6TRHkKcgxta1NtzvvDMnH/w9dEE9PYZJG2NaPcz5
	AeMCtIf9l4nB6nUPFgNd24U/BYIBlUrQnK1VRlMbo/AKVci7OtEtZtV0v86/GLgDjww9vJlcrXS
	pXx3mu0BOTDN4CTLcbYAAv0Sb/E7y4fOWvvxVqhObyLOyC7mzFrnR7SUqbh1FQX/yYarMNAYttb
	XdEEQtnyit20NiiDZMGzF+IsE9N5Qh84nEgeEbSw2F8OXdJBq9GmlTPQf34Te4eooLEdKMbWDRc
	ZhV5geKkNaDMGMgtUiopSF0Rx9sS
X-Received: by 2002:a17:907:d16:b0:b04:3402:3940 with SMTP id a640c23a62f3a-b07c35d4d02mr1305642566b.27.1757952211047;
        Mon, 15 Sep 2025 09:03:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNtSBH6QlKSIfQdtkhP6WbRqJLxZsgUpRv3jEYGQSqAMd7B74yXmlLS/60ot7X5iMC+KioIg==
X-Received: by 2002:a17:907:d16:b0:b04:3402:3940 with SMTP id a640c23a62f3a-b07c35d4d02mr1305636166b.27.1757952210298;
        Mon, 15 Sep 2025 09:03:30 -0700 (PDT)
Received: from redhat.com ([31.187.78.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b32dd413sm988048866b.71.2025.09.15.09.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 09:03:29 -0700 (PDT)
Date: Mon, 15 Sep 2025 12:03:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>, netdev@vger.kernel.org,
	stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH v3 3/3] vhost-net: flush batched before enabling notifications
Message-ID: <7b0c9cf7c81e39a59897b3a76d159aa0580b2baa.1757952021.git.mst@redhat.com>
References: <b93d3101a6c78f17a19bb0f883d72b30f66d1b54.1757952021.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b93d3101a6c78f17a19bb0f883d72b30f66d1b54.1757952021.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
sendmsg") tries to defer the notification enabling by moving the logic
out of the loop after the vhost_tx_batch() when nothing new is spotted.
This caused unexpected side effects as the new logic is reused for
several other error conditions.

A previous patch reverted 8c2e6b26ffe2. Now, bring the performance
back up by flushing batched buffers before enabling notifications.

Link: https://lore.kernel.org/all/20250915024703.2206-2-jasowang@redhat.com
Reported-by: Jon Kohler <jon@nutanix.com>
Cc: stable@vger.kernel.org
Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 57efd5c55f89..72ecb8691275 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -782,11 +782,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		if (head == vq->num) {
 			if (unlikely(busyloop_intr)) {
 				vhost_poll_queue(&vq->poll);
-			} else if (unlikely(vhost_enable_notify(&net->dev,
-								vq))) {
-				vhost_disable_notify(&net->dev, vq);
-				continue;
-			}
+			} else {
+				/* Flush batched packets before enabling
+				 * virtqueue notifications to reduce
+				 * unnecessary virtqueue kicks.
+				 */
+				vhost_tx_batch(net, nvq, sock, &msg);
+
+				if (unlikely(vhost_enable_notify(&net->dev,
+								 vq))) {
+					vhost_disable_notify(&net->dev, vq);
+					continue;
+				}
 			break;
 		}
 
-- 
MST


