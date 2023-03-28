Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AB76CBB61
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 11:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbjC1Jpl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 05:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjC1JpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 05:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B58F65B6
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679996670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GyxpUUnFruYhLDW97U96aBL0RSI09u9J7yvwV5Q6QsQ=;
        b=iqe5j9qUCnWbGqE+d1ov1worlyZrY/2ilgjtJfeMeAXNWB2sksgbSi9VrX7+LJGtxwzpoQ
        2GLWucC3BF9OKabnXyTFBpe8WiO+XpXDL8sDEyN0V+YNUc3Arbzlx4qn9f98KejW7wQIfs
        mk1RJe4knto8/iMgasMAm/7XP7h8dHY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-qC-eiThwNWeazRLII0Phnw-1; Tue, 28 Mar 2023 05:44:29 -0400
X-MC-Unique: qC-eiThwNWeazRLII0Phnw-1
Received: by mail-qk1-f199.google.com with SMTP id b142-20020ae9eb94000000b007486a8b9ae9so2739802qkg.11
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 02:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679996669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyxpUUnFruYhLDW97U96aBL0RSI09u9J7yvwV5Q6QsQ=;
        b=04WFpi/sw6lssFiHTcaOcEsQSwqPNYRCTHJkiZJQW1tpcAJ4+AwiP4q1S40YBPcNlw
         Ml1sYUWjByXKTI5BdJMS5lwArVQOMA1Hn6QYSAPAcme8TPNi15fPZCnxQ+EevawFp9Lb
         cUNlvleqK8cCxBPzXgIQ/wXfJqnpz2jGgNx30z8erftwEKyXpgVzoqnIua/NY41RcvLw
         0UILZ+X6C983/0ZcvxpTSvmRqOUng30gWBYwxtKMReS/vfokfSevmYt7dS05k94y6WnH
         xkIRJYIW8d5XDdVeYOTju8lvipst6uUCu3bTCWnZ8mfOYjtRNt0DFMPVUt5o5OQtrIee
         iWog==
X-Gm-Message-State: AO0yUKU4KvqRLW37aipZiKHmJEQOfj6z9z4SdPQdr+etrKQk0cc280co
        kzWPUablAeURCEn9pS6e0b9nzWdRLnlRrDs5Iji6LH5uZsYW5bxgFdpV53zqzRQDXg2BvSa71uY
        OAP0mh780Ow0R
X-Received: by 2002:a05:622a:13cc:b0:3e3:89a5:192f with SMTP id p12-20020a05622a13cc00b003e389a5192fmr22427363qtk.61.1679996669193;
        Tue, 28 Mar 2023 02:44:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set+hHbSqMRRzFJgBA3hfVusjzZ/rusAYAK9YK1O6yI6x5F2UoicEOao0GkyXZn34kiaPcnzB3Q==
X-Received: by 2002:a05:622a:13cc:b0:3e3:89a5:192f with SMTP id p12-20020a05622a13cc00b003e389a5192fmr22427348qtk.61.1679996668960;
        Tue, 28 Mar 2023 02:44:28 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id 11-20020a05620a040b00b007468733cd1fsm6632277qkp.58.2023.03.28.02.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:44:28 -0700 (PDT)
Date:   Tue, 28 Mar 2023 11:44:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/2] vsock/test: update expected return values
Message-ID: <eysn6yxwzwe4mirxk6maqubfdu33yy6b6jjrxa6lqexxxqghln@3ean24dkrf5v>
References: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
 <f302d3de-28aa-e0b1-1fed-88d3c3bd606a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f302d3de-28aa-e0b1-1fed-88d3c3bd606a@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 26, 2023 at 01:14:01AM +0300, Arseniy Krasnov wrote:
>This updates expected return values for invalid buffer test. Now such
>values are returned from transport, not from af_vsock.c.

Since only virtio transport supports it for now, it's okay.
In the future we should make sure that we have the same behavior between 
transports.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/vsock_test.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 3de10dbb50f5..a91d0ef963be 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -723,7 +723,7 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
> 		exit(EXIT_FAILURE);
> 	}
>
>-	if (errno != ENOMEM) {
>+	if (errno != EFAULT) {
> 		perror("unexpected errno of 'broken_buf'");
> 		exit(EXIT_FAILURE);
> 	}
>@@ -887,7 +887,7 @@ static void test_inv_buf_client(const struct test_opts *opts, bool stream)
> 		exit(EXIT_FAILURE);
> 	}
>
>-	if (errno != ENOMEM) {
>+	if (errno != EFAULT) {
> 		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
> 		exit(EXIT_FAILURE);
> 	}
>-- 
>2.25.1
>

