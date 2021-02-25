Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A81C324834
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhBYBCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:02:10 -0500
Received: from foss.arm.com ([217.140.110.172]:58502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhBYBB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:01:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA47A11FB;
        Wed, 24 Feb 2021 17:00:33 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FA163F73B;
        Wed, 24 Feb 2021 17:00:32 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 05/22] hw/i8042: Clean up data types
Date:   Thu, 25 Feb 2021 00:58:58 +0000
Message-Id: <20210225005915.26423-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The i8042 is clearly an 8-bit era device, so there is little room for
32-bit registers.
Clean up the data types used.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/i8042.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/hw/i8042.c b/hw/i8042.c
index 37a99a2d..7d1f9772 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -64,11 +64,11 @@
 struct kbd_state {
 	struct kvm		*kvm;
 
-	char			kq[QUEUE_SIZE];	/* Keyboard queue */
+	u8			kq[QUEUE_SIZE];	/* Keyboard queue */
 	int			kread, kwrite;	/* Indexes into the queue */
 	int			kcount;		/* number of elements in queue */
 
-	char			mq[QUEUE_SIZE];
+	u8			mq[QUEUE_SIZE];
 	int			mread, mwrite;
 	int			mcount;
 
@@ -82,7 +82,7 @@ struct kbd_state {
 	 * Some commands (on port 0x64) have arguments;
 	 * we store the command here while we wait for the argument
 	 */
-	u32			write_cmd;
+	u8			write_cmd;
 };
 
 static struct kbd_state		state;
@@ -173,9 +173,9 @@ static void kbd_write_command(struct kvm *kvm, u8 val)
 /*
  * Called when the OS reads from port 0x60 (PS/2 data)
  */
-static u32 kbd_read_data(void)
+static u8 kbd_read_data(void)
 {
-	u32 ret;
+	u8 ret;
 	int i;
 
 	if (state.kcount != 0) {
@@ -202,9 +202,9 @@ static u32 kbd_read_data(void)
 /*
  * Called when the OS read from port 0x64, the command port
  */
-static u32 kbd_read_status(void)
+static u8 kbd_read_status(void)
 {
-	return (u32)state.status;
+	return state.status;
 }
 
 /*
@@ -212,7 +212,7 @@ static u32 kbd_read_status(void)
  * Things written here are generally arguments to commands previously
  * written to port 0x64 and stored in state.write_cmd
  */
-static void kbd_write_data(u32 val)
+static void kbd_write_data(u8 val)
 {
 	switch (state.write_cmd) {
 	case I8042_CMD_CTL_WCTR:
@@ -266,8 +266,8 @@ static void kbd_write_data(u32 val)
 			break;
 		default:
 			break;
-	}
-	break;
+		}
+		break;
 	case 0:
 		/* Just send the ID */
 		kbd_queue(RESPONSE_ACK);
@@ -304,8 +304,8 @@ static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *
 		break;
 	}
 	case I8042_DATA_REG: {
-		u32 value = kbd_read_data();
-		ioport__write32(data, value);
+		u8 value = kbd_read_data();
+		ioport__write8(data, value);
 		break;
 	}
 	case I8042_PORT_B_REG: {
@@ -328,7 +328,7 @@ static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void
 		break;
 	}
 	case I8042_DATA_REG: {
-		u32 value = ioport__read32(data);
+		u8 value = ioport__read8(data);
 		kbd_write_data(value);
 		break;
 	}
-- 
2.17.5

