Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E1232483D
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236651AbhBYBDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:03:15 -0500
Received: from foss.arm.com ([217.140.110.172]:58520 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhBYBCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AFEC143D;
        Wed, 24 Feb 2021 17:00:46 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 101DC3F73B;
        Wed, 24 Feb 2021 17:00:44 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 13/22] hw/serial: Refactor trap handler
Date:   Thu, 25 Feb 2021 00:59:06 +0000
Message-Id: <20210225005915.26423-14-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the planned retirement of the special ioport emulation code, we
need to provide an emulation function compatible with the MMIO prototype.

Adjust the trap handler to use that new function, and provide shims to
implement the old ioport interface, for now.

We drop the usage of ioport__read8/write8 entirely, as this would only
be applicable for I/O port accesses, and does nothing for 8-bit wide
accesses anyway.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 hw/serial.c | 93 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 35 deletions(-)

diff --git a/hw/serial.c b/hw/serial.c
index b0465d99..c495eac1 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -242,36 +242,31 @@ void serial8250__inject_sysrq(struct kvm *kvm, char sysrq)
 	sysrq_pending = sysrq;
 }
 
-static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
-			   void *data, int size)
+static bool serial8250_out(struct serial8250_device *dev, struct kvm_cpu *vcpu,
+			   u16 offset, u8 data)
 {
-	struct serial8250_device *dev = ioport->priv;
-	u16 offset;
 	bool ret = true;
-	char *addr = data;
 
 	mutex_lock(&dev->mutex);
 
-	offset = port - dev->iobase;
-
 	switch (offset) {
 	case UART_TX:
 		if (dev->lcr & UART_LCR_DLAB) {
-			dev->dll = ioport__read8(data);
+			dev->dll = data;
 			break;
 		}
 
 		/* Loopback mode */
 		if (dev->mcr & UART_MCR_LOOP) {
 			if (dev->rxcnt < FIFO_LEN) {
-				dev->rxbuf[dev->rxcnt++] = *addr;
+				dev->rxbuf[dev->rxcnt++] = data;
 				dev->lsr |= UART_LSR_DR;
 			}
 			break;
 		}
 
 		if (dev->txcnt < FIFO_LEN) {
-			dev->txbuf[dev->txcnt++] = *addr;
+			dev->txbuf[dev->txcnt++] = data;
 			dev->lsr &= ~UART_LSR_TEMT;
 			if (dev->txcnt == FIFO_LEN / 2)
 				dev->lsr &= ~UART_LSR_THRE;
@@ -283,18 +278,18 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
 		break;
 	case UART_IER:
 		if (!(dev->lcr & UART_LCR_DLAB))
-			dev->ier = ioport__read8(data) & 0x0f;
+			dev->ier = data & 0x0f;
 		else
-			dev->dlm = ioport__read8(data);
+			dev->dlm = data;
 		break;
 	case UART_FCR:
-		dev->fcr = ioport__read8(data);
+		dev->fcr = data;
 		break;
 	case UART_LCR:
-		dev->lcr = ioport__read8(data);
+		dev->lcr = data;
 		break;
 	case UART_MCR:
-		dev->mcr = ioport__read8(data);
+		dev->mcr = data;
 		break;
 	case UART_LSR:
 		/* Factory test */
@@ -303,7 +298,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
 		/* Not used */
 		break;
 	case UART_SCR:
-		dev->scr = ioport__read8(data);
+		dev->scr = data;
 		break;
 	default:
 		ret = false;
@@ -317,7 +312,7 @@ static bool serial8250_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port
 	return ret;
 }
 
-static void serial8250_rx(struct serial8250_device *dev, void *data)
+static void serial8250_rx(struct serial8250_device *dev, u8 *data)
 {
 	if (dev->rxdone == dev->rxcnt)
 		return;
@@ -325,57 +320,54 @@ static void serial8250_rx(struct serial8250_device *dev, void *data)
 	/* Break issued ? */
 	if (dev->lsr & UART_LSR_BI) {
 		dev->lsr &= ~UART_LSR_BI;
-		ioport__write8(data, 0);
+		*data = 0;
 		return;
 	}
 
-	ioport__write8(data, dev->rxbuf[dev->rxdone++]);
+	*data = dev->rxbuf[dev->rxdone++];
 	if (dev->rxcnt == dev->rxdone) {
 		dev->lsr &= ~UART_LSR_DR;
 		dev->rxcnt = dev->rxdone = 0;
 	}
 }
 
-static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static bool serial8250_in(struct serial8250_device *dev, struct kvm_cpu *vcpu,
+			  u16 offset, u8 *data)
 {
-	struct serial8250_device *dev = ioport->priv;
-	u16 offset;
 	bool ret = true;
 
 	mutex_lock(&dev->mutex);
 
-	offset = port - dev->iobase;
-
 	switch (offset) {
 	case UART_RX:
 		if (dev->lcr & UART_LCR_DLAB)
-			ioport__write8(data, dev->dll);
+			*data = dev->dll;
 		else
 			serial8250_rx(dev, data);
 		break;
 	case UART_IER:
 		if (dev->lcr & UART_LCR_DLAB)
-			ioport__write8(data, dev->dlm);
+			*data = dev->dlm;
 		else
-			ioport__write8(data, dev->ier);
+			*data = dev->ier;
 		break;
 	case UART_IIR:
-		ioport__write8(data, dev->iir | UART_IIR_TYPE_BITS);
+		*data = dev->iir | UART_IIR_TYPE_BITS;
 		break;
 	case UART_LCR:
-		ioport__write8(data, dev->lcr);
+		*data = dev->lcr;
 		break;
 	case UART_MCR:
-		ioport__write8(data, dev->mcr);
+		*data = dev->mcr;
 		break;
 	case UART_LSR:
-		ioport__write8(data, dev->lsr);
+		*data = dev->lsr;
 		break;
 	case UART_MSR:
-		ioport__write8(data, dev->msr);
+		*data = dev->msr;
 		break;
 	case UART_SCR:
-		ioport__write8(data, dev->scr);
+		*data = dev->scr;
 		break;
 	default:
 		ret = false;
@@ -389,6 +381,37 @@ static bool serial8250_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port,
 	return ret;
 }
 
+static void serial8250_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			    u8 is_write, void *ptr)
+{
+	struct serial8250_device *dev = ptr;
+
+	if (is_write)
+		serial8250_out(dev, vcpu, addr - dev->iobase, *data);
+	else
+		serial8250_in(dev, vcpu, addr - dev->iobase, data);
+}
+
+static bool serial8250_ioport_out(struct ioport *ioport, struct kvm_cpu *vcpu,
+				  u16 port, void *data, int size)
+{
+	struct serial8250_device *dev = ioport->priv;
+
+	serial8250_mmio(vcpu, port, data, 1, true, dev);
+
+	return true;
+}
+
+static bool serial8250_ioport_in(struct ioport *ioport, struct kvm_cpu *vcpu,
+				 u16 port, void *data, int size)
+{
+	struct serial8250_device *dev = ioport->priv;
+
+	serial8250_mmio(vcpu, port, data, 1, false, dev);
+
+	return true;
+}
+
 #ifdef CONFIG_HAS_LIBFDT
 
 char *fdt_stdout_path = NULL;
@@ -427,8 +450,8 @@ void serial8250_generate_fdt_node(void *fdt, struct device_header *dev_hdr,
 #endif
 
 static struct ioport_operations serial8250_ops = {
-	.io_in			= serial8250_in,
-	.io_out			= serial8250_out,
+	.io_in			= serial8250_ioport_in,
+	.io_out			= serial8250_ioport_out,
 };
 
 static int serial8250__device_init(struct kvm *kvm,
-- 
2.17.5

