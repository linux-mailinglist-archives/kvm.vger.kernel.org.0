Return-Path: <kvm+bounces-64055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 683DAC77698
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:45:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id BCB0D2C972
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2012F83C0;
	Fri, 21 Nov 2025 05:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gqv3HKsk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D162F2900
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703895; cv=none; b=cXqzmppM3oPx0R0zeim0e3goYeHghsomG7ChwlNkVj3had4sA+giyYtU5mwdVmKBLFhaWP2/kUF/JETIa+95bHYhSpghWQvIag3/WDGlunVnOK8UsRWXwhWd6PkDM1i2oJxfIxpgnSkZdNEuDgsgWMJHDR0bk9ZiJGHrtogSHrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703895; c=relaxed/simple;
	bh=26Ucrht91aAIwIXyn98Z2G6zb0Uqo0wULoQ9rseWbpU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VrHQ59jyeSOKUdxOhAieQKl2m5ba9D1on3xsDfSNPMU+shyX0Vcb9BUJNO4PAllcelvfVPuh74yKzOAifMjNGQg3jG6OJpUbqhE3DoJ9H9PazqASDLPaiKeFHTyiXD8OxQhJ5ARIDeL5bnkm4/XYps2RsO1RweL4Qa9p4YURJ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gqv3HKsk; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-299d40b0845so26504415ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 21:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763703891; x=1764308691; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rD2STQ1vCewvqhwa6nIY2y5ruJr4z91nYVEqL9bn/Qk=;
        b=gqv3HKskU/+y+owSy0N+Hl/+uFi0kqaRvA4Y66iVrdcTX77kheoF2gxjxknbwmP/Jw
         3FG94ymCJvVJSwN+TAdstMhq0brq4pDFK2yB1RUWZwOuKrkQjtoXkMJTRH4zwCOCwXPN
         ooyaBZjX6fVanjyjDioFPqDb9v/SFsXR4ChdOV8OY5boIWVpoq+3mtnNoqW+tikaMZko
         xtPzpJS54ekUsg3jz7v5CcqQIKIjBx48PR24O6p7Wa/LdCPAEeILDfrmSLmmZHs2gWhP
         5qsSMl3Z5dO/a56JVFVIiCMqtr00czJISKFDX0k/AWkVJleXf1AF9npIbLvKT3a7bU3c
         2bqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763703891; x=1764308691;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rD2STQ1vCewvqhwa6nIY2y5ruJr4z91nYVEqL9bn/Qk=;
        b=W0Ql0gSftxxcfbF2Px/7z30BdvfJC9UMyKwX/dN/274g9i4jnG1gpGcgNfF9oTRr5J
         GNtKnWY78m7Jnzq0BA+TnI97nnurJBc2pB78bG2i3mfLkSBqFITvRbm57bDrxkC/0ZQU
         Syhnx0L+UzsvCPwgRyakaUwkm5QT042PDxbtNBE/9bCsoIHzy4iQ/PA2JKM93pVjkpJd
         l6vVYxRNwpdysGhiuAJ6Ijwix2WNO6Vkzt8/ip8YTHO81Mo89fIEICgYHCp8uhkPO9AX
         y+Jg4OnDEIk2pFA4FEu3u5UhcgzzmYhbwad7rPR47aEPi0QS3t/ZAu3C+9Xo5QWeU/db
         5JZw==
X-Forwarded-Encrypted: i=1; AJvYcCU0+4lPlHn+5dcxL1RieuVHO/rJAYWj240p6zAuzqc7QyizrWutqO37QomaQGdQI9Uuiso=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+T2zAaMwstNM+NaAAh3DB8u3HeztIw4afN7AzIzjcNJ8nN5r5
	7l5aC+XxPiD5t1CLsDKaHEr6kMOSknCBAScDUQGAC3LjhH2MIbfIhLoI
X-Gm-Gg: ASbGncu6qxotJH+zL39KxrGML0mwdyEbhpdN66wNiEZ27L6Q3yNrRsoMDvkp/QtbQX8
	lmCGVwEoEznjlotmNrGQqC0f+oqXDLsKe6B+j5NnYsAAfTnyFh96x7WLZM8azt1kW/ty9c3vGW3
	/mb1EJgiv6DPrD7Drs6Nt+J5i2rN5TVZu7oY0rbd3cNQeh9Dau+MGSE7fmya0bW+eO6UpGGn/49
	PpX7b1LmEVqakQYtLvN0wKNQlp0n1TfIyxfzS7+Yd6nNtgOVuEIPvaIP+iqoPXdv9VXcH3bLm+w
	0n4+KyGstaDX09sQgr8su43JumO17/iSUKM4IZSzbZd88IX5hgvn4ym7j/z5NFQXuHDuhIA2lrr
	hh1rl1Fxoy2ouuZT3DtQmRdE9FgLMZOv8I4oeuWVdRiEow6RUDJ0ymvj02ABmzJpjZ2iEB5gp2K
	6oaz40P+XQ60mcUN73YBZehfEGy1FXqA==
X-Google-Smtp-Source: AGHT+IGBX6lBycTr5y8I7/Ff3OgYb9C5r3Lt5Iu6ZJFwCB5+wDgrL2QmZGU72lmD28DyGWR9DkSOnQ==
X-Received: by 2002:a17:903:3843:b0:298:8ec:9991 with SMTP id d9443c01a7336-29b6bf1a4famr16902995ad.37.1763703891158;
        Thu, 20 Nov 2025 21:44:51 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b111e01sm43622845ad.7.2025.11.20.21.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:44:50 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 20 Nov 2025 21:44:33 -0800
Subject: [PATCH net-next v11 01/13] vsock: a per-net vsock NS mode state
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251120-vsock-vmtest-v11-1-55cbc80249a7@meta.com>
References: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
In-Reply-To: <20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

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

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
Changes in v10:
- change mode_locked to int (Stefano)

Changes in v9:
- use xchg(), WRITE_ONCE(), READ_ONCE() for mode and mode_locked (Stefano)
- clarify mode0/mode1 meaning in vsock_net_check_mode() comment
- remove spin lock in net->vsock (not used anymore)
- change mode from u8 to enum vsock_net_mode in vsock_net_write_mode()

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
 include/net/af_vsock.h      | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/net/net_namespace.h |  4 ++++
 include/net/netns/vsock.h   | 17 +++++++++++++++++
 4 files changed, 66 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e9a8d945632b..b6ac6720d706 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27105,6 +27105,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/vhost/vsock.c
 F:	include/linux/virtio_vsock.h
+F:	include/net/netns/vsock.h
 F:	include/uapi/linux/virtio_vsock.h
 F:	net/vmw_vsock/virtio_transport.c
 F:	net/vmw_vsock/virtio_transport_common.c
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index d40e978126e3..9b5bdd083b6f 100644
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
@@ -256,4 +258,46 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
 {
 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
 }
+
+static inline enum vsock_net_mode vsock_net_mode(struct net *net)
+{
+	return READ_ONCE(net->vsock.mode);
+}
+
+static inline bool vsock_net_write_mode(struct net *net,
+					enum vsock_net_mode mode)
+{
+	if (xchg(&net->vsock.mode_locked, 1))
+		return false;
+
+	WRITE_ONCE(net->vsock.mode, mode);
+	return true;
+}
+
+/* Return true if two namespaces and modes pass the mode rules. Otherwise,
+ * return false.
+ *
+ * - ns0 and ns1 are the namespaces being checked.
+ * - mode0 and mode1 are the vsock namespace modes of ns0 and ns1 at the time
+ *   the vsock objects were created.
+ *
+ * Read more about modes in the comment header of net/vmw_vsock/af_vsock.c.
+ */
+static inline bool vsock_net_check_mode(struct net *ns0,
+					enum vsock_net_mode mode0,
+					struct net *ns1,
+					enum vsock_net_mode mode1)
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
index 000000000000..c1a5e805949d
--- /dev/null
+++ b/include/net/netns/vsock.h
@@ -0,0 +1,17 @@
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
+	enum vsock_net_mode mode;
+	int mode_locked;
+};
+#endif /* __NET_NET_NAMESPACE_VSOCK_H */

-- 
2.47.3


