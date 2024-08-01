Return-Path: <kvm+bounces-22967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B256494511E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 18:53:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7801B23FFF
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 16:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A592F1B9B3A;
	Thu,  1 Aug 2024 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JCERyO9t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E611B32B7
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722531172; cv=none; b=XxzbbdHXPy7CcneovRZeiZSVSnLLDZzjuL437DYFwFM+gAmBPAfxtwJtThNHxgUSyd/gcyKb50nTAoYoJzH2fcv4oPaHaXfbgS0ROwuEHljrv/ohfhCw2kITXiX+IEdvLB7FDIxs/XZ9GfaqWIPE/P6SpEN9NAUYVxe2MO1BWrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722531172; c=relaxed/simple;
	bh=hp+rgYYRo50hwKh1LDQi8Oyxg3DabI6TLekF3ScmZJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ft/xNzcbkHbgxA4YctKBIneoyOriP4VaE4/5gbIV4a/CLUZ7J8sYqj39FULHQn04QiVPPC/M7X+nAhRhIe/k8qxQRsjV34RqOgNMGKChIWcbhb9I4LEhy/5HwGYFaKGmipB2xcycjBaWqk8t1hMFA+ni8LsehBz9ZOfE5Q/7RSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JCERyO9t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722531170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=In6Cn2xSF6K1Txw+9OHxhvG/x3BTNE8UYi8iKBtCE1w=;
	b=JCERyO9tFCwJ1xqTyQUqxyZOd1GNmMfP8ic56OatFIF0IgoXZaEXvq1QTqhJ0oFV2hxjRm
	WAllURn1yMSz/otm/WIXovMZKslzMJSVl8NJDayp3o7Y8axrH37sNKZNDQm8LXkB3J938I
	TAlruLf3uAlN7wvWawBaoKpbTb+nkcQ=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-kEhB1QogPtGW0hLxlUpYqg-1; Thu, 01 Aug 2024 12:52:21 -0400
X-MC-Unique: kEhB1QogPtGW0hLxlUpYqg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8036e96f0caso1013630639f.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 09:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722531141; x=1723135941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=In6Cn2xSF6K1Txw+9OHxhvG/x3BTNE8UYi8iKBtCE1w=;
        b=YoqLlVjemrd3CFidqMJMbCB8de6YkxCsiRO+sCAHilQaSnPkCrGnwQegHAsXQGpqw4
         PMKCCZHWB/luotZs14gBDwAsf5NjAae1llTzCY54ZZGRUlJLjy66UWJqZAYfN77OqLho
         AoTIcvYWLjm3Z7IrRvjE6OEayECI2ipapVGJF6TtcO/ZQke3B46+7l3VSkhRoJwUjZeN
         Y1EXxxRDlm2aeH/csfOVplXxxvBs0ceJaSdLXTWKZ0kAVgjPD475VZJIxUNbkHETqrGk
         XEIqhFxzn0mKiIk+ob6fH8FeDtSjCAWtdorz+x57eR9jD7Uy7Ls0O8EXBDCsutazfmH+
         JF6w==
X-Forwarded-Encrypted: i=1; AJvYcCWxy4cQAwP1yWJC9xaAmPdHR891S95XNSCXC9q3qlof4mDHZ5fpylqNufzEJ88KkY1oxtHi5J6jwd1yaNZoaAjOMUCi
X-Gm-Message-State: AOJu0YyxmQFqJh+ZJn9cPNktHd/2wieNFdzBpoBkYpodCAlhtnCjWF9a
	cn+EiaY4i5FMLm2A0PWAVdBGQSadLrutmy7LV1UmpOP/FNd1LPRgemgYXMcGtXPGBgRBq9yYhSx
	GiyiErEZ9Jht8nXKMpRZfAuBcH5sqpQx5rAD2QvHc1NsF2RUAZQ==
X-Received: by 2002:a05:6602:341b:b0:81f:d520:782e with SMTP id ca18e2360f4ac-81fd52079e9mr5820039f.10.1722531140949;
        Thu, 01 Aug 2024 09:52:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEguJLIZCuR30jhbFH1uV2ABBQ6B8lbpnc18CWwr0MwUsWsiQskJsa6T+L1Yfmj2pvqHT1ORg==
X-Received: by 2002:a05:6602:341b:b0:81f:d520:782e with SMTP id ca18e2360f4ac-81fd52079e9mr5817339f.10.1722531140528;
        Thu, 01 Aug 2024 09:52:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c8d6a5a7b9sm4048173.171.2024.08.01.09.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 09:52:19 -0700 (PDT)
Date: Thu, 1 Aug 2024 10:52:18 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801105218.7c297f9a.alex.williamson@redhat.com>
In-Reply-To: <20240801161130.GD3030761@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
	<20240801141914.GC3030761@ziepe.ca>
	<20240801094123.4eda2e91.alex.williamson@redhat.com>
	<20240801161130.GD3030761@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Aug 2024 13:11:30 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, Aug 01, 2024 at 09:41:23AM -0600, Alex Williamson wrote:
> > On Thu, 1 Aug 2024 11:19:14 -0300
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >   
> > > On Wed, Jul 31, 2024 at 08:53:52AM -0700, Keith Busch wrote:  
> > > > From: Keith Busch <kbusch@kernel.org>
> > > > 
> > > > Write combining can be provide performance improvement for places that
> > > > can safely use this capability.
> > > > 
> > > > Previous discussions on the topic suggest a vfio user needs to
> > > > explicitly request such a mapping, and it sounds like a new vfio
> > > > specific ioctl to request this is one way recommended way to do that.
> > > > This patch implements a new ioctl to achieve that so a user can request
> > > > write combining on prefetchable memory. A new ioctl seems a bit much for
> > > > just this purpose, so the implementation here provides a "flags" field
> > > > with only the write combine option defined. The rest of the bits are
> > > > reserved for future use.    
> > > 
> > > This is a neat hack for sure
> > > 
> > > But how about adding this flag to vfio_region_info ?
> > > 
> > > @@ -275,6 +289,7 @@ struct vfio_region_info {
> > >  #define VFIO_REGION_INFO_FLAG_WRITE    (1 << 1) /* Region supports write */
> > >  #define VFIO_REGION_INFO_FLAG_MMAP     (1 << 2) /* Region supports mmap */
> > >  #define VFIO_REGION_INFO_FLAG_CAPS     (1 << 3) /* Info supports caps */
> > > +#define VFIO_REGION_INFO_REQ_WC         (1 << 4) /* Request a write combining mapping*/
> > >         __u32   index;          /* Region index */
> > >         __u32   cap_offset;     /* Offset within info struct of first cap */
> > >         __aligned_u64   size;   /* Region size (bytes) */
> > > 
> > > 
> > > It specify REQ_WC when calling VFIO_DEVICE_GET_REGION_INFO
> > > 
> > > The kernel will then return an offset value that yields a WC
> > > mapping. It doesn't displace the normal non-WC mapping?
> > > 
> > > Arguably we should fixup the kernel to put the mmap cookies into a
> > > maple tree so they can be dynamically allocated and more densely
> > > packed.  
> > 
> > vfio_region_info.flags in not currently tested for input therefore this
> > proposal could lead to unexpected behavior for a caller that doesn't
> > currently zero this field.  It's intended as an output-only field.  
> 
> Perhaps a REGION_INFO2 then?
> 
> I still think per-request is better than a global flag

I don't understand why we'd need a REGION_INFO2, we already have
support for defining new regions.  We do this by increasing the
num_regions value from the VFIO_DEVICE_GET_INFO ioctl.  The user can
iterate those additional regions and for each index call
VFIO_DEVICE_GET_REGION_INFO.  The new regions expose a
VFIO_REGION_INFO_CAP_TYPE capability where we define new types as:

#define VFIO_REGION_TYPE_PCI_BAR0_WC	(4)
#define VFIO_REGION_TYPE_PCI_BAR1_WC	(5)
#define VFIO_REGION_TYPE_PCI_BAR2_WC	(6)
#define VFIO_REGION_TYPE_PCI_BAR3_WC	(7)
#define VFIO_REGION_TYPE_PCI_BAR4_WC	(8)
#define VFIO_REGION_TYPE_PCI_BAR5_WC	(9)

We'd populate these new regions only for BARs that support prefetch and
mmap and we'd define that these BARs may expose only the MMAP flag and
not the READ or WRITE flags since those can go through the standard
region.  Really the only difference from the static vfio-pci defined
region indexes is the O(N) search for the user to find the vfio region
index to BAR mapping.  Thanks,

Alex


