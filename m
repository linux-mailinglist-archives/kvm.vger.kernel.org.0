Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C213E8CF4
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 11:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhHKJNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 05:13:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236314AbhHKJNJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 05:13:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628673165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xXwE7CHo/JY+uapmOrMsy/SWDFuCzkqxTC2MlTmyXRU=;
        b=PNqRbR0LCPP26r8qJyRM55VysXR+ZyvAF8CTULKwFk15qy1NRgy2UoYSCC2s5YBYa9vs6C
        9Phodca/oMtaaqWr4kqj1oOs/oRrI5MjMn52c9p8gLUcZ4fwVd+ateECb8aitmXugn9e7B
        lW5rIlePq0M6sar42bmsQUDYctNx3go=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-vFdS7mAYO6Wd1Shc5pZrZA-1; Wed, 11 Aug 2021 05:12:44 -0400
X-MC-Unique: vFdS7mAYO6Wd1Shc5pZrZA-1
Received: by mail-ed1-f69.google.com with SMTP id n4-20020aa7c6840000b02903be94ce771fso353135edq.11
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 02:12:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xXwE7CHo/JY+uapmOrMsy/SWDFuCzkqxTC2MlTmyXRU=;
        b=hv/Cm5QovZT9QodJ9X7FQKDKrs5REUzBed9weBSlggGbJ1ZsnYFHFTN0ydYcgyRC/t
         MGthpAVXOdMasZinpaHf3vVbuCnTyIEeLJRNY+5Qq6yMmiMr7ScYYqYxuKIkEWXgJ9gI
         XBFYBYlaTXsG+y5X9OQb3zVL8Tte/WRXtACwonR2+/5sUNZOetDLgbCgAthkMf9bE5hQ
         G2XFBqqi5Ec6BfSGw5gLvvd33eq/Cbi4Sz2cxZzCwhWQeyIg7C6qSK7su2JMjdez04RK
         aHIug3cshXG9f8v8VeE3leFkCtv6ORjvt2AulPKy0ssQTqI4lxqZuIzpZ7yBNAZu+bJe
         V1dg==
X-Gm-Message-State: AOAM531rrcKwsEvKdyKWiGgw/mJj+BfGOfQTVd6+P7Uayc9qVwpv2Ddy
        uAASdZMA2j5s0y0WC9o+iQl4TzPlUQkGEjBUyQSC4p++lp3P1viHtJShckBT+mnqKpNOTuxlyPu
        Ga/5gb3RnUOjr
X-Received: by 2002:a17:906:b1d3:: with SMTP id bv19mr1140407ejb.361.1628673163552;
        Wed, 11 Aug 2021 02:12:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOBdpK/bCd9lXs8Es1fYDQDN9tg88WZ+etc/k124zb/U4oV6dt2a1qRBU8C9IEa088GmY3XQ==
X-Received: by 2002:a17:906:b1d3:: with SMTP id bv19mr1140394ejb.361.1628673163432;
        Wed, 11 Aug 2021 02:12:43 -0700 (PDT)
Received: from steredhat (a-nu5-14.tin.it. [212.216.181.13])
        by smtp.gmail.com with ESMTPSA id ee11sm8306374edb.26.2021.08.11.02.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 02:12:43 -0700 (PDT)
Date:   Wed, 11 Aug 2021 11:12:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 5/5] vsock_test: update message bounds test for
 MSG_EOR
Message-ID: <20210811091240.jbum3572eelgbbpi@steredhat>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
 <20210810114119.1215014-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810114119.1215014-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 02:41:16PM +0300, Arseny Krasnov wrote:
>Set 'MSG_EOR' in one of message sent, check that 'MSG_EOR'
>is visible in corresponding message at receiver.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> tools/testing/vsock/vsock_test.c | 8 +++++++-
> 1 file changed, 7 insertions(+), 1 deletion(-)
>
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index 67766bfe176f..2a3638c0a008 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -282,6 +282,7 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
> }
>
> #define MESSAGES_CNT 7
>+#define MSG_EOR_IDX (MESSAGES_CNT / 2)
> static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
> {
> 	int fd;
>@@ -294,7 +295,7 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>
> 	/* Send several messages, one with MSG_EOR flag */
> 	for (int i = 0; i < MESSAGES_CNT; i++)
>-		send_byte(fd, 1, 0);
>+		send_byte(fd, 1, (i == MSG_EOR_IDX) ? MSG_EOR : 0);
>
> 	control_writeln("SENDDONE");
> 	close(fd);
>@@ -324,6 +325,11 @@ static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
> 			perror("message bound violated");
> 			exit(EXIT_FAILURE);
> 		}
>+
>+		if ((i == MSG_EOR_IDX) ^ !!(msg.msg_flags & MSG_EOR)) {
>+			perror("MSG_EOR");
>+			exit(EXIT_FAILURE);
>+		}
> 	}
>
> 	close(fd);
>-- 
>2.25.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

