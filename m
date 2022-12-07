Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079DE645DB6
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLGPdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLGPdi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:33:38 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9238163B8B
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:33:36 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id g10so10217382qkl.6
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjikf8BONkNBHq/mdSHMPb1S0WDsfH+RsTxDU14w2U8=;
        b=WLyP/sfOhBiMsNF2s65Gxuq7n9uP2ESaakKI/3HI1+vYUOiel9xaoXz4rrPACjE1t6
         BcAHNJCIpzJ3DcERjul4uyDvWESyrxasi3bBWJGFp3W+fkHrf9Jvg3wGOJa8qBdBJbJJ
         r+a2klUQv/qyzv7o81LiM0UrHNEE9sgzO2I00mp1FAqrnsn7/8TsfzUYJP+u3SP3Viab
         XmkrnQPBMqktuVRXx1NySaLMv9T14aEYK0Pbr6gyMRycrQEN+aT528SEbc/byp3iOQh+
         jGD3RhcmDgwvBvuaUIpDQq/WhR4jfDsEHX27fFvpg5PNbyPfHtWh4Iksxi/ZxJUi38g5
         RaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wjikf8BONkNBHq/mdSHMPb1S0WDsfH+RsTxDU14w2U8=;
        b=L95t2oCjCCD19830GSozT+cqLbX8d837QRUIUYJOyuHSP844e4W18AdcAbDExf7xu0
         FtN9UUYt9sMQXDdj7Mx+72HbfrVU0Y6Q6iHJ7znrWL88mUUaNVUIdJBgvRaWK/v0/cxL
         GO3xD/b76L4TgoQ2Vhntk9pqb4uM7Xol7AAOiJEwRNeyQSsalKc9CqdIKDIY8BSrQv5H
         4c9LnI+yxXCta3JaeDFSRcErcZUeTTHahq4Ls2OPvObgJij0ra3PRig0jSjTuEpAEErF
         uXAumi3WK/4Y/K6Z3mQij3kMWZOOVShVYygkuB62pZZgA5cQI6Zl6JpZsKwtUYpSay/5
         RkRg==
X-Gm-Message-State: ANoB5pkBzqLmjcMTMu8DRk1Nvj5GtokGCFFkkdsgOsEPBspgqWV07RDa
        sIOPIzpNF28tE79DQDmhqPWS8Q==
X-Google-Smtp-Source: AA0mqf6H3CUbZahGNznYB0JQYDxDw79bxzgM/h4A32ynuBG2ju5kK/9OhXvFJpvphgAQq9r/tBJFwA==
X-Received: by 2002:ae9:e919:0:b0:6fe:c7a2:b2d0 with SMTP id x25-20020ae9e919000000b006fec7a2b2d0mr8631309qkf.317.1670427215720;
        Wed, 07 Dec 2022 07:33:35 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id o21-20020a05620a2a1500b006eeb3165554sm17830112qkp.19.2022.12.07.07.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:33:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2w0t-005E3g-AJ;
        Wed, 07 Dec 2022 11:07:11 -0400
Date:   Wed, 7 Dec 2022 11:07:11 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y5CsH5PqMYAWYatw@ziepe.ca>
References: <Y49HKHP9NrId39iH@ziepe.ca>
 <20221206135810.GA27689@lst.de>
 <Y49eObpI7QoSnugu@ziepe.ca>
 <20221206153811.GB2266@lst.de>
 <Y49k++D3i8DfLOLL@ziepe.ca>
 <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca>
 <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca>
 <20221207135203.GA22803@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207135203.GA22803@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 02:52:03PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 09:34:14AM -0400, Jason Gunthorpe wrote:
> > The VFIO design assumes that the "vfio migration driver" will talk to
> > both functions under the hood, and I don't see a fundamental problem
> > with this beyond it being awkward with the driver core.
> 
> And while that is a fine concept per see, the current incarnation of
> that is fundamentally broken is it centered around the controlled
> VM.  Which really can't work.

I don't see why you keep saying this. It is centered around the struct
vfio_device object in the kernel, which is definately NOT the VM.

The struct vfio_device is the handle for the hypervisor to control
the physical assigned device - and it is the hypervisor that controls
the migration.

We do not need the hypervisor userspace to have a handle to the hidden
controlling function. It provides no additional functionality,
security or insight to what qemu needs to do. Keeping that
relationship abstracted inside the kernel is a reasonable choice and
is not "fundamentally broken".

> > Even the basic assumption that there would be a controlling/controlled
> > relationship is not universally true. The mdev type drivers, and 
> > SIOV-like devices are unlikely to have that. Once you can use PASID
> > the reasons to split things at the HW level go away, and a VF could
> > certainly self-migrate.
> 
> Even then you need a controlling and a controlled entity.  The
> controlling entity even in SIOV remains a PCIe function.  The
> controlled entity might just be a bunch of hardware resoures and
> a PASID.  Making it important again that all migration is driven
> by the controlling entity.

If they are the same driver implementing vfio_device you may be able
to claim they conceptually exist, but it is pretty artificial to draw
this kind of distinction inside a single driver.

> Also the whole concept that only VFIO can do live migration is
> a little bogus.  With checkpoint and restart it absolutely
> does make sense to live migrate a container, and with that
> the hardware interface (e.g. nvme controller) assigned to it.

I agree people may want to do this, but it is very unclear how SRIOV
live migration can help do this.

SRIOV live migration is all about not disturbing the kernel driver,
assuming it is the same kernel driver on both sides. If you have two
different kernel's there is nothing worth migrating. There isn't even
an assurance the dma API will have IOMMU mapped the same objects to
the same IOVAs. eg so you have re-establish your admin queue, IO
queues, etc after migration anyhow.

Let alone how to solve the security problems of allow userspace to
load arbitary FW blobs into a device with potentially insecure DMA
access..

At that point it isn't really the same kind of migration.

Jason
