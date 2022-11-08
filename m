Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CEB620D34
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbiKHKZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiKHKZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:25:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617DFB873
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 02:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667903065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V0f6miHyfdXlJNB+m5URvLSjup5N3IeFlLnjD/c/Qow=;
        b=CjaDmi4y38HkQGWPIVIl9Q4tITaVICvfuKjBgoXm2JCrULlWnMzrI3U9DcFPx9xXkMZOJI
        6xeFPEJDYCyMNG05514nSikcDtYEyL54c4LT9a/oEXQaHoU22iVvw1xqQ49bYWj2qfQNMh
        kAMM+OYoWJX02qUzOKn3XnDtFlb3mWs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-621-hdDuqR36MHyK8zIgs50a2Q-1; Tue, 08 Nov 2022 05:24:24 -0500
X-MC-Unique: hdDuqR36MHyK8zIgs50a2Q-1
Received: by mail-wr1-f69.google.com with SMTP id o13-20020adfa10d000000b00232c00377a0so3847375wro.13
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 02:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0f6miHyfdXlJNB+m5URvLSjup5N3IeFlLnjD/c/Qow=;
        b=DRpxp6nhsafiAVNzN2v67NAV3fqB+3H6VzGiht9Ytz0S3L8WVqtiiQhg2XxYwuWBFG
         hXx5Zo/L62dNz75xuma12U/z2E3B90XEH9jHIkBB+D3inIbkFDcirTvKIExM4+HeJOzm
         G57Bzh2CYDt+7fhOeqhKzxzy93opYQA47vuXDa0uiHZ4rwJTlpd1xzX+JjkvESypU5k2
         71ovrUMSNV246Vmh3qZoYngfjMDJzQJc9EihGxvmuok4lQSrBHWBlQfHhTEnK1aiLVig
         DqLsIM7RYrlv6BDQjw6v8lnmNxTHK9LEmi56E6W45soXvmBM0OAc06RAUk1C8qE5tZHO
         eQiA==
X-Gm-Message-State: ACrzQf3aZe1UsqFvmdK74g/zfUCphVfqccNPR9o9eYe1ISxnGBMzVTYn
        vf0iPVwhvxYicQHvCKUMJQWgyeMULfZK/37J+aTjyROr2K+F9wZMAD5Ptqliesi2KXp+uAyE8hk
        ci9YntWHFt1It
X-Received: by 2002:a05:600c:2242:b0:3cf:4ccc:7418 with SMTP id a2-20020a05600c224200b003cf4ccc7418mr45909505wmm.191.1667903063322;
        Tue, 08 Nov 2022 02:24:23 -0800 (PST)
X-Google-Smtp-Source: AMsMyM63jNoqd/VARfO8cpeBbtfv5zYnABJ0tzkSvzQF3g0iN4WYdzewkQNJ5FZQKIEXIt6HCSt8Lw==
X-Received: by 2002:a05:600c:2242:b0:3cf:4ccc:7418 with SMTP id a2-20020a05600c224200b003cf4ccc7418mr45909493wmm.191.1667903063122;
        Tue, 08 Nov 2022 02:24:23 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id f10-20020a05600c154a00b003a2f2bb72d5sm19230518wmg.45.2022.11.08.02.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:24:22 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:24:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost/vsock: Fix error handling in vhost_vsock_init()
Message-ID: <20221108102419.tq4veo3h4xj3jr46@sgarzare-redhat>
References: <20221108101705.45981-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221108101705.45981-1-yuancan@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 10:17:05AM +0000, Yuan Can wrote:
>A problem about modprobe vhost_vsock failed is triggered with the
>following log given:
>
>modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy
>
>The reason is that vhost_vsock_init() returns misc_register() directly
>without checking its return value, if misc_register() failed, it returns
>without calling vsock_core_unregister() on vhost_transport, resulting the
>vhost_vsock can never be installed later.
>A simple call graph is shown as below:
>
> vhost_vsock_init()
>   vsock_core_register() # register vhost_transport
>   misc_register()
>     device_create_with_groups()
>       device_create_groups_vargs()
>         dev = kzalloc(...) # OOM happened
>   # return without unregister vhost_transport
>
>Fix by calling vsock_core_unregister() when misc_register() returns error.
>
>Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>Signed-off-by: Yuan Can <yuancan@huawei.com>
>---
>Changes in v2:
>- change to the correct Fixes: tag

I forgot to mention that anyway the patch was okay for me :-) and so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
> drivers/vhost/vsock.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5703775af129..10a7d23731fe 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -959,7 +959,14 @@ static int __init vhost_vsock_init(void)
> 				  VSOCK_TRANSPORT_F_H2G);
> 	if (ret < 0)
> 		return ret;
>-	return misc_register(&vhost_vsock_misc);
>+
>+	ret = misc_register(&vhost_vsock_misc);
>+	if (ret) {
>+		vsock_core_unregister(&vhost_transport.transport);
>+		return ret;
>+	}
>+
>+	return 0;
> };
>
> static void __exit vhost_vsock_exit(void)
>-- 
>2.17.1
>

