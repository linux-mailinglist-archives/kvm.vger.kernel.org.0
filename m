Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA464BB7F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 19:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbiLMSDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 13:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbiLMSDp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 13:03:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41944642A
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670954577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r9E+N2k2PlNYTDkkB3cR457URBRxZvtHjvtb7vtCz4k=;
        b=I8WwdHHDGRTuz+0uTCgTB2Y9WiKa+z42iGqggt/eR4ZajR9BbXF54/2gmH+7JQzH5RFegi
        YFpZ5an1ELYcPuS4u0nrifzKuYqbDfsbi0wUvK9GdTaatqMoHyp1mIupOQaSSw3CbWGllu
        NJIoXan5inh6gX7cchXyx9jPXtTPcLw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-NQgzejwtOgqnMipUwHQf9A-1; Tue, 13 Dec 2022 13:02:56 -0500
X-MC-Unique: NQgzejwtOgqnMipUwHQf9A-1
Received: by mail-il1-f199.google.com with SMTP id 7-20020a056e0220c700b0030386f0d0e6so7980833ilq.3
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9E+N2k2PlNYTDkkB3cR457URBRxZvtHjvtb7vtCz4k=;
        b=L2yreJK8C9gH4phUX4cvHNeUlnPkfKMq9UV3x2thOGIHw/YEfGEvwUWzTyGEq/oR24
         32CZesl6xfVzWGbzHZYTG2FB7+J7M+1/lKpZ7rNCLOPahTbEttNhoVBZJwbD1g1S7AMr
         I0mdRLvHHupqbiZW6lj55MK9c58n7Vs7aJtt8kvRZA2Pzol4/e9ZbGZ+7MuG+vrTEXAK
         twko0FcAENJwoaom9KP7xOSL7wzhStXnHuDLHXF2SvFJvVPFdNx1Gtj0sEdNeUQ852fU
         nFiav8QLjGRNJxHCtBfu8O03Ouad+peQpiwKfpIzU0C6ZyWK4H//NNG94Dm3W4GP9PEr
         bmbg==
X-Gm-Message-State: ANoB5pn9jMY3mUxzcLEMAXHveeTF6CHFSi9OCh0wmkgVk3Vuar+Q8u0c
        F9u7gl58OvYtvKk7oMg/P5aZb03bl53TlZCDjG0cvlw0vkAz504YlBcXROsGrpvgOV14tt2Sas5
        cT0d4MRVr/iar
X-Received: by 2002:a5d:8351:0:b0:6df:e430:e8af with SMTP id q17-20020a5d8351000000b006dfe430e8afmr12799526ior.18.1670954574929;
        Tue, 13 Dec 2022 10:02:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7fbBsONL4xFqevTRJrZky2JIfHRDglikffxIKp7h2t/k7F5PKdgBRP/9gr8ZkeTK8bSLbi2Q==
X-Received: by 2002:a5d:8351:0:b0:6df:e430:e8af with SMTP id q17-20020a5d8351000000b006dfe430e8afmr12799508ior.18.1670954574695;
        Tue, 13 Dec 2022 10:02:54 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f90-20020a0284e3000000b00374ff5df5ccsm1033157jai.167.2022.12.13.10.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 10:02:54 -0800 (PST)
Date:   Tue, 13 Dec 2022 11:02:52 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 2/2] vfio/type1: prevent locked_vm underflow
Message-ID: <20221213110252.7bcebb97.alex.williamson@redhat.com>
In-Reply-To: <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
        <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
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

On Tue, 13 Dec 2022 07:46:56 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
> dma mapping, locked_vm underflows to a large unsigned value, and a
> subsequent dma map request fails with ENOMEM in __account_locked_vm.
> 
> To fix, when VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed,
> add the mapping's pinned page count to the new mm->locked_vm, subject to
> the rlimit.  Now that mediated devices are excluded when using
> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of the
> mapping.
> 
> Underflow will not occur when all dma mappings are invalidated before exec.
> An attempt to unmap before updating the vaddr with VFIO_DMA_MAP_FLAG_VADDR
> will fail with EINVAL because the mapping is in the vaddr_invalid state.

Where is this enforced?

> Underflow may still occur in a buggy application that fails to invalidate
> all before exec.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index f81e925..e5a02f8 100644
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
> @@ -1174,6 +1175,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  	vfio_unmap_unpin(iommu, dma, true);
>  	vfio_unlink_dma(iommu, dma);
>  	put_task_struct(dma->task);
> +	mmdrop(dma->mm);
>  	vfio_dma_bitmap_free(dma);
>  	if (dma->vaddr_invalid) {
>  		iommu->vaddr_invalid_count--;
> @@ -1622,6 +1624,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  			dma->vaddr = vaddr;
>  			dma->vaddr_invalid = false;
>  			iommu->vaddr_invalid_count--;
> +			if (current->mm != dma->mm) {
> +				mmdrop(dma->mm);
> +				dma->mm = current->mm;
> +				mmgrab(dma->mm);
> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
> +						     0);

What does it actually mean if this fails?  The pages are still pinned.
lock_vm doesn't get updated.  Underflow can still occur.  Thanks,

Alex

> +			}
>  			wake_up_all(&iommu->vaddr_wait);
>  		}
>  		goto out_unlock;
> @@ -1679,6 +1688,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	get_task_struct(current->group_leader);
>  	dma->task = current->group_leader;
>  	dma->lock_cap = capable(CAP_IPC_LOCK);
> +	dma->mm = dma->task->mm;
> +	mmgrab(dma->mm);
>  
>  	dma->pfn_list = RB_ROOT;
>  

