Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293D72D65FE
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393280AbgLJTIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 14:08:19 -0500
Received: from foss.arm.com ([217.140.110.172]:45078 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389019AbgLJObA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9201F1477;
        Thu, 10 Dec 2020 06:29:32 -0800 (PST)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.195.35])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 788D23F718;
        Thu, 10 Dec 2020 06:29:31 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH kvmtool 08/21] x86/ioport: Refactor trap handlers
Date:   Thu, 10 Dec 2020 14:28:55 +0000
Message-Id: <20201210142908.169597-9-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210142908.169597-1-andre.przywara@arm.com>
References: <20201210142908.169597-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the planned retirement of the special ioport emulation code, we
need to provide emulation functions compatible with the MMIO
prototype.

Adjust the trap handlers to use that new function, and provide shims to
implement the old ioport interface, for now.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 x86/ioport.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/x86/ioport.c b/x86/ioport.c
index 8c5c7699..932da20a 100644
--- a/x86/ioport.c
+++ b/x86/ioport.c
@@ -3,8 +3,14 @@
 #include <stdlib.h>
 #include <stdio.h>
 
+static void dummy_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+		       u8 is_write, void *ptr)
+{
+}
+
 static bool debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
+	dummy_mmio(vcpu, port, data, size, true, NULL);
 	return 0;
 }
 
@@ -12,15 +18,23 @@ static struct ioport_operations debug_ops = {
 	.io_out		= debug_io_out,
 };
 
-static bool seabios_debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void seabios_debug_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
+			       u32 len, u8 is_write, void *ptr)
 {
 	char ch;
 
+	if (!is_write)
+		return;
+
 	ch = ioport__read8(data);
 
 	putchar(ch);
+}
 
-	return true;
+static bool seabios_debug_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	seabios_debug_mmio(vcpu, port, data, size, true, NULL);
+	return 0;
 }
 
 static struct ioport_operations seabios_debug_ops = {
@@ -29,11 +43,13 @@ static struct ioport_operations seabios_debug_ops = {
 
 static bool dummy_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
+	dummy_mmio(vcpu, port, data, size, false, NULL);
 	return true;
 }
 
 static bool dummy_io_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
 {
+	dummy_mmio(vcpu, port, data, size, true, NULL);
 	return true;
 }
 
@@ -50,13 +66,19 @@ static struct ioport_operations dummy_write_only_ioport_ops = {
  * The "fast A20 gate"
  */
 
-static bool ps2_control_a_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+static void ps2_control_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
+			     u8 is_write, void *ptr)
 {
 	/*
 	 * A20 is always enabled.
 	 */
-	ioport__write8(data, 0x02);
+	if (!is_write)
+		ioport__write8(data, 0x02);
+}
 
+static bool ps2_control_a_io_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
+{
+	ps2_control_mmio(vcpu, port, data, size, false, NULL);
 	return true;
 }
 
-- 
2.17.1

