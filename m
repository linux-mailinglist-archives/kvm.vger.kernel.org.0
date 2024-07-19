Return-Path: <kvm+bounces-21947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A7E937A75
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:12:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 02B781F21464
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53765149001;
	Fri, 19 Jul 2024 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GTkeRxmt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFD3148837
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721405395; cv=none; b=Li4VgAyjBAtbyS9ClykpzEKClPtFLrp+MowULjZv1MIhhTzSqzsUQEVXZFeLRZI28cdGtg12DI79A33PsOYCmH9g//59P/VFhwE4ThtnHHwOYVQcet0NfwNRlOznrQ597TViNz3OXl0M8aTtH26K04L99bsjCI4iWtRmCSV3TyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721405395; c=relaxed/simple;
	bh=rLr/7TLkY09nUGqJWk909E3zipSxSCjGAYCNHnraZs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e68Fmt/IztQR78F3fc2syTSo03KJQR/5MJL8aVGxLSNvDTq70gGQNoq/BsiOtqb0tz6fOnGY4tHcWdqueA//DycOAfSxHnpnMVzuB3U2Off/5/ECnyuDKc50aSYMSMamgtcnZY23LnOrmhZNZ7uEXwsq/WsRav7cYU8ghnvvLPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GTkeRxmt; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1fc65329979so15050285ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1721405393; x=1722010193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNRjpl9AWOu5Y/06ZXovZLxYd73eZ2CcfqE7LV9a3jU=;
        b=GTkeRxmtzvCvOfa2ZQRhAfzT2sWiGKUzKrqVTX00exHsmzKtmSdgPUPginNrEuptzg
         itGnLtZkHN7l0tRk9T1SGX0Gmbb5MxzTOpB6YqgOHG3EV48bS612+628/rJWS1C35CFd
         icO+s92lxDeNdOwpdjygQaIaPekSXtziEzUpkcHyo2Yw5V/OWbkxnISUm1JBUu4JA//0
         750I7oJ/GnfcsufgD5Xmq9d2WJbjCNwYIMc414uGADJ5GRX//AuZP8LLqy2yqv5FwUaB
         p7rr5JacczT64wfAGOA5stkadubpfTgKlDEW4XZgXfBNfuWMcVjhzrnyzNax+kHqDGI5
         gRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721405393; x=1722010193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pNRjpl9AWOu5Y/06ZXovZLxYd73eZ2CcfqE7LV9a3jU=;
        b=DLbPvm7lQuYDIrIKt7LL3wupY50NFy23sCD62blnajL0Mo7NorrAYEI9ThDz2QsOil
         5pPr0xaLy1VzzHboxnD1eB8dRkGMK3o43Tj+FgeunUXNtnxJQVAGqZ9BIu883qCDFhwt
         WVDyvKCkZYrUqMk70xgUsUnFwTUBnJsZNh4av0rJKUicj5wz3sdv1HkZgqoP9U6cSQPi
         zfXVr04lfBXo5nf5AdVea0E9/I7UknGj0PIwpZslXTjMAIIGlA11S3BU9N2dzDb26Cou
         MWcUan3kjNan6lIEgzlSZCBXV0U6DuR2c75FjQRctCMBUTTFLac4+qaDwIzhLsQX31X4
         5AfA==
X-Forwarded-Encrypted: i=1; AJvYcCUKl+Wp09kfl54gG7q8lb+UkzlgNagVFaBfZrrWdZSNrrT3dQLOG8GeLWoixtEmQRgwszN43hBgPcHSFV4CznAeLCr7
X-Gm-Message-State: AOJu0YzAbMVTQSDC1QvOCQLndz2ZkU5fMBnPm0eLRQHIXJNpFVXSz3Gg
	MNJdX28nkQZUfeoaWhYPiKElxNtyrsItZX8edE50eAmv9mqN3nFkvykBAOC/MKo=
X-Google-Smtp-Source: AGHT+IGsSBffRZbxlhKIbUi3MquECwG/00bsx5PoG3YEzYyosi1BS/71TDciBJgkl9GHm7KPMmnNHw==
X-Received: by 2002:a17:902:e547:b0:1fa:ab25:f625 with SMTP id d9443c01a7336-1fd74585690mr3006245ad.38.1721405392800;
        Fri, 19 Jul 2024 09:09:52 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.236])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd6f28f518sm6632615ad.69.2024.07.19.09.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 09:09:52 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>
Cc: Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 08/13] RISC-V: KVM: Add common nested acceleration support
Date: Fri, 19 Jul 2024 21:39:08 +0530
Message-Id: <20240719160913.342027-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240719160913.342027-1-apatel@ventanamicro.com>
References: <20240719160913.342027-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a common nested acceleration support which will be shared by
all parts of KVM RISC-V. This nested acceleration support detects
and enables SBI NACL extension usage based on static keys which
ensures minimum impact on the non-nested scenario.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_nacl.h | 205 ++++++++++++++++++++++++++++++
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/main.c             |  53 +++++++-
 arch/riscv/kvm/nacl.c             | 152 ++++++++++++++++++++++
 4 files changed, 409 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_nacl.h
 create mode 100644 arch/riscv/kvm/nacl.c

diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/kvm_nacl.h
new file mode 100644
index 000000000000..a704e8000a58
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_nacl.h
@@ -0,0 +1,205 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024 Ventana Micro Systems Inc.
+ */
+
+#ifndef __KVM_NACL_H
+#define __KVM_NACL_H
+
+#include <linux/jump_label.h>
+#include <linux/percpu.h>
+#include <asm/byteorder.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
+#define kvm_riscv_nacl_available() \
+	static_branch_unlikely(&kvm_riscv_nacl_available)
+
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_csr_available);
+#define kvm_riscv_nacl_sync_csr_available() \
+	static_branch_unlikely(&kvm_riscv_nacl_sync_csr_available)
+
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_hfence_available);
+#define kvm_riscv_nacl_sync_hfence_available() \
+	static_branch_unlikely(&kvm_riscv_nacl_sync_hfence_available)
+
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_sret_available);
+#define kvm_riscv_nacl_sync_sret_available() \
+	static_branch_unlikely(&kvm_riscv_nacl_sync_sret_available)
+
+DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_autoswap_csr_available);
+#define kvm_riscv_nacl_autoswap_csr_available() \
+	static_branch_unlikely(&kvm_riscv_nacl_autoswap_csr_available)
+
+struct kvm_riscv_nacl {
+	void *shmem;
+	phys_addr_t shmem_phys;
+};
+DECLARE_PER_CPU(struct kvm_riscv_nacl, kvm_riscv_nacl);
+
+void __kvm_riscv_nacl_hfence(void *shmem,
+			     unsigned long control,
+			     unsigned long page_num,
+			     unsigned long page_count);
+
+int kvm_riscv_nacl_enable(void);
+
+void kvm_riscv_nacl_disable(void);
+
+void kvm_riscv_nacl_exit(void);
+
+int kvm_riscv_nacl_init(void);
+
+#ifdef CONFIG_32BIT
+#define lelong_to_cpu(__x)	le32_to_cpu(__x)
+#define cpu_to_lelong(__x)	cpu_to_le32(__x)
+#else
+#define lelong_to_cpu(__x)	le64_to_cpu(__x)
+#define cpu_to_lelong(__x)	cpu_to_le64(__x)
+#endif
+
+#define nacl_shmem()							\
+	this_cpu_ptr(&kvm_riscv_nacl)->shmem
+#define nacl_shmem_fast()						\
+	(kvm_riscv_nacl_available() ? nacl_shmem() : NULL)
+
+#define nacl_sync_hfence(__e)						\
+	sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_HFENCE,		\
+		  (__e), 0, 0, 0, 0, 0)
+
+#define nacl_hfence_mkconfig(__type, __order, __vmid, __asid)		\
+({									\
+	unsigned long __c = SBI_NACL_SHMEM_HFENCE_CONFIG_PEND;		\
+	__c |= ((__type) & SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_MASK)	\
+		<< SBI_NACL_SHMEM_HFENCE_CONFIG_TYPE_SHIFT;		\
+	__c |= (((__order) - SBI_NACL_SHMEM_HFENCE_ORDER_BASE) &	\
+		SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_MASK)		\
+		<< SBI_NACL_SHMEM_HFENCE_CONFIG_ORDER_SHIFT;		\
+	__c |= ((__vmid) & SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_MASK)	\
+		<< SBI_NACL_SHMEM_HFENCE_CONFIG_VMID_SHIFT;		\
+	__c |= ((__asid) & SBI_NACL_SHMEM_HFENCE_CONFIG_ASID_MASK);	\
+	__c;								\
+})
+
+#define nacl_hfence_mkpnum(__order, __addr)				\
+	((__addr) >> (__order))
+
+#define nacl_hfence_mkpcount(__order, __size)				\
+	((__size) >> (__order))
+
+#define nacl_hfence_gvma(__shmem, __gpa, __gpsz, __order)		\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA,		\
+			   __order, 0, 0),				\
+	nacl_hfence_mkpnum(__order, __gpa),				\
+	nacl_hfence_mkpcount(__order, __gpsz))
+
+#define nacl_hfence_gvma_all(__shmem)					\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_ALL,	\
+			   0, 0, 0), 0, 0)
+
+#define nacl_hfence_gvma_vmid(__shmem, __vmid, __gpa, __gpsz, __order)	\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID,	\
+			   __order, __vmid, 0),				\
+	nacl_hfence_mkpnum(__order, __gpa),				\
+	nacl_hfence_mkpcount(__order, __gpsz))
+
+#define nacl_hfence_gvma_vmid_all(__shmem, __vmid)			\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_GVMA_VMID_ALL,	\
+			   0, __vmid, 0), 0, 0)
+
+#define nacl_hfence_vvma(__shmem, __vmid, __gva, __gvsz, __order)	\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA,		\
+			   __order, __vmid, 0),				\
+	nacl_hfence_mkpnum(__order, __gva),				\
+	nacl_hfence_mkpcount(__order, __gvsz))
+
+#define nacl_hfence_vvma_all(__shmem, __vmid)				\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ALL,	\
+			   0, __vmid, 0), 0, 0)
+
+#define nacl_hfence_vvma_asid(__shmem, __vmid, __asid, __gva, __gvsz, __order)\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID,	\
+			   __order, __vmid, __asid),			\
+	nacl_hfence_mkpnum(__order, __gva),				\
+	nacl_hfence_mkpcount(__order, __gvsz))
+
+#define nacl_hfence_vvma_asid_all(__shmem, __vmid, __asid)		\
+__kvm_riscv_nacl_hfence(__shmem,					\
+	nacl_hfence_mkconfig(SBI_NACL_SHMEM_HFENCE_TYPE_VVMA_ASID_ALL,	\
+			   0, __vmid, __asid), 0, 0)
+
+#define nacl_csr_read(__shmem, __csr)					\
+({									\
+	unsigned long *__a = (__shmem) + SBI_NACL_SHMEM_CSR_OFFSET;	\
+	lelong_to_cpu(__a[SBI_NACL_SHMEM_CSR_INDEX(__csr)]);		\
+})
+
+#define nacl_csr_write(__shmem, __csr, __val)				\
+do {									\
+	void *__s = (__shmem);						\
+	unsigned int __i = SBI_NACL_SHMEM_CSR_INDEX(__csr);		\
+	unsigned long *__a = (__s) + SBI_NACL_SHMEM_CSR_OFFSET;		\
+	u8 *__b = (__s) + SBI_NACL_SHMEM_DBITMAP_OFFSET;		\
+	__a[__i] = cpu_to_lelong(__val);				\
+	__b[__i >> 3] |= 1U << (__i & 0x7);				\
+} while (0)
+
+#define nacl_csr_swap(__shmem, __csr, __val)				\
+({									\
+	void *__s = (__shmem);						\
+	unsigned int __i = SBI_NACL_SHMEM_CSR_INDEX(__csr);		\
+	unsigned long *__a = (__s) + SBI_NACL_SHMEM_CSR_OFFSET;		\
+	u8 *__b = (__s) + SBI_NACL_SHMEM_DBITMAP_OFFSET;		\
+	unsigned long __r = lelong_to_cpu(__a[__i]);			\
+	__a[__i] = cpu_to_lelong(__val);				\
+	__b[__i >> 3] |= 1U << (__i & 0x7);				\
+	__r;								\
+})
+
+#define nacl_sync_csr(__csr)						\
+	sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SYNC_CSR,			\
+		  (__csr), 0, 0, 0, 0, 0)
+
+#define ncsr_read(__csr)						\
+({									\
+	unsigned long __r;						\
+	if (kvm_riscv_nacl_available())					\
+		__r = nacl_csr_read(nacl_shmem(), __csr);		\
+	else								\
+		__r = csr_read(__csr);					\
+	__r;								\
+})
+
+#define ncsr_write(__csr, __val)					\
+do {									\
+	if (kvm_riscv_nacl_sync_csr_available())			\
+		nacl_csr_write(nacl_shmem(), __csr, __val);		\
+	else								\
+		csr_write(__csr, __val);				\
+} while (0)
+
+#define ncsr_swap(__csr, __val)						\
+({									\
+	unsigned long __r;						\
+	if (kvm_riscv_nacl_sync_csr_available())			\
+		__r = nacl_csr_swap(nacl_shmem(), __csr, __val);	\
+	else								\
+		__r = csr_swap(__csr, __val);				\
+	__r;								\
+})
+
+#define nsync_csr(__csr)						\
+do {									\
+	if (kvm_riscv_nacl_sync_csr_available())			\
+		nacl_sync_csr(__csr);					\
+} while (0)
+
+#endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index c1eac0d093de..0fb1840c3e0a 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -16,6 +16,7 @@ kvm-y += aia_device.o
 kvm-y += aia_imsic.o
 kvm-y += main.o
 kvm-y += mmu.o
+kvm-y += nacl.o
 kvm-y += tlb.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index bab2ec34cd87..fd78f40bbb04 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -10,8 +10,8 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/kvm_host.h>
-#include <asm/csr.h>
 #include <asm/cpufeature.h>
+#include <asm/kvm_nacl.h>
 #include <asm/sbi.h>
 
 long kvm_arch_dev_ioctl(struct file *filp,
@@ -22,6 +22,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
 
 int kvm_arch_hardware_enable(void)
 {
+	int rc;
+
+	rc = kvm_riscv_nacl_enable();
+	if (rc)
+		return rc;
+
 	csr_write(CSR_HEDELEG, KVM_HEDELEG_DEFAULT);
 	csr_write(CSR_HIDELEG, KVM_HIDELEG_DEFAULT);
 
@@ -49,11 +55,14 @@ void kvm_arch_hardware_disable(void)
 	csr_write(CSR_HVIP, 0);
 	csr_write(CSR_HEDELEG, 0);
 	csr_write(CSR_HIDELEG, 0);
+
+	kvm_riscv_nacl_disable();
 }
 
 static int __init riscv_kvm_init(void)
 {
 	int rc;
+	char slist[64];
 	const char *str;
 
 	if (!riscv_isa_extension_available(NULL, h)) {
@@ -71,16 +80,53 @@ static int __init riscv_kvm_init(void)
 		return -ENODEV;
 	}
 
+	rc = kvm_riscv_nacl_init();
+	if (rc && rc != -ENODEV)
+		return rc;
+
 	kvm_riscv_gstage_mode_detect();
 
 	kvm_riscv_gstage_vmid_detect();
 
 	rc = kvm_riscv_aia_init();
-	if (rc && rc != -ENODEV)
+	if (rc && rc != -ENODEV) {
+		kvm_riscv_nacl_exit();
 		return rc;
+	}
 
 	kvm_info("hypervisor extension available\n");
 
+	if (kvm_riscv_nacl_available()) {
+		rc = 0;
+		slist[0] = '\0';
+		if (kvm_riscv_nacl_sync_csr_available()) {
+			if (rc)
+				strcat(slist, ", ");
+			strcat(slist, "sync_csr");
+			rc++;
+		}
+		if (kvm_riscv_nacl_sync_hfence_available()) {
+			if (rc)
+				strcat(slist, ", ");
+			strcat(slist, "sync_hfence");
+			rc++;
+		}
+		if (kvm_riscv_nacl_sync_sret_available()) {
+			if (rc)
+				strcat(slist, ", ");
+			strcat(slist, "sync_sret");
+			rc++;
+		}
+		if (kvm_riscv_nacl_autoswap_csr_available()) {
+			if (rc)
+				strcat(slist, ", ");
+			strcat(slist, "autoswap_csr");
+			rc++;
+		}
+		kvm_info("using SBI nested acceleration with %s\n",
+			 (rc) ? slist : "no features");
+	}
+
 	switch (kvm_riscv_gstage_mode()) {
 	case HGATP_MODE_SV32X4:
 		str = "Sv32x4";
@@ -108,6 +154,7 @@ static int __init riscv_kvm_init(void)
 	rc = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
 	if (rc) {
 		kvm_riscv_aia_exit();
+		kvm_riscv_nacl_exit();
 		return rc;
 	}
 
@@ -119,6 +166,8 @@ static void __exit riscv_kvm_exit(void)
 {
 	kvm_riscv_aia_exit();
 
+	kvm_riscv_nacl_exit();
+
 	kvm_exit();
 }
 module_exit(riscv_kvm_exit);
diff --git a/arch/riscv/kvm/nacl.c b/arch/riscv/kvm/nacl.c
new file mode 100644
index 000000000000..08a95ad9ada2
--- /dev/null
+++ b/arch/riscv/kvm/nacl.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Ventana Micro Systems Inc.
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/vmalloc.h>
+#include <asm/kvm_nacl.h>
+
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_csr_available);
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_hfence_available);
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_sync_sret_available);
+DEFINE_STATIC_KEY_FALSE(kvm_riscv_nacl_autoswap_csr_available);
+DEFINE_PER_CPU(struct kvm_riscv_nacl, kvm_riscv_nacl);
+
+void __kvm_riscv_nacl_hfence(void *shmem,
+			     unsigned long control,
+			     unsigned long page_num,
+			     unsigned long page_count)
+{
+	int i, ent = -1, try_count = 5;
+	unsigned long *entp;
+
+again:
+	for (i = 0; i < SBI_NACL_SHMEM_HFENCE_ENTRY_MAX; i++) {
+		entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(i);
+		if (lelong_to_cpu(*entp) & SBI_NACL_SHMEM_HFENCE_CONFIG_PEND)
+			continue;
+
+		ent = i;
+		break;
+	}
+
+	if (ent < 0) {
+		if (try_count) {
+			nacl_sync_hfence(-1UL);
+			goto again;
+		} else {
+			pr_warn("KVM: No free entry in NACL shared memory\n");
+			return;
+		}
+	}
+
+	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_CONFIG(i);
+	*entp = cpu_to_lelong(control);
+	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_PNUM(i);
+	*entp = cpu_to_lelong(page_num);
+	entp = shmem + SBI_NACL_SHMEM_HFENCE_ENTRY_PCOUNT(i);
+	*entp = cpu_to_lelong(page_count);
+}
+
+int kvm_riscv_nacl_enable(void)
+{
+	int rc;
+	struct sbiret ret;
+	struct kvm_riscv_nacl *nacl;
+
+	if (!kvm_riscv_nacl_available())
+		return 0;
+	nacl = this_cpu_ptr(&kvm_riscv_nacl);
+
+	ret = sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SET_SHMEM,
+			nacl->shmem_phys, 0, 0, 0, 0, 0);
+	rc = sbi_err_map_linux_errno(ret.error);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+void kvm_riscv_nacl_disable(void)
+{
+	if (!kvm_riscv_nacl_available())
+		return;
+
+	sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_SET_SHMEM,
+		  SBI_SHMEM_DISABLE, SBI_SHMEM_DISABLE, 0, 0, 0, 0);
+}
+
+void kvm_riscv_nacl_exit(void)
+{
+	int cpu;
+	struct kvm_riscv_nacl *nacl;
+
+	if (!kvm_riscv_nacl_available())
+		return;
+
+	/* Allocate per-CPU shared memory */
+	for_each_possible_cpu(cpu) {
+		nacl = per_cpu_ptr(&kvm_riscv_nacl, cpu);
+		if (!nacl->shmem)
+			continue;
+
+		free_pages((unsigned long)nacl->shmem,
+			   get_order(SBI_NACL_SHMEM_SIZE));
+		nacl->shmem = NULL;
+		nacl->shmem_phys = 0;
+	}
+}
+
+static long nacl_probe_feature(long feature_id)
+{
+	struct sbiret ret;
+
+	if (!kvm_riscv_nacl_available())
+		return 0;
+
+	ret = sbi_ecall(SBI_EXT_NACL, SBI_EXT_NACL_PROBE_FEATURE,
+			feature_id, 0, 0, 0, 0, 0);
+	return ret.value;
+}
+
+int kvm_riscv_nacl_init(void)
+{
+	int cpu;
+	struct page *shmem_page;
+	struct kvm_riscv_nacl *nacl;
+
+	if (sbi_spec_version < sbi_mk_version(1, 0) ||
+	    sbi_probe_extension(SBI_EXT_NACL) <= 0)
+		return -ENODEV;
+
+	/* Enable NACL support */
+	static_branch_enable(&kvm_riscv_nacl_available);
+
+	/* Probe NACL features */
+	if (nacl_probe_feature(SBI_NACL_FEAT_SYNC_CSR))
+		static_branch_enable(&kvm_riscv_nacl_sync_csr_available);
+	if (nacl_probe_feature(SBI_NACL_FEAT_SYNC_HFENCE))
+		static_branch_enable(&kvm_riscv_nacl_sync_hfence_available);
+	if (nacl_probe_feature(SBI_NACL_FEAT_SYNC_SRET))
+		static_branch_enable(&kvm_riscv_nacl_sync_sret_available);
+	if (nacl_probe_feature(SBI_NACL_FEAT_AUTOSWAP_CSR))
+		static_branch_enable(&kvm_riscv_nacl_autoswap_csr_available);
+
+	/* Allocate per-CPU shared memory */
+	for_each_possible_cpu(cpu) {
+		nacl = per_cpu_ptr(&kvm_riscv_nacl, cpu);
+
+		shmem_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+					 get_order(SBI_NACL_SHMEM_SIZE));
+		if (!shmem_page) {
+			kvm_riscv_nacl_exit();
+			return -ENOMEM;
+		}
+		nacl->shmem = page_to_virt(shmem_page);
+		nacl->shmem_phys = page_to_phys(shmem_page);
+	}
+
+	return 0;
+}
-- 
2.34.1


