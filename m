Return-Path: <kvm+bounces-846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4736A7E37AB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78BF41C20AFC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D8112E4B;
	Tue,  7 Nov 2023 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cw1GeOn4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36FB8F6F
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:22:19 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393E0106
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kWdbDjeYz0afnZnwtIhprW3R32uFeN2KMkLsabrtTH8=; b=Cw1GeOn4kpo8cW2cKosb3qe9MO
	dyfGbnQtiq55C/Sw5Cvina+fKES9cSV1XfsFJKhXJ8bfrclHP+3L26I7mgvzz36dYJllEEnQVMFsF
	HoV0m5bq0JsQl3wDWE5ikNkzgPrAOk2jazWS6AWFEzKvMquaosPtu882fXTRAIxIGqEUyNlJ36lK8
	73fT2RuvI8EN9w/U/J7MLWSnVhqkU01k8NGlVQJcCpkFdGpvaMLJAoJ3YqsH3oyip60Pp8NsU4Znu
	kxLCpOt+uhIAe47HC6/wZ/m+fAP8JC3j4vMJILoOf02sh1d0Nu5BWz4neZVPHvWNLeYVLXgUeQCiN
	hD6B72zA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0IHN-00BPkW-UH; Tue, 07 Nov 2023 09:21:50 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96.2 #2 (Red Hat Linux))
	id 1r0IHO-001hKg-0o;
	Tue, 07 Nov 2023 09:21:50 +0000
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
Subject: [PULL 13/15] hw/i386/pc: support '-nic' for xen-net-device
Date: Tue,  7 Nov 2023 09:21:45 +0000
Message-ID: <20231107092149.404842-14-dwmw2@infradead.org>
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

The default NIC creation seems a bit hackish to me. I don't understand
why each platform has to call pci_nic_init_nofail() from a point in the
code where it actually has a pointer to the PCI bus, and then we have
the special cases for things like ne2k_isa.

If qmp_device_add() can *find* the appropriate bus and instantiate
the device on it, why can't we just do that from generic code for
creating the default NICs too?

But that isn't a yak I want to shave today. Add a xenbus field to the
PCMachineState so that it can make its way from pc_basic_device_init()
to pc_nic_init() and be handled as a special case like ne2k_isa is.

Now we can launch emulated Xen guests with '-nic user'.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 hw/i386/pc.c             | 11 ++++++++---
 hw/i386/pc_piix.c        |  2 +-
 hw/i386/pc_q35.c         |  2 +-
 hw/xen/xen-bus.c         |  4 +++-
 include/hw/i386/pc.h     |  4 +++-
 include/hw/xen/xen-bus.h |  2 +-
 6 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 1aef21aa2c..188bc9d0f8 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1261,7 +1261,7 @@ void pc_basic_device_init(struct PCMachineState *pcms,
         if (pcms->bus) {
             pci_create_simple(pcms->bus, -1, "xen-platform");
         }
-        xen_bus_init();
+        pcms->xenbus = xen_bus_init();
         xen_be_init();
     }
 #endif
@@ -1289,7 +1289,8 @@ void pc_basic_device_init(struct PCMachineState *pcms,
                     pcms->vmport != ON_OFF_AUTO_ON);
 }
 
-void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)
+void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus,
+                 BusState *xen_bus)
 {
     MachineClass *mc = MACHINE_CLASS(pcmc);
     int i;
@@ -1299,7 +1300,11 @@ void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus)
         NICInfo *nd = &nd_table[i];
         const char *model = nd->model ? nd->model : mc->default_nic;
 
-        if (g_str_equal(model, "ne2k_isa")) {
+        if (xen_bus && (!nd->model || g_str_equal(model, "xen-net-device"))) {
+            DeviceState *dev = qdev_new("xen-net-device");
+            qdev_set_nic_properties(dev, nd);
+            qdev_realize_and_unref(dev, xen_bus, &error_fatal);
+        } else if (g_str_equal(model, "ne2k_isa")) {
             pc_init_ne2k_isa(isa_bus, nd);
         } else {
             pci_nic_init_nofail(nd, pci_bus, model, NULL);
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 26e161beb9..eace854335 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -342,7 +342,7 @@ static void pc_init1(MachineState *machine,
     pc_basic_device_init(pcms, isa_bus, x86ms->gsi, rtc_state, true,
                          0x4);
 
-    pc_nic_init(pcmc, isa_bus, pci_bus);
+    pc_nic_init(pcmc, isa_bus, pci_bus, pcms->xenbus);
 
     if (pcmc->pci_enabled) {
         pc_cmos_init(pcms, idebus[0], idebus[1], rtc_state);
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 597943ff1b..4f3e5412f6 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -340,7 +340,7 @@ static void pc_q35_init(MachineState *machine)
 
     /* the rest devices to which pci devfn is automatically assigned */
     pc_vga_init(isa_bus, host_bus);
-    pc_nic_init(pcmc, isa_bus, host_bus);
+    pc_nic_init(pcmc, isa_bus, host_bus, pcms->xenbus);
 
     if (machine->nvdimms_state->is_enabled) {
         nvdimm_init_acpi_state(machine->nvdimms_state, system_io,
diff --git a/hw/xen/xen-bus.c b/hw/xen/xen-bus.c
index cc6f1b362f..4973e7d9c9 100644
--- a/hw/xen/xen-bus.c
+++ b/hw/xen/xen-bus.c
@@ -1133,11 +1133,13 @@ static void xen_register_types(void)
 
 type_init(xen_register_types)
 
-void xen_bus_init(void)
+BusState *xen_bus_init(void)
 {
     DeviceState *dev = qdev_new(TYPE_XEN_BRIDGE);
     BusState *bus = qbus_new(TYPE_XEN_BUS, dev, NULL);
 
     sysbus_realize_and_unref(SYS_BUS_DEVICE(dev), &error_fatal);
     qbus_set_bus_hotplug_handler(bus);
+
+    return bus;
 }
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 29a9724524..a10ceeabbf 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -33,6 +33,7 @@ typedef struct PCMachineState {
 
     /* Pointers to devices and objects: */
     PCIBus *bus;
+    BusState *xenbus;
     I2CBus *smbus;
     PFlashCFI01 *flash[2];
     ISADevice *pcspk;
@@ -184,7 +185,8 @@ void pc_basic_device_init(struct PCMachineState *pcms,
 void pc_cmos_init(PCMachineState *pcms,
                   BusState *ide0, BusState *ide1,
                   ISADevice *s);
-void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus);
+void pc_nic_init(PCMachineClass *pcmc, ISABus *isa_bus, PCIBus *pci_bus,
+                 BusState *xen_bus);
 
 void pc_i8259_create(ISABus *isa_bus, qemu_irq *i8259_irqs);
 
diff --git a/include/hw/xen/xen-bus.h b/include/hw/xen/xen-bus.h
index 38d40afa37..334ddd1ff6 100644
--- a/include/hw/xen/xen-bus.h
+++ b/include/hw/xen/xen-bus.h
@@ -75,7 +75,7 @@ struct XenBusClass {
 OBJECT_DECLARE_TYPE(XenBus, XenBusClass,
                     XEN_BUS)
 
-void xen_bus_init(void);
+BusState *xen_bus_init(void);
 
 void xen_device_backend_set_state(XenDevice *xendev,
                                   enum xenbus_state state);
-- 
2.41.0


