Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54503F7A4F
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241901AbhHYQU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:20:26 -0400
Received: from foss.arm.com ([217.140.110.172]:55070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241288AbhHYQTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:19:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C65ED113E;
        Wed, 25 Aug 2021 09:18:54 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BF7323F66F;
        Wed, 25 Aug 2021 09:18:53 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v4 kvmtool 5/5] arm64: SPE: Set KVM_ARM_VCPU_SUPPORTED_CPUS
Date:   Wed, 25 Aug 2021 17:19:58 +0100
Message-Id: <20210825161958.266411-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161958.266411-1-alexandru.elisei@arm.com>
References: <20210825161958.266411-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM uses the KVM_ARM_VCPU_SUPPORTED_CPUS to make sure that an SPE-enabled
VCPU is not scheduled on a CPU without SPE. Get the cpulist of physical
CPUs that support SPE by parsing the /sys/devices directories that the SPE
driver creates, and passing that on as the argument for
KVM_ARM_VCPU_SUPPORTED_CPUS.

It is still up to the user to make sure that the VCPUs run on the correct
physical CPUs (those specified via KVM_ARM_VCPU_SUPPORTED_CPUS), for
example, by using taskset.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/spe.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/arm/aarch64/spe.c b/arm/aarch64/spe.c
index 673c84e63cc2..6eccc6b72677 100644
--- a/arm/aarch64/spe.c
+++ b/arm/aarch64/spe.c
@@ -1,3 +1,4 @@
+#include <dirent.h>
 #include <stdio.h>
 
 #include <sys/resource.h>
@@ -13,6 +14,8 @@
 
 #include "arm-common/gic.h"
 
+#define SYS_DEVICES	"/sys/devices/"
+
 void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,statistical-profiling-extension-v1";
@@ -35,6 +38,118 @@ void spe__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	_FDT(fdt_end_node(fdt));
 }
 
+static int spe_set_supported_cpumask(char *cpumask)
+{
+	struct dirent *dirent;
+	size_t cpumask_len;
+	char *path;
+	size_t path_len;
+	DIR *dir;
+	int fd;
+	ssize_t fd_sz;
+	int ret = 0;
+
+	path = calloc(1, PAGE_SIZE);
+	if (!path)
+		return -ENOMEM;
+
+	/* Make the compiler happy by copying the NULL terminating byte. */
+	strncpy(path, SYS_DEVICES, strlen(SYS_DEVICES) + 1);
+
+	dir = opendir(SYS_DEVICES);
+	if (!dir) {
+		ret = -errno;
+		goto out_free;
+	}
+
+	cpumask_len = 0;
+	while ((dirent = readdir(dir))) {
+		if (dirent->d_type != DT_DIR)
+			continue;
+		if (strncmp(dirent->d_name, "arm_spe", 7) != 0)
+			continue;
+
+		path_len = strlen(SYS_DEVICES) + strlen(dirent->d_name) +
+			   strlen("/cpumask");
+		/* No room for NULL. */
+		if (path_len >= (long unsigned)PAGE_SIZE) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+
+		strcat(path, dirent->d_name);
+		strcat(path, "/cpumask");
+
+		fd = open(path, O_RDONLY);
+		if (fd < 0) {
+			ret = -errno;
+			goto out_free;
+		}
+
+		/* No room for comma + single digit CPU number. */
+		if (cpumask_len >= (long unsigned)PAGE_SIZE - 2) {
+			ret = -ENOMEM;
+			goto out_free;
+		}
+		if (cpumask_len > 0)
+			cpumask[cpumask_len++] = ',';
+
+		/* Newline will be converted to NULL, it's safe to fill cpumask. */
+		fd_sz = read_file(fd, &cpumask[cpumask_len],
+				  PAGE_SIZE - cpumask_len);
+		if (fd_sz < 0) {
+			ret = -errno;
+			goto out_free;
+		}
+		close(fd);
+
+		cpumask_len = strlen(cpumask);
+		/* Strip newline. */
+		cpumask[--cpumask_len] = '\0';
+
+		/* Reset path to point to /sys/devices/ */
+		memset(&path[strlen(SYS_DEVICES)], '\0',
+		       strlen(path) - strlen(SYS_DEVICES));
+	}
+
+	if (cpumask_len == 0)
+		ret = -ENODEV;
+
+out_free:
+	free(path);
+	return ret;
+}
+
+static int spe_set_supported_cpus(struct kvm *kvm)
+{
+	char *cpumask;
+	int i, fd;
+	int ret;
+
+	cpumask = calloc(1, PAGE_SIZE);
+	if (!cpumask)
+		return -ENOMEM;
+
+	ret = spe_set_supported_cpumask(cpumask);
+	if (ret)
+		goto out_free;
+
+	pr_info("SPE detected on CPUs %s", cpumask);
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		fd = kvm->cpus[i]->vcpu_fd;
+		ret = ioctl(fd, KVM_ARM_VCPU_SUPPORTED_CPUS, cpumask);
+		if (ret == -1) {
+			ret = -errno;
+			goto out_free;
+		}
+	}
+
+out_free:
+	free(cpumask);
+	return ret;
+}
+
 static void spe_try_increase_mlock_limit(struct kvm *kvm)
 {
 	u64 size = kvm->ram_size;
@@ -88,6 +203,21 @@ static int spe__init(struct kvm *kvm)
 	if (!kvm->cfg.arch.has_spe)
 		return 0;
 
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_VCPU_SUPPORTED_CPUS)) {
+		ret = spe_set_supported_cpus(kvm);
+		if (ret)
+			return ret;
+	} else {
+		/*
+		 * Assume that KVM knows what it's doing by not supporting the
+		 * extension and has some other way to prevent SPE enabled VCPUs
+		 * from running on physical CPUs without SPE, if there are
+		 * present. Print a debug statement just in case something goes
+		 * horribly wrong.
+		 */
+		pr_debug("KVM_ARM_VCPU_SUPPORTED_CPUS not present");
+	}
+
 	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_LOCK_USER_MEMORY_REGION))
 		die("KVM_CAP_ARM_LOCK_USER_MEMORY_REGION not supported");
 
-- 
2.33.0

