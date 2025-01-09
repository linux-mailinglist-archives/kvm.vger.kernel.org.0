Return-Path: <kvm+bounces-34880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6487A06F0D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 08:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCB0A3A30FE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 07:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D07214808;
	Thu,  9 Jan 2025 07:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0lkGLKM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196F6201036
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 07:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736407903; cv=none; b=AU+TCCB4JRy3Gl5T5xVGojEVC6OnjfJMdirCEjUu8KLlSEQ13sFZccwyYKmOlW/jb2zwDt6eo2elUQ7XCFisp2GPijjvhr0ACvk6lCdpoIOjLlrL9oH4pZTqaY57So5bNseUlArRr+i/IwxBtBI70F1J3SBDatbDTtWLskZUagM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736407903; c=relaxed/simple;
	bh=rBPdYEnZvtSaWGeIKaMzYx3ocXn/sfrS1kD4E5tn0hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKriXcvFpb2Vz2MR8x9nfiXrCFS7jbAV3tmyKJPUMyc1LxkZdjKbwEjKA8cT2T74MDaVKtUdgbeFIVXC7V5rtxxeKvdQ5MCyHA2P+eu7f6VvdX5y39WP7YlLt2ZNojQD3H4+maty4tmG9cyHbFJMvYytQQig+w1VXMHnkOZcCPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0lkGLKM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736407901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pr4ssIrc4EtFfekk83GYUXsTrXGomg6Zpaa+C070Fnc=;
	b=K0lkGLKMUBXU6NSdPQsjULTBgMrkPptPl6FkLRdPDD2+VM7CYqTYALxrYhrXpQb72pczqW
	wtz4BKv5Vy1NTzSa99qSe0fkPfFhHQHflje+Ht4L8K8iQnDFKLiTifn12fk3a4UVe7ksqH
	RFLwf70wP5mxphD3v2TPn8XnEMCA88U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-ZPLj1nz3NCqqslY9fQBDXg-1; Thu, 09 Jan 2025 02:31:39 -0500
X-MC-Unique: ZPLj1nz3NCqqslY9fQBDXg-1
X-Mimecast-MFC-AGG-ID: ZPLj1nz3NCqqslY9fQBDXg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa68952272bso68432766b.2
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 23:31:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736407898; x=1737012698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pr4ssIrc4EtFfekk83GYUXsTrXGomg6Zpaa+C070Fnc=;
        b=HRILeGqZpuoedAM8u7cKCH5PoiYxedof+dT2BDlaQQkp7Ok6ZDZI3KY2CEqp+RI9d1
         573NzN2myQclBfSd5WQj5/khwza5JHVB2fRXnL8eUqnYvDIcNcA/Cx+ZmNXWT6NPHz2H
         5x03Bh2kUR6jGAEloAergje3ift+DTKkIxDy89jY2/CE5sLlIxoKINs7judtBSwC7mkQ
         fCLlHTuayIjO9hXmBAXuY/HaLiSX6qMA1lVEmNSLSfwqgA9f0LPVTH2wL7uGMW4429ks
         3u2W0cErP2MDTiupAU9e2mI/cbBzMlUrrVkNTOGRsVuO3VeSZv/bY+hbCVlh+zm1PtOj
         VcOA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ8DnhvjUYADA6oeH4CCy6sv+7RV9iLI5VonCaQhwAgRulTDPFUQOCGpqGnai9f4TmWRk=@vger.kernel.org
X-Gm-Message-State: AOJu0YylBPQpdnICKwJv2XbRfeXUs2ZbVVOVEE1f7Wa/ZEE1ZUTF/2GF
	kge6jRey1G1Rc/MyLwGwadYg46bTKI2geR9c4nq+AM/BU7QuxiPKIWK+Ckf7JwCKKO9LpH+SOhD
	/oo5vwg2AgpQ2JEeKj+o+uY4hQRBYKYXtKlaqNfXVahm4qqZ0hw==
X-Gm-Gg: ASbGncvnr3za4AL8NeTnvJKWZrTP975eALUEEqRC0K8Y9SF3DqJ0AxZtsrnOZH/haFJ
	I25TOJSVrkApYn25uR1WVOx7Z8pOj7vdZEs495x5dq1Qay63dHdyk2An30+9S6AfiD7naLECPec
	Iqg0N3dTTRh2PaV5mgivLhKd48RyKswmCjl0W1ptEnmsDFR1CrItVhrYbetuIN6q4GRESTzOJfU
	ESD3QYp7BQwK6bSYN52V0vLeCJTcSXCtWUDckCMESLAxDxz6gU=
X-Received: by 2002:a17:906:6a04:b0:aa6:800a:128c with SMTP id a640c23a62f3a-ab2ab6a8dc8mr488064166b.11.1736407897984;
        Wed, 08 Jan 2025 23:31:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG4ZKe0mzkcp2svj7dRwqQX0ex75ZtTovLeEL0VhHSiIUTDBhHXztbYHy36NKkZRj6x0d75Jg==
X-Received: by 2002:a17:906:6a04:b0:aa6:800a:128c with SMTP id a640c23a62f3a-ab2ab6a8dc8mr488061666b.11.1736407897607;
        Wed, 08 Jan 2025 23:31:37 -0800 (PST)
Received: from redhat.com ([2a02:14f:175:d62d:93ef:d7e2:e7da:ed72])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90638acsm42482166b.20.2025.01.08.23.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 23:31:36 -0800 (PST)
Date: Thu, 9 Jan 2025 02:31:30 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Andrew Melnychenko <andrew@daynix.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	gur.stavi@huawei.com, devel@daynix.com
Subject: Re: [PATCH v2 2/3] tun: Pad virtio header with zero
Message-ID: <20250109023056-mutt-send-email-mst@kernel.org>
References: <20250109-tun-v2-0-388d7d5a287a@daynix.com>
 <20250109-tun-v2-2-388d7d5a287a@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109-tun-v2-2-388d7d5a287a@daynix.com>

On Thu, Jan 09, 2025 at 03:58:44PM +0900, Akihiko Odaki wrote:
> tun used to simply advance iov_iter when it needs to pad virtio header,
> which leaves the garbage in the buffer as is. This is especially
> problematic when tun starts to allow enabling the hash reporting
> feature; even if the feature is enabled, the packet may lack a hash
> value and may contain a hole in the virtio header because the packet
> arrived before the feature gets enabled or does not contain the
> header fields to be hashed. If the hole is not filled with zero, it is
> impossible to tell if the packet lacks a hash value.
> 
> In theory, a user of tun can fill the buffer with zero before calling
> read() to avoid such a problem, but leaving the garbage in the buffer is
> awkward anyway so fill the buffer in tun.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

But if the user did it, you have just overwritten his value,
did you not?

> ---
>  drivers/net/tun_vnet.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/tun_vnet.c b/drivers/net/tun_vnet.c
> index fe842df9e9ef..ffb2186facd3 100644
> --- a/drivers/net/tun_vnet.c
> +++ b/drivers/net/tun_vnet.c
> @@ -138,7 +138,8 @@ int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>  	if (copy_to_iter(hdr, sizeof(*hdr), iter) != sizeof(*hdr))
>  		return -EFAULT;
>  
> -	iov_iter_advance(iter, sz - sizeof(*hdr));
> +	if (iov_iter_zero(sz - sizeof(*hdr), iter) != sz - sizeof(*hdr))
> +		return -EFAULT;
>  
>  	return 0;
>  }
> 
> -- 
> 2.47.1


