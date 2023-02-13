Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D65A6942B2
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjBMKUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjBMKTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:19:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A2221204C
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:19:30 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51FAB1F60;
        Mon, 13 Feb 2023 02:19:18 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D29FF3F703;
        Mon, 13 Feb 2023 02:18:34 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 27/30] lib: Avoid external dependency in libelf
Date:   Mon, 13 Feb 2023 10:17:56 +0000
Message-Id: <20230213101759.2577077-28-nikos.nikoleris@arm.com>
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

There is just a small number of definitions we need from
uapi/linux/elf.h and asm/elf.h and the relocation code is
self-contained.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 arm/efi/reloc_aarch64.c |  3 +--
 lib/elf.h               | 57 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)
 create mode 100644 lib/elf.h

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index fa0cd6bc..3f6d9a6d 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -34,8 +34,7 @@
     SUCH DAMAGE.
 */
 
-#include "efi.h"
-#include <elf.h>
+#include <efi.h>
 
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
 		       efi_system_table_t *sys_tab)
diff --git a/lib/elf.h b/lib/elf.h
new file mode 100644
index 00000000..abd5cf4b
--- /dev/null
+++ b/lib/elf.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: LGPL-2.0-or-later */
+/*
+ * Relevant definitions from uapi/linux/elf.h and asm/elf.h
+ */
+
+#ifndef _ELF_H_
+#define _ELF_H_
+
+#include <libcflat.h>
+
+/* 64-bit ELF base types. */
+typedef u64	Elf64_Addr;
+typedef u64	Elf64_Xword;
+typedef s64	Elf64_Sxword;
+
+typedef struct {
+	Elf64_Sxword d_tag;             /* entry tag value */
+	union {
+		Elf64_Xword d_val;
+		Elf64_Addr d_ptr;
+	} d_un;
+} Elf64_Dyn;
+
+typedef struct elf64_rel {
+	Elf64_Addr r_offset;    /* Location at which to apply the action */
+	Elf64_Xword r_info;     /* index and type of relocation */
+} Elf64_Rel;
+
+typedef struct elf64_rela {
+	Elf64_Addr r_offset;    /* Location at which to apply the action */
+	Elf64_Xword r_info;     /* index and type of relocation */
+	Elf64_Sxword r_addend;  /* Constant addend used to compute value */
+} Elf64_Rela;
+
+/* This is the info that is needed to parse the dynamic section of the file */
+#define DT_NULL		0
+#define DT_RELA		7
+#define DT_RELASZ	8
+#define DT_RELAENT	9
+
+/* x86 relocation types. */
+#define R_X86_64_NONE		0       /* No reloc */
+#define R_X86_64_RELATIVE	8       /* Adjust by program base */
+
+
+/*
+ * AArch64 static relocation types.
+ */
+
+/* Miscellaneous. */
+#define R_AARCH64_NONE		256
+#define R_AARCH64_RELATIVE	1027
+
+/* The following are used with relocations */
+#define ELF64_R_TYPE(i)		((i) & 0xffffffff)
+
+#endif /* _ELF_H_ */
-- 
2.25.1

