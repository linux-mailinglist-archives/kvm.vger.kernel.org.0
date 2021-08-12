Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777F53EA819
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbhHLP4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:56:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238477AbhHLP4q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 11:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628783780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jP9rC4W5Rt3ibI4PmBrTL9EEbYfxjT7lG4AyqlHLOZw=;
        b=OfzxomGvoR7lvFfc0daKdr36AOan73IIoheCgMe2r/mQPKapZGrKcXVcW8yEqjRw4Z8Bbv
        LFpLusI0faVtHBC2JiPCLEhzNGTvurtVkEd7LzK6L2PDWg/KRhn3wPaRT4muzCsumCjRU5
        fCDbZv904ZFlZmDsDyn/3AfWjoSV6yk=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-rJPUPUJBOtqtXisi5qwhAA-1; Thu, 12 Aug 2021 11:56:17 -0400
X-MC-Unique: rJPUPUJBOtqtXisi5qwhAA-1
Received: by mail-oo1-f69.google.com with SMTP id b24-20020a4ac2980000b0290269ebe9b797so2277183ooq.18
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 08:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jP9rC4W5Rt3ibI4PmBrTL9EEbYfxjT7lG4AyqlHLOZw=;
        b=elWuKMAOa8vvBdpmDxq8m+vkp7AT0u8k6SwXi6kRvxFpWc1HrDw4MnyhfVeZwm1dOm
         JajnRhYFN//VS7AB8WmKKHoSHhyCwhO0t9L2X74+nZFxRFkUBraDOC1pR9+DWV/3aIJB
         p5jBgK8rr9b1WFJp/4NLSTjxdWU3deMjNIBkPAuhG3Qjdf98A0Yu9oNW4EfkPKNQ3IoS
         orbUh2jLTvph01riQNCINvPS0b1EnR73zf+Aqr/Ynichnltmh+weukna5+cDo94TsarK
         yRhSKA1IGH1i6IQLt+ncVhxI6Vp/OAfV5/J3Fqo+2F08lM1wwPXdLju9Z1f5/9I9PeGL
         j4iw==
X-Gm-Message-State: AOAM532iCjzsgmRucSY4ucmQG6Q06+a3AdXGuLiZ9V12sA0+AFWL2bDu
        IVfmf8PchuGGEJdPZKQu1hR5nCJS2rZ73r4azf31xu8s6dRTvCAwr2xh7wEfJD/0iNg39GrRR/r
        OUA3gA46ak2FB
X-Received: by 2002:a05:6830:3145:: with SMTP id c5mr3935364ots.245.1628783776429;
        Thu, 12 Aug 2021 08:56:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznlclP0Zx5nBNeeFvXZ3mWhBBV2KVFXd0kDScEy4VoJCRJyLLF3KeFSh05bRPBExRmJinXkg==
X-Received: by 2002:a05:6830:3145:: with SMTP id c5mr3935350ots.245.1628783776155;
        Thu, 12 Aug 2021 08:56:16 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id u14sm611344oot.36.2021.08.12.08.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:56:15 -0700 (PDT)
Date:   Thu, 12 Aug 2021 09:56:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210812095614.3299d7ab.alex.williamson@redhat.com>
In-Reply-To: <20210812072617.GA28507@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
        <20210811151500.2744-6-hch@lst.de>
        <20210811160341.573a5b82.alex.williamson@redhat.com>
        <20210812072617.GA28507@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Aug 2021 09:26:17 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Aug 11, 2021 at 04:03:41PM -0600, Alex Williamson wrote:
> > > +			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
> > > +			return vfio_noiommu_group_alloc(dev);  
> > 
> > Nit, we taint regardless of the success of this function, should we
> > move the tainting back into the function (using the flags to skip for
> > mdev in subsequent patches) or swap the order to check the return value
> > before tainting?  Thanks,  
> 
> Does it really matter to have the extra thread if a memory allocation
> failed when going down this route?

Extra thread?  In practice this is unlikely to ever fail, but if we've
chosen the point at which we have a no-iommu group as where we taint,
then let's at least be consistent and not move that back to the point
where we tried to make a no-iommu group, regardless of whether it was
successful.  Thanks,

Alex

