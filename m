Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF8B7AF9A8
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjI0EsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjI0Erl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:47:41 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 118E812A;
        Tue, 26 Sep 2023 20:10:04 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxY_AKnRNl2hYtAA--.20855S3;
        Wed, 27 Sep 2023 11:10:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S4;
        Wed, 27 Sep 2023 11:10:01 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 02/25] LoongArch: KVM: Implement kvm module related interface
Date:   Wed, 27 Sep 2023 11:09:36 +0800
Message-Id: <20230927030959.3629941-3-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S4
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch kvm module init, module exit interface, using kvm
context to save the vpid info and vcpu world switch interface pointer.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/main.c | 358 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 358 insertions(+)
 create mode 100644 arch/loongarch/kvm/main.c

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
new file mode 100644
index 0000000000..267c0505ea
--- /dev/null
+++ b/arch/loongarch/kvm/main.c
@@ -0,0 +1,358 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
+#include <asm/kvm_csr.h>
+#include "trace.h"
+
+unsigned long vpid_mask;
+struct kvm_world_switch *kvm_loongarch_ops;
+static int gcsr_flag[CSR_MAX_NUMS];
+static struct kvm_context __percpu *vmcs;
+
+int get_gcsr_flag(int csr)
+{
+	if (csr < CSR_MAX_NUMS)
+		return gcsr_flag[csr];
+
+	return INVALID_GCSR;
+}
+
+static inline void set_gcsr_sw_flag(int csr)
+{
+	if (csr < CSR_MAX_NUMS)
+		gcsr_flag[csr] |= SW_GCSR;
+}
+
+static inline void set_gcsr_hw_flag(int csr)
+{
+	if (csr < CSR_MAX_NUMS)
+		gcsr_flag[csr] |= HW_GCSR;
+}
+
+/*
+ * The default value of gcsr_flag[CSR] is 0, and we use this
+ * function to set the flag to 1 (SW_GCSR) or 2 (HW_GCSR) if the
+ * gcsr is software or hardware. It will be used by get/set_gcsr,
+ * if gcsr_flag is HW we should use gcsrrd/gcsrwr to access it,
+ * else use software csr to emulate it.
+ */
+static void kvm_init_gcsr_flag(void)
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
+	set_gcsr_hw_flag(LOONGARCH_CSR_PGD);
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
+	set_gcsr_hw_flag(LOONGARCH_CSR_TINTCLR);
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
+
+	set_gcsr_sw_flag(LOONGARCH_CSR_FWPC);
+	set_gcsr_sw_flag(LOONGARCH_CSR_FWPS);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MWPC);
+	set_gcsr_sw_flag(LOONGARCH_CSR_MWPS);
+
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB0ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB0MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB0CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB0ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB1ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB1MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB1CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB1ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB2ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB2MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB2CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB2ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB3ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB3MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB3CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB3ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB4ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB4MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB4CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB4ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB5ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB5MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB5CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB5ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB6ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB6MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB6CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB6ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB7ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB7MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB7CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_DB7ASID);
+
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB0ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB0MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB0CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB0ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB1ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB1MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB1CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB1ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB2ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB2MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB2CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB2ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB3ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB3MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB3CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB3ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB4ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB4MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB4CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB4ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB5ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB5MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB5CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB5ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB6ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB6MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB6CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB6ASID);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB7ADDR);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB7MASK);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB7CTRL);
+	set_gcsr_sw_flag(LOONGARCH_CSR_IB7ASID);
+
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL0);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR0);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL1);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR1);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL2);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR2);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCTRL3);
+	set_gcsr_sw_flag(LOONGARCH_CSR_PERFCNTR3);
+}
+
+static void kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
+{
+	unsigned long vpid;
+	struct kvm_context *context;
+
+	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+	vpid = context->vpid_cache + 1;
+	if (!(vpid & vpid_mask)) {
+		/* finish round of vpid loop */
+		if (unlikely(!vpid))
+			vpid = vpid_mask + 1;
+
+		++vpid; /* vpid 0 reserved for root */
+
+		/* start new vpid cycle */
+		kvm_flush_tlb_all();
+	}
+
+	context->vpid_cache = vpid;
+	vcpu->arch.vpid = vpid;
+}
+
+void kvm_check_vpid(struct kvm_vcpu *vcpu)
+{
+	int cpu;
+	bool migrated;
+	unsigned long ver, old, vpid;
+	struct kvm_context *context;
+
+	cpu = smp_processor_id();
+	/*
+	 * Are we entering guest context on a different CPU to last time?
+	 * If so, the vCPU's guest TLB state on this CPU may be stale.
+	 */
+	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
+	migrated = (vcpu->cpu != cpu);
+
+	/*
+	 * Check if our vpid is of an older version
+	 *
+	 * We also discard the stored vpid if we've executed on
+	 * another CPU, as the guest mappings may have changed without
+	 * hypervisor knowledge.
+	 */
+	ver = vcpu->arch.vpid & ~vpid_mask;
+	old = context->vpid_cache  & ~vpid_mask;
+	if (migrated || (ver != old)) {
+		kvm_update_vpid(vcpu, cpu);
+		trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
+		vcpu->cpu = cpu;
+	}
+
+	/* Restore GSTAT(0x50).vpid */
+	vpid = (vcpu->arch.vpid & vpid_mask) << CSR_GSTAT_GID_SHIFT;
+	change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
+}
+
+static int kvm_loongarch_env_init(void)
+{
+	int cpu, order;
+	void *addr;
+	struct kvm_context *context;
+
+	vmcs = alloc_percpu(struct kvm_context);
+	if (!vmcs) {
+		pr_err("kvm: failed to allocate percpu kvm_context\n");
+		return -ENOMEM;
+	}
+
+	kvm_loongarch_ops = kzalloc(sizeof(*kvm_loongarch_ops), GFP_KERNEL);
+	if (!kvm_loongarch_ops) {
+		free_percpu(vmcs);
+		vmcs = NULL;
+		return -ENOMEM;
+	}
+
+	/*
+	 * PGD register is shared between root kernel and kvm hypervisor.
+	 * So world switch entry should be in DMW area rather than TLB area
+	 * to avoid page fault reenter.
+	 *
+	 * In future if hardware pagetable walking is supported, we won't
+	 * need to copy world switch code to DMW area.
+	 */
+	order = get_order(kvm_exception_size + kvm_enter_guest_size);
+	addr = (void *)__get_free_pages(GFP_KERNEL, order);
+	if (!addr) {
+		free_percpu(vmcs);
+		vmcs = NULL;
+		kfree(kvm_loongarch_ops);
+		kvm_loongarch_ops = NULL;
+		return -ENOMEM;
+	}
+
+	memcpy(addr, kvm_exc_entry, kvm_exception_size);
+	memcpy(addr + kvm_exception_size, kvm_enter_guest, kvm_enter_guest_size);
+	flush_icache_range((unsigned long)addr, (unsigned long)addr + kvm_exception_size + kvm_enter_guest_size);
+	kvm_loongarch_ops->exc_entry = addr;
+	kvm_loongarch_ops->enter_guest = addr + kvm_exception_size;
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
+	kvm_init_gcsr_flag();
+
+	return 0;
+}
+
+static void kvm_loongarch_env_exit(void)
+{
+	unsigned long addr;
+
+	if (vmcs)
+		free_percpu(vmcs);
+
+	if (kvm_loongarch_ops) {
+		if (kvm_loongarch_ops->exc_entry) {
+			addr = (unsigned long)kvm_loongarch_ops->exc_entry;
+			free_pages(addr, kvm_loongarch_ops->page_order);
+		}
+		kfree(kvm_loongarch_ops);
+	}
+}
+
+static int kvm_loongarch_init(void)
+{
+	int r;
+
+	if (!cpu_has_lvz) {
+		kvm_info("Hardware virtualization not available\n");
+		return -ENODEV;
+	}
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
+
+#ifdef MODULE
+static const struct cpu_feature kvm_feature[] = {
+	{ .feature = cpu_feature(LOONGARCH_LVZ) },
+	{},
+};
+MODULE_DEVICE_TABLE(cpu, kvm_feature);
+#endif
-- 
2.39.3

