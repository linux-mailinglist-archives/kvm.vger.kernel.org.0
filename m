Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8074664BE73
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 22:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbiLMVcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 16:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbiLMVcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 16:32:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5930723BEF
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670967080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wsTRR4388NXy6b8VNu1DFmdq430XTx0DeaOkt6uFSdk=;
        b=F6XY5TaZeoV5Vy1ypgz/h8lu+nsdPNei2f1lxW98B9cy4+Rotg7Ku5WUo6uyNBfZes98qE
        e5qSJ+A7c6ODVInTuqiQT1EkMUvOqo3uYoItinGFtcemugL/RZNDTic9p26SrPgDK85IFe
        /8bSdZaj8Rf2BA05mDITmBU0VYq7Wdw=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-220-blbYU-YBPwGgU3h0mlRMFA-1; Tue, 13 Dec 2022 16:31:19 -0500
X-MC-Unique: blbYU-YBPwGgU3h0mlRMFA-1
Received: by mail-il1-f198.google.com with SMTP id j3-20020a056e02154300b00304bc968ef1so4411962ilu.4
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:31:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsTRR4388NXy6b8VNu1DFmdq430XTx0DeaOkt6uFSdk=;
        b=DAtKm/4cQwoGCXHEbS1Ep+abe4Dw/N9bRuyzNPxV6E2aWMrMSaaklpu+5zzLMnQSj2
         nVTh86aSGK1j82T2kXGVITboV5F1TP50vFd4qC07Aybhwt7NFQGy6HANlFQDDddVhvR9
         J1+RGr7NlUE6Voq8g2AMApUBzxK6czIFSeklg8QMttHF99YGISsOCf9RiKwmv0cBD79Z
         0oo7gmvgAzK3/nN2gUpngUXKgisI7DEThIQ9fb2yEui4A6m8R2PGxry6eLuunmu6Botl
         f9an3J83zuiajDxnFT4ALVRMkVJ9zSUh+roCKWkHycC4ylgoDzwroDuYtItyQxg8w9Tc
         CuUg==
X-Gm-Message-State: ANoB5pl2NSEbkQsGyF94k2Nz2rPhIpNjo1UEN1jDyrsodoSrhgX0eK+w
        0FfKEyiikX80GNYOjrQdMSd8eiFStKq/giZm+v3a3sNzrVeHB094U//hHHxgKGLB5x1TaeusShB
        RBsNdjJ4G+OJ6
X-Received: by 2002:a6b:d10f:0:b0:6cc:a195:ce91 with SMTP id l15-20020a6bd10f000000b006cca195ce91mr11423611iob.7.1670967078098;
        Tue, 13 Dec 2022 13:31:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7RM5NTNhXJ+s54qf/OOu1T/ESMGqQjMIrsIZyc9hlhgfXW8JMdh+dAzdhNJaORox4hmjay7A==
X-Received: by 2002:a6b:d10f:0:b0:6cc:a195:ce91 with SMTP id l15-20020a6bd10f000000b006cca195ce91mr11423605iob.7.1670967077798;
        Tue, 13 Dec 2022 13:31:17 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f90-20020a0284e3000000b0038a5ff28a96sm1157657jai.156.2022.12.13.13.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 13:31:17 -0800 (PST)
Date:   Tue, 13 Dec 2022 14:31:16 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 2/5] vfio/type1: prevent locked_vm underflow
Message-ID: <20221213143116.33aab0b8.alex.williamson@redhat.com>
In-Reply-To: <ae08a80a-bac0-fbd2-2e8d-278c8609efe4@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
        <1670960459-415264-3-git-send-email-steven.sistare@oracle.com>
        <20221213132309.3e6903e8.alex.williamson@redhat.com>
        <ae08a80a-bac0-fbd2-2e8d-278c8609efe4@oracle.com>
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

On Tue, 13 Dec 2022 16:01:21 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/13/2022 3:23 PM, Alex Williamson wrote:
> > On Tue, 13 Dec 2022 11:40:56 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
> >> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
> >> dma mapping, locked_vm underflows to a large unsigned value, and a
> >> subsequent dma map request fails with ENOMEM in __account_locked_vm.
> >>
> >> To avoid underflow, do not decrement locked_vm during unmap if the
> >> dma's mm has changed.  To restore the correct locked_vm count, when
> >> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
> >> the mapping's pinned page count to the new mm->locked_vm, subject
> >> to the rlimit.  Now that mediated devices are excluded when using
> >> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
> >> the mapping.  
> > 
> > Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> > 
> >   
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++----
> >>  1 file changed, 19 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 80bdb4d..35a1a52 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -100,6 +100,7 @@ struct vfio_dma {
> >>  	struct task_struct	*task;
> >>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >>  	unsigned long		*bitmap;
> >> +	struct mm_struct	*mm;
> >>  };
> >>  
> >>  struct vfio_batch {
> >> @@ -1165,7 +1166,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >>  					    &iotlb_gather);
> >>  	}
> >>  
> >> -	if (do_accounting) {
> >> +	if (do_accounting && current->mm == dma->mm) {  
> > 
> > 
> > This seems incompatible with ffed0518d871 ("vfio: remove useless
> > judgement") where we no longer assume that the unmap mm is the same as
> > the mapping mm.  
> 
> They are compatible.  My fix allows another task to unmap, but only decreases
> locked_vm if the current mm matches the original mm that locked it.  And the
> "original" mm is updated by MAP_FLAG_VADDR.

It seems like there's either a bug fix or behavioral change to
ffed0518d871 then.  What mm were we previously accounting in their
fork/exec scenario that we're not with this change?

> > Does this need to get_task_mm(dma->task) and compare that mm to dma->mm
> > to determine whether an exec w/o vaddr remapping has occurred?  That's
> > the only use case I can figure out where grabbing the mm for dma->mm
> > actually makes any sense at all.  
> 
> The mm grab does detect an exec.  Before exec, at map time, we get task and grab
> its mm.  During exec, task gets a new mm.  The old mm becomes defunct, but we
> still hold it and can examine its pointer address.

This is describing exactly the test I'm asking about, if dma->task->mm
no longer matches dma->mm then an exec has occurred w/o a subsequent
vaddr remap.  So why are we bringing current->mm into the equation?
Thanks,

Alex 

> The new code does not require that current == dma->task.
> 
> >>  		vfio_lock_acct(dma, -unlocked, true);
> >>  		return 0;
> >>  	}
> >> @@ -1178,6 +1179,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >>  	vfio_unmap_unpin(iommu, dma, true);
> >>  	vfio_unlink_dma(iommu, dma);
> >>  	put_task_struct(dma->task);
> >> +	mmdrop(dma->mm);
> >>  	vfio_dma_bitmap_free(dma);
> >>  	if (dma->vaddr_invalid) {
> >>  		iommu->vaddr_invalid_count--;
> >> @@ -1623,9 +1625,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>  			   dma->size != size) {
> >>  			ret = -EINVAL;
> >>  		} else {
> >> -			dma->vaddr = vaddr;
> >> -			dma->vaddr_invalid = false;
> >> -			iommu->vaddr_invalid_count--;
> >> +			if (current->mm != dma->mm) {
> >> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
> >> +						     0);
> >> +				if (!ret) {
> >> +					mmdrop(dma->mm);
> >> +					dma->mm = current->mm;
> >> +					mmgrab(dma->mm);
> >> +				}
> >> +			}
> >> +			if (!ret) {
> >> +				dma->vaddr = vaddr;
> >> +				dma->vaddr_invalid = false;
> >> +				iommu->vaddr_invalid_count--;
> >> +			}  
> > 
> > Poor flow, shouldn't this be:
> > 
> > 			if (current->mm != dma->mm) {
> > 				ret = vfio_lock_acct(dma,
> > 						     size >> PAGE_SHIFT, 0);
> > 				if (ret)
> > 					goto out_unlock;
> > 
> > 				mmdrop(dma->mm);
> > 				dma->mm = current->mm;
> > 				mmgrab(dma->mm);
> > 			}
> > 			dma->vaddr = vaddr;
> > 			dma->vaddr_invalid = false;
> > 			iommu->vaddr_invalid_count--;  
> 
> Better, will do, thanks.
> 
> - Steve
> 
> >>  			wake_up_all(&iommu->vaddr_wait);
> >>  		}
> >>  		goto out_unlock;
> >> @@ -1683,6 +1696,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>  	get_task_struct(current->group_leader);
> >>  	dma->task = current->group_leader;
> >>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> >> +	dma->mm = dma->task->mm;
> >> +	mmgrab(dma->mm);
> >>  
> >>  	dma->pfn_list = RB_ROOT;
> >>    
> >   
> 

