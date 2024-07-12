Return-Path: <kvm+bounces-21509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D68E192FB9D
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:42:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05FEA1C226FE
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 13:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C924171080;
	Fri, 12 Jul 2024 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T6yGy7H6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39D316F857
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720791722; cv=none; b=hZAZ6Gz1lcTtknJyPz61Wr1z5yyR94RNNrfyIYTDyauzRylDZRRhWq4lpQ0G7yLrO4SlqJ1KUdz2/AW/tH5D5mq34w+qCvFIFOrAy4v4qBLdNjoY8feErGroaTbBt0VTPX9Jt21mq5f8nSKrhSgbchIfdqm/Ur5fa2h+u7xFhkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720791722; c=relaxed/simple;
	bh=VlSHi9RK0cz8oHSgiEYUsmDxeuGYyWFs8bFgo7jHaYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtymj7gwI79nS4pDd4slot4NoTqk0OkbPJTJdKK95TDzf4HiGSTxZql46fxEqn5gNyfAZ/Esl+xoYpAawYNyLIAVdndy4ABm+Kxk3wJUu6Zru48u1jnxuigB9Rn9/tPh3N9BHbsBH4t+vlZCkVN3sfb+EmD74vaG4xGxJYeM9gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T6yGy7H6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720791719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mk+WM1arm/64ZpMrIxPRFx219R8+aXz4jqZ8C+xP4gc=;
	b=T6yGy7H6j7yapCGhLzi3G2Zv66sC+5WSSiO/fllkyowaP2lvfVYMOklyOsQo1+vkGQDsUj
	rEQpb5ctZinc4jZZDJB054FNStlWSPm2Yzd6fhACYYUtrc7jF8SyYGx4UR1EH2TIu4HWwP
	Q2PEo/e2LyzYdQJ0kyj5Blnx5Rm2vrI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-udsXTqlPPoSntXnB4PaAjg-1; Fri, 12 Jul 2024 09:41:58 -0400
X-MC-Unique: udsXTqlPPoSntXnB4PaAjg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52ea4178bafso1824873e87.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 06:41:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720791716; x=1721396516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mk+WM1arm/64ZpMrIxPRFx219R8+aXz4jqZ8C+xP4gc=;
        b=bjObJ9OGIwoPrC6XgXKV8Q5oWOTQMcOEyiCBl6JbGdKDy5mRsAtJOBjf90NDMaHLVH
         ZkdDIyprMCrPO/D+ohkDCfwstq3NCJAKh+/4BXo9oTAyaoJd8ZNeAuT+29SgtV551xZx
         WrFK+943Y/pKsnfjlZHW4pQaO4xwzMZLOPh47onjd6Pk2ae3a0NanW6Vf7oBcU518FmE
         bYEocK9ec12kWF3qstW2onsLECJ3BP5qR/rMqKvcqq/cXZ841x1oNqmvB1ahzVvLI+AM
         hauxt6tmLSXp6gfUlGI1lOPJIg/EUssY1iP1pdCj8PGvglj3BF8vVLxCEzukFrgIGjeJ
         eZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn8wLgZirC+MMEGiN4SONRBM9BZh8kSoQAbUXsOckhcFoxI5FeXqBObv9HywwJCMDSqUbjxTFccfjQObRtNPkgEpJt
X-Gm-Message-State: AOJu0Yyfyb5xbmh/Hvm0iTuxFZc2qbsqblqC4syyz4xk9rM36AmdgZkx
	gLiEFATwmTWNgd34QJnxPB3GUunnzFPAstLgMl9tJEaoGA6DAYdZOHm2OyN4dRBU21dpbGyJXuk
	+cYMC27BdTNHIuivapJyfO8AO9q0wpJ5foSv7Wv/Rm0mVqgdwDw==
X-Received: by 2002:a05:6512:3a8a:b0:52c:e402:4dc1 with SMTP id 2adb3069b0e04-52eb99cc600mr7617111e87.55.1720791716570;
        Fri, 12 Jul 2024 06:41:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUaf4mxN3q9ATPhlcpzBYwPRxW6N5KDcX6uHj3/W1daAmMkIG36ncQyE+RQl/Wv+1PaDvSBA==
X-Received: by 2002:a05:6512:3a8a:b0:52c:e402:4dc1 with SMTP id 2adb3069b0e04-52eb99cc600mr7617095e87.55.1720791715892;
        Fri, 12 Jul 2024 06:41:55 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-153.retail.telecomitalia.it. [82.57.51.153])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a85431fsm343736466b.153.2024.07.12.06.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 06:41:55 -0700 (PDT)
Date: Fri, 12 Jul 2024 15:41:51 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: luigi.leonardi@outlook.com
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marco Pinna <marco.pinn95@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] vsock/virtio: refactor
 virtio_transport_send_pkt_work
Message-ID: <5myg3te4nmgrddh3dvh6t4guvmr4i73uwksyf2g4h4n3gjqk74@mf43vrv5gym2>
References: <20240711-pinna-v3-0-697d4164fe80@outlook.com>
 <20240711-pinna-v3-1-697d4164fe80@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240711-pinna-v3-1-697d4164fe80@outlook.com>

On Thu, Jul 11, 2024 at 04:58:46PM GMT, Luigi Leonardi via B4 Relay wrote:
>From: Marco Pinna <marco.pinn95@gmail.com>
>
>Preliminary patch to introduce an optimization to the
>enqueue system.
>
>All the code used to enqueue a packet into the virtqueue
>is removed from virtio_transport_send_pkt_work()
>and moved to the new virtio_transport_send_skb() function.
>
>Co-developed-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
>Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
>---
> net/vmw_vsock/virtio_transport.c | 105 ++++++++++++++++++++++-----------------
> 1 file changed, 59 insertions(+), 46 deletions(-)

LGTM

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport.c 
>b/net/vmw_vsock/virtio_transport.c
>index 43d405298857..c4205c22f40b 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -94,6 +94,63 @@ static u32 virtio_transport_get_local_cid(void)
> 	return ret;
> }
>
>+/* Caller need to hold vsock->tx_lock on vq */
>+static int virtio_transport_send_skb(struct sk_buff *skb, struct virtqueue *vq,
>+				     struct virtio_vsock *vsock)
>+{
>+	int ret, in_sg = 0, out_sg = 0;
>+	struct scatterlist **sgs;
>+
>+	sgs = vsock->out_sgs;
>+	sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
>+		    sizeof(*virtio_vsock_hdr(skb)));
>+	out_sg++;
>+
>+	if (!skb_is_nonlinear(skb)) {
>+		if (skb->len > 0) {
>+			sg_init_one(sgs[out_sg], skb->data, skb->len);
>+			out_sg++;
>+		}
>+	} else {
>+		struct skb_shared_info *si;
>+		int i;
>+
>+		/* If skb is nonlinear, then its buffer must contain
>+		 * only header and nothing more. Data is stored in
>+		 * the fragged part.
>+		 */
>+		WARN_ON_ONCE(skb_headroom(skb) != sizeof(*virtio_vsock_hdr(skb)));
>+
>+		si = skb_shinfo(skb);
>+
>+		for (i = 0; i < si->nr_frags; i++) {
>+			skb_frag_t *skb_frag = &si->frags[i];
>+			void *va;
>+
>+			/* We will use 'page_to_virt()' for the userspace page
>+			 * here, because virtio or dma-mapping layers will call
>+			 * 'virt_to_phys()' later to fill the buffer descriptor.
>+			 * We don't touch memory at "virtual" address of this page.
>+			 */
>+			va = page_to_virt(skb_frag_page(skb_frag));
>+			sg_init_one(sgs[out_sg],
>+				    va + skb_frag_off(skb_frag),
>+				    skb_frag_size(skb_frag));
>+			out_sg++;
>+		}
>+	}
>+
>+	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>+	/* Usually this means that there is no more space available in
>+	 * the vq
>+	 */
>+	if (ret < 0)
>+		return ret;
>+
>+	virtio_transport_deliver_tap_pkt(skb);
>+	return 0;
>+}
>+
> static void
> virtio_transport_send_pkt_work(struct work_struct *work)
> {
>@@ -111,66 +168,22 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
>-		int ret, in_sg = 0, out_sg = 0;
>-		struct scatterlist **sgs;
> 		struct sk_buff *skb;
> 		bool reply;
>+		int ret;
>
> 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
> 		if (!skb)
> 			break;
>
> 		reply = virtio_vsock_skb_reply(skb);
>-		sgs = vsock->out_sgs;
>-		sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
>-			    sizeof(*virtio_vsock_hdr(skb)));
>-		out_sg++;
>-
>-		if (!skb_is_nonlinear(skb)) {
>-			if (skb->len > 0) {
>-				sg_init_one(sgs[out_sg], skb->data, skb->len);
>-				out_sg++;
>-			}
>-		} else {
>-			struct skb_shared_info *si;
>-			int i;
>-
>-			/* If skb is nonlinear, then its buffer must contain
>-			 * only header and nothing more. Data is stored in
>-			 * the fragged part.
>-			 */
>-			WARN_ON_ONCE(skb_headroom(skb) != sizeof(*virtio_vsock_hdr(skb)));
>-
>-			si = skb_shinfo(skb);
>
>-			for (i = 0; i < si->nr_frags; i++) {
>-				skb_frag_t *skb_frag = &si->frags[i];
>-				void *va;
>-
>-				/* We will use 'page_to_virt()' for the userspace page
>-				 * here, because virtio or dma-mapping layers will call
>-				 * 'virt_to_phys()' later to fill the buffer descriptor.
>-				 * We don't touch memory at "virtual" address of this page.
>-				 */
>-				va = page_to_virt(skb_frag_page(skb_frag));
>-				sg_init_one(sgs[out_sg],
>-					    va + skb_frag_off(skb_frag),
>-					    skb_frag_size(skb_frag));
>-				out_sg++;
>-			}
>-		}
>-
>-		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>-		/* Usually this means that there is no more space available in
>-		 * the vq
>-		 */
>+		ret = virtio_transport_send_skb(skb, vq, vsock);
> 		if (ret < 0) {
> 			virtio_vsock_skb_queue_head(&vsock->send_pkt_queue, skb);
> 			break;
> 		}
>
>-		virtio_transport_deliver_tap_pkt(skb);
>-
> 		if (reply) {
> 			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
> 			int val;
>
>-- 
>2.45.2
>
>


