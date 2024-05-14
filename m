Return-Path: <kvm+bounces-17364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6048C4C12
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 07:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3DE51C22D49
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 05:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB161CA92;
	Tue, 14 May 2024 05:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="FZY3KNOG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A93C1BC49
	for <kvm@vger.kernel.org>; Tue, 14 May 2024 05:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665851; cv=none; b=DfCtyL6LUy/SO5LkHI08ZCRLneQYL8uFTEKqcXWWbbh3d4XbC1gvT/aV0ImFxvRtooCQT003/IG3Wt2VIGlWiTEHFo9VP8/+7MZ71rf65QQrU1T19oYxx9ljJ2t9Y91ur1vlZ24Uy/YoqLoW+se6XWVNhkwKvaW4AqOsZtQUxfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665851; c=relaxed/simple;
	bh=f8CGGxEZwAdbdSSDtwI6bn2XJNpG7jfU6nN9ziBZBnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hD4kcQ0FFxlOB64HX7K7ltGZEmWiPyNR+iFaZfueW53f7jgyvhHO/WRlwMqmxIZYi2DA4fGc1mezsMyyPBmcaqXOPP02hhp6R7kz5WTt6JTUIv+/gkjgwyKAjfncJAmlCUOdbD5yhBbszST1TiditOV5XixjzYGTpMujrNThuYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=FZY3KNOG; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6f4ed9dc7beso1876504b3a.1
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 22:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1715665848; x=1716270648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=12T7Hu9ERAYKj6wkSEO/05Lm5ldlLjZSrTAYrcI97oA=;
        b=FZY3KNOGrzmg6tkPLawIUp2hfhz6TSFGbIqlRUijpGdeaey43U3XSMx7BqpJSV/zQL
         vD2jJGjEBFJRPyZwMCTihphyEcPQ8T0BUiccq6PDBQuxum59cf3EO8d0GPdVhfM9dO/K
         lAYlPpydvTvXfuCFAIsc3NeL6kU7L+ZdQxDKoljOVddc8HvaL5rhcf916xsGHLhqFVIu
         sl7lc4HoOcZ2ModVoVeWXtOyOsXBhFuXxmoc4+DwFpIiqRBwwL/MAGT6sFWaccg5Xg4b
         oQ4+wyHB4WGp22c9LavMgzKKLN8Rk9G1yfmFaWAw0nHUL6m2gZJGiVafzWXq4fJBYQ9w
         nFTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665848; x=1716270648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=12T7Hu9ERAYKj6wkSEO/05Lm5ldlLjZSrTAYrcI97oA=;
        b=a5uiKJPT7a5tAPM+CDqZtbE7G8TlOqbhDtzZN+0wlAPA/x7YqEJBtiLOYNza9NvS3S
         16mGVahB4rZBgBr2l4CsYq7m6vsjcjRXrxGruYl2QtDKbLRLWolT24EqZmY9BTgXAbS8
         F0i2VHrYOc9bHb1sbI2WM6Zwwb0L6bonA1LNJ2R8wQDVN0PaANAe518I6DohLwuYI8Js
         t/vveGX3JfhfKirF3xlecH3/k5IFEJ8uStSmxRh76IUKQUu7eYv15yh/6p7EEpFnCzlH
         mOBbGJ4lHufy7oH6ceW3xlqUAVmJRq/tU58t8Ra2pvUuN+a03GePEzmxj9sJs4QIANNz
         uKHw==
X-Forwarded-Encrypted: i=1; AJvYcCVBaDbCreFDCvA1i6RTrmduDGqsdr6ThYR+injUEraKoQHV10+wDTPpLObqg6vMzRXYK/7zCk34tf/kFN7aJdlxU2ir
X-Gm-Message-State: AOJu0YysHI5SVzCZcv5Tc3UGKCHeQk65qQp4/ijVANI1vlptR8hTWslZ
	0QCoBJ16oCALS/uOt0ZhL1vNVbyy1Nrp/Z/hzX7cZ14z4mu64zirrk8NY7R2XZ0=
X-Google-Smtp-Source: AGHT+IEWAW6oMOBJ+GpdDixNMVCwVlRUypkFEW1N0lcWYF+9g+bcZQ2m0fCkCdJ8700U00CeXXhRJA==
X-Received: by 2002:a05:6a00:1953:b0:6ea:dfc1:b86 with SMTP id d2e1a72fcca58-6f4df43520emr16774204b3a.12.1715665847993;
        Mon, 13 May 2024 22:50:47 -0700 (PDT)
Received: from localhost.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2b2de1csm8689246b3a.204.2024.05.13.22.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 22:50:47 -0700 (PDT)
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
Subject: [kvmtool PATCH 1/3] Sync-up headers with Linux-6.9 kernel
Date: Tue, 14 May 2024 11:19:26 +0530
Message-Id: <20240514054928.854419-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240514054928.854419-1-apatel@ventanamicro.com>
References: <20240514054928.854419-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
Ztso and Zacas support.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 arm/aarch64/include/asm/kvm.h         |  15 +-
 arm/aarch64/include/asm/sve_context.h |  11 +
 include/linux/kvm.h                   | 689 +-------------------------
 include/linux/virtio_pci.h            |  10 +-
 mips/include/asm/kvm.h                |   2 -
 powerpc/include/asm/kvm.h             |  45 +-
 riscv/include/asm/kvm.h               |   3 +-
 x86/include/asm/kvm.h                 | 308 +++++++++++-
 8 files changed, 376 insertions(+), 707 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 89d2fc8..964df31 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -37,9 +37,7 @@
 #include <asm/ptrace.h>
 #include <asm/sve_context.h>
 
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -76,11 +74,11 @@ struct kvm_regs {
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
-#define KVM_ARM_DEVICE_TYPE_MASK	GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
-						KVM_ARM_DEVICE_TYPE_SHIFT)
+#define KVM_ARM_DEVICE_TYPE_MASK	__GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
+						  KVM_ARM_DEVICE_TYPE_SHIFT)
 #define KVM_ARM_DEVICE_ID_SHIFT		16
-#define KVM_ARM_DEVICE_ID_MASK		GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
-						KVM_ARM_DEVICE_ID_SHIFT)
+#define KVM_ARM_DEVICE_ID_MASK		__GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
+						  KVM_ARM_DEVICE_ID_SHIFT)
 
 /* Supported device IDs */
 #define KVM_ARM_DEVICE_VGIC_V2		0
@@ -162,6 +160,11 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
+/* Bits for run->s.regs.device_irq_level */
+#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
+#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
+#define KVM_ARM_DEV_PMU			(1 << 2)
+
 /*
  * PMU filter structure. Describe a range of events with a particular
  * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
diff --git a/arm/aarch64/include/asm/sve_context.h b/arm/aarch64/include/asm/sve_context.h
index 754ab75..72aefc0 100644
--- a/arm/aarch64/include/asm/sve_context.h
+++ b/arm/aarch64/include/asm/sve_context.h
@@ -13,6 +13,17 @@
 
 #define __SVE_VQ_BYTES		16	/* number of bytes per quadword */
 
+/*
+ * Yes, __SVE_VQ_MAX is 512 QUADWORDS.
+ *
+ * To help ensure forward portability, this is much larger than the
+ * current maximum value defined by the SVE architecture.  While arrays
+ * or static allocations can be sized based on this value, watch out!
+ * It will waste a surprisingly large amount of memory.
+ *
+ * Dynamic sizing based on the actual runtime vector length is likely to
+ * be preferable for most purposes.
+ */
 #define __SVE_VQ_MIN		1
 #define __SVE_VQ_MAX		512
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c330853..2190adb 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -16,6 +16,11 @@
 
 #define KVM_API_VERSION 12
 
+/*
+ * Backwards-compatible definitions.
+ */
+#define __KVM_HAVE_GUEST_DEBUG
+
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -85,43 +90,6 @@ struct kvm_pit_config {
 
 #define KVM_PIT_SPEAKER_DUMMY     1
 
-struct kvm_s390_skeys {
-	__u64 start_gfn;
-	__u64 count;
-	__u64 skeydata_addr;
-	__u32 flags;
-	__u32 reserved[9];
-};
-
-#define KVM_S390_CMMA_PEEK (1 << 0)
-
-/**
- * kvm_s390_cmma_log - Used for CMMA migration.
- *
- * Used both for input and output.
- *
- * @start_gfn: Guest page number to start from.
- * @count: Size of the result buffer.
- * @flags: Control operation mode via KVM_S390_CMMA_* flags
- * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
- *             pages are still remaining.
- * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
- *        in the PGSTE.
- * @values: Pointer to the values buffer.
- *
- * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
- */
-struct kvm_s390_cmma_log {
-	__u64 start_gfn;
-	__u32 count;
-	__u32 flags;
-	union {
-		__u64 remaining;
-		__u64 mask;
-	};
-	__u64 values;
-};
-
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
@@ -315,11 +283,6 @@ struct kvm_run {
 			__u32 ipb;
 		} s390_sieic;
 		/* KVM_EXIT_S390_RESET */
-#define KVM_S390_RESET_POR       1
-#define KVM_S390_RESET_CLEAR     2
-#define KVM_S390_RESET_SUBSYSTEM 4
-#define KVM_S390_RESET_CPU_INIT  8
-#define KVM_S390_RESET_IPL       16
 		__u64 s390_reset_flags;
 		/* KVM_EXIT_S390_UCONTROL */
 		struct {
@@ -536,43 +499,6 @@ struct kvm_translation {
 	__u8  pad[5];
 };
 
-/* for KVM_S390_MEM_OP */
-struct kvm_s390_mem_op {
-	/* in */
-	__u64 gaddr;		/* the guest address */
-	__u64 flags;		/* flags */
-	__u32 size;		/* amount of bytes */
-	__u32 op;		/* type of operation */
-	__u64 buf;		/* buffer in userspace */
-	union {
-		struct {
-			__u8 ar;	/* the access register number */
-			__u8 key;	/* access key, ignored if flag unset */
-			__u8 pad1[6];	/* ignored */
-			__u64 old_addr;	/* ignored if cmpxchg flag unset */
-		};
-		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* ignored */
-	};
-};
-/* types for kvm_s390_mem_op->op */
-#define KVM_S390_MEMOP_LOGICAL_READ	0
-#define KVM_S390_MEMOP_LOGICAL_WRITE	1
-#define KVM_S390_MEMOP_SIDA_READ	2
-#define KVM_S390_MEMOP_SIDA_WRITE	3
-#define KVM_S390_MEMOP_ABSOLUTE_READ	4
-#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
-#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
-
-/* flags for kvm_s390_mem_op->flags */
-#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
-#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
-#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
-
-/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
-#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
-#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
-
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -637,124 +563,6 @@ struct kvm_mp_state {
 	__u32 mp_state;
 };
 
-struct kvm_s390_psw {
-	__u64 mask;
-	__u64 addr;
-};
-
-/* valid values for type in kvm_s390_interrupt */
-#define KVM_S390_SIGP_STOP		0xfffe0000u
-#define KVM_S390_PROGRAM_INT		0xfffe0001u
-#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
-#define KVM_S390_RESTART		0xfffe0003u
-#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
-#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
-#define KVM_S390_MCHK			0xfffe1000u
-#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
-#define KVM_S390_INT_CPU_TIMER		0xffff1005u
-#define KVM_S390_INT_VIRTIO		0xffff2603u
-#define KVM_S390_INT_SERVICE		0xffff2401u
-#define KVM_S390_INT_EMERGENCY		0xffff1201u
-#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
-/* Anything below 0xfffe0000u is taken by INT_IO */
-#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
-	(((schid)) |			       \
-	 ((ssid) << 16) |		       \
-	 ((cssid) << 18) |		       \
-	 ((ai) << 26))
-#define KVM_S390_INT_IO_MIN		0x00000000u
-#define KVM_S390_INT_IO_MAX		0xfffdffffu
-#define KVM_S390_INT_IO_AI_MASK		0x04000000u
-
-
-struct kvm_s390_interrupt {
-	__u32 type;
-	__u32 parm;
-	__u64 parm64;
-};
-
-struct kvm_s390_io_info {
-	__u16 subchannel_id;
-	__u16 subchannel_nr;
-	__u32 io_int_parm;
-	__u32 io_int_word;
-};
-
-struct kvm_s390_ext_info {
-	__u32 ext_params;
-	__u32 pad;
-	__u64 ext_params2;
-};
-
-struct kvm_s390_pgm_info {
-	__u64 trans_exc_code;
-	__u64 mon_code;
-	__u64 per_address;
-	__u32 data_exc_code;
-	__u16 code;
-	__u16 mon_class_nr;
-	__u8 per_code;
-	__u8 per_atmid;
-	__u8 exc_access_id;
-	__u8 per_access_id;
-	__u8 op_access_id;
-#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
-#define KVM_S390_PGM_FLAGS_ILC_0	0x02
-#define KVM_S390_PGM_FLAGS_ILC_1	0x04
-#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
-#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
-	__u8 flags;
-	__u8 pad[2];
-};
-
-struct kvm_s390_prefix_info {
-	__u32 address;
-};
-
-struct kvm_s390_extcall_info {
-	__u16 code;
-};
-
-struct kvm_s390_emerg_info {
-	__u16 code;
-};
-
-#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
-struct kvm_s390_stop_info {
-	__u32 flags;
-};
-
-struct kvm_s390_mchk_info {
-	__u64 cr14;
-	__u64 mcic;
-	__u64 failing_storage_address;
-	__u32 ext_damage_code;
-	__u32 pad;
-	__u8 fixed_logout[16];
-};
-
-struct kvm_s390_irq {
-	__u64 type;
-	union {
-		struct kvm_s390_io_info io;
-		struct kvm_s390_ext_info ext;
-		struct kvm_s390_pgm_info pgm;
-		struct kvm_s390_emerg_info emerg;
-		struct kvm_s390_extcall_info extcall;
-		struct kvm_s390_prefix_info prefix;
-		struct kvm_s390_stop_info stop;
-		struct kvm_s390_mchk_info mchk;
-		char reserved[64];
-	} u;
-};
-
-struct kvm_s390_irq_state {
-	__u64 buf;
-	__u32 flags;        /* will stay unused for compatibility reasons */
-	__u32 len;
-	__u32 reserved[4];  /* will stay unused for compatibility reasons */
-};
-
 /* for KVM_SET_GUEST_DEBUG */
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
@@ -810,50 +618,6 @@ struct kvm_enable_cap {
 	__u8  pad[64];
 };
 
-/* for KVM_PPC_GET_PVINFO */
-
-#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
-
-struct kvm_ppc_pvinfo {
-	/* out */
-	__u32 flags;
-	__u32 hcall[4];
-	__u8  pad[108];
-};
-
-/* for KVM_PPC_GET_SMMU_INFO */
-#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
-
-struct kvm_ppc_one_page_size {
-	__u32 page_shift;	/* Page shift (or 0) */
-	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
-};
-
-struct kvm_ppc_one_seg_page_size {
-	__u32 page_shift;	/* Base page shift of segment (or 0) */
-	__u32 slb_enc;		/* SLB encoding for BookS */
-	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
-#define KVM_PPC_1T_SEGMENTS		0x00000002
-#define KVM_PPC_NO_HASH			0x00000004
-
-struct kvm_ppc_smmu_info {
-	__u64 flags;
-	__u32 slb_size;
-	__u16 data_keys;	/* # storage keys supported for data */
-	__u16 instr_keys;	/* # storage keys supported for instructions */
-	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
-struct kvm_ppc_resize_hpt {
-	__u64 flags;
-	__u32 shift;
-	__u32 pad;
-};
-
 #define KVMIO 0xAE
 
 /* machine type bits, to be used as argument to KVM_CREATE_VM */
@@ -923,9 +687,7 @@ struct kvm_ppc_resize_hpt {
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 #define KVM_CAP_USER_NMI 22
-#ifdef __KVM_HAVE_GUEST_DEBUG
 #define KVM_CAP_SET_GUEST_DEBUG 23
-#endif
 #ifdef __KVM_HAVE_PIT
 #define KVM_CAP_REINJECT_CONTROL 24
 #endif
@@ -1156,8 +918,6 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
 
-#ifdef KVM_CAP_IRQ_ROUTING
-
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
 	__u32 pin;
@@ -1222,42 +982,6 @@ struct kvm_irq_routing {
 	struct kvm_irq_routing_entry entries[];
 };
 
-#endif
-
-#ifdef KVM_CAP_MCE
-/* x86 MCE */
-struct kvm_x86_mce {
-	__u64 status;
-	__u64 addr;
-	__u64 misc;
-	__u64 mcg_status;
-	__u8 bank;
-	__u8 pad1[7];
-	__u64 pad2[3];
-};
-#endif
-
-#ifdef KVM_CAP_XEN_HVM
-#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
-#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
-#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
-#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
-
-struct kvm_xen_hvm_config {
-	__u32 flags;
-	__u32 msr;
-	__u64 blob_addr_32;
-	__u64 blob_addr_64;
-	__u8 blob_size_32;
-	__u8 blob_size_64;
-	__u8 pad2[30];
-};
-#endif
-
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
 /*
  * Available with KVM_CAP_IRQFD_RESAMPLE
@@ -1442,11 +1166,6 @@ struct kvm_vfio_spapr_tce {
 					 struct kvm_userspace_memory_region2)
 
 /* enable ucontrol for s390 */
-struct kvm_s390_ucas_mapping {
-	__u64 user_addr;
-	__u64 vcpu_addr;
-	__u64 length;
-};
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
@@ -1641,89 +1360,6 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
-struct kvm_s390_pv_sec_parm {
-	__u64 origin;
-	__u64 length;
-};
-
-struct kvm_s390_pv_unp {
-	__u64 addr;
-	__u64 size;
-	__u64 tweak;
-};
-
-enum pv_cmd_dmp_id {
-	KVM_PV_DUMP_INIT,
-	KVM_PV_DUMP_CONFIG_STOR_STATE,
-	KVM_PV_DUMP_COMPLETE,
-	KVM_PV_DUMP_CPU,
-};
-
-struct kvm_s390_pv_dmp {
-	__u64 subcmd;
-	__u64 buff_addr;
-	__u64 buff_len;
-	__u64 gaddr;		/* For dump storage state */
-	__u64 reserved[4];
-};
-
-enum pv_cmd_info_id {
-	KVM_PV_INFO_VM,
-	KVM_PV_INFO_DUMP,
-};
-
-struct kvm_s390_pv_info_dump {
-	__u64 dump_cpu_buffer_len;
-	__u64 dump_config_mem_buffer_per_1m;
-	__u64 dump_config_finalize_len;
-};
-
-struct kvm_s390_pv_info_vm {
-	__u64 inst_calls_list[4];
-	__u64 max_cpus;
-	__u64 max_guests;
-	__u64 max_guest_addr;
-	__u64 feature_indication;
-};
-
-struct kvm_s390_pv_info_header {
-	__u32 id;
-	__u32 len_max;
-	__u32 len_written;
-	__u32 reserved;
-};
-
-struct kvm_s390_pv_info {
-	struct kvm_s390_pv_info_header header;
-	union {
-		struct kvm_s390_pv_info_dump dump;
-		struct kvm_s390_pv_info_vm vm;
-	};
-};
-
-enum pv_cmd_id {
-	KVM_PV_ENABLE,
-	KVM_PV_DISABLE,
-	KVM_PV_SET_SEC_PARMS,
-	KVM_PV_UNPACK,
-	KVM_PV_VERIFY,
-	KVM_PV_PREP_RESET,
-	KVM_PV_UNSHARE_ALL,
-	KVM_PV_INFO,
-	KVM_PV_DUMP,
-	KVM_PV_ASYNC_CLEANUP_PREPARE,
-	KVM_PV_ASYNC_CLEANUP_PERFORM,
-};
-
-struct kvm_pv_cmd {
-	__u32 cmd;	/* Command to be executed */
-	__u16 rc;	/* Ultravisor return code */
-	__u16 rrc;	/* Ultravisor return reason code */
-	__u64 data;	/* Data or address */
-	__u32 flags;    /* flags for future extensions. Must be 0 for now */
-	__u32 reserved[3];
-};
-
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
@@ -1737,58 +1373,6 @@ struct kvm_pv_cmd {
 #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
 #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
 
-struct kvm_xen_hvm_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u8 long_mode;
-		__u8 vector;
-		__u8 runstate_update_flag;
-		struct {
-			__u64 gfn;
-#define KVM_XEN_INVALID_GFN ((__u64)-1)
-		} shared_info;
-		struct {
-			__u32 send_port;
-			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
-			__u32 flags;
-#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
-#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
-#define KVM_XEN_EVTCHN_RESET		(1 << 2)
-			/*
-			 * Events sent by the guest are either looped back to
-			 * the guest itself (potentially on a different port#)
-			 * or signalled via an eventfd.
-			 */
-			union {
-				struct {
-					__u32 port;
-					__u32 vcpu;
-					__u32 priority;
-				} port;
-				struct {
-					__u32 port; /* Zero for eventfd */
-					__s32 fd;
-				} eventfd;
-				__u32 padding[4];
-			} deliver;
-		} evtchn;
-		__u32 xen_version;
-		__u64 pad[8];
-	} u;
-};
-
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
-#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
-#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
-#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
-#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
-
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
@@ -1799,242 +1383,6 @@ struct kvm_xen_hvm_attr {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
-struct kvm_xen_vcpu_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u64 gpa;
-#define KVM_XEN_INVALID_GPA ((__u64)-1)
-		__u64 pad[8];
-		struct {
-			__u64 state;
-			__u64 state_entry_time;
-			__u64 time_running;
-			__u64 time_runnable;
-			__u64 time_blocked;
-			__u64 time_offline;
-		} runstate;
-		__u32 vcpu_id;
-		struct {
-			__u32 port;
-			__u32 priority;
-			__u64 expires_ns;
-		} timer;
-		__u8 vector;
-	} u;
-};
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
-#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
-#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
-
-/* Secure Encrypted Virtualization command */
-enum sev_cmd_id {
-	/* Guest initialization commands */
-	KVM_SEV_INIT = 0,
-	KVM_SEV_ES_INIT,
-	/* Guest launch commands */
-	KVM_SEV_LAUNCH_START,
-	KVM_SEV_LAUNCH_UPDATE_DATA,
-	KVM_SEV_LAUNCH_UPDATE_VMSA,
-	KVM_SEV_LAUNCH_SECRET,
-	KVM_SEV_LAUNCH_MEASURE,
-	KVM_SEV_LAUNCH_FINISH,
-	/* Guest migration commands (outgoing) */
-	KVM_SEV_SEND_START,
-	KVM_SEV_SEND_UPDATE_DATA,
-	KVM_SEV_SEND_UPDATE_VMSA,
-	KVM_SEV_SEND_FINISH,
-	/* Guest migration commands (incoming) */
-	KVM_SEV_RECEIVE_START,
-	KVM_SEV_RECEIVE_UPDATE_DATA,
-	KVM_SEV_RECEIVE_UPDATE_VMSA,
-	KVM_SEV_RECEIVE_FINISH,
-	/* Guest status and debug commands */
-	KVM_SEV_GUEST_STATUS,
-	KVM_SEV_DBG_DECRYPT,
-	KVM_SEV_DBG_ENCRYPT,
-	/* Guest certificates commands */
-	KVM_SEV_CERT_EXPORT,
-	/* Attestation report */
-	KVM_SEV_GET_ATTESTATION_REPORT,
-	/* Guest Migration Extension */
-	KVM_SEV_SEND_CANCEL,
-
-	KVM_SEV_NR_MAX,
-};
-
-struct kvm_sev_cmd {
-	__u32 id;
-	__u64 data;
-	__u32 error;
-	__u32 sev_fd;
-};
-
-struct kvm_sev_launch_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 dh_uaddr;
-	__u32 dh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_launch_update_data {
-	__u64 uaddr;
-	__u32 len;
-};
-
-
-struct kvm_sev_launch_secret {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_launch_measure {
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_guest_status {
-	__u32 handle;
-	__u32 policy;
-	__u32 state;
-};
-
-struct kvm_sev_dbg {
-	__u64 src_uaddr;
-	__u64 dst_uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_attestation_report {
-	__u8 mnonce[16];
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_send_start {
-	__u32 policy;
-	__u64 pdh_cert_uaddr;
-	__u32 pdh_cert_len;
-	__u64 plat_certs_uaddr;
-	__u32 plat_certs_len;
-	__u64 amd_certs_uaddr;
-	__u32 amd_certs_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_send_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_receive_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 pdh_uaddr;
-	__u32 pdh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_receive_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-#define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
-#define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
-#define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-
-struct kvm_assigned_pci_dev {
-	__u32 assigned_dev_id;
-	__u32 busnr;
-	__u32 devfn;
-	__u32 flags;
-	__u32 segnr;
-	union {
-		__u32 reserved[11];
-	};
-};
-
-#define KVM_DEV_IRQ_HOST_INTX    (1 << 0)
-#define KVM_DEV_IRQ_HOST_MSI     (1 << 1)
-#define KVM_DEV_IRQ_HOST_MSIX    (1 << 2)
-
-#define KVM_DEV_IRQ_GUEST_INTX   (1 << 8)
-#define KVM_DEV_IRQ_GUEST_MSI    (1 << 9)
-#define KVM_DEV_IRQ_GUEST_MSIX   (1 << 10)
-
-#define KVM_DEV_IRQ_HOST_MASK	 0x00ff
-#define KVM_DEV_IRQ_GUEST_MASK   0xff00
-
-struct kvm_assigned_irq {
-	__u32 assigned_dev_id;
-	__u32 host_irq; /* ignored (legacy field) */
-	__u32 guest_irq;
-	__u32 flags;
-	union {
-		__u32 reserved[12];
-	};
-};
-
-struct kvm_assigned_msix_nr {
-	__u32 assigned_dev_id;
-	__u16 entry_nr;
-	__u16 padding;
-};
-
-#define KVM_MAX_MSIX_PER_DEV		256
-struct kvm_assigned_msix_entry {
-	__u32 assigned_dev_id;
-	__u32 gsi;
-	__u16 entry; /* The index of entry in the MSI-X table */
-	__u16 padding[3];
-};
-
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
-
-/* Available with KVM_CAP_ARM_USER_IRQ */
-
-/* Bits for run->s.regs.device_irq_level */
-#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
-#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
-#define KVM_ARM_DEV_PMU			(1 << 2)
-
-struct kvm_hyperv_eventfd {
-	__u32 conn_id;
-	__s32 fd;
-	__u32 flags;
-	__u32 padding[3];
-};
-
-#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
-#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
-
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
@@ -2180,33 +1528,6 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_S390_ZPCI_OP */
 #define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
 
-struct kvm_s390_zpci_op {
-	/* in */
-	__u32 fh;               /* target device */
-	__u8  op;               /* operation to perform */
-	__u8  pad[3];
-	union {
-		/* for KVM_S390_ZPCIOP_REG_AEN */
-		struct {
-			__u64 ibv;      /* Guest addr of interrupt bit vector */
-			__u64 sb;       /* Guest addr of summary bit */
-			__u32 flags;
-			__u32 noi;      /* Number of interrupts */
-			__u8 isc;       /* Guest interrupt subclass */
-			__u8 sbo;       /* Offset of guest summary bit vector */
-			__u16 pad;
-		} reg_aen;
-		__u64 reserved[8];
-	} u;
-};
-
-/* types for kvm_s390_zpci_op->op */
-#define KVM_S390_ZPCIOP_REG_AEN                0
-#define KVM_S390_ZPCIOP_DEREG_AEN      1
-
-/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
-#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
-
 /* Available with KVM_CAP_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
 
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index ef3810d..a820849 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -240,7 +240,7 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
 #define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
 
-struct __packed virtio_admin_cmd_hdr {
+struct virtio_admin_cmd_hdr {
 	__le16 opcode;
 	/*
 	 * 1 - SR-IOV
@@ -252,20 +252,20 @@ struct __packed virtio_admin_cmd_hdr {
 	__le64 group_member_id;
 };
 
-struct __packed virtio_admin_cmd_status {
+struct virtio_admin_cmd_status {
 	__le16 status;
 	__le16 status_qualifier;
 	/* Unused, reserved for future extensions. */
 	__u8 reserved2[4];
 };
 
-struct __packed virtio_admin_cmd_legacy_wr_data {
+struct virtio_admin_cmd_legacy_wr_data {
 	__u8 offset; /* Starting offset of the register(s) to write. */
 	__u8 reserved[7];
 	__u8 registers[];
 };
 
-struct __packed virtio_admin_cmd_legacy_rd_data {
+struct virtio_admin_cmd_legacy_rd_data {
 	__u8 offset; /* Starting offset of the register(s) to read. */
 };
 
@@ -275,7 +275,7 @@ struct __packed virtio_admin_cmd_legacy_rd_data {
 
 #define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
 
-struct __packed virtio_admin_cmd_notify_info_data {
+struct virtio_admin_cmd_notify_info_data {
 	__u8 flags; /* 0 = end of list, 1 = owner device, 2 = member device */
 	__u8 bar; /* BAR of the member or the owner device */
 	__u8 padding[6];
diff --git a/mips/include/asm/kvm.h b/mips/include/asm/kvm.h
index edcf717..9673dc9 100644
--- a/mips/include/asm/kvm.h
+++ b/mips/include/asm/kvm.h
@@ -20,8 +20,6 @@
  * Some parts derived from the x86 version of this file.
  */
 
-#define __KVM_HAVE_READONLY_MEM
-
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /*
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index 9f18fa0..1691297 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -28,7 +28,6 @@
 #define __KVM_HAVE_PPC_SMT
 #define __KVM_HAVE_IRQCHIP
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_GUEST_DEBUG
 
 /* Not always available, but if it is, this is the correct offset.  */
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -733,4 +732,48 @@ struct kvm_ppc_xive_eq {
 #define KVM_XIVE_TIMA_PAGE_OFFSET	0
 #define KVM_XIVE_ESB_PAGE_OFFSET	4
 
+/* for KVM_PPC_GET_PVINFO */
+
+#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+
+struct kvm_ppc_pvinfo {
+	/* out */
+	__u32 flags;
+	__u32 hcall[4];
+	__u8  pad[108];
+};
+
+/* for KVM_PPC_GET_SMMU_INFO */
+#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
+
+struct kvm_ppc_one_page_size {
+	__u32 page_shift;	/* Page shift (or 0) */
+	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
+};
+
+struct kvm_ppc_one_seg_page_size {
+	__u32 page_shift;	/* Base page shift of segment (or 0) */
+	__u32 slb_enc;		/* SLB encoding for BookS */
+	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
+#define KVM_PPC_1T_SEGMENTS		0x00000002
+#define KVM_PPC_NO_HASH			0x00000004
+
+struct kvm_ppc_smmu_info {
+	__u64 flags;
+	__u32 slb_size;
+	__u16 data_keys;	/* # storage keys supported for data */
+	__u16 instr_keys;	/* # storage keys supported for instructions */
+	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
+struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+};
+
 #endif /* __LINUX_KVM_POWERPC_H */
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 7499e88..b1c503c 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -16,7 +16,6 @@
 #include <asm/ptrace.h>
 
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
@@ -166,6 +165,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZVFH,
 	KVM_RISCV_ISA_EXT_ZVFHMIN,
 	KVM_RISCV_ISA_EXT_ZFA,
+	KVM_RISCV_ISA_EXT_ZTSO,
+	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index a448d09..ef11aa4 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -7,6 +7,8 @@
  *
  */
 
+#include <linux/const.h>
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/stddef.h>
@@ -40,7 +42,6 @@
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_MSIX
 #define __KVM_HAVE_MCE
 #define __KVM_HAVE_PIT_STATE2
@@ -49,7 +50,6 @@
 #define __KVM_HAVE_DEBUGREGS
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
-#define __KVM_HAVE_READONLY_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
@@ -526,9 +526,301 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
-#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
 #define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 
+/* for KVM_CAP_MCE */
+struct kvm_x86_mce {
+	__u64 status;
+	__u64 addr;
+	__u64 misc;
+	__u64 mcg_status;
+	__u8 bank;
+	__u8 pad1[7];
+	__u64 pad2[3];
+};
+
+/* for KVM_CAP_XEN_HVM */
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
+
+struct kvm_xen_hvm_config {
+	__u32 flags;
+	__u32 msr;
+	__u64 blob_addr_32;
+	__u64 blob_addr_64;
+	__u8 blob_size_32;
+	__u8 blob_size_64;
+	__u8 pad2[30];
+};
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		__u8 runstate_update_flag;
+		union {
+			__u64 gfn;
+#define KVM_XEN_INVALID_GFN ((__u64)-1)
+			__u64 hva;
+		} shared_info;
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
+#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
+#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
+#define KVM_XEN_EVTCHN_RESET		(1 << 2)
+			/*
+			 * Events sent by the guest are either looped back to
+			 * the guest itself (potentially on a different port#)
+			 * or signalled via an eventfd.
+			 */
+			union {
+				struct {
+					__u32 port;
+					__u32 vcpu;
+					__u32 priority;
+				} port;
+				struct {
+					__u32 port; /* Zero for eventfd */
+					__s32 fd;
+				} eventfd;
+				__u32 padding[4];
+			} deliver;
+		} evtchn;
+		__u32 xen_version;
+		__u64 pad[8];
+	} u;
+};
+
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
+#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA	0x6
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+#define KVM_XEN_INVALID_GPA ((__u64)-1)
+		__u64 hva;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
+		__u8 vector;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
+#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
+#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA	0x9
+
+/* Secure Encrypted Virtualization command */
+enum sev_cmd_id {
+	/* Guest initialization commands */
+	KVM_SEV_INIT = 0,
+	KVM_SEV_ES_INIT,
+	/* Guest launch commands */
+	KVM_SEV_LAUNCH_START,
+	KVM_SEV_LAUNCH_UPDATE_DATA,
+	KVM_SEV_LAUNCH_UPDATE_VMSA,
+	KVM_SEV_LAUNCH_SECRET,
+	KVM_SEV_LAUNCH_MEASURE,
+	KVM_SEV_LAUNCH_FINISH,
+	/* Guest migration commands (outgoing) */
+	KVM_SEV_SEND_START,
+	KVM_SEV_SEND_UPDATE_DATA,
+	KVM_SEV_SEND_UPDATE_VMSA,
+	KVM_SEV_SEND_FINISH,
+	/* Guest migration commands (incoming) */
+	KVM_SEV_RECEIVE_START,
+	KVM_SEV_RECEIVE_UPDATE_DATA,
+	KVM_SEV_RECEIVE_UPDATE_VMSA,
+	KVM_SEV_RECEIVE_FINISH,
+	/* Guest status and debug commands */
+	KVM_SEV_GUEST_STATUS,
+	KVM_SEV_DBG_DECRYPT,
+	KVM_SEV_DBG_ENCRYPT,
+	/* Guest certificates commands */
+	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
+
+	KVM_SEV_NR_MAX,
+};
+
+struct kvm_sev_cmd {
+	__u32 id;
+	__u32 pad0;
+	__u64 data;
+	__u32 error;
+	__u32 sev_fd;
+};
+
+struct kvm_sev_launch_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 dh_uaddr;
+	__u32 dh_len;
+	__u32 pad0;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad1;
+};
+
+struct kvm_sev_launch_update_data {
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+
+struct kvm_sev_launch_secret {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+struct kvm_sev_launch_measure {
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_guest_status {
+	__u32 handle;
+	__u32 policy;
+	__u32 state;
+};
+
+struct kvm_sev_dbg {
+	__u64 src_uaddr;
+	__u64 dst_uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u32 pad0;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u32 pad1;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u32 pad2;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u32 pad3;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad4;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u32 pad0;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad1;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+
+struct kvm_hyperv_eventfd {
+	__u32 conn_id;
+	__s32 fd;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
+#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
+
 /*
  * Masked event layout.
  * Bits   Description
@@ -549,10 +841,10 @@ struct kvm_pmu_event_filter {
 	((__u64)(!!(exclude)) << 55))
 
 #define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
-	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
-#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
-#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
-#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+	(__GENMASK_ULL(7, 0) | __GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(__GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(__GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(_BITULL(55))
 #define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
 
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
@@ -560,7 +852,7 @@ struct kvm_pmu_event_filter {
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
-#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+#define KVM_EXIT_HYPERCALL_LONG_MODE	_BITULL(0)
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
-- 
2.34.1


