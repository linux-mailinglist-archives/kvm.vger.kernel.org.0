Return-Path: <kvm+bounces-62853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 922C2C50D4E
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:02:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2619C4F6EB3
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A775C2F8BD9;
	Wed, 12 Nov 2025 06:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgN7gmBa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61E2E336F
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930548; cv=none; b=uqvHmcU7/A/NVwkm6MCMaML85ISHdXM6HvbhpVwmwOLTwDzR3o4MVskoZIn0E/8p3TtEs67Ljl5E/muInVt1eZlQUSj32dgPzTBZP8Ym3MVZsZ/aYaCpKyMYNLYQRy+MxnuTafhCcpls3ng8uL4XVo4rZTMCWP9WAl+xHWEEhTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930548; c=relaxed/simple;
	bh=fzE8vjOCqgEdVLGviLFQQ/if3C/Y0MI6EzENTGjvUpY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ty0bSviALbSoSgbsIhhAHTa1PwCl5DMnENcs+0x3/7Uni014tpt/eejickLBvWJ0W5CvX2EXMpHYzBxj+s/pjOQZ5C4acGKg+NAOR7RZUv80PeGRfitxKcp+MVQ3CUOFQB6SW55YFq5Pz3i6Ept8Xslg9101/cFfaMNzPyt21aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PgN7gmBa; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7a9fb6fccabso412732b3a.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762930542; x=1763535342; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sY1ws7TASlscml7aUd7HPBk1tWYzYKHf5oRjRrX7GME=;
        b=PgN7gmBat53yEhTjAiEfdNg+5fPLaF+VqvZ8gNmAG8KflpO3BQ7kMIyJAnM03tSezg
         LDwCjOoPbttBkB4GDyvcbZR3YktB50qRwBGGqYC5hu8PitPGJMeqM+VE8eL8Hd3Fp81z
         4S0N9TNwVyaxdljTtvyFlmaEOywEhxFo8SQJ9/clMPbZ/8GNqw7qWkKoH8Zdp04lkinP
         13Y6q7+GvkNArUpY0fzEMEgPviYc8XzAoUcRHZDPOayy6plaUHjOrzX1V0UGwNyMO0vx
         3Ck8nmyHLBYFtFMzAdOLi6B7xiyFD3RxiYAYosfL9yPsVpYUwLn+aMpBsodp+2ZbSKS2
         nUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930542; x=1763535342;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sY1ws7TASlscml7aUd7HPBk1tWYzYKHf5oRjRrX7GME=;
        b=DIJRdz0QxHTCEr33Kect3y/4R7VJt5vVFJizknGH4e+cK7z6Kx6r2eTYBdb02gacuu
         TivPpKPz+CmhzVxXNluHCCRtLSs8OqO2JLeUuZlDzll9k/3DsUjiHO5W8AafxzsdQ2vn
         UJWM2a/tWYEcLyzQ0SPU+hqURUKx0uY+CL8ushCbrxTF4gPlwrGI5WxauZUlx9k2C9z/
         8SbBs/RHQn10uT8sbedsIjUJ0qP3i2NNulgNEyj6TdpM/mw15xocFLp9uf31SYnGnnPI
         spODmANXdnSpPbQkd4C85k2ehYWyeze2+VOynQHktF2pu2kHdtsCi3krskxzCErNI8vb
         opSw==
X-Forwarded-Encrypted: i=1; AJvYcCXHY6Y5Z1lu/WqmzdsHVaOdh7DXs+R/9oMKMPnlWHU/k31c1CToNV/9Q0RB5hPX7CA4uzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLMuL5IyHA+2Qumw7Yr3+RvxKXK9A/AD9QKRuZcUubQ2czXAAX
	e1WviVFioFBA/oNH9562hTCpzXqZxOFlISJcPmgDR1FKJbmYxbzvM/cZ
X-Gm-Gg: ASbGnctXQtr/MEFJW+BnA1mw34QmpcRGUttF9S8kea4G4oqJriDmlnzlBKEQnvcUYKX
	nxsIkp6HSqmof9LA6CnBRl4VShGHzU/D06/l7Qykuf3aUDLdOlkHXUlMc3AJ468VjhGHbg9/ev2
	aYVQavV/TzEvLNnc+SKb///nRf2lwPtKsRMRf/NTLBepSfMruFl1oVpumJNgDU9o5odMLy6WtHu
	s2mIZeLFw4gh9kEMZQtwXyLX+X1MTK2jC9lWVzLgkJZhkdGJ/gm4JMVHt3HkI+q993GYir6pkPc
	50Jvv08nVrI+iaSQeThdXxdMpNhzU6+D5x+TpzT3ayMlc0Yqzv3i0Sy33PhySo9nooHtK4pDGk0
	CP30WhDxDQLQXB7PIVg4ym6/h/9dOKRvUDIBshocbDuTQKl+yEF7+D+/ZwKM5BF6rcez0eMBjvQ
	==
X-Google-Smtp-Source: AGHT+IELhzgnizTiqKz1cTk9BoLnvpdIuZr/u1AmUOgJ4ajaUaegLKsYPXo9c/uRPcWaVRaXIBlchQ==
X-Received: by 2002:a05:6a00:4f85:b0:7ab:2896:bfb with SMTP id d2e1a72fcca58-7b7a2d8f209mr2120012b3a.13.1762930542332;
        Tue, 11 Nov 2025 22:55:42 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:72::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccd4edc3sm17522079b3a.66.2025.11.11.22.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:42 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 11 Nov 2025 22:54:50 -0800
Subject: [PATCH net-next v9 08/14] vsock: reject bad VSOCK_NET_MODE_LOCAL
 configuration for G2H
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vsock-vmtest-v9-8-852787a37bed@meta.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
In-Reply-To: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Reject setting VSOCK_NET_MODE_LOCAL with -EOPNOTSUPP if a G2H transport
is operational. Additionally, reject G2H transport registration if there
already exists a namespace in local mode.

G2H sockets break in local mode because the G2H transports don't support
namespacing yet. The current approach is to coerce packets coming out of
G2H transports into VSOCK_NET_MODE_GLOBAL mode, but it is not possible
to coerce sockets in the same way because it cannot be deduced which
transport will be used by the socket. Specifically, when bound to
VMADDR_CID_ANY in a nested VM (both G2H and H2G available), it is not
until a packet is received and matched to the bound socket that we
assign the transport. This presents a chicken-and-egg problem, because
we need the namespace to lookup the socket and resolve the transport,
but we need the transport to know how to use the namespace during
lookup.

For that reason, this patch prevents VSOCK_NET_MODE_LOCAL from being
used on systems that support G2H, even nested systems that also have H2G
transports.

Local mode is blocked based on detecting the presence of G2H devices
(when possible, as hyperv is special). This means that a host kernel
with G2H support compiled in (or has the module loaded), will still
support local mode because there is no G2H (e.g., virtio-vsock) device
detected. This enables using the same kernel in the host and in the
guest, as we do in kselftest.

Systems with only namespace-aware transports (vhost-vsock, loopback) can
still use both VSOCK_NET_MODE_GLOBAL and VSOCK_NET_MODE_LOCAL modes as
intended.

The hyperv transport must be treated specially. Other G2H transports can
can report presence of a device using get_local_cid(). When a device is
present it returns a valid CID; otherwise, it returns VMADDR_CID_ANY.
THe hyperv transport's get_local_cid() always returns VMADDR_CID_ANY,
however, even when a device is present.

For that reason, this patch adds an always_block_local_mode flag to
struct vsock_transport. When set to true, VSOCK_NET_MODE_LOCAL is
blocked unconditionally whenever the transport is registered, regardless
of device presence. When false, LOCAL mode is only blocked when
get_local_cid() indicates a device is present (!= VMADDR_CID_ANY).

The hyperv transport sets this flag to true to unconditionally block
local mode. Other G2H transports (virtio-vsock, vmci-vsock) leave it
false and continue using device detection via get_local_cid() to block
local mode.

These restrictions can be lifted in a future patch series when G2H
transports gain namespace support.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 include/net/af_vsock.h           |  8 +++++++
 net/vmw_vsock/af_vsock.c         | 45 +++++++++++++++++++++++++++++++++++++---
 net/vmw_vsock/hyperv_transport.c |  1 +
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index cfd121bb5ab7..089c61105dda 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -108,6 +108,14 @@ struct vsock_transport_send_notify_data {
 
 struct vsock_transport {
 	struct module *module;
+	/* If true, block VSOCK_NET_MODE_LOCAL unconditionally when this G2H
+	 * transport is registered. If false, only block LOCAL mode when
+	 * get_local_cid() indicates a device is present (!= VMADDR_CID_ANY).
+	 * Hyperv sets this true because it doesn't offer a callback that
+	 * detects device presence. This only applies to G2H transports; H2G
+	 * transports are unaffected.
+	 */
+	bool always_block_local_mode;
 
 	/* Initialize/tear-down socket. */
 	int (*init)(struct vsock_sock *, struct vsock_sock *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c0b5946bdc95..a2da1810b802 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -91,6 +91,11 @@
  *   and locked down by a namespace manager. The default is "global". The mode
  *   is set per-namespace.
  *
+ *   Note: LOCAL mode is only supported when using namespace-aware transports
+ *   (vhost-vsock, loopback). If a guest-to-host transport (virtio-vsock,
+ *   hyperv-vsock, vmci-vsock) is loaded, attempts to set LOCAL mode will fail
+ *   with EOPNOTSUPP, as these transports do not support per-namespace isolation.
+ *
  *   The modes affect the allocation and accessibility of CIDs as follows:
  *
  *   - global - access and allocation are all system-wide
@@ -2757,12 +2762,30 @@ static int vsock_net_mode_string(const struct ctl_table *table, int write,
 		if (*lenp >= sizeof(data))
 			return -EINVAL;
 
-		if (!strncmp(data, VSOCK_NET_MODE_STR_GLOBAL, sizeof(data)))
+		if (!strncmp(data, VSOCK_NET_MODE_STR_GLOBAL, sizeof(data))) {
 			mode = VSOCK_NET_MODE_GLOBAL;
-		else if (!strncmp(data, VSOCK_NET_MODE_STR_LOCAL, sizeof(data)))
+		} else if (!strncmp(data, VSOCK_NET_MODE_STR_LOCAL, sizeof(data))) {
+			/* LOCAL mode is not supported when G2H transports
+			 * (virtio-vsock, hyperv, vmci) are active, because
+			 * these transports don't support namespaces. We must
+			 * stay in GLOBAL mode to avoid bind/lookup mismatches.
+			 *
+			 * Check if G2H transport is present and either:
+			 * 1. Has always_block_local_mode set (hyperv), OR
+			 * 2. Has an actual device present (get_local_cid() != VMADDR_CID_ANY)
+			 */
+			mutex_lock(&vsock_register_mutex);
+			if (transport_g2h &&
+			    (transport_g2h->always_block_local_mode ||
+			     transport_g2h->get_local_cid() != VMADDR_CID_ANY)) {
+				mutex_unlock(&vsock_register_mutex);
+				return -EOPNOTSUPP;
+			}
+			mutex_unlock(&vsock_register_mutex);
 			mode = VSOCK_NET_MODE_LOCAL;
-		else
+		} else {
 			return -EINVAL;
+		}
 
 		if (!vsock_net_write_mode(net, mode))
 			return -EPERM;
@@ -2909,6 +2932,7 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 {
 	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
 	int err = mutex_lock_interruptible(&vsock_register_mutex);
+	struct net *net;
 
 	if (err)
 		return err;
@@ -2931,6 +2955,21 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 			err = -EBUSY;
 			goto err_busy;
 		}
+
+		/* G2H sockets break in LOCAL mode namespaces because G2H transports
+		 * don't support them yet. Block registering new G2H transports if we
+		 * already have local mode namespaces on the system.
+		 */
+		rcu_read_lock();
+		for_each_net_rcu(net) {
+			if (vsock_net_mode(net) == VSOCK_NET_MODE_LOCAL) {
+				rcu_read_unlock();
+				err = -EOPNOTSUPP;
+				goto err_busy;
+			}
+		}
+		rcu_read_unlock();
+
 		t_g2h = t;
 	}
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 432fcbbd14d4..ed48dd1ff19b 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -835,6 +835,7 @@ int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
 
 static struct vsock_transport hvs_transport = {
 	.module                   = THIS_MODULE,
+	.always_block_local_mode  = true,
 
 	.get_local_cid            = hvs_get_local_cid,
 

-- 
2.47.3


