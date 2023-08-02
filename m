Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B3776C7C6
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 10:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjHBIBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 04:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjHBIBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 04:01:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0296ED
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 01:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690963240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oX2LNKOIHdzcvnsRpFJ7qJD3bKveDIMqdWllDVDTcVI=;
        b=NuA9B7HVY2ae+W8BBlmipaVbaaOK+h3UUoD+hWcu0gKshBeIWpN3mx8Igq1yVdLR//OrCH
        mJdcLyot7Sqhfei4cHwOPDRQVBeaEuiaFRtUZavwqlR/MdwtW+aNpNT7PILjkfpsncn1bJ
        DuHba4rCSOsFPUgzm4SIF4eIGWn0a/E=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-P6JkJPzYN16D4hAQuH7HyA-1; Wed, 02 Aug 2023 04:00:39 -0400
X-MC-Unique: P6JkJPzYN16D4hAQuH7HyA-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f9e616e25dso84831881cf.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 01:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690963239; x=1691568039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oX2LNKOIHdzcvnsRpFJ7qJD3bKveDIMqdWllDVDTcVI=;
        b=Ok/sZzhRzNmvrad67s3foQ8nzPcoAQFdcJACrKD7qTHOVuYFmW6aSVJaXIoiNxe7PH
         VcqPytdd743TeF0AME/475uGZZgGOXMsRcP8PYWuq/G1j4q1fmAkbKdatyqylPyvF5wJ
         gxRrvtTD4lDIV97Ji9+PW3S4/pwsmnpHoD0LIfQm+E9iOjAgNUFDDtGyaSsv94S+Zpqu
         NTeQu7Ha+JwpizRO9XNcSkLemoP1uW8xKIf1nwtRXjRQfWv71Fy4CWqDLi13yDm0ovW6
         HYhK0kc/vg6NAiBOYIfkPtfVnNwOIZrNodZsU4RRwsKx4yr13No4gw5cWOqoS0/O5X0Z
         R4/A==
X-Gm-Message-State: ABy/qLYa3obpPN/NfD0U3Z1Tioho6KCSbVNZ7+CEVSEDif0ES76j5fjp
        ODNIYGQVTLYI9Ok5MMfEtsur3Hp3ok0g1rjBdG4DmIXnatqo8EElQb7NWyg+ghk1VW9c18o1h31
        iSJQm4+SsuJVe
X-Received: by 2002:a05:622a:208:b0:403:b12b:908d with SMTP id b8-20020a05622a020800b00403b12b908dmr22409158qtx.8.1690963239452;
        Wed, 02 Aug 2023 01:00:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGrOKV3rYZOQ8uyqLMK5NY1CIny88EL3WOMwRsqXwVgCP9aOiPOtdVkUVSrpY7PwwrzUZO25A==
X-Received: by 2002:a05:622a:208:b0:403:b12b:908d with SMTP id b8-20020a05622a020800b00403b12b908dmr22409133qtx.8.1690963239236;
        Wed, 02 Aug 2023 01:00:39 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-214.retail.telecomitalia.it. [82.57.51.214])
        by smtp.gmail.com with ESMTPSA id g8-20020ac87748000000b00401217aa51dsm5074523qtu.76.2023.08.02.01.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 01:00:38 -0700 (PDT)
Date:   Wed, 2 Aug 2023 10:00:34 +0200
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
Subject: Re: [RFC PATCH v1 2/2] test/vsock: shutdowned socket test
Message-ID: <76yecufn7766obfi5zae5hpg6yrlestrqocnk56jgnukakkdds@rqbgbhh7xgck>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-3-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230801141727.481156-3-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 05:17:27PM +0300, Arseniy Krasnov wrote:
>This adds two tests for 'shutdown()' call. It checks that SIGPIPE is
>sent when MSG_NOSIGNAL is not set and vice versa. Both flags SHUT_WR
>and SHUT_RD are tested.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 138 +++++++++++++++++++++++++++++++
> 1 file changed, 138 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 90718c2fd4ea..21d40a8d881c 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -19,6 +19,7 @@
> #include <time.h>
> #include <sys/mman.h>
> #include <poll.h>
>+#include <signal.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -1170,6 +1171,133 @@ static void test_seqpacket_msg_peek_server(const struct test_opts *opts)
> 	return test_msg_peek_server(opts, true);
> }
>
>+static bool have_sigpipe;
                  ^
We should define it as `volatile sig_atomic_t`:

the behavior is undefined if the signal handler refers to any object
[CX] [Option Start]  other than errno [Option End]  with static storage
duration other than by assigning a value to an object declared as
volatile sig_atomic_t

https://pubs.opengroup.org/onlinepubs/9699919799/functions/signal.html

The rest LGTM!

Thanks,
Stefano

>+
>+static void sigpipe(int signo)
>+{
>+	have_sigpipe = true;
>+}
>+
>+static void test_stream_check_sigpipe(int fd)
>+{
>+	ssize_t res;
>+
>+	have_sigpipe = false;
>+
>+	res = send(fd, "A", 1, 0);
>+	if (res != -1) {
>+		fprintf(stderr, "expected send(2) failure, got %zi\n", res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!have_sigpipe) {
>+		fprintf(stderr, "SIGPIPE expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	have_sigpipe = false;
>+
>+	res = send(fd, "A", 1, MSG_NOSIGNAL);
>+	if (res != -1) {
>+		fprintf(stderr, "expected send(2) failure, got %zi\n", res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (have_sigpipe) {
>+		fprintf(stderr, "SIGPIPE not expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>+
>+static void test_stream_shutwr_client(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	struct sigaction act = {
>+		.sa_handler = sigpipe,
>+	};
>+
>+	sigaction(SIGPIPE, &act, NULL);
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (shutdown(fd, SHUT_WR)) {
>+		perror("shutdown");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	test_stream_check_sigpipe(fd);
>+
>+	control_writeln("CLIENTDONE");
>+
>+	close(fd);
>+}
>+
>+static void test_stream_shutwr_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("CLIENTDONE");
>+
>+	close(fd);
>+}
>+
>+static void test_stream_shutrd_client(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	struct sigaction act = {
>+		.sa_handler = sigpipe,
>+	};
>+
>+	sigaction(SIGPIPE, &act, NULL);
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("SHUTRDDONE");
>+
>+	test_stream_check_sigpipe(fd);
>+
>+	control_writeln("CLIENTDONE");
>+
>+	close(fd);
>+}
>+
>+static void test_stream_shutrd_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (shutdown(fd, SHUT_RD)) {
>+		perror("shutdown");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("SHUTRDDONE");
>+	control_expectln("CLIENTDONE");
>+
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -1250,6 +1378,16 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_msg_peek_client,
> 		.run_server = test_seqpacket_msg_peek_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM SHUT_WR",
>+		.run_client = test_stream_shutwr_client,
>+		.run_server = test_stream_shutwr_server,
>+	},
>+	{
>+		.name = "SOCK_STREAM SHUT_RD",
>+		.run_client = test_stream_shutrd_client,
>+		.run_server = test_stream_shutrd_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1
>

