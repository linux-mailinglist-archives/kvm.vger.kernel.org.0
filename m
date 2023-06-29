Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC8E742680
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 14:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjF2Mdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 08:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjF2Mdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 08:33:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DB22684
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 05:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688041967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HYE719U1OUkNnisJmvcieL26+HWSje3lg9pLqFXWKw8=;
        b=Yt7mnbcsiGRXufOXYiN0M/TalPKjRobFyHBxwIDmiB4TYxYzECHsTNGWwFIjHdefvwlP/p
        PINlEAjKQupgekgNFph5rpqTd+IG415E2gRyGAbsXltTHHtQvvbPp2nn9XuaI2FJ2RRAhs
        yQoWpfPhVYjFMwMhisqN9Xq1gCrdxLk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-6b-szuWyPH-DfjVjEPzi9Q-1; Thu, 29 Jun 2023 08:32:45 -0400
X-MC-Unique: 6b-szuWyPH-DfjVjEPzi9Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3140a8bb992so327135f8f.2
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 05:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688041964; x=1690633964;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HYE719U1OUkNnisJmvcieL26+HWSje3lg9pLqFXWKw8=;
        b=MTSPuSIsVrx26UyJ5Bze5Wqlg6a5OThu8j0rRcAg4LPybEgJtIDwijajS5JMo+jeQa
         qpYzGU1aab75AgJq+jNOmjy8ZOtNzAeRhV9v1decy919qAlW3wm3lWvV14S9qeV4M5+O
         ERKSPEImfnepAkOH1udYtSMNYYDGp0qanrPdln3Hr7RLf810TnnKCHSEWGFA5JkIsaZF
         tZsTbZsAKyJOnXSJGIYBIx19gVfRwrBItjaE+qm+gnclkU++1JZfGhOgDsB8kG/FDRuY
         K4c/YHUmD3t/VmoHh/jYRGtIhCDv3U+XegrZmHUonK9EevWCHbA6s2cEDQX49zOC3SGs
         3Ypw==
X-Gm-Message-State: ABy/qLbNiJr3GHxchFfCH6rDtODtJ/aT3n7HH7Y55JhLWvcTsO6PrzRD
        dHgVOX/A0EdJK4I4KnWWMK/+EJ1U1uIZgjNp6QCEgjlcP7I4xon/nfWYdV4COhIte6ks3TBxkxz
        fjI9A2vzE4lA8
X-Received: by 2002:a5d:46c5:0:b0:314:1d88:f072 with SMTP id g5-20020a5d46c5000000b003141d88f072mr317981wrs.25.1688041964179;
        Thu, 29 Jun 2023 05:32:44 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEtUwIW1ZrD3I9b9uT4pawJX8l8ZiV0GiqcnxSQtlSd3loTHdLCrIheG0Pd7AXzzPURuZJHKQ==
X-Received: by 2002:a5d:46c5:0:b0:314:1d88:f072 with SMTP id g5-20020a5d46c5000000b003141d88f072mr317966wrs.25.1688041963792;
        Thu, 29 Jun 2023 05:32:43 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id j19-20020a5d4533000000b0030fafcbbd33sm15635349wra.50.2023.06.29.05.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jun 2023 05:32:43 -0700 (PDT)
Date:   Thu, 29 Jun 2023 14:32:40 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 05/17] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <kkz3hl5ebhblyyerduybbrdcntdilsecjlhq4y5cymayw55q22@w4mph6yu2x7d>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-6-AVKrasnov@sberdevices.ru>
 <rbyt6uomvimurmgchxpuyoqjehdleqzzohzzdnajgadrwkbwsf@qwlcvzqhqxqw>
 <b25f0c4d-828c-ffe8-2780-2c954ed8770a@sberdevices.ru>
 <m5q3fqqvur4pcvkcxx36ivoqu77tsrjd4xna6zszmzq34dbqq5@6wfrhllk6tsq>
 <7bce4bbc-6549-1284-e027-05d5a9d100e1@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7bce4bbc-6549-1284-e027-05d5a9d100e1@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 27, 2023 at 11:22:52AM +0300, Arseniy Krasnov wrote:
>
>
>On 27.06.2023 10:50, Stefano Garzarella wrote:
>> On Tue, Jun 27, 2023 at 07:41:51AM +0300, Arseniy Krasnov wrote:
>>>
>>>
>>> On 26.06.2023 19:03, Stefano Garzarella wrote:
>>>> On Sat, Jun 03, 2023 at 11:49:27PM +0300, Arseniy Krasnov wrote:
>>>>> This adds handling of MSG_ZEROCOPY flag on transmission path: if this
>>>>> flag is set and zerocopy transmission is possible, then non-linear skb
>>>>> will be created and filled with the pages of user's buffer. Pages of
>>>>> user's buffer are locked in memory by 'get_user_pages()'.
>>>>>
>>>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>>>> ---
>>>>> net/vmw_vsock/virtio_transport_common.c | 270 ++++++++++++++++++------
>>>>> 1 file changed, 208 insertions(+), 62 deletions(-)
>>>>>
>>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>>>>> index 0de562c1dc4b..f1ec38c72db7 100644
>>>>> --- a/net/vmw_vsock/virtio_transport_common.c
>>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
>>>>> @@ -37,27 +37,100 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
>>>>>     return container_of(t, struct virtio_transport, transport);
>>>>> }
>>>>>
>>>>> -/* Returns a new packet on success, otherwise returns NULL.
>>>>> - *
>>>>> - * If NULL is returned, errp is set to a negative errno.
>>>>> - */
>>>>> -static struct sk_buff *
>>>>> -virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>>>>> -               size_t len,
>>>>> -               u32 src_cid,
>>>>> -               u32 src_port,
>>>>> -               u32 dst_cid,
>>>>> -               u32 dst_port)
>>>>> -{
>>>>> -    const size_t skb_len = VIRTIO_VSOCK_SKB_HEADROOM + len;
>>>>> -    struct virtio_vsock_hdr *hdr;
>>>>> -    struct sk_buff *skb;
>>>>> +static bool virtio_transport_can_zcopy(struct virtio_vsock_pkt_info *info,
>>>>> +                       size_t max_to_send)
>>>>> +{
>>>>> +    struct iov_iter *iov_iter;
>>>>> +
>>>>> +    if (!info->msg)
>>>>> +        return false;
>>>>> +
>>>>> +    iov_iter = &info->msg->msg_iter;
>>>>> +
>>>>> +    /* Data is simple buffer. */
>>>>> +    if (iter_is_ubuf(iov_iter))
>>>>> +        return true;
>>>>> +
>>>>> +    if (!iter_is_iovec(iov_iter))
>>>>> +        return false;
>>>>> +
>>>>> +    if (iov_iter->iov_offset)
>>>>> +        return false;
>>>>> +
>>>>> +    /* We can't send whole iov. */
>>>>> +    if (iov_iter->count > max_to_send)
>>>>> +        return false;
>>>>> +
>>>>> +    return true;
>>>>> +}
>>>>> +
>>>>> +static int virtio_transport_init_zcopy_skb(struct vsock_sock *vsk,
>>>>> +                       struct sk_buff *skb,
>>>>> +                       struct msghdr *msg,
>>>>> +                       bool zerocopy)
>>>>> +{
>>>>> +    struct ubuf_info *uarg;
>>>>> +
>>>>> +    if (msg->msg_ubuf) {
>>>>> +        uarg = msg->msg_ubuf;
>>>>> +        net_zcopy_get(uarg);
>>>>> +    } else {
>>>>> +        struct iov_iter *iter = &msg->msg_iter;
>>>>> +        struct ubuf_info_msgzc *uarg_zc;
>>>>> +        int len;
>>>>> +
>>>>> +        /* Only ITER_IOVEC or ITER_UBUF are allowed and
>>>>> +         * checked before.
>>>>> +         */
>>>>> +        if (iter_is_iovec(iter))
>>>>> +            len = iov_length(iter->__iov, iter->nr_segs);
>>>>> +        else
>>>>> +            len = iter->count;
>>>>> +
>>>>> +        uarg = msg_zerocopy_realloc(sk_vsock(vsk),
>>>>> +                        len,
>>>>> +                        NULL);
>>>>> +
>>>>> +        if (!uarg)
>>>>> +            return -1;
>>>>> +
>>>>> +        uarg_zc = uarg_to_msgzc(uarg);
>>>>> +        uarg_zc->zerocopy = zerocopy ? 1 : 0;
>>>>> +    }
>>>>> +
>>>>> +    skb_zcopy_init(skb, uarg);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static int virtio_transport_fill_linear_skb(struct sk_buff *skb,
>>>>> +                        struct vsock_sock *vsk,
>>>>
>>>> `vsk` seems unused
>>>>
>>>>> +                        struct virtio_vsock_pkt_info *info,
>>>>> +                        size_t len)
>>>>> +{
>>>>>     void *payload;
>>>>>     int err;
>>>>>
>>>>> -    skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>>>>> -    if (!skb)
>>>>> -        return NULL;
>>>>> +    payload = skb_put(skb, len);
>>>>> +    err = memcpy_from_msg(payload, info->msg, len);
>>>>> +    if (err)
>>>>> +        return -1;
>>>>> +
>>>>> +    if (msg_data_left(info->msg))
>>>>> +        return 0;
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static void virtio_transport_init_hdr(struct sk_buff *skb,
>>>>> +                      struct virtio_vsock_pkt_info *info,
>>>>> +                      u32 src_cid,
>>>>> +                      u32 src_port,
>>>>> +                      u32 dst_cid,
>>>>> +                      u32 dst_port,
>>>>> +                      size_t len)
>>>>> +{
>>>>> +    struct virtio_vsock_hdr *hdr;
>>>>>
>>>>>     hdr = virtio_vsock_hdr(skb);
>>>>>     hdr->type    = cpu_to_le16(info->type);
>>>>> @@ -68,42 +141,6 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
>>>>>     hdr->dst_port    = cpu_to_le32(dst_port);
>>>>>     hdr->flags    = cpu_to_le32(info->flags);
>>>>>     hdr->len    = cpu_to_le32(len);
>>>>> -
>>>>> -    if (info->msg && len > 0) {
>>>>> -        payload = skb_put(skb, len);
>>>>> -        err = memcpy_from_msg(payload, info->msg, len);
>>>>> -        if (err)
>>>>> -            goto out;
>>>>> -
>>>>> -        if (msg_data_left(info->msg) == 0 &&
>>>>> -            info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>>>>> -            hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>>>> -
>>>>> -            if (info->msg->msg_flags & MSG_EOR)
>>>>> -                hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>>>> -        }
>>>>> -    }
>>>>> -
>>>>> -    if (info->reply)
>>>>> -        virtio_vsock_skb_set_reply(skb);
>>>>> -
>>>>> -    trace_virtio_transport_alloc_pkt(src_cid, src_port,
>>>>> -                     dst_cid, dst_port,
>>>>> -                     len,
>>>>> -                     info->type,
>>>>> -                     info->op,
>>>>> -                     info->flags);
>>>>> -
>>>>> -    if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
>>>>> -        WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
>>>>> -        goto out;
>>>>> -    }
>>>>> -
>>>>> -    return skb;
>>>>> -
>>>>> -out:
>>>>> -    kfree_skb(skb);
>>>>> -    return NULL;
>>>>> }
>>>>>
>>>>> static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
>>>>> @@ -214,6 +251,85 @@ static u16 virtio_transport_get_type(struct sock *sk)
>>>>>         return VIRTIO_VSOCK_TYPE_SEQPACKET;
>>>>> }
>>>>>
>>>>> +/* Returns a new packet on success, otherwise returns NULL.
>>>>> + *
>>>>> + * If NULL is returned, errp is set to a negative errno.
>>>>
>>>> I had noticed this in Bobby's patches, I think it's an old comment we
>>>> left around.
>>>>
>>>>> + */
>>>>> +static struct sk_buff *virtio_transport_alloc_skb(struct vsock_sock *vsk,
>>>>> +                          struct virtio_vsock_pkt_info *info,
>>>>> +                          size_t payload_len,
>>>>> +                          bool zcopy,
>>>>> +                          u32 dst_cid,
>>>>> +                          u32 dst_port,
>>>>> +                          u32 src_cid,
>>>>> +                          u32 src_port)
>>>>> +{
>>>>> +    struct sk_buff *skb;
>>>>> +    size_t skb_len;
>>>>> +
>>>>> +    skb_len = VIRTIO_VSOCK_SKB_HEADROOM;
>>>>> +
>>>>> +    if (!zcopy)
>>>>> +        skb_len += payload_len;
>>>>> +
>>>>> +    skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
>>>>> +    if (!skb)
>>>>> +        return NULL;
>>>>> +
>>>>> +    virtio_transport_init_hdr(skb, info, src_cid, src_port,
>>>>> +                  dst_cid, dst_port,
>>>>> +                  payload_len);
>>>>> +
>>>>> +    /* Set owner here, because '__zerocopy_sg_from_iter()' uses
>>>>> +     * owner of skb without check to update 'sk_wmem_alloc'.
>>>>> +     */
>>>>> +    if (vsk)
>>>>> +        skb_set_owner_w(skb, sk_vsock(vsk));
>>>>
>>>> why we are moving from skb_set_owner_sk_safe() to skb_set_owner_w()?
>>>>
>>>> We should mention this in the commit description.
>>>>
>>>>> +
>>>>> +    if (info->msg && payload_len > 0) {
>>>>> +        int err;
>>>>> +
>>>>> +        if (zcopy) {
>>>>> +            err = __zerocopy_sg_from_iter(info->msg, NULL, skb,
>>>>> +                              &info->msg->msg_iter,
>>>>> +                              payload_len);
>>>>> +        } else {
>>>>> +            err = virtio_transport_fill_linear_skb(skb, vsk, info, payload_len);
>>>>> +        }
>>>>> +
>>>>> +        if (err)
>>>>> +            goto out;
>>>>> +
>>>>> +        VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
>>>>> +
>>>>> +        if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET) {
>>>>> +            struct virtio_vsock_hdr *hdr;
>>>>> +
>>>>> +            hdr = virtio_vsock_hdr(skb);
>>>>
>>>> Just `struct virtio_vsock_hdr *hdr = virtio_vsock_hdr(skb);` should be
>>>> fine.
>>>>
>>>>> +
>>>>> +            hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
>>>>> +
>>>>> +            if (info->msg->msg_flags & MSG_EOR)
>>>>> +                hdr->flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
>>>>> +        }
>>>>> +    }
>>>>> +
>>>>> +    if (info->reply)
>>>>> +        virtio_vsock_skb_set_reply(skb);
>>>>> +
>>>>> +    trace_virtio_transport_alloc_pkt(src_cid, src_port,
>>>>> +                     dst_cid, dst_port,
>>>>> +                     payload_len,
>>>>> +                     info->type,
>>>>> +                     info->op,
>>>>> +                     info->flags);
>>>>> +
>>>>> +    return skb;
>>>>> +out:
>>>>> +    kfree_skb(skb);
>>>>> +    return NULL;
>>>>> +}
>>>>> +
>>>>> /* This function can only be used on connecting/connected sockets,
>>>>>  * since a socket assigned to a transport is required.
>>>>>  *
>>>>> @@ -226,6 +342,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>>>     const struct virtio_transport *t_ops;
>>>>>     struct virtio_vsock_sock *vvs;
>>>>>     u32 pkt_len = info->pkt_len;
>>>>> +    bool can_zcopy = false;
>>>>> +    u32 max_skb_cap;
>>>>>     u32 rest_len;
>>>>>     int ret;
>>>>>
>>>>> @@ -254,22 +372,49 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>>>>>     if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>>>>>         return pkt_len;
>>>>>
>>>>> +    /* If zerocopy is not enabled by 'setsockopt()', we behave as
>>>>> +     * there is no MSG_ZEROCOPY flag set.
>>>>> +     */
>>>>> +    if (!sock_flag(sk_vsock(vsk), SOCK_ZEROCOPY))
>>>>> +        info->flags &= ~MSG_ZEROCOPY;
>>>>> +
>>>>> +    if (info->flags & MSG_ZEROCOPY)
>>>>> +        can_zcopy = virtio_transport_can_zcopy(info, pkt_len);
>>>>> +
>>>>> +    if (can_zcopy)
>>>>> +        max_skb_cap = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE,
>>>>> +                    (MAX_SKB_FRAGS * PAGE_SIZE));
>>>>> +    else
>>>>> +        max_skb_cap = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>>>>> +
>>>>
>>>> We use `len` very often, what about `max_skb_len`?
>>>>
>>>>>     rest_len = pkt_len;
>>>>>
>>>>>     do {
>>>>>         struct sk_buff *skb;
>>>>>         size_t skb_len;
>>>>>
>>>>> -        skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>>>>> +        skb_len = min(max_skb_cap, rest_len);
>>>>>
>>>>> -        skb = virtio_transport_alloc_skb(info, skb_len,
>>>>> -                         src_cid, src_port,
>>>>> -                         dst_cid, dst_port);
>>>>> +        skb = virtio_transport_alloc_skb(vsk, info, skb_len, can_zcopy,
>>>>> +                         dst_cid, dst_port,
>>>>> +                         src_cid, src_port);
>>>>>         if (!skb) {
>>>>>             ret = -ENOMEM;
>>>>>             break;
>>>>>         }
>>>>>
>>>>> +        /* This is last skb to send this portion of data. */
>>>>> +        if (skb_len == rest_len &&
>>>>> +            info->flags & MSG_ZEROCOPY &&
>>>>> +            info->op == VIRTIO_VSOCK_OP_RW) {
>>>>> +            if (virtio_transport_init_zcopy_skb(vsk, skb,
>>>>> +                                info->msg,
>>>>> +                                can_zcopy)) {
>>>>> +                ret = -ENOMEM;
>>>>> +                break;
>>>>> +            }
>>>>> +        }
>>>>> +
>>>>>         virtio_transport_inc_tx_pkt(vvs, skb);
>>>>>
>>>>>         ret = t_ops->send_pkt(skb);
>>>>> @@ -884,6 +1029,7 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
>>>>>         .msg = msg,
>>>>>         .pkt_len = len,
>>>>>         .vsk = vsk,
>>>>> +        .flags = msg->msg_flags,
>>>>
>>>> These flags then get copied into the virtio_vsock_hdr, which I don't
>>>> think is a good idea.
>>>>
>>>> Why not using directly info->msg->msg_flags?
>>>
>>> Ops, yes, it's a bug, You're right, this is really wrong as there are two different
>>> sets of flags - MSG_XXX passed to syscall and flags in the header of packet.
>>
>> Yep.
>>
>> What about the moving from skb_set_owner_sk_safe() to skb_set_owner_w()?
>> Was it voluntary? If so, can you explain why?
>
>Sure! here is what happens: difference between these functions is that 'skb_set_owner_w()'
>sets another destructor - 'sock_wfree()':
>
>https://elixir.bootlin.com/linux/v6.4/source/net/core/sock.c#L2408
>
>This destructor also updates 'sk->sk_wmem_alloc' during skb freeing. Why this is needed?
>Because '__zerocopy_sg_from_iter()' updates 'sk_wmem_alloc' if socket is NOT SOCK_STREAM
>or socket was NOT passed as input argument (it is not obvious why, but it is so):
>
>https://elixir.bootlin.com/linux/latest/source/net/core/datagram.c#L646
>
>So to support both types of sockets (seqpacket and stream) I decided to try pass NULL always
>as socket argument to '__zerocopy_sg_from_iter()', with this 'sk_wmem_alloc' will be always
>updated in '__zerocopy_sg_from_iter()' and then we decrease 'sk_wmem_alloc' in 'sock_wfree()'.
>
>May be this looks strange - I tried to understand logic of this code in '__zerocopy_sg_from_iter()',
>but it requires more deep analysis. Anyway it works:)

Yep, it should require also more analysis on my side :-)

Please document it in the commit description, so if we will find any
issue in the future, we know why we did this change.

Thanks,
Stefano

