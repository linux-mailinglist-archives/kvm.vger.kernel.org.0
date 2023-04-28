Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64ACC6F171E
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjD1MEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjD1MEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:04:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64D9A1FF0
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:04:50 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AC5D12FC;
        Fri, 28 Apr 2023 05:05:34 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 490B53F5A1;
        Fri, 28 Apr 2023 05:04:49 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 01/29] lib: Move acpi header and implementation to lib
Date:   Fri, 28 Apr 2023 13:03:37 +0100
Message-Id: <20230428120405.3770496-2-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move acpi.h to lib to make it available for other architectures.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 x86/Makefile.common  | 2 +-
 lib/x86/asm/setup.h  | 2 +-
 lib/{x86 => }/acpi.h | 4 ++--
 lib/{x86 => }/acpi.c | 0
 x86/s3.c             | 2 +-
 x86/vmexit.c         | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)
 rename lib/{x86 => }/acpi.h (99%)
 rename lib/{x86 => }/acpi.c (100%)

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
 
diff --git a/lib/x86/acpi.c b/lib/acpi.c
similarity index 100%
rename from lib/x86/acpi.c
rename to lib/acpi.c
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
index 2e8866e1..9260accc 100644
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

