Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FFC3B3570
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhFXSQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232604AbhFXSQa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yZ5ari2GxI81SYwIm60/E7Xbba1sdIVbXhz1cSIMcs=;
        b=bDWTHSPNVeOBWoxdPOqsgg8D3C0GgOkb6lIaTVkR07AQ6XZau2FlGzSRHruFLutTz6w+0c
        u28n555o52VaO+cno/cjm38j0ud2HYHks5WyrEo0YuJLUiA6Wu3HQE2OZtL3a/YMCwUUHS
        GyUvIP/+wfTzu1lQ0h6edoIkwSOR1yA=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-TgAUrnLQMJGhB9rv7ckxQg-1; Thu, 24 Jun 2021 14:14:09 -0400
X-MC-Unique: TgAUrnLQMJGhB9rv7ckxQg-1
Received: by mail-qt1-f199.google.com with SMTP id t6-20020ac80dc60000b029024e988e8277so7101092qti.23
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:14:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/yZ5ari2GxI81SYwIm60/E7Xbba1sdIVbXhz1cSIMcs=;
        b=GHzuIbhSP4X6pqrupcr79nWTQ2OjeekcYrXT8+xJjLht5bUl1J2NPu/268a+bYiZ4b
         VXBoY9jTwodRwEchLYGV9elnE0X1IGSEbwQxpIaiC/fPU+RWiKBCqkN6pBQT+wUHfC4c
         vM/MpWKEe/XNSobNVhYsgaZ5cDXY9kZ7SH2q+YC5INmIeLgpTx5IbO9NGZBoAXeH+ptB
         5zwefbcem7+sQFHbltMBknorNihUHFTurfZYo8NptLI4hdKpn6Tz+I0RPgfXc+kVL3yS
         Rlo2Y9urNQzblRXdPeBsor3Cwnq5LDFVmzqVXbtexSr8DVMQ2EMxn6PAwn6khLWgLPk+
         qNmQ==
X-Gm-Message-State: AOAM532KXNyXZhHRYJpJU+9BDKuqS4DlqOcN3twMsecYZmdYdBabjj8z
        8UEdb1wo7CouGQUqdRzdu+Fu15LCjOKQEAf8u1hcmKIpx+m0FCcddv1ilQDQoZeJzY3vOGHb/+x
        1JnlIIAvpNdgNrgcUz2pBcSe8TwNMylk0E3Wn8aq7QhAu7tKJDTzME/tNQqx8/A==
X-Received: by 2002:a37:9a51:: with SMTP id c78mr6998659qke.51.1624558448163;
        Thu, 24 Jun 2021 11:14:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqgpBf2cWmlIRdlKjq1uHOYzaPGIHk6EiH4zSJaOEnFdCdUw6l+gCzal6Txx9g68afbsz6bA==
X-Received: by 2002:a37:9a51:: with SMTP id c78mr6998629qke.51.1624558447861;
        Thu, 24 Jun 2021 11:14:07 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:14:07 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6/9] KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file
Date:   Thu, 24 Jun 2021 14:13:53 -0400
Message-Id: <20210624181356.10235-7-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624181356.10235-1-peterx@redhat.com>
References: <20210624181356.10235-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use this file to dump rmap statistic information.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/x86.c | 113 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2acbea2f3b5..6dfae8375c44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -30,6 +30,7 @@
 #include "hyperv.h"
 #include "lapic.h"
 #include "xen.h"
+#include "mmu/mmu_internal.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -58,6 +59,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
+#include <linux/debugfs.h>
 
 #include <trace/events/kvm.h>
 
@@ -10763,6 +10765,117 @@ int kvm_arch_post_init_vm(struct kvm *kvm)
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

