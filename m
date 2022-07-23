Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295E957EAFC
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiGWBJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiGWBJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:09:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D7238C3FB
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658538546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TtJITXeJe/HGejcmvCfgDWekHgAs+3zE0/89IdxKZLc=;
        b=AnRW15r6SqABdIHTcJw/b5bnbn8HaU4OO5yi5JK1+6XxL6x2Y1AAReAEKUBAbPh/7eITat
        fuI3AG4Hq4GsxSbgawWodSv8SNUMjBO76oJ58tMdDfLZFX0WMKC+BsT/BVkafLatQgdtbq
        q6pAG2x8Q+RP4gTP5zsYvAAGWWItJ2c=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-LO6CeLpcPWiNJUy6FuaRyg-1; Fri, 22 Jul 2022 21:09:04 -0400
X-MC-Unique: LO6CeLpcPWiNJUy6FuaRyg-1
Received: by mail-il1-f199.google.com with SMTP id e9-20020a056e020b2900b002dc6c27849cso3566846ilu.8
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TtJITXeJe/HGejcmvCfgDWekHgAs+3zE0/89IdxKZLc=;
        b=wEAfRk4SFEF+6dBGGEx0bu+KubL0vCgEHk020mN6zYyiRX5EYN7rro6OEjY61kOqqW
         1+ViM5uIa0yIS71mHiPFOrD/G+N1aBJZb909HswEhy1yT/zSqw6hbSmk4HiUu6/L/iO9
         +Uutixsvo13egJY2mBRt5G+tRMNBPm4mMXWxLEKp7kTOEaordMNFJFXbR8QjNmy14HVP
         C6TVFk3Jlp2a7vvoqgJ+NYxsELapxg9HvihUg+/MkU7HnYpmfryo390Wx82e7w54zR8r
         R45yV6JiYY8xgTAEsUI9YMC9sxPPC1Cs7TKDZO+a7s7cIsPbwfErLGx0VzSYxd0cafmi
         wWgQ==
X-Gm-Message-State: AJIora+vzhftxN+rxGw0DO/9iXJdvZqDCgt+0JDuwXSIyaWtM0qmgdhD
        sHHBz64bpiz7x4XTCANKmAh61xAWaJZHJVyV06BG+rN6WDYx81D45fct8UhXQUkg2QZsJD8MV7H
        QwgAoodonpo82
X-Received: by 2002:a05:6e02:1b07:b0:2dc:767c:6607 with SMTP id i7-20020a056e021b0700b002dc767c6607mr962235ilv.178.1658538544155;
        Fri, 22 Jul 2022 18:09:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vLeZy56sEhX34vmR/dm7wtpceD1ImpTzU8x3g21W4EturgnacF7y4YsmXib0rg5DdXzeXkiQ==
X-Received: by 2002:a05:6e02:1b07:b0:2dc:767c:6607 with SMTP id i7-20020a056e021b0700b002dc767c6607mr962219ilv.178.1658538543921;
        Fri, 22 Jul 2022 18:09:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g18-20020a05663810f200b0033f43a220a6sm2654122jae.11.2022.07.22.18.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 18:09:03 -0700 (PDT)
Date:   Fri, 22 Jul 2022 19:09:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <cohuck@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <terrence.xu@intel.com>
Subject: Re: [PATCH v3 00/10] Update vfio_pin/unpin_pages API
Message-ID: <20220722190901.262a1978.alex.williamson@redhat.com>
In-Reply-To: <YttDAfDEnrlhcZix@Asurada-Nvidia>
References: <20220708224427.1245-1-nicolinc@nvidia.com>
        <20220722161129.21059262.alex.williamson@redhat.com>
        <Ytsu07eGHS9B7HY8@Asurada-Nvidia>
        <20220722181800.56093444.alex.williamson@redhat.com>
        <YttDAfDEnrlhcZix@Asurada-Nvidia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 17:38:25 -0700
Nicolin Chen <nicolinc@nvidia.com> wrote:

> On Fri, Jul 22, 2022 at 06:18:00PM -0600, Alex Williamson wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Fri, 22 Jul 2022 16:12:19 -0700
> > Nicolin Chen <nicolinc@nvidia.com> wrote:
> >   
> > > On Fri, Jul 22, 2022 at 04:11:29PM -0600, Alex Williamson wrote:
> > >  
> > > > GVT-g explodes for me with this series on my Broadwell test system,
> > > > continuously spewing the following:  
> > >
> > > Thank you for running additional tests.
> > >  
> > > > [   47.348778] WARNING: CPU: 3 PID: 501 at drivers/vfio/vfio_iommu_type1.c:978 vfio_iommu_type1_unpin_pages+0x7b/0x100 [vfio_iommu_type1]  
> > >  
> > > > Line 978 is the WARN_ON(i != npage) line.  For the cases where we don't
> > > > find a matching vfio_dma, I'm seeing addresses that look maybe like
> > > > we're shifting  a value that's already an iova by PAGE_SHIFT somewhere.  
> > >
> > > Hmm..I don't understand the PAGE_SHIFT part. Do you mind clarifying?  
> > 
> > The iova was a very large address for a 4GB VM with a lot of zeros on
> > the low order bits, ex. 0x162459000000.  Thanks,  
> 
> Ah! Thanks for the hint. The following commit did a double shifting:
>    "vfio: Pass in starting IOVA to vfio_pin/unpin_pages AP"
> 
> And the following change should fix:
> -------------------
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 481dd2aeb40e..4790c7f35b88 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -293,7 +293,7 @@ static int gvt_dma_map_page(struct intel_vgpu *vgpu, unsigned long gfn,
>         if (dma_mapping_error(dev, *dma_addr)) {
>                 gvt_vgpu_err("DMA mapping failed for pfn 0x%lx, ret %d\n",
>                              page_to_pfn(page), ret);
> -               gvt_unpin_guest_page(vgpu, gfn << PAGE_SHIFT, size);
> +               gvt_unpin_guest_page(vgpu, gfn, size);
>                 return -ENOMEM;
>         }
> 
> @@ -306,7 +306,7 @@ static void gvt_dma_unmap_page(struct intel_vgpu *vgpu, unsigned long gfn,
>         struct device *dev = vgpu->gvt->gt->i915->drm.dev;
> 
>         dma_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL);
> -       gvt_unpin_guest_page(vgpu, gfn << PAGE_SHIFT, size);
> +       gvt_unpin_guest_page(vgpu, gfn, size);
>  }
> 
>  static struct gvt_dma *__gvt_cache_find_dma_addr(struct intel_vgpu *vgpu,
> -------------------

Looks likely.  Not sure how Terrance was able to test this successfully
though.

> So, I think that I should send a v4, given that the patches aren't
> officially applied?

Yep, please rebase on current vfio next branch.  Thanks,

Alex

