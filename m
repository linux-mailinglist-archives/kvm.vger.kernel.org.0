Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3164BE58
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 22:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiLMV04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 16:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLMV0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 16:26:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A5C218B5
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670966768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Zg7DCrtxlMszxrpA7HdkT9wUDSI7bARMR/qMe4onhU=;
        b=XkdpfRk7JEo3biof29WVLX85ObMOv6VGYYgmf4o1Gf/ixfba6dowFhiNGfuXGCQhXfIpaZ
        T/04mB0gdGHlN5lxRsgGhZ1YYDYUB0DWJFzTalsZxj30zsfUpmWJdF9d2BK3ol5YZRorKe
        MsUe64v0HeIQowHikvWr3oQL0wJDA/0=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-118-WzSQRBKOPnWZRwtS1jtaog-1; Tue, 13 Dec 2022 16:26:06 -0500
X-MC-Unique: WzSQRBKOPnWZRwtS1jtaog-1
Received: by mail-io1-f69.google.com with SMTP id s22-20020a6bdc16000000b006e2d7c78010so2709713ioc.21
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 13:26:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Zg7DCrtxlMszxrpA7HdkT9wUDSI7bARMR/qMe4onhU=;
        b=HT9d31Og6YZJfzuduQ9rCU7qbyXlP2i844Vv3MPyUZRBY4ampU3R5GgeDURY680MOy
         8FUyXptmgJjS6ppvQlfEosRVtA24VwRlbhfIPRFgx/lD64/lZTi/8WnhClBqykx/eLuG
         EHkHZugt59eV5PLv+fb/h8COJRqlVDx3md0LEo3wddweHQ5WlpzyX2joHhNMaqVw8kxo
         u8d/elgMdavgK2UwWn/M+71ZoYlKtKBQ7FgMaAMkryH5DEtAQqJrxMRVvdas3eRe1f1D
         8Rl/28PKjUiEQV4vQrZ586V6qxlc4qPhH3zIqf7MNUpRQcQzuViWmxCnkHk6UjesqtbV
         FWrQ==
X-Gm-Message-State: ANoB5pm7ilzl86x+DwMRuBeeL6BBe5o7refUfhBrm4Qsnl1VXd6AGSCb
        K4P4raMZkXO64SppXBr8GhA2UxFAAlgwoi5SIMYPGwC6Q9nS1tM817sGRHI0NF50OWJ3/f/cpRx
        Ge3MvijZmwj9n
X-Received: by 2002:a6b:e414:0:b0:6e0:2f8f:7bf0 with SMTP id u20-20020a6be414000000b006e02f8f7bf0mr12201271iog.9.1670966765959;
        Tue, 13 Dec 2022 13:26:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7QUcz87jkeazsSvsbTD5InmuRbEdXV44bRSYMbK69EBcKRDDy5zjBCm9Imb96pR3JJvIlJbA==
X-Received: by 2002:a6b:e414:0:b0:6e0:2f8f:7bf0 with SMTP id u20-20020a6be414000000b006e02f8f7bf0mr12201264iog.9.1670966765608;
        Tue, 13 Dec 2022 13:26:05 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id j9-20020a0566022cc900b006d8b7bcaa6esm5603500iow.4.2022.12.13.13.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 13:26:04 -0800 (PST)
Date:   Tue, 13 Dec 2022 14:26:03 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <20221213142603.5309d2d6.alex.williamson@redhat.com>
In-Reply-To: <7b0fc4e5-8bc5-27dc-10f6-06493abb4ea3@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
        <1670960459-415264-2-git-send-email-steven.sistare@oracle.com>
        <20221213132245.10ef6873.alex.williamson@redhat.com>
        <16a49fb7-e7bd-f794-9e12-9e88fa5d536c@oracle.com>
        <20221213135907.71f56f8a.alex.williamson@redhat.com>
        <7b0fc4e5-8bc5-27dc-10f6-06493abb4ea3@oracle.com>
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

On Tue, 13 Dec 2022 16:16:31 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/13/2022 3:59 PM, Alex Williamson wrote:
> > On Tue, 13 Dec 2022 15:37:45 -0500
> > Steven Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> On 12/13/2022 3:22 PM, Alex Williamson wrote:  
> >>> On Tue, 13 Dec 2022 11:40:55 -0800
> >>> Steve Sistare <steven.sistare@oracle.com> wrote:
> >>>     
> >>>> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
> >>>> Their kernel threads could be blocked indefinitely by a misbehaving
> >>>> userland while trying to pin/unpin pages while vaddrs are being updated.
> >>>>
> >>>> Do not allow groups to be added to the container while vaddr's are invalid,
> >>>> so we never need to block user threads from pinning, and can delete the
> >>>> vaddr-waiting code in a subsequent patch.
> >>>>    
> >>>
> >>>
> >>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")    
> >>
> >> will do in both patches, slipped through the cracks.
> >>  
> >>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >>>> ---
> >>>>  drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++++++++++-
> >>>>  include/uapi/linux/vfio.h       | 15 +++++++++------
> >>>>  2 files changed, 39 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>>> index 23c24fe..80bdb4d 100644
> >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>> @@ -859,6 +859,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
> >>>>  	if (!iommu->v2)
> >>>>  		return -EACCES;
> >>>>  
> >>>> +	WARN_ON(iommu->vaddr_invalid_count);
> >>>> +    
> >>>
> >>> I'd expect this to abort and return -errno rather than simply trigger a
> >>> warning.    
> >>
> >> I added the three WARN_ON's at your request, but they should never fire because
> >> we exclude mdevs.  I prefer not to bloat the code with additional checking that
> >> never fires, and I would prefer to just delete WARN_ON, but its your call.  
> > 
> > Other than convention, what prevents non-mdev code from using this
> > interface?  I agree that making vaddr unmapping and emulated IOMMU
> > devices mutually exclusive *should* be enough, but I have reason to
> > suspect there could be out-of-tree non-mdev drivers using these
> > interfaces.  Thanks,  
> 
> OK, none of the exclusion checks will prevent such calls, even for mdevs.  I will 
> delete the WARN_ON's and return an error code.

The WARN_ONs are still appropriate.  We've specified via comment in
vfio_pin_pages() that only devices created with
vfio_register_emulated_iommu_dev() can use it, so if the mutual
exclusion we think should be present between vaddr and kernel threads
is broken, there's a driver bug that justifies a WARN_ON.  Thanks,

Alex
 
> >>>>  	mutex_lock(&iommu->lock);
> >>>>  
> >>>>  	/*
> >>>> @@ -976,6 +978,8 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
> >>>>  
> >>>>  	mutex_lock(&iommu->lock);
> >>>>  
> >>>> +	WARN_ON(iommu->vaddr_invalid_count);
> >>>> +    
> >>>
> >>> This should never happen or else I'd suggest this also make an early
> >>> exit.    
> >>
> >> I would like to delete the WARN_ON's entirely.
> >>  
> >>>>  	do_accounting = list_empty(&iommu->domain_list);
> >>>>  	for (i = 0; i < npage; i++) {
> >>>>  		dma_addr_t iova = user_iova + PAGE_SIZE * i;
> >>>> @@ -1343,6 +1347,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>>>  
> >>>>  	mutex_lock(&iommu->lock);
> >>>>  
> >>>> +	/* Cannot update vaddr if mdev is present. */
> >>>> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
> >>>> +		goto unlock;    
> >>>
> >>> A different errno here to reflect that the container state is the issue
> >>> might be appropriate here.    
> >>
> >> Will do.
> >>  
> >>>> +
> >>>>  	pgshift = __ffs(iommu->pgsize_bitmap);
> >>>>  	pgsize = (size_t)1 << pgshift;
> >>>>  
> >>>> @@ -2189,6 +2197,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >>>>  
> >>>>  	mutex_lock(&iommu->lock);
> >>>>  
> >>>> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
> >>>> +	if (iommu->vaddr_invalid_count)
> >>>> +		goto out_unlock;
> >>>> +
> >>>>  	/* Check for duplicates */
> >>>>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
> >>>>  		goto out_unlock;
> >>>> @@ -2660,6 +2672,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
> >>>>  	return ret;
> >>>>  }
> >>>>  
> >>>> +static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
> >>>> +{
> >>>> +	int ret;
> >>>> +
> >>>> +	mutex_lock(&iommu->lock);
> >>>> +	ret = !list_empty(&iommu->emulated_iommu_groups);
> >>>> +	mutex_unlock(&iommu->lock);
> >>>> +	return ret;
> >>>> +}
> >>>> +
> >>>>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
> >>>>  					    unsigned long arg)
> >>>>  {
> >>>> @@ -2668,8 +2690,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
> >>>>  	case VFIO_TYPE1v2_IOMMU:
> >>>>  	case VFIO_TYPE1_NESTING_IOMMU:
> >>>>  	case VFIO_UNMAP_ALL:
> >>>> -	case VFIO_UPDATE_VADDR:
> >>>>  		return 1;
> >>>> +	case VFIO_UPDATE_VADDR:
> >>>> +		/*
> >>>> +		 * Disable this feature if mdevs are present.  They cannot
> >>>> +		 * safely pin/unpin while vaddrs are being updated.
> >>>> +		 */
> >>>> +		return iommu && !vfio_iommu_has_emulated(iommu);
> >>>>  	case VFIO_DMA_CC_IOMMU:
> >>>>  		if (!iommu)
> >>>>  			return 0;
> >>>> @@ -3080,6 +3107,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
> >>>>  	size_t offset;
> >>>>  	int ret;
> >>>>  
> >>>> +	WARN_ON(iommu->vaddr_invalid_count);
> >>>> +    
> >>>
> >>> Same as pinning, this should trigger -errno.  Thanks,    
> >>
> >> Another one that should never happen.  
> >>
> >> - Steve
> >>  
> >>>>  	*copied = 0;
> >>>>  
> >>>>  	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
> >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>>> index d7d8e09..4e8d344 100644
> >>>> --- a/include/uapi/linux/vfio.h
> >>>> +++ b/include/uapi/linux/vfio.h
> >>>> @@ -49,7 +49,11 @@
> >>>>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
> >>>>  #define VFIO_UNMAP_ALL			9
> >>>>  
> >>>> -/* Supports the vaddr flag for DMA map and unmap */
> >>>> +/*
> >>>> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
> >>>> + * devices, so this capability is subject to change as groups are added or
> >>>> + * removed.
> >>>> + */
> >>>>  #define VFIO_UPDATE_VADDR		10
> >>>>  
> >>>>  /*
> >>>> @@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
> >>>>   * Map process virtual addresses to IO virtual addresses using the
> >>>>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
> >>>>   *
> >>>> - * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
> >>>> - * unblock translation of host virtual addresses in the iova range.  The vaddr
> >>>> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
> >>>>   * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
> >>>>   * maintain memory consistency within the user application, the updated vaddr
> >>>>   * must address the same memory object as originally mapped.  Failure to do so
> >>>> @@ -1267,9 +1270,9 @@ struct vfio_bitmap {
> >>>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
> >>>>   *
> >>>>   * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> >>>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
> >>>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
> >>>> - * cannot be combined with the get-dirty-bitmap flag.
> >>>> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
> >>>> + * Groups may not be added to the container while any addresses are invalid.
> >>>> + * This cannot be combined with the get-dirty-bitmap flag.
> >>>>   */
> >>>>  struct vfio_iommu_type1_dma_unmap {
> >>>>  	__u32	argsz;    
> >>>     
> >>  
> >   
> 

