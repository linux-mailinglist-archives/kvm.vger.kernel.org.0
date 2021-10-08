Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BCB4262DD
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 05:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbhJHDWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 23:22:44 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:10101 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbhJHDWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Oct 2021 23:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1633663245; x=1665199245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EpLJPbtsFvyJ4JlBOPqbNVw1g1nmngX2jDHxjNeMYq8=;
  b=P35aBDNpCPjEvW5i13kHOm1cqemyjY5LqcUPQbYiY1Ejj3GeMhGYi1sP
   D8oBP9S+wzz79LHpBSqtvnl/fmXGzR9Tk7DKKRhPmCb9B3vNk4VITxoKu
   x34SwF9vCs4/c/J9FPpBgc3lWJmpm03Lnfv3v3yAGBYbdX1NzevmOc/Z5
   MbJxBUtHeHNtEYyF0qwkDlP8gh54YyGCQ/Ic58YLdajdb3oWAxAJVMt74
   KigXNt7813yurh2hW1+XJ3ucdEVofhVgrafxHoQufxmQHyEGP88ujt2g8
   1NHbdGaUyPsGrJTFHph7jvEjNCTWYFEPk6EcFsrHxnNHT9D1C7q4D5WEE
   w==;
X-IronPort-AV: E=Sophos;i="5.85,356,1624291200"; 
   d="scan'208";a="182972383"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Oct 2021 11:20:40 +0800
IronPort-SDR: S/d1qJdx5puLEIXM+T//T/FBSQw2GsblFwmbOYmuFK/ZSc+SeCoex7HczR5AT4q4CbD0Gm1Ep2
 Pr0PG+urQaTirvfpimZPewR/dumZjsF40aRet9/lIiBqVa7cPux2MUsnl1w0FchRGzXT2Rbrmu
 2+Qw05aJfaRQXKuFgL+KFqJhz+H6gDI7pPUw9JXsTdCYo4p07zh+qenFVox3hiBRr2J5vCwbrN
 DGF0WIg7RXqBjPB2lHX207CYini7GwvmnALbWeX1hLC6NSYAA5Cv+4H7b7Ue3QhQWiNtl9twFI
 IhEvsnCH9NajZ8380cLZwgma
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 19:56:33 -0700
IronPort-SDR: QLH0vuqzIewwJanN1B8+2WStqn+4r+n6dhdXSHpI3cuFoytp12yeo+/86TaYN75mmCuD/USsgb
 Yao1TxNP1TWX7e5/aZWHNv5OsUwTprnton/b8QsxWi6MegaFwATq6lQJOSIGIHYeYNdrW0tR5l
 PppwYoprtMbinRTyNZftfbxzH16Fqp0oVeQ8GhN8jXg40IsTDeKR0A8dXpXI4jyD8pZWRG0lmR
 Uy/VmDSdZpBCbbZYktaGo4IlpJPU0d8I+7cH40vf+3PQdB3Vf0GRMsy9Iz57HW+p9tgLTArvrp
 Ysg=
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
Subject: [PATCH v3 3/5] RISC-V: Add SBI v0.2 base extension
Date:   Thu,  7 Oct 2021 20:20:34 -0700
Message-Id: <20211008032036.2201971-4-atish.patra@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008032036.2201971-1-atish.patra@wdc.com>
References: <20211008032036.2201971-1-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SBI v0.2 base extension defined to allow backward compatibility and
probing of future extensions. This is also the only mandatory SBI
extension that must be implemented by SBI implementors.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 +
 arch/riscv/include/asm/sbi.h          |  8 +++
 arch/riscv/kvm/Makefile               |  1 +
 arch/riscv/kvm/vcpu_sbi.c             |  3 +-
 arch/riscv/kvm/vcpu_sbi_base.c        | 73 +++++++++++++++++++++++++++
 5 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_base.c

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 704151969ceb..76e4e17a3e00 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -9,6 +9,8 @@
 #ifndef __RISCV_KVM_VCPU_SBI_H__
 #define __RISCV_KVM_VCPU_SBI_H__
 
+#define KVM_SBI_IMPID 3
+
 #define KVM_SBI_VERSION_MAJOR 0
 #define KVM_SBI_VERSION_MINOR 2
 
diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 289621da4a2a..20e049857e98 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -28,6 +28,14 @@ enum sbi_ext_id {
 	SBI_EXT_RFENCE = 0x52464E43,
 	SBI_EXT_HSM = 0x48534D,
 	SBI_EXT_SRST = 0x53525354,
+
+	/* Experimentals extensions must lie within this range */
+	SBI_EXT_EXPERIMENTAL_START = 0x0800000,
+	SBI_EXT_EXPERIMENTAL_END = 0x08FFFFFF,
+
+	/* Vendor extensions must lie within this range */
+	SBI_EXT_VENDOR_START = 0x09000000,
+	SBI_EXT_VENDOR_END = 0x09FFFFFF,
 };
 
 enum sbi_ext_base_fid {
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 53cbecc44c4c..aaf02efafc0f 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -23,4 +23,5 @@ kvm-y += vcpu_exit.o
 kvm-y += vcpu_switch.o
 kvm-y += vcpu_sbi.o
 kvm-$(CONFIG_RISCV_SBI_V01) += vcpu_sbi_legacy.o
+kvm-y += vcpu_sbi_base.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index e51de3e4526a..5533ffc25ed0 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -39,9 +39,10 @@ static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_legacy = {
 	.handler = NULL,
 };
 #endif
-
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
 static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_legacy,
+	&vcpu_sbi_ext_base,
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
new file mode 100644
index 000000000000..1aeda3e10e7c
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -0,0 +1,73 @@
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
+static int kvm_sbi_ext_base_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
+				    unsigned long *out_val,
+				    struct kvm_cpu_trap *trap, bool *exit)
+{
+	int ret = 0;
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	struct sbiret ecall_ret;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a6) {
+	case SBI_EXT_BASE_GET_SPEC_VERSION:
+		*out_val = (KVM_SBI_VERSION_MAJOR <<
+			    SBI_SPEC_VERSION_MAJOR_SHIFT) |
+			    KVM_SBI_VERSION_MINOR;
+		break;
+	case SBI_EXT_BASE_GET_IMP_ID:
+		*out_val = KVM_SBI_IMPID;
+		break;
+	case SBI_EXT_BASE_GET_IMP_VERSION:
+		*out_val = 0;
+		break;
+	case SBI_EXT_BASE_PROBE_EXT:
+		*out_val = kvm_vcpu_sbi_find_ext(cp->a0) ? 1 : 0;
+		if ((!*out_val) &&
+		    ((cp->a0 >= SBI_EXT_EXPERIMENTAL_START &&
+		     cp->a0 <= SBI_EXT_EXPERIMENTAL_END) ||
+		    ((cp->a0 >= SBI_EXT_VENDOR_START &&
+		     cp->a0 <= SBI_EXT_VENDOR_END)))) {
+		/* For experimental/vendor extensions forward to the userspace*/
+			kvm_riscv_vcpu_sbi_forward(vcpu, run);
+			*exit = true;
+		}
+		break;
+	case SBI_EXT_BASE_GET_MVENDORID:
+	case SBI_EXT_BASE_GET_MARCHID:
+	case SBI_EXT_BASE_GET_MIMPID:
+		ecall_ret = sbi_ecall(SBI_EXT_BASE, cp->a6, 0, 0, 0, 0, 0, 0);
+		if (!ecall_ret.error)
+			*out_val = ecall_ret.value;
+		/*TODO: We are unnecessarily converting the error twice */
+		ret = sbi_err_map_linux_errno(ecall_ret.error);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
+	.extid_start = SBI_EXT_BASE,
+	.extid_end = SBI_EXT_BASE,
+	.handler = kvm_sbi_ext_base_handler,
+};
-- 
2.31.1

