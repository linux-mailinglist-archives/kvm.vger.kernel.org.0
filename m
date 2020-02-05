Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBF115260E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 06:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgBEFiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 00:38:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53866 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725385AbgBEFiF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 00:38:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580881083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxLib1DyGWA3n/jl6h9rliqNTP1O1RA9Yuhg5J8jnQ8=;
        b=fOw+pS4UPGNwgFcELmQf0tuvLOvAHXpbDTnrMcn31mEFiPxuHNhhxmIdrlSWBXyoVacMDf
        TUXxoJ3vHlIWR2FYBAjQQ1xu6KcuU84xVYViaW2N6tAZJlYw0HZeOvWubHBJ5lU8KmEzKG
        n18He0xIDNBg0Aw1EDPiF8N6oBTLmyQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-bJ40bHRONgmdOzH7gPixqw-1; Wed, 05 Feb 2020 00:38:01 -0500
X-MC-Unique: bJ40bHRONgmdOzH7gPixqw-1
Received: by mail-qt1-f199.google.com with SMTP id x8so619934qtq.14
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 21:38:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XxLib1DyGWA3n/jl6h9rliqNTP1O1RA9Yuhg5J8jnQ8=;
        b=gNyHkKIshHpRTNQVQ6LjnGrz16Va85wV2xdC91SBE0top4COhzZdOVSiwtQKn4gyMq
         Dgg1d6ZCaQzwtTLBtroPY+BYV7R48jjSZk+2kXuHG9q9+oo5ywsz0Kun1n/wAWK0whse
         fB/9Nb/JUTZNdJiIzWdYDSOmXyTXsgBpfhtCFc6DL6zS5llqTvU4xSEGSaX7SflMhTEg
         Ns1u9KbjfnsiJZgXTkjKyWRZAx8O7LLgoTIJtId1h26RLjBK08lEYo81c6CzPSemNVaE
         kT59nRLifoPPZA16FfIwcx7+Ca0buABRsRDCYuOWWNANxpYxCSsc8wasRCK1HGiIc0p0
         /1DQ==
X-Gm-Message-State: APjAAAWiVE0GcYG6rBjKjDLZJTEHBz7fkpsaL50dQp3aLNZACeZWSDRb
        453qtQyT++1NE8hcIAwvnJoJit/5LkXXMiZaks/SXaa3xYLlsnvVThbYYb1r/iSYV7VF/Zrfkxv
        uVDeAYxvc/41b
X-Received: by 2002:ac8:4446:: with SMTP id m6mr32612718qtn.159.1580881080970;
        Tue, 04 Feb 2020 21:38:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqw0rRf19uckjRT2XyuOTvPcwwSVFIB7TnwPqwZmh7xwjP4vvHrAEcKTKEeGxk7l0EPBEm80AA==
X-Received: by 2002:ac8:4e43:: with SMTP id e3mr32421061qtw.129.1580880686259;
        Tue, 04 Feb 2020 21:31:26 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id y145sm12328322qkb.87.2020.02.04.21.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 21:31:25 -0800 (PST)
Date:   Wed, 5 Feb 2020 00:31:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200205003048-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
 <20200204005306-mutt-send-email-mst@kernel.org>
 <cf485e7f-46e3-20d3-8452-e3058b885d0a@redhat.com>
 <20200205020555.GA369236@___>
 <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <798e5644-ca28-ee46-c953-688af9bccd3b@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 11:12:21AM +0800, Jason Wang wrote:
> 
> On 2020/2/5 上午10:05, Tiwei Bie wrote:
> > On Tue, Feb 04, 2020 at 02:46:16PM +0800, Jason Wang wrote:
> > > On 2020/2/4 下午2:01, Michael S. Tsirkin wrote:
> > > > On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> > > > > 5) generate diffs of memory table and using IOMMU API to setup the dma
> > > > > mapping in this method
> > > > Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?
> > > > 
> > > Sure, so that basically VHOST_IOTLB_UPDATE/INVALIDATE I think?
> > Do you mean we let userspace to only use VHOST_IOTLB_UPDATE/INVALIDATE
> > to do the DMA mapping in vhost-vdpa case? When vIOMMU isn't available,
> > userspace will set msg->iova to GPA, otherwise userspace will set
> > msg->iova to GIOVA, and vhost-vdpa module will get HPA from msg->uaddr?
> > 
> > Thanks,
> > Tiwei
> 
> 
> I think so. Michael, do you think this makes sense?
> 
> Thanks

to make sure, could you post the suggested argument format for
these ioctls?

> 
> > 
> > > Thanks
> > > 
> > > 

