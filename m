Return-Path: <kvm+bounces-16178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DED98B5F17
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 18:32:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DFCF1C218F8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 16:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C2F8563C;
	Mon, 29 Apr 2024 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a9P1/IS6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275308562C
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408328; cv=none; b=N18tltneruMJAs4bCuw9ukrVHIqIVhOzFVKlsymN/4ZfpOXw6h0xziWyZhKIxMRbb6zNfpY3jkcI+9gmdkX+1BFsQFyt9h60gF8GF2H9/McOaAfCENXKFsSLiz3FQkoz0mwqgpN3G6wKOHh4Qtd701ooSmqXb4e0qi9xIeuUpdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408328; c=relaxed/simple;
	bh=KNY7YfkCFOCGJEjKFw4J5ymcqJqQzD2TMjdp9S6DTnU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpQl96A8VK/XFKJ698YOjOD2c1gEoxCr0xN53IEKpMPRZFQ3r6GJ6+djcjbbMW6Do0VBrnT3XBccLORL2Ck1/CEXkbVJgbvMTl3gnFLGTXFv70T+mXXravumhTa3KEqxZTciNr/cNTKnEiH9kiF4AdqGmNMUEoTTgooUaLoyYZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a9P1/IS6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714408326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=krZbL0UMrNCqvGgRWhIvx68Omsbhhm2kSbHqmbczntg=;
	b=a9P1/IS6ReEuU2g21ThCLw0cHngsi0pkzne4S6UszuIkKsRX84uMl0vNLgYP1c8QOxI1yF
	uLQavmgJJx/eFrJZjnXBiZoSFw9VePMncW6cZCtXWBWw1bZlmx7H5K9Uv83a24mRHl+6jM
	vd4HaMeysSYQb74+F3O5NU94wFrS6qo=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-Cv6X8RDiM3qHj5Z7ueszcw-1; Mon, 29 Apr 2024 12:32:03 -0400
X-MC-Unique: Cv6X8RDiM3qHj5Z7ueszcw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7da41c44e78so504184439f.1
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 09:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714408323; x=1715013123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krZbL0UMrNCqvGgRWhIvx68Omsbhhm2kSbHqmbczntg=;
        b=UEGsPZrUUfXHD6qj4U+9IE8ODK5F2SHE/GQjceVXSSQolIGfhltm5afZlyzNiP9jL4
         1rBF6ebHercPq8Rg/rSX3TKdn+3yjkuyt398h2DIweyOyHdU3h//vyChLL2EVAPBCfoV
         9c1x18xkyXNbysGDW8Huey/2evNp0460s0IlK3RcTpBtZTwAxaHailBDnjJAR2Qi1AHl
         05RBPQqA3cJlWeMU6W/LBSoy7hrLO4H0LPyF57GZzry88mjLYtYrwdP1/ee5v64GMB/G
         DCJyWiHxImGQRAyN/qvHay29W9E6mz7e/5svrCuOph3R7cfyEqITCUr1fhkRIzAkgDVA
         nwzA==
X-Forwarded-Encrypted: i=1; AJvYcCWElOGkMxXcbPkQG55jpNbojF14D8qsdIlHJb9W9PKiV31NHGPhBeuC5+Je5Wj81G1rgUGkwmBCZqdhfDgCMss8OCr5
X-Gm-Message-State: AOJu0YwSAJIpba+7brr+ZFKvGou8+m7oHmjTRsdkPASs5XX7m3pbLUiV
	Aiej9ewuzOkRSfA7YC2Yi+pLUZuuHS16BV8DMM2kLRJzEPYOPJiyH8HhqKx39ZAjcALyc++Ybzf
	qJ9614vuJqu61fQUOy64OE9YSuyM9xRmCJidGkNqmxtfg9YjsbQ==
X-Received: by 2002:a6b:7802:0:b0:7da:a00d:8b55 with SMTP id j2-20020a6b7802000000b007daa00d8b55mr12471088iom.17.1714408323041;
        Mon, 29 Apr 2024 09:32:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuu3m9KV8Dkpua6ArPjFefWK1kmulefZ84u2kCvEoe9tguZjAfNmfbuuSm83m/jDnLO7QT2w==
X-Received: by 2002:a6b:7802:0:b0:7da:a00d:8b55 with SMTP id j2-20020a6b7802000000b007daa00d8b55mr12471056iom.17.1714408322693;
        Mon, 29 Apr 2024 09:32:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id iu21-20020a056638861500b00487366e2e1bsm2547608jab.144.2024.04.29.09.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 09:32:02 -0700 (PDT)
Date: Mon, 29 Apr 2024 10:32:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil
 Pasic <pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH v3 3/3] vfio/pci: Continue to refactor
 vfio_pci_core_do_io_rw
Message-ID: <20240429103201.7e07e502.alex.williamson@redhat.com>
In-Reply-To: <20240425165604.899447-4-gbayer@linux.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	<20240425165604.899447-4-gbayer@linux.ibm.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 18:56:04 +0200
Gerd Bayer <gbayer@linux.ibm.com> wrote:

> Convert if-elseif-chain into switch-case.
> Separate out and generalize the code from the if-clauses so the result
> can be used in the switch statement.
> 
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 8ed06edaee23..634c00b03c71 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -131,6 +131,20 @@ VFIO_IORDWR(32)
>  VFIO_IORDWR(64)

#define MAX_FILL_SIZE 8
#else
#define MAX_FILL_SIZE 4

>  #endif
>  
> +static int fill_size(size_t fillable, loff_t off)
> +{
> +	unsigned int fill_size;

	unsigned int fill_size = MAX_FILL_SIZE;

> +#if defined(ioread64) && defined(iowrite64)
> +	for (fill_size = 8; fill_size >= 0; fill_size /= 2) {
> +#else
> +	for (fill_size = 4; fill_size >= 0; fill_size /= 2) {
> +#endif /* defined(ioread64) && defined(iowrite64) */
> +		if (fillable >= fill_size && !(off % fill_size))
> +			return fill_size;
> +	}
> +	return -1;
> +}
> +
>  /*
>   * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>   * range which is inaccessible.  The excluded range drops writes and fills
> @@ -155,34 +169,38 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  		else
>  			fillable = 0;
>  
> +		switch (fill_size(fillable, off)) {
>  #if defined(ioread64) && defined(iowrite64)
> -		if (fillable >= 8 && !(off % 8)) {
> +		case 8:
>  			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
>  						     io, buf, off, &filled);
>  			if (ret)
>  				return ret;
> +			break;
>  
> -		} else

AFAICT, avoiding this dangling else within the #ifdef is really the
only tangible advantage of conversion to a switch statement.  Getting
rid of that alone while keeping, and actually increasing, the inline
ifdefs in the code doesn't seem worthwhile to me.  I'd probably only go
this route if we could make vfio_pci_iordwr64() stubbed as a BUG_ON
when we don't have the ioread64 and iowrite64 accessors, in which case
the switch helper would never return 8 and the function would be
unreachable.

>  #endif /* defined(ioread64) && defined(iowrite64) */
> -		if (fillable >= 4 && !(off % 4)) {
> +		case 4:
>  			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
>  						     io, buf, off, &filled);
>  			if (ret)
>  				return ret;
> +			break;
>  
> -		} else if (fillable >= 2 && !(off % 2)) {
> +		case 2:
>  			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
>  						     io, buf, off, &filled);
>  			if (ret)
>  				return ret;
> +			break;
>  
> -		} else if (fillable) {
> +		case 1:
>  			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
>  						    io, buf, off, &filled);
>  			if (ret)
>  				return ret;
> +			break;
>  
> -		} else {
> +		default:

This condition also seems a little more obfuscated without being
preceded by the 'if (fillable)' test, which might warrant handling
separate from the switch if we continue to pursue the switch
conversion.  Thanks,

Alex

>  			/* Fill reads with -1, drop writes */
>  			filled = min(count, (size_t)(x_end - off));
>  			if (!iswrite) {


