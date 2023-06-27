Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA473F3B3
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 06:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjF0EsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 00:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjF0Ern (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 00:47:43 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214FF19BA;
        Mon, 26 Jun 2023 21:47:14 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 4C44D5FD20;
        Tue, 27 Jun 2023 07:47:12 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1687841232;
        bh=yRmCYPFIDeRr6hqHZ/8Ucw4Bal/N4BW9u6qwfm5whMc=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=m58zsYZ4W72+7ohiqwrLjoYhLluOJXWKuCWuZ42ohvgxW/iCcuI9/WNdQjqASTrx7
         /O/1LUuYJPYMkcuPS482cZb656Pu7XIJxbPhYU89eccSwxwpJ3YzRpMZq1rd1iGopB
         9MFY1vUEIQr2lAWsWr8oocPR7LRSity9TRWLf6dE+WI1SsbFkrh1eQ+5QS5ER0+oIq
         AbQKjGB/VuM804giwVZjUCxBEHG2MNgWIHtu84qvJsSK/S/uQ76Tn/H2YHEML18HNT
         cIrOf5ob+sN0WMlST1BUBst4fEsPfd2A3IXxGGKfOwqmtIwqUG0Dt6lDAqLOqw8B+O
         7Ozmae+4KNBNA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 27 Jun 2023 07:46:56 +0300 (MSK)
Message-ID: <b25f0c4d-828c-ffe8-2780-2c954ed8770a@sberdevices.ru>
Date:   Tue, 27 Jun 2023 07:41:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [RFC PATCH v4 05/17] vsock/virtio: MSG_ZEROCOPY flag support
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
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-6-AVKrasnov@sberdevices.ru>
 <rbyt6uomvimurmgchxpuyoqjehdleqzzohzzdnajgadrwkbwsf@qwlcvzqhqxqw>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <rbyt6uomvimurmgchxpuyoqjehdleqzzohzzdnajgadrwkbwsf@qwlcvzqhqxqw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/27 02:11:00 #21585463
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 26.06.2023 19:03, Stefano Garzarella wrote:
> On Sat, Jun 03, 2023 at 11:49:27PM +0300, Arseniy Krasnov wrote:
>> This adds handling of MSG_ZEROCOPY flag on transmission path: if this
>> flag is set and zerocopy transmission is possible, then non-linear skb
>> will be created and filled with the pages of user's buffer. Pages of
>> user's buffer are locked in memory by 'get_user_pages()'.
>>
>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> ---
>> net/vmw_vsock/virtio_transport_common.c | 270 ++++++++++++++++++------
>> 1 file changed, 208 insertions(+), 62 deletions(-)
>>
>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>> index 0de562c1dc4b..f1ec38c72db7 100644
>> --- a/net/vmw_vsock/virtio_transport_common.c
>> +++ b/net/vmw_vsock/virtio_transport_common.c
>> @@ -37,27 +37,100 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
>>     return container_of(t, struct virtio_transport, transport);
>> }
>>
>> -/* Returns a new packet on success, otherwise returns NULL.
>> - *
>> - * If NULL is returned, errp is set to a negative errno.
>> - */
>> -static struct sk_buff *
>> -virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>> -               size_t len,
>> -               u32 src_cid,
>> -               u32 src_port,
>> -               u32 dst_cid,
>> -               u32 dst_port)
>> -{
>> -    const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>> -    struct virtio_vsock_hdr *hdr;
>> -    struct sk_buff *skb;
>> +static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
>> +                       size_t max_to_send)
>> +{
>> +    struct iov_iter *iov_iter;
>> +
>> +    if (!info->msg)
>> +        return false;
>> +
>> +    iov_iter = &info->msg->msg_iter;
>> +
>> +    /* Data is simple buffer. */
>> +    if (iter_is_ubuf(iov_iter))
>> +        return true;
>> +
>> +    if (!iter_is_iovec(iov_iter))
>> +        return false;
>> +
>> +    if (iov_iter->iov_offset)
>> +        return false;
>> +
>> +    /* We can't send whole iov. */
>> +    if (iov_iter->count > max_to_send)
>> +        return false;
>> +
>> +    return true;
>> +}
>> +
>> +static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
>> +                       struct sk_buff *skb,
>> +                       struct msghdr *msg,
>> +                       bool zerocopy)
>> +{
>> +    struct ubuf_info *uarg;
>> +
>> +    if (msg->msg_ubuf) {
>> +        uarg = msg->msg_ubuf;
>> +        net_zcopy_get(uarg);
>> +    } else {
>> +        struct iov_iter *iter = &msg->msg_iter;
>> +        struct ubuf_info_msgzc *uarg_zc;
>> +        int len;
>> +
>> +        /* Only ITER_IOVEC or ITER_UBUF are allowed and
>> +         * checked before.
>> +         */
>> +        if (iter_is_iovec(iter))
>> +            len = iov_length(iter->__iov, iter->nr_segs);
>> +        else
>> +            len = iter->count;
>> +
>> +        uarg = msg_zerocopy_realloc(sk_vsock(vsk),
>> +                        len,
>> +                        NULL);
>> +
>> +        if (!uarg)
>> +            return -1;
>> +
>> +        uarg_zc = uarg_to_msgzc(uarg);
>> +        uarg_zc->zerocopy = zerocopy ? 1 : 0;
>> +    }
>> +
>> +    skb_zcopy_init(skb, uarg);
>> +
>> +    return 0;
>> +}
>> +
>> +static int virtio_transport_fill_linear_skb(struct sk_buff *skb,
>> +                        struct vsock_sock *vsk,
> 
> `vsk` seems unused
> 
>> +                        struct virtio_vsock_pkt_info *info,
>> +                        size_t len)
>> +{
>>     void *payload;
>>     int err;
>>
>> -    skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>> -    if (!skb)
>> -        return NULL;
>> +    payload = skb_put(skb, len);
>> +    err = memcpy_from_msg(payload, info->msg, len);
>> +    if (err)
>> +        return -1;
>> +
>> +    if (msg_data_left(info->msg))
>> +        return 0;
>> +
>> +    return 0;
>> +}
>> +
>> +static void virtio_transport_init_hdr(struct sk_buff *skb,
>> +                      struct virtio_vsock_pkt_info *info,
>> +                      u32 src_cid,
>> +                      u32 src_port,
>> +                      u32 dst_cid,
>> +                      u32 dst_port,
>> +                      size_t len)
>> +{
>> +    struct virtio_vsock_hdr *hdr;
>>
>>     hdr = virtio_vsock_hdr(skb);
>>     hdr->type    = cpu_to_le16(info->type);
>> @@ -68,42 +141,6 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>>     hdr->dst_port    = cpu_to_le32(dst_port);
>>     hdr->flags    = cpu_to_le32(info->flags);
>>     hdr->len    = cpu_to_le32(len);
>> -
>> -    if (info->msg && len > 0) {
>> -        payload = skb_put(skb, len);
>> -        err = memcpy_from_msg(payload, info->msg, len);
>> -        if (err)
>> -            goto out;
>> -
>> -        if (msg_data_left(info->msg) == 0 &&
>> -            info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>> -            hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>> -
>> -            if (info->msg->msg_flags & MSG_EOR)
>> -                hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>> -        }
>> -    }
>> -
>> -    if (info->reply)
>> -        virtio_vsock_skb_set_reply(skb);
>> -
>> -    trace_virtio_transport_alloc_pkt(src_cid, src_port,
>> -                     dst_cid, dst_port,
>> -                     len,
>> -                     info->type,
>> -                     info->op,
>> -                     info->flags);
>> -
>> -    if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
>> -        WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
>> -        goto out;
>> -    }
>> -
>> -    return skb;
>> -
>> -out:
>> -    kfree_skb(skb);
>> -    return NULL;
>> }
>>
>> static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
>> @@ -214,6 +251,85 @@ static u16 virtio_transport_get_type(struct sock *sk)
>>         return VIRTIO_VSOCK_TYPE_SEQPACKET;
>> }
>>
>> +/* Returns a new packet on success, otherwise returns NULL.
>> + *
>> + * If NULL is returned, errp is set to a negative errno.
> 
> I had noticed this in Bobby's patches, I think it's an old comment we
> left around.
> 
>> + */
>> +static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock *vsk,
>> +                          struct virtio_vsock_pkt_info *info,
>> +                          size_t payload_len,
>> +                          bool zcopy,
>> +                          u32 dst_cid,
>> +                          u32 dst_port,
>> +                          u32 src_cid,
>> +                          u32 src_port)
>> +{
>> +    struct sk_buff *skb;
>> +    size_t skb_len;
>> +
>> +    skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
>> +
>> +    if (!zcopy)
>> +        skb_len += payload_len;
>> +
>> +    skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>> +    if (!skb)
>> +        return NULL;
>> +
>> +    virtio_transport_init_hdr(skb, info, src_cid, src_port,
>> +                  dst_cid, dst_port,
>> +                  payload_len);
>> +
>> +    /* Set owner here, because '__zerocopy_sg_from_iter()' uses
>> +     * owner of skb without check to update 'sk_wmem_alloc'.
>> +     */
>> +    if (vsk)
>> +        skb_set_owner_w(skb, sk_vsock(vsk));
> 
> why we are moving from skb_set_owner_sk_safe() to skb_set_owner_w()?
> 
> We should mention this in the commit description.
> 
>> +
>> +    if (info->msg && payload_len > 0) {
>> +        int err;
>> +
>> +        if (zcopy) {
>> +            err = __zerocopy_sg_from_iter(info->msg, NULL, skb,
>> +                              &info->msg->msg_iter,
>> +                              payload_len);
>> +        } else {
>> +            err = virtio_transport_fill_linear_skb(skb, vsk, info, payload_len);
>> +        }
>> +
>> +        if (err)
>> +            goto out;
>> +
>> +        VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
>> +
>> +        if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>> +            struct virtio_vsock_hdr *hdr;
>> +
>> +            hdr = virtio_vsock_hdr(skb);
> 
> Just `struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);` should be
> fine.
> 
>> +
>> +            hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>> +
>> +            if (info->msg->msg_flags & MSG_EOR)
>> +                hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>> +        }
>> +    }
>> +
>> +    if (info->reply)
>> +        virtio_vsock_skb_set_reply(skb);
>> +
>> +    trace_virtio_transport_alloc_pkt(src_cid, src_port,
>> +                     dst_cid, dst_port,
>> +                     payload_len,
>> +                     info->type,
>> +                     info->op,
>> +                     info->flags);
>> +
>> +    return skb;
>> +out:
>> +    kfree_skb(skb);
>> +    return NULL;
>> +}
>> +
>> /* This function can only be used on connecting/connected sockets,
>>  * since a socket assigned to a transport is required.
>>  *
>> @@ -226,6 +342,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>     const struct virtio_transport *t_ops;
>>     struct virtio_vsock_sock *vvs;
>>     u32 pkt_len = info->pkt_len;
>> +    bool can_zcopy = false;
>> +    u32 max_skb_cap;
>>     u32 rest_len;
>>     int ret;
>>
>> @@ -254,22 +372,49 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>     if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>>         return pkt_len;
>>
>> +    /* If zerocopy is not enabled by 'setsockopt()', we behave as
>> +     * there is no MSG_ZEROCOPY flag set.
>> +     */
>> +    if (!sock_flag(sk_vsock(vsk), SOCK_ZEROCOPY))
>> +        info->flags &= ~MSG_ZEROCOPY;
>> +
>> +    if (info->flags & MSG_ZEROCOPY)
>> +        can_zcopy = virtio_transport_can_zcopy(info, pkt_len);
>> +
>> +    if (can_zcopy)
>> +        max_skb_cap = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE,
>> +                    (MAX_SKB_FRAGS * PAGE_SIZE));
>> +    else
>> +        max_skb_cap = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>> +
> 
> We use `len` very often, what about `max_skb_len`?
> 
>>     rest_len = pkt_len;
>>
>>     do {
>>         struct sk_buff *skb;
>>         size_t skb_len;
>>
>> -        skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>> +        skb_len = min(max_skb_cap, rest_len);
>>
>> -        skb = virtio_transport_alloc_skb(info, skb_len,
>> -                         src_cid, src_port,
>> -                         dst_cid, dst_port);
>> +        skb = virtio_transport_alloc_skb(vsk, info, skb_len, can_zcopy,
>> +                         dst_cid, dst_port,
>> +                         src_cid, src_port);
>>         if (!skb) {
>>             ret = -ENOMEM;
>>             break;
>>         }
>>
>> +        /* This is last skb to send this portion of data. */
>> +        if (skb_len == rest_len &&
>> +            info->flags & MSG_ZEROCOPY &&
>> +            info->op == VIRTIO_VSOCK_OP_RW) {
>> +            if (virtio_transport_init_zcopy_skb(vsk, skb,
>> +                                info->msg,
>> +                                can_zcopy)) {
>> +                ret = -ENOMEM;
>> +                break;
>> +            }
>> +        }
>> +
>>         virtio_transport_inc_tx_pkt(vvs, skb);
>>
>>         ret = t_ops->send_pkt(skb);
>> @@ -884,6 +1029,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
>>         .msg = msg,
>>         .pkt_len = len,
>>         .vsk = vsk,
>> +        .flags = msg->msg_flags,
> 
> These flags then get copied into the virtio_vsock_hdr, which I don't
> think is a good idea.
> 
> Why not using directly info->msg->msg_flags?

Ops, yes, it's a bug, You're right, this is really wrong as there are two different
sets of flags - MSG_XXX passed to syscall and flags in the header of packet.

Thanks, Arseniy

> 
>>     };
>>
>>     return virtio_transport_send_pkt_info(vsk, &info);
>> @@ -935,11 +1081,11 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>>     if (!t)
>>         return -ENOTCONN;
>>
>> -    reply = virtio_transport_alloc_skb(&info, 0,
>> -                       le64_to_cpu(hdr->dst_cid),
>> -                       le32_to_cpu(hdr->dst_port),
>> +    reply = virtio_transport_alloc_skb(NULL, &info, 0, false,
>>                        le64_to_cpu(hdr->src_cid),
>> -                       le32_to_cpu(hdr->src_port));
>> +                       le32_to_cpu(hdr->src_port),
>> +                       le64_to_cpu(hdr->dst_cid),
>> +                       le32_to_cpu(hdr->dst_port));
>>     if (!reply)
>>         return -ENOMEM;
>>
>> -- 
>> 2.25.1
>>
> 
