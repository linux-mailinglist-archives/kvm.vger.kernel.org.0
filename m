Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072724262E2
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 05:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242336AbhJHDWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 23:22:53 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10090 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbhJHDWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 23:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633663245; x=1665199245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q2+/KxAgiVhBN81Q/zvhVdRkI2k27noHgHBsYrjATgc=;
  b=Ae2aPRAz6upjk8n9b//7SejOldoPs/L18UNrwRvRJ8K190QNAXza24Gq
   xhqF4MwMyanNa2JZvbGdnVRiEbc6UwYRUnyq2+lVfyKhlzmiaPN1D7Oxe
   hiQzdSw1Ak2VL+PgBHnj5Y1AmFF7ctlLwoqF2eB0Oeu5YthFsKEXC0hnZ
   HsVZhXj6Mto1F4OFzPOtSUlx4V9+As2/izW9FHXKprZjwI7NpXrlRNoco
   JU1Hteqi8l3iN8CJx1yoqtKdpvJDkfW+1+Xi2+ElIrzRY2t98T8Xnuqwm
   DqSHX3Fuw5BCP/D1iIRCVZBfs3VPOzv1h3cFz+MHQEu3qvCR4nF38E2Dh
   A==;
X-IronPort-AV: E=Sophos;i="5.85,356,1624291200"; 
   d="scan'208";a="182972385"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2021 11:20:40 +0800
IronPort-SDR: 8P0adjZgvj01tMPTaFm4sbNtpYK1WCMcC2YGKvMP12OmazmQSi3ew7kV0zxMKQ0l/ZF2Gz02+m
 2Rv6mHIGbQI0SIkvzXvphphZ9wlJosAG47QiDCpXLflK9IH0nLec/4fCodM6QUyBEPcfHvop1Q
 N2UOVhgO7ayTyEHCUnOPt6eJBQ02PuRaBMlh83ZsgmxW1nZm6b4jwd8NbOJFMNYjYyGLM4h6nF
 e/RR7Ldw3VRw7fURZ+DVKYa8zrUXBSTSsVfOR2qz+VyJZTDcSfQL+aK7HF8Y/QGBoIRKVPmbuT
 NNbrtRvpGjcKC33Q5LOXTdJw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 19:56:33 -0700
IronPort-SDR: lPKmT8U9MpZ9PIq4SIvifo8WeYBM7DFJfLNzwIjkXOYsr7/+hDUag/wjgw2d1uP747ErbXFNLD
 oaCkg6ElE51apt6QPaN//SenlTJFNA6E768cvhCYyBcfOVb5Ezl3taAZHotvSZK93FsuZ2CAaO
 sqiXuZPayZwZRICRSkv6mDlZbj+LPlmFsG6gTO6Rfx6uw6YpU6g5aDnL8TAXVnEjgcnamL2/RV
 ARHcM5/Bkzhqg7fUqM3FgBjU90l6xkDw+OiZWhJYZHoOZzUuybzoufrYxjoVrWM34+WeLZktgT
 Lwg=
WDCIronportException: Internal
Received: from unknown (HELO hulk.wdc.com) ([10.225.167.125])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Oct 2021 20:20:41 -0700
From:   Atish Patra <atish.patra@wdc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atish.patra@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH v3 4/5] RISC-V: Add v0.1 replacement SBI extensions defined in v02
Date:   Thu,  7 Oct 2021 20:20:35 -0700
Message-Id: <20211008032036.2201971-5-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008032036.2201971-1-atish.patra@wdc.com>
References: <20211008032036.2201971-1-atish.patra@wdc.com>
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
index aaf02efafc0f..272428459a99 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -24,4 +24,5 @@ kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_legacy.o
 kvm-y += vcpu_sbi_base.o
+kvm-y += vcpu_sbi_replace.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 5533ffc25ed0..dadee5e61a46 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -40,9 +40,16 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_legacy = {
 };
 #endif
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
+
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_legacy,
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

