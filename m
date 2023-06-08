Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1787289B9
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 22:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbjFHU5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 16:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjFHU5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 16:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921C7E61
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 13:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686257796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PJ8juZ8Q2bIBQLeKki4qKbKgEzmr7QQFLcUkAqFdNw=;
        b=BAas7k9qYbuKVWEIc1HVjimMbooxzQMZGcl0PV0MBmUcI71Mhr+Qy2Q5G5O5wgBP6O/Dsf
        q2u1vweIaYnFQizneIDl6s+cvvdfaA4dL/UUYp44wU0zenQskZZbhJqu9yShFtUBHFflCD
        7mjowXX6hZvBepsuF3jW0Ccw78pUGKM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-4wegk0ynPj-01koG41z5fQ-1; Thu, 08 Jun 2023 16:56:35 -0400
X-MC-Unique: 4wegk0ynPj-01koG41z5fQ-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77accdaa0e0so90233339f.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 13:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686257794; x=1688849794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9PJ8juZ8Q2bIBQLeKki4qKbKgEzmr7QQFLcUkAqFdNw=;
        b=Vf9VDo6mjDLC+K4hfDJ6wcgpyo8w7UYSNVk2xSKkWaBy16prBX845AVa7/dVAMMj8R
         g10vmJb5SPhOMd/WrW1Qh9SfZwh8WLgVTUaBzYR1gc+2mM5S3Fg2ZcguPkEaZK4x2JNV
         7tcPDpw5mwy9LWuh/QKBLg3ZA2O2cb9wbvr8pzpSLTLV1jeIhY1AlNVRCKf5BG8p7vBp
         Y+ZqTKCTTiWoUkXpzkVhm0SFN1iGc7xbXXzpHsxS9ET2DYxUDb3w5lHzFyoLT1kL5DSp
         WUgueoscs9aM9FAHqGCNwDH3FVCZ/Y6fjYK6UL0Qv1Xoyn2qg273s19hv5oHd/kgcHFQ
         G1ng==
X-Gm-Message-State: AC+VfDwMgoKAIPVBl3D380T/1HJLxf/mCsTsxT1nL1bnvaq5yQiMsDUp
        TDw8z3SI2lsqkFwYp26Z+O7+nOJ4Tv887tc6+SOv9iseTVLJkW+ePMVu302xjPLyjgvdbPJDELI
        3F60d7/CVfq4lpatpngRg
X-Received: by 2002:a5e:c119:0:b0:774:84b5:cb77 with SMTP id v25-20020a5ec119000000b0077484b5cb77mr9289133iol.18.1686257794566;
        Thu, 08 Jun 2023 13:56:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6yHRVXjAqAJolQVpnfr2/GQx0sufa8nbZ0eSOaJTxwUDlR7eYX4gxYCo5VzmpdSZirAgmwPA==
X-Received: by 2002:a5e:c119:0:b0:774:84b5:cb77 with SMTP id v25-20020a5ec119000000b0077484b5cb77mr9289129iol.18.1686257794339;
        Thu, 08 Jun 2023 13:56:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z20-20020a029f14000000b00408b3bc8061sm500297jal.43.2023.06.08.13.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:56:33 -0700 (PDT)
Date:   Thu, 8 Jun 2023 14:56:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        khalid.aziz@oracle.com
Subject: Re: [PATCH] vfio/iommu_type1: acquire iommu lock in
 vfio_iommu_type1_release()
Message-ID: <20230608145632.41073b65.alex.williamson@redhat.com>
In-Reply-To: <8bf63ad2-43fd-41cd-c3dc-0507701eb5c1@oracle.com>
References: <20230607190752.216801-1-sidhartha.kumar@oracle.com>
        <20230607134037.6d81e288.alex.williamson@redhat.com>
        <8bf63ad2-43fd-41cd-c3dc-0507701eb5c1@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Jun 2023 13:16:12 -0700
Sidhartha Kumar <sidhartha.kumar@oracle.com> wrote:

> On 6/7/23 12:40 PM, Alex Williamson wrote:
> > On Wed,  7 Jun 2023 12:07:52 -0700
> > Sidhartha Kumar <sidhartha.kumar@oracle.com> wrote:
> >   
> >>  From vfio_iommu_type1_release() there is a code path:
> >>
> >> vfio_iommu_unmap_unpin_all()
> >>   vfio_remove_dma()
> >>      vfio_unmap_unpin()
> >>        unmap_unpin_slow()
> >>          vfio_unpin_pages_remote()
> >>            vfio_find_vpfn()
> >>
> >> This path is taken without acquiring the iommu lock so it could lead to
> >> a race condition in the traversal of the pfn_list rb tree.  
> > 
> > What's the competing thread for the race, vfio_remove_dma() tests:
> > 
> > 	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
> > 
> > The fix is not unreasonable, but is this a theoretical fix upstream
> > that's tickled by some downstream additions, or are we actually
> > competing against page pinning by an mdev driver after the container is
> > released?  Thanks,
> >   
> 
> Hello,
> 
> In a stress test of starting and stopping multiple VMs for a few days we 
> observed a memory leak that occurs after a few days. These guests have 
> their memory pinned via the pin_user_pages_remote() call in 
> vaddr_get_pfns(). From examining the vfio/iommu_type1 code this 
> potential race condition was noticed, but we have not root caused this 
> race to be the cause of the memory leak.

Ok, I think we're going to need to wait for that root cause.  It's
trivial to hold the lock here, but we're imminently freeing the object
hosting that lock, so we have bigger problems than threads stepping on
each other in the pfn_list if this lock were to actually resolve
anything.  It's not an oversight that we don't hold the lock here,
there should be no outstanding references to the iommu object at this
point.  Thanks,

Alex
 
> >> The lack of
> >> the iommu lock in vfio_iommu_type1_release() was confirmed by adding a
> >>
> >> WARN_ON(!mutex_is_locked(&iommu->lock))
> >>
> >> which was reported in dmesg. Fix this potential race by adding a iommu
> >> lock and release in vfio_iommu_type1_release().
> >>
> >> Suggested-by: Khalid Aziz <khalid.aziz@oracle.com>
> >> Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> >> ---
> >>   drivers/vfio/vfio_iommu_type1.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 306e6f1d1c70e..7d2fea1b483dc 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -2601,7 +2601,9 @@ static void vfio_iommu_type1_release(void *iommu_data)
> >>   		kfree(group);
> >>   	}
> >>   
> >> +	mutex_lock(&iommu->lock);
> >>   	vfio_iommu_unmap_unpin_all(iommu);
> >> +	mutex_unlock(&iommu->lock);
> >>   
> >>   	list_for_each_entry_safe(domain, domain_tmp,
> >>   				 &iommu->domain_list, next) {  
> >   
> 

