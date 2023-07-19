Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE02E758DA1
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 08:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjGSGSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 02:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjGSGSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 02:18:44 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AF81FC8;
        Tue, 18 Jul 2023 23:18:36 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id DC6B010002B;
        Wed, 19 Jul 2023 09:18:33 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru DC6B010002B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1689747513;
        bh=T5//4veKF9G1kOtGCcNXq0VI2OqwBcKn7BZ/2ww7RM8=;
        h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type:From;
        b=LlK0jZKGNAC0gd8i62mWbtHVMu9jzhbmZhi2vt+gXYplBuTFh6U+qeEpd1MAQrnte
         pbhl1DGl7Au3q3S8F0tVBMjG6juM6aLqi15/zMsfWyc6UDy55JUu/ZevgQvazEEMH6
         +duU7P5eOptffWT0BlJT32yqVZIs+8Tl/aqpuo88Pc1MLRtFt9drXrhU/jw+CaUEYR
         z4NHhxqIwGsa1CoHL7RUKJhxZn+lU9VNPRzUShslJtzPRtdAY2Wl9oEf4nrsWOAIZD
         ItMUw+0yQ1mmGC6zPK03K8/hQeDNFOJqTqvA66C7XZtoc7Nif4a/JdSx5uj3Upki1W
         sMlxEjG4GliJg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 09:18:33 +0300 (MSK)
Received: from [192.168.0.12] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 09:18:33 +0300
Message-ID: <48090ce4-e610-58c9-5d92-34570d2eeed4@sberdevices.ru>
Date:   Wed, 19 Jul 2023 09:13:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 2/4] vsock/virtio: support to send non-linear
 skb
Content-Language: en-US
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230718180237.3248179-1-AVKrasnov@sberdevices.ru>
 <20230718180237.3248179-3-AVKrasnov@sberdevices.ru>
 <20230718162202-mutt-send-email-mst@kernel.org>
 <1ac4be11-0814-05af-6c2e-8563ac15e206@sberdevices.ru>
In-Reply-To: <1ac4be11-0814-05af-6c2e-8563ac15e206@sberdevices.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178705 [Jul 19 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 524 524 9753033d6953787301affc41bead8ed49c47b39d, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/19 03:54:00 #21637026
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



On 19.07.2023 07:46, Arseniy Krasnov wrote:
> 
> 
> On 18.07.2023 23:27, Michael S. Tsirkin wrote:
>> On Tue, Jul 18, 2023 at 09:02:35PM +0300, Arseniy Krasnov wrote:
>>> For non-linear skb use its pages from fragment array as buffers in
>>> virtio tx queue. These pages are already pinned by 'get_user_pages()'
>>> during such skb creation.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  net/vmw_vsock/virtio_transport.c | 40 +++++++++++++++++++++++++++-----
>>>  1 file changed, 34 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>> index e95df847176b..6cbb45bb12d2 100644
>>> --- a/net/vmw_vsock/virtio_transport.c
>>> +++ b/net/vmw_vsock/virtio_transport.c
>>> @@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>>  	vq = vsock->vqs[VSOCK_VQ_TX];
>>>  
>>>  	for (;;) {
>>> -		struct scatterlist hdr, buf, *sgs[2];
>>> +		/* +1 is for packet header. */
>>> +		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>>> +		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
>>>  		int ret, in_sg = 0, out_sg = 0;
>>>  		struct sk_buff *skb;
>>>  		bool reply;
>>> @@ -111,12 +113,38 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>>  
>>>  		virtio_transport_deliver_tap_pkt(skb);
>>>  		reply = virtio_vsock_skb_reply(skb);
>>> +		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
>>> +			    sizeof(*virtio_vsock_hdr(skb)));
>>> +		sgs[out_sg] = &bufs[out_sg];
>>> +		out_sg++;
>>> +
>>> +		if (!skb_is_nonlinear(skb)) {
>>> +			if (skb->len > 0) {
>>> +				sg_init_one(&bufs[out_sg], skb->data, skb->len);
>>> +				sgs[out_sg] = &bufs[out_sg];
>>> +				out_sg++;
>>> +			}
>>> +		} else {
>>> +			struct skb_shared_info *si;
>>> +			int i;
>>> +
>>> +			si = skb_shinfo(skb);
>>> +
>>> +			for (i = 0; i < si->nr_frags; i++) {
>>> +				skb_frag_t *skb_frag = &si->frags[i];
>>> +				void *va = page_to_virt(skb_frag->bv_page);
>>>  
>>> -		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>>> -		sgs[out_sg++] = &hdr;
>>> -		if (skb->len > 0) {
>>> -			sg_init_one(&buf, skb->data, skb->len);
>>> -			sgs[out_sg++] = &buf;
>>> +				/* We will use 'page_to_virt()' for userspace page here,
>>
>> don't put comments after code they refer to, please?
>>
>>> +				 * because virtio layer will call 'virt_to_phys()' later
>>
>> it will but not always. sometimes it's the dma mapping layer.
>>
>>
>>> +				 * to fill buffer descriptor. We don't touch memory at
>>> +				 * "virtual" address of this page.
>>
>>
>> you need to stick "the" in a bunch of places above.
> 
> Ok, I'll fix this comment!
> 
>>
>>> +				 */
>>> +				sg_init_one(&bufs[out_sg],
>>> +					    va + skb_frag->bv_offset,
>>> +					    skb_frag->bv_len);
>>> +				sgs[out_sg] = &bufs[out_sg];
>>> +				out_sg++;
>>> +			}
>>>  		}
>>>  
>>>  		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>>
>>
>> There's a problem here: if there vq is small this will fail.
>> So you really should check free vq s/gs and switch to non-zcopy
>> if too small.
> 
> Ok, so idea is that:
> 
> if (out_sg > vq->num_free)
>     reorganise current skb for copy mode (e.g. 2 out_sg - header and data)
>     and try to add it to vq again.
> 
> ?

I guess I need to check number of elements in sg list against 'vq->num_max' - as this is
maximum number for totally free queue (if even big sg list does not fit to be added to the
tx queue at this moment, skb will be requeued below, waiting for enough space). I'll pass
'vq->num_max' value by another transport callback to 'virtio_transport_common.c' and check
number of user pages against this value - if user's buffer is too big, then use copy mode,
thus there will be only 2 elements in sg list and this will fit to vq anyway.

Thanks, Arseniy

> 
> @Stefano, I'll remove net-next tag (guess RFC is not required again, but not net-next
> anyway) as this change will require review. R-b I think should be also removed. All
> other patches in this set still unchanged.
> 
> Thanks, Arseniy
> 
>>
>>> -- 
>>> 2.25.1
>>
