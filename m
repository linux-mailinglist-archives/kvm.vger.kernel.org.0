Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06DEC7A04FD
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 15:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238717AbjINNHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 09:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238675AbjINNHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 09:07:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A3A41FD9
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694696785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X/pGng4Jlz5jKGWmwVqa99A3qKH6EyoanXPEX+/wRiw=;
        b=hIRVVVOzKiwgVi2u5A31m4hbSkkKjOsCcwEMo3YF2ynF969HokJTRo83QQm436VsU4RlMh
        FlOxZoqZvMtAtR1KbYi9vKbEpTeZScmgp/BjxmvpxCDCgknoivMek3sm/ZZqMEPO4nM8fV
        4OUCCXo4aMscBy4L5GQ3H2YND1drdHg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-1DGsIEI9Ooylc07uZA41hg-1; Thu, 14 Sep 2023 09:06:23 -0400
X-MC-Unique: 1DGsIEI9Ooylc07uZA41hg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-2f2981b8364so570141f8f.1
        for <kvm@vger.kernel.org>; Thu, 14 Sep 2023 06:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694696782; x=1695301582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/pGng4Jlz5jKGWmwVqa99A3qKH6EyoanXPEX+/wRiw=;
        b=r9bTCK0mUIjxecbuwLmnoyaqbqsMv/YC7KUDllvZuKmJcym9u5/MUaM0QOTU0UjTjD
         AyN+GmYGUeByBZMBrLc7NNsCfwvkRw+5pnmdzEnHIfca0flFnDmSzsjmnExpvHii5UV5
         5MvtkC9ndoFKcfRBQ3axcI3xNVlXArAkUeR3nrLitfDXulMNijCaBar5Ko3nuhKB8+kR
         2GE0oPIhZW+4jToX9XEAg6l1uu/ZWTVbVktR7LsjI2fQ+kAWXiBx++NMq/7w21p0JFCN
         1xwIHZXb2itMx49H76eokfkaSL5FSUmytLJLI5Oe1UKSFUVRJ0z1OeGbSZ7Wfr5YXw6R
         aXdg==
X-Gm-Message-State: AOJu0YyvwlN1pkWHq9hxMe7oGjshqY2/S9qwH5yB69qtGoR3No8f9D82
        bJxiVRyw49SjSY86BWOa/8dH90Ziz+EDKyu+Dybx+3idmjE9xS6bDgCMrnJH3EXOJcVbdKsk3+4
        G1tXnyyT/zAsw
X-Received: by 2002:a5d:6752:0:b0:31f:b91c:6ebc with SMTP id l18-20020a5d6752000000b0031fb91c6ebcmr4442865wrw.14.1694696782740;
        Thu, 14 Sep 2023 06:06:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMprSt5Eq7z2+zyD9pVdEhDhOcN3K4FFKy92OAHwhT7/UABz6yxx0vX6SGjsriWT02u92rgg==
X-Received: by 2002:a5d:6752:0:b0:31f:b91c:6ebc with SMTP id l18-20020a5d6752000000b0031fb91c6ebcmr4442801wrw.14.1694696781669;
        Thu, 14 Sep 2023 06:06:21 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.114.183])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c22c400b00403b63e87f2sm1940671wmg.32.2023.09.14.06.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 06:06:21 -0700 (PDT)
Date:   Thu, 14 Sep 2023 15:06:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v8 2/4] vsock/virtio: support to send non-linear
 skb
Message-ID: <nzguzjuchyk5uwdnexegayweyogv5wdfgaxrrw47fuw2rjkumq@4ybro57ixsga>
References: <20230911202234.1932024-1-avkrasnov@salutedevices.com>
 <20230911202234.1932024-3-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230911202234.1932024-3-avkrasnov@salutedevices.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 11:22:32PM +0300, Arseniy Krasnov wrote:
>For non-linear skb use its pages from fragment array as buffers in
>virtio tx queue. These pages are already pinned by 'get_user_pages()'
>during such skb creation.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v2 -> v3:
>  * Comment about 'page_to_virt()' is updated. I don't remove R-b,
>    as this change is quiet small I guess.
> v6 -> v7:
>  * Move arrays '*sgs' and 'bufs' to 'virtio_vsock' instead of being
>    local variables. This allows to save stack space in cases of too
>    big MAX_SKB_FRAGS.
>  * Add 'WARN_ON_ONCE()' for handling nonlinear skbs - it checks that
>    linear part of such skb contains only header.
>  * R-b tag removed due to updates above.
> v7 -> v8:
>  * Add comment in 'struct virtio_vsock' for both 'struct scatterlist'
>    fields.
>  * Rename '*sgs' and 'bufs' to '*out_sgs' and 'out_bufs'.
>  * Initialize '*out_sgs' in 'virtio_vsock_probe()' by always pointing
>    to the corresponding element of 'out_bufs'.

LGTM, thanks for addressing that comments!

>
> net/vmw_vsock/virtio_transport.c | 60 ++++++++++++++++++++++++++++----
> 1 file changed, 53 insertions(+), 7 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

