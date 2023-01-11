Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3880C66560C
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 09:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbjAKI1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 03:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238052AbjAKI1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 03:27:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672EF6557
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673425520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z9BqbleyIskxpRXIgDkvfJFpA17h9Qu7BSswmKTjpxs=;
        b=Vp011uveWAFidbpxSQeikU0aUoLMQDXzeHzV9YnDW10AFzZnYisWLkZCAkHFsyTQ2BKb7I
        X08wKZtGA4zSb5bMM8AwzaUiQ6eFSagl+06OLST1hyi5ZEmBhWHU4gNSGQdqlNfZqKEn+a
        vhqRB04VUqPK/ER2V4qgD/62H1D2mek=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-iWuyHlwNNk-aMt3aGx4HMw-1; Wed, 11 Jan 2023 03:25:19 -0500
X-MC-Unique: iWuyHlwNNk-aMt3aGx4HMw-1
Received: by mail-qv1-f69.google.com with SMTP id r10-20020ad4522a000000b004d28fcbfe17so8025424qvq.4
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:25:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9BqbleyIskxpRXIgDkvfJFpA17h9Qu7BSswmKTjpxs=;
        b=A2zSK9T50qN1baNyiL+peATGTtSatIOYDeEX8pusN5AVJJJjfRAlNK9m1/DPi9R68q
         3COz4yVGTA2Cwk4zv8WIUDwLAib2WofA71E4ee5j2UCqpoPjT45KiFnLaqEHwqA/nC+N
         i7G9zzl1DlSrRkq+VmfZ9OXhdiUOHo5tDDFf/pWCGAEcn9mthB0HWbmUKbFL/+oczhSj
         tmh3gOTFICf3ZgGm197XrhcnkUkZ2fnvRPqbacF5gNNMx20UGSG4Iwx9HlhBDvvBNXOj
         apOruswwi6RAGlXy1YVPk9JTH8mpiifRMf8Ra3VRL7POzm06EbuWi5wFoYpykdEb8BzD
         ci8g==
X-Gm-Message-State: AFqh2krhA2qJxyymge7To7k9GW9WfiC++v8+Haz+MNWClZZLqscxNR03
        aeh+NDLuusIHcs535yUI6scx+vgb69p6NS/uJqdbQjLcng/2b9gN8pvyW/x8gQJrhOvKU9b4Rpn
        aQ02Zippj4/OC
X-Received: by 2002:ac8:6f19:0:b0:3a9:84bd:7cc5 with SMTP id bs25-20020ac86f19000000b003a984bd7cc5mr109481132qtb.39.1673425518776;
        Wed, 11 Jan 2023 00:25:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvypWklvz3km9uYoBB0qv32xq21YlcTjpjh3KzgK6avNFjv4jYlLRNPx/BLDFKbo966A5oWEQ==
X-Received: by 2002:ac8:6f19:0:b0:3a9:84bd:7cc5 with SMTP id bs25-20020ac86f19000000b003a984bd7cc5mr109481108qtb.39.1673425518406;
        Wed, 11 Jan 2023 00:25:18 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-244.retail.telecomitalia.it. [79.46.200.244])
        by smtp.gmail.com with ESMTPSA id c8-20020ac86608000000b003a4f435e381sm7226084qtp.18.2023.01.11.00.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 00:25:17 -0800 (PST)
Date:   Wed, 11 Jan 2023 09:25:13 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     liming.wu@jaguarmicro.com
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Subject: Re: [PATCH] vhost: remove unused paramete
Message-ID: <20230111082513.weu6go5k2nyfvkjh@sgarzare-redhat>
References: <20230110024445.303-1-liming.wu@jaguarmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230110024445.303-1-liming.wu@jaguarmicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 10:44:45AM +0800, liming.wu@jaguarmicro.com wrote:
>From: Liming Wu <liming.wu@jaguarmicro.com>
>
>"enabled" is defined in vhost_init_device_iotlb,
>but it is never used. Let's remove it.
>
>Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
>---
> drivers/vhost/net.c   | 2 +-
> drivers/vhost/vhost.c | 2 +-
> drivers/vhost/vhost.h | 2 +-
> drivers/vhost/vsock.c | 2 +-
> 4 files changed, 4 insertions(+), 4 deletions(-)

Little typo in the title s/paramete/parameter.

A part of that, the patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

