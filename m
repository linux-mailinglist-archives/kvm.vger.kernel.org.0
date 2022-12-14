Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27CB64D0DE
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiLNUNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiLNUM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:12:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB752D1DF
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671048203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RieW7Nm4oEd1+1iBQvjtwTnctMeAAxEtNrQcWo1DK+M=;
        b=aZXfU9Pb+28xvM64ma4Wo5RvsON872k51AgeyDcCtKFc3rMrIAjYfVGKWMrt42QSPdvX9Q
        nNALfoXSI2RGWk3t12U8Z77w1dT9qBoPlAYF6F4nXUpri2hhCCjxwDjfwbl2a6Eib4+8OL
        JBwnMeytKZlN9lG87LWugA29NlxYp4Q=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-36-3IkzSqDoMNa3jiAB0Ajecg-1; Wed, 14 Dec 2022 15:03:21 -0500
X-MC-Unique: 3IkzSqDoMNa3jiAB0Ajecg-1
Received: by mail-il1-f197.google.com with SMTP id h18-20020a056e021d9200b00304c4ff476fso5399060ila.2
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:03:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RieW7Nm4oEd1+1iBQvjtwTnctMeAAxEtNrQcWo1DK+M=;
        b=dCFsh47ZLWYKVHSEHVCOWcgNV46Baap4bR3WxFHCQiarcvIpttpBAjIFwZU5JyceOW
         Yq9VGCofr2OSDoCidsrjDU9CzlkbzkbkSHRT6kysVqDxtfNjjyDEx4qwk208AcMemwNg
         okx4WbXh4zz9kTbrK1VsMA/NgvsNJVMWej80BAHm9GHQuTdA3/c9jksEN4DnmUSPe8jB
         Z6fznEXHONXT2eug+a7/7wRPIcs016gZEPlhuZW3Uq8ZW0DGikH5GgNAW1+Y868HJ70z
         1O87Y9JV9O0B/eSL0LyAwhuj4UjiKV4sjgfuEslKsUtM1iUVE3/kCIWkVJ+fWtSSWS7i
         NAaQ==
X-Gm-Message-State: ANoB5pm4Cue/VCScH2I2R/7S1lzuEqLH/JbOwtgVEjQ3mJshdR44J/Fw
        Km0L4IdFMFJmp2VUGIbHynK5UfE48rdFZL72wRM+Cx2uCG9fyqQWhROYyWJ8m5FB0gjjgAk+0Eq
        /ACdTClHPlbqA
X-Received: by 2002:a6b:c413:0:b0:6bc:d71a:570e with SMTP id y19-20020a6bc413000000b006bcd71a570emr14434435ioa.16.1671048200642;
        Wed, 14 Dec 2022 12:03:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6+4YcYJYuh5vNRW0r3V47O7/4PMMB7vUktST77NW/p57r9lDFvjp4rgfBKzePRos/ktIXKmQ==
X-Received: by 2002:a6b:c413:0:b0:6bc:d71a:570e with SMTP id y19-20020a6bc413000000b006bcd71a570emr14434419ioa.16.1671048200309;
        Wed, 14 Dec 2022 12:03:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w11-20020a056602034b00b006ddd15ca0absm251254iou.25.2022.12.14.12.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 12:03:19 -0800 (PST)
Date:   Wed, 14 Dec 2022 13:03:18 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V3 2/5] vfio/type1: prevent locked_vm underflow
Message-ID: <20221214130318.05055dd7.alex.williamson@redhat.com>
In-Reply-To: <1671045771-59788-3-git-send-email-steven.sistare@oracle.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
        <1671045771-59788-3-git-send-email-steven.sistare@oracle.com>
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

On Wed, 14 Dec 2022 11:22:48 -0800
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
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index b04f485..e719c13 100644
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
> @@ -424,6 +425,12 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>  	if (!mm)
>  		return -ESRCH; /* process exited */
>  
> +	/* Avoid locked_vm underflow */
> +	if (dma->mm != mm && npage < 0) {
> +		mmput(mm);
> +		return 0;
> +	}

How about initialize ret = 0 and jump to the existing mmput() with a
goto, so there's no assumptions about whether we need the mmput() or
not.

> +
>  	ret = mmap_write_lock_killable(mm);
>  	if (!ret) {
>  		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
> @@ -1180,6 +1187,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> +	mmdrop(dma->mm);
>  	vfio_dma_bitmap_free(dma);
>  	if (dma->vaddr_invalid) {
>  		iommu->vaddr_invalid_count--;
> @@ -1578,6 +1586,42 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>  	return list_empty(iova);
>  }
>  
> +static int vfio_change_dma_owner(struct vfio_dma *dma)
> +{
> +	int ret = 0;
> +	struct mm_struct *mm = get_task_mm(dma->task);
> +
> +	if (dma->mm != mm) {
> +		long npage = dma->size >> PAGE_SHIFT;
> +		bool new_lock_cap = capable(CAP_IPC_LOCK);
> +		struct task_struct *new_task = current->group_leader;
> +
> +		ret = mmap_write_lock_killable(new_task->mm);
> +		if (ret)
> +			goto out;
> +
> +		ret = __account_locked_vm(new_task->mm, npage, true,
> +					  new_task, new_lock_cap);
> +		mmap_write_unlock(new_task->mm);
> +		if (ret)
> +			goto out;
> +
> +		if (dma->task != new_task) {
> +			vfio_lock_acct(dma, -npage, 0);
> +			put_task_struct(dma->task);
> +			dma->task = get_task_struct(new_task);
> +		}

IIUC, we're essentially open coding vfio_lock_acct() in the previous
section so that we can be sure we've accounted the new task before we
credit the previous task.  However, I was under the impression the task
remained the same, but the mm changes, which is how we end up with the
underflow described in the commit log.  What circumstances cause a task
change?  Thanks,

Alex


> +		mmdrop(dma->mm);
> +		dma->mm = new_task->mm;
> +		mmgrab(dma->mm);
> +		dma->lock_cap = new_lock_cap;
> +	}
> +out:
> +	if (mm)
> +		mmput(mm);
> +	return ret;
> +}
> +
>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			   struct vfio_iommu_type1_dma_map *map)
>  {
> @@ -1627,6 +1671,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			   dma->size != size) {
>  			ret = -EINVAL;
>  		} else {
> +			ret = vfio_change_dma_owner(dma);
> +			if (ret)
> +				goto out_unlock;
>  			dma->vaddr = vaddr;
>  			dma->vaddr_invalid = false;
>  			iommu->vaddr_invalid_count--;
> @@ -1687,6 +1734,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	get_task_struct(current->group_leader);
>  	dma->task = current->group_leader;
>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> +	dma->mm = dma->task->mm;
> +	mmgrab(dma->mm);
>  
>  	dma->pfn_list = RB_ROOT;
>  

