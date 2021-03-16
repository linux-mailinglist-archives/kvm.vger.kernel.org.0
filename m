Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2A33D74C
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbhCPPYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:24:40 -0400
Received: from foss.arm.com ([217.140.110.172]:46176 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231989AbhCPPYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:24:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88FED106F;
        Tue, 16 Mar 2021 08:24:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B2AA13F792;
        Tue, 16 Mar 2021 08:24:14 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH 3/4] Makefile: Avoid double definition of libfdt_clean
Date:   Tue, 16 Mar 2021 15:24:04 +0000
Message-Id: <20210316152405.50363-4-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210316152405.50363-1-nikos.nikoleris@arm.com>
References: <20210316152405.50363-1-nikos.nikoleris@arm.com>
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
 Makefile | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index e0828fe..37aa3c6 100644
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
+libfdt_clean: STD_CLEANFILES = *.o *.d
+libfdt_clean: LIBFDT_dir = $(LIBFDT_objdir)
+libfdt_clean: SHAREDLIB_EXT = so
 
 # Build directory target
 .PHONY: directories
@@ -113,12 +115,8 @@ install: standalone
 clean: arch_clean
 	$(RM) lib/.*.d $(libcflat) $(cflatobjs)
 
-libfdt_clean:
-	$(RM) $(LIBFDT_archive) \
-	$(addprefix $(LIBFDT_objdir)/,$(LIBFDT_OBJS)) \
-	$(LIBFDT_objdir)/.*.d
-
 distclean: clean libfdt_clean
+	$(RM) $(LIBFDT_archive)
 	$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.* build-head
 	$(RM) -r tests logs logs.old
 
-- 
2.25.1

