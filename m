Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D9364BDEA
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 21:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237286AbiLMU3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 15:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbiLMU2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 15:28:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A8026481
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670962994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MP2f1uG1cBbDi3s+LsvzJEeEXNAQy5gDqredPnyzZFI=;
        b=Rxz07iezDOFv3ddLiKxp6ZaaMOFdsVHxpnj72LEghds0x2zUiOt40OGU7Oco+HK5AQQfbi
        J2lcpR9hiBimS2fS8XP9es6vp8RAEtmBhO+jKaE0ZdbwmcKDWswQD9hrAJiG3gUj3K95aL
        KPH6PKT/iYDFmktHiCjJpjhgWADkrBs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-62-UN-utMvbPfGpnsFIgUVTCQ-1; Tue, 13 Dec 2022 15:23:12 -0500
X-MC-Unique: UN-utMvbPfGpnsFIgUVTCQ-1
Received: by mail-io1-f70.google.com with SMTP id t2-20020a6b6402000000b006dea34ad528so2633750iog.1
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:23:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MP2f1uG1cBbDi3s+LsvzJEeEXNAQy5gDqredPnyzZFI=;
        b=utXmXl0n6QEzfTU89sPLM4tUJs+hjCVVRNmHzWyAPwCtNfWocbfAU5R3ryidO/BG9f
         or72zI1vP4ZjCjX/2cwnFiFo1RvpGMRBrrqLVjOnrIW16WYp8rvzkKCRit3wYEwtsboF
         RMm2YZZglU+0OWaQNsLHxQ24tVgkXQqmCRvLcCoM9wP48mB+OA8i1YxJQZ643mOirOvH
         N5hsIlJZGc/y5jAzeuhL/qoknGHJFkS2CIbDlwXbfJ8sF6C0yVGxVJvh5riJcbMa1jdk
         vkZpS9AnUomPDfR60j8NLp/cTrWwLVwDbjBfblnADfn8X9OiHGGclWPTajbte0M25fA2
         rkbQ==
X-Gm-Message-State: ANoB5pkfgLd9AUsum7OpvPoF3rlPJIz7G02wHdvAlwGjCik9MHCEnlM/
        aUPBelgT1QuZ1lcpeEXHnb6dkcCO8djdm32GeFX68zzNY6rtdbG1yCz7teKc1OghrXKaSg/Bypv
        1X02AQFJO9r0X
X-Received: by 2002:a05:6e02:5a3:b0:303:7c98:b9d4 with SMTP id k3-20020a056e0205a300b003037c98b9d4mr14565840ils.23.1670962991778;
        Tue, 13 Dec 2022 12:23:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5poRQ6jtVh3bTaEvTnPH0Q6smaLd3jeDa8qEVc6s31QeLVRdQSIMg8XFP5dnjHAYfrwMOxMA==
X-Received: by 2002:a05:6e02:5a3:b0:303:7c98:b9d4 with SMTP id k3-20020a056e0205a300b003037c98b9d4mr14565832ils.23.1670962991491;
        Tue, 13 Dec 2022 12:23:11 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w11-20020a02cf8b000000b00375b92f14c8sm1120652jar.94.2022.12.13.12.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 12:23:10 -0800 (PST)
Date:   Tue, 13 Dec 2022 13:23:09 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 2/5] vfio/type1: prevent locked_vm underflow
Message-ID: <20221213132309.3e6903e8.alex.williamson@redhat.com>
In-Reply-To: <1670960459-415264-3-git-send-email-steven.sistare@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
        <1670960459-415264-3-git-send-email-steven.sistare@oracle.com>
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

On Tue, 13 Dec 2022 11:40:56 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
> dma mapping, locked_vm underflows to a large unsigned value, and a
> subsequent dma map request fails with ENOMEM in __account_locked_vm.
> 
> To avoid underflow, do not decrement locked_vm during unmap if the
> dma's mm has changed.  To restore the correct locked_vm count, when
> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
> the mapping's pinned page count to the new mm->locked_vm, subject
> to the rlimit.  Now that mediated devices are excluded when using
> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
> the mapping.
> 


Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")


> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 80bdb4d..35a1a52 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -100,6 +100,7 @@ struct vfio_dma {
>  	struct task_struct	*task;
>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>  	unsigned long		*bitmap;
> +	struct mm_struct	*mm;
>  };
>  
>  struct vfio_batch {
> @@ -1165,7 +1166,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  					    &iotlb_gather);
>  	}
>  
> -	if (do_accounting) {
> +	if (do_accounting && current->mm == dma->mm) {


This seems incompatible with ffed0518d871 ("vfio: remove useless
judgement") where we no longer assume that the unmap mm is the same as
the mapping mm.

Does this need to get_task_mm(dma->task) and compare that mm to dma->mm
to determine whether an exec w/o vaddr remapping has occurred?  That's
the only use case I can figure out where grabbing the mm for dma->mm
actually makes any sense at all.

>  		vfio_lock_acct(dma, -unlocked, true);
>  		return 0;
>  	}
> @@ -1178,6 +1179,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> +	mmdrop(dma->mm);
>  	vfio_dma_bitmap_free(dma);
>  	if (dma->vaddr_invalid) {
>  		iommu->vaddr_invalid_count--;
> @@ -1623,9 +1625,20 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			   dma->size != size) {
>  			ret = -EINVAL;
>  		} else {
> -			dma->vaddr = vaddr;
> -			dma->vaddr_invalid = false;
> -			iommu->vaddr_invalid_count--;
> +			if (current->mm != dma->mm) {
> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
> +						     0);
> +				if (!ret) {
> +					mmdrop(dma->mm);
> +					dma->mm = current->mm;
> +					mmgrab(dma->mm);
> +				}
> +			}
> +			if (!ret) {
> +				dma->vaddr = vaddr;
> +				dma->vaddr_invalid = false;
> +				iommu->vaddr_invalid_count--;
> +			}

Poor flow, shouldn't this be:

			if (current->mm != dma->mm) {
				ret = vfio_lock_acct(dma,
						     size >> PAGE_SHIFT, 0);
				if (ret)
					goto out_unlock;

				mmdrop(dma->mm);
				dma->mm = current->mm;
				mmgrab(dma->mm);
			}
			dma->vaddr = vaddr;
			dma->vaddr_invalid = false;
			iommu->vaddr_invalid_count--;


Thanks,
Alex

>  			wake_up_all(&iommu->vaddr_wait);
>  		}
>  		goto out_unlock;
> @@ -1683,6 +1696,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	get_task_struct(current->group_leader);
>  	dma->task = current->group_leader;
>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> +	dma->mm = dma->task->mm;
> +	mmgrab(dma->mm);
>  
>  	dma->pfn_list = RB_ROOT;
>  

