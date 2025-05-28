Return-Path: <kvm+bounces-47908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6A5AC7208
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 22:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E1299E484F
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 20:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1EC221271;
	Wed, 28 May 2025 20:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d9vLtCdH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39797220F2D
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 20:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748463117; cv=none; b=B9mtTulA1W90TwPnIOTfp3qJ9XplX+9T93w7LTrT6UswAlCv0ga8WgBhO0gPIjN6ogAp+nyhu4nR3cvy8rAbP2VjOcskFfNYema+KKSgqK9WTZG3HduZJrE6l6A3K872jWN0l7QdEwj2NAwnyuc5FCND0m5SEiXk1TZTEmS+5bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748463117; c=relaxed/simple;
	bh=yTibps6sQtyWOT1ZpkEFcbp9vQHKMOZepSb52BCrQZw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NEY2WexLX+4gUCLULLIz9tH7vVVOR4XdgqoYjVAz9+cqB5q2meO8MsaCmqbpnn0mQgpfPbpTig4linjtmRsoFBl/+/9k81WM9kNYRNz78KCVBbD30XChY1fV2QbhAHVyFhqpW+jzXgjMNCcqwJilnbxXMFsRhwckS/FTcOdbnfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d9vLtCdH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748463115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AXTVaff9a+Mqy0vxS6aINGdRM0ujSeLiK0Ywdp1i2eg=;
	b=d9vLtCdH4u0ytutUmBRd9VCT8jH1+3E25BVWakbFOYUKCV3VVAboZgdkP7IQcjBxM7YXS2
	4wHslJr+PdsgYLtkjHrS1WUJZg4U4GjKBJgr8JIk1g3rZ6IBwU0W8QKXfIT4nVTRUnebFh
	oSFeAs5merlgzBtXXGL9bcfVHwFjFUQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-PlPJ30_7P9-MmlX4fWJEKQ-1; Wed, 28 May 2025 16:11:52 -0400
X-MC-Unique: PlPJ30_7P9-MmlX4fWJEKQ-1
X-Mimecast-MFC-AGG-ID: PlPJ30_7P9-MmlX4fWJEKQ_1748463111
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3da7648c031so453575ab.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 13:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748463110; x=1749067910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXTVaff9a+Mqy0vxS6aINGdRM0ujSeLiK0Ywdp1i2eg=;
        b=pJc2hm2SzcvmrWKf2ZNKN3AKIx6kB+pey2kJ+Re3ZygWuq65kGJrDNe4RnELLIIilJ
         FfWsYEgjHhz3VX+ReIGSFSbndNxl9D7K2555QXqwOYrFi/vfQldN+YnX4BHDasqYOL5O
         k03EyQ1DKIxenGBqypm4vFLd79ZmSvkmkYmsHbbosG2uURiaD3hlMSVGN8pxMmqrN1iS
         CYQOuhVmHGaegHsIp22PuI6FEmogeme+CohRI9MphX0s9Px+tlOkMN6LCRV/FU+l9cKV
         s5acvo130eExti8qXJP3AbD7jpQ43SiYyvtH4O7DNxDcOKf0nwRN2/JomFM3RoKA7jIq
         T03A==
X-Forwarded-Encrypted: i=1; AJvYcCXVgAKQvXiPVBEGBoN+nCOr6gnkhz9kjNaOPni2bYbn6gBPOaPSJTFqKpSkpWXcpY/dCK0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3DOU8+Ta7mx2V8KqmWbpL3AN3djn6i/DXzUTQwzniqv4DWS5I
	+M2deKSDGvdpYGIJQK2RJ0L8ncb9W7D9BmCfPv8jchWzLY1ofWlf5dWs48R3b6rwdHoOp+I+Pxn
	mHCUE27GDKwo58lV3NFFnDTL0zRvJQkTe3pvI4M69urKFDgU/wRHPZA==
X-Gm-Gg: ASbGncuKuavJdkj0fHOyKPnF/StydgPnKO1+5tTnhdbWRicPlYm/cQR8CAH8pGwwfXS
	J750yqSE426UtXPgYNDaPqn6UGc0fge0ZD/Sk66RLpjXL9Z044iIvQapomSlb0ICcxskqj6A035
	hMkycqn0fRNHb4p1BqB4XJVr/yA1gnQwozfSO5Zm4LYbhpOY1HxVYajidKZCnlRhnc12aBFb+h8
	1D0mgJbYEmYdtAwORyx+7TBpP3ItaHIenb7lOtGejOrbfYUPIrSUSz53l1uTgtio8xinwxq9uLV
	0zip0ugE1Jkuy1I=
X-Received: by 2002:a05:6602:13cb:b0:85e:5cbc:115 with SMTP id ca18e2360f4ac-86ce9603c1amr143964039f.1.1748463109990;
        Wed, 28 May 2025 13:11:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWRD0ZinUQC5DXrMjGiU9am068ESztzqYYU2+gGmoY/VB0ikpKuuvysopy0HHu0Fgc4j91Pw==
X-Received: by 2002:a05:6602:13cb:b0:85e:5cbc:115 with SMTP id ca18e2360f4ac-86ce9603c1amr143962939f.1.1748463109617;
        Wed, 28 May 2025 13:11:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdbd5a8db5sm360812173.122.2025.05.28.13.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 13:11:48 -0700 (PDT)
Date: Wed, 28 May 2025 14:11:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, peterx@redhat.com
Subject: Re: [PATCH v4] vfio/type1: optimize vfio_pin_pages_remote() for
 large folio
Message-ID: <20250528141147.2d91370c.alex.williamson@redhat.com>
In-Reply-To: <20250528042124.69827-1-lizhe.67@bytedance.com>
References: <20250527131450.7e961373.alex.williamson@redhat.com>
	<20250528042124.69827-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 May 2025 12:21:24 +0800
lizhe.67@bytedance.com wrote:

> On Tue, 27 May 2025 13:14:50 -0600, alex.williamson@redhat.com wrote: 
> 
> > > The utilization of the function vpfn_pages() is undoubtedly a
> > > good idea. It can swiftly determine the num of vpfn pages
> > > within a specified range, which will evidently expedite the
> > > process of vfio_pin_pages_remote(). Given that the function
> > > vfio_find_vpfn_range() returns the "top" node in the rb tree
> > > that satisfies the condition within the range
> > > [iova_start, iova_end), might we consider implementing the
> > > functionality of vpfn_pages() using the following approach?
> > > 
> > > +static long _vpfn_pages(struct vfio_pfn *vpfn,
> > > +               dma_addr_t iova_start, dma_addr_t iova_end)
> > > +{
> > > +       struct vfio_pfn *left;
> > > +       struct vfio_pfn *right;
> > > +
> > > +       if (!vpfn)
> > > +               return 0;
> > > +
> > > +       left = vpfn->node.rb_left ?
> > > +               rb_entry(vpfn->node.rb_left, struct vfio_pfn, node) : NULL;
> > > +       right = vpfn->node.rb_right ?
> > > +               rb_entry(vpfn->node.rb_right, struct vfio_pfn, node) : NULL;
> > > +
> > > +       if ((vpfn->iova >= iova_start) && (vpfn->iova < iova_end))
> > > +               return 1 + _vpfn_pages(left, iova_start, iova_end) +
> > > +                               _vpfn_pages(right, iova_start, iova_end);
> > > +
> > > +       if (vpfn->iova >= iova_end)
> > > +               return _vpfn_pages(left, iova_start, iova_end);
> > > +
> > > +       return _vpfn_pages(right, iova_start, iova_end);
> > > +}  
> > 
> > Recursion doesn't seem like a good fit here, the depth is practically
> > unbounded.  Why not just use the new range function to find the highest
> > point in the tree that intersects, then search each direction in
> > separate loops (rb_next/rb_prev), counting additional entries within
> > the range?  Thanks,
> > 
> > Alex  
> 
> Oh, I see what you mean. So the implementation of vpfn_pages() might be
> something like this.
> 
> +static long vpfn_pages(struct vfio_dma *dma,
> +               dma_addr_t iova_start, long nr_pages)
> +{
> +       dma_addr_t iova_end = iova_start + (nr_pages << PAGE_SHIFT);
> +       struct vfio_pfn *top = vfio_find_vpfn_range(dma, iova_start, iova_end);
> +       long ret = 1;
> +       struct vfio_pfn *vpfn;
> +       struct rb_node *prev;
> +       struct rb_node *next;
> +
> +       if (likely(!top))
> +               return 0;
> +
> +       prev = next = &top->node;
> +
> +       while ((prev = rb_prev(prev))) {
> +               vpfn = rb_entry(prev, struct vfio_pfn, node);
> +               if (vpfn->iova < iova_start)
> +                       break;
> +               ret++;
> +       }
> +
> +       while ((next = rb_next(next))) {
> +               vpfn = rb_entry(next, struct vfio_pfn, node);
> +               if (vpfn->iova >= iova_end)
> +                       break;
> +               ret++;
> +       }
> +
> +       return ret;
> +}

Yes, that looks like it should work to me.  Thanks,

Alex


