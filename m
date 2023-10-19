Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAAA7CFE31
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346400AbjJSPlJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346356AbjJSPk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:40:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386E2138
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HpAnqIpUHaVwXa5iWHpYTFYCLZj1Y+T0PVMmr0HgVt0=; b=qoE9WPy4p0tLodU89sn1K6KZOH
        WKyBaVrLndSiy16DLnilXZzaF3uloDHYPsSrzDPTYEe+kIFqGfs5KLMtA8HG8Hs91NyXXxWuVzx7s
        dFHL7vXbL2eNxD4zF/wvaP5pg3fCmgduLWze5nEs7JcgRcKFPd8d+uqrDsGO/fqOdwvP+Jw626Yz+
        orGWQyoRtYvIGQH8lkenOd/4+aj7pYpIAjAf5q5XSvi7MP9+mA2PFVK3R4QWsk4pPeKEEHJZDzk4y
        CsCiOVQBpa+kMB4e3s44w0DsmK/sjSkci2/JRmVP2bUbPImsAXGekiJ0XN/MEAjluJBx+11ai0s2V
        oLYUSJcw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qtV8M-007osj-HC; Thu, 19 Oct 2023 15:40:26 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8M-000Pu6-0K;
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
Subject: [PATCH v2 07/24] hw/xen: Clean up event channel 'type_val' handling to use union
Date:   Thu, 19 Oct 2023 16:40:03 +0100
Message-Id: <20231019154020.99080-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231019154020.99080-1-dwmw2@infradead.org>
References: <20231019154020.99080-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

A previous implementation of this stuff used a 64-bit field for all of
the port information (vcpu/type/type_val) and did atomic exchanges on
them. When I implemented that in Qemu I regretted my life choices and
just kept it simple with locking instead.

So there's no need for the XenEvtchnPort to be so simplistic. We can
use a union for the pirq/virq/interdomain information, which lets us
keep a separate bit for the 'remote domain' in interdomain ports. A
single bit is enough since the only possible targets are loopback or
qemu itself.

So now we can ditch PORT_INFO_TYPEVAL_REMOTE_QEMU and the horrid
manual masking, although the in-memory representation is identical
so there's no change in the saved state ABI.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/kvm/xen_evtchn.c | 151 ++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 81 deletions(-)

diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index 3d6f4b4a0a..d72dca6591 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -58,7 +58,15 @@ OBJECT_DECLARE_SIMPLE_TYPE(XenEvtchnState, XEN_EVTCHN)
 typedef struct XenEvtchnPort {
     uint32_t vcpu;      /* Xen/ACPI vcpu_id */
     uint16_t type;      /* EVTCHNSTAT_xxxx */
-    uint16_t type_val;  /* pirq# / virq# / remote port according to type */
+    union {
+        uint16_t val;  /* raw value for serialization etc. */
+        uint16_t pirq;
+        uint16_t virq;
+        struct {
+            uint16_t port:15;
+            uint16_t to_qemu:1; /* Only two targets; qemu or loopback */
+        } interdomain;
+    } u;
 } XenEvtchnPort;
 
 /* 32-bit compatibility definitions, also used natively in 32-bit build */
@@ -105,14 +113,6 @@ struct xenevtchn_handle {
     int fd;
 };
 
-/*
- * For unbound/interdomain ports there are only two possible remote
- * domains; self and QEMU. Use a single high bit in type_val for that,
- * and the low bits for the remote port number (or 0 for unbound).
- */
-#define PORT_INFO_TYPEVAL_REMOTE_QEMU           0x8000
-#define PORT_INFO_TYPEVAL_REMOTE_PORT_MASK      0x7FFF
-
 /*
  * These 'emuirq' values are used by Xen in the LM stream... and yes, I am
  * insane enough to think about guest-transparent live migration from actual
@@ -210,16 +210,16 @@ static int xen_evtchn_post_load(void *opaque, int version_id)
         XenEvtchnPort *p = &s->port_table[i];
 
         if (p->type == EVTCHNSTAT_pirq) {
-            assert(p->type_val);
-            assert(p->type_val < s->nr_pirqs);
+            assert(p->u.pirq);
+            assert(p->u.pirq < s->nr_pirqs);
 
             /*
              * Set the gsi to IRQ_UNBOUND; it may be changed to an actual
              * GSI# below, or to IRQ_MSI_EMU when the MSI table snooping
              * catches up with it.
              */
-            s->pirq[p->type_val].gsi = IRQ_UNBOUND;
-            s->pirq[p->type_val].port = i;
+            s->pirq[p->u.pirq].gsi = IRQ_UNBOUND;
+            s->pirq[p->u.pirq].port = i;
         }
     }
     /* Rebuild s->pirq[].gsi mapping */
@@ -243,7 +243,7 @@ static const VMStateDescription xen_evtchn_port_vmstate = {
     .fields = (VMStateField[]) {
         VMSTATE_UINT32(vcpu, XenEvtchnPort),
         VMSTATE_UINT16(type, XenEvtchnPort),
-        VMSTATE_UINT16(type_val, XenEvtchnPort),
+        VMSTATE_UINT16(u.val, XenEvtchnPort),
         VMSTATE_END_OF_LIST()
     }
 };
@@ -605,14 +605,13 @@ static void unbind_backend_ports(XenEvtchnState *s)
 
     for (i = 1; i < s->nr_ports; i++) {
         p = &s->port_table[i];
-        if (p->type == EVTCHNSTAT_interdomain &&
-            (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU)) {
-            evtchn_port_t be_port = p->type_val & PORT_INFO_TYPEVAL_REMOTE_PORT_MASK;
+        if (p->type == EVTCHNSTAT_interdomain && p->u.interdomain.to_qemu) {
+            evtchn_port_t be_port = p->u.interdomain.port;
 
             if (s->be_handles[be_port]) {
                 /* This part will be overwritten on the load anyway. */
                 p->type = EVTCHNSTAT_unbound;
-                p->type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU;
+                p->u.interdomain.port = 0;
 
                 /* Leave the backend port open and unbound too. */
                 if (kvm_xen_has_cap(EVTCHN_SEND)) {
@@ -650,30 +649,22 @@ int xen_evtchn_status_op(struct evtchn_status *status)
 
     switch (p->type) {
     case EVTCHNSTAT_unbound:
-        if (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU) {
-            status->u.unbound.dom = DOMID_QEMU;
-        } else {
-            status->u.unbound.dom = xen_domid;
-        }
+        status->u.unbound.dom = p->u.interdomain.to_qemu ? DOMID_QEMU
+                                                         : xen_domid;
         break;
 
     case EVTCHNSTAT_interdomain:
-        if (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU) {
-            status->u.interdomain.dom = DOMID_QEMU;
-        } else {
-            status->u.interdomain.dom = xen_domid;
-        }
-
-        status->u.interdomain.port = p->type_val &
-            PORT_INFO_TYPEVAL_REMOTE_PORT_MASK;
+        status->u.interdomain.dom = p->u.interdomain.to_qemu ? DOMID_QEMU
+                                                             : xen_domid;
+        status->u.interdomain.port = p->u.interdomain.port;
         break;
 
     case EVTCHNSTAT_pirq:
-        status->u.pirq = p->type_val;
+        status->u.pirq = p->u.pirq;
         break;
 
     case EVTCHNSTAT_virq:
-        status->u.virq = p->type_val;
+        status->u.virq = p->u.virq;
         break;
     }
 
@@ -989,7 +980,7 @@ static int clear_port_pending(XenEvtchnState *s, evtchn_port_t port)
 static void free_port(XenEvtchnState *s, evtchn_port_t port)
 {
     s->port_table[port].type = EVTCHNSTAT_closed;
-    s->port_table[port].type_val = 0;
+    s->port_table[port].u.val = 0;
     s->port_table[port].vcpu = 0;
 
     if (s->nr_ports == port + 1) {
@@ -1012,7 +1003,7 @@ static int allocate_port(XenEvtchnState *s, uint32_t vcpu, uint16_t type,
         if (s->port_table[p].type == EVTCHNSTAT_closed) {
             s->port_table[p].vcpu = vcpu;
             s->port_table[p].type = type;
-            s->port_table[p].type_val = val;
+            s->port_table[p].u.val = val;
 
             *port = p;
 
@@ -1053,15 +1044,15 @@ static int close_port(XenEvtchnState *s, evtchn_port_t port,
         return -ENOENT;
 
     case EVTCHNSTAT_pirq:
-        s->pirq[p->type_val].port = 0;
-        if (s->pirq[p->type_val].is_translated) {
+        s->pirq[p->u.pirq].port = 0;
+        if (s->pirq[p->u.pirq].is_translated) {
             *flush_kvm_routes = true;
         }
         break;
 
     case EVTCHNSTAT_virq:
-        kvm_xen_set_vcpu_virq(virq_is_global(p->type_val) ? 0 : p->vcpu,
-                              p->type_val, 0);
+        kvm_xen_set_vcpu_virq(virq_is_global(p->u.virq) ? 0 : p->vcpu,
+                              p->u.virq, 0);
         break;
 
     case EVTCHNSTAT_ipi:
@@ -1071,8 +1062,8 @@ static int close_port(XenEvtchnState *s, evtchn_port_t port,
         break;
 
     case EVTCHNSTAT_interdomain:
-        if (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU) {
-            uint16_t be_port = p->type_val & ~PORT_INFO_TYPEVAL_REMOTE_QEMU;
+        if (p->u.interdomain.to_qemu) {
+            uint16_t be_port = p->u.interdomain.port;
             struct xenevtchn_handle *xc = s->be_handles[be_port];
             if (xc) {
                 if (kvm_xen_has_cap(EVTCHN_SEND)) {
@@ -1082,14 +1073,15 @@ static int close_port(XenEvtchnState *s, evtchn_port_t port,
             }
         } else {
             /* Loopback interdomain */
-            XenEvtchnPort *rp = &s->port_table[p->type_val];
-            if (!valid_port(p->type_val) || rp->type_val != port ||
+            XenEvtchnPort *rp = &s->port_table[p->u.interdomain.port];
+            if (!valid_port(p->u.interdomain.port) ||
+                rp->u.interdomain.port != port ||
                 rp->type != EVTCHNSTAT_interdomain) {
                 error_report("Inconsistent state for interdomain unbind");
             } else {
                 /* Set the other end back to unbound */
                 rp->type = EVTCHNSTAT_unbound;
-                rp->type_val = 0;
+                rp->u.interdomain.port = 0;
             }
         }
         break;
@@ -1213,7 +1205,7 @@ int xen_evtchn_bind_vcpu_op(struct evtchn_bind_vcpu *vcpu)
     if (p->type == EVTCHNSTAT_interdomain ||
         p->type == EVTCHNSTAT_unbound ||
         p->type == EVTCHNSTAT_pirq ||
-        (p->type == EVTCHNSTAT_virq && virq_is_global(p->type_val))) {
+        (p->type == EVTCHNSTAT_virq && virq_is_global(p->u.virq))) {
         /*
          * unmask_port() with do_unmask==false will just raise the event
          * on the new vCPU if the port was already pending.
@@ -1358,19 +1350,15 @@ int xen_evtchn_bind_ipi_op(struct evtchn_bind_ipi *ipi)
 int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
 {
     XenEvtchnState *s = xen_evtchn_singleton;
-    uint16_t type_val;
     int ret;
 
     if (!s) {
         return -ENOTSUP;
     }
 
-    if (interdomain->remote_dom == DOMID_QEMU) {
-        type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU;
-    } else if (interdomain->remote_dom == DOMID_SELF ||
-               interdomain->remote_dom == xen_domid) {
-        type_val = 0;
-    } else {
+    if (interdomain->remote_dom != DOMID_QEMU &&
+        interdomain->remote_dom != DOMID_SELF &&
+        interdomain->remote_dom != xen_domid) {
         return -ESRCH;
     }
 
@@ -1381,8 +1369,8 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
     qemu_mutex_lock(&s->port_lock);
 
     /* The newly allocated port starts out as unbound */
-    ret = allocate_port(s, 0, EVTCHNSTAT_unbound, type_val,
-                        &interdomain->local_port);
+    ret = allocate_port(s, 0, EVTCHNSTAT_unbound, 0, &interdomain->local_port);
+
     if (ret) {
         goto out;
     }
@@ -1407,7 +1395,8 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
             assign_kernel_eventfd(lp->type, xc->guest_port, xc->fd);
         }
         lp->type = EVTCHNSTAT_interdomain;
-        lp->type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU | interdomain->remote_port;
+        lp->u.interdomain.to_qemu = 1;
+        lp->u.interdomain.port = interdomain->remote_port;
         ret = 0;
     } else {
         /* Loopback */
@@ -1415,19 +1404,18 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
         XenEvtchnPort *lp = &s->port_table[interdomain->local_port];
 
         /*
-         * The 'remote' port for loopback must be an unbound port allocated for
-         * communication with the local domain (as indicated by rp->type_val
-         * being zero, not PORT_INFO_TYPEVAL_REMOTE_QEMU), and must *not* be
-         * the port that was just allocated for the local end.
+         * The 'remote' port for loopback must be an unbound port allocated
+         * for communication with the local domain, and must *not* be the
+         * port that was just allocated for the local end.
          */
         if (interdomain->local_port != interdomain->remote_port &&
-            rp->type == EVTCHNSTAT_unbound && rp->type_val == 0) {
+            rp->type == EVTCHNSTAT_unbound && !rp->u.interdomain.to_qemu) {
 
             rp->type = EVTCHNSTAT_interdomain;
-            rp->type_val = interdomain->local_port;
+            rp->u.interdomain.port = interdomain->local_port;
 
             lp->type = EVTCHNSTAT_interdomain;
-            lp->type_val = interdomain->remote_port;
+            lp->u.interdomain.port = interdomain->remote_port;
         } else {
             ret = -EINVAL;
         }
@@ -1446,7 +1434,6 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
 int xen_evtchn_alloc_unbound_op(struct evtchn_alloc_unbound *alloc)
 {
     XenEvtchnState *s = xen_evtchn_singleton;
-    uint16_t type_val;
     int ret;
 
     if (!s) {
@@ -1457,18 +1444,20 @@ int xen_evtchn_alloc_unbound_op(struct evtchn_alloc_unbound *alloc)
         return -ESRCH;
     }
 
-    if (alloc->remote_dom == DOMID_QEMU) {
-        type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU;
-    } else if (alloc->remote_dom == DOMID_SELF ||
-               alloc->remote_dom == xen_domid) {
-        type_val = 0;
-    } else {
+    if (alloc->remote_dom != DOMID_QEMU &&
+        alloc->remote_dom != DOMID_SELF &&
+        alloc->remote_dom != xen_domid) {
         return -EPERM;
     }
 
     qemu_mutex_lock(&s->port_lock);
 
-    ret = allocate_port(s, 0, EVTCHNSTAT_unbound, type_val, &alloc->port);
+    ret = allocate_port(s, 0, EVTCHNSTAT_unbound, 0, &alloc->port);
+
+    if (!ret && alloc->remote_dom == DOMID_QEMU) {
+        XenEvtchnPort *p = &s->port_table[alloc->port];
+        p->u.interdomain.to_qemu = 1;
+    }
 
     qemu_mutex_unlock(&s->port_lock);
 
@@ -1495,12 +1484,12 @@ int xen_evtchn_send_op(struct evtchn_send *send)
 
     switch (p->type) {
     case EVTCHNSTAT_interdomain:
-        if (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU) {
+        if (p->u.interdomain.to_qemu) {
             /*
              * This is an event from the guest to qemu itself, which is
              * serving as the driver domain.
              */
-            uint16_t be_port = p->type_val & ~PORT_INFO_TYPEVAL_REMOTE_QEMU;
+            uint16_t be_port = p->u.interdomain.port;
             struct xenevtchn_handle *xc = s->be_handles[be_port];
             if (xc) {
                 eventfd_write(xc->fd, 1);
@@ -1510,7 +1499,7 @@ int xen_evtchn_send_op(struct evtchn_send *send)
             }
         } else {
             /* Loopback interdomain ports; just a complex IPI */
-            set_port_pending(s, p->type_val);
+            set_port_pending(s, p->u.interdomain.port);
         }
         break;
 
@@ -1552,8 +1541,7 @@ int xen_evtchn_set_port(uint16_t port)
 
     /* QEMU has no business sending to anything but these */
     if (p->type == EVTCHNSTAT_virq ||
-        (p->type == EVTCHNSTAT_interdomain &&
-         (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU))) {
+        (p->type == EVTCHNSTAT_interdomain && p->u.interdomain.to_qemu)) {
         set_port_pending(s, port);
         ret = 0;
     }
@@ -2063,7 +2051,7 @@ int xen_be_evtchn_bind_interdomain(struct xenevtchn_handle *xc, uint32_t domid,
     switch (gp->type) {
     case EVTCHNSTAT_interdomain:
         /* Allow rebinding after migration, preserve port # if possible */
-        be_port = gp->type_val & ~PORT_INFO_TYPEVAL_REMOTE_QEMU;
+        be_port = gp->u.interdomain.port;
         assert(be_port != 0);
         if (!s->be_handles[be_port]) {
             s->be_handles[be_port] = xc;
@@ -2084,7 +2072,8 @@ int xen_be_evtchn_bind_interdomain(struct xenevtchn_handle *xc, uint32_t domid,
         }
 
         gp->type = EVTCHNSTAT_interdomain;
-        gp->type_val = be_port | PORT_INFO_TYPEVAL_REMOTE_QEMU;
+        gp->u.interdomain.to_qemu = 1;
+        gp->u.interdomain.port = be_port;
         xc->guest_port = guest_port;
         if (kvm_xen_has_cap(EVTCHN_SEND)) {
             assign_kernel_eventfd(gp->type, guest_port, xc->fd);
@@ -2129,7 +2118,7 @@ int xen_be_evtchn_unbind(struct xenevtchn_handle *xc, evtchn_port_t port)
         /* This should never *not* be true */
         if (gp->type == EVTCHNSTAT_interdomain) {
             gp->type = EVTCHNSTAT_unbound;
-            gp->type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU;
+            gp->u.interdomain.port = 0;
         }
 
         if (kvm_xen_has_cap(EVTCHN_SEND)) {
@@ -2283,11 +2272,11 @@ EvtchnInfoList *qmp_xen_event_list(Error **errp)
 
         info->type = p->type;
         if (p->type == EVTCHNSTAT_interdomain) {
-            info->remote_domain = g_strdup((p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU) ?
+            info->remote_domain = g_strdup(p->u.interdomain.to_qemu ?
                                            "qemu" : "loopback");
-            info->target = p->type_val & PORT_INFO_TYPEVAL_REMOTE_PORT_MASK;
+            info->target = p->u.interdomain.port;
         } else {
-            info->target = p->type_val;
+            info->target = p->u.val; /* pirq# or virq# */
         }
         info->vcpu = p->vcpu;
         info->pending = test_bit(i, pending);
-- 
2.40.1

