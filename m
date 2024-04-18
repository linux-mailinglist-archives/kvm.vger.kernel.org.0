Return-Path: <kvm+bounces-15109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C8358A9D1E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:30:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5231C21E96
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B55D16E87A;
	Thu, 18 Apr 2024 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="3MZjJB0p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A616D4D0
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450441; cv=none; b=UFoeFhVZya3U945NKfHbtfiJXq2aMqIOWQc3uoE0jFz/pW9eMgEiS0+ono3+PW3IkILRHON6+yYkffcSrs3vudqqW7N+T7k8RfNl7nLlN8i1GqLHhZFHKlTAcnBMsPIq3VwZtJ5nS2qB8l40RkNUFS1H6bPxNeCj4ydL4zaY1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450441; c=relaxed/simple;
	bh=UNrY7ZJ8C+87BdlHqGuS8vMwNElY+SOB7mPxe2CzPOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QmSbY3p7Ut+QAWNfxilKkl/9QdIwv/L7RtWErQEBhbZ6FbNv+fd0MC2Z57Hm/kpCFUfz9orFmM/F2b7lSbGLByLpdPVz4fhZ4JOCXoQnXmeu0RxbdmIl9xBTVKJjpgRwtoDrWuMk+EIqvfLlxII4tX/5F3TKBdrd8/du2FUsYLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=3MZjJB0p; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-349a31b2babso113861f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 07:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713450437; x=1714055237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ux6Z0dvHS0AaHNoD8WJhlnEKIxWvWWXWdBe+6rPnELc=;
        b=3MZjJB0pWmx/OSPyEgGXXLZNAsETw4gjaia2ZieZZ1Ruxa+PUWIa39m4gY3qA3il11
         sNvuKyp8UaChSogJp1YpgyTDBya/Sn/CEDSaviPmoHaHBm2mS8kIfyriXYtYOlSEzlbo
         3PEWWiB3uBcxJt5ESGWwWjWPQ01kycjumCd+QptXLXtljutMaJ1BqMD153SXohP/eiK3
         mnJPgSeY8UpC4TKQL/VuOkKwoiBYcY4EoAckxpU7gtoxIAnAxW30toCbI3KOtG5rIco1
         0EGGvi1ONMEb/LzVubWEQmkZ9QRLHlsVHdZxzQgVBQSstiDjhMwjkOcV09FCo1L4hpNQ
         Ee2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713450437; x=1714055237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ux6Z0dvHS0AaHNoD8WJhlnEKIxWvWWXWdBe+6rPnELc=;
        b=IFEWchfKMZELxvOJl+Ym3eZBeDw73+pW8z1EZbuHGttC7hMmNaTDIW0OLLEOtMu6iW
         pXlWyGpsGXVFI4LpDLWw0/A7bkRZm67bUU95XRgb4P8yy5uB68vWZMXRVhOGSpVFk/p/
         0KepavV39g/pro2+xvZf7lAsbEEB/XszY5WYfBStv70kOpRj9X84MEyNbCfTu8LoVJ0T
         AzWtIG8ZgEV+5JCF5+Pf9azBwImGBvFlKpHYrzAnt3YFO3IVP3r0+0ziyL7pve7m3lBT
         q3wxU1u0TKVTMJMjfaZOLCxBoOHcO+0kKnSo7ftDbYRHszeiXLZzvOl3h2jiN1/QFiMC
         8r0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGHADMezawQVHajpk7t55VPAPQPuxijskipxB4Qf3lH1ZhRsdkdHXl/Max/qC+BALVOEw9XRD7KjQFJq3cI8ha9ZN6
X-Gm-Message-State: AOJu0YwNGb1cUBKSGqo1OKY7YHXwGWRUAUwzeotj0rqi/xaAgJ16HxRz
	F0H65RDxUPoZs0NDxkk0MKylDTHhW+hq/r9SmV4Q1Z7qZWeeIo32Sdg6nxnYe3c=
X-Google-Smtp-Source: AGHT+IGBKkRXPRGYPrNf2xynAaVp5CuMPioqb/sz3tcbUIZ90ojHCdGDsQ+aqJS0cvtdtDhHjXauZw==
X-Received: by 2002:a05:600c:5101:b0:416:a773:7d18 with SMTP id o1-20020a05600c510100b00416a7737d18mr2062486wms.0.1713450437373;
        Thu, 18 Apr 2024 07:27:17 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c470a00b00418a386c059sm2873645wmo.42.2024.04.18.07.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 07:27:16 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Conor Dooley <conor@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Ved Shanbhogue <ved@rivosinc.com>
Subject: [RFC PATCH 7/7] RISC-V: KVM: add support for double trap exception
Date: Thu, 18 Apr 2024 16:26:46 +0200
Message-ID: <20240418142701.1493091-8-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418142701.1493091-1-cleger@rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When a double trap exception is generated from VS-mode, it should be
delivered to M-mode which might redirect it to S-mode. Currently, the
kvm double trap exception handling simply prints an error and returns
-EOPNOTSUPP to stop VM execution. In future, this might use KVM SBI SSE
extension implementation to actually send an SSE event to the guest VM.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/kvm_host.h |  7 ++++---
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu.c             | 23 +++++++++------------
 arch/riscv/kvm/vcpu_exit.c        | 33 +++++++++++++++++++++++++------
 arch/riscv/kvm/vcpu_insn.c        | 15 +++++---------
 arch/riscv/kvm/vcpu_onereg.c      |  2 ++
 arch/riscv/kvm/vcpu_sbi.c         |  4 +---
 arch/riscv/kvm/vcpu_switch.S      | 19 +++++++++++++++---
 8 files changed, 65 insertions(+), 39 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index be60aaa07f57..1d699bf44c45 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -358,12 +358,13 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
 					 bool read_insn,
 					 unsigned long guest_addr,
 					 struct kvm_cpu_trap *trap);
-void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
-				  struct kvm_cpu_trap *trap);
+int kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_trap *trap);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			struct kvm_cpu_trap *trap);
 
-void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch,
+			   struct kvm_cpu_trap *trap);
 
 void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu);
 unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index fa3097da91c0..323f4e8380d2 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -166,6 +166,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZVFH,
 	KVM_RISCV_ISA_EXT_ZVFHMIN,
 	KVM_RISCV_ISA_EXT_ZFA,
+	KVM_RISCV_ISA_EXT_SSDBLTRP,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 461ef60d4eda..89e663defe14 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -121,6 +121,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
 	cntx = &vcpu->arch.guest_reset_context;
 	cntx->sstatus = SR_SPP | SR_SPIE;
+	if (riscv_isa_extension_available(vcpu->arch.isa, SSDBLTRP))
+		cntx->sstatus |= SR_SDT;
 	cntx->hstatus = 0;
 	cntx->hstatus |= HSTATUS_VTW;
 	cntx->hstatus |= HSTATUS_SPVP;
@@ -579,6 +581,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	csr->hvip = csr_read(CSR_HVIP);
 	csr->vsatp = csr_read(CSR_VSATP);
 	cfg->hedeleg = csr_read(CSR_HEDELEG);
+	cfg->henvcfg = csr_read(CSR_HENVCFG);
+	if (IS_ENABLED(CONFIG_32BIT))
+		cfg->henvcfg = csr_read(CSR_HENVCFGH) << 32;
 }
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
@@ -670,11 +675,12 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
  * This must be noinstr as instrumentation may make use of RCU, and this is not
  * safe during the EQS.
  */
-static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					      struct kvm_cpu_trap *trap)
 {
 	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
 	guest_state_enter_irqoff();
-	__kvm_riscv_switch_to(&vcpu->arch);
+	__kvm_riscv_switch_to(&vcpu->arch, trap);
 	vcpu->arch.last_exit_cpu = vcpu->cpu;
 	guest_state_exit_irqoff();
 	kvm_riscv_vcpu_swap_in_host_state(vcpu);
@@ -789,22 +795,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		guest_timing_enter_irqoff();
 
-		kvm_riscv_vcpu_enter_exit(vcpu);
+		kvm_riscv_vcpu_enter_exit(vcpu, &trap);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		vcpu->stat.exits++;
 
-		/*
-		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
-		 * get an interrupt between __kvm_riscv_switch_to() and
-		 * local_irq_enable() which can potentially change CSRs.
-		 */
-		trap.sepc = vcpu->arch.guest_context.sepc;
-		trap.scause = csr_read(CSR_SCAUSE);
-		trap.stval = csr_read(CSR_STVAL);
-		trap.htval = csr_read(CSR_HTVAL);
-		trap.htinst = csr_read(CSR_HTINST);
-
 		/* Syncup interrupts state with HW */
 		kvm_riscv_vcpu_sync_interrupts(vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2415722c01b8..892c6df97eaf 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -126,17 +126,34 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
 	return val;
 }
 
+static int kvm_riscv_double_trap(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_trap *trap)
+{
+	pr_err("Guest double trap");
+	/* TODO: Implement SSE support */
+
+	return -EOPNOTSUPP;
+}
+
 /**
  * kvm_riscv_vcpu_trap_redirect -- Redirect trap to Guest
  *
  * @vcpu: The VCPU pointer
  * @trap: Trap details
  */
-void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
-				  struct kvm_cpu_trap *trap)
+int kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_trap *trap)
 {
 	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
 
+	if (riscv_isa_extension_available(vcpu->arch.isa, SSDBLTRP)) {
+		if (vsstatus & SR_SDT)
+			return kvm_riscv_double_trap(vcpu, trap);
+
+		/* Set Double Trap bit to enable double trap detection */
+		vsstatus |= SR_SDT;
+	}
+
 	/* Change Guest SSTATUS.SPP bit */
 	vsstatus &= ~SR_SPP;
 	if (vcpu->arch.guest_context.sstatus & SR_SPP)
@@ -163,6 +180,8 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
 
 	/* Set Guest privilege mode to supervisor */
 	vcpu->arch.guest_context.sstatus |= SR_SPP;
+
+	return 1;
 }
 
 /*
@@ -185,10 +204,8 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	case EXC_INST_ILLEGAL:
 	case EXC_LOAD_MISALIGNED:
 	case EXC_STORE_MISALIGNED:
-		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
-			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
-			ret = 1;
-		}
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = kvm_riscv_vcpu_trap_redirect(vcpu, trap);
 		break;
 	case EXC_VIRTUAL_INST_FAULT:
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
@@ -204,6 +221,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
 		break;
+	case EXC_DOUBLE_TRAP:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = kvm_riscv_double_trap(vcpu, trap);
+		break;
 	default:
 		break;
 	}
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 7a6abed41bc1..050e811204f2 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -159,9 +159,8 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	utrap.stval = insn;
 	utrap.htval = 0;
 	utrap.htinst = 0;
-	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 
-	return 1;
+	return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 }
 
 static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
@@ -175,9 +174,8 @@ static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	utrap.stval = insn;
 	utrap.htval = 0;
 	utrap.htinst = 0;
-	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 
-	return 1;
+	return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 }
 
 /**
@@ -422,8 +420,7 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
 							  &utrap);
 			if (utrap.scause) {
 				utrap.sepc = ct->sepc;
-				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-				return 1;
+				return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 			}
 		}
 		if (INSN_IS_16BIT(insn))
@@ -478,8 +475,7 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (utrap.scause) {
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-			return 1;
+			return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 		}
 		insn_len = INSN_LEN(insn);
 	}
@@ -604,8 +600,7 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (utrap.scause) {
 			/* Redirect trap if we failed to read instruction */
 			utrap.sepc = ct->sepc;
-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
-			return 1;
+			return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
 		}
 		insn_len = INSN_LEN(insn);
 	}
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 5f7355e96008..fece0043871c 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	/* Multi letter extensions (alphabetically sorted) */
 	KVM_ISA_EXT_ARR(SMSTATEEN),
 	KVM_ISA_EXT_ARR(SSAIA),
+	KVM_ISA_EXT_ARR(SSDBLTRP),
 	KVM_ISA_EXT_ARR(SSTC),
 	KVM_ISA_EXT_ARR(SVINVAL),
 	KVM_ISA_EXT_ARR(SVNAPOT),
@@ -153,6 +154,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZVKSED:
 	case KVM_RISCV_ISA_EXT_ZVKSH:
 	case KVM_RISCV_ISA_EXT_ZVKT:
+	case KVM_RISCV_ISA_EXT_SSDBLTRP:
 		return false;
 	/* Extensions which can be disabled using Smstateen */
 	case KVM_RISCV_ISA_EXT_SSAIA:
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 76901f0f34b7..b839d578dc26 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -456,10 +456,8 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	/* Handle special error cases i.e trap, exit or userspace forward */
 	if (sbi_ret.utrap->scause) {
-		/* No need to increment sepc or exit ioctl loop */
-		ret = 1;
 		sbi_ret.utrap->sepc = cp->sepc;
-		kvm_riscv_vcpu_trap_redirect(vcpu, sbi_ret.utrap);
+		ret = kvm_riscv_vcpu_trap_redirect(vcpu, sbi_ret.utrap);
 		next_sepc = false;
 		goto ecall_done;
 	}
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index 0c26189aa01c..94d5eb9da788 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -154,7 +154,6 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
 	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
 	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
-	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
 
 	/* Save Guest SEPC */
 	csrr	t0, CSR_SEPC
@@ -171,8 +170,8 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	/* Save Guest and Restore Host HSTATUS */
 	csrrw	t4, CSR_HSTATUS, t4
 
-	/* Save Guest and Restore Host SSTATUS */
-	csrrw	t5, CSR_SSTATUS, t5
+	/* Save Guest SSTATUS */
+	csrr	t5, CSR_SSTATUS
 
 	/* Store Guest CSR values */
 	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
@@ -206,6 +205,20 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
 	REG_L	s10, (KVM_ARCH_HOST_S10)(a0)
 	REG_L	s11, (KVM_ARCH_HOST_S11)(a0)
 
+	csrr	t1, CSR_SCAUSE
+	csrr	t2, CSR_STVAL
+	csrr	t3, CSR_HTVAL
+	csrr	t4, CSR_HTINST
+	REG_S	t0, (KVM_ARCH_TRAP_SEPC)(a1)
+	REG_S	t1, (KVM_ARCH_TRAP_SCAUSE)(a1)
+	REG_S	t2, (KVM_ARCH_TRAP_STVAL)(a1)
+	REG_S	t3, (KVM_ARCH_TRAP_HTVAL)(a1)
+	REG_S	t4, (KVM_ARCH_TRAP_HTINST)(a1)
+
+	/* Restore Host SSTATUS */
+	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrw	CSR_SSTATUS, t5
+
 	/* Return to C code */
 	ret
 SYM_FUNC_END(__kvm_riscv_switch_to)
-- 
2.43.0


