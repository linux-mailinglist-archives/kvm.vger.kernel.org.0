Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C17AEDA4
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 15:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbjIZNFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 09:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbjIZNFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 09:05:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED08FC
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 06:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695733479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pw3uLk1RX7EItsMeljDJQUwIv63n45/6NY/27SYTAmo=;
        b=FOdNHx0O7Mzvr+gNApSPjRGbXufqoyCY6rUhahLgkbA50Qcg8XnOstCw4iz8udCis89Wvb
        jVZ7p9LL8wAWDG5JVgvRDc11Vn2t1JQiwKWPVSOW25VJjhTbemtGVGCSahTuMpsKkdc/I0
        rXPEKg1j+M6ZUWGYWXTcXAqcDgDMc1g=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617--bj1y4WXNoaZDuK1QlVOjA-1; Tue, 26 Sep 2023 09:04:37 -0400
X-MC-Unique: -bj1y4WXNoaZDuK1QlVOjA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ae686dafedso724998866b.3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 06:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695733476; x=1696338276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pw3uLk1RX7EItsMeljDJQUwIv63n45/6NY/27SYTAmo=;
        b=o45tb344Jksegzt1jDGdNUMl+MKzQPTYN1CJU+0akVAyXYIGyK3Gc8VTAnpFFtWSeB
         Cpv0gax875kdCG7BybtwDuVzg31I5RA1wE0xeZBbqFvHrOrTJkClVmnzCz1GctoSZL4a
         ThpUxlt1LnVuokHmR0lVvHTAO8tmDEDiLvjEoYdWCS52LrANGRrKppCH8J/Au/8tb5+M
         OLrvYdn0bDgfn9kB21hEPpRM4pltn3qfZ1JxqitnHkTEgCxieH0cAfSvqkF5xNOdItTU
         2zgWFLxrgknYwTFOD29rIx2nfKLTRzSc8IGiUwOwgJzT49QD1xQsB632rlo1hr/TklEo
         FL3A==
X-Gm-Message-State: AOJu0YyOFlRwF9HbvPhpy8Ddge+86qCOVlgM9J6C5AT9DEijw4OtFDZZ
        ui7EwO29D1aMR+SeV6Upx9MeCQAo3mCcZOG0KyJhG6ESje9PChiUGFcT5lD9wZQ+c9tXVlO5SLs
        QCE3xBczA1OVy
X-Received: by 2002:a17:906:3299:b0:9ae:6196:a4d0 with SMTP id 25-20020a170906329900b009ae6196a4d0mr8605612ejw.17.1695733476618;
        Tue, 26 Sep 2023 06:04:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPT+qJWI4CE1FK30C7JELaHKq82GsQA7VABRt7UrHezh/PpcrPOPNsUXvYOw92dsnA/haacQ==
X-Received: by 2002:a17:906:3299:b0:9ae:6196:a4d0 with SMTP id 25-20020a170906329900b009ae6196a4d0mr8605597ejw.17.1695733476299;
        Tue, 26 Sep 2023 06:04:36 -0700 (PDT)
Received: from sgarzare-redhat ([46.6.146.182])
        by smtp.gmail.com with ESMTPSA id r11-20020a170906704b00b00999bb1e01dfsm7746690ejj.52.2023.09.26.06.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 06:04:35 -0700 (PDT)
Date:   Tue, 26 Sep 2023 15:04:31 +0200
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
Subject: Re: [PATCH net-next v1 12/12] test/vsock: io_uring rx/tx tests
Message-ID: <kfuzqzhrgdk5f5arbq4n3vd6vro6533aeysqhdgqevcqxrdm6e@57ylpkc2t4q4>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <20230922052428.4005676-13-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230922052428.4005676-13-avkrasnov@salutedevices.com>
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

On Fri, Sep 22, 2023 at 08:24:28AM +0300, Arseniy Krasnov wrote:
>This adds set of tests which use io_uring for rx/tx. This test suite is
>implemented as separated util like 'vsock_test' and has the same set of
>input arguments as 'vsock_test'. These tests only cover cases of data
>transmission (no connect/bind/accept etc).
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v5(big patchset) -> v1:
>  * Use LDLIBS instead of LDFLAGS.
>
> tools/testing/vsock/Makefile           |   7 +-
> tools/testing/vsock/vsock_uring_test.c | 321 +++++++++++++++++++++++++
> 2 files changed, 327 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/vsock/vsock_uring_test.c
>
>diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>index 1a26f60a596c..c84380bfc18d 100644
>--- a/tools/testing/vsock/Makefile
>+++ b/tools/testing/vsock/Makefile
>@@ -1,12 +1,17 @@
> # SPDX-License-Identifier: GPL-2.0-only
>+ifeq ($(MAKECMDGOALS),vsock_uring_test)
>+LDLIBS = -luring
>+endif
>+

This will fails if for example we call make with more targets,
e.g. `make vsock_test vsock_uring_test`.

I'd suggest to use something like this:

--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -1,13 +1,11 @@
  # SPDX-License-Identifier: GPL-2.0-only
-ifeq ($(MAKECMDGOALS),vsock_uring_test)
-LDLIBS = -luring
-endif
-
  all: test vsock_perf
  test: vsock_test vsock_diag_test
  vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
  vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
  vsock_perf: vsock_perf.o
+
+vsock_uring_test: LDLIBS = -luring
  vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o

  CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE

> all: test vsock_perf
> test: vsock_test vsock_diag_test
> vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
> vsock_perf: vsock_perf.o
>+vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o

Shoud we add this new test to the "test" target as well?

Stefano

