Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D124E52FA
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 14:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbiCWNXm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 09:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244240AbiCWNXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 09:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE3447CDFC
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648041731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=suvndhg5i90sE3alVpWaoy01Es5EJ/QlvWcm+elPd0I=;
        b=gKnZmccY1DbHQu2UBDe6WX7bI95sTIdY/HAPq/SmYPdnlJPEvM6Jkgn8SMLXn9KA7YLPQ6
        Qqk+CYyTupWrP2ligJhfOjFbB1WYYb/W48qaaxjw1EkSKTSCX5KYySglQcd7Ixmz4cAf4a
        7H6UGx7xPaBdtU1UZoRIAr93IdBF5G4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-oDtRnVfLOZWfE45l5M6Zbg-1; Wed, 23 Mar 2022 09:22:10 -0400
X-MC-Unique: oDtRnVfLOZWfE45l5M6Zbg-1
Received: by mail-wr1-f72.google.com with SMTP id d17-20020adfc3d1000000b00203e2ff73a6so507001wrg.8
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 06:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=suvndhg5i90sE3alVpWaoy01Es5EJ/QlvWcm+elPd0I=;
        b=HlJ68LB8rXl1LqpksX9VraKKipX7MWNRSzrXuGqaIkTo6NRLaTBKU8dMVoRtr5waHI
         ma/LMpjPT9J8WS9OoO4pkEKDICp4CDjxoc2rVna3E9A3ZMuuuJZDBcW6U1i9UMFuj48V
         r0gLJR24BQduN3xg9mA3nX4GsKkUKfntSFp0qi4hxMlb4N6jBKA+LSz/YM64dEm7HvFX
         RCZIMVb9yZTOVKI3orjR/KD+Dp7iqOBPUwLfGZVRtZWBAXT3Arbg0fgh98+ZfBI+9h/B
         odb8ACrx5C2yR2LdjukbdaJ8ngwsldsz0c5OZESo+qV/+nqJhPhn9tAddYZdTZZ4AU93
         iw6g==
X-Gm-Message-State: AOAM531hZKse/93TXsD5LoKCrwhySSTRH8cWCZfzCbtSM8lV6b2hXkzS
        BRf3A7Xi/9llLv1u27ipWoZ0902W4T2en+OhkVJ1gTXJzqfF3IKYzEXamud+bK4cTZaJXGZitGi
        C/FgCDylnxpLM
X-Received: by 2002:a05:6000:15c7:b0:205:87a2:87bc with SMTP id y7-20020a05600015c700b0020587a287bcmr2861190wry.260.1648041728538;
        Wed, 23 Mar 2022 06:22:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyp9kjUHrJnPA7iyjXS+pAxAeSdHIG+pVsNH4tY9VWV5thpBNO3b44rofEKgNXV0UAniIaJg==
X-Received: by 2002:a05:6000:15c7:b0:205:87a2:87bc with SMTP id y7-20020a05600015c700b0020587a287bcmr2861171wry.260.1648041728292;
        Wed, 23 Mar 2022 06:22:08 -0700 (PDT)
Received: from redhat.com ([2.55.151.118])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b0038ca32d0f26sm4091594wmq.17.2022.03.23.06.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 06:22:06 -0700 (PDT)
Date:   Wed, 23 Mar 2022 09:22:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <20220323092118-mutt-send-email-mst@kernel.org>
References: <20220323084954.11769-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323084954.11769-1-sgarzare@redhat.com>
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

On Wed, Mar 23, 2022 at 09:49:51AM +0100, Stefano Garzarella wrote:
> The first patch fixes a virtio-spec violation. The other two patches
> complete the driver configuration before using the VQs in the probe.
> 
> The patch order should simplify backporting in stable branches.

Ok but I think the order is wrong. It should be 2-3-1,
otherwise bisect can pick just 1 and it will have
the issues previous reviw pointed out.



> v2:
> - patch 1 is not changed from v1
> - added 2 patches to complete the driver configuration before using the
>   VQs in the probe [MST]
> 
> v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat.com/
> 
> Stefano Garzarella (3):
>   vsock/virtio: enable VQs early on probe
>   vsock/virtio: initialize vdev->priv before using VQs
>   vsock/virtio: read the negotiated features before using VQs
> 
>  net/vmw_vsock/virtio_transport.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> -- 
> 2.35.1

