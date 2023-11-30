Return-Path: <kvm+bounces-2891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D3D7FEDE5
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 12:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06B661C20F21
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 11:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3778E3D386;
	Thu, 30 Nov 2023 11:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B8221709;
	Thu, 30 Nov 2023 03:31:03 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8Cxrut1cmhl8+c9AA--.54787S3;
	Thu, 30 Nov 2023 19:31:01 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxG9xycmhlNblQAA--.47327S3;
	Thu, 30 Nov 2023 19:31:00 +0800 (CST)
From: Tianrui Zhao <zhaotianrui@loongson.cn>
To: Shuah Khan <shuah@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Peter Xu <peterx@redhat.com>,
	Vipin Sharma <vipinsh@google.com>,
	maobibo@loongson.cn,
	zhaotianrui@loongson.cn
Subject: [PATCH v5 1/4] KVM: selftests: Add KVM selftests header files for LoongArch
Date: Thu, 30 Nov 2023 19:18:01 +0800
Message-Id: <20231130111804.2227570-2-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
References: <20231130111804.2227570-1-zhaotianrui@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxG9xycmhlNblQAA--.47327S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Add KVM selftests header files for LoongArch, including processor.h
and kvm_util_base.h. Those mainly contain LoongArch CSR register defines
and page table information. And change DEFAULT_GUEST_TEST_MEM base addr
for LoongArch.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 .../selftests/kvm/include/kvm_util_base.h     |   5 +
 .../kvm/include/loongarch/processor.h         | 133 ++++++++++++++++++
 .../testing/selftests/kvm/include/memstress.h |   2 +
 3 files changed, 140 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/loongarch/processor.h

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3c..97f8b24741b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -218,6 +218,11 @@ extern enum vm_guest_mode vm_mode_default;
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 8)
 
+#elif defined(__loongarch__)
+#define VM_MODE_DEFAULT			VM_MODE_P36V47_16K
+#define MIN_PAGE_SHIFT			14U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
 #endif
 
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
diff --git a/tools/testing/selftests/kvm/include/loongarch/processor.h b/tools/testing/selftests/kvm/include/loongarch/processor.h
new file mode 100644
index 00000000000..cea6b284131
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/loongarch/processor.h
@@ -0,0 +1,133 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef SELFTEST_KVM_PROCESSOR_H
+#define SELFTEST_KVM_PROCESSOR_H
+
+#define _PAGE_VALID_SHIFT	0
+#define _PAGE_DIRTY_SHIFT	1
+#define _PAGE_PLV_SHIFT		2  /* 2~3, two bits */
+#define _CACHE_SHIFT		4  /* 4~5, two bits */
+#define _PAGE_PRESENT_SHIFT	7
+#define _PAGE_WRITE_SHIFT	8
+
+#define PLV_KERN		0
+#define PLV_USER		3
+#define PLV_MASK		0x3
+
+#define _PAGE_VALID		(0x1UL << _PAGE_VALID_SHIFT)
+#define _PAGE_PRESENT		(0x1UL << _PAGE_PRESENT_SHIFT)
+#define _PAGE_WRITE		(0x1UL << _PAGE_WRITE_SHIFT)
+#define _PAGE_DIRTY		(0x1UL << _PAGE_DIRTY_SHIFT)
+#define _PAGE_USER		(PLV_USER << _PAGE_PLV_SHIFT)
+#define __READABLE		(_PAGE_VALID)
+#define __WRITEABLE		(_PAGE_DIRTY | _PAGE_WRITE)
+#define _CACHE_CC		(0x1UL << _CACHE_SHIFT) /* Coherent Cached */
+
+/* general registers */
+#define zero	$r0
+#define ra	$r1
+#define tp	$r2
+#define sp	$r3
+#define a0	$r4
+#define a1	$r5
+#define a2	$r6
+#define a3	$r7
+#define a4	$r8
+#define a5	$r9
+#define a6	$r10
+#define a7	$r11
+#define t0	$r12
+#define t1	$r13
+#define t2	$r14
+#define t3	$r15
+#define t4	$r16
+#define t5	$r17
+#define t6	$r18
+#define t7	$r19
+#define t8	$r20
+#define u0	$r21
+#define fp	$r22
+#define s0	$r23
+#define s1	$r24
+#define s2	$r25
+#define s3	$r26
+#define s4	$r27
+#define s5	$r28
+#define s6	$r29
+#define s7	$r30
+#define s8	$r31
+
+#define PS_4K				0x0000000c
+#define PS_8K				0x0000000d
+#define PS_16K				0x0000000e
+#define PS_DEFAULT_SIZE			PS_16K
+
+/* Basic CSR registers */
+#define LOONGARCH_CSR_CRMD		0x0 /* Current mode info */
+#define CSR_CRMD_PG_SHIFT		4
+#define CSR_CRMD_PG			(0x1UL << CSR_CRMD_PG_SHIFT)
+#define CSR_CRMD_IE_SHIFT		2
+#define CSR_CRMD_IE			(0x1UL << CSR_CRMD_IE_SHIFT)
+#define CSR_CRMD_PLV_SHIFT		0
+#define CSR_CRMD_PLV_WIDTH		2
+#define CSR_CRMD_PLV			(0x3UL << CSR_CRMD_PLV_SHIFT)
+#define PLV_MASK			0x3
+
+#define LOONGARCH_CSR_PRMD		0x1
+#define LOONGARCH_CSR_EUEN		0x2
+#define LOONGARCH_CSR_ECFG		0x4
+#define LOONGARCH_CSR_ESTAT		0x5 /* Exception status */
+#define LOONGARCH_CSR_ERA		0x6 /* ERA */
+#define LOONGARCH_CSR_BADV		0x7 /* Bad virtual address */
+#define LOONGARCH_CSR_EENTRY		0xc
+#define LOONGARCH_CSR_TLBIDX		0x10 /* TLB Index, EHINV, PageSize, NP */
+#define CSR_TLBIDX_PS_SHIFT		24
+#define CSR_TLBIDX_PS_WIDTH		6
+#define CSR_TLBIDX_PS			(0x3fUL << CSR_TLBIDX_PS_SHIFT)
+#define CSR_TLBIDX_SIZEM		0x3f000000
+#define CSR_TLBIDX_SIZE			CSR_TLBIDX_PS_SHIFT
+
+#define LOONGARCH_CSR_ASID		0x18 /* ASID */
+/* Page table base address when VA[VALEN-1] = 0 */
+#define LOONGARCH_CSR_PGDL		0x19
+/* Page table base address when VA[VALEN-1] = 1 */
+#define LOONGARCH_CSR_PGDH		0x1a
+/* Page table base */
+#define LOONGARCH_CSR_PGD		0x1b
+#define LOONGARCH_CSR_PWCTL0		0x1c
+#define LOONGARCH_CSR_PWCTL1		0x1d
+#define LOONGARCH_CSR_STLBPGSIZE	0x1e
+#define LOONGARCH_CSR_CPUID		0x20
+#define LOONGARCH_CSR_KS0		0x30
+#define LOONGARCH_CSR_KS1		0x31
+#define LOONGARCH_CSR_TMID		0x40
+#define LOONGARCH_CSR_TCFG		0x41
+#define LOONGARCH_CSR_TLBRENTRY		0x88 /* TLB refill exception entry */
+/* KSave for TLB refill exception */
+#define LOONGARCH_CSR_TLBRSAVE		0x8b
+#define LOONGARCH_CSR_TLBREHI		0x8e
+#define CSR_TLBREHI_PS_SHIFT		0
+#define CSR_TLBREHI_PS			(0x3fUL << CSR_TLBREHI_PS_SHIFT)
+
+#define DEFAULT_LOONARCH64_STACK_MIN		0x4000
+#define DEFAULT_LOONARCH64_PAGE_TABLE_MIN	0x4000
+#define EXREGS_GPRS				(32)
+
+#ifndef __ASSEMBLER__
+struct ex_regs {
+	unsigned long regs[EXREGS_GPRS];
+	unsigned long pc;
+	unsigned long estat;
+	unsigned long badv;
+};
+
+extern void handle_tlb_refill(void);
+extern void handle_exception(void);
+#endif
+
+#define PC_OFFSET_EXREGS		((EXREGS_GPRS + 0) * 8)
+#define ESTAT_OFFSET_EXREGS		((EXREGS_GPRS + 1) * 8)
+#define BADV_OFFSET_EXREGS		((EXREGS_GPRS + 2) * 8)
+#define EXREGS_SIZE			((EXREGS_GPRS + 3) * 8)
+
+#endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index ce4e603050e..5bcdaf2efab 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -13,7 +13,9 @@
 #include "kvm_util.h"
 
 /* Default guest test virtual memory offset */
+#ifndef DEFAULT_GUEST_TEST_MEM
 #define DEFAULT_GUEST_TEST_MEM		0xc0000000
+#endif
 
 #define DEFAULT_PER_VCPU_MEM_SIZE	(1 << 30) /* 1G */
 
-- 
2.39.1


