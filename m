Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F959340C7A
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhCRSIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:08:13 -0400
Received: from foss.arm.com ([217.140.110.172]:45668 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhCRSII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 14:08:08 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8414231B;
        Thu, 18 Mar 2021 11:08:08 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 741DC3F70D;
        Thu, 18 Mar 2021 11:08:07 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com, Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH v2 3/4] Makefile: Remove overriding recipe for libfdt_clean
Date:   Thu, 18 Mar 2021 18:07:26 +0000
Message-Id: <20210318180727.116004-4-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318180727.116004-1-nikos.nikoleris@arm.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

libfdt_clean is now defined in the libfdt Makefile and as a result, we
don't need to redefine it in the top Makefile. In addition we define
some variables for the remaining libfdt_clean rule.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 Makefile                | 16 +++++++---------
 arm/Makefile.common     |  2 +-
 powerpc/Makefile.common |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index e0828fe..24b7917 100644
--- a/Makefile
+++ b/Makefile
@@ -40,8 +40,6 @@ cflatobjs := \
 LIBFDT_objdir = lib/libfdt
 LIBFDT_srcdir = $(SRCDIR)/lib/libfdt
 LIBFDT_archive = $(LIBFDT_objdir)/libfdt.a
-LIBFDT_include = $(addprefix $(LIBFDT_srcdir)/,$(LIBFDT_INCLUDES))
-LIBFDT_version = $(addprefix $(LIBFDT_srcdir)/,$(LIBFDT_VERSION))
 
 OBJDIRS += $(LIBFDT_objdir)
 
@@ -90,6 +88,10 @@ $(LIBFDT_archive): CFLAGS += -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/li
 $(LIBFDT_archive): $(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS))
 	$(AR) rcs $@ $^
 
+libfdt_clean: VECHO = echo " "
+libfdt_clean: STD_CLEANFILES = *.o .*.d
+libfdt_clean: LIBFDT_dir = $(LIBFDT_objdir)
+libfdt_clean: SHAREDLIB_EXT = so
 
 # Build directory target
 .PHONY: directories
@@ -110,15 +112,11 @@ install: standalone
 	mkdir -p $(DESTDIR)
 	install tests/* $(DESTDIR)
 
-clean: arch_clean
+clean: arch_clean libfdt_clean
+	$(RM) $(LIBFDT_archive)
 	$(RM) lib/.*.d $(libcflat) $(cflatobjs)
 
-libfdt_clean:
-	$(RM) $(LIBFDT_archive) \
-	$(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS)) \
-	$(LIBFDT_objdir)/.*.d
-
-distclean: clean libfdt_clean
+distclean: clean
 	$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.* build-head
 	$(RM) -r tests logs logs.old
 
diff --git a/arm/Makefile.common b/arm/Makefile.common
index a123e85..55478ec 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -78,7 +78,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libgcc) $(libeabi)
 $(libeabi): $(eabiobjs)
 	$(AR) rcs $@ $^
 
-arm_clean: libfdt_clean asm_offsets_clean
+arm_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,flat,elf} $(libeabi) $(eabiobjs) \
 	      $(TEST_DIR)/.*.d lib/arm/.*.d
 
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index ac3cab6..4c3121a 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -73,7 +73,7 @@ $(TEST_DIR)/boot_rom.elf: $(TEST_DIR)/boot_rom.o
 	$(LD) -EB -nostdlib -Ttext=0x100 --entry=start --build-id=none -o $@ $<
 	@chmod a-x $@
 
-powerpc_clean: libfdt_clean asm_offsets_clean
+powerpc_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,elf} $(TEST_DIR)/boot_rom.bin \
 	      $(TEST_DIR)/.*.d lib/powerpc/.*.d
 
-- 
2.25.1

