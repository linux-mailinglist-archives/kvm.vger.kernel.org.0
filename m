Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3353B662
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 11:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiFBJwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 05:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiFBJwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 05:52:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A5C512ADC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 02:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654163519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=95fjZ/B3kpsPbz5qD+HTWPkRB4J4HKCIftwEN6akcmc=;
        b=QMa0PBWp+kdBPUQgqSPpfCMzuMkcQMsiJhX5Nijf4HIc4dh/35VKdFEy/PA2gMk3T2tdQx
        r6ewvHByKA1d4xkkQv7F2d4BnFUllzsmBdJs8F44vEa9uhC2WtenqYNalYrU4YlJraXAPO
        IsNebcE4XQHpex+cIGFLglu+BvYPiCw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-sQRHP6K8OSe5fptATcjx2A-1; Thu, 02 Jun 2022 05:51:57 -0400
X-MC-Unique: sQRHP6K8OSe5fptATcjx2A-1
Received: by mail-wm1-f71.google.com with SMTP id i1-20020a05600c354100b003976fc71579so2568972wmq.8
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 02:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=95fjZ/B3kpsPbz5qD+HTWPkRB4J4HKCIftwEN6akcmc=;
        b=0+crfzZpVIEddzwpmt0wE+JH13ntJ3zJNQy3lIjeUWXlXUtYPjE+IVuUvAUUkhWAzw
         mdWfA1wEJQlPGtqV8ioupa4Na0VBxkz2ZSanwB3Lj4jYoc9yhd/n9KsXfbZDJBH3w6y/
         0msEcING1CcjaAtzDXjy3E1y9znW2nCESoLls9HaS8Xt0Qb+QbEoVLhHRxWCfy5cxqgH
         cz442+YPPy8HCmpoVoali25snEgsF9PS8fShyEWbIxDkfk/XgMNGGWgZ4UJS+8bTQCUg
         wDJ7VLur9ktZWkKeHTn9HRIFaQQMagcSc9pFXBdr0NiSafgmt10mWgKl98uHGUj98y6c
         efmA==
X-Gm-Message-State: AOAM530sPOkAlrP3o4Xqx7CKBl3FHojfLwnnAHgjLPdkFvW3SS4JvjQi
        ZQ9kQwU5VXnJOR7SGsq9atGUUF0WNQZClA2EOWxkNJJyBjpUvGBQqwaFJfE644+3gh8A65C5nJr
        1Ib3BEyTInAxi
X-Received: by 2002:a05:600c:4fcd:b0:398:e5d2:bfc7 with SMTP id o13-20020a05600c4fcd00b00398e5d2bfc7mr24335355wmq.60.1654163516718;
        Thu, 02 Jun 2022 02:51:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxerGLbgaKfeaVA7rraLsd7mgR0u9TWI3iGl43SD0tSzx9IQc+Lqm5RcOZz7zZy+hjkwc3juA==
X-Received: by 2002:a05:600c:4fcd:b0:398:e5d2:bfc7 with SMTP id o13-20020a05600c4fcd00b00398e5d2bfc7mr24335336wmq.60.1654163516509;
        Thu, 02 Jun 2022 02:51:56 -0700 (PDT)
Received: from redhat.com ([2.52.157.68])
        by smtp.gmail.com with ESMTPSA id u18-20020a5d5152000000b0020cdcb0efa2sm3791739wrt.34.2022.06.02.02.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 02:51:55 -0700 (PDT)
Date:   Thu, 2 Jun 2022 05:51:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v2] vringh: Fix loop descriptors check in the indirect
 cases
Message-ID: <20220602055133-mutt-send-email-mst@kernel.org>
References: <20220505100910.137-1-xieyongji@bytedance.com>
 <CACGkMEv3Ofbu7OOTB9vN2Lt85TD44LipjoPm26KEq3RiKJU0Yw@mail.gmail.com>
 <CACycT3uakPB_JeXb11hrBaPjcdqign3FmuQd3FXgFR7orO_Eaw@mail.gmail.com>
 <CACGkMEu72zPKyZXWvyeMsNwjKohXHEMu_hp1dwPVF_2RF5ezPA@mail.gmail.com>
 <CACycT3v8bo=6YHmb-F3fEjVSCsJdWSLwLy4RTz6hCW39FAZZPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3v8bo=6YHmb-F3fEjVSCsJdWSLwLy4RTz6hCW39FAZZPA@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 12:55:50PM +0800, Yongji Xie wrote:
> Ping.


Thanks for the reminder!
Will queue for rc2, rc1 has too much stuff already.

> On Tue, May 10, 2022 at 3:56 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> > On Tue, May 10, 2022 at 3:54 PM Yongji Xie <xieyongji@bytedance.com> wrote:
> > >
> > > On Tue, May 10, 2022 at 3:44 PM Jason Wang <jasowang@redhat.com> wrote:
> > > >
> > > > On Thu, May 5, 2022 at 6:08 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> > > > >
> > > > > We should use size of descriptor chain to test loop condition
> > > > > in the indirect case. And another statistical count is also introduced
> > > > > for indirect descriptors to avoid conflict with the statistical count
> > > > > of direct descriptors.
> > > > >
> > > > > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > > > > ---
> > > > >  drivers/vhost/vringh.c | 10 ++++++++--
> > > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > > > index 14e2043d7685..eab55accf381 100644
> > > > > --- a/drivers/vhost/vringh.c
> > > > > +++ b/drivers/vhost/vringh.c
> > > > > @@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > > > >              int (*copy)(const struct vringh *vrh,
> > > > >                          void *dst, const void *src, size_t len))
> > > > >  {
> > > > > -       int err, count = 0, up_next, desc_max;
> > > > > +       int err, count = 0, indirect_count = 0, up_next, desc_max;
> > > > >         struct vring_desc desc, *descs;
> > > > >         struct vringh_range range = { -1ULL, 0 }, slowrange;
> > > > >         bool slow = false;
> > > > > @@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > > > >                         continue;
> > > > >                 }
> > > > >
> > > > > -               if (count++ == vrh->vring.num) {
> > > > > +               if (up_next == -1)
> > > > > +                       count++;
> > > > > +               else
> > > > > +                       indirect_count++;
> > > > > +
> > > > > +               if (count > vrh->vring.num || indirect_count > desc_max) {
> > > > >                         vringh_bad("Descriptor loop in %p", descs);
> > > > >                         err = -ELOOP;
> > > > >                         goto fail;
> > > > > @@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > > > >                                 i = return_from_indirect(vrh, &up_next,
> > > > >                                                          &descs, &desc_max);
> > > > >                                 slow = false;
> > > > > +                               indirect_count = 0;
> > > >
> > > > Do we need to reset up_next to -1 here?
> > > >
> > >
> > > It will be reset to -1 in return_from_indirect().
> >
> > Right. Then
> >
> > Acked-by: Jason Wang <jasowang@redhat.com>
> >
> > Thanks
> >
> > >
> > > Thanks,
> > > Yongji
> > >
> >

