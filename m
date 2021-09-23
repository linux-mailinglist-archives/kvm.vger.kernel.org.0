Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA1441614B
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 16:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241754AbhIWOpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 10:45:24 -0400
Received: from foss.arm.com ([217.140.110.172]:35508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241728AbhIWOpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 10:45:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54ACCD6E;
        Thu, 23 Sep 2021 07:43:52 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4EF7F3F718;
        Thu, 23 Sep 2021 07:43:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     christoffer.dall@arm.com, vivek.gautam@arm.com
Subject: [PATCH kvmtool 05/10] Use kvm->nr_disks instead of kvm->cfg.image_count
Date:   Thu, 23 Sep 2021 15:45:00 +0100
Message-Id: <20210923144505.60776-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210923144505.60776-1-alexandru.elisei@arm.com>
References: <20210923144505.60776-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A user can specify multiple disk images using the --disk/-d argument. The
callback for the argument ends up in
disk/core.c::calling disk_img_name_parser(), which increments
kvm->cfg.image_count for each disk image.

Immediately after parsing the arguments in kvm_cmd_run_init(),
kvm->nr_disks is set to kvm->cfg.image_count, effectively making
kvm->nr_disks an alias for kvm->cfg.image_count, as image_count is never
changed afterward.

Later on, the core disk code uses kvm->cfg.image_count when opening all the
disk images, but kvm->nr_disks when closing them, which is inconsistent,
but technically correct since they represent the same thing and have the
same value.

Let's remove all this confusing usage and use only kvm->nr_disks to
represent the number of disk images specified by the user.

While this technically means that kvmtool now supports up to INT_MAX disk
images, in practice this is limited by MAX_DISK_IMAGES, which is equal to
four. Which means there are no functional changes.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 builtin-run.c            |  2 --
 disk/core.c              | 18 +++++++++---------
 include/kvm/kvm-config.h |  1 -
 3 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/builtin-run.c b/builtin-run.c
index 2a14723ba042..6822c321883e 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -526,8 +526,6 @@ static struct kvm *kvm_cmd_run_init(int argc, const char **argv)
 
 	kvm_run_validate_cfg(kvm);
 
-	kvm->nr_disks = kvm->cfg.image_count;
-
 	if (!kvm->cfg.kernel_filename && !kvm->cfg.firmware_filename) {
 		kvm->cfg.kernel_filename = find_kernel();
 
diff --git a/disk/core.c b/disk/core.c
index 8d95c98e2169..d8d04cb0a24e 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -16,20 +16,20 @@ int disk_img_name_parser(const struct option *opt, const char *arg, int unset)
 	char *sep;
 	struct kvm *kvm = opt->ptr;
 
-	if (kvm->cfg.image_count >= MAX_DISK_IMAGES)
+	if (kvm->nr_disks >= MAX_DISK_IMAGES)
 		die("Currently only 4 images are supported");
 
-	kvm->cfg.disk_image[kvm->cfg.image_count].filename = arg;
+	kvm->cfg.disk_image[kvm->nr_disks].filename = arg;
 	cur = arg;
 
 	if (strncmp(arg, "scsi:", 5) == 0) {
 		sep = strstr(arg, ":");
 		if (sep)
-			kvm->cfg.disk_image[kvm->cfg.image_count].wwpn = sep + 1;
+			kvm->cfg.disk_image[kvm->nr_disks].wwpn = sep + 1;
 		sep = strstr(sep + 1, ":");
 		if (sep) {
 			*sep = 0;
-			kvm->cfg.disk_image[kvm->cfg.image_count].tpgt = sep + 1;
+			kvm->cfg.disk_image[kvm->nr_disks].tpgt = sep + 1;
 		}
 		cur = sep + 1;
 	}
@@ -38,15 +38,15 @@ int disk_img_name_parser(const struct option *opt, const char *arg, int unset)
 		sep = strstr(cur, ",");
 		if (sep) {
 			if (strncmp(sep + 1, "ro", 2) == 0)
-				kvm->cfg.disk_image[kvm->cfg.image_count].readonly = true;
+				kvm->cfg.disk_image[kvm->nr_disks].readonly = true;
 			else if (strncmp(sep + 1, "direct", 6) == 0)
-				kvm->cfg.disk_image[kvm->cfg.image_count].direct = true;
+				kvm->cfg.disk_image[kvm->nr_disks].direct = true;
 			*sep = 0;
 			cur = sep + 1;
 		}
 	} while (sep);
 
-	kvm->cfg.image_count++;
+	kvm->nr_disks++;
 
 	return 0;
 }
@@ -152,7 +152,7 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 	void *err;
 	int i;
 	struct disk_image_params *params = (struct disk_image_params *)&kvm->cfg.disk_image;
-	int count = kvm->cfg.image_count;
+	int count = kvm->nr_disks;
 
 	if (!count)
 		return ERR_PTR(-EINVAL);
@@ -328,7 +328,7 @@ void disk_image__set_callback(struct disk_image *disk,
 
 int disk_image__init(struct kvm *kvm)
 {
-	if (kvm->cfg.image_count) {
+	if (kvm->nr_disks) {
 		kvm->disks = disk_image__open_all(kvm);
 		if (IS_ERR(kvm->disks))
 			return PTR_ERR(kvm->disks);
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 8b6c151191f6..35d45c0f7ab1 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -23,7 +23,6 @@ struct kvm_config {
 	struct disk_image_params disk_image[MAX_DISK_IMAGES];
 	struct vfio_device_params *vfio_devices;
 	u64 ram_size;
-	u8  image_count;
 	u8 num_net_devices;
 	u8 num_vfio_devices;
 	u64 vsock_cid;
-- 
2.31.1

