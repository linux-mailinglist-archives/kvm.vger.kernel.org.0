Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7587662100
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 10:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbjAIJI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 04:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbjAIJH7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 04:07:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E458E1B9D0
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 01:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673254833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ciW9YYwTiwLOjY3s3cXAhwyZejxqMBoqkbNB9AuORqI=;
        b=jNVl9DsYYvjiQeADeHt+6ueODc3Dqn3GbxBB52SV1J+VWwrTacFqL71R3A8RZQsdQ+Lvnb
        cqxhMtmBFsLTaLZfp4jp+yhMGALKdE3jkgS9Xwh+ePThp9+tx0gxZ1+9mGzpqPoXw1Zfow
        b2Tvgp3iw0uFU/xOM8J8yunQXZgS2/U=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-352-dnIQ9X4UMlO-xoIkz2zllg-1; Mon, 09 Jan 2023 04:00:29 -0500
X-MC-Unique: dnIQ9X4UMlO-xoIkz2zllg-1
Received: by mail-ot1-f71.google.com with SMTP id s22-20020a9d7596000000b0066eb4e77127so4138981otk.13
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 01:00:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciW9YYwTiwLOjY3s3cXAhwyZejxqMBoqkbNB9AuORqI=;
        b=bO3Mzk8ueFPHbQcaoQS/cCXmcK/yhxiiYwcbbFyuTpinS1o80evaKgXSqwL95ZFhna
         LX0Q1w63uzDhYgs8f40w6uzyFIpoZFZH2h7ibmmMLLhMPz1ZrHVlpP1vKbHAZFIrtBFP
         kBLeHRNqAXaRQAEdKB1oVZ9Y5+8z2OzVEsUbbK1M72tszqKBaArEORDWqBoCs3qFTAiC
         kGiS0SkTELBfpYiIElmCBxUsYJw/VNuJ+hxwC4o8sFw47eQNX+Eu3WeWEyWc95BEkTTE
         aITcit1AGFvSEfaIufT4InkVA9aVva/gG41CRduobSLun2xt4y1x5ayto7KIQzwjx/OS
         pyrg==
X-Gm-Message-State: AFqh2kofctcTJQOGbFNZLYhDd2kIfB1nf/ytdVwcuoP5lU6YJWg+xTIu
        eXxnSrpAojHd0gQgDSxLGH1/t0u7gdUfI1ZObtLSSXRrP4r+RUY8OWbSvc029Y71zQ858fRPikC
        u3xtloC2+rMr4D/aP3GttrO/KBKE5
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id u19-20020a056870441300b00144a97b1ae2mr3397918oah.35.1673254829168;
        Mon, 09 Jan 2023 01:00:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs3r6xZeYmx2QyOOAm/OSF4k+rcH2P78FK/uye9bebpGs3wKFdyeXk7nf1guSipnglxm3zqQ43faxDfLHs0f1A=
X-Received: by 2002:a05:6870:4413:b0:144:a97b:1ae2 with SMTP id
 u19-20020a056870441300b00144a97b1ae2mr3397915oah.35.1673254828989; Mon, 09
 Jan 2023 01:00:28 -0800 (PST)
MIME-Version: 1.0
References: <20230105070357.274-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20230105070357.274-1-liming.wu@jaguarmicro.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 Jan 2023 17:00:17 +0800
Message-ID: <CACGkMEtOAiV4v=-d1SA-wAVvD2WJyes3wWghpAJ9q0baG_aKGg@mail.gmail.com>
Subject: Re: [PATCH] vhost-test: remove meaningless debug info
To:     liming.wu@jaguarmicro.com
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 5, 2023 at 3:04 PM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> remove printk as it is meaningless.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vhost/test.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index bc8e7fb1e635..42c955a5b211 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -333,13 +333,10 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
>                         return -EFAULT;
>                 return 0;
>         case VHOST_SET_FEATURES:
> -               printk(KERN_ERR "1\n");
>                 if (copy_from_user(&features, featurep, sizeof features))
>                         return -EFAULT;
> -               printk(KERN_ERR "2\n");
>                 if (features & ~VHOST_FEATURES)
>                         return -EOPNOTSUPP;
> -               printk(KERN_ERR "3\n");
>                 return vhost_test_set_features(n, features);
>         case VHOST_RESET_OWNER:
>                 return vhost_test_reset_owner(n);
> --
> 2.25.1
>

