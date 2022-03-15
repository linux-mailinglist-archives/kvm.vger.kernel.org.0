Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73F04D9BA3
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 13:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242105AbiCOM43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 08:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235491AbiCOM42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 08:56:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7FEA4474C
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 05:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647348914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/7kF6mwRMvcQL1DtiGEysf7dz4yz7QqO8NSJRvpKnr4=;
        b=DKBmqFg1HlKuETJ/TdoLqLnERW9Q5aBrSFBh7oPIdKDZ1cnexxxqndR8xjCFRPfF18mw22
        eI/YewnIsKGQkmMKmA27CG4GQIOVhQR3XpmTSn//riN/h8JAvlkzS1s+CoCq9L2VFKxX9b
        zveyLrdIdYNmAFOTkjKsJwDQg5+duQw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-Yl3YmQfVNpq3VbBk0yR4lw-1; Tue, 15 Mar 2022 08:55:13 -0400
X-MC-Unique: Yl3YmQfVNpq3VbBk0yR4lw-1
Received: by mail-qv1-f69.google.com with SMTP id h18-20020a05621402f200b00440cedaa9a2so26614qvu.17
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 05:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/7kF6mwRMvcQL1DtiGEysf7dz4yz7QqO8NSJRvpKnr4=;
        b=yAKP8XNBJTvWrALOsNoxT6MnomDrF8Kx0Z9EcD4rR7pjtrO8y0NRFqpGFhqzFmA+UR
         kgccExlmRWoljGeNvlrlXDJdIV/gfX+DrQMznIAk6mlEkkpzOEIvH4E2aB9X3zJmnybk
         K14uL4jJ7qjdEGtSjSc9XZoIXAfY9eaR3xu4fBw7qqI/KUKw35S9PescVlajy9pyp0ot
         3c5HZMHho73WHf7SSIcQkX4gXMFeMwJoW0EeSNj9tEie4YFmOVrc23hNx90st8T0T7d8
         NhjB3D/GYRzFMhw4X5QZR2yVKQp7hZCHZdcCWUOc+ywlBGQ7Nda+PX9IshNsDrEweq4T
         VXgA==
X-Gm-Message-State: AOAM530U6Ilu3OxtmPaASYeTFyUKjuXyxBstgi+B2mhCD0vHZvKd3ZA0
        /cCFE2DojxvD3+D7N+rKR5jvbTDVmy0Iqgs9+IPwoOIyrJ2tp9MHMoLP4lY/ozPjFm8UEI4CUhF
        pbvXgEsJYnEBs
X-Received: by 2002:a05:6214:2689:b0:435:be79:a17e with SMTP id gm9-20020a056214268900b00435be79a17emr20994835qvb.35.1647348913104;
        Tue, 15 Mar 2022 05:55:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBekmlL+mi9yLEYSbEo0oZTdDpBDWm38egtm8H1DGuL5A7k5WLIfNlBSOt5YUdgYGPYOnxvA==
X-Received: by 2002:a05:6214:2689:b0:435:be79:a17e with SMTP id gm9-20020a056214268900b00435be79a17emr20994818qvb.35.1647348912845;
        Tue, 15 Mar 2022 05:55:12 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id g7-20020a376b07000000b006492f19ae76sm9286561qkc.27.2022.03.15.05.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 05:55:12 -0700 (PDT)
Date:   Tue, 15 Mar 2022 13:55:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
Cc:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 3/3] af_vsock: SOCK_SEQPACKET broken buffer test
Message-ID: <20220315125504.ut3bxfw5jvuop33d@sgarzare-redhat>
References: <1bb5ce91-da53-7de9-49ba-f49f76f45512@sberdevices.ru>
 <bc309cf9-5bcf-b645-577f-8e5b0cf6f220@sberdevices.ru>
 <20220315083617.n33naazzf3se4ozo@sgarzare-redhat>
 <b452aeac-9628-5e37-e0e6-d33f8bb47b22@sberdevices.ru>
 <f05280bb-9b48-8705-a2ef-3d02ea98fd25@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f05280bb-9b48-8705-a2ef-3d02ea98fd25@sberdevices.ru>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 12:43:13PM +0000, Krasnov Arseniy Vladimirovich wrote:
>On 15.03.2022 12:35, Arseniy Krasnov wrote:
>> On 15.03.2022 11:36, Stefano Garzarella wrote:
>>> On Fri, Mar 11, 2022 at 10:58:32AM +0000, Krasnov Arseniy Vladimirovich wrote:
>>>> Add test where sender sends two message, each with own
>>>> data pattern. Reader tries to read first to broken buffer:
>>>> it has three pages size, but middle page is unmapped. Then,
>>>> reader tries to read second message to valid buffer. Test
>>>> checks, that uncopied part of first message was dropped
>>>> and thus not copied as part of second message.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>> ---
>>>> tools/testing/vsock/vsock_test.c | 121 +++++++++++++++++++++++++++++++
>>>> 1 file changed, 121 insertions(+)
>>>>
>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>> index aa2de27d0f77..686af712b4ad 100644
>>>> --- a/tools/testing/vsock/vsock_test.c
>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>> @@ -16,6 +16,7 @@
>>>> #include <linux/kernel.h>
>>>> #include <sys/types.h>
>>>> #include <sys/socket.h>
>>>> +#include <sys/mman.h>
>>>>
>>>> #include "timeout.h"
>>>> #include "control.h"
>>>> @@ -435,6 +436,121 @@ static void test_seqpacket_timeout_server(const struct test_opts *opts)
>>>>     close(fd);
>>>> }
>>>>
>>>> +#define BUF_PATTERN_1 'a'
>>>> +#define BUF_PATTERN_2 'b'
>>>> +
>>>> +static void test_seqpacket_invalid_rec_buffer_client(const struct test_opts *opts)
>>>> +{
>>>> +    int fd;
>>>> +    unsigned char *buf1;
>>>> +    unsigned char *buf2;
>>>> +    int buf_size = getpagesize() * 3;
>>>> +
>>>> +    fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>>>> +    if (fd < 0) {
>>>> +        perror("connect");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    buf1 = malloc(buf_size);
>>>> +    if (buf1 == NULL) {
>>>> +        perror("'malloc()' for 'buf1'");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    buf2 = malloc(buf_size);
>>>> +    if (buf2 == NULL) {
>>>> +        perror("'malloc()' for 'buf2'");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    memset(buf1, BUF_PATTERN_1, buf_size);
>>>> +    memset(buf2, BUF_PATTERN_2, buf_size);
>>>> +
>>>> +    if (send(fd, buf1, buf_size, 0) != buf_size) {
>>>> +        perror("send failed");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    if (send(fd, buf2, buf_size, 0) != buf_size) {
>>>> +        perror("send failed");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    close(fd);
>>>> +}
>>>> +
>>>> +static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opts)
>>>> +{
>>>> +    int fd;
>>>> +    unsigned char *broken_buf;
>>>> +    unsigned char *valid_buf;
>>>> +    int page_size = getpagesize();
>>>> +    int buf_size = page_size * 3;
>>>> +    ssize_t res;
>>>> +    int prot = PROT_READ | PROT_WRITE;
>>>> +    int flags = MAP_PRIVATE | MAP_ANONYMOUS;
>>>> +    int i;
>>>> +
>>>> +    fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>>>> +    if (fd < 0) {
>>>> +        perror("accept");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    /* Setup first buffer. */
>>>> +    broken_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
>>>> +    if (broken_buf == MAP_FAILED) {
>>>> +        perror("mmap for 'broken_buf'");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    /* Unmap "hole" in buffer. */
>>>> +    if (munmap(broken_buf + page_size, page_size)) {
>>>> +        perror("'broken_buf' setup");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    valid_buf = mmap(NULL, buf_size, prot, flags, -1, 0);
>>>> +    if (valid_buf == MAP_FAILED) {
>>>> +        perror("mmap for 'valid_buf'");
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    /* Try to fill buffer with unmapped middle. */
>>>> +    res = read(fd, broken_buf, buf_size);
>>>> +    if (res != -1) {
>>>> +        perror("invalid read result of 'broken_buf'");
>>>
>>> if `res` is valid, errno is not set, better to use fprintf(stderr, ...) printing the expected and received result.
>>> Take a look at test_stream_connection_reset()
>>
>> Ack, fix it in v2
>>
>>>
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    if (errno != ENOMEM) {
>>>> +        perror("invalid errno of 'broken_buf'");
>>>
>>> Instead of "invalid", I would say "unexpected".
>>
>> Ack
>>
>>>
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>
>>>
>>>> +
>>>> +    /* Try to fill valid buffer. */
>>>> +    res = read(fd, valid_buf, buf_size);
>>>> +    if (res != buf_size) {
>>>> +        perror("invalid read result of 'valid_buf'");
>>>
>>> I would split in 2 checks:
>>> - (res < 0) then use perror()
>>> - (res != buf_size) then use fprintf(stderr, ...) printing the expected   and received result.
>>
>> Ack
>>
>>>
>>>> +        exit(EXIT_FAILURE);
>>>> +    }
>>>> +
>>>> +    for (i = 0; i < buf_size; i++) {
>>>> +        if (valid_buf[i] != BUF_PATTERN_2) {
>>>> +            perror("invalid pattern for valid buf");
>>>
>>> errno is not set here, better to use fprintf(stderr, ...)
>>
>> Ack
>>
>>>
>>>> +            exit(EXIT_FAILURE);
>>>> +        }
>>>> +    }
>>>
>>> What about replace this for with a memcmp()?
>
>memcmp() will require special buffer with BUF_PATTERN_2 data as
>second argument. I think 'if()' condition is better here, as we
>compare each element of buffer with single byte. Anyway, 'memcmp()'
>does the same things inside itself.

Ah, I see. Okay, I agree on for()/if(), maybe we can also print more 
info (index, expected value, current value).

>
>>
>> Ack
>>
>>>
>>>> +
>>>> +
>>>> +    /* Unmap buffers. */
>>>> +    munmap(broken_buf, page_size);
>>>> +    munmap(broken_buf + page_size * 2, page_size);
>>>> +    munmap(valid_buf, buf_size);
>>>> +    close(fd);
>>>> +}
>>>> +
>>>> static struct test_case test_cases[] = {
>>>>     {
>>>>         .name = "SOCK_STREAM connection reset",
>>>> @@ -480,6 +596,11 @@ static struct test_case test_cases[] = {
>>>>         .run_client = test_seqpacket_timeout_client,
>>>>         .run_server = test_seqpacket_timeout_server,
>>>>     },
>>>> +    {
>>>> +        .name = "SOCK_SEQPACKET invalid receive buffer",
>>>> +        .run_client = test_seqpacket_invalid_rec_buffer_client,
>>>> +        .run_server = test_seqpacket_invalid_rec_buffer_server,
>>>> +    },
>>>
>>>
>>> Is this the right behavior? If read() fails because the buffer is invalid, do we throw out the whole packet?
>>>
>>> I was expecting the packet not to be consumed, have you tried AF_UNIX, does it have the same behavior?
>>
>> I've just checked AF_UNIX implementation of SEQPACKET receive in net/unix/af_unix.c. So, if 'skb_copy_datagram_msg()'
>> fails, it calls 'skb_free_datagram()'. I think this means that whole sk buff will be dropped, but anyway, i'll check
>> this behaviour in practice. See '__unix_dgram_recvmsg()' in net/unix/af_unix.c.
>
>So i've checked that assumption for SEQPACKET + AF_UNIX: when user passes broken buffer to
>the kernel(for example with unmapped page in the mid), rest of message will be dropped. Next
>read will never get tail of the dropped message.

Thanks for checking, so it seems the same behaviour.
Let's go ahead with this test :-)

Stefano

