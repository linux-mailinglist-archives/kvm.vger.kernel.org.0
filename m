Return-Path: <kvm+bounces-47822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F177AC5A80
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 21:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CEF51BA41A3
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 19:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008422820A4;
	Tue, 27 May 2025 19:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iys6QEYo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C0527FD6E
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748373302; cv=none; b=nabxmDLt4K+jhF1F6vDWciVzpgt3kPjjW5c2gkAklUKwMFMxHljSPjVhP9FUlRsQGegFL4aTZb5sGLTVe315XxErzmaMTBQqT/7WlMTfbZB2hiLIMFhgvdHTwqcnETBHoZxM8GTfpOiEWJsHf5RcMp/p0B58eje/opmxr6pznCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748373302; c=relaxed/simple;
	bh=vvXw0E7KhYiCUrAKJzQstQee/UQMK4ldfgHCUC6DWPc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kVP0j0nVqTnnb54RwflpaJO9ZIHDx7o8jEvAvPRSe4bk2/Ywie30EzSxDo47drzp5aPAfTymIAOE4yQfHYrBxRZFPpT7i7eU5jZyC1jarvHvOlynaaGHX8OLCLtaiMMNGmg7V0KalJ5LhGHrCcN2CoHZzXxva7RQwI1T33qZSUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iys6QEYo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748373296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A61WYnWj5Uj0Eyu8/R7/WVTiW1jNq3R30BLWtPJ5MI=;
	b=iys6QEYo1ygkvyiBGKVvUquw2EZN0S0GCdE8Q4P5s4yMgAjfAUrKGzlsIQWvUgfncxO7kv
	qjof3odY2abfeeIpSkFpnROlZGhJs2LtJsAGWI4QpD3IcQNqQ4W7Y0hZ6mN6S29FGM0dlD
	vIbURQWWNal6vI4wftPtITVThkw3jHA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-rCZ-42BnP6mKQ26SC-Eq7Q-1; Tue, 27 May 2025 15:14:55 -0400
X-MC-Unique: rCZ-42BnP6mKQ26SC-Eq7Q-1
X-Mimecast-MFC-AGG-ID: rCZ-42BnP6mKQ26SC-Eq7Q_1748373294
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3dd756e455aso3493315ab.2
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 12:14:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748373294; x=1748978094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+A61WYnWj5Uj0Eyu8/R7/WVTiW1jNq3R30BLWtPJ5MI=;
        b=baHKr2yLRqPglwyLLDUoRyd1TqGpYPqO07raOH+RGhBLTcrKIRGW1SUcxgHrHPW+hG
         orRhSNUTB8B+e+Tv9qIKmh2i2E6Orqm8Bfjm751AkvtjQSGjhQw6Q/PV++PHS+QaewKK
         BaHXuEa0TSIb2Ov8FU73XLFdscizh6pqTZXr10+DstFqpH3s+vIz36hbmuagjlVja+dI
         lfq/d13K79DkAu6Itvz2yXSmLeqY4J5vKbDLjxh1IrRSQJYvIW4VZW2Og/3q2fja6eWr
         H6r9B2CJhrcYg0Tyref8DEWEErBJ4MkWnYM2DvGAloMw0qoTwlYl5F2+0Zc5nLpnw+e1
         geaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxZs121y5qsvcGlgMky/CqdyAdm2TvrP68H+QlHvz+b14Vqvb3W2dePOp0zyrU92qRD60=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Ub5/kyGWyX6R+LmkDhqDCMjeVMgIY4p1vplUbD535IWR5vNS
	SFaQPxqWR2FlaGtOv8CG1k8U3uefs0v4JhAp2zupx4hvqAEH/RcVFwWymz5TVgmZbFM2cw9r0hV
	sZlynfVf8bqtWwHOgDVRvxKd7Y89OslUx8K8f+PDM0sMdI0LUxQbSicFyFYlrHQ==
X-Gm-Gg: ASbGncuM67K+GZWfyko7m8gCJ1CBV6z8SitkI/m61LZnxbCfe/8jKHmSmV03I+6Lh7I
	c/kOz8dfrmScUa5SC6D24u8Qc4rPuPQipROb0OArayIBsKDq4daKCLZfLzl4/gd0jCd1is73qiU
	xuVBFBrXxPb3f6h+m29e9/EP1rZSfQwMWSfdDRH/TLwUf3gAT8TX1fcLfpw5uUtLjF6DFdTuO2c
	NDVQURV2Yy6ft1OEZgANIZ/r4cgmwLw6fzREPxPWGEYQko/oyfcdfbijvAesOa5ZTJACM/LeMMZ
	NUOllZ4rXVihAAA=
X-Received: by 2002:a05:6602:6c01:b0:86a:24c0:8829 with SMTP id ca18e2360f4ac-86cbb6c098dmr427828639f.0.1748373293760;
        Tue, 27 May 2025 12:14:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFU8GmOksxajcZcAXCgxVMvMRhbIvCl6cNfPryCupK0n+LI5zGmRgcGkxfHgird94ZbXntg4g==
X-Received: by 2002:a05:6602:6c01:b0:86a:24c0:8829 with SMTP id ca18e2360f4ac-86cbb6c098dmr427827439f.0.1748373293260;
        Tue, 27 May 2025 12:14:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86a50664b8bsm349552439f.2.2025.05.27.12.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 12:14:52 -0700 (PDT)
Date: Tue, 27 May 2025 13:14:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for
 large folio
Message-ID: <20250527131450.7e961373.alex.williamson@redhat.com>
In-Reply-To: <20250526033737.7657-1-lizhe.67@bytedance.com>
References: <20250523085415.6f316c84.alex.williamson@redhat.com>
	<20250526033737.7657-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 May 2025 11:37:37 +0800
lizhe.67@bytedance.com wrote:

> On Fri, 23 May 2025 08:54:15 -0600, alex.williamson@redhat.com wrote: 
> 
> > > > +static long vpfn_pages(struct vfio_dma *dma,
> > > > +		       dma_addr_t iova_start, long nr_pages)
> > > > +{
> > > > +	dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> > > > +	struct vfio_pfn *vpfn;
> > > > +	long count = 0;
> > > > +
> > > > +	do {
> > > > +		vpfn = vfio_find_vpfn_range(dma, iova_start, iova_end);  
> > > 
> > > I am somehow confused here. Function vfio_find_vpfn_range()is designed
> > > to find, through the rbtree, the node that is closest to the root node
> > > and satisfies the condition within the range [iova_start, iova_end),
> > > rather than the node closest to iova_start? Or perhaps I have
> > > misunderstood something?  
> > 
> > Sorry, that's an oversight on my part.  We might forego the _range
> > version and just do an inline walk of the tree counting the number of
> > already accounted pfns within the range.  Thanks,
> > 
> > Alex
> >   
> > > > +		if (likely(!vpfn))
> > > > +			break;
> > > > +
> > > > +		count++;
> > > > +		iova_start = vpfn->iova + PAGE_SIZE;
> > > > +	} while (iova_start < iova_end);
> > > > +
> > > > +	return count;
> > > > +}  
> 
> The utilization of the function vpfn_pages() is undoubtedly a
> good idea. It can swiftly determine the num of vpfn pages
> within a specified range, which will evidently expedite the
> process of vfio_pin_pages_remote(). Given that the function
> vfio_find_vpfn_range() returns the "top" node in the rb tree
> that satisfies the condition within the range
> [iova_start, iova_end), might we consider implementing the
> functionality of vpfn_pages() using the following approach?
> 
> +static long _vpfn_pages(struct vfio_pfn *vpfn,
> +               dma_addr_t iova_start, dma_addr_t iova_end)
> +{
> +       struct vfio_pfn *left;
> +       struct vfio_pfn *right;
> +
> +       if (!vpfn)
> +               return 0;
> +
> +       left = vpfn->node.rb_left ?
> +               rb_entry(vpfn->node.rb_left, struct vfio_pfn, node) : NULL;
> +       right = vpfn->node.rb_right ?
> +               rb_entry(vpfn->node.rb_right, struct vfio_pfn, node) : NULL;
> +
> +       if ((vpfn->iova >= iova_start) && (vpfn->iova < iova_end))
> +               return 1 + _vpfn_pages(left, iova_start, iova_end) +
> +                               _vpfn_pages(right, iova_start, iova_end);
> +
> +       if (vpfn->iova >= iova_end)
> +               return _vpfn_pages(left, iova_start, iova_end);
> +
> +       return _vpfn_pages(right, iova_start, iova_end);
> +}

Recursion doesn't seem like a good fit here, the depth is practically
unbounded.  Why not just use the new range function to find the highest
point in the tree that intersects, then search each direction in
separate loops (rb_next/rb_prev), counting additional entries within
the range?  Thanks,

Alex

> +
> +static long vpfn_pages(struct vfio_dma *dma,
> +               dma_addr_t iova_start, long nr_pages)
> +{
> +       dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> +       struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
> +
> +       return _vpfn_pages(top, iova_start, iova_end);
> +}
> 
> Thanks,
> Zhe
> 


