Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7832D6673
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390301AbgLJT3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 14:29:10 -0500
Received: from foss.arm.com ([217.140.110.172]:44788 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390264AbgLJOaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 09:30:10 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 928F71396;
        Thu, 10 Dec 2020 06:29:24 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 772623F718;
        Thu, 10 Dec 2020 06:29:23 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 02/21] hw/serial: Use device abstraction for FDT generator function
Date:   Thu, 10 Dec 2020 14:28:49 +0000
Message-Id: <20201210142908.169597-3-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210142908.169597-1-andre.przywara@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment we use the .generate_fdt_node member of the ioport ops
structure to store the function pointer for the FDT node generator
function. ioport__register() will then put a wrapper and this pointer
into the device header.
The serial device is the only device making use of this special ioport
feature, so let's move this over to using the device header directly.

This will allow us to get rid of this .generate_fdt_node member in the
ops and simplify the code.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/serial.c       | 49 +++++++++++++++++++++++++++++++++++++----------
 include/kvm/kvm.h |  2 ++
 2 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/hw/serial.c b/hw/serial.c
index 13c4663e..b0465d99 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -23,6 +23,7 @@
 #define UART_IIR_TYPE_BITS	0xc0
 
 struct serial8250_device {
+	struct device_header	dev_hdr;
 	struct mutex		mutex;
 	u8			id;
 
@@ -53,9 +54,20 @@ struct serial8250_device {
 	.msr			= UART_MSR_DCD | UART_MSR_DSR | UART_MSR_CTS, \
 	.mcr			= UART_MCR_OUT2,
 
+#ifdef CONFIG_HAS_LIBFDT
+static
+void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
+				  fdt_irq_fn irq_fn);
+#else
+#define serial8250_generate_fdt_node	NULL
+#endif
 static struct serial8250_device devices[] = {
 	/* ttyS0 */
 	[0]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 0,
@@ -66,6 +78,10 @@ static struct serial8250_device devices[] = {
 	},
 	/* ttyS1 */
 	[1]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 1,
@@ -76,6 +92,10 @@ static struct serial8250_device devices[] = {
 	},
 	/* ttyS2 */
 	[2]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 2,
@@ -86,6 +106,10 @@ static struct serial8250_device devices[] = {
 	},
 	/* ttyS3 */
 	[3]	= {
+		.dev_hdr = {
+			.bus_type	= DEVICE_BUS_IOPORT,
+			.data		= serial8250_generate_fdt_node,
+		},
 		.mutex			= MUTEX_INITIALIZER,
 
 		.id			= 3,
@@ -371,13 +395,14 @@ char *fdt_stdout_path = NULL;
 
 #define DEVICE_NAME_MAX_LEN 32
 static
-void serial8250_generate_fdt_node(struct ioport *ioport, void *fdt,
-				  void (*generate_irq_prop)(void *fdt,
-							    u8 irq,
-							    enum irq_type))
+void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
+				  fdt_irq_fn irq_fn)
 {
 	char dev_name[DEVICE_NAME_MAX_LEN];
-	struct serial8250_device *dev = ioport->priv;
+	struct serial8250_device *dev = container_of(dev_hdr,
+						     struct serial8250_device,
+						     dev_hdr);
+
 	u64 addr = KVM_IOPORT_AREA + dev->iobase;
 	u64 reg_prop[] = {
 		cpu_to_fdt64(addr),
@@ -395,24 +420,26 @@ void serial8250_generate_fdt_node(struct ioport *ioport, void *fdt,
 	_FDT(fdt_begin_node(fdt, dev_name));
 	_FDT(fdt_property_string(fdt, "compatible", "ns16550a"));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
-	generate_irq_prop(fdt, dev->irq, IRQ_TYPE_LEVEL_HIGH);
+	irq_fn(fdt, dev->irq, IRQ_TYPE_LEVEL_HIGH);
 	_FDT(fdt_property_cell(fdt, "clock-frequency", 1843200));
 	_FDT(fdt_end_node(fdt));
 }
-#else
-#define serial8250_generate_fdt_node	NULL
 #endif
 
 static struct ioport_operations serial8250_ops = {
 	.io_in			= serial8250_in,
 	.io_out			= serial8250_out,
-	.generate_fdt_node	= serial8250_generate_fdt_node,
 };
 
-static int serial8250__device_init(struct kvm *kvm, struct serial8250_device *dev)
+static int serial8250__device_init(struct kvm *kvm,
+				   struct serial8250_device *dev)
 {
 	int r;
 
+	r = device__register(&dev->dev_hdr);
+	if (r < 0)
+		return r;
+
 	ioport__map_irq(&dev->irq);
 	r = ioport__register(kvm, dev->iobase, &serial8250_ops, 8, dev);
 
@@ -438,6 +465,7 @@ cleanup:
 		struct serial8250_device *dev = &devices[j];
 
 		ioport__unregister(kvm, dev->iobase);
+		device__unregister(&dev->dev_hdr);
 	}
 
 	return r;
@@ -455,6 +483,7 @@ int serial8250__exit(struct kvm *kvm)
 		r = ioport__unregister(kvm, dev->iobase);
 		if (r < 0)
 			return r;
+		device__unregister(&dev->dev_hdr);
 	}
 
 	return 0;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 53373b08..ee99c28e 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -31,6 +31,8 @@
 	.name = #ext,			\
 	.code = ext
 
+typedef void (*fdt_irq_fn)(void *fdt, u8 irq, enum irq_type);
+
 enum {
 	KVM_VMSTATE_RUNNING,
 	KVM_VMSTATE_PAUSED,
-- 
2.17.1

