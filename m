Return-Path: <kvm+bounces-2747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE437FD2E8
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D21371C210AB
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7FEB1803B;
	Wed, 29 Nov 2023 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IMZTPVbc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3667D1BC1
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701250617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmfiUoMGCSqDA5zypbVWGdwfGo6gARdw5ZkS+2p63ME=;
	b=IMZTPVbc7u7/q4kYkllsrV02/6nHuHH2+bFeLfuWvLRID5lw686Yf1uyXGaWtKU6aSHgQz
	xpHHR0bRdVPbH2PT48PaxVlcMXa8vMIgkv58SGanY3K9c2V/VQaANZTotRrC0sYf0RVNi8
	YakltyQS/k7JINbK8fXeg8u2PtIA0Vs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-kDyIPOg6PKKxJTTn2036KA-1; Wed, 29 Nov 2023 04:36:56 -0500
X-MC-Unique: kDyIPOg6PKKxJTTn2036KA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-408695c377dso42804725e9.2
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 01:36:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701250615; x=1701855415;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KmfiUoMGCSqDA5zypbVWGdwfGo6gARdw5ZkS+2p63ME=;
        b=wYCR4mZC+hY/Gm8tCEQ6p90Uwhl//tkYVWFI3x9CXrNAT+bHyiN1qQEJDYxVypH/ah
         gYy5up+30qkf1SBCiDXoJOLggGFXGNW+UWl9YStH3NInVvfEK8Pbv8Zw4e92m22Zijv1
         AU4kb5hw7gQBeSvcBk5/ox/mQEPOyEbwUUHOCTFgI5KTmDtwX/6wDBhEpxoxXUu4hlqn
         qQLqYbMHdUWofELAKxBPSK8i9X99BLJIDx/XMU0w7arTHgqcSpk/gGF9oWz4BEjK3gJO
         sPFsHv9/zW9LKlpayoHQr7Cv/moIB0pdVJeYp9F+3awAASpTWvygMIHPC7hr3bg03cp7
         KF8A==
X-Gm-Message-State: AOJu0Yy0YqbcFbSjcmkWl+cLQhlv0aPDWcQbhGBO9rh8VXDU9vZyfSjF
	XFrvEwrHHo7UvYUy/LJqxycdwVb2hNvw/l+j1VkdzzXJYoeDIbMO4PdNJy/cqR8lBTBzsPQqMME
	ebTAd9KDJAoYn
X-Received: by 2002:a05:600c:46cc:b0:402:e68f:8896 with SMTP id q12-20020a05600c46cc00b00402e68f8896mr9785473wmo.0.1701250614867;
        Wed, 29 Nov 2023 01:36:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4BRcthRqpUqHsj2H4jRhD7y7b/qGrQhDTQGqXi1seM0N+RIMB0GeDrMRO80d/ClXyeYP18g==
X-Received: by 2002:a05:600c:46cc:b0:402:e68f:8896 with SMTP id q12-20020a05600c46cc00b00402e68f8896mr9785450wmo.0.1701250614447;
        Wed, 29 Nov 2023 01:36:54 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id j7-20020a05600c190700b0040b43da0bbasm1518805wmq.30.2023.11.29.01.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 01:36:53 -0800 (PST)
Date: Wed, 29 Nov 2023 10:36:48 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 3/3] vsock/test: SO_RCVLOWAT + deferred credit
 update test
Message-ID: <grwpjitnh6jqlougrw2b5xibuclos3tpgyxv5exgcbnvcy6crp@jt4o2hz6pk6n>
References: <20231122180510.2297075-1-avkrasnov@salutedevices.com>
 <20231122180510.2297075-4-avkrasnov@salutedevices.com>
 <mklk6i6frkms33qntatlejbyl2czf7sp4quorkuxy6lpwmmlcn@foknxen36olr>
 <be8b1d3e-7032-76dc-042c-9513a933a0f3@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be8b1d3e-7032-76dc-042c-9513a933a0f3@salutedevices.com>

On Wed, Nov 29, 2023 at 12:16:54PM +0300, Arseniy Krasnov wrote:
>
>
>On 29.11.2023 12:16, Stefano Garzarella wrote:
>> On Wed, Nov 22, 2023 at 09:05:10PM +0300, Arseniy Krasnov wrote:
>>> Test which checks, that updating SO_RCVLOWAT value also sends credit
>>> update message. Otherwise mutual hungup may happen when receiver didn't
>>> send credit update and then calls 'poll()' with non default SO_RCVLOWAT
>>> value (e.g. waiting enough bytes to read), while sender waits for free
>>> space at receiver's side. Important thing is that this test relies on
>>> kernel's define for maximum packet size for virtio transport and this
>>> value is not exported to user: VIRTIO_VSOCK_MAX_PKT_BUF_SIZE (this
>>> define is used to control moment when to send credit update message).
>>> If this value or its usage will be changed in kernel - this test may
>>> become useless/broken.
>>>
>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> ---
>>> Changelog:
>>> v1 -> v2:
>>>  * Update commit message by removing 'This patch adds XXX' manner.
>>>  * Update commit message by adding details about dependency for this
>>>    test from kernel internal define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
>>>  * Add comment for this dependency in 'vsock_test.c' where this define
>>>    is duplicated.
>>> v2 -> v3:
>>>  * Replace synchronization based on control TCP socket with vsock
>>>    data socket - this is needed to allow sender transmit data only
>>>    when new buffer size of receiver is visible to sender. Otherwise
>>>    there is race and test fails sometimes.
>>>
>>> tools/testing/vsock/vsock_test.c | 142 +++++++++++++++++++++++++++++++
>>> 1 file changed, 142 insertions(+)
>>>
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index 5b0e93f9996c..773a71260fba 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -1225,6 +1225,143 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
>>>     }
>>> }
>>>
>>> +#define RCVLOWAT_CREDIT_UPD_BUF_SIZE    (1024 * 128)
>>> +/* This define is the same as in 'include/linux/virtio_vsock.h':
>>> + * it is used to decide when to send credit update message during
>>> + * reading from rx queue of a socket. Value and its usage in
>>> + * kernel is important for this test.
>>> + */
>>> +#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE    (1024 * 64)
>>> +
>>> +static void test_stream_rcvlowat_def_cred_upd_client(const struct test_opts *opts)
>>> +{
>>> +    size_t buf_size;
>>> +    void *buf;
>>> +    int fd;
>>> +
>>> +    fd = vsock_stream_connect(opts->peer_cid, 1234);
>>> +    if (fd < 0) {
>>> +        perror("connect");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    /* Send 1 byte more than peer's buffer size. */
>>> +    buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE + 1;
>>> +
>>> +    buf = malloc(buf_size);
>>> +    if (!buf) {
>>> +        perror("malloc");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    /* Wait until peer sets needed buffer size. */
>>> +    recv_byte(fd, 1, 0);
>>> +
>>> +    if (send(fd, buf, buf_size, 0) != buf_size) {
>>> +        perror("send failed");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    free(buf);
>>> +    close(fd);
>>> +}
>>> +
>>> +static void test_stream_rcvlowat_def_cred_upd_server(const struct test_opts *opts)
>>> +{
>>> +    size_t recv_buf_size;
>>> +    struct pollfd fds;
>>> +    size_t buf_size;
>>> +    void *buf;
>>> +    int fd;
>>> +
>>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>>> +    if (fd < 0) {
>>> +        perror("accept");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE;
>>> +
>>> +    if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>>> +               &buf_size, sizeof(buf_size))) {
>>> +        perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    /* Send one dummy byte here, because 'setsockopt()' above also
>>> +     * sends special packet which tells sender to update our buffer
>>> +     * size. This 'send_byte()' will serialize such packet with data
>>> +     * reads in a loop below. Sender starts transmission only when
>>> +     * it receives this single byte.
>>> +     */
>>> +    send_byte(fd, 1, 0);
>>> +
>>> +    buf = malloc(buf_size);
>>> +    if (!buf) {
>>> +        perror("malloc");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    /* Wait until there will be 128KB of data in rx queue. */
>>> +    while (1) {
>>> +        ssize_t res;
>>> +
>>> +        res = recv(fd, buf, buf_size, MSG_PEEK);
>>> +        if (res == buf_size)
>>> +            break;
>>> +
>>> +        if (res <= 0) {
>>> +            fprintf(stderr, "unexpected 'recv()' return: %zi\n", res);
>>> +            exit(EXIT_FAILURE);
>>> +        }
>>> +    }
>>> +
>>> +    /* There is 128KB of data in the socket's rx queue,
>>> +     * dequeue first 64KB, credit update is not sent.
>>> +     */
>>> +    recv_buf_size = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>>> +    recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
>>> +    recv_buf_size++;
>>> +
>>> +    /* Updating SO_RCVLOWAT will send credit update. */
>>> +    if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
>>> +               &recv_buf_size, sizeof(recv_buf_size))) {
>>> +        perror("setsockopt(SO_RCVLOWAT)");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    memset(&fds, 0, sizeof(fds));
>>> +    fds.fd = fd;
>>> +    fds.events = POLLIN | POLLRDNORM | POLLERR |
>>> +             POLLRDHUP | POLLHUP;
>>> +
>>> +    /* This 'poll()' will return once we receive last byte
>>> +     * sent by client.
>>> +     */
>>> +    if (poll(&fds, 1, -1) < 0) {
>>> +        perror("poll");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (fds.revents & POLLERR) {
>>> +        fprintf(stderr, "'poll()' error\n");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    if (fds.revents & (POLLIN | POLLRDNORM)) {
>>> +        recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
>>
>> Should we set the socket non-blocking?
>>
>> Otherwise, here poll() might wake up even if there are not all the
>> expected bytes due to some bug and recv() block waiting for the
>> remaining bytes, so we might not notice the bug.
>
>Good point! or just use MSG_DONTWAIT flag for only this 'recv()'.

Yep, right!

Stefano


