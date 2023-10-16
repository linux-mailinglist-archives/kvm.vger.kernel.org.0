Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8257CAD3A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjJPPTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbjJPPTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838ABF2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MW+VqkBMBDTx8qpmwaHvLd47tVYOYFHTVMg8ZLGqw+E=; b=F6Le8wEulZH/uGxnTtpjVzO9ks
        9OnUELoCQHWZpUn/3J6l2TGdPJwLX8s0ZW6hyNfyRPBV+C7+l9seIP59ZPz4k4cKYhhHVS1dDUx4+
        PPPZDhIUbz3fykPPx7t2MFnACpZYcs7kJkjS8HweTafNS4o+gzn5cMC7MsQfCvFAriMq7WJis47n4
        Y8hwSAY0GPu2RemhT6zyN84lmtbiUjyDrBv+97ojYvjFBLJpZLHiXCtpl3kY6hQ6ebLthx0owWmXN
        deJEsBA0gren6xtJuy2xDD2w9k3puHr0xO2u8/hy+XyPGvwLve73rWPevvfZ4HXAu0Tm1sbmfA6Hs
        yWkA8PyA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsPNC-006lqc-Bb; Mon, 16 Oct 2023 15:19:14 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0005nW-37;
        Mon, 16 Oct 2023 16:19:13 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: [PATCH 07/12] hw/xen: update Xen console to XenDevice model
Date:   Mon, 16 Oct 2023 16:19:04 +0100
Message-Id: <20231016151909.22133-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows (non-primary) console devices to be created on the command
line.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 hw/char/trace-events        |   8 +
 hw/char/xen_console.c       | 502 +++++++++++++++++++++++++++---------
 hw/xen/xen-legacy-backend.c |   1 -
 3 files changed, 381 insertions(+), 130 deletions(-)

diff --git a/hw/char/trace-events b/hw/char/trace-events
index babf4d35ea..7a398c82a5 100644
--- a/hw/char/trace-events
+++ b/hw/char/trace-events
@@ -105,3 +105,11 @@ cadence_uart_baudrate(unsigned baudrate) "baudrate %u"
 # sh_serial.c
 sh_serial_read(char *id, unsigned size, uint64_t offs, uint64_t val) " %s size %d offs 0x%02" PRIx64 " -> 0x%02" PRIx64
 sh_serial_write(char *id, unsigned size, uint64_t offs, uint64_t val) "%s size %d offs 0x%02" PRIx64 " <- 0x%02" PRIx64
+
+# xen_console.c
+xen_console_connect(unsigned int idx, unsigned int ring_ref, unsigned int port, unsigned int limit) "idx %u ring_ref %u port %u limit %u"
+xen_console_disconnect(unsigned int idx) "idx %u"
+xen_console_unrealize(unsigned int idx) "idx %u"
+xen_console_realize(unsigned int idx, const char *chrdev) "idx %u chrdev %s"
+xen_console_device_create(unsigned int idx) "idx %u"
+xen_console_device_destroy(unsigned int idx) "idx %u"
diff --git a/hw/char/xen_console.c b/hw/char/xen_console.c
index 810dae3f44..bd20be116c 100644
--- a/hw/char/xen_console.c
+++ b/hw/char/xen_console.c
@@ -20,15 +20,19 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
 #include <sys/select.h>
 #include <termios.h>
 
 #include "qapi/error.h"
 #include "sysemu/sysemu.h"
 #include "chardev/char-fe.h"
-#include "hw/xen/xen-legacy-backend.h"
-
+#include "hw/xen/xen-backend.h"
+#include "hw/xen/xen-bus-helper.h"
+#include "hw/qdev-properties.h"
+#include "hw/qdev-properties-system.h"
 #include "hw/xen/interface/io/console.h"
+#include "trace.h"
 
 struct buffer {
     uint8_t *data;
@@ -39,16 +43,22 @@ struct buffer {
 };
 
 struct XenConsole {
-    struct XenLegacyDevice  xendev;  /* must be first */
+    struct XenDevice  xendev;  /* must be first */
+    XenEventChannel   *event_channel;
+    int               dev;
     struct buffer     buffer;
-    char              console[XEN_BUFSIZE];
-    int               ring_ref;
+    char              *fe_path;
+    unsigned int      ring_ref;
     void              *sring;
     CharBackend       chr;
     int               backlog;
 };
+typedef struct XenConsole XenConsole;
+
+#define TYPE_XEN_CONSOLE_DEVICE "xen-console"
+OBJECT_DECLARE_SIMPLE_TYPE(XenConsole, XEN_CONSOLE_DEVICE)
 
-static void buffer_append(struct XenConsole *con)
+static bool buffer_append(XenConsole *con)
 {
     struct buffer *buffer = &con->buffer;
     XENCONS_RING_IDX cons, prod, size;
@@ -60,7 +70,7 @@ static void buffer_append(struct XenConsole *con)
 
     size = prod - cons;
     if ((size == 0) || (size > sizeof(intf->out)))
-        return;
+        return false;
 
     if ((buffer->capacity - buffer->size) < size) {
         buffer->capacity += (size + 1024);
@@ -73,7 +83,7 @@ static void buffer_append(struct XenConsole *con)
 
     xen_mb();
     intf->out_cons = cons;
-    xen_pv_send_notify(&con->xendev);
+    xen_device_notify_event_channel(XEN_DEVICE(con), con->event_channel, NULL);
 
     if (buffer->max_capacity &&
         buffer->size > buffer->max_capacity) {
@@ -89,6 +99,7 @@ static void buffer_append(struct XenConsole *con)
         if (buffer->consumed > buffer->max_capacity - over)
             buffer->consumed = buffer->max_capacity - over;
     }
+    return true;
 }
 
 static void buffer_advance(struct buffer *buffer, size_t len)
@@ -100,7 +111,7 @@ static void buffer_advance(struct buffer *buffer, size_t len)
     }
 }
 
-static int ring_free_bytes(struct XenConsole *con)
+static int ring_free_bytes(XenConsole *con)
 {
     struct xencons_interface *intf = con->sring;
     XENCONS_RING_IDX cons, prod, space;
@@ -118,13 +129,13 @@ static int ring_free_bytes(struct XenConsole *con)
 
 static int xencons_can_receive(void *opaque)
 {
-    struct XenConsole *con = opaque;
+    XenConsole *con = opaque;
     return ring_free_bytes(con);
 }
 
 static void xencons_receive(void *opaque, const uint8_t *buf, int len)
 {
-    struct XenConsole *con = opaque;
+    XenConsole *con = opaque;
     struct xencons_interface *intf = con->sring;
     XENCONS_RING_IDX prod;
     int i, max;
@@ -141,10 +152,10 @@ static void xencons_receive(void *opaque, const uint8_t *buf, int len)
     }
     xen_wmb();
     intf->in_prod = prod;
-    xen_pv_send_notify(&con->xendev);
+    xen_device_notify_event_channel(XEN_DEVICE(con), con->event_channel, NULL);
 }
 
-static void xencons_send(struct XenConsole *con)
+static bool xencons_send(XenConsole *con)
 {
     ssize_t len, size;
 
@@ -159,174 +170,407 @@ static void xencons_send(struct XenConsole *con)
     if (len < 1) {
         if (!con->backlog) {
             con->backlog = 1;
-            xen_pv_printf(&con->xendev, 1,
-                          "backlog piling up, nobody listening?\n");
         }
     } else {
         buffer_advance(&con->buffer, len);
         if (con->backlog && len == size) {
             con->backlog = 0;
-            xen_pv_printf(&con->xendev, 1, "backlog is gone\n");
         }
     }
+    return len > 0;
 }
 
 /* -------------------------------------------------------------------- */
 
-static int store_con_info(struct XenConsole *con)
+static bool con_event(void *_xendev)
 {
-    Chardev *cs = qemu_chr_fe_get_driver(&con->chr);
-    char *pts = NULL;
-    char *dom_path;
-    g_autoptr(GString) path = NULL;
+    XenConsole *con = XEN_CONSOLE_DEVICE(_xendev);
+    bool done_something;
 
-    /* Only continue if we're talking to a pty. */
-    if (!CHARDEV_IS_PTY(cs)) {
-        return 0;
-    }
-    pts = cs->filename + 4;
+    done_something = buffer_append(con);
 
-    dom_path = qemu_xen_xs_get_domain_path(xenstore, xen_domid);
-    if (!dom_path) {
-        return 0;
+    if (con->buffer.size - con->buffer.consumed) {
+        done_something |= xencons_send(con);
     }
+    return done_something;
+}
 
-    path = g_string_new(dom_path);
-    free(dom_path);
+/* -------------------------------------------------------------------- */
 
-    if (con->xendev.dev) {
-        g_string_append_printf(path, "/device/console/%d", con->xendev.dev);
-    } else {
-        g_string_append(path, "/console");
+static void xen_console_disconnect(XenDevice *xendev, Error **errp)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    qemu_chr_fe_set_handlers(&con->chr, NULL, NULL, NULL, NULL,
+                             con, NULL, true);
+
+
+    trace_xen_console_disconnect(con->dev);
+
+    if (con->event_channel) {
+        xen_device_unbind_event_channel(xendev, con->event_channel,
+                                        errp);
     }
-    g_string_append(path, "/tty");
 
-    if (xenstore_write_str(con->console, path->str, pts)) {
-        fprintf(stderr, "xenstore_write_str for '%s' fail", path->str);
-        return -1;
+    if (!con->sring) {
+        return;
+    }
+
+    if (!con->dev) {
+        qemu_xen_foreignmem_unmap(con->sring, 1);
+    } else {
+        xen_device_unmap_grant_refs(xendev, con->sring,
+                                    &con->ring_ref, 1, errp);
     }
-    return 0;
 }
 
-static int con_init(struct XenLegacyDevice *xendev)
+static void xen_console_connect(XenDevice *xendev, Error **errp)
 {
-    struct XenConsole *con = container_of(xendev, struct XenConsole, xendev);
-    char *type, *dom, label[32];
-    int ret = 0;
-    const char *output;
-
-    /* setup */
-    dom = qemu_xen_xs_get_domain_path(xenstore, con->xendev.dom);
-    if (!xendev->dev) {
-        snprintf(con->console, sizeof(con->console), "%s/console", dom);
-    } else {
-        snprintf(con->console, sizeof(con->console), "%s/device/console/%d", dom, xendev->dev);
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+    unsigned int port, limit;
+
+    if (xen_device_frontend_scanf(xendev, "ring-ref", "%u",
+                                  &con->ring_ref) != 1) {
+        error_setg(errp, "failed to read ring-ref");
+        return;
     }
-    free(dom);
 
-    type = xenstore_read_str(con->console, "type");
-    if (!type || strcmp(type, "ioemu") != 0) {
-        xen_pv_printf(xendev, 1, "not for me (type=%s)\n", type);
-        ret = -1;
-        goto out;
+    if (xen_device_frontend_scanf(xendev, "port", "%u", &port) != 1) {
+        error_setg(errp, "failed to read remote port");
+        return;
     }
 
-    output = xenstore_read_str(con->console, "output");
+    if (xen_device_frontend_scanf(xendev, "limit", "%u", &limit) == 1) {
+        con->buffer.max_capacity = limit;
+    }
 
-    /* no Xen override, use qemu output device */
-    if (output == NULL) {
-        if (con->xendev.dev) {
-            qemu_chr_fe_init(&con->chr, serial_hd(con->xendev.dev),
-                             &error_abort);
+    if (!con->dev) {
+        xen_pfn_t mfn = (xen_pfn_t)con->ring_ref;
+        con->sring = qemu_xen_foreignmem_map(xendev->frontend_id, NULL,
+                                             PROT_READ | PROT_WRITE,
+                                             1, &mfn, NULL);
+        if (!con->sring) {
+            error_setg(errp, "failed to map console page");
+            return;
         }
     } else {
-        snprintf(label, sizeof(label), "xencons%d", con->xendev.dev);
-        qemu_chr_fe_init(&con->chr,
-                         /*
-                          * FIXME: sure we want to support implicit
-                          * muxed monitors here?
-                          */
-                         qemu_chr_new_mux_mon(label, output, NULL),
-                         &error_abort);
+        con->sring = xen_device_map_grant_refs(xendev,
+                                               &con->ring_ref, 1,
+                                               PROT_READ | PROT_WRITE,
+                                               errp);
+        if (!con->sring) {
+            error_prepend(errp, "failed to map grant ref: ");
+            return;
+        }
     }
 
-    store_con_info(con);
+    con->event_channel = xen_device_bind_event_channel(xendev, port,
+                                                       con_event,
+                                                       con,
+                                                       errp);
+    if (!con->event_channel) {
+        xen_console_disconnect(xendev, NULL);
+        return;
+    }
 
-out:
-    g_free(type);
-    return ret;
+    trace_xen_console_connect(con->dev, con->ring_ref, port,
+                              con->buffer.max_capacity);
+
+    qemu_chr_fe_set_handlers(&con->chr, xencons_can_receive,
+                             xencons_receive, NULL, NULL, con, NULL,
+                             true);
 }
 
-static int con_initialise(struct XenLegacyDevice *xendev)
+
+static void xen_console_frontend_changed(XenDevice *xendev,
+                                       enum xenbus_state frontend_state,
+                                       Error **errp)
 {
-    struct XenConsole *con = container_of(xendev, struct XenConsole, xendev);
-    int limit;
-
-    if (xenstore_read_int(con->console, "ring-ref", &con->ring_ref) == -1)
-        return -1;
-    if (xenstore_read_int(con->console, "port", &con->xendev.remote_port) == -1)
-        return -1;
-    if (xenstore_read_int(con->console, "limit", &limit) == 0)
-        con->buffer.max_capacity = limit;
+    ERRP_GUARD();
+    enum xenbus_state backend_state = xen_device_backend_get_state(xendev);
+
+    switch (frontend_state) {
+    case XenbusStateInitialised:
+    case XenbusStateConnected:
+        if (backend_state == XenbusStateConnected) {
+            break;
+        }
 
-    if (!xendev->dev) {
-        xen_pfn_t mfn = con->ring_ref;
-        con->sring = qemu_xen_foreignmem_map(con->xendev.dom, NULL,
-                                             PROT_READ | PROT_WRITE,
-                                             1, &mfn, NULL);
-    } else {
-        con->sring = xen_be_map_grant_ref(xendev, con->ring_ref,
-                                          PROT_READ | PROT_WRITE);
+        xen_console_disconnect(xendev, errp);
+        if (*errp) {
+            break;
+        }
+
+        xen_console_connect(xendev, errp);
+        if (*errp) {
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
+        xen_console_disconnect(xendev, errp);
+        if (*errp) {
+            break;
+        }
+
+        xen_device_backend_set_state(xendev, XenbusStateClosed);
+        break;
+
+    default:
+        break;
     }
-    if (!con->sring)
-        return -1;
+}
 
-    xen_be_bind_evtchn(&con->xendev);
-    qemu_chr_fe_set_handlers(&con->chr, xencons_can_receive,
-                             xencons_receive, NULL, NULL, con, NULL, true);
-
-    xen_pv_printf(xendev, 1,
-                  "ring mfn %d, remote port %d, local port %d, limit %zd\n",
-                  con->ring_ref,
-                  con->xendev.remote_port,
-                  con->xendev.local_port,
-                  con->buffer.max_capacity);
-    return 0;
+
+static char *xen_console_get_name(XenDevice *xendev, Error **errp)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    return g_strdup_printf("%u", con->dev);
 }
 
-static void con_disconnect(struct XenLegacyDevice *xendev)
+static void xen_console_unrealize(XenDevice *xendev)
 {
-    struct XenConsole *con = container_of(xendev, struct XenConsole, xendev);
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    trace_xen_console_unrealize(con->dev);
+
+    /* Disconnect from the frontend in case this has not already happened */
+    xen_console_disconnect(xendev, NULL);
 
     qemu_chr_fe_deinit(&con->chr, false);
-    xen_pv_unbind_evtchn(&con->xendev);
+}
+
+static void xen_console_realize(XenDevice *xendev, Error **errp)
+{
+    ERRP_GUARD();
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+    Chardev *cs = qemu_chr_fe_get_driver(&con->chr);
+    unsigned int u;
+
+    if (!cs) {
+        error_setg(errp, "no backing character device");
+        return;
+    }
+
+    if (con->dev == -1) {
+        error_setg(errp, "no device index provided");
+        return;
+    }
 
-    if (con->sring) {
-        if (!xendev->dev) {
-            qemu_xen_foreignmem_unmap(con->sring, 1);
-        } else {
-            xen_be_unmap_grant_ref(xendev, con->sring, con->ring_ref);
+    /*
+     * The Xen primary console is special. The ring-ref is actually a GFN to
+     * be mapped directly as foreignmem (not a grant ref), and the guest port
+     * was allocated *for* the guest by the toolstack. The guest gets these
+     * through HVMOP_get_param and can use the console long before it's got
+     * XenStore up and running. We cannot create those for a Xen guest.
+     */
+    if (!con->dev) {
+        if (xen_device_frontend_scanf(xendev, "ring-ref", "%u", &u) != 1 ||
+            xen_device_frontend_scanf(xendev, "port", "%u", &u) != 1) {
+            error_setg(errp, "cannot create primary Xen console");
+            return;
         }
-        con->sring = NULL;
+    }
+
+    trace_xen_console_realize(con->dev, object_get_typename(OBJECT(cs)));
+
+    if (CHARDEV_IS_PTY(cs)) {
+        /* Strip the leading 'pty:' */
+        xen_device_frontend_printf(xendev, "tty", "%s", cs->filename + 4);
+    }
+
+    /* No normal PV driver initialization for the primary console */
+    if (!con->dev) {
+        xen_console_connect(xendev, errp);
+    }
+}
+
+static char *console_frontend_path(struct qemu_xs_handle *xenstore,
+                                   unsigned int dom_id, unsigned int dev)
+{
+    if (!dev) {
+        return g_strdup_printf("/local/domain/%u/console", dom_id);
+    } else {
+        return g_strdup_printf("/local/domain/%u/device/console/%u", dom_id, dev);
     }
 }
 
-static void con_event(struct XenLegacyDevice *xendev)
+static char *xen_console_get_frontend_path(XenDevice *xendev, Error **errp)
 {
-    struct XenConsole *con = container_of(xendev, struct XenConsole, xendev);
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+    XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+    char *ret = console_frontend_path(xenbus->xsh, xendev->frontend_id,
+                                      con->dev);
 
-    buffer_append(con);
-    if (con->buffer.size - con->buffer.consumed)
-        xencons_send(con);
+    if (!ret) {
+        error_setg(errp, "failed to create frontend path");
+    }
+    return ret;
 }
 
-/* -------------------------------------------------------------------- */
 
-struct XenDevOps xen_console_ops = {
-    .size       = sizeof(struct XenConsole),
-    .flags      = DEVOPS_FLAG_IGNORE_STATE|DEVOPS_FLAG_NEED_GNTDEV,
-    .init       = con_init,
-    .initialise = con_initialise,
-    .event      = con_event,
-    .disconnect = con_disconnect,
+static Property xen_console_properties[] = {
+    DEFINE_PROP_CHR("chardev", XenConsole, chr),
+    DEFINE_PROP_INT32("idx", XenConsole, dev, -1),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void xen_console_class_init(ObjectClass *class, void *data)
+{
+    DeviceClass *dev_class = DEVICE_CLASS(class);
+    XenDeviceClass *xendev_class = XEN_DEVICE_CLASS(class);
+
+    xendev_class->backend = "console";
+    xendev_class->device = "console";
+    xendev_class->get_name = xen_console_get_name;
+    xendev_class->realize = xen_console_realize;
+    xendev_class->frontend_changed = xen_console_frontend_changed;
+    xendev_class->unrealize = xen_console_unrealize;
+    xendev_class->get_frontend_path = xen_console_get_frontend_path;
+
+    device_class_set_props(dev_class, xen_console_properties);
+}
+
+static const TypeInfo xen_console_type_info = {
+    .name = TYPE_XEN_CONSOLE_DEVICE,
+    .parent = TYPE_XEN_DEVICE,
+    .instance_size = sizeof(XenConsole),
+    .class_init = xen_console_class_init,
+};
+
+static void xen_console_register_types(void)
+{
+    type_register_static(&xen_console_type_info);
+}
+
+type_init(xen_console_register_types)
+
+/* Called to instantiate a XenConsole when the backend is detected. */
+static void xen_console_device_create(XenBackendInstance *backend,
+                                      QDict *opts, Error **errp)
+{
+    ERRP_GUARD();
+    XenBus *xenbus = xen_backend_get_bus(backend);
+    const char *name = xen_backend_get_name(backend);
+    unsigned long number;
+    char *fe_path = NULL, *type = NULL, *output = NULL;
+    char label[32];
+    XenDevice *xendev = NULL;
+    XenConsole *con;
+    Chardev *cd = NULL;
+    struct qemu_xs_handle *xsh = xenbus->xsh;
+
+    if (qemu_strtoul(name, NULL, 10, &number)) {
+        error_setg(errp, "failed to parse name '%s'", name);
+        goto fail;
+    }
+
+    trace_xen_console_device_create(number);
+
+    fe_path = console_frontend_path(xsh, xen_domid, number);
+    if (fe_path == NULL) {
+        error_setg(errp, "failed to generate frontend path");
+        goto fail;
+    }
+
+    if (xs_node_scanf(xsh, XBT_NULL, fe_path, "type", errp, "%ms", &type) != 1) {
+        error_prepend(errp, "failed to read console device type: ");
+        goto fail;
+    }
+
+    if (strcmp(type, "ioemu")) {
+        error_setg(errp, "declining to handle console type '%s'",
+                   type);
+        goto fail;
+    }
+
+    xendev = XEN_DEVICE(qdev_new(TYPE_XEN_CONSOLE_DEVICE));
+    con = XEN_CONSOLE_DEVICE(xendev);
+
+    con->dev = number;
+
+    snprintf(label, sizeof(label), "xencons%ld", number);
+
+    if (xs_node_scanf(xsh, XBT_NULL, fe_path, "output", NULL, "%ms",
+                      &output) == 1) {
+        /*
+         * FIXME: sure we want to support implicit
+         * muxed monitors here?
+         */
+        cd = qemu_chr_new_mux_mon(label, output, NULL);
+        if (!cd) {
+            error_setg(errp, "console: No valid chardev found at '%s': ",
+                       output);
+            goto fail;
+        }
+    } else if (number) {
+        cd = serial_hd(number);
+        if (!cd) {
+            error_prepend(errp, "console: No serial device #%ld found: ",
+                          number);
+            goto fail;
+        }
+    } else {
+        /* No 'output' node on primary console: use null. */
+        cd = qemu_chr_new(label, "null", NULL);
+        if (!cd) {
+            error_setg(errp, "console: failed to create null device");
+            goto fail;
+        }
+    }
+
+    if (!qemu_chr_fe_init(&con->chr, cd, errp)) {
+        error_prepend(errp, "console: failed to initialize backing chardev: ");
+        goto fail;
+    }
+
+    if (qdev_realize_and_unref(DEVICE(xendev), BUS(xenbus), errp)) {
+        xendev = NULL;
+    } else {
+        error_prepend(errp, "realization of console device %lu failed: ",
+                      number);
+        goto fail;
+    }
+
+ fail:
+    if (xendev) {
+        object_unparent(OBJECT(xendev));
+    }
+
+    g_free(fe_path);
+    free(type);
+    free(output);
+}
+
+static void xen_console_device_destroy(XenBackendInstance *backend,
+                                       Error **errp)
+{
+    ERRP_GUARD();
+    XenDevice *xendev = xen_backend_get_device(backend);
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    trace_xen_console_device_destroy(con->dev);
+
+    object_unparent(OBJECT(xendev));
+}
+
+static const XenBackendInfo xen_console_backend_info  = {
+    .type = "console",
+    .create = xen_console_device_create,
+    .destroy = xen_console_device_destroy,
 };
+
+static void xen_console_register_backend(void)
+{
+    xen_backend_register(&xen_console_backend_info);
+}
+
+xen_backend_init(xen_console_register_backend);
diff --git a/hw/xen/xen-legacy-backend.c b/hw/xen/xen-legacy-backend.c
index 4ded3cec23..124dd5f3d6 100644
--- a/hw/xen/xen-legacy-backend.c
+++ b/hw/xen/xen-legacy-backend.c
@@ -623,7 +623,6 @@ void xen_be_init(void)
 
     xen_set_dynamic_sysbus();
 
-    xen_be_register("console", &xen_console_ops);
     xen_be_register("vkbd", &xen_kbdmouse_ops);
 #ifdef CONFIG_VIRTFS
     xen_be_register("9pfs", &xen_9pfs_ops);
-- 
2.40.1

