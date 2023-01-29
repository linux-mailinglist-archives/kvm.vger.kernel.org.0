Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7F368009B
	for <lists+kvm@lfdr.de>; Sun, 29 Jan 2023 18:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbjA2R7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Jan 2023 12:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjA2R7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Jan 2023 12:59:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C53B771
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 09:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675015096;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZoRK9BZ3t2Wi1ix9FutdV7vK4dm+2rgUqjlwcOivCI=;
        b=Z9WxSd49v3S8loVGffNDYQaJURpbgDdcvDsrU8rbs0q5XTcVe+9wQ9nA6Zc6GaQUYpBTRT
        0F+nBWtL/zWPKdow0pmi7QZrcpX+iruEaXRYwc+718E9pLmRNno0qS20NBEmAIRd87o6U4
        uKpEv6Dl7MpHA6dbBYgw6zKmhRH9aWA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-296-NLaCEBUXPNy3-oMCCPI2Vw-1; Sun, 29 Jan 2023 12:58:13 -0500
X-MC-Unique: NLaCEBUXPNy3-oMCCPI2Vw-1
Received: by mail-qk1-f199.google.com with SMTP id bm30-20020a05620a199e00b007090f3c5ec0so6259828qkb.21
        for <kvm@vger.kernel.org>; Sun, 29 Jan 2023 09:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZoRK9BZ3t2Wi1ix9FutdV7vK4dm+2rgUqjlwcOivCI=;
        b=dnoIP/KsLD7mYr122PXiNq1LPhRsOR+wPl6IjVESHBr0KZoWUbqIIB4qOZEDWuBn++
         /TK3ozFeGEdkTMJB9y9/7bjNHw9fyItcgaRjQEz5xRdJXrDisyJEdW2hqLAP1dX1bEd5
         4SwX577Yf5pVIH98rsmLXjNd4XvxS/RqGy+7l6/CbAmfMkHyQZcGaMoTCPKd+Im6D1f0
         IkUVQd31E9LUMq1UmUQ2OSXwB0jbjWXFyvm8KiyLL8I1Z4KnC9jkAxGPEOb3S4Ah0NPv
         U9FHvCiPhmfPI1LqtISjaPyEU4XCZGWg+iJzIgvwJTcxAK+juzc+0n7o9WXIgyK8Ql5R
         lmSA==
X-Gm-Message-State: AO0yUKXW4n8JxB4SvJVtqMDzv0jD6erjRbVun8Qt4Ma1BFg2jzGDKqei
        JXKCRfwz0fmkK9aAJ7dWH1c0gMG/KARwkJPneBysxjZkJ5Mv6FjRel+l2yrqW5AC0TNOhAs36NL
        KdFiTeXH5+X7d
X-Received: by 2002:ac8:5f50:0:b0:3b8:2a6c:d1e4 with SMTP id y16-20020ac85f50000000b003b82a6cd1e4mr14798111qta.23.1675015093345;
        Sun, 29 Jan 2023 09:58:13 -0800 (PST)
X-Google-Smtp-Source: AK7set81mP2q7yHpiOp5TTYBWsJ3krnk4K3MhdR8gsDVQLP3L1zEgo8bkLBq0lFX+0cwwTn5XuracA==
X-Received: by 2002:ac8:5f50:0:b0:3b8:2a6c:d1e4 with SMTP id y16-20020ac85f50000000b003b82a6cd1e4mr14798091qta.23.1675015093057;
        Sun, 29 Jan 2023 09:58:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t3-20020ac86a03000000b003a591194221sm4257080qtr.7.2023.01.29.09.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 09:58:12 -0800 (PST)
Message-ID: <3fe5971a-5991-488f-cef5-473c9faa1ba1@redhat.com>
Date:   Sun, 29 Jan 2023 18:58:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 0/2] vhost/net: Clear the pending messages when the
 backend is removed
Content-Language: en-US
To:     eric.auger.pro@gmail.com, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     peterx@redhat.com, lvivier@redhat.com
References: <20230117151518.44725-1-eric.auger@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117151518.44725-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/17/23 16:15, Eric Auger wrote:
> When the vhost iotlb is used along with a guest virtual iommu
> and the guest gets rebooted, some MISS messages may have been
> recorded just before the reboot and spuriously executed by
> the virtual iommu after the reboot. This is due to the fact
> the pending messages are not cleared.
>
> As vhost does not have any explicit reset user API,
> VHOST_NET_SET_BACKEND looks a reasonable point where to clear
> the pending messages, in case the backend is removed (fd = -1).
>
> This version is a follow-up on the discussions held in [1].
>
> The first patch removes an unused 'enabled' parameter in
> vhost_init_device_iotlb().

Gentle Ping. Does it look a reasonable fix now?

Thanks

Eric
>
> Best Regards
>
> Eric
>
> History:
> [1] RFC: [RFC] vhost: Clear the pending messages on vhost_init_device_iotlb()
> https://lore.kernel.org/all/20221107203431.368306-1-eric.auger@redhat.com/
>
> Eric Auger (2):
>   vhost: Remove the enabled parameter from vhost_init_device_iotlb
>   vhost/net: Clear the pending messages when the backend is removed
>
>  drivers/vhost/net.c   | 5 ++++-
>  drivers/vhost/vhost.c | 5 +++--
>  drivers/vhost/vhost.h | 3 ++-
>  3 files changed, 9 insertions(+), 4 deletions(-)
>

