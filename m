Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9749118D40
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 17:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfLJQIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 11:08:19 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:7041 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfLJQIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 11:08:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1575994097; x=1607530097;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=uvB7xnkSnsEw+GrrnNatJiopzdUBiH1mP8A1khdgfVI=;
  b=Mh+0ErAW8SdVRdQ4svgoU39+ylssuV0MFp1kNTCsyowgOuhXxy41fVzk
   sgTmsF2talYcmd+DJvpmHVT0tgRNiCc7Yf3XaUpy+M/EXmchZMjkKcM3t
   wYNkEhH8ZUfrGZGXLxZotdxItuXqJFXC+xecgFRwjbOcObFfqVpp0ujgd
   8=;
IronPort-SDR: 2VVPu23ZC1Ja977LBpFcQX7CisdfapsSVh/YguNp0QzWR639Z6+3Fvyz1Ocs4PG6vwoiLHz/is
 nJOZ+fxbVFQw==
X-IronPort-AV: E=Sophos;i="5.69,300,1571702400"; 
   d="scan'208";a="12699808"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Dec 2019 16:07:38 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 3295FA0376;
        Tue, 10 Dec 2019 16:07:38 +0000 (UTC)
Received: from EX13D27EUB004.ant.amazon.com (10.43.166.152) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 16:07:37 +0000
Received: from uc3ce012741425f.ant.amazon.com (10.43.162.171) by
 EX13D27EUB004.ant.amazon.com (10.43.166.152) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Dec 2019 16:07:34 +0000
From:   Milan Pandurov <milanpa@amazon.de>
To:     <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>, <graf@amazon.de>,
        <borntraeger@de.ibm.com>
Subject: [PATCH] kvm: Refactor handling of VM debugfs files
Date:   Tue, 10 Dec 2019 17:07:24 +0100
Message-ID: <20191210160724.1030-1-milanpa@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.171]
X-ClientProxiedBy: EX13D07UWB003.ant.amazon.com (10.43.161.66) To
 EX13D27EUB004.ant.amazon.com (10.43.166.152)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By storing kvm_stat_kind inside kvm_stat_data struct we can remove
duplicated code and remove usage of temporary kvm_stat_data struct
inside vm_stat_get et al.

Signed-off-by: Milan Pandurov <milanpa@amazon.de>
---
 include/linux/kvm_host.h |   1 +
 virt/kvm/kvm_main.c      | 118 +++++++++++++++++----------------------
 2 files changed, 53 insertions(+), 66 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7ed1e2f8641e..212d5117efda 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1112,6 +1112,7 @@ struct kvm_stat_data {
 	int offset;
 	int mode;
 	struct kvm *kvm;
+	enum kvm_stat_kind kind;
 };
 
 struct kvm_stats_debugfs_item {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 00268290dcbd..155f144fcc7c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -113,7 +113,7 @@ struct dentry *kvm_debugfs_dir;
 EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 
 static int kvm_debugfs_num_entries;
-static const struct file_operations *stat_fops_per_vm[];
+static const struct file_operations stat_fops_per_vm;
 
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
@@ -652,9 +652,10 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 		stat_data->kvm = kvm;
 		stat_data->offset = p->offset;
 		stat_data->mode = p->mode ? p->mode : 0644;
+		stat_data->kind = p->kind;
 		kvm->debugfs_stat_data[p - debugfs_entries] = stat_data;
 		debugfs_create_file(p->name, stat_data->mode, kvm->debugfs_dentry,
-				    stat_data, stat_fops_per_vm[p->kind]);
+				    stat_data, &stat_fops_per_vm);
 	}
 	return 0;
 }
@@ -4033,105 +4034,96 @@ static int kvm_debugfs_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int vm_stat_get_per_vm(void *data, u64 *val)
+static int kvm_get_stat_per_vm(struct kvm *kvm, size_t offset, u64 *val)
 {
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
-
-	*val = *(ulong *)((void *)stat_data->kvm + stat_data->offset);
+	*val = *(ulong *)((void *)kvm + offset);
 
 	return 0;
 }
 
-static int vm_stat_clear_per_vm(void *data, u64 val)
+static int kvm_clear_stat_per_vm(struct kvm *kvm, size_t offset)
 {
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
-
-	if (val)
-		return -EINVAL;
-
-	*(ulong *)((void *)stat_data->kvm + stat_data->offset) = 0;
+	*(ulong *)((void *)kvm + offset) = 0;
 
 	return 0;
 }
 
-static int vm_stat_get_per_vm_open(struct inode *inode, struct file *file)
-{
-	__simple_attr_check_format("%llu\n", 0ull);
-	return kvm_debugfs_open(inode, file, vm_stat_get_per_vm,
-				vm_stat_clear_per_vm, "%llu\n");
-}
-
-static const struct file_operations vm_stat_get_per_vm_fops = {
-	.owner   = THIS_MODULE,
-	.open    = vm_stat_get_per_vm_open,
-	.release = kvm_debugfs_release,
-	.read    = simple_attr_read,
-	.write   = simple_attr_write,
-	.llseek  = no_llseek,
-};
-
-static int vcpu_stat_get_per_vm(void *data, u64 *val)
+static int kvm_get_stat_per_vcpu(struct kvm *kvm, size_t offset, u64 *val)
 {
 	int i;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
 	struct kvm_vcpu *vcpu;
 
 	*val = 0;
 
-	kvm_for_each_vcpu(i, vcpu, stat_data->kvm)
-		*val += *(u64 *)((void *)vcpu + stat_data->offset);
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		*val += *(u64 *)((void *)vcpu + offset);
 
 	return 0;
 }
 
-static int vcpu_stat_clear_per_vm(void *data, u64 val)
+static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
 {
 	int i;
-	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
 	struct kvm_vcpu *vcpu;
 
-	if (val)
-		return -EINVAL;
-
-	kvm_for_each_vcpu(i, vcpu, stat_data->kvm)
-		*(u64 *)((void *)vcpu + stat_data->offset) = 0;
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		*(u64 *)((void *)vcpu + offset) = 0;
 
 	return 0;
 }
 
-static int vcpu_stat_get_per_vm_open(struct inode *inode, struct file *file)
+struct kvm_stat_operations {
+	int (*get)(struct kvm *kvm, size_t offset, u64 *val);
+	int (*clear)(struct kvm *kvm, size_t offset);
+};
+
+static const struct kvm_stat_operations kvm_stat_ops[] = {
+	[KVM_STAT_VM] = { .get = kvm_get_stat_per_vm,
+			  .clear = kvm_clear_stat_per_vm },
+	[KVM_STAT_VCPU] = { .get = kvm_get_stat_per_vcpu,
+			    .clear = kvm_clear_stat_per_vcpu },
+};
+
+static int kvm_stat_data_get(void *data, u64 *val)
+{
+	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
+	return kvm_stat_ops[stat_data->kind].get(stat_data->kvm,
+						 stat_data->offset, val);
+}
+
+static int kvm_stat_data_clear(void *data, u64 val)
+{
+	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)data;
+	return kvm_stat_ops[stat_data->kind].clear(stat_data->kvm,
+						   stat_data->offset);
+}
+
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
+		vm_stat_get_per_vm(kvm, offset, &tmp_val);
 		*val += tmp_val;
 	}
 	mutex_unlock(&kvm_lock);
@@ -4142,15 +4134,13 @@ static int vm_stat_clear(void *_offset, u64 val)
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
+		vm_stat_clear_per_vm(kvm, offset);
 	}
 	mutex_unlock(&kvm_lock);
 
@@ -4163,14 +4153,12 @@ static int vcpu_stat_get(void *_offset, u64 *val)
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
+		vcpu_stat_get_per_vm(kvm, offset, &tmp_val);
 		*val += tmp_val;
 	}
 	mutex_unlock(&kvm_lock);
@@ -4181,15 +4169,13 @@ static int vcpu_stat_clear(void *_offset, u64 val)
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
 
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



