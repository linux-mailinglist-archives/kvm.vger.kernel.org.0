Return-Path: <kvm+bounces-29220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0C79A5683
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB4A7B25A1C
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFC019C56F;
	Sun, 20 Oct 2024 19:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SN/SWH3/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B103B19AD87
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453685; cv=none; b=lnAXaB6nlWV4NqqNOFaM362zQDthmcoktBH2O60Jk6Q+gb/XFnzpg38GCxToIA0lPvmb4AApWcg+0W4NXA+yQQzyucy5KBAZPShSuwOot/rnjzdFU1qc7AmkTKXrLZ6iq7OzokqomxHwWgUI4dqJZ6KhT8J/8olMMJAq6r9agLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453685; c=relaxed/simple;
	bh=6Ws710PoAAvwNXc2iPqor0uTF1NrnxyfADVPvl1EQyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2Eazpvqn9WmLQ12E6YqAUpXVeQMp9BuuRRhff99OHfD/Dtb7z8kiKmJ4V+4MI1eJKiuQdhdQ0RxAwQDiBH00f1HaWUv0aT6H/rUd5sxV9xAAiG3LZqzrJelKCLtIpLPhpQrdsu8HeOC4N82PBAbw7l5ygcHUMlrPGZGUnb4/bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=SN/SWH3/; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7e9fd82f1a5so2507677a12.1
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453683; x=1730058483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KOSHWqnsb0W3cOOf6DyqEOJr3wAY0C67ufwSo4h3/A8=;
        b=SN/SWH3/38Zi486UqY1ji7eOLCyfus105fyCasRwMy+sTzpmHZYje9+8HEZ/e6G5Iv
         2EoFe+BPHlVDk4ZLMS6Jh25Cy1LToyCaO9E0L1N0OSSDkIN6w4v5C6qBRuHnL1lVfJaw
         EM+qDycjoX5JzgEB3mZtnV97fMOD7o9qErPnQ78/8MdXdmMKgKW1Iz1ykSxvQHaYv1Xn
         jMMIK5a1CWjOL8Wpb/gJzme7KYmaUmGDXZFkP5JZTi9tukUD4Ea/vm/VODcKrk8BfJYj
         vqonkT2YNI6639JAgDpskGUB18Hy/7ThKQblO72CNaTEvjF38wBCSFowUyc378M7kCtE
         sKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453683; x=1730058483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KOSHWqnsb0W3cOOf6DyqEOJr3wAY0C67ufwSo4h3/A8=;
        b=tN280FRmAHxBkXfkBuVz/gN3odiVU/CK/neQ+0OGm9d0fOFyY5AQ2BoTFKZTPO4Q76
         ki8Yh/Z528chYD9wX1ylnZ2HiE369y/I+ILNDaO7eOiHsFZWw5pGKt7877N/9CJH7Wrr
         aTWKANQSqGB22u9gFPmYvBF9WDwFPoP9dIEZ1EWRpVaKwqZKHYYWtH8nLiw7nUWh9DdG
         5jDN19TrJBi+NRd5XgRbHjWJwr5Z9XKqoXzd5e188+GoYCW4mODL2wk8vENlOwoJw0Wo
         lRr98AvxRVSh4EQPIBk31n2s/u/i+2113vAHo/FLr32AicFb7hhcBNzXh34o0Wf9KJnt
         s0dA==
X-Forwarded-Encrypted: i=1; AJvYcCVJZ8wB5DXlY1mzIbnSMEDuc2PMZAhagdJP3uk1jQ1KmlKmN/klk8uw3SaSnf1eYDjj0c4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMqbfTLBKijRcylz+xRvhH6TUwKzrCCvZ4uqmj4A76hinN+/ko
	OhCzEQez7ndYO2A+y7JODpiiwDuML5kFNCMGkhRnaSjMhsKF3Fgae7oLXqg5wJs=
X-Google-Smtp-Source: AGHT+IGGt5JhB4IG8+i0HAXwMX0R3ki791FJ5Pz6hTqm+U8OcKSwC7G5E4tWlwhk9qK0fqoTXOXa+A==
X-Received: by 2002:a17:90b:20a:b0:2e2:af52:a7b7 with SMTP id 98e67ed59e1d1-2e561a008ebmr11046511a91.34.1729453682889;
        Sun, 20 Oct 2024 12:48:02 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:48:02 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 10/13] RISC-V: KVM: Use nacl_csr_xyz() for accessing AIA CSRs
Date: Mon, 21 Oct 2024 01:17:31 +0530
Message-ID: <20241020194734.58686-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241020194734.58686-1-apatel@ventanamicro.com>
References: <20241020194734.58686-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running under some other hypervisor, prefer nacl_csr_xyz()
for accessing AIA CSRs in the run-loop. This makes CSR access
faster whenever SBI nested acceleration is available.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/aia.c | 97 ++++++++++++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 34 deletions(-)

diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 8ffae0330c89..dcced4db7fe8 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -16,6 +16,7 @@
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <asm/cpufeature.h>
+#include <asm/kvm_nacl.h>
 
 struct aia_hgei_control {
 	raw_spinlock_t lock;
@@ -88,7 +89,7 @@ void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
 
 	if (kvm_riscv_aia_available())
-		csr->vsieh = csr_read(CSR_VSIEH);
+		csr->vsieh = ncsr_read(CSR_VSIEH);
 }
 #endif
 
@@ -115,7 +116,7 @@ bool kvm_riscv_vcpu_aia_has_interrupts(struct kvm_vcpu *vcpu, u64 mask)
 
 	hgei = aia_find_hgei(vcpu);
 	if (hgei > 0)
-		return !!(csr_read(CSR_HGEIP) & BIT(hgei));
+		return !!(ncsr_read(CSR_HGEIP) & BIT(hgei));
 
 	return false;
 }
@@ -128,45 +129,73 @@ void kvm_riscv_vcpu_aia_update_hvip(struct kvm_vcpu *vcpu)
 		return;
 
 #ifdef CONFIG_32BIT
-	csr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
+	ncsr_write(CSR_HVIPH, vcpu->arch.aia_context.guest_csr.hviph);
 #endif
-	csr_write(CSR_HVICTL, aia_hvictl_value(!!(csr->hvip & BIT(IRQ_VS_EXT))));
+	ncsr_write(CSR_HVICTL, aia_hvictl_value(!!(csr->hvip & BIT(IRQ_VS_EXT))));
 }
 
 void kvm_riscv_vcpu_aia_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
+	void *nsh;
 
 	if (!kvm_riscv_aia_available())
 		return;
 
-	csr_write(CSR_VSISELECT, csr->vsiselect);
-	csr_write(CSR_HVIPRIO1, csr->hviprio1);
-	csr_write(CSR_HVIPRIO2, csr->hviprio2);
+	if (kvm_riscv_nacl_sync_csr_available()) {
+		nsh = nacl_shmem();
+		nacl_csr_write(nsh, CSR_VSISELECT, csr->vsiselect);
+		nacl_csr_write(nsh, CSR_HVIPRIO1, csr->hviprio1);
+		nacl_csr_write(nsh, CSR_HVIPRIO2, csr->hviprio2);
+#ifdef CONFIG_32BIT
+		nacl_csr_write(nsh, CSR_VSIEH, csr->vsieh);
+		nacl_csr_write(nsh, CSR_HVIPH, csr->hviph);
+		nacl_csr_write(nsh, CSR_HVIPRIO1H, csr->hviprio1h);
+		nacl_csr_write(nsh, CSR_HVIPRIO2H, csr->hviprio2h);
+#endif
+	} else {
+		csr_write(CSR_VSISELECT, csr->vsiselect);
+		csr_write(CSR_HVIPRIO1, csr->hviprio1);
+		csr_write(CSR_HVIPRIO2, csr->hviprio2);
 #ifdef CONFIG_32BIT
-	csr_write(CSR_VSIEH, csr->vsieh);
-	csr_write(CSR_HVIPH, csr->hviph);
-	csr_write(CSR_HVIPRIO1H, csr->hviprio1h);
-	csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
+		csr_write(CSR_VSIEH, csr->vsieh);
+		csr_write(CSR_HVIPH, csr->hviph);
+		csr_write(CSR_HVIPRIO1H, csr->hviprio1h);
+		csr_write(CSR_HVIPRIO2H, csr->hviprio2h);
 #endif
+	}
 }
 
 void kvm_riscv_vcpu_aia_put(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
+	void *nsh;
 
 	if (!kvm_riscv_aia_available())
 		return;
 
-	csr->vsiselect = csr_read(CSR_VSISELECT);
-	csr->hviprio1 = csr_read(CSR_HVIPRIO1);
-	csr->hviprio2 = csr_read(CSR_HVIPRIO2);
+	if (kvm_riscv_nacl_available()) {
+		nsh = nacl_shmem();
+		csr->vsiselect = nacl_csr_read(nsh, CSR_VSISELECT);
+		csr->hviprio1 = nacl_csr_read(nsh, CSR_HVIPRIO1);
+		csr->hviprio2 = nacl_csr_read(nsh, CSR_HVIPRIO2);
 #ifdef CONFIG_32BIT
-	csr->vsieh = csr_read(CSR_VSIEH);
-	csr->hviph = csr_read(CSR_HVIPH);
-	csr->hviprio1h = csr_read(CSR_HVIPRIO1H);
-	csr->hviprio2h = csr_read(CSR_HVIPRIO2H);
+		csr->vsieh = nacl_csr_read(nsh, CSR_VSIEH);
+		csr->hviph = nacl_csr_read(nsh, CSR_HVIPH);
+		csr->hviprio1h = nacl_csr_read(nsh, CSR_HVIPRIO1H);
+		csr->hviprio2h = nacl_csr_read(nsh, CSR_HVIPRIO2H);
 #endif
+	} else {
+		csr->vsiselect = csr_read(CSR_VSISELECT);
+		csr->hviprio1 = csr_read(CSR_HVIPRIO1);
+		csr->hviprio2 = csr_read(CSR_HVIPRIO2);
+#ifdef CONFIG_32BIT
+		csr->vsieh = csr_read(CSR_VSIEH);
+		csr->hviph = csr_read(CSR_HVIPH);
+		csr->hviprio1h = csr_read(CSR_HVIPRIO1H);
+		csr->hviprio2h = csr_read(CSR_HVIPRIO2H);
+#endif
+	}
 }
 
 int kvm_riscv_vcpu_aia_get_csr(struct kvm_vcpu *vcpu,
@@ -250,20 +279,20 @@ static u8 aia_get_iprio8(struct kvm_vcpu *vcpu, unsigned int irq)
 
 	switch (bitpos / BITS_PER_LONG) {
 	case 0:
-		hviprio = csr_read(CSR_HVIPRIO1);
+		hviprio = ncsr_read(CSR_HVIPRIO1);
 		break;
 	case 1:
 #ifndef CONFIG_32BIT
-		hviprio = csr_read(CSR_HVIPRIO2);
+		hviprio = ncsr_read(CSR_HVIPRIO2);
 		break;
 #else
-		hviprio = csr_read(CSR_HVIPRIO1H);
+		hviprio = ncsr_read(CSR_HVIPRIO1H);
 		break;
 	case 2:
-		hviprio = csr_read(CSR_HVIPRIO2);
+		hviprio = ncsr_read(CSR_HVIPRIO2);
 		break;
 	case 3:
-		hviprio = csr_read(CSR_HVIPRIO2H);
+		hviprio = ncsr_read(CSR_HVIPRIO2H);
 		break;
 #endif
 	default:
@@ -283,20 +312,20 @@ static void aia_set_iprio8(struct kvm_vcpu *vcpu, unsigned int irq, u8 prio)
 
 	switch (bitpos / BITS_PER_LONG) {
 	case 0:
-		hviprio = csr_read(CSR_HVIPRIO1);
+		hviprio = ncsr_read(CSR_HVIPRIO1);
 		break;
 	case 1:
 #ifndef CONFIG_32BIT
-		hviprio = csr_read(CSR_HVIPRIO2);
+		hviprio = ncsr_read(CSR_HVIPRIO2);
 		break;
 #else
-		hviprio = csr_read(CSR_HVIPRIO1H);
+		hviprio = ncsr_read(CSR_HVIPRIO1H);
 		break;
 	case 2:
-		hviprio = csr_read(CSR_HVIPRIO2);
+		hviprio = ncsr_read(CSR_HVIPRIO2);
 		break;
 	case 3:
-		hviprio = csr_read(CSR_HVIPRIO2H);
+		hviprio = ncsr_read(CSR_HVIPRIO2H);
 		break;
 #endif
 	default:
@@ -308,20 +337,20 @@ static void aia_set_iprio8(struct kvm_vcpu *vcpu, unsigned int irq, u8 prio)
 
 	switch (bitpos / BITS_PER_LONG) {
 	case 0:
-		csr_write(CSR_HVIPRIO1, hviprio);
+		ncsr_write(CSR_HVIPRIO1, hviprio);
 		break;
 	case 1:
 #ifndef CONFIG_32BIT
-		csr_write(CSR_HVIPRIO2, hviprio);
+		ncsr_write(CSR_HVIPRIO2, hviprio);
 		break;
 #else
-		csr_write(CSR_HVIPRIO1H, hviprio);
+		ncsr_write(CSR_HVIPRIO1H, hviprio);
 		break;
 	case 2:
-		csr_write(CSR_HVIPRIO2, hviprio);
+		ncsr_write(CSR_HVIPRIO2, hviprio);
 		break;
 	case 3:
-		csr_write(CSR_HVIPRIO2H, hviprio);
+		ncsr_write(CSR_HVIPRIO2H, hviprio);
 		break;
 #endif
 	default:
@@ -377,7 +406,7 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 		return KVM_INSN_ILLEGAL_TRAP;
 
 	/* First try to emulate in kernel space */
-	isel = csr_read(CSR_VSISELECT) & ISELECT_MASK;
+	isel = ncsr_read(CSR_VSISELECT) & ISELECT_MASK;
 	if (isel >= ISELECT_IPRIO0 && isel <= ISELECT_IPRIO15)
 		return aia_rmw_iprio(vcpu, isel, val, new_val, wr_mask);
 	else if (isel >= IMSIC_FIRST && isel <= IMSIC_LAST &&
-- 
2.43.0


