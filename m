Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB2D7D700E
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344160AbjJYOvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbjJYOvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD709E5
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=nSyX13U7fFimGQ53pLarBeZoTcJ83YAj4kMDKmZCroo=; b=sU8+/FmzjvrZSwWTPPHaMd+E4T
        jDMl4D0TCrxob06SgGcF9MfamCPAfdobDvLhfXAHXXUJy1JIIsdGOJrwJ6KkWpcQebdQIvtIRk2ZW
        5evtP1+2Epvifd5plVPrEYcgUl+KNVqqnhYU6uDiAUpJTuO7KsfGFs6aqQNY1cdQM+xLFt+LIbQqo
        ItGqyZWn2VySri4f6dwJx5KlmfhaNHIUoJ1T/LcFvLwtN5Cj7xsOSVFG88YEt4I8ecxy2Tt1K+BKx
        ieaE8fBANaoPEcW7oXj/KXgHK/MgdrubPp0V6+Dtsmwuo2ZyVcJnxQWh/MQR/uUI9ghpGaiQGy+rZ
        FmQ4QrgQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvfDZ-009Nmh-5W; Wed, 25 Oct 2023 14:50:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDY-002dEt-2Q;
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
Subject: [PATCH v3 14/28] hw/xen: add get_frontend_path() method to XenDeviceClass
Date:   Wed, 25 Oct 2023 15:50:28 +0100
Message-Id: <20231025145042.627381-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231025145042.627381-1-dwmw2@infradead.org>
References: <20231025145042.627381-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The primary Xen console is special. The guest's side is set up for it by
the toolstack automatically and not by the standard PV init sequence.

Accordingly, its *frontend* doesn't appear in …/device/console/0 either;
instead it appears under …/console in the guest's XenStore node.

To allow the Xen console driver to override the frontend path for the
primary console, add a method to the XenDeviceClass which can be used
instead of the standard xen_device_get_frontend_path()

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
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
2.40.1

