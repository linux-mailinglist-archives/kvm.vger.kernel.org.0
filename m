Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB30F64BD4F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbiLMTa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 14:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbiLMTaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 14:30:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0312494C
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670959762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nR6iWCL8YUtOhSGCd+nwCL6JXD86i6fQ2bs7FrtErA=;
        b=eGxMbYpU9vJlWKTYUo2K2jqI6eniiQwlQPUpZO2jLHm2LjZJJwAhybTB/oSGiagzNFsF8J
        j/tzqhIev7haLhpoVo9ZonjCL9u1OIzWccWY86ryuolAvvjl5YtsSdlLmd2RQ886Jd1JK0
        g/x1hRFWrw3s6Eb9t7Dg8xwXhPR44rQ=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-201-G5pT_EP8MqGG0SJHB5WvYg-1; Tue, 13 Dec 2022 14:29:21 -0500
X-MC-Unique: G5pT_EP8MqGG0SJHB5WvYg-1
Received: by mail-il1-f199.google.com with SMTP id i21-20020a056e021d1500b003041b04e3ebso8035534ila.7
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 11:29:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nR6iWCL8YUtOhSGCd+nwCL6JXD86i6fQ2bs7FrtErA=;
        b=2o0vSRLHOA45lsDGjAB+aKUO7t8sXUieaHUlyUB0SyAD0PwAz8dplHN+NDvgRBaoKV
         k6durpU30MFo5dSY7JD1VTY1Ax2WqZDe6D2CBa5CBWoQajdpSOkHxLimDp2gFmVROiM1
         0lnZlPw6jITDEjUaK4Ybs7tOMt3fd7KVL0G4fosDZPxbr85bl5BeIqfCbg/qvu09g68j
         IlSm0Ahs1NWELX40Z9qklfACxEgibBgRB8/E1sD5pse/79qwEg4yQSKBj2d0FqyLaKJq
         MVttFZULgabTnK16SUmqYsW/15veIatuNW+HQ1oOJukmwi4W/sGhuFk/0KLygsLIZbPf
         on+Q==
X-Gm-Message-State: ANoB5pn744D9AZsU3OAKxzWIV0PjDvyK0HhtAXYqvbByfFzcDgz3A5qu
        VKvsX7wIPvkH96HzvtRo7OgiNl9QuF7sX+YCw99Z6HXV4CRFalDFlleEfVSIZjrCcUHFfvcSvva
        Bh2pQDIntFHzW
X-Received: by 2002:a05:6e02:dd3:b0:303:def:8e5 with SMTP id l19-20020a056e020dd300b003030def08e5mr11942542ilj.2.1670959760911;
        Tue, 13 Dec 2022 11:29:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6NEd90XsH5kPNlIKuGsIcDkniTaWzxainzPJMHk+na5ALToQZ63/KnSmWQSlzMrvpoSQeg4g==
X-Received: by 2002:a05:6e02:dd3:b0:303:def:8e5 with SMTP id l19-20020a056e020dd300b003030def08e5mr11942536ilj.2.1670959760602;
        Tue, 13 Dec 2022 11:29:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r16-20020a02aa10000000b00389b6c71347sm1124300jam.60.2022.12.13.11.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 11:29:19 -0800 (PST)
Date:   Tue, 13 Dec 2022 12:29:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 2/2] vfio/type1: prevent locked_vm underflow
Message-ID: <20221213122918.024f43c5.alex.williamson@redhat.com>
In-Reply-To: <43ad3256-e485-b358-6445-35645d943b7b@oracle.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
        <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
        <20221213110252.7bcebb97.alex.williamson@redhat.com>
        <69e68902-eed9-748a-887a-549c717ebe01@oracle.com>
        <43ad3256-e485-b358-6445-35645d943b7b@oracle.com>
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

On Tue, 13 Dec 2022 13:21:15 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/13/2022 1:17 PM, Steven Sistare wrote:
> > On 12/13/2022 1:02 PM, Alex Williamson wrote:  
> >> On Tue, 13 Dec 2022 07:46:56 -0800
> >> Steve Sistare <steven.sistare@oracle.com> wrote:
> >>  
> >>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
> >>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
> >>> dma mapping, locked_vm underflows to a large unsigned value, and a
> >>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
> >>>
> >>> To fix, when VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed,
> >>> add the mapping's pinned page count to the new mm->locked_vm, subject to
> >>> the rlimit.  Now that mediated devices are excluded when using
> >>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of the
> >>> mapping.
> >>>
> >>> Underflow will not occur when all dma mappings are invalidated before exec.
> >>> An attempt to unmap before updating the vaddr with VFIO_DMA_MAP_FLAG_VADDR
> >>> will fail with EINVAL because the mapping is in the vaddr_invalid state.  
> >>
> >> Where is this enforced?  
> > 
> > In vfio_dma_do_unmap:
> >         if (invalidate_vaddr) {
> >                 if (dma->vaddr_invalid) {
> >                         ...
> >                         ret = -EINVAL;  
> 
> My bad, this is a different case, and my comment in the commit message is
> incorrect.  I should test mm != dma->mm during unmap as well, and suppress
> the locked_vm deduction there.

I'm getting confused how this patch actually does anything.  We grab
the mm of the task doing mappings, and we swap that grab when updating
the vaddr, but vfio_lock_acct() uses the original dma->task mm for
accounting.  Therefore how can an underflow occur?  It seems we're
simply failing to adjust locked_vm for the new mm at all.

> >>> Underflow may still occur in a buggy application that fails to invalidate
> >>> all before exec.
> >>>
> >>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >>> ---
> >>>  drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
> >>>  1 file changed, 11 insertions(+)
> >>>
> >>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>> index f81e925..e5a02f8 100644
> >>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>> @@ -100,6 +100,7 @@ struct vfio_dma {
> >>>  	struct task_struct	*task;
> >>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >>>  	unsigned long		*bitmap;
> >>> +	struct mm_struct	*mm;
> >>>  };
> >>>  
> >>>  struct vfio_batch {
> >>> @@ -1174,6 +1175,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >>>  	vfio_unmap_unpin(iommu, dma, true);
> >>>  	vfio_unlink_dma(iommu, dma);
> >>>  	put_task_struct(dma->task);
> >>> +	mmdrop(dma->mm);
> >>>  	vfio_dma_bitmap_free(dma);
> >>>  	if (dma->vaddr_invalid) {
> >>>  		iommu->vaddr_invalid_count--;
> >>> @@ -1622,6 +1624,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>>  			dma->vaddr = vaddr;
> >>>  			dma->vaddr_invalid = false;
> >>>  			iommu->vaddr_invalid_count--;
> >>> +			if (current->mm != dma->mm) {
> >>> +				mmdrop(dma->mm);
> >>> +				dma->mm = current->mm;
> >>> +				mmgrab(dma->mm);
> >>> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
> >>> +						     0);  
> >>
> >> What does it actually mean if this fails?  The pages are still pinned.
> >> lock_vm doesn't get updated.  Underflow can still occur.  Thanks,  
> > 
> > If this fails, the user has locked additional memory after exec and before making
> > this call -- more than was locked before exec -- and the rlimit is exceeded.
> > A misbehaving application, which will only hurt itself.
> > 
> > However, I should reorder these, and check ret before changing the other state.

The result would then be that the mapping remains with vaddr_invalid on
error?  Thanks,

Alex

> >>> +			}
> >>>  			wake_up_all(&iommu->vaddr_wait);
> >>>  		}
> >>>  		goto out_unlock;
> >>> @@ -1679,6 +1688,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
> >>>  	get_task_struct(current->group_leader);
> >>>  	dma->task = current->group_leader;
> >>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> >>> +	dma->mm = dma->task->mm;
> >>> +	mmgrab(dma->mm);
> >>>  
> >>>  	dma->pfn_list = RB_ROOT;
> >>>    
> >>  
> 

