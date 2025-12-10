Return-Path: <kvm+bounces-65648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F75FCB26CE
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 09:32:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A2C3310B181
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 08:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A8E3016F5;
	Wed, 10 Dec 2025 08:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghM+4o8r"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14C31F3FE9;
	Wed, 10 Dec 2025 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765355491; cv=none; b=HmMkVrGojpdDrnyHqj5hhcj769m0hPou+0Hxb8hBV2xrG2sF8Jil+P76ftsC00q3h0y3GKQWtOICFF289cEnN94a62F1a9cHP4PkM29j2IKu+KUT5ejnH4xLwHEQXMMTpIK9uiGcWGJwiLgCr4YOfymss260PrRjfh3oXw8geMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765355491; c=relaxed/simple;
	bh=n7nCUlTV4fyFUAsZSXKYvC743HHeyUkFmbdCcDsWo+M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C+7dfwcDwUy/3V9k2FtU/ucJshDWx8Ltf7NOZiR3GoGj+GSvvkXVXFAxwtD/nPrp0WRst3OIaJ3DKxmUyK4lAW/KEC8+PzdA6q0NhrCbJl0IVofPoN3kIeZK/05aU9z1GhaS4k26GvnuBu5dFDj12tR5kmTFptJW82ZkJhoklbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghM+4o8r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96596C4CEF1;
	Wed, 10 Dec 2025 08:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765355491;
	bh=n7nCUlTV4fyFUAsZSXKYvC743HHeyUkFmbdCcDsWo+M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ghM+4o8rF/F5mw+FOs2evBq07uS5QT/UaWbrA7+lu1nYQkS5toqOZTcnqNon7wus7
	 cOZaVW7XoNseG15YkvjZ/xlc0GXNUFMmgGzb7pOAXQ3ll/nqMbPeVkg3jB2/N4SN0K
	 a3AEA7zme/jWHTUguYbNpeKwQ1oo3Q+RXqJh7R4aoh8LDdiApAA7dUNoIdEmq2ETNj
	 Ql1U/X/DTdeyAm8HcITheEW0pZaeRnG4u4S8RYGhatSD4Jr30Mu2c8rPD+fgCNaJqS
	 pH2Ivxkdj4Db9Fn8nYf2I9fBDZytufzrx+nVoaXDRXLi3OwqkejLArsrq7HituzOG3
	 ndBKO/RRsHI4w==
Date: Wed, 10 Dec 2025 17:31:25 +0900
From: Jakub Kicinski <kuba@kernel.org>
To: Edward Adam Davis <eadavis@qq.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com,
 horms@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
 pabeni@redhat.com, sgarzare@redhat.com, stefanha@redhat.com,
 syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
 syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com, will@kernel.org
Subject: Re: [PATCH net-next V3] net: restore the iterator to its original
 state when an error occurs
Message-ID: <20251210173125.281dc808@kernel.org>
In-Reply-To: <tencent_3C86DFD37A0374496263BE24483777D76305@qq.com>
References: <tencent_3C86DFD37A0374496263BE24483777D76305@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

CC: Will, as this looks like ZC side of 7fb1291257ea1e27

On Thu,  4 Dec 2025 00:03:39 +0800 Edward Adam Davis wrote:
> In zerocopy_fill_skb_from_iter(), if two copy operations are performed
> and the first one succeeds while the second one fails, it returns a
> failure but the count in iterator has already been decremented due to
> the first successful copy. This ultimately affects the local variable
> rest_len in virtio_transport_send_pkt_info(), causing the remaining
> count in rest_len to be greater than the actual iterator count. As a
> result, packet sending operations continue even when the iterator count
> is zero, which further leads to skb->len being 0 and triggers the warning
> reported by syzbot [1].
> 
> Therefore, if the zerocopy operation fails, we should revert the iterator
> to its original state.
> 
> The iov_iter_revert() in skb_zerocopy_iter_stream() is no longer needed
> and has been removed.
> 
> [1]
> 'send_pkt()' returns 0, but 4096 expected
> WARNING: net/vmw_vsock/virtio_transport_common.c:430 at virtio_transport_send_pkt_info+0xd1e/0xef0 net/vmw_vsock/virtio_transport_common.c:428, CPU#1: syz.0.17/5986
> Call Trace:
>  virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1113 [inline]
>  virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:841
>  vsock_connectible_sendmsg+0xabf/0x1040 net/vmw_vsock/af_vsock.c:2158
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:746
> 
> Reported-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=28e5f3d207b14bae122a
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
> v3:
>   - fix test tcp_zerocopy_maxfrags timeout
> v2: https://lore.kernel.org/all/tencent_BA768766163C533724966E36344AAE754709@qq.com/
>   - Remove iov_iter_revert() in skb_zerocopy_iter_stream()
> v1: https://lore.kernel.org/all/tencent_387517772566B03DBD365896C036264AA809@qq.com/

Have you investigated the other callers? Given problems with previous
version of this patch I'm worried you have not. If you did please extend
the commit message with the appropriate explanation.

Alternative would be to add a _full() flavor of this API, but not sure
if other callers actually care.

> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index c285c6465923..3a612ebbbe80 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -748,9 +748,13 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
>  			    size_t length,
>  			    struct net_devmem_dmabuf_binding *binding)
>  {
> +	struct iov_iter_state state;

nit: if you respin move this one line down

>  	unsigned long orig_size = skb->truesize;
>  	unsigned long truesize;
> -	int ret;
> +	int ret, orig_len;
> +
> +	iov_iter_save_state(from, &state);
> +	orig_len = skb->len;
>  
>  	if (msg && msg->msg_ubuf && msg->sg_from_iter)
>  		ret = msg->sg_from_iter(skb, from, length);
> @@ -759,6 +763,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
>  	else
>  		ret = zerocopy_fill_skb_from_iter(skb, from, length);
>  
> +	if (ret == -EFAULT || (ret == -EMSGSIZE && skb->len == orig_len))

I'd think that for the purpose of reverting iter the second part of
this condition is completely moot. If skb len didn't change there should
be nothing to revert?

> +		iov_iter_restore(from, &state);
> +
>  	truesize = skb->truesize - orig_size;
>  	if (sk && sk->sk_type == SOCK_STREAM) {
>  		sk_wmem_queued_add(sk, truesize);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index a00808f7be6a..7b8836f668b7 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1908,7 +1908,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
>  		struct sock *save_sk = skb->sk;
>  
>  		/* Streams do not free skb on error. Reset to prev state. */
> -		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
>  		skb->sk = sk;
>  		___pskb_trim(skb, orig_len);
>  		skb->sk = save_sk;
-- 
pw-bot: cr

