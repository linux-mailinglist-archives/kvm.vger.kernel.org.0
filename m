Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1545D33BFEB
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 16:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhCOPe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 11:34:29 -0400
Received: from foss.arm.com ([217.140.110.172]:50692 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhCOPeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 11:34:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E2DF1FB;
        Mon, 15 Mar 2021 08:34:22 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C049C3F792;
        Mon, 15 Mar 2021 08:34:20 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v3 07/22] hw/i8042: Switch to new trap handlers
Date:   Mon, 15 Mar 2021 15:33:35 +0000
Message-Id: <20210315153350.19988-8-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210315153350.19988-1-andre.przywara@arm.com>
References: <20210315153350.19988-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the PC keyboard has a trap handler adhering to the MMIO fault
handler prototype, let's switch over to the joint registration routine.

This allows us to get rid of the ioport shim routines.

Make the kbd_init() function static on the way.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/i8042.c          | 30 ++++--------------------------
 include/kvm/i8042.h |  1 -
 2 files changed, 4 insertions(+), 27 deletions(-)

diff --git a/hw/i8042.c b/hw/i8042.c
index ab866662..20be36c4 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -325,40 +325,18 @@ static void kbd_io(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len,
 		ioport__write8(data, value);
 }
 
-/*
- * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
- */
-static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	kbd_io(vcpu, port, data, size, false, NULL);
-
-	return true;
-}
-
-static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
-{
-	kbd_io(vcpu, port, data, size, true, NULL);
-
-	return true;
-}
-
-static struct ioport_operations kbd_ops = {
-	.io_in		= kbd_in,
-	.io_out		= kbd_out,
-};
-
-int kbd__init(struct kvm *kvm)
+static int kbd__init(struct kvm *kvm)
 {
 	int r;
 
 	kbd_reset();
 	state.kvm = kvm;
-	r = ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
+	r = kvm__register_pio(kvm, I8042_DATA_REG, 2, kbd_io, NULL);
 	if (r < 0)
 		return r;
-	r = ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
+	r = kvm__register_pio(kvm, I8042_COMMAND_REG, 2, kbd_io, NULL);
 	if (r < 0) {
-		ioport__unregister(kvm, I8042_DATA_REG);
+		kvm__deregister_pio(kvm, I8042_DATA_REG);
 		return r;
 	}
 
diff --git a/include/kvm/i8042.h b/include/kvm/i8042.h
index 3b4ab688..cd4ae6bb 100644
--- a/include/kvm/i8042.h
+++ b/include/kvm/i8042.h
@@ -7,6 +7,5 @@ struct kvm;
 
 void mouse_queue(u8 c);
 void kbd_queue(u8 c);
-int kbd__init(struct kvm *kvm);
 
 #endif
-- 
2.17.5

