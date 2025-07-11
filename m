Return-Path: <kvm+bounces-52154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DAD2B01CEB
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2556D5C3530
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580652D3A60;
	Fri, 11 Jul 2025 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gaZZEclU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE142D23B7
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752239049; cv=none; b=CwDK5rV5NcPhu+wy0FEvDUQKne9fEvB0Gx2+tms2my0hQ3deauXfzPcmNf9/29LX7BgVSSsz4JCOYwAZyz5+N01BzjJu+nNcedCDCe8KA3oXsxMoUr7IzkfPVH8Lnd+GJ1qC2/ROF+hZdSSTCY2K/DdpGjDrR7aKfMCz4iBW01E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752239049; c=relaxed/simple;
	bh=4OjOzbETFya+46l7wTh0p7Nb7VL0yL+j68r4AqrgYnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMzgdi6DER2LHxC9fULSlbUTS5eIZ/oxdoKHcc+YqaYkoRY2KldamvLG6+cITwZanjw86u+RWwmh3IbyBO31Mnf3gFBGl7ZoeQ7S8FtNTggWFQJHHSFni4z760DJgr8dqkIHaX+s6oiqv/ncCejoKwtbgwbKQm4NBiBQfV6bhoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gaZZEclU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752239047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=deNzeY8fPYX4UsVS1X8oPLeiiPq26mWZLw+kyJ1F82k=;
	b=gaZZEclUomv1NDxuPL70MW6OTKBau3E7uuy3/dRNzHjKdFB6fudfQtUKtp3iGzG4C6rSSx
	R5LvV7YLpssS2h7DiHl8hyqYT1RkZaLdSUOasgV6w0EJ+fj/4+tS+vDKJIYP4+gr9a3XGl
	Ji5zODEH/qezj14lXdKMuuEwK515vSc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-kbQDjhVpO0WNRc860C6Imw-1; Fri,
 11 Jul 2025 09:04:03 -0400
X-MC-Unique: kbQDjhVpO0WNRc860C6Imw-1
X-Mimecast-MFC-AGG-ID: kbQDjhVpO0WNRc860C6Imw_1752239042
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D4BD180028B;
	Fri, 11 Jul 2025 13:04:02 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.33.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E77B219560A3;
	Fri, 11 Jul 2025 13:03:56 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Jason Wang <jasowang@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Luigi Rizzo <lrizzo@google.com>,
	Giuseppe Lettieri <g.lettieri@iet.unipi.it>,
	Vincenzo Maffione <v.maffione@gmail.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH RFC v2 12/13] net: implement tunnel probing
Date: Fri, 11 Jul 2025 15:02:17 +0200
Message-ID: <94ffdec876d61f22a90e63d6a79ff5517d1c727c.1752229731.git.pabeni@redhat.com>
In-Reply-To: <cover.1752229731.git.pabeni@redhat.com>
References: <cover.1752229731.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Tap devices support GSO over UDP tunnel offload. Probe for such
feature in a similar manner to other offloads.

GSO over UDP tunnel needs to be enabled in addition to  a "plain"
offload (TSO or USO).

No need to check separately for the outer header checksum offload:
the kernel is going to support both of them or none.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v1 -> v2:
  - peer_has_tunnel return a bool
  - move TUN_F definition in net/tun-linux.h
---
 hw/net/virtio-net.c | 37 +++++++++++++++++++++++++++++++++++++
 include/net/net.h   |  3 +++
 net/net.c           |  9 +++++++++
 net/tap-bsd.c       |  5 +++++
 net/tap-linux.c     | 11 +++++++++++
 net/tap-linux.h     |  9 +++++++++
 net/tap-solaris.c   |  5 +++++
 net/tap-stub.c      |  5 +++++
 net/tap.c           | 11 +++++++++++
 net/tap_int.h       |  1 +
 10 files changed, 96 insertions(+)

diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 09d5ef1ece..8ed1cad363 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -649,6 +649,15 @@ static int peer_has_uso(VirtIONet *n)
     return qemu_has_uso(qemu_get_queue(n->nic)->peer);
 }
 
+static bool peer_has_tunnel(VirtIONet *n)
+{
+    if (!peer_has_vnet_hdr(n)) {
+        return 0;
+    }
+
+    return qemu_has_tunnel(qemu_get_queue(n->nic)->peer);
+}
+
 static void virtio_net_set_mrg_rx_bufs(VirtIONet *n, int mergeable_rx_bufs,
                                        int version_1, int hash_report)
 {
@@ -791,6 +800,13 @@ static void virtio_net_get_features(VirtIODevice *vdev, uint64_t *features,
         virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO4);
         virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO6);
 
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO);
+        virtio_clear_feature_ex(features,
+                                VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM);
+        virtio_clear_feature_ex(features,
+                                VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM);
+
         virtio_clear_feature_ex(features, VIRTIO_NET_F_HASH_REPORT);
     }
 
@@ -805,6 +821,15 @@ static void virtio_net_get_features(VirtIODevice *vdev, uint64_t *features,
         virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_USO6);
     }
 
+    if (!peer_has_tunnel(n)) {
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO);
+        virtio_clear_feature_ex(features, VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO);
+        virtio_clear_feature_ex(features,
+                                VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM);
+        virtio_clear_feature_ex(features,
+                                VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM);
+    }
+
     if (!get_vhost_net(nc->peer)) {
         return;
     }
@@ -4087,6 +4112,10 @@ static const VMStateDescription vmstate_virtio_net = {
     .dev_unplug_pending = dev_unplug_pending,
 };
 
+#define DEFINE_PROP_FEATURE(_name, _state, _field, _bit, _defval)   \
+    DEFINE_PROP_BIT64(_name, _state, _field[VIRTIO_DWORD(_bit)],    \
+                      _bit & 0x3f, _defval)
+
 static const Property virtio_net_properties[] = {
     DEFINE_PROP_BIT64("csum", VirtIONet, host_features,
                     VIRTIO_NET_F_CSUM, true),
@@ -4159,6 +4188,14 @@ static const Property virtio_net_properties[] = {
                       VIRTIO_NET_F_GUEST_USO6, true),
     DEFINE_PROP_BIT64("host_uso", VirtIONet, host_features,
                       VIRTIO_NET_F_HOST_USO, true),
+    DEFINE_PROP_FEATURE("host_tunnel", VirtIONet, host_features_array,
+                        VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO, true),
+    DEFINE_PROP_FEATURE("host_tunnel_csum", VirtIONet, host_features_array,
+                        VIRTIO_NET_F_HOST_UDP_TUNNEL_GSO_CSUM, true),
+    DEFINE_PROP_FEATURE("guest_tunnel", VirtIONet, host_features_array,
+                        VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO, true),
+    DEFINE_PROP_FEATURE("guest_tunnel_csum", VirtIONet, host_features_array,
+                        VIRTIO_NET_F_GUEST_UDP_TUNNEL_GSO_CSUM, true),
 };
 
 static void virtio_net_class_init(ObjectClass *klass, const void *data)
diff --git a/include/net/net.h b/include/net/net.h
index 5edea7671a..c71d7c6074 100644
--- a/include/net/net.h
+++ b/include/net/net.h
@@ -65,6 +65,7 @@ typedef void (NetClientDestructor)(NetClientState *);
 typedef RxFilterInfo *(QueryRxFilter)(NetClientState *);
 typedef bool (HasUfo)(NetClientState *);
 typedef bool (HasUso)(NetClientState *);
+typedef bool (HasTunnel)(NetClientState *);
 typedef bool (HasVnetHdr)(NetClientState *);
 typedef bool (HasVnetHdrLen)(NetClientState *, int);
 typedef void (SetOffload)(NetClientState *, const NetOffloads *);
@@ -93,6 +94,7 @@ typedef struct NetClientInfo {
     NetPoll *poll;
     HasUfo *has_ufo;
     HasUso *has_uso;
+    HasTunnel *has_tunnel;
     HasVnetHdr *has_vnet_hdr;
     HasVnetHdrLen *has_vnet_hdr_len;
     SetOffload *set_offload;
@@ -193,6 +195,7 @@ void qemu_set_info_str(NetClientState *nc,
 void qemu_format_nic_info_str(NetClientState *nc, uint8_t macaddr[6]);
 bool qemu_has_ufo(NetClientState *nc);
 bool qemu_has_uso(NetClientState *nc);
+bool qemu_has_tunnel(NetClientState *nc);
 bool qemu_has_vnet_hdr(NetClientState *nc);
 bool qemu_has_vnet_hdr_len(NetClientState *nc, int len);
 void qemu_set_offload(NetClientState *nc, const NetOffloads *ol);
diff --git a/net/net.c b/net/net.c
index 053db7c314..5a2f00c108 100644
--- a/net/net.c
+++ b/net/net.c
@@ -522,6 +522,15 @@ bool qemu_has_uso(NetClientState *nc)
     return nc->info->has_uso(nc);
 }
 
+bool qemu_has_tunnel(NetClientState *nc)
+{
+    if (!nc || !nc->info->has_tunnel) {
+        return false;
+    }
+
+    return nc->info->has_tunnel(nc);
+}
+
 bool qemu_has_vnet_hdr(NetClientState *nc)
 {
     if (!nc || !nc->info->has_vnet_hdr) {
diff --git a/net/tap-bsd.c b/net/tap-bsd.c
index 86b6edee94..e7de0672f4 100644
--- a/net/tap-bsd.c
+++ b/net/tap-bsd.c
@@ -217,6 +217,11 @@ int tap_probe_has_uso(int fd)
     return 0;
 }
 
+int tap_probe_has_tunnel(int fd)
+{
+    return 0;
+}
+
 void tap_fd_set_vnet_hdr_len(int fd, int len)
 {
 }
diff --git a/net/tap-linux.c b/net/tap-linux.c
index a1c58f74f5..4ec638add6 100644
--- a/net/tap-linux.c
+++ b/net/tap-linux.c
@@ -196,6 +196,17 @@ int tap_probe_has_uso(int fd)
     return 1;
 }
 
+int tap_probe_has_tunnel(int fd)
+{
+    unsigned offload;
+
+    offload = TUN_F_CSUM | TUN_F_TSO4 | TUN_F_UDP_TUNNEL_GSO;
+    if (ioctl(fd, TUNSETOFFLOAD, offload) < 0) {
+        return 0;
+    }
+    return 1;
+}
+
 void tap_fd_set_vnet_hdr_len(int fd, int len)
 {
     if (ioctl(fd, TUNSETVNETHDRSZ, &len) == -1) {
diff --git a/net/tap-linux.h b/net/tap-linux.h
index 9a58cecb7f..8cd6b5874b 100644
--- a/net/tap-linux.h
+++ b/net/tap-linux.h
@@ -53,4 +53,13 @@
 #define TUN_F_USO4    0x20    /* I can handle USO for IPv4 packets */
 #define TUN_F_USO6    0x40    /* I can handle USO for IPv6 packets */
 
+/* I can handle TSO/USO for UDP tunneled packets */
+#define TUN_F_UDP_TUNNEL_GSO       0x080
+
+/*
+ * I can handle TSO/USO for UDP tunneled packets requiring csum offload for
+ * the outer header
+ */
+#define TUN_F_UDP_TUNNEL_GSO_CSUM  0x100
+
 #endif /* QEMU_TAP_LINUX_H */
diff --git a/net/tap-solaris.c b/net/tap-solaris.c
index 833c066bee..ac09ae03c0 100644
--- a/net/tap-solaris.c
+++ b/net/tap-solaris.c
@@ -222,6 +222,11 @@ int tap_probe_has_uso(int fd)
     return 0;
 }
 
+int tap_probe_has_tunnel(int fd)
+{
+    return 0;
+}
+
 void tap_fd_set_vnet_hdr_len(int fd, int len)
 {
 }
diff --git a/net/tap-stub.c b/net/tap-stub.c
index 67d14ad4d5..66abbbc392 100644
--- a/net/tap-stub.c
+++ b/net/tap-stub.c
@@ -52,6 +52,11 @@ int tap_probe_has_uso(int fd)
     return 0;
 }
 
+int tap_probe_has_tunnel(int fd)
+{
+    return 0;
+}
+
 void tap_fd_set_vnet_hdr_len(int fd, int len)
 {
 }
diff --git a/net/tap.c b/net/tap.c
index 13e19130ce..c7612fb91b 100644
--- a/net/tap.c
+++ b/net/tap.c
@@ -58,6 +58,7 @@ typedef struct TAPState {
     bool using_vnet_hdr;
     bool has_ufo;
     bool has_uso;
+    bool has_tunnel;
     bool enabled;
     VHostNetState *vhost_net;
     unsigned host_vnet_hdr_len;
@@ -223,6 +224,14 @@ static bool tap_has_uso(NetClientState *nc)
     return s->has_uso;
 }
 
+static bool tap_has_tunnel(NetClientState *nc)
+{
+    TAPState *s = DO_UPCAST(TAPState, nc, nc);
+
+    assert(nc->info->type == NET_CLIENT_DRIVER_TAP);
+    return s->has_tunnel;
+}
+
 static bool tap_has_vnet_hdr(NetClientState *nc)
 {
     TAPState *s = DO_UPCAST(TAPState, nc, nc);
@@ -339,6 +348,7 @@ static NetClientInfo net_tap_info = {
     .cleanup = tap_cleanup,
     .has_ufo = tap_has_ufo,
     .has_uso = tap_has_uso,
+    .has_tunnel = tap_has_tunnel,
     .has_vnet_hdr = tap_has_vnet_hdr,
     .has_vnet_hdr_len = tap_has_vnet_hdr_len,
     .set_offload = tap_set_offload,
@@ -367,6 +377,7 @@ static TAPState *net_tap_fd_init(NetClientState *peer,
     s->using_vnet_hdr = false;
     s->has_ufo = tap_probe_has_ufo(s->fd);
     s->has_uso = tap_probe_has_uso(s->fd);
+    s->has_tunnel = tap_probe_has_tunnel(s->fd);
     s->enabled = true;
     tap_set_offload(&s->nc, &ol);
     /*
diff --git a/net/tap_int.h b/net/tap_int.h
index f8bbe1cb0c..327d10f68b 100644
--- a/net/tap_int.h
+++ b/net/tap_int.h
@@ -38,6 +38,7 @@ void tap_set_sndbuf(int fd, const NetdevTapOptions *tap, Error **errp);
 int tap_probe_vnet_hdr(int fd, Error **errp);
 int tap_probe_has_ufo(int fd);
 int tap_probe_has_uso(int fd);
+int tap_probe_has_tunnel(int fd);
 void tap_fd_set_offload(int fd, const NetOffloads *ol);
 void tap_fd_set_vnet_hdr_len(int fd, int len);
 int tap_fd_set_vnet_le(int fd, int vnet_is_le);
-- 
2.50.0


