Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDEA69428E
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjBMKSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjBMKSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:07 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72924E064
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:06 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC320106F;
        Mon, 13 Feb 2023 02:18:48 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 584703F703;
        Mon, 13 Feb 2023 02:18:05 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 01/30] lib: Move acpi header and implementation to lib
Date:   Mon, 13 Feb 2023 10:17:30 +0000
Message-Id: <20230213101759.2577077-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move acpi.h to lib to make it available for other architectures.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 lib/{x86 => }/acpi.c | 0
 lib/{x86 => }/acpi.h | 4 ++--
 lib/x86/asm/setup.h  | 2 +-
 x86/Makefile.common  | 2 +-
 x86/s3.c             | 2 +-
 x86/vmexit.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)
 rename lib/{x86 => }/acpi.c (100%)
 rename lib/{x86 => }/acpi.h (99%)

diff --git a/lib/x86/acpi.c b/lib/acpi.c
similarity index 100%
rename from lib/x86/acpi.c
rename to lib/acpi.c
diff --git a/lib/x86/acpi.h b/lib/acpi.h
similarity index 99%
rename from lib/x86/acpi.h
rename to lib/acpi.h
index 67ba3899..1e89840c 100644
--- a/lib/x86/acpi.h
+++ b/lib/acpi.h
@@ -1,5 +1,5 @@
-#ifndef _X86_ACPI_H_
-#define _X86_ACPI_H_
+#ifndef _ACPI_H_
+#define _ACPI_H_
 
 #include "libcflat.h"
 
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 1f384274..458eac85 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -4,7 +4,7 @@
 unsigned long setup_tss(u8 *stacktop);
 
 #ifdef CONFIG_EFI
-#include "x86/acpi.h"
+#include "acpi.h"
 #include "x86/apic.h"
 #include "x86/processor.h"
 #include "x86/smp.h"
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 365e199f..9f2bc93f 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -2,6 +2,7 @@
 
 all: directories test_cases
 
+cflatobjs += lib/acpi.o
 cflatobjs += lib/pci.o
 cflatobjs += lib/pci-edu.o
 cflatobjs += lib/alloc.o
@@ -18,7 +19,6 @@ cflatobjs += lib/x86/apic.o
 cflatobjs += lib/x86/atomic.o
 cflatobjs += lib/x86/desc.o
 cflatobjs += lib/x86/isr.o
-cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
diff --git a/x86/s3.c b/x86/s3.c
index 6e41d0c4..378d37ae 100644
--- a/x86/s3.c
+++ b/x86/s3.c
@@ -1,5 +1,5 @@
 #include "libcflat.h"
-#include "x86/acpi.h"
+#include "acpi.h"
 #include "asm/io.h"
 
 static u32* find_resume_vector_addr(void)
diff --git a/x86/vmexit.c b/x86/vmexit.c
index b1eed8d1..865ccf6b 100644
--- a/x86/vmexit.c
+++ b/x86/vmexit.c
@@ -1,9 +1,9 @@
 #include "libcflat.h"
+#include "acpi.h"
 #include "smp.h"
 #include "pci.h"
 #include "x86/vm.h"
 #include "x86/desc.h"
-#include "x86/acpi.h"
 #include "x86/apic.h"
 #include "x86/isr.h"
 
-- 
2.25.1

