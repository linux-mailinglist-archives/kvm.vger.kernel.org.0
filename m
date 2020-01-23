Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E5D146989
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgAWNsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:22 -0500
Received: from foss.arm.com ([217.140.110.172]:39654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbgAWNsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFE94106F;
        Thu, 23 Jan 2020 05:48:21 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D4CFE3F68E;
        Thu, 23 Jan 2020 05:48:20 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 02/30] hw/i8042: Compile only for x86
Date:   Thu, 23 Jan 2020 13:47:37 +0000
Message-Id: <20200123134805.1993-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile   | 2 +-
 hw/i8042.c | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 6d6880dd4f8a..33eddcbb4d66 100644
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

