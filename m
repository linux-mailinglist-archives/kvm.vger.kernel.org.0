Return-Path: <kvm+bounces-34999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D4DCA08A6F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46B2D165066
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6017020B1EF;
	Fri, 10 Jan 2025 08:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1PPdZ99"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E520B1EE
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498143; cv=none; b=puea+BPYsGagpR1V5LRFlcjFfnVPfV6pfJhWqdOWYBaIATyT3OnZGq2RXg+x+zHozEtXSzb55O+c2FF0oQiCFqXWsco7pSRjqiNp3jUwWhTfVqqH1LupTm9GLSTnohJnrUjeJtsKP8Ie3TYGFg+FdH3ttMteNNmPXwHDdUm91JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498143; c=relaxed/simple;
	bh=uPsduUWhdScehzIkWWVjxwh3m7xAtK9UHuNXKkdV3cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1nb8QCrVzh1uY01nUPLSdF7sE6j0xYEux65YbHuttjUGfH1l2JYTXhPR5my6FIhlbrZuZNfoyUITHwUibeICEYImtMPE60P4U8fZVyStmK0B4/buYr2TdZXnGy9Wk1GzxgQLqGah9efqNV6Fkpot1Jfr5Gk+15HZuJJFaVgnwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1PPdZ99; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736498141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i/UxJFQhjZHiTLyDu6i94GmVxCXul14lCOVKyB1E+sY=;
	b=P1PPdZ99n92Uc8zsuCYTOeZlzGlJxfQS/MdOUwvWN4jZpsSXH4HhxlXpBPMmW1VMV7E7ie
	WpREVjgCOgbdg8QBx4SnprjyRyKeQChMUrYPUMfKtsyFzGL+gxBUM6fdOnVjlui8GssAdj
	rLd0OH7bg++sr8DLtp4oSC3aGhjBMIU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-153-CMpBgCZfNY225Sbj-RVpFg-1; Fri, 10 Jan 2025 03:35:40 -0500
X-MC-Unique: CMpBgCZfNY225Sbj-RVpFg-1
X-Mimecast-MFC-AGG-ID: CMpBgCZfNY225Sbj-RVpFg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43625ceae52so9655065e9.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:35:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736498139; x=1737102939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i/UxJFQhjZHiTLyDu6i94GmVxCXul14lCOVKyB1E+sY=;
        b=DF028PZgvwSkgG+cH7mFGOlP7iA2ZKdtOZHk/Hmr5mWxzE718oN/Zxek3CYqLQpifU
         8ezd3q36/0FmlVPv6prLQq/OrK3vo7fzAk6uWz4RqLPkI13WwDJ47s/zPW9YfaS53iry
         NkTg/fcXMgoGS0uTYP4Cdv+IqleOyyqkq0tGBWdDb0m7smaqgdCyzQJPmZIXhxg9qcVm
         UCnk4XKLCY3YXW38zx/21kGWoRbMJ+knB7bWIb0bL99+trIev7KJg/JWEXhnPU7QqkWV
         5Vwi2RPrEOu7x5qcPKbC+7SpgNOIkNXTJSkcco3R3/PD4xxXKZhzrS5ZiAfX6UGtpdZs
         JYRg==
X-Forwarded-Encrypted: i=1; AJvYcCVSEPpt1Irvm5AseYSw1wmVmFMOw7aPEz1utl2HeVJwbca+0n27ucsmYnw8HAXm+hSMLtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwuhAnUs1M7ET3fnpVhtIc0UeZGM03QFHckUbCuiDPApJV94FO
	qQTlSxPv7bKlvYsSpN7Tbql5jBjnE+psfRhMXNw+kZHGB80loRloQnrQjtxInBjfj8aWB8uwxiw
	QK+MXen71yLBN3KyrWjd7rvngZ2vTwrFSZzvR/+UubHfOMPE0Ew==
X-Gm-Gg: ASbGncuTxa+hGmA3B6bZ5e1Q6JBsBqoBsSknCMRW9dq4c2Wbfq6Sy41PeJrxIAvcvk6
	0vmsDvPXzPKO3rZMUZ4nQzbh5/Zp9yMqd/cUYwQnfxo5XcDIvlR6cJo++Cjb2Sb1JEElL1VlOvN
	jV/VNNrQXjxtJIGhLaDr0WlFf4qAtMYZ5mUEEOOOYYHkO2BrGi6mE5Zf/YlRnVJ7BdBuJPoF39m
	lznJvxam6Srnfuk2rdLOt2iXHpy8FtgEUy7tKSV3YZyBrk=
X-Received: by 2002:adf:ae59:0:b0:38a:88b8:97a9 with SMTP id ffacd0b85a97d-38a88b898b4mr6672296f8f.2.1736498138758;
        Fri, 10 Jan 2025 00:35:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0wfwdkUAlCHyAfjqywZwwjbDz7xJE+/6M4bU0+8jxnFXT/mEU5AdPqfdlVeWVXgoMTeKpvg==
X-Received: by 2002:adf:ae59:0:b0:38a:88b8:97a9 with SMTP id ffacd0b85a97d-38a88b898b4mr6672275f8f.2.1736498138249;
        Fri, 10 Jan 2025 00:35:38 -0800 (PST)
Received: from step1.. ([5.77.78.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4b8214sm3895187f8f.78.2025.01.10.00.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:35:37 -0800 (PST)
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
	stable@vger.kernel.org
Subject: [PATCH net v2 4/5] vsock: reset socket state when de-assigning the transport
Date: Fri, 10 Jan 2025 09:35:10 +0100
Message-ID: <20250110083511.30419-5-sgarzare@redhat.com>
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

Transport's release() and destruct() are called when de-assigning the
vsock transport. These callbacks can touch some socket state like
sock flags, sk_state, and peer_shutdown.

Since we are reassigning the socket to a new transport during
vsock_connect(), let's reset these fields to have a clean state with
the new transport.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5cf8109f672a..74d35a871644 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -491,6 +491,15 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
+
+		/* transport's release() and destruct() can touch some socket
+		 * state, since we are reassigning the socket to a new transport
+		 * during vsock_connect(), let's reset these fields to have a
+		 * clean state.
+		 */
+		sock_reset_flag(sk, SOCK_DONE);
+		sk->sk_state = TCP_CLOSE;
+		vsk->peer_shutdown = 0;
 	}
 
 	/* We increase the module refcnt to prevent the transport unloading
-- 
2.47.1


