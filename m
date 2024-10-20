Return-Path: <kvm+bounces-29221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2C99A5684
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 21:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFDB4282958
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 19:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D76CF19CD08;
	Sun, 20 Oct 2024 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KO2NmrsO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0726D19C556
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 19:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729453687; cv=none; b=BhtJH+sp2p9ItMrODKCwFf7Da2M0MIHwVfjkX9dtSy+ESc/pPh7uZusG7zBvGkhP3/xgWANhleYuR7dzL1OGKtvJ5krPSEqFAI8DFGT/Stkp0yNzGJ1hdqTVPiWdgyeWAptvz+wuZZOfxaL6rEeQCsUaaxiipoS3fqVKS0DsDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729453687; c=relaxed/simple;
	bh=vjKQC0zoF7G9cM7ssIkz36wmQJSD3vz5oHrHzckRPHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+Oop6wxtqUwr8MxIsDZcCCgWiHQ0Evv1NNSqJutBxhz0A/xmXpehD7NEQh2NRf94i0Gb2lFfnlyZtL4G0c6bNYx2wSYB6gE6JkhczvdQb8G52TlEt9PBeKfHFKYrkJLMk+CqNLXC7jYnhhkClDApV14WSVgF/oDgkoCo5D/Fn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KO2NmrsO; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2eb9dde40so3073905a91.0
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 12:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1729453685; x=1730058485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4C7ZduGC7pkN/JUl6gfB/F71HinWDzomU4MOEbWcFt4=;
        b=KO2NmrsONf8EXrQGO9D9vu2AwQwHnUijQsZ8qN/6rI+DAwdi2TGR23yMHng/54/Im/
         iQqn0+POZ/DkkIdgYUuE+y7x8g6k7GarwLIkcxUyPjcENYb8X0kWLST3g15ACo+YNuH9
         BYd5ST7FU3F4otKoFScOeXrjYHXZi7J+cxyGUchk2ekIwH72xlOL0FJqcKO3J82XxyzG
         xxeU7jDPNh6AZrtdYV9/s3hAYZvF1WKmkJ4Cq6Gx18/QXahEFDnzTcYXb5alvRmRQdVF
         MYe3533+zsvCc9MAw4VYuwOVXdy6kUUJQeq0bM2jjpbbq79kfoWyzWQLlaywpUdbAiMD
         DSKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729453685; x=1730058485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4C7ZduGC7pkN/JUl6gfB/F71HinWDzomU4MOEbWcFt4=;
        b=HF/jaDxRiLWBGKmJ2DohRdEoWnrDqh6q2Sd0V5lX1gf7t1gq4WORJeeGhmxO2rViaR
         rVm7Gtf4zokOFlz5lBJlwyejPnyynlKw6ToRETSUZOvH6qZHMQbS/rNkVdeYTip4wJ9p
         w+BoZQ7eshUNMnvqY1KFSmPVnmOCcp37lRTar8tkpYUtWLph0VaXhUfsu7u0O63tYlCl
         Gwr7OpCMrI6b8AcotMPbVellE14Mfqs7XUcGbCZOtYaZHkyFHTWhOftB+3gdIQgyVe61
         V4ljOyTwO8lPaI8UA1FbyxNOs2EdMhSeyHH7tFoXlRlEXqSWDFWHxRmqSY0X2Duckt0K
         Mnlw==
X-Forwarded-Encrypted: i=1; AJvYcCU58liO+JoS00LhEFrsC45Grd+iD4wgtcY7RGYdFe4jqYSeeQX3BSpsYJkraH62PzST76Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyqu5WdUDItm2xkLV7vfy95aFifel5gVmSK5XyviOnfKCUEbW3D
	32DOUh5SMmsI+OUEJcaohUFClUNZGMhy4oauhkzmQZppkmAWF5EbQhCCuOA+avQ=
X-Google-Smtp-Source: AGHT+IG/11qYdtlLvAcC5cZkvAaWerEVivMA/dGwxaUtWguVGnxVgD9ylKyt8Lr3PM/GRQspnVP0aw==
X-Received: by 2002:a17:90a:15c9:b0:2e2:bad3:e393 with SMTP id 98e67ed59e1d1-2e5616de72amr10855206a91.3.1729453685228;
        Sun, 20 Oct 2024 12:48:05 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([50.238.223.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad365d4dsm1933188a91.14.2024.10.20.12.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 12:48:04 -0700 (PDT)
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
Subject: [PATCH v2 11/13] RISC-V: KVM: Use SBI sync SRET call when available
Date: Mon, 21 Oct 2024 01:17:32 +0530
Message-ID: <20241020194734.58686-12-apatel@ventanamicro.com>
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

Implement an optimized KVM world-switch using SBI sync SRET call
when SBI nested acceleration extension is available. This improves
KVM world-switch when KVM RISC-V is running as a Guest under some
other hypervisor.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_nacl.h |  6 ++++
 arch/riscv/kvm/vcpu.c             | 48 ++++++++++++++++++++++++++++---
 arch/riscv/kvm/vcpu_switch.S      | 29 +++++++++++++++++++
 3 files changed, 79 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/kvm_nacl.h
index 8f3e3ebf5017..4124d5e06a0f 100644
--- a/arch/riscv/include/asm/kvm_nacl.h
+++ b/arch/riscv/include/asm/kvm_nacl.h
@@ -12,6 +12,8 @@
 #include <asm/csr.h>
 #include <asm/sbi.h>
 
+struct kvm_vcpu_arch;
+
 DECLARE_STATIC_KEY_FALSE(kvm_riscv_nacl_available);
 #define kvm_riscv_nacl_available() \
 	static_branch_unlikely(&kvm_riscv_nacl_available)
@@ -43,6 +45,10 @@ void __kvm_riscv_nacl_hfence(void *shmem,
 			     unsigned long page_num,
 			     unsigned long page_count);
 
+void __kvm_riscv_nacl_switch_to(struct kvm_vcpu_arch *vcpu_arch,
+				unsigned long sbi_ext_id,
+				unsigned long sbi_func_id);
+
 int kvm_riscv_nacl_enable(void);
 
 void kvm_riscv_nacl_disable(void);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 0aad58f984ff..e191e6eae0c0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -770,19 +770,59 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
  */
 static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
+	void *nsh;
 	struct kvm_cpu_context *gcntx = &vcpu->arch.guest_context;
 	struct kvm_cpu_context *hcntx = &vcpu->arch.host_context;
 
 	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
 	guest_state_enter_irqoff();
 
-	hcntx->hstatus = ncsr_swap(CSR_HSTATUS, gcntx->hstatus);
+	if (kvm_riscv_nacl_sync_sret_available()) {
+		nsh = nacl_shmem();
 
-	nsync_csr(-1UL);
+		if (kvm_riscv_nacl_autoswap_csr_available()) {
+			hcntx->hstatus =
+				nacl_csr_read(nsh, CSR_HSTATUS);
+			nacl_scratch_write_long(nsh,
+						SBI_NACL_SHMEM_AUTOSWAP_OFFSET +
+						SBI_NACL_SHMEM_AUTOSWAP_HSTATUS,
+						gcntx->hstatus);
+			nacl_scratch_write_long(nsh,
+						SBI_NACL_SHMEM_AUTOSWAP_OFFSET,
+						SBI_NACL_SHMEM_AUTOSWAP_FLAG_HSTATUS);
+		} else if (kvm_riscv_nacl_sync_csr_available()) {
+			hcntx->hstatus = nacl_csr_swap(nsh,
+						       CSR_HSTATUS, gcntx->hstatus);
+		} else {
+			hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
+		}
 
-	__kvm_riscv_switch_to(&vcpu->arch);
+		nacl_scratch_write_longs(nsh,
+					 SBI_NACL_SHMEM_SRET_OFFSET +
+					 SBI_NACL_SHMEM_SRET_X(1),
+					 &gcntx->ra,
+					 SBI_NACL_SHMEM_SRET_X_LAST);
+
+		__kvm_riscv_nacl_switch_to(&vcpu->arch, SBI_EXT_NACL,
+					   SBI_EXT_NACL_SYNC_SRET);
+
+		if (kvm_riscv_nacl_autoswap_csr_available()) {
+			nacl_scratch_write_long(nsh,
+						SBI_NACL_SHMEM_AUTOSWAP_OFFSET,
+						0);
+			gcntx->hstatus = nacl_scratch_read_long(nsh,
+								SBI_NACL_SHMEM_AUTOSWAP_OFFSET +
+								SBI_NACL_SHMEM_AUTOSWAP_HSTATUS);
+		} else {
+			gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+		}
+	} else {
+		hcntx->hstatus = csr_swap(CSR_HSTATUS, gcntx->hstatus);
 
-	gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+		__kvm_riscv_switch_to(&vcpu->arch);
+
+		gcntx->hstatus = csr_swap(CSR_HSTATUS, hcntx->hstatus);
+	}
 
 	vcpu->arch.last_exit_cpu = vcpu->cpu;
 	guest_state_exit_irqoff();
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 9f13e5ce6a18..47686bcb21e0 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -218,6 +218,35 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	ret
 SYM_FUNC_END(__kvm_riscv_switch_to)
 
+	/*
+	 * Parameters:
+	 * A0 <= Pointer to struct kvm_vcpu_arch
+	 * A1 <= SBI extension ID
+	 * A2 <= SBI function ID
+	 */
+SYM_FUNC_START(__kvm_riscv_nacl_switch_to)
+	SAVE_HOST_GPRS
+
+	SAVE_HOST_AND_RESTORE_GUEST_CSRS .Lkvm_nacl_switch_return
+
+	/* Resume Guest using SBI nested acceleration */
+	add	a6, a2, zero
+	add	a7, a1, zero
+	ecall
+
+	/* Back to Host */
+	.align 2
+.Lkvm_nacl_switch_return:
+	SAVE_GUEST_GPRS
+
+	SAVE_GUEST_AND_RESTORE_HOST_CSRS
+
+	RESTORE_HOST_GPRS
+
+	/* Return to C code */
+	ret
+SYM_FUNC_END(__kvm_riscv_nacl_switch_to)
+
 SYM_CODE_START(__kvm_riscv_unpriv_trap)
 	/*
 	 * We assume that faulting unpriv load/store instruction is
-- 
2.43.0


