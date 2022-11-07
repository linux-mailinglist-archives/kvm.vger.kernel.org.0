Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3973A61FFAE
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 21:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbiKGUnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 15:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbiKGUnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 15:43:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF43829C83
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 12:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667853732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=evzlFbUTnO3GwUjJoQCN6EwhyV6gOnjO3o6XcJLyk7g=;
        b=V1V/0T60pxAWcPdNX8u1t3584GMXn5gEbpa+BnmX9e1S1Hcv0XXfNEcO9hhhY3wU4SmWaT
        KNNOz7tBtTn2f9snBTNGd87lP+g1av4cjVSpAjMNA6ZzxOukR07hyKsgYjXml6HMVDwKXr
        SkIIvRjSkd6FQ7d/u5cFWfLnpmX45F8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-522-nzaLirSENE-b3shYVeXcPA-1; Mon, 07 Nov 2022 15:42:10 -0500
X-MC-Unique: nzaLirSENE-b3shYVeXcPA-1
Received: by mail-wr1-f70.google.com with SMTP id w23-20020adf8bd7000000b002358f733307so3217863wra.17
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 12:42:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evzlFbUTnO3GwUjJoQCN6EwhyV6gOnjO3o6XcJLyk7g=;
        b=w93IoaI2GQ1qyLA/EYgTJasQM55+9E2ADMq/3IRLLW7TCrJPXJc391Dg3yQdusaOWN
         0nK20QKLO5OiwJEUSjXr30koN11CJWEFLRefz4tu+EZGnNXsLTE0/qsJkgXySJxs+DQm
         +9HmZCX39Gw7a/nW9drlx3+V1TqnRTGWy343hY+NcTI78hB8w8e9ZEYQ3cedLqu8L/Z0
         A/Un1iwHF2JJNv+JecjwUGq8hfbIBipXDSH+BpDnSSNucrpt7Xbm/VnORv7cDcoyzIoA
         WIkWJR47Is8gKYSupA8Y37geMXB9jcV7Qo+28ee3Qe25JELrT5OinRc36SrhNXfKCpgx
         FwRQ==
X-Gm-Message-State: ACrzQf0Lru9bG9oh+83XUCyVjJ4+eH1Ame73DJ8bSz2dbHBy5+8Ob0PI
        w0cQMMEKfM2JsZ7n1IMp49JQ+Y/v9WS5oeyBJJatqVtKY1t9laBa7O1mOkKhJ+O0vufUq3afjrZ
        qHai/RzQO6Tfw
X-Received: by 2002:a5d:4e88:0:b0:236:590:f5a9 with SMTP id e8-20020a5d4e88000000b002360590f5a9mr30678057wru.126.1667853729524;
        Mon, 07 Nov 2022 12:42:09 -0800 (PST)
X-Google-Smtp-Source: AMsMyM6WrUGrbJ5bDelW9gjzQbAoXk9wPLV0dNxhMA028zBS3d1N8r/SEQc4SPIPfwfT8tBzm7vyBA==
X-Received: by 2002:a5d:4e88:0:b0:236:590:f5a9 with SMTP id e8-20020a5d4e88000000b002360590f5a9mr30678048wru.126.1667853729282;
        Mon, 07 Nov 2022 12:42:09 -0800 (PST)
Received: from redhat.com ([169.150.226.212])
        by smtp.gmail.com with ESMTPSA id v14-20020adfedce000000b00236883f2f5csm8369250wro.94.2022.11.07.12.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:42:08 -0800 (PST)
Date:   Mon, 7 Nov 2022 15:42:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [RFC] vhost: Clear the pending messages on
 vhost_init_device_iotlb()
Message-ID: <20221107153924-mutt-send-email-mst@kernel.org>
References: <20221107203431.368306-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107203431.368306-1-eric.auger@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 07, 2022 at 09:34:31PM +0100, Eric Auger wrote:
> When the vhost iotlb is used along with a guest virtual iommu
> and the guest gets rebooted, some MISS messages may have been
> recorded just before the reboot and spuriously executed by
> the virtual iommu after the reboot. Despite the device iotlb gets
> re-initialized, the messages are not cleared. Fix that by calling
> vhost_clear_msg() at the end of vhost_init_device_iotlb().
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  drivers/vhost/vhost.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..422a1fdee0ca 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1751,6 +1751,7 @@ int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled)
>  	}
>  
>  	vhost_iotlb_free(oiotlb);
> +	vhost_clear_msg(d);
>  
>  	return 0;
>  }

Hmm.  Can't messages meanwhile get processes and affect the
new iotlb?


> -- 
> 2.37.3

