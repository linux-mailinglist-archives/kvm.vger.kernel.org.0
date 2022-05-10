Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDBF520EF2
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 09:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbiEJHtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 03:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiEJHso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 03:48:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A210923F389
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652168651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BlIci0CNep+wUrkQW4AUVcPk7iMZk76yZupgc0VUTvc=;
        b=aW9mywZaLC5/KN57zKmR75XHXaV+5SyjAly6eKBInAW4SmhZMYVclTFBu3Lnihz+A+qZFE
        0RIqtv+7P+uyuKPsOtU+AsVwa3ZJTsU/aypXIkzX/6wLk6DjPLYuHhCn+Nn8Uhh2v46msP
        wGkkkApZxWpMl20b7uDXH5jHqwtlYK8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-8JVz-4_PN--TfHu0ucdw-w-1; Tue, 10 May 2022 03:44:10 -0400
X-MC-Unique: 8JVz-4_PN--TfHu0ucdw-w-1
Received: by mail-lf1-f69.google.com with SMTP id c15-20020a056512238f00b00473a118e7a7so6890120lfv.18
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 00:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BlIci0CNep+wUrkQW4AUVcPk7iMZk76yZupgc0VUTvc=;
        b=Mo0yGfr1XJ3cTJwu9WcUCFbMDwrLoB81njB9Z2rPrsQsv/YfttdcKPQLo/hMJJSZ6E
         NXi2h390E5yoQDBV5gs6bIDudLy0BEqbfZP3oZuYE4yL2wRdCEpS+TqGJrQrBtWDrwCu
         B2JkkHV3wqcfYuDUH5HetU6pVkc63ALDxMrOy2kz0QTS7su8RvOYYQq0LBmJ90IzFnih
         efPNYPycnHt1mWvTPy4/Z2Fo3WLUp9QPyDjkDdAWCWSYi30KoUdirHX5AtC86TXmDOdx
         X6qTmIxOtFkYl593JjXy5hduSIxXFIwbmyHPBkKYA8yx2sdON+EQ2RlzTwab/mupikQI
         E+nA==
X-Gm-Message-State: AOAM531I0OnFMWux4vMdHweV9YFx9kCeCIQTi1BNVfx+GxnlXLbRZPrK
        N8svCPy/8BhIl7AhT42oUH7cdlMWjRy9FhxetEhVCCZoYFgtnb/+qe4GHpb0+uUXCD5/Ctz/Ep4
        qBLMcetrn4/n88r86K4eYGvjlSrfA
X-Received: by 2002:a2e:9698:0:b0:24f:14da:6a59 with SMTP id q24-20020a2e9698000000b0024f14da6a59mr13648646lji.73.1652168648517;
        Tue, 10 May 2022 00:44:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygBKTQ1tWgHWbzhGASQpmN3PyPzyFzMva5OVPLIN/NuPJga8PT9LebRImJkl5usaxcBpwgh5iqnPLxiNqYoO8=
X-Received: by 2002:a2e:9698:0:b0:24f:14da:6a59 with SMTP id
 q24-20020a2e9698000000b0024f14da6a59mr13648637lji.73.1652168648340; Tue, 10
 May 2022 00:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220505100910.137-1-xieyongji@bytedance.com>
In-Reply-To: <20220505100910.137-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 May 2022 15:43:57 +0800
Message-ID: <CACGkMEv3Ofbu7OOTB9vN2Lt85TD44LipjoPm26KEq3RiKJU0Yw@mail.gmail.com>
Subject: Re: [PATCH v2] vringh: Fix loop descriptors check in the indirect cases
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst <mst@redhat.com>, rusty <rusty@rustcorp.com.au>,
        fam.zheng@bytedance.com, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 5, 2022 at 6:08 PM Xie Yongji <xieyongji@bytedance.com> wrote:
>
> We should use size of descriptor chain to test loop condition
> in the indirect case. And another statistical count is also introduced
> for indirect descriptors to avoid conflict with the statistical count
> of direct descriptors.
>
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> ---
>  drivers/vhost/vringh.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 14e2043d7685..eab55accf381 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
>              int (*copy)(const struct vringh *vrh,
>                          void *dst, const void *src, size_t len))
>  {
> -       int err, count = 0, up_next, desc_max;
> +       int err, count = 0, indirect_count = 0, up_next, desc_max;
>         struct vring_desc desc, *descs;
>         struct vringh_range range = { -1ULL, 0 }, slowrange;
>         bool slow = false;
> @@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
>                         continue;
>                 }
>
> -               if (count++ == vrh->vring.num) {
> +               if (up_next == -1)
> +                       count++;
> +               else
> +                       indirect_count++;
> +
> +               if (count > vrh->vring.num || indirect_count > desc_max) {
>                         vringh_bad("Descriptor loop in %p", descs);
>                         err = -ELOOP;
>                         goto fail;
> @@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
>                                 i = return_from_indirect(vrh, &up_next,
>                                                          &descs, &desc_max);
>                                 slow = false;
> +                               indirect_count = 0;

Do we need to reset up_next to -1 here?

Thanks

>                         } else
>                                 break;
>                 }
> --
> 2.20.1
>

