Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DC6644597
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiLFO1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiLFO1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:27:11 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBE3D7E
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:27:09 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y4so14072635plb.2
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 06:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Mdjw8teEuS8fu1LzdE03VCDBBE/nyDuXFgC+OWm78E=;
        b=JTrqxIKbISVas3nmVgciA/jFgtsvHbGds9y9TE+NeJDiSpP6+RfmKxfgtL0v0hVlhx
         Xt+JIhTdyVpZq/qBAkgyvyud2u6wCPMjw+bwqYEUXXzPteMf6wDSZpfj9PyGoZj8hpJo
         Ri6AC6357268HQeq5Ar2oWAJ8mMTmSqto4tssZvSPA85TofMwONCiCV/2FSVtO/72cCv
         B4gSYLk2107+aX7tn9bgF8waU10Ev4Dh6UupBGr2l5q2PSQNBAxCwG0vfqH7hsXiBnRs
         NZq3Tu7/kQ/vmrMQG0RXz7KdWbYOd3Td/2yrZmGPyhtywi+LAcIvwY+AnNrKY7dnLH/6
         eJpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Mdjw8teEuS8fu1LzdE03VCDBBE/nyDuXFgC+OWm78E=;
        b=8NQfjce1iDpLkawojQCjQEpVXC5aXRihc1ooz+0HvqAIeTmwQnmI9CE08zoivrPibz
         /YmWB5iT7D+MPotqIgdoPnwADPLRyTM9/KHzbAhyiJK1MSX5g2twbSmFB3PthLZRo15L
         9NqM35JjI4zXyM2fpQ9ae7FDcxatGMqMSq5v6vN38mao6fW7To6WI0c3nN1uu9opGkKY
         Ejuzs0Fkj3szKGboxlKxkzPTocvZhwAZYKQQxgVBL57J4iH5cruJFo2KsVX2NJf4ezpq
         ajTYFOKO2n5b04/wNHWytGlw9Ug4NlEGbAJ8kGCGh5sJsuSea0Oi9a3wY/gL+aN88fYY
         elPQ==
X-Gm-Message-State: ANoB5pmQBjPaoN0a9kv1VS3D+1NdoK90lCV3SRXmwewWd6UeJuHauVQz
        usWgoWus7Zrd8YszxBtRLRowOQ==
X-Google-Smtp-Source: AA0mqf4onWTUgiJ4pOlfZR6yKmpmp9+evnjGR22ptDTfxs3rCfyKWJ8/Zxj8Atiyy/h4dPtnxckbDA==
X-Received: by 2002:a17:90b:4d84:b0:212:9b3f:dee5 with SMTP id oj4-20020a17090b4d8400b002129b3fdee5mr99097552pjb.62.1670336829049;
        Tue, 06 Dec 2022 06:27:09 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id n6-20020a170902d2c600b0017c19d7c89bsm12695526plc.269.2022.12.06.06.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 06:27:08 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2YuY-004c5n-RN;
        Tue, 06 Dec 2022 10:27:06 -0400
Date:   Tue, 6 Dec 2022 10:27:06 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Lei Rao <lei.rao@intel.com>,
        axboe@fb.com, kch@nvidia.com, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y49ROloD4qWzjqnz@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com>
 <20221206061940.GA6595@lst.de>
 <Y49HKHP9NrId39iH@ziepe.ca>
 <Y49I5MRsgHdNkIff@kbusch-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y49I5MRsgHdNkIff@kbusch-mbp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:51:32PM +0000, Keith Busch wrote:
> On Tue, Dec 06, 2022 at 09:44:08AM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 06, 2022 at 07:19:40AM +0100, Christoph Hellwig wrote:
> > > On Tue, Dec 06, 2022 at 01:58:12PM +0800, Lei Rao wrote:
> > > > The new function nvme_submit_vf_cmd() helps the host VF driver to issue
> > > > VF admin commands. It's helpful in some cases that the host NVMe driver
> > > > does not control VF's admin queue. For example, in the virtualization
> > > > device pass-through case, the VF controller's admin queue is governed
> > > > by the Guest NVMe driver. Host VF driver relies on PF device's admin
> > > > queue to control VF devices like vendor-specific live migration commands.
> > > 
> > > WTF are you even smoking when you think this would be acceptable?
> > 
> > Not speaking to NVMe - but this driver is clearly copying mlx5's live
> > migration driver, almost completely - including this basic function.
> > 
> > So, to explain why mlx5 works this way..
> > 
> > The VFIO approach is to fully assign an entire VF to the guest OS. The
> > entire VF assignment means every MMIO register *and all the DMA* of
> > the VF is owned by the guest operating system.
> > 
> > mlx5 needs to transfer hundreds of megabytes to gigabytes of in-device
> > state to perform a migration.
> 
> For storage, though, you can't just transfer the controller state. You have to
> transfer all the namespace user data, too. So potentially many terabytes?

There are two different scenarios - lets call it shared medium and
local medium.

If the medium is shared then only the controller state needs to be
transfered. The controller state would include enough information to
locate and identify the shared medium.

This would apply to cases like DPU/smart NIC, multi-port physical
drives, etc.

local medium will require the medium copy. Within Linux I don't have a
clear sense if that should be done within the VFIO migration
framework, or if it would better to have its own operations.

For the NVMe spec I'd strongly suggest keeping medium copy as its own
set of commands.

It will be interesting to see how to standardize all these scenarios :)

Jason
