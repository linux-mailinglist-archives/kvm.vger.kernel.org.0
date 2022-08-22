Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1517F59C678
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 20:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiHVSfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 14:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiHVSfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 14:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B718E24
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661193337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oul0rlXeVckRoIaE/5tvHqkKjZyojO8sXzYxt2BvGKM=;
        b=b9C0csP8rMPCa3qi0HRnjhIQoss8DoAh2CYcMA+izhdyBI0DV4B5G8OG3+7yDrbKdLn2Sb
        CsjR7c+Yr1CK3c3+3Zoxeo7pmArN5vN5iEh5tviyoSnjDnk4IejX39/+c5yRJRBnx59URS
        PrawIJ6ddoQX/Zl+TLtlGLUbkcKWvbw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-TREX2xY9NjK2VOJHUKjDQQ-1; Mon, 22 Aug 2022 14:35:36 -0400
X-MC-Unique: TREX2xY9NjK2VOJHUKjDQQ-1
Received: by mail-il1-f199.google.com with SMTP id x7-20020a056e021ca700b002ea01be6018so142567ill.18
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 11:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=oul0rlXeVckRoIaE/5tvHqkKjZyojO8sXzYxt2BvGKM=;
        b=BBkxrJX+QAhw7rCV4Xh8v+kZ66ik54xq634VAzGfPevYvkGG+sln09a2YRHJpkQIGq
         /ISrAxQv/FdANnhW+zU9EVX/FbAWrX8Wu8cSfOACVR6DMiYJrRKV6gt0FQWE3LPVCHIY
         YuOoRcLvdoQ1HlQ4AsuyExYuh6QLXr2kT6jISBjnH8AgoOpQdh3jzZ8mBj3NH+4nKzc7
         EezpApDVMpZP3XwAaAutNJreCT+6rMWDIs0Y/wKdb8xjVafpxh0NEcvhk+g9KQEmHD1L
         ZvELX4wgvZd55jRALA6OCcYYfOp5wSf6ibKYig+h7C3HEpg4IiaEY8kLGMMg5b5exOuQ
         c+NQ==
X-Gm-Message-State: ACgBeo15cgtCbu2tcsp23iIFVc54fYu170zd2hcNmtYYZGsqBTMP3f0t
        eNIWamN6sfioJhfVgPhKFMPS2Bq6EpWa6cygcTz22VAQJ9YEdiUoK0hF8D06XzpZJoH6hMo6sWn
        le3Yt95160CIS
X-Received: by 2002:a05:6638:2652:b0:343:d46:58e7 with SMTP id n18-20020a056638265200b003430d4658e7mr10135518jat.134.1661193335642;
        Mon, 22 Aug 2022 11:35:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4wT/BfQls06SdjOiihytLqHWnxuXH+bpmjtY0h2K0Tb4O0L6xOZdO7CH2xdFyp+emMwBRShg==
X-Received: by 2002:a05:6638:2652:b0:343:d46:58e7 with SMTP id n18-20020a056638265200b003430d4658e7mr10135510jat.134.1661193335441;
        Mon, 22 Aug 2022 11:35:35 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c1-20020a92bd01000000b002e93dc753c0sm4158539ile.66.2022.08.22.11.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 11:35:35 -0700 (PDT)
Date:   Mon, 22 Aug 2022 12:35:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Remove vfio_group dev_counter
Message-ID: <20220822123532.49dd0e0e.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
        <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Mon, 22 Aug 2022 04:39:45 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 17, 2022 3:13 AM
> > 
> > + *
> > + * A driver may only call this function if the vfio_device was created
> > + * by vfio_register_emulated_iommu_dev().
> >   */
> >  int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
> >  		   int npage, int prot, struct page **pages)  
> 
> Though I agree with the code change, I'm still unclear about this
> comment.
> 
> First this comment is not equivalent to the old code which only
> checks dev_counter (implying a physical device in a singleton
> group can use this API too). though I didn't get why the singleton
> restriction was imposed in the first place...

It's related to the dirty page scope.  Use of the pinned page interface
is essentially a contract with the IOMMU back-end that only pinned pages
will be considered for the dirty page scope.  However, type1 operates
on groups, therefore we needed to create a restriction that only
singleton groups could make use of page pinning such that the dirty
page scope could be attached to the group.

> Second I also didn't get why such a pinning API is tied to emulated
> iommu now. Though not required for any physical device today, what
> would be the actual problem of allowing a variant driver to make 
> such call? 

In fact I do recall such discussions.  An IOMMU backed mdev (defunct)
or vfio-pci variant driver could gratuitously pin pages in order to
limit the dirty page scope.  We don't have anything in-tree that relies
on this.  It also seems we're heading more in the direction of device
level DMA dirty tracking as Yishai proposes in the series for mlx5.
These interfaces are far more efficient for this use case, but perhaps
you have another use case in mind where we couldn't use the dma_rw
interface?

I think the assumption is that devices that can perform DMA through an
IOMMU generally wouldn't need to twiddle guest DMA targets on a regular
basis otherwise, therefore limiting this to emulated IOMMU devices is
reasonable.  Thanks,

Alex

