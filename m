Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E824E536A
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 14:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243828AbiCWNoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 09:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbiCWNox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 09:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8DE54E098
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 06:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IJHOsMD+p/TxrB7WMAz/bVsoyRgqHIkadq0oUUT9qqg=;
        b=guhqm6v26Z5AVpVYv02xLTClscv1t7+17sqda1y8ocDTtWoFukdkM8NOS1g2BcnmHSzHLd
        tkrGAFlB+bSW7G7t5g9SE/DEfR7Pda9t8BPG1Usm8NDO+Hiwgmuq8d4dCu8BqcOPVv7uqF
        t6vk6hl9QcnYkRn6BKMKcrcs4vOHouI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-VyBDIZbYN3W2_3VS3GRAcQ-1; Wed, 23 Mar 2022 09:43:20 -0400
X-MC-Unique: VyBDIZbYN3W2_3VS3GRAcQ-1
Received: by mail-qk1-f200.google.com with SMTP id y140-20020a376492000000b0067b14129a63so991240qkb.9
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 06:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IJHOsMD+p/TxrB7WMAz/bVsoyRgqHIkadq0oUUT9qqg=;
        b=vG0LaXIoNu/5KzCaSxFF0ING1hW8zuv7OlVJXas3hpLBnX41mU4Pc5iPc3imP3jSGa
         OqTvDM3Rq1mwzDl5herRjeSAUA/XzV4/tRbaBB8wE4xrp7S3uiKqLH/0BUSwkahnR1Nx
         0t+v18CSucoAt7lmmk/z3VQ7qy0vD3F1lSXk5KVVOtXULDmvojtTonG5vyfGkXJfVrXR
         BSab0f9YmrCIB0VE5AVwbWBfrNfxPY2mlsDzR4iU0zl5vchLJ6vZvREeeqoCmUe0mwT6
         3+jOQrKO65kw+vXRGOd5g1bED20y1wRiM6bCzvh0DmGyel5IK57bIH7DpbmAKh0XInLf
         1nug==
X-Gm-Message-State: AOAM532VIMLJsgDlhD5FHB50fqKCkYy1xtaXT3GCjEPapAgsfgmG149G
        2kHKOp4JKWCfApxIcibuhxbSZyYJjDJX2rhL8catHHQBWIYXUavN+ncco9nLN2XidBl6m27WLAT
        8P9PKyvm669tO
X-Received: by 2002:a05:622a:1111:b0:2e1:e831:2ee2 with SMTP id e17-20020a05622a111100b002e1e8312ee2mr23861901qty.264.1648043000028;
        Wed, 23 Mar 2022 06:43:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzn19Zj7+5jT24adJG336cYAb3ONCKQCObx38/CuWziIHD5QGZCRUCxyzDDeqQ7YzreKx5W0Q==
X-Received: by 2002:a05:622a:1111:b0:2e1:e831:2ee2 with SMTP id e17-20020a05622a111100b002e1e8312ee2mr23861884qty.264.1648042999740;
        Wed, 23 Mar 2022 06:43:19 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id 20-20020ac84e94000000b002e1d5505fb6sm54700qtp.63.2022.03.23.06.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:43:19 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:43:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <20220323134313.rmx24o3534rmgp3u@sgarzare-redhat>
References: <20220323084954.11769-1-sgarzare@redhat.com>
 <20220323092118-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220323092118-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 09:22:02AM -0400, Michael S. Tsirkin wrote:
>On Wed, Mar 23, 2022 at 09:49:51AM +0100, Stefano Garzarella wrote:
>> The first patch fixes a virtio-spec violation. The other two patches
>> complete the driver configuration before using the VQs in the probe.
>>
>> The patch order should simplify backporting in stable branches.
>
>Ok but I think the order is wrong. It should be 2-3-1,
>otherwise bisect can pick just 1 and it will have
>the issues previous reviw pointed out.

Right, I prioritized simplifying the backport, but obviously 
bisectability is priority!

I'll send v3 changing the order in 2-3-1

Thanks,
Stefano

