Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF1C762F6B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjGZIPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjGZIOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:14:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB501BFA
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 01:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690358699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eAjNRIihSOf+ZWCQiGmuIak9rrS2S/b0k59m1Q9Sn58=;
        b=cRkZK7VepVRwbsTDg6CbZaFtEhlzuJ0re7gqD8KHpEHXjkuj43EqFncvdDaMJjqaZP6XXx
        WEOTZNwMOsbxXi7xepCRJms0nAxJMyC0TBo6pktCGSlFPJ/nj5RiJ1c7C1pCGL+YXqNTv+
        snXrfw+XjXrNP8ZUZNbMvWdN4UlEEhM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-ndxjHwbVOvm_slUeDTjzGg-1; Wed, 26 Jul 2023 04:04:57 -0400
X-MC-Unique: ndxjHwbVOvm_slUeDTjzGg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9932e8e76b9so527257366b.3
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 01:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690358696; x=1690963496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAjNRIihSOf+ZWCQiGmuIak9rrS2S/b0k59m1Q9Sn58=;
        b=ge08twZ3/s4Y37Z63TxLHkSqovMjg8iuYQc6ohnRF5bWvlkhFSbfwELVhB60hr8KcV
         iZ4E/e1LrhBR2slNUfV/I7plvWQmm7rVH7jhmNOWr3v0rG6hiFgbP/6LhwO6pm9jhxm+
         NGnwi+iqrZYC82VlqP+PXkMfiFlBNjcYEKLFjxF7jIooQgnnV0/o/VdJou/fcdAAlzSK
         gmF6oJ2xXL6bi7EGSOUBwk4vB64A6Ix1REKib7fiK8TybzoW19XL/Cs5qG2hqBNEWvf9
         KgNyWmijYIkagNo5JWple7r7onvuHVynXuFoySSAIgaWshYpNEk2YTe1QyWc8wWuD0h8
         4gvA==
X-Gm-Message-State: ABy/qLYsKiwA7wZobN+o2x9j90AbSu/u73LQco1d/WX6nFzkmTl8IWhM
        EbdI4gkeQmx0jYXlSJ+2khRYRnrRJmsPiBrRYcBn/B7LlIvAJ6Ci4bZ0+hmIOG8LXwoYphrvavu
        VC70WS9LP2e+Q3f7fulK8
X-Received: by 2002:a05:6402:1489:b0:522:30cc:a1f0 with SMTP id e9-20020a056402148900b0052230cca1f0mr1048234edv.14.1690358696041;
        Wed, 26 Jul 2023 01:04:56 -0700 (PDT)
X-Google-Smtp-Source: APBJJlH9cTC/+4nVrUrzuc8eu1ehgpHLqa3C+TMwtpTbgkUOYw+ZUE8Z5I+GDauZapCy0HXIvtSFdQ==
X-Received: by 2002:a05:6402:1489:b0:522:30cc:a1f0 with SMTP id e9-20020a056402148900b0052230cca1f0mr1048219edv.14.1690358695716;
        Wed, 26 Jul 2023 01:04:55 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.111.137])
        by smtp.gmail.com with ESMTPSA id f5-20020a056402068500b0051ded17b30bsm8479399edy.40.2023.07.26.01.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 01:04:55 -0700 (PDT)
Date:   Wed, 26 Jul 2023 10:04:51 +0200
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
Subject: Re: [PATCH net-next v3 4/4] vsock/test: MSG_PEEK test for
 SOCK_SEQPACKET
Message-ID: <fbyxkuf3z3grrwnj6riwy4fki47yqfrdplhmcsd4ye3ga7apsk@5zeiorqk6uaz>
References: <20230725172912.1659970-1-AVKrasnov@sberdevices.ru>
 <20230725172912.1659970-5-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230725172912.1659970-5-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 08:29:12PM +0300, Arseniy Krasnov wrote:
>This adds MSG_PEEK test for SOCK_SEQPACKET. It works in the same way as
>SOCK_STREAM test, except it also tests MSG_TRUNC flag.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 58 +++++++++++++++++++++++++++++---
> 1 file changed, 54 insertions(+), 4 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 444a3ff0681f..90718c2fd4ea 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -257,14 +257,19 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
>
> #define MSG_PEEK_BUF_LEN 64
>
>-static void test_stream_msg_peek_client(const struct test_opts *opts)
>+static void test_msg_peek_client(const struct test_opts *opts,
>+				 bool seqpacket)
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
>+static void test_msg_peek_server(const struct test_opts *opts,
>+				 bool seqpacket)
> {
> 	unsigned char buf_half[MSG_PEEK_BUF_LEN / 2];
> 	unsigned char buf_normal[MSG_PEEK_BUF_LEN];
>@@ -298,7 +304,11 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> 	ssize_t res;
> 	int fd;
>
>-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (seqpacket)
>+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	else
>+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+
> 	if (fd < 0) {
> 		perror("accept");
> 		exit(EXIT_FAILURE);
>@@ -340,6 +350,21 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> 		exit(EXIT_FAILURE);
> 	}
>
>+	if (seqpacket) {
>+		/* This type of socket supports MSG_TRUNC flag,
>+		 * so check it with MSG_PEEK. We must get length
>+		 * of the message.
>+		 */
>+		res = recv(fd, buf_half, sizeof(buf_half), MSG_PEEK |
>+			   MSG_TRUNC);
>+		if (res != sizeof(buf_peek)) {
>+			fprintf(stderr,
>+				"recv(2) + MSG_PEEK | MSG_TRUNC, exp %zu, got %zi\n",
>+				sizeof(buf_half), res);
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
> 	res = recv(fd, buf_normal, sizeof(buf_normal), 0);
> 	if (res != sizeof(buf_normal)) {
> 		fprintf(stderr, "recv(2), expected %zu, got %zi\n",
>@@ -356,6 +381,16 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static void test_stream_msg_peek_client(const struct test_opts *opts)
>+{
>+	return test_msg_peek_client(opts, false);
>+}
>+
>+static void test_stream_msg_peek_server(const struct test_opts *opts)
>+{
>+	return test_msg_peek_server(opts, false);
>+}
>+
> #define SOCK_BUF_SIZE (2 * 1024 * 1024)
> #define MAX_MSG_SIZE (32 * 1024)
>
>@@ -1125,6 +1160,16 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static void test_seqpacket_msg_peek_client(const struct test_opts *opts)
>+{
>+	return test_msg_peek_client(opts, true);
>+}
>+
>+static void test_seqpacket_msg_peek_server(const struct test_opts *opts)
>+{
>+	return test_msg_peek_server(opts, true);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1200,6 +1245,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_virtio_skb_merge_client,
> 		.run_server = test_stream_virtio_skb_merge_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET MSG_PEEK",
>+		.run_client = test_seqpacket_msg_peek_client,
>+		.run_server = test_seqpacket_msg_peek_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>

