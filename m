Return-Path: <kvm+bounces-2745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0BA27FD26C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 563881F2100F
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F270E14AAF;
	Wed, 29 Nov 2023 09:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="SJrfKwT9"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC15D1;
	Wed, 29 Nov 2023 01:24:59 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id F3D79100019;
	Wed, 29 Nov 2023 12:24:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru F3D79100019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701249896;
	bh=eVwndGgq0W0UsSKxBhx+5YPBwXU+EeeXoPsonuNv8sE=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=SJrfKwT9bR/NZ/ynUGUOKSpVvGjZCplqJNTnMkVFpGqOvWvGUp3lxOvraoDaJBQ8d
	 /p+9Ww/2LojwNx+jMcVknSBemkHQASMW2VzvIdYnfODtcrJSbzh1md+BEfsDyOL7MI
	 A7iL5FyJ+229888p5lwvLRzPmoSl+bfPBG/aX+XNDkqjyC7uj4jVB/3Y2rOGAW4OSt
	 1SM07hKJYT1VQ7+Ykok8S9ftDS9vzatzSpAZNO6lBzGmI3Sj70Zz/+vpAeH4r5h3Lw
	 18DZp/VoeSDWK8k/V1XhJSbOiggS4baHWMSiZva3wtisqPOg+N6Tv1ynhP28QbBxH/
	 gDOqeHdMzDsWw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Wed, 29 Nov 2023 12:24:55 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 29 Nov 2023 12:24:55 +0300
Message-ID: <be8b1d3e-7032-76dc-042c-9513a933a0f3@salutedevices.com>
Date: Wed, 29 Nov 2023 12:16:54 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v3 3/3] vsock/test: SO_RCVLOWAT + deferred credit
 update test
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Bobby Eshleman
	<bobby.eshleman@bytedance.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20231122180510.2297075-1-avkrasnov@salutedevices.com>
 <20231122180510.2297075-4-avkrasnov@salutedevices.com>
 <mklk6i6frkms33qntatlejbyl2czf7sp4quorkuxy6lpwmmlcn@foknxen36olr>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <mklk6i6frkms33qntatlejbyl2czf7sp4quorkuxy6lpwmmlcn@foknxen36olr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181677 [Nov 29 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/29 05:52:00 #22570775
X-KSMG-AntiVirus-Status: Clean, skipped



On 29.11.2023 12:16, Stefano Garzarella wrote:
> On Wed, Nov 22, 2023 at 09:05:10PM +0300, Arseniy Krasnov wrote:
>> Test which checks, that updating SO_RCVLOWAT value also sends credit
>> update message. Otherwise mutual hungup may happen when receiver didn't
>> send credit update and then calls 'poll()' with non default SO_RCVLOWAT
>> value (e.g. waiting enough bytes to read), while sender waits for free
>> space at receiver's side. Important thing is that this test relies on
>> kernel's define for maximum packet size for virtio transport and this
>> value is not exported to user: VIRTIO_VSOCK_MAX_PKT_BUF_SIZE (this
>> define is used to control moment when to send credit update message).
>> If this value or its usage will be changed in kernel - this test may
>> become useless/broken.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> Changelog:
>> v1 -> v2:
>>  * Update commit message by removing 'This patch adds XXX' manner.
>>  * Update commit message by adding details about dependency for this
>>    test from kernel internal define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE.
>>  * Add comment for this dependency in 'vsock_test.c' where this define
>>    is duplicated.
>> v2 -> v3:
>>  * Replace synchronization based on control TCP socket with vsock
>>    data socket - this is needed to allow sender transmit data only
>>    when new buffer size of receiver is visible to sender. Otherwise
>>    there is race and test fails sometimes.
>>
>> tools/testing/vsock/vsock_test.c | 142 +++++++++++++++++++++++++++++++
>> 1 file changed, 142 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index 5b0e93f9996c..773a71260fba 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -1225,6 +1225,143 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
>>     }
>> }
>>
>> +#define RCVLOWAT_CREDIT_UPD_BUF_SIZE    (1024 * 128)
>> +/* This define is the same as in 'include/linux/virtio_vsock.h':
>> + * it is used to decide when to send credit update message during
>> + * reading from rx queue of a socket. Value and its usage in
>> + * kernel is important for this test.
>> + */
>> +#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE    (1024 * 64)
>> +
>> +static void test_stream_rcvlowat_def_cred_upd_client(const struct test_opts *opts)
>> +{
>> +    size_t buf_size;
>> +    void *buf;
>> +    int fd;
>> +
>> +    fd = vsock_stream_connect(opts->peer_cid, 1234);
>> +    if (fd < 0) {
>> +        perror("connect");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    /* Send 1 byte more than peer's buffer size. */
>> +    buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE + 1;
>> +
>> +    buf = malloc(buf_size);
>> +    if (!buf) {
>> +        perror("malloc");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    /* Wait until peer sets needed buffer size. */
>> +    recv_byte(fd, 1, 0);
>> +
>> +    if (send(fd, buf, buf_size, 0) != buf_size) {
>> +        perror("send failed");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    free(buf);
>> +    close(fd);
>> +}
>> +
>> +static void test_stream_rcvlowat_def_cred_upd_server(const struct test_opts *opts)
>> +{
>> +    size_t recv_buf_size;
>> +    struct pollfd fds;
>> +    size_t buf_size;
>> +    void *buf;
>> +    int fd;
>> +
>> +    fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>> +    if (fd < 0) {
>> +        perror("accept");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    buf_size = RCVLOWAT_CREDIT_UPD_BUF_SIZE;
>> +
>> +    if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
>> +               &buf_size, sizeof(buf_size))) {
>> +        perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    /* Send one dummy byte here, because 'setsockopt()' above also
>> +     * sends special packet which tells sender to update our buffer
>> +     * size. This 'send_byte()' will serialize such packet with data
>> +     * reads in a loop below. Sender starts transmission only when
>> +     * it receives this single byte.
>> +     */
>> +    send_byte(fd, 1, 0);
>> +
>> +    buf = malloc(buf_size);
>> +    if (!buf) {
>> +        perror("malloc");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    /* Wait until there will be 128KB of data in rx queue. */
>> +    while (1) {
>> +        ssize_t res;
>> +
>> +        res = recv(fd, buf, buf_size, MSG_PEEK);
>> +        if (res == buf_size)
>> +            break;
>> +
>> +        if (res <= 0) {
>> +            fprintf(stderr, "unexpected 'recv()' return: %zi\n", res);
>> +            exit(EXIT_FAILURE);
>> +        }
>> +    }
>> +
>> +    /* There is 128KB of data in the socket's rx queue,
>> +     * dequeue first 64KB, credit update is not sent.
>> +     */
>> +    recv_buf_size = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>> +    recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
>> +    recv_buf_size++;
>> +
>> +    /* Updating SO_RCVLOWAT will send credit update. */
>> +    if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
>> +               &recv_buf_size, sizeof(recv_buf_size))) {
>> +        perror("setsockopt(SO_RCVLOWAT)");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    memset(&fds, 0, sizeof(fds));
>> +    fds.fd = fd;
>> +    fds.events = POLLIN | POLLRDNORM | POLLERR |
>> +             POLLRDHUP | POLLHUP;
>> +
>> +    /* This 'poll()' will return once we receive last byte
>> +     * sent by client.
>> +     */
>> +    if (poll(&fds, 1, -1) < 0) {
>> +        perror("poll");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (fds.revents & POLLERR) {
>> +        fprintf(stderr, "'poll()' error\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    if (fds.revents & (POLLIN | POLLRDNORM)) {
>> +        recv_buf(fd, buf, recv_buf_size, 0, recv_buf_size);
> 
> Should we set the socket non-blocking?
> 
> Otherwise, here poll() might wake up even if there are not all the
> expected bytes due to some bug and recv() block waiting for the
> remaining bytes, so we might not notice the bug.

Good point! or just use MSG_DONTWAIT flag for only this 'recv()'.

Thanks, Arseniy

> 
> Stefano
> 
>> +    } else {
>> +        /* These flags must be set, as there is at
>> +         * least 64KB of data ready to read.
>> +         */
>> +        fprintf(stderr, "POLLIN | POLLRDNORM expected\n");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    free(buf);
>> +    close(fd);
>> +}
>> +
>> static struct test_case test_cases[] = {
>>     {
>>         .name = "SOCK_STREAM connection reset",
>> @@ -1335,6 +1472,11 @@ static struct test_case test_cases[] = {
>>         .run_client = test_double_bind_connect_client,
>>         .run_server = test_double_bind_connect_server,
>>     },
>> +    {
>> +        .name = "SOCK_STREAM virtio SO_RCVLOWAT + deferred cred update",
>> +        .run_client = test_stream_rcvlowat_def_cred_upd_client,
>> +        .run_server = test_stream_rcvlowat_def_cred_upd_server,
>> +    },
>>     {},
>> };
>>
>> -- 
>> 2.25.1
>>
> 

