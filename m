Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4E3520F32
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 09:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbiEJH6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 03:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbiEJH60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 03:58:26 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB064244F03
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:54:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dk23so31264597ejb.8
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vye0u3dcZwbTnLfXvSCGn8z0ei03Wa9XvPoPd5FTMc=;
        b=agfwBlThL9GkcniR31AxYOFGFzTdHIAkkSiZxJSU9KCb7cz8mbmzllc4861BNLMCAd
         TTzkQ5vHFRvtnJVaJNA19dW9hhZ9H5ritWz3waF1wFGraqWPmugDHIihu6hgDWdLamQM
         ldiTJEt9RneOeZVeyjkyuZbq9Y+Axl+E7mOhsKo9AV4rtXBVR6CHayFVybiY6xP/Z4X3
         YxyyIKsKBVweUu4qqc4HwZOBESVC9za0kWBudSllOBSAgw/95wm6OfyZPS4++1No9SDh
         pdQeB63iTIrEwSU7PFQ1ga7cxQO/1efRC9ZcsZi3t3uXgUP904Xu2RxBfvFvF211jItl
         yV6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vye0u3dcZwbTnLfXvSCGn8z0ei03Wa9XvPoPd5FTMc=;
        b=ulx79QbZZzvs41NzaWtUWxizhXBBZOUNzS/Sd6giU71bewJJUAYxEMMDBR6nd7Upgy
         6NhNmL0bYuxy9PloIyLXYGgeLtzbQyTrRglbEQOLRbjMsamgU6LuXiYfArT+SMuSKF29
         aKk4zQrqhRMhVCoool4Qr3ODJrKZ2H3bJP2inKBSMPD1dBH7BzYdogM7VliunxPD9r9W
         c6n1jeWTE2kG8xdJ/6PJBkws8qcWCMyTZTKELh/XRw9q7n2tXkyDB6x1cBEvLsx5W4CL
         nNmj15WP/dtq0mtzBrH9TjQudcBpADMUswjGbonzJ4vaGG2iBYC6ZyNwNFqGdNdYMW4V
         X/Xw==
X-Gm-Message-State: AOAM5337/EbXAniDzn3axatwMs6O8ou72rO734Zxxo41feZ4e9xyB+jg
        63rFgaqCdpvZKPGwmztdPoZInBWCfUmRFuMe/TgqXrSMrhJw
X-Google-Smtp-Source: ABdhPJy/fqPPV4jkBUl8DQ/7eoGKWbtVHgiITR8jkk3Tvg6I1o7I/BqP1ikg+9i91O29FQHWroZT2vpEzyg6++1gvbA=
X-Received: by 2002:a17:906:699:b0:6f3:a7a3:d3 with SMTP id
 u25-20020a170906069900b006f3a7a300d3mr18711465ejb.650.1652169258503; Tue, 10
 May 2022 00:54:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220505100910.137-1-xieyongji@bytedance.com> <CACGkMEv3Ofbu7OOTB9vN2Lt85TD44LipjoPm26KEq3RiKJU0Yw@mail.gmail.com>
In-Reply-To: <CACGkMEv3Ofbu7OOTB9vN2Lt85TD44LipjoPm26KEq3RiKJU0Yw@mail.gmail.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 10 May 2022 15:54:55 +0800
Message-ID: <CACycT3uakPB_JeXb11hrBaPjcdqign3FmuQd3FXgFR7orO_Eaw@mail.gmail.com>
Subject: Re: [PATCH v2] vringh: Fix loop descriptors check in the indirect cases
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

On Tue, May 10, 2022 at 3:44 PM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, May 5, 2022 at 6:08 PM Xie Yongji <xieyongji@bytedance.com> wrote:
> >
> > We should use size of descriptor chain to test loop condition
> > in the indirect case. And another statistical count is also introduced
> > for indirect descriptors to avoid conflict with the statistical count
> > of direct descriptors.
> >
> > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> > ---
> >  drivers/vhost/vringh.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 14e2043d7685..eab55accf381 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >              int (*copy)(const struct vringh *vrh,
> >                          void *dst, const void *src, size_t len))
> >  {
> > -       int err, count = 0, up_next, desc_max;
> > +       int err, count = 0, indirect_count = 0, up_next, desc_max;
> >         struct vring_desc desc, *descs;
> >         struct vringh_range range = { -1ULL, 0 }, slowrange;
> >         bool slow = false;
> > @@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >                         continue;
> >                 }
> >
> > -               if (count++ == vrh->vring.num) {
> > +               if (up_next == -1)
> > +                       count++;
> > +               else
> > +                       indirect_count++;
> > +
> > +               if (count > vrh->vring.num || indirect_count > desc_max) {
> >                         vringh_bad("Descriptor loop in %p", descs);
> >                         err = -ELOOP;
> >                         goto fail;
> > @@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
> >                                 i = return_from_indirect(vrh, &up_next,
> >                                                          &descs, &desc_max);
> >                                 slow = false;
> > +                               indirect_count = 0;
>
> Do we need to reset up_next to -1 here?
>

It will be reset to -1 in return_from_indirect().

Thanks,
Yongji
