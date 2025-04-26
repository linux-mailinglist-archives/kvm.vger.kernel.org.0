Return-Path: <kvm+bounces-44401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B9DA9DA48
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1222C9A273E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E3B223DFF;
	Sat, 26 Apr 2025 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Hr7JTAZs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2F01E519
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665445; cv=none; b=DIqnhzgOCQ4Pwm+f573MGa/sfkKsstm8KfrIJ+w0CmYssWNBx6Me+u53Vk5di69fpHxPjltW7ZWCyS+DM+IWumjSK2ablymGfoF9w/0U5U5eHtytinTyYgcXzX/56trfFLMWcV6SrreENTGTQFv22+iyrm4MB+3GJp6eGvSjuW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665445; c=relaxed/simple;
	bh=Ucbg3E7i3MZwWYjyL1vcEheaNviswYua+9AIX2CHzLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OImyIMlsEn0HGdz6QjcNBb4BxeZ/7ANAM8jjOJhZ3p7KuMYD4UbRkYtYQM6azUGhLzUPns2zTcv30Y4gWIXAcJMn56pTMemrXW5DV7bdyb5ZbqBvD6EC841gff/e4inibJGrh7cuuZOi6KChIcyIFh9AmSk1Cjy3qWfABcWTdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Hr7JTAZs; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-301302a328bso4441715a91.2
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665443; x=1746270243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KosB5ZgKDG2GT/pwZox4H0XOpN/IyUSJojX16UBufxk=;
        b=Hr7JTAZszp3f4NZx/7wpSn4MvcKD51qXn/IC0pvfppuEulLvnWZMg/L1nTQOY6wYa/
         gJYMruXhMUghv3LH5r6HD3mC/sTDHPOmgK5Qq+uOqM3yySIhazpNAQRhDQ27qRvdmbLO
         4xvxbUFQtm/+1h+8Q5auWh5KUHNtPIbhHGcJQKVo3cMMMMmbQuZT21Kmpi94s7P5n0FZ
         ff0qLwIqiiiPI2FKwTe21xTObrdVRbaYmhaZEk6HuMLwXUWvxX0eb2S/Lj3Rsx9++/c+
         FvSIx806EmeTZ9vil7xAdl8NhDX8dpOeLLZsbRPva4ZaEvb46strRg5Ls7WFo6zfv/Ac
         aO/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665443; x=1746270243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KosB5ZgKDG2GT/pwZox4H0XOpN/IyUSJojX16UBufxk=;
        b=XDQfVhk7K7+1v+zPCtk83PK2MZKOQe0OAUwaHJccJHqSaQjiXCMfJDL3utR/gd3Bk+
         usYLCwA7B7uSDpcJKxom467DohLShzAMwmX3M3uZN/o3enj2/jUqAC9VtxsmgTWqcba1
         8pTxkyU6Lwo+1VNugXF8fj3qYLWGZW2ika2Po1f9PE6QfxIIcv8UoMjNByzCHHXPss46
         FJJk4ratb5rcU8MzaD6YCc32kW0nKA/5NQmVGrviRzT4dgjqQgzHfI6IwYlpcFYfrKK/
         ZN7TayUuWh6QWxjuLDQxfTD2w7Pvqb8jJYLpwOVoK382+raXx3tRSewExiM1gnOGVtLg
         LvfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWh/Q39rBYhZhuwlD4Khd/za31GRK2BsRkgse1iOYsCgaYHuK7hm4TvtBDW0dDhYz/TZ1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIhc9Br4WQ4jeLtZEmJZIpNF/3BpCJSQHAfmyKosDKDGk61kWe
	9IezOgyaWcFfHihayok2uQZsS7G537LGt93plIdENNrJaC+IocSfp1nCdn8vh1I=
X-Gm-Gg: ASbGncuBW11HubigJYy+pImoP2jUSmEITpZxnwM2fga0t335+EKR60H+M9T94CKmzu+
	zWTywRfNDDZQpojCKS1eNIT5bAXyFb0WEF2SkIhNRiTRpApuiJN5op11cWthbdV6Ze2pQSrpHfr
	5CJcFGgLrbFrkuQjhpEWrFX2PKVx/CuH8QZrXfQe7S6m+ht/wFqL48BalSIc2thGL254kKzzu6G
	MS/m3pJhrbcDf63ChSqMhzTuF1Ve2lslOXJ8PC42nZWGHq2c8QRls5BQYHFFBm5aZSmSbCtMtm9
	t1b6H8WOfV8XWgzfK84e+BkhU6vq2TE1f2Zw5AV4ClFFTG8wQ2DVv9ps0cTBzBUf0/rG6O8NBrh
	zSrtH
X-Google-Smtp-Source: AGHT+IGAfyrCkQFHH/yoCf0uzQ8ItQRlM5Gw9a1UYmbefrBes8PbO9i2PmAJYcaSCWg0jeYyrvqVlg==
X-Received: by 2002:a17:90b:3a0e:b0:2f6:f32e:90ac with SMTP id 98e67ed59e1d1-309f7dd8a1cmr8809821a91.11.1745665443498;
        Sat, 26 Apr 2025 04:04:03 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:03 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 01/10] Sync-up headers with Linux-6.14 kernel
Date: Sat, 26 Apr 2025 16:33:38 +0530
Message-ID: <20250426110348.338114-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
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


