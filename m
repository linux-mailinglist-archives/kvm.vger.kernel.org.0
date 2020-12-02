Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8082CC132
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 16:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbgLBPqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 10:46:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727966AbgLBPqn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 10:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606923916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rYeojU2BV32koHjOp1T69U+yIm9pG6hdZwR2k7JADHk=;
        b=ZevwB4CH244ZL5zLGCLK+zRgLfaEBCxm11S9i1Dqp3kC1JXLC0qt8gyvI9xvGp5FgO2QrM
        k9L6bE2dV6Mkgc8pWBoIP7NLfIYO+5kLxR6UkhNO5sbum2Xy8jAWd6tZ5T9ECtt3eWmU5d
        5Lz2HQFbA5ReSBMDd2e37B84LBIGu/4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-JXAC4JsAOGaQqfr3Cv2IcA-1; Wed, 02 Dec 2020 10:45:14 -0500
X-MC-Unique: JXAC4JsAOGaQqfr3Cv2IcA-1
Received: by mail-qv1-f72.google.com with SMTP id ca17so1508698qvb.1
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 07:45:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rYeojU2BV32koHjOp1T69U+yIm9pG6hdZwR2k7JADHk=;
        b=kzYwKEE2UDoyA8SpRtx1pSVS018ZX6qLGje2npJILfpCzsRyp4b47clZyZAEU4xl4g
         VXhLlErfYksnTnqAS+8vwhdm5nf3yYa1oY59LrQtzdx9HM2mXLyjYW6TTLYJ59oH1uGJ
         LJ7a11TnSLiwz8ukAINtGTtgTyqIVa1te0t8LnTf7hkTPShnfm3s3NGMmiFQnBJRTx14
         fgX6g3MUNZKSwJZpBjsu7HARWQ7sZPpf6PzYrr+qvS76equlmVab/M531LqNh+uZmqk+
         oNPsu6SomKdAHiOB7CgXo3rEM4MduAtw0kejpge48yoD/V+fwIvxLFD0cpzwQNYPYAIE
         u/Rg==
X-Gm-Message-State: AOAM531rnqugJlZKS1UPtxex9r8gM3Z5PujWq+ZQrP68tDVWTmAUe13y
        0Ubl1uxRtFOl75QFadXPxKiL9f8pzfR1YJaKytGG7ttXN8gDUuRwUkrRzP3nbPnbvA9UW3pjga/
        2SdaHPO6y+O4I
X-Received: by 2002:a0c:fa4f:: with SMTP id k15mr2997622qvo.62.1606923914283;
        Wed, 02 Dec 2020 07:45:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/s7lau9uMMae+1kW9tIhIk49vmBEdT4Fe1z9pgzRuFvs/dTHZvXh5HM5I+aw5aSRZnLJ/ow==
X-Received: by 2002:a0c:fa4f:: with SMTP id k15mr2997597qvo.62.1606923914031;
        Wed, 02 Dec 2020 07:45:14 -0800 (PST)
Received: from xz-x1 ([142.126.94.187])
        by smtp.gmail.com with ESMTPSA id j17sm1975151qtn.2.2020.12.02.07.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 07:45:13 -0800 (PST)
Date:   Wed, 2 Dec 2020 10:45:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201202154511.GI3277@xz-x1>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
 <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
 <20201125155711.GA6489@xz-x1>
 <20201202143356.GK655829@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201202143356.GK655829@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Stefan,

On Wed, Dec 02, 2020 at 02:33:56PM +0000, Stefan Hajnoczi wrote:
> On Wed, Nov 25, 2020 at 10:57:11AM -0500, Peter Xu wrote:
> > On Wed, Nov 25, 2020 at 01:05:25AM +0000, Justin He wrote:
> > > > I'd appreciate if you could explain why vfio needs to dma map some
> > > > PROT_NONE
> > > 
> > > Virtiofs will map a PROT_NONE cache window region firstly, then remap the sub
> > > region of that cache window with read or write permission. I guess this might
> > > be an security concern. Just CC virtiofs expert Stefan to answer it more accurately.
> > 
> > Yep.  Since my previous sentence was cut off, I'll rephrase: I was thinking
> > whether qemu can do vfio maps only until it remaps the PROT_NONE regions into
> > PROT_READ|PROT_WRITE ones, rather than trying to map dma pages upon PROT_NONE.
> 
> Userspace processes sometimes use PROT_NONE to reserve virtual address
> space. That way future mmap(NULL, ...) calls will not accidentally
> allocate an address from the reserved range.
> 
> virtio-fs needs to do this because the DAX window mappings change at
> runtime. Initially the entire DAX window is just reserved using
> PROT_NONE. When it's time to mmap a portion of a file into the DAX
> window an mmap(fixed_addr, ...) call will be made.

Yes I can understand the rational on why the region is reserved.  However IMHO
the real question is why such reservation behavior should affect qemu memory
layout, and even further to VFIO mappings.

Note that PROT_NONE should likely mean that there's no backing page at all in
this case.  Since vfio will pin all the pages before mapping the DMAs, it also
means that it's at least inefficient, because when we try to map all the
PROT_NONE pages we'll try to fault in every single page of it, even if they may
not ever be used.

So I still think this patch is not doing the right thing.  Instead we should
somehow teach qemu that the virtiofs memory region should only be the size of
enabled regions (with PROT_READ|PROT_WRITE), rather than the whole reserved
PROT_NONE region.

Thanks,

-- 
Peter Xu

