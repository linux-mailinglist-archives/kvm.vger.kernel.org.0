Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A4785107
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 09:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbjHWHAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 03:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjHWHAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 03:00:40 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F446E7;
        Wed, 23 Aug 2023 00:00:35 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id A5AE710000E;
        Wed, 23 Aug 2023 10:00:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru A5AE710000E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1692774032;
        bh=SRJZujbowiyE4xrK91RwKf1qOYluLzScsl3Xa81A+dk=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=BffrOigH5z4JgZW9GxRwHqrTqdiFOY9UMOPXHdXeZoQmrBL7PCdgk9cLxNDTj/M3/
         9vvv6yyNgRR+GtStPHapPTzmCo5vT8Ot4J2RZakcVicaNAHkD7XwwtgIbQyd2wSypI
         fyVUAq7wiFOgC3ljf/pT9JLAOeTjVMa5xPDGbVXJC7JcxbIjwKm0NUKY+b2ZjFR9eb
         NfHzXvGkHUSq3lkp4+a4Rv80VZJGGKgTCfbRNjNIQ0XwPyq6Cec+phHaGUtfnv+POb
         09SBHOSIeX4S+VBBW3eD84W+DkCkBTz9ZbhAe1tZ+OC+ARY0esgXG0nL8iW9ByVYnI
         eP4xtaFdr/3pQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Wed, 23 Aug 2023 10:00:30 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 23 Aug 2023 10:00:25 +0300
Message-ID: <0e23cec7-0e9a-ac8d-e8b6-536a5c3d4b2e@sberdevices.ru>
Date:   Wed, 23 Aug 2023 09:54:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v6 2/4] vsock/virtio: support to send non-linear
 skb
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
References: <20230814212720.3679058-1-AVKrasnov@sberdevices.ru>
 <20230814212720.3679058-3-AVKrasnov@sberdevices.ru>
 <85ff931ea180e19ae3df83367cf1e7cac99fa0d8.camel@redhat.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <85ff931ea180e19ae3df83367cf1e7cac99fa0d8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179391 [Aug 23 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 527 527 5bb611be2ca2baa31d984ccbf4ef4415504fc308, {Tracking_smtp_not_equal_from}, {Tracking_from_domain_doesnt_match_to}, p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;salutedevices.com:7.1.1, FromAlignment: n, {Tracking_smtp_domain_mismatch}, {Tracking_smtp_domain_2level_mismatch}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/23 04:58:00 #21681850
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 22.08.2023 11:16, Paolo Abeni wrote:
> Hi,
> 
> I'm sorry for the long delay here. I was OoO in the past few weeks.
> 
> On Tue, 2023-08-15 at 00:27 +0300, Arseniy Krasnov wrote:
>> For non-linear skb use its pages from fragment array as buffers in
>> virtio tx queue. These pages are already pinned by 'get_user_pages()'
>> during such skb creation.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>  Changelog:
>>  v2 -> v3:
>>   * Comment about 'page_to_virt()' is updated. I don't remove R-b,
>>     as this change is quiet small I guess.
>>
>>  net/vmw_vsock/virtio_transport.c | 41 +++++++++++++++++++++++++++-----
>>  1 file changed, 35 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> index e95df847176b..7bbcc8093e51 100644
>> --- a/net/vmw_vsock/virtio_transport.c
>> +++ b/net/vmw_vsock/virtio_transport.c
>> @@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>  	vq = vsock->vqs[VSOCK_VQ_TX];
>>  
>>  	for (;;) {
>> -		struct scatterlist hdr, buf, *sgs[2];
>> +		/* +1 is for packet header. */
>> +		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>> +		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
> 
> Note that MAX_SKB_FRAGS depends on a config knob (CONFIG_MAX_SKB_FRAGS)
> and valid/reasonable values are up to 45. The total stack usage can be
> pretty large (~700 bytes).
> 
> As this is under the vsk tx lock, have you considered moving such data
> in the virtio_vsock struct?

I think yes, there will be no problem if these temporary variables will be moved
into this global struct. I'll add comment about this reason.

> 
>>  		int ret, in_sg = 0, out_sg = 0;
>>  		struct sk_buff *skb;
>>  		bool reply;
>> @@ -111,12 +113,39 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>>  
>>  		virtio_transport_deliver_tap_pkt(skb);
>>  		reply = virtio_vsock_skb_reply(skb);
>> +		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
>> +			    sizeof(*virtio_vsock_hdr(skb)));
>> +		sgs[out_sg] = &bufs[out_sg];
>> +		out_sg++;
>> +
>> +		if (!skb_is_nonlinear(skb)) {
>> +			if (skb->len > 0) {
>> +				sg_init_one(&bufs[out_sg], skb->data, skb->len);
>> +				sgs[out_sg] = &bufs[out_sg];
>> +				out_sg++;
>> +			}
>> +		} else {
>> +			struct skb_shared_info *si;
>> +			int i;
>> +
>> +			si = skb_shinfo(skb);
> 
> This assumes that the paged skb does not carry any actual data in the
> head buffer (only the header). Is that constraint enforced somewhere
> else? Otherwise a
> 
> 	WARN_ON_ONCE(skb_headlen(skb) > sizeof(*virtio_vsock_hdr(skb))
> 
> could be helpful to catch early possible bugs.

Yes, such skbs have data only in paged part, while linear buffer contains only
header. Ok, let's add this warning here to prevent future bugs.

Thanks, Arseniy

> 
> Thanks!
> 
> Paolo
> 
>> +
>> +			for (i = 0; i < si->nr_frags; i++) {
>> +				skb_frag_t *skb_frag = &si->frags[i];
>> +				void *va;
>>  
>> -		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>> -		sgs[out_sg++] = &hdr;
>> -		if (skb->len > 0) {
>> -			sg_init_one(&buf, skb->data, skb->len);
>> -			sgs[out_sg++] = &buf;
>> +				/* We will use 'page_to_virt()' for the userspace page
>> +				 * here, because virtio or dma-mapping layers will call
>> +				 * 'virt_to_phys()' later to fill the buffer descriptor.
>> +				 * We don't touch memory at "virtual" address of this page.
>> +				 */
>> +				va = page_to_virt(skb_frag->bv_page);
>> +				sg_init_one(&bufs[out_sg],
>> +					    va + skb_frag->bv_offset,
>> +					    skb_frag->bv_len);
>> +				sgs[out_sg] = &bufs[out_sg];
>> +				out_sg++;
>> +			}
>>  		}
>>  
>>  		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
> 
