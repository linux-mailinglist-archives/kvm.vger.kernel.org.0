Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B775A0392
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 00:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbiHXWCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 18:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiHXWCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 18:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C383A75CC3
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661378525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KuQP2Wdk1ChLsQt933Dx50eCztce+E2B3cpbYWabPRQ=;
        b=SR2sc3tDDxw1H7UZ6O3ZdE4RrkZy8KKK7wBz7F3fcDaHa77luC64KlgqSyd/4bZ8BbkHeQ
        vEdRVr9UKWD2Go+t5sXACDzx6smPKOVBU8ShUGJjC0l9+YTXsMAbUsddvUddpnQH8zcIu2
        DnjweDi+/vD3JU0HuuwfWU0po1+yeBM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-625-1wUM5kp8MgGo_ZnmJJYRHg-1; Wed, 24 Aug 2022 18:02:04 -0400
X-MC-Unique: 1wUM5kp8MgGo_ZnmJJYRHg-1
Received: by mail-io1-f69.google.com with SMTP id z30-20020a05660217de00b00688bd42dc1dso10143120iox.15
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 15:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=KuQP2Wdk1ChLsQt933Dx50eCztce+E2B3cpbYWabPRQ=;
        b=7tX5ZsF3HsW8RnB5BSDjGUIpCFo6qQIP7X9lgiqpGV/KybSDHI2OHIT+j5TnAAIba4
         Z+vsqzdPJJ2v8VSQLI2sypJMvZwLnwMD7ZT/+IBAG0dS6Bis/hrwCTOT88jNkQw5ecFN
         wWm+vR/yYzc4ZcE3cYFKFPDaDSJ7q0fqpxQoJBoCeuSZWSk7WgFs5xIdR9+1uNv3DSJY
         ztBThGbywGZUGGDBcQmaO+8pFQ/kk8QlFTpEflcg7PBChWh6qYqEnJ8A3/urUo0JcLzQ
         Yth0SP4f7euXcWg4qsJPNxZyBwp9zaoC+zE629c7EHS5Cat8JtBT0VWy3DXNTYmTQmQG
         znUg==
X-Gm-Message-State: ACgBeo1LYBOj6G5Cs7n5gRZvTpgdVrdOMZvjJjmTHWxh6wEqCU3lRYvM
        KUgM1pmuP+/LxmcOjfAQlg8BpMJrY9kJL4WVCup8VYrSLsuA69NiUKs7KF1kCFlLW/UfsBpBSVe
        22kFkpQELpWSl
X-Received: by 2002:a05:6e02:2163:b0:2ea:367:f1be with SMTP id s3-20020a056e02216300b002ea0367f1bemr423787ilv.213.1661378523902;
        Wed, 24 Aug 2022 15:02:03 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6OcDOv1g3eAR8zX8TubDTh4L3RUBfXNTsHKzBzv76JrasNZgOAoXk+Cohwa2e935sVI3/6sA==
X-Received: by 2002:a05:6e02:2163:b0:2ea:367:f1be with SMTP id s3-20020a056e02216300b002ea0367f1bemr423775ilv.213.1661378523664;
        Wed, 24 Aug 2022 15:02:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bc9-20020a0566383cc900b00349d0b0b67dsm273208jab.120.2022.08.24.15.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 15:02:03 -0700 (PDT)
Date:   Wed, 24 Aug 2022 16:02:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Remove vfio_group dev_counter
Message-ID: <20220824160201.1902d6c4.alex.williamson@redhat.com>
In-Reply-To: <20220824003808.GE4090@nvidia.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
        <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220822123532.49dd0e0e.alex.williamson@redhat.com>
        <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220824003808.GE4090@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Aug 2022 21:38:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:
> So, I would prefer to comment it like this and if someone comes with a
> driver that wants to use it in some other way they have to address
> these problems so it works generally and correctly. I don't want to
> write more code to protect against something that auditing tells us
> doesn't happen today.
> 
> The whole thing should naturally become fixed fairly soon, as once we
> have Yishai and Joao's changes there will be no use for the dirty
> tracking code in type1 that is causing this problem.

I assume this is referring to the DMA logging interface and
implementation for mlx5[1], but I don't see anyone else getting on board
with that proposal (or reviewing).  AIUI, most are waiting for system
IOMMU DMA logging, so the above seems a bit of a bold claim.  Do we
expect system IOMMU logging flowing through this device feature or will
there be an interface at the shared IOMMU context level?  Do we expect
mdev drivers supporting migration to track their dirty iovas locally
and implement this feature? 

And touching on this question that wasn't addressed...

On Tue, 23 Aug 2022 01:31:11 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, August 23, 2022 2:36 AM
> > It's related to the dirty page scope.  Use of the pinned page interface
> > is essentially a contract with the IOMMU back-end that only pinned pages
> > will be considered for the dirty page scope.  However, type1 operates
> > on groups, therefore we needed to create a restriction that only
> > singleton groups could make use of page pinning such that the dirty
> > page scope could be attached to the group.  
> 
> I get the former part but not the latter. Can you elaborate why
> multi-device group can not be attached by the dirty page scope?
> It's kind of sharing the scope by all devices in the group.

There's no fundamental reason we couldn't do it.  At the time it wasn't
necessary and wasn't convenient since type1 operated exclusively on
groups.  Now maybe we'd expand the device_list beyond just devices with
dma_unmap callbacks and link page pinning to the device rather than the
group to get better granularity, but that all seems to be work in the
opposite direction from where we want the IOMMU uAPI to go.  If type1
dirty logging goes away and moves to the drivers, we could scrap the
singleton requirement, but as Jason notes, expanding its use to hack
around regions that can't fault is a bit of an abuse of the intended
use case.  Thanks,

Alex

[1]20220815151109.180403-1-yishaih@nvidia.com

