Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1167BF3F9
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 09:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442453AbjJJHUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 03:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442436AbjJJHUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 03:20:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B5F9E
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 00:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696922395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hG4G5LHxyO9rF9s8YLsKT4ym4urhl2/BzqoAhOo/Ftk=;
        b=ey55krzyGIcrMgU7OfESKN9aXbwFPaFmql3neH7HoKiTf9aQfw5NOeag9Jd+Spz6dqalJN
        wAeUsj0hFccgfYuHJJwvEGO1AdzFVZv3Q1ajDAZTHWRmWKUl0nS0IR3pVLUJb32rH8Vmns
        8dDuej0cEVigyyLjQQZiEdanP7hptUg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-cTn16iTlP-S9E3tdmcILyA-1; Tue, 10 Oct 2023 03:19:43 -0400
X-MC-Unique: cTn16iTlP-S9E3tdmcILyA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-53342507b7fso4096159a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 00:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696922383; x=1697527183;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hG4G5LHxyO9rF9s8YLsKT4ym4urhl2/BzqoAhOo/Ftk=;
        b=eOmj83jcFV17hvCfTEW1Aa3AfQDyP9WRIrwWWJgF+2/5jF3Y64pO3FD9/QL89LSlmE
         E+YfezyG5jnibvyd7G0KY3D8z9Qx+lU6bD3Uq86FyDUWyhNzhPeCWgIB/FgQns5C7duS
         A/6Uh1X+1xvWMpPMgB6Ct1vsS1oMExqErj8Kp0I6dOk2wR7Aztn1oRwe9PBHea/711cD
         JuoqZ/ho0vNJGPf/4QwWcGxW6PHOX+BkW65UPmlf9kbEq6mpvxE8yUDog+Yu6WWbOuOp
         2m5gzr22sZ9kVYQFIoQneG1rjPOnBgIcmTQ1IyclSYK247NICh2jNvlpO3IHroHeSeGb
         5L5w==
X-Gm-Message-State: AOJu0Yyo3n22C+ImTUm14wR9Bn08W5gYK3PaRIg2ra5Cgxjsemvy9MHj
        dY7yAGV0wwQCsGtiwZ/GoktcUDDZypzL4uO8reRRUBpnDzkpYiLOdXCoEbElOVIH1aXv5j6SgxX
        +5ck37b/g94nE
X-Received: by 2002:aa7:c301:0:b0:523:2e0e:5462 with SMTP id l1-20020aa7c301000000b005232e0e5462mr12303703edq.42.1696922382713;
        Tue, 10 Oct 2023 00:19:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4DJEvSN+yZmfl2FrbqK6Z817nYmTKVXhRBgo48yXE16BJYDaAP/1S+GzFzRPmr42qxiD1yA==
X-Received: by 2002:aa7:c301:0:b0:523:2e0e:5462 with SMTP id l1-20020aa7c301000000b005232e0e5462mr12303687edq.42.1696922382204;
        Tue, 10 Oct 2023 00:19:42 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-251.retail.telecomitalia.it. [79.46.200.251])
        by smtp.gmail.com with ESMTPSA id o26-20020a056402039a00b00538538f1fcesm7188966edv.47.2023.10.10.00.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 00:19:41 -0700 (PDT)
Date:   Tue, 10 Oct 2023 09:19:36 +0200
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
Subject: Re: [PATCH net-next v3 10/12] test/vsock: MSG_ZEROCOPY flag tests
Message-ID: <pxwl3veyqs5xuvww7dyhj45u7okmjmc2hao3z5a7pzkxwgljcf@qtgi3ht7yet7>
References: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
 <20231007172139.1338644-11-avkrasnov@salutedevices.com>
 <q3246d73b2u6lquey2b5ie4xzmsoe6lqqq6nqaq6drne2lx6tt@fpe6gdvuqzll>
 <ce166660-15a2-92ac-f736-179a8bc2adde@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce166660-15a2-92ac-f736-179a8bc2adde@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023 at 11:24:18PM +0300, Arseniy Krasnov wrote:
>
>
>On 09.10.2023 18:17, Stefano Garzarella wrote:
>> On Sat, Oct 07, 2023 at 08:21:37PM +0300, Arseniy Krasnov wrote:
>>> This adds three tests for MSG_ZEROCOPY feature:
>>> 1) SOCK_STREAM tx with different buffers.
>>> 2) SOCK_SEQPACKET tx with different buffers.
>>> 3) SOCK_STREAM test to read empty error queue of the socket.
>>>
>>> Patch also works as preparation for the next patches for tools in this
>>> patchset: vsock_perf and vsock_uring_test:
>>> 1) Adds several new functions to util.c - they will be also used by
>>>   vsock_uring_test.
>>> 2) Adds two new functions for MSG_ZEROCOPY handling to a new header
>>>   file - such header will be shared between vsock_test, vsock_perf and
>>>   vsock_uring_test, thus avoiding code copy-pasting.
>>>
>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> ---
>>> Changelog:
>>> v1 -> v2:
>>>  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
>>> v2 -> v3:
>>>  * Patch was reworked. Now it is also preparation patch (see commit
>>>    message). Shared stuff for 'vsock_perf' and tests is placed to a
>>>    new header file, while shared code between current test tool and
>>>    future uring test is placed to the 'util.c'. I think, that making
>>>    this patch as preparation allows to reduce number of changes in the
>>>    next patches in this patchset.
>>>  * Make 'struct vsock_test_data' private by placing it to the .c file.
>>>    Also add comments to this struct to clarify sense of its fields.
>>>
>>> tools/testing/vsock/Makefile              |   2 +-
>>> tools/testing/vsock/msg_zerocopy_common.h |  92 ++++++
>>> tools/testing/vsock/util.c                | 110 +++++++
>>> tools/testing/vsock/util.h                |   5 +
>>> tools/testing/vsock/vsock_test.c          |  16 +
>>> tools/testing/vsock/vsock_test_zerocopy.c | 367 ++++++++++++++++++++++
>>> tools/testing/vsock/vsock_test_zerocopy.h |  15 +
>>> 7 files changed, 606 insertions(+), 1 deletion(-)
>>> create mode 100644 tools/testing/vsock/msg_zerocopy_common.h
>>> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
>>> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h
>>>
>>> diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>>> index 21a98ba565ab..1a26f60a596c 100644
>>> --- a/tools/testing/vsock/Makefile
>>> +++ b/tools/testing/vsock/Makefile
>>> @@ -1,7 +1,7 @@
>>> # SPDX-License-Identifier: GPL-2.0-only
>>> all: test vsock_perf
>>> test: vsock_test vsock_diag_test
>>> -vsock_test: vsock_test.o timeout.o control.o util.o
>>> +vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
>>> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
>>> vsock_perf: vsock_perf.o
>>>
>>> diff --git a/tools/testing/vsock/msg_zerocopy_common.h b/tools/testing/vsock/msg_zerocopy_common.h
>>> new file mode 100644
>>> index 000000000000..ce89f1281584
>>> --- /dev/null
>>> +++ b/tools/testing/vsock/msg_zerocopy_common.h
>>> @@ -0,0 +1,92 @@
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +#ifndef MSG_ZEROCOPY_COMMON_H
>>> +#define MSG_ZEROCOPY_COMMON_H
>>> +
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <sys/types.h>
>>> +#include <sys/socket.h>
>>> +#include <linux/errqueue.h>
>>> +
>>> +#ifndef SOL_VSOCK
>>> +#define SOL_VSOCK    287
>>> +#endif
>>> +
>>> +#ifndef VSOCK_RECVERR
>>> +#define VSOCK_RECVERR    1
>>> +#endif
>>> +
>>> +static void enable_so_zerocopy(int fd)
>>> +{
>>> +    int val = 1;
>>> +
>>> +    if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
>>> +        perror("setsockopt");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +}
>>> +
>>> +static void vsock_recv_completion(int fd, const bool *zerocopied) __maybe_unused;
>>
>> To avoid this, maybe we can implement those functions in .c file and
>> link the object.
>>
>> WDYT?
>>
>> Ah, here (cc (GCC) 13.2.1 20230728 (Red Hat 13.2.1-1)) the build is
>> failing:
>>
>> In file included from vsock_perf.c:23:
>> msg_zerocopy_common.h: In function ‘vsock_recv_completion’:
>> msg_zerocopy_common.h:29:67: error: expected declaration specifiers before ‘__maybe_unused’
>>    29 | static void vsock_recv_completion(int fd, const bool *zerocopied) __maybe_unused;
>>       |                                                                   ^~~~~~~~~~~~~~
>> msg_zerocopy_common.h:31:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘{’ token
>>    31 | {
>>       | ^
>>
>>> +static void vsock_recv_completion(int fd, const bool *zerocopied)
>>> +{
>>> +    struct sock_extended_err *serr;
>>> +    struct msghdr msg = { 0 };
>>> +    char cmsg_data[128];
>>> +    struct cmsghdr *cm;
>>> +    ssize_t res;
>>> +
>>> +    msg.msg_control = cmsg_data;
>>> +    msg.msg_controllen = sizeof(cmsg_data);
>>> +
>>> +    res = recvmsg(fd, &msg, MSG_ERRQUEUE);
>>> +    if (res) {
>>> +        fprintf(stderr, "failed to read error queue: %zi\n", res);
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    cm = CMSG_FIRSTHDR(&msg);
>>> +    if (!cm) {
>>> +        fprintf(stderr, "cmsg: no cmsg\n");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (cm->cmsg_level != SOL_VSOCK) {
>>> +        fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (cm->cmsg_type != VSOCK_RECVERR) {
>>> +        fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    serr = (void *)CMSG_DATA(cm);
>>> +    if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
>>> +        fprintf(stderr, "serr: wrong origin: %u\n", serr->ee_origin);
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (serr->ee_errno) {
>>> +        fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    /* This flag is used for tests, to check that transmission was
>>> +     * performed as expected: zerocopy or fallback to copy. If NULL
>>> +     * - don't care.
>>> +     */
>>> +    if (!zerocopied)
>>> +        return;
>>> +
>>> +    if (*zerocopied && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>>> +        fprintf(stderr, "serr: was copy instead of zerocopy\n");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (!*zerocopied && !(serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>>> +        fprintf(stderr, "serr: was zerocopy instead of copy\n");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +}
>>> +
>>> +#endif /* MSG_ZEROCOPY_COMMON_H */
>>> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>>> index 6779d5008b27..b1770edd8cc1 100644
>>> --- a/tools/testing/vsock/util.c
>>> +++ b/tools/testing/vsock/util.c
>>> @@ -11,10 +11,12 @@
>>> #include <stdio.h>
>>> #include <stdint.h>
>>> #include <stdlib.h>
>>> +#include <string.h>
>>> #include <signal.h>
>>> #include <unistd.h>
>>> #include <assert.h>
>>> #include <sys/epoll.h>
>>> +#include <sys/mman.h>
>>>
>>> #include "timeout.h"
>>> #include "control.h"
>>> @@ -444,3 +446,111 @@ unsigned long hash_djb2(const void *data, size_t len)
>>>
>>>     return hash;
>>> }
>>> +
>>> +size_t iovec_bytes(const struct iovec *iov, size_t iovnum)
>>> +{
>>> +    size_t bytes;
>>> +    int i;
>>> +
>>> +    for (bytes = 0, i = 0; i < iovnum; i++)
>>> +        bytes += iov[i].iov_len;
>>> +
>>> +    return bytes;
>>> +}
>>> +
>>> +unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum)
>>> +{
>>> +    unsigned long hash;
>>> +    size_t iov_bytes;
>>> +    size_t offs;
>>> +    void *tmp;
>>> +    int i;
>>> +
>>> +    iov_bytes = iovec_bytes(iov, iovnum);
>>> +
>>> +    tmp = malloc(iov_bytes);
>>> +    if (!tmp) {
>>> +        perror("malloc");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    for (offs = 0, i = 0; i < iovnum; i++) {
>>> +        memcpy(tmp + offs, iov[i].iov_base, iov[i].iov_len);
>>> +        offs += iov[i].iov_len;
>>> +    }
>>> +
>>> +    hash = hash_djb2(tmp, iov_bytes);
>>> +    free(tmp);
>>> +
>>> +    return hash;
>>> +}
>>> +
>>> +struct iovec *iovec_from_test_data(const struct iovec *test_iovec, int iovnum)
>>
>> From the name this function seems related to vsock_test_data, so I'd
>> suggest to move this and free_iovec_test_data() in vsock_test_zerocopy.c
>>
>>> +{
>>> +    struct iovec *iovec;
>>> +    int i;
>>> +
>>> +    iovec = malloc(sizeof(*iovec) * iovnum);
>>> +    if (!iovec) {
>>> +        perror("malloc");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    for (i = 0; i < iovnum; i++) {
>>> +        iovec[i].iov_len = test_iovec[i].iov_len;
>>> +
>>> +        iovec[i].iov_base = mmap(NULL, iovec[i].iov_len,
>>> +                     PROT_READ | PROT_WRITE,
>>> +                     MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
>>> +                     -1, 0);
>>> +        if (iovec[i].iov_base == MAP_FAILED) {
>>> +            perror("mmap");
>>> +            exit(EXIT_FAILURE);
>>> +        }
>>> +
>>> +        if (test_iovec[i].iov_base != MAP_FAILED)
>>> +            iovec[i].iov_base += (uintptr_t)test_iovec[i].iov_base;
>>> +    }
>>> +
>>> +    /* Unmap "invalid" elements. */
>>> +    for (i = 0; i < iovnum; i++) {
>>> +        if (test_iovec[i].iov_base == MAP_FAILED) {
>>> +            if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>>> +                perror("munmap");
>>> +                exit(EXIT_FAILURE);
>>> +            }
>>> +        }
>>> +    }
>>> +
>>> +    for (i = 0; i < iovnum; i++) {
>>> +        int j;
>>> +
>>> +        if (test_iovec[i].iov_base == MAP_FAILED)
>>> +            continue;
>>> +
>>> +        for (j = 0; j < iovec[i].iov_len; j++)
>>> +            ((uint8_t *)iovec[i].iov_base)[j] = rand() & 0xff;
>>> +    }
>>> +
>>> +    return iovec;
>>> +}
>>> +
>>> +void free_iovec_test_data(const struct iovec *test_iovec,
>>> +              struct iovec *iovec, int iovnum)
>>> +{
>>> +    int i;
>>> +
>>> +    for (i = 0; i < iovnum; i++) {
>>> +        if (test_iovec[i].iov_base != MAP_FAILED) {
>>> +            if (test_iovec[i].iov_base)
>>> +                iovec[i].iov_base -= (uintptr_t)test_iovec[i].iov_base;
>>> +
>>> +            if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>>> +                perror("munmap");
>>> +                exit(EXIT_FAILURE);
>>> +            }
>>> +        }
>>> +    }
>>> +
>>> +    free(iovec);
>>> +}
>>> diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>>> index e5407677ce05..4cacb8d804c1 100644
>>> --- a/tools/testing/vsock/util.h
>>> +++ b/tools/testing/vsock/util.h
>>> @@ -53,4 +53,9 @@ void list_tests(const struct test_case *test_cases);
>>> void skip_test(struct test_case *test_cases, size_t test_cases_len,
>>>            const char *test_id_str);
>>> unsigned long hash_djb2(const void *data, size_t len);
>>> +size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
>>> +unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum);
>>> +struct iovec *iovec_from_test_data(const struct iovec *test_iovec, int iovnum);
>>> +void free_iovec_test_data(const struct iovec *test_iovec,
>>> +              struct iovec *iovec, int iovnum);
>>> #endif /* UTIL_H */
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index da4cb819a183..c1f7bc9abd22 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -21,6 +21,7 @@
>>> #include <poll.h>
>>> #include <signal.h>
>>>
>>> +#include "vsock_test_zerocopy.h"
>>> #include "timeout.h"
>>> #include "control.h"
>>> #include "util.h"
>>> @@ -1269,6 +1270,21 @@ static struct test_case test_cases[] = {
>>>         .run_client = test_stream_shutrd_client,
>>>         .run_server = test_stream_shutrd_server,
>>>     },
>>> +    {
>>> +        .name = "SOCK_STREAM MSG_ZEROCOPY",
>>> +        .run_client = test_stream_msgzcopy_client,
>>> +        .run_server = test_stream_msgzcopy_server,
>>> +    },
>>> +    {
>>> +        .name = "SOCK_SEQPACKET MSG_ZEROCOPY",
>>> +        .run_client = test_seqpacket_msgzcopy_client,
>>> +        .run_server = test_seqpacket_msgzcopy_server,
>>> +    },
>>> +    {
>>> +        .name = "SOCK_STREAM MSG_ZEROCOPY empty MSG_ERRQUEUE",
>>> +        .run_client = test_stream_msgzcopy_empty_errq_client,
>>> +        .run_server = test_stream_msgzcopy_empty_errq_server,
>>> +    },
>>>     {},
>>> };
>>>
>>> diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
>>> new file mode 100644
>>> index 000000000000..af14efdf334b
>>> --- /dev/null
>>> +++ b/tools/testing/vsock/vsock_test_zerocopy.c
>>> @@ -0,0 +1,367 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/* MSG_ZEROCOPY feature tests for vsock
>>> + *
>>> + * Copyright (C) 2023 SberDevices.
>>> + *
>>> + * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> + */
>>> +
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <sys/mman.h>
>>> +#include <unistd.h>
>>> +#include <poll.h>
>>> +#include <linux/errqueue.h>
>>> +#include <linux/kernel.h>
>>> +#include <errno.h>
>>> +
>>> +#include "control.h"
>>> +#include "vsock_test_zerocopy.h"
>>> +#include "msg_zerocopy_common.h"
>>> +
>>> +#define PAGE_SIZE        4096
>>
>> In some tests I saw `sysconf(_SC_PAGESIZE)` is used,
>> e.g. in selftests/ptrace/peeksiginfo.c:
>>
>> #ifndef PAGE_SIZE
>> #define PAGE_SIZE sysconf(_SC_PAGESIZE)
>> #endif
>>
>> WDYT?
>
>Only small problem with that - in this case I can't use PAGE_SIZE
>as array initializer. I think to add some reserved constant value
>to designate that iov element must be size of page, then use this
>value as initializer and handle it during test iov creating...

Okay I see. Maybe I'm overthinking!
It is just a test, let's do not complicate it.

Feel free to use the previous version, I'd just add the guards.

Thanks,
Stefano

