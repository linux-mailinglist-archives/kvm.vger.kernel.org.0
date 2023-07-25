Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5207761D8C
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjGYPmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjGYPmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:42:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5AA1FD3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690299673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ywc41/BPTk/JOAzpj2Ndsq/haHQiohuM6GBycryh5is=;
        b=emCsZIr6jKqZ7vlyZ45ONeGyycQJM+RgbU+DjUId2IW5s96A6Yxu3yxi8wJYk/0a8xuCso
        OiMtvCYPuRz5CVxqbVphHMnB+9/QrNPG5kusnNLuY5VbqqlV2yKNhiQfdW7tNbTFKmw3z3
        GUjQ9julY7wuWF4A3CleEWJy+Vb6qwQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347--QhfHuGbODqqa6WNtukF8g-1; Tue, 25 Jul 2023 11:41:12 -0400
X-MC-Unique: -QhfHuGbODqqa6WNtukF8g-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4053d7854a9so73695781cf.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:41:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690299672; x=1690904472;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ywc41/BPTk/JOAzpj2Ndsq/haHQiohuM6GBycryh5is=;
        b=dqe+D8EAkONwJLxmQ/gpjgU70zKNF8ca/WGscaI2yL1vePrMdpoL9GpBrYpiNmSrQe
         7XAyTMcuefIc5c+zZmmzHEu9P7HCD4QkbYvd1bQuLJKNVqHx+w8UmnVmbizJpUYxVUlO
         Q8R6VLarZQF0KTeOqTJuM1Z5ZS9ms0Q57uiYL5y2WB4wKsbuHplqU1kIMYN+JI5s/kw0
         yjxFDl9+uT6yrBApVSzWpg3nRILlIOpozTbHieV/ysSDABdwlMJApiLnt4KJAxigLSfs
         ClBOvA1IqGRJ+d8aNZ6dEAqZXx9vFh0P+KXUCCBbdCB9dgJYczutXAOGnTVmdyESU+g7
         Befw==
X-Gm-Message-State: ABy/qLbI7233eck06ZMWuIx6/a1Y9N2L5yRa37CxGXeaRfnlYet5hCwn
        NQsYpYkU2cwXe7UtGU4IJG+j1+QtvOGN3nhTaBdH0E9NltqC1Jjk9WOyXylgymrDz186sghv6Iz
        4GIPae+qeBEJf
X-Received: by 2002:ac8:5f0c:0:b0:405:47aa:742f with SMTP id x12-20020ac85f0c000000b0040547aa742fmr3527179qta.32.1690299671819;
        Tue, 25 Jul 2023 08:41:11 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHA1b4My1rtvlYJYA1W4nzseTpuRek/vvdBo/xbpSdUcXuiki19nX3FPgKAFwQK2ije6YiWNA==
X-Received: by 2002:ac8:5f0c:0:b0:405:47aa:742f with SMTP id x12-20020ac85f0c000000b0040547aa742fmr3527157qta.32.1690299671554;
        Tue, 25 Jul 2023 08:41:11 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.153.113])
        by smtp.gmail.com with ESMTPSA id g1-20020ac870c1000000b00404f8e9902dsm4132859qtp.2.2023.07.25.08.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:41:11 -0700 (PDT)
Date:   Tue, 25 Jul 2023 17:41:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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
Subject: Re: [RFC PATCH v2 4/4] vsock/test: MSG_PEEK test for SOCK_SEQPACKET
Message-ID: <lkfzuvv53lyycpun27knppjhk46lyqrz4idvzj7fzer2566y5t@mtc7v33q3erg>
References: <20230719192708.1775162-1-AVKrasnov@sberdevices.ru>
 <20230719192708.1775162-5-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230719192708.1775162-5-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 10:27:08PM +0300, Arseniy Krasnov wrote:
>This adds MSG_PEEK test for SOCK_SEQPACKET. It works in the same way as
>SOCK_STREAM test, except it also tests MSG_TRUNC flag.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 58 +++++++++++++++++++++++++++++---
> 1 file changed, 54 insertions(+), 4 deletions(-)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 444a3ff0681f..2ca2cbfa9808 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -257,14 +257,19 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
>
> #define MSG_PEEK_BUF_LEN 64
>
>-static void test_stream_msg_peek_client(const struct test_opts *opts)
>+static void __test_msg_peek_client(const struct test_opts *opts,

Let's stay with just test_msg_peek_client(), WDYT?

>+				   bool seqpacket)
> {
> 	unsigned char buf[MSG_PEEK_BUF_LEN];
> 	ssize_t send_size;
> 	int fd;
> 	int i;
>
>-	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (seqpacket)
>+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	else
>+		fd = vsock_stream_connect(opts->peer_cid, 1234);
>+
> 	if (fd < 0) {
> 		perror("connect");
> 		exit(EXIT_FAILURE);
>@@ -290,7 +295,8 @@ static void test_stream_msg_peek_client(const struct test_opts *opts)
> 	close(fd);
> }
>
>-static void test_stream_msg_peek_server(const struct test_opts *opts)
>+static void __test_msg_peek_server(const struct test_opts *opts,

Same here.

The rest LGTM!

Also the whole series should be ready for net-next, right?

Stefano

