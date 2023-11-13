Return-Path: <kvm+bounces-1542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CC47E949B
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D21FF280B40
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C7E8820;
	Mon, 13 Nov 2023 02:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="dJfAiYA2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030508472
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:25:15 +0000 (UTC)
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [IPv6:2001:1600:3:17::1909])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55F6385D
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:25:06 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtx4lfyzMq2H9;
	Mon, 13 Nov 2023 02:24:57 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtw1z09zMpnPr;
	Mon, 13 Nov 2023 03:24:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842297;
	bh=x8fg6SD1g74kkGJ23TK2HH1loleby/1wIvw5whB02rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJfAiYA2HYA3jqI/ZQKjz5gzrQbNbqyogck83ckqbDcyi+QeXvv9eLzd5ebcYVOvo
	 cLtZ+H/07iEl7T5kTrk2eFqbGuc3VumW1ct0jF8/XyG299t2fBuDo8YODWnquBbTNY
	 ymQ6InNw/ozaj7PTIf8MX7lr4GmSX3s7IhzlnmOM=
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
Subject: [RFC PATCH v2 17/19] heki: x86: Update permissions counters during text patching
Date: Sun, 12 Nov 2023 21:23:24 -0500
Message-ID: <20231113022326.24388-18-mic@digikod.net>
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

X86 uses a function called __text_poke() to modify executable code. This
patching function is used by many features such as KProbes and FTrace.

Update the permissions counters for the text page so that write
permissions can be temporarily established in the EPT to modify the
instructions in that page.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---

Changes since v1:
* New patch
---
 arch/x86/kernel/alternative.c |  5 ++++
 arch/x86/mm/heki.c            | 49 +++++++++++++++++++++++++++++++++++
 include/linux/heki.h          | 14 ++++++++++
 3 files changed, 68 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 517ee01503be..64fd8757ba5c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -18,6 +18,7 @@
 #include <linux/mmu_context.h>
 #include <linux/bsearch.h>
 #include <linux/sync_core.h>
+#include <linux/heki.h>
 #include <asm/text-patching.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
@@ -1801,6 +1802,7 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
 	 */
 	pgprot = __pgprot(pgprot_val(PAGE_KERNEL) & ~_PAGE_GLOBAL);
 
+	heki_text_poke_start(pages, cross_page_boundary ? 2 : 1, pgprot);
 	/*
 	 * The lock is not really needed, but this allows to avoid open-coding.
 	 */
@@ -1865,7 +1867,10 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
 	}
 
 	local_irq_restore(flags);
+
 	pte_unmap_unlock(ptep, ptl);
+	heki_text_poke_end(pages, cross_page_boundary ? 2 : 1, pgprot);
+
 	return addr;
 }
 
diff --git a/arch/x86/mm/heki.c b/arch/x86/mm/heki.c
index c0eace9e343f..e4c60d8b4f2d 100644
--- a/arch/x86/mm/heki.c
+++ b/arch/x86/mm/heki.c
@@ -5,8 +5,11 @@
  * Copyright © 2023 Microsoft Corporation
  */
 
+#include <asm/pgtable.h>
+#include <asm/text-patching.h>
 #include <linux/heki.h>
 #include <linux/kvm_mem_attr.h>
+#include <linux/mm.h>
 
 #ifdef pr_fmt
 #undef pr_fmt
@@ -63,3 +66,49 @@ void heki_pgprot_to_permissions(pgprot_t prot, unsigned long *set,
 	if (pgprot_val(prot) & _PAGE_NX)
 		*clear |= MEM_ATTR_EXEC;
 }
+
+static unsigned long heki_pgprot_to_flags(pgprot_t prot)
+{
+	unsigned long flags = 0;
+
+	if (pgprot_val(prot) & _PAGE_RW)
+		flags |= _PAGE_RW;
+	if (pgprot_val(prot) & _PAGE_NX)
+		flags |= _PAGE_NX;
+	return flags;
+}
+
+static void heki_text_poke_common(struct page **pages, int npages,
+				  pgprot_t prot, enum heki_cmd cmd)
+{
+	struct heki_args args = {
+		.cmd = cmd,
+	};
+	unsigned long va = poking_addr;
+	int i;
+
+	if (!heki.counters)
+		return;
+
+	mutex_lock(&heki_lock);
+
+	for (i = 0; i < npages; i++, va += PAGE_SIZE) {
+		args.va = va;
+		args.pa = page_to_pfn(pages[i]) << PAGE_SHIFT;
+		args.size = PAGE_SIZE;
+		args.flags = heki_pgprot_to_flags(prot);
+		heki_callback(&args);
+	}
+
+	mutex_unlock(&heki_lock);
+}
+
+void heki_text_poke_start(struct page **pages, int npages, pgprot_t prot)
+{
+	heki_text_poke_common(pages, npages, prot, HEKI_MAP);
+}
+
+void heki_text_poke_end(struct page **pages, int npages, pgprot_t prot)
+{
+	heki_text_poke_common(pages, npages, prot, HEKI_UNMAP);
+}
diff --git a/include/linux/heki.h b/include/linux/heki.h
index 079b34af07f0..6f2cfddc6dac 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -111,6 +111,7 @@ typedef void (*heki_func_t)(struct heki_args *args);
 
 extern struct heki heki;
 extern bool heki_enabled;
+extern struct mutex heki_lock;
 
 extern bool __read_mostly enable_mbec;
 
@@ -123,12 +124,15 @@ void heki_map(unsigned long va, unsigned long end);
 void heki_update(unsigned long va, unsigned long end, unsigned long set,
 		 unsigned long clear);
 void heki_unmap(unsigned long va, unsigned long end);
+void heki_callback(struct heki_args *args);
 
 /* Arch-specific functions. */
 void heki_arch_early_init(void);
 unsigned long heki_flags_to_permissions(unsigned long flags);
 void heki_pgprot_to_permissions(pgprot_t prot, unsigned long *set,
 				unsigned long *clear);
+void heki_text_poke_start(struct page **pages, int npages, pgprot_t prot);
+void heki_text_poke_end(struct page **pages, int npages, pgprot_t prot);
 
 #else /* !CONFIG_HEKI */
 
@@ -149,6 +153,16 @@ static inline void heki_unmap(unsigned long va, unsigned long end)
 {
 }
 
+/* Arch-specific functions. */
+static inline void heki_text_poke_start(struct page **pages, int npages,
+					pgprot_t prot)
+{
+}
+static inline void heki_text_poke_end(struct page **pages, int npages,
+				      pgprot_t prot)
+{
+}
+
 #endif /* CONFIG_HEKI */
 
 #endif /* __HEKI_H__ */
-- 
2.42.1


