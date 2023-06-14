Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEC773080D
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbjFNTVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjFNTVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:21:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E8E2135
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686770454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fd3UDbr2Nlwpbzx+9+5vMnQCL/akEJaw/zMcUhpGS2E=;
        b=ZibbrmySBPKt41oh/S8uGR95Bop1+qo0YoDlN0/4BzeISsEQULpZymxz1Fm5+++lJdpRaV
        qOBvO45Zd3JKwis0LO86feRDleIiMNAzp1KzCopdetr87+RG5jNfq4/aKU+wuyBYUAc4/P
        Lpdoygk8bRNFz2Q9QyVx9Q48VWdnzgU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-jkuokanlOE-ELKdSQ8-cPg-1; Wed, 14 Jun 2023 15:20:53 -0400
X-MC-Unique: jkuokanlOE-ELKdSQ8-cPg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-77b25d256aaso259169239f.0
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686770452; x=1689362452;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fd3UDbr2Nlwpbzx+9+5vMnQCL/akEJaw/zMcUhpGS2E=;
        b=M/R9+xH2hm37QO9WrnIbwp1Ig++1hnEdHUqTjKUEabohrFFqsFlt9L4uE1UFJwYmoB
         yJU3hrx3YkKzrgrkXWgBUNNHQFBPFaBCa9J0PAc4XNuC2SOsC1QqkPP61GhvQas5UabX
         JrRyskvd5fm2pnyY8fZ65M0KRgXr81VIh/TyfYuUv8BKG+FDepaDlRsV7Wh3PuVxoLAy
         39esqmkd1yyNcrt/A55bp03rxRdWDu7MmlIXd72AZBAFBs23uT/jRIpVdnhZ6+viPO6i
         nDYLDashQtP040uG6wjo/4/zPQ9WDQnRr/2SEvAfxvf4wt5tL50+DOWujJ98UbgDuG9B
         Brzw==
X-Gm-Message-State: AC+VfDxBLEfxe/30Wl8OMikOE7dODky4qzMWf8uImkQs7ZTYhWgmKBC+
        C7YS+/SeNTeXlYwrXSNYgrcItWisPgpJd2jjm7xn22V0yOGC3elecnFsIY/TguzXMFhntkDZiLi
        GJVUjv8eeIVSj
X-Received: by 2002:a92:d34f:0:b0:340:998a:e966 with SMTP id a15-20020a92d34f000000b00340998ae966mr2855917ilh.17.1686770452309;
        Wed, 14 Jun 2023 12:20:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7BCoBzWr9RbpjyjV9Oy4DCDN0kg/DMXuykivi8VeCJxcD74DjrW2/UMBvab8Dw/LnY2mi/jw==
X-Received: by 2002:a92:d34f:0:b0:340:998a:e966 with SMTP id a15-20020a92d34f000000b00340998ae966mr2855893ilh.17.1686770451956;
        Wed, 14 Jun 2023 12:20:51 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k8-20020a02c768000000b00416650ba62esm5153404jao.76.2023.06.14.12.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 12:20:50 -0700 (PDT)
Date:   Wed, 14 Jun 2023 13:20:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230614132047.519abe95.alex.williamson@redhat.com>
In-Reply-To: <ZIn/EHnCg444LJ3i@nvidia.com>
References: <ZH9RfXhbuED2IUgJ@nvidia.com>
        <20230606110510.0f87952c.alex.williamson@redhat.com>
        <ZH9p+giEs6bCYfw8@nvidia.com>
        <20230606121348.670229ff.alex.williamson@redhat.com>
        <ZH+DdVIyZ6hHCDaK@nvidia.com>
        <20230606153057.4cbc36a0.alex.williamson@redhat.com>
        <ZH/LzyF/uttviRnQ@nvidia.com>
        <20230607122303.5d25c973.alex.williamson@redhat.com>
        <ZIh+wXFrls7StWzc@nvidia.com>
        <20230613132402.2765b6cb.alex.williamson@redhat.com>
        <ZIn/EHnCg444LJ3i@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Jun 2023 14:55:28 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 13, 2023 at 01:24:02PM -0600, Alex Williamson wrote:
> 
> > I'd even forgotten about the sparse mmap solution here, that's even
> > better than trying to do something clever with the mmap.  
> 
> Okay, Ankit please try this, it sounds good
> 
> > > You may be right, I think this patch is trying to make things
> > > automatic for user, but a dedicated machine type might make more
> > > sense.  
> > 
> > Juan and I discussed this with Ankit last week, there are a lot of down
> > sides with another machine type, but the automatic manipulation of the
> > machine is still problematic.  Another option we have is to use QEMU
> > command line options for each feature.  For example we already support
> > NUMA VM configurations and loading command line ACPI tables, hopefully
> > also associating devices to nodes.  Do we end up with just a
> > configuration spec for the VM to satisfy the in-guest drivers?
> > Potentially guest driver requirements may changes over time, so a hard
> > coded recipe built-in to QEMU might not be the best solution anyway.  
> 
> Let's have those discussions settle then, I know there are a few
> different ideas here people are looking at.
> 
> > I think NVIDIA might have an interest in enabling Atomic Ops support in
> > VMs as well, so please comment in the series thread if there are
> > concerns here or if anyone can definitively says that another guest OS
> > we might care about does cache root port capability bits.  Thanks,  
> 
> I expect we do - I haven't heard of atomic ops specifically yet
> though.
> 
> We just did a big exercise on relaxed ordering which is similarly
> troubled.
> 
> Here we deciced to just not use the VM's config space at all. The
> device itself knows if it can do relaxed ordering and it just reports
> this directly to the driver.
> 
> In many ways I would prefer to do the same for atomic.. I haven't
> checked fully but I think we do this anyhow as you can see mlx5 simply
> tries to enable PCI atomics but doesn't appear to do anything with the
> result of it. I expect the actual success/fail is looped back through
> the device interface itself.
> 
> So, for mlx5, it probably already works in most real cases. Passing a
> PF might not work I guess.
> 
> It is not a satisfying answer from a VMM design perspective..
> 
> Some qemu command line to say what root ports with what atomic caps to
> create seems like a reasonable thing to do.

The referenced QEMU proposal puts a number of restrictions on
automatically flipping bits on the root port, ex. as exposed in the VM
the endpoint must be directly connected to a root port (avoiding
complications around atomic ops routing support) and must be a
single function device at devfn 0x0 (avoiding heterogeneous paths on
the host).  It also tests the root port bits to make sure they aren't
otherwise set in order to be compatible with some future root port
device switch to enable fixed atomic completer support.

This tries to balance the idea that we want to support device switches
for these sort of fine grained VM configuration, but there are also
isolated cases which can be automatically enabled that can potentially
cover the vast majority of use cases.

OTOH, trying to do something automatic for 'AtomicOps Routing Support'
looks far more challenging and we probably would rely on command line
device switches for that.

Regarding relaxed ordering, are we talking about the 'No RO-enabled
PR-PR Passing' bit in the devcap2 register?  Unfortunately that bit is
labeled HwInit, so we don't have the same leniency towards modifying it
at runtime as we do for the immediately preceding AtomicOps completer
support bits.  In my interpretation, that bit also only seems to be
reporting whether a specific reordering is implemented, so more
important in determining expected performance than functionality(?)

In general, I think we put driver writers in an awkward place if they
start trying things that are clearly not supported as reported by
hardware capability bits.  Error handling can be pretty fragile,
especially when value-add firmware thinks it knows best.  Thanks,

Alex

