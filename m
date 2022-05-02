Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA4517657
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 20:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355517AbiEBSOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 14:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238752AbiEBSOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 14:14:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F6C5F2C
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 11:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651515072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OB2hOtFGf786xTKJG2c2V8jCJu7i8Ybw34LncXS8QJg=;
        b=V1Jr5+ywHEWyzHrrAF0PjDJxwsES5jdCNEq9hek4rONpeCmCRoN6eJ4uxTTBi5CDbVrJG4
        PVYRHMAafC6CFmRJxSFdyO+9K00d8gvclYV1w32VRii3PvsA0tO0TD/cNz1Ko8E9vm0J4O
        4x0QWP2VkpjAZsriTVxNyq3Cbd53LvQ=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-mnknv66gMD-Hjw6snNGM8Q-1; Mon, 02 May 2022 14:11:09 -0400
X-MC-Unique: mnknv66gMD-Hjw6snNGM8Q-1
Received: by mail-io1-f70.google.com with SMTP id o6-20020a0566022e0600b0065a5780f48bso2777831iow.10
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 11:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OB2hOtFGf786xTKJG2c2V8jCJu7i8Ybw34LncXS8QJg=;
        b=hCU95+0C5dfXpcsNdL7P7AObUX+gA5XAS2u7wEbu8Y5b8xd8mCzc6e5pE2xvHY7sOd
         aLz3sYr4A/wiLgbKX2EqW66koLpWprWJKSG+4qLI1xtYaLVzz1bCZ/uUAFYO/kcF4UNL
         3GUJvc7riqd3WxR0WwriZ6Db6DZIekurfJYwcp7QUhUo9c+LcGgZreSeL47Et6P8Fxpi
         UoVMIPsFeQ/L4d3pYS1a334AJ+wkdJSGwIiEb4zpIzdHAY3uavXcNWzI0y1aqtr19B3y
         Bk66dNzU81G0oQd1fsl/8hA2usNZynxfCLCtlJMhqVCqW1ItHsfZlz1HS+XSfal7GkNg
         0Xaw==
X-Gm-Message-State: AOAM531YzUrkGLZVcJ3VSvKleSye+3BBUUfUUh6K4r9Bm9YJHcfvflbb
        RDBHLTUMRD1bBqAM+AmVYyKU0QrWa624jk0KzzOEqn8EHqekLtXNxYL0xDAkwhI8eM1JwZRKnNI
        a0KcThFCWeg9X
X-Received: by 2002:a05:6e02:1a2d:b0:2cc:4fb5:6007 with SMTP id g13-20020a056e021a2d00b002cc4fb56007mr4788048ile.124.1651515069098;
        Mon, 02 May 2022 11:11:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3mKkLtOXlkpKnETd6PyjwpXqsT5TaGR1bDtZUr1B8qKfwqjSCM2B65ksgE07ihNdH8nI4Fg==
X-Received: by 2002:a05:6e02:1a2d:b0:2cc:4fb5:6007 with SMTP id g13-20020a056e021a2d00b002cc4fb56007mr4788033ile.124.1651515068830;
        Mon, 02 May 2022 11:11:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q13-20020a02a98d000000b0032b3a781741sm3252949jam.5.2022.05.02.11.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:11:08 -0700 (PDT)
Date:   Mon, 2 May 2022 12:11:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Martins, Joao" <joao.m.martins@oracle.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Cornelia Huck" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Message-ID: <20220502121107.653ac0c5.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
        <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Apr 2022 05:45:20 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:
> > From: Joao Martins <joao.m.martins@oracle.com>
> >  3) Unmapping an IOVA range while returning its dirty bit prior to
> > unmap. This case is specific for non-nested vIOMMU case where an
> > erronous guest (or device) DMAing to an address being unmapped at the
> > same time.  
> 
> an erroneous attempt like above cannot anticipate which DMAs can
> succeed in that window thus the end behavior is undefined. For an
> undefined behavior nothing will be broken by losing some bits dirtied
> in the window between reading back dirty bits of the range and
> actually calling unmap. From guest p.o.v. all those are black-box
> hardware logic to serve a virtual iotlb invalidation request which just
> cannot be completed in one cycle.
> 
> Hence in reality probably this is not required except to meet vfio
> compat requirement. Just in concept returning dirty bits at unmap
> is more accurate.
> 
> I'm slightly inclined to abandon it in iommufd uAPI.

Sorry, I'm not following why an unmap with returned dirty bitmap
operation is specific to a vIOMMU case, or in fact indicative of some
sort of erroneous, racy behavior of guest or device.  We need the
flexibility to support memory hot-unplug operations during migration,
but even in the vIOMMU case, isn't it fair for the VMM to ask whether a
device dirtied the range being unmapped?  This was implemented as a
single operation specifically to avoid races where ongoing access may be
available after retrieving a snapshot of the bitmap.  Thanks,

Alex

