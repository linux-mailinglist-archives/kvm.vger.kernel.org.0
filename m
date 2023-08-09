Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DC477667E
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 19:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjHIRdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 13:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjHIRdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 13:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2500AB0
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 10:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691602384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=heW4BkVBw+NkcR2iHSr2+2OT03Hw46yqkzZxV9HJVr8=;
        b=FL2uLYOMRohZxanh528Er0MfTmAJId6j+FSUSO8bWwkP1IOS3pY5q8jJibrBzuWx9AaB+s
        KfAb64YNhONwOWcykniOyBNwvKR3TwYImUdPnARxSQFOvOMgkq1V3O/vY5uITOKrX7ry2k
        4lFIOHuKtFq/JBIRxb4rP5XPywEqE3M=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-tldL2YLbPCWStYq9LoItuQ-1; Wed, 09 Aug 2023 13:33:02 -0400
X-MC-Unique: tldL2YLbPCWStYq9LoItuQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3497e1c8e6eso377165ab.1
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 10:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691602382; x=1692207182;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=heW4BkVBw+NkcR2iHSr2+2OT03Hw46yqkzZxV9HJVr8=;
        b=hSM1K9KymQVy2j+aIN3saH+P514qti7tn6GYMQFcLAfmR1t9iCXQ8PQaeEVT1KjWMm
         66csGtef8xXUoM/hbLxge5QjW2dqFLlTLJWUXzCcgUaeGmzTyZKtBCrhWViqw91kKI7Y
         OcCCa16yKFQ63BvFt/ifCufsRHo1xduNEBypz4hV70AbpflsOIkenpsB/+NEJO7tPk1x
         iQjra4qNwfQEW8To2etJ8dNfxqKcDR7iqknRBZX7irKq5A0/afDIwTAfFhJYW9Dzcqiq
         cUmhD4wZBIJKmnMm58jbx+L+eLKxPAeixKR2xyF2j2FQVuJKmocH7zlFifXs/9aExLKL
         oDXg==
X-Gm-Message-State: AOJu0YwnDM8Qu0FbO0ly36mjjZ4mYSxV0gT2X6kvmq7pGYL8V93+qm75
        OsVMniuVUMdFFYldaPPhVMposPFsGuKVlHpCXoxN73nMx/3JFy9tk96Wo64lSYOkIrQs3yzPGfl
        lUltBfTVB/wkz
X-Received: by 2002:a05:6e02:dca:b0:347:5ce2:b996 with SMTP id l10-20020a056e020dca00b003475ce2b996mr3133262ilj.20.1691602382109;
        Wed, 09 Aug 2023 10:33:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKr/F5lwg/hPh9aoCpzlYVKe07RuvXQoLaRd3H7m8V5ROQxMGUkYfwrnukTQ1QOKZemHsWnA==
X-Received: by 2002:a05:6e02:dca:b0:347:5ce2:b996 with SMTP id l10-20020a056e020dca00b003475ce2b996mr3133253ilj.20.1691602381876;
        Wed, 09 Aug 2023 10:33:01 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id s13-20020a02ad0d000000b0042b52dc77e3sm4001703jan.158.2023.08.09.10.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:33:01 -0700 (PDT)
Date:   Wed, 9 Aug 2023 11:33:00 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        horms@kernel.org, shannon.nelson@amd.com
Subject: Re: [PATCH v14 vfio 6/8] vfio/pds: Add support for dirty page
 tracking
Message-ID: <20230809113300.2c4b0888.alex.williamson@redhat.com>
In-Reply-To: <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
        <20230807205755.29579-7-brett.creeley@amd.com>
        <20230808162718.2151e175.alex.williamson@redhat.com>
        <01a8ee12-7a95-7245-3a00-2745aa846fca@amd.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Aug 2023 08:44:44 -0700
Brett Creeley <bcreeley@amd.com> wrote:

> On 8/8/2023 3:27 PM, Alex Williamson wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Mon, 7 Aug 2023 13:57:53 -0700
> > Brett Creeley <brett.creeley@amd.com> wrote:
> > ...  
> >> +static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
> >> +                              struct rb_root_cached *ranges, u32 nnodes,
> >> +                              u64 *page_size)
> >> +{
> >> +     struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
> >> +     struct device *pdsc_dev = &pci_physfn(pdev)->dev;
> >> +     struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
> >> +     u64 region_start, region_size, region_page_size;
> >> +     struct pds_lm_dirty_region_info *region_info;
> >> +     struct interval_tree_node *node = NULL;
> >> +     u8 max_regions = 0, num_regions;
> >> +     dma_addr_t regions_dma = 0;
> >> +     u32 num_ranges = nnodes;
> >> +     u32 page_count;
> >> +     u16 len;
> >> +     int err;
> >> +
> >> +     dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n",
> >> +             pds_vfio->vf_id);
> >> +
> >> +     if (pds_vfio_dirty_is_enabled(pds_vfio))
> >> +             return -EINVAL;
> >> +
> >> +     /* find if dirty tracking is disabled, i.e. num_regions == 0 */
> >> +     err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions,
> >> +                                     &num_regions);
> >> +     if (err < 0) {
> >> +             dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
> >> +                     ERR_PTR(err));
> >> +             return err;
> >> +     } else if (num_regions) {
> >> +             dev_err(&pdev->dev,
> >> +                     "Dirty tracking already enabled for %d regions\n",
> >> +                     num_regions);
> >> +             return -EEXIST;
> >> +     } else if (!max_regions) {
> >> +             dev_err(&pdev->dev,
> >> +                     "Device doesn't support dirty tracking, max_regions %d\n",
> >> +                     max_regions);
> >> +             return -EOPNOTSUPP;
> >> +     }
> >> +
> >> +     /*
> >> +      * Only support 1 region for now. If there are any large gaps in the
> >> +      * VM's address regions, then this would be a waste of memory as we are
> >> +      * generating 2 bitmaps (ack/seq) from the min address to the max
> >> +      * address of the VM's address regions. In the future, if we support
> >> +      * more than one region in the device/driver we can split the bitmaps
> >> +      * on the largest address region gaps. We can do this split up to the
> >> +      * max_regions times returned from the dirty_status command.
> >> +      */  
> > 
> > Isn't this a pretty unfortunately limitation given QEMU makes a 1TB
> > hole on AMD hosts?  Or maybe I misunderstand.
> > 
> > https://gitlab.com/qemu-project/qemu/-/commit/8504f129450b909c88e199ca44facd35d38ba4de
> > 
> > Thanks,
> > Alex
> >   
> 
> Yes, this is currently an unfortunate limitation. However, our device is 
> flexible enough to support >1 regions. There has been some work in this 
> area, but we aren't quite there yet. The goal was to get this initial 
> support accepted and submit follow on work to support >1 regions.

Ok, good that this is temporary.

Shameer, Kevin, Jason, Yishai, I'm hoping one or more of you can
approve this series as well.  Thanks,

Alex

