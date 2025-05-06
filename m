Return-Path: <kvm+bounces-45581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B67AAC046
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 314F74A54FC
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B703126B2D5;
	Tue,  6 May 2025 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LXn2TU4D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4022C442C
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746524704; cv=none; b=Vb9HwRNFZHFRvoDioeDWDS6izKea59HYbj0GNCe2eWWzvo7J1ofOXrpXDj2nuANm4ng4a0ir+/Nogtf49+8QSaOLsGkEvaBcDSq7tFZ9t1+/WWtuc4SgvHkpKEP5iom3a2OXh0M2/dZX2/Dk2NNEMIGgZDushaiP6iJz5/3pL+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746524704; c=relaxed/simple;
	bh=XtmhV9BRgG8S3EP7Ij8mgx59xV75hcQcMAEky/2dcT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R0rwlnXq8/zNZ9SfTyoosLEISvAnWGRzuyAWbcTrZKjrekZpHOsaKphQ/WG2HBDpO4aYa1keokl6Rzo+Pyt3hatECtMrsCRGzY647wpd0/ueiNQlSG8FSpusCNL4EAFZRMQmaResUzx+2J9JuiyUdXr9lYptL8nAXaA4jkoOur8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LXn2TU4D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746524699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ywb7zRNx3vPc7CyeVZadCCnMzE2V02v3OC1ITxjbuEs=;
	b=LXn2TU4DHABlMpmsCyXkxAMIAwg9JkYX755mUqS0McUHALfnNuoSRNQWDPTKGJNAxldAkr
	GTK9p9XiEy+8ULjJIHW6FkXugc/4q1GGmEOay8FCkZfobGh2MsOTEsKevw5k6+tBFfAwjK
	rdbwxGik2fPB2UOAO5Z0W/A0X5hHAw8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-Ra7aLm4RNWqKvpngJTiLdw-1; Tue, 06 May 2025 05:44:57 -0400
X-MC-Unique: Ra7aLm4RNWqKvpngJTiLdw-1
X-Mimecast-MFC-AGG-ID: Ra7aLm4RNWqKvpngJTiLdw_1746524694
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-acb23361d73so612190866b.0
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 02:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746524694; x=1747129494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ywb7zRNx3vPc7CyeVZadCCnMzE2V02v3OC1ITxjbuEs=;
        b=TibSvwexAtsqKf/8itFh9RZT97nXDmgO+23BLO7OzKe/7bmgUjnP+ip1iEhIPdLfTE
         Ja1mh8VD6l+rNKOo5xlbGIjHqCVZ4tnAq1ZOWa4p8wUVsZ/rEsEBANjtQ9PNSKfqQmGW
         L0Lc1tMhF6yaerop3jehjZqjerWz9L/mwu+jGKKIzXbipI3qr4JxQAJFk6PQEzV+63M+
         mDJ9cq+ZY0NISfgLprP0MZcEndWZQnx3epAqnZ0fZFl973SCUcYjeAmTBZn0hpcWecTA
         hS7g53P8swGLxREozX/tiGrRcrL00YqQf57AKuUFKEPF/zWuhye93FBoP1Up/vgR3CvL
         LQpg==
X-Forwarded-Encrypted: i=1; AJvYcCWcfh5nOdppZc4mdKZLF1qa5dfU6m/sT+udYdTbH/eT0PkhsiTTu1IbTDs6BZgViNEM9b8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD8Ocg5xFLeiZgZNpy8bdf1oc1c0vpl1WP4QDM9J+mncXYlD68
	+z3yOYVS3MvTDyrsSnJnczHi0uRcZViMUbPhdqhyzZhxEMkJgOF2VaS26/RwZBBCavkvL79XJGl
	UApyoto4luzNg8ptcpaJM8UBm72qYw7SQuC6Yp2dReLTlp+FKrw==
X-Gm-Gg: ASbGncuclrat3iX40sFOf8ZHr0z+L2CVcLFMquBtxAt+TIWL630JPhCq2VfbrZlaESN
	qx4IfDMmykTUUbY3LsmgR8I6cGZJ/MEQ/7NPUIBmbWusWt9ElrSAsD3ctm05OglZNiehwRJiRAp
	ELYhVKTFgPh+//IQm0qkv+SzVwj03r6e0asqIH30DZwWhmJ0OIyFfKfOAYySxlPZjcYz5sHv3pW
	k9bpBwV4sGixdXc7Z2iil8knZ2CThnFNsEmnLv13qqK220iIQil7bjZBbqyfrZZbwuAs6riu/OW
	pDi3JyF6B1oaK+BPbQ==
X-Received: by 2002:a17:907:720e:b0:ace:c47c:d05 with SMTP id a640c23a62f3a-ad1d2edb5a8mr271264566b.17.1746524694211;
        Tue, 06 May 2025 02:44:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEy3Ipkv1JwfR8lsrwW2awsV3Xlbn5tYIVtWI1ItVLrYmS6wlQhRVbeVxW3XdsKsaomx8V8tg==
X-Received: by 2002:a17:907:720e:b0:ace:c47c:d05 with SMTP id a640c23a62f3a-ad1d2edb5a8mr271260366b.17.1746524693669;
        Tue, 06 May 2025 02:44:53 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.219.197])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad189146991sm676458966b.14.2025.05.06.02.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 02:44:53 -0700 (PDT)
Date: Tue, 6 May 2025 11:44:44 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] vsock/virtio: Linger on unsent data
Message-ID: <2latqq7jrneyimj6okjbarofnksmgwddwq2eie4mforjrjaxwv@jjbru7irkyyi>
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-1-beabbd8a0847@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250501-vsock-linger-v4-1-beabbd8a0847@rbox.co>

On Thu, May 01, 2025 at 10:05:22AM +0200, Michal Luczaj wrote:
>Currently vsock's lingering effectively boils down to waiting (or timing
>out) until packets are consumed or dropped by the peer; be it by receiving
>the data, closing or shutting down the connection.
>
>To align with the semantics described in the SO_LINGER section of man
>socket(7) and to mimic AF_INET's behaviour more closely, change the logic
>of a lingering close(): instead of waiting for all data to be handled,
>block until data is considered sent from the vsock's transport point of
>view. That is until worker picks the packets for processing and decrements
>virtio_vsock_sock::bytes_unsent down to 0.
>
>Note that (some interpretation of) lingering was always limited to
>transports that called virtio_transport_wait_close() on transport release.
>This does not change, i.e. under Hyper-V and VMCI no lingering would be
>observed.
>
>The implementation does not adhere strictly to man page's interpretation of
>SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
> net/vmw_vsock/virtio_transport_common.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 7f7de6d8809655fe522749fbbc9025df71f071bd..045ac53f69735e1979162aea8c9ab5961407640c 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1196,12 +1196,14 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
> {
> 	if (timeout) {
> 		DEFINE_WAIT_FUNC(wait, woken_wake_function);
>+		struct vsock_sock *vsk = vsock_sk(sk);
>
> 		add_wait_queue(sk_sleep(sk), &wait);
>
> 		do {
> 			if (sk_wait_event(sk, &timeout,
>-					  sock_flag(sk, SOCK_DONE), &wait))
>+					  virtio_transport_unsent_bytes(vsk) == 0,
>+					  &wait))
> 				break;
> 		} while (!signal_pending(current) && timeout);
>
>
>-- 
>2.49.0
>


