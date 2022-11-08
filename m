Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C25C620C53
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 10:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiKHJfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 04:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiKHJfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 04:35:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259A9DF5E
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 01:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667900045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Las2jwQInbTqaGESYtOqR8ORil6cZe276BySoHxkoJo=;
        b=U9AIoGg4SNzEQ/Sy1cYTBbAGUxHgjPvRr/3/14mFdhxYfk+CHuzMTOACEMwO0NvGJe7o0l
        pYIDqVEYBp6FFEE1iC1gVqzzuAMpUoZKBpJ6xHcKhMKHae+p57dPgXtUKaxRkckFbyHm+R
        CMSOjxMD6dPui6k79rE29dA3uJLe8iM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-3k3fLt6EPy6JYqw1VZR7bg-1; Tue, 08 Nov 2022 04:34:03 -0500
X-MC-Unique: 3k3fLt6EPy6JYqw1VZR7bg-1
Received: by mail-wr1-f71.google.com with SMTP id r4-20020adfbb04000000b00236639438e9so3833250wrg.11
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 01:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Las2jwQInbTqaGESYtOqR8ORil6cZe276BySoHxkoJo=;
        b=TAB8x7YCvxCZVnkERMlYZF8dy06NuVqtU3102XkqghnVeG8NCuHe7LJwB+T7XJhBAF
         F73juoaq8a6aWPleQLWDkZ9dXma3zmx8UwSCw0t2zCfHUfU/nCCrFfZi91bsK5osO53o
         UWHVv4/lpNnKCuQsnKr15V0SIJ205kr0TU/Qv0ivQI0lpXesQJrfPbWbnrW3bT3lh75E
         NrSIvt03sntaJBRf5ThW6VBeyXL02YyYOWTQSnqiD9L/xLTxKAOjQNzKvzgVRtAcshKS
         tn+9sRg/p89hXE79smU8qFDxDYdNki5TtZ+5R2P2KI63NupDRS43w+Cpdy8j4jLvjCl7
         26dg==
X-Gm-Message-State: ACrzQf2BC76f3oWrxre2c4Ff0Il4EXhB0idC0Qpxf6e8hQ0+mKwBxHwY
        8q2zV9cO04ja7PS/Es+yK390fIEjUiNxOBNI1Kbp4EmL3L2Vn2+Da/WaNZ6nfxRf8r1vlcoDLaW
        Ze7TyE8uOWlp9
X-Received: by 2002:a05:6000:114e:b0:236:f365:b769 with SMTP id d14-20020a056000114e00b00236f365b769mr20584811wrx.266.1667900042449;
        Tue, 08 Nov 2022 01:34:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7PUbxzyZyAh4lu3TeI5npdnQRCKbagPaMHNYMKPGGmR4cOee7DVWQzcDxDyrBEiBASAFOWdQ==
X-Received: by 2002:a05:6000:114e:b0:236:f365:b769 with SMTP id d14-20020a056000114e00b00236f365b769mr20584800wrx.266.1667900042228;
        Tue, 08 Nov 2022 01:34:02 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id p20-20020a05600c359400b003a6a3595edasm11355392wmq.27.2022.11.08.01.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:34:01 -0800 (PST)
Date:   Tue, 8 Nov 2022 10:33:58 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: Fix error handling in vhost_vsock_init()
Message-ID: <20221108093358.4knnc6tlts7sm7a6@sgarzare-redhat>
References: <20221108091357.115738-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221108091357.115738-1-yuancan@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 09:13:57AM +0000, Yuan Can wrote:
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

Thanks for this fix!

>
>Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")

Is this the right tag?

It seems to me that since the introduction of vhost-vsock we have the 
same problem (to be solved differently, because with the introduction of 
multi-transport we refactored the initialization functions).

So should we use 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")?

Thanks,
Stefano

>Signed-off-by: Yuan Can <yuancan@huawei.com>
>---
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

