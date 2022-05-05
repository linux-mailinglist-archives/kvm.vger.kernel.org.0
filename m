Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C0951B999
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346312AbiEEIKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 04:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239748AbiEEIKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 04:10:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854D425588
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 01:06:27 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bv19so7210273ejb.6
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 01:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3K83JMDMx9AxkY2MpTWHL/X8yc+mGKll6H+GwGrzrXw=;
        b=Pdtsnpz25g0L0sGsgkrGA9PE/jHPEhiufxAQs2UORRU6ww6fyZmlK5ZxLJgl2nf2GB
         gUr3FSeYrQjGGlhnhiio8frv3RAdG1/f5l9akUth8+9ycpCiEBTacerm9IlZlKN+/qSw
         0+ZGPlcM+wD9GQs/W5gZHHqeL1x1hjV+y465Cm4UWAbaQV/d/rpOB0/PVJ7mvUeM4G6f
         frbcyzypQKiG866cTRDIqK9y3RZ98qJyksHtGSvW+uwlkYGWY6KllQu6imHlN8PNLVi/
         cs5vsbApi2i+F6I5sQsxwrEzHJXvaMHlUGkzDCAW38+OLJSLkNCzHrDQ2cGKQyTWqGCT
         AWXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3K83JMDMx9AxkY2MpTWHL/X8yc+mGKll6H+GwGrzrXw=;
        b=Emra+1Rc7qkPN2D3fBuudXwbtNwJiKSmA3UQBLhQTCfyYEFvInTtXWKzgPCA1uPGnX
         j2q5z854iL9QcAlgNKcGffvZKyGRXcUfoO9L1feN8yCVQ6xUWYxXeSCGNFhFmK1QIxMo
         x2yzt/vkqiFRSsi+Rz6Qdu6IlGnfdupOZJuGBqNPiYA1cmjt/3UFosFHR9K3czZwukVZ
         Us+ycQmq70coSAB1IASDIDy2742IQIoEiR3jK32vknvj77ADpQ4zTdzYKoJW5KxsI4HD
         as37T4bPFIuKfz//piXpIW4mPcl/8cnRVJ1Qx1MfanIsG8kR6AhzGLDn46oy33pTAq8D
         owMw==
X-Gm-Message-State: AOAM532zijXrMFIditK6XgovXnj0bF7SmtUDjkEtrBsJZC59/iiPH/A6
        bam4fbNqNBM7FfzLSb7YXEkJbjYrbFZfyFaMAXeI
X-Google-Smtp-Source: ABdhPJwOHANVwEvQlCGaUkJaMC0dkIEkNL1jg88b2HsPrT7nBl1xSN42xNAG4Kt4eSmC5H2uZ6XhIWNcXorY2Q9AZ2k=
X-Received: by 2002:a17:906:7c96:b0:6f3:b6c4:7b2 with SMTP id
 w22-20020a1709067c9600b006f3b6c407b2mr24797714ejo.676.1651737986127; Thu, 05
 May 2022 01:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220504081117.40-1-xieyongji@bytedance.com> <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
In-Reply-To: <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 5 May 2022 16:07:00 +0800
Message-ID: <CACycT3sdLfJPhm73p8onT1zZF3eyt+uPKBj__cfH_RvEk=FoBw@mail.gmail.com>
Subject: Re: [PATCH] vringh: Fix maximum number check for indirect descriptors
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 3:47 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Wed, May 4, 2022 at 4:12 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> >
> > We should use size of descriptor chain to check the maximum
> > number of consumed descriptors in indirect case.
>
> AFAIK, it's a guard for loop descriptors.
>

Yes, but for indirect descriptors, we know the size of the descriptor
chain. Should we use it to test loop condition rather than using
virtqueue size?

> > And the
> > statistical counts should also be reset to zero each time
> > we get an indirect descriptor.
>
> What might happen if we don't have this patch?
>

Then we can't handle the case that one request includes multiple
indirect descriptors. Although I never see this kind of case now, the
spec doesn't forbid it.

> >
> > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > ---
> >  drivers/vhost/vringh.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 14e2043d7685..c1810b77a05e 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -344,12 +344,13 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >                         addr = (void *)(long)(a + range.offset);
> >                         err = move_to_indirect(vrh, &up_next, &i, addr, &desc,
> >                                                &descs, &desc_max);
> > +                       count = 0;
>
> Then it looks to me we can detect a loop indirect descriptor chain?
>

I think so.

Thanks,
Yongji
