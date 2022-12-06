Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5367064431C
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 13:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiLFM2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 07:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiLFM2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 07:28:00 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D552B69
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 04:27:58 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NRKRX5kNJz15N5j;
        Tue,  6 Dec 2022 20:27:04 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 20:27:52 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <pbonzini@redhat.com>, <maz@kernel.org>, <james.morse@arm.com>
CC:     <kvm@vger.kernel.org>, <linuxarm@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [RFC PATCH 1/2] KVM: debugfs: Add vcpu debugfs to record statstical data for every single vcpu
Date:   Tue, 6 Dec 2022 20:58:27 +0800
Message-ID: <1670331508-67322-2-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1670331508-67322-1-git-send-email-chenxiang66@hisilicon.com>
References: <1670331508-67322-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently kvm supports debugfs for vm and vcpu. For vcpu debugfs, it
records statistical data for all vcpus not for every single vcpu. But
sometimes we want to know statistical data for every vcpu, there is no
vcpu debugfs for that. So add vcpu debugfs to record statistical
data for every single vcpu.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 62 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 597953f..25cd2e2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1756,12 +1756,14 @@ static inline bool kvm_is_error_gpa(struct kvm *kvm, gpa_t gpa)
 enum kvm_stat_kind {
 	KVM_STAT_VM,
 	KVM_STAT_VCPU,
+	KVM_STAT_VCPU_SINGLE,
 };
 
 struct kvm_stat_data {
 	struct kvm *kvm;
 	const struct _kvm_stats_desc *desc;
 	enum kvm_stat_kind kind;
+	unsigned long cpu_id;
 };
 
 struct _kvm_stats_desc {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index baf7a83..0cca201 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1009,7 +1009,7 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 {
 	int i;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
-				      kvm_vcpu_stats_header.num_desc;
+				      2 * kvm_vcpu_stats_header.num_desc;
 
 	if (IS_ERR(kvm->debugfs_dentry))
 		return;
@@ -1032,7 +1032,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, const char *fdname)
 	const struct _kvm_stats_desc *pdesc;
 	int i, ret = -ENOMEM;
 	int kvm_debugfs_num_entries = kvm_vm_stats_header.num_desc +
-				      kvm_vcpu_stats_header.num_desc;
+				      2 * kvm_vcpu_stats_header.num_desc;
 
 	if (!debugfs_initialized())
 		return 0;
@@ -3899,6 +3899,12 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 {
 	struct dentry *debugfs_dentry;
 	char dir_name[ITOA_MAX_LEN * 2];
+	const struct _kvm_stats_desc *pdesc;
+	struct kvm_stat_data *stat_data;
+	struct kvm *kvm = vcpu->kvm;
+	int start = kvm_vm_stats_header.num_desc +
+		kvm_vcpu_stats_header.num_desc;
+	int i, j;
 
 	if (!debugfs_initialized())
 		return;
@@ -3909,7 +3915,29 @@ static void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
 	debugfs_create_file("pid", 0444, debugfs_dentry, vcpu,
 			    &vcpu_get_pid_fops);
 
+	for (i = 0; i < kvm_vcpu_stats_header.num_desc; ++i) {
+		pdesc = &kvm_vcpu_stats_desc[i];
+		stat_data = kzalloc(sizeof(*stat_data), GFP_KERNEL_ACCOUNT);
+		if (!stat_data)
+			goto out_err;
+		stat_data->kvm = kvm;
+		stat_data->desc = pdesc;
+		stat_data->kind = KVM_STAT_VCPU_SINGLE;
+		stat_data->cpu_id = vcpu->vcpu_id;
+		kvm->debugfs_stat_data[i + start] = stat_data;
+		debugfs_create_file(pdesc->name, kvm_stats_debugfs_mode(pdesc),
+				    debugfs_dentry, stat_data,
+				    &stat_fops_per_vm);
+	}
+
 	kvm_arch_create_vcpu_debugfs(vcpu, debugfs_dentry);
+	return;
+out_err:
+	debugfs_remove_recursive(debugfs_dentry);
+	if (kvm->debugfs_stat_data)
+		for (j = i - 1; j >= 0; j--)
+			kfree(kvm->debugfs_stat_data[j + start]);
+	return;
 }
 #endif
 
@@ -5581,6 +5609,28 @@ static int kvm_clear_stat_per_vcpu(struct kvm *kvm, size_t offset)
 	return 0;
 }
 
+static int kvm_get_stat_per_vcpu_single(struct kvm *kvm, size_t offset, unsigned long i, u64 *val)
+{
+	struct kvm_vcpu *vcpu;
+
+	*val = 0;
+
+	vcpu = kvm_get_vcpu(kvm, i);
+	*val += *(u64 *)((void *)(&vcpu->stat) + offset);
+
+	return 0;
+}
+
+static int kvm_clear_stat_per_vcpu_single(struct kvm *kvm, size_t offset, unsigned long i)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = kvm_get_vcpu(kvm, i);
+	*(u64 *)((void *)(&vcpu->stat) + offset) = 0;
+
+	return 0;
+}
+
 static int kvm_stat_data_get(void *data, u64 *val)
 {
 	int r = -EFAULT;
@@ -5595,6 +5645,10 @@ static int kvm_stat_data_get(void *data, u64 *val)
 		r = kvm_get_stat_per_vcpu(stat_data->kvm,
 					  stat_data->desc->desc.offset, val);
 		break;
+	case KVM_STAT_VCPU_SINGLE:
+		r = kvm_get_stat_per_vcpu_single(stat_data->kvm,
+				stat_data->desc->desc.offset, stat_data->cpu_id, val);
+		break;
 	}
 
 	return r;
@@ -5617,6 +5671,10 @@ static int kvm_stat_data_clear(void *data, u64 val)
 		r = kvm_clear_stat_per_vcpu(stat_data->kvm,
 					    stat_data->desc->desc.offset);
 		break;
+	case KVM_STAT_VCPU_SINGLE:
+		r = kvm_clear_stat_per_vcpu_single(stat_data->kvm,
+					    stat_data->desc->desc.offset, stat_data->cpu_id);
+		break;
 	}
 
 	return r;
-- 
2.8.1

