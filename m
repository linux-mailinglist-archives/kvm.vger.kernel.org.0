Return-Path: <kvm+bounces-21575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B016930226
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 00:36:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41970283182
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 22:36:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2C076A347;
	Fri, 12 Jul 2024 22:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g0RzIS5j"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325D1BC59
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 22:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720823788; cv=none; b=bfAJ3f8+w0BSZQf2b7n5NJmlicrAHgEfa4ajMNYxsT+SSaAWm3zKbyEbj8RZhABCMDFlC1vLfrM+dIAXjRUeo/DcGdSdJMscVKYN3imhmAlA0gKJAVCSRQ+dWm4gYVfKqL+GaNPp5yD5m3Km/hO1N1ztODvhbWPovwJmcBiuuW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720823788; c=relaxed/simple;
	bh=TNXcGKx0oO0INQoUwhNKp6sd7FDNWObHlJOZyFifFs8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XfdR6SHyLiLB3LX/xKD/MidQmj5PfHkqiJRRK6H1xfhEfzBdx5V5VIl/JXebEWVoR/glrH5v48Q8UvyPoggVkaaJbML0EP7EWvXhIaQPtH3s6Jjjdl9e7F0WyFn+a/UqxQowYJ9XjW+qZBkbwLC16g0Kon/etfVAETGBA1RJLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g0RzIS5j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720823785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UD+jsIB9utwUuMD5D9RKKWQHJKFtMYpx4nMjcv9KoxQ=;
	b=g0RzIS5jZ0pVFs4XJGtFxt+wj/GxJVWlW+v/GTSPSPH0yrOMZqU9FR1EgyxAVdXtlh6BUa
	rsPYi+5013FlI2YcstNLVJXLWn/zaYHgUvHY1MSNi6ZY4ViPCP8RvBGIufGef1MBXIgYVz
	/PYztBb8KxyuZj76YXft+8pyVsvpdx8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-_xGgCGyvObO7qCb1a_v3Sw-1; Fri, 12 Jul 2024 18:36:24 -0400
X-MC-Unique: _xGgCGyvObO7qCb1a_v3Sw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-806199616d0so258601539f.2
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720823784; x=1721428584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UD+jsIB9utwUuMD5D9RKKWQHJKFtMYpx4nMjcv9KoxQ=;
        b=xVmGIEaBGxblP+ekp9mMGLbOFScRa+4/4GWCizAF8aqMp9aiuqHyyjmQ2wr6C3oyMN
         QSud3esDoWE18HnudGaDE/adVaNygrp7jrNItuf5lF9OXzXV2UnSMTKv1Y9tuvPODTMq
         rlG4RPxUWdTqXu1eYT4LlUi/LCENxn6c4ZhpFw5RnuTJTRSx79lDSm/Poimbrj/zxOZy
         tfRgd6QAZ2ULuaRqN4TiObglStjB+ZlNMCRZqz72jLLU8HzolQV2WUmkulPT/wR/UXsD
         Ekswy2RYjOhAYEkC8WZHO0rArJ8cVO8enblok12i+IvNqllhGFSuDxusrQXNl0eZ13Y7
         9nDA==
X-Gm-Message-State: AOJu0Yzmw0/vDL3Th9Jfj8IGJaLK/IFA7k5SOkl0184H9Y3YzeM8P4OI
	6GlZX2Sk+RbsRc5Xfz/BMpn1WorTDsXXosSWmFG2cSvZMUbRv1BVTCWeQevmAeGZ10Ui85UYVEO
	k0hzGEHSheBaKzt7UnM0RXJFfGiSlNsPfAagfRQLxHYlCAe6mMA==
X-Received: by 2002:a05:6602:1615:b0:7f6:f93d:e6a0 with SMTP id ca18e2360f4ac-800034fd528mr1822795439f.15.1720823783807;
        Fri, 12 Jul 2024 15:36:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSyar8qW8JkxVFrshE2XwMjaVLy7kugEr4dBZXEvrYReUj5BJaoGKYAE5t07ynIbmqrbCK4g==
X-Received: by 2002:a05:6602:1615:b0:7f6:f93d:e6a0 with SMTP id ca18e2360f4ac-800034fd528mr1822794539f.15.1720823783398;
        Fri, 12 Jul 2024 15:36:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c0b1af8108sm2710939173.14.2024.07.12.15.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 15:36:22 -0700 (PDT)
Date: Fri, 12 Jul 2024 16:36:21 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Kirti Wankhede <kwankhede@nvidia.com>, Jeff Johnson
 <quic_jjohnson@quicinc.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
Message-ID: <20240712163621.6f34ae98.alex.williamson@redhat.com>
In-Reply-To: <MN2PR12MB420688C51B3F2CC8BF8CA3A8DCA62@MN2PR12MB4206.namprd12.prod.outlook.com>
References: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
	<a94604eb-7ea6-4813-aa78-6c73f7d4253a@quicinc.com>
	<MN2PR12MB420688C51B3F2CC8BF8CA3A8DCA62@MN2PR12MB4206.namprd12.prod.outlook.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jul 2024 07:27:33 +0000
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> + Alex.
> 
> Reviewed by : Kirti Wankhede <kwankhede@nvidia.com>

Mind the syntax, Reviewed-by:

Also a comment below...

> > -----Original Message-----
> > From: Jeff Johnson <quic_jjohnson@quicinc.com>
> > Sent: Friday, July 12, 2024 12:01 AM
> > To: Kirti Wankhede <kwankhede@nvidia.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org; kernel-
> > janitors@vger.kernel.org
> > Subject: Re: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
> > 
> > On 5/23/24 17:12, Jeff Johnson wrote:  
> > > Fix the 'make W=1' warnings:
> > > WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-  
> > mdev/mtty.o  
> > > WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-  
> > mdev/mdpy.o  
> > > WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-  
> > mdev/mdpy-fb.o  
> > > WARNING: modpost: missing MODULE_DESCRIPTION() in samples/vfio-  
> > mdev/mbochs.o  
> > >
> > > Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> > > ---
> > >   samples/vfio-mdev/mbochs.c  | 1 +
> > >   samples/vfio-mdev/mdpy-fb.c | 1 +
> > >   samples/vfio-mdev/mdpy.c    | 1 +
> > >   samples/vfio-mdev/mtty.c    | 1 +
> > >   4 files changed, 4 insertions(+)
> > >
> > > diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> > > index 9062598ea03d..836456837997 100644
> > > --- a/samples/vfio-mdev/mbochs.c
> > > +++ b/samples/vfio-mdev/mbochs.c
> > > @@ -88,6 +88,7 @@
> > >   #define STORE_LE32(addr, val)	(*(u32 *)addr = val)
> > >
> > >
> > > +MODULE_DESCRIPTION("Mediated virtual PCI display host device driver");
> > >   MODULE_LICENSE("GPL v2");
> > >
> > >   static int max_mbytes = 256;
> > > diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> > > index 4598bc28acd9..149af7f598f8 100644
> > > --- a/samples/vfio-mdev/mdpy-fb.c
> > > +++ b/samples/vfio-mdev/mdpy-fb.c
> > > @@ -229,4 +229,5 @@ static int __init mdpy_fb_init(void)
> > >   module_init(mdpy_fb_init);
> > >
> > >   MODULE_DEVICE_TABLE(pci, mdpy_fb_pci_table);
> > > +MODULE_DESCRIPTION("Framebuffer driver for mdpy (mediated virtual pci  
> > display device)");  
> > >   MODULE_LICENSE("GPL v2");
> > > diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> > > index 27795501de6e..8104831ae125 100644
> > > --- a/samples/vfio-mdev/mdpy.c
> > > +++ b/samples/vfio-mdev/mdpy.c
> > > @@ -40,6 +40,7 @@
> > >   #define STORE_LE32(addr, val)	(*(u32 *)addr = val)
> > >
> > >
> > > +MODULE_DESCRIPTION("Mediated virtual PCI display host device driver");
> > >   MODULE_LICENSE("GPL v2");
> > >
> > >   #define MDPY_TYPE_1 "vga"
> > > diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> > > index 2284b3751240..40e7d154455e 100644
> > > --- a/samples/vfio-mdev/mtty.c
> > > +++ b/samples/vfio-mdev/mtty.c
> > > @@ -2059,5 +2059,6 @@ module_exit(mtty_dev_exit)
> > >
> > >   MODULE_LICENSE("GPL v2");
> > >   MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
> > > +MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");

Seems the preceding MODULE_INFO needs to be removed here.  At best the
added MODULE_DESCRIPTION is redundant, but "supported" is not a
standard tag, so it's not clear what the purpose of that tag was meant
to be anyway.  Thanks,

Alex

> > >   MODULE_VERSION(VERSION_STRING);
> > >   MODULE_AUTHOR(DRIVER_AUTHOR);
> > >
> > > ---
> > > base-commit: 5c4069234f68372e80e4edfcce260e81fd9da007
> > > change-id: 20240523-md-vfio-mdev-381f74bf87f1
> > >  
> > 
> > I don't see this in linux-next yet so following up to see if anything
> > else is needed to get this merged.
> > 
> > I hope to have these warnings fixed tree-wide in 6.11.
> > 
> > /jeff  


