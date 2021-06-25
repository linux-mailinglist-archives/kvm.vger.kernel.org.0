Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211BB3B46AE
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhFYPfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:35:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30573 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229974AbhFYPeu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624635149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5L+y5wxukijhnMqO8uY2oYn+ZxljnPTrsvoXiVvQBkI=;
        b=P6/ogbGKFMDGkYtxroXXL3dMZUC3SHxttqmzz+GQc9NyFXNGVyIt44WRRNDa9bm0qAtDBi
        pR1+gqa9SNVNnYcx0QsZWzoMCgHRAQqobmf+cDAUwUYQqRzj+vXfSfsufBECP5IBhZLxdv
        sOD7Ahueyf2yPAM9bWAxRUTaII+3E5Y=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-33Ps384pP0Ojo0x-YBp0jw-1; Fri, 25 Jun 2021 11:32:28 -0400
X-MC-Unique: 33Ps384pP0Ojo0x-YBp0jw-1
Received: by mail-io1-f72.google.com with SMTP id d24-20020a5d95180000b02904f1970a0af0so1106660iom.6
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5L+y5wxukijhnMqO8uY2oYn+ZxljnPTrsvoXiVvQBkI=;
        b=E5JdceTnhBSqkUdaeRZRzoB1s2cRj04xI6lmGI4/9vvzQp2MEu3RQOjfXbAmoRVIff
         7VIEbivPGNipzJm4k94+jwJa6s/8xENUKPsmr1GOivsOxo4sH3dTR914IqDbXJ4tm7yd
         OEXTvoQWhWoQuQ4SSOqoysV2Nsncfa3I0+4nOqMYJuYL55u1Mqxnv0M6fMGXlWnbb9m/
         WBEYwP4R++xGZE0dutkZL0UCjH/M1L97BnHyqpGyMFqUHKy2qHQnSUJxfAT2RMQOnUxP
         M9hsLaqz01eEncBV/bjLGV82nWeTP6Wsor0rNNxETYp/s1RGVQxQ+HnNc6zNttB1fCNp
         3Dzw==
X-Gm-Message-State: AOAM5308G35vu0a+LHsws4KWlKucVkNx1ODjSPW3DU1hCjdD9vHDQtB7
        2xh7BYWjfpzgdqux7RqB9WnIjJtHZkYqAz5DPrwNoYgS/gar9uP7jHrj8YKiH7nrGeRDdqtV3Vj
        4h/HbwzcmZPnP
X-Received: by 2002:a6b:4905:: with SMTP id u5mr8857144iob.55.1624635146772;
        Fri, 25 Jun 2021 08:32:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTfhbYTxu+uLNMWEhDkuuhs/pLwJAGvcKmYGmdYiFeDS8YErT8ZbVBAACcbTtCofcPlVsnpA==
X-Received: by 2002:a6b:4905:: with SMTP id u5mr8857130iob.55.1624635146616;
        Fri, 25 Jun 2021 08:32:26 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id s8sm3668772ilj.51.2021.06.25.08.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:32:26 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, peterx@redhat.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 6/9] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file
Date:   Fri, 25 Jun 2021 11:32:11 -0400
Message-Id: <20210625153214.43106-7-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625153214.43106-1-peterx@redhat.com>
References: <20210625153214.43106-1-peterx@redhat.com>
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
index b64708f9f27d..c3c51361cf6c 100644
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
 
@@ -11138,6 +11140,117 @@ int kvm_arch_post_init_vm(struct kvm *kvm)
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

