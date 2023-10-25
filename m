Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE517D6FF0
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344415AbjJYOvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344183AbjJYOvP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE54E5
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xzkyRUM7nQfBrePX87BOU/AjGHoWHaL/QraAYhiDuVA=; b=BL58INjOUPmq2JMYOeuvydyhAU
        tPTn/p80t5Eh08H3gRlleRlgP+tgQWGq7N5wXJH7X/mlOScXTpOEWnbOuRpXEPuP6qVNRYaSGOugd
        6tcXeJgK3mLtMIaVmwTi4STOuz6ondMNTsb2Dj73DZe37n6idaDQJsRGljufaBfSmbEuV49teBrTx
        m/FgIqkMEwtqCXoCcT8ymUrb/NGT1pJYZuYZbwQtSluK2yb0iTICekflP2IJA3Gpi9MMvtZg5uGSH
        wfGZq2vvHZM4qZ/snaUefgRQOvq1JM0TDWen5C41IvSrdS9pyW1ej5/6MqLtxrfa64loaDy8AXSPz
        05GH0pzA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvfDb-009Nmv-GY; Wed, 25 Oct 2023 14:50:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDZ-002dFp-2d;
        Wed, 25 Oct 2023 15:50:45 +0100
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
Subject: [PATCH v3 27/28] hw/xen: use qemu_create_nic_bus_devices() to instantiate Xen NICs
Date:   Wed, 25 Oct 2023 15:50:41 +0100
Message-Id: <20231025145042.627381-28-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231025145042.627381-1-dwmw2@infradead.org>
References: <20231025145042.627381-1-dwmw2@infradead.org>
MIME-Version: 1.0
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

When instantiating XenBus itself, for each NIC which is configured with
either the model unspecified, or set to to "xen" or "xen-net-device",
create a corresponding xen-net-device for it.

Now we can launch emulated Xen guests with '-nic user', and this fixes
the setup for Xen PV guests, which was previously broken in various
ways and never actually managed to peer with the netdev.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 hw/xen/xen-bus.c                    |  4 ++++
 hw/xen/xen_devconfig.c              | 25 -------------------------
 hw/xenpv/xen_machine_pv.c           |  9 ---------
 include/hw/xen/xen-legacy-backend.h |  1 -
 4 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
index cc6f1b362f..fb82cc33e4 100644
--- a/hw/xen/xen-bus.c
+++ b/hw/xen/xen-bus.c
@@ -19,6 +19,7 @@
 #include "qapi/error.h"
 #include "qapi/qmp/qdict.h"
 #include "sysemu/sysemu.h"
+#include "net/net.h"
 #include "trace.h"
 
 static char *xen_device_get_backend_path(XenDevice *xendev)
@@ -1140,4 +1141,7 @@ void xen_bus_init(void)
 
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
     qbus_set_bus_hotplug_handler(bus);
+
+    qemu_create_nic_bus_devices(bus, TYPE_XEN_DEVICE, "xen-net-device",
+                                "xen", "xen-net-device");
 }
diff --git a/hw/xen/xen_devconfig.c b/hw/xen/xen_devconfig.c
index 3f77c675c6..2150869f60 100644
--- a/hw/xen/xen_devconfig.c
+++ b/hw/xen/xen_devconfig.c
@@ -46,31 +46,6 @@ static int xen_config_dev_all(char *fe, char *be)
 
 /* ------------------------------------------------------------- */
 
-int xen_config_dev_nic(NICInfo *nic)
-{
-    char fe[256], be[256];
-    char mac[20];
-    int vlan_id = -1;
-
-    net_hub_id_for_client(nic->netdev, &vlan_id);
-    snprintf(mac, sizeof(mac), "%02x:%02x:%02x:%02x:%02x:%02x",
-             nic->macaddr.a[0], nic->macaddr.a[1], nic->macaddr.a[2],
-             nic->macaddr.a[3], nic->macaddr.a[4], nic->macaddr.a[5]);
-    xen_pv_printf(NULL, 1, "config nic %d: mac=\"%s\"\n", vlan_id, mac);
-    xen_config_dev_dirs("vif", "qnic", vlan_id, fe, be, sizeof(fe));
-
-    /* frontend */
-    xenstore_write_int(fe, "handle",     vlan_id);
-    xenstore_write_str(fe, "mac",        mac);
-
-    /* backend */
-    xenstore_write_int(be, "handle",     vlan_id);
-    xenstore_write_str(be, "mac",        mac);
-
-    /* common stuff */
-    return xen_config_dev_all(fe, be);
-}
-
 int xen_config_dev_vfb(int vdev, const char *type)
 {
     char fe[256], be[256];
diff --git a/hw/xenpv/xen_machine_pv.c b/hw/xenpv/xen_machine_pv.c
index 9f9f137f99..1130d1a147 100644
--- a/hw/xenpv/xen_machine_pv.c
+++ b/hw/xenpv/xen_machine_pv.c
@@ -32,8 +32,6 @@
 
 static void xen_init_pv(MachineState *machine)
 {
-    int i;
-
     setup_xen_backend_ops();
 
     /* Initialize backend core & drivers */
@@ -62,13 +60,6 @@ static void xen_init_pv(MachineState *machine)
         vga_interface_created = true;
     }
 
-    /* configure nics */
-    for (i = 0; i < nb_nics; i++) {
-        if (!nd_table[i].model || 0 != strcmp(nd_table[i].model, "xen"))
-            continue;
-        xen_config_dev_nic(nd_table + i);
-    }
-
     xen_bus_init();
 
     /* config cleanup hook */
diff --git a/include/hw/xen/xen-legacy-backend.h b/include/hw/xen/xen-legacy-backend.h
index fc42146bc2..2cca174778 100644
--- a/include/hw/xen/xen-legacy-backend.h
+++ b/include/hw/xen/xen-legacy-backend.h
@@ -81,7 +81,6 @@ extern struct XenDevOps xen_usb_ops;          /* xen-usb.c         */
 
 /* configuration (aka xenbus setup) */
 void xen_config_cleanup(void);
-int xen_config_dev_nic(NICInfo *nic);
 int xen_config_dev_vfb(int vdev, const char *type);
 int xen_config_dev_vkbd(int vdev);
 int xen_config_dev_console(int vdev);
-- 
2.40.1

