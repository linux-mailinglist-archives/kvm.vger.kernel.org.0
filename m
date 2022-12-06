Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11449644C55
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 20:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLFTPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 14:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLFTPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 14:15:46 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B3340935
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 11:15:44 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id c15so14518681qtw.8
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 11:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GG73iLTCO/uw4M1Ylg2jcMVxqfgJjKpsiaTSmU2EXGA=;
        b=JIXO4eFgOaT8ujjjyeXvuO8qQ+yypxhZOimo6XQPj9ykjHnpz42lA0hxwRS2CqALlP
         InZ5KniMwf4gL2CkysIfWTSK/zRhcKpgYW1h7jk80RV72fs+TIGlADEs1qMbux4LzQXs
         kgFo0jiGF80V8ESdg6/Y8ivo2WWI0dTsZ+SjdqyptOk2b/5s3bOyMy2Cjfh133fw5t7P
         inVYux5ZW6ridMLq77+CizaOGY5xhsgGqo/Q+axhpiXkSy3h5saQm0aOlMTavw/1Z53L
         RwcTU+ikujUo3UDBcOg37Tvhuh6FiRok4lYQDG1ACo4Agcpan+pZrTeBeKsNDB9ShmHe
         G8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GG73iLTCO/uw4M1Ylg2jcMVxqfgJjKpsiaTSmU2EXGA=;
        b=OEmD4gJTu6Jjm4rsjJJFoBpt8UCnD+47nSLY+RaTx5y73GEPyHULHg9UXldic7/tkh
         1zD+VkZdkYNBW35uhYx8b2XdjwledWXGWVLl1nwavOaOIiHKOLG5stiBUuNW3gdP4C6y
         la+DBmzvQqpq4L1c3JxmUdqND+nHFqvRM3acst2l4Egm7Yxxly5vy09hOJPsaLjT3d3E
         DpjK/tsOYboio7ObJhOm4EjWQPYgf5gErmLJYC/2A1Py85aJ6f8f5ROPiA2r++tcPzo7
         ZfPDK5bwG3ZuQ47KwK9yHi+UqGhNcM+o/HpTIte4Y7zBzOc3nRy6hi2eHCur7miMEUIc
         ITKw==
X-Gm-Message-State: ANoB5pmuBVnBdYu3e5SJXlgmuojzVj/n9sMDTokcx3Pqz4xDU0sgWfHi
        RacxtYBpNqPzyZfVhmsx/Ylhqw==
X-Google-Smtp-Source: AA0mqf6eCv+InVfKA4sHLrootqXhgKbPCqZwr/BHpgt/6iwDstlRrCS04XbrZWyIdohBA+R6Gq2t/Q==
X-Received: by 2002:ac8:5892:0:b0:3a5:3d08:9fdd with SMTP id t18-20020ac85892000000b003a53d089fddmr82236079qta.684.1670354143281;
        Tue, 06 Dec 2022 11:15:43 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id y14-20020a37f60e000000b006fbaf9c1b70sm14752500qkj.133.2022.12.06.11.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 11:15:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2dPp-004gjs-T7;
        Tue, 06 Dec 2022 15:15:41 -0400
Date:   Tue, 6 Dec 2022 15:15:41 -0400
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
Message-ID: <Y4+U3VR2LeEh2S7B@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com>
 <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca>
 <20221206135810.GA27689@lst.de>
 <Y49eObpI7QoSnugu@ziepe.ca>
 <20221206153811.GB2266@lst.de>
 <Y49k++D3i8DfLOLL@ziepe.ca>
 <20221206165503.GA8677@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206165503.GA8677@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 05:55:03PM +0100, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 11:51:23AM -0400, Jason Gunthorpe wrote:
> > That is a big deviation from where VFIO is right now, the controlled
> > function is the one with the VFIO driver, it should be the one that
> > drives the migration uAPI components.
> 
> Well, that is one way to see it, but I think the more natural
> way to deal with it is to drive everyting from the controlling
> function, because that is by definition much more in control.

Sure, the controlling function should (and does in mlx5) drive
everything here.

What the kernel is doing is providing the abstraction to link the
controlling function to the VFIO device in a general way.

We don't want to just punt this problem to user space and say 'good
luck finding the right cdev for migration control'. If the kernel
struggles to link them then userspace will not fare better on its own.

Especially, we do not want every VFIO device to have its own crazy way
for userspace to link the controlling/controlled functions
together. This is something the kernel has to abstract away.

So, IMHO, we must assume the kernel is aware of the relationship,
whatever algorithm it uses to become aware.

It just means the issue is doing the necessary cross-subsystem
locking.

That combined with the fact they really are two halfs of the same
thing - operations on the controlling function have to be sequenced
with operations on the VFIO device - makes me prefer the single uAPI.

> More importantly any sane design will have easy ways to list and
> manipulate all the controlled functions from the controlling
> functions, while getting from the controlled function to the
> controlling one is extremely awkward, as anything that can be
> used for that is by definition and information leak.  

We have spend some time looking at this for mlx5. It is a hard
problem. The VFIO driver cannot operate the device, eg it cannot do
MMIO and things, so it is limited to items in the PCI config space to
figure out the device identity.

> It seems mlx5 just gets away with that by saying controlled
> functions are always VFs, and the controlling function is a PF, but
> that will break down very easily, 

Yes, that is part of the current mlx5 model. It is not inherent to the
device design, but the problems with arbitary nesting were hard enough
they were not tackled at this point.

Jason
