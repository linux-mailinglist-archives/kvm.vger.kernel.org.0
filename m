Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2577CAD41
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbjJPPT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbjJPPTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:48 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6278BAB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=jwGGWJD+aiNhUio6yXXYsQeQjFRX090/8s/pV5DcAPo=; b=nTtN6JRD/EBeLKEvbsufzqlbru
        I5Y17CMSysfhnozFHuM9sbPyu6B7o38BvbjJP7YM/huwOwOmM7M69ztifXBKwRAx+0BFBQu/nSafh
        6D5Hv2f20ZHCxPY1qUHqQNx+EwO6SpBTNfmcTAyTvyd32h7REGSMT09J1UCxPWmSpYcunHlREOgEd
        mD1QhZbOwWNsw7Vpi9yQCxYy7YACIbopBij9Slp+QO4r7TG6Lj3YYB2qbVh0D0Bvjuwr2tU41hUkj
        RLpPFgm1NjcggUm8/3qf7afu4o64ishMZRotMptZIwIKC3APG/f9sfEVPIPSyV+gM5OK+VgVgnszX
        cORGT8mw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0067AL-2I;
        Mon, 16 Oct 2023 15:19:15 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNC-0005nr-0V;
        Mon, 16 Oct 2023 16:19:14 +0100
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
Subject: [PATCH 12/12] hw/xen: add support for Xen primary console in emulated mode
Date:   Mon, 16 Oct 2023 16:19:09 +0100
Message-Id: <20231016151909.22133-13-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The primary console is special because the toolstack maps a page at a
fixed GFN and also allocates the guest-side event channel. Add support
for that in emulated mode, so that we can have a primary console.

Add a *very* rudimentary stub of foriegnmem ops for emulated mode, which
supports literally nothing except a single-page mapping of the console
page. This might as well have been a hack in the xen_console driver, but
this way at least the special-casing is kept within the Xen emulation
code, and it gives us a hook for a more complete implementation if/when
we ever do need one.

Now at last we can boot the Xen PV shim and run PV kernels in QEMU.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/char/xen_console.c             |  12 ++-
 hw/i386/kvm/meson.build           |   1 +
 hw/i386/kvm/trace-events          |   2 +
 hw/i386/kvm/xen-stubs.c           |   5 +
 hw/i386/kvm/xen_gnttab.c          |  32 +++++-
 hw/i386/kvm/xen_primary_console.c | 167 ++++++++++++++++++++++++++++++
 hw/i386/kvm/xen_primary_console.h |  22 ++++
 hw/i386/kvm/xen_xenstore.c        |   9 ++
 target/i386/kvm/xen-emu.c         |  23 +++-
 9 files changed, 266 insertions(+), 7 deletions(-)
 create mode 100644 hw/i386/kvm/xen_primary_console.c
 create mode 100644 hw/i386/kvm/xen_primary_console.h

diff --git a/hw/char/xen_console.c b/hw/char/xen_console.c
index 1a0f5ed3e1..dfc4be0aa1 100644
--- a/hw/char/xen_console.c
+++ b/hw/char/xen_console.c
@@ -32,6 +32,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/qdev-properties-system.h"
 #include "hw/xen/interface/io/console.h"
+#include "hw/i386/kvm/xen_primary_console.h"
 #include "trace.h"
 
 struct buffer {
@@ -334,8 +335,8 @@ static char *xen_console_get_name(XenDevice *xendev, Error **errp)
     XenConsole *con = XEN_CONSOLE_DEVICE(xendev);
 
     if (con->dev == -1) {
+        int idx = (xen_mode == XEN_EMULATE) ? 0 : 1;
         char name[11];
-        int idx = 1;
 
         /* Theoretically we could go up to INT_MAX here but that's overkill */
         while (idx < 100) {
@@ -386,10 +387,13 @@ static void xen_console_realize(XenDevice *xendev, Error **errp)
      * be mapped directly as foreignmem (not a grant ref), and the guest port
      * was allocated *for* the guest by the toolstack. The guest gets these
      * through HVMOP_get_param and can use the console long before it's got
-     * XenStore up and running. We cannot create those for a Xen guest.
+     * XenStore up and running. We cannot create those for a true Xen guest,
+     * but we can for Xen emulation.
      */
     if (!con->dev) {
-        if (xen_device_frontend_scanf(xendev, "ring-ref", "%u", &u) != 1 ||
+        if (xen_mode == XEN_EMULATE) {
+            xen_primary_console_create();
+        } else if (xen_device_frontend_scanf(xendev, "ring-ref", "%u", &u) != 1 ||
             xen_device_frontend_scanf(xendev, "port", "%u", &u) != 1) {
             error_setg(errp, "cannot create primary Xen console");
             return;
@@ -404,7 +408,7 @@ static void xen_console_realize(XenDevice *xendev, Error **errp)
     }
 
     /* No normal PV driver initialization for the primary console */
-    if (!con->dev) {
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
index ae406e0b02..10068970fe 100644
--- a/hw/i386/kvm/xen-stubs.c
+++ b/hw/i386/kvm/xen-stubs.c
@@ -15,6 +15,7 @@
 #include "qapi/qapi-commands-misc-target.h"
 
 #include "xen_evtchn.h"
+#include "xen_primary_console.h"
 
 void xen_evtchn_snoop_msi(PCIDevice *dev, bool is_msix, unsigned int vector,
                           uint64_t addr, uint32_t data, bool is_masked)
@@ -30,6 +31,10 @@ bool xen_evtchn_deliver_pirq_msi(uint64_t address, uint32_t data)
     return false;
 }
 
+void xen_primary_console_create(void)
+{
+}
+
 #ifdef TARGET_I386
 EvtchnInfoList *qmp_xen_event_list(Error **errp)
 {
diff --git a/hw/i386/kvm/xen_gnttab.c b/hw/i386/kvm/xen_gnttab.c
index 21c30e3659..ea201cd582 100644
--- a/hw/i386/kvm/xen_gnttab.c
+++ b/hw/i386/kvm/xen_gnttab.c
@@ -25,6 +25,7 @@
 #include "hw/xen/xen_backend_ops.h"
 #include "xen_overlay.h"
 #include "xen_gnttab.h"
+#include "xen_primary_console.h"
 
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_xen.h"
@@ -38,6 +39,7 @@ OBJECT_DECLARE_SIMPLE_TYPE(XenGnttabState, XEN_GNTTAB)
 #define ENTRIES_PER_FRAME_V1 (XEN_PAGE_SIZE / sizeof(grant_entry_v1_t))
 
 static struct gnttab_backend_ops emu_gnttab_backend_ops;
+static struct foreignmem_backend_ops emu_foreignmem_backend_ops;
 
 struct XenGnttabState {
     /*< private >*/
@@ -100,6 +102,7 @@ static void xen_gnttab_realize(DeviceState *dev, Error **errp)
     s->map_track = g_new0(uint8_t, s->max_frames * ENTRIES_PER_FRAME_V1);
 
     xen_gnttab_ops = &emu_gnttab_backend_ops;
+    xen_foreignmem_ops = &emu_foreignmem_backend_ops;
 }
 
 static int xen_gnttab_post_load(void *opaque, int version_id)
@@ -524,6 +527,29 @@ static struct gnttab_backend_ops emu_gnttab_backend_ops = {
     .unmap = xen_be_gnttab_unmap,
 };
 
+/* Dummy implementation of foriegnmem; just enough for console */
+static void *xen_be_foreignmem_map(uint32_t dom, void *addr, int prot,
+                                   size_t pages, xen_pfn_t *pfns,
+                                   int *errs)
+{
+    if (dom == xen_domid && !addr && pages == 1 &&
+        pfns[0] == xen_primary_console_get_pfn()) {
+        return xen_primary_console_get_map();
+    }
+
+    return NULL;
+}
+
+static int xen_be_foreignmem_unmap(void *addr, size_t pages)
+{
+    return 0;
+}
+
+static struct foreignmem_backend_ops emu_foreignmem_backend_ops = {
+    .map = xen_be_foreignmem_map,
+    .unmap = xen_be_foreignmem_unmap,
+};
+
 int xen_gnttab_reset(void)
 {
     XenGnttabState *s = xen_gnttab_singleton;
@@ -537,10 +563,14 @@ int xen_gnttab_reset(void)
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
     memset(s->map_track, 0, s->max_frames * ENTRIES_PER_FRAME_V1);
 
     return 0;
diff --git a/hw/i386/kvm/xen_primary_console.c b/hw/i386/kvm/xen_primary_console.c
new file mode 100644
index 0000000000..0aa1c16ad6
--- /dev/null
+++ b/hw/i386/kvm/xen_primary_console.c
@@ -0,0 +1,167 @@
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
+    alloc_guest_port(s);
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
index 0000000000..dd4922f3f4
--- /dev/null
+++ b/hw/i386/kvm/xen_primary_console.h
@@ -0,0 +1,22 @@
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
+uint64_t xen_primary_console_get_pfn(void);
+void *xen_primary_console_get_map(void);
+
+#endif /* QEMU_XEN_PRIMARY_CONSOLE_H */
diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index 3300e0614a..9f8946e0ce 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -25,6 +25,7 @@
 #include "hw/xen/xen_backend_ops.h"
 #include "xen_overlay.h"
 #include "xen_evtchn.h"
+#include "xen_primary_console.h"
 #include "xen_xenstore.h"
 
 #include "sysemu/kvm.h"
@@ -1432,6 +1433,7 @@ static void alloc_guest_port(XenXenstoreState *s)
 int xen_xenstore_reset(void)
 {
     XenXenstoreState *s = xen_xenstore_singleton;
+    int console_port;
     GList *perms;
     int err;
 
@@ -1467,6 +1469,13 @@ int xen_xenstore_reset(void)
     relpath_printf(s, perms, "store/ring-ref", "%lu", XEN_SPECIAL_PFN(XENSTORE));
     relpath_printf(s, perms, "store/port", "%u", s->be_port);
 
+    console_port = xen_primary_console_get_port();
+    if (console_port) {
+        relpath_printf(s, perms, "console/ring-ref", "%lu", XEN_SPECIAL_PFN(CONSOLE));
+        relpath_printf(s, perms, "console/port", "%u", console_port);
+        relpath_printf(s, perms, "console/state", "%u", XenbusStateInitialised);
+    }
+
     g_list_free_full(perms, g_free);
 
     /*
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index 477e93cd92..9f57786e95 100644
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
@@ -811,11 +813,23 @@ static bool handle_get_param(struct kvm_xen_exit *exit, X86CPU *cpu,
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
@@ -1426,6 +1440,11 @@ int kvm_xen_soft_reset(void)
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
2.40.1

