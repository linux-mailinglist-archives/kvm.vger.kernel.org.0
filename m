Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B65917168C7
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjE3QKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbjE3QKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:10:21 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ABA24E4A
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:09:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C18531756;
        Tue, 30 May 2023 09:10:39 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 777923F663;
        Tue, 30 May 2023 09:09:53 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        shahuang@redhat.com
Subject: [kvm-unit-tests PATCH v6 02/32] x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
Date:   Tue, 30 May 2023 17:08:54 +0100
Message-Id: <20230530160924.82158-3-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compiler flag -macculate-outgoing-args is only needed by the x86_64
ABI. Move it to the relevant Makefile.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 Makefile            | 4 ----
 x86/Makefile.x86_64 | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 6ed5deac..307bc291 100644
--- a/Makefile
+++ b/Makefile
@@ -40,14 +40,10 @@ OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
 ifeq ($(CONFIG_EFI),y)
-EFI_ARCH = x86_64
 EFI_CFLAGS := -DCONFIG_EFI
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
-# Function calls must include the number of arguments passed to the functions
-# More details: https://wiki.osdev.org/GNU-EFI
-EFI_CFLAGS += -maccumulate-outgoing-args
 # GCC defines wchar to be 32 bits, but EFI expects 16 bits
 EFI_CFLAGS += -fshort-wchar
 # EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f483dead..2771a6fa 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -2,6 +2,10 @@ cstart.o = $(TEST_DIR)/cstart64.o
 bits = 64
 ldarch = elf64-x86-64
 ifeq ($(CONFIG_EFI),y)
+# Function calls must include the number of arguments passed to the functions
+# More details: https://wiki.osdev.org/GNU-EFI
+CFLAGS += -maccumulate-outgoing-args
+
 exe = efi
 bin = so
 FORMAT = efi-app-x86_64
-- 
2.25.1

