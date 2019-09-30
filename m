Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D22FC2578
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 18:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbfI3Qwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 12:52:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55050 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3Qwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 12:52:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so238636wmp.4;
        Mon, 30 Sep 2019 09:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=S4meV0NsaDpqLa7tBEXkvORH5DuiHJR7oObrl4NCVW4=;
        b=ZKFO2GkolErFUr68Pj8DzLdvfmN6K47nQm/2ypFNwkvAju1BtuE3hjRdgIslfArdCz
         tcSel3xQCWbcB9PQrXVWPcuH3PEHd/hwfhCl2SuSzh4zQFu09bkn5UKDvsSgV48XA3IQ
         wTXguVJwJVOrG22nKLayzi1SKn+1HdpDfx2i0URglXV/jfSSRFtVyGVfpdOy0GnJLv/8
         ojpfSrPFo/YhMqVgCF38LrBx2u/NPItz1UqQK0tl1bDKUayanqN5P+6FDgtaA2HKX/+X
         XtEYy4zUAt+Z4GNZDpFuC7GDd3hlHw46kI7Ko829sHQc3p9iGotQePXO/DoNFEA0pNyZ
         Qe2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=S4meV0NsaDpqLa7tBEXkvORH5DuiHJR7oObrl4NCVW4=;
        b=An34awI32oh+EqjtLvtVntQq6PYzXZcsjDWTYLbVdcg/qRrvg39u33irWvTA+SShmp
         SNs9l4sdM/4MjnrpHm5AgzpzgKF17BjctMHY3T+xYiDxkKFQWaEczl41gCxXVpO7+d/P
         PHPHo0poOAOfmFnk0s7tDZvGSWP7RW+rMYVl/WvcyQWM6XaFKpDr+A0G3SYGqKb+4O+0
         UkR+EfbpgWFq98caK21xI94Rae7otbamU9KmNa14gg10YWmYfe6rcR4JDo2Oh6No3mHk
         upBgP1D7t8cVgrCLvCWiS8WD/ppa0PmnEbRS0XAe8QEzk1LZPaNCHeMSu+kOJeSFjdQW
         eVxg==
X-Gm-Message-State: APjAAAWASdhu/rXgrXRKEYlHa726Kgdr17VrARdDMHve3yyW/44exLCH
        JDWwv7aUOMV/ZkNtQZU+6WM6YusH
X-Google-Smtp-Source: APXvYqzCLsczViMIVb7X3HfOf7obZBubZ1E1KCxx7eCgHu7Vt1z3KtWGQvxR+kz+c/TU/OFIY2h5pw==
X-Received: by 2002:a7b:c4c9:: with SMTP id g9mr141219wmk.150.1569862355607;
        Mon, 30 Sep 2019 09:52:35 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n22sm139924wmk.19.2019.09.30.09.52.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 09:52:34 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, kvm-ppc@vger.kernel.org
Subject: [PATCH] kvm: x86, powerpc: do not allow clearing largepages debugfs entry
Date:   Mon, 30 Sep 2019 18:52:31 +0200
Message-Id: <1569862351-19760-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The largepages debugfs entry is incremented/decremented as shadow
pages are created or destroyed.  Clearing it will result in an
underflow, which is harmless to KVM but ugly (and could be
misinterpreted by tools that use debugfs information), so make
this particular statistic read-only.

Cc: kvm-ppc@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/powerpc/kvm/book3s.c |  8 ++++----
 arch/x86/kvm/x86.c        |  6 +++---
 include/linux/kvm_host.h  |  2 ++
 virt/kvm/kvm_main.c       | 10 +++++++---
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d7fcdfa7fee4..ec2547cc5ecb 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -36,8 +36,8 @@
 #include "book3s.h"
 #include "trace.h"
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
 
 /* #define EXIT_DEBUG */
 
@@ -69,8 +69,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "pthru_all",       VCPU_STAT(pthru_all) },
 	{ "pthru_host",      VCPU_STAT(pthru_host) },
 	{ "pthru_bad_aff",   VCPU_STAT(pthru_bad_aff) },
-	{ "largepages_2M",    VM_STAT(num_2M_pages) },
-	{ "largepages_1G",    VM_STAT(num_1G_pages) },
+	{ "largepages_2M",    VM_STAT(num_2M_pages, .mode = 0444) },
+	{ "largepages_1G",    VM_STAT(num_1G_pages, .mode = 0444) },
 	{ NULL }
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 180c7e88577a..8072acaaf028 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -92,8 +92,8 @@
 static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 #endif
 
-#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
-#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+#define VM_STAT(x, ...) offsetof(struct kvm, stat.x), KVM_STAT_VM, ## __VA_ARGS__
+#define VCPU_STAT(x, ...) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ## __VA_ARGS__
 
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
@@ -212,7 +212,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "mmu_cache_miss", VM_STAT(mmu_cache_miss) },
 	{ "mmu_unsync", VM_STAT(mmu_unsync) },
 	{ "remote_tlb_flush", VM_STAT(remote_tlb_flush) },
-	{ "largepages", VM_STAT(lpages) },
+	{ "largepages", VM_STAT(lpages, .mode = 0444) },
 	{ "max_mmu_page_hash_collisions",
 		VM_STAT(max_mmu_page_hash_collisions) },
 	{ NULL }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fcb46b3374c6..719fc3e15ea4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1090,6 +1090,7 @@ enum kvm_stat_kind {
 
 struct kvm_stat_data {
 	int offset;
+	int mode;
 	struct kvm *kvm;
 };
 
@@ -1097,6 +1098,7 @@ struct kvm_stats_debugfs_item {
 	const char *name;
 	int offset;
 	enum kvm_stat_kind kind;
+	int mode;
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e6de3159e682..fd68fbe0a75d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -617,8 +617,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 
 		stat_data->kvm = kvm;
 		stat_data->offset = p->offset;
+		stat_data->mode = p->mode ? p->mode : 0644;
 		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
-		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
+		debugfs_create_file(p->name, stat_data->mode, kvm->debugfs_dentry,
 				    stat_data, stat_fops_per_vm[p->kind]);
 	}
 	return 0;
@@ -3929,7 +3930,9 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!refcount_inc_not_zero(&stat_data->kvm->users_count))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get, set, fmt)) {
+	if (simple_attr_open(inode, file, get,
+			     stat_data->mode & S_IWUGO ? set : NULL,
+			     fmt)) {
 		kvm_put_kvm(stat_data->kvm);
 		return -ENOMEM;
 	}
@@ -4177,7 +4180,8 @@ static void kvm_init_debug(void)
 
 	kvm_debugfs_num_entries = 0;
 	for (p = debugfs_entries; p->name; ++p, kvm_debugfs_num_entries++) {
-		debugfs_create_file(p->name, 0644, kvm_debugfs_dir,
+		int mode = p->mode ? p->mode : 0644;
+		debugfs_create_file(p->name, mode, kvm_debugfs_dir,
 				    (void *)(long)p->offset,
 				    stat_fops[p->kind]);
 	}
-- 
1.8.3.1

