Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD05BB572
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439661AbfIWNfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:43 -0400
Received: from foss.arm.com ([217.140.110.172]:42312 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437017AbfIWNfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBCF91597;
        Mon, 23 Sep 2019 06:35:41 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D960E3F694;
        Mon, 23 Sep 2019 06:35:40 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 04/16] kvmtool: Add helper to sanitize arch specific KVM configuration
Date:   Mon, 23 Sep 2019 14:35:10 +0100
Message-Id: <1569245722-23375-5-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool accepts generic and architecture specific parameters. When creating
a virtual machine, only the generic parameters are checked against sane
values. Add a function to sanitize the architecture specific configuration
options and call it before the initialization routines.

This patch was inspired by Julien Grall's patch.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/kvm/kvm-arch.h |  2 +-
 arm/include/arm-common/kvm-arch.h  |  4 ++++
 arm/kvm.c                          | 11 +++++++++--
 builtin-run.c                      |  2 ++
 mips/include/kvm/kvm-arch.h        |  4 ++++
 mips/kvm.c                         |  5 +++++
 powerpc/include/kvm/kvm-arch.h     |  4 ++++
 powerpc/kvm.c                      |  5 +++++
 x86/include/kvm/kvm-arch.h         |  4 ++++
 x86/kvm.c                          | 24 ++++++++++++------------
 10 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 9de623ac6cb9..1b3d0a5fb1b4 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -5,7 +5,7 @@
 				0x8000				:	\
 				0x80000)
 
-#define ARM_MAX_MEMORY(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
+#define ARM_MAX_MEMORY(cfg)	((cfg)->arch.aarch32_guest	?	\
 				ARM_LOMAP_MAX_MEMORY		:	\
 				ARM_HIMAP_MAX_MEMORY)
 
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b9d486d5eac2..965978d7cfb5 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -74,4 +74,8 @@ struct kvm_arch {
 	u64	dtb_guest_start;
 };
 
+struct kvm_config;
+
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg);
+
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index 198cee5c0997..5decc138fd3e 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -57,11 +57,18 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 {
 }
 
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
+{
+	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
+		cfg->ram_size = ARM_MAX_MEMORY(cfg);
+		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
+	}
+}
+
 void kvm__arch_init(struct kvm *kvm)
 {
 	unsigned long alignment;
 	/* Convenience aliases */
-	u64 ram_size = kvm->cfg.ram_size;
 	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
 
 	/*
@@ -87,7 +94,7 @@ void kvm__arch_init(struct kvm *kvm)
 			alignment = SZ_2M;
 	}
 
-	kvm->ram_size = min(ram_size, (u64)ARM_MAX_MEMORY(kvm));
+	kvm->ram_size = kvm->cfg.ram_size;
 	kvm->arch.ram_alloc_size = kvm->ram_size + alignment;
 	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
 						kvm->arch.ram_alloc_size);
diff --git a/builtin-run.c b/builtin-run.c
index c867c8ba0892..532c06f90ba0 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -642,6 +642,8 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	kvm->cfg.real_cmdline = real_cmdline;
 
+	kvm__arch_sanitize_cfg(&kvm->cfg);
+
 	if (kvm->cfg.kernel_filename) {
 		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
 		       kvm->cfg.kernel_filename,
diff --git a/mips/include/kvm/kvm-arch.h b/mips/include/kvm/kvm-arch.h
index fdc09d830263..f0bfff50c7c9 100644
--- a/mips/include/kvm/kvm-arch.h
+++ b/mips/include/kvm/kvm-arch.h
@@ -47,4 +47,8 @@ struct kvm_arch {
 	bool is64bit;
 };
 
+struct kvm_config;
+
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/mips/kvm.c b/mips/kvm.c
index e2a0c63b14b8..63d651f29f70 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -56,6 +56,11 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 }
 
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
+{
+	/* We don't have any arch specific configuration. */
+}
+
 /* Architecture-specific KVM init */
 void kvm__arch_init(struct kvm *kvm)
 {
diff --git a/powerpc/include/kvm/kvm-arch.h b/powerpc/include/kvm/kvm-arch.h
index 8126b96cb66a..42ea7df1325f 100644
--- a/powerpc/include/kvm/kvm-arch.h
+++ b/powerpc/include/kvm/kvm-arch.h
@@ -64,4 +64,8 @@ struct kvm_arch {
 	struct spapr_phb	*phb;
 };
 
+struct kvm_config;
+
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 034bc4608ad9..73965640cf82 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -87,6 +87,11 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 	/* We don't need anything unusual in here. */
 }
 
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
+{
+	/* We don't have any arch specific configuration. */
+}
+
 /* Architecture-specific KVM init */
 void kvm__arch_init(struct kvm *kvm)
 {
diff --git a/x86/include/kvm/kvm-arch.h b/x86/include/kvm/kvm-arch.h
index bfdd3438a9de..2cc65f30fcd2 100644
--- a/x86/include/kvm/kvm-arch.h
+++ b/x86/include/kvm/kvm-arch.h
@@ -40,4 +40,8 @@ struct kvm_arch {
 	struct interrupt_table	interrupt_table;
 };
 
+struct kvm_config;
+
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/x86/kvm.c b/x86/kvm.c
index 5abb41e370bb..df5d48106c80 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -129,6 +129,17 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 		strcat(cmdline, " earlyprintk=serial i8042.noaux=1");
 }
 
+void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
+{
+	/* vidmode should be either specified or set by default */
+	if (cfg->vnc || cfg->sdl || cfg->gtk) {
+		if (!cfg->arch.vidmode)
+			cfg->arch.vidmode = 0x312;
+	} else {
+		cfg->arch.vidmode = 0;
+	}
+}
+
 /* Architecture-specific KVM init */
 void kvm__arch_init(struct kvm *kvm)
 {
@@ -239,7 +250,6 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	size_t cmdline_size;
 	ssize_t file_size;
 	void *p;
-	u16 vidmode;
 
 	/*
 	 * See Documentation/x86/boot.txt for details no bzImage on-disk and
@@ -282,23 +292,13 @@ static bool load_bzimage(struct kvm *kvm, int fd_kernel, int fd_initrd,
 		memcpy(p, kernel_cmdline, cmdline_size - 1);
 	}
 
-	/* vidmode should be either specified or set by default */
-	if (kvm->cfg.vnc || kvm->cfg.sdl || kvm->cfg.gtk) {
-		if (!kvm->cfg.arch.vidmode)
-			vidmode = 0x312;
-		else
-			vidmode = kvm->cfg.arch.vidmode;
-	} else {
-		vidmode = 0;
-	}
-
 	kern_boot	= guest_real_to_host(kvm, BOOT_LOADER_SELECTOR, 0x00);
 
 	kern_boot->hdr.cmd_line_ptr	= BOOT_CMDLINE_OFFSET;
 	kern_boot->hdr.type_of_loader	= 0xff;
 	kern_boot->hdr.heap_end_ptr	= 0xfe00;
 	kern_boot->hdr.loadflags	|= CAN_USE_HEAP;
-	kern_boot->hdr.vid_mode		= vidmode;
+	kern_boot->hdr.vid_mode		= kvm->cfg.arch.vidmode;
 
 	/*
 	 * Read initrd image into guest memory
-- 
2.7.4

