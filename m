Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF0851B96C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 09:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243463AbiEEHuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 03:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242896AbiEEHum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 03:50:42 -0400
X-Greylist: delayed 345 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 May 2022 00:47:03 PDT
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93A081DA55
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 00:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651736822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j+el8V1xMUirJQUv2r3o0pzphH83zFlz8WJOJ63XP1Q=;
        b=EXAKVlIQ0/HaxoKiIEwqRzq7u7PuPmyOAZxXd6Ot8rjMi2AV0OoqK/xpSuaijRx5Gxio8K
        +GVR53FDLM6b9KqLa4JtFjXd8YdzL9e2FyTKR9xD/4UrBTmxMHrXlrkFkhmMRv/ZM20EbA
        eMKiWn9f1AomKSa/+9JAsTwAMaCXvnI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-zCc4MuHTPtuWzLNvQY1bgg-1; Thu, 05 May 2022 03:47:01 -0400
X-MC-Unique: zCc4MuHTPtuWzLNvQY1bgg-1
Received: by mail-lj1-f199.google.com with SMTP id q7-20020a2e8747000000b0024f2d363986so1124006ljj.5
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 00:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j+el8V1xMUirJQUv2r3o0pzphH83zFlz8WJOJ63XP1Q=;
        b=lSbHPuQaFJOUN4iA1rnsiGXVyYw0Tqm21FgmJ7wRPX9bWfhB9M4cinLjXekJm+OcFf
         hGGsAJQ1ocXrQl0+xBM1sLQgap2INtDNHsYF0o6vc1ALgNZKgTSbDaIxs3VqM/3AfgQI
         wFtR8IFSFCnlAHplJxlUo5tQyrPBTGfPmkZ/g8FL0ACTmC270eZ0885BhB3xVlVS+5aV
         E1nciHqzFwyf5wZIxCFMEEOU3FRpfel9llY6luGeb0L3EhSYSdgk9ej8hAwSQIZB2cmV
         p+3Eue0TmdN7oxrXYpKlXt/YpJduPt5pMCzDFPK5fRFf1EmNUIMwnwbNaZvzmHwsOcs/
         EPMQ==
X-Gm-Message-State: AOAM533aDKglsaHrTo2UwqPW4EQ1NNA41BM6BW/8iHi27JwkGkpcQTMZ
        QLEcPzXoeffRPinmxaatCFmOJuShSVeZJnRbLobdmU7cczHuigInDPj89Eu/eR8OrAydGRk+d2A
        WZdjEVPmaAeGQzhWsDflruTvKyHGp
X-Received: by 2002:a05:6512:b81:b0:448:b342:513c with SMTP id b1-20020a0565120b8100b00448b342513cmr16864512lfv.257.1651736819938;
        Thu, 05 May 2022 00:46:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo3YA6g05X5pjwguq4bRI8kfZwD9pTqEzAjIvoSY4GZJXUuPL2nx0FsFK/zLQo8qSKYRPgS/lBOpjBIzD0OgM=
X-Received: by 2002:a05:6512:b81:b0:448:b342:513c with SMTP id
 b1-20020a0565120b8100b00448b342513cmr16864505lfv.257.1651736819762; Thu, 05
 May 2022 00:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220504081117.40-1-xieyongji@bytedance.com>
In-Reply-To: <20220504081117.40-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 5 May 2022 15:46:48 +0800
Message-ID: <CACGkMEvdVFP2GkTy2Vxe44xZ+6BOU3FM5WccuHe-32FN1Pm=7A@mail.gmail.com>
Subject: Re: [PATCH] vringh: Fix maximum number check for indirect descriptors
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

On Wed, May 4, 2022 at 4:12 PM Xie Yongji <xieyongji@bytedance.com> wrote:
>
> We should use size of descriptor chain to check the maximum
> number of consumed descriptors in indirect case.

AFAIK, it's a guard for loop descriptors.

> And the
> statistical counts should also be reset to zero each time
> we get an indirect descriptor.

What might happen if we don't have this patch?

>
> Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Signed-off-by: Fam Zheng <fam.zheng@bytedance.com>
> ---
>  drivers/vhost/vringh.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 14e2043d7685..c1810b77a05e 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -344,12 +344,13 @@ __vringh_iov(struct vringh *vrh, u16 i,
>                         addr = (void *)(long)(a + range.offset);
>                         err = move_to_indirect(vrh, &up_next, &i, addr, &desc,
>                                                &descs, &desc_max);
> +                       count = 0;

Then it looks to me we can detect a loop indirect descriptor chain?

Thanks

>                         if (err)
>                                 goto fail;
>                         continue;
>                 }
>
> -               if (count++ == vrh->vring.num) {
> +               if (count++ == desc_max) {
>                         vringh_bad("Descriptor loop in %p", descs);
>                         err = -ELOOP;
>                         goto fail;
> @@ -410,6 +411,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
>                         if (unlikely(up_next > 0)) {
>                                 i = return_from_indirect(vrh, &up_next,
>                                                          &descs, &desc_max);
> +                               count = 0;
>                                 slow = false;
>                         } else
>                                 break;
> --
> 2.20.1
>

