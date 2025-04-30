Return-Path: <kvm+bounces-44874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9320AA4695
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685A35A6695
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0121F221FC8;
	Wed, 30 Apr 2025 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="TWoSFyl9"
X-Original-To: kvm@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598621ABC9;
	Wed, 30 Apr 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004292; cv=none; b=F71WwK3lIE/KpFlBiNdfbPxJwvsf3r3jaC+0rWlpdjgxsTdB7/p1QfMT/Z1APoOm1rgzZKclm4VNJitXfZ64N8Yp3W+1usrjn02VcHM4sWwEUpPBDexA6syEcwORDBS5vCdN7Kdws/m85+cc3Bw6Nm7TMhxQx2HwQdTp57BVj08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004292; c=relaxed/simple;
	bh=QOwQWEPmSdsZ1l9v4+trXRCmhOBbQz5fJN9ec4tju+o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C2yELGdNUV1gieWALJHQsUT1do1/Ktay5YVGnln0fMiYhYV+CRU6MqktJ3Fpj3wXQQRg1dpyXzQSi6+Zt2iDyDf8BxeQ4JzTKfxyIZdQL/yzxmgY9uERA0QA5hoc3mqZzbQk12SrpN3N9Ul4hC9tEhYXqS3txeZzCH3fuRi02h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=TWoSFyl9; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1uA3TN-006EEf-NF; Wed, 30 Apr 2025 11:11:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector1; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=+AFO0qPjos/NBG+JIX67V5Put3nuZOLxt4o4r9L7j7Q=; b=TWoSFyl9JCvkFqqVgMifYk2NCN
	V2SKHzuEZFd5KrOEnxRbTKosBvU+O2HzL+ctgTvj/4JEOo6zqIa1ueNucO4V2a6bAebkSWPqFYjT4
	1Y2H58Sts+tYlWgw+aPCHTQtrKXGpj3r0yKCWENpXe70M3vstPALmUdtZ+xDkEPIXj//VC6B9iKRX
	Toku4ZPOeWDJk+K1h4HVvq4b9nKVq5xccuuGUPJWihDTZFlzyxrhmLlg/oKopkBaNAfgxb3OtRFAj
	Q6nTfuPguJBhb9yb76hyCZp4RlP1sEKbd7qncKJLDkS9/rESuTdtopRrS9X9xODpWNuRiScuBRaAL
	Ceujdtyw==;
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1uA3TN-0006Ay-Bx; Wed, 30 Apr 2025 11:11:21 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1uA3TH-00CDEV-HR; Wed, 30 Apr 2025 11:11:15 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 30 Apr 2025 11:10:28 +0200
Subject: [PATCH net-next v3 2/4] vsock/virtio: Reduce indentation in
 virtio_transport_wait_close()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250430-vsock-linger-v3-2-ddbe73b53457@rbox.co>
References: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
In-Reply-To: <20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 Michal Luczaj <mhal@rbox.co>
X-Mailer: b4 0.14.2

Flatten the function. Remove the nested block by inverting the condition:
return early on !timeout.

No functional change intended.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 net/vmw_vsock/virtio_transport_common.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 49c6617b467195ba385cc3db86caa4321b422d7a..4425802c5d718f65aaea425ea35886ad64e2fe6e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1194,23 +1194,23 @@ static void virtio_transport_remove_sock(struct vsock_sock *vsk)
 
 static void virtio_transport_wait_close(struct sock *sk, long timeout)
 {
-	if (timeout) {
-		DEFINE_WAIT_FUNC(wait, woken_wake_function);
-		ssize_t (*unsent)(struct vsock_sock *vsk);
-		struct vsock_sock *vsk = vsock_sk(sk);
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	ssize_t (*unsent)(struct vsock_sock *vsk);
+	struct vsock_sock *vsk = vsock_sk(sk);
 
-		unsent = vsk->transport->unsent_bytes;
+	if (!timeout)
+		return;
 
-		add_wait_queue(sk_sleep(sk), &wait);
+	unsent = vsk->transport->unsent_bytes;
 
-		do {
-			if (sk_wait_event(sk, &timeout, unsent(vsk) == 0,
-					  &wait))
-				break;
-		} while (!signal_pending(current) && timeout);
+	add_wait_queue(sk_sleep(sk), &wait);
 
-		remove_wait_queue(sk_sleep(sk), &wait);
-	}
+	do {
+		if (sk_wait_event(sk, &timeout, unsent(vsk) == 0, &wait))
+			break;
+	} while (!signal_pending(current) && timeout);
+
+	remove_wait_queue(sk_sleep(sk), &wait);
 }
 
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,

-- 
2.49.0


