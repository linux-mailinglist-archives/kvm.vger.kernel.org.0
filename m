Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18D96222A1
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 04:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiKIDem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 22:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKIDek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 22:34:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86FD6362
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 19:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667964780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivtonRD5aoz1CKIuTlgMyAr3i3s0X8AlSd+W+AfcZ24=;
        b=Vqg82B5SenOSIgNZX1r7Ghtlx16TxLxkGwzy0wQ3PK5cAMKdIgTAf5d6H/265H0jnBCjjB
        HN1EHsMOJXKBokVSMuJ3PnxQPyvBN3FWyHK1DM4Royx7lyJ3tiy+JCT69CE5vnFEeGIhgo
        SoqR+u8lDqRTrEXUiyY+o3d5/kCGthk=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-326-EAlElG_nPNuOP6i4NB6xbQ-1; Tue, 08 Nov 2022 22:32:59 -0500
X-MC-Unique: EAlElG_nPNuOP6i4NB6xbQ-1
Received: by mail-oo1-f72.google.com with SMTP id g28-20020a4a251c000000b0049c515643ecso4489175ooa.14
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 19:32:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivtonRD5aoz1CKIuTlgMyAr3i3s0X8AlSd+W+AfcZ24=;
        b=xgIihkYNfaAXeLr1m7Pmg7VJrPZhC2xNlgZD2VJSUWdlI8q5ijSfgY1OhOrvT8VGew
         As7JSFHWUhWz1vP1e5eLuBCTVZvFgL5z2ORuBJdK0c4KJYni2g5xXp4RErXpM8U6jJBd
         t3N7sRWp49ni5g1df+dIlJTu6o2EkwZsB2S1rAdjfWwklE4A8X5/s/FvtdzmWX6hoH3x
         ZXuQr+kRFVDuftKeqNXjfpsVCFAauH2wbOeoeIKu3P8ulSFd2U+ZyZAFXoNt2RcnUCBV
         iWcFgD0FLbB9pl6CvVuIDTwOvmyZK1cFnw9XH9JW8rADicoVOviRJweHpOfRoWo8u2lH
         pqJg==
X-Gm-Message-State: ACrzQf1rccQv3o+v6oR5q8PUUcFOUxxsZ7MZ85Gg/fKi4evoB1L6fxQK
        feHir9w9XgSnLgL7TeSRkux/JwjMnd9UQflA9HwyRJW5b7fl87Mjb9Cu2NCQ2Vq4pqxxhh2fJ7A
        DvABSYFoEWoDKM5fR9FLn6qJ5H1co
X-Received: by 2002:a05:6870:9595:b0:132:7b3:29ac with SMTP id k21-20020a056870959500b0013207b329acmr761471oao.35.1667964777581;
        Tue, 08 Nov 2022 19:32:57 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5M8878AGpCqTVOaVFaPL3HZWvPRD0v5I0xFnMjQ8KJ1iwAp/N5riXwSLa+mgg2JddtpNM0glIl1LS7stO0moc=
X-Received: by 2002:a05:6870:9595:b0:132:7b3:29ac with SMTP id
 k21-20020a056870959500b0013207b329acmr761468oao.35.1667964777388; Tue, 08 Nov
 2022 19:32:57 -0800 (PST)
MIME-Version: 1.0
References: <20221108101705.45981-1-yuancan@huawei.com>
In-Reply-To: <20221108101705.45981-1-yuancan@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 11:32:45 +0800
Message-ID: <CACGkMEsce-TUjC+2H-jaky8=8A+r0sgF2Ti27Hr2YDmKeDpUHw@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: Fix error handling in vhost_vsock_init()
To:     Yuan Can <yuancan@huawei.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
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

On Tue, Nov 8, 2022 at 6:19 PM Yuan Can <yuancan@huawei.com> wrote:
>
> A problem about modprobe vhost_vsock failed is triggered with the
> following log given:
>
> modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy
>
> The reason is that vhost_vsock_init() returns misc_register() directly
> without checking its return value, if misc_register() failed, it returns
> without calling vsock_core_unregister() on vhost_transport, resulting the
> vhost_vsock can never be installed later.
> A simple call graph is shown as below:
>
>  vhost_vsock_init()
>    vsock_core_register() # register vhost_transport
>    misc_register()
>      device_create_with_groups()
>        device_create_groups_vargs()
>          dev = kzalloc(...) # OOM happened
>    # return without unregister vhost_transport
>
> Fix by calling vsock_core_unregister() when misc_register() returns error.
>
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> Changes in v2:
> - change to the correct Fixes: tag
>
>  drivers/vhost/vsock.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 5703775af129..10a7d23731fe 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -959,7 +959,14 @@ static int __init vhost_vsock_init(void)
>                                   VSOCK_TRANSPORT_F_H2G);
>         if (ret < 0)
>                 return ret;
> -       return misc_register(&vhost_vsock_misc);
> +
> +       ret = misc_register(&vhost_vsock_misc);
> +       if (ret) {
> +               vsock_core_unregister(&vhost_transport.transport);
> +               return ret;
> +       }
> +
> +       return 0;
>  };
>
>  static void __exit vhost_vsock_exit(void)
> --
> 2.17.1
>

