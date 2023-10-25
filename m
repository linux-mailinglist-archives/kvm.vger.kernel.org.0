Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C77F7D6FDF
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344465AbjJYOvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344480AbjJYOve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9515B10FC
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=auoyj1xEgaC8bMi0O7YUpQ0rx3BFjT2lyRCJL3y5wnE=; b=f9MCdDvLs+qhwkY0BLNlfs14jT
        yrufAYA9JVI6q35igUctpZ6mzrMYX7I5p9/s6ghbctBLFRaMt/6qiW7JclxMDG8Q1UnjnvEaWzbAg
        YN4r3n/mx+izvC/7zFhlKoaYMdVN5utuEXqi09ru8grPMQrP1B5UsCNbiLaR/C6mBBGpd2rjMig2J
        H3xaLdbmoQUfqN4wMM9ZuzOJXVF358Nug7RCgfVzNBsGiH8aM9hCh3VKZ74Xbau3LKG4qSvXEdaFb
        L/Lu1nKwEOPY1Pt9RFQxjKQNPSCuly+xtT5J3Vq1Dyyr2b8emQVdjD2Lkx9zslYfVFoTFsX+hP+L7
        6bV63/wA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDa-00GPM2-1E;
        Wed, 25 Oct 2023 14:50:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDY-002dF1-2x;
        Wed, 25 Oct 2023 15:50:44 +0100
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
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v3 16/28] hw/xen: update Xen console to XenDevice model
Date:   Wed, 25 Oct 2023 15:50:30 +0100
Message-Id: <20231025145042.627381-17-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231025145042.627381-1-dwmw2@infradead.org>
References: <20231025145042.627381-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This allows (non-primary) console devices to be created on the command
line and hotplugged.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/char/trace-events        |   8 +
 hw/char/xen_console.c       | 532 +++++++++++++++++++++++++++---------
 hw/xen/xen-legacy-backend.c |   1 -
 3 files changed, 411 insertions(+), 130 deletions(-)

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
index 810dae3f44..4a419dc287 100644
--- a/hw/char/xen_console.c
+++ b/hw/char/xen_console.c
@@ -20,15 +20,20 @@
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
+#include "hw/xen/interface/io/xs_wire.h"
+#include "trace.h"
 
 struct buffer {
     uint8_t *data;
@@ -39,16 +44,22 @@ struct buffer {
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
@@ -60,7 +71,7 @@ static void buffer_append(struct XenConsole *con)
 
     size = prod - cons;
     if ((size == 0) || (size > sizeof(intf->out)))
-        return;
+        return false;
 
     if ((buffer->capacity - buffer->size) < size) {
         buffer->capacity += (size + 1024);
@@ -73,7 +84,7 @@ static void buffer_append(struct XenConsole *con)
 
     xen_mb();
     intf->out_cons = cons;
-    xen_pv_send_notify(&con->xendev);
+    xen_device_notify_event_channel(XEN_DEVICE(con), con->event_channel, NULL);
 
     if (buffer->max_capacity &&
         buffer->size > buffer->max_capacity) {
@@ -89,6 +100,7 @@ static void buffer_append(struct XenConsole *con)
         if (buffer->consumed > buffer->max_capacity - over)
             buffer->consumed = buffer->max_capacity - over;
     }
+    return true;
 }
 
 static void buffer_advance(struct buffer *buffer, size_t len)
@@ -100,7 +112,7 @@ static void buffer_advance(struct buffer *buffer, size_t len)
     }
 }
 
-static int ring_free_bytes(struct XenConsole *con)
+static int ring_free_bytes(XenConsole *con)
 {
     struct xencons_interface *intf = con->sring;
     XENCONS_RING_IDX cons, prod, space;
@@ -118,13 +130,13 @@ static int ring_free_bytes(struct XenConsole *con)
 
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
@@ -141,10 +153,10 @@ static void xencons_receive(void *opaque, const uint8_t *buf, int len)
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
 
@@ -159,174 +171,436 @@ static void xencons_send(struct XenConsole *con)
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
+
+    if (xen_device_backend_get_state(&con->xendev) != XenbusStateConnected) {
+        return false;
+    }
+
+    done_something = buffer_append(con);
+
+    if (con->buffer.size - con->buffer.consumed) {
+        done_something |= xencons_send(con);
+    }
+    return done_something;
+}
+
+/* -------------------------------------------------------------------- */
+
+static bool xen_console_connect(XenDevice *xendev, Error **errp)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+    unsigned int port, limit;
+
+    if (xen_device_frontend_scanf(xendev, "ring-ref", "%u",
+                                  &con->ring_ref) != 1) {
+        error_setg(errp, "failed to read ring-ref");
+        return false;
+    }
 
-    /* Only continue if we're talking to a pty. */
-    if (!CHARDEV_IS_PTY(cs)) {
-        return 0;
+    if (xen_device_frontend_scanf(xendev, "port", "%u", &port) != 1) {
+        error_setg(errp, "failed to read remote port");
+        return false;
     }
-    pts = cs->filename + 4;
 
-    dom_path = qemu_xen_xs_get_domain_path(xenstore, xen_domid);
-    if (!dom_path) {
-        return 0;
+    if (xen_device_frontend_scanf(xendev, "limit", "%u", &limit) == 1) {
+        con->buffer.max_capacity = limit;
     }
 
-    path = g_string_new(dom_path);
-    free(dom_path);
+    con->event_channel = xen_device_bind_event_channel(xendev, port,
+                                                       con_event,
+                                                       con,
+                                                       errp);
+    if (!con->event_channel) {
+        return false;
+    }
 
-    if (con->xendev.dev) {
-        g_string_append_printf(path, "/device/console/%d", con->xendev.dev);
+    if (!con->dev) {
+        xen_pfn_t mfn = (xen_pfn_t)con->ring_ref;
+        con->sring = qemu_xen_foreignmem_map(xendev->frontend_id, NULL,
+                                             PROT_READ | PROT_WRITE,
+                                             1, &mfn, NULL);
+        if (!con->sring) {
+            error_setg(errp, "failed to map console page");
+            return false;
+        }
     } else {
-        g_string_append(path, "/console");
+        con->sring = xen_device_map_grant_refs(xendev,
+                                               &con->ring_ref, 1,
+                                               PROT_READ | PROT_WRITE,
+                                               errp);
+        if (!con->sring) {
+            error_prepend(errp, "failed to map grant ref: ");
+            return false;
+        }
     }
-    g_string_append(path, "/tty");
 
-    if (xenstore_write_str(con->console, path->str, pts)) {
-        fprintf(stderr, "xenstore_write_str for '%s' fail", path->str);
-        return -1;
+    trace_xen_console_connect(con->dev, con->ring_ref, port,
+                              con->buffer.max_capacity);
+
+    qemu_chr_fe_set_handlers(&con->chr, xencons_can_receive,
+                             xencons_receive, NULL, NULL, con, NULL,
+                             true);
+    return true;
+}
+
+static void xen_console_disconnect(XenDevice *xendev, Error **errp)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    trace_xen_console_disconnect(con->dev);
+
+    qemu_chr_fe_set_handlers(&con->chr, NULL, NULL, NULL, NULL,
+                             con, NULL, true);
+
+    if (con->event_channel) {
+        xen_device_unbind_event_channel(xendev, con->event_channel,
+                                        errp);
+        con->event_channel = NULL;
+    }
+
+    if (con->sring) {
+        if (!con->dev) {
+            qemu_xen_foreignmem_unmap(con->sring, 1);
+        } else {
+            xen_device_unmap_grant_refs(xendev, con->sring,
+                                        &con->ring_ref, 1, errp);
+        }
+        con->sring = NULL;
     }
-    return 0;
 }
 
-static int con_init(struct XenLegacyDevice *xendev)
+static void xen_console_frontend_changed(XenDevice *xendev,
+                                         enum xenbus_state frontend_state,
+                                         Error **errp)
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
+    ERRP_GUARD();
+    enum xenbus_state backend_state = xen_device_backend_get_state(xendev);
+
+    switch (frontend_state) {
+    case XenbusStateInitialised:
+    case XenbusStateConnected:
+        if (backend_state == XenbusStateConnected) {
+            break;
+        }
+
+        xen_console_disconnect(xendev, errp);
+        if (*errp) {
+            break;
+        }
+
+        if (!xen_console_connect(xendev, errp)) {
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
-    free(dom);
+}
 
-    type = xenstore_read_str(con->console, "type");
-    if (!type || strcmp(type, "ioemu") != 0) {
-        xen_pv_printf(xendev, 1, "not for me (type=%s)\n", type);
-        ret = -1;
-        goto out;
+static char *xen_console_get_name(XenDevice *xendev, Error **errp)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    if (con->dev == -1) {
+        XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+        char fe_path[XENSTORE_ABS_PATH_MAX + 1];
+        char *value;
+        int idx = 1;
+
+        /* Theoretically we could go up to INT_MAX here but that's overkill */
+        while (idx < 100) {
+            snprintf(fe_path, sizeof(fe_path),
+                     "/local/domain/%u/device/console/%u",
+                     xendev->frontend_id, idx);
+            value = qemu_xen_xs_read(xenbus->xsh, XBT_NULL, fe_path, NULL);
+            if (!value) {
+                if (errno == ENOENT) {
+                    con->dev = idx;
+                    goto found;
+                }
+                error_setg(errp, "cannot read %s: %s", fe_path,
+                           strerror(errno));
+                return NULL;
+            }
+            free(value);
+            idx++;
+        }
+        error_setg(errp, "cannot find device index for console device");
+        return NULL;
     }
+ found:
+    return g_strdup_printf("%u", con->dev);
+}
+
+static void xen_console_unrealize(XenDevice *xendev)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+
+    trace_xen_console_unrealize(con->dev);
 
-    output = xenstore_read_str(con->console, "output");
+    /* Disconnect from the frontend in case this has not already happened */
+    xen_console_disconnect(xendev, NULL);
 
-    /* no Xen override, use qemu output device */
-    if (output == NULL) {
-        if (con->xendev.dev) {
-            qemu_chr_fe_init(&con->chr, serial_hd(con->xendev.dev),
-                             &error_abort);
+    qemu_chr_fe_deinit(&con->chr, false);
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
+
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
     } else {
-        snprintf(label, sizeof(label), "xencons%d", con->xendev.dev);
-        qemu_chr_fe_init(&con->chr,
-                         /*
-                          * FIXME: sure we want to support implicit
-                          * muxed monitors here?
-                          */
-                         qemu_chr_new_mux_mon(label, output, NULL),
-                         &error_abort);
+        return g_strdup_printf("/local/domain/%u/device/console/%u", dom_id,
+                               dev);
     }
+}
 
-    store_con_info(con);
+static char *xen_console_get_frontend_path(XenDevice *xendev, Error **errp)
+{
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
+    XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+    char *ret = console_frontend_path(xenbus->xsh, xendev->frontend_id,
+                                      con->dev);
 
-out:
-    g_free(type);
+    if (!ret) {
+        error_setg(errp, "failed to create frontend path");
+    }
     return ret;
 }
 
-static int con_initialise(struct XenLegacyDevice *xendev)
+
+static Property xen_console_properties[] = {
+    DEFINE_PROP_CHR("chardev", XenConsole, chr),
+    DEFINE_PROP_INT32("idx", XenConsole, dev, -1),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void xen_console_class_init(ObjectClass *class, void *data)
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
 
-    if (!xendev->dev) {
-        xen_pfn_t mfn = con->ring_ref;
-        con->sring = qemu_xen_foreignmem_map(con->xendev.dom, NULL,
-                                             PROT_READ | PROT_WRITE,
-                                             1, &mfn, NULL);
-    } else {
-        con->sring = xen_be_map_grant_ref(xendev, con->ring_ref,
-                                          PROT_READ | PROT_WRITE);
-    }
-    if (!con->sring)
-        return -1;
+static const TypeInfo xen_console_type_info = {
+    .name = TYPE_XEN_CONSOLE_DEVICE,
+    .parent = TYPE_XEN_DEVICE,
+    .instance_size = sizeof(XenConsole),
+    .class_init = xen_console_class_init,
+};
 
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
+static void xen_console_register_types(void)
+{
+    type_register_static(&xen_console_type_info);
 }
 
-static void con_disconnect(struct XenLegacyDevice *xendev)
+type_init(xen_console_register_types)
+
+/* Called to instantiate a XenConsole when the backend is detected. */
+static void xen_console_device_create(XenBackendInstance *backend,
+                                      QDict *opts, Error **errp)
 {
-    struct XenConsole *con = container_of(xendev, struct XenConsole, xendev);
+    ERRP_GUARD();
+    XenBus *xenbus = xen_backend_get_bus(backend);
+    const char *name = xen_backend_get_name(backend);
+    unsigned long number;
+    char *fe = NULL, *type = NULL, *output = NULL;
+    char label[32];
+    XenDevice *xendev = NULL;
+    XenConsole *con;
+    Chardev *cd = NULL;
+    struct qemu_xs_handle *xsh = xenbus->xsh;
+
+    if (qemu_strtoul(name, NULL, 10, &number) || number > INT_MAX) {
+        error_setg(errp, "failed to parse name '%s'", name);
+        goto fail;
+    }
 
-    qemu_chr_fe_deinit(&con->chr, false);
-    xen_pv_unbind_evtchn(&con->xendev);
+    trace_xen_console_device_create(number);
 
-    if (con->sring) {
-        if (!xendev->dev) {
-            qemu_xen_foreignmem_unmap(con->sring, 1);
-        } else {
-            xen_be_unmap_grant_ref(xendev, con->sring, con->ring_ref);
+    fe = console_frontend_path(xsh, xen_domid, number);
+    if (fe == NULL) {
+        error_setg(errp, "failed to generate frontend path");
+        goto fail;
+    }
+
+    if (xs_node_scanf(xsh, XBT_NULL, fe, "type", errp, "%ms", &type) != 1) {
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
+    if (xs_node_scanf(xsh, XBT_NULL, fe, "output", NULL, "%ms", &output) == 1) {
+        /*
+         * FIXME: sure we want to support implicit
+         * muxed monitors here?
+         */
+        cd = qemu_chr_new_mux_mon(label, output, NULL);
+        if (!cd) {
+            error_setg(errp, "console: No valid chardev found at '%s': ",
+                       output);
+            goto fail;
         }
-        con->sring = NULL;
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
+        xen_backend_set_device(backend, xendev);
+        goto done;
+    }
+
+    error_prepend(errp, "realization of console device %lu failed: ",
+                  number);
+
+ fail:
+    if (xendev) {
+        object_unparent(OBJECT(xendev));
     }
+ done:
+    g_free(fe);
+    free(type);
+    free(output);
 }
 
-static void con_event(struct XenLegacyDevice *xendev)
+static void xen_console_device_destroy(XenBackendInstance *backend,
+                                       Error **errp)
 {
-    struct XenConsole *con = container_of(xendev, struct XenConsole, xendev);
+    ERRP_GUARD();
+    XenDevice *xendev = xen_backend_get_device(backend);
+    XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
 
-    buffer_append(con);
-    if (con->buffer.size - con->buffer.consumed)
-        xencons_send(con);
-}
+    trace_xen_console_device_destroy(con->dev);
 
-/* -------------------------------------------------------------------- */
+    object_unparent(OBJECT(xendev));
+}
 
-struct XenDevOps xen_console_ops = {
-    .size       = sizeof(struct XenConsole),
-    .flags      = DEVOPS_FLAG_IGNORE_STATE|DEVOPS_FLAG_NEED_GNTDEV,
-    .init       = con_init,
-    .initialise = con_initialise,
-    .event      = con_event,
-    .disconnect = con_disconnect,
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

