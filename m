Return-Path: <kvm+bounces-849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 030427E37B6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 206471C209F7
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B50514F92;
	Tue,  7 Nov 2023 09:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gouk68fG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B190E12E6F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:22:23 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C7A114
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ldaWM+gDHfd6Xp3v91LJNro28chXyp7v9vtW0DR3dbc=; b=gouk68fGVvphc3/EDuizxqyQeK
	cxUOdHrGYObAyuFtxTt/yJnJgqnlKCdULHugUzAYTDZgle8QVMO2s5PbzF7JS6zAud0GoU959sQBV
	UTKwzvFcr2JMA8+bkQ993tVL/cY0Uij7Mi98UAYm3QLd+svft7DbLxBCvB2tYX4CLespbBUG17aNi
	GxgBI97FhaII5LrL90cZgmtYABfmERe9Oi6utyar8YmUtD0uhGUd8PYD3iKlbQwcRS2x2Ub6wxxim
	CLIIT3M3wl+xMhpEtNm8lwi3ei//PMU/I5maGL3Sv7UI9zmNbErOcRiF5U9GZuEdOyqlCgySZur/W
	Oef8hnvQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0IHN-00BPkL-8r; Tue, 07 Nov 2023 09:21:50 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1r0IHN-001hJy-1u;
	Tue, 07 Nov 2023 09:21:49 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: qemu-devel@nongnu.org,
	Stefan Hajnoczi <stefanha@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
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
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-block@nongnu.org,
	xen-devel@lists.xenproject.org,
	kvm@vger.kernel.org
Subject: [PULL 02/15] hw/xen: Clean up event channel 'type_val' handling to use union
Date: Tue,  7 Nov 2023 09:21:34 +0000
Message-ID: <20231107092149.404842-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231107092149.404842-1-dwmw2@infradead.org>
References: <20231107092149.404842-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

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
index b2b4be9983..02b8cbf8df 100644
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
@@ -1214,7 +1206,7 @@ int xen_evtchn_bind_vcpu_op(struct evtchn_bind_vcpu *vcpu)
     if (p->type == EVTCHNSTAT_interdomain ||
         p->type == EVTCHNSTAT_unbound ||
         p->type == EVTCHNSTAT_pirq ||
-        (p->type == EVTCHNSTAT_virq && virq_is_global(p->type_val))) {
+        (p->type == EVTCHNSTAT_virq && virq_is_global(p->u.virq))) {
         /*
          * unmask_port() with do_unmask==false will just raise the event
          * on the new vCPU if the port was already pending.
@@ -1359,19 +1351,15 @@ int xen_evtchn_bind_ipi_op(struct evtchn_bind_ipi *ipi)
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
 
@@ -1382,8 +1370,8 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
     qemu_mutex_lock(&s->port_lock);
 
     /* The newly allocated port starts out as unbound */
-    ret = allocate_port(s, 0, EVTCHNSTAT_unbound, type_val,
-                        &interdomain->local_port);
+    ret = allocate_port(s, 0, EVTCHNSTAT_unbound, 0, &interdomain->local_port);
+
     if (ret) {
         goto out;
     }
@@ -1408,7 +1396,8 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
             assign_kernel_eventfd(lp->type, xc->guest_port, xc->fd);
         }
         lp->type = EVTCHNSTAT_interdomain;
-        lp->type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU | interdomain->remote_port;
+        lp->u.interdomain.to_qemu = 1;
+        lp->u.interdomain.port = interdomain->remote_port;
         ret = 0;
     } else {
         /* Loopback */
@@ -1416,19 +1405,18 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
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
@@ -1447,7 +1435,6 @@ int xen_evtchn_bind_interdomain_op(struct evtchn_bind_interdomain *interdomain)
 int xen_evtchn_alloc_unbound_op(struct evtchn_alloc_unbound *alloc)
 {
     XenEvtchnState *s = xen_evtchn_singleton;
-    uint16_t type_val;
     int ret;
 
     if (!s) {
@@ -1458,18 +1445,20 @@ int xen_evtchn_alloc_unbound_op(struct evtchn_alloc_unbound *alloc)
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
 
@@ -1496,12 +1485,12 @@ int xen_evtchn_send_op(struct evtchn_send *send)
 
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
@@ -1511,7 +1500,7 @@ int xen_evtchn_send_op(struct evtchn_send *send)
             }
         } else {
             /* Loopback interdomain ports; just a complex IPI */
-            set_port_pending(s, p->type_val);
+            set_port_pending(s, p->u.interdomain.port);
         }
         break;
 
@@ -1553,8 +1542,7 @@ int xen_evtchn_set_port(uint16_t port)
 
     /* QEMU has no business sending to anything but these */
     if (p->type == EVTCHNSTAT_virq ||
-        (p->type == EVTCHNSTAT_interdomain &&
-         (p->type_val & PORT_INFO_TYPEVAL_REMOTE_QEMU))) {
+        (p->type == EVTCHNSTAT_interdomain && p->u.interdomain.to_qemu)) {
         set_port_pending(s, port);
         ret = 0;
     }
@@ -2064,7 +2052,7 @@ int xen_be_evtchn_bind_interdomain(struct xenevtchn_handle *xc, uint32_t domid,
     switch (gp->type) {
     case EVTCHNSTAT_interdomain:
         /* Allow rebinding after migration, preserve port # if possible */
-        be_port = gp->type_val & ~PORT_INFO_TYPEVAL_REMOTE_QEMU;
+        be_port = gp->u.interdomain.port;
         assert(be_port != 0);
         if (!s->be_handles[be_port]) {
             s->be_handles[be_port] = xc;
@@ -2085,7 +2073,8 @@ int xen_be_evtchn_bind_interdomain(struct xenevtchn_handle *xc, uint32_t domid,
         }
 
         gp->type = EVTCHNSTAT_interdomain;
-        gp->type_val = be_port | PORT_INFO_TYPEVAL_REMOTE_QEMU;
+        gp->u.interdomain.to_qemu = 1;
+        gp->u.interdomain.port = be_port;
         xc->guest_port = guest_port;
         if (kvm_xen_has_cap(EVTCHN_SEND)) {
             assign_kernel_eventfd(gp->type, guest_port, xc->fd);
@@ -2130,7 +2119,7 @@ int xen_be_evtchn_unbind(struct xenevtchn_handle *xc, evtchn_port_t port)
         /* This should never *not* be true */
         if (gp->type == EVTCHNSTAT_interdomain) {
             gp->type = EVTCHNSTAT_unbound;
-            gp->type_val = PORT_INFO_TYPEVAL_REMOTE_QEMU;
+            gp->u.interdomain.port = 0;
         }
 
         if (kvm_xen_has_cap(EVTCHN_SEND)) {
@@ -2284,11 +2273,11 @@ EvtchnInfoList *qmp_xen_event_list(Error **errp)
 
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
2.41.0


