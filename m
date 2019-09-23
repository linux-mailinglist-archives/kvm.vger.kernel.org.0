Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5A2BB579
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfIWNfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:53 -0400
Received: from foss.arm.com ([217.140.110.172]:42380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728460AbfIWNfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8A1D1576;
        Mon, 23 Sep 2019 06:35:51 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B58F33F694;
        Mon, 23 Sep 2019 06:35:50 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 12/16] Fold kvm__init_ram call in kvm__arch_init and rename it
Date:   Mon, 23 Sep 2019 14:35:18 +0100
Message-Id: <1569245722-23375-13-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Grall <julien.grall@arm.com>

When we will add support for allocating the MMIO memory dynamically, we
will need to initialize the memory before the irqchip. Move the
kvm__init_ram call in kvm__arch_init so we can be flexible in the future
with the regards to when we call it.

kvm__init_ram isn't a globally visible function anymore, so rename it to
init_ram.

Note that it is necessary to move the call to kvm__arch_init after the
initialization of the list kvm->mem_banks because kvm__init_ram was
relying on it.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c         | 4 +++-
 include/kvm/kvm.h | 1 -
 kvm.c             | 4 +---
 mips/kvm.c        | 4 +++-
 powerpc/kvm.c     | 4 +++-
 x86/kvm.c         | 6 ++++--
 6 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 355c118b098a..138ef5763cc2 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -24,7 +24,7 @@ bool kvm__arch_cpu_supports_vm(void)
 	return true;
 }
 
-void kvm__init_ram(struct kvm *kvm)
+static void init_ram(struct kvm *kvm)
 {
 	int err;
 	u64 phys_start, phys_size;
@@ -126,6 +126,8 @@ void kvm__arch_init(struct kvm *kvm)
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
+
+	init_ram(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index a866d5a825c4..8787a92b4dbb 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -94,7 +94,6 @@ int kvm__init(struct kvm *kvm);
 struct kvm *kvm__new(void);
 int kvm__recommended_cpus(struct kvm *kvm);
 int kvm__max_cpus(struct kvm *kvm);
-void kvm__init_ram(struct kvm *kvm);
 int kvm__exit(struct kvm *kvm);
 bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename);
 bool kvm__load_kernel(struct kvm *kvm, const char *kernel_filename,
diff --git a/kvm.c b/kvm.c
index 55a7465960b0..4da413e0681d 100644
--- a/kvm.c
+++ b/kvm.c
@@ -398,10 +398,8 @@ int kvm__init(struct kvm *kvm)
 		goto err_vm_fd;
 	}
 
-	kvm__arch_init(kvm);
-
 	INIT_LIST_HEAD(&kvm->mem_banks);
-	kvm__init_ram(kvm);
+	kvm__arch_init(kvm);
 
 	if (!kvm->cfg.firmware_filename) {
 		if (!kvm__load_kernel(kvm, kvm->cfg.kernel_filename,
diff --git a/mips/kvm.c b/mips/kvm.c
index 63d651f29f70..54f1c134a9d7 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -17,7 +17,7 @@ void kvm__arch_read_term(struct kvm *kvm)
 	virtio_console__inject_interrupt(kvm);
 }
 
-void kvm__init_ram(struct kvm *kvm)
+static void init_ram(struct kvm *kvm)
 {
 	u64	phys_start, phys_size;
 	void	*host_mem;
@@ -80,6 +80,8 @@ void kvm__arch_init(struct kvm *kvm)
 	ret = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
 	if (ret < 0)
 		die_perror("KVM_CREATE_IRQCHIP ioctl");
+
+	init_ram(kvm);
 }
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 73965640cf82..3a5e11eee806 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -60,7 +60,7 @@ bool kvm__arch_cpu_supports_vm(void)
 	return true;
 }
 
-void kvm__init_ram(struct kvm *kvm)
+static void init_ram(struct kvm *kvm)
 {
 	u64	phys_start, phys_size;
 	void	*host_mem;
@@ -144,6 +144,8 @@ void kvm__arch_init(struct kvm *kvm)
 			 SPAPR_PCI_MEM_WIN_SIZE,
 			 SPAPR_PCI_IO_WIN_ADDR,
 			 SPAPR_PCI_IO_WIN_SIZE);
+
+	init_ram(kvm);
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
diff --git a/x86/kvm.c b/x86/kvm.c
index df5d48106c80..2627fcb959b5 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -86,7 +86,7 @@ bool kvm__arch_cpu_supports_vm(void)
  * a gap between 0xe0000000 and 0x100000000 in the guest virtual mem space.
  */
 
-void kvm__init_ram(struct kvm *kvm)
+static void init_ram(struct kvm *kvm)
 {
 	u64	phys_start, phys_size;
 	void	*host_mem;
@@ -165,7 +165,7 @@ void kvm__arch_init(struct kvm *kvm)
 		kvm->ram_size = ram_size + KVM_32BIT_GAP_SIZE;
 		if (kvm->ram_start != MAP_FAILED)
 			/*
-			 * We mprotect the gap (see kvm__init_ram() for details) PROT_NONE so that
+			 * We mprotect the gap (see init_ram() for details) PROT_NONE so that
 			 * if we accidently write to it, we will know.
 			 */
 			mprotect(kvm->ram_start + KVM_32BIT_GAP_START, KVM_32BIT_GAP_SIZE, PROT_NONE);
@@ -178,6 +178,8 @@ void kvm__arch_init(struct kvm *kvm)
 	ret = ioctl(kvm->vm_fd, KVM_CREATE_IRQCHIP);
 	if (ret < 0)
 		die_perror("KVM_CREATE_IRQCHIP ioctl");
+
+	init_ram(kvm);
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
-- 
2.7.4

