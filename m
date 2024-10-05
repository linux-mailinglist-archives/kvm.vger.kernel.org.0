Return-Path: <kvm+bounces-28006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14CB999152E
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 10:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67DC4283957
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 08:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D6013C8EA;
	Sat,  5 Oct 2024 08:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fmslaeQS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7B313BC0D
	for <kvm@vger.kernel.org>; Sat,  5 Oct 2024 08:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728115240; cv=none; b=uc69xPoABgEbtEcU+1tmzwGZ0+//dLaD0nvtjLDVWsM1CuJ452/vwSC3KAWOEIElzFQVXZbNh6oQh7YMKGYetKw7GlSVQf5rW2MID2TSh6PxZdW/dfdStxTTAc4AFzTE7vq/J6cj1lMP7NOitkGSwdlRDej96HSGv5Lz6yRR+2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728115240; c=relaxed/simple;
	bh=bISm15AbbnFVsyVKS1rJGvGAUkByyzepdR6nVr5qNrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiDFTBa/aXTEoO2L0i5guxu3hhmLPFsktL7ETfqZ+M+3G1HB2Wj8unyHthqT/43WhbIdQ97h7c95I7XNIitQJpR+Svv5ljDURvkI3hu0AUnsUnKqJN1Gr8L2e6OnlKI/Gv7d9mpXBLDt/ifAH8+C9VoNhr76Xd8x7Pg1lDEFCw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fmslaeQS; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2e0a74ce880so2466868a91.2
        for <kvm@vger.kernel.org>; Sat, 05 Oct 2024 01:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1728115238; x=1728720038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sWS7QAt4/N9QpfhM3GlMbw5FIufz8mceTBIPQoGets=;
        b=fmslaeQSGB57T4hPscVPg8YbPZagV5inb9sV6HUnYsCqORqssDCexArGf2goiF3SvQ
         F+sDoXFsKgUKiSioH+KRIoiFB/ih20h2dbYL1PI0PVjgllXiH3MTmgoWTj2ca/KikHMS
         IFmi0BF3606zKtk7az2oFeIrhobiZ+qiB+jGf3QGBTr0xVu70YhBAgRPaJX2diJdiKLH
         +TacUltlGgghF7hFGJUwNt7QIXs9w0wJ52Q5baMVKCKrXQ+EcumRlMhaHgC7VTBg1D2v
         2w3O1HRoLNjyuH1PdGn/liF1i8IZhl+YDmltAzNUAfn65wQ5zzfiSp/js/IOlUkHchUf
         rOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728115238; x=1728720038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sWS7QAt4/N9QpfhM3GlMbw5FIufz8mceTBIPQoGets=;
        b=c5PNe0Oa6qumC9LU61wM2L9oETCwkYlF/R8kN0XQ6s1TgexrnbCwXOtLBGIVcw5vUJ
         H9/KY62YH8E1OVIWqQw2VCtH+5oB9kv2rE4m/I2pN9BWCtwODgnIZuWRdgOK+9sJXr4T
         FG4vnShWxmq2c26inud3mi75xhhWjggoSyGeVtXRVTLk7XgZDjyT5g8gEdHad+e2PmHR
         ki40jvVOrKuixconeRslO5+P33rzjDOGT3NUCCqZu8QEZg+Hcn2nmnYO5LdrHIkz8vC8
         y1vlx7Qv/NX7xzTtAQqNE7qx0r00zNlfyaJbnhtK717dtyWSmxL5jfrgzKLhlAIgnjbR
         vqCA==
X-Forwarded-Encrypted: i=1; AJvYcCVNPLZ3ZRywwUE4u2XyZNr5jNNYAd1f097kaxKIy6KflNQIeeZrh5ZGnQRLLuo9/COvl5U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVMSHwh2ro2Y2vKMzEVKj6h49VIfmnPQ4iG5ObL8lCOwMj0RVi
	O/GM8uiM6HoQ4SAsMkxrwVP5GaL8FZKQQZg5SpzrhZHZIjssTPq+b0hR7CThAHE=
X-Google-Smtp-Source: AGHT+IHh93RIZYuNbGThvVvVMpxxIordQ/uESwOsTOoZeBZX1xZ/v0qBg4GsRWvKsWgREH1GU0mihQ==
X-Received: by 2002:a17:90a:f2c4:b0:2e0:9160:1842 with SMTP id 98e67ed59e1d1-2e1e620c8e8mr7348534a91.1.1728115237626;
        Sat, 05 Oct 2024 01:00:37 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([223.185.135.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e20ae69766sm1259172a91.8.2024.10.05.01.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 01:00:37 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 1/8] Sync-up headers with Linux-6.11 kernel
Date: Sat,  5 Oct 2024 13:30:17 +0530
Message-ID: <20241005080024.11927-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241005080024.11927-1-apatel@ventanamicro.com>
References: <20241005080024.11927-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
newly added ISA extensions in ONE_REG interface.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
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


