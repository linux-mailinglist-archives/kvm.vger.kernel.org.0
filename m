Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0EEA4215AC
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhJDR6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 13:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235542AbhJDR6j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 13:58:39 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AC1A61207;
        Mon,  4 Oct 2021 17:56:50 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mXS5H-00EhBv-I3; Mon, 04 Oct 2021 18:49:03 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 12/16] mm/vmalloc: Add arch-specific callbacks to track io{remap,unmap} physical pages
Date:   Mon,  4 Oct 2021 18:48:45 +0100
Message-Id: <20211004174849.2831548-13-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211004174849.2831548-1-maz@kernel.org>
References: <20211004174849.2831548-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, steven.price@arm.com, drjones@redhat.com, tabba@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a pair of hooks (ioremap_phys_range_hook/iounmap_phys_range_hook)
that can be implemented by an architecture. Contrary to the existing
arch_sync_kernel_mappings(), this one tracks things at the physical
address level.

This is specially useful in these virtualised environments where
the guest has to tell the host whether (and how) it intends to use
a MMIO device.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/io.h |  2 ++
 mm/Kconfig         |  5 +++++
 mm/vmalloc.c       | 12 +++++++++++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index 9595151d800d..84eac81e8834 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -21,6 +21,8 @@ void __ioread32_copy(void *to, const void __iomem *from, size_t count);
 void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 
 #ifdef CONFIG_MMU
+void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot);
+void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size);
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		       phys_addr_t phys_addr, pgprot_t prot);
 #else
diff --git a/mm/Kconfig b/mm/Kconfig
index d16ba9249bc5..a154803836b7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -894,6 +894,11 @@ config IO_MAPPING
 config SECRETMEM
 	def_bool ARCH_HAS_SET_DIRECT_MAP && !EMBEDDED
 
+# Some architectures want callbacks for all IO mappings in order to
+# track the physical addresses that get used as devices.
+config ARCH_HAS_IOREMAP_PHYS_HOOKS
+	bool
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d77830ff604c..babcf3a75502 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -38,6 +38,7 @@
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/io.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -316,9 +317,14 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
 {
 	int err;
 
-	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
+	prot = pgprot_nx(prot);
+	err = vmap_range_noflush(addr, end, phys_addr, prot,
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
+
+	if (IS_ENABLED(CONFIG_ARCH_HAS_IOREMAP_PHYS_HOOKS) && !err)
+		ioremap_phys_range_hook(phys_addr, end - addr, prot);
+
 	return err;
 }
 
@@ -2608,6 +2614,10 @@ static void __vunmap(const void *addr, int deallocate_pages)
 
 	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_IOREMAP_PHYS_HOOKS) &&
+	    area->flags & VM_IOREMAP)
+		iounmap_phys_range_hook(area->phys_addr, get_vm_area_size(area));
+
 	vm_remove_mappings(area, deallocate_pages);
 
 	if (deallocate_pages) {
-- 
2.30.2

