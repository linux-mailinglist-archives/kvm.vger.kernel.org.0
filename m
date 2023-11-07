Return-Path: <kvm+bounces-856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F32E87E37C1
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8343281009
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7792D026;
	Tue,  7 Nov 2023 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aV84bzG7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA2029420
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:22:33 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45745113
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=8NC7zpHNUo9fTggjfL7ZxSV8IkLkmeuOC0riizcU694=; b=aV84bzG7ukFmJTaTuA0mtfKe0U
	+Ajm3miAr4CJKjCvycFlH65hRrcWMVTEtDB6vE8ggMdhPtHYWGnrVE3nZ8HX9zT3gR9MDlttFZCDa
	qfq4FXPaWILOFgdHLMr68c01echV8zlcMU7mpjnyNluBIW3HrnFT2CP+WVFX6z1POLZ3pzkXFkp87
	wZ+hbaIGdPrsK39ki+HNpF6PEgk7lbTExcDAhhaJ/u2HXP70FjDcdHJruS5CCUSSrrlP6I6G/+7cL
	ZVpIk+g5iLiVrs97EEAvKpdJR1nEkcXu6Srn4Br9OYPXe4e9tg/CIu/ayYaFroJw4Y3SR3wSzIaMQ
	TuWynf4w==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r0IHP-00BtG1-0d;
	Tue, 07 Nov 2023 09:21:55 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1r0IHN-001hKI-2u;
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
Subject: [PULL 07/15] hw/xen: add get_frontend_path() method to XenDeviceClass
Date: Tue,  7 Nov 2023 09:21:39 +0000
Message-ID: <20231107092149.404842-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231107092149.404842-1-dwmw2@infradead.org>
References: <20231107092149.404842-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The primary Xen console is special. The guest's side is set up for it by
the toolstack automatically and not by the standard PV init sequence.

Accordingly, its *frontend* doesn't appear in …/device/console/0 either;
instead it appears under …/console in the guest's XenStore node.

To allow the Xen console driver to override the frontend path for the
primary console, add a method to the XenDeviceClass which can be used
instead of the standard xen_device_get_frontend_path()

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/xen/xen-bus.c         | 11 ++++++++++-
 include/hw/xen/xen-bus.h |  2 ++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
index ece8ec40cd..12ff782005 100644
--- a/hw/xen/xen-bus.c
+++ b/hw/xen/xen-bus.c
@@ -711,8 +711,17 @@ static void xen_device_frontend_create(XenDevice *xendev, Error **errp)
 {
     ERRP_GUARD();
     XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+    XenDeviceClass *xendev_class = XEN_DEVICE_GET_CLASS(xendev);
 
-    xendev->frontend_path = xen_device_get_frontend_path(xendev);
+    if (xendev_class->get_frontend_path) {
+        xendev->frontend_path = xendev_class->get_frontend_path(xendev, errp);
+        if (!xendev->frontend_path) {
+            error_prepend(errp, "failed to create frontend: ");
+            return;
+        }
+    } else {
+        xendev->frontend_path = xen_device_get_frontend_path(xendev);
+    }
 
     /*
      * The frontend area may have already been created by a legacy
diff --git a/include/hw/xen/xen-bus.h b/include/hw/xen/xen-bus.h
index f435898164..eb440880b5 100644
--- a/include/hw/xen/xen-bus.h
+++ b/include/hw/xen/xen-bus.h
@@ -33,6 +33,7 @@ struct XenDevice {
 };
 typedef struct XenDevice XenDevice;
 
+typedef char *(*XenDeviceGetFrontendPath)(XenDevice *xendev, Error **errp);
 typedef char *(*XenDeviceGetName)(XenDevice *xendev, Error **errp);
 typedef void (*XenDeviceRealize)(XenDevice *xendev, Error **errp);
 typedef void (*XenDeviceFrontendChanged)(XenDevice *xendev,
@@ -46,6 +47,7 @@ struct XenDeviceClass {
     /*< public >*/
     const char *backend;
     const char *device;
+    XenDeviceGetFrontendPath get_frontend_path;
     XenDeviceGetName get_name;
     XenDeviceRealize realize;
     XenDeviceFrontendChanged frontend_changed;
-- 
2.41.0


