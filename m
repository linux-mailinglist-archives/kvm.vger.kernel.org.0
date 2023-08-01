Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF01976B5EF
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 15:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjHANeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbjHANem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 09:34:42 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E5F1982;
        Tue,  1 Aug 2023 06:34:40 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 058C810001A;
        Tue,  1 Aug 2023 16:34:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 058C810001A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690896877;
        bh=SqyWBmlbpE2iXGo+rpnFFpO+xhRt15lpwrE9fVXIJ28=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=VEtV8Lpc9bWMXbJjnlxA+XJyvyIGet2Z0IYipnkTjOhECPmMTgG9f9zWizqYo8UrZ
         WYoOgUAUWxDEF1su9ji5RmZt//wmvPf85TQwVfYkd6VRMncyMdRYzgMcYyzjtmkLIf
         H8npoKVJb6JWPN1pI7Z/Ye0eWW2LRPkxaT1j32U9GPAPVvqlKA4/slY2uDWjFNccP7
         hkHAW9bYDwgzibafCGoYT9S/tIZf8Ci1g2oAQWG7bZhC6HG1EWpCdHWzjqm2CgFdkp
         v51f+zMMYLwgxX5Kttyh4PW6vDXKorSzcdqUeQsraI9oqeQrCiHeVUk+SCewb/us+z
         JhgCLfwIq3pUQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue,  1 Aug 2023 16:34:36 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 1 Aug 2023 16:34:33 +0300
Message-ID: <2b581879-f449-4ba3-8fbd-397d0f23ae15@sberdevices.ru>
Date:   Tue, 1 Aug 2023 16:28:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v5 1/4] vsock/virtio/vhost: read data from
 non-linear skb
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230730085905.3420811-1-AVKrasnov@sberdevices.ru>
 <20230730085905.3420811-2-AVKrasnov@sberdevices.ru>
 <8972ac7df2298d47e1b2f53b7f1b5d5941999580.camel@redhat.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <8972ac7df2298d47e1b2f53b7f1b5d5941999580.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01.08.2023 16:11, Paolo Abeni wrote:
> On Sun, 2023-07-30 at 11:59 +0300, Arseniy Krasnov wrote:
>> This is preparation patch for MSG_ZEROCOPY support. It adds handling of
>> non-linear skbs by replacing direct calls of 'memcpy_to_msg()' with
>> 'skb_copy_datagram_iter()'. Main advantage of the second one is that it
>> can handle paged part of the skb by using 'kmap()' on each page, but if
>> there are no pages in the skb, it behaves like simple copying to iov
>> iterator. This patch also adds new field to the control block of skb -
>> this value shows current offset in the skb to read next portion of data
>> (it doesn't matter linear it or not). Idea behind this field is that
>> 'skb_copy_datagram_iter()' handles both types of skb internally - it
>> just needs an offset from which to copy data from the given skb. This
>> offset is incremented on each read from skb. This approach allows to
>> avoid special handling of non-linear skbs:
>> 1) We can't call 'skb_pull()' on it, because it updates 'data' pointer.
>> 2) We need to update 'data_len' also on each read from this skb.
> 
> It looks like the above sentence is a left-over from previous version
> as, as this patch does not touch data_len. And I think it contradicts
> the previous one, so it's a bit confusing.

Yes, seems I need to rephrase it in the next version. I meant that with
approach introduced in this patch we don't need to check that skb is
linear of non-linear after reading data from it. Because otherwise:
1) In case of linear skb we will need to call 'skb_pull()' after reading
   data, to update 'data' pointer.
2) In case of non-linear skb we will need to update 'data_len' field after
   reading data, as this field shows amount of data in fragged part.

> 
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>>  Changelog:
>>  v5(big patchset) -> v1:
>>   * Merge 'virtio_transport_common.c' and 'vhost/vsock.c' patches into
>>     this single patch.
>>   * Commit message update: grammar fix and remark that this patch is
>>     MSG_ZEROCOPY preparation.
>>   * Use 'min_t()' instead of comparison using '<>' operators.
>>  v1 -> v2:
>>   * R-b tag added.
>>  v3 -> v4:
>>   * R-b tag removed due to rebase:
>>     * Part for 'virtio_transport_stream_do_peek()' is changed.
>>     * Part for 'virtio_transport_seqpacket_do_peek()' is added.
>>   * Comments about sleep in 'memcpy_to_msg()' now describe sleep in
>>     'skb_copy_datagram_iter()'.
>>
>>  drivers/vhost/vsock.c                   | 14 +++++++----
>>  include/linux/virtio_vsock.h            |  1 +
>>  net/vmw_vsock/virtio_transport_common.c | 32 +++++++++++++++----------
>>  3 files changed, 29 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>> index 817d377a3f36..8c917be32b5d 100644
>> --- a/drivers/vhost/vsock.c
>> +++ b/drivers/vhost/vsock.c
>> @@ -114,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>  		struct sk_buff *skb;
>>  		unsigned out, in;
>>  		size_t nbytes;
>> +		u32 frag_off;
> 
> IMHO 'offset' would be a better name for both the variable and the CB
> field, as it can points both inside the skb frags, linear part or frag
> list.

Ack

> 
> Otherwise LGTM, thanks!
> 
> Paolo
> 

Thanks, Arseniy
