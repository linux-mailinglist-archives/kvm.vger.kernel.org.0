Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6097DBB576
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439775AbfIWNfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:48 -0400
Received: from foss.arm.com ([217.140.110.172]:42346 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439766AbfIWNfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB78B1000;
        Mon, 23 Sep 2019 06:35:46 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C88673F694;
        Mon, 23 Sep 2019 06:35:45 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 08/16] arm: Move anything related to RAM initialization in kvm__init_ram
Date:   Mon, 23 Sep 2019 14:35:14 +0100
Message-Id: <1569245722-23375-9-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Grall <julien.grall@arm.com>

RAM initialization is currently split between kvm__init_ram and
kvm__arch_init.  Move all code related to RAM initialization to
kvm__init_ram.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c | 75 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 5decc138fd3e..3e49db7704aa 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -29,44 +29,6 @@ void kvm__init_ram(struct kvm *kvm)
 	int err;
 	u64 phys_start, phys_size;
 	void *host_mem;
-
-	phys_start	= ARM_MEMORY_AREA;
-	phys_size	= kvm->ram_size;
-	host_mem	= kvm->ram_start;
-
-	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
-	if (err)
-		die("Failed to register %lld bytes of memory at physical "
-		    "address 0x%llx [err %d]", phys_size, phys_start, err);
-
-	kvm->arch.memory_guest_start = phys_start;
-}
-
-void kvm__arch_delete_ram(struct kvm *kvm)
-{
-	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
-}
-
-void kvm__arch_read_term(struct kvm *kvm)
-{
-	serial8250__update_consoles(kvm);
-	virtio_console__inject_interrupt(kvm);
-}
-
-void kvm__arch_set_cmdline(char *cmdline, bool video)
-{
-}
-
-void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
-{
-	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
-		cfg->ram_size = ARM_MAX_MEMORY(cfg);
-		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
-	}
-}
-
-void kvm__arch_init(struct kvm *kvm)
-{
 	unsigned long alignment;
 	/* Convenience aliases */
 	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
@@ -115,6 +77,43 @@ void kvm__arch_init(struct kvm *kvm)
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
 
+	phys_start	= ARM_MEMORY_AREA;
+	phys_size	= kvm->ram_size;
+	host_mem	= kvm->ram_start;
+
+	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	if (err)
+		die("Failed to register %lld bytes of memory at physical "
+		    "address 0x%llx [err %d]", phys_size, phys_start, err);
+
+	kvm->arch.memory_guest_start = phys_start;
+}
+
+void kvm__arch_delete_ram(struct kvm *kvm)
+{
+	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
+}
+
+void kvm__arch_read_term(struct kvm *kvm)
+{
+	serial8250__update_consoles(kvm);
+	virtio_console__inject_interrupt(kvm);
+}
+
+void kvm__arch_set_cmdline(char *cmdline, bool video)
+{
+}
+
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
+{
+	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
+		cfg->ram_size = ARM_MAX_MEMORY(cfg);
+		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
+	}
+}
+
+void kvm__arch_init(struct kvm *kvm)
+{
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
-- 
2.7.4

