Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C5446B6E
	for <lists+kvm@lfdr.de>; Sat,  6 Nov 2021 00:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhKFABv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 20:01:51 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:4775 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233506AbhKFABn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 20:01:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636156743; x=1667692743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8N7I3xFAN4A0OtRWqWWyaemIsM7CmwJ3kiGZkFqV+q8=;
  b=OKbx9+6SFOsxgSkBnTslP3hpr62xaIN1SAoD9A4I7W52mT32dsgckEO1
   PbhKG8gd140CV/iRWZ7g6iyrc/SbIzt5fz/etesvSUgMBDwBEpD6yaLcI
   PAK3GcKgJCPTS3wtPjN1mqH1NwB++NLaojJ5g83F7u0uwAsvJmiOZ5Ahh
   +K8YjBVVxtSYXsP0NDyR+ryA74eeHOoHvf3UAze6j0uT7BoZOn69Vp62b
   WTyMs3V2WhcvmUInyBXpzo7eAc18cNPLLWDVdEeBrkpZymgjT6vmIdjUG
   ggdQKWA7ohF8Djo2R9wgrto4lJMii4EUJq7ChhwsVyQ98X2GigqBrjy2K
   A==;
X-IronPort-AV: E=Sophos;i="5.87,212,1631548800"; 
   d="scan'208";a="189637769"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2021 07:59:02 +0800
IronPort-SDR: ZP60XWkUpGj8m2OXwX54vUXBWIowWPhZvUh64/mXKNPiF/y359qRZkyVIwatG79SOKftiLufw1
 2P8jNt470bi47GVZ/+534ZBHQ7BaLLRGaJ4VOOOil7YU0EmThn7OUxyYPtk5uFV5OrHsWjIiVV
 MHDGHm4cvwrjTYWRBt1paRH13VSBTgS3cJnV2ckG5Yl9kU8zsdOQojO/BDVITNbHltWFi2B9Pr
 pW/up+i1IqDScmAxXjL25pg+wDvpG+k5CFYGkM3/kVAwSISPpbBzn8Mcu4ougnqvs8dZc8Mucz
 DmmNjb/hbl7tgkq7ZIdJqVSk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2021 16:32:47 -0700
IronPort-SDR: 4prbuhVOfYfRIJwLSL7Yjz1dLcKn/hge99idIBa14P8ZIIGPjNHHUfE2mCr/KBWIIEUhc2N+z7
 swEaWYHUJpgwPYewqvPckC2DIO83iM7OGTRMRXgc6GFR0Z3HQZDL6BOGU2cb5JnX+KoyscMrUE
 62+cSD7jew3dwEd4mD7TER/g/GMbZaE652DjJ1TB8iq1POah0vHAN4TPizZYNCXJv6DuRWqKfx
 XaAGNubSHyGQrkIeAHxR/EvZe6dAY0+hi7D6pPZaSDRmqAkXnqm7EU9pTuz1y1rO/BrpRFPXQ4
 bFQ=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Nov 2021 16:59:03 -0700
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
Subject: [PATCH v4 4/5] RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v02
Date:   Fri,  5 Nov 2021 16:58:51 -0700
Message-Id: <20211105235852.3011900-5-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105235852.3011900-1-atish.patra@wdc.com>
References: <20211105235852.3011900-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SBI v0.2 contains some of the improved versions of required v0.1
extensions such as remote fence, timer and IPI.

This patch implements those extensions.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/vcpu_sbi.c         |   7 ++
 arch/riscv/kvm/vcpu_sbi_replace.c | 136 ++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_replace.c

diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 84c02922a329..4757ae158bf3 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -25,4 +25,5 @@ kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_v01.o
 kvm-y += vcpu_sbi_base.o
+kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 92b682f4f29e..3502c6166eba 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -40,9 +40,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
 };
 #endif
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
+
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_v01,
 	&vcpu_sbi_ext_base,
+	&vcpu_sbi_ext_time,
+	&vcpu_sbi_ext_ipi,
+	&vcpu_sbi_ext_rfence,
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
new file mode 100644
index 000000000000..a80fa7691b14
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -0,0 +1,136 @@
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
+#include <asm/kvm_vcpu_timer.h>
+#include <asm/kvm_vcpu_sbi.h>
+
+static int kvm_sbi_ext_time_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    unsigned long *out_val,
+				    struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	u64 next_cycle;
+
+	if (!cp || (cp->a6 != SBI_EXT_TIME_SET_TIMER))
+		return -EINVAL;
+
+#if __riscv_xlen == 32
+	next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+	next_cycle = (u64)cp->a0;
+#endif
+	kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time = {
+	.extid_start = SBI_EXT_TIME,
+	.extid_end = SBI_EXT_TIME,
+	.handler = kvm_sbi_ext_time_handler,
+};
+
+static int kvm_sbi_ext_ipi_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				   unsigned long *out_val,
+				   struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int i, ret = 0;
+	struct kvm_vcpu *tmp;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long hmask = cp->a0;
+	unsigned long hbase = cp->a1;
+
+	if (!cp || (cp->a6 != SBI_EXT_IPI_SEND_IPI))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (hbase != -1UL) {
+			if (tmp->vcpu_id < hbase)
+				continue;
+			if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
+				continue;
+		}
+		ret = kvm_riscv_vcpu_set_interrupt(tmp, IRQ_VS_SOFT);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi = {
+	.extid_start = SBI_EXT_IPI,
+	.extid_end = SBI_EXT_IPI,
+	.handler = kvm_sbi_ext_ipi_handler,
+};
+
+static int kvm_sbi_ext_rfence_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				      unsigned long *out_val,
+				      struct kvm_cpu_trap *utrap, bool *exit)
+{
+	int i, ret = 0;
+	struct cpumask cm, hm;
+	struct kvm_vcpu *tmp;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long hmask = cp->a0;
+	unsigned long hbase = cp->a1;
+	unsigned long funcid = cp->a6;
+
+	if (!cp)
+		return -EINVAL;
+
+	cpumask_clear(&cm);
+	cpumask_clear(&hm);
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+		if (hbase != -1UL) {
+			if (tmp->vcpu_id < hbase)
+				continue;
+			if (!(hmask & (1UL << (tmp->vcpu_id - hbase))))
+				continue;
+		}
+		if (tmp->cpu < 0)
+			continue;
+		cpumask_set_cpu(tmp->cpu, &cm);
+	}
+
+	riscv_cpuid_to_hartid_mask(&cm, &hm);
+
+	switch (funcid) {
+	case SBI_EXT_RFENCE_REMOTE_FENCE_I:
+		ret = sbi_remote_fence_i(cpumask_bits(&hm));
+		break;
+	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
+		ret = sbi_remote_hfence_vvma(cpumask_bits(&hm), cp->a2, cp->a3);
+		break;
+	case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
+		ret = sbi_remote_hfence_vvma_asid(cpumask_bits(&hm), cp->a2,
+						  cp->a3, cp->a4);
+		break;
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA:
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_GVMA_VMID:
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA:
+	case SBI_EXT_RFENCE_REMOTE_HFENCE_VVMA_ASID:
+	/* TODO: implement for nested hypervisor case */
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
+	.extid_start = SBI_EXT_RFENCE,
+	.extid_end = SBI_EXT_RFENCE,
+	.handler = kvm_sbi_ext_rfence_handler,
+};
-- 
2.31.1

