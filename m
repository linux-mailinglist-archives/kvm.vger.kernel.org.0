Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3010F375093
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 10:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhEFINZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 04:13:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231372AbhEFINY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 04:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620288746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UC82bAJniKzYDd1rr6hFdgedXUqInssRFspajndQMpU=;
        b=SK8K2O+TEh9ofT+OChMOa8gvXEKqeKOs94Zso8TwxRT8LPF92W6hNmXxbr9UoUVJY6bRMv
        Zq9lwm6mmJrdbKrvg75l43ovexfx6ledyQgI67J5MT7hlNS3IviyzQhFWNdGe4JbvlMvsS
        KObIJy0ZVi5FzBY8WY5eoquaVYCau3Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-OnlyOSJRNAmb0vOfbdGs1g-1; Thu, 06 May 2021 04:12:23 -0400
X-MC-Unique: OnlyOSJRNAmb0vOfbdGs1g-1
Received: by mail-wm1-f71.google.com with SMTP id n9-20020a1c40090000b02901401bf40f9dso2367642wma.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 01:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UC82bAJniKzYDd1rr6hFdgedXUqInssRFspajndQMpU=;
        b=kI/Ih64aUdPRhsIf7318NCIuLx6e/gojdZhcaY5u5rMEBZChpzadnqFfCW4hjr7aSE
         QRO3Fx+VIp2HMwK9er3b9plFNkqKYVWjy/fJ1odt6EfRLDy4tjOYU08KwWqgVIeh1wS1
         ImfuZokMf0eKgJXOCWclJ2vC0Jx4+eUnISm9xiU4GXtiU/pHQqpmB/CqS42Dt/xf8FFh
         P+u422ODuAmkBiqcH5N+VDQK+ahDy2DrzL7wCKBPhad6isSUDv8FxrMC8gI1SGf2CBR1
         4NYDvIscEUNvUwfaYpec7GJc1urNCz/JBzhFkF7a2WTtIaxIpYnEfHPPva1lRhTl1O+l
         PEhg==
X-Gm-Message-State: AOAM530wMhHcy5S+4xLuzK+bo9X93j4tz3NQGyxvrd9nvMX//n2vTnoj
        +kvHce5MVORrmPcdB+FHRyiEOgjm/cO1ozoM67Wtrgjv7kXt60tyPh21bB98o8yaV1N0YjE8+5S
        bXh7yDAfhDOdo
X-Received: by 2002:a5d:5351:: with SMTP id t17mr3541254wrv.83.1620288741817;
        Thu, 06 May 2021 01:12:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxYOEaMbdcz5IXpIt214SV5btSIHDzQM7uxpcmfvjwnZSCT2BWQX5LFXPNw221igJoGM2NA4Q==
X-Received: by 2002:a5d:5351:: with SMTP id t17mr3541224wrv.83.1620288741611;
        Thu, 06 May 2021 01:12:21 -0700 (PDT)
Received: from redhat.com ([2a10:8004:640e:0:d1db:1802:5043:7b85])
        by smtp.gmail.com with ESMTPSA id x65sm10637130wmg.36.2021.05.06.01.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 01:12:20 -0700 (PDT)
Date:   Thu, 6 May 2021 04:12:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, hch@infradead.org
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <20210506041057-mutt-send-email-mst@kernel.org>
References: <20210423080942.2997-1-jasowang@redhat.com>
 <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 06, 2021 at 11:20:30AM +0800, Jason Wang wrote:
> 
> 在 2021/4/23 下午4:09, Jason Wang 写道:
> > Hi:
> > 
> > Sometimes, the driver doesn't trust the device. This is usually
> > happens for the encrtpyed VM or VDUSE[1]. In both cases, technology
> > like swiotlb is used to prevent the poking/mangling of memory from the
> > device. But this is not sufficient since current virtio driver may
> > trust what is stored in the descriptor table (coherent mapping) for
> > performing the DMA operations like unmap and bounce so the device may
> > choose to utilize the behaviour of swiotlb to perform attacks[2].
> > 
> > To protect from a malicous device, this series store and use the
> > descriptor metadata in an auxiliay structure which can not be accessed
> > via swiotlb instead of the ones in the descriptor table. This means
> > the descriptor table is write-only from the view of the driver.
> > 
> > Actually, we've almost achieved that through packed virtqueue and we
> > just need to fix a corner case of handling mapping errors. For split
> > virtqueue we just follow what's done in the packed.
> > 
> > Note that we don't duplicate descriptor medata for indirect
> > descriptors since it uses stream mapping which is read only so it's
> > safe if the metadata of non-indirect descriptors are correct.
> > 
> > For split virtqueue, the change increase the footprint due the the
> > auxiliary metadata but it's almost neglectlable in the simple test
> > like pktgen or netpef.
> > 
> > Slightly tested with packed on/off, iommu on/of, swiotlb force/off in
> > the guest.
> > 
> > Please review.
> > 
> > Changes from V1:
> > - Always use auxiliary metadata for split virtqueue
> > - Don't read from descripto when detaching indirect descriptor
> 
> 
> Hi Michael:
> 
> Our QE see no regression on the perf test for 10G but some regressions
> (5%-10%) on 40G card.
> 
> I think this is expected since we increase the footprint, are you OK with
> this and we can try to optimize on top or you have other ideas?
> 
> Thanks

Let's try for just a bit, won't make this window anyway:

I have an old idea. Add a way to find out that unmap is a nop
(or more exactly does not use the address/length).
Then in that case even with DMA API we do not need
the extra data. Hmm?


> 
> > 
> > [1]
> > https://lore.kernel.org/netdev/fab615ce-5e13-a3b3-3715-a4203b4ab010@redhat.com/T/
> > [2]
> > https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
> > 
> > Jason Wang (7):
> >    virtio-ring: maintain next in extra state for packed virtqueue
> >    virtio_ring: rename vring_desc_extra_packed
> >    virtio-ring: factor out desc_extra allocation
> >    virtio_ring: secure handling of mapping errors
> >    virtio_ring: introduce virtqueue_desc_add_split()
> >    virtio: use err label in __vring_new_virtqueue()
> >    virtio-ring: store DMA metadata in desc_extra for split virtqueue
> > 
> >   drivers/virtio/virtio_ring.c | 201 +++++++++++++++++++++++++----------
> >   1 file changed, 144 insertions(+), 57 deletions(-)
> > 

