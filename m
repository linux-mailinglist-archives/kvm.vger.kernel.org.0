Return-Path: <kvm+bounces-22960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E3B944F83
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7BF1289D62
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1981F1B32A1;
	Thu,  1 Aug 2024 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZ1LmPyD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3042049
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722526891; cv=none; b=cnU8U5dqrkGCKlT6HlTtHnBXW4wQ5AGOVNtg8DIJFckSWnrBSWdtTXn5ufZPK3X7jPT6Gq5tkKIUAGmniNtO6SMuj03JoMcGve09RB19rm6ypPNhqRj2NjYLe1Ehus/lmI6ykSxe6hgMXTyTjQJcIntdT23Mfk/gjixt5wMua8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722526891; c=relaxed/simple;
	bh=TqtTHFkHdrU+w5H01QuxOvyTv7YQdBMPyjAR+uHA+TE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPCGD+fV6NI8KFk3g7h7rT/PUkJyoV6aWkIZC/guXSWNEVslcycel965wvyIj45neyaBu9zeaeLJ9NtwyvMuZ+zwY81ArwafrFtoFe3T8GTwH17D6kXDJNAZSq8j9ZL5pmklFYbYInZjw7Tel0YbIAyCQ/YVm9uYUXAiTh/o7Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZ1LmPyD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722526888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x0jkUwUSwfb5o9OMU/gJuQXr3j6VILXirLVqM0pfXY4=;
	b=KZ1LmPyDs16Q4uc2TiztD9ib7lbc5vbqfJ7+vB7aCrHDTImq+7Bx/XZt17+jZ+oLwhoVOv
	YSoh32W4qMB9TuFcUUOfLLH56BVUMX7ofD9IeyFrBMQXxpYK4R9C63JAZEzc3QrMOqW39f
	cQMzwUReez2WAQjcZd98ZYEgqTM/y+c=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-srHKoPlNPLCV8xglK0sjCg-1; Thu, 01 Aug 2024 11:41:26 -0400
X-MC-Unique: srHKoPlNPLCV8xglK0sjCg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81d1b92b559so1009943839f.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 08:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722526886; x=1723131686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x0jkUwUSwfb5o9OMU/gJuQXr3j6VILXirLVqM0pfXY4=;
        b=Epn26q4ctaGQ3Ao2XrBsHtPOS0dYRdO1xW6d8hBTzOJanPp3cq8XigisPX4Fk1nan+
         5NyfCsAHTsvvCX9Uwce8ESDJfF6gYcuYC157Z/3IJzjWziE/upRcBKwVDlHxSY7yEnik
         7JFEoapG4GzjZ5mFPJ4IeV7l3ocSDF1LsoQJbPj/uzQfl4/7dEA/zyejUItjdymDQD2B
         Qv/iZ0Hqe5UXHiRRRAQy+IdTOvSQGy+zgAxUTqRp+apFLzDfurI9UuKsl4ed08fwYRZn
         t+r3aqCQgRFbhCs+BQhYBge54raBYsuuanOTjCtRhsi+SXElYljMkLbTCTRF1fQBVbV2
         UX3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUywgyO8+wm4mlAXZiJPIDn9XunHzEiivhG/QOvEIpx7Dv1EIKb4XWTUngaT4/SP2ijooM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG4vKmQVjnQENIbsCbZv9Tximo6TdKRhWNOgBG4doZG8cZ5sWM
	EhgkPAO9e+vTCf+6TgYsvKQ1M2/7NV+vXunwtseES+jB79DChGekhHOzFI39RS4HTdgX4a1OOCx
	gB+5/4xO+cGqKKAKeKhXxda8/42+OVF8Rv8Cbh9ogw51D6cCT6SUk/JqxPA==
X-Received: by 2002:a05:6602:6423:b0:7fa:2902:aec5 with SMTP id ca18e2360f4ac-81fd43f90c8mr83778939f.17.1722526885888;
        Thu, 01 Aug 2024 08:41:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG059LRf2rIjuHE7r+DsGNo0Z5nTdhm7GoFU+8MkkSCDAMD9lp1m5d+5iq+neF29ByQcuLWhg==
X-Received: by 2002:a05:6602:6423:b0:7fa:2902:aec5 with SMTP id ca18e2360f4ac-81fd43f90c8mr83776639f.17.1722526885492;
        Thu, 01 Aug 2024 08:41:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81fd4c7c98esm2424639f.0.2024.08.01.08.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 08:41:25 -0700 (PDT)
Date: Thu, 1 Aug 2024 09:41:23 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801094123.4eda2e91.alex.williamson@redhat.com>
In-Reply-To: <20240801141914.GC3030761@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
	<20240801141914.GC3030761@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Aug 2024 11:19:14 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Jul 31, 2024 at 08:53:52AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Write combining can be provide performance improvement for places that
> > can safely use this capability.
> > 
> > Previous discussions on the topic suggest a vfio user needs to
> > explicitly request such a mapping, and it sounds like a new vfio
> > specific ioctl to request this is one way recommended way to do that.
> > This patch implements a new ioctl to achieve that so a user can request
> > write combining on prefetchable memory. A new ioctl seems a bit much for
> > just this purpose, so the implementation here provides a "flags" field
> > with only the write combine option defined. The rest of the bits are
> > reserved for future use.  
> 
> This is a neat hack for sure
> 
> But how about adding this flag to vfio_region_info ?
> 
> @@ -275,6 +289,7 @@ struct vfio_region_info {
>  #define VFIO_REGION_INFO_FLAG_WRITE    (1 << 1) /* Region supports write */
>  #define VFIO_REGION_INFO_FLAG_MMAP     (1 << 2) /* Region supports mmap */
>  #define VFIO_REGION_INFO_FLAG_CAPS     (1 << 3) /* Info supports caps */
> +#define VFIO_REGION_INFO_REQ_WC         (1 << 4) /* Request a write combining mapping*/
>         __u32   index;          /* Region index */
>         __u32   cap_offset;     /* Offset within info struct of first cap */
>         __aligned_u64   size;   /* Region size (bytes) */
> 
> 
> It specify REQ_WC when calling VFIO_DEVICE_GET_REGION_INFO
> 
> The kernel will then return an offset value that yields a WC
> mapping. It doesn't displace the normal non-WC mapping?
> 
> Arguably we should fixup the kernel to put the mmap cookies into a
> maple tree so they can be dynamically allocated and more densely
> packed.

vfio_region_info.flags in not currently tested for input therefore this
proposal could lead to unexpected behavior for a caller that doesn't
currently zero this field.  It's intended as an output-only field.
Thanks,

Alex



