Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C95D2C173
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 10:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfE1If4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 04:35:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33242 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfE1If4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 04:35:56 -0400
Received: by mail-pl1-f196.google.com with SMTP id g21so8061882plq.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 01:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SgSfv16gsEtblka9oNhoUkR95N141+ewYrs8CjvW54E=;
        b=YjiBfcfPM0w3q8iRRSgUc7eegDabvBxCQU/77AW19EapIZiX8exC37pGxdukzTev2K
         MSMDnfoKfNd1RWDe9Xo1k/NPtf7ulLZGT2ZktsMJzYQTvyzeVnAD4AEAgDd5O0XygaD7
         pES014KGJCtBBzH5FCYeE2sKA94L/prTiosbtKP1JzmnNJEyaiHFHttN/u5eXa8U27KX
         AsE9LkQjpl0atiL1HZeUXHWj2iIlgad6MadQQiAY+NtFbI++WV0d2oT0mgczOQQ1Hg05
         CZFVvlVYkHjjw6J+amPxYku55L2Pt0MXpYX8UDWWT0tlOlTqSOKGb4Uqoyuz6jeaUnRT
         MFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SgSfv16gsEtblka9oNhoUkR95N141+ewYrs8CjvW54E=;
        b=ZHQiSsjJTHqWliHFxR6V0W7ck8zBOFSPXJUrb7D2F8vt0SYsCv5TWNSQFo6btyznlZ
         UmIxn7PLSVM6EGsdCm7wSw2MrcPMjGCD2UHOGU2LtDnoT0oV97HyMmPklSfTZkuRUSx4
         9acCK+uCDAjPM5JEM16z/iXxUSjb3cpf9bEkJii5QwcRI/zTkiKMDpnByn1fmb+o6cil
         5+m/fKIo3khVIO44wdufrvX4U3Y25gQLCS6AHrdtX9qMBfT0Gk8SJQoBQxu37eVJaIQ1
         JKbHiMbyVbpjmfNEBTV8P+Gv5yyxPJ1f77/ng7qDkSIvHCWcCYHWZv4sD1wME2NOxqhs
         nUfQ==
X-Gm-Message-State: APjAAAVGFxc3QXejDh400TNnLJgaW1kYJcf4bW9yQEfhDNZA1Irx//ik
        bNdb8lSoXhkeKg/1Z1MYU3KSLeaI
X-Google-Smtp-Source: APXvYqx7NP94n+veXdKe4GF+biixUft9gFtxGgfGJO4zAN5KcKuzSdw+sZYjrpTFWc/oqQMPNDkSuQ==
X-Received: by 2002:a17:902:3283:: with SMTP id z3mr107011258plb.278.1559032555521;
        Tue, 28 May 2019 01:35:55 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id g71sm21427986pgc.41.2019.05.28.01.35.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 01:35:54 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        dja@axtens.net, Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH] kvm: add kvm cap values to debugfs
Date:   Tue, 28 May 2019 18:35:35 +1000
Message-Id: <20190528083535.27643-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM capabilities are used to communicate the availability of certain
capabilities to userspace.

It might be nice to know these values without having to add debug
printing to the userspace tool consuming this data.

Thus add a file in the kvm per vm debugfs file named "caps" which
contains a file for each capability number which when read returns what
would be returned when querying that capability.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>

---

I'm not sure if it'd be better to keep a per arch list of the revelevant
capabilities to avoid adding an entry for irrelevant ones. Comments?
---
 include/linux/kvm_host.h |  1 +
 include/uapi/linux/kvm.h |  1 +
 virt/kvm/kvm_main.c      | 31 +++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79fa4426509c..6cb45a8de818 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -500,6 +500,7 @@ struct kvm {
 	bool manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
 	struct kvm_stat_data **debugfs_stat_data;
+	int debugfs_cap_data[KVM_CAP_MAX + 1];
 	struct srcu_struct srcu;
 	struct srcu_struct irq_srcu;
 	pid_t userspace_pid;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..7b5042ec5902 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_MAX	KVM_CAP_ARM_PTRAUTH_GENERIC
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 134ec0283a8a..b85a43263fb7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -117,6 +117,7 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
 static int kvm_debugfs_num_entries;
 static const struct file_operations *stat_fops_per_vm[];
 
+static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg);
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 #ifdef CONFIG_KVM_COMPAT
@@ -594,6 +595,33 @@ static void kvm_destroy_vm_debugfs(struct kvm *kvm)
 	}
 }
 
+static int vm_cap_get(void *data, u64 *val)
+{
+	*val = *((int *) data);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cap_fops, vm_cap_get, NULL, "%llu\n");
+
+static void kvm_create_vm_cap_debugfs(struct kvm *kvm)
+{
+	char *dir_name = "caps";
+	struct dentry *dentry_p;
+	int i;
+
+	dentry_p = debugfs_create_dir(dir_name, kvm->debugfs_dentry);
+
+	for (i = 0; i <= KVM_CAP_MAX; i++) {
+		int *cap = &kvm->debugfs_cap_data[i];
+		char file_name[ITOA_MAX_LEN];
+
+		*cap = kvm_vm_ioctl_check_extension_generic(kvm, i);
+		snprintf(file_name, sizeof(file_name), "%d", i);
+		debugfs_create_file(file_name, 0444, dentry_p, cap, &cap_fops);
+	}
+}
+
 static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 {
 	char dir_name[ITOA_MAX_LEN * 2];
@@ -623,6 +651,9 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
 		debugfs_create_file(p->name, 0644, kvm->debugfs_dentry,
 				    stat_data, stat_fops_per_vm[p->kind]);
 	}
+
+	kvm_create_vm_cap_debugfs(kvm);
+
 	return 0;
 }
 
-- 
2.13.6

