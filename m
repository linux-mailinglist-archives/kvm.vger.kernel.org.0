Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6AD1A8016
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391060AbgDNOkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:40:08 -0400
Received: from foss.arm.com ([217.140.110.172]:57110 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391035AbgDNOkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2DEDC14;
        Tue, 14 Apr 2020 07:39:59 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DACC93F73D;
        Tue, 14 Apr 2020 07:39:58 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 02/18] hw/i8042: Compile only for x86
Date:   Tue, 14 Apr 2020 15:39:30 +0100
Message-Id: <20200414143946.1521-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The initialization function for the i8042 emulated device does exactly
nothing for all architectures, except for x86. As a result, the device
is usable only for x86, so let's make the file an architecture specific
object file.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile   | 2 +-
 hw/i8042.c | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index f72f163101c3..9dfb21b56c41 100644
--- a/Makefile
+++ b/Makefile
@@ -103,7 +103,6 @@ OBJS	+= hw/pci-shmem.o
 OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
-OBJS	+= hw/i8042.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
@@ -124,6 +123,7 @@ endif
 #x86
 ifeq ($(ARCH),x86)
 	DEFINES += -DCONFIG_X86
+	OBJS	+= hw/i8042.o
 	OBJS	+= x86/boot.o
 	OBJS	+= x86/cpuid.o
 	OBJS	+= x86/interrupt.o
diff --git a/hw/i8042.c b/hw/i8042.c
index 288b7d1108ac..2d8c96e9c7e6 100644
--- a/hw/i8042.c
+++ b/hw/i8042.c
@@ -349,10 +349,6 @@ static struct ioport_operations kbd_ops = {
 
 int kbd__init(struct kvm *kvm)
 {
-#ifndef CONFIG_X86
-	return 0;
-#endif
-
 	kbd_reset();
 	state.kvm = kvm;
 	ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
-- 
2.20.1

