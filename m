Return-Path: <kvm+bounces-20624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F7C91B1F5
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 00:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D636B252CE
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 22:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA3D1A0B07;
	Thu, 27 Jun 2024 22:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HNHUFCvz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4FF1A08D6
	for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 22:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719525955; cv=none; b=rQafLBylyAcCiXD/qFQNKvFGQgpR7xh7ZIilyTjyFBt5auSqIg57obfrMmLiKQwbN839jUTA1+D4/O2CMvmZGTWMwIS14RUvA9WbCQ6g92F7T8qcW/OcvT9oSMtmdFPlYCsyrMhyFmYoOKXsrSeiOEDJsCB4o6mVbdxgUVViIdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719525955; c=relaxed/simple;
	bh=GPka9uH0tbnuzJFPMYjQ/2ZBGJ77SVwzIe7FH4suRuM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jr77I+fxU0JMT4IHHsHjbVDjc+r7QQ2mdBV3uJcOQ3BadPwbNxLI5I+7A/UK9/M7E+HkoFlzgRIQUgkwtbEd9ui5LuAThvNhCYeD+WjMLBtR/Myi6nLEXzJkyRUoC0bTPmMChNmJ3e72uftLuw32Vezg0newLtvr4AboBKULtas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HNHUFCvz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719525952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X1trEn5o04941xk6vp/8nx318y7mfTBtf0H5o3zSA70=;
	b=HNHUFCvzRObCsSSJjbBzEznMv6Wy02YylIPxeMAR0xVR6W//g2AUg7Fs7QxEns0wPw2iB9
	qU+CKdFoatzW/ojhZTIdieG845MGIor7ct4waBNDRUJaiTWAg0UKpMYMslTd3Rb3BXko30
	UNUYV12WvwOcjbGC8XdpUuTryVFzTLo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-aaxJJ9VrOH6bgR_dbF-3nA-1; Thu, 27 Jun 2024 18:05:51 -0400
X-MC-Unique: aaxJJ9VrOH6bgR_dbF-3nA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-379c2ff145dso9199255ab.1
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2024 15:05:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719525950; x=1720130750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1trEn5o04941xk6vp/8nx318y7mfTBtf0H5o3zSA70=;
        b=hyyTWjhDFjZiWvQrA7fbTOD0MprT5Q8uXH05jReSjzcTlDFQ3zGrMUOga8T1mf+SGc
         RF2U24H9padpCl29AVDQW2FwRJ2/dxbMBvYk2sXlc0+UjU/0EGm5ai4ItcFuXiZGLR2Q
         C/uaJG5sr0CdLiWzf2ot1IJJleqX6LpzcnmZOcVQpyLDidI+K9/oBO7QN93n1I0w6Lsj
         51DT6ozv2YdO0BUlbb040JEtFcn8YHn5Ly/WRs53rccfbGebb//Ji7w1aBar/XEFK3fJ
         WwkKdSfiK0q1hqANFCftxyk5EWgjvRmQryW1ge5IEPFQmEZ0CxTvWUbbjAQPlCQwPGGp
         Xgmg==
X-Forwarded-Encrypted: i=1; AJvYcCXj5tdqCGqrRSY1uF2A6X/0MWCqwbg3+4ToE6q7ecfLRsOCUX9i524iYM5prR27aI4sx0qqzkXIh/x7arHf3mV/ydW4
X-Gm-Message-State: AOJu0Yxp0CXuVNsx5dgz0S9L1BsBAxDIlpQy+xFnyaH+kIr1H/Jro/v5
	6GV0lOt31rWBfPgIk00rzu3uZgJDxbYEcwCwZ+M5QZhogCedYhV1klvfGeWeAsmdQt/AcoBH9kI
	e0aPCPlDs1Fdm0EuyKOb4jaBPCuwU+JSXR/vnfIDuQrbG/xQ/Ww==
X-Received: by 2002:a92:d98c:0:b0:376:3fad:bb82 with SMTP id e9e14a558f8ab-37998213149mr19053425ab.2.1719525950606;
        Thu, 27 Jun 2024 15:05:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWyN9z1P+4hFoDr0ILN126oWRY+ZLqxo7RK8d3Xv3l6qhXSmy135HJFuBTabIJvwAzxzW0Hg==
X-Received: by 2002:a92:d98c:0:b0:376:3fad:bb82 with SMTP id e9e14a558f8ab-37998213149mr19053305ab.2.1719525950275;
        Thu, 27 Jun 2024 15:05:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4bb73e084c8sm161260173.80.2024.06.27.15.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 15:05:49 -0700 (PDT)
Date: Thu, 27 Jun 2024 16:05:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Gerd
 Bayer <gbayer@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/4] vfio/pci: Disable mmap() non-compliant BARs
Message-ID: <20240627160547.2879c6b3.alex.williamson@redhat.com>
In-Reply-To: <20240626-vfio_pci_mmap-v4-3-7f038870f022@linux.ibm.com>
References: <20240626-vfio_pci_mmap-v4-0-7f038870f022@linux.ibm.com>
	<20240626-vfio_pci_mmap-v4-3-7f038870f022@linux.ibm.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Jun 2024 13:15:50 +0200
Niklas Schnelle <schnelle@linux.ibm.com> wrote:

> When VFIO_PCI_MMAP is enabled for s390 in a future commit and the ISM
> device is passed-through to a KVM guest QEMU attempts to eagerly mmap()
> its BAR. This fails because the 256 TiB large BAR does not fit in the
> virtual map. Besides this issue mmap() of the ISM device's BAR is not
> useful either as even a partial mapping won't be usable from user-space
> without a vfio-pci variant driver. A previous commit ensures that pdev->
> non_compliant_bars is set for ISM so use this to disallow mmap() with
> the expecation that mmap() of non-compliant BARs is not advisable in the
> general case either.
> 
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 987c7921affa..0e9d46575776 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -128,10 +128,9 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  
>  		/*
>  		 * The PCI core shouldn't set up a resource with a
> -		 * type but zero size. But there may be bugs that
> -		 * cause us to do that.
> +		 * type but zero size or non-compliant BARs.
>  		 */
> -		if (!resource_size(res))
> +		if (!resource_size(res) || vdev->pdev->non_compliant_bars)
>  			goto no_mmap;
>  
>  		if (resource_size(res) >= PAGE_SIZE) {
> 

The non_compliant_bars flag causes pci_read_bases() to exit, shouldn't
that mean the resource is not setup and resource_size() is zero and
explicitly testing the non_compliant_bars flag is redundant?  Or does
s390 do this somewhere else?

The non_compliant_bars flag is defined as /* Broken BARs; ignore them */
so it'd be pretty strange if they had a resource size and we chose to
still expose them with read-write access... why wouldn't we just
deny-list the device from use with vfio-pci?

Also probably worth an explicit comment in the commit log why pci-sysfs
mmap support doesn't need to be bypassed on s390.  Thanks,

Alex


