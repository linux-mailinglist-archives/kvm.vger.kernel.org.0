Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DF87CAD39
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjJPPTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 11:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjJPPTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 11:19:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA07AB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 08:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TdW7pWLHlLv278eB+Yc1VQQLRAc6P36ZNDdKDPh28m0=; b=RGDymOaeG8K1D/v44ruA5TZh8q
        yIisakCcpuamBOij8UlBgpYUEpR1D1wEBLaWOSU+ss27q//FiVgfKJeg7VS8pbyC9PsQmXmwnrOmW
        o5iVb9ww1iBkPJhyOi7Sc43Xfr7YBbFVdfusAPOOwRATZNOM2ObJhyC7K66YjP+S5gUOdMo0pr9mK
        Jo+USZWvusMx/TNmvhcGTcsrSwDS5+1Z1bYJmgYpEilt7n2HkBGrvg+D7T8zHfi73sb2dEblB7LX2
        iNt0YZiJQwK3W1lkbDeL4VfcIg9XkLaUoqSE48WawQUxp9Q87L69aiRbTfJZJYSkjK1T/tBHXRNPD
        lvQikPAQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNB-0067AJ-2F;
        Mon, 16 Oct 2023 15:19:15 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPNC-0005ne-0D;
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
Subject: [PATCH 09/12] hw/xen: prevent duplicate device registrations
Date:   Mon, 16 Oct 2023 16:19:06 +0100
Message-Id: <20231016151909.22133-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231016151909.22133-1-dwmw2@infradead.org>
References: <20231016151909.22133-1-dwmw2@infradead.org>
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

Ensure that we have a XenBackendInstance for every device regardless
of whether it was "discovered" in XenStore or created directly in QEMU.

This allows the backend_list to be a source of truth about whether a
given backend exists, and allows us to reject duplicates.

This also cleans up the fact that backend drivers were calling
xen_backend_set_device() with a XenDevice immediately after calling
qdev_realize_and_unref() on it, when it wasn't theirs to play with any
more.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/block/xen-block.c         |  1 -
 hw/char/xen_console.c        |  2 +-
 hw/xen/xen-backend.c         | 78 ++++++++++++++++++++++++++----------
 hw/xen/xen-bus.c             |  8 ++++
 include/hw/xen/xen-backend.h |  3 ++
 5 files changed, 69 insertions(+), 23 deletions(-)

diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
index a07cd7eb5d..9262338535 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -975,7 +975,6 @@ static void xen_block_device_create(XenBackendInstance *backend,
         goto fail;
     }
 
-    xen_backend_set_device(backend, xendev);
     return;
 
 fail:
diff --git a/hw/char/xen_console.c b/hw/char/xen_console.c
index bd20be116c..2825b8c511 100644
--- a/hw/char/xen_console.c
+++ b/hw/char/xen_console.c
@@ -468,7 +468,7 @@ static void xen_console_device_create(XenBackendInstance *backend,
     Chardev *cd = NULL;
     struct qemu_xs_handle *xsh = xenbus->xsh;
 
-    if (qemu_strtoul(name, NULL, 10, &number)) {
+    if (qemu_strtoul(name, NULL, 10, &number) || number >= INT_MAX) {
         error_setg(errp, "failed to parse name '%s'", name);
         goto fail;
     }
diff --git a/hw/xen/xen-backend.c b/hw/xen/xen-backend.c
index b9bf70a9f5..dcb4329258 100644
--- a/hw/xen/xen-backend.c
+++ b/hw/xen/xen-backend.c
@@ -101,22 +101,28 @@ static XenBackendInstance *xen_backend_list_find(XenDevice *xendev)
     return NULL;
 }
 
-bool xen_backend_exists(const char *type, const char *name)
+static XenBackendInstance *xen_backend_lookup(const XenBackendImpl *impl, const char *name)
 {
-    const XenBackendImpl *impl = xen_backend_table_lookup(type);
     XenBackendInstance *backend;
 
-    if (!impl) {
-        return false;
-    }
-
     QLIST_FOREACH(backend, &backend_list, entry) {
         if (backend->impl == impl && !strcmp(backend->name, name)) {
-            return true;
+            return backend;
         }
     }
 
-    return false;
+    return NULL;
+}
+
+bool xen_backend_exists(const char *type, const char *name)
+{
+    const XenBackendImpl *impl = xen_backend_table_lookup(type);
+
+    if (!impl) {
+        return false;
+    }
+
+    return !!xen_backend_lookup(impl, name);
 }
 
 static void xen_backend_list_remove(XenBackendInstance *backend)
@@ -138,11 +144,10 @@ void xen_backend_device_create(XenBus *xenbus, const char *type,
     backend = g_new0(XenBackendInstance, 1);
     backend->xenbus = xenbus;
     backend->name = g_strdup(name);
-
-    impl->create(backend, opts, errp);
-
     backend->impl = impl;
     xen_backend_list_add(backend);
+
+    impl->create(backend, opts, errp);
 }
 
 XenBus *xen_backend_get_bus(XenBackendInstance *backend)
@@ -155,13 +160,6 @@ const char *xen_backend_get_name(XenBackendInstance *backend)
     return backend->name;
 }
 
-void xen_backend_set_device(XenBackendInstance *backend,
-                            XenDevice *xendev)
-{
-    g_assert(!backend->xendev);
-    backend->xendev = xendev;
-}
-
 XenDevice *xen_backend_get_device(XenBackendInstance *backend)
 {
     return backend->xendev;
@@ -178,9 +176,7 @@ bool xen_backend_try_device_destroy(XenDevice *xendev, Error **errp)
     }
 
     impl = backend->impl;
-    if (backend->xendev) {
-        impl->destroy(backend, errp);
-    }
+    impl->destroy(backend, errp);
 
     xen_backend_list_remove(backend);
     g_free(backend->name);
@@ -188,3 +184,43 @@ bool xen_backend_try_device_destroy(XenDevice *xendev, Error **errp)
 
     return true;
 }
+
+bool xen_backend_device_realized(XenDevice *xendev, Error **errp)
+{
+    XenDeviceClass *xendev_class = XEN_DEVICE_GET_CLASS(xendev);
+    const char *type = xendev_class->backend ? : object_get_typename(OBJECT(xendev));
+    const XenBackendImpl *impl = xen_backend_table_lookup(type);
+    XenBackendInstance *backend;
+
+    if (!impl) {
+        return false;
+    }
+
+    backend = xen_backend_lookup(impl, xendev->name);
+    if (backend) {
+        if (backend->xendev && backend->xendev != xendev) {
+            error_setg(errp, "device %s/%s already exists", type, xendev->name);
+            return false;
+        }
+        backend->xendev = xendev;
+        return true;
+    }
+
+    backend = g_new0(XenBackendInstance, 1);
+    backend->xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+    backend->xendev = xendev;
+    backend->name = g_strdup(xendev->name);
+    backend->impl = impl;
+
+    xen_backend_list_add(backend);
+    return true;
+}
+
+void xen_backend_device_unrealized(XenDevice *xendev)
+{
+    XenBackendInstance *backend = xen_backend_list_find(xendev);
+
+    if (backend) {
+        backend->xendev = NULL;
+    }
+}
diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
index 0da2aa219a..0b232d1f94 100644
--- a/hw/xen/xen-bus.c
+++ b/hw/xen/xen-bus.c
@@ -359,6 +359,8 @@ static void xen_bus_realize(BusState *bus, Error **errp)
 
     g_free(type);
     g_free(key);
+
+    xen_bus_enumerate(xenbus);
     return;
 
 fail:
@@ -958,6 +960,8 @@ static void xen_device_unrealize(DeviceState *dev)
 
     trace_xen_device_unrealize(type, xendev->name);
 
+    xen_backend_device_unrealized(xendev);
+
     if (xendev->exit.notify) {
         qemu_remove_exit_notifier(&xendev->exit);
         xendev->exit.notify = NULL;
@@ -1024,6 +1028,10 @@ static void xen_device_realize(DeviceState *dev, Error **errp)
         goto unrealize;
     }
 
+    if (!xen_backend_device_realized(xendev, errp)) {
+        goto unrealize;
+    }
+
     trace_xen_device_realize(type, xendev->name);
 
     xendev->xsh = qemu_xen_xs_open();
diff --git a/include/hw/xen/xen-backend.h b/include/hw/xen/xen-backend.h
index 0f01631ae7..3f1e764c51 100644
--- a/include/hw/xen/xen-backend.h
+++ b/include/hw/xen/xen-backend.h
@@ -38,4 +38,7 @@ void xen_backend_device_create(XenBus *xenbus, const char *type,
                                const char *name, QDict *opts, Error **errp);
 bool xen_backend_try_device_destroy(XenDevice *xendev, Error **errp);
 
+bool xen_backend_device_realized(XenDevice *xendev, Error **errp);
+void xen_backend_device_unrealized(XenDevice *xendev);
+
 #endif /* HW_XEN_BACKEND_H */
-- 
2.40.1

