Return-Path: <kvm+bounces-1553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5190C7E94F6
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB8C4B20F09
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5B01CA92;
	Mon, 13 Nov 2023 02:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="K5jzM4Xu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801C218623
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:32 +0000 (UTC)
Received: from smtp-190e.mail.infomaniak.ch (smtp-190e.mail.infomaniak.ch [185.125.25.14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A51BFF
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:29 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtn6lRlzMpvf0;
	Mon, 13 Nov 2023 02:24:49 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtn0kJDz3W;
	Mon, 13 Nov 2023 03:24:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842289;
	bh=oIX4MzUmE/Oa64hLfkUteDWwPQashM0GHMQHapB48so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5jzM4XuFLgeXCO9+orL/1d6/57akoG8sVCXVP6DTx3kGnM8+LT8Zp4EFmKLEQVJU
	 byp0y0LRrf6MzvP+HnMoZzEDuC6dqCMBtuBJ4XXTKeXfqgWYy3j1J1518WlBYsj24n
	 4qx1SQ23tdaoLwB2+k7Q0uM0YzOX+D/zb42fxDvg=
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
Subject: [RFC PATCH v2 15/19] heki: x86: Initialize permissions counters for pages in vmap()/vunmap()
Date: Sun, 12 Nov 2023 21:23:22 -0500
Message-ID: <20231113022326.24388-16-mic@digikod.net>
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

When a page gets mapped, create permissions counters for it and
initialize them based on the specified permissions.

When a page gets unmapped, update the counters appropriately.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
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
 include/linux/heki.h | 11 ++++++++++-
 mm/vmalloc.c         |  7 +++++++
 virt/heki/counters.c | 20 ++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/heki.h b/include/linux/heki.h
index 86c787d121e0..d660994d34d0 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -68,7 +68,11 @@ struct heki_hypervisor {
  * pointer into this heki structure.
  *
  * During guest kernel boot, permissions counters for each guest page are
- * initialized based on the page's current permissions.
+ * initialized based on the page's current permissions. Beyond this point,
+ * the counters are updated whenever:
+ *
+ *	- a page is mapped into the kernel address space
+ *	- a page is unmapped from the kernel address space
  */
 struct heki {
 	struct heki_hypervisor *hypervisor;
@@ -77,6 +81,7 @@ struct heki {
 
 enum heki_cmd {
 	HEKI_MAP,
+	HEKI_UNMAP,
 };
 
 /*
@@ -109,6 +114,7 @@ void heki_counters_init(void);
 void heki_walk(unsigned long va, unsigned long va_end, heki_func_t func,
 	       struct heki_args *args);
 void heki_map(unsigned long va, unsigned long end);
+void heki_unmap(unsigned long va, unsigned long end);
 
 /* Arch-specific functions. */
 void heki_arch_early_init(void);
@@ -125,6 +131,9 @@ static inline void heki_late_init(void)
 static inline void heki_map(unsigned long va, unsigned long end)
 {
 }
+static inline void heki_unmap(unsigned long va, unsigned long end)
+{
+}
 
 #endif /* CONFIG_HEKI */
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a3fedb3ee0db..d9096502e571 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -40,6 +40,7 @@
 #include <linux/pgtable.h>
 #include <linux/hugetlb.h>
 #include <linux/sched/mm.h>
+#include <linux/heki.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -301,6 +302,8 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
+	heki_map(start, end);
+
 	return err;
 }
 
@@ -419,6 +422,8 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 	pgtbl_mod_mask mask = 0;
 
 	BUG_ON(addr >= end);
+	heki_unmap(start, end);
+
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
@@ -564,6 +569,8 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
 		arch_sync_kernel_mappings(start, end);
 
+	heki_map(start, end);
+
 	return 0;
 }
 
diff --git a/virt/heki/counters.c b/virt/heki/counters.c
index 7067449cabca..adc8d566b8a9 100644
--- a/virt/heki/counters.c
+++ b/virt/heki/counters.c
@@ -88,6 +88,13 @@ void heki_callback(struct heki_args *args)
 			heki_update_counters(counters, 0, permissions, 0);
 			break;
 
+		case HEKI_UNMAP:
+			if (WARN_ON_ONCE(!counters))
+				break;
+			heki_update_counters(counters, permissions, 0,
+					     permissions);
+			break;
+
 		default:
 			WARN_ON_ONCE(1);
 			break;
@@ -124,6 +131,19 @@ void heki_map(unsigned long va, unsigned long end)
 	heki_func(va, end, &args);
 }
 
+/*
+ * Find the mappings in the given range and revert the permission counters for
+ * them.
+ */
+void heki_unmap(unsigned long va, unsigned long end)
+{
+	struct heki_args args = {
+		.cmd = HEKI_UNMAP,
+	};
+
+	heki_func(va, end, &args);
+}
+
 /*
  * Permissions counters are associated with each guest page using the
  * Memory Table feature. Initialize the permissions counters here.
-- 
2.42.1


