Return-Path: <kvm+bounces-64923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C97DC91457
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 09:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D79EF3ACF5F
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 08:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5D32E9EC1;
	Fri, 28 Nov 2025 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="tFQsu/ZA"
X-Original-To: kvm@vger.kernel.org
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB892E03EA;
	Fri, 28 Nov 2025 08:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764319314; cv=none; b=YQWgQk4MDNrw9+d4n0/UxbQBlEwQzpizudoUfj0WNi5SQ62XtIrkCBHgLcT9sTAOpnvpUXTS1TZu2E6HngJDn4V32I4qqeBermf4exKTm4xBLnOAhVLLp2TMzjEc9A5a2faO4oR8bFce7eXa0y4ugFJMc4pbh6GjChjkeOU1HBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764319314; c=relaxed/simple;
	bh=ObBQE2s6w9HpNtJAwbYSXSwHgGEn8nc872DiGO97wuw=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=Tzw7F0RPmmFvtpBXWRtkvBXMWXRHE20gxPmH8GxClYtUyYM90391k43U/REnHnsyfj8P6x5c/ARSCar1kOcCbzYOqgPv1YFICx9x/v/Zc7Kk2wtQS1CX4dX5vogVm32CKbO/kmZWK8UG7uRcTLe92LKo9kd19OV61aZU2/YEaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=tFQsu/ZA; arc=none smtp.client-ip=43.163.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1764319301; bh=A8mGR1d0H3r4bTkQhku0Qmh1ZtU7rdJN6hfaTO0TCCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFQsu/ZARHr/IuMfdIIEHFK/rTVNGAGMiKOGGz3rA8PosZRwEpOeC9X6y6m4eAtqE
	 AJBsXfKWQGa/HLHuZ4GEITXk/o0n/zD4gwOAQ5KxnB3PbTbk+s10BhPGNrtWIJrYuT
	 rnosBWufLAopFhJavViqU7NUh9uShCgZ29mjARDY=
Received: from lxu-ped-host.. ([111.201.7.117])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id A660CEAC; Fri, 28 Nov 2025 16:41:38 +0800
X-QQ-mid: xmsmtpt1764319298t8lg5qfwq
Message-ID: <tencent_387517772566B03DBD365896C036264AA809@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uRkp6Iutn8gH3U/2cUmQ2vbZNRc0DRSeKbGa5dtJo5Ioh9IVQjx
	 t64wGLlZUkU+vMD8fMxdF0pACrDiveMTe3zsI10UdlU6h+6OljpXgZzKuWbXuB6EyTn+YkWJiJ4a
	 nezFiCWi2eVIJfWiRh1OYxMgtYC4FU7ql0FoA48AE+pjTMczj7A1BL/U4/BImO7ppUM5wKom+WtX
	 C7TXUtJgDOZ3+Q5lbBwh65Ey8ggUt/WlwCnm3O+q5bJE4EC20SRSIxR3Y2uGh3WBdEFmXb+HIZHL
	 Bvq3dQOHCnLAR6sRB51wx+V2H3Dac6V/ZDkvl/JChQU9Tj4f7JrF/JeZLWyMAd7ytFY/fQ9k6lVM
	 wOTZ5iQKqB8zpBgXpUs7nQ82QPkuqvoWB6gsoCdJKAuKsNg/lwA6t6pmp7oErpgT2YNyRlPZigbj
	 sOMv7LEmhw/YqMKdBfRK3EGDPDqmnBPTxwk0Yueq4d7aCBTQSGU46139JdcD/J3cf+Ogf+KKaylP
	 3oIEXNyIYvwyvZu71sCDRM9Wuv5KyKF5zC5WVO2a5Eav36HBdpw4a/KCmDlNwvGrHfK9FMJoiFid
	 jpOC/KMHbSHistD3Ikz7/B9TV1oYFJJoE20Rs8IvdHX/XMPe5ph5TkvkQQ2/Z6qclGZ+amo5/okW
	 fdfaxtyIK6TsMur2uA0SLTzoJSAzh4QdvVibQ8p9Ql7ul3jT1wi6MvBaFOlh08vooIEZsgQxH+JZ
	 0KazWIga4LwbR71i2j2onIqAT2tEyqCxt3u0KKe/CRE6zyAwLWuDAhUk+FiFYdLeqP0lCFOUG51x
	 LHoC39ULfKvsqd27ESsaTYMeElVXf0ttE/LJZx4xW4jhMavBBiZMb+Y/yAP0Fh2yTtDetsRKx2X6
	 uxXXCK7cmdS9ArHz8h7hEiKeWz0szd9WcAHGBoA4e2LQiojE9S+PYTLsER86q2xKT8Ku3VCJ1pu3
	 MXH7gbOGuhDYENSVJy5Jd8O+tQnHiBY8fB93ZKBH1GxjAsVGpRe3vlDzHKUY3yIGJRwd2+QQY=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Edward Adam Davis <eadavis@qq.com>
To: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	eperezma@redhat.com,
	horms@kernel.org,
	jasowang@redhat.com,
	kuba@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	sgarzare@redhat.com,
	stefanha@redhat.com,
	syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: [PATCH Next] net: restore the iterator to its original state when an error occurs
Date: Fri, 28 Nov 2025 16:41:38 +0800
X-OQ-MSGID: <20251128084137.112073-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6928fe78.a70a0220.d98e3.012a.GAE@google.com>
References: <6928fe78.a70a0220.d98e3.012a.GAE@google.com>
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
Tested-by: syzbot+28e5f3d207b14bae122a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
---
 net/core/datagram.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index c285c6465923..da10465cd8a4 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -748,10 +748,13 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 			    size_t length,
 			    struct net_devmem_dmabuf_binding *binding)
 {
+	struct iov_iter_state state;
 	unsigned long orig_size = skb->truesize;
 	unsigned long truesize;
 	int ret;
 
+	iov_iter_save_state(from, &state);
+
 	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		ret = msg->sg_from_iter(skb, from, length);
 	else if (binding)
@@ -759,6 +762,9 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else
 		ret = zerocopy_fill_skb_from_iter(skb, from, length);
 
+	if (ret)
+		iov_iter_restore(from, &state);
+
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
 		sk_wmem_queued_add(sk, truesize);
-- 
2.43.0


