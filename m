Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C545776B6F5
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbjHAONV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 10:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjHAONQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 10:13:16 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3805273F;
        Tue,  1 Aug 2023 07:12:41 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id D025F120006;
        Tue,  1 Aug 2023 17:12:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D025F120006
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690899159;
        bh=65FgcRTx26LZHNe8UJ3rutBm/GhTUW86J1RJsgpMT28=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=pPoh05I/Q3JbQHwhnV6BKKtFG0Jhlt5Yw0hONtDZNSzUO3/HPzISgOj90FeiuTruS
         y6W4rc+t8VaFq8f6YYO4QCNa3kakxwtzYh3kBATvsmrN+E1addOYq3fJrPdvwRN8KP
         c3yYXCpsNJ0j8JiuDURAZnfq1eDoY2096hqAvh5pQGXzNA0z7N+u02lZFoa3NGjYOt
         QYq0ai2g2mEVpvS26f9Kz+DoeA0gO/7QyqwJD+UPJA9a+iIVGGJNWlhFxSrtRcajn+
         mPF8hFcg48Y3agwQUe++xwbRorJLMKC9+9Wr3rhkZck1h2frFrDou1Cu288TPh42ma
         mZUVLEczcPKqg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue,  1 Aug 2023 17:12:39 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 1 Aug 2023 17:12:36 +0300
Message-ID: <43991690-2b53-8211-8aad-693ae5c725e4@sberdevices.ru>
Date:   Tue, 1 Aug 2023 17:06:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v5 4/4] vsock/virtio: MSG_ZEROCOPY flag support
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
 <20230730085905.3420811-5-AVKrasnov@sberdevices.ru>
 <8a7772a50a16fbbcb82fc0c5e09f9e31f3427e3d.camel@redhat.com>
 <1c9f9851-2228-c92b-ce3d-6a84d44e6628@sberdevices.ru>
 <00f2b7bdb18e0eaa42f0cca542a9530564615475.camel@redhat.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <00f2b7bdb18e0eaa42f0cca542a9530564615475.camel@redhat.com>
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



On 01.08.2023 17:04, Paolo Abeni wrote:
> On Tue, 2023-08-01 at 16:36 +0300, Arseniy Krasnov wrote:
>>
>> On 01.08.2023 16:34, Paolo Abeni wrote:
>>> On Sun, 2023-07-30 at 11:59 +0300, Arseniy Krasnov wrote:
>>>> +static int virtio_transport_fill_skb(struct sk_buff *skb,
>>>> +				     struct virtio_vsock_pkt_info *info,
>>>> +				     size_t len,
>>>> +				     bool zcopy)
>>>> +{
>>>> +	if (zcopy) {
>>>> +		return __zerocopy_sg_from_iter(info->msg, NULL, skb,
>>>> +					      &info->msg->msg_iter,
>>>> +					      len);
>>>> +	} else {
>>>
>>>
>>> No need for an else statement after 'return'
>>>
>>>> +		void *payload;
>>>> +		int err;
>>>> +
>>>> +		payload = skb_put(skb, len);
>>>> +		err = memcpy_from_msg(payload, info->msg, len);
>>>> +		if (err)
>>>> +			return -1;
>>>> +
>>>> +		if (msg_data_left(info->msg))
>>>> +			return 0;
>>>> +
>>>
>>> This path does not update truesize, evem if it increases the skb len...
>>
>> Thanks, I'll fix it.
>>
>>>
>>>> +		return 0;
>>>> +	}
>>>> +}
>>>
>>> [...]
>>>
>>>> @@ -214,6 +251,70 @@ static u16 virtio_transport_get_type(struct sock *sk)
>>>>  		return VIRTIO_VSOCK_TYPE_SEQPACKET;
>>>>  }
>>>>  
>>>> +static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock *vsk,
>>>> +						  struct virtio_vsock_pkt_info *info,
>>>> +						  size_t payload_len,
>>>> +						  bool zcopy,
>>>> +						  u32 src_cid,
>>>> +						  u32 src_port,
>>>> +						  u32 dst_cid,
>>>> +						  u32 dst_port)
>>>> +{
>>>> +	struct sk_buff *skb;
>>>> +	size_t skb_len;
>>>> +
>>>> +	skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
>>>> +
>>>> +	if (!zcopy)
>>>> +		skb_len += payload_len;
>>>> +
>>>> +	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>>>> +	if (!skb)
>>>> +		return NULL;
>>>> +
>>>> +	virtio_transport_init_hdr(skb, info, src_cid, src_port,
>>>> +				  dst_cid, dst_port,
>>>> +				  payload_len);
>>>> +
>>>> +	/* Set owner here, because '__zerocopy_sg_from_iter()' uses
>>>> +	 * owner of skb without check to update 'sk_wmem_alloc'.
>>>> +	 */
>>>> +	if (vsk)
>>>> +		skb_set_owner_w(skb, sk_vsock(vsk));
>>>
>>> ... which can lead to bad things(TM) if the skb goes trough some later
>>> non trivial processing, due to the above skb_set_owner_w().
>>>
>>> Additionally can be the following condition be true:
>>>
>>> 	vsk == NULL && (info->msg && payload_len > 0) && zcopy
>>>
>>> ???
>>
>> No, vsk == NULL only when we reset connection, in that case both info->msg == NULL and payload_len == 0,
>> as this is control message without any data.
> 
> Perhaps a comment with possibly even a WARN_ON_ONCE(!<the above>) could
> help ;)

Ack

Thanks, Arseniy

> 
> Thanks!
> 
> Paolo
> 
