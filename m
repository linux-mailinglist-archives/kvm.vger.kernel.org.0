Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC567A5BB7
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 09:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjISHzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 03:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjISHzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 03:55:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E13116
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 00:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695110096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xq2PUpZjcLYmB0sc19KGgnU6q5ctsCTIhTwce+KUPmU=;
        b=Pmg4C76dgDF4DRpsKhlfJIu0MYDvFKVK5PfipIPU28UTx31IWzM7NN/UQ6fSXUbe0vr9z5
        np6S5C9B3U4auH+b1rI8cEzDvOzJLzrMxB9HOKVN7cyEXQbAoXIrdt8sFdoE0KlfwhX+Vh
        TpkmZgwVe3VJuomBr43jLi00kd6BJDI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-R0qJOmd6MGK-Sjac_s9GBg-1; Tue, 19 Sep 2023 03:54:52 -0400
X-MC-Unique: R0qJOmd6MGK-Sjac_s9GBg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5009ee2287aso6364116e87.2
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 00:54:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695110091; x=1695714891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq2PUpZjcLYmB0sc19KGgnU6q5ctsCTIhTwce+KUPmU=;
        b=RxfcwW1AN7Mx4AaJVEhQP+xe03yygH+YLr5q19VfdsGnSjBArabwfTfH6twjWTWW6i
         fvh5x49Btbq9l4znffksEIPMOvbdMesUo9/pYOL8hXV9GyCEmDI03iQRPn3fTim9soXM
         4wXMwA9H+0Sp146oX+ge4DeQ3qNi7J3SkrNWC/lyr2G5IQ3COXwGjC+/PZkVWrr7dLx7
         +h2qx38EO7Eh2dFZ97OlyydhMns6TnCw7KYhpg+50sVIVZ5kEkoUwjk091tB/Z/Juvie
         Ov5BCLtQYGyHy5FtfHovH4cwA6nQKA5q+ytohZpeml9Ti3WgZdf7LgOikTthRJ4LGBqe
         DjCQ==
X-Gm-Message-State: AOJu0YxjpdQ2ev7UROqnivBDIsWInfK3rQOw6Fb/JCHTs8ZLyhG7jK4Z
        c1zmfkCuhNH3+ijP3hE2FC/6Q/WTvGPqWc/1JCFVpnoPjZUmPUwIBe2e+8M620VR4OvcFbklh5o
        u9RiQCKiR3PKL
X-Received: by 2002:a05:6512:988:b0:500:7e64:cff1 with SMTP id w8-20020a056512098800b005007e64cff1mr7920465lft.14.1695110091568;
        Tue, 19 Sep 2023 00:54:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuCMWkGTykvVJzGOBWF+ltNRkIaGMXVMrzHnBowZKeRdkWnM1pfr62hc7g2qB3p0oGcC763w==
X-Received: by 2002:a05:6512:988:b0:500:7e64:cff1 with SMTP id w8-20020a056512098800b005007e64cff1mr7920452lft.14.1695110091255;
        Tue, 19 Sep 2023 00:54:51 -0700 (PDT)
Received: from sgarzare-redhat ([46.222.147.15])
        by smtp.gmail.com with ESMTPSA id a4-20020a05600c068400b004042dbb8925sm14294571wmn.38.2023.09.19.00.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 00:54:50 -0700 (PDT)
Date:   Tue, 19 Sep 2023 09:54:47 +0200
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
Subject: Re: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY
 preparations
Message-ID: <yys5jgwkukvfyrgfz6txxzqc7el5megf2xntnk6j4ausvjdgld@7aan4quqy4bs>
References: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
 <b5873e36-fe8c-85e8-e11b-4ccec386c015@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b5873e36-fe8c-85e8-e11b-4ccec386c015@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 07:56:00PM +0300, Arseniy Krasnov wrote:
>Hi Stefano,
>
>thanks for review! So when this patchset will be merged to net-next,
>I'll start sending next part of MSG_ZEROCOPY patchset, e.g. AF_VSOCK +
>Documentation/ patches.

Ack, if it is not a very big series, maybe better to include also the
tests so we can run them before merge the feature.

WDYT?

Stefano

