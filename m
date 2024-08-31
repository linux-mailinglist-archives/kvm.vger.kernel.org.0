Return-Path: <kvm+bounces-25621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D24C96713F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16D641F22AEE
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8AA517DFF4;
	Sat, 31 Aug 2024 11:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GprDlzUq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5DB33EA
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103685; cv=none; b=Ve0wDthODPXxuKqB73gbfF6VSrBpJ560FwrxsSyVqMyCyulvo2/M6ip/jTiI3lBxSyFxfo6DhQrlIAf5uC+DwbRQDbrjoUNGfIQG2fSFFe4YskLtKKx0/WTFV6VgUzwHgtfXyKi/aIvVJjst1tidQbXvww8zrbDAmPfcjmQt6Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103685; c=relaxed/simple;
	bh=XAZpLjGaTatCjl0h+K/byOYY8HXw2mFJT3zVZZIUn2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtYu4XxJpEQTZXIYYtekU6b8GomO7ShOeZ6CTI9+PC8zc0FezhaxAwT9ppDcGvEJT06oYurm+ugnE5a5xi6t3Db6HDpzuioUbiDWe4XdyS0m2ZvnSjSpK8e1xWmsBlmtPq2uMMRy9Nc9RdEz+76uRVm3uKMQD/xCA+2pLUCiJX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GprDlzUq; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-201fba05363so22372505ad.3
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103683; x=1725708483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/BXM/UjcLm0O8HfweJKHKopg0DzPpx/VDjUX4pXUr5s=;
        b=GprDlzUqG8jaFD+bvFKczVgh7mPfXRdVz4tCw7ZXZRzAH16zlnS8LG328RKo6OOwfB
         78vS9CPDu3dIRevjpPJsQJDPoaP5sfId2u+OJL2+wnppqSmd14euH0aLMYDQxvZh16nx
         JFuJQw7oEQiPHQeQdcH6lmxr+mCmCyoKTNZZQe/kuipMoNK34tJAm7DM2Gp/QbNHCRnL
         s9wh2uhfGLOudLZRl06omHPMP/V8vpEfaNiSOslw9XnXerYDO65Rida1LXFRvMJRjWts
         u/WVNv7Pw9w5EWZkKlfy4MXgSfNWdZde11HGUnlxOZxyA5sdNeDcBMWUWe5Kx+RJ6+Qv
         IEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103683; x=1725708483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/BXM/UjcLm0O8HfweJKHKopg0DzPpx/VDjUX4pXUr5s=;
        b=avSDHp5P43KYFRk+MiZwlVELV/VqgJwOs7lclAORcKrNCegHSzNUkThhNQg1YZZhji
         BON9sT/3arhAyy7mGjBzHC7cVXoGuyBRhG/FvC59Nfxc+n8DmavuFkZvCJggBzEgqCoX
         eUdVTuDz5KH3NuT4d1bEeKrEPm4DJ569IiXIzBOdbhx/USA48vbOs5zchzX2xIx5/rJg
         SQRbBEf6Qpsak9iysGOJP0u3Tgjg6xVhZpYpPeNHw9hKE6zV988bALEn+Yg92QZG5l9i
         42jzSxnsHoFQ/qc4l4+gCbSWEL+Uhxu+Brs8mYE+HUa1p+0e36vO6Dz6Ioa8ZIw+ZiDQ
         B6sg==
X-Forwarded-Encrypted: i=1; AJvYcCXhQni1zt0poQFojcsdmE7t4ZFjftd2GjVFC6YMOMimzvOuZ05aNFyQtVNW35DJeImTSQo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoRudjnvdw6nVRGYXmi9AQcBWpLcubacXq4SlQMC5jkl9ff532
	COhuq+/PoYPmQTL8KxSnQljBG4pHFirswrVyI9y3SpNyxkybsODjNab1ICK5dYM=
X-Google-Smtp-Source: AGHT+IEQIeW8TsJRj3YdPcy+zVYnpU6q86s+Ay93nPwfWubG0G4A/nhUXxKmJgbl2LeoLHyQsp6O+w==
X-Received: by 2002:a17:902:d2c2:b0:1fd:67c2:f97f with SMTP id d9443c01a7336-20544514f71mr23150075ad.28.1725103682450;
        Sat, 31 Aug 2024 04:28:02 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:02 -0700 (PDT)
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
Subject: [kvmtool PATCH 1/8] Sync-up headers with Linux-6.11-rc4 kernel
Date: Sat, 31 Aug 2024 16:57:36 +0530
Message-ID: <20240831112743.379709-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240831112743.379709-1-apatel@ventanamicro.com>
References: <20240831112743.379709-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
Zawrs support.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kvm.h       | 27 ++++++++++++++++++++-
 powerpc/include/asm/kvm.h |  3 +++
 riscv/include/asm/kvm.h   |  7 ++++++
 x86/include/asm/kvm.h     | 49 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index d03842a..637efc0 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -192,11 +192,24 @@ struct kvm_xen_exit {
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
+/*
+ * struct kvm_run can be modified by userspace at any time, so KVM must be
+ * careful to avoid TOCTOU bugs. In order to protect KVM, HINT_UNSAFE_IN_KVM()
+ * renames fields in struct kvm_run from <symbol> to <symbol>__unsafe when
+ * compiled into the kernel, ensuring that any use within KVM is obvious and
+ * gets extra scrutiny.
+ */
+#ifdef __KERNEL__
+#define HINT_UNSAFE_IN_KVM(_symbol) _symbol##__unsafe
+#else
+#define HINT_UNSAFE_IN_KVM(_symbol) _symbol
+#endif
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
-	__u8 immediate_exit;
+	__u8 HINT_UNSAFE_IN_KVM(immediate_exit);
 	__u8 padding1[6];
 
 	/* out */
@@ -917,6 +930,9 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_PRE_FAULT_MEMORY 236
+#define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
+#define KVM_CAP_X86_GUEST_MODE 238
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1548,4 +1564,13 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
+
+struct kvm_pre_fault_memory {
+	__u64 gpa;
+	__u64 size;
+	__u64 flags;
+	__u64 padding[5];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index 1691297..eaeda00 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -645,6 +645,9 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
 #define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
 #define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+#define KVM_REG_PPC_DEXCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc6)
+#define KVM_REG_PPC_HASHKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc7)
+#define KVM_REG_PPC_HASHPKEYR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc8)
 
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index e878e7c..e97db32 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -168,6 +168,13 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_SSCOFPMF,
+	KVM_RISCV_ISA_EXT_ZIMOP,
+	KVM_RISCV_ISA_EXT_ZCA,
+	KVM_RISCV_ISA_EXT_ZCB,
+	KVM_RISCV_ISA_EXT_ZCD,
+	KVM_RISCV_ISA_EXT_ZCF,
+	KVM_RISCV_ISA_EXT_ZCMOP,
+	KVM_RISCV_ISA_EXT_ZAWRS,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 9fae1b7..bf57a82 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_ioapic_state {
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
 #define KVM_RUN_X86_BUS_LOCK     (1 << 1)
+#define KVM_RUN_X86_GUEST_MODE   (1 << 2)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
@@ -697,6 +698,11 @@ enum sev_cmd_id {
 	/* Second time is the charm; improved versions of the above ioctls.  */
 	KVM_SEV_INIT2,
 
+	/* SNP-specific commands */
+	KVM_SEV_SNP_LAUNCH_START = 100,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -824,6 +830,48 @@ struct kvm_sev_receive_update_data {
 	__u32 pad2;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+	__u16 flags;
+	__u8 pad0[6];
+	__u64 pad1[4];
+};
+
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u64 len;
+	__u8 type;
+	__u8 pad0;
+	__u16 flags;
+	__u32 pad1;
+	__u64 pad2[4];
+};
+
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 vcek_disabled;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad0[3];
+	__u16 flags;
+	__u64 pad1[4];
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
@@ -874,5 +922,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SW_PROTECTED_VM	1
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.43.0


