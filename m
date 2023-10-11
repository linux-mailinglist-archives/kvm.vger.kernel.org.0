Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294A17C549C
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjJKM7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346939AbjJKM6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A006D98
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697029086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=srINTOA9TWB2isXW3Sgrz+IUFVxpno9ZCmYhECMZXz8=;
        b=FSpCPp3gxoRf0ep/in/nq98TWJocZURqWWmikeA5tokQXNTXzAIyDMOj3igQ9LtBWKn1sc
        eh8/xS8eT6RVwMNzrPPP5o/ESpXc+9BWRuX5K8UkJGG7T8/dghNDRzGk1LOB+FjARGQg1s
        HYQN0bNLEu/HsiWod6jC1acnAlXe0vw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-IwEqXl1FOeK3nPt_PhMOeQ-1; Wed, 11 Oct 2023 08:58:05 -0400
X-MC-Unique: IwEqXl1FOeK3nPt_PhMOeQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-77422b0e373so742305685a.3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697029085; x=1697633885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srINTOA9TWB2isXW3Sgrz+IUFVxpno9ZCmYhECMZXz8=;
        b=aBWL/n9ccLDoTCKaKRZ+iGsX1rs41o8nabamqk9tWj1oQVzQYNfn42wn2IJhT5QBsu
         yFh7Jl1UzyNizV3DuyQ2gelkGV3mWGLnXOKd7pWpjusBa5FQ4QjY2dj8FQCb9UiY+UvA
         YsarRnOE8nG5djjzhFF/Y+AjIxyowQ08vDRF08lPUQTJHu6dERohPkuntIh0GABaNZz+
         L5F3cAcivpbABdkHzAxXeSEQaIW8lxsBGg0mbF0EQ51olq+h+iT++417Pp20N6yl19Eo
         PMoq5bREwJAcWEkI2rP7BiTQymFgeuBSloKLovecp4U2o2T8fWrADAlfKr60pUNMQJx3
         zU4w==
X-Gm-Message-State: AOJu0YxxrHyQ+ltxp1TFuA84PtkcRNNv2JFvKJ4mG4nN8TAjp9rqGfC7
        mpcnNnZW9GY31ULd23k01ckabv+pMSIYxoN6j4pjMm3lXpIz1sexDj/U4TKolHU9p8wHMyvkx9f
        WjL2/MhYF5JMD
X-Received: by 2002:a05:620a:28c1:b0:772:64b3:889f with SMTP id l1-20020a05620a28c100b0077264b3889fmr23924385qkp.29.1697029085393;
        Wed, 11 Oct 2023 05:58:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEat3sMaNphExceyLByW9stmPTXf2ifIIJ9bDX8SUeZpYDbCXHEF5UpdzIbTW2PMO+Wgc/Bfg==
X-Received: by 2002:a05:620a:28c1:b0:772:64b3:889f with SMTP id l1-20020a05620a28c100b0077264b3889fmr23924364qkp.29.1697029085125;
        Wed, 11 Oct 2023 05:58:05 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-251.retail.telecomitalia.it. [79.46.200.251])
        by smtp.gmail.com with ESMTPSA id u16-20020a05620a121000b0076cdc3b5beasm5193811qkj.86.2023.10.11.05.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 05:58:04 -0700 (PDT)
Date:   Wed, 11 Oct 2023 14:57:57 +0200
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
Subject: Re: [PATCH net-next v4 00/12] vsock/virtio: continue MSG_ZEROCOPY
 support
Message-ID: <eey4hfz43popgwlwtheapjefzmxea7dk733y3v6aqsrewhq3mq@lcmmhdpwvvzc>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:15:12PM +0300, Arseniy Krasnov wrote:
>Hello,
>
>this patchset contains second and third parts of another big patchset
>for MSG_ZEROCOPY flag support:
>https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/
>
>During review of this series, Stefano Garzarella <sgarzare@redhat.com>
>suggested to split it for three parts to simplify review and merging:
>
>1) virtio and vhost updates (for fragged skbs) (merged to net-next, see
>   link below)
>2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
>   tx completions) and update for Documentation/. <-- this patchset
>3) Updates for tests and utils. <-- this patchset
>
>Part 1) was merged:
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7
>
>Head for this patchset is:
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=19537e125cc7cf2da43a606f5bcebbe0c9aea4cc
>
>Link to v1:
>https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
>Link to v2:
>https://lore.kernel.org/netdev/20230930210308.2394919-1-avkrasnov@salutedevices.com/
>Link to v3:
>https://lore.kernel.org/netdev/20231007172139.1338644-1-avkrasnov@salutedevices.com/
>
>Changelog:
> v1 -> v2:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * See per-patch changelog after ---.
> v2 -> v3:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * See per-patch changelog after ---.
> v3 -> v4:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * See per-patch changelog after ---.

I think I fully reviewed the series ;-)

Tests are all passing here, including the new ones. I also added
vsock_perf and vsock_uring_test to my test suite!

So for vsock point of view everything looks fine.

Let's see if there is anything about net (MSG_ZEROCOPY flags, etc.)

Thanks,
Stefano

