Return-Path: <kvm+bounces-34997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED90A08A63
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A0C31685E3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F8920A5F4;
	Fri, 10 Jan 2025 08:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCqE31qx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A1D2080FB
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498133; cv=none; b=WKIDP9Rxy7nmIW6Eo/eFDK24htBF6AyPCmjU4pWFnmnc/hYsNWgJ87j1ZRs3l4q0gnhOjEBS8HgLyrlhz8ZaK/EKtOCvZYkrznarxyCB5e456bwi8GBCVZrbi0dYgElTVYhdTmsenozgQN+Y5rG0JrZ0aDnJJfeWaSvXsawHtlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498133; c=relaxed/simple;
	bh=N7oUWVYpspVtl1b3a9o1m38utpVtuI2HVqr6S2jFP5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmckHhHMmX8IzxWen1u84ZCT6qYu3Dp95qXIO6smTSVUO3fJsIkbp5TWdHbjT87LM84DHX2661Idcbx/yg5577P3+d+uX6hM3xd0z4AtMTlAcHyyP45AOfLbvlohzchonJldM80nxUgkKo1FuoQHs6ySbneW9iO9iRxTfmTBnZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dCqE31qx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736498130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCCvBVF1oU547nRVhmRIMNs6MmiGORia96sQhicKNFk=;
	b=dCqE31qxSqd1ZwhYVYqf7woY75Jvp9X7cCNr62s2EdBAv0JoIisOj0i+uvqI16/wdsu/fD
	xggBvm/SSZ4nUvz2C+RLiKDJtp8PaOHxjB0sGqcWQrXpL70g0sLKqBlh9jmB+7csh/yUNW
	mPRNdrcACrezWQ5AbPk7c0eMM/OVeb4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-jC6a9wIVMQSd4konEoE0nA-1; Fri, 10 Jan 2025 03:35:28 -0500
X-MC-Unique: jC6a9wIVMQSd4konEoE0nA-1
X-Mimecast-MFC-AGG-ID: jC6a9wIVMQSd4konEoE0nA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43651b1ba8aso12572815e9.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:35:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736498127; x=1737102927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jCCvBVF1oU547nRVhmRIMNs6MmiGORia96sQhicKNFk=;
        b=Pv54C8A7J24fteYn/xAXIce6drSYGyRBBjK33TkpA77OIM+W+is7bm6dGm2YFey3L3
         DdXGfKBDcy81dqeoxASu+OGQIi79d5cBpn5cJkbw37uY3P9g+MSVuYI3ce2unEBoLul0
         fucWILnm3+dx/PkqO8q2gWEQAc2B7g8ugJEcp0/vLUu07Zv+S40MD7jlwaErhJ5Ihdwy
         uJZiZ1JeiJlWH4GANzB1OB8rvUmqNyeN+JuLxdGjUTRCaXU2gQgsKMO6E7SX6SY3acLo
         Ze/Q6INMlWoXCzWITInQHcsqWT4EBAirDRODpkO2wtFOpNxEzDyAwpqx0JPv8+v/mWjU
         76Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVcgFRsglNyslDFin3IeWFr6snV3EOwawuIFhsW6w4Ro9ya9sCH/pofGTasVxoQ8DTZxAM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwySefr+rTw9uyEN++eDDAg7ke5PE6ytq8+VTKKflbaRJCg4MNd
	oH0kenFVNlRPkWx09Ntj/4O4oobckuKr1zEqF4C61nmvYWTmMKreZMxoyBEoDcLHOMcREoZDsOi
	FRyj/flXQCffO21RhrYIrG7UXWEf7D73V48dnt+6EUhDvqRT1dA==
X-Gm-Gg: ASbGncvPA03iA+ZMw3JAxht5oXMWP6Q7BZfzr7zruSjiifrw7FuAo4SgNcQmwepo7Nu
	oxJ3D+gUyKQEtJoo9pMO50ovBMeorr3jyH7SXNFmHtN9g8DL8GWT1AziucPXcmVEJn+OAUg+nXf
	nqUNNn/TJgjxvKl2GKtHiWHrNnprEyS5TIRqXVTC5rCReMFgyZDUwDvE3MwUqrTcUHyZ5D8axpc
	JwQvvP6TmYTSI57066p8sODn2qL/m0hzRJA6NRdgsR+hyY=
X-Received: by 2002:a05:600c:3b08:b0:436:18e5:6917 with SMTP id 5b1f17b1804b1-436e255ffd6mr98683015e9.0.1736498127452;
        Fri, 10 Jan 2025 00:35:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXYbonID+NCEiPxf2xSK2i1RLGHHOMCpGw+AxBXOdkAZovSc4AvlC1EcoGIJDqTU4Av556Sw==
X-Received: by 2002:a05:600c:3b08:b0:436:18e5:6917 with SMTP id 5b1f17b1804b1-436e255ffd6mr98682465e9.0.1736498126795;
        Fri, 10 Jan 2025 00:35:26 -0800 (PST)
Received: from step1.. ([5.77.78.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38332asm3858150f8f.23.2025.01.10.00.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:35:26 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luigi Leonardi <leonardi@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	kvm@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Hyunwoo Kim <v4bel@theori.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Michal Luczaj <mhal@rbox.co>,
	virtualization@lists.linux.dev,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	stable@vger.kernel.org,
	syzbot+3affdbfc986ecd9200fd@syzkaller.appspotmail.com
Subject: [PATCH net v2 2/5] vsock/bpf: return early if transport is not assigned
Date: Fri, 10 Jan 2025 09:35:08 +0100
Message-ID: <20250110083511.30419-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250110083511.30419-1-sgarzare@redhat.com>
References: <20250110083511.30419-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the core functions can only be called if the transport
has been assigned.

As Michal reported, a socket might have the transport at NULL,
for example after a failed connect(), causing the following trace:

    BUG: kernel NULL pointer dereference, address: 00000000000000a0
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 12faf8067 P4D 12faf8067 PUD 113670067 PMD 0
    Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
    CPU: 15 UID: 0 PID: 1198 Comm: a.out Not tainted 6.13.0-rc2+
    RIP: 0010:vsock_connectible_has_data+0x1f/0x40
    Call Trace:
     vsock_bpf_recvmsg+0xca/0x5e0
     sock_recvmsg+0xb9/0xc0
     __sys_recvfrom+0xb3/0x130
     __x64_sys_recvfrom+0x20/0x30
     do_syscall_64+0x93/0x180
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

So we need to check the `vsk->transport` in vsock_bpf_recvmsg(),
especially for connected sockets (stream/seqpacket) as we already
do in __vsock_connectible_recvmsg().

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Cc: stable@vger.kernel.org
Reported-by: Michal Luczaj <mhal@rbox.co>
Closes: https://lore.kernel.org/netdev/5ca20d4c-1017-49c2-9516-f6f75fd331e9@rbox.co/
Tested-by: Michal Luczaj <mhal@rbox.co>
Reported-by: syzbot+3affdbfc986ecd9200fd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/677f84a8.050a0220.25a300.01b3.GAE@google.com/
Tested-by: syzbot+3affdbfc986ecd9200fd@syzkaller.appspotmail.com
Reviewed-by: Hyunwoo Kim <v4bel@theori.io>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vsock_bpf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
index 4aa6e74ec295..f201d9eca1df 100644
--- a/net/vmw_vsock/vsock_bpf.c
+++ b/net/vmw_vsock/vsock_bpf.c
@@ -77,6 +77,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 			     size_t len, int flags, int *addr_len)
 {
 	struct sk_psock *psock;
+	struct vsock_sock *vsk;
 	int copied;
 
 	psock = sk_psock_get(sk);
@@ -84,6 +85,13 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 		return __vsock_recvmsg(sk, msg, len, flags);
 
 	lock_sock(sk);
+	vsk = vsock_sk(sk);
+
+	if (!vsk->transport) {
+		copied = -ENODEV;
+		goto out;
+	}
+
 	if (vsock_has_data(sk, psock) && sk_psock_queue_empty(psock)) {
 		release_sock(sk);
 		sk_psock_put(sk, psock);
@@ -108,6 +116,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 		copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	}
 
+out:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 
-- 
2.47.1


