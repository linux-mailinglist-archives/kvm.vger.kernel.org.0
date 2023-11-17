Return-Path: <kvm+bounces-1940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1702F7EEDF5
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:58:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48B1E1C20AD5
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06FEDDD9;
	Fri, 17 Nov 2023 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="fbTB1TKj"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C3A11F;
	Fri, 17 Nov 2023 00:58:43 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id A64B9120097;
	Fri, 17 Nov 2023 11:58:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A64B9120097
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1700211520;
	bh=HN+PvIjLqzQn6wjZP926vHy0wPu+a4K5ITDOFK7AlOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
	b=fbTB1TKjZE9AIUNudoR0Vy7AVqsTakFba2sLFRyrNstMcANH1pgsLVYXHK6ITrOE+
	 RU3YvcWfqGgqUCZPQ41moC7zCReP6GTarQHJx0ZYEXm5HuKHgtp4522pitd2wYYxhj
	 60npuohOI7JFMtLNBsJpdD5RqkxFG/eN6vlFJdIDPDFZ6ENtP1WhdMbe4YvZaOXzSb
	 gU0RryRcspaEmkqh50nWKgHrDNnf+ELoT6vqhDmJ5yikPagei9i6Ao9Lqkz0at6c5k
	 SjfoqusdKk5ydlEcvuDF/GlwKsMovwEJjm/jfgKwK1o7cRSbYMQm2ThR5niBnw7M37
	 J+IcbfY7hiGjQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 17 Nov 2023 11:58:40 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 17 Nov 2023 11:58:40 +0300
Message-ID: <1700ac19-a355-fad4-79e2-7598ee33bd00@salutedevices.com>
Date: Fri, 17 Nov 2023 11:50:59 +0300
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
 <923a6149-3bd5-c5b4-766d-8301f9e7484a@salutedevices.com>
 <tbvwohgvrc6kvlsyap3sk5zqww5q6schsu4szx7e23wgg7pvb3@e7xa5mg5inul>
Content-Language: en-US
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <tbvwohgvrc6kvlsyap3sk5zqww5q6schsu4szx7e23wgg7pvb3@e7xa5mg5inul>
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
X-KSMG-AntiSpam-Info: LuaCore: 543 543 1e3516af5cdd92079dfeb0e292c8747a62cb1ee4, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;docs.kernel.org:7.1.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/11/17 08:17:00
X-KSMG-LinksScanning: Clean, bases: 2023/11/17 08:17:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/17 07:09:00 #22469944
X-KSMG-AntiVirus-Status: Clean, skipped



On 17.11.2023 11:30, Stefano Garzarella wrote:
> On Fri, Nov 17, 2023 at 10:12:38AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 15.11.2023 14:11, Stefano Garzarella wrote:
>>> On Wed, Nov 08, 2023 at 10:20:04AM +0300, Arseniy Krasnov wrote:
>>>> This adds test which checks, that updating SO_RCVLOWAT value also sends
>>>
>>> You can avoid "This adds", and write just "Add test ...".
>>>
>>> See https://docs.kernel.org/process/submitting-patches.html#describe-your-changes
>>>
>>>     Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>>>     instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>>>     to do frotz", as if you are giving orders to the codebase to change
>>>     its behaviour.
>>>
>>> Also in the other patch.
>>>
>>>> credit update message. Otherwise mutual hungup may happen when receiver
>>>> didn't send credit update and then calls 'poll()' with non default
>>>> SO_RCVLOWAT value (e.g. waiting enough bytes to read), while sender
>>>> waits for free space at receiver's side.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>>> ---
>>>> tools/testing/vsock/vsock_test.c | 131 +++++++++++++++++++++++++++++++
>>>> 1 file changed, 131 insertions(+)
>>>>
>>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>>> index c1f7bc9abd22..c71b3875fd16 100644
>>>> --- a/tools/testing/vsock/vsock_test.c
>>>> +++ b/tools/testing/vsock/vsock_test.c
>>>> @@ -1180,6 +1180,132 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
>>>>     close(fd);
>>>> }
>>>>
>>>> +#define RCVLOWAT_CREDIT_UPD_BUF_SIZE    (1024 * 128)
>>>> +#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE    (1024 * 64)
>>>
>>> What about adding a comment like the one in the cover letter about
>>> dependency with kernel values?
>>>
>>> Please add it also in the commit description.
>>>
>>> I'm thinking if we should move all the defines that depends on the
>>> kernel in some special header.
>>
>> IIUC it will be new header file in tools/testing/vsock, which includes such defines. At
>> this moment in will contain only VIRTIO_VSOCK_MAX_PKT_BUF_SIZE. Idea is that such defines
> 
> So this only works on the virtio transport though, not the other
> transports, right? (but maybe the others don't have this problem, so
> it's fine).

Yes, this case is only actual in virtio as this logic exists in virtio
only (the same situation as for skb merging sometimes ago).

> 
>> are not supposed to use by user (so do not move it to uapi headers), but needed by tests
>> to check kernel behaviour. Please correct me if i'm wrong.
> 
> Right!
> Maybe if it's just one, we can leave it there for now, but with a
> comment on top explaining where it comes.

Ok, got it, I'll add comment

Thanks, Arseniy

> 
> Thanks,
> Stefano
> 

