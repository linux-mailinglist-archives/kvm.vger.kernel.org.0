Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B257CFE39
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346412AbjJSPlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346339AbjJSPlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:41:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C365E131
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MBQc9snncSE2SGAFzCkA4MXIHKXNBdfUi4wKrq7w/1Q=; b=ftO+b8ElisYoMpG6zh4oL72AfJ
        Ii6zdS2m5gCiLsTfzkWuceDvvAtF6ydm4VmZwsvnD9u6WC/l3M5bS8tBmYXwqyy5ik/WGknx4wUMq
        zTrGu1K4y7WdpY9FH/Yah0O4ZKN8sGhFl96X+8Vo9gN+FBAtWHBw+oNgsuZ9Kmfxq6ZZtmPDSFN/x
        0sp0dLKiKHxPJIWsXiR8Fn+p8oiyWGRHQOAUf0Bamp01RBJ2FPpB00o227cpACs7VAYQ/AdK6sr0I
        uytX2giVHMItlD5wlxHiC7L1Ajrb8aEV9+gENuG9w84JwBi4B7zekZsrIAYll/rPzp6XajxnH9iOU
        +tu/QtAw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8O-009yCu-0Q;
        Thu, 19 Oct 2023 15:40:28 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8M-000Pur-39;
        Thu, 19 Oct 2023 16:40:26 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v2 18/24] hw/xen: update Xen PV NIC to XenDevice model
Date:   Thu, 19 Oct 2023 16:40:14 +0100
Message-Id: <20231019154020.99080-19-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231019154020.99080-1-dwmw2@infradead.org>
References: <20231019154020.99080-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This allows us to use Xen PV networking with emulated Xen guests, and to
add them on the command line or hotplug.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/net/meson.build        |   2 +-
 hw/net/trace-events       |  11 +
 hw/net/xen_nic.c          | 471 ++++++++++++++++++++++++++++----------
 hw/xenpv/xen_machine_pv.c |   1 -
 4 files changed, 368 insertions(+), 117 deletions(-)

diff --git a/hw/net/meson.build b/hw/net/meson.build
index 2632634df3..f64651c467 100644
--- a/hw/net/meson.build
+++ b/hw/net/meson.build
@@ -1,5 +1,5 @@
 system_ss.add(when: 'CONFIG_DP8393X', if_true: files('dp8393x.c'))
-system_ss.add(when: 'CONFIG_XEN', if_true: files('xen_nic.c'))
+system_ss.add(when: 'CONFIG_XEN_BUS', if_true: files('xen_nic.c'))
 system_ss.add(when: 'CONFIG_NE2000_COMMON', if_true: files('ne2000.c'))
 
 # PCI network cards
diff --git a/hw/net/trace-events b/hw/net/trace-events
index 3abfd65e5b..3097742cc0 100644
--- a/hw/net/trace-events
+++ b/hw/net/trace-events
@@ -482,3 +482,14 @@ dp8393x_receive_oversize(int size) "oversize packet, pkt_size is %d"
 dp8393x_receive_not_netcard(void) "packet not for netcard"
 dp8393x_receive_packet(int crba) "Receive packet at 0x%"PRIx32
 dp8393x_receive_write_status(int crba) "Write status at 0x%"PRIx32
+
+# xen_nic.c
+xen_netdev_realize(int dev, const char *info, const char *peer) "vif%u info '%s' peer '%s'"
+xen_netdev_unrealize(int dev) "vif%u"
+xen_netdev_create(int dev) "vif%u"
+xen_netdev_destroy(int dev) "vif%u"
+xen_netdev_disconnect(int dev) "vif%u"
+xen_netdev_connect(int dev, unsigned int tx, unsigned int rx, int port) "vif%u tx %u rx %u port %u"
+xen_netdev_frontend_changed(const char *dev, int state) "vif%s state %d"
+xen_netdev_tx(int dev, int ref, int off, int len, unsigned int flags, const char *c, const char *d, const char *m, const char *e) "vif%u ref %u off %u len %u flags 0x%x%s%s%s%s"
+xen_netdev_rx(int dev, int idx, int status, int flags) "vif%u idx %d status %d flags 0x%x"
diff --git a/hw/net/xen_nic.c b/hw/net/xen_nic.c
index 9bbf6599fc..d4d13a7c51 100644
--- a/hw/net/xen_nic.c
+++ b/hw/net/xen_nic.c
@@ -20,6 +20,12 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
+#include "qemu/log.h"
+#include "qemu/qemu-print.h"
+#include "qapi/qmp/qdict.h"
+#include "qapi/error.h"
+
 #include <sys/socket.h>
 #include <sys/ioctl.h>
 #include <sys/wait.h>
@@ -27,18 +33,26 @@
 #include "net/net.h"
 #include "net/checksum.h"
 #include "net/util.h"
-#include "hw/xen/xen-legacy-backend.h"
+
+#include "hw/xen/xen-backend.h"
+#include "hw/xen/xen-bus-helper.h"
+#include "hw/qdev-properties.h"
+#include "hw/qdev-properties-system.h"
 
 #include "hw/xen/interface/io/netif.h"
+#include "hw/xen/interface/io/xs_wire.h"
+
+#include "trace.h"
 
 /* ------------------------------------------------------------- */
 
 struct XenNetDev {
-    struct XenLegacyDevice      xendev;  /* must be first */
-    char                  *mac;
+    struct XenDevice      xendev;  /* must be first */
+    XenEventChannel       *event_channel;
+    int                   dev;
     int                   tx_work;
-    int                   tx_ring_ref;
-    int                   rx_ring_ref;
+    unsigned int          tx_ring_ref;
+    unsigned int          rx_ring_ref;
     struct netif_tx_sring *txs;
     struct netif_rx_sring *rxs;
     netif_tx_back_ring_t  tx_ring;
@@ -47,6 +61,11 @@ struct XenNetDev {
     NICState              *nic;
 };
 
+typedef struct XenNetDev XenNetDev;
+
+#define TYPE_XEN_NET_DEVICE "xen-net-device"
+OBJECT_DECLARE_SIMPLE_TYPE(XenNetDev, XEN_NET_DEVICE)
+
 /* ------------------------------------------------------------- */
 
 static void net_tx_response(struct XenNetDev *netdev, netif_tx_request_t *txp, int8_t st)
@@ -68,7 +87,8 @@ static void net_tx_response(struct XenNetDev *netdev, netif_tx_request_t *txp, i
     netdev->tx_ring.rsp_prod_pvt = ++i;
     RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&netdev->tx_ring, notify);
     if (notify) {
-        xen_pv_send_notify(&netdev->xendev);
+        xen_device_notify_event_channel(XEN_DEVICE(netdev),
+                                        netdev->event_channel, NULL);
     }
 
     if (i == netdev->tx_ring.req_cons) {
@@ -104,8 +124,9 @@ static void net_tx_error(struct XenNetDev *netdev, netif_tx_request_t *txp, RING
 #endif
 }
 
-static void net_tx_packets(struct XenNetDev *netdev)
+static bool net_tx_packets(struct XenNetDev *netdev)
 {
+    bool done_something = false;
     netif_tx_request_t txreq;
     RING_IDX rc, rp;
     void *page;
@@ -122,49 +143,52 @@ static void net_tx_packets(struct XenNetDev *netdev)
             }
             memcpy(&txreq, RING_GET_REQUEST(&netdev->tx_ring, rc), sizeof(txreq));
             netdev->tx_ring.req_cons = ++rc;
+            done_something = true;
 
 #if 1
             /* should not happen in theory, we don't announce the *
              * feature-{sg,gso,whatelse} flags in xenstore (yet?) */
             if (txreq.flags & NETTXF_extra_info) {
-                xen_pv_printf(&netdev->xendev, 0, "FIXME: extra info flag\n");
+                qemu_log_mask(LOG_UNIMP, "vif%u: FIXME: extra info flag\n",
+                              netdev->dev);
                 net_tx_error(netdev, &txreq, rc);
                 continue;
             }
             if (txreq.flags & NETTXF_more_data) {
-                xen_pv_printf(&netdev->xendev, 0, "FIXME: more data flag\n");
+                qemu_log_mask(LOG_UNIMP, "vif%u: FIXME: more data flag\n",
+                              netdev->dev);
                 net_tx_error(netdev, &txreq, rc);
                 continue;
             }
 #endif
 
             if (txreq.size < 14) {
-                xen_pv_printf(&netdev->xendev, 0, "bad packet size: %d\n",
-                              txreq.size);
+                qemu_log_mask(LOG_GUEST_ERROR, "vif%u: bad packet size: %d\n",
+                              netdev->dev, txreq.size);
                 net_tx_error(netdev, &txreq, rc);
                 continue;
             }
 
             if ((txreq.offset + txreq.size) > XEN_PAGE_SIZE) {
-                xen_pv_printf(&netdev->xendev, 0, "error: page crossing\n");
+                qemu_log_mask(LOG_GUEST_ERROR, "vif%u: error: page crossing\n",
+                              netdev->dev);
                 net_tx_error(netdev, &txreq, rc);
                 continue;
             }
 
-            xen_pv_printf(&netdev->xendev, 3,
-                          "tx packet ref %d, off %d, len %d, flags 0x%x%s%s%s%s\n",
-                          txreq.gref, txreq.offset, txreq.size, txreq.flags,
-                          (txreq.flags & NETTXF_csum_blank)     ? " csum_blank"     : "",
-                          (txreq.flags & NETTXF_data_validated) ? " data_validated" : "",
-                          (txreq.flags & NETTXF_more_data)      ? " more_data"      : "",
-                          (txreq.flags & NETTXF_extra_info)     ? " extra_info"     : "");
+            trace_xen_netdev_tx(netdev->dev, txreq.gref, txreq.offset,
+                                txreq.size, txreq.flags,
+                                (txreq.flags & NETTXF_csum_blank)     ? " csum_blank"     : "",
+                                (txreq.flags & NETTXF_data_validated) ? " data_validated" : "",
+                                (txreq.flags & NETTXF_more_data)      ? " more_data"      : "",
+                                (txreq.flags & NETTXF_extra_info)     ? " extra_info"     : "");
 
-            page = xen_be_map_grant_ref(&netdev->xendev, txreq.gref,
-                                        PROT_READ);
+            page = xen_device_map_grant_refs(&netdev->xendev, &txreq.gref, 1,
+                                             PROT_READ, NULL);
             if (page == NULL) {
-                xen_pv_printf(&netdev->xendev, 0,
-                              "error: tx gref dereference failed (%d)\n",
-                             txreq.gref);
+                qemu_log_mask(LOG_GUEST_ERROR,
+                              "vif%u: tx gref dereference failed (%d)\n",
+                              netdev->dev, txreq.gref);
                 net_tx_error(netdev, &txreq, rc);
                 continue;
             }
@@ -181,7 +205,8 @@ static void net_tx_packets(struct XenNetDev *netdev)
                 qemu_send_packet(qemu_get_queue(netdev->nic),
                                  page + txreq.offset, txreq.size);
             }
-            xen_be_unmap_grant_ref(&netdev->xendev, page, txreq.gref);
+            xen_device_unmap_grant_refs(&netdev->xendev, page, &txreq.gref, 1,
+                                        NULL);
             net_tx_response(netdev, &txreq, NETIF_RSP_OKAY);
         }
         if (!netdev->tx_work) {
@@ -190,6 +215,7 @@ static void net_tx_packets(struct XenNetDev *netdev)
         netdev->tx_work = 0;
     }
     g_free(tmpbuf);
+    return done_something;
 }
 
 /* ------------------------------------------------------------- */
@@ -212,14 +238,13 @@ static void net_rx_response(struct XenNetDev *netdev,
         resp->status = (int16_t)st;
     }
 
-    xen_pv_printf(&netdev->xendev, 3,
-                  "rx response: idx %d, status %d, flags 0x%x\n",
-                  i, resp->status, resp->flags);
+    trace_xen_netdev_rx(netdev->dev, i, resp->status, resp->flags);
 
     netdev->rx_ring.rsp_prod_pvt = ++i;
     RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&netdev->rx_ring, notify);
     if (notify) {
-        xen_pv_send_notify(&netdev->xendev);
+        xen_device_notify_event_channel(XEN_DEVICE(netdev),
+                                        netdev->event_channel, NULL);
     }
 }
 
@@ -232,7 +257,7 @@ static ssize_t net_rx_packet(NetClientState *nc, const uint8_t *buf, size_t size
     RING_IDX rc, rp;
     void *page;
 
-    if (netdev->xendev.be_state != XenbusStateConnected) {
+    if (netdev->rx_ring.sring == NULL) {
         return -1;
     }
 
@@ -244,24 +269,26 @@ static ssize_t net_rx_packet(NetClientState *nc, const uint8_t *buf, size_t size
         return 0;
     }
     if (size > XEN_PAGE_SIZE - NET_IP_ALIGN) {
-        xen_pv_printf(&netdev->xendev, 0, "packet too big (%lu > %ld)",
-                      (unsigned long)size, XEN_PAGE_SIZE - NET_IP_ALIGN);
+        qemu_log_mask(LOG_GUEST_ERROR, "vif%u: packet too big (%lu > %ld)",
+                      netdev->dev, (unsigned long)size,
+                      XEN_PAGE_SIZE - NET_IP_ALIGN);
         return -1;
     }
 
     memcpy(&rxreq, RING_GET_REQUEST(&netdev->rx_ring, rc), sizeof(rxreq));
     netdev->rx_ring.req_cons = ++rc;
 
-    page = xen_be_map_grant_ref(&netdev->xendev, rxreq.gref, PROT_WRITE);
+    page = xen_device_map_grant_refs(&netdev->xendev, &rxreq.gref, 1,
+                                     PROT_WRITE, NULL);
     if (page == NULL) {
-        xen_pv_printf(&netdev->xendev, 0,
-                      "error: rx gref dereference failed (%d)\n",
-                      rxreq.gref);
+        qemu_log_mask(LOG_GUEST_ERROR,
+                      "vif%u: rx gref dereference failed (%d)\n",
+                      netdev->dev, rxreq.gref);
         net_rx_response(netdev, &rxreq, NETIF_RSP_ERROR, 0, 0, 0);
         return -1;
     }
     memcpy(page + NET_IP_ALIGN, buf, size);
-    xen_be_unmap_grant_ref(&netdev->xendev, page, rxreq.gref);
+    xen_device_unmap_grant_refs(&netdev->xendev, page, &rxreq.gref, 1, NULL);
     net_rx_response(netdev, &rxreq, NETIF_RSP_OKAY, NET_IP_ALIGN, size, 0);
 
     return size;
@@ -275,139 +302,353 @@ static NetClientInfo net_xen_info = {
     .receive = net_rx_packet,
 };
 
-static int net_init(struct XenLegacyDevice *xendev)
+static void xen_netdev_realize(XenDevice *xendev, Error **errp)
 {
-    struct XenNetDev *netdev = container_of(xendev, struct XenNetDev, xendev);
-
-    /* read xenstore entries */
-    if (netdev->mac == NULL) {
-        netdev->mac = xenstore_read_be_str(&netdev->xendev, "mac");
-    }
+    ERRP_GUARD();
+    XenNetDev *netdev = XEN_NET_DEVICE(xendev);
+    NetClientState *nc;
 
-    /* do we have all we need? */
-    if (netdev->mac == NULL) {
-        return -1;
-    }
+    qemu_macaddr_default_if_unset(&netdev->conf.macaddr);
 
-    if (net_parse_macaddr(netdev->conf.macaddr.a, netdev->mac) < 0) {
-        return -1;
-    }
+    xen_device_frontend_printf(xendev, "mac", "%02x:%02x:%02x:%02x:%02x:%02x",
+                               netdev->conf.macaddr.a[0],
+                               netdev->conf.macaddr.a[1],
+                               netdev->conf.macaddr.a[2],
+                               netdev->conf.macaddr.a[3],
+                               netdev->conf.macaddr.a[4],
+                               netdev->conf.macaddr.a[5]);
 
     netdev->nic = qemu_new_nic(&net_xen_info, &netdev->conf,
-                               "xen", NULL, netdev);
+                               object_get_typename(OBJECT(xendev)),
+                               DEVICE(xendev)->id, netdev);
 
-    qemu_set_info_str(qemu_get_queue(netdev->nic),
-                      "nic: xenbus vif macaddr=%s", netdev->mac);
+    nc = qemu_get_queue(netdev->nic);
+    qemu_format_nic_info_str(nc, netdev->conf.macaddr.a);
 
     /* fill info */
-    xenstore_write_be_int(&netdev->xendev, "feature-rx-copy", 1);
-    xenstore_write_be_int(&netdev->xendev, "feature-rx-flip", 0);
+    xen_device_backend_printf(xendev, "feature-rx-copy", "%u", 1);
+    xen_device_backend_printf(xendev, "feature-rx-flip", "%u", 0);
 
-    return 0;
+    trace_xen_netdev_realize(netdev->dev, nc->info_str, nc->peer ?
+                             nc->peer->name : "(none)");
 }
 
-static int net_connect(struct XenLegacyDevice *xendev)
+static bool net_event(void *_xendev)
 {
-    struct XenNetDev *netdev = container_of(xendev, struct XenNetDev, xendev);
-    int rx_copy;
+    XenNetDev *netdev = XEN_NET_DEVICE(_xendev);
+    bool done_something;
 
-    if (xenstore_read_fe_int(&netdev->xendev, "tx-ring-ref",
-                             &netdev->tx_ring_ref) == -1) {
-        return -1;
+    done_something = net_tx_packets(netdev);
+    qemu_flush_queued_packets(qemu_get_queue(netdev->nic));
+    return done_something;
+}
+
+static bool xen_netdev_connect(XenDevice *xendev, Error **errp)
+{
+    XenNetDev *netdev = XEN_NET_DEVICE(xendev);
+    unsigned int port, rx_copy;
+
+    if (xen_device_frontend_scanf(xendev, "tx-ring-ref", "%u",
+                                  &netdev->tx_ring_ref) != 1) {
+        error_setg(errp, "failed to read tx-ring-ref");
+        return false;
     }
-    if (xenstore_read_fe_int(&netdev->xendev, "rx-ring-ref",
-                             &netdev->rx_ring_ref) == -1) {
-        return 1;
+
+    if (xen_device_frontend_scanf(xendev, "rx-ring-ref", "%u",
+                                  &netdev->rx_ring_ref) != 1) {
+        error_setg(errp, "failed to read rx-ring-ref");
+        return false;
     }
-    if (xenstore_read_fe_int(&netdev->xendev, "event-channel",
-                             &netdev->xendev.remote_port) == -1) {
-        return -1;
+
+    if (xen_device_frontend_scanf(xendev, "event-channel", "%u",
+                                  &port) != 1) {
+        error_setg(errp, "failed to read event-channel");
+        return false;
     }
 
-    if (xenstore_read_fe_int(&netdev->xendev, "request-rx-copy", &rx_copy) == -1) {
+    if (xen_device_frontend_scanf(xendev, "request-rx-copy", "%u",
+                                  &rx_copy) != 1) {
         rx_copy = 0;
     }
     if (rx_copy == 0) {
-        xen_pv_printf(&netdev->xendev, 0,
-                      "frontend doesn't support rx-copy.\n");
-        return -1;
+        error_setg(errp, "frontend doesn't support rx-copy");
+        return false;
     }
 
-    netdev->txs = xen_be_map_grant_ref(&netdev->xendev,
-                                       netdev->tx_ring_ref,
-                                       PROT_READ | PROT_WRITE);
+    netdev->txs = xen_device_map_grant_refs(xendev,
+                                            &netdev->tx_ring_ref, 1,
+                                            PROT_READ | PROT_WRITE,
+                                            errp);
     if (!netdev->txs) {
-        return -1;
+        error_prepend(errp, "failed to map tx grant ref: ");
+        return false;
     }
-    netdev->rxs = xen_be_map_grant_ref(&netdev->xendev,
-                                       netdev->rx_ring_ref,
-                                       PROT_READ | PROT_WRITE);
+
+    netdev->rxs = xen_device_map_grant_refs(xendev,
+                                            &netdev->rx_ring_ref, 1,
+                                            PROT_READ | PROT_WRITE,
+                                            errp);
     if (!netdev->rxs) {
-        xen_be_unmap_grant_ref(&netdev->xendev, netdev->txs,
-                               netdev->tx_ring_ref);
-        netdev->txs = NULL;
-        return -1;
+        error_prepend(errp, "failed to map rx grant ref: ");
+        return false;
     }
+
     BACK_RING_INIT(&netdev->tx_ring, netdev->txs, XEN_PAGE_SIZE);
     BACK_RING_INIT(&netdev->rx_ring, netdev->rxs, XEN_PAGE_SIZE);
 
-    xen_be_bind_evtchn(&netdev->xendev);
+    netdev->event_channel = xen_device_bind_event_channel(xendev, port,
+                                                          net_event,
+                                                          netdev,
+                                                          errp);
+    if (!netdev->event_channel) {
+        return false;
+    }
 
-    xen_pv_printf(&netdev->xendev, 1, "ok: tx-ring-ref %d, rx-ring-ref %d, "
-                  "remote port %d, local port %d\n",
-                  netdev->tx_ring_ref, netdev->rx_ring_ref,
-                  netdev->xendev.remote_port, netdev->xendev.local_port);
+    trace_xen_netdev_connect(netdev->dev, netdev->tx_ring_ref,
+                             netdev->rx_ring_ref, port);
 
     net_tx_packets(netdev);
-    return 0;
+    return true;
 }
 
-static void net_disconnect(struct XenLegacyDevice *xendev)
+static void xen_netdev_disconnect(XenDevice *xendev, Error **errp)
 {
-    struct XenNetDev *netdev = container_of(xendev, struct XenNetDev, xendev);
+    XenNetDev *netdev = XEN_NET_DEVICE(xendev);
 
-    xen_pv_unbind_evtchn(&netdev->xendev);
+    trace_xen_netdev_disconnect(netdev->dev);
 
+    netdev->tx_ring.sring = NULL;
+    netdev->rx_ring.sring = NULL;
+
+    if (netdev->event_channel) {
+        xen_device_unbind_event_channel(xendev, netdev->event_channel,
+                                        errp);
+        netdev->event_channel = NULL;
+    }
     if (netdev->txs) {
-        xen_be_unmap_grant_ref(&netdev->xendev, netdev->txs,
-                               netdev->tx_ring_ref);
+        xen_device_unmap_grant_refs(xendev, netdev->txs,
+                                    &netdev->tx_ring_ref, 1, errp);
         netdev->txs = NULL;
     }
     if (netdev->rxs) {
-        xen_be_unmap_grant_ref(&netdev->xendev, netdev->rxs,
-                               netdev->rx_ring_ref);
+        xen_device_unmap_grant_refs(xendev, netdev->rxs,
+                                    &netdev->rx_ring_ref, 1, errp);
         netdev->rxs = NULL;
     }
 }
 
-static void net_event(struct XenLegacyDevice *xendev)
+/* -------------------------------------------------------------------- */
+
+
+static void xen_netdev_frontend_changed(XenDevice *xendev,
+                                       enum xenbus_state frontend_state,
+                                       Error **errp)
 {
-    struct XenNetDev *netdev = container_of(xendev, struct XenNetDev, xendev);
-    net_tx_packets(netdev);
-    qemu_flush_queued_packets(qemu_get_queue(netdev->nic));
+    ERRP_GUARD();
+    enum xenbus_state backend_state = xen_device_backend_get_state(xendev);
+
+    trace_xen_netdev_frontend_changed(xendev->name, frontend_state);
+
+    switch (frontend_state) {
+    case XenbusStateInitialised:
+    case XenbusStateConnected:
+        if (backend_state == XenbusStateConnected) {
+            break;
+        }
+
+        xen_netdev_disconnect(xendev, errp);
+        if (*errp) {
+            break;
+        }
+
+        if (!xen_netdev_connect(xendev, errp)) {
+            xen_netdev_disconnect(xendev, NULL);
+            xen_device_backend_set_state(xendev, XenbusStateClosing);
+            break;
+        }
+
+        xen_device_backend_set_state(xendev, XenbusStateConnected);
+        break;
+
+    case XenbusStateClosing:
+        xen_device_backend_set_state(xendev, XenbusStateClosing);
+        break;
+
+    case XenbusStateClosed:
+    case XenbusStateUnknown:
+        xen_netdev_disconnect(xendev, errp);
+        if (*errp) {
+            break;
+        }
+
+        xen_device_backend_set_state(xendev, XenbusStateClosed);
+        break;
+
+    default:
+        break;
+    }
+}
+
+static char *xen_netdev_get_name(XenDevice *xendev, Error **errp)
+{
+    XenNetDev *netdev = XEN_NET_DEVICE(xendev);
+
+    if (netdev->dev == -1) {
+        XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+        char fe_path[XENSTORE_ABS_PATH_MAX + 1];
+        int idx = (xen_mode == XEN_EMULATE) ? 0 : 1;
+        char *value;
+
+        /* Theoretically we could go up to INT_MAX here but that's overkill */
+        while (idx < 100) {
+            snprintf(fe_path, sizeof(fe_path),
+                     "/local/domain/%u/device/vif/%u",
+                     xendev->frontend_id, idx);
+            value = qemu_xen_xs_read(xenbus->xsh, XBT_NULL, fe_path, NULL);
+            if (!value) {
+                if (errno == ENOENT) {
+                    netdev->dev = idx;
+                    goto found;
+                }
+                error_setg(errp, "cannot read %s: %s", fe_path,
+                           strerror(errno));
+                return NULL;
+            }
+            free(value);
+            idx++;
+        }
+        error_setg(errp, "cannot find device index for netdev device");
+        return NULL;
+    }
+ found:
+    return g_strdup_printf("%u", netdev->dev);
 }
 
-static int net_free(struct XenLegacyDevice *xendev)
+static void xen_netdev_unrealize(XenDevice *xendev)
 {
-    struct XenNetDev *netdev = container_of(xendev, struct XenNetDev, xendev);
+    XenNetDev *netdev = XEN_NET_DEVICE(xendev);
+
+    trace_xen_netdev_unrealize(netdev->dev);
+
+    /* Disconnect from the frontend in case this has not already happened */
+    xen_netdev_disconnect(xendev, NULL);
 
     if (netdev->nic) {
         qemu_del_nic(netdev->nic);
-        netdev->nic = NULL;
     }
-    g_free(netdev->mac);
-    netdev->mac = NULL;
-    return 0;
 }
 
 /* ------------------------------------------------------------- */
 
-struct XenDevOps xen_netdev_ops = {
-    .size       = sizeof(struct XenNetDev),
-    .flags      = DEVOPS_FLAG_NEED_GNTDEV,
-    .init       = net_init,
-    .initialise    = net_connect,
-    .event      = net_event,
-    .disconnect = net_disconnect,
-    .free       = net_free,
+static Property xen_netdev_properties[] = {
+    DEFINE_NIC_PROPERTIES(XenNetDev, conf),
+    DEFINE_PROP_INT32("idx", XenNetDev, dev, -1),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void xen_netdev_class_init(ObjectClass *class, void *data)
+{
+    DeviceClass *dev_class = DEVICE_CLASS(class);
+    XenDeviceClass *xendev_class = XEN_DEVICE_CLASS(class);
+
+    xendev_class->backend = "qnic";
+    xendev_class->device = "vif";
+    xendev_class->get_name = xen_netdev_get_name;
+    xendev_class->realize = xen_netdev_realize;
+    xendev_class->frontend_changed = xen_netdev_frontend_changed;
+    xendev_class->unrealize = xen_netdev_unrealize;
+    set_bit(DEVICE_CATEGORY_NETWORK, dev_class->categories);
+    dev_class->user_creatable = true;
+
+    device_class_set_props(dev_class, xen_netdev_properties);
+}
+
+static const TypeInfo xen_net_type_info = {
+    .name = TYPE_XEN_NET_DEVICE,
+    .parent = TYPE_XEN_DEVICE,
+    .instance_size = sizeof(XenNetDev),
+    .class_init = xen_netdev_class_init,
+};
+
+static void xen_net_register_types(void)
+{
+    type_register_static(&xen_net_type_info);
+}
+
+type_init(xen_net_register_types)
+
+/* Called to instantiate a XenNetDev when the backend is detected. */
+static void xen_net_device_create(XenBackendInstance *backend,
+                                  QDict *opts, Error **errp)
+{
+    ERRP_GUARD();
+    XenBus *xenbus = xen_backend_get_bus(backend);
+    const char *name = xen_backend_get_name(backend);
+    XenDevice *xendev = NULL;
+    unsigned long number;
+    const char *macstr;
+    XenNetDev *net;
+    MACAddr mac;
+
+    if (qemu_strtoul(name, NULL, 10, &number) || number >= INT_MAX) {
+        error_setg(errp, "failed to parse name '%s'", name);
+        goto fail;
+    }
+
+    trace_xen_netdev_create(number);
+
+    macstr = qdict_get_try_str(opts, "mac");
+    if (macstr == NULL) {
+        error_setg(errp, "no MAC address found");
+        goto fail;
+    }
+
+    if (net_parse_macaddr(mac.a, macstr) < 0) {
+        error_setg(errp, "failed to parse MAC address");
+        goto fail;
+    }
+
+    xendev = XEN_DEVICE(qdev_new(TYPE_XEN_NET_DEVICE));
+    net = XEN_NET_DEVICE(xendev);
+
+    net->dev = number;
+    memcpy(&net->conf.macaddr, &mac, sizeof(mac));
+
+    if (qdev_realize_and_unref(DEVICE(xendev), BUS(xenbus), errp)) {
+        xen_backend_set_device(backend, xendev);
+        return;
+    }
+
+    error_prepend(errp, "realization of net device %lu failed: ",
+                  number);
+
+ fail:
+    if (xendev) {
+        object_unparent(OBJECT(xendev));
+    }
+}
+
+static void xen_net_device_destroy(XenBackendInstance *backend,
+                                       Error **errp)
+{
+    ERRP_GUARD();
+    XenDevice *xendev = xen_backend_get_device(backend);
+    XenNetDev *netdev = XEN_NET_DEVICE(xendev);
+
+    trace_xen_netdev_destroy(netdev->dev);
+
+    object_unparent(OBJECT(xendev));
+}
+
+static const XenBackendInfo xen_net_backend_info  = {
+    .type = "qnic",
+    .create = xen_net_device_create,
+    .destroy = xen_net_device_destroy,
 };
+
+static void xen_net_register_backend(void)
+{
+    xen_backend_register(&xen_net_backend_info);
+}
+
+xen_backend_init(xen_net_register_backend);
diff --git a/hw/xenpv/xen_machine_pv.c b/hw/xenpv/xen_machine_pv.c
index 1533f5dfb4..9f9f137f99 100644
--- a/hw/xenpv/xen_machine_pv.c
+++ b/hw/xenpv/xen_machine_pv.c
@@ -54,7 +54,6 @@ static void xen_init_pv(MachineState *machine)
     }
 
     xen_be_register("vfb", &xen_framebuffer_ops);
-    xen_be_register("qnic", &xen_netdev_ops);
 
     /* configure framebuffer */
     if (vga_interface_type == VGA_XENFB) {
-- 
2.40.1

