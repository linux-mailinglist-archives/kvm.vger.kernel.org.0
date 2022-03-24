Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A624E6A7B
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 23:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353273AbiCXWFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 18:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232361AbiCXWFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 18:05:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09A6C369ED
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 15:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648159447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2AFpyFlXBgco+VqYSZsqBuFpsgC1f/3TZbRqwznPwM=;
        b=bynabz7MXFJu3rtQGbFkrTASNCRU2TkQbeYQ0PmHXv8h5g07WvN07PDK9BfazTFQ6Qste8
        XY2mEQGRwFL34Hk0vafKOePnDXNddtl6l6+O8lN9aZt2vxZBe6roxm31lDECduwqNTARs9
        Ono3vbAVyXgIb8aN9GWOfi+Sbwu5gro=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-5_YGOmlgNHCt1hRrO1IyZw-1; Thu, 24 Mar 2022 18:04:06 -0400
X-MC-Unique: 5_YGOmlgNHCt1hRrO1IyZw-1
Received: by mail-il1-f200.google.com with SMTP id m16-20020a928710000000b002c7be7653d1so3564623ild.4
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 15:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=G2AFpyFlXBgco+VqYSZsqBuFpsgC1f/3TZbRqwznPwM=;
        b=qw0Ptk9NEMUgSkGbmRutu2stNZXTqQxhQXwrJrkTJaIQsBZfOURw5WUqbUhBE1N+Yl
         d2l5kGor/faohUeqNO/pbdT4XhNVEMOSKMqtzHAaHIoeR4uImJ2dNPc/cgFJ4IJK0NCB
         KhG1kaRGG58zRVmnzT64a1khK4EoULt/lT4R3vpk9d8IuOKP8chDAuuJvj+P2en25qHu
         fSY9ghMX4mo/vKIRkS/bOD5qiKCfiuNgnCSQhbnrcIcJ8okFjcV48kb2/lW4l8lp/MJ4
         R5Dx31qKi7NRZNWlXFQbAIoCTNrVSaCaki1Qd6G9FxFkgA6P9SioSss1fL6YiXnDcSv9
         1aQw==
X-Gm-Message-State: AOAM53043RwJAnTCjLpIKrUfT3ueX88s95FZwvpnVVJYD8dkvNCRVU00
        dSYb6Ma9rg8efvxfZVDz03n3vr5x9zx1dfYSBkaSmQJYWoObmP2iAxRQUCo7xx1oF5ExgZt2uF8
        FZwsEDcvIBNto
X-Received: by 2002:a05:6638:13cf:b0:319:e4eb:ac0 with SMTP id i15-20020a05663813cf00b00319e4eb0ac0mr4067434jaj.209.1648159445309;
        Thu, 24 Mar 2022 15:04:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgAdRk7l9Q4iHYdb0ppw6ZPRlja3+sEz7RMEsJ5GJTRVbl6/Ug4jB6W8gdKTPr3N+yE6FyfA==
X-Received: by 2002:a05:6638:13cf:b0:319:e4eb:ac0 with SMTP id i15-20020a05663813cf00b00319e4eb0ac0mr4067413jaj.209.1648159445007;
        Thu, 24 Mar 2022 15:04:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m5-20020a927105000000b002c60ed6d3afsm2068970ilc.69.2022.03.24.15.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 15:04:04 -0700 (PDT)
Date:   Thu, 24 Mar 2022 16:04:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl
 compatibility
Message-ID: <20220324160403.42131028.alex.williamson@redhat.com>
In-Reply-To: <20220324003342.GV11336@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
        <20220323165125.5efd5976.alex.williamson@redhat.com>
        <20220324003342.GV11336@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Mar 2022 21:33:42 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 23, 2022 at 04:51:25PM -0600, Alex Williamson wrote:
> 
> > My overall question here would be whether we can actually achieve a
> > compatibility interface that has sufficient feature transparency that we
> > can dump vfio code in favor of this interface, or will there be enough
> > niche use cases that we need to keep type1 and vfio containers around
> > through a deprecation process?  
> 
> Other than SPAPR, I think we can.

Does this mean #ifdef CONFIG_PPC in vfio core to retain infrastructure
for POWER support?

> > The locked memory differences for one seem like something that
> > libvirt wouldn't want hidden  
> 
> I'm first interested to have an understanding how this change becomes
> a real problem in practice that requires libvirt to do something
> different for vfio or iommufd. We can discuss in the other thread
> 
> If this is the make or break point then I think we can deal with it
> either by going back to what vfio does now or perhaps some other
> friendly compat approach..
> 
> > and we have questions regarding support for vaddr hijacking  
> 
> I'm not sure what vaddr hijacking is? Do you mean
> VFIO_DMA_MAP_FLAG_VADDR ? There is a comment that outlines my plan to
> implement it in a functionally compatible way without the deadlock
> problem. I estimate this as a small project.
> 
> > and different ideas how to implement dirty page tracking,   
> 
> I don't think this is compatibility. No kernel today triggers qemu to
> use this feature as no kernel supports live migration. No existing
> qemu will trigger this feature with new kernels that support live
> migration v2. Therefore we can adjust qemu's dirty tracking at the
> same time we enable migration v2 in qemu.

I guess I was assuming that enabling v2 migration in QEMU was dependent
on the existing type1 dirty tracking because it's the only means we
have to tell QEMU that all memory is perpetually dirty when we have a
DMA device.  Is that not correct?  If we don't intend to carry type1
dirty tracking into iommufd compatibility and we need it for this
purpose, then our window for being able to rip it out entirely closes
when QEMU gains v2 migration support.

> With Joao's work we are close to having a solid RFC to come with
> something that can be fully implemented.
> 
> Hopefully we can agree to this soon enough that qemu can come with a
> full package of migration v2 support including the dirty tracking
> solution.
> 
> > not to mention the missing features that are currently well used,
> > like p2p mappings, coherency tracking, mdev, etc.  
> 
> I consider these all mandatory things, they won't be left out.
> 
> The reason they are not in the RFC is mostly because supporting them
> requires work outside just this iommufd area, and I'd like this series
> to remain self-contained.
> 
> I've already got a draft to add DMABUF support to VFIO PCI which
> nicely solves the follow_pfn security problem, we want to do this for
> another reason already. I'm waiting for some testing feedback before
> posting it. Need some help from Daniel make the DMABUF revoke semantic
> him and I have been talking about. In the worst case can copy the
> follow_pfn approach.
> 
> Intel no-snoop is simple enough, just needs some Intel cleanup parts.
> 
> mdev will come along with the final VFIO integration, all the really
> hard parts are done already. The VFIO integration is a medium sized
> task overall.
> 
> So, I'm not ready to give up yet :)

Ok, that's a more promising outlook than I was inferring from the long
list of missing features.

> > Where do we focus attention?  Is symlinking device files our proposal
> > to userspace and is that something achievable, or do we want to use
> > this compatibility interface as a means to test the interface and
> > allow userspace to make use of it for transition, if their use cases
> > allow it, perhaps eventually performing the symlink after deprecation
> > and eventual removal of the vfio container and type1 code?  Thanks,  
> 
> symlinking device files is definitely just a suggested way to expedite
> testing.
> 
> Things like qemu that are learning to use iommufd-only features should
> learn to directly open iommufd instead of vfio container to activate
> those features.

Which is kind of the basis for my question, QEMU is racing for native
support, Eric and Yi are already working on this, so some of these
compatibility interfaces might only have short term usefulness.

> Looking long down the road I don't think we want to have type 1 and
> iommufd code forever.

Agreed.

> So, I would like to make an option to compile
> out vfio container support entirely and have that option arrange for
> iommufd to provide the container device node itself.
> 
> I think we can get there pretty quickly, or at least I haven't got
> anything that is scaring me alot (beyond SPAPR of course)
> 
> For the dpdk/etcs of the world I think we are already there.

That's essentially what I'm trying to reconcile, we're racing both
to round out the compatibility interface to fully support QEMU, while
also updating QEMU to use iommufd directly so it won't need that full
support.  It's a confusing message.  Thanks,

Alex

