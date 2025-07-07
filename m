Return-Path: <kvm+bounces-51645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BEBAFAA71
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 05:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B103B2660
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 03:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929AC13959D;
	Mon,  7 Jul 2025 03:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Wofb4n6b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3320D25A2CE
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 03:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751860446; cv=none; b=nFh30dFA8cUKrsb10kkauwxNomWz0fgSHi5LNA/Ic7r4/xDdbqQZ3K7gmJY5R856Edvcci1o7JXzT3NfSvKP20DabHGx21DjBOYAe7G7AzmE8JQiqTpb6EzEwFZLUg9Bk/0JJ7dq0r2Y1LW4XuSKgqSBOwgx+4jY1ef1gN+O+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751860446; c=relaxed/simple;
	bh=7Uk9OAd7smP0dqj86QAPUUBb3gP4XU+VQr7d95v9yv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+J3wGI5DvKXjAJyajuWrJx1DnGK4UGz6YQvJY854XpMzUheY2O01Qq3cTlHRqMGb3CJiQhycNi6HdTPAu6fOozkWC569oMixsBQi7I7hk0tZ7BMSR0Wp6qv8HQwNXFiokB1o7hJQRYfyW/ZO25eVXr/8jRrL7akkHWH8L43wZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Wofb4n6b; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2353a2bc210so23446865ad.2
        for <kvm@vger.kernel.org>; Sun, 06 Jul 2025 20:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751860444; x=1752465244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fh2AJt0yoZFTrEfJ+nsZtn9P0jIR9N+wVBorJAiW1uA=;
        b=Wofb4n6blFt0oMo6BF1AimpxibLIXCX6ipZ8jrWRJPkB/Fe8t4uBBf4UWeTM2N9Kus
         iJXYfOUdJICn24iwOJyCvC9YBgJDiG5NlGBJ3DptGJtVn36Q2WIKGMy8bQ3BANTzjAPr
         r+sSol/QJ8shdD33f5hRYsuOx/FCQaAl1Ets8Eql9dmG0A1PJcoa7UIJQAUjYjbeQKhU
         W51gOHgKhCqa/vzHqIAiFMaVLBj5zjU8KoROQG9up7qASCiB41Z/sP5Qb2g6U/DpMro6
         yMedEJcIwPODZh5xKOrrX6WqW3rKU+4INcQdosjbKk1KhSI6zjoTIxTZfm5cvgf0UoIj
         Wulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751860444; x=1752465244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fh2AJt0yoZFTrEfJ+nsZtn9P0jIR9N+wVBorJAiW1uA=;
        b=Vx27k+evMXsHejrOneI4bnpkic2MudfSEHyeDTxpOHdMMDC/uJkopiBr1mkPJpqJUe
         +0+m4XEYfGMKYQvtkMbf3/ORmxEhXVJYybfXtzDM1uEGHpQRTcfiktutdfuR6a2k7YZ5
         +hZBreKplThdBM8OYYEaVx3udGOPziVy5660rWMkYN4q0RRVqYIQZXHEk8b90GyxIv/d
         ORFXJvX8EvsusCrNvmoeS6ERuvPQ0wclJgNRMZRhq9yZmkG97KHskq6BmwdXeRUfyQfy
         +k+lZZNqxHLpR4jhw7jJ+6zobUEahswvoq28IR7av86zDWZczlBi3H1G7gT7okzxK+nD
         w6vQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEXR6enPgQ8l68cY9WTa56q1jhwJSHd+iCtm3ypTTBfwALS6VFUK/0Rpk7ztCOy7Ihx68=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCfhpRSXn6tbDkwXLmPr63dUqi6YIitP/FI3oho+7QZfOpsMLY
	tSnhzQkuvTE2uafA8+uRTQSdFo6XcBfb++BcrcHZIAPhkT43cj+oCVLuWofKn25mr4Q=
X-Gm-Gg: ASbGnctGZ/NlW5fr+OnJfASc18Vz/Zb62FAFJ5Ybc169IdWEG6d0Uj+0ITr1DE8xo3j
	yY+JGE5b7LmqjMtDw/bT2cmUTC6TMptgzvVMI+eeILiN4ucClgKc12luSnxdPBCm85izFKTFuU1
	4BS9fL2XRR1CnVqtI0GRq1qgKFTBOvmKZlZ/Uw2512m5zWc0/Dc0I2nQ4A7S/BStMeQwItSheHr
	pKRVKsPLfmk9efp9X5S0BEmejdOTVwMEpE/xrb6hlbSFoXYexEYALnbFU755qfKL86Ac89sS7L8
	yz/hwL/KAl8n37vUQ2ybWAqMTFj1aTufANsqMTrHwxR0xdEy7dmvZTEAcERpsMD711cnAwx5XEy
	EFNWahvk3nl9DFh3Cuag=
X-Google-Smtp-Source: AGHT+IFe82d6BHmBOo2M+2ls1e4A5K/eZXQL9BtmwHX6jMWuif2aGFAVvqblJlwRZZSbrmPBr5HHVg==
X-Received: by 2002:a17:903:27cc:b0:235:225d:30a2 with SMTP id d9443c01a7336-23c85ec7329mr136803185ad.48.1751860444304;
        Sun, 06 Jul 2025 20:54:04 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.152])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31aaae80ae0sm8159137a91.21.2025.07.06.20.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jul 2025 20:54:03 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Subject: [PATCH v2 2/2] RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
Date: Mon,  7 Jul 2025 09:23:44 +0530
Message-ID: <20250707035345.17494-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707035345.17494-1-apatel@ventanamicro.com>
References: <20250707035345.17494-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the common AIA functions kvm_riscv_vcpu_aia_has_interrupts()
and kvm_riscv_aia_wakeon_hgei() lookup HGEI line using an array of VCPU
pointers before accessing HGEI[E|P] CSR which is slow and prone to race
conditions because there is a separate per-hart lock for the VCPU pointer
array and a separate per-VCPU rwlock for IMSIC VS-file (including HGEI
line) used by the VCPU. Due to these race conditions, it is observed
on QEMU RISC-V host that Guest VCPUs sleep in WFI and never wakeup even
with interrupt pending in the IMSIC VS-file because VCPUs were waiting
for HGEI wakeup on the wrong host CPU.

The IMSIC virtualization already keeps track of the HGEI line and the
associated IMSIC VS-file used by each VCPU so move the HGEI[E|P] CSR
access to IMSIC virtualization so that costly HGEI line lookup can be
avoided and likelihood of race-conditions when updating HGEI[E|P] CSR
is also reduced.

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Tested-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Fixes: 3385339296d1 ("RISC-V: KVM: Use IMSIC guest files when available")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h |  4 ++-
 arch/riscv/kvm/aia.c             | 51 +++++---------------------------
 arch/riscv/kvm/aia_imsic.c       | 45 ++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c            |  2 --
 4 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 0a0f12496f00..b04ecdd1a860 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -87,6 +87,9 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
 
 extern struct kvm_device_ops kvm_riscv_aia_device_ops;
 
+bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu);
+void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu);
 
@@ -161,7 +164,6 @@ void kvm_riscv_aia_destroy_vm(struct kvm *kvm);
 int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
 			     void __iomem **hgei_va, phys_addr_t *hgei_pa);
 void kvm_riscv_aia_free_hgei(int cpu, int hgei);
-void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable);
 
 void kvm_riscv_aia_enable(void);
 void kvm_riscv_aia_disable(void);
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 19afd1f23537..dad318185660 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -30,28 +30,6 @@ unsigned int kvm_riscv_aia_nr_hgei;
 unsigned int kvm_riscv_aia_max_ids;
 DEFINE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
 
-static int aia_find_hgei(struct kvm_vcpu *owner)
-{
-	int i, hgei;
-	unsigned long flags;
-	struct aia_hgei_control *hgctrl = get_cpu_ptr(&aia_hgei);
-
-	raw_spin_lock_irqsave(&hgctrl->lock, flags);
-
-	hgei = -1;
-	for (i = 1; i <= kvm_riscv_aia_nr_hgei; i++) {
-		if (hgctrl->owners[i] == owner) {
-			hgei = i;
-			break;
-		}
-	}
-
-	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
-
-	put_cpu_ptr(&aia_hgei);
-	return hgei;
-}
-
 static inline unsigned long aia_hvictl_value(bool ext_irq_pending)
 {
 	unsigned long hvictl;
@@ -95,7 +73,6 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
 
 bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 {
-	int hgei;
 	unsigned long seip;
 
 	if (!kvm_riscv_aia_available())
@@ -114,11 +91,7 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 	if (!kvm_riscv_aia_initialized(vcpu->kvm) || !seip)
 		return false;
 
-	hgei = aia_find_hgei(vcpu);
-	if (hgei > 0)
-		return !!(ncsr_read(CSR_HGEIP) & BIT(hgei));
-
-	return false;
+	return kvm_riscv_vcpu_aia_imsic_has_interrupt(vcpu);
 }
 
 void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
@@ -164,6 +137,9 @@ void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
 		csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
 #endif
 	}
+
+	if (kvm_riscv_aia_initialized(vcpu->kvm))
+		kvm_riscv_vcpu_aia_imsic_load(vcpu, cpu);
 }
 
 void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
@@ -174,6 +150,9 @@ void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
 	if (!kvm_riscv_aia_available())
 		return;
 
+	if (kvm_riscv_aia_initialized(vcpu->kvm))
+		kvm_riscv_vcpu_aia_imsic_put(vcpu);
+
 	if (kvm_riscv_nacl_available()) {
 		nsh = nacl_shmem();
 		csr->vsiselect = nacl_csr_read(nsh, CSR_VSISELECT);
@@ -472,22 +451,6 @@ void kvm_riscv_aia_free_hgei(int cpu, int hgei)
 	raw_spin_unlock_irqrestore(&hgctrl->lock, flags);
 }
 
-void kvm_riscv_aia_wakeon_hgei(struct kvm_vcpu *owner, bool enable)
-{
-	int hgei;
-
-	if (!kvm_riscv_aia_available())
-		return;
-
-	hgei = aia_find_hgei(owner);
-	if (hgei > 0) {
-		if (enable)
-			csr_set(CSR_HGEIE, BIT(hgei));
-		else
-			csr_clear(CSR_HGEIE, BIT(hgei));
-	}
-}
-
 static irqreturn_t hgei_interrupt(int irq, void *dev_id)
 {
 	int i;
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index ea1a36836d9c..fda0346f0ea1 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -677,6 +677,48 @@ static void imsic_swfile_update(struct kvm_vcpu *vcpu,
 	imsic_swfile_extirq_update(vcpu);
 }
 
+bool kvm_riscv_vcpu_aia_imsic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
+	unsigned long flags;
+	bool ret = false;
+
+	/*
+	 * The IMSIC SW-file directly injects interrupt via hvip so
+	 * only check for interrupt when IMSIC VS-file is being used.
+	 */
+
+	read_lock_irqsave(&imsic->vsfile_lock, flags);
+	if (imsic->vsfile_cpu > -1)
+		ret = !!(csr_read(CSR_HGEIP) & BIT(imsic->vsfile_hgei));
+	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
+
+	return ret;
+}
+
+void kvm_riscv_vcpu_aia_imsic_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/*
+	 * No need to explicitly clear HGEIE CSR bits because the
+	 * hgei interrupt handler (aka hgei_interrupt()) will always
+	 * clear it for us.
+	 */
+}
+
+void kvm_riscv_vcpu_aia_imsic_put(struct kvm_vcpu *vcpu)
+{
+	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
+	unsigned long flags;
+
+	if (!kvm_vcpu_is_blocking(vcpu))
+		return;
+
+	read_lock_irqsave(&imsic->vsfile_lock, flags);
+	if (imsic->vsfile_cpu > -1)
+		csr_set(CSR_HGEIE, BIT(imsic->vsfile_hgei));
+	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
+}
+
 void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 {
 	unsigned long flags;
@@ -781,6 +823,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
 	 * producers to the new IMSIC VS-file.
 	 */
 
+	/* Ensure HGEIE CSR bit is zero before using the new IMSIC VS-file */
+	csr_clear(CSR_HGEIE, BIT(new_vsfile_hgei));
+
 	/* Zero-out new IMSIC VS-file */
 	imsic_vsfile_local_clear(new_vsfile_hgei, imsic->nr_hw_eix);
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index fe028b4274df..b26bf35a0a19 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -211,12 +211,10 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
-	kvm_riscv_aia_wakeon_hgei(vcpu, true);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
-	kvm_riscv_aia_wakeon_hgei(vcpu, false);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
2.43.0


