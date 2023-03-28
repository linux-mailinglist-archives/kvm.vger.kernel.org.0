Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073536CBF10
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjC1Mbg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 08:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC1Mbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 08:31:34 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20AC9974C;
        Tue, 28 Mar 2023 05:31:21 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxedkZ3iJksRgTAA--.29214S3;
        Tue, 28 Mar 2023 20:31:21 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxPL4X3iJku2cPAA--.12046S4;
        Tue, 28 Mar 2023 20:31:20 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PING PATCH v4 02/29] LoongArch: KVM: Implement kvm module related interface
Date:   Tue, 28 Mar 2023 20:30:52 +0800
Message-Id: <20230328123119.3649361-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
References: <20230328123119.3649361-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxPL4X3iJku2cPAA--.12046S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3Jry7JryxuFyDWr4rur4xXrb_yoWxKw1DpF
        W0krW8Ar17GFnrWa4rJw1Y9w45XrZ7ua90yF13trWktw1jvrWrua4IkF17XFy5Jw1xXF1j
        k3Z5AFZa9F1kXrDanT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bc8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
        0267AKxVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF
        6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8V
        WrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWU
        twCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
        wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj4RKpBTUUUUU
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement loongarch kvm module init, module exit interface,
using kvm context to save the vpid info and vcpu world switch
interface pointer.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/main.c | 197 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 197 insertions(+)
 create mode 100644 arch/loongarch/kvm/main.c

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
new file mode 100644
index 000000000..2c6b4760f
--- /dev/null
+++ b/arch/loongarch/kvm/main.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/kvm_host.h>
+#include <asm/cacheflush.h>
+
+static struct kvm_context __percpu *vmcs;
+struct kvm_world_switch *kvm_loongarch_ops;
+unsigned long vpid_mask;
+static int gcsr_flag[CSR_ALL_SIZE];
+
+int get_gcsr_flag(int csr)
+{
+	return gcsr_flag[csr];
+}
+
+static inline void set_gcsr_sw_flag(int csr)
+{
+	gcsr_flag[csr] |= SW_GCSR;
+}
+
+static inline void set_gcsr_hw_flag(int csr)
+{
+	gcsr_flag[csr] |= HW_GCSR;
+}
+
+/*
+ * The default value of gcsr_flag[CSR] is 0(INVALID_GCSR), and we use this
+ * function to set the flag to 1(SW_GCSR) or 2(HW_GCSR) if the gcsr is software
+ * or hardware. It will be used by get/set_gcsr, if gcsr_flag is HW we should
+ * use gcsrrd/gcsrwr to access it, else use sw csr to emulate it.
+ */
+static void _kvm_init_gcsr_flag(void)
+{
+	set_gcsr_hw_flag(LOONGARCH_CSR_CRMD);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PRMD);
+	set_gcsr_hw_flag(LOONGARCH_CSR_EUEN);
+	set_gcsr_hw_flag(LOONGARCH_CSR_MISC);
+	set_gcsr_hw_flag(LOONGARCH_CSR_ECFG);
+	set_gcsr_hw_flag(LOONGARCH_CSR_ESTAT);
+	set_gcsr_hw_flag(LOONGARCH_CSR_ERA);
+	set_gcsr_hw_flag(LOONGARCH_CSR_BADV);
+	set_gcsr_hw_flag(LOONGARCH_CSR_BADI);
+	set_gcsr_hw_flag(LOONGARCH_CSR_EENTRY);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBIDX);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBEHI);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO0);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBELO1);
+	set_gcsr_hw_flag(LOONGARCH_CSR_ASID);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PGDL);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PGDH);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL0);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PWCTL1);
+	set_gcsr_hw_flag(LOONGARCH_CSR_STLBPGSIZE);
+	set_gcsr_hw_flag(LOONGARCH_CSR_RVACFG);
+	set_gcsr_hw_flag(LOONGARCH_CSR_CPUID);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG1);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG2);
+	set_gcsr_hw_flag(LOONGARCH_CSR_PRCFG3);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS0);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS1);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS2);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS3);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS4);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS5);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS6);
+	set_gcsr_hw_flag(LOONGARCH_CSR_KS7);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TMID);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TCFG);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TVAL);
+	set_gcsr_hw_flag(LOONGARCH_CSR_CNTC);
+	set_gcsr_hw_flag(LOONGARCH_CSR_LLBCTL);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRENTRY);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRBADV);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRERA);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRSAVE);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO0);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRELO1);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBREHI);
+	set_gcsr_hw_flag(LOONGARCH_CSR_TLBRPRMD);
+	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN0);
+	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN1);
+	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN2);
+	set_gcsr_hw_flag(LOONGARCH_CSR_DMWIN3);
+	set_gcsr_hw_flag(LOONGARCH_CSR_MWPS);
+	set_gcsr_hw_flag(LOONGARCH_CSR_FWPS);
+
+	set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL1);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IMPCTL2);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MERRCTL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO1);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MERRINFO2);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MERRENTRY);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MERRERA);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MERRSAVE);
+	set_gcsr_sw_flag(LOONGARCH_CSR_CTAG);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DEBUG);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DERA);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DESAVE);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG1);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG2);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PRCFG3);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PGD);
+	set_gcsr_sw_flag(LOONGARCH_CSR_TINTCLR);
+}
+
+static int kvm_loongarch_env_init(void)
+{
+	struct kvm_context *context;
+	int cpu, order;
+	void *addr;
+
+	vmcs = alloc_percpu(struct kvm_context);
+	if (!vmcs) {
+		pr_err("kvm: failed to allocate percpu kvm_context\n");
+		return -ENOMEM;
+	}
+
+	kvm_loongarch_ops = kzalloc(sizeof(*kvm_loongarch_ops), GFP_KERNEL);
+	if (!kvm_loongarch_ops)
+		return -ENOMEM;
+
+	/*
+	 * There will be problem in world switch code if there
+	 * is page fault reenter, since pgd register is shared
+	 * between root kernel and kvm hypervisor. World switch
+	 * entry need be unmapped area, cannot be tlb mapped area.
+	 * In future if hw pagetable walking is supported, or there
+	 * is separate pgd registers between root kernel and kvm
+	 * hypervisor, copying about world switch code will not be used.
+	 */
+
+	order = get_order(kvm_vector_size + kvm_enter_guest_size);
+	addr = (void *)__get_free_pages(GFP_KERNEL, order);
+	if (!addr) {
+		free_percpu(vmcs);
+		return -ENOMEM;
+	}
+
+	memcpy(addr, kvm_vector_entry, kvm_vector_size);
+	memcpy(addr + kvm_vector_size, kvm_enter_guest, kvm_enter_guest_size);
+	flush_icache_range((unsigned long)addr, (unsigned long)addr +
+				kvm_vector_size + kvm_enter_guest_size);
+	kvm_loongarch_ops->guest_eentry = addr;
+	kvm_loongarch_ops->enter_guest = addr + kvm_vector_size;
+	kvm_loongarch_ops->page_order = order;
+
+	vpid_mask = read_csr_gstat();
+	vpid_mask = (vpid_mask & CSR_GSTAT_GIDBIT) >> CSR_GSTAT_GIDBIT_SHIFT;
+	if (vpid_mask)
+		vpid_mask = GENMASK(vpid_mask - 1, 0);
+
+	for_each_possible_cpu(cpu) {
+		context = per_cpu_ptr(vmcs, cpu);
+		context->vpid_cache = vpid_mask + 1;
+		context->last_vcpu = NULL;
+	}
+
+	_kvm_init_fault();
+	_kvm_init_gcsr_flag();
+
+	return 0;
+}
+
+static void kvm_loongarch_env_exit(void)
+{
+	free_pages((unsigned long)kvm_loongarch_ops->guest_eentry, kvm_loongarch_ops->page_order);
+	free_percpu(vmcs);
+}
+
+static int kvm_loongarch_init(void)
+{
+	int r;
+
+	if (!cpu_has_lvz)
+		return 0;
+
+	r = kvm_loongarch_env_init();
+	if (r)
+		return r;
+
+	return kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+}
+
+static void kvm_loongarch_exit(void)
+{
+	kvm_exit();
+	kvm_loongarch_env_exit();
+}
+
+module_init(kvm_loongarch_init);
+module_exit(kvm_loongarch_exit);
-- 
2.31.1

