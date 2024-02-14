Return-Path: <kvm+bounces-8661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9F385491C
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A68E28ED7C
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 12:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064DC1BDCB;
	Wed, 14 Feb 2024 12:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZdlCN6fI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F7F1BC4C
	for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 12:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707913316; cv=none; b=NvLd3toSlAT6ufJVZJnftJfkBwHK4J7DesQB9UW7DohsEddJHz+eZJeBTf0NwHwxWvUg8yUleQirhb9A1h/KeyG+phpJWnqlasZc8vQU72KOeF/KQDATJtmeXLBmHGEDISM/LJDOhGG5xRaMhFRv8wOHNu1ToMlGpqQjAjQt2NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707913316; c=relaxed/simple;
	bh=eSCPp5BZR2FchMsq+62Fxq/ckhn8vfDXgrh80QckDOE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k8bznD9xPgqa5f4tyLQSH1SNVom7+DQD3gxmyQp+D6u04EBtbGfNB1dHvR73ozbhLRDofmwgnJM2QRJEWPcMkwxGciOxk3WEEKofPxaH1CuMc2eYIgQpxAH67n/gL6nAw9kkf+EwALodNy33M48vfosmhdq0chyOjoFQXXjpntY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZdlCN6fI; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e0a4c6c2adso2075455b3a.1
        for <kvm@vger.kernel.org>; Wed, 14 Feb 2024 04:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1707913313; x=1708518113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ngxwXlnRnmE5mmXUezOnr5izpLf9SqETmoi0NyF/Uo=;
        b=ZdlCN6fIItgX/ySbwg8D8cYxrgj54ZqVlJ+EsDGkG1WbqE+AVWSDzfQk+EN8joMfZE
         3HtFCFXCHYdGPa2vR9SYJCSOMf+L0kIDoVZpyHueqR9cIbbIIoO3XFnZ/bX4biTP6iY7
         M5gmTtBK1yVzMC0qFoXCGPInlAX13/7QuNd6OtdLr7Ows497CVaAhEl1tdn7wbdgmNjc
         G1tej7FW0N/4K4Filh2SIvI31sJr343yMMsiZpAR2RpXKDYTBKBNLus9v/e0tIF0hLRa
         /CbBPC1SpgxhSfN1dzhq6/HDIpdrrTzhM0w62JM/FSWUhVd4Fn6l312n1UnhqMMrNJTk
         WPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707913313; x=1708518113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ngxwXlnRnmE5mmXUezOnr5izpLf9SqETmoi0NyF/Uo=;
        b=GNnYhOatdslG9R0rxKgjwLHp7Nm9SxSzrf04Fja5ET1Myj4JD2AlzWwcO9lzXKiszR
         WO6aiGt3AOLF+XiKKuZJv/ePdNZpeQZ9MSaRykSYOLts5xgDqrSInPZYSqLDlvhhDUZy
         9H1DtKTgvVuIX4Uqiq0DVrvc5DXmu/U55lQqZzloiOQeyg8KnK6wArzXGTGmXes/KiLv
         fM3qWPI0qFsRXxrJh9XS3QH5e7oI86+tQLJZeP/jnYMAYOfX8VKFetfPEn4JS+DBKHfg
         QOcaQmJdv7tvi27TJjq5N11BTMblwOmUdKak+/bpT+Wmhz2xIdpm5b23jxTJ7fPRmTs2
         zoMw==
X-Forwarded-Encrypted: i=1; AJvYcCVXxKCmagv7A7Tl4IPZnEOFbM8r/GJGrj8ifmcTj+15ZpejtyuiTxtn/wS9h8abyJm3nqBHvZtCzf9oi1ShfGHgJO0t
X-Gm-Message-State: AOJu0Yw6vIivwE9p8/HqeK3vj9/rIZfQUKY4XsIG2C1MqmqTSeZ8T6xO
	5L6WugY/KtQk9Jak76UgqXHLjFeSvfa0/wZ9nwwO7RBLQEjNGcKZ33eKBjHUY5w=
X-Google-Smtp-Source: AGHT+IFntPXJG+DP7/SKZ0zP4F4+odgq6jaMijmravexY58pKlv0JJplCuC9gCFDxOc1KsR4mgM66g==
X-Received: by 2002:a05:6a00:1404:b0:6df:f7f3:6197 with SMTP id l4-20020a056a00140400b006dff7f36197mr2541379pfu.34.1707913313379;
        Wed, 14 Feb 2024 04:21:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWytp6abX29d43AwyIxDb3T4tKOFhNM11aM0SABRX/qDm/ceg6xIH3NberSB8SzFn9EKMpMg3sEQTE5PetwT2EP2VSwSrE7qC2EmRxTEtb2VkR4EZe/NPl/U4r7PEYB9pYiGjw0gsNkFdjkHMtUmqTZffh0tU4Bh2+/xeHa3MSRtDHxKAx2GPGDuCHtSvELwfYLIdbGrn5wJts2cvPdDPSsSPS+JfX8GnYujX7jDoZsFjhJySte/Bo9Qi/lUXeHirZ5xA7B8uxh2oeQJUtgvyDgjyX/Adh9LOP2Nn2OdXAAuNA319DmP7ci2gMvVFbQYg==
Received: from anup-ubuntu-vm.localdomain ([171.76.87.178])
        by smtp.gmail.com with ESMTPSA id hq26-20020a056a00681a00b006dbdac1595esm9496060pfb.141.2024.02.14.04.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Feb 2024 04:21:52 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 01/10] Sync-up header with Linux-6.8-rc4 for KVM RISC-V
Date: Wed, 14 Feb 2024 17:51:32 +0530
Message-Id: <20240214122141.305126-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240214122141.305126-1-apatel@ventanamicro.com>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
Zbc, Scalar crypto, Vector crypto, Zfh[min], Zihintntl, Zvfh[min],
Zfa, and SBI steal-time support.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kvm.h           | 140 ++++++++++++----------------------
 include/linux/virtio_config.h |   8 +-
 include/linux/virtio_pci.h    |  68 +++++++++++++++++
 riscv/include/asm/kvm.h       |  40 ++++++++++
 x86/include/asm/kvm.h         |   3 +
 5 files changed, 168 insertions(+), 91 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 211b86d..c330853 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -16,76 +16,6 @@
 
 #define KVM_API_VERSION 12
 
-/* *** Deprecated interfaces *** */
-
-#define KVM_TRC_SHIFT           16
-
-#define KVM_TRC_ENTRYEXIT       (1 << KVM_TRC_SHIFT)
-#define KVM_TRC_HANDLER         (1 << (KVM_TRC_SHIFT + 1))
-
-#define KVM_TRC_VMENTRY         (KVM_TRC_ENTRYEXIT + 0x01)
-#define KVM_TRC_VMEXIT          (KVM_TRC_ENTRYEXIT + 0x02)
-#define KVM_TRC_PAGE_FAULT      (KVM_TRC_HANDLER + 0x01)
-
-#define KVM_TRC_HEAD_SIZE       12
-#define KVM_TRC_CYCLE_SIZE      8
-#define KVM_TRC_EXTRA_MAX       7
-
-#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
-#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
-#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
-#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
-#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
-#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
-#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
-#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
-#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
-#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
-#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
-#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
-#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
-#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
-#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
-#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
-#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
-#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
-#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
-#define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
-#define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
-#define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
-#define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
-
-struct kvm_user_trace_setup {
-	__u32 buf_size;
-	__u32 buf_nr;
-};
-
-#define __KVM_DEPRECATED_MAIN_W_0x06 \
-	_IOW(KVMIO, 0x06, struct kvm_user_trace_setup)
-#define __KVM_DEPRECATED_MAIN_0x07 _IO(KVMIO, 0x07)
-#define __KVM_DEPRECATED_MAIN_0x08 _IO(KVMIO, 0x08)
-
-#define __KVM_DEPRECATED_VM_R_0x70 _IOR(KVMIO, 0x70, struct kvm_assigned_irq)
-
-struct kvm_breakpoint {
-	__u32 enabled;
-	__u32 padding;
-	__u64 address;
-};
-
-struct kvm_debug_guest {
-	__u32 enabled;
-	__u32 pad;
-	struct kvm_breakpoint breakpoints[4];
-	__u32 singlestep;
-};
-
-#define __KVM_DEPRECATED_VCPU_W_0x87 _IOW(KVMIO, 0x87, struct kvm_debug_guest)
-
-/* *** End of deprecated interfaces *** */
-
-
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -95,6 +25,19 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SET_USER_MEMORY_REGION2 */
+struct kvm_userspace_memory_region2 {
+	__u32 slot;
+	__u32 flags;
+	__u64 guest_phys_addr;
+	__u64 memory_size;
+	__u64 userspace_addr;
+	__u64 guest_memfd_offset;
+	__u32 guest_memfd;
+	__u32 pad1;
+	__u64 pad2[14];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_userspace_memory_region::flags are visible for
  * userspace, other bits are reserved for kvm internal use which are defined
@@ -102,6 +45,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_GUEST_MEMFD	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -265,6 +209,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
+#define KVM_EXIT_MEMORY_FAULT     39
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -518,6 +463,13 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+			__u64 flags;
+			__u64 gpa;
+			__u64 size;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -945,9 +897,6 @@ struct kvm_ppc_resize_hpt {
  */
 #define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 #define KVM_GET_SUPPORTED_CPUID   _IOWR(KVMIO, 0x05, struct kvm_cpuid2)
-#define KVM_TRACE_ENABLE          __KVM_DEPRECATED_MAIN_W_0x06
-#define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
-#define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
 #define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
 #define KVM_GET_MSR_FEATURE_INDEX_LIST    _IOWR(KVMIO, 0x0a, struct kvm_msr_list)
 
@@ -1201,6 +1150,11 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
+#define KVM_CAP_USER_MEMORY2 231
+#define KVM_CAP_MEMORY_FAULT_INFO 232
+#define KVM_CAP_MEMORY_ATTRIBUTES 233
+#define KVM_CAP_GUEST_MEMFD 234
+#define KVM_CAP_VM_TYPES 235
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1291,6 +1245,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1483,6 +1438,8 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SET_USER_MEMORY_REGION2 _IOW(KVMIO, 0x49, \
+					 struct kvm_userspace_memory_region2)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
@@ -1507,20 +1464,8 @@ struct kvm_s390_ucas_mapping {
 			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
 #define KVM_UNREGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
-#define KVM_ASSIGN_PCI_DEVICE     _IOR(KVMIO,  0x69, \
-				       struct kvm_assigned_pci_dev)
 #define KVM_SET_GSI_ROUTING       _IOW(KVMIO,  0x6a, struct kvm_irq_routing)
-/* deprecated, replaced by KVM_ASSIGN_DEV_IRQ */
-#define KVM_ASSIGN_IRQ            __KVM_DEPRECATED_VM_R_0x70
-#define KVM_ASSIGN_DEV_IRQ        _IOW(KVMIO,  0x70, struct kvm_assigned_irq)
 #define KVM_REINJECT_CONTROL      _IO(KVMIO,   0x71)
-#define KVM_DEASSIGN_PCI_DEVICE   _IOW(KVMIO,  0x72, \
-				       struct kvm_assigned_pci_dev)
-#define KVM_ASSIGN_SET_MSIX_NR    _IOW(KVMIO,  0x73, \
-				       struct kvm_assigned_msix_nr)
-#define KVM_ASSIGN_SET_MSIX_ENTRY _IOW(KVMIO,  0x74, \
-				       struct kvm_assigned_msix_entry)
-#define KVM_DEASSIGN_DEV_IRQ      _IOW(KVMIO,  0x75, struct kvm_assigned_irq)
 #define KVM_IRQFD                 _IOW(KVMIO,  0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		  _IOW(KVMIO,  0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID       _IO(KVMIO,   0x78)
@@ -1537,9 +1482,6 @@ struct kvm_s390_ucas_mapping {
 *  KVM_CAP_VM_TSC_CONTROL to set defaults for a VM */
 #define KVM_SET_TSC_KHZ           _IO(KVMIO,  0xa2)
 #define KVM_GET_TSC_KHZ           _IO(KVMIO,  0xa3)
-/* Available with KVM_CAP_PCI_2_3 */
-#define KVM_ASSIGN_SET_INTX_MASK  _IOW(KVMIO,  0xa4, \
-				       struct kvm_assigned_pci_dev)
 /* Available with KVM_CAP_SIGNAL_MSI */
 #define KVM_SIGNAL_MSI            _IOW(KVMIO,  0xa5, struct kvm_msi)
 /* Available with KVM_CAP_PPC_GET_SMMU_INFO */
@@ -1592,8 +1534,6 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_SREGS             _IOW(KVMIO,  0x84, struct kvm_sregs)
 #define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
 #define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
-/* KVM_DEBUG_GUEST is no longer supported, use KVM_SET_GUEST_DEBUG instead */
-#define KVM_DEBUG_GUEST           __KVM_DEPRECATED_VCPU_W_0x87
 #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
@@ -2267,4 +2207,24 @@ struct kvm_s390_zpci_op {
 /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
 #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
+/* Available with KVM_CAP_MEMORY_ATTRIBUTES */
+#define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
+
+struct kvm_memory_attributes {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+};
+
+#define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+#define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+
+struct kvm_create_guest_memfd {
+	__u64 size;
+	__u64 flags;
+	__u64 reserved[6];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 8881aea..2445f36 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -114,4 +114,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index 44f4dd2..ef3810d 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -175,6 +175,9 @@ struct virtio_pci_modern_common_cfg {
 
 	__le16 queue_notify_data;	/* read-write */
 	__le16 queue_reset;		/* read-write */
+
+	__le16 admin_queue_index;	/* read-only */
+	__le16 admin_queue_num;		/* read-only */
 };
 
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
@@ -215,7 +218,72 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_USEDHI	52
 #define VIRTIO_PCI_COMMON_Q_NDATA	56
 #define VIRTIO_PCI_COMMON_Q_RESET	58
+#define VIRTIO_PCI_COMMON_ADM_Q_IDX	60
+#define VIRTIO_PCI_COMMON_ADM_Q_NUM	62
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
+/* Admin command status. */
+#define VIRTIO_ADMIN_STATUS_OK		0
+
+/* Admin command opcode. */
+#define VIRTIO_ADMIN_CMD_LIST_QUERY	0x0
+#define VIRTIO_ADMIN_CMD_LIST_USE	0x1
+
+/* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
+
+/* Transitional device admin command. */
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
+#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
+
+struct __packed virtio_admin_cmd_hdr {
+	__le16 opcode;
+	/*
+	 * 1 - SR-IOV
+	 * 2-65535 - reserved
+	 */
+	__le16 group_type;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved1[12];
+	__le64 group_member_id;
+};
+
+struct __packed virtio_admin_cmd_status {
+	__le16 status;
+	__le16 status_qualifier;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved2[4];
+};
+
+struct __packed virtio_admin_cmd_legacy_wr_data {
+	__u8 offset; /* Starting offset of the register(s) to write. */
+	__u8 reserved[7];
+	__u8 registers[];
+};
+
+struct __packed virtio_admin_cmd_legacy_rd_data {
+	__u8 offset; /* Starting offset of the register(s) to read. */
+};
+
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END 0
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_DEV 0x1
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM 0x2
+
+#define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
+
+struct __packed virtio_admin_cmd_notify_info_data {
+	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
+	__u8 bar; /* BAR of the member or the owner device */
+	__u8 padding[6];
+	__le64 offset; /* Offset within bar. */
+};
+
+struct virtio_admin_cmd_notify_info_result {
+	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
+};
+
 #endif
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 60d3b21..7499e88 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -139,6 +139,33 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHPM,
 	KVM_RISCV_ISA_EXT_SMSTATEEN,
 	KVM_RISCV_ISA_EXT_ZICOND,
+	KVM_RISCV_ISA_EXT_ZBC,
+	KVM_RISCV_ISA_EXT_ZBKB,
+	KVM_RISCV_ISA_EXT_ZBKC,
+	KVM_RISCV_ISA_EXT_ZBKX,
+	KVM_RISCV_ISA_EXT_ZKND,
+	KVM_RISCV_ISA_EXT_ZKNE,
+	KVM_RISCV_ISA_EXT_ZKNH,
+	KVM_RISCV_ISA_EXT_ZKR,
+	KVM_RISCV_ISA_EXT_ZKSED,
+	KVM_RISCV_ISA_EXT_ZKSH,
+	KVM_RISCV_ISA_EXT_ZKT,
+	KVM_RISCV_ISA_EXT_ZVBB,
+	KVM_RISCV_ISA_EXT_ZVBC,
+	KVM_RISCV_ISA_EXT_ZVKB,
+	KVM_RISCV_ISA_EXT_ZVKG,
+	KVM_RISCV_ISA_EXT_ZVKNED,
+	KVM_RISCV_ISA_EXT_ZVKNHA,
+	KVM_RISCV_ISA_EXT_ZVKNHB,
+	KVM_RISCV_ISA_EXT_ZVKSED,
+	KVM_RISCV_ISA_EXT_ZVKSH,
+	KVM_RISCV_ISA_EXT_ZVKT,
+	KVM_RISCV_ISA_EXT_ZFH,
+	KVM_RISCV_ISA_EXT_ZFHMIN,
+	KVM_RISCV_ISA_EXT_ZIHINTNTL,
+	KVM_RISCV_ISA_EXT_ZVFH,
+	KVM_RISCV_ISA_EXT_ZVFHMIN,
+	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -157,9 +184,16 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_RISCV_SBI_EXT_DBCN,
+	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
+/* SBI STA extension registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_sbi_sta {
+	unsigned long shmem_lo;
+	unsigned long shmem_hi;
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -241,6 +275,12 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_VECTOR_REG(n)	\
 		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
 
+/* Registers for specific SBI extensions are mapped as type 10 */
+#define KVM_REG_RISCV_SBI_STATE		(0x0a << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_STA_REG(name)		\
+		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
 #define KVM_DEV_RISCV_APLIC_SIZE		0x4000
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 1a6a1f9..a448d09 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -562,4 +562,7 @@ struct kvm_pmu_event_filter {
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
 #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
 
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_SW_PROTECTED_VM	1
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.34.1


