Return-Path: <kvm+bounces-767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D17D97E2707
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 003481C20BEC
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632BB28DDB;
	Mon,  6 Nov 2023 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA8C28DB5
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:36:04 +0000 (UTC)
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF371BF
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:36:01 -0800 (PST)
X-IronPort-AV: E=Sophos;i="6.03,281,1694736000"; 
   d="scan'208";a="683074538"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 14:36:02 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id 513BF27C7FC;
	Mon,  6 Nov 2023 14:35:58 +0000 (UTC)
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:13407]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.21.17:2525] with esmtp (Farcaster)
 id 84b22f4b-16ca-48d4-8201-95492ce3a265; Mon, 6 Nov 2023 14:35:57 +0000 (UTC)
X-Farcaster-Flow-ID: 84b22f4b-16ca-48d4-8201-95492ce3a265
Received: from EX19EXOUWC001.ant.amazon.com (10.250.64.135) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 6 Nov 2023 14:35:46 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19EXOUWC001.ant.amazon.com (10.250.64.135) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.27; Mon, 6 Nov 2023 14:35:45 +0000
Received: from u3832b3a9db3152.ant.amazon.com (10.106.83.6) by
 mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Mon, 6 Nov 2023 14:35:42 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: <qemu-devel@nongnu.org>
CC: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Peter
 Maydell" <peter.maydell@linaro.org>, Stefano Stabellini
	<sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, "Paul
 Durrant" <paul@xen.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?=
	<marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, "Marcel
 Apfelbaum" <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, <qemu-block@nongnu.org>,
	<xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 10/17] hw/xen: add support for Xen primary console in emulated mode
Date: Mon, 6 Nov 2023 14:35:00 +0000
Message-ID: <20231106143507.1060610-11-dwmw2@infradead.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231106143507.1060610-1-dwmw2@infradead.org>
References: <20231106143507.1060610-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: Bulk

From: David Woodhouse <dwmw@amazon.co.uk>

The primary console is special because the toolstack maps a page into
the guest for its ring, and also allocates the guest-side event channel.
The guest's grant table is even primed to export that page using a known
grant ref#. Add support for all that in emulated mode, so that we can
have a primary console.

For reasons unclear, the backends running under real Xen don't just use
a mapping of the well-known GNTTAB_RESERVED_CONSOLE grant ref (which
would also be in the ring-ref node in XenStore). Instead, the toolstack
sets the ring-ref node of the primary console to the GFN of the guest
page. The backend is expected to handle that special case and map it
with foreignmem operations instead.

We don't have an implementation of foreignmem ops for emulated Xen mode,
so just make it map GNTTAB_RESERVED_CONSOLE instead. This would probably
work for real Xen too, but we can't work out how to make real Xen create
a primary console of type "ioemu" to make QEMU drive it, so we can't
test that; might as well leave it as it is for now under Xen.

Now at last we can boot the Xen PV shim and run PV kernels in QEMU.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/char/xen_console.c             |  78 ++++++++----
 hw/i386/kvm/meson.build           |   1 +
 hw/i386/kvm/trace-events          |   2 +
 hw/i386/kvm/xen-stubs.c           |   8 ++
 hw/i386/kvm/xen_gnttab.c          |   7 +-
 hw/i386/kvm/xen_primary_console.c | 193 ++++++++++++++++++++++++++++++
 hw/i386/kvm/xen_primary_console.h |  23 ++++
 hw/i386/kvm/xen_xenstore.c        |  10 ++
 hw/xen/xen-bus.c                  |   5 +
 include/hw/xen/xen-bus.h          |   1 +
 target/i386/kvm/xen-emu.c         |  23 +++-
 11 files changed, 328 insertions(+), 23 deletions(-)
 create mode 100644 hw/i386/kvm/xen_primary_console.c
 create mode 100644 hw/i386/kvm/xen_primary_console.h

diff --git a/hw/char/xen_console.c b/hw/char/xen_console.c
index 4a419dc287..5cbee2f184 100644
--- a/hw/char/xen_console.c
+++ b/hw/char/xen_console.c
@@ -33,6 +33,8 @@
 #include "hw/qdev-properties-system.h"
 #include "hw/xen/interface/io/console.h"
 #include "hw/xen/interface/io/xs_wire.h"
+#include "hw/xen/interface/grant_table.h"
+#include "hw/i386/kvm/xen_primary_console.h"
 #include "trace.h"
 
 struct buffer {
@@ -230,24 +232,47 @@ static bool xen_console_connect(XenDevice *xendev, Error **errp)
         return false;
     }
 
-    if (!con->dev) {
-        xen_pfn_t mfn = (xen_pfn_t)con->ring_ref;
-        con->sring = qemu_xen_foreignmem_map(xendev->frontend_id, NULL,
-                                             PROT_READ | PROT_WRITE,
-                                             1, &mfn, NULL);
-        if (!con->sring) {
-            error_setg(errp, "failed to map console page");
-            return false;
+    switch (con->dev) {
+    case 0:
+        /*
+         * The primary console is special. For real Xen the ring-ref is
+         * actually a GFN which needs to be mapped as foreignmem.
+         */
+        if (xen_mode != XEN_EMULATE) {
+            xen_pfn_t mfn = (xen_pfn_t)con->ring_ref;
+            con->sring = qemu_xen_foreignmem_map(xendev->frontend_id, NULL,
+                                                 PROT_READ | PROT_WRITE,
+                                                 1, &mfn, NULL);
+            if (!con->sring) {
+                error_setg(errp, "failed to map console page");
+                return false;
+            }
+            break;
         }
-    } else {
+
+        /*
+         * For Xen emulation, we still follow the convention of ring-ref
+         * holding the GFN, but we map the fixed GNTTAB_RESERVED_CONSOLE
+         * grant ref because there is no implementation of foreignmem
+         * operations for emulated mode. The emulation code which handles
+         * the guest-side page and event channel also needs to be informed
+         * of the backend event channel port, in order to reconnect to it
+         * after a soft reset.
+         */
+        xen_primary_console_set_be_port(
+            xen_event_channel_get_local_port(con->event_channel));
+        con->ring_ref = GNTTAB_RESERVED_CONSOLE;
+        /* fallthrough */
+    default:
         con->sring = xen_device_map_grant_refs(xendev,
                                                &con->ring_ref, 1,
                                                PROT_READ | PROT_WRITE,
                                                errp);
         if (!con->sring) {
-            error_prepend(errp, "failed to map grant ref: ");
+            error_prepend(errp, "failed to map console grant ref: ");
             return false;
         }
+        break;
     }
 
     trace_xen_console_connect(con->dev, con->ring_ref, port,
@@ -272,10 +297,14 @@ static void xen_console_disconnect(XenDevice *xendev, Error **errp)
         xen_device_unbind_event_channel(xendev, con->event_channel,
                                         errp);
         con->event_channel = NULL;
+
+        if (xen_mode == XEN_EMULATE && !con->dev) {
+            xen_primary_console_set_be_port(0);
+        }
     }
 
     if (con->sring) {
-        if (!con->dev) {
+        if (!con->dev && xen_mode != XEN_EMULATE) {
             qemu_xen_foreignmem_unmap(con->sring, 1);
         } else {
             xen_device_unmap_grant_refs(xendev, con->sring,
@@ -338,14 +367,19 @@ static char *xen_console_get_name(XenDevice *xendev, Error **errp)
     if (con->dev == -1) {
         XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
         char fe_path[XENSTORE_ABS_PATH_MAX + 1];
+        int idx = (xen_mode == XEN_EMULATE) ? 0 : 1;
         char *value;
-        int idx = 1;
 
         /* Theoretically we could go up to INT_MAX here but that's overkill */
         while (idx < 100) {
-            snprintf(fe_path, sizeof(fe_path),
-                     "/local/domain/%u/device/console/%u",
-                     xendev->frontend_id, idx);
+            if (!idx) {
+                snprintf(fe_path, sizeof(fe_path),
+                         "/local/domain/%u/console", xendev->frontend_id);
+            } else {
+                snprintf(fe_path, sizeof(fe_path),
+                         "/local/domain/%u/device/console/%u",
+                         xendev->frontend_id, idx);
+            }
             value = qemu_xen_xs_read(xenbus->xsh, XBT_NULL, fe_path, NULL);
             if (!value) {
                 if (errno == ENOENT) {
@@ -400,11 +434,15 @@ static void xen_console_realize(XenDevice *xendev, Error **errp)
      * be mapped directly as foreignmem (not a grant ref), and the guest port
      * was allocated *for* the guest by the toolstack. The guest gets these
      * through HVMOP_get_param and can use the console long before it's got
-     * XenStore up and running. We cannot create those for a Xen guest.
+     * XenStore up and running. We cannot create those for a true Xen guest,
+     * but we can for Xen emulation.
      */
     if (!con->dev) {
-        if (xen_device_frontend_scanf(xendev, "ring-ref", "%u", &u) != 1 ||
-            xen_device_frontend_scanf(xendev, "port", "%u", &u) != 1) {
+        if (xen_mode == XEN_EMULATE) {
+            xen_primary_console_create();
+        } else if (xen_device_frontend_scanf(xendev, "ring-ref", "%u", &u)
+                   != 1 ||
+                   xen_device_frontend_scanf(xendev, "port", "%u", &u) != 1) {
             error_setg(errp, "cannot create primary Xen console");
             return;
         }
@@ -417,8 +455,8 @@ static void xen_console_realize(XenDevice *xendev, Error **errp)
         xen_device_frontend_printf(xendev, "tty", "%s", cs->filename + 4);
     }
 
-    /* No normal PV driver initialization for the primary console */
-    if (!con->dev) {
+    /* No normal PV driver initialization for the primary console under Xen */
+    if (!con->dev && xen_mode != XEN_EMULATE) {
         xen_console_connect(xendev, errp);
     }
 }
diff --git a/hw/i386/kvm/meson.build b/hw/i386/kvm/meson.build
index ab143d6474..a4a2e23c06 100644
--- a/hw/i386/kvm/meson.build
+++ b/hw/i386/kvm/meson.build
@@ -9,6 +9,7 @@ i386_kvm_ss.add(when: 'CONFIG_XEN_EMU', if_true: files(
   'xen_evtchn.c',
   'xen_gnttab.c',
   'xen_xenstore.c',
+  'xen_primary_console.c',
   'xenstore_impl.c',
   ))
 
diff --git a/hw/i386/kvm/trace-events b/hw/i386/kvm/trace-events
index e4c82de6f3..67bf7f174e 100644
--- a/hw/i386/kvm/trace-events
+++ b/hw/i386/kvm/trace-events
@@ -18,3 +18,5 @@ xenstore_watch(const char *path, const char *token) "path %s token %s"
 xenstore_unwatch(const char *path, const char *token) "path %s token %s"
 xenstore_reset_watches(void) ""
 xenstore_watch_event(const char *path, const char *token) "path %s token %s"
+xen_primary_console_create(void) ""
+xen_primary_console_reset(int port) "port %u"
diff --git a/hw/i386/kvm/xen-stubs.c b/hw/i386/kvm/xen-stubs.c
index ae406e0b02..d03131e686 100644
--- a/hw/i386/kvm/xen-stubs.c
+++ b/hw/i386/kvm/xen-stubs.c
@@ -15,6 +15,7 @@
 #include "qapi/qapi-commands-misc-target.h"
 
 #include "xen_evtchn.h"
+#include "xen_primary_console.h"
 
 void xen_evtchn_snoop_msi(PCIDevice *dev, bool is_msix, unsigned int vector,
                           uint64_t addr, uint32_t data, bool is_masked)
@@ -30,6 +31,13 @@ bool xen_evtchn_deliver_pirq_msi(uint64_t address, uint32_t data)
     return false;
 }
 
+void xen_primary_console_create(void)
+{
+}
+
+void xen_primary_console_set_be_port(uint16_t port)
+{
+}
 #ifdef TARGET_I386
 EvtchnInfoList *qmp_xen_event_list(Error **errp)
 {
diff --git a/hw/i386/kvm/xen_gnttab.c b/hw/i386/kvm/xen_gnttab.c
index 839ec920a1..0a24f53f20 100644
--- a/hw/i386/kvm/xen_gnttab.c
+++ b/hw/i386/kvm/xen_gnttab.c
@@ -25,6 +25,7 @@
 #include "hw/xen/xen_backend_ops.h"
 #include "xen_overlay.h"
 #include "xen_gnttab.h"
+#include "xen_primary_console.h"
 
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_xen.h"
@@ -537,9 +538,13 @@ int xen_gnttab_reset(void)
     s->nr_frames = 0;
 
     memset(s->entries.v1, 0, XEN_PAGE_SIZE * s->max_frames);
-
     s->entries.v1[GNTTAB_RESERVED_XENSTORE].flags = GTF_permit_access;
     s->entries.v1[GNTTAB_RESERVED_XENSTORE].frame = XEN_SPECIAL_PFN(XENSTORE);
 
+    if (xen_primary_console_get_pfn()) {
+        s->entries.v1[GNTTAB_RESERVED_CONSOLE].flags = GTF_permit_access;
+        s->entries.v1[GNTTAB_RESERVED_CONSOLE].frame = XEN_SPECIAL_PFN(CONSOLE);
+    }
+
     return 0;
 }
diff --git a/hw/i386/kvm/xen_primary_console.c b/hw/i386/kvm/xen_primary_console.c
new file mode 100644
index 0000000000..abe79f565b
--- /dev/null
+++ b/hw/i386/kvm/xen_primary_console.c
@@ -0,0 +1,193 @@
+/*
+ * QEMU Xen emulation: Primary console support
+ *
+ * Copyright © 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Authors: David Woodhouse <dwmw2@infradead.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+
+#include "qapi/error.h"
+
+#include "hw/sysbus.h"
+#include "hw/xen/xen.h"
+#include "hw/xen/xen_backend_ops.h"
+#include "xen_evtchn.h"
+#include "xen_overlay.h"
+#include "xen_primary_console.h"
+
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_xen.h"
+
+#include "trace.h"
+
+#include "hw/xen/interface/event_channel.h"
+#include "hw/xen/interface/grant_table.h"
+
+#define TYPE_XEN_PRIMARY_CONSOLE "xen-primary-console"
+OBJECT_DECLARE_SIMPLE_TYPE(XenPrimaryConsoleState, XEN_PRIMARY_CONSOLE)
+
+struct XenPrimaryConsoleState {
+    /*< private >*/
+    SysBusDevice busdev;
+    /*< public >*/
+
+    MemoryRegion console_page;
+    void *cp;
+
+    evtchn_port_t guest_port;
+    evtchn_port_t be_port;
+
+    struct xengntdev_handle *gt;
+    void *granted_xs;
+};
+
+struct XenPrimaryConsoleState *xen_primary_console_singleton;
+
+static void xen_primary_console_realize(DeviceState *dev, Error **errp)
+{
+    XenPrimaryConsoleState *s = XEN_PRIMARY_CONSOLE(dev);
+
+    if (xen_mode != XEN_EMULATE) {
+        error_setg(errp, "Xen primary console support is for Xen emulation");
+        return;
+    }
+
+    memory_region_init_ram(&s->console_page, OBJECT(dev), "xen:console_page",
+                           XEN_PAGE_SIZE, &error_abort);
+    memory_region_set_enabled(&s->console_page, true);
+    s->cp = memory_region_get_ram_ptr(&s->console_page);
+    memset(s->cp, 0, XEN_PAGE_SIZE);
+
+    /* We can't map it this early as KVM isn't ready */
+    xen_primary_console_singleton = s;
+}
+
+static void xen_primary_console_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+
+    dc->realize = xen_primary_console_realize;
+}
+
+static const TypeInfo xen_primary_console_info = {
+    .name          = TYPE_XEN_PRIMARY_CONSOLE,
+    .parent        = TYPE_SYS_BUS_DEVICE,
+    .instance_size = sizeof(XenPrimaryConsoleState),
+    .class_init    = xen_primary_console_class_init,
+};
+
+
+void xen_primary_console_create(void)
+{
+    DeviceState *dev = sysbus_create_simple(TYPE_XEN_PRIMARY_CONSOLE, -1, NULL);
+
+    trace_xen_primary_console_create();
+
+    xen_primary_console_singleton = XEN_PRIMARY_CONSOLE(dev);
+
+    /*
+     * Defer the init (xen_primary_console_reset()) until KVM is set up and the
+     * overlay page can be mapped.
+     */
+}
+
+static void xen_primary_console_register_types(void)
+{
+    type_register_static(&xen_primary_console_info);
+}
+
+type_init(xen_primary_console_register_types)
+
+uint16_t xen_primary_console_get_port(void)
+{
+    XenPrimaryConsoleState *s = xen_primary_console_singleton;
+    if (!s) {
+        return 0;
+    }
+    return s->guest_port;
+}
+
+void xen_primary_console_set_be_port(uint16_t port)
+{
+    XenPrimaryConsoleState *s = xen_primary_console_singleton;
+    if (s) {
+        s->be_port = port;
+    }
+}
+
+uint64_t xen_primary_console_get_pfn(void)
+{
+    XenPrimaryConsoleState *s = xen_primary_console_singleton;
+    if (!s) {
+        return 0;
+    }
+    return XEN_SPECIAL_PFN(CONSOLE);
+}
+
+void *xen_primary_console_get_map(void)
+{
+    XenPrimaryConsoleState *s = xen_primary_console_singleton;
+    if (!s) {
+        return 0;
+    }
+    return s->cp;
+}
+
+static void alloc_guest_port(XenPrimaryConsoleState *s)
+{
+    struct evtchn_alloc_unbound alloc = {
+        .dom = DOMID_SELF,
+        .remote_dom = DOMID_QEMU,
+    };
+
+    if (!xen_evtchn_alloc_unbound_op(&alloc)) {
+        s->guest_port = alloc.port;
+    }
+}
+
+static void rebind_guest_port(XenPrimaryConsoleState *s)
+{
+    struct evtchn_bind_interdomain inter = {
+        .remote_dom = DOMID_QEMU,
+        .remote_port = s->be_port,
+    };
+
+    if (!xen_evtchn_bind_interdomain_op(&inter)) {
+        s->guest_port = inter.local_port;
+    }
+
+    s->be_port = 0;
+}
+
+int xen_primary_console_reset(void)
+{
+    XenPrimaryConsoleState *s = xen_primary_console_singleton;
+    if (!s) {
+        return 0;
+    }
+
+    if (!memory_region_is_mapped(&s->console_page)) {
+        uint64_t gpa = XEN_SPECIAL_PFN(CONSOLE) << TARGET_PAGE_BITS;
+        xen_overlay_do_map_page(&s->console_page, gpa);
+    }
+
+    if (s->be_port) {
+        rebind_guest_port(s);
+    } else {
+        alloc_guest_port(s);
+    }
+
+    trace_xen_primary_console_reset(s->guest_port);
+
+    s->gt = qemu_xen_gnttab_open();
+    uint32_t xs_gntref = GNTTAB_RESERVED_CONSOLE;
+    s->granted_xs = qemu_xen_gnttab_map_refs(s->gt, 1, xen_domid, &xs_gntref,
+                                             PROT_READ | PROT_WRITE);
+
+    return 0;
+}
diff --git a/hw/i386/kvm/xen_primary_console.h b/hw/i386/kvm/xen_primary_console.h
new file mode 100644
index 0000000000..7e2989ea0d
--- /dev/null
+++ b/hw/i386/kvm/xen_primary_console.h
@@ -0,0 +1,23 @@
+/*
+ * QEMU Xen emulation: Primary console support
+ *
+ * Copyright © 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Authors: David Woodhouse <dwmw2@infradead.org>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+
+#ifndef QEMU_XEN_PRIMARY_CONSOLE_H
+#define QEMU_XEN_PRIMARY_CONSOLE_H
+
+void xen_primary_console_create(void);
+int xen_primary_console_reset(void);
+
+uint16_t xen_primary_console_get_port(void);
+void xen_primary_console_set_be_port(uint16_t port);
+uint64_t xen_primary_console_get_pfn(void);
+void *xen_primary_console_get_map(void);
+
+#endif /* QEMU_XEN_PRIMARY_CONSOLE_H */
diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index b7c0407765..6e651960b3 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -25,6 +25,7 @@
 #include "hw/xen/xen_backend_ops.h"
 #include "xen_overlay.h"
 #include "xen_evtchn.h"
+#include "xen_primary_console.h"
 #include "xen_xenstore.h"
 
 #include "sysemu/kvm.h"
@@ -1434,6 +1435,7 @@ static void alloc_guest_port(XenXenstoreState *s)
 int xen_xenstore_reset(void)
 {
     XenXenstoreState *s = xen_xenstore_singleton;
+    int console_port;
     GList *perms;
     int err;
 
@@ -1470,6 +1472,14 @@ int xen_xenstore_reset(void)
     relpath_printf(s, perms, "store/ring-ref", "%lu",
                    XEN_SPECIAL_PFN(XENSTORE));
 
+    console_port = xen_primary_console_get_port();
+    if (console_port) {
+        relpath_printf(s, perms, "console/ring-ref", "%lu",
+                       XEN_SPECIAL_PFN(CONSOLE));
+        relpath_printf(s, perms, "console/port", "%u", console_port);
+        relpath_printf(s, perms, "console/state", "%u", XenbusStateInitialised);
+    }
+
     g_list_free_full(perms, g_free);
 
     /*
diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
index 3ffd1a5333..cc6f1b362f 100644
--- a/hw/xen/xen-bus.c
+++ b/hw/xen/xen-bus.c
@@ -922,6 +922,11 @@ void xen_device_notify_event_channel(XenDevice *xendev,
     }
 }
 
+unsigned int xen_event_channel_get_local_port(XenEventChannel *channel)
+{
+    return channel->local_port;
+}
+
 void xen_device_unbind_event_channel(XenDevice *xendev,
                                      XenEventChannel *channel,
                                      Error **errp)
diff --git a/include/hw/xen/xen-bus.h b/include/hw/xen/xen-bus.h
index eb440880b5..38d40afa37 100644
--- a/include/hw/xen/xen-bus.h
+++ b/include/hw/xen/xen-bus.h
@@ -131,5 +131,6 @@ void xen_device_notify_event_channel(XenDevice *xendev,
 void xen_device_unbind_event_channel(XenDevice *xendev,
                                      XenEventChannel *channel,
                                      Error **errp);
+unsigned int xen_event_channel_get_local_port(XenEventChannel *channel);
 
 #endif /* HW_XEN_BUS_H */
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 1dc9ab0d91..c0631f9cf4 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -28,6 +28,7 @@
 #include "hw/i386/kvm/xen_overlay.h"
 #include "hw/i386/kvm/xen_evtchn.h"
 #include "hw/i386/kvm/xen_gnttab.h"
+#include "hw/i386/kvm/xen_primary_console.h"
 #include "hw/i386/kvm/xen_xenstore.h"
 
 #include "hw/xen/interface/version.h"
@@ -182,7 +183,8 @@ int kvm_xen_init(KVMState *s, uint32_t hypercall_msr)
         return ret;
     }
 
-    /* The page couldn't be overlaid until KVM was initialized */
+    /* The pages couldn't be overlaid until KVM was initialized */
+    xen_primary_console_reset();
     xen_xenstore_reset();
 
     return 0;
@@ -812,11 +814,23 @@ static bool handle_get_param(struct kvm_xen_exit *exit, X86CPU *cpu,
     case HVM_PARAM_STORE_EVTCHN:
         hp.value = xen_xenstore_get_port();
         break;
+    case HVM_PARAM_CONSOLE_PFN:
+        hp.value = xen_primary_console_get_pfn();
+        if (!hp.value) {
+            err = -EINVAL;
+        }
+        break;
+    case HVM_PARAM_CONSOLE_EVTCHN:
+        hp.value = xen_primary_console_get_port();
+        if (!hp.value) {
+            err = -EINVAL;
+        }
+        break;
     default:
         return false;
     }
 
-    if (kvm_copy_to_gva(cs, arg, &hp, sizeof(hp))) {
+    if (!err && kvm_copy_to_gva(cs, arg, &hp, sizeof(hp))) {
         err = -EFAULT;
     }
 out:
@@ -1427,6 +1441,11 @@ int kvm_xen_soft_reset(void)
         return err;
     }
 
+    err = xen_primary_console_reset();
+    if (err) {
+        return err;
+    }
+
     err = xen_xenstore_reset();
     if (err) {
         return err;
-- 
2.34.1


