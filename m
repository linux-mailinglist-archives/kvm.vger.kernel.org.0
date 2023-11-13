Return-Path: <kvm+bounces-1550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E4A07E94F2
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 911191C20AFB
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7131C6B8;
	Mon, 13 Nov 2023 02:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="K6v5KJH9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CFA18632
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:32 +0000 (UTC)
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [185.125.25.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CC810E
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:28 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtf4t44zMpvd2;
	Mon, 13 Nov 2023 02:24:42 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtd2zG3zMpnPr;
	Mon, 13 Nov 2023 03:24:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842282;
	bh=hEzwbKiCPTVRprt7TA2n5SNi5zwGnb2iVWTsgeipVHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6v5KJH9jR6IiLGfGMDtfMvhMpsRKAlNdnYP3VLP1tQYDJsD9yOa1l7BiqESRCqDJ
	 cmZYiFVvTDYPtiXd2tBOhB0CrMCZj3y2+qczeM+o9M04Idv7FHkodSM7IbhjzC/hXd
	 PiK+ofD1UU5HDgZ8vthIvlYSVcyE4os40daGAPbA=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 13/19] heki: Implement a kernel page table walker
Date: Sun, 12 Nov 2023 21:23:20 -0500
Message-ID: <20231113022326.24388-14-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

The Heki feature needs to do the following:

- Find kernel mappings.

- Determine the permissions associated with each mapping.

- Determine the collective permissions for a guest physical page across
  all of its mappings.

This way, a guest physical page can reflect only the required
permissions in the EPT thanks to the KVM_HC_PROTECT_MEMORY hypercall..

Implement a kernel page table walker that walks all of the kernel
mappings and calls a callback function for each mapping.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---

Change since v1:
* New patch and new file: virt/heki/walk.c
---
 include/linux/heki.h |  16 +++++
 virt/heki/Makefile   |   1 +
 virt/heki/walk.c     | 140 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+)
 create mode 100644 virt/heki/walk.c

diff --git a/include/linux/heki.h b/include/linux/heki.h
index 9b0c966c50d1..a7ae0b387dfe 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -61,6 +61,22 @@ struct heki {
 	struct heki_hypervisor *hypervisor;
 };
 
+/*
+ * The kernel page table is walked to locate kernel mappings. For each
+ * mapping, a callback function is called. The table walker passes information
+ * about the mapping to the callback using this structure.
+ */
+struct heki_args {
+	/* Information passed by the table walker to the callback. */
+	unsigned long va;
+	phys_addr_t pa;
+	size_t size;
+	unsigned long flags;
+};
+
+/* Callback function called by the table walker. */
+typedef void (*heki_func_t)(struct heki_args *args);
+
 extern struct heki heki;
 extern bool heki_enabled;
 
diff --git a/virt/heki/Makefile b/virt/heki/Makefile
index 354e567df71c..a5daa4ff7a4f 100644
--- a/virt/heki/Makefile
+++ b/virt/heki/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 obj-y += main.o
+obj-y += walk.o
diff --git a/virt/heki/walk.c b/virt/heki/walk.c
new file mode 100644
index 000000000000..e10b54226fcc
--- /dev/null
+++ b/virt/heki/walk.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Kernel page table walker.
+ *
+ * Copyright © 2023 Microsoft Corporation
+ *
+ * Cf. arch/x86/mm/init_64.c
+ */
+
+#include <linux/heki.h>
+#include <linux/pgtable.h>
+
+static void heki_walk_pte(pmd_t *pmd, unsigned long va, unsigned long va_end,
+			  heki_func_t func, struct heki_args *args)
+{
+	pte_t *pte;
+	unsigned long next_va;
+
+	for (pte = pte_offset_kernel(pmd, va); va < va_end;
+	     va = next_va, pte++) {
+		next_va = (va + PAGE_SIZE) & PAGE_MASK;
+
+		if (next_va > va_end)
+			next_va = va_end;
+
+		if (!pte_present(*pte))
+			continue;
+
+		args->va = va;
+		args->pa = pte_pfn(*pte) << PAGE_SHIFT;
+		args->size = PAGE_SIZE;
+		args->flags = pte_flags(*pte);
+
+		func(args);
+	}
+}
+
+static void heki_walk_pmd(pud_t *pud, unsigned long va, unsigned long va_end,
+			  heki_func_t func, struct heki_args *args)
+{
+	pmd_t *pmd;
+	unsigned long next_va;
+
+	for (pmd = pmd_offset(pud, va); va < va_end; va = next_va, pmd++) {
+		next_va = pmd_addr_end(va, va_end);
+
+		if (!pmd_present(*pmd))
+			continue;
+
+		if (pmd_large(*pmd)) {
+			args->va = va;
+			args->pa = pmd_pfn(*pmd) << PAGE_SHIFT;
+			args->pa += va & (PMD_SIZE - 1);
+			args->size = next_va - va;
+			args->flags = pmd_flags(*pmd);
+
+			func(args);
+		} else {
+			heki_walk_pte(pmd, va, next_va, func, args);
+		}
+	}
+}
+
+static void heki_walk_pud(p4d_t *p4d, unsigned long va, unsigned long va_end,
+			  heki_func_t func, struct heki_args *args)
+{
+	pud_t *pud;
+	unsigned long next_va;
+
+	for (pud = pud_offset(p4d, va); va < va_end; va = next_va, pud++) {
+		next_va = pud_addr_end(va, va_end);
+
+		if (!pud_present(*pud))
+			continue;
+
+		if (pud_large(*pud)) {
+			args->va = va;
+			args->pa = pud_pfn(*pud) << PAGE_SHIFT;
+			args->pa += va & (PUD_SIZE - 1);
+			args->size = next_va - va;
+			args->flags = pud_flags(*pud);
+
+			func(args);
+		} else {
+			heki_walk_pmd(pud, va, next_va, func, args);
+		}
+	}
+}
+
+static void heki_walk_p4d(pgd_t *pgd, unsigned long va, unsigned long va_end,
+			  heki_func_t func, struct heki_args *args)
+{
+	p4d_t *p4d;
+	unsigned long next_va;
+
+	for (p4d = p4d_offset(pgd, va); va < va_end; va = next_va, p4d++) {
+		next_va = p4d_addr_end(va, va_end);
+
+		if (!p4d_present(*p4d))
+			continue;
+
+		if (p4d_large(*p4d)) {
+			args->va = va;
+			args->pa = p4d_pfn(*p4d) << PAGE_SHIFT;
+			args->pa += va & (P4D_SIZE - 1);
+			args->size = next_va - va;
+			args->flags = p4d_flags(*p4d);
+
+			func(args);
+		} else {
+			heki_walk_pud(p4d, va, next_va, func, args);
+		}
+	}
+}
+
+void heki_walk(unsigned long va, unsigned long va_end, heki_func_t func,
+	       struct heki_args *args)
+{
+	pgd_t *pgd;
+	unsigned long next_va;
+
+	for (pgd = pgd_offset_k(va); va < va_end; va = next_va, pgd++) {
+		next_va = pgd_addr_end(va, va_end);
+
+		if (!pgd_present(*pgd))
+			continue;
+
+		if (pgd_large(*pgd)) {
+			args->va = va;
+			args->pa = pgd_pfn(*pgd) << PAGE_SHIFT;
+			args->pa += va & (PGDIR_SIZE - 1);
+			args->size = next_va - va;
+			args->flags = pgd_flags(*pgd);
+
+			func(args);
+		} else {
+			heki_walk_p4d(pgd, va, next_va, func, args);
+		}
+	}
+}
-- 
2.42.1


