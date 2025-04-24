Return-Path: <kvm+bounces-44186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FDAA9B25B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F786920FC2
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874081A23BB;
	Thu, 24 Apr 2025 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Tldnpmd6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EDD1B0437
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508735; cv=none; b=Vfp/8mu4Ek7D1UX2OkV9zKydkP9OVWT/vlwvmat6D0nZScehLGM7qgENfMZHUS2QC5mFjHhXt3Z0ChAN9aNvEkDSv4jEyJ5WL9Q/wr5sFJQJ8OxqGZY/cRtsar2+j/01NBdI1yhZz2IUruZjASQ3JElYwZXJ06RH/xtiiNDyVus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508735; c=relaxed/simple;
	bh=Ucbg3E7i3MZwWYjyL1vcEheaNviswYua+9AIX2CHzLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luKSY1Wu/w07MarDgOvdTrYma8QN4zcQVAY3K/U33+UQZC4MItIH0rdQQJPONp12it+AuBqqit+hk4hQBUDzecOMhATvbAu1OsjJqFP2YzxYSJWDR3Rkd0aoUpibYfhtoQ6R5ctncJ8ykA91kwZSk9W2BK0B6/rfMsjzcYE7LsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Tldnpmd6; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-736b34a71a1so1383317b3a.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508733; x=1746113533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KosB5ZgKDG2GT/pwZox4H0XOpN/IyUSJojX16UBufxk=;
        b=Tldnpmd6vcYpJTn8Cp10hu+8PBLC47aZLYjS4hzOqprmMyWBI5VajVzbwC3XFdbDB+
         2qRi47gEWH2PwdvEvBPAC/rEOTK2DWN/wxQteJmIO2ncznTE+Dr5jxUnYw2pX8VxcivA
         mZcJPFyOqWnaI/+41GMiFBQ+xMx/GDH4xfUXeM/gNKrYmAINg9QrvP2FIkk7vRMmktb4
         xmRi5FNA3aylzoiVxq2EjWLzUwChRKk2duqy5DXdG/XIi4ngqu5BsZfoFujDIzmYCxd8
         ulhBY1rLCXkKlfpCFFOzBn3VXwiPcKp/5LZgS6pqb/YvRBxZnIDIR7lWkSl8YWrrBPbU
         FBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508733; x=1746113533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KosB5ZgKDG2GT/pwZox4H0XOpN/IyUSJojX16UBufxk=;
        b=RLSYP98hcCd8+9ZcNg8cZ8bOP3j+dUtATDWMIAT+rQF1zB7KvBDbGKXall1W8d61xm
         IigtiAr+OjqiJEskUvaFHB4Hle+quu9Q993c0RPVBEm+w3VOwPKUpSHcHdtXn3pBQCqv
         dmV4/lMsUhSPCw90ncTqj4CGOyiKyju559wP6rScfrICTBwxwb0UdiGvSDN/Q0cYnEIW
         KnimTfIvYJ6qxOhL0G3pn+lkTio4xHlHteYDg8MED/2hIVH3KPRdNZAjqHE7ZSYFIRbZ
         WQY5ob2m0lJyvt9S6wAwumXvRsbZw9P7zzkAEKd4Bdavh30pr5El5zO+E4Cz8avnFsVw
         DgsA==
X-Forwarded-Encrypted: i=1; AJvYcCXyrXVv6h9nKyUZ7sJ4ggWrRCnzRJ5mVAkalthxLIft6k0URD3y8+glnEIghL8xBQAg8VA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpJdmLaW+pL7i5ZIRIWk9Y/8duFP2qFnTHK24pjK98kwouJaYV
	TJRsXTr4NEoz8sYQbE7WLMMaXd+R0HKtyaPgxdKoYV7W0cM1amk8NDub0FfWdQ0=
X-Gm-Gg: ASbGnctwO14QIDSe7NWhssiO9zCYkz0sAscghlkdn+ofAdG9hJrBuZt1P3hUnAcVbWq
	AJOF1lmvAOt7b5PlVCxWaCpeu0mu9alCwaKQaa7PL2APA0dIoBWVfbEaXzVWdTYyhY8PsqKyOym
	FvY2mgPiiaPM9loxf9lmVaFLhF47aSBuT0rYNIbhywZhwi6Grz7geLs7H8bvjYcGa/mvXRI05ch
	xJYQqcjTK2vHqB8bVq8ij4CG8UpOnBnQEn4QTparZ9B4FBVRs15S8T71AGCSqZXGKMpvKhWGeES
	D/c3tgcBJRnQ4QQxPHHGTqHFiJdIDcQTuSiFp4KJU+jO1W+eF5gQJ2bo26jBOuSP09s6MWulmq+
	WJV0rYAremdLnyCo=
X-Google-Smtp-Source: AGHT+IG/fjJRFAZc1F/U7WUvrAgadtxqffvxRh33xTuPAQ9Z9YehChN+iK2lWhURInGWDQbiRKcNqg==
X-Received: by 2002:a05:6a20:9f46:b0:203:ad33:1ae3 with SMTP id adf61e73a8af0-20444ee397bmr4762728637.10.1745508733155;
        Thu, 24 Apr 2025 08:32:13 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:12 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 01/10] Sync-up headers with Linux-6.14 kernel
Date: Thu, 24 Apr 2025 21:01:50 +0530
Message-ID: <20250424153159.289441-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
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
 arm64/include/asm/kvm.h    |  3 ---
 include/linux/kvm.h        |  8 ++++----
 include/linux/virtio_pci.h | 14 ++++++++++++++
 riscv/include/asm/kvm.h    |  7 ++++---
 x86/include/asm/kvm.h      |  1 +
 5 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index 66736ff..568bf85 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
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


