Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DBE646049
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLGRbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 12:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiLGRbr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 12:31:47 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71139FF6
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 09:31:46 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id c15so16714359qtw.8
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 09:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GGYm/U8zQZjJljcYBsuBB43oBO+UowQVbQ4PB8XzHy4=;
        b=JVYHn2Uq7dr+ybmwbABL740dori9GKB6509NnTrMEa0HWmWilQWCIsVF0ukAsjG0NJ
         QB//ZxGk2bJyMjHgSdkpktwlHmE19dA8spOKyggVH/cdq3YhnCzM1OQu10Am4JJ/l6b9
         2nSL+gRXQWCEy3K+o7LxOw8fQnrdBysQlRwgT7fXE1KZKfzPNG6gD8G5T0vGKFy/spxj
         FSD0L66l01my1N0CgZoGKZTtdXiH42Kst31L7UDnWFgCpMa2vTSyYkSWzRCMEwZlVv6M
         KWPgTxnjaLbHpwVKG8Sc8MS+9eVKpTy4TSwNughyBUWBb5GB6feee5Zf7HbiedQI/CPq
         GFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GGYm/U8zQZjJljcYBsuBB43oBO+UowQVbQ4PB8XzHy4=;
        b=lX3c3uiL4jotp4oF4xSsd1y/tc6d7Wpx5ICtQHsVGNgz64frrRs42+pJ133UcOWEhF
         MjzecuJFQhIXienv/hbUAxpAXjeyMhu7otii/zA5He5/rkR7IUer2bT5u2s1tgnyCcr2
         SFd4legFqZdAf064+hvfOE+aGXP4gqFpvjWubxJnfPjw6Vh5MmJmybIjkonG3kDRtkXp
         a/F/WTmBTv8qVgp7CIgImzOVrKbw3eq6+8gmnSnAMiPtnOv6SCy63KkdO5cu49oZLaH9
         K+JZjpDGsP++hfTXWcraDVos6oTSezucmVH/wLbEny70Tc8WeoCSumae3WyMjAmuPe1m
         Yb+w==
X-Gm-Message-State: ANoB5pkXVlRoyiMwhFRElF+nkHPYOVAk0vtBSxmXmF2VBeBSxJKoH6gO
        R7q+7Ar2BBpxKlBefufcT6LhYA==
X-Google-Smtp-Source: AA0mqf42zyYSULlUE4U8ptwueXX6sRZDqQITBgKVrqFCvFRJD27eq+kQvOKvmlFR+vkVg2fYBCK3PA==
X-Received: by 2002:a05:622a:17cb:b0:3a6:21fd:6c9a with SMTP id u11-20020a05622a17cb00b003a621fd6c9amr71657357qtk.545.1670434305934;
        Wed, 07 Dec 2022 09:31:45 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id t3-20020a05620a450300b006eea4b5abcesm18442401qkp.89.2022.12.07.09.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 09:31:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2yGm-005IGO-HV;
        Wed, 07 Dec 2022 13:31:44 -0400
Date:   Wed, 7 Dec 2022 13:31:44 -0400
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
Message-ID: <Y5DOAKArjyfb6Mcz@ziepe.ca>
References: <Y49eObpI7QoSnugu@ziepe.ca>
 <20221206153811.GB2266@lst.de>
 <Y49k++D3i8DfLOLL@ziepe.ca>
 <20221206165503.GA8677@lst.de>
 <Y4+U3VR2LeEh2S7B@ziepe.ca>
 <20221207075415.GB2283@lst.de>
 <Y5CWVu08abcOuEQH@ziepe.ca>
 <20221207135203.GA22803@lst.de>
 <Y5CsH5PqMYAWYatw@ziepe.ca>
 <20221207163857.GB2010@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207163857.GB2010@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 05:38:57PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 07, 2022 at 11:07:11AM -0400, Jason Gunthorpe wrote:
> > > And while that is a fine concept per see, the current incarnation of
> > > that is fundamentally broken is it centered around the controlled
> > > VM.  Which really can't work.
> > 
> > I don't see why you keep saying this. It is centered around the struct
> > vfio_device object in the kernel, which is definately NOT the VM.
> 
> Sorry, I meant VF.  Your continued using of SR-IOV teminology now keeps
> confusing my mind so much that I start mistyping things.

Well, what words do you want to use?

Regardless of VF/VM, it doesn't matter - my point is that the
vfio_device is the hypervisor control for *whatever* is under the
vfio_device and it is not desirable to break it up along arbitrary HW
boundaries.

I've given lots of reasons why not to do this now.

I strongly suspect it can work technically - as ugly as it is Pensando
shows an approach.

So I don't think I've learned anything more about your objection.

"fundamentally broken" doesn't help

It is a major point, because if we are going to have to rip apart all
the uAPI we built here and are completing the qemu work for, we need
to come to an understanding very soon.

And given how difficult it has been to get to this point, I want a
*really* good reason why we have to start again, and rewrite all the
drivers that exist and are coming.

Jason
