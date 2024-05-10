Return-Path: <kvm+bounces-17233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174008C2C81
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 00:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 482351C212C0
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 22:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E5013B7A1;
	Fri, 10 May 2024 22:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZ/89QAT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5876913C3D6
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715379398; cv=none; b=oyG/TAxs01yNWVLgpS3rbZkH+PuCEJqcarpfPDHQ8fDa7MwEHCNg2RRipMh9dWWqaRRFkhXWgQBGbtp3sB3pkCs2c/+LdKP8prl6XXVe6A7QvQEZcRNzdx1novlfT0nUcJX1mdrMYzOQR4jjZhRlbOftKZmkjWvKhI2JJuKyUp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715379398; c=relaxed/simple;
	bh=ROcGEvtftnjYPI08GGYz9bNGpaH/RrDFIcR0zoLFgN0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WWxeC75zxDnKjvZfp83RajH6Vzm3ssz2iBWDrh+QwBjVXHmk96Lxphvt7V00w2HwuKdT19JyT4Y5vd0rfiorIerjY/xyA6ggqPxKII7QwfdeppBtoqHDG3zofLLxlUvP/NLQxUEmMbjsW7HmJb/E4mKCyHxeYo0SxHyGdv/89FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZ/89QAT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715379395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I/QlJHr+D+VnlQcWOXKBfsNZlT2gXuYn22rJbWjqVyA=;
	b=eZ/89QATxTJxI90v39aM0Zq2Erqp9qOi71PgFrXdZ+IdjjG84d7ddwVRbjtj6PQPeptnpV
	K7vSVnsKfbAbiwCzlEw69ichFUJ4JS4Z3u73hs929gBKu8dj3BYUZALr/LRoTUz/4ycGJN
	FJDJ0j7KypD+F5Lnqy9qseLZbNvF1eA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-Sai6C9a4NYKK8CQ-DJT2wA-1; Fri, 10 May 2024 18:14:29 -0400
X-MC-Unique: Sai6C9a4NYKK8CQ-DJT2wA-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e186a8af8bso272120639f.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 15:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715379268; x=1715984068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/QlJHr+D+VnlQcWOXKBfsNZlT2gXuYn22rJbWjqVyA=;
        b=rTzaSPi9Mj/UamLWudoqqp4lvrir4IUShszSlfBJ2O892q6HFGKuwI7EkR3ed1agep
         z1agNxADQl0DsT/WvOfARmypHzhOWAa3QlhxRCc0NFN6XBuiHPMUM2WcGj6XUSVFeaKk
         OEldztl5SlfaYcpu4Ysho4D9JuxqINA303ocEWF4v6X/auEYPMTdpfPPT05HBmlcZ1vT
         3YZIscfTb9kGui7mIHJqIKco9cVagXUrsycbfUZ5NOnxMrtNuesBB4Uy12KYjqu2HT9F
         reyEYqtIbZUD8nnvzvqo7lTZaNlXp1zvDp7s+jbTBcdP7WD7SOXThwhY1HQ9dFMEA2Xz
         vIjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeP1fgABoC4RLhCPYRl/TwbXuMz/SWyY8Ivd8Lfus37c1g9VzHFdcZLVY7314dVbaWYoFQEzKKeME9UXLoW/bANiHF
X-Gm-Message-State: AOJu0YzF7EqGW4wsVPD0zj/cL6IoQJGTjGJ/JfFYoCNO3cK8Q2wHwgKo
	viBhdXOpN/oZHYjaVC5J2R3SVU1RSwy7+q5Po4V7Qz1cP79uNm/r0TwviWNF1wSWFi5IsboKEvf
	m02DJoY2pnRD+xF51Ttj8Zrlp/Ef2Ts5SSD2ssiQOKZOyUgRLPS0O2i9w0A==
X-Received: by 2002:a05:6602:178d:b0:7e1:b4b2:d706 with SMTP id ca18e2360f4ac-7e1b51a3f2fmr446829039f.3.1715379268282;
        Fri, 10 May 2024 15:14:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBFf1hFugwXrr0klEwmRsIlfe4M8Guf0BNT2CGB9vmEx+wes5EAiaXPPMN4KI1D245YbdcEA==
X-Received: by 2002:a05:6602:178d:b0:7e1:b4b2:d706 with SMTP id ca18e2360f4ac-7e1b51a3f2fmr446826939f.3.1715379267902;
        Fri, 10 May 2024 15:14:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1b9499ba6sm54162539f.31.2024.05.10.15.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 15:14:27 -0700 (PDT)
Date: Fri, 10 May 2024 16:14:25 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "foryun.ma" <foryun.ma@jaguarmicro.com>
Cc: corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, angus.chen@jaguarmicro.com
Subject: Re: [PATCH] vfio: remove an extra semicolon
Message-ID: <20240510161425.589eb25d.alex.williamson@redhat.com>
In-Reply-To: <20240510003735.2766-1-foryun.ma@jaguarmicro.com>
References: <20240510003735.2766-1-foryun.ma@jaguarmicro.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 May 2024 14:37:35 +1400
"foryun.ma" <foryun.ma@jaguarmicro.com> wrote:

> remove an extra semicolon from the example code
> 
> Signed-off-by: foryun.ma <foryun.ma@jaguarmicro.com>
> ---
>  Documentation/driver-api/vfio.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index 633d11c7fa71..2a21a42c9386 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -364,7 +364,7 @@ IOMMUFD IOAS/HWPT to enable userspace DMA::
>  				    MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
>  	map.iova = 0; /* 1MB starting at 0x0 from device view */
>  	map.length = 1024 * 1024;
> -	map.ioas_id = alloc_data.out_ioas_id;;
> +	map.ioas_id = alloc_data.out_ioas_id;
>  
>  	ioctl(iommufd, IOMMU_IOAS_MAP, &map);
>  

Applied to vfio next branch for v6.10.  Thanks,

Alex


