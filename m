Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1882CDA48
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 16:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387848AbgLCPoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 10:44:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387680AbgLCPox (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 10:44:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607010206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mRZ+N7+DKVnB4FTAtX9mrza/iWwjCH89QGOlxrsGIes=;
        b=U5ljhQxVMLO2b37F+a6gRRQelzPqV30MyIdhXt/OCkx1au36k4zAbRyndD8BxXrnbWojQk
        wcQZUivemitIorFS8sqYsJRDDYQmXbt/yJfzDe6fk5lIEiO8P6pTPI2nhnKx3EzBZg66of
        oV6GT6NzV9ZYc5HNgrVOebi0XLrzFjE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-q6unW_ncMFqA-BU3UqXSOA-1; Thu, 03 Dec 2020 10:43:25 -0500
X-MC-Unique: q6unW_ncMFqA-BU3UqXSOA-1
Received: by mail-qv1-f70.google.com with SMTP id f2so1929714qvb.7
        for <kvm@vger.kernel.org>; Thu, 03 Dec 2020 07:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mRZ+N7+DKVnB4FTAtX9mrza/iWwjCH89QGOlxrsGIes=;
        b=QGXxNuNjZATR1kqFcN/0IotUbX0KzeUhqypmNq9ZSXLYAJnytOMBAWbXHAYn81aXm6
         gzcY2bPXyL6y/xWlbJK9zfdZfgW4FgN5XDhRMxTdSt+nJoo5GiRdS85xDC4u2XDcJkcG
         atgzo63DvSm/2pjjVYS2zcUFcM6FvY6b26PCzr82LnMf1EGuuEdbPokKVwytQ5AUuiUR
         kznm9PoyHXXiIXcDDMItvFW/j9BLw2VITI1F/8tZvl8zLgROe5kHKa8xHeOGxt3b+W0H
         rCKxZdXAKN54SSun29J2+zyAH0oKLUqimXEwOPh2Wrl1AjyO9nl1RLLOnxuY3osakouA
         L2Pg==
X-Gm-Message-State: AOAM532kUZjgd9p2a3e3GLsRy8ba5tYk5ancla9W1LLfzN3Pfl90PkpP
        TZjhBLvk01pzEB1QJyY8BvuIOi+Y4QYCr1EwQK0GxgR1+Qig+IC3t5tCvtvNTaUDP3fe1dbxfrC
        wlrgymLmUtlT8
X-Received: by 2002:a05:6214:366:: with SMTP id t6mr3982352qvu.58.1607010204919;
        Thu, 03 Dec 2020 07:43:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6scxoBNpecARFdQfp1n5lnLQe6YgxDt/NvNxEcWQnQH6XXutdUiMKS3eA1hJSNjKEGXuDfw==
X-Received: by 2002:a05:6214:366:: with SMTP id t6mr3982333qvu.58.1607010204690;
        Thu, 03 Dec 2020 07:43:24 -0800 (PST)
Received: from xz-x1 ([142.126.94.187])
        by smtp.gmail.com with ESMTPSA id w21sm1854362qki.6.2020.12.03.07.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 07:43:23 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:43:22 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201203154322.GH108496@xz-x1>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
 <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
 <20201125155711.GA6489@xz-x1>
 <20201202143356.GK655829@stefanha-x1.localdomain>
 <20201202154511.GI3277@xz-x1>
 <20201203112002.GE689053@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203112002.GE689053@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 03, 2020 at 11:20:02AM +0000, Stefan Hajnoczi wrote:
> On Wed, Dec 02, 2020 at 10:45:11AM -0500, Peter Xu wrote:
> > On Wed, Dec 02, 2020 at 02:33:56PM +0000, Stefan Hajnoczi wrote:
> > > On Wed, Nov 25, 2020 at 10:57:11AM -0500, Peter Xu wrote:
> > > > On Wed, Nov 25, 2020 at 01:05:25AM +0000, Justin He wrote:
> > > > > > I'd appreciate if you could explain why vfio needs to dma map some
> > > > > > PROT_NONE
> > > > > 
> > > > > Virtiofs will map a PROT_NONE cache window region firstly, then remap the sub
> > > > > region of that cache window with read or write permission. I guess this might
> > > > > be an security concern. Just CC virtiofs expert Stefan to answer it more accurately.
> > > > 
> > > > Yep.  Since my previous sentence was cut off, I'll rephrase: I was thinking
> > > > whether qemu can do vfio maps only until it remaps the PROT_NONE regions into
> > > > PROT_READ|PROT_WRITE ones, rather than trying to map dma pages upon PROT_NONE.
> > > 
> > > Userspace processes sometimes use PROT_NONE to reserve virtual address
> > > space. That way future mmap(NULL, ...) calls will not accidentally
> > > allocate an address from the reserved range.
> > > 
> > > virtio-fs needs to do this because the DAX window mappings change at
> > > runtime. Initially the entire DAX window is just reserved using
> > > PROT_NONE. When it's time to mmap a portion of a file into the DAX
> > > window an mmap(fixed_addr, ...) call will be made.
> > 
> > Yes I can understand the rational on why the region is reserved.  However IMHO
> > the real question is why such reservation behavior should affect qemu memory
> > layout, and even further to VFIO mappings.
> > 
> > Note that PROT_NONE should likely mean that there's no backing page at all in
> > this case.  Since vfio will pin all the pages before mapping the DMAs, it also
> > means that it's at least inefficient, because when we try to map all the
> > PROT_NONE pages we'll try to fault in every single page of it, even if they may
> > not ever be used.
> > 
> > So I still think this patch is not doing the right thing.  Instead we should
> > somehow teach qemu that the virtiofs memory region should only be the size of
> > enabled regions (with PROT_READ|PROT_WRITE), rather than the whole reserved
> > PROT_NONE region.
> 
> virtio-fs was not implemented with IOMMUs in mind. The idea is just to
> install a kvm.ko memory region that exposes the DAX window.
> 
> Perhaps we need to treat the DAX window like an IOMMU? That way the
> virtio-fs code can send map/unmap notifications and hw/vfio/ can
> propagate them to the host kernel.

Sounds right.  One more thing to mention is that we may need to avoid tearing
down the whole old DMA region when resizing the PROT_READ|PROT_WRITE region
into e.g. a bigger one to cover some of the previusly PROT_NONE part, as long
as if the before-resizing region is still possible to be accessed from any
hardware.  It smells like something David is working with virtio-mem, not sure
whether there's any common infrastructure that could be shared.

Thanks,

-- 
Peter Xu

