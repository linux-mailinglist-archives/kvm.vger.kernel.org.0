Return-Path: <kvm+bounces-1557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 030A47E9506
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC195281103
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C613A1DA53;
	Mon, 13 Nov 2023 02:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="tSrGiLtu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0A91C291
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:36 +0000 (UTC)
Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fae])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC851BCC
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:29 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCts44SJzMpvdP;
	Mon, 13 Nov 2023 02:24:53 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtr2nMzz3W;
	Mon, 13 Nov 2023 03:24:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842293;
	bh=xCal4QiPzuyoIMCQ55fNeQ6igvrqyER4Ogi9VJWigXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSrGiLtuSOlTibjuVDi1SgaJbkgBVfdywQJICFGMkZZbetDA86MTLx1CUJrtURSJN
	 PCIUP107oOKIFocIkyU1oVto05PKP3vEUaLGG4TW793G5zq8LWUqWguccvZHAbm47M
	 LggTT2pvie45aa6Z33u6iroI0xd/t/vhEQdIBxuk=
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
Subject: [RFC PATCH v2 16/19] heki: x86: Update permissions counters when guest page permissions change
Date: Sun, 12 Nov 2023 21:23:23 -0500
Message-ID: <20231113022326.24388-17-mic@digikod.net>
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

When permissions are changed on an existing mapping, update the
permissions counters.

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
 arch/x86/mm/heki.c           |  9 +++++++
 arch/x86/mm/pat/set_memory.c | 51 ++++++++++++++++++++++++++++++++++++
 include/linux/heki.h         | 14 ++++++++++
 virt/heki/counters.c         | 23 ++++++++++++++++
 4 files changed, 97 insertions(+)

diff --git a/arch/x86/mm/heki.c b/arch/x86/mm/heki.c
index c495df0d8772..c0eace9e343f 100644
--- a/arch/x86/mm/heki.c
+++ b/arch/x86/mm/heki.c
@@ -54,3 +54,12 @@ unsigned long heki_flags_to_permissions(unsigned long flags)
 
 	return permissions;
 }
+
+void heki_pgprot_to_permissions(pgprot_t prot, unsigned long *set,
+				unsigned long *clear)
+{
+	if (pgprot_val(prot) & _PAGE_RW)
+		*set |= MEM_ATTR_WRITE;
+	if (pgprot_val(prot) & _PAGE_NX)
+		*clear |= MEM_ATTR_EXEC;
+}
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index bda9f129835e..6aaa1ce5692c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/heki.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -2056,11 +2057,56 @@ int clear_mce_nospec(unsigned long pfn)
 EXPORT_SYMBOL_GPL(clear_mce_nospec);
 #endif /* CONFIG_X86_64 */
 
+#ifdef CONFIG_HEKI
+
+static void heki_change_page_attr_set(unsigned long va, int numpages,
+				      pgprot_t set)
+{
+	unsigned long va_end;
+	unsigned long set_permissions = 0, clear_permissions = 0;
+
+	heki_pgprot_to_permissions(set, &set_permissions, &clear_permissions);
+	if (!(set_permissions | clear_permissions))
+		return;
+
+	va_end = va + (numpages << PAGE_SHIFT);
+	heki_update(va, va_end, set_permissions, clear_permissions);
+}
+
+static void heki_change_page_attr_clear(unsigned long va, int numpages,
+					pgprot_t clear)
+{
+	unsigned long va_end;
+	unsigned long set_permissions = 0, clear_permissions = 0;
+
+	heki_pgprot_to_permissions(clear, &clear_permissions, &set_permissions);
+	if (!(set_permissions | clear_permissions))
+		return;
+
+	va_end = va + (numpages << PAGE_SHIFT);
+	heki_update(va, va_end, set_permissions, clear_permissions);
+}
+
+#else /* !CONFIG_HEKI */
+
+static void heki_change_page_attr_set(unsigned long va, int numpages,
+				      pgprot_t set)
+{
+}
+
+static void heki_change_page_attr_clear(unsigned long va, int numpages,
+					pgprot_t clear)
+{
+}
+
+#endif /* CONFIG_HEKI */
+
 int set_memory_x(unsigned long addr, int numpages)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return 0;
 
+	heki_change_page_attr_clear(addr, numpages, __pgprot(_PAGE_NX));
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 
@@ -2069,11 +2115,14 @@ int set_memory_nx(unsigned long addr, int numpages)
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return 0;
 
+	heki_change_page_attr_set(addr, numpages, __pgprot(_PAGE_NX));
 	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 
 int set_memory_ro(unsigned long addr, int numpages)
 {
+	// TODO: What about _PAGE_DIRTY?
+	heki_change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
 	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_RW | _PAGE_DIRTY), 0);
 }
 
@@ -2084,11 +2133,13 @@ int set_memory_rox(unsigned long addr, int numpages)
 	if (__supported_pte_mask & _PAGE_NX)
 		clr.pgprot |= _PAGE_NX;
 
+	heki_change_page_attr_clear(addr, numpages, clr);
 	return change_page_attr_clear(&addr, numpages, clr, 0);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
+	heki_change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
 	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
diff --git a/include/linux/heki.h b/include/linux/heki.h
index d660994d34d0..079b34af07f0 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -73,6 +73,7 @@ struct heki_hypervisor {
  *
  *	- a page is mapped into the kernel address space
  *	- a page is unmapped from the kernel address space
+ *	- permissions are changed for a mapped page
  */
 struct heki {
 	struct heki_hypervisor *hypervisor;
@@ -81,6 +82,7 @@ struct heki {
 
 enum heki_cmd {
 	HEKI_MAP,
+	HEKI_UPDATE,
 	HEKI_UNMAP,
 };
 
@@ -98,6 +100,10 @@ struct heki_args {
 
 	/* Command passed by caller. */
 	enum heki_cmd cmd;
+
+	/* Permissions passed by heki_update(). */
+	unsigned long set;
+	unsigned long clear;
 };
 
 /* Callback function called by the table walker. */
@@ -114,11 +120,15 @@ void heki_counters_init(void);
 void heki_walk(unsigned long va, unsigned long va_end, heki_func_t func,
 	       struct heki_args *args);
 void heki_map(unsigned long va, unsigned long end);
+void heki_update(unsigned long va, unsigned long end, unsigned long set,
+		 unsigned long clear);
 void heki_unmap(unsigned long va, unsigned long end);
 
 /* Arch-specific functions. */
 void heki_arch_early_init(void);
 unsigned long heki_flags_to_permissions(unsigned long flags);
+void heki_pgprot_to_permissions(pgprot_t prot, unsigned long *set,
+				unsigned long *clear);
 
 #else /* !CONFIG_HEKI */
 
@@ -131,6 +141,10 @@ static inline void heki_late_init(void)
 static inline void heki_map(unsigned long va, unsigned long end)
 {
 }
+static inline void heki_update(unsigned long va, unsigned long end,
+			       unsigned long set, unsigned long clear)
+{
+}
 static inline void heki_unmap(unsigned long va, unsigned long end)
 {
 }
diff --git a/virt/heki/counters.c b/virt/heki/counters.c
index adc8d566b8a9..d0f830b0775a 100644
--- a/virt/heki/counters.c
+++ b/virt/heki/counters.c
@@ -88,6 +88,13 @@ void heki_callback(struct heki_args *args)
 			heki_update_counters(counters, 0, permissions, 0);
 			break;
 
+		case HEKI_UPDATE:
+			if (!counters)
+				continue;
+			heki_update_counters(counters, permissions, args->set,
+					     args->clear);
+			break;
+
 		case HEKI_UNMAP:
 			if (WARN_ON_ONCE(!counters))
 				break;
@@ -131,6 +138,22 @@ void heki_map(unsigned long va, unsigned long end)
 	heki_func(va, end, &args);
 }
 
+/*
+ * Find the mappings in the given range and update permission counters for
+ * them. Apply permissions in the host page table.
+ */
+void heki_update(unsigned long va, unsigned long end, unsigned long set,
+		 unsigned long clear)
+{
+	struct heki_args args = {
+		.cmd = HEKI_UPDATE,
+		.set = set,
+		.clear = clear,
+	};
+
+	heki_func(va, end, &args);
+}
+
 /*
  * Find the mappings in the given range and revert the permission counters for
  * them.
-- 
2.42.1


