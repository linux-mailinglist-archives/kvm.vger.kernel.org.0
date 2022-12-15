Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD5764E117
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 19:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLOSj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 13:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLOSj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 13:39:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E028D632A
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671129473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KiyR3q2QilSoSniSeTl48sVRXl2+c/GeOT9JcKfPnwg=;
        b=WNzGb7ogK2qtO+H9G/t0ttMiDWk26CHJCipT4LaeWBf3w7JfOhjsAhlP03hRkGBoRnkgzL
        IJpMdseQkTaQKJVcWncoCA42abVJKEaBbKFeCof81f6f/6kapZPjd7nsbhIEWbHzQHrBxM
        nnN2yK7BnydWCfMgOA4grl6CgZJp/AM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-e6yHrjzvNQe4ViDkW8zsAg-1; Thu, 15 Dec 2022 13:37:46 -0500
X-MC-Unique: e6yHrjzvNQe4ViDkW8zsAg-1
Received: by mail-il1-f199.google.com with SMTP id l16-20020a056e02067000b0030325bbd570so162506ilt.0
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 10:37:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KiyR3q2QilSoSniSeTl48sVRXl2+c/GeOT9JcKfPnwg=;
        b=ViMYiBTqplmrqHYFb1UH3qZAdoucdsUzf2nPN7/crGGGWnLW/hgGZ6Dp1oqzobKbjL
         /MD32udf9gNV8EjhdZUFe8D52LKjNEXeDbzPlyilSB/VZsS+hnQ7WpE30ayW5h1NoEhv
         BlyfHIr9hrjjeqkclxSX0zLDXZ8wEgqhwPPwM2cCXytMGgYqtlEkBKP/zY2POIKQfTS/
         CvVSCzn6ggvvXQ3KObWgWXb18XzeSNC84gZ0IUlQr4AUYmuhNJG0Gx5vMExJIQzIP4W5
         az9uCF8ZOmmx0CpQ3X6lEHVrSKWj0d3zNTfJIQ4Btk0lCDUfooF/7ZIwBHiXoxMjMGeG
         NGrQ==
X-Gm-Message-State: ANoB5pmB3qan5KtFonq1PgwgGQ2auGzyvrq8AUG+OapyTSCswxMIeMJZ
        iRg9rD6mi9tGXQ38gSQmI87Chgw04Kq3fb3S4JbymtM6nkQ/O/8VLB7KmpmAgo2DvuXonBOTnc8
        YOgyIJ9ESjHom
X-Received: by 2002:a05:6e02:141:b0:304:cf5c:736b with SMTP id j1-20020a056e02014100b00304cf5c736bmr11949662ilr.15.1671129464968;
        Thu, 15 Dec 2022 10:37:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf71IeLmuqTjWdzG15RK5JvAff5/GpEJKnMcGMpw977gxTIjWQWsfU9o7kP3eoVgf8Y468wYyg==
X-Received: by 2002:a05:6e02:141:b0:304:cf5c:736b with SMTP id j1-20020a056e02014100b00304cf5c736bmr11949641ilr.15.1671129464700;
        Thu, 15 Dec 2022 10:37:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e5-20020a026d45000000b003758390c97esm27797jaf.83.2022.12.15.10.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 10:37:43 -0800 (PST)
Date:   Thu, 15 Dec 2022 11:37:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Steve Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V4 0/5] fixes for virtual address update
Message-ID: <20221215113742.726ba06f.alex.williamson@redhat.com>
In-Reply-To: <Y5suR/nBlxnfJY0n@nvidia.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
        <20221214144229.43c8348d.alex.williamson@redhat.com>
        <Y5suR/nBlxnfJY0n@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Dec 2022 10:25:11 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Dec 14, 2022 at 02:42:29PM -0700, Alex Williamson wrote:
> > On Wed, 14 Dec 2022 13:24:52 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:
> >   
> > > Fix bugs in the interfaces that allow the underlying memory object of an
> > > iova range to be mapped in a new address space.  They allow userland to
> > > indefinitely block vfio mediated device kernel threads, and do not
> > > propagate the locked_vm count to a new mm.
> > > 
> > > The fixes impose restrictions that eliminate waiting conditions, so
> > > revert the dead code:
> > >   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
> > >   commit 487ace134053 ("vfio/type1: implement notify callback")
> > >   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> > > 
> > > Changes in V2 (thanks Alex):
> > >   * do not allow group attach while vaddrs are invalid
> > >   * add patches to delete dead code
> > >   * add WARN_ON for never-should-happen conditions
> > >   * check for changed mm in unmap.
> > >   * check for vfio_lock_acct failure in remap
> > > 
> > > Changes in V3 (ditto!):
> > >   * return errno at WARN_ON sites, and make it unique
> > >   * correctly check for dma task mm change
> > >   * change dma owner to current when vaddr is updated
> > >   * add Fixes to commit messages
> > >   * refactored new code in vfio_dma_do_map
> > > 
> > > Changes in V4:
> > >   * misc cosmetic changes
> > > 
> > > Steve Sistare (5):
> > >   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
> > >   vfio/type1: prevent locked_vm underflow
> > >   vfio/type1: revert "block on invalid vaddr"
> > >   vfio/type1: revert "implement notify callback"
> > >   vfio: revert "iommu driver notify callback"
> > > 
> > >  drivers/vfio/container.c        |   5 -
> > >  drivers/vfio/vfio.h             |   7 --
> > >  drivers/vfio/vfio_iommu_type1.c | 199 +++++++++++++++++++---------------------
> > >  include/uapi/linux/vfio.h       |  15 +--
> > >  4 files changed, 103 insertions(+), 123 deletions(-)
> > >   
> > 
> > Looks ok to me.  Jason, Kevin, I'd appreciate your reviews regarding
> > whether this sufficiently addresses the outstanding issues to keep this
> > interface around until we have a re-implementation in iommufd.  Thanks,  
> 
> Well, patch 3 undeniably solves the deadlock problem.
> 
> I still don't like that we are keeping this, an interface that doesn't
> support mdevs has no future and can't really be used in any general
> purpose way.
> 
> Can we at least protect it with a kconfig && CONFIG_EXPERIMENTAL so it
> is disabled in most builds?

We no longer have that tool, CONFIG_EXPERIMENTAL hasn't existed for
almost a decade.

I don't think anyone would argue this as a perfect solution, but at the
same time we're putting Steve in a position where we want to remove the
vulnerabilities, we're divesting development in type1 with the
introduction of iommufd, and there's clearly some utility remaining in
the interface, even without mdev support.

It's not that different from migration in fact.  In order to migrate a
VM with vfio devices, all those devices need to support migration.  In
order to live update a VM, all the device need to support live update,
where we have an implementation of generic support here for non-mdev
devices.

It looks like we need some more refinement of the patches, but I think
there's enough here to show there's an interim, restricted use case
solution short of reverting the feature entirely.  Thanks,

Alex

