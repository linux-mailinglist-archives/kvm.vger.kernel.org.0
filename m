Return-Path: <kvm+bounces-65225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E08C9FDAF
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 17:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5CD183008041
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 16:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD283431E3;
	Wed,  3 Dec 2025 16:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="QbyG//lT"
X-Original-To: kvm@vger.kernel.org
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A85342146;
	Wed,  3 Dec 2025 16:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777838; cv=none; b=TPt5IbLRSEhyE18tBa4y1+px6tUo5CDsvnfELxHNffhjALEG8WCnKESTyD1lbkm3Vs39msFVMCm0CBXhblPaSv8i07uh6rw5LceZV/4qu1JOgml/krvygkdsW6V/uJl4EkJRxVo00mN8/0SSGTNbpFi3A8KrZtwQrm+9HdxhEtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777838; c=relaxed/simple;
	bh=44aWoO0xgrbCYwAvNjJ2HHKTl5rnXStHKGkAwNTZeOE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=RmoVYI5qjg6+QA0uoA29qi5lGL3ZpGpFk46K2PDFhKkife5+piXELcBpLRQl7WHunnRuguqC12ieXEe97yDiq5ydyBLOjosAZUUIV4gn2kcr1fzPwh9wV1ZoQzrngNLrah9P/xr/xBc0so++CTJXav7wX76ZEwWpGorECEYd8zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=QbyG//lT; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1764777825; bh=e1cr7cB9gHoKGVQYhIC4CvFypTqIWDD1zmvqi8c+6Rc=;
	h=From:To:Cc:Subject:Date;
	b=QbyG//lTMa/9UlMzl/F1rT2VpRekrhDi140zrwXsEFxSKLzxa82XPIV0xdSy1JvuV
	 bO5FZCFlHkFc9agzjEY451ZKMoNH3jguHqx6tQpBDlF0SaZg+fFDzz43GdFxpasXEX
	 pr8ot8bgWs+Vjuy0jUeOXEqaABpgHX7sV7wKiFX4=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id E81C8F7; Thu, 04 Dec 2025 00:03:40 +0800
X-QQ-mid: xmsmtpt1764777820t4qo7i2do
Message-ID: <tencent_3C86DFD37A0374496263BE24483777D76305@qq.com>
X-QQ-XMAILINFO: Mm3lGEhJcF5GES4dJXmrXXeRjVFRK9xLrz1OHc0rxpoLA+afC7a9iXoooZhjj4
	 toWUN1AVx0njlGItEE030M4WPQN5zD05g7mji1EtYEXqIvgYiceXGF7lBPga5KuJop7VY/csunpw
	 n2LJ/6GtcJRCEpr823xHzkTC6Q5RgZC1XWtWOS6H0jtRkvL3ay52VuS+u4wJ1S435fLZVVv/7Mu/
	 cVhsURbGNz7iuExHYBBmYMG25EpCXsjX2UpzDnxXWEOLJTOtIEEULHxbFD+H7pu4fhzAoUop9GUH
	 yDkzV3exGXX3+LiywTimz3dNggCqva4d87NBkzSVKBgWR8LP3n4SoOjBLEYU6omP1gYGBmyl0Kvz
	 NLVhxD5q0/3u71Xezsrzc0XJXTvv+dtLfMayITb+kDdRQkr/fS8ZTHh8QqrG34Pcbae0IuyYwmpS
	 08HRuFluYAN2RXO0pBFXowJAU34Jil1EICUaAXnJwQi080+5duxZgAkamoW4WHevkyLr6rsSZSnL
	 lc+SvJdMxm5DPavd5Pf2N6MoZX1zneLIggVimp2Gomd3CM+liSpm4muW8dkIwFe3u4e3B4ePg12A
	 gE/6BZ96kh7bLL3UVSZwsIRDHg+RpQVcaijqYDUnK4bxwXxLPXhwWKS/YCscJnrG21XjLv4fIS8i
	 EBA94xZpH6iX590So0Y8/Mnoj2GJAmNQ+b+z68xoheAu8OfCEA7daMTs/iQsEdeRtI3xtaUF1dBF
	 aQmpYmLNBLFUqmeh1JOd5joAXAY+oJfOZqIN4lO/bFQtOotbtKa+gUYdm6HEg5okqsNs6IZflCSN
	 Jq2E7ATchHPTHBPck3p//zYnyrK2cTommDsZ+jZq60vDXSxpaWTesZ04UouE5JNA5fjMfivzJo1a
	 aGwIl6CAvj4v2Rz0MP0F97iZRP13Id7lZpkJg3CVlZlQLHpqWceqXuECwPiap7kKbWUeE8HSqdNu
	 53Uud1bGVJ0H7r3jI9zBhdEG7Nkvv3WmQrwMfJ+D8Ru1LJMeI/Xo65X7eiXSinrZSKl+tdfAazZ8
	 KPIbRkZQ==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Edward Adam Davis <eadavis@qq.com>
To: kuba@kernel.org
Cc: davem@davemloft.net,
	eadavis@qq.com,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzbot+ci3edb9412aeb2e703@syzkaller.appspotmail.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: [PATCH net-next V3] net: restore the iterator to its original state when an error occurs
Date: Thu,  4 Dec 2025 00:03:39 +0800
X-OQ-MSGID: <20251203160339.303720-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In zerocopy_fill_skb_from_iter(), if two copy operations are performed
and the first one succeeds while the second one fails, it returns a
failure but the count in iterator has already been decremented due to
the first successful copy. This ultimately affects the local variable
rest_len in virtio_transport_send_pkt_info(), causing the remaining
count in rest_len to be greater than the actual iterator count. As a
result, packet sending operations continue even when the iterator count
is zero, which further leads to skb->len being 0 and triggers the warning
reported by syzbot [1].

Therefore, if the zerocopy operation fails, we should revert the iterator
to its original state.

The iov_iter_revert() in skb_zerocopy_iter_stream() is no longer needed
and has been removed.

[1]
'send_pkt()' returns 0, but 4096 expected
WARNING: net/vmw_vsock/virtio_transport_common.c:430 at virtio_transport_send_pkt_info+0xd1e/0xef0 net/vmw_vsock/virtio_transport_common.c:428, CPU#1: syz.0.17/5986
Call Trace:
 virtio_transport_stream_enqueue net/vmw_vsock/virtio_transport_common.c:1113 [inline]
 virtio_transport_seqpacket_enqueue+0x143/0x1c0 net/vmw_vsock/virtio_transport_common.c:841
 vsock_connectible_sendmsg+0xabf/0x1040 net/vmw_vsock/af_vsock.c:2158
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:746

Reported-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=28e5f3d207b14bae122a
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
v3:
  - fix test tcp_zerocopy_maxfrags timeout
v2: https://lore.kernel.org/all/tencent_BA768766163C533724966E36344AAE754709@qq.com/
  - Remove iov_iter_revert() in skb_zerocopy_iter_stream()
v1: https://lore.kernel.org/all/tencent_387517772566B03DBD365896C036264AA809@qq.com/

 net/core/datagram.c | 9 ++++++++-
 net/core/skbuff.c   | 1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index c285c6465923..3a612ebbbe80 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -748,9 +748,13 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    size_t length,
 			    struct net_devmem_dmabuf_binding *binding)
 {
+	struct iov_iter_state state;
 	unsigned long orig_size = skb->truesize;
 	unsigned long truesize;
-	int ret;
+	int ret, orig_len;
+
+	iov_iter_save_state(from, &state);
+	orig_len = skb->len;
 
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		ret = msg->sg_from_iter(skb, from, length);
@@ -759,6 +763,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else
 		ret = zerocopy_fill_skb_from_iter(skb, from, length);
 
+	if (ret == -EFAULT || (ret == -EMSGSIZE && skb->len == orig_len))
+		iov_iter_restore(from, &state);
+
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
 		sk_wmem_queued_add(sk, truesize);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a00808f7be6a..7b8836f668b7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1908,7 +1908,6 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
-		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
 		___pskb_trim(skb, orig_len);
 		skb->sk = save_sk;
-- 
2.43.0


