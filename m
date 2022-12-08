Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518F56476C5
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLHTqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHTqQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:46:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5A8F00
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670528683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GYolMYmevphISUXV8T71XWUijdt0atK98M5aC2PO9iI=;
        b=AfJPyKPb6PBBFi3TE0H26B7asIPdAnJVWLtsJ9NPK/iOXGkci3IU6Xuxlkvs14e5jH4aJz
        WzhisMB7LhGDUfUQOgVmjh+QuvT/4r0MgBy08p3+gXhG86xpjwQ6cxCMHTY53c64w9tv5g
        4rLSyTOZ/HiSC+7nYWMVEFRooM1PHMA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-466-BeGmEuXnOXazAGb2-t0hgg-1; Thu, 08 Dec 2022 14:44:42 -0500
X-MC-Unique: BeGmEuXnOXazAGb2-t0hgg-1
Received: by mail-io1-f69.google.com with SMTP id r25-20020a6bfc19000000b006e002cb217fso846843ioh.2
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYolMYmevphISUXV8T71XWUijdt0atK98M5aC2PO9iI=;
        b=X8b3LUWVWt5rTtZka6DIO88DjrQSTP+Kd1J3V6bYtdBztMBY7T8BQ/cTJ8xreZu9xV
         yfWfimUpMxVBi07hemllEUJveuGKfRRZzilLTzLeOAAh6b23RlHkIgH/p+nMEXxsjnO4
         hljrwn1lkNrfv4vQkkEXaP7T+3s2dGCqUiehdOrfrnWwXK053KEZJ+nAkY348zmDxel6
         gHv9Iht39J3SyxhNJ82waVIyP+ir/VlWuuux9p71RNkzlfrzeXRVgqU8geee5ApEeeXf
         dI67RpVnAwZZCMLn6Lvaylj65bPFeAm2OTkNDv9+8egUDBjXd0JvHUEtP8ciN7RFv7V9
         9t0A==
X-Gm-Message-State: ANoB5pmE2lDcEtOQWIAhHjg/0XCu1pI5wdOgfcYM3yGoGlCg81tVHOQV
        h1GZUWieliLCJ5LtEcwHQILhdtmXWZrQor8uIQXZVY2GE2UdQzwwZ9O/SODkPAIOGgjGM80OB5u
        gNwHOq8A3jDVm
X-Received: by 2002:a92:d784:0:b0:302:e57b:b5b7 with SMTP id d4-20020a92d784000000b00302e57bb5b7mr30609171iln.217.1670528681155;
        Thu, 08 Dec 2022 11:44:41 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7tnqOERfs0CG01vI6YgE/q7zOmHGLjnFq4cIpRITf7cyJSsfdBQR9UWjLgJGsnxWDWm+fA+g==
X-Received: by 2002:a92:d784:0:b0:302:e57b:b5b7 with SMTP id d4-20020a92d784000000b00302e57bb5b7mr30609167iln.217.1670528680880;
        Thu, 08 Dec 2022 11:44:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bo11-20020a056638438b00b0038a6ae38ceasm1976165jab.26.2022.12.08.11.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 11:44:40 -0800 (PST)
Date:   Thu, 8 Dec 2022 12:44:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <20221208124438.045c5bce.alex.williamson@redhat.com>
In-Reply-To: <d215f5df-6668-8cfe-1564-2636b3260b8e@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
        <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
        <20221206165232.2a822e52.alex.williamson@redhat.com>
        <Y5CvBZCyfNS1q7rn@ziepe.ca>
        <d215f5df-6668-8cfe-1564-2636b3260b8e@oracle.com>
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

On Thu, 8 Dec 2022 14:09:44 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/7/2022 10:19 AM, Jason Gunthorpe wrote:
> > On Tue, Dec 06, 2022 at 04:52:32PM -0700, Alex Williamson wrote:  
> >> On Tue,  6 Dec 2022 13:55:46 -0800
> >> Steve Sistare <steven.sistare@oracle.com> wrote:  
> >>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> >>> index d7d8e09..5c5cc7e 100644
> >>> --- a/include/uapi/linux/vfio.h
> >>> +++ b/include/uapi/linux/vfio.h  
> >> ...  
> >>> @@ -1265,18 +1256,12 @@ struct vfio_bitmap {
> >>>   *
> >>>   * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
> >>>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
> >>> - *
> >>> - * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> >>> - * virtual addresses in the iova range.  Tasks that attempt to translate an
> >>> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
> >>> - * cannot be combined with the get-dirty-bitmap flag.
> >>>   */
> >>>  struct vfio_iommu_type1_dma_unmap {
> >>>  	__u32	argsz;
> >>>  	__u32	flags;
> >>>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> >>>  #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
> >>> -#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)  
> >>
> >> This flag should probably be marked reserved.
> >>
> >> Should we consider this separately for v6.2?  
> > 
> > I think we should merge this immediately, given the security problem.
> >   
> >> For the remainder, the long term plan is to move to iommufd, so any new
> >> feature of type1 would need equivalent support in iommufd.  Thanks,  
> > 
> > At a bare minimum nothing should be merged to type1 that doesn't come
> > along with an iommufd implementation too.
> > 
> > IMHO at this point we should not be changing type1 any more - just do
> > it iommufd only please. No reason to write and review everything
> > twice.  
> 
> Alex, your opinion?  Implement in iommufd only, or also in type1?  The latter
> makes it more feasible to port to stable kernels and allow qemu with live update
> to run on them.  I imagine porting iommufd to a stable kernel would be heavy lift,
> and be considered too risky.

I understand your concerns, but this isn't really an upstream stable
kernel discussion.  The only thing relevant to an upstream stable
kernel is the removal of the old, vulnerable interface, which I'm
preparing to queue for v6.2.  The new re-implementation isn't eligible
for upstream stable backports, imo.

So I suspect the only stable kernel relevant to the new implementation
is a downstream stable kernel.  While I agree that backporting iommufd
to get this feature is a heavy lift, the alternative is asking upstream
QEMU and kernel to accept and maintain a separate interface in a
backend slated for deprecation.  That's a lot.

I expect you'll be in good company pushing for downstream support of
iommufd given the various improvements and features it offers.  No
offense, but QEMU live update might not even be the primary reason that
a downstream ought to be interested in iommufd.  Thanks,

Alex

