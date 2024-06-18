Return-Path: <kvm+bounces-19876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB0390DA70
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E7A01C226C2
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8CB13DB98;
	Tue, 18 Jun 2024 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PMwTe7GI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64D413AA41
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 17:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718731232; cv=none; b=pHOLE7FV2VoK8Eqxjjs6GcshBpEAlV9lKlc6/lLEIHYLg2BGq9gXX0WObSdwnNaa+CVEkkkOWJS7Xhdk8Zu/ZXghsBbypcA6lcYmT/zM9Z5hYAUHPahgXu+jSbV8I/EZfp5ohMtbIumHKtGuavA8e5ioPH3mfWUi6s6Bph7VXgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718731232; c=relaxed/simple;
	bh=INqmVCBc8HU0+P42MTmf0zgLb2AXGhOwm1WL9RDPipU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ut3hnGBZQrrul74CG55/mIOG9+GaZ3B05Xzu7uV9D9VN75fSU09cHBpYNdCIzNPCS7uN50bfZExPAzLdlEJPoqp9YJmKXcuGpiCP5ES/wreHI8wUGFZjbXXTtp4rExnOPM+OWuOWwkaIj0eZoq0VJ36IpNi0vKcfjQd1092iu9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PMwTe7GI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718731229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwt23sAZ2WeiBvroMNMzIKHNDpn7DovDgGAmHCl/TIA=;
	b=PMwTe7GImXRtsFWGqRaPZdK5Si50yIBDswMGELErbFPsaakxG/A7ivVINvecRurghR1d8Z
	JY4KK686F2sFzpVGr+00Bp6cAxnKlaGcNO+LdLC97ZO4B2w4/vpw5IZCL3XcpBg9wmRGy7
	E/yWVPF7iBPQaART1OMVo3f3xCDyAZg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-arz0bcrOOxW2k3DNnXWfCw-1; Tue, 18 Jun 2024 13:20:23 -0400
X-MC-Unique: arz0bcrOOxW2k3DNnXWfCw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7e20341b122so658010239f.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 10:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718731223; x=1719336023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fwt23sAZ2WeiBvroMNMzIKHNDpn7DovDgGAmHCl/TIA=;
        b=uKKaoWvN69RLxIyIl+lGJsNZDhFv+LAR4274UdEh03i2x4wMU4wYpTLdGSoW5XIdF8
         k9MNzZ2Z8rOKb739gRZ8MSZc/T2Mvfl92yaWFFe2xiKeYzRd6LEStV3NAOhJ8mYA4syB
         U0/FWzmdY0YZzuDlAOsAfzViYlEOj2hQCSHjtnj6RmDXrcBqFtiLfAEch863WLGyuoAl
         zPBNt8tw/e6xUK+Ne/ed7pClhOZjOXQbEFZiagyVYMfUtP/YWw4NwUFMh0c2JCejuC95
         Dcj6GkV1YwaO08O1XZfK99IDVnGV2b5qeeuNszQVq+U5ZD8RiMVz1XZGbyobZ0EVQWHX
         0unA==
X-Forwarded-Encrypted: i=1; AJvYcCWMKu4L+AK26w8zv4U5kniKqNhl5b2bdT5FiROlA22NYaIxjFN+kX4quBztQLy74BYOonWp4ByfvJ80tHe3aRZEjv7j
X-Gm-Message-State: AOJu0YxlAALXP7cNpQ3ULk9TZiq2WjQYVWtsCRllFLCxUSFyE0u+LfvW
	j5N5+ZRqCBdfK7oZRF81ceuuI7FoAnwwkM+ykeZqfA4SROYiGOFziuP5PAVVrcTHFGQP1m4nYhj
	aphbyKFxSgbrfaJZq7GzZHkSyIkRyO0eTJdVnUZUqmx/VDiPAFg==
X-Received: by 2002:a05:6602:6405:b0:7eb:7887:a4a9 with SMTP id ca18e2360f4ac-7f13edb2716mr63375039f.4.1718731223072;
        Tue, 18 Jun 2024 10:20:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGzXJQLdgF3B6icXL7Ah1nqLxdQK0SBjMksmtymW9ngK1rCZftPEsBb6BNRnVSGHJrEDcSKvg==
X-Received: by 2002:a05:6602:6405:b0:7eb:7887:a4a9 with SMTP id ca18e2360f4ac-7f13edb2716mr63372139f.4.1718731222724;
        Tue, 18 Jun 2024 10:20:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7ebdba66726sm277082139f.27.2024.06.18.10.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 10:20:22 -0700 (PDT)
Date: Tue, 18 Jun 2024 11:20:20 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Gerd Bayer <gbayer@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>, Ramesh Thomas <ramesh.thomas@intel.com>,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org, Ankit Agrawal
 <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
 <pasic@linux.ibm.com>, Ben Segal <bpsegal@us.ibm.com>, "Tian, Kevin"
 <kevin.tian@intel.com>, Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH v5 3/3] vfio/pci: Fix typo in macro to declare accessors
Message-ID: <20240618112020.3e348767.alex.williamson@redhat.com>
In-Reply-To: <20240605160112.925957-4-gbayer@linux.ibm.com>
References: <20240605160112.925957-1-gbayer@linux.ibm.com>
	<20240605160112.925957-4-gbayer@linux.ibm.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 18:01:12 +0200
Gerd Bayer <gbayer@linux.ibm.com> wrote:

> Correct spelling of DECLA[RA]TION

But why did we also transfer the semicolon from the body of the macro
to the call site?  This doesn't match how we handle macros for
VFIO_IOWRITE, VFIO_IOREAD, or the new VFIO_IORDWR added in this series.
Thanks,

Alex

> Suggested-by: Ramesh Thomas <ramesh.thomas@intel.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>  include/linux/vfio_pci_core.h | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index f4cf5fd2350c..fa59d40573f1 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -139,26 +139,26 @@ bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
>  					 loff_t *buf_offset,
>  					 size_t *intersect_count,
>  					 size_t *register_offset);
> -#define VFIO_IOWRITE_DECLATION(size) \
> +#define VFIO_IOWRITE_DECLARATION(size) \
>  int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
> -			bool test_mem, u##size val, void __iomem *io);
> +			bool test_mem, u##size val, void __iomem *io)
>  
> -VFIO_IOWRITE_DECLATION(8)
> -VFIO_IOWRITE_DECLATION(16)
> -VFIO_IOWRITE_DECLATION(32)
> +VFIO_IOWRITE_DECLARATION(8);
> +VFIO_IOWRITE_DECLARATION(16);
> +VFIO_IOWRITE_DECLARATION(32);
>  #ifdef iowrite64
> -VFIO_IOWRITE_DECLATION(64)
> +VFIO_IOWRITE_DECLARATION(64);
>  #endif
>  
> -#define VFIO_IOREAD_DECLATION(size) \
> +#define VFIO_IOREAD_DECLARATION(size) \
>  int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
> -			bool test_mem, u##size *val, void __iomem *io);
> +			bool test_mem, u##size *val, void __iomem *io)
>  
> -VFIO_IOREAD_DECLATION(8)
> -VFIO_IOREAD_DECLATION(16)
> -VFIO_IOREAD_DECLATION(32)
> +VFIO_IOREAD_DECLARATION(8);
> +VFIO_IOREAD_DECLARATION(16);
> +VFIO_IOREAD_DECLARATION(32);
>  #ifdef ioread64
> -VFIO_IOREAD_DECLATION(64)
> +VFIO_IOREAD_DECLARATION(64);
>  #endif
>  
>  #endif /* VFIO_PCI_CORE_H */


