Return-Path: <kvm+bounces-17528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 848718C767F
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 14:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B42A01C20B44
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 12:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15B78146D49;
	Thu, 16 May 2024 12:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gt1Us/Dd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8DB1E511
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 12:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862802; cv=none; b=TAd/yfNT5QknWPaPaVAqCP0yoLgCzoe7L9FhV9zdTyD7w+PBc1VqNv90NFWI83em1WqJ8CCCZsT6jfoZK9KiehEFlFkcMkHKUb1cmGVUJWG8Sy0LtT95nvD0+3FK70p9GvpPY5UaEW5oF4PgSC1Xfa1gS6MMLtmhFnm5pFWTHp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862802; c=relaxed/simple;
	bh=kG4YbPhbEHf2GsE98OI9GeD5VDcN/gjk8FDCVUgYQOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=is/WfmYs0UE/41KxfF9DctxO7c7SNpSHz9vIeaR8UEueCEMAh+4Ou0Tyz6q+nZITEd1GmhVqozN0d6WxoaYIi3Y1/bwM1KMcsqD2AcbcxNzRkVP4eIo/GdLKUj4oUAVMRL35X7ACG35vTWVVywfFA/qr/QWuZ7sraij4zTBuKS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gt1Us/Dd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715862799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8tTC7ohyTAFY3GRYmUhC1nAYpxmmnw9+Ospuc7sYSlA=;
	b=Gt1Us/Ddt+6NnuHrn9J/tMhy+3Oov14sAj7m8EtM4hFmqCvL3nnYrEgyho9XNCoTJkxPS5
	eriO1U2kU96kejy/zzxiIPSvgm3ParyBuG+A/Tdd7fPTEXFTRyVL/n/FrUhM+eZcW5cQKK
	rg10iPkCAAsZz4wSpDO1BOOzebxOPq8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-jsnCwYdnPvyYtRhNKpdjwA-1; Thu, 16 May 2024 08:33:17 -0400
X-MC-Unique: jsnCwYdnPvyYtRhNKpdjwA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-574bce0f824so3462346a12.1
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 05:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715862796; x=1716467596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8tTC7ohyTAFY3GRYmUhC1nAYpxmmnw9+Ospuc7sYSlA=;
        b=ZtP7KqIcpE1lIqS2eg0cbqoA3RLBbWKczqfIEBRAELrkWjHn0hErObGNosK0Q0jtPj
         A1Q/E6zWvsjgzJh5Iy37oGzNeNcA9qjNEkoBo9BebvrhS3WipMAub7SOOOrIaxOrYXWM
         y3h/td4id+Fe6JtR6kkntBwKfNJEuanbvwW1+LFQoDeDbZavogAMqXC3j9i3wyKPhcRt
         11TqNFC9LVHvtRvtogHI/WyytjQlHqnyqzD99WDRdVmPJUDWWOtroVH3GMZBVCby6dhj
         CVBW5yGaXWXJAZxezXIyLCIVBBNjhFo0lEc64PxHPZ+WbdY5z0kapykceWi2HuWYrInn
         l96g==
X-Forwarded-Encrypted: i=1; AJvYcCVV7JUFLEXHzLDdFgVyTyJLA3bkTBAgkl8QhpZZfMHNc7z7y0OmbbRdFCkQFYRMR3KGfNp+qVqZ00oJD+5b6G+vOAUY
X-Gm-Message-State: AOJu0YyTSmI5a1ngU7tVNlk18NkESjgx2m/GgUoKi/m3OkWkkkIcPMPf
	lmyPLTU7gKrz9QkIVQh4fwIXqXkPx4UyrbX/O8YvG1GK4fypU0TmW/cQRrI3XIk1qnkA4fcgpgH
	3vQnrGwds1Cu5Hxx77svAPgBjCoMqUglSxTYJ08jbufXTWSwsJg==
X-Received: by 2002:a05:6402:13d3:b0:572:b83e:e062 with SMTP id 4fb4d7f45d1cf-57332686076mr22078706a12.3.1715862796007;
        Thu, 16 May 2024 05:33:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCxXOUkrsCcpZ7D9SIlwb/5j8SMjlf2OmY4LpAd4O74EkS4uDCh+dxB/DAz92Y/peO5r9Xkw==
X-Received: by 2002:a05:6402:13d3:b0:572:b83e:e062 with SMTP id 4fb4d7f45d1cf-57332686076mr22078674a12.3.1715862795469;
        Thu, 16 May 2024 05:33:15 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:443:357d:1f98:7ef8:1117:f7bb])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733beb89e7sm10768239a12.21.2024.05.16.05.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 05:33:14 -0700 (PDT)
Date: Thu, 16 May 2024 08:33:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	eperezma@redhat.com, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH] vhost: use pr_err for vq_err
Message-ID: <20240516083221-mutt-send-email-mst@kernel.org>
References: <20240516074629.1785921-1-peng.fan@oss.nxp.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516074629.1785921-1-peng.fan@oss.nxp.com>

On Thu, May 16, 2024 at 03:46:29PM +0800, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Use pr_err to print out error message without enabling DEBUG. This could
> make people catch error easier.
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

This isn't appropriate: pr_err must not be triggerable
by userspace. If you are debugging userspace, use a debugging
kernel, it's that simple.


> ---
>  drivers/vhost/vhost.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index bb75a292d50c..0bff436d1ce9 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -248,7 +248,7 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
>  			  struct vhost_iotlb_map *map);
>  
>  #define vq_err(vq, fmt, ...) do {                                  \
> -		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
> +		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
>  		if ((vq)->error_ctx)                               \
>  				eventfd_signal((vq)->error_ctx);\
>  	} while (0)
> -- 
> 2.37.1


