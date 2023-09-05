Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8898C7926A4
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbjIEQFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348231AbjIEEhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 00:37:13 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225ED1B6;
        Mon,  4 Sep 2023 21:37:08 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 651E7120003;
        Tue,  5 Sep 2023 07:37:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 651E7120003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1693888625;
        bh=HoIC/Rt7SCCOTU5bzlF4Kw/h0G5mggsepxhm/KWPIrg=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:From;
        b=hIJ7B0NsW7yAaf58/o8XZuTZxIYaC/3XsjNmNqKM187fL/S+F2TdfTM/h9P82y2Uw
         krF6hyzSxYEaeqbHR8r3haXXXCYVlBEq7prtyRelRQCFHWcn1aImP5140T/3X9K1hx
         Z9lyXRTOT+J9mJqx4+UjMSMkBYxORLXGrqTzYSOjrlDo3xgBgT30cAmZjpeV51UeKE
         KjbxFmX/1EUC6f21eErA0clUB5+6bQpUVA1/qMlHIBbV2QIueD65HHSIokHNk8e+Fy
         yPfRRRAxPJrs3ljcA17u2Jx3QQDjJ+ZXU6yuuZfsG9FYyDWKh/sY+8zvY3gVzS2Wcu
         xDLyytGWQw3iw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue,  5 Sep 2023 07:37:03 +0300 (MSK)
Received: from [192.168.0.106] (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 5 Sep 2023 07:36:59 +0300
Message-ID: <c3b34d3c-29ea-5a0f-24d3-483836faa7ba@salutedevices.com>
Date:   Tue, 5 Sep 2023 07:30:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v7 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>
References: <20230827085436.941183-1-avkrasnov@salutedevices.com>
 <20230827085436.941183-5-avkrasnov@salutedevices.com>
 <p2u2irlju6yuy54w4tqstaijhpnbmqxwavsdumsmyskrjguwux@kmd7cbavhjbh>
 <0ab443b5-73a5-f092-44a3-52e26244c9a8@salutedevices.com>
 <h63t6heovmyafu2lo6x6rzsbdbrhqhlbuol774ngbgshbycgdu@fgynzbmj5zn7>
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
In-Reply-To: <h63t6heovmyafu2lo6x6rzsbdbrhqhlbuol774ngbgshbycgdu@fgynzbmj5zn7>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179642 [Sep 04 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 529 529 a773548e495283fecef97c3e587259fde2135fef, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/05 03:12:00 #21800815
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04.09.2023 11:21, Stefano Garzarella wrote:
> On Sun, Sep 03, 2023 at 11:13:23AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 01.09.2023 15:30, Stefano Garzarella wrote:
>>> On Sun, Aug 27, 2023 at 11:54:36AM +0300, Arseniy Krasnov wrote:
>>>> This adds handling of MSG_ZEROCOPY flag on transmission path: if this
>>>> flag is set and zerocopy transmission is possible (enabled in socket
>>>> options and transport allows zerocopy), then non-linear skb will be
>>>> created and filled with the pages of user's buffer. Pages of user's
>>>> buffer are locked in memory by 'get_user_pages()'. Second thing that
>>>> this patch does is replace type of skb owning: instead of calling
>>>> 'skb_set_owner_sk_safe()' it calls 'skb_set_owner_w()'. Reason of this
>>>> change is that '__zerocopy_sg_from_iter()' increments 'sk_wmem_alloc'
>>>> of socket, so to decrease this field correctly proper skb destructor is
>>>> needed: 'sock_wfree()'. This destructor is set by 'skb_set_owner_w()'.
>>>>
>>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> 
> [...]
> 
>>>>
>>>> -/* Returns a new packet on success, otherwise returns NULL.
>>>> - *
>>>> - * If NULL is returned, errp is set to a negative errno.
>>>> - */
>>>> -static struct sk_buff *
>>>> -virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>>>> -               size_t len,
>>>> -               u32 src_cid,
>>>> -               u32 src_port,
>>>> -               u32 dst_cid,
>>>> -               u32 dst_port)
>>>> -{
>>>> -    const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>>>> -    struct virtio_vsock_hdr *hdr;
>>>> -    struct sk_buff *skb;
>>>> +static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
>>>> +                       size_t max_to_send)
>>>                                               ^
>>> I'd call it `pkt_len`, `max_to_send` is confusing IMHO. I didn't
>>> initially if it was the number of buffers or bytes.
>>>
>>>> +{
>>>> +    const struct virtio_transport *t_ops;
>>>> +    struct iov_iter *iov_iter;
>>>> +
>>>> +    if (!info->msg)
>>>> +        return false;
>>>> +
>>>> +    iov_iter = &info->msg->msg_iter;
>>>> +
>>>> +    if (iov_iter->iov_offset)
>>>> +        return false;
>>>> +
>>>> +    /* We can't send whole iov. */
>>>> +    if (iov_iter->count > max_to_send)
>>>> +        return false;
>>>> +
>>>> +    /* Check that transport can send data in zerocopy mode. */
>>>> +    t_ops = virtio_transport_get_ops(info->vsk);
>>>> +
>>>> +    if (t_ops->can_msgzerocopy) {
>>>
>>> So if `can_msgzerocopy` is not implemented, we always return true after
>>> this point. Should we mention it in the .can_msgzerocopy documentation?


^^^

Sorry, ops again. Just checked this code during comments fixing. It is correct
to "return true;" Idea is:

if (generic conditions for MSG_ZEROCOPY == false)
    return false;// can't zerocopy

if (t_ops->can_msgzerocopy) //transport needs extra check
    return t_ops->can_msgzerocopy();

return true;//transport doesn't require extra check and generic conditions above are OK -> can zerocopy

But anyway:

1) I'll add comment in 'struct virtio_transport' for '.can_msgzerocopy' that this callback is
   not mandatory - just additional transport specific check.

2) Add test for fallback to copy.

Thanks, Arseniy

>>
>> Ops, this is my mistake, I must return 'false' in this case. Seems I didn't
>> catch this problem with my tests, because there was no test case where
>> zerocopy will fallback to copy!
>>
>> I'll fix it and add new test!
> 
> yep, I agree!
> 
>>
>>>
>>> Can we also mention in the commit description why this is need only for
>>> virtio_tranport and not for vhost and loopback?
>>>
>>>> +        int pages_in_iov = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
>>>> +        int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
>>>> +
>>>> +        return t_ops->can_msgzerocopy(pages_to_send);
>>>> +    }
>>>> +
>>>> +    return true;
>>>> +}
>>>> +
> 
> [...]
> 
>>>> @@ -270,6 +395,17 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>>             break;
>>>>         }
>>>>
>>>> +        /* This is last skb to send this portion of data. */
>>>
>>> Sorry I didn't get it :-(
>>>
>>> Can you elaborate this a bit more?
>>
>> I mean that we iterate over user's buffer here, allocating skb on each
>> iteration. And for last skb for this buffer we initialize completion
>> for user (we need to allocate one completion for one syscall).
> 
> Okay, so maybe we should explain better also in the code comment.
>>
>> Thanks for review, I'll fix all other comments and resend patchset when
>> 'net-next' will be opened again.
> 
> Cool, thanks!
> Stefano
> 
