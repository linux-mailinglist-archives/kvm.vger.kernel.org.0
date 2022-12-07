Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65550645D8C
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiLGPTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiLGPTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:19:37 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF08461BBD
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 07:19:35 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id p18so10204619qkg.2
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 07:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=shkSmGQzG+o33+1ITgh7ycYWXYsNy5k8QaDwPEH3sxk=;
        b=Yi5DHBCrtkYMZZi2FmJyNqEikNm+oB6+qV2Yuo6y8bdX595glKWElj6hsuvDxZqJsa
         Y2sI8vE4rPafMrmkluKTk5jkes2wlNLw8Q6iXn/X6wsADqgGesk9IxuqLcG8LumcDpSw
         BPghwxurUUPFj0oT0d7AyF7C9sngNp69yNpjRYj8ACMhxBF44Dfdo28rL8H4EbmR9YCn
         HgZKwpOR+Ar6XO5OsY1PmxBC8cGoZ4I0F32Ihq0c7bzsGHUXJmCJ5aIGdcrvjckvs4vW
         ae68YrT9cCzSxgW5lPZ5s/fmJ6Xl3al3niJfznn8YIx/0sWtS/gmK77EhopHgT1euxKl
         aHyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=shkSmGQzG+o33+1ITgh7ycYWXYsNy5k8QaDwPEH3sxk=;
        b=iRAvsqGpcEL88mUKKDOVB9cSMIFsJ4PEOkjPI2u3uI5pgFF5Mi7nf6GeZ1dTOA3qzg
         uTpVSK/8djLBSrZIPnPPYobRruDlY3dBFqItuMWe/FozquAEkh2JMbjlVn+ZsdXmgc8R
         KlK/INnRxXSq+59ehiQJbVnQV0zDG3m4ouRTirJTEPhqukm+f+eKQMWyzU0VkXgZqVue
         QQrM/1uOzp2VON/c2H4h2MdcG1xWRcYiAOpKIdArh9t2Y8fBOMv1JB7OmMc0HILo3E+P
         n4BdONWITbtDpVCkvj3hE4Y1NgKkx2HSOSmYRyvOD54gJTyf9AxfsZ8JVlxa0B0wio5d
         6JKg==
X-Gm-Message-State: ANoB5pnmFpxvnOZb+WID3O3yyBcH3svMOwKUIQ7sYyFlzL0Ws3gY/AcB
        /v51LLvdN9Sd3QlZqU7+TI/L/x3wJgdwvm5E
X-Google-Smtp-Source: AA0mqf6kDz+i8nw6kZqfyZexq6F2IuUCUpK/77Kqz9ZQH+lsJzTSlt3ekaMsvX6gK4yYATHd9TFxaA==
X-Received: by 2002:ae9:e412:0:b0:6fa:30f1:c1ba with SMTP id q18-20020ae9e412000000b006fa30f1c1bamr82396999qkc.117.1670426374943;
        Wed, 07 Dec 2022 07:19:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id o22-20020a05620a2a1600b006fb112f512csm17627130qkp.74.2022.12.07.07.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:19:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2wCr-005EUW-6E;
        Wed, 07 Dec 2022 11:19:33 -0400
Date:   Wed, 7 Dec 2022 11:19:33 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Steve Sistare <steven.sistare@oracle.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <Y5CvBZCyfNS1q7rn@ziepe.ca>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
 <20221206165232.2a822e52.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206165232.2a822e52.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 04:52:32PM -0700, Alex Williamson wrote:
> On Tue,  6 Dec 2022 13:55:46 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index d7d8e09..5c5cc7e 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> ...
> > @@ -1265,18 +1256,12 @@ struct vfio_bitmap {
> >   *
> >   * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
> >   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
> > - *
> > - * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> > - * virtual addresses in the iova range.  Tasks that attempt to translate an
> > - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
> > - * cannot be combined with the get-dirty-bitmap flag.
> >   */
> >  struct vfio_iommu_type1_dma_unmap {
> >  	__u32	argsz;
> >  	__u32	flags;
> >  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
> >  #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
> > -#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
> 
> 
> This flag should probably be marked reserved.
> 
> Should we consider this separately for v6.2?

I think we should merge this immediately, given the security problem.

> For the remainder, the long term plan is to move to iommufd, so any new
> feature of type1 would need equivalent support in iommufd.  Thanks,

At a bare minimum nothing should be merged to type1 that doesn't come
along with an iommufd implementation too.

IMHO at this point we should not be changing type1 any more - just do
it iommufd only please. No reason to write and review everything
twice.

Jason
