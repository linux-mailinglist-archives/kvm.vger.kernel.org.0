Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233CB78FD59
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 14:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349487AbjIAMfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjIAMfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 08:35:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB4EE7B
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 05:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693571654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aNIJ/eGigZtGUYGZTGziEv0Hr86IZ6MX9zljYZmw98Q=;
        b=dW71cnaqsMBubyvulZnP+cNA3c7u+JDEORkXzSESoNtOiMqluKcZ5vuebGHdn7iVw/i67h
        1zgsJeoogWW/sOQrilF/vapsv06UEZnA8ioNtJVNDMlleiZYTRCX2wkQ1NRvJ3O8QmoN7O
        nHoMv837Fo6suG6BuTgfwQ8iXkKtwRQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-L6REiD1KOdOh5E_JwmiYoQ-1; Fri, 01 Sep 2023 08:34:13 -0400
X-MC-Unique: L6REiD1KOdOh5E_JwmiYoQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-98e40d91fdfso141298866b.3
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 05:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693571652; x=1694176452;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNIJ/eGigZtGUYGZTGziEv0Hr86IZ6MX9zljYZmw98Q=;
        b=XXbW0Yp+l8CmvbDU/yNSzogQOO1WHYp46bYkfpNoN9DD1fFeztAhwuGdpPQTIFdPp/
         2ZpEjSD8kdHdzeSysXMnnSvDLEceuVzVdU6Qw0GmqkDR9CI3C1PWkC1JJ24WEWeOY8f/
         08b/4y5PDMJWMHqhz2o1Us7MhycyEBWQV1bIn+L7nKhMdG1J+S+wil6mJcYvBd+W/BSN
         wdZlECvl7vavFVzZtDAghPJDsOiD+QY67of8cWS+bsiTDd85Lp9I8KNtDdYJ3u+LF3fM
         MCw+z9zRw7n6SbL1psNeENqznzf4AAAEyDT1+x8OMNYVhm4vCnsOTr2eNdGHeLz8xbWo
         hy1w==
X-Gm-Message-State: AOJu0YwKKKGjuA0gmgkr/sMT9jPOjfe3fGbOjmXqXF6EW03ayiZgT5rK
        6BX6hDiHhXm5L8UZ3OOcPp3ZITfLjZIfkasZoht0EJYYa2+GZmGpaxrbzPf+JoYKwOG+pcLZGns
        HT1wzARK+wXG8
X-Received: by 2002:a17:906:cc4b:b0:9a1:f521:c3ff with SMTP id mm11-20020a170906cc4b00b009a1f521c3ffmr1968914ejb.40.1693571651948;
        Fri, 01 Sep 2023 05:34:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdwDTby/bdcndq6+v/2sv0Oadl3EG/Z9W3gE2sao7E3fQXKbNEUWMjvDkVCoig3fFvaMVq/Q==
X-Received: by 2002:a17:906:cc4b:b0:9a1:f521:c3ff with SMTP id mm11-20020a170906cc4b00b009a1f521c3ffmr1968892ejb.40.1693571651661;
        Fri, 01 Sep 2023 05:34:11 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id l13-20020a170906a40d00b0099bc0daf3d7sm1926076ejz.182.2023.09.01.05.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 05:34:11 -0700 (PDT)
Date:   Fri, 1 Sep 2023 14:34:08 +0200
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
Subject: Re: [PATCH net-next v7 1/4] vsock/virtio/vhost: read data from
 non-linear skb
Message-ID: <auffsp3vajtsh4gynsfusph74bdbghvhoalalgvcfqyvphj5vw@hgiwneiqcbrd>
References: <20230827085436.941183-1-avkrasnov@salutedevices.com>
 <20230827085436.941183-2-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230827085436.941183-2-avkrasnov@salutedevices.com>
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

On Sun, Aug 27, 2023 at 11:54:33AM +0300, Arseniy Krasnov wrote:
>This is preparation patch for MSG_ZEROCOPY support. It adds handling of
>non-linear skbs by replacing direct calls of 'memcpy_to_msg()' with
>'skb_copy_datagram_iter()'. Main advantage of the second one is that it
>can handle paged part of the skb by using 'kmap()' on each page, but if
>there are no pages in the skb, it behaves like simple copying to iov
>iterator. This patch also adds new field to the control block of skb -
>this value shows current offset in the skb to read next portion of data
>(it doesn't matter linear it or not). Idea behind this field is that
>'skb_copy_datagram_iter()' handles both types of skb internally - it
>just needs an offset from which to copy data from the given skb. This
>offset is incremented on each read from skb. This approach allows to
>simplify handling of both linear and non-linear skbs, because for
>linear skb we need to call 'skb_pull()' after reading data from it,
>while in non-linear case we need to update 'data_len'.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v5(big patchset) -> v1:
>  * Merge 'virtio_transport_common.c' and 'vhost/vsock.c' patches into
>    this single patch.
>  * Commit message update: grammar fix and remark that this patch is
>    MSG_ZEROCOPY preparation.
>  * Use 'min_t()' instead of comparison using '<>' operators.
> v1 -> v2:
>  * R-b tag added.
> v3 -> v4:
>  * R-b tag removed due to rebase:
>    * Part for 'virtio_transport_stream_do_peek()' is changed.
>    * Part for 'virtio_transport_seqpacket_do_peek()' is added.
>  * Comments about sleep in 'memcpy_to_msg()' now describe sleep in
>    'skb_copy_datagram_iter()'.
> v5 -> v6:
>  * Commit message update.
>  * Rename 'frag_off' to 'offset' in 'virtio_vsock_skb_cb'.
>
> drivers/vhost/vsock.c                   | 14 +++++++----
> include/linux/virtio_vsock.h            |  1 +
> net/vmw_vsock/virtio_transport_common.c | 32 +++++++++++++++----------
> 3 files changed, 29 insertions(+), 18 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

