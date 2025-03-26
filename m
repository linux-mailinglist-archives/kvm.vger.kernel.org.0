Return-Path: <kvm+bounces-42021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F3FA710DC
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:57:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA79C3B90EA
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5B71991B6;
	Wed, 26 Mar 2025 06:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iMhVu/ZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238D317578
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972221; cv=none; b=ds9PcOtafNa5nyf6LOO+KLy89FYWUZ9tFTYmPIO//JPnzQBbs5/imCSO6Sl3T2gjfcx4Ph5j4RfdJzsn6Mkov4BeG5OVGPYAZo45HGD7KnJ6EI9PWxTjkU69zG/az/yFd08/39vuyNE88Tw6xhmpK0+y5CPaWUWnQBPc6vEEKs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972221; c=relaxed/simple;
	bh=FpIjztZFrgmXz45qTQ6XXvq6Nz6sk0eQiKgxwa6ytd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcOWJzEhJjvMPgdWEdwv1TnmyU0B4O9Iza6s25b9gPf/LD1Cl7/epRLNbqiuI3rLFQ6c0VmpVntNC6v0B/0jZ71RUHXj/VwGIamRZb7oZKFM7/DeHN4m+eP25IRYKh+CgX4yHYkJ+cEW8rBQa65wDIFNR1t70PtIdnwBLpYsb6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iMhVu/ZZ; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22622ddcc35so11232955ad.2
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972219; x=1743577019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c57jI5pRh7M1URIQaAfsM++KrpcwjMDHmdbLiR48JuA=;
        b=iMhVu/ZZZDw9AxTWIrEF5BNEX9tpZMy6drxBTl+uMn1cXh/A5Hh1l+YshDR8x5zT9O
         oiMXTuGrV4yLdJlEZzPHeBSie4reNd7lUP3apJZHUb0TTI38VF014VZjSfa8bWWd840B
         h5e3PAhr6nFQyAhck8r8YqdrXkhTpQSA25edsrbq0lEELjiaHlRrhijmMZpwbGx6wv6S
         P2+cJNpCQdpY3GPvIAdUEW4L9IMYiTP5Cnqmin2FjZCI8k9thty3DF6W4C0HXqxN4u9G
         IS+/y9OVU+vIeNmeFuuRdxW+0Pnd+NcR+mvVgpnGso7pb0ftgB6wlTTMs+1j25puQSWt
         mUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972219; x=1743577019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c57jI5pRh7M1URIQaAfsM++KrpcwjMDHmdbLiR48JuA=;
        b=Of8UQrUIRm3NzCEiDVy11Y2vfa0SE2noEhykuGeOHw5l3sT+XjKNfwu8kg2i22If/0
         zF/QRWDvUXJnJT9jkZwvg2VUUX3M8uVLe1hrXgYneyrG7frd10g20yxB/zdu9yelRIoF
         F6uIMKznUxKmcqX9wL4AI5d3kOM7vvmhIWJELFfPlVnHXU6FttmDzOq6+gXjXyEnFKCs
         2a5r/2tajf5a7rwtxPE8L9GG+ptdKwLLxaScfw7+8oO4KTvkGyV23D+u+BpIQhLaFVp7
         9v3Ol0xH5t8nY+irowKQrnRe0xbhcWTbYFCP/qMai7m7GKNWF845vDDF4AlRx4c7gilx
         ysXw==
X-Forwarded-Encrypted: i=1; AJvYcCUhZBX2Nmjf4oNhvxE5sGl2R3rvFSqIe0aaXBLtl0w8mkHIKva5ooJzWIPHsZfwEwshEzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAvHilqk2t3mvcf4KcuaKQq4ybxXewaZCjVB2Aq9Kze6unUcni
	/NNQyAbtRo0ZMLYompMC66GNiKTe47fFSzsWV9Ev3oa3txYYk9mEHhGOlg0yXF6OuJ57tGxV6so
	v
X-Gm-Gg: ASbGncvhMZhjRGr82Zh6KZsf6eAnJ7zIw5wdkVOHg7Iyw2Atd56nleS5YPsaXQcSnui
	UrufSfT9wc6xFYbCg06U4jfZy2pt8QUcvtEUBjp0QRUcJh2oD8rHUDHhPKuZ1MbKfr2EMLmFl29
	FnJUH3W9OUx4MORgreNaeQUXjTY1A7n6YU9P8hI+uBCnWL0BDE1UYIp+Oioj+a1Vu5e2/W5osmc
	x01ravyo4VvVAPWbDkjkJeY4ODcuVVi4J7jlr1YYw7zoB20d6eKXDeDMGfeSfZfnyR0cIW9EOYD
	nqPPmej6T2MA0YYg5jP/mwyzyP9eBdkwD/m3SDcnxiFfWSlgq/M5zcyHQV2KCUvkZ898lQx1qDx
	uG/rILg==
X-Google-Smtp-Source: AGHT+IETcnyhYHBTogDJh7RcGANfUgL6TqZGlc9sjLBEKj5xN3He3kdBXTPl8inCEMI1FxRFDEYcwA==
X-Received: by 2002:a05:6a21:900a:b0:1f5:6680:82b6 with SMTP id adf61e73a8af0-1fe43437130mr35906975637.38.1742972219229;
        Tue, 25 Mar 2025 23:56:59 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:56:58 -0700 (PDT)
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
Subject: [kvmtool PATCH 01/10] Sync-up headers with Linux-6.14 kernel
Date: Wed, 26 Mar 2025 12:26:35 +0530
Message-ID: <20250326065644.73765-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
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
 arm/aarch64/include/asm/kvm.h |  3 ---
 include/linux/kvm.h           |  8 ++++----
 include/linux/virtio_pci.h    | 14 ++++++++++++++
 riscv/include/asm/kvm.h       |  7 ++++---
 x86/include/asm/kvm.h         |  1 +
 5 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 66736ff..568bf85 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -43,9 +43,6 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
-#define KVM_REG_SIZE(id)						\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 struct kvm_regs {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 502ea63..45e6d8f 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -617,10 +617,6 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
-#define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
-                                              KVM_X86_DISABLE_EXITS_HLT | \
-                                              KVM_X86_DISABLE_EXITS_PAUSE | \
-                                              KVM_X86_DISABLE_EXITS_CSTATE)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
@@ -1070,6 +1066,10 @@ struct kvm_dirty_tlb {
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
 #define KVM_REG_SIZE_U8		0x0000000000000000ULL
 #define KVM_REG_SIZE_U16	0x0010000000000000ULL
 #define KVM_REG_SIZE_U32	0x0020000000000000ULL
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index 1beb317..8549d45 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -116,6 +116,8 @@
 #define VIRTIO_PCI_CAP_PCI_CFG		5
 /* Additional shared memory capability */
 #define VIRTIO_PCI_CAP_SHARED_MEMORY_CFG 8
+/* PCI vendor data configuration */
+#define VIRTIO_PCI_CAP_VENDOR_CFG	9
 
 /* This is the PCI capability header: */
 struct virtio_pci_cap {
@@ -130,6 +132,18 @@ struct virtio_pci_cap {
 	__le32 length;		/* Length of the structure, in bytes. */
 };
 
+/* This is the PCI vendor data capability header: */
+struct virtio_pci_vndr_data {
+	__u8 cap_vndr;		/* Generic PCI field: PCI_CAP_ID_VNDR */
+	__u8 cap_next;		/* Generic PCI field: next ptr. */
+	__u8 cap_len;		/* Generic PCI field: capability length */
+	__u8 cfg_type;		/* Identifies the structure. */
+	__u16 vendor_id;	/* Identifies the vendor-specific format. */
+	/* For Vendor Definition */
+	/* Pads structure to a multiple of 4 bytes */
+	/* Reads must not have side effects */
+};
+
 struct virtio_pci_cap64 {
 	struct virtio_pci_cap cap;
 	__le32 offset_hi;             /* Most sig 32 bits of offset */
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 3482c9a..f06bc5e 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -179,6 +179,9 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SSNPM,
 	KVM_RISCV_ISA_EXT_SVADE,
 	KVM_RISCV_ISA_EXT_SVADU,
+	KVM_RISCV_ISA_EXT_SVVPTC,
+	KVM_RISCV_ISA_EXT_ZABHA,
+	KVM_RISCV_ISA_EXT_ZICCRSE,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -198,6 +201,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
+	KVM_RISCV_SBI_EXT_SUSP,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
@@ -211,9 +215,6 @@ struct kvm_riscv_sbi_sta {
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
 
-#define KVM_REG_SIZE(id)		\
-	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
-
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 88585c1..9e75da9 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -925,5 +925,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
 #define KVM_X86_SNP_VM		4
+#define KVM_X86_TDX_VM		5
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.43.0


