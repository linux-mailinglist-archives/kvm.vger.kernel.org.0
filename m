Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8673DC0C1
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhG3WFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233100AbhG3WFL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Jul 2021 18:05:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627682706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RDoZRQ4z39utw+snkzSoyuPXl0N6gUtnPUuN5iXfGY=;
        b=ZkYLlso5yUt6Uwo8B3lgie+RhS9Pr0ljKVnGOUGSDtTGtD+YssdslyqorGHebSPvv8Ci2+
        NN5Ozo+9ixCSoJ2O5NCDo2Qlp5voxkgEcPKLVMOijBWipk/LeGCsDy9LbErJUe0FGydM0B
        +ivIlKZF25prFa1bjSPysTGeMHoOrNY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-KnnevuvXNq2hXe9jaJDudQ-1; Fri, 30 Jul 2021 18:05:04 -0400
X-MC-Unique: KnnevuvXNq2hXe9jaJDudQ-1
Received: by mail-qk1-f199.google.com with SMTP id x2-20020a05620a0ec2b02903b8bd8b612eso6521713qkm.19
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/RDoZRQ4z39utw+snkzSoyuPXl0N6gUtnPUuN5iXfGY=;
        b=twaLPCpVdKpnfocQX5F7KZVRhgO4cc5Vzd95dTWpAO3lTUwZ4/mo3yOUl+l98RX70w
         k6CEHIdPMIFX+sGEum+lt3o9Bl/5OYVHx5Q0L4suD6GhKg4YTtBzZDM2ORBuJt8xlr+j
         2MTJnrc+Ro8ClveLg7rIiwsqOyP2wuvuQzpgdWY9BfiH/u7Yd7XFmoHKvSAYiQo3a1U8
         0FDU+JHXA3RD5SaXD4rs+P9t/xcOg3JvwsE36JDNcBmei8roFWb0R8Y+tJyJ3hChBsC+
         jolBPV+1D7/QRTUH2cvsfxZe+i9rmg5cGUg06RbayHb5O3M0eqW2ZiqDXShzxaqUSZha
         omoQ==
X-Gm-Message-State: AOAM531QxBgZ15c0+dO/YS4b5q6I1JkF91csVlzuc060LzckyxdkUi2O
        e0AjXRdTZsHGvJcAf286+/SFV1XnlwMFYFXtkWs9yYNh/e/dH5so7kjkAfUhYLR2QhwiJ3g+jL/
        MQJ3uvaZa6diX2U7gTSiLIR5K9dBlPHYqnHb0V6m6sD51edVoAbCWQ55PmY9NhA==
X-Received: by 2002:a05:6214:301d:: with SMTP id ke29mr5138492qvb.30.1627682703169;
        Fri, 30 Jul 2021 15:05:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWCmoNcaZU19195qKr1Fps5K3/JOg1+6YD1Cz0f/pAtcjGUvYAKUdj8qKiLNrXgJM3H6DyoA==
X-Received: by 2002:a05:6214:301d:: with SMTP id ke29mr5138465qvb.30.1627682702921;
        Fri, 30 Jul 2021 15:05:02 -0700 (PDT)
Received: from t490s.. (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id l12sm1199651qtx.45.2021.07.30.15.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:05:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 4/7] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file
Date:   Fri, 30 Jul 2021 18:04:52 -0400
Message-Id: <20210730220455.26054-5-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730220455.26054-1-peterx@redhat.com>
References: <20210730220455.26054-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use this file to dump rmap statistic information.  The statistic is done by
calculating the rmap count and the result is log-2-based.

An example output of this looks like (idle 6GB guest, right after boot linux):

Rmap_Count:     0       1       2-3     4-7     8-15    16-31   32-63   64-127  128-255 256-511 512-1023
Level=4K:       3086676 53045   12330   1272    502     121     76      2       0       0       0
Level=2M:       5947    231     0       0       0       0       0       0       0       0       0
Level=1G:       32      0       0       0       0       0       0       0       0       0       0

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 113 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e44d8f7781b6..0877340dc6ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -30,6 +30,7 @@
 #include "hyperv.h"
 #include "lapic.h"
 #include "xen.h"
+#include "mmu/mmu_internal.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -59,6 +60,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
 #include <linux/suspend.h>
+#include <linux/debugfs.h>
 
 #include <trace/events/kvm.h>
 
@@ -11193,6 +11195,117 @@ int kvm_arch_post_init_vm(struct kvm *kvm)
 	return kvm_mmu_post_init_vm(kvm);
 }
 
+/*
+ * This covers statistics <1024 (11=log(1024)+1), which should be enough to
+ * cover RMAP_RECYCLE_THRESHOLD.
+ */
+#define  RMAP_LOG_SIZE  11
+
+static const char *kvm_lpage_str[KVM_NR_PAGE_SIZES] = { "4K", "2M", "1G" };
+
+static int kvm_mmu_rmaps_stat_show(struct seq_file *m, void *v)
+{
+	struct kvm_rmap_head *rmap;
+	struct kvm *kvm = m->private;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	unsigned int lpage_size, index;
+	/* Still small enough to be on the stack */
+	unsigned int *log[KVM_NR_PAGE_SIZES], *cur;
+	int i, j, k, l, ret;
+
+	memset(log, 0, sizeof(log));
+
+	ret = -ENOMEM;
+	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
+		log[i] = kzalloc(RMAP_LOG_SIZE * sizeof(unsigned int), GFP_KERNEL);
+		if (!log[i])
+			goto out;
+	}
+
+	mutex_lock(&kvm->slots_lock);
+	write_lock(&kvm->mmu_lock);
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		for (j = 0; j < slots->used_slots; j++) {
+			slot = &slots->memslots[j];
+			for (k = 0; k < KVM_NR_PAGE_SIZES; k++) {
+				rmap = slot->arch.rmap[k];
+				lpage_size = kvm_mmu_slot_lpages(slot, k + 1);
+				cur = log[k];
+				for (l = 0; l < lpage_size; l++) {
+					index = ffs(pte_list_count(&rmap[l]));
+					if (WARN_ON_ONCE(index >= RMAP_LOG_SIZE))
+						index = RMAP_LOG_SIZE - 1;
+					cur[index]++;
+				}
+			}
+		}
+	}
+
+	write_unlock(&kvm->mmu_lock);
+	mutex_unlock(&kvm->slots_lock);
+
+	/* index=0 counts no rmap; index=1 counts 1 rmap */
+	seq_printf(m, "Rmap_Count:\t0\t1\t");
+	for (i = 2; i < RMAP_LOG_SIZE; i++) {
+		j = 1 << (i - 1);
+		k = (1 << i) - 1;
+		seq_printf(m, "%d-%d\t", j, k);
+	}
+	seq_printf(m, "\n");
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES; i++) {
+		seq_printf(m, "Level=%s:\t", kvm_lpage_str[i]);
+		cur = log[i];
+		for (j = 0; j < RMAP_LOG_SIZE; j++)
+			seq_printf(m, "%d\t", cur[j]);
+		seq_printf(m, "\n");
+	}
+
+	ret = 0;
+out:
+	for (i = 0; i < KVM_NR_PAGE_SIZES; i++)
+		if (log[i])
+			kfree(log[i]);
+
+	return ret;
+}
+
+static int kvm_mmu_rmaps_stat_open(struct inode *inode, struct file *file)
+{
+	struct kvm *kvm = inode->i_private;
+
+	if (!kvm_get_kvm_safe(kvm))
+		return -ENOENT;
+
+	return single_open(file, kvm_mmu_rmaps_stat_show, kvm);
+}
+
+static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
+{
+	struct kvm *kvm = inode->i_private;
+
+	kvm_put_kvm(kvm);
+
+	return single_release(inode, file);
+}
+
+static const struct file_operations mmu_rmaps_stat_fops = {
+	.open		= kvm_mmu_rmaps_stat_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= kvm_mmu_rmaps_stat_release,
+};
+
+int kvm_arch_create_vm_debugfs(struct kvm *kvm)
+{
+	debugfs_create_file("mmu_rmaps_stat", 0644, kvm->debugfs_dentry, kvm,
+			    &mmu_rmaps_stat_fops);
+	return 0;
+}
+
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
-- 
2.31.1

