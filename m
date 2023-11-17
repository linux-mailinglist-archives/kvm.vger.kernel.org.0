Return-Path: <kvm+bounces-1915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB7497EEC97
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09F8A1C20AD6
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 07:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E38DF53;
	Fri, 17 Nov 2023 07:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="YjxB/p4q"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CE3D5E;
	Thu, 16 Nov 2023 23:20:21 -0800 (PST)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 42D46100053;
	Fri, 17 Nov 2023 10:20:20 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 42D46100053
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1700205620;
	bh=TXUWzwEhbxgHVkn7xc8Va70O8zxsHqn90+mpouI8FXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=YjxB/p4q7lGQMkqHj1iaTecDtBc+2MLOvH8esTIyX9HXuDAXC1YFwYsvOE8x9hUIV
	 6vCAA3PnX66Im+M8Q7exm3jzILXBXMsOyTsc6ONN2toX7et3HguQRdZcROO3D9NOl4
	 kPI2MIAxr/uOk719tbkPn12IDFhcXIQIpiyGuNDsxhhYz1hAq4DGHAHcFjoWAZt5+R
	 ls/We6bbnInDdnXyk8bGR2jBsEqBn47tzeTSvfmszkpuhF/4t4XZVGOxRzPBzYThJB
	 uNTzZeO45BbeRD3hCcvb+5TVrxXUnQH1ZYR2tsNI1rynY81O54PuB0RE4YnSnqo5il
	 mxcJGP+3QT1VA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 17 Nov 2023 10:20:20 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 17 Nov 2023 10:20:19 +0300
Message-ID: <923a6149-3bd5-c5b4-766d-8301f9e7484a@salutedevices.com>
Date: Fri, 17 Nov 2023 10:12:38 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v1 2/2] vsock/test: SO_RCVLOWAT + deferred credit
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
References: <20231108072004.1045669-1-avkrasnov@salutedevices.com>
 <20231108072004.1045669-3-avkrasnov@salutedevices.com>
 <zukasb6k7ogta33c2wik6cgadg2rkacestat7pkexd45u53swh@ovso3hafta77>
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <zukasb6k7ogta33c2wik6cgadg2rkacestat7pkexd45u53swh@ovso3hafta77>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181429 [Nov 17 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 543 543 1e3516af5cdd92079dfeb0e292c8747a62cb1ee4, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;docs.kernel.org:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/11/17 06:10:00
X-KSMG-LinksScanning: Clean, bases: 2023/11/17 06:10:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/17 06:08:00 #22469568
X-KSMG-AntiVirus-Status: Clean, skipped



On 15.11.2023 14:11, Stefano Garzarella wrote:
> On Wed, Nov 08, 2023 at 10:20:04AM +0300, Arseniy Krasnov wrote:
>> This adds test which checks, that updating SO_RCVLOWAT value also sends
> 
> You can avoid "This adds", and write just "Add test ...".
> 
> See https://docs.kernel.org/process/submitting-patches.html#describe-your-changes
> 
>     Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>     instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>     to do frotz", as if you are giving orders to the codebase to change
>     its behaviour.
> 
> Also in the other patch.
> 
>> credit update message. Otherwise mutual hungup may happen when receiver
>> didn't send credit update and then calls 'poll()' with non default
>> SO_RCVLOWAT value (e.g. waiting enough bytes to read), while sender
>> waits for free space at receiver's side.
>>
>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>> ---
>> tools/testing/vsock/vsock_test.c | 131 +++++++++++++++++++++++++++++++
>> 1 file changed, 131 insertions(+)
>>
>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>> index c1f7bc9abd22..c71b3875fd16 100644
>> --- a/tools/testing/vsock/vsock_test.c
>> +++ b/tools/testing/vsock/vsock_test.c
>> @@ -1180,6 +1180,132 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
>>     close(fd);
>> }
>>
>> +#define RCVLOWAT_CREDIT_UPD_BUF_SIZE    (1024 * 128)
>> +#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE    (1024 * 64)
> 
> What about adding a comment like the one in the cover letter about
> dependency with kernel values?
> 
> Please add it also in the commit description.
> 
> I'm thinking if we should move all the defines that depends on the
> kernel in some special header.

IIUC it will be new header file in tools/testing/vsock, which includes such defines. At
this moment in will contain only VIRTIO_VSOCK_MAX_PKT_BUF_SIZE. Idea is that such defines
are not supposed to use by user (so do not move it to uapi headers), but needed by tests
to check kernel behaviour. Please correct me if i'm wrong.

Thanks, Arseniy

> 
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
>> +    control_expectln("SRVREADY");
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
>> +    buf = malloc(buf_size);
>> +    if (!buf) {
>> +        perror("malloc");
>> +        exit(EXIT_FAILURE);
>> +    }
>> +
>> +    control_writeln("SRVREADY");
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
>> @@ -1285,6 +1411,11 @@ static struct test_case test_cases[] = {
>>         .run_client = test_stream_msgzcopy_empty_errq_client,
>>         .run_server = test_stream_msgzcopy_empty_errq_server,
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

