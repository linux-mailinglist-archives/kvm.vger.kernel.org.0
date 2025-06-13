Return-Path: <kvm+bounces-49357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F24AD80D8
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 04:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 417D11E290E
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68CE41EFFA6;
	Fri, 13 Jun 2025 02:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BopHJtLS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B76D2F430F;
	Fri, 13 Jun 2025 02:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749780961; cv=none; b=VzbmOhxECD6A/7KqxfT5jf1MxYq9nCyL1Du0b+Ww1SO7sUqUAJgP7DNyTcI/RHZ451W6o03tSBpAbjIuZS59NqjsJs63utc6F3Zi6AasXl98e7nZUeanAmZFGnYbYbVUOmL7VqXk/gv2wdtHov7+nYhOYqbBUCEEhn7y0Ueee8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749780961; c=relaxed/simple;
	bh=hhA4hRWSrpkLSGj8Jisx6+n8n8ogU+EaoUZol/upAgE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=jQbuG6KcOqQi5qacnj+8Xtyv3XCCQ2IhVECOQI14mDugqBpn/VywItd+j5NGWl4kF/WcOC47+yyhz6W3zep8HqinLaM4u719lBw7nOn9IGl0VUIixyvCoWpfi/8Vy6GLl0VGPzLlksPCDSqoGvMxFikuED4dAdMpHuDmQOPDAWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BopHJtLS; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e81ec95d944so2389696276.1;
        Thu, 12 Jun 2025 19:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749780959; x=1750385759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A4OSg9tMv2M+t3/zopdwTDlZ3XltE4WsKCLg6MjL/6Q=;
        b=BopHJtLS9VsHl+2V1s5uB9PqfkX6mXF3vM7JoKcZEdcqTNW8a7lnkFkgMuILSUrPzU
         VGGEEowuaqkruLBGHfCV986CYblXjCZPBIMa/dIUxGGOXJIVyPY9wKpMlXSFqHHJkllc
         DziJFi3nyMVEBXsr8mEJzo1y8ZttAOGm19w5hQJNMS3V0S7ZfuKstzjaM4HQWpC7lEds
         hXD4hTpZay2o3nclMZC9pi0vRigPH5AAYY2RtizwVQVtaN6U8Pt4m+g3UpaVFRw+sZLb
         YmK4iDFTWKL/rxiEuyUq+k/JERhAbydAMHjWAsqqMMjWtHwkjEmRL2yomkldNcm6ExLq
         kl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749780959; x=1750385759;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A4OSg9tMv2M+t3/zopdwTDlZ3XltE4WsKCLg6MjL/6Q=;
        b=qy4tWPv71pkx3G5UKR497o6pdnqD0k4aTUY5AL8jXWe3a1mspjonYganBMs1Wq+7aa
         mjKoPmMhKFOYxdrxU2FhTGY+cZ6So+nkQyPpyRu5YKOpxg4ebiTGmlpraCKh8cqysniP
         xc284n8Aaqc0dD06l6Zc/vtPvTAapKQlURXmhU4T2WnVyMGw0jHO6OjfDHe0uJUWgUnj
         aa2y8c0poKaWEPGLSPQNuJID/06Elj6HU2SgL52v1lAeX7K9TN7SwI2d5flR635C9KVd
         O+zvmFXeDDstBvZteVtNsdqXvQP8naJd52+MwvVkHMUOECTcIl9x8cnGe6Y7oB4l20lT
         wAAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTS/hG+ML2Zf8PEz3Quf8nvkL0mY8rmK1KO1wL73QUsmQmBbNGm1JnbbzR3Edp+Cy09zb17hoZ@vger.kernel.org, AJvYcCUhqteAwXCe7zGj8vHSIjIVcH/fnNHj0dK07SR+i5fOdqDr2Yl3iRh4+P8CYzpz/6qnUlU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBUkl7hODDyOc+xOisetvvYJ9K3weB47XqCUVi9yWmhP+JJBGH
	+1HUarR9KrdO0XSq9MkU1sYxSy+fPTnIzB2ZX9rT7sYCmbdyHezQ1CoRjF9JZw==
X-Gm-Gg: ASbGncuQueJZNYFFWH6q+DvFyt7JZSuTa74f/hWuN1FCW2RiniBsrAs/btLCAjo8MXU
	T51A1J0L8tndnjXIUg2bWwOhqn/+xMc4WHm2z8fG5RHDEYxmglTcAzxdoRumfq+wircgI8Hkq+u
	d6D8JLb3eRJ0yXmrE+ATVPp65T/DMDGK/GYTQYy59VPZ/VRVicVIwojgR0LsYSHTnMEYA+Su6Cr
	KYgkNQd+7t+XcsEaCyTHo1PELMCwpOW/+R74sj1xo+rY68/ZAhT8q7+KMJ/+K4Y45xmlHR/g/e/
	ObHL4eD8tSIMjqyoD2T27dPzzf4o4j6gMaGjTX1noyhTXWIBRLatGcifg/5fb/F4uEHrmTyQsF+
	eh1bjP1acnQssu0Tw/F2vJudiJW8GDf5TEN3uWZIYHQ==
X-Google-Smtp-Source: AGHT+IFNJsQBvWYBgsCWdmxYYF6e6UN9FeyqBxn+1/yGfoGQcLpzsbu5qgjeR9PWb955JCwfENqtVQ==
X-Received: by 2002:a05:6902:250f:b0:e81:b5c8:3d71 with SMTP id 3f1490d57ef6-e821ddc2fccmr967447276.17.1749780959097;
        Thu, 12 Jun 2025 19:15:59 -0700 (PDT)
Received: from localhost (141.139.145.34.bc.googleusercontent.com. [34.145.139.141])
        by smtp.gmail.com with UTF8SMTPSA id 3f1490d57ef6-e820e09d3ffsm813581276.23.2025.06.12.19.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 19:15:58 -0700 (PDT)
Date: Thu, 12 Jun 2025 22:15:58 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Jason Wang <jasowang@redhat.com>, 
 mst@redhat.com, 
 jasowang@redhat.com
Cc: eperezma@redhat.com, 
 kvm@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, 
 willemdebruijn.kernel@gmail.com, 
 davem@davemloft.net, 
 andrew+netdev@lunn.ch, 
 edumazet@google.com, 
 kuba@kernel.org, 
 pabeni@redhat.com
Message-ID: <684b89de38e3_dcc452944e@willemb.c.googlers.com.notmuch>
In-Reply-To: <20250612083213.2704-2-jasowang@redhat.com>
References: <20250612083213.2704-1-jasowang@redhat.com>
 <20250612083213.2704-2-jasowang@redhat.com>
Subject: Re: [PATCH net-next 2/2] vhost-net: reduce one userspace copy when
 building XDP buff
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Jason Wang wrote:
> We used to do twice copy_from_iter() to copy virtio-net and packet
> separately. This introduce overheads for userspace access hardening as
> well as SMAP (for x86 it's stac/clac). So this patch tries to use one
> copy_from_iter() to copy them once and move the virtio-net header
> afterwards to reduce overheads.
> 
> Testpmd + vhost_net shows 10% improvement from 5.45Mpps to 6.0Mpps.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Willem de Bruijn <willemb@google.com>

> ---
>  drivers/vhost/net.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 777eb6193985..2845e0a473ea 100644
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
> @@ -715,12 +715,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>  		}
>  	}
>  
> -	len -= sock_hlen;
> -	copied = copy_from_iter(buf + pad, len, from);
> -	if (copied != len) {
> -		ret = -EFAULT;
> -		goto err;
> -	}
> +	memcpy(buf, buf + pad - sock_hlen, sock_hlen);

It's not trivial to see that the dst and src do not overlap, and does
does not need memmove.

Minimal pad that I can find is 32B and and maximal sock_hlen is 12B.

So this is safe. But not obviously so. Unfortunately, these offsets
are not all known at compile time, so a BUILD_BUG_ON is not possible.

>  	xdp_init_buff(xdp, buflen, NULL);
>  	xdp_prepare_buff(xdp, buf, pad, len, true);
> -- 
> 2.34.1
> 



