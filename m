Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06C8645D6F
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLGPQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLGPPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:15:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E426037A
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670426092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=58ZyRpbATzYwCw2rZvsfumd/Zzq3YA/w5RUXGrdcFac=;
        b=LNmow0kzBgbfUipllcvd53zKZzEWrLzqjZp1HSQCnuS4LiZV4UraD5QUupQSILMps3kcgI
        yt7Er0in+C2FJHtziLDoQURGJsW1hGXcwSqYezUsXwyHTN6DTACLXyILq+g1e4mlqSo0IV
        aYMbcdt1JTSDzlE0/9cPkU+nY4s0kYE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-648-33RtUKS_O5aRpbT56w3E6g-1; Wed, 07 Dec 2022 10:14:51 -0500
X-MC-Unique: 33RtUKS_O5aRpbT56w3E6g-1
Received: by mail-io1-f72.google.com with SMTP id h21-20020a05660224d500b006debd7dedccso13661298ioe.9
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:14:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=58ZyRpbATzYwCw2rZvsfumd/Zzq3YA/w5RUXGrdcFac=;
        b=ZTMXP7KPFYB9oa5WSbMhfVK5vfRFifD9fIQUeokQt/7cJsFt/DUjxk+a/MtOfu57FR
         VMuxJI0uGvCXFbEmyHnr0gGNsENLrRve5ohBnEjI1OpgEfBZI/+NJpuYX8U5v3I0UiHf
         3ij+scvp3ezl01lzSQovuBW94jsiigs0m1rm3+i7BUHcSrAtZKxXXYQj3MpNZzqByYkP
         5DHD2e7j0nJPHEci324ma6nh8MPPVtTmUeSjG6WzyuGa4C7YsVBKbvUoWpCV10QH+X10
         AtALaXr8/E1a/rSQ6q5ONtzkcY8hFBLDsMsuXFUCtkpBeAjqIofAC/66YEg+YCPZWbd2
         dpcQ==
X-Gm-Message-State: ANoB5pkrYDdiNIah6jTSdMRdvsYi8DUN+QtrRWhCA32Y7Mez1dJA/Zng
        YI5FP86ap+0nJAzM1+URlPviMyd18+tn1jD3Uto0/e/WGteYPOxhKhr5NMKS8FXcmP2SobElWNX
        MoT24vrWBYk++
X-Received: by 2002:a92:200b:0:b0:300:f5ab:3ff2 with SMTP id j11-20020a92200b000000b00300f5ab3ff2mr40584684ile.13.1670426090724;
        Wed, 07 Dec 2022 07:14:50 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7P8OtGfw+nx5yICbQJyzVpVs7D1g4m4ZL9P773OljZkxCT0D76xWeraFZEoqSFWqqVs85KMQ==
X-Received: by 2002:a92:200b:0:b0:300:f5ab:3ff2 with SMTP id j11-20020a92200b000000b00300f5ab3ff2mr40584669ile.13.1670426090406;
        Wed, 07 Dec 2022 07:14:50 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u30-20020a02cbde000000b0038a55bcfb47sm2263153jaq.58.2022.12.07.07.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:14:49 -0800 (PST)
Date:   Wed, 7 Dec 2022 08:14:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <20221207081448.6c7705ae.alex.williamson@redhat.com>
In-Reply-To: <7614cc78-610a-f661-f564-b5cd6c624f42@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
        <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
        <20221206165232.2a822e52.alex.williamson@redhat.com>
        <7614cc78-610a-f661-f564-b5cd6c624f42@oracle.com>
Organization: Red Hat
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

On Wed, 7 Dec 2022 09:26:33 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/6/2022 6:52 PM, Alex Williamson wrote:
> > On Tue,  6 Dec 2022 13:55:46 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:  
> >> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >> index d7d8e09..5c5cc7e 100644
> >> --- a/include/uapi/linux/vfio.h
> >> +++ b/include/uapi/linux/vfio.h  
> > ...  
> >> @@ -1265,18 +1256,12 @@ struct vfio_bitmap {
> >>   *
> >>   * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
> >>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
> >> - *
> >> - * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> >> - * virtual addresses in the iova range.  Tasks that attempt to translate an
> >> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
> >> - * cannot be combined with the get-dirty-bitmap flag.
> >>   */
> >>  struct vfio_iommu_type1_dma_unmap {
> >>  	__u32	argsz;
> >>  	__u32	flags;
> >>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> >>  #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
> >> -#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)  
> > 
> > 
> > This flag should probably be marked reserved.
> > 
> > Should we consider this separately for v6.2?  
> 
> Ideally I would like all kernels to support either the old or new vaddr interface.
> If iommufd + vfio compat does not make 6.2, then I prefer not to delete the old
> interface separately.

You've identified a couple vulnerabilities with the current
implementation in the cover letter, userspace can detect the presence
of the feature and therefore removing it should only remove the
capability without breaking otherwise, no upstream userspace seems to
support this, and downstreams that wish to continue support can of
course revert the removal.  So I think as far as the upstream kernel is
concerned, this is dead, risky code.
 
> > For the remainder, the long term plan is to move to iommufd, so any new
> > feature of type1 would need equivalent support in iommufd.  Thanks,  
> 
> Sure.  I will study iommufd and make a proposal.
> 
> Will you review these patches as is to give feedback on the approach?

Yup, it's in my queue.
 
> If I show that iommufd and the vfio compat layer can support these interfaces,
> are you open to accepting these in v6.2 if iommufd is still a ways off? I see 
> iommufd in qemu-next, but not the compat layer.

It's too late for this sort of feature for v6.2, the merge window is
only about 4 days way.  I think the removal can be done with little
risk though.  Thanks,

Alex

