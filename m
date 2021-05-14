Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1572380835
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 13:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhENLPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 07:15:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhENLPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 May 2021 07:15:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620990835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GcyY5SRYU8znOLGxlQ+VXLYAFrni6/EsXvguEf/Rk+o=;
        b=ZYbH02KiPau9filrDGpj6XsfzlDwLyIGYeYJM8COAgaHTclrQ9FEyJpwlmLNJoNWglmxAt
        0yOZnlf0JG5gVrxMoKeui42MmKT+lUQmTMjiP0pEfJID9mZVyZVxQgFoHjd1//xsEzT/XL
        jdS3v7CiyqWFnz3Swkv28u0eLT++aGA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-v1nhCI6APpSp36Ltsb3GOA-1; Fri, 14 May 2021 07:13:53 -0400
X-MC-Unique: v1nhCI6APpSp36Ltsb3GOA-1
Received: by mail-wr1-f72.google.com with SMTP id h104-20020adf90710000b029010de8455a3aso12589116wrh.12
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 04:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GcyY5SRYU8znOLGxlQ+VXLYAFrni6/EsXvguEf/Rk+o=;
        b=abyb74bYWtobP2rhQ/0yz7uKHPmU98231DBCz/H5xsaWNwGt/LSWc+lnrJL6+Zd3yQ
         jLoeuFtFYxFuxTGkpfSbmzy/+QltMQDG4DT66IgQkQvXQgPCyH05kRTam9CgtW2iXVIa
         HyvZPu6QDTEqz4HsFixpMJ+gV6AYgUrrbtzCWMEqFhV+Z2HJffBGDM0wU9E/PhkzgEuw
         AjT25TiDFA8DiWpmKy8po4pWwttV04A2GYQjxYQ9Xnc/zn1uEkIF+s173X04CeAFkz6n
         EFAXDZTZ+PDRRPuvrw8WwvsSYI/SUuuoOT6ps6iQemSjb/hwGuYubhhs1llOu/y5AOHA
         aQKg==
X-Gm-Message-State: AOAM530P52FbuP1FIKjGL+y2GRY50cjAbceK/owlhW9TLJpnL9owueJ8
        8KuUPIhth2D1EwTbk7Zlw7Nki0Yi1f3J0AIHvd0AJtfxA7vpTmR+EKxBrHfOblLVyHnvaC2azoo
        9uj5NFCSQcvDm
X-Received: by 2002:a7b:c042:: with SMTP id u2mr9792474wmc.127.1620990832245;
        Fri, 14 May 2021 04:13:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZNhppxBIXT6J4oHOEj05xdp5fT5MtIiU2dY4jUT95nukcwuVNGKlHAjd1LlANrcZHhqooTQ==
X-Received: by 2002:a7b:c042:: with SMTP id u2mr9792463wmc.127.1620990832028;
        Fri, 14 May 2021 04:13:52 -0700 (PDT)
Received: from redhat.com ([2a10:800c:1fa6:0:3809:fe0c:bb87:250e])
        by smtp.gmail.com with ESMTPSA id f7sm5007823wmq.30.2021.05.14.04.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 04:13:51 -0700 (PDT)
Date:   Fri, 14 May 2021 07:13:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <20210514063516-mutt-send-email-mst@kernel.org>
References: <20210423080942.2997-1-jasowang@redhat.com>
 <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
 <20210506041057-mutt-send-email-mst@kernel.org>
 <20210506123829.GA403858@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506123829.GA403858@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 01:38:29PM +0100, Christoph Hellwig wrote:
> On Thu, May 06, 2021 at 04:12:17AM -0400, Michael S. Tsirkin wrote:
> > Let's try for just a bit, won't make this window anyway:
> > 
> > I have an old idea. Add a way to find out that unmap is a nop
> > (or more exactly does not use the address/length).
> > Then in that case even with DMA API we do not need
> > the extra data. Hmm?
> 
> So we actually do have a check for that from the early days of the DMA
> API, but it only works at compile time: CONFIG_NEED_DMA_MAP_STATE.
> 
> But given how rare configs without an iommu or swiotlb are these days
> it has stopped to be very useful.  Unfortunately a runtime-version is
> not entirely trivial, but maybe if we allow for false positives we
> could do something like this
> 
> bool dma_direct_need_state(struct device *dev)
> {
> 	/* some areas could not be covered by any map at all */
> 	if (dev->dma_range_map)
> 		return false;
> 	if (force_dma_unencrypted(dev))
> 		return false;
> 	if (dma_direct_need_sync(dev))
> 		return false;
> 	return *dev->dma_mask == DMA_BIT_MASK(64);
> }
> 
> bool dma_need_state(struct device *dev)
> {
> 	const struct dma_map_ops *ops = get_dma_ops(dev);
> 
> 	if (dma_map_direct(dev, ops))
> 		return dma_direct_need_state(dev);
> 	return ops->unmap_page ||
> 		ops->sync_single_for_cpu || ops->sync_single_for_device;
> }

Yea that sounds like a good idea. We will need to document that.


Something like:

/*
 * dma_need_state - report whether unmap calls use the address and length
 * @dev: device to guery
 *
 * This is a runtime version of CONFIG_NEED_DMA_MAP_STATE.
 *
 * Return the value indicating whether dma_unmap_* and dma_sync_* calls for the device
 * use the DMA state parameters passed to them.
 * The DMA state parameters are: scatter/gather list/table, address and
 * length.
 *
 * If dma_need_state returns false then DMA state parameters are
 * ignored by all dma_unmap_* and dma_sync_* calls, so it is safe to pass 0 for
 * address and length, and DMA_UNMAP_SG_TABLE_INVALID and
 * DMA_UNMAP_SG_LIST_INVALID for s/g table and length respectively.
 * If dma_need_state returns true then DMA state might
 * be used and so the actual values are required.
 */

And we will need DMA_UNMAP_SG_TABLE_INVALID and
DMA_UNMAP_SG_LIST_INVALID as pointers to an empty global table and list
for calls such as dma_unmap_sgtable that dereference pointers before checking
they are used.


Does this look good?

The table/length variants are for consistency, virtio specifically does
not use s/g at the moment, but it seems nicer than leaving
users wonder what to do about these.

Thoughts? Jason want to try implementing?

-- 
MST

