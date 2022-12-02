Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80AB64115B
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 00:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiLBXN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 18:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbiLBXN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 18:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146C5F7A0F
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 15:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670022750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2/CllKU0U4UJwmVyb3sb1SBnPQ6vUB5Z0Z6WOmVpQeo=;
        b=Yuzssan3LBXiMmr6ufk+RczuEfZqfZcC8uc2tWajdBuZDVj3XZfl6+0qFv+dnwIoXg7UVf
        kigz4SZ5lf60bLvZeSt10MeIqpFlW4G9OpXFt082CpfpU6Hljee4f54W+mWzUcoYKmONuR
        2i4+7yIE0nPfDTVL7huSTRo1MoywuT4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-8Pac2dWzN8Oz3kZJkgibrQ-1; Fri, 02 Dec 2022 18:12:29 -0500
X-MC-Unique: 8Pac2dWzN8Oz3kZJkgibrQ-1
Received: by mail-il1-f198.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso6863254ilj.17
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 15:12:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2/CllKU0U4UJwmVyb3sb1SBnPQ6vUB5Z0Z6WOmVpQeo=;
        b=bNJ8mqwj9WPgtt0NIgf2VyNxMUItJa9BmdpYhBtXeNeO7uLv2/tqWSYGhJ70NU57Pq
         ZfW5Me79e104maKfQXAhYA5aQEWojOs/z7OSBGjkYI+PonAIQ4qG01U+tCeG+5Z60NdA
         W/LceGRbL9uRG5NNgKHYYbwZlgNN89448G6wrp6rmfbbW9X0iyoAVsyjSiwlmSzgUCCI
         wZ+ymuUJJcdEEe7AzwAhGfZ0YRWK+LqcA4lkpdDDzvtq9L6DEs3Q3OYQCIoKD4uKk4mk
         pjLb4Xhn41ZOzFLCC6UFW68JMwuRrWCn6epmduXNcPaV3Dx2yunn0EpuSaAQ64PbHPeL
         hveA==
X-Gm-Message-State: ANoB5pk5HopexjYX0otnJcrC6XIDxtONB/IAqEGtakGnbNE/XsDCeMbX
        gxPydX/Or071xTURnji4iBKd2Qa5hhp9ahw/6c73KD8sqUKS42oEmUw5x2JTJIBdRltwG6MsUqe
        7nmIh0k/60s7v
X-Received: by 2002:a5d:9f1a:0:b0:6df:f1ea:70f9 with SMTP id q26-20020a5d9f1a000000b006dff1ea70f9mr1477878iot.3.1670022748282;
        Fri, 02 Dec 2022 15:12:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6NOYnHuJfn4TD40sOo/ZiU6gdEH9eGAmwEgkmBv72fXBxDqMnMPy93GgA7m/lfBrANbhpAYg==
X-Received: by 2002:a5d:9f1a:0:b0:6df:f1ea:70f9 with SMTP id q26-20020a5d9f1a000000b006dff1ea70f9mr1477869iot.3.1670022748006;
        Fri, 02 Dec 2022 15:12:28 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ch11-20020a0566383e8b00b00375783003fcsm3064717jab.136.2022.12.02.15.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 15:12:27 -0800 (PST)
Date:   Fri, 2 Dec 2022 16:12:25 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, yi.y.sun@linux.intel.com
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com
Subject: Re: [PATCH 00/10] Move group specific code into group.c
Message-ID: <20221202161225.3144305f.alex.williamson@redhat.com>
In-Reply-To: <Y4oPTjCTlQ/ozjoZ@nvidia.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
        <Y4kRC0SRD9kpKFWS@nvidia.com>
        <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
        <Y4oPTjCTlQ/ozjoZ@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Fri, 2 Dec 2022 10:44:30 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Dec 02, 2022 at 09:57:45PM +0800, Yi Liu wrote:
> > On 2022/12/2 04:39, Jason Gunthorpe wrote:  
> > > On Thu, Dec 01, 2022 at 06:55:25AM -0800, Yi Liu wrote:  
> > > > With the introduction of iommufd[1], VFIO is towarding to provide device
> > > > centric uAPI after adapting to iommufd. With this trend, existing VFIO
> > > > group infrastructure is optional once VFIO converted to device centric.
> > > > 
> > > > This series moves the group specific code out of vfio_main.c, prepares
> > > > for compiling group infrastructure out after adding vfio device cdev[2]
> > > > 
> > > > Complete code in below branch:
> > > > 
> > > > https://github.com/yiliu1765/iommufd/commits/vfio_group_split_v1
> > > > 
> > > > This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
> > > > dma_unmap callback tolerant to unmaps come before device open"[4]
> > > > 
> > > > [1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
> > > > [2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
> > > > [3] https://lore.kernel.org/kvm/0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/
> > > > [4] https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/  
> > > 
> > > This looks good to me, and it applies OK to my branch here:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/
> > > 
> > > Alex, if you ack this in the next few days I can include it in the
> > > iommufd PR, otherwise it can go into the vfio tree in January
> > > 
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > >   
> > 
> > thanks. btw. I've updated my github to incorporate Kevin's nit and also
> > r-b from you and Kevin.  
> 
> Please rebase it on the above branch also

It looks fine to me aside from the previous review comments and my own
spelling nit.  I also don't see that this adds any additional conflicts
vs the existing iommufd integration for any outstanding vfio patches on
the list, therefore, where there's not already a sign-off from me:

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

Thanks,
Alex

