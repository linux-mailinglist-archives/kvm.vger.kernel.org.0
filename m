Return-Path: <kvm+bounces-17615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 736C78C885C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A9DC2892BE
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500726FE21;
	Fri, 17 May 2024 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEQQYZWC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA8C6E613;
	Fri, 17 May 2024 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957193; cv=none; b=rSEtJG94B4L17lfmCu665CVYkk6f0GmbrwRaBotyLM4LrbhchGYeQZPyUKlRZR3Q0TPLoYuI8PtDidUKQz6bmdwnEKzEm48eIhwelzpFgPI2RQln68aKUEPn6f+pGfKQMvqIa34EN+Y64lLqnb9f5NJnMOCK1KgntE1MMI34ha0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957193; c=relaxed/simple;
	bh=q3sDsBUcUDme/MtiN7St5f8cv1EJMwhSScadewV7zew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mVxLpbrmwawFD16ZL+wIrzpsU0uU23h4yhu2jCsPIiVLN8fnQd+YM7NRzqfVc02xnZ1Rsej/fAe4tLS79qmo5cm4G7AaONKgFDJvbeF1pN3tOtRxOyANWO4UQIy1YoqPDbwSKNsRyMzoKmQ5kJ3kFB/7LhK14cqSVrGL2Eh8Ljc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEQQYZWC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e651a9f3ffso10221635ad.1;
        Fri, 17 May 2024 07:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715957191; x=1716561991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJq2b9RGdc8kjbmcDqovAimStl9IOIGQIeg0f2YK8Ws=;
        b=QEQQYZWChPlrWoUlTcI2bWFY4hFLou1WlOtVtR5LDM0WO5NBkYDa2CnUtztjtqTsP9
         ny09gOGm7VoAebnSM89IaOnBLQYym5O5msTWKB9LXfkminhl1UxRpmni8HngQF+9zH8D
         +WWuBNbLlpzfmzHiza1M3ol0N5pyBAkVgIuVSWxM9P6DWcWOMszj+b142JsbhYTDOzTd
         3lb1KH2zaaMktZjhJVCVVP8YOrucqzfly/X5JhISbcQpbc1TiPLvnVCdlDxExA/ZgPOm
         QlXBsd1jOtfXAkcVq8DUnm+ykoZb+EPsny1mjwBCVpbSbf2PDTXLIioeWVUaR3jT1aPL
         F6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957191; x=1716561991;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hJq2b9RGdc8kjbmcDqovAimStl9IOIGQIeg0f2YK8Ws=;
        b=aAfkwaUDldwstwTEjSozbU6/XsApRoyJxCd7CKgMbhLfffjTagGKCsgW9TGUxb0p7o
         zfuRRKOP8svu29GbyfXmgCE/PTYl3LrnNBoN4EKKewH4orL+ByLQh15XmBsV+lauqcCH
         b1GuF0/CQvRO4uI3fOrb/f+cYlf+qrxWW7DGrE7CNzNi4WmUD9rhONsFIUWCtivztFYg
         vhLmgMISKOaUGJ20jfSQJ2qskDP2Vgrdq+KD435vtWE1reYpN6HywOwno49vKpZ+uOJz
         Tq4Il1KatQ5o9g9B1lblfnNVG2GQdzdeuJT50ysdYSO9OyY/LXSihAge545FhcXBhQZa
         tDTA==
X-Forwarded-Encrypted: i=1; AJvYcCXzBH5jIW/gcbIGiaLglKAq/7GSx6+THTd4bWwEFSbKFFDO0BuDBsqS1mEtc79ZfiaMGVFzkiE4a+UVfEsFYrczGd8m7j6p3Ir45a815170w64/kQW31l/6cK8UIhpjYTuJaJRODAX/Sc+xCbL/QPpE3xHApglzTL+D
X-Gm-Message-State: AOJu0YwEMHAakpk+7GLAmQXchIYT5x91TgAMLO1/j2rMeVhzngZGY2cd
	AN8UIFSgrMCzn7As8cl4/KOr+e40wmYJ1P1KTxfrgdltdUgUsJDb
X-Google-Smtp-Source: AGHT+IHL2uRGyT1nIYq0kpvkRlAo7ap2G40vKTgf52EWRitQ6LcfBBTk+NlOH/B34nRbz+e6iAEM4g==
X-Received: by 2002:a17:902:d506:b0:1e4:24cc:e021 with SMTP id d9443c01a7336-1ef44050595mr282515655ad.50.1715957191409;
        Fri, 17 May 2024 07:46:31 -0700 (PDT)
Received: from devant.hz.ali.com ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c160a1esm158504985ad.279.2024.05.17.07.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:46:30 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: mst@redhat.com,
	davem@davemloft.net,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RFC PATCH 4/5] vsock: seqpacket_allow adapts to multi-devices
Date: Fri, 17 May 2024 22:46:06 +0800
Message-Id: <20240517144607.2595798-5-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds a new argument, named "src_cid", to let them know which `virtio_vsock`
to be selected.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 include/net/af_vsock.h           |  2 +-
 net/vmw_vsock/af_vsock.c         | 15 +++++++++++++--
 net/vmw_vsock/virtio_transport.c |  4 ++--
 net/vmw_vsock/vsock_loopback.c   |  4 ++--
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 0151296a0bc5..25f7dc3d602d 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -143,7 +143,7 @@ struct vsock_transport {
 				     int flags);
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
-	bool (*seqpacket_allow)(u32 remote_cid);
+	bool (*seqpacket_allow)(u32 src_cid, u32 remote_cid);
 	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
 
 	/* Notification. */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index da06ddc940cd..3b34be802bf2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -470,10 +470,12 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
 	const struct vsock_transport *new_transport;
 	struct sock *sk = sk_vsock(vsk);
-	unsigned int remote_cid = vsk->remote_addr.svm_cid;
+	unsigned int src_cid, remote_cid;
 	__u8 remote_flags;
 	int ret;
 
+	remote_cid = vsk->remote_addr.svm_cid;
+
 	/* If the packet is coming with the source and destination CIDs higher
 	 * than VMADDR_CID_HOST, then a vsock channel where all the packets are
 	 * forwarded to the host should be established. Then the host will
@@ -527,8 +529,17 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		return -ENODEV;
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
+		if (vsk->local_addr.svm_cid == VMADDR_CID_ANY) {
+			if (new_transport->get_default_cid)
+				src_cid = new_transport->get_default_cid();
+			else
+				src_cid = new_transport->get_local_cid();
+		} else {
+			src_cid = vsk->local_addr.svm_cid;
+		}
+
 		if (!new_transport->seqpacket_allow ||
-		    !new_transport->seqpacket_allow(remote_cid)) {
+		    !new_transport->seqpacket_allow(src_cid, remote_cid)) {
 			module_put(new_transport->module);
 			return -ESOCKTNOSUPPORT;
 		}
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 998b22e5ce36..0bddcbd906a2 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -615,14 +615,14 @@ static struct virtio_transport virtio_transport = {
 	.can_msgzerocopy = virtio_transport_can_msgzerocopy,
 };
 
-static bool virtio_transport_seqpacket_allow(u32 remote_cid)
+static bool virtio_transport_seqpacket_allow(u32 src_cid, u32 remote_cid)
 {
 	struct virtio_vsock *vsock;
 	bool seqpacket_allow;
 
 	seqpacket_allow = false;
 	rcu_read_lock();
-	vsock = rcu_dereference(the_virtio_vsock);
+	vsock = virtio_transport_get_virtio_vsock(src_cid);
 	if (vsock)
 		seqpacket_allow = vsock->seqpacket_allow;
 	rcu_read_unlock();
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 6dea6119f5b2..b94358f5bb2c 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -46,7 +46,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 	return 0;
 }
 
-static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
+static bool vsock_loopback_seqpacket_allow(u32 src_cid, u32 remote_cid);
 static bool vsock_loopback_msgzerocopy_allow(void)
 {
 	return true;
@@ -104,7 +104,7 @@ static struct virtio_transport loopback_transport = {
 	.send_pkt = vsock_loopback_send_pkt,
 };
 
-static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
+static bool vsock_loopback_seqpacket_allow(u32 src_cid, u32 remote_cid)
 {
 	return true;
 }
-- 
2.34.1


