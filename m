Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E216D6956D8
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBNC44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBNC4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:56:55 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F03CF18A80;
        Mon, 13 Feb 2023 18:56:52 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxC9pz+OpjKFcAAA--.937S3;
        Tue, 14 Feb 2023 10:56:51 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axeb1w+OpjmZwyAA--.28802S4;
        Tue, 14 Feb 2023 10:56:50 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v1 02/24] LoongArch: KVM: Implement VM related functions
Date:   Tue, 14 Feb 2023 10:56:26 +0800
Message-Id: <20230214025648.1898508-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axeb1w+OpjmZwyAA--.28802S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxuFy5ur1UZr4fZFWxZrWxXrb_yoW5Xr15pF
        1UAay5Kr4rXwn3tr1fJ3yDuw1S9a93GryxJa42v345CFnxtwn5XFy0yry3GF98J34ruFyf
        Xa4aqwn09a4Yy3DanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bckFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
        CjxVAFwI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAq
        jxCEc2xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6c
        x26rWlOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r12
        6r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_WwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
        Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
        IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
        6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0zR9iSdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement loongarch VM operations:
1. Init and destroy vm interface, allocating memory page to save the
vm pgd when init vm.
2. Implement vm check extension, such as getting vcpu number info,
memory slots info, and fpu info.
3. Implement vm status description.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vm.c | 85 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 arch/loongarch/kvm/vm.c

diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
new file mode 100644
index 000000000..6efa6689b
--- /dev/null
+++ b/arch/loongarch/kvm/vm.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_host.h>
+
+#define KVM_LOONGARCH_VERSION 1
+
+const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+	KVM_GENERIC_VM_STATS(),
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
+	/* Allocate page table to map GPA -> RPA */
+	kvm->arch.gpa_mm.pgd = kvm_pgd_alloc();
+	if (!kvm->arch.gpa_mm.pgd)
+		return -ENOMEM;
+
+	kvm_init_vmcs(kvm);
+	return 0;
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	kvm_destroy_vcpus(kvm);
+	_kvm_destroy_mm(kvm);
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
+	case KVM_CAP_LOONGARCH_FPU:
+		/* We don't handle systems with inconsistent cpu_has_fpu */
+		r = !!cpu_has_fpu;
+		break;
+	case KVM_CAP_LOONGARCH_VZ:
+		/* get user defined kvm version */
+		r = KVM_LOONGARCH_VERSION;
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
+{
+	return -ENOIOCTLCMD;
+}
-- 
2.31.1

