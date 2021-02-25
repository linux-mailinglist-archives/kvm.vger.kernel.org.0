Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4E32483C
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhBYBDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:03:07 -0500
Received: from foss.arm.com ([217.140.110.172]:58522 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235508AbhBYBCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0C661474;
        Wed, 24 Feb 2021 17:00:47 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96A2A3F73B;
        Wed, 24 Feb 2021 17:00:46 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 14/22] hw/serial: Switch to new trap handlers
Date:   Thu, 25 Feb 2021 00:59:07 +0000
Message-Id: <20210225005915.26423-15-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the serial device has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/serial.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/hw/serial.c b/hw/serial.c
index c495eac1..4be188a1 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -392,26 +392,6 @@ static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 		serial8250_in(dev, vcpu, addr - dev->iobase, data);
 }
 
-static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
-				  u16 port, void *data, int size)
-{
-	struct serial8250_device *dev = ioport->priv;
-
-	serial8250_mmio(vcpu, port, data, 1, true, dev);
-
-	return true;
-}
-
-static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
-				 u16 port, void *data, int size)
-{
-	struct serial8250_device *dev = ioport->priv;
-
-	serial8250_mmio(vcpu, port, data, 1, false, dev);
-
-	return true;
-}
-
 #ifdef CONFIG_HAS_LIBFDT
 
 char *fdt_stdout_path = NULL;
@@ -449,11 +429,6 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
 }
 #endif
 
-static struct ioport_operations serial8250_ops = {
-	.io_in			= serial8250_ioport_in,
-	.io_out			= serial8250_ioport_out,
-};
-
 static int serial8250__device_init(struct kvm *kvm,
 				   struct serial8250_device *dev)
 {
@@ -464,7 +439,7 @@ static int serial8250__device_init(struct kvm *kvm,
 		return r;
 
 	ioport__map_irq(&dev->irq);
-	r = ioport__register(kvm, dev->iobase, &serial8250_ops, 8, dev);
+	r = kvm__register_pio(kvm, dev->iobase, 8, serial8250_mmio, dev);
 
 	return r;
 }
@@ -487,7 +462,7 @@ cleanup:
 	for (j = 0; j <= i; j++) {
 		struct serial8250_device *dev = &devices[j];
 
-		ioport__unregister(kvm, dev->iobase);
+		kvm__deregister_pio(kvm, dev->iobase);
 		device__unregister(&dev->dev_hdr);
 	}
 
@@ -503,7 +478,7 @@ int serial8250__exit(struct kvm *kvm)
 	for (i = 0; i < ARRAY_SIZE(devices); i++) {
 		struct serial8250_device *dev = &devices[i];
 
-		r = ioport__unregister(kvm, dev->iobase);
+		r = kvm__deregister_pio(kvm, dev->iobase);
 		if (r < 0)
 			return r;
 		device__unregister(&dev->dev_hdr);
-- 
2.17.5

