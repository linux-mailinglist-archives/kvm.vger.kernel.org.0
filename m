Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB56BB570
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408120AbfIWNfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:40 -0400
Received: from foss.arm.com ([217.140.110.172]:42292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404581AbfIWNfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CE2A1000;
        Mon, 23 Sep 2019 06:35:39 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6AC773F694;
        Mon, 23 Sep 2019 06:35:38 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 02/16] kvm__arch_init: Don't pass hugetlbfs_path and ram_size in parameter
Date:   Mon, 23 Sep 2019 14:35:08 +0100
Message-Id: <1569245722-23375-3-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Grall <julien.grall@arm.com>

The structure KVM already contains a pointer to the configuration. Both
hugetlbfs_path and ram_size are part of the configuration, so is it not
necessary to path them again in parameter.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm.c         | 5 ++++-
 include/kvm/kvm.h | 2 +-
 kvm.c             | 2 +-
 mips/kvm.c        | 5 ++++-
 powerpc/kvm.c     | 5 ++++-
 x86/kvm.c         | 5 ++++-
 6 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index 1c5bdb8026bf..198cee5c0997 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -57,9 +57,12 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
 }
 
-void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
+void kvm__arch_init(struct kvm *kvm)
 {
 	unsigned long alignment;
+	/* Convenience aliases */
+	u64 ram_size = kvm->cfg.ram_size;
+	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
 
 	/*
 	 * Allocate guest memory. If the user wants to use hugetlbfs, then the
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 7a738183d67a..635ce0f40b1e 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -140,7 +140,7 @@ int kvm__enumerate_instances(int (*callback)(const char *name, int pid));
 void kvm__remove_socket(const char *name);
 
 void kvm__arch_set_cmdline(char *cmdline, bool video);
-void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size);
+void kvm__arch_init(struct kvm *kvm);
 void kvm__arch_delete_ram(struct kvm *kvm);
 int kvm__arch_setup_firmware(struct kvm *kvm);
 int kvm__arch_free_firmware(struct kvm *kvm);
diff --git a/kvm.c b/kvm.c
index 57c4ff98ec4c..36b238791fc1 100644
--- a/kvm.c
+++ b/kvm.c
@@ -392,7 +392,7 @@ int kvm__init(struct kvm *kvm)
 		goto err_vm_fd;
 	}
 
-	kvm__arch_init(kvm, kvm->cfg.hugetlbfs_path, kvm->cfg.ram_size);
+	kvm__arch_init(kvm);
 
 	INIT_LIST_HEAD(&kvm->mem_banks);
 	kvm__init_ram(kvm);
diff --git a/mips/kvm.c b/mips/kvm.c
index 211770da0d85..e2a0c63b14b8 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -57,9 +57,12 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 }
 
 /* Architecture-specific KVM init */
-void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
+void kvm__arch_init(struct kvm *kvm)
 {
 	int ret;
+	/* Convenience aliases */
+	u64 ram_size = kvm->cfg.ram_size;
+	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
 
 	kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, ram_size);
 	kvm->ram_size = ram_size;
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 702d67dca614..034bc4608ad9 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -88,10 +88,13 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 }
 
 /* Architecture-specific KVM init */
-void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
+void kvm__arch_init(struct kvm *kvm)
 {
 	int cap_ppc_rma;
 	unsigned long hpt;
+	/* Convenience aliases */
+	u64 ram_size = kvm->cfg.ram_size;
+	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
 
 	kvm->ram_size		= ram_size;
 
diff --git a/x86/kvm.c b/x86/kvm.c
index 3e0f0b743f8c..5abb41e370bb 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -130,10 +130,13 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 }
 
 /* Architecture-specific KVM init */
-void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
+void kvm__arch_init(struct kvm *kvm)
 {
 	struct kvm_pit_config pit_config = { .flags = 0, };
 	int ret;
+	/* Convenience aliases */
+	u64 ram_size = kvm->cfg.ram_size;
+	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
 
 	ret = ioctl(kvm->vm_fd, KVM_SET_TSS_ADDR, 0xfffbd000);
 	if (ret < 0)
-- 
2.7.4

