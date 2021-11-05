Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76553446B6F
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 00:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233686AbhKFAB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 20:01:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4775 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhKFABo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 20:01:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636156743; x=1667692743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CPBkmZZLjh3iLG2oa7rF/7SGMXdLh45iugpgmq06jR0=;
  b=B6HaNlVJKcbgITTiy7kROnS4Gr7KqigJVfjoNuHXFdTDeF/vglFV0ep1
   3sYGZGVDmQcxd1PxTLoFyqxmZ3u7VaiwOyog4r2+ZOcvZg/ObImEug+L+
   NUvX7ojTk0DQ0ltd4BA1aMMdr5yDup7rFRJjfq0UYyVTGM/qzBc2f6m0a
   zhZP3g/NALgCJFyrGh59ps0OJpCEkNyWxIA32ztZY7eQ6H3DDzi4tKxQS
   If22xEvnympPV8OUm5rILVYoAW5v+hP+3YeFrkJVBhat44ladnxLn2Jd+
   RISCiuhtfjKT4Ct8mZkeIVU/CTnBhF6GVIzmL6qlYLCA1IUxZu3IemKzT
   w==;
X-IronPort-AV: E=Sophos;i="5.87,212,1631548800"; 
   d="scan'208";a="189637770"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2021 07:59:03 +0800
IronPort-SDR: e41hfve6MU8Nr3H6gGZPc0rZtZXjXoI7R5XxPo5EBZN+qgae1KbjNBJsAQLcTfM9Ytf4RJm3x3
 Hv3aQyDJnXEpE0bhsQyjc05moGu76Cs0+F2P/FVY4rdQgBnUIPvrsuMH4sQtKVQ8LgM9YfFpeP
 nF6uGvu0gvnFCy4nH+Q/e+kC1yLdJgLQNUg8zO2PTTxtSwCAQOObNcQjvZC1EgNFKHV65vtGzS
 O2KnYVxB3tWxjnEeyvwo7uAP3/EGCYjK2L/OOPBj7NMxoHv42OhY7Br/Z/c5+CJ3Oq6+bLKKyF
 xRgUkz52Ld9w57hwbxTkLH+L
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 16:32:48 -0700
IronPort-SDR: Usq9zpvtPvxj8wXdxBMHGJngbrSgxOMSBNgqyOohPmxmbffHG+jDOLZ3zyORCCSD9WL7vh51ok
 xMVcQONiQUfhc2EWL6VTd52yU8KHl46VmRh21ytS+gi1JRNH9tW/qDm9z4CMxfeBPo91/Rvdfg
 uRqw8OopCyvo2dz5A7h8m/huCh4/JZNrZrdukwZKhfqklLzuGDUuFXKmlUzyDaaT1t4NNn6OAI
 EAdS+lHgFYYcqFZfEloyvDfDmc6Jw1lo5x1LWYiAufwXrmwbhrKvfz2SvnOPgIfY2t0CvOV9DF
 MKY=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Nov 2021 16:59:04 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>, Anup Patel <anup.patel@wdc.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>, pbonzini@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v4 5/5] RISC-V: KVM: Add SBI HSM extension in KVM
Date:   Fri,  5 Nov 2021 16:58:52 -0700
Message-Id: <20211105235852.3011900-6-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105235852.3011900-1-atish.patra@wdc.com>
References: <20211105235852.3011900-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI HSM extension allows OS to start/stop harts any time. It also allows
ordered booting of harts instead of random booting.

Implement SBI HSM exntesion and designate the vcpu 0 as the boot vcpu id.
All other non-zero non-booting vcpus should be brought up by the OS
implementing HSM extension. If the guest OS doesn't implement HSM
extension, only single vcpu will be available to OS.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/sbi.h  |   1 +
 arch/riscv/kvm/Makefile       |   1 +
 arch/riscv/kvm/vcpu.c         |  23 ++++++++
 arch/riscv/kvm/vcpu_sbi.c     |   4 ++
 arch/riscv/kvm/vcpu_sbi_hsm.c | 107 ++++++++++++++++++++++++++++++++++
 5 files changed, 136 insertions(+)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_hsm.c

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 4f9370b6032e..79af25c45c8d 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -90,6 +90,7 @@ enum sbi_hsm_hart_status {
 #define SBI_ERR_INVALID_PARAM	-3
 #define SBI_ERR_DENIED		-4
 #define SBI_ERR_INVALID_ADDRESS	-5
+#define SBI_ERR_ALREADY_AVAILABLE -6
 
 extern unsigned long sbi_spec_version;
 struct sbiret {
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4757ae158bf3..aaf181a3d74b 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -26,4 +26,5 @@ kvm-y += vcpu_sbi.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
 kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_sbi_replace.o
+kvm-y += vcpu_sbi_hsm.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e3d3aed46184..50158867406d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -53,6 +53,17 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
 	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
 	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
+	bool loaded;
+
+	/**
+	 * The preemption should be disabled here because it races with
+	 * kvm_sched_out/kvm_sched_in(called from preempt notifiers) which
+	 * also calls vcpu_load/put.
+	 */
+	get_cpu();
+	loaded = (vcpu->cpu != -1);
+	if (loaded)
+		kvm_arch_vcpu_put(vcpu);
 
 	memcpy(csr, reset_csr, sizeof(*csr));
 
@@ -64,6 +75,11 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+
+	/* Reset the guest CSRs for hotplug usecase */
+	if (loaded)
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	put_cpu();
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
@@ -100,6 +116,13 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
+	/**
+	 * vcpu with id 0 is the designated boot cpu.
+	 * Keep all vcpus with non-zero cpu id in power-off state so that they
+	 * can brought to online using SBI HSM extension.
+	 */
+	if (vcpu->vcpu_idx != 0)
+		kvm_riscv_vcpu_power_off(vcpu);
 }
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 3502c6166eba..bff753b6e4b0 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -25,6 +25,8 @@ static int kvm_linux_err_map_sbi(int err)
 		return SBI_ERR_INVALID_ADDRESS;
 	case -EOPNOTSUPP:
 		return SBI_ERR_NOT_SUPPORTED;
+	case -EALREADY:
+		return SBI_ERR_ALREADY_AVAILABLE;
 	default:
 		return SBI_ERR_FAILURE;
 	};
@@ -43,6 +45,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
 
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_v01,
@@ -50,6 +53,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_time,
 	&vcpu_sbi_ext_ipi,
 	&vcpu_sbi_ext_rfence,
+	&vcpu_sbi_ext_hsm,
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
new file mode 100644
index 000000000000..aefee16a1560
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_sbi.h>
+
+static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *reset_cntx;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	struct kvm_vcpu *target_vcpu;
+	unsigned long target_vcpuid = cp->a0;
+
+	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
+	if (!target_vcpu)
+		return -EINVAL;
+	if (!target_vcpu->arch.power_off)
+		return -EALREADY;
+
+	reset_cntx = &target_vcpu->arch.guest_reset_context;
+	/* start address */
+	reset_cntx->sepc = cp->a1;
+	/* target vcpu id to start */
+	reset_cntx->a0 = target_vcpuid;
+	/* private data passed from kernel */
+	reset_cntx->a1 = cp->a2;
+	kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
+
+	kvm_riscv_vcpu_power_on(target_vcpu);
+
+	return 0;
+}
+
+static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.power_off)
+		return -EINVAL;
+
+	kvm_riscv_vcpu_power_off(vcpu);
+
+	return 0;
+}
+
+static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long target_vcpuid = cp->a0;
+	struct kvm_vcpu *target_vcpu;
+
+	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
+	if (!target_vcpu)
+		return -EINVAL;
+	if (!target_vcpu->arch.power_off)
+		return SBI_HSM_HART_STATUS_STARTED;
+	else
+		return SBI_HSM_HART_STATUS_STOPPED;
+}
+
+static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				   unsigned long *out_val,
+				   struct kvm_cpu_trap *utrap,
+				   bool *exit)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long funcid = cp->a6;
+
+	if (!cp)
+		return -EINVAL;
+	switch (funcid) {
+	case SBI_EXT_HSM_HART_START:
+		mutex_lock(&kvm->lock);
+		ret = kvm_sbi_hsm_vcpu_start(vcpu);
+		mutex_unlock(&kvm->lock);
+		break;
+	case SBI_EXT_HSM_HART_STOP:
+		ret = kvm_sbi_hsm_vcpu_stop(vcpu);
+		break;
+	case SBI_EXT_HSM_HART_STATUS:
+		ret = kvm_sbi_hsm_vcpu_get_status(vcpu);
+		if (ret >= 0) {
+			*out_val = ret;
+			ret = 0;
+		}
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm = {
+	.extid_start = SBI_EXT_HSM,
+	.extid_end = SBI_EXT_HSM,
+	.handler = kvm_sbi_ext_hsm_handler,
+};
-- 
2.31.1

