Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0194511E459
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 14:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfLMNHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 08:07:41 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:49205 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbfLMNHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 08:07:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1576242458; x=1607778458;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=4fQBD4rRlXQRRamEzH1tOwObi2stteZWOKar33c3SOw=;
  b=ua3Y2KtVebY6x4Sl1ldwwNt3IPl/3Brumcg4QjXk2OI6jMFLKG6OKR10
   qWClspJSWdbHjmUIf9YKi/0ohPCEijFk/3/M4qnLeYzQosDjXzmIa2LOO
   s+aToBPRCnbNeBY8Ui1KPPe5RNYLl+BivrzN2/FGVSWj0YpAN5Q7UYllO
   Y=;
IronPort-SDR: 7uwDc3ozL1jchQhLsYIQc6pKAlvqbZN3cNdeNTTXbDVvU7T5YxI7UCtMZMu49EXlgFxXwC7Ogz
 9Y1C/wOi5eWw==
X-IronPort-AV: E=Sophos;i="5.69,309,1571702400"; 
   d="scan'208";a="8355052"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 13 Dec 2019 13:07:36 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id C5A62A2158;
        Fri, 13 Dec 2019 13:07:35 +0000 (UTC)
Received: from EX13D27EUB004.ant.amazon.com (10.43.166.152) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Dec 2019 13:07:35 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.43.161.179) by
 EX13D27EUB004.ant.amazon.com (10.43.166.152) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 13 Dec 2019 13:07:31 +0000
From:   Milan Pandurov <milanpa@amazon.de>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <graf@amazon.de>,
        <borntraeger@de.ibm.com>
Subject: [PATCH v5] kvm: Refactor handling of VM debugfs files
Date:   Fri, 13 Dec 2019 14:07:21 +0100
Message-ID: <20191213130721.7942-1-milanpa@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.179]
X-ClientProxiedBy: EX13D02UWB004.ant.amazon.com (10.43.161.11) To
 EX13D27EUB004.ant.amazon.com (10.43.166.152)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can store reference to kvm_stats_debugfs_item instead of copying
its values to kvm_stat_data.
This allows us to remove duplicated code and usage of temporary
kvm_stat_data inside vm_stat_get et al.

Signed-off-by: Milan Pandurov <milanpa@amazon.de>
Reviewed-by: Alexander Graf <graf@anazon.com>

---
v1 -> v2:
 - fix compile issues
 - add reference to kvm_stats_debugfs_item in kvm_stat_data
 - return -EINVAL when writing !0
 - use explicit switch case instead of ops indirection
 - fix checkpatch warning: Change S_IWUGO to 0222

v2 -> v3:
 - remove unused kvm_stat_ops
 - fix style issues

v3 -> v4:
 - revert: Change S_IWUGO to 0222

v4 -> v5:
 - fix checkpatch warning: Change S_IWUGO to 0222
---
 include/linux/kvm_host.h |   7 +-
 virt/kvm/kvm_main.c      | 142 +++++++++++++++++++--------------------
 2 files changed, 76 insertions(+), 73 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ed1e2f8641e..d3f2c0eae857 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1109,9 +1109,8 @@ enum kvm_stat_kind {
 };
 
 struct kvm_stat_data {
-	int offset;
-	int mode;
 	struct kvm *kvm;
+	struct kvm_stats_debugfs_item *dbgfs_item;
 };
 
 struct kvm_stats_debugfs_item {
@@ -1120,6 +1119,10 @@ struct kvm_stats_debugfs_item {
 	enum kvm_stat_kind kind;
 	int mode;
 };
+
+#define KVM_DBGFS_GET_MODE(dbgfs_item)                                         \
+	((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
+
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 extern struct dentry *kvm_debugfs_dir;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 00268290dcbd..0ebd6aa95671 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -113,7 +113,7 @@ struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static int kvm_debugfs_num_entries;
-static const struct file_operations *stat_fops_per_vm[];
+static const struct file_operations stat_fops_per_vm;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
@@ -650,11 +650,11 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 			return -ENOMEM;
 
 		stat_data->kvm = kvm;
-		stat_data->offset = p->offset;
-		stat_data->mode = p->mode ? p->mode : 0644;
+		stat_data->dbgfs_item = p;
 		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
-		debugfs_create_file(p->name, stat_data->mode, kvm->debugfs_dentry,
-				    stat_data, stat_fops_per_vm[p->kind]);
+		debugfs_create_file(p->name, KVM_DBGFS_GET_MODE(p),
+				    kvm->debugfs_dentry, stat_data,
+				    &stat_fops_per_vm);
 	}
 	return 0;
 }
@@ -4013,8 +4013,9 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 		return -ENOENT;
 
 	if (simple_attr_open(inode, file, get,
-			     stat_data->mode & S_IWUGO ? set : NULL,
-			     fmt)) {
+		    KVM_DBGFS_GET_MODE(stat_data->dbgfs_item) & 0222
+		    ? set : NULL,
+		    fmt)) {
 		kvm_put_kvm(stat_data->kvm);
 		return -ENOMEM;
 	}
@@ -4033,105 +4034,111 @@ static int kvm_debugfs_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int vm_stat_get_per_vm(void *data, u64 *val)
+static int kvm_get_stat_per_vm(struct kvm *kvm, size_t offset, u64 *val)
 {
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
+	*val = *(ulong *)((void *)kvm + offset);
 
-	*val = *(ulong *)((void *)stat_data->kvm + stat_data->offset);
+	return 0;
+}
+
+static int kvm_clear_stat_per_vm(struct kvm *kvm, size_t offset)
+{
+	*(ulong *)((void *)kvm + offset) = 0;
 
 	return 0;
 }
 
-static int vm_stat_clear_per_vm(void *data, u64 val)
+static int kvm_get_stat_per_vcpu(struct kvm *kvm, size_t offset, u64 *val)
 {
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
+	int i;
+	struct kvm_vcpu *vcpu;
 
-	if (val)
-		return -EINVAL;
+	*val = 0;
 
-	*(ulong *)((void *)stat_data->kvm + stat_data->offset) = 0;
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		*val += *(u64 *)((void *)vcpu + offset);
 
 	return 0;
 }
 
-static int vm_stat_get_per_vm_open(struct inode *inode, struct file *file)
+static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
 {
-	__simple_attr_check_format("%llu\n", 0ull);
-	return kvm_debugfs_open(inode, file, vm_stat_get_per_vm,
-				vm_stat_clear_per_vm, "%llu\n");
-}
+	int i;
+	struct kvm_vcpu *vcpu;
 
-static const struct file_operations vm_stat_get_per_vm_fops = {
-	.owner   = THIS_MODULE,
-	.open    = vm_stat_get_per_vm_open,
-	.release = kvm_debugfs_release,
-	.read    = simple_attr_read,
-	.write   = simple_attr_write,
-	.llseek  = no_llseek,
-};
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		*(u64 *)((void *)vcpu + offset) = 0;
+
+	return 0;
+}
 
-static int vcpu_stat_get_per_vm(void *data, u64 *val)
+static int kvm_stat_data_get(void *data, u64 *val)
 {
-	int i;
+	int r = -EFAULT;
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
-	struct kvm_vcpu *vcpu;
-
-	*val = 0;
 
-	kvm_for_each_vcpu(i, vcpu, stat_data->kvm)
-		*val += *(u64 *)((void *)vcpu + stat_data->offset);
+	switch (stat_data->dbgfs_item->kind) {
+	case KVM_STAT_VM:
+		r = kvm_get_stat_per_vm(stat_data->kvm,
+					stat_data->dbgfs_item->offset, val);
+		break;
+	case KVM_STAT_VCPU:
+		r = kvm_get_stat_per_vcpu(stat_data->kvm,
+					  stat_data->dbgfs_item->offset, val);
+		break;
+	}
 
-	return 0;
+	return r;
 }
 
-static int vcpu_stat_clear_per_vm(void *data, u64 val)
+static int kvm_stat_data_clear(void *data, u64 val)
 {
-	int i;
+	int r = -EFAULT;
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
-	struct kvm_vcpu *vcpu;
 
 	if (val)
 		return -EINVAL;
 
-	kvm_for_each_vcpu(i, vcpu, stat_data->kvm)
-		*(u64 *)((void *)vcpu + stat_data->offset) = 0;
+	switch (stat_data->dbgfs_item->kind) {
+	case KVM_STAT_VM:
+		r = kvm_clear_stat_per_vm(stat_data->kvm,
+					  stat_data->dbgfs_item->offset);
+		break;
+	case KVM_STAT_VCPU:
+		r = kvm_clear_stat_per_vcpu(stat_data->kvm,
+					    stat_data->dbgfs_item->offset);
+		break;
+	}
 
-	return 0;
+	return r;
 }
 
-static int vcpu_stat_get_per_vm_open(struct inode *inode, struct file *file)
+static int kvm_stat_data_open(struct inode *inode, struct file *file)
 {
 	__simple_attr_check_format("%llu\n", 0ull);
-	return kvm_debugfs_open(inode, file, vcpu_stat_get_per_vm,
-				 vcpu_stat_clear_per_vm, "%llu\n");
+	return kvm_debugfs_open(inode, file, kvm_stat_data_get,
+				kvm_stat_data_clear, "%llu\n");
 }
 
-static const struct file_operations vcpu_stat_get_per_vm_fops = {
-	.owner   = THIS_MODULE,
-	.open    = vcpu_stat_get_per_vm_open,
+static const struct file_operations stat_fops_per_vm = {
+	.owner = THIS_MODULE,
+	.open = kvm_stat_data_open,
 	.release = kvm_debugfs_release,
-	.read    = simple_attr_read,
-	.write   = simple_attr_write,
-	.llseek  = no_llseek,
-};
-
-static const struct file_operations *stat_fops_per_vm[] = {
-	[KVM_STAT_VCPU] = &vcpu_stat_get_per_vm_fops,
-	[KVM_STAT_VM]   = &vm_stat_get_per_vm_fops,
+	.read = simple_attr_read,
+	.write = simple_attr_write,
+	.llseek = no_llseek,
 };
 
 static int vm_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
-	struct kvm_stat_data stat_tmp = {.offset = offset};
 	u64 tmp_val;
 
 	*val = 0;
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		stat_tmp.kvm = kvm;
-		vm_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
+		kvm_get_stat_per_vm(kvm, offset, &tmp_val);
 		*val += tmp_val;
 	}
 	mutex_unlock(&kvm_lock);
@@ -4142,15 +4149,13 @@ static int vm_stat_clear(void *_offset, u64 val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
-	struct kvm_stat_data stat_tmp = {.offset = offset};
 
 	if (val)
 		return -EINVAL;
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		stat_tmp.kvm = kvm;
-		vm_stat_clear_per_vm((void *)&stat_tmp, 0);
+		kvm_clear_stat_per_vm(kvm, offset);
 	}
 	mutex_unlock(&kvm_lock);
 
@@ -4163,14 +4168,12 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
-	struct kvm_stat_data stat_tmp = {.offset = offset};
 	u64 tmp_val;
 
 	*val = 0;
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		stat_tmp.kvm = kvm;
-		vcpu_stat_get_per_vm((void *)&stat_tmp, &tmp_val);
+		kvm_get_stat_per_vcpu(kvm, offset, &tmp_val);
 		*val += tmp_val;
 	}
 	mutex_unlock(&kvm_lock);
@@ -4181,15 +4184,13 @@ static int vcpu_stat_clear(void *_offset, u64 val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
-	struct kvm_stat_data stat_tmp = {.offset = offset};
 
 	if (val)
 		return -EINVAL;
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		stat_tmp.kvm = kvm;
-		vcpu_stat_clear_per_vm((void *)&stat_tmp, 0);
+		kvm_clear_stat_per_vcpu(kvm, offset);
 	}
 	mutex_unlock(&kvm_lock);
 
@@ -4262,9 +4263,8 @@ static void kvm_init_debug(void)
 
 	kvm_debugfs_num_entries = 0;
 	for (p = debugfs_entries; p->name; ++p, kvm_debugfs_num_entries++) {
-		int mode = p->mode ? p->mode : 0644;
-		debugfs_create_file(p->name, mode, kvm_debugfs_dir,
-				    (void *)(long)p->offset,
+		debugfs_create_file(p->name, KVM_DBGFS_GET_MODE(p),
+				    kvm_debugfs_dir, (void *)(long)p->offset,
 				    stat_fops[p->kind]);
 	}
 }
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



