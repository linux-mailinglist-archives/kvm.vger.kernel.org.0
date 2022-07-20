Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8139557C073
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 01:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiGTXFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 19:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbiGTXFE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 19:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 455584599F
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658358302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zg6tKh24AWnTu20bQJOGXj28spsKAAV7siHCBMGPsbs=;
        b=V30Ve37xYpdvDbBpkI76x2H5epYbpdi0WGlMECTy3Rnjij0x99vZnHQDBhjIOqwYWJvVpm
        Ggyje7saAq/BI162l1RQh1F87XpJ1d1xhytBaDIqTqp4YUm8Rryse+cxHZFgNcSaXnLYPb
        i5nCL5EO8EuqBMiKYipHLcuVnjyBNcY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-ndExvGVwMWO6T1_tiCVeKw-1; Wed, 20 Jul 2022 19:05:00 -0400
X-MC-Unique: ndExvGVwMWO6T1_tiCVeKw-1
Received: by mail-il1-f197.google.com with SMTP id l10-20020a056e021aaa00b002dd08016baeso2672863ilv.13
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zg6tKh24AWnTu20bQJOGXj28spsKAAV7siHCBMGPsbs=;
        b=vgreZGr6+hWtYOzDFmUIrNq9XK6z0Tx73Y0oTidky0lr5xTgUvSq5Rzd2lgjqjg4HC
         9nVcxEnyW0VJ12IhP+RD4kE8LTBG3+lUSmauVRdtXLMiQlCYD1hPMNwtzlIB9TKdjiLl
         XLoBe8SN5c5/VKRRCbYspJ95E2Yl4R1x7Zem1besofnsKbwIqgk9fm4iHBxYyrBPKZxi
         KZIxaI86XclfTl2vWKuB1BLATLArk2cVwIl+5XT5kwaWa5H2g5PUrhPb0jtrcSKhWfNp
         u0zLD+NPnRnrtRv4GPdEun8NIpG4uLZdyre35EdKXM3zcoAgwJOYNSgHnhnSAkdLm4NB
         nH5w==
X-Gm-Message-State: AJIora9BJmUXiRYlOEeZcTDPP/8tnBo2gkgRQCtBCsIKsF5/wJWgL5jB
        bTkEDa4FcZ1PJ51TWCJMKJEQzqwQ/VRtxvsLJ3hBwVzpekrE1BVfVneWJWU8OLCWsuwoFyNe78g
        45P+YpqvIbyOf
X-Received: by 2002:a92:d64d:0:b0:2dc:e337:58ab with SMTP id x13-20020a92d64d000000b002dce33758abmr8883700ilp.85.1658358300017;
        Wed, 20 Jul 2022 16:05:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sQXCea5IlpPt4z3PoQC/VJ/h3ZRlmifntgfmb+p+6Hl0NlKR1GQe1eKRx6WPGYdv4/I+TsDA==
X-Received: by 2002:a92:d64d:0:b0:2dc:e337:58ab with SMTP id x13-20020a92d64d000000b002dce33758abmr8883682ilp.85.1658358299767;
        Wed, 20 Jul 2022 16:04:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n24-20020a056638111800b0034195de93b3sm92309jal.51.2022.07.20.16.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:04:59 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:04:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v4 1/2] vfio: Replace the DMA unmapping notifier with a
 callback
Message-ID: <20220720170457.39cda0d0.alex.williamson@redhat.com>
In-Reply-To: <20220720200829.GW4609@nvidia.com>
References: <0-v4-681e038e30fd+78-vfio_unmap_notif_jgg@nvidia.com>
        <1-v4-681e038e30fd+78-vfio_unmap_notif_jgg@nvidia.com>
        <20220720134113.4225f9d6.alex.williamson@redhat.com>
        <20220720200829.GW4609@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Jul 2022 17:08:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jul 20, 2022 at 01:41:13PM -0600, Alex Williamson wrote:
>  
> > ie. we don't need the gfn, we only need the iova.  
> 
> Right, that makes sense
>  
> > However then I start to wonder why we're passing in 1 for the number of
> > pages because this previously notifier, now callback is called for the
> > entire vfio_dma range when we find any pinned pages.    
> 
> Well, it is doing this because it only ever pins one page.

Of course that page is not necessarily the page it unpins given the
contract misunderstanding below.
 
> The drivers are confused about what the contract is. vfio is calling
> the notifier with the entire IOVA range that is being unmapped and the
> drivers are expecting to receive notifications only for the IOVA they
> have actually pinned.
> 
> > Should ap and ccw implementations of .dma_unmap just be replaced with a
> > BUG_ON(1)?  
> 
> The point of these callbacks is to halt concurrent DMA, and ccw does
> that today.

ccw essentially only checks whether the starting iova of the unmap is
currently mapped.  If not it does nothing, if it is it tries to reset
the device and unpin everything.  Chances are the first iova is not the
one pinned, so we don't end up removing the pinned page and type1 will
eventually BUG_ON after a few tries.

> It looks like AP is missing a call to ap_aqic(), so it is
> probably double wrong.

Thankfully the type1 unpinning path can't be tricked into unpinning
something that wasn't pinned, so chances are the unpin call does
nothing, with a small risk that it unpins another driver's pinned page,
which might not yet have been notified and could still be using the
page.  In the end, if ap did have a page pinned in the range, we'll hit
the same BUG_ON as above.

> What I'd suggest is adding a WARN_ON that the dma->pfn_list is not
> empty and leave these functions alone.

The BUG_ON still exists in type1.

Eric, Matt, Tony, Halil, JasonH, any quick fixes here?  ccw looks like
it would be pretty straightforward to test against a range rather than
a single iova.
 
> Most likely AP should be fixed to call vfio_ap_irq_disable() and to
> check the q->saved_pfn against the IOVA.

Right, the q->saved_iova, perhaps calling vfio_ap_irq_disable() on
finding a matching queue.

> But I'm inclined to leave this as-is for this series given we are at
> rc7.

On the grounds that it's no worse, maybe, but given the changes
around this code hopefully we can submit fixes patches to stable if the
backport isn't obvious and the BUG_ON in type1 is reachable.  Thanks,

Alex

