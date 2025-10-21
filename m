Return-Path: <kvm+bounces-60759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9BDBBF94AB
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6296558462C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2622BE036;
	Tue, 21 Oct 2025 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bADi7B/p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B3A23D7DE
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 23:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761090423; cv=none; b=uT/hffAm81uv6d+ZitPoODV8xfmOHdiuYqw5/jfnAAeZbE5m+WBgVpRzyG6hHdnrvWbumDvhUw/VTTFQCDoAln1nm0fYB14qDvGmFjUir0aVJz9YhglUFdpjuMqGTUVoBQ55gmPoiLDttcLvvyk++swO3mK2xTsjmMLUFDAgJ6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761090423; c=relaxed/simple;
	bh=i/0blcvw30L2XmsZDP8JwezkIYQz0CtWUOjE1zydzXY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u54hqmiVXwaalFjQXdwoEo2mck0lSKltPp1CcGDXznDBlSNcQgVZ2wWyY/g7WCWZOdEjJGbU0Lr/0I57i66f7y3iT6ItNzkvivPKFss24kuEkfLhVaYNhAAbCt4B9T4GWYvUGgh6jVQwCZZPz8qKPktGeFhWz2Z6j0SksN3qz3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bADi7B/p; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b6cdcc280c3so232707a12.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 16:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761090420; x=1761695220; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ux00ENqxNtzazJRP0kNIFZEFFfqT/sB9ciqM1XMIy8Y=;
        b=bADi7B/pZVDCE7VQv7lugnzQ18wRMEqm0V+SsIVNvoOsEejkuOFcmucO70NUMdlrRn
         nDgIfYNZFKZpatd2u9Ouia5gQcwNGRFmEg+bTsP+4w5feLim+Bj8M5wP1FHn6cjbhGqj
         IZeB8umpj4ftY9zphnMT5lDd5Dv8NP8ePlgItJgbl8NvdtI8GbT1A8PicdvliKK9dBkZ
         ZzJ33tn28IB63lB35dsp6/9vnTxSg3zAC8vCxCg8lfa0MlVsmXgR8pPI6Yw7Tcpegb/J
         VUs6rzSPXDRveYIJ2t8enX41n3ysSdp7tQMviUFFnrHbwM14mZCDSuzwgkvodgByLUvy
         vz5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761090420; x=1761695220;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ux00ENqxNtzazJRP0kNIFZEFFfqT/sB9ciqM1XMIy8Y=;
        b=qwbXoOOTZY5ovOSMZXBvlFFM9qsQ3g+kGMcdcmnd4b5St06Zos4hbEwhLvlFJqb4w9
         Wy8Bxk9a3nGex2wc6welU9PddD4Z9dNvmym84QIIktl7PHvdZrJMk5PcN1ZJRyNL04D0
         yWqKpex6I4jkagaUSSFXXDzXTqSRp2VzP7SL6MOYyuXLQE4nU97FKAq43bO8QqjM/+or
         Goci9yNjkzqeTyK80vVpU1EAfKueTE8RJdgt148vpbQHwtKo44EMvqrLLSNG6EJWvkBw
         EaLnzO4fDqOgv6FDff9Mr52wvMsXsEeyOSyY4n09iELos0XZFHjDvarkaKIX1Qp/UmS1
         Q/uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUE87NKjleFSwwtTNVyLsIe/dH/go7NYpB3ieAT98KoXkqNp8m2MPCbHNirelbBRiakTHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM1Dly80FBLuT2eK5KAtxEtjqvG46lsWCTCNXg97zMy6fpeyBw
	QnBZn2hT6VSHHp6DS8Rszr4u3hvK+n1G4FfWQ1rDzWe8wFl+ChovtCZa
X-Gm-Gg: ASbGncu0VRZGGYvP0V7DvEB546hT1mXhgwQD4S/uwDDxS9g8nL+GWGZy1s/qzcROrzZ
	pJfDpyTmMv1iSpWjQkFBm5bM9kZ0nK+3tJHAPkfRc9KhyV8dhH/zmxNEActwWU7cyuHyCEj4TH/
	WkjgVx4ASbbObCyzFGJeDfgkpr9gEhNlnab1sXPWQ0r7WO3Y7NmpRdZLlGEKB+F/HLxplIUgO92
	X+nqDrb6oPtYhTYUNlc2X2pSWEA91eTzAEEYZZ21xrIZtUszqlbUkZeH+tLzHbCeqewLxt/0MJv
	ywt6qi81qDcr0hCR0ZTUzVfCz/hDbQ3bL5d4030xhx14GAYCzsq3fnjxaYWcbLrqLhgCnG4eaTh
	6SmVePrSS0d3gURyBkX1r7vlqZ63Jsff2ozNZgKCbcj/hiwqWjmZUXmobmsrJ4mAU5Vd6vhaY
X-Google-Smtp-Source: AGHT+IHeGId/ywDSD1+B3HjeV1Dv8DYhirb7ZJAGBaWWTqw55VcAYUuGBf/b9fQl2uNxLFwxdMYmNQ==
X-Received: by 2002:a17:903:2445:b0:25c:25f1:542d with SMTP id d9443c01a7336-290ca1219e1mr253823315ad.36.1761090419637;
        Tue, 21 Oct 2025 16:46:59 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471fd9e8sm120714105ad.85.2025.10.21.16.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 16:46:59 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 21 Oct 2025 16:46:44 -0700
Subject: [PATCH net-next v7 01/26] vsock: a per-net vsock NS mode state
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251021-vsock-vmtest-v7-1-0661b7b6f081@meta.com>
References: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
In-Reply-To: <20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com>
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
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add the per-net vsock NS mode state. This only adds the structure for
holding the mode and some of the functions for setting/getting and
checking the mode, but does not integrate the functionality yet.

A "net_mode" field is added to vsock_sock to store the mode of the
namespace when the vsock_sock was created. In order to evaluate
namespace mode rules we need to know both a) which namespace the
endpoints are in, and b) what mode that namespace had when the endpoints
were created. This allows us to handle the changing of modes from global
to local *after* a socket has been created by remembering that the mode
was global when the socket was created. If we were to use the current
net's mode instead, then the lookup would fail and the socket would
break.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v7:
- clarify vsock_net_check_mode() comments
- change to `orig_net_mode == VSOCK_NET_MODE_GLOBAL && orig_net_mode == vsk->orig_net_mode`
- remove extraneous explanation of `orig_net_mode`
- rename `written` to `mode_locked`
- rename `vsock_hdr` to `sysctl_hdr`
- change `orig_net_mode` to `net_mode`
- make vsock_net_check_mode() more generic by taking just net pointers
  and modes, instead of a vsock_sock ptr, for reuse by transports
  (e.g., vhost_vsock)

Changes in v6:
- add orig_net_mode to store mode at creation time which will be used to
  avoid breakage when namespace changes mode during socket/VM lifespan

Changes in v5:
- use /proc/sys/net/vsock/ns_mode instead of /proc/net/vsock_ns_mode
- change from net->vsock.ns_mode to net->vsock.mode
- change vsock_net_set_mode() to vsock_net_write_mode()
- vsock_net_write_mode() returns bool for write success to avoid
  need to use vsock_net_mode_can_set()
- remove vsock_net_mode_can_set()
---
 MAINTAINERS                 |  1 +
 include/net/af_vsock.h      | 64 +++++++++++++++++++++++++++++++++++++++++++++
 include/net/net_namespace.h |  4 +++
 include/net/netns/vsock.h   | 20 ++++++++++++++
 4 files changed, 89 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4faa7719bf86..c58f9e38898a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27062,6 +27062,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/vhost/vsock.c
 F:	include/linux/virtio_vsock.h
+F:	include/net/netns/vsock.h
 F:	include/uapi/linux/virtio_vsock.h
 F:	net/vmw_vsock/virtio_transport.c
 F:	net/vmw_vsock/virtio_transport_common.c
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index d40e978126e3..a1053d3668cf 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -10,6 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
+#include <net/netns/vsock.h>
 #include <net/sock.h>
 #include <uapi/linux/vm_sockets.h>
 
@@ -65,6 +66,7 @@ struct vsock_sock {
 	u32 peer_shutdown;
 	bool sent_request;
 	bool ignore_connecting_rst;
+	enum vsock_net_mode net_mode;
 
 	/* Protected by lock_sock(sk) */
 	u64 buffer_size;
@@ -256,4 +258,66 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
 {
 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
 }
+
+static inline enum vsock_net_mode vsock_net_mode(struct net *net)
+{
+	enum vsock_net_mode ret;
+
+	spin_lock_bh(&net->vsock.lock);
+	ret = net->vsock.mode;
+	spin_unlock_bh(&net->vsock.lock);
+	return ret;
+}
+
+static inline bool vsock_net_write_mode(struct net *net, u8 mode)
+{
+	bool ret;
+
+	spin_lock_bh(&net->vsock.lock);
+
+	if (net->vsock.mode_locked) {
+		ret = false;
+		goto skip;
+	}
+
+	net->vsock.mode = mode;
+	net->vsock.mode_locked = true;
+	ret = true;
+
+skip:
+	spin_unlock_bh(&net->vsock.lock);
+	return ret;
+}
+
+/* Return true if two namespaces and modes pass the mode rules. Otherwise,
+ * return false.
+ *
+ * ns0 and ns1 are the namespaces being checked.
+ * mode0 and mode1 are the vsock namespace modes of ns0 and ns1.
+ *
+ * Read more about modes in the comment header of net/vmw_vsock/af_vsock.c.
+ */
+static inline bool vsock_net_check_mode(struct net *ns0, enum vsock_net_mode mode0,
+					struct net *ns1, enum vsock_net_mode mode1)
+{
+	/* Any vsocks within the same network namespace are always reachable,
+	 * regardless of the mode.
+	 */
+	if (net_eq(ns0, ns1))
+		return true;
+
+	/*
+	 * If the network namespaces differ, vsocks are only reachable if both
+	 * were created in VSOCK_NET_MODE_GLOBAL mode.
+	 *
+	 * The vsock namespace mode is write-once, and the default is
+	 * VSOCK_NET_MODE_GLOBAL. Once set to VSOCK_NET_MODE_LOCAL, it cannot
+	 * revert to GLOBAL. It is not possible to have a case where a socket
+	 * was created in LOCAL mode, and then the mode switched to GLOBAL.
+	 *
+	 * As a result, we only need to check if the modes were global at
+	 * creation time.
+	 */
+	return mode0 == VSOCK_NET_MODE_GLOBAL && mode0 == mode1;
+}
 #endif /* __AF_VSOCK_H__ */
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index cb664f6e3558..66d3de1d935f 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -37,6 +37,7 @@
 #include <net/netns/smc.h>
 #include <net/netns/bpf.h>
 #include <net/netns/mctp.h>
+#include <net/netns/vsock.h>
 #include <net/net_trackers.h>
 #include <linux/ns_common.h>
 #include <linux/idr.h>
@@ -196,6 +197,9 @@ struct net {
 	/* Move to a better place when the config guard is removed. */
 	struct mutex		rtnl_mutex;
 #endif
+#if IS_ENABLED(CONFIG_VSOCKETS)
+	struct netns_vsock	vsock;
+#endif
 } __randomize_layout;
 
 #include <linux/seq_file_net.h>
diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
new file mode 100644
index 000000000000..c9a438ad52f2
--- /dev/null
+++ b/include/net/netns/vsock.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_NET_NAMESPACE_VSOCK_H
+#define __NET_NET_NAMESPACE_VSOCK_H
+
+#include <linux/types.h>
+
+enum vsock_net_mode {
+	VSOCK_NET_MODE_GLOBAL,
+	VSOCK_NET_MODE_LOCAL,
+};
+
+struct netns_vsock {
+	struct ctl_table_header *sysctl_hdr;
+	spinlock_t lock;
+
+	/* protected by lock */
+	enum vsock_net_mode mode;
+	bool mode_locked;
+};
+#endif /* __NET_NET_NAMESPACE_VSOCK_H */

-- 
2.47.3


