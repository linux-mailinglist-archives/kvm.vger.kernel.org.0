Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D92CDA7B
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 16:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgLCP5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 10:57:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58117 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726162AbgLCP5U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 10:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607010953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TD7yoOq0StC1kk+iV8oct8NiB7XzLCThQ4yP+5VBFYM=;
        b=XklypySM5hd6uvTu0RlrY7A+KyY+zXcjRI7E8KXFc9ZiTiaGQZBUys60HvxiAsOeOOJ5zV
        TxELVTAoV2rR3jURUMGhIJvagG5kvl6SEbY5PaxQ2Acg0FBD2+ILirKTDO1bCfVg9Mqt5l
        PRvmorkBwWQxtcnKHNslLy105DEcpgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-eoOuWSa2Pjad67_cyOh5yQ-1; Thu, 03 Dec 2020 10:55:51 -0500
X-MC-Unique: eoOuWSa2Pjad67_cyOh5yQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D89F84E240;
        Thu,  3 Dec 2020 15:55:48 +0000 (UTC)
Received: from w520.home (ovpn-112-10.phx2.redhat.com [10.3.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EFEF1057F61;
        Thu,  3 Dec 2020 15:55:16 +0000 (UTC)
Date:   Thu, 3 Dec 2020 08:55:16 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Justin He <Justin.He@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201203085516.2016d154@w520.home>
In-Reply-To: <20201203154322.GH108496@xz-x1>
References: <20201119142737.17574-1-justin.he@arm.com>
        <20201124181228.GA276043@xz-x1>
        <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
        <20201125155711.GA6489@xz-x1>
        <20201202143356.GK655829@stefanha-x1.localdomain>
        <20201202154511.GI3277@xz-x1>
        <20201203112002.GE689053@stefanha-x1.localdomain>
        <20201203154322.GH108496@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Dec 2020 10:43:22 -0500
Peter Xu <peterx@redhat.com> wrote:

> On Thu, Dec 03, 2020 at 11:20:02AM +0000, Stefan Hajnoczi wrote:
> > On Wed, Dec 02, 2020 at 10:45:11AM -0500, Peter Xu wrote:  
> > > On Wed, Dec 02, 2020 at 02:33:56PM +0000, Stefan Hajnoczi wrote:  
> > > > On Wed, Nov 25, 2020 at 10:57:11AM -0500, Peter Xu wrote:  
> > > > > On Wed, Nov 25, 2020 at 01:05:25AM +0000, Justin He wrote:  
> > > > > > > I'd appreciate if you could explain why vfio needs to dma map some
> > > > > > > PROT_NONE  
> > > > > > 
> > > > > > Virtiofs will map a PROT_NONE cache window region firstly, then remap the sub
> > > > > > region of that cache window with read or write permission. I guess this might
> > > > > > be an security concern. Just CC virtiofs expert Stefan to answer it more accurately.  
> > > > > 
> > > > > Yep.  Since my previous sentence was cut off, I'll rephrase: I was thinking
> > > > > whether qemu can do vfio maps only until it remaps the PROT_NONE regions into
> > > > > PROT_READ|PROT_WRITE ones, rather than trying to map dma pages upon PROT_NONE.  
> > > > 
> > > > Userspace processes sometimes use PROT_NONE to reserve virtual address
> > > > space. That way future mmap(NULL, ...) calls will not accidentally
> > > > allocate an address from the reserved range.
> > > > 
> > > > virtio-fs needs to do this because the DAX window mappings change at
> > > > runtime. Initially the entire DAX window is just reserved using
> > > > PROT_NONE. When it's time to mmap a portion of a file into the DAX
> > > > window an mmap(fixed_addr, ...) call will be made.  
> > > 
> > > Yes I can understand the rational on why the region is reserved.  However IMHO
> > > the real question is why such reservation behavior should affect qemu memory
> > > layout, and even further to VFIO mappings.
> > > 
> > > Note that PROT_NONE should likely mean that there's no backing page at all in
> > > this case.  Since vfio will pin all the pages before mapping the DMAs, it also
> > > means that it's at least inefficient, because when we try to map all the
> > > PROT_NONE pages we'll try to fault in every single page of it, even if they may
> > > not ever be used.
> > > 
> > > So I still think this patch is not doing the right thing.  Instead we should
> > > somehow teach qemu that the virtiofs memory region should only be the size of
> > > enabled regions (with PROT_READ|PROT_WRITE), rather than the whole reserved
> > > PROT_NONE region.  
> > 
> > virtio-fs was not implemented with IOMMUs in mind. The idea is just to
> > install a kvm.ko memory region that exposes the DAX window.
> > 
> > Perhaps we need to treat the DAX window like an IOMMU? That way the
> > virtio-fs code can send map/unmap notifications and hw/vfio/ can
> > propagate them to the host kernel.  
> 
> Sounds right.  One more thing to mention is that we may need to avoid tearing
> down the whole old DMA region when resizing the PROT_READ|PROT_WRITE region
> into e.g. a bigger one to cover some of the previusly PROT_NONE part, as long
> as if the before-resizing region is still possible to be accessed from any
> hardware.  It smells like something David is working with virtio-mem, not sure
> whether there's any common infrastructure that could be shared.

Yes, very similar to his RamDiscardMgr which works on a granularity
basis.  vfio maps in granularity chunks and unmaps can span multiple
chunks.  This usage might be similar enough to use as-is.  Thanks,

Alex

