Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4156F173C
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346069AbjD1MFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjD1MFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:05:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C415A5FC4
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:05:18 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99C901570;
        Fri, 28 Apr 2023 05:06:02 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A843C3F5A1;
        Fri, 28 Apr 2023 05:05:17 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 26/29] lib: Avoid external dependency in libelf
Date:   Fri, 28 Apr 2023 13:04:02 +0100
Message-Id: <20230428120405.3770496-27-nikos.nikoleris@arm.com>
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

There is just a small number of definitions we need from
uapi/linux/elf.h and asm/elf.h and the relocation code is
self-contained.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 lib/elf.h | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 lib/elf.h

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

