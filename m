Return-Path: <kvm+bounces-51039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 65144AEC39E
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 02:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B10BE4A3D34
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 00:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2270E17799F;
	Sat, 28 Jun 2025 00:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZRHU3bk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664215E90;
	Sat, 28 Jun 2025 00:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751071707; cv=none; b=It5cRIhuo57blc6UoC3raX+XHPkZ/aNx80XMZiT2sq8Vv4J4EMVIXSPbRAXKyREOE5cWVjjFcGyfSB15RY6W9PBE3AwLsyNJKY2+rtCua0EOTRW5GBMRxB8AS7cabIejA4hLOHBRX7v5erhjfptYtVLzooJUgEX0fMHeaf8zn6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751071707; c=relaxed/simple;
	bh=3gPdAhZcL0dOsBkIzlRz+fs3n8dByysDR60VQ4rRQl8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wt7sh2xR1Ao0zfAX+VwbyNvZWntWtsJha7abS+XU/+OvC0P5X0PgA2DHQOXlDYINk/cvjtEn8X7M3ry6mOpshn3jYQWZcUnvEKI7oZECFie78y5t79fhsGhAYILDcUWhkPYu7r8lVFsCiWSYAXqIp5kRA+qlNw1x97wu5jk6Gdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZRHU3bk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5627FC4CEE3;
	Sat, 28 Jun 2025 00:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751071706;
	bh=3gPdAhZcL0dOsBkIzlRz+fs3n8dByysDR60VQ4rRQl8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dZRHU3bkHtCYVhMXXvK9PHYgC7UlosoEY4rL3ruXnOMGYPiQbr0hZwpuLFxwPY2nM
	 Y5GgLFAclJr9lEkNk2JPOZYdLDgMKyZqD/FeTN2UrPbZaWSx9o/2CmxpLPXljWZLzo
	 7TrMUg8A7b1FP7Gh+UJurO6N7ZwgeLdSLB8C1D449MvW9XUCCb3zJJkmilwSssNt48
	 N6kcFocltCjC6wh46B3QgvYOxkQ17EFy7x75Crg4pn6AApjGRBV3+GTVRp1VTdeKX3
	 VYZZBbjWnM2b3WyCEhcETxtGIhvt6BT8Q6Dc7C6vaw3DU3YQPzzGXBw8nFn8yPmsa8
	 hMybBbKowGrUA==
Date: Fri, 27 Jun 2025 17:48:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 mst@redhat.com, eperezma@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V2 net-next 2/2] vhost-net: reduce one userspace copy
 when building XDP buff
Message-ID: <20250627174825.667e1e5f@kernel.org>
In-Reply-To: <20250626021445.49068-2-jasowang@redhat.com>
References: <20250626021445.49068-1-jasowang@redhat.com>
	<20250626021445.49068-2-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 26 Jun 2025 10:14:45 +0800 Jason Wang wrote:
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -690,13 +690,13 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>  	if (unlikely(!buf))
>  		return -ENOMEM;
>  
> -	copied = copy_from_iter(buf, sock_hlen, from);
> -	if (copied != sock_hlen) {
> +	copied = copy_from_iter(buf + pad - sock_hlen, len, from);
> +	if (copied != len) {
>  		ret = -EFAULT;
>  		goto err;
>  	}
>  
> -	gso = buf;
> +	gso = buf + pad - sock_hlen;
>  
>  	if (!sock_hlen)
>  		memset(buf, 0, pad);
> @@ -715,12 +715,8 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>  		}
>  	}
>  
> -	len -= sock_hlen;

we used to adjust @len here, now we don't..

> -	copied = copy_from_iter(buf + pad, len, from);
> -	if (copied != len) {
> -		ret = -EFAULT;
> -		goto err;
> -	}
> +	/* pad contains sock_hlen */
> +	memcpy(buf, buf + pad - sock_hlen, sock_hlen);
>  
>  	xdp_init_buff(xdp, buflen, NULL);
>  	xdp_prepare_buff(xdp, buf, pad, len, true);

.. yet we still use len as the packet size here.
-- 
pw-bot: cr

