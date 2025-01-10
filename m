Return-Path: <kvm+bounces-34998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0C4A08A6B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 998CF1884163
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BEF520897E;
	Fri, 10 Jan 2025 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5MgoYq8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C59520ADD8
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 08:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736498138; cv=none; b=mwhmtO+ayash+nStcuH3+/6zhVXQ1KLaOzY+TYFOmT9doUn6BxS8wh3GJKbE8L4mkrl5PU+Ufe+nciRVeAzrSo3I9Fprs85+QxUl9fvCh8/kprG0FA/E8CzM7JlRmHosRtRBttXhlcFihvnMzlAjRejGeYyxYcFtH1dGVJ4ojKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736498138; c=relaxed/simple;
	bh=QjfOQgTaUWrmSTlG/geSr55nIlTbnhvRsiGytk5OSls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEoNmfYhQOHP3qd0iA7t/QDX+tMByP0kzm9Rr+H5+QK0eIP2t/GL+OtyG1N+VGg39SStdRwqGvCQ4CASARk7GzJRHPXRYvrjpjIpwZsT0lOiwiLpfTsNLyYnTQVS/gpKhoku7WAGb00EqQdRZk194RNfdIPYlsE29fL/XA4pSKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5MgoYq8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736498136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sBLDY4DTw2zaWMjga9j81VUizG/Z+zQDnv2kJoLZ4eU=;
	b=J5MgoYq8llsSaZg5DlPTxJmyRn3oqNS4/skVdIZCccbo757hYIE8YcQLjFipsXR7tonn9Z
	IydwYJ3l41+3kTzuHRQkwx8NJAilGRD8iYVJJS9m+u7MeSuXrGcBHQHSYT0s9JZd+P0Kr4
	XNfG8ORhMSnQWn51sImr882AYEPkDU0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-PkFcHGxGNiaTM3vMgX2OdA-1; Fri, 10 Jan 2025 03:35:34 -0500
X-MC-Unique: PkFcHGxGNiaTM3vMgX2OdA-1
X-Mimecast-MFC-AGG-ID: PkFcHGxGNiaTM3vMgX2OdA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-388d1f6f3b2so783548f8f.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 00:35:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736498133; x=1737102933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sBLDY4DTw2zaWMjga9j81VUizG/Z+zQDnv2kJoLZ4eU=;
        b=q7SILhz4a4yJ/PNOUD/cOX/QxVIhb4TuTdyUg6PvSxLV95MWL/bxvID4Ob7uM/TkNb
         Itp6+CmF0RjN+5zm4PIamnTgUv0LEZMSwqgZfGsGnOcK3sPZk9iB6aGxH7lbUd6YVc7h
         a1oRVgIvHD1gV0/6SovrQnwS0V0N63WcpWfu3Wc0LaWHm4ZM7H7aouPd3b4NOVi/EzHN
         0aSbhiNL5vfXQqp7h1MnbHY8TB8mPxwuGKJnxjOfCuBtE3TJYxbRt/2ZJUnKlVDFL1kX
         qnXwJSI10vTDH69IuJAqVO8avj1xdZwI6/XHJSK9WeC6B4TOZlWBOuGr7yPZaTVFTDi9
         fgQA==
X-Forwarded-Encrypted: i=1; AJvYcCWIwIh+nhKsw+/uuP0zZThNhdEpDCMfRA+omUpnFtOmy0capYZnvafzfRI/dm170K10U6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzglQabk6UBNtVcvD26Gl6/xElOgArZ6l6aWTUCScB89bN3tGk
	XNfPPsdPEX9Bt/RN0AowI/mujG8Ui/oBJMB05Pz3AIglg5k4lFCYEKxTIBI2d1sA9vIBdMaHS8X
	ddRgPj27c6MNeI80dHfA8xF/hOfU61F4vDXYa+OgE7ZFTIcnaVQ==
X-Gm-Gg: ASbGncvUfxCPW8n5dOaydEC+2wpbdKfkDaZoA95i7j/yHx5HweodedzRQ9T+mX4df97
	zA5n+E/pxegOCKjTWi9o4ST77bLb1cD5XeddD7amuPoj373npGMhl2wiwfjitg+8076hR3A+9kQ
	17QEaaD5ODP0iD2Nsnx0374Tyg48sqqYZCiN5b4izZ0CYrq9VVNKqP3d6PtoeqBL7Ly2tcWyTlq
	YfTj5cF0VO3Agbpp5uCbRg0wiVOIIctrJfqoU65dhlZhnU=
X-Received: by 2002:a5d:64eb:0:b0:385:ec89:2f07 with SMTP id ffacd0b85a97d-38a87312d2emr8464150f8f.32.1736498133281;
        Fri, 10 Jan 2025 00:35:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkY+6wyisWu9I5OnlNIAEaCc1RkfYRMe4WOOPOqI9L+4Q6XFHZJA9lRe1HqGdOwc7Z+AC+ww==
X-Received: by 2002:a5d:64eb:0:b0:385:ec89:2f07 with SMTP id ffacd0b85a97d-38a87312d2emr8464107f8f.32.1736498132691;
        Fri, 10 Jan 2025 00:35:32 -0800 (PST)
Received: from step1.. ([5.77.78.183])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436dcc8ddddsm73101805e9.0.2025.01.10.00.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 00:35:31 -0800 (PST)
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
Subject: [PATCH net v2 3/5] vsock/virtio: cancel close work in the destructor
Date: Fri, 10 Jan 2025 09:35:09 +0100
Message-ID: <20250110083511.30419-4-sgarzare@redhat.com>
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

During virtio_transport_release() we can schedule a delayed work to
perform the closing of the socket before destruction.

The destructor is called either when the socket is really destroyed
(reference counter to zero), or it can also be called when we are
de-assigning the transport.

In the former case, we are sure the delayed work has completed, because
it holds a reference until it completes, so the destructor will
definitely be called after the delayed work is finished.
But in the latter case, the destructor is called by AF_VSOCK core, just
after the release(), so there may still be delayed work scheduled.

Refactor the code, moving the code to delete the close work already in
the do_close() to a new function. Invoke it during destruction to make
sure we don't leave any pending work.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Closes: https://lore.kernel.org/netdev/Z37Sh+utS+iV3+eb@v4bel-B760M-AORUS-ELITE-AX/
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 29 ++++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 51a494b69be8..7f7de6d88096 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -26,6 +26,9 @@
 /* Threshold for detecting small packets to copy */
 #define GOOD_COPY_LEN  128
 
+static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
+					       bool cancel_timeout);
+
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
 {
@@ -1109,6 +1112,8 @@ void virtio_transport_destruct(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
+	virtio_transport_cancel_close_work(vsk, true);
+
 	kfree(vvs);
 	vsk->trans = NULL;
 }
@@ -1204,17 +1209,11 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
 	}
 }
 
-static void virtio_transport_do_close(struct vsock_sock *vsk,
-				      bool cancel_timeout)
+static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
+					       bool cancel_timeout)
 {
 	struct sock *sk = sk_vsock(vsk);
 
-	sock_set_flag(sk, SOCK_DONE);
-	vsk->peer_shutdown = SHUTDOWN_MASK;
-	if (vsock_stream_has_data(vsk) <= 0)
-		sk->sk_state = TCP_CLOSING;
-	sk->sk_state_change(sk);
-
 	if (vsk->close_work_scheduled &&
 	    (!cancel_timeout || cancel_delayed_work(&vsk->close_work))) {
 		vsk->close_work_scheduled = false;
@@ -1226,6 +1225,20 @@ static void virtio_transport_do_close(struct vsock_sock *vsk,
 	}
 }
 
+static void virtio_transport_do_close(struct vsock_sock *vsk,
+				      bool cancel_timeout)
+{
+	struct sock *sk = sk_vsock(vsk);
+
+	sock_set_flag(sk, SOCK_DONE);
+	vsk->peer_shutdown = SHUTDOWN_MASK;
+	if (vsock_stream_has_data(vsk) <= 0)
+		sk->sk_state = TCP_CLOSING;
+	sk->sk_state_change(sk);
+
+	virtio_transport_cancel_close_work(vsk, cancel_timeout);
+}
+
 static void virtio_transport_close_timeout(struct work_struct *work)
 {
 	struct vsock_sock *vsk =
-- 
2.47.1


