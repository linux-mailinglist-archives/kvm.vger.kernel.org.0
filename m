Return-Path: <kvm+bounces-58015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32449B855C9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7E447A4481
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 14:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D473030CB4C;
	Thu, 18 Sep 2025 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jVvuEHXy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2DC28467D
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758207151; cv=none; b=szMLEuZWOfN+H4N2zIvYqmxuq7sMJo0ksGaIS1sNUcxjGi+3JW/7DrukXgoBuEcPPQS7VS6exWsvts9zi4bJLeg1xLPr1BcOiU9spsE+iTdaTFPjMe67MrRlwG9QZHnObVPNw8Y/5Z1gt0+GK0w1ezvjzAQFnI1eavnkCQzpdnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758207151; c=relaxed/simple;
	bh=877fy4JwCj6Yt7dwkYYuI8E/1ziIUPjIl8VIeeaY+04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cx7/0+dFlo2vrn7tBM/UPg3Tpy3/BtUYVWbyaof7TcHJmhUSoi+6qCA8/VBMfXnIbp5hVAYf29gV855ZJkuojlPGjcQGPpfxnni+gdOsYGqcpyzpjx8SGc3Q3RucaRuOMlZAOhxyiyWCSk0AXvcSUP+HvDE4TmMdKMTA4ag8k0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jVvuEHXy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758207149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4xuHLo8yzB0A9DafNx4LR5vIcuDhtQe+LRGJvMc0Qw=;
	b=jVvuEHXyyx2qRRl9+A8XcdWiFUC36jVy3Glzrc7VCHOMFIF700KlwkzHADd8FzKXHehWOE
	fH3SyKpjNf4y3VNMXsWBwa66EYZtWhp9J0FHaTVdffoCuyTAHfylPVU8brrwinyiCHHUny
	eA1AJ9rmMf03cJU8dyP6zJIMkaP9/vA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-pvdo4PpNPWS_fyulE5vxtw-1; Thu, 18 Sep 2025 10:52:28 -0400
X-MC-Unique: pvdo4PpNPWS_fyulE5vxtw-1
X-Mimecast-MFC-AGG-ID: pvdo4PpNPWS_fyulE5vxtw_1758207147
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ee1365964cso570706f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 07:52:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758207147; x=1758811947;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o4xuHLo8yzB0A9DafNx4LR5vIcuDhtQe+LRGJvMc0Qw=;
        b=jwXoQjYoq5d0DzTlr1DpvQkT9KS+M60NPNpKOSYV5VMdWGE8I4zAkKBCfMo0O48Y9f
         K5WSzRwwkOzj8lBZ9Ij/CJxR5/P/Kp2zHGYkrJqqLjwpLGISKVg1u5CyOZXkoQ04PzeL
         AU0k5n5Fx/4pxh2ZrTd9ka0/FEYxsyrlfQtS1pR4GC4H0kneWBxemh4CuzyQDi3/XKjO
         PujmFSSA0nJEIsU8jat7Det15q3iPSEzZVEiIcQKtN2fxW9p5K0PXRALh1sb1oE05HQM
         F8YYx7eciE9ObP9j/dOvu/mupDg7SDizfxAm/P8GKwQ72Ebu2cs7O98qpmqpSQADgjpW
         d/zw==
X-Forwarded-Encrypted: i=1; AJvYcCUaVyJM8jenIWLqSISgBTbtRTPxvxwFZTT4VKjWn6K26lQ5fcymRqoTpAJkt5BliXvenR0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAu7/uMdiAyo0r4r49DpbY7vFllp7XOERIbVv6QjrVbbfSJIxi
	6L2rDPxlS2Sb9vpyJzO7PzXxkNJlflidhzMNsy4jek1u7ZbP4Z1peXjkWNCVzU61M11+T8M1Sqp
	OLPQadQ4pqHzO/KSZpRcA9mg5gfRuiQoBdw4lEpRUG+LPACGvaHjfyQ==
X-Gm-Gg: ASbGncs3TI5SWcI1CabIYuQGCHisXsmyaIhsVbsIVGaUVBfrOWfNaIIbkGuruGs2gQT
	Lrwd7bPVbWLZdu6n8dpNbDzWhgA1iNelMoUIuLiAXKH117j7AcLCt72kEBptta4KaWiZYBDwYHP
	eZg3YAU85Iqn/uouqRrlR0AuIliZIEBxVtdWGy0nXgsndR8FoTmRSvr0W66azRUnL/TXAmGz6Hc
	475gYqNDChNztnmPpiL93hQsOn57x58uDhI8UsiscIg7ieaeBW24csO6s/NgYVIlqykDFLQVPvH
	6fascuuB7W8htWWblYJZtYJ3FaUudNaO/WA=
X-Received: by 2002:a05:6000:430c:b0:3e2:4a3e:d3e5 with SMTP id ffacd0b85a97d-3ecdf9bbb14mr6283925f8f.22.1758207146763;
        Thu, 18 Sep 2025 07:52:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqwMRBHuFFqMWYMrzOGs/Y1LvHSUdwEyMMdSeQZSTNEKri6ViSDAyQsaqS+nlL7xHwrs2MhA==
X-Received: by 2002:a05:6000:430c:b0:3e2:4a3e:d3e5 with SMTP id ffacd0b85a97d-3ecdf9bbb14mr6283908f8f.22.1758207146339;
        Thu, 18 Sep 2025 07:52:26 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f32083729sm61479685e9.0.2025.09.18.07.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 07:52:25 -0700 (PDT)
Date: Thu, 18 Sep 2025 10:52:23 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: eperezma@redhat.com, jonah.palmer@oracle.com, kuba@kernel.org,
	jon@nutanix.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH vhost 1/3] vhost-net: unbreak busy polling
Message-ID: <20250918105037-mutt-send-email-mst@kernel.org>
References: <20250917063045.2042-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917063045.2042-1-jasowang@redhat.com>

On Wed, Sep 17, 2025 at 02:30:43PM +0800, Jason Wang wrote:
> Commit 67a873df0c41 ("vhost: basic in order support") pass the number
> of used elem to vhost_net_rx_peek_head_len() to make sure it can
> signal the used correctly before trying to do busy polling. But it
> forgets to clear the count, this would cause the count run out of sync
> with handle_rx() and break the busy polling.
> 
> Fixing this by passing the pointer of the count and clearing it after
> the signaling the used.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 67a873df0c41 ("vhost: basic in order support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I queued this but no promises this gets into this release - depending
on whether there is another rc or no. I had the console revert which
I wanted in this release and don't want it to be held up.

for the future, I expect either a cover letter explaining
what unites the patchset, or just separate patches.

> ---
>  drivers/vhost/net.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c6508fe0d5c8..16e39f3ab956 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1014,7 +1014,7 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
>  }
>  
>  static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
> -				      bool *busyloop_intr, unsigned int count)
> +				      bool *busyloop_intr, unsigned int *count)
>  {
>  	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
>  	struct vhost_net_virtqueue *tnvq = &net->vqs[VHOST_NET_VQ_TX];
> @@ -1024,7 +1024,8 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
>  
>  	if (!len && rvq->busyloop_timeout) {
>  		/* Flush batched heads first */
> -		vhost_net_signal_used(rnvq, count);
> +		vhost_net_signal_used(rnvq, *count);
> +		*count = 0;
>  		/* Both tx vq and rx socket were polled here */
>  		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, true);
>  
> @@ -1180,7 +1181,7 @@ static void handle_rx(struct vhost_net *net)
>  
>  	do {
>  		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
> -						      &busyloop_intr, count);
> +						      &busyloop_intr, &count);
>  		if (!sock_len)
>  			break;
>  		sock_len += sock_hlen;
> -- 
> 2.34.1


