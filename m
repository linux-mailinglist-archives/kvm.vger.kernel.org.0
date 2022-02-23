Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFB54C0BA5
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbiBWFYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235058AbiBWFYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:24:16 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C5669294
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:48 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l3-20020a25ad43000000b0062462e2af34so11455926ybe.17
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GiCelUYVwIstxpHcG9rjUpGG5AWgwrhv320gd9YieGc=;
        b=m37cSIhex1P0AZECSya53Nwlg/yln3Q85Hc/7yVpLCT4G9GGxthOi0alDY9kzflfJf
         jxr7dI9kLc34Zh2tgIIu7ncsA8mItJVunH8yTxcyUS0nT8UjkaLLgEbCfjeQThYH++9U
         X5/yPZI6EEWT1qhiFMvs4k6thovqNzSAhAgs+b0wZLFQZwXp2Q22vOzrG2juvEle09q1
         lF2qYsQdKi3eJhFxiXSLgstSyfZd9tAOiBs2kmdCVwg1XZsE0rPkNGxamGQwsj1qmYfa
         3N/pDdrSsLFF0KDU8Yzh8eFsdN7hYEX4OK/Dt3o9A1u0TvL2rmxVKhEMmpc6wiFqQO4Y
         WIOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GiCelUYVwIstxpHcG9rjUpGG5AWgwrhv320gd9YieGc=;
        b=UNfaNswsYR9U5wzp8Y4vhOQ6+VvF1M1gYyL1HaSbWBgOhg/7lnP/DmbEDCdcZCJpBG
         T/9A0FfSKju6GgxNjxkmaOc11jVwLnegx+FwI8moeqATJpRaZm7Zq+s858ObTHrmEc/M
         0OmduNpgzVi8NS2NmXKvxhFg/ZL0l9cAm4FFyvy6Uv1UFtJnI9NEWIoKKoLOh3zXgHow
         veOeyQ31TUv2W6ucisMf1XM75SEPlKdq12FlND8Qp9Z2CAfAEHVv8zYrqjZ6rwlpbWYh
         S/u6fQP/N7M1eGr23ZTfRzEJ4VCc+1u2EybnjSFH6HluwM7F6qH8J5ESTh6u2Sr8Wup3
         yPSw==
X-Gm-Message-State: AOAM531D7HF0UolFW39A1fj9e920AkUjteS5kf0vqzEY+R+mdole3Nup
        8SaqawiY+7fvc+7q7F10EIWXByt15bzM
X-Google-Smtp-Source: ABdhPJymjY3mQJBHUfMhfZ8vJdOZZMoFyZQ84NUDUQbSn/nngiTOsENeiNKk8wsCIb50BwzPk44T8MOnbWIc
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a25:2b0a:0:b0:624:a898:3e2f with SMTP id
 r10-20020a252b0a000000b00624a8983e2fmr9721548ybr.643.1645593828179; Tue, 22
 Feb 2022 21:23:48 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:21:37 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-2-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 01/47] mm: asi: Introduce ASI core API
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce core API for Address Space Isolation (ASI).
Kernel address space isolation provides the ability to run some kernel
code with a reduced kernel address space.

There can be multiple classes of such restricted kernel address spaces
(e.g. KPTI, KVM-PTI etc.). Each ASI class is identified by an index.
The ASI class can register some hooks to be called when
entering/exiting the restricted address space.

Currently, there is a fixed maximum number of ASI classes supported.
In addition, each process can have at most one restricted address space
from each ASI class. Neither of these are inherent limitations and
are merely simplifying assumptions for the time being.

(The Kconfig and the high-level ASI API are derived from the original
ASI RFC by Alexandre Chartre).

Originally-by: Alexandre Chartre <alexandre.chartre@oracle.com>

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/alpha/include/asm/Kbuild      |   1 +
 arch/arc/include/asm/Kbuild        |   1 +
 arch/arm/include/asm/Kbuild        |   1 +
 arch/arm64/include/asm/Kbuild      |   1 +
 arch/csky/include/asm/Kbuild       |   1 +
 arch/h8300/include/asm/Kbuild      |   1 +
 arch/hexagon/include/asm/Kbuild    |   1 +
 arch/ia64/include/asm/Kbuild       |   1 +
 arch/m68k/include/asm/Kbuild       |   1 +
 arch/microblaze/include/asm/Kbuild |   1 +
 arch/mips/include/asm/Kbuild       |   1 +
 arch/nds32/include/asm/Kbuild      |   1 +
 arch/nios2/include/asm/Kbuild      |   1 +
 arch/openrisc/include/asm/Kbuild   |   1 +
 arch/parisc/include/asm/Kbuild     |   1 +
 arch/powerpc/include/asm/Kbuild    |   1 +
 arch/riscv/include/asm/Kbuild      |   1 +
 arch/s390/include/asm/Kbuild       |   1 +
 arch/sh/include/asm/Kbuild         |   1 +
 arch/sparc/include/asm/Kbuild      |   1 +
 arch/um/include/asm/Kbuild         |   1 +
 arch/x86/include/asm/asi.h         |  81 +++++++++++++++
 arch/x86/include/asm/tlbflush.h    |   2 +
 arch/x86/mm/Makefile               |   1 +
 arch/x86/mm/asi.c                  | 152 +++++++++++++++++++++++++++++
 arch/x86/mm/init.c                 |   5 +-
 arch/x86/mm/tlb.c                  |   2 +-
 arch/xtensa/include/asm/Kbuild     |   1 +
 include/asm-generic/asi.h          |  51 ++++++++++
 include/linux/mm_types.h           |   3 +
 kernel/fork.c                      |   3 +
 security/Kconfig                   |  10 ++
 32 files changed, 329 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/include/asm/asi.h
 create mode 100644 arch/x86/mm/asi.c
 create mode 100644 include/asm-generic/asi.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 42911c8340c7..e3cd063d9cca 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -4,3 +4,4 @@ generated-y += syscall_table.h
 generic-y += export.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 3c1afa524b9c..60bdeffa7c31 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 03657ff8fbe3..1e2c3d8dbbd9 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += parport.h
 
 generated-y += mach-types.h
 generated-y += unistd-nr.h
+generic-y += asi.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 64202010b700..086e94f00f94 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -4,5 +4,6 @@ generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += user.h
+generic-y += asi.h
 
 generated-y += cpucaps.h
diff --git a/arch/csky/include/asm/Kbuild b/arch/csky/include/asm/Kbuild
index 904a18a818be..b4af49fa48c3 100644
--- a/arch/csky/include/asm/Kbuild
+++ b/arch/csky/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += kvm_para.h
 generic-y += qrwlock.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
+generic-y += asi.h
diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index e23139c8fc0d..f1e937df4c8e 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
 generic-y += spinlock.h
+generic-y += asi.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 3ece3c93fe08..744ffbeeb7ae 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -3,3 +3,4 @@ generic-y += extable.h
 generic-y += iomap.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index f994c1daf9d4..897a388f3e85 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -3,3 +3,4 @@ generated-y += syscall_table.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += vtime.h
+generic-y += asi.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index 0dbf9c5c6fae..faf0f135df4a 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -4,3 +4,4 @@ generic-y += extable.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += spinlock.h
+generic-y += asi.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index a055f5dbe00a..012e4bf83c13 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += parport.h
 generic-y += syscalls.h
 generic-y += tlb.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index dee172716581..b2c7b62536b4 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -14,3 +14,4 @@ generic-y += parport.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/nds32/include/asm/Kbuild b/arch/nds32/include/asm/Kbuild
index 82a4453c9c2d..e8c4cf63db79 100644
--- a/arch/nds32/include/asm/Kbuild
+++ b/arch/nds32/include/asm/Kbuild
@@ -6,3 +6,4 @@ generic-y += gpio.h
 generic-y += kvm_para.h
 generic-y += parport.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/nios2/include/asm/Kbuild b/arch/nios2/include/asm/Kbuild
index 7fe7437555fb..bfdc4026c5b1 100644
--- a/arch/nios2/include/asm/Kbuild
+++ b/arch/nios2/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += spinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index ca5987e11053..3d365bec74d0 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -7,3 +7,4 @@ generic-y += qspinlock.h
 generic-y += qrwlock_types.h
 generic-y += qrwlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index e6e7f74c8ac9..b14e4f727331 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generated-y += syscall_table_64.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index bcf95ce0964f..2aff0fa469c4 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += mcs_spinlock.h
 generic-y += qrwlock.h
 generic-y += vtime.h
 generic-y += early_ioremap.h
+generic-y += asi.h
diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
index 445ccc97305a..3e2022a5a6c5 100644
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -5,3 +5,4 @@ generic-y += flat.h
 generic-y += kvm_para.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
+generic-y += asi.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index 1a18d7b82f86..ef80906ed195 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -8,3 +8,4 @@ generic-y += asm-offsets.h
 generic-y += export.h
 generic-y += kvm_types.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index fc44d9c88b41..ea19e4515828 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -3,3 +3,4 @@ generated-y += syscall_table.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += parport.h
+generic-y += asi.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 0b9d98ced34a..08730a26aaed 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -4,3 +4,4 @@ generated-y += syscall_table_64.h
 generic-y += export.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += asi.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index e5a7b552bb38..b62245b2445a 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -27,3 +27,4 @@ generic-y += word-at-a-time.h
 generic-y += kprobes.h
 generic-y += mm_hooks.h
 generic-y += vga.h
+generic-y += asi.h
diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
new file mode 100644
index 000000000000..f9fc928a555d
--- /dev/null
+++ b/arch/x86/include/asm/asi.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_ASI_H
+#define _ASM_X86_ASI_H
+
+#include <asm-generic/asi.h>
+
+#include <asm/pgtable_types.h>
+#include <asm/percpu.h>
+
+#ifdef CONFIG_ADDRESS_SPACE_ISOLATION
+
+#define ASI_MAX_NUM_ORDER	2
+#define ASI_MAX_NUM		(1 << ASI_MAX_NUM_ORDER)
+
+struct asi_state {
+	struct asi *curr_asi;
+	struct asi *target_asi;
+};
+
+struct asi_hooks {
+	/* Both of these functions MUST be idempotent and re-entrant. */
+
+	void (*post_asi_enter)(void);
+	void (*pre_asi_exit)(void);
+};
+
+struct asi_class {
+	struct asi_hooks ops;
+	uint flags;
+	const char *name;
+};
+
+struct asi {
+	pgd_t *pgd;
+	struct asi_class *class;
+	struct mm_struct *mm;
+};
+
+DECLARE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
+
+void asi_init_mm_state(struct mm_struct *mm);
+
+int  asi_register_class(const char *name, uint flags,
+			const struct asi_hooks *ops);
+void asi_unregister_class(int index);
+
+int  asi_init(struct mm_struct *mm, int asi_index);
+void asi_destroy(struct asi *asi);
+
+void asi_enter(struct asi *asi);
+void asi_exit(void);
+
+static inline void asi_set_target_unrestricted(void)
+{
+	barrier();
+	this_cpu_write(asi_cpu_state.target_asi, NULL);
+}
+
+static inline struct asi *asi_get_current(void)
+{
+	return this_cpu_read(asi_cpu_state.curr_asi);
+}
+
+static inline struct asi *asi_get_target(void)
+{
+	return this_cpu_read(asi_cpu_state.target_asi);
+}
+
+static inline bool is_asi_active(void)
+{
+	return (bool)asi_get_current();
+}
+
+static inline bool asi_is_target_unrestricted(void)
+{
+	return !asi_get_target();
+}
+
+#endif	/* CONFIG_ADDRESS_SPACE_ISOLATION */
+
+#endif
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index b587a9ee9cb2..3c43ad46c14a 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -259,6 +259,8 @@ static inline void arch_tlbbatch_add_mm(struct arch_tlbflush_unmap_batch *batch,
 
 extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
+unsigned long build_cr3(pgd_t *pgd, u16 asid);
+
 #endif /* !MODULE */
 
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5864219221ca..09d5e65e47c8 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
+obj-$(CONFIG_ADDRESS_SPACE_ISOLATION)		+= asi.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
new file mode 100644
index 000000000000..9928325f3787
--- /dev/null
+++ b/arch/x86/mm/asi.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <asm/asi.h>
+#include <asm/pgalloc.h>
+#include <asm/mmu_context.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt)     "ASI: " fmt
+
+static struct asi_class asi_class[ASI_MAX_NUM];
+static DEFINE_SPINLOCK(asi_class_lock);
+
+DEFINE_PER_CPU_ALIGNED(struct asi_state, asi_cpu_state);
+EXPORT_PER_CPU_SYMBOL_GPL(asi_cpu_state);
+
+int asi_register_class(const char *name, uint flags,
+		       const struct asi_hooks *ops)
+{
+	int i;
+
+	VM_BUG_ON(name == NULL);
+
+	spin_lock(&asi_class_lock);
+
+	for (i = 1; i < ASI_MAX_NUM; i++) {
+		if (asi_class[i].name == NULL) {
+			asi_class[i].name = name;
+			asi_class[i].flags = flags;
+			if (ops != NULL)
+				asi_class[i].ops = *ops;
+			break;
+		}
+	}
+
+	spin_unlock(&asi_class_lock);
+
+	if (i == ASI_MAX_NUM)
+		i = -ENOSPC;
+
+	return i;
+}
+EXPORT_SYMBOL_GPL(asi_register_class);
+
+void asi_unregister_class(int index)
+{
+	spin_lock(&asi_class_lock);
+
+	WARN_ON(asi_class[index].name == NULL);
+	memset(&asi_class[index], 0, sizeof(struct asi_class));
+
+	spin_unlock(&asi_class_lock);
+}
+EXPORT_SYMBOL_GPL(asi_unregister_class);
+
+int asi_init(struct mm_struct *mm, int asi_index)
+{
+	struct asi *asi = &mm->asi[asi_index];
+
+	/* Index 0 is reserved for special purposes. */
+	WARN_ON(asi_index == 0 || asi_index >= ASI_MAX_NUM);
+	WARN_ON(asi->pgd != NULL);
+
+	/*
+	 * For now, we allocate 2 pages to avoid any potential problems with
+	 * KPTI code. This won't be needed once KPTI is folded into the ASI
+	 * framework.
+	 */
+	asi->pgd = (pgd_t *)__get_free_pages(GFP_PGTABLE_USER,
+					     PGD_ALLOCATION_ORDER);
+	if (!asi->pgd)
+		return -ENOMEM;
+
+	asi->class = &asi_class[asi_index];
+	asi->mm = mm;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(asi_init);
+
+void asi_destroy(struct asi *asi)
+{
+	free_pages((ulong)asi->pgd, PGD_ALLOCATION_ORDER);
+	memset(asi, 0, sizeof(struct asi));
+}
+EXPORT_SYMBOL_GPL(asi_destroy);
+
+static void __asi_enter(void)
+{
+	u64 asi_cr3;
+	struct asi *target = this_cpu_read(asi_cpu_state.target_asi);
+
+	VM_BUG_ON(preemptible());
+
+	if (!target || target == this_cpu_read(asi_cpu_state.curr_asi))
+		return;
+
+	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
+		  LOADED_MM_SWITCHING);
+
+	this_cpu_write(asi_cpu_state.curr_asi, target);
+
+	asi_cr3 = build_cr3(target->pgd,
+			    this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+	write_cr3(asi_cr3);
+
+	if (target->class->ops.post_asi_enter)
+		target->class->ops.post_asi_enter();
+}
+
+void asi_enter(struct asi *asi)
+{
+	VM_WARN_ON_ONCE(!asi);
+
+	this_cpu_write(asi_cpu_state.target_asi, asi);
+	barrier();
+
+	__asi_enter();
+}
+EXPORT_SYMBOL_GPL(asi_enter);
+
+void asi_exit(void)
+{
+	u64 unrestricted_cr3;
+	struct asi *asi;
+
+	preempt_disable();
+
+	VM_BUG_ON(this_cpu_read(cpu_tlbstate.loaded_mm) ==
+		  LOADED_MM_SWITCHING);
+
+	asi = this_cpu_read(asi_cpu_state.curr_asi);
+
+	if (asi) {
+		if (asi->class->ops.pre_asi_exit)
+			asi->class->ops.pre_asi_exit();
+
+		unrestricted_cr3 =
+			build_cr3(this_cpu_read(cpu_tlbstate.loaded_mm)->pgd,
+				  this_cpu_read(cpu_tlbstate.loaded_mm_asid));
+
+		write_cr3(unrestricted_cr3);
+		this_cpu_write(asi_cpu_state.curr_asi, NULL);
+	}
+
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(asi_exit);
+
+void asi_init_mm_state(struct mm_struct *mm)
+{
+	memset(mm->asi, 0, sizeof(mm->asi));
+}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 1895986842b9..000cbe5315f5 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -238,8 +238,9 @@ static void __init probe_page_size_mask(void)
 
 	/* By the default is everything supported: */
 	__default_kernel_pte_mask = __supported_pte_mask;
-	/* Except when with PTI where the kernel is mostly non-Global: */
-	if (cpu_feature_enabled(X86_FEATURE_PTI))
+	/* Except when with PTI or ASI where the kernel is mostly non-Global: */
+	if (cpu_feature_enabled(X86_FEATURE_PTI) ||
+	    IS_ENABLED(CONFIG_ADDRESS_SPACE_ISOLATION))
 		__default_kernel_pte_mask &= ~_PAGE_GLOBAL;
 
 	/* Enable 1 GB linear kernel mappings if available: */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 59ba2968af1b..88d9298720dc 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -153,7 +153,7 @@ static inline u16 user_pcid(u16 asid)
 	return ret;
 }
 
-static inline unsigned long build_cr3(pgd_t *pgd, u16 asid)
+inline unsigned long build_cr3(pgd_t *pgd, u16 asid)
 {
 	if (static_cpu_has(X86_FEATURE_PCID)) {
 		return __sme_pa(pgd) | kern_pcid(asid);
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index 854c5e07e867..49fcdf9d83f5 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -7,3 +7,4 @@ generic-y += param.h
 generic-y += qrwlock.h
 generic-y += qspinlock.h
 generic-y += user.h
+generic-y += asi.h
diff --git a/include/asm-generic/asi.h b/include/asm-generic/asi.h
new file mode 100644
index 000000000000..e5ba51d30b90
--- /dev/null
+++ b/include/asm-generic/asi.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_GENERIC_ASI_H
+#define __ASM_GENERIC_ASI_H
+
+/* ASI class flags */
+#define ASI_MAP_STANDARD_NONSENSITIVE	1
+
+#ifndef CONFIG_ADDRESS_SPACE_ISOLATION
+
+#define ASI_MAX_NUM_ORDER		0
+#define ASI_MAX_NUM			0
+
+#ifndef _ASSEMBLY_
+
+struct asi_hooks {};
+struct asi {};
+
+static inline
+int asi_register_class(const char *name, uint flags,
+		       const struct asi_hooks *ops)
+{
+	return 0;
+}
+
+static inline void asi_unregister_class(int asi_index) { }
+
+static inline void asi_init_mm_state(struct mm_struct *mm) { }
+
+static inline int asi_init(struct mm_struct *mm, int asi_index) { return 0; }
+
+static inline void asi_destroy(struct asi *asi) { }
+
+static inline void asi_enter(struct asi *asi) { }
+
+static inline void asi_set_target_unrestricted(void) { }
+
+static inline bool asi_is_target_unrestricted(void) { return true; }
+
+static inline void asi_exit(void) { }
+
+static inline bool is_asi_active(void) { return false; }
+
+static inline struct asi *asi_get_target(void) { return NULL; }
+
+static inline struct asi *asi_get_current(void) { return NULL; }
+
+#endif  /* !_ASSEMBLY_ */
+
+#endif /* !CONFIG_ADDRESS_SPACE_ISOLATION */
+
+#endif
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index c3a6e6209600..3de1afa57289 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -18,6 +18,7 @@
 #include <linux/seqlock.h>
 
 #include <asm/mmu.h>
+#include <asm/asi.h>
 
 #ifndef AT_VECTOR_SIZE_ARCH
 #define AT_VECTOR_SIZE_ARCH 0
@@ -495,6 +496,8 @@ struct mm_struct {
 		atomic_t membarrier_state;
 #endif
 
+		struct asi asi[ASI_MAX_NUM];
+
 		/**
 		 * @mm_users: The number of users including userspace.
 		 *
diff --git a/kernel/fork.c b/kernel/fork.c
index 3244cc56b697..3695a32ee9bd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -102,6 +102,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
+#include <asm/asi.h>
 
 #include <trace/events/sched.h>
 
@@ -1071,6 +1072,8 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 		mm->def_flags = 0;
 	}
 
+	asi_init_mm_state(mm);
+
 	if (mm_alloc_pgd(mm))
 		goto fail_nopgd;
 
diff --git a/security/Kconfig b/security/Kconfig
index 0b847f435beb..21b15ecaf2c1 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -65,6 +65,16 @@ config PAGE_TABLE_ISOLATION
 
 	  See Documentation/x86/pti.rst for more details.
 
+config ADDRESS_SPACE_ISOLATION
+	bool "Allow code to run with a reduced kernel address space"
+	default n
+	depends on X86_64 && !UML
+	depends on !PARAVIRT
+	help
+	   This feature provides the ability to run some kernel code
+	   with a reduced kernel address space. This can be used to
+	   mitigate some speculative execution attacks.
+
 config SECURITY_INFINIBAND
 	bool "Infiniband Security Hooks"
 	depends on SECURITY && INFINIBAND
-- 
2.35.1.473.g83b2b277ed-goog

