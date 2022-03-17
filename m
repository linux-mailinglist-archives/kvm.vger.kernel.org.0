Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A9B4DC0A0
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 09:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiCQIIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 04:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiCQIIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 04:08:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24BE1120D92
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 01:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647504441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HhlFyUE6IEBsOcwDfZpsFqlAMN7YDfaF0SxISDC03Tg=;
        b=AJcZzkjA7v9V3oELPBdGubrNtaUwk/fRR5wmLvFXn/NB5b1tEbdfzb9/b8WrD5tXyP5EYC
        mN6mR6TGqHu8Q+yNl59bFfetJ5t+gjWXvNKhrk7gMLeGDZ2gPIpEW3LpfpUDC/zUdmNo7Q
        GyM5uQ3ICuC3E3q6R85Qpd29YEzr2j8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-4R0loSevPd-cS0ChJZCoFw-1; Thu, 17 Mar 2022 04:07:19 -0400
X-MC-Unique: 4R0loSevPd-cS0ChJZCoFw-1
Received: by mail-qv1-f71.google.com with SMTP id 33-20020a0c8024000000b0043d17ffb0bdso3423165qva.18
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 01:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HhlFyUE6IEBsOcwDfZpsFqlAMN7YDfaF0SxISDC03Tg=;
        b=GNUEmZvIUNpA3E4LQpRk/v/f1qXAJxm0p5m9+hPLpbDG7Nl43TYosGDCfo/xh880Kv
         4Ks8OoHf7PuH6Hia7BHqoO+Fp2924t/N7WrmS3H84nnZdB1g2hIh0HKUYt6glXhUHlkB
         6wnasSrpF/7NXE39nzHYfXQAEkmSAw0wChdATFpyuUbXwM93Rq6wjOm1oyh+NKVMc08v
         TCefWN6hBSp0kybRp8Q+HSFm7sgdcFGqVfG3iXgKnuWynGvsyN2grZsclUfsEAJgugku
         7Wl+5jIhRx2H936fCu+zXgDsj1HxlcvLqs3mFHdUNHHK60mU4sbe9TLjIRdBa4OXM6De
         sj6w==
X-Gm-Message-State: AOAM530pKwvYKoVdXgG6a2fSB8mIvtveQtE3VH4sLwtIbjEmvi/3R+07
        OZ4niIqaYfZSoyyqTjLK1ehqROx7Gg3n3gZbqXxbYrEckTO6E5kTbEEMYCvQHo/occ4nvhesfE3
        UrQOygtkuat3Y
X-Received: by 2002:a05:622a:164d:b0:2e1:d592:ade2 with SMTP id y13-20020a05622a164d00b002e1d592ade2mr2739621qtj.602.1647504439395;
        Thu, 17 Mar 2022 01:07:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3SA57vAbApSbgd6VxWAFzL+Wipmtr+x6XIq8uK0YzNcWOmMeuA4rjFzXIwSc3fKrbvcggGQ==
X-Received: by 2002:a05:622a:164d:b0:2e1:d592:ade2 with SMTP id y13-20020a05622a164d00b002e1d592ade2mr2739609qtj.602.1647504439118;
        Thu, 17 Mar 2022 01:07:19 -0700 (PDT)
Received: from sgarzare-redhat (host-79-42-202-12.retail.telecomitalia.it. [79.42.202.12])
        by smtp.gmail.com with ESMTPSA id j11-20020a37a00b000000b0067b436faccesm2040526qke.122.2022.03.17.01.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 01:07:18 -0700 (PDT)
Date:   Thu, 17 Mar 2022 09:07:08 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 1/2] af_vsock: SOCK_SEQPACKET receive timeout
 test
Message-ID: <20220317080708.duovh4tnf6oxhciq@sgarzare-redhat>
References: <4ecfa306-a374-93f6-4e66-be62895ae4f7@sberdevices.ru>
 <a3f95812-d5bb-86a0-46a0-78935651e39e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a3f95812-d5bb-86a0-46a0-78935651e39e@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 05:26:45AM +0000, Krasnov Arseniy Vladimirovich wrote:
>Test for receive timeout check: connection is established,
>receiver sets timeout, but sender does nothing. Receiver's
>'read()' call must return EAGAIN.
>
>Signed-off-by: Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
>---
> v2 -> v3:
> 1) Use 'fprintf()' instead of 'perror()' where 'errno' variable
>    is not affected.
> 2) Print 'read()' overhead.
>
> tools/testing/vsock/vsock_test.c | 84 ++++++++++++++++++++++++++++++++
> 1 file changed, 84 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 2a3638c0a008..f5498de6751d 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -16,6 +16,7 @@
> #include <linux/kernel.h>
> #include <sys/types.h>
> #include <sys/socket.h>
>+#include <time.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -391,6 +392,84 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
> 	close(fd);
> }
>
>+static time_t current_nsec(void)
>+{
>+	struct timespec ts;
>+
>+	if (clock_gettime(CLOCK_REALTIME, &ts)) {
>+		perror("clock_gettime(3) failed");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	return (ts.tv_sec * 1000000000ULL) + ts.tv_nsec;
>+}
>+
>+#define RCVTIMEO_TIMEOUT_SEC 1
>+#define READ_OVERHEAD_NSEC 250000000 /* 0.25 sec */
>+
>+static void test_seqpacket_timeout_client(const struct test_opts *opts)
>+{
>+	int fd;
>+	struct timeval tv;
>+	char dummy;
>+	time_t read_enter_ns;
>+	time_t read_overhead_ns;
>+
>+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	tv.tv_sec = RCVTIMEO_TIMEOUT_SEC;
>+	tv.tv_usec = 0;
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, sizeof(tv)) == -1) {
>+		perror("setsockopt 'SO_RCVTIMEO'");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	read_enter_ns = current_nsec();
>+
>+	if (errno != EAGAIN) {
>+		perror("EAGAIN expected");
>+		exit(EXIT_FAILURE);
>+	}

Should this check go after read()?

Indeed now the test fails on my environment with "EAGAIN expected" 
message.

The rest LGTM :-)

Stefano

>+
>+	if (read(fd, &dummy, sizeof(dummy)) != -1) {
>+		fprintf(stderr,
>+			"expected 'dummy' read(2) failure\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	read_overhead_ns = current_nsec() - read_enter_ns -
>+			1000000000ULL * RCVTIMEO_TIMEOUT_SEC;
>+
>+	if (read_overhead_ns > READ_OVERHEAD_NSEC) {
>+		fprintf(stderr,
>+			"too much time in read(2), %lu > %i ns\n",
>+			read_overhead_ns, READ_OVERHEAD_NSEC);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("WAITDONE");
>+	close(fd);
>+}
>+
>+static void test_seqpacket_timeout_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("WAITDONE");
>+	close(fd);
>+}
>+
> static struct test_case test_cases[] = {
> 	{
> 		.name = "SOCK_STREAM connection reset",
>@@ -431,6 +510,11 @@ static struct test_case test_cases[] = {
> 		.run_client = test_seqpacket_msg_trunc_client,
> 		.run_server = test_seqpacket_msg_trunc_server,
> 	},
>+	{
>+		.name = "SOCK_SEQPACKET timeout",
>+		.run_client = test_seqpacket_timeout_client,
>+		.run_server = test_seqpacket_timeout_server,
>+	},
> 	{},
> };
>
>-- 
>2.25.1

