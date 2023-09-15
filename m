Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14B17A1321
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjIOBuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjIOBuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:05 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2ED5E270F;
        Thu, 14 Sep 2023 18:49:57 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxDOtDuANliv4nAA--.6203S3;
        Fri, 15 Sep 2023 09:49:55 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S6;
        Fri, 15 Sep 2023 09:49:54 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v21 04/29] LoongArch: KVM: Implement VM related functions
Date:   Fri, 15 Sep 2023 09:49:24 +0800
Message-Id: <20230915014949.1222777-5-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S6
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch VM operations: Init and destroy vm interface,
allocating memory page to save the vm pgd when init vm. Implement
vm check extension, such as getting vcpu number info, memory slots
info, and fpu info. And implement vm status description.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vm.c | 92 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 arch/loongarch/kvm/vm.c

diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
new file mode 100644
index 0000000000..abc345bf37
--- /dev/null
+++ b/arch/loongarch/kvm/vm.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_mmu.h>
+
+const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+	KVM_GENERIC_VM_STATS(),
+	STATS_DESC_ICOUNTER(VM, pages),
+	STATS_DESC_ICOUNTER(VM, hugepages),
+};
+
+const struct kvm_stats_header kvm_vm_stats_header = {
+	.name_size = KVM_STATS_NAME_SIZE,
+	.num_desc = ARRAY_SIZE(kvm_vm_stats_desc),
+	.id_offset =  sizeof(struct kvm_stats_header),
+	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
+	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
+					sizeof(kvm_vm_stats_desc),
+};
+
+int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
+{
+	int i;
+
+	/* Allocate page table to map GPA -> RPA */
+	kvm->arch.pgd = kvm_pgd_alloc();
+	if (!kvm->arch.pgd)
+		return -ENOMEM;
+
+	kvm_init_vmcs(kvm);
+	kvm->arch.gpa_size = BIT(cpu_vabits - 1);
+	kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
+	kvm->arch.invalid_ptes[0] = 0;
+	kvm->arch.invalid_ptes[1] = (unsigned long)invalid_pte_table;
+	kvm->arch.invalid_ptes[2] = (unsigned long)invalid_pmd_table;
+#if CONFIG_PGTABLE_LEVELS > 3
+	kvm->arch.invalid_ptes[3] = (unsigned long)invalid_pud_table;
+#endif
+	for (i = 0; i <= kvm->arch.root_level; i++)
+		kvm->arch.pte_shifts[i] = PAGE_SHIFT + i * (PAGE_SHIFT - 3);
+
+	return 0;
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	kvm_destroy_vcpus(kvm);
+	free_page((unsigned long)kvm->arch.pgd);
+	kvm->arch.pgd = NULL;
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_SYNC_MMU:
+	case KVM_CAP_IMMEDIATE_EXIT:
+	case KVM_CAP_IOEVENTFD:
+	case KVM_CAP_MP_STATE:
+		r = 1;
+		break;
+	case KVM_CAP_NR_VCPUS:
+		r = num_online_cpus();
+		break;
+	case KVM_CAP_MAX_VCPUS:
+		r = KVM_MAX_VCPUS;
+		break;
+	case KVM_CAP_MAX_VCPU_ID:
+		r = KVM_MAX_VCPU_IDS;
+		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r = KVM_USER_MEM_SLOTS;
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
-- 
2.39.1

