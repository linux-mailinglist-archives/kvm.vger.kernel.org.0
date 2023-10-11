Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E427C5481
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346959AbjJKMzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346744AbjJKMzg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:55:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385B098
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697028886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A+7ZEoe9gqs3ohA/tE8e5TAOHw5GEtQ2AHlZY+ECy20=;
        b=P06NKT9+8xTwhGwQJsHTMj+tm0+zENZSQFcUjdy1dyQbpNis3tELo2s0EcCqG1N1sWfJ+a
        BJVOWzc8bbAA/AKGM4iFBVebASBpIK9NqccAaGThiSGSrU6dZT2hOOnMOwm5qLTYoBDnen
        m10r5bGiHohHP9paPBjd84L0/BaDvig=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-r2ieJtd2OB6FzKYhNsMA8Q-1; Wed, 11 Oct 2023 08:54:40 -0400
X-MC-Unique: r2ieJtd2OB6FzKYhNsMA8Q-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-77435bbb71dso715022085a.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:54:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697028879; x=1697633679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+7ZEoe9gqs3ohA/tE8e5TAOHw5GEtQ2AHlZY+ECy20=;
        b=Hq+aX4seeQUovhi9JeVgkH7QGdFvcJRICCp/+gCOYtq7BjjXvSZmEmg4r0bKSzdCqa
         Sq8hwVQoCA89rT2udzHHLm1/dc2N0vxXfpl9mzXQcIhQkuEFjZW+kHE8U1AIRvjYO36m
         tfIM8e6tnIZGfaQiZEr9Qpl2BPYuKQkgbx8Dw2afaJdipz+PzeLinDpYYPXEsRnkmfr+
         Lwle26J5iXCH6GugIt608OT65B/vxp0JEpxLdyQ/HlvSLhjgwDEYO7tmcbw40/kYQg4D
         DMbjCTHd3fGm8eiJi2qwxQqKqDytl6gkoIsULQQ0X8MSttjFqtdsCgiRHRRirtzoYRMA
         f8Yw==
X-Gm-Message-State: AOJu0YzVZFxeMmCS+XDMdE2is+ldBcNYnFx5A/lXecF2uDKeFDfJVDqJ
        ONQPpAc3/9K2o1rDe+aq4XQp2WpZiu2jsPzJyMYpSBb1iJk98LQ3I8FzeYA5ZKyoKVV8aGCUQYx
        7yV5iIVZHvQch
X-Received: by 2002:a05:620a:288c:b0:775:cf6d:a468 with SMTP id j12-20020a05620a288c00b00775cf6da468mr20569729qkp.49.1697028879727;
        Wed, 11 Oct 2023 05:54:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9V91LsLeBU3VLmajHUFBGtvS1V1JObKngcrNenQu9Dow0QDj9KmJu20EfpX9LZg4A5flqNw==
X-Received: by 2002:a05:620a:288c:b0:775:cf6d:a468 with SMTP id j12-20020a05620a288c00b00775cf6da468mr20569709qkp.49.1697028879396;
        Wed, 11 Oct 2023 05:54:39 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-251.retail.telecomitalia.it. [79.46.200.251])
        by smtp.gmail.com with ESMTPSA id oo23-20020a05620a531700b00774652483b7sm5210995qkn.33.2023.10.11.05.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 05:54:38 -0700 (PDT)
Date:   Wed, 11 Oct 2023 14:54:33 +0200
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
Subject: Re: [PATCH net-next v4 02/12] vsock: read from socket's error queue
Message-ID: <w3r22qa6ydaxa5ke34v6v6lruxyvxrpx2jo7dnakyyvaoqu52j@ohocxsyqpxj7>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
 <20231010191524.1694217-3-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231010191524.1694217-3-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:15:14PM +0300, Arseniy Krasnov wrote:
>This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
>is used to read socket's error queue instead of data queue. Possible
>scenario of error queue usage is receiving completions for transmission
>with MSG_ZEROCOPY flag. This patch also adds new defines: 'SOL_VSOCK'
>and 'VSOCK_RECVERR'.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Place new defines for userspace to the existing file 'vm_sockets.h'
>    instead of creating new one.
> v2 -> v3:
>  * Add comments to describe 'SOL_VSOCK' and 'VSOCK_RECVERR' in the file
>    'vm_sockets.h'.
>  * Reorder includes in 'af_vsock.c' in alphabetical order.
> v3 -> v4:
>  * Update comments for 'SOL_VSOCK' and 'VSOCK_RECVERR' by adding more
>    details.
>
> include/linux/socket.h          |  1 +
> include/uapi/linux/vm_sockets.h | 17 +++++++++++++++++
> net/vmw_vsock/af_vsock.c        |  6 ++++++
> 3 files changed, 24 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

