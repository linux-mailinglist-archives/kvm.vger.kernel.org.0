Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025E03F7529
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240835AbhHYMfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240564AbhHYMfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:35:42 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9013C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:34:56 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id 14so26838757qkc.4
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zFZPuPaQ1Kz3G6x6PmpNKKGypTkQ311aJRO6yBZn+Ls=;
        b=aZ8hL+0hnTqHi2k0g6M0vFYJojK+pBS3e+VueZvBphF5TsE22ITl/3Tap3iu3locai
         arax04ktKul3Qie4p9AldV2jtPAG+ZGTWIXnOVbobw2lKoWfjkG8aPaofIifWjo2TohW
         Tndez8Q/gRtdWIM9hw7UDjdCW4GEvHEm8JCuNjCggTbeBgiptiqZ7L2b7BRcY4H0BFpY
         DnYFUISpJTh3gv/93cG4x4vVw7y5HvQOSNQZUm6zrxXVmytmCC7HaU6vcf9Yv+KWJcKs
         OdhQ6njyqdykXRw39kNp1ODxmJgOsrU684/jCOILaxyv2Y/5vYHI6GqjiTjW84WHzMX7
         E3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zFZPuPaQ1Kz3G6x6PmpNKKGypTkQ311aJRO6yBZn+Ls=;
        b=jUzLeM5p2uIHRmCQWl64xd9fvvItScnr1Ms2BMN0fSPY4KLLjqVRa8gtDA9dxQ6nys
         uw6JJGccgCqxCLh89ULAiWddPHET2V7GymxQQ/4/pXMAWwt+0aBa9VosiZmMTJgoYJFu
         4nLmVZNRTGgvu+p1rGLRgfqA+C0ZlgZ56/nrPus+Qms710pRNva67aAKBu6lmAvT12Lo
         Yp2NghHtKlRc4cscR3MofymxHJ0C5udQibXGecSifH5CesUz9idgj+Zt9n6atjHy8i09
         hlIZEXn+5FHM8CtBfzgqZ0oVuQyctNnybbBzkyJ+eXSfcWNnh4NBBmp/Sb1YrrBTSv4R
         T0Bw==
X-Gm-Message-State: AOAM533cUlJ/3DLx32/qyhBe7+54PZQTeE3OG9Sf2QlY4MeKC50PP1bE
        eiEaeHJoVrwTZLH7YDuivwwYpg==
X-Google-Smtp-Source: ABdhPJwfoYKuqKx94oq8lEIYiqZAwjXKk1pIXZ/e6gkz+s7S/qHxvf1P9ahHCVeeI+O+hTJRhDLaWw==
X-Received: by 2002:a37:a88a:: with SMTP id r132mr31995310qke.212.1629894896166;
        Wed, 25 Aug 2021 05:34:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id t8sm7755626qtn.37.2021.08.25.05.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:34:55 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIs7K-004slb-Lr; Wed, 25 Aug 2021 09:34:54 -0300
Date:   Wed, 25 Aug 2021 09:34:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Message-ID: <20210825123454.GW543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-8-hch@lst.de>
 <20210825001916.GN543798@ziepe.ca>
 <20210825053237.GB26806@lst.de>
 <20210825122144.GV543798@ziepe.ca>
 <20210825122400.GA16194@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825122400.GA16194@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 02:24:00PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 25, 2021 at 09:21:44AM -0300, Jason Gunthorpe wrote:
> > This feature is about creating a device that is not connected to a HW
> > IO page table (at least by the VFIO iommu code) but the IO page table
> > is held in software and accessed by the VFIO driver through the pin
> > API.
> > 
> > virtual_iommu is somewhat overloaded with the idea of a vIOMMU created
> > by qemu and stuffed into a guest..
> > 
> > "domainless" might work but I also find it confusing that the iommu
> > code uses the word domain to refer to a HW IO page table :\
> > 
> > Maybe "sw io page table" ?
> 
> Or simply emulated?  At least looking at i915 there is very little
> direct connection to the actual hardware, and while I don't understand
> them fully the s390 driver look similar.  And the samples are completely
> faked up anyway.

Emulated IO page table works for me!

Jason
