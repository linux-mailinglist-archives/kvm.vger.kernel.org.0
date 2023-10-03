Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F91F7B6E60
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbjJCQYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjJCQYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083C0BB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696350235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BApKczrxEPgLzQsQyB3wpnpVoMtABSfbJmV036In4jc=;
        b=UyD84gfKl8JMQihqMQeQQ19XLFoGLKSuvHfa266BL1vZNEbYHEQ3Fh5B6T7+OB5xZ8sjqU
        1OI4ymcnZhQyBod3P6jRJtMmwpwMNC+SQXaBFvaWwNtRqdPuxMfFrth/IEkcUP2q437k5g
        9NTBU6mhIcbr48vRSlmeagoIW+CtHDU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-DzOGaLnCMbCKTc1ooExF3g-1; Tue, 03 Oct 2023 12:23:53 -0400
X-MC-Unique: DzOGaLnCMbCKTc1ooExF3g-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-5a4c68a71b2so16424337b3.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696350233; x=1696955033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BApKczrxEPgLzQsQyB3wpnpVoMtABSfbJmV036In4jc=;
        b=Tf+wPPJU7MfLKEUPpZ2d7na7y8N7t5Wo1rX+4ua2184SB1xD2uH3SD5TqAQTxqTpgI
         axUF6MHIpIAjVT/tB3G4d0X9tnio+srr0eStA3/f9EfZogWI+OsHrudaSfHyiHpmXNkM
         9/geljdfnIunaErEB/LkTOiBcFIaHOz9yjJf2YxTCaYUJxG0gpVR8cg04uPEo97iiJo9
         bg0bKkC4KyL/u4x0Mml3vDZQP2fecMxc2lp+OvksEH0H8pByk3BYwdeaC4ZnRiJzFcA4
         nTj2/ugzhYXJgMdZOBimH6ZU/0ttfRyINikg08DxVjdofR1AqlwMpiLKbqtmZo2PMfWT
         +fug==
X-Gm-Message-State: AOJu0YwF5eaAFgAvwOMhLG4WFs1IotwrPMnsSNnZhMx1KO+Rz33FR0JU
        j+JHL7mlrE5yYaqB1/6og2CEecgLdoRUJ5XrqQytmexTCYxDlEnAkuva2clE/VYTXA7zVhJwKsU
        Xxj/zroOqHTpN
X-Received: by 2002:a25:6fc1:0:b0:d74:62df:e802 with SMTP id k184-20020a256fc1000000b00d7462dfe802mr13099900ybc.0.1696350233387;
        Tue, 03 Oct 2023 09:23:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFA4CkY3jrhTI4v/yIBb1i8/xVZlYFpMjG1ENvBNmWm2bYF1ZcRT0YuJJUdqErnU00bMgI0g==
X-Received: by 2002:a25:6fc1:0:b0:d74:62df:e802 with SMTP id k184-20020a256fc1000000b00d7462dfe802mr13099882ybc.0.1696350233091;
        Tue, 03 Oct 2023 09:23:53 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id y6-20020a0ce046000000b0065823d20381sm596479qvk.8.2023.10.03.09.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:23:52 -0700 (PDT)
Date:   Tue, 3 Oct 2023 18:23:48 +0200
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
Subject: Re: [PATCH net-next v2 09/12] docs: net: description of MSG_ZEROCOPY
 for AF_VSOCK
Message-ID: <waco5sx7dxzvb7ogs3nnxugrt7afppk3432wc2fwwovic5y4pa@wmdi3tis36rz>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <20230930210308.2394919-10-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230930210308.2394919-10-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023 at 12:03:05AM +0300, Arseniy Krasnov wrote:
>This adds description of MSG_ZEROCOPY flag support for AF_VSOCK type of
>socket.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Documentation/networking/msg_zerocopy.rst | 13 +++++++++++--
> 1 file changed, 11 insertions(+), 2 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
>index b3ea96af9b49..78fb70e748b7 100644
>--- a/Documentation/networking/msg_zerocopy.rst
>+++ b/Documentation/networking/msg_zerocopy.rst
>@@ -7,7 +7,8 @@ Intro
> =====
>
> The MSG_ZEROCOPY flag enables copy avoidance for socket send calls.
>-The feature is currently implemented for TCP and UDP sockets.
>+The feature is currently implemented for TCP, UDP and VSOCK (with
>+virtio transport) sockets.
>
>
> Opportunity and Caveats
>@@ -174,7 +175,9 @@ read_notification() call in the previous snippet. A notification
> is encoded in the standard error format, sock_extended_err.
>
> The level and type fields in the control data are protocol family
>-specific, IP_RECVERR or IPV6_RECVERR.
>+specific, IP_RECVERR or IPV6_RECVERR (for TCP or UDP socket).
>+For VSOCK socket, cmsg_level will be SOL_VSOCK and cmsg_type will be
>+VSOCK_RECVERR.
>
> Error origin is the new type SO_EE_ORIGIN_ZEROCOPY. ee_errno is zero,
> as explained before, to avoid blocking read and write system calls on
>@@ -235,12 +238,15 @@ Implementation
> Loopback
> --------
>
>+For TCP and UDP:
> Data sent to local sockets can be queued indefinitely if the receive
> process does not read its socket. Unbound notification latency is not
> acceptable. For this reason all packets generated with MSG_ZEROCOPY
> that are looped to a local socket will incur a deferred copy. This
> includes looping onto packet sockets (e.g., tcpdump) and tun devices.
>
>+For VSOCK:
>+Data path sent to local sockets is the same as for non-local sockets.
>
> Testing
> =======
>@@ -254,3 +260,6 @@ instance when run with msg_zerocopy.sh between a veth pair across
> namespaces, the test will not show any improvement. For testing, the
> loopback restriction can be temporarily relaxed by making
> skb_orphan_frags_rx identical to skb_orphan_frags.
>+
>+For VSOCK type of socket example can be found in
>+tools/testing/vsock/vsock_test_zerocopy.c.
>-- 
>2.25.1
>

