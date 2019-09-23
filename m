Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78001BB574
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 15:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439752AbfIWNfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 09:35:46 -0400
Received: from foss.arm.com ([217.140.110.172]:42330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439741AbfIWNfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 09:35:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57C091576;
        Mon, 23 Sep 2019 06:35:44 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 53CA73F694;
        Mon, 23 Sep 2019 06:35:43 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     maz@kernel.org, suzuki.poulose@arm.com, julien.grall@arm.com,
        andre.przywara@arm.com
Subject: [PATCH kvmtool 06/16] builtin-run.c: Always use ram_size in bytes
Date:   Mon, 23 Sep 2019 14:35:12 +0100
Message-Id: <1569245722-23375-7-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The user can specify the virtual machine memory size, in MB, which is saved
in cfg->ram_size. kvmtool validates it against the host memory size,
converted from bytes to MB. ram_size is aftwerwards converted to bytes, and
this is how it is used throughout the rest of the program.

Let's avoid any confusion about the unit of measurement and always use
cfg->ram_size in bytes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c            | 19 ++++++++++---------
 include/kvm/kvm-config.h |  2 +-
 include/kvm/kvm.h        |  2 +-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index cff44047bb1c..4e0c52b3e027 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -262,7 +262,7 @@ static u64 host_ram_size(void)
 		return 0;
 	}
 
-	return (nr_pages * page_size) >> MB_SHIFT;
+	return nr_pages * page_size;
 }
 
 /*
@@ -276,11 +276,11 @@ static u64 get_ram_size(int nr_cpus)
 	u64 available;
 	u64 ram_size;
 
-	ram_size	= 64 * (nr_cpus + 3);
+	ram_size	= (64 * (nr_cpus + 3)) << MB_SHIFT;
 
 	available	= host_ram_size() * RAM_SIZE_RATIO;
 	if (!available)
-		available = MIN_RAM_SIZE_MB;
+		available = MIN_RAM_SIZE_BYTE;
 
 	if (ram_size > available)
 		ram_size	= available;
@@ -531,13 +531,14 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	if (!kvm->cfg.ram_size)
 		kvm->cfg.ram_size = get_ram_size(kvm->cfg.nrcpus);
+	else
+		/* The user specifies the memory in MB. */
+		kvm->cfg.ram_size <<= MB_SHIFT;
 
 	if (kvm->cfg.ram_size > host_ram_size())
 		pr_warning("Guest memory size %lluMB exceeds host physical RAM size %lluMB",
-			(unsigned long long)kvm->cfg.ram_size,
-			(unsigned long long)host_ram_size());
-
-	kvm->cfg.ram_size <<= MB_SHIFT;
+			(unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
+			(unsigned long long)host_ram_size() >> MB_SHIFT);
 
 	if (!kvm->cfg.dev)
 		kvm->cfg.dev = DEFAULT_KVM_DEV;
@@ -647,12 +648,12 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 	if (kvm->cfg.kernel_filename) {
 		printf("  # %s run -k %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
 		       kvm->cfg.kernel_filename,
-		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
+		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
 		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
 	} else if (kvm->cfg.firmware_filename) {
 		printf("  # %s run --firmware %s -m %Lu -c %d --name %s\n", KVM_BINARY_NAME,
 		       kvm->cfg.firmware_filename,
-		       (unsigned long long)kvm->cfg.ram_size / 1024 / 1024,
+		       (unsigned long long)kvm->cfg.ram_size >> MB_SHIFT,
 		       kvm->cfg.nrcpus, kvm->cfg.guest_name);
 	}
 
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index a052b0bc7582..e0c9ee14e103 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -22,7 +22,7 @@ struct kvm_config {
 	struct kvm_config_arch arch;
 	struct disk_image_params disk_image[MAX_DISK_IMAGES];
 	struct vfio_device_params *vfio_devices;
-	u64 ram_size;
+	u64 ram_size;		/* Guest memory size, in bytes */
 	u8  image_count;
 	u8 num_net_devices;
 	u8 num_vfio_devices;
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 635ce0f40b1e..a866d5a825c4 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -68,7 +68,7 @@ struct kvm {
 	struct kvm_cpu		**cpus;
 
 	u32			mem_slots;	/* for KVM_SET_USER_MEMORY_REGION */
-	u64			ram_size;
+	u64			ram_size;	/* Guest memory size, in bytes */
 	void			*ram_start;
 	u64			ram_pagesize;
 	struct list_head	mem_banks;
-- 
2.7.4

