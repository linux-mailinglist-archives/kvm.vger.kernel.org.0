Return-Path: <kvm+bounces-51607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED429AF9713
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 17:39:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C9687B5724
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 15:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6347303DE9;
	Fri,  4 Jul 2025 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="cR7jjLLa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0BC2DE6EA
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643542; cv=none; b=d8OJ2SSjXDcxtq1uE3+l0am6SsKmFjEL4aPTMSJ9fs7Y+z3r2RPzKp3kIvpt4alkhjcjc2LLgHZehXjnvIq9PlLDURIxJ1zTPbLsza+9ANPOeRmOu+4Ea0gDK3Ld5VycWAAI+fVIxdRIQgoKKaw+EQs3FDOkwrmJ0Zeyv9E8xaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643542; c=relaxed/simple;
	bh=cezdU2bQL4U/SmpjZpHsgWLGnEQHdGGqsWftSuehstM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTHLSDUZP7Tr2AGUQy41zn2KEJ6z7ZpH/275LukR+Z+8HwMae9J4iZn7jhkxP1exs4uLtK2Iygz2wudhgmcKFrvsaSwr4ErrKXD8gNM7Rf8JFQMKO5HfIzOvbttTyaxAh2vJpwTOGVjm3wqaMci2gc/+b1JhDM829x4gBchaCbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=cR7jjLLa; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso1377593b3a.2
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 08:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1751643540; x=1752248340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGu8D5CO2g4ATuM30TaqWjSMbmUsVDtUpJDi7E1Auq4=;
        b=cR7jjLLaqLUdLRnaQ6AEWpLsmiBpJi+O9D94HIw1h0HbcusZux+xTSTdWEjWLIz9wt
         fQY9otN6JpHEdlavvwsTB683HPosgz7PhVtlCymsD24o+CsY6F3KR0IXPgxiDfj7thf6
         uGDhiftkBXZTvYEtPjHR026/4WHHPw/yo7dmLCt5gm7jAzETEf0kzHwpa7p6TA8DxKU6
         jb5hU0hqL21l3XIg2YqAwjB56+IOtgTmzP0mYfLNNiuIQXjZ0/6lahqpWIKwgH9w+PTf
         l9TbgzuF034XEil6vwpuTILqtcpTqpXqOGDfALPdOTTsb7+Jjgezrb8byW9iRwpPrP6b
         oF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751643540; x=1752248340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EGu8D5CO2g4ATuM30TaqWjSMbmUsVDtUpJDi7E1Auq4=;
        b=JFT4c2qlJwXU2wAdIB8RwbPB9jsuAnItxZaG/ThswpRh2LVC8RJKZ/3Qz7Rg35U1hV
         gfhXMwv26mkQXGyX+/yoFpS9vWayfC/4P5w2dyJ7/sO0kNNRZMmVA0S3+mUtJfn8bFUU
         nosBvFe2khMgil2eZlce5LVMqGIhW2EB3dt2FYPUnP5tvPLZeEzz35EL7zNLbmi76N0Z
         xgMnL/xx/KIHDEivAtqy/3MTiJF/ULFLGynMQWCeVZyGi4K123EapH5h/t26gsVpo359
         hsxXMr2ZttxKWU9jKUt82a9JFPifC6XQ6J6+vJw00NcOD+dw31q6g4lrmdeB/BuB5o9K
         cM6A==
X-Forwarded-Encrypted: i=1; AJvYcCUanoWsyTJFTvq3HSxrZT4TNrT64SSKFJTCkIKw8FgGflQItNcBcuyMnrfR77hu4RhqUKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPlinZIWP9m+1TiIIJPbSGXPjVz81+Jp/sP0kkONz6YFc+tiaP
	n9yyO5qx8jKKzHIcqUrcTf57YuzHhyfZQdVXBfh3OM81fOwRE6Bu//cPfhrvYiyJBe0=
X-Gm-Gg: ASbGncto0sw9N0BNwVhjKO9lbqUiIh37R8MhnJj/E9+IqtCLizp3wRYmvaI4TrdVrfd
	M/9BxJuIszfHYe7AdDlv5Oh1Jr0Es/uYAUKTKuM7p/ZO+eECGZ7u+KgFZeRmAUHt81Ftu1IAhtt
	OuTlRy4xvYJf9vHhlIQEJb9fv+gWfImVao6AUXfXCNCFG9hlo1xWTrT3i/Pl8dYV3NmAmhGkX2L
	05jWHL0xZh5yNGQo6OeW6xlbY0+QN1G84FpGl78nTyFW+0WRJvhpuYRi2726w1yC8Lx+LoD3lE+
	BzwOONHnDKiOoZlCEofnaawqSrAcSZsO6l59BZ/PooGYPUasH78T4gBQU5yiH2ZEZXEIYMCw1To
	8vjg4rganqCwjr+VyIdg=
X-Google-Smtp-Source: AGHT+IEy5K6TN3PEoTMk39/X767PpUlO+bEGeE+f/+6Ff0hJG+gUrinbRE67z7eLIyDgw9OeZ6XYHA==
X-Received: by 2002:a05:6a21:a8e:b0:220:a3de:a083 with SMTP id adf61e73a8af0-225b85f3eafmr5148507637.10.1751643540342;
        Fri, 04 Jul 2025 08:39:00 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38ee63003bsm2084818a12.62.2025.07.04.08.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 08:38:59 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/2] RISC-V: KVM: Move HGEI[E|P] CSR access to IMSIC virtualization
Date: Fri,  4 Jul 2025 21:08:38 +0530
Message-ID: <20250704153838.6575-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250704153838.6575-1-apatel@ventanamicro.com>
References: <20250704153838.6575-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is one HGEI line associated with each IMSIC VS-file on a host CPU.
The IMSIC virtualization already keeps track of the HGEI line and the
associated IMSIC VS-file used by each VCPU.

Currently, the common AIA functions kvm_riscv_vcpu_aia_has_interrupts()
and kvm_riscv_aia_wakeon_hgei() lookup HGEI line using an array of VCPU
pointers before accessing HGEI[E|P] CSR which is slow. Move the HGEI[E|P]
CSR access to IMSIC virtualization so that costly HGEI line lookup and
potential race-conditions when updating HGEI[E|P] CSR can be avoided.

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


