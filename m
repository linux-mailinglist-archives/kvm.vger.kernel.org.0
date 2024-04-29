Return-Path: <kvm+bounces-16176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6AE8B5F13
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 18:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313181C219A8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 16:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95C985634;
	Mon, 29 Apr 2024 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1nukj/v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B2A8529C
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714408306; cv=none; b=VuBSTJhc4CEKw0ekPBJOwZRQakbFY4femab6r2ykyvExAcBd/Bvwi1YSF5cknLFMNi59qgsb6+je9btywIOWLHd8hp2GjtvVg4v5LnTyKF9SnufffhWyZ+q2CZ5T6aXhchvbCXkV8mMIPQI9epBc7WQPWwX/jATY39YEqwaqm68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714408306; c=relaxed/simple;
	bh=9LZtxJD6B+6zioX7BNC1oyMqWg0YmSIbb9AD+1CR/UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2RvBlBBD75kkG1nwt1P76gHllQcHQXeelldJfG0yqzKFkR5PczPLcoKBAVGVKF53/bl8A2KbGYwVcgjvswrC2rnZ8eRLwwhqiDCErwIdkT+6R/4wYuGhnzF3qakgtnXsUxG7qrXczLJMOXdJaGeUYZAI3FqyTwyAG+g31hIAiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1nukj/v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714408303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a3bnP5fq/PnIo0P3cjy/umu94aFyOl2Akp5t0nlUjdE=;
	b=R1nukj/v96RWW0uBKTXEk75LpUHkGhGRd8kJDRM/PSUSXBGVzFCJ4rZxBJ9bb2gNTUKa80
	y6ir/jEGe2jnHM62MkYHCyXZk//+o5i37ifxHk7rZDz40VSO9AOfl7tED7h6re3Uk910oA
	eBWYvc5vfP6BjItkB6ithjROVtwIGvM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-zCEquSbWNfem_eK3-utcqQ-1; Mon, 29 Apr 2024 12:31:41 -0400
X-MC-Unique: zCEquSbWNfem_eK3-utcqQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-36a1a2f396aso48879335ab.3
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 09:31:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714408299; x=1715013099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a3bnP5fq/PnIo0P3cjy/umu94aFyOl2Akp5t0nlUjdE=;
        b=gNWmxwv2/RWoM3QtDm0puUzPTsSJL8MJd/5o4jdnc7AM/iy7ql/Whn5k6ANGjK1KBz
         mZIIZF+QXCmtYiIj/x8dfPiZXEx3FTyvX65DpNOrz/wRXLhZsOEvIk+bgvXMsyX75G0k
         DE+MKFobFnHfx9clcAozcftedKaz6f4fOjWv9EEu9ahCro4PyAULAC7eNqxp7qhii22a
         Sd0XENeSBYo7MwVXYFcrfl0HNY6d9MTsWXbKEpvb5ZzYezYPWto1AUavaLqof5PHIjIC
         1nu0Jp5Z6B+sqENoyKmAktKVpz1g8bzSbG+hgzGM8gnkIQuB2Ru0lWB13J7p5L6uKDIT
         eM+g==
X-Forwarded-Encrypted: i=1; AJvYcCUwkair+qtJe9jbaGExIKQTrTDGSwIboj0P6LJ3Oag9N6KnfhoZmTjJ2MA5izpggS4u5jp8QUXjLRY3R3+YWW2jzbL4
X-Gm-Message-State: AOJu0YxefRXjl5ZtcaYv17RUWGdQ486SWTKJZCCeLygu9gC07c1uA6RV
	CNPIKnZ5fQFZynVoUwt7/nQx+5l2qs8RxbMgzuM8ycjtxJJzf56MIlFgNEB9zN7KbpEZRhvuPCc
	/MNfqDA9dpbKHfKeUX/DbobOctdjhXftEJ7PXs88Fx6RPZu1XSg==
X-Received: by 2002:a05:6e02:1aa3:b0:36b:1e1:552f with SMTP id l3-20020a056e021aa300b0036b01e1552fmr291834ilv.23.1714408299370;
        Mon, 29 Apr 2024 09:31:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZBWRGB/H4xzITyzWAXi20ENkjfQgAIHe1Cpv5I8TUJlPz91KZJwLgwMQ7idtqRUHZMs8Rag==
X-Received: by 2002:a05:6e02:1aa3:b0:36b:1e1:552f with SMTP id l3-20020a056e021aa300b0036b01e1552fmr291789ilv.23.1714408298764;
        Mon, 29 Apr 2024 09:31:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id v12-20020a056638358c00b00487cb697fc2sm399310jal.23.2024.04.29.09.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 09:31:38 -0700 (PDT)
Date: Mon, 29 Apr 2024 10:31:35 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil
 Pasic <pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] vfio/pci: Extract duplicated code into macro
Message-ID: <20240429103135.56682371.alex.williamson@redhat.com>
In-Reply-To: <20240425165604.899447-2-gbayer@linux.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	<20240425165604.899447-2-gbayer@linux.ibm.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 18:56:02 +0200
Gerd Bayer <gbayer@linux.ibm.com> wrote:

> vfio_pci_core_do_io_rw() repeats the same code for multiple access
> widths. Factor this out into a macro
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_rdwr.c | 106 ++++++++++++++-----------------
>  1 file changed, 46 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 03b8f7ada1ac..3335f1b868b1 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -90,6 +90,40 @@ VFIO_IOREAD(8)
>  VFIO_IOREAD(16)
>  VFIO_IOREAD(32)
>  
> +#define VFIO_IORDWR(size)						\
> +static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
> +				bool iswrite, bool test_mem,		\
> +				void __iomem *io, char __user *buf,	\
> +				loff_t off, size_t *filled)		\

I realized later after proposing this that we should drop 'core' from
the name since the resulting functions are not currently exported.  It
also helps with the wordiness.  Thanks,

Alex

> +{									\
> +	u##size val;							\
> +	int ret;							\
> +									\
> +	if (iswrite) {							\
> +		if (copy_from_user(&val, buf, sizeof(val)))		\
> +			return -EFAULT;					\
> +									\
> +		ret = vfio_pci_core_iowrite##size(vdev, test_mem,	\
> +						  val, io + off);	\
> +		if (ret)						\
> +			return ret;					\
> +	} else {							\
> +		ret = vfio_pci_core_ioread##size(vdev, test_mem,	\
> +						 &val, io + off);	\
> +		if (ret)						\
> +			return ret;					\
> +									\
> +		if (copy_to_user(buf, &val, sizeof(val)))		\
> +			return -EFAULT;					\
> +	}								\
> +									\
> +	*filled = sizeof(val);						\
> +	return 0;							\
> +}									\
> +
> +VFIO_IORDWR(8)
> +VFIO_IORDWR(16)
> +VFIO_IORDWR(32)
>  /*
>   * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>   * range which is inaccessible.  The excluded range drops writes and fills
> @@ -115,71 +149,23 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>  			fillable = 0;
>  
>  		if (fillable >= 4 && !(off % 4)) {
> -			u32 val;
> -
> -			if (iswrite) {
> -				if (copy_from_user(&val, buf, 4))
> -					return -EFAULT;
> -
> -				ret = vfio_pci_core_iowrite32(vdev, test_mem,
> -							      val, io + off);
> -				if (ret)
> -					return ret;
> -			} else {
> -				ret = vfio_pci_core_ioread32(vdev, test_mem,
> -							     &val, io + off);
> -				if (ret)
> -					return ret;
> -
> -				if (copy_to_user(buf, &val, 4))
> -					return -EFAULT;
> -			}
> +			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
> +						     io, buf, off, &filled);
> +			if (ret)
> +				return ret;
>  
> -			filled = 4;
>  		} else if (fillable >= 2 && !(off % 2)) {
> -			u16 val;
> -
> -			if (iswrite) {
> -				if (copy_from_user(&val, buf, 2))
> -					return -EFAULT;
> -
> -				ret = vfio_pci_core_iowrite16(vdev, test_mem,
> -							      val, io + off);
> -				if (ret)
> -					return ret;
> -			} else {
> -				ret = vfio_pci_core_ioread16(vdev, test_mem,
> -							     &val, io + off);
> -				if (ret)
> -					return ret;
> -
> -				if (copy_to_user(buf, &val, 2))
> -					return -EFAULT;
> -			}
> +			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
> +						     io, buf, off, &filled);
> +			if (ret)
> +				return ret;
>  
> -			filled = 2;
>  		} else if (fillable) {
> -			u8 val;
> -
> -			if (iswrite) {
> -				if (copy_from_user(&val, buf, 1))
> -					return -EFAULT;
> -
> -				ret = vfio_pci_core_iowrite8(vdev, test_mem,
> -							     val, io + off);
> -				if (ret)
> -					return ret;
> -			} else {
> -				ret = vfio_pci_core_ioread8(vdev, test_mem,
> -							    &val, io + off);
> -				if (ret)
> -					return ret;
> -
> -				if (copy_to_user(buf, &val, 1))
> -					return -EFAULT;
> -			}
> +			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
> +						    io, buf, off, &filled);
> +			if (ret)
> +				return ret;
>  
> -			filled = 1;
>  		} else {
>  			/* Fill reads with -1, drop writes */
>  			filled = min(count, (size_t)(x_end - off));


