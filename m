Return-Path: <kvm+bounces-63579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8E5C6B22B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 1965028D0B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CB3C35FF63;
	Tue, 18 Nov 2025 18:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gbSD2g4i";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bgobyGdq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFB0339B20
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489566; cv=none; b=hbRQdfPnBcwPjbYISuPRCw3puOh1ALGiNH3FYchYJbl4zGEUEUneMcEwoYOPiAcWVPa0wwVbHMPu7tqixNI4N2dr4X5nlldpFs1o6GySsfa/htFQXoaGPrd+sjlxh/rNbf/HAGMqdkcWkyiDfUtxH0H8+ynEdHdGYDRBtliEW+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489566; c=relaxed/simple;
	bh=er1J307+KJnRBNUgsTZ17cqFXn2zardiLpzpxp0mLOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vi02hAKZVQKimF+pOdKBvLvtKQlBnVwGFh82tPF7SOa7tyLtMsH9nmo8r9U0nTWI/V/E/VeKNuvdurBYrq6ka6csafipqtroLGc9EJ13AC0HSd/FV9nM8MmO+gTWEkxR+88wfH6iIyODTFWj3wEtW/ReJTfQ4o0bs1QAtP1yma0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gbSD2g4i; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bgobyGdq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763489563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+h5sKZ9VJjMM8mERtb5Zt23BghZJxFGhKJW89VCOck8=;
	b=gbSD2g4iiIEB9AJFemhWr27zXXtkHP6FmT4PwYOBzzMjtFysavo332E3PD0FRKKTEyBUII
	eDAR/YXOgqACCBWPSaWDUgZrYrbmq/y4uXlwpa3Fh0BT58LAlunlms7R/rbi0lCCxgPn8c
	qyNWycF0aZWz/rTsPJpVxVKVZtaB/x0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-qxegAQZ_PVOlGe1g6HkVNw-1; Tue, 18 Nov 2025 13:12:42 -0500
X-MC-Unique: qxegAQZ_PVOlGe1g6HkVNw-1
X-Mimecast-MFC-AGG-ID: qxegAQZ_PVOlGe1g6HkVNw_1763489561
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so26359815e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763489561; x=1764094361; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+h5sKZ9VJjMM8mERtb5Zt23BghZJxFGhKJW89VCOck8=;
        b=bgobyGdqdIbD62/NuL81F0Tvj+BcEyw97DZXBgJNbFZAg0aeRiTWj+2OVIubV2pksc
         8iujT4+gm/6CqOV2YwO1Q+p6mZhGQFD0EtnuutRLco1NI/LtVnpJVsv2iBtsP4XzaaqG
         pH3PvZCsozAuKHOThSbGn06chBFgB+zEzbMyGfbcerFCevVKy+ictSQCw2CXnueqUIH0
         e1NUNI9PBgG1/8XFw+lT33XYdZoTvlka2X+6whpne1F4vCwQWozeHo3hKx+ADbmV1FH3
         MuHQ15MRDQEj+FQAM9InHW8gbDAjdrOWJQcoTTJxx9BSFanNlKiB0+vngx5lgnwdBYP6
         /WFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763489561; x=1764094361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+h5sKZ9VJjMM8mERtb5Zt23BghZJxFGhKJW89VCOck8=;
        b=rnKTAkZZ8vIHYS8AQ9wSd0YZ22zCd6/IV2c1LLN4LgQhBmsGr8LU5fbzH1Sa2b6j4B
         hefKv0lXjVtItl+GIBMg6JHsz1mZGce7SCDEvtyX7XocULLgPAzGSBCqMPju31Mzm7KC
         YbjtSE2j78ne0LMxlotVK5qXq84nJjvKsnCqh5cjgVtY4tOYXQIbd/WFwJh29M/ln+Z3
         XJIfgQqC6ubqHl6wvRP3aRGeX8QYftSq9wfn/e+FWUynEcfcw8LMV8b3DIKrXHH/3FNi
         cdSvAfAMPSOpaG+RcHB4TZlLjITxnwGewaNeA7Rt0M+0rIsGpUhlg4egxbjgudfF2jwb
         1wfA==
X-Forwarded-Encrypted: i=1; AJvYcCXpxxV4FhzrPtJlWzcGFAsLUra0WM8bGjWxgNRxnM5D4szSzJd2DMrzZ7eSqirk5H++2hY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYP1Uardm/Osp/XMUAtwNqJfW5VSqnDNa+2CB7vsmiduLnZCVW
	H6G6eDViOWxJxgKQPeIw1tXR5Q4DcHj9Iq78QVHjsBaauGMoEu4b+NL8wXht4jEfi95y/QO+yWa
	PcMz+NBALP5vWLkFP7v4xmmVONLlVtmS234O9foju+7+GVsnyFq2dgw==
X-Gm-Gg: ASbGncv63K61LQAGbUlkw9+MIFkE4wWj/8KwvHwblIkULLgJsUJv07UBG1qsBByLwTX
	uZhcI8UcghWptNcb1HBYeZSVqsKBlAUOf7dyo4gBDgtW2SANLS5i9SdBrkeQ64BZBy3Dd0btqL/
	yuHFlTnufX4/KdbYtlQP1Wi9By/1aPeSgjNg/kZ/aYal74Xpu0YXhXrXhtVMDLl/huKb83xXP15
	AMlFgPh07TcVbqTIB799PAso/05XfPQ1S5vRO9jjaGKmV0MJ+DMw1K3UQi5WVExpQbH0Idpa1E0
	gtjjuUfQfDwVUOvnQBrgJzwMX/6/JTWlKUDp0BEvpYxmiVP7usrZ9B+RhHevWp/3GWrq5UNVgrr
	h5tW2vgG5gH6BQEbdXr/boCnmAq8c6V3MB274qOwDARjvWWcgsDXL0llMcok=
X-Received: by 2002:a05:600c:a43:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-4778fea84e4mr144928425e9.32.1763489560850;
        Tue, 18 Nov 2025 10:12:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOpTmbeuBuF6OCuotMnf25yLK3sUbAbvYEMuVVlK2CBmGppKS9Ccp0DvA2VuQ7IZI1U9CwzQ==
X-Received: by 2002:a05:600c:a43:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-4778fea84e4mr144927985e9.32.1763489560327;
        Tue, 18 Nov 2025 10:12:40 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-250.retail.telecomitalia.it. [82.57.51.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b10142d3sm4356375e9.5.2025.11.18.10.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 10:12:39 -0800 (PST)
Date: Tue, 18 Nov 2025 19:12:22 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v10 05/11] virtio: set skb owner of
 virtio_transport_reset_no_sock() reply
Message-ID: <zwpwgzf6opt2qiqrnpas7bwyphpvrpjmy4pee5w6e3um557x34@wnqbvwofevcs>
References: <20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com>
 <20251117-vsock-vmtest-v10-5-df08f165bf3e@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251117-vsock-vmtest-v10-5-df08f165bf3e@meta.com>

On Mon, Nov 17, 2025 at 06:00:28PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Associate reply packets with the sending socket. When vsock must reply
>with an RST packet and there exists a sending socket (e.g., for
>loopback), setting the skb owner to the socket correctly handles
>reference counting between the skb and sk (i.e., the sk stays alive
>until the skb is freed).
>
>This allows the net namespace to be used for socket lookups for the
>duration of the reply skb's lifetime, preventing race conditions between
>the namespace lifecycle and vsock socket search using the namespace
>pointer.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v10:
>- break this out into its own patch for easy revert (Stefano)
>---
> net/vmw_vsock/virtio_transport_common.c | 6 ++++++
> 1 file changed, 6 insertions(+)

IIUC the previous patch only works well whit this one applied, right?

Please pay more attention to the order; we never want to break the 
bisection.

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 168e7517a3f0..5bb498caa19e 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1181,6 +1181,12 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 		.type = le16_to_cpu(hdr->type),
> 		.reply = true,
>
>+		/* Set sk owner to socket we are replying to (may be NULL for
>+		 * non-loopback). This keeps a reference to the sock and
>+		 * sock_net(sk) until the reply skb is freed.
>+		 */
>+		.vsk = vsock_sk(skb->sk),
>+
> 		/* net or net_mode are not defined here because we pass
> 		 * net and net_mode directly to t->send_pkt(), instead of
> 		 * relying on virtio_transport_send_pkt_info() to pass them to
>
>-- 
>2.47.3
>


