Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F3F579FCE
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbiGSNi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiGSNiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:38:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04954F2CC9
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658235164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TYVq4WjdOQMHhc5px4YCUTqr6DUNRdDOEbVtXRDK/f8=;
        b=SOeEYKgs3DAGzFD5EJ9VGpa4mAvdzvysO/Ty8DFZ99XedfkovZh+iFHbNb4hCb3YR4YKoC
        7LAUzHkGFPQynxiDBVXne4GeNHZrZ8nLUBdVXJP2LoJMWLsDqRcjraa+Cr0DE/+HauZtLF
        336zgTodD/4WInPBL3iZhD6pzl3fROs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-0BrQDTCSMKK1HgYzNv5M8w-1; Tue, 19 Jul 2022 08:52:37 -0400
X-MC-Unique: 0BrQDTCSMKK1HgYzNv5M8w-1
Received: by mail-qk1-f200.google.com with SMTP id e128-20020a376986000000b006af6adf035cso11601930qkc.8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TYVq4WjdOQMHhc5px4YCUTqr6DUNRdDOEbVtXRDK/f8=;
        b=6IvYjhxgNJZTBhrbBeMrb1EZB/pzknrWKZ3258hIc4MHt7aHw69UgK19yPju0KRgtK
         0LHbWnqYpTUKAU8skrNhmDvAmhyZosfIw90eOkDaq2nnzH9Rl5droYo8LCzoCVEGePtY
         drZVCZvrBmc4Vn6N6aPXR73JoKgl87UTqExg8hv4MIMZy4rLDesBf38VHEKXbxcVgPWW
         E9giOKID8ddLVkFwGEkoF3aCi13q8IZk35ezbwDQ6N/HjKZaR0cYs0ipVY5KsW08JbhP
         mtcOodSfqgNOolJalEXnVBfpun6qpQlsEWwOfBKKp3K9adXqVDoiB3ogdQI+c6sWDzDy
         T8zg==
X-Gm-Message-State: AJIora+Jm3I9XIc9S7ALSzUv44UMTB6+jt7+MVCHa/AVfCDB710FeURe
        FIApgvqjWTMmrhIbNc9qSjn4Kxfqz4HU6SFSk/337RA8ABfPD8LJxvCKlOZb/fLI3lzeRBbkeNF
        9UGttKdVTX7qu
X-Received: by 2002:a37:614:0:b0:6b5:cda7:694b with SMTP id 20-20020a370614000000b006b5cda7694bmr13081906qkg.532.1658235157514;
        Tue, 19 Jul 2022 05:52:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u9pkG+DbLrrLN376mRVwAbaPHBtJQ48OByRq4neWnlpWQY9teeIXv+aG4MfOrc28E2dEFUWw==
X-Received: by 2002:a37:614:0:b0:6b5:cda7:694b with SMTP id 20-20020a370614000000b006b5cda7694bmr13081889qkg.532.1658235157281;
        Tue, 19 Jul 2022 05:52:37 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id c26-20020a05620a269a00b006b5ba7b9a6fsm13373178qkp.35.2022.07.19.05.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:52:36 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:52:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Message-ID: <20220719125227.bktosg3yboeaeoo5@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 08:19:06AM +0000, Arseniy Krasnov wrote:
>This adds test to check, that when poll() returns POLLIN and
>POLLRDNORM bits, next read call won't block.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 90 ++++++++++++++++++++++++++++++++
> 1 file changed, 90 insertions(+)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index dc577461afc2..8e394443eaf6 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -18,6 +18,7 @@
> #include <sys/socket.h>
> #include <time.h>
> #include <sys/mman.h>
>+#include <poll.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -596,6 +597,90 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
> 	close(fd);
> }
>
>+static void test_stream_poll_rcvlowat_server(const struct test_opts *opts)
>+{
>+#define RCVLOWAT_BUF_SIZE 128
>+	int fd;
>+	int i;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* Send 1 byte. */
>+	send_byte(fd, 1, 0);
>+
>+	control_writeln("SRVSENT");
>+
>+	/* Just empirically delay value. */
>+	sleep(4);

Why we need this sleep()?

