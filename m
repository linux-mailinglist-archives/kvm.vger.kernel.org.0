Return-Path: <kvm+bounces-16094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE9C8B4385
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 03:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EADCE1F22BA2
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 01:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88113374F2;
	Sat, 27 Apr 2024 01:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="YhnCVyVp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE1D3BBD4
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 01:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714181603; cv=none; b=TTkjsv2OdlUjOG29i/khmK7H/WedghAeKnosHDNmC1QYzUymxYqrYyf74Dn+eGRrW0O7whj+2qxa0UuNQ7qBFU+VKON2GN8X5zqbeJJ/c2B9U4VlSCjRvNWkDS9MOUYltDJ1C9O9W8fKHLhEU2vfplhqQxx91zhNxqY3sYzOL9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714181603; c=relaxed/simple;
	bh=i59/ujEJMNnCg7gi/40daSIU/Bj4KauqTOsX3ixwd70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzcV/YJxR6MoRw9ThHiDAcpYyukZ62x3UBhIUegra3rMg1RKtzBTeMXBbEjP37oV4MWOpvzztNeanx5+hqOtLpL0NXVhRhWXRDclCgppL1wEGFQPDRQinhidOQeCERE/uqMQCELfqkSB235he4PlMF246Rong3ErOr2jhBoO+rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=YhnCVyVp; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-23981fd7947so1658366fac.3
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 18:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1714181601; x=1714786401; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JQpt6297aHfVvE4nT7VnKeCEcale8WPc/TTW64rkQYo=;
        b=YhnCVyVpdLDbJU5aUgjFRianGfhgrmLaCVuSsl1Y3UeiFKJsyRtAo6Sn1AIWGvscEd
         VOl2b38f1ZOt4bVlSqQ2hvfUHwGGORvLoex5dodLTum8qJI2jW4ZuzZIn5RviZHqjQXi
         mV3UsrOkY0JtcGhWVnxBA4o2Xq7RUYzCcHwLWOX/c3ZUltsg/QCY0f8TQEPfBKg5myrR
         lNCb9zpV793qWtTiMl/C3n3jz0dnZhrzHRcPBRhgHBTJc4K1wd5c45Fkb6vJ9W2dJmUC
         N54FdeODrr86XsUxu4keoLHo0NWbLzuATkicgb3i6YwfMlbhBg3NMx9CiAlDSCR1G+yQ
         99Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714181601; x=1714786401;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JQpt6297aHfVvE4nT7VnKeCEcale8WPc/TTW64rkQYo=;
        b=dfHu/bXXsA3wrVOuV8PjvnJZW9aafOqRDxafkKrDFCL+RKMfkTy+KZi1/K7qdslWXT
         VEgRWYWE7K7kn+ZoN55VBDokFqxKTtoAmCy1guwrwIqRgfAZXTk3nj7VDgxSBpmUI8rp
         EtsPIU9okUZ77j8KhVi7rsX+1ABsBaQ7mjnEeIr2tdaXXN+jWMF7bCCFgDmnXdYOa8QJ
         P+8jqezBCoNInQw00Mw/wFdXLLrdQ+0jNYybnqsp2IVyiINqxXYg4mmLFHyfZTWGFGHw
         xzrijnRtKEj3eeeyjpQj0j+eviMnPunP8fjGJwyqdmdJuIwI1tm6Mbd5ldjWR83fTw/N
         Dpjw==
X-Forwarded-Encrypted: i=1; AJvYcCVCeQptetD5d7AbaVZSwBN4ksvxOy0xSMj+dKyJkSeYWpIG1Snbv/d3KqrVG5YXdai75BLFKOOj4HEy14M0C2tvlpE3
X-Gm-Message-State: AOJu0YxwJgzabNvFmzAr3wOtWnqvNsmabH2yQAt825ivC02bsSHpDkxw
	Q2ZMmiJeIsemyAbyE9yvinZXxZCxBEiQD/vKZioJHt/+WOWh4iFiRRauZiR+pfk=
X-Google-Smtp-Source: AGHT+IFKPghsjZLurC4EQwLfRUO+CkR+Zm3QBKflvDaBl342rGaCxptKAb76eL5uFB+LD8nIQWO/NA==
X-Received: by 2002:a05:6870:724b:b0:22e:ddde:adab with SMTP id y11-20020a056870724b00b0022edddeadabmr4780625oaf.36.1714181600802;
        Fri, 26 Apr 2024 18:33:20 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id h17-20020a62b411000000b006edd05e3751sm16003458pfn.176.2024.04.26.18.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 18:33:20 -0700 (PDT)
Date: Fri, 26 Apr 2024 18:33:18 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>
Cc: Conor Dooley <conor@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [RFC PATCH 7/7] RISC-V: KVM: add support for double trap
 exception
Message-ID: <ZixV3lCe3jYQN3Qx@debug.ba.rivosinc.com>
References: <20240418142701.1493091-1-cleger@rivosinc.com>
 <20240418142701.1493091-8-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240418142701.1493091-8-cleger@rivosinc.com>

On Thu, Apr 18, 2024 at 04:26:46PM +0200, Clément Léger wrote:
>When a double trap exception is generated from VS-mode, it should be
>delivered to M-mode which might redirect it to S-mode. Currently, the
>kvm double trap exception handling simply prints an error and returns
>-EOPNOTSUPP to stop VM execution. In future, this might use KVM SBI SSE
>extension implementation to actually send an SSE event to the guest VM.
>
>Signed-off-by: Clément Léger <cleger@rivosinc.com>
>---
> arch/riscv/include/asm/kvm_host.h |  7 ++++---
> arch/riscv/include/uapi/asm/kvm.h |  1 +
> arch/riscv/kvm/vcpu.c             | 23 +++++++++------------
> arch/riscv/kvm/vcpu_exit.c        | 33 +++++++++++++++++++++++++------
> arch/riscv/kvm/vcpu_insn.c        | 15 +++++---------
> arch/riscv/kvm/vcpu_onereg.c      |  2 ++
> arch/riscv/kvm/vcpu_sbi.c         |  4 +---
> arch/riscv/kvm/vcpu_switch.S      | 19 +++++++++++++++---
> 8 files changed, 65 insertions(+), 39 deletions(-)
>
>diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>index be60aaa07f57..1d699bf44c45 100644
>--- a/arch/riscv/include/asm/kvm_host.h
>+++ b/arch/riscv/include/asm/kvm_host.h
>@@ -358,12 +358,13 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
> 					 bool read_insn,
> 					 unsigned long guest_addr,
> 					 struct kvm_cpu_trap *trap);
>-void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>-				  struct kvm_cpu_trap *trap);
>+int kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>+				 struct kvm_cpu_trap *trap);
> int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 			struct kvm_cpu_trap *trap);
>
>-void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
>+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch,
>+			   struct kvm_cpu_trap *trap);
>
> void kvm_riscv_vcpu_setup_isa(struct kvm_vcpu *vcpu);
> unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vcpu *vcpu);
>diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
>index fa3097da91c0..323f4e8380d2 100644
>--- a/arch/riscv/include/uapi/asm/kvm.h
>+++ b/arch/riscv/include/uapi/asm/kvm.h
>@@ -166,6 +166,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> 	KVM_RISCV_ISA_EXT_ZVFH,
> 	KVM_RISCV_ISA_EXT_ZVFHMIN,
> 	KVM_RISCV_ISA_EXT_ZFA,
>+	KVM_RISCV_ISA_EXT_SSDBLTRP,
> 	KVM_RISCV_ISA_EXT_MAX,
> };
>
>diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>index 461ef60d4eda..89e663defe14 100644
>--- a/arch/riscv/kvm/vcpu.c
>+++ b/arch/riscv/kvm/vcpu.c
>@@ -121,6 +121,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
> 	cntx = &vcpu->arch.guest_reset_context;
> 	cntx->sstatus = SR_SPP | SR_SPIE;
>+	if (riscv_isa_extension_available(vcpu->arch.isa, SSDBLTRP))
>+		cntx->sstatus |= SR_SDT;
> 	cntx->hstatus = 0;
> 	cntx->hstatus |= HSTATUS_VTW;
> 	cntx->hstatus |= HSTATUS_SPVP;
>@@ -579,6 +581,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> 	csr->hvip = csr_read(CSR_HVIP);
> 	csr->vsatp = csr_read(CSR_VSATP);
> 	cfg->hedeleg = csr_read(CSR_HEDELEG);
>+	cfg->henvcfg = csr_read(CSR_HENVCFG);
>+	if (IS_ENABLED(CONFIG_32BIT))
>+		cfg->henvcfg = csr_read(CSR_HENVCFGH) << 32;
> }
>
> static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
>@@ -670,11 +675,12 @@ static __always_inline void kvm_riscv_vcpu_swap_in_host_state(struct kvm_vcpu *v
>  * This must be noinstr as instrumentation may make use of RCU, and this is not
>  * safe during the EQS.
>  */
>-static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>+static void noinstr kvm_riscv_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>+					      struct kvm_cpu_trap *trap)
> {
> 	kvm_riscv_vcpu_swap_in_guest_state(vcpu);
> 	guest_state_enter_irqoff();
>-	__kvm_riscv_switch_to(&vcpu->arch);
>+	__kvm_riscv_switch_to(&vcpu->arch, trap);
> 	vcpu->arch.last_exit_cpu = vcpu->cpu;
> 	guest_state_exit_irqoff();
> 	kvm_riscv_vcpu_swap_in_host_state(vcpu);
>@@ -789,22 +795,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>
> 		guest_timing_enter_irqoff();
>
>-		kvm_riscv_vcpu_enter_exit(vcpu);
>+		kvm_riscv_vcpu_enter_exit(vcpu, &trap);
>
> 		vcpu->mode = OUTSIDE_GUEST_MODE;
> 		vcpu->stat.exits++;
>
>-		/*
>-		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
>-		 * get an interrupt between __kvm_riscv_switch_to() and
>-		 * local_irq_enable() which can potentially change CSRs.
>-		 */
>-		trap.sepc = vcpu->arch.guest_context.sepc;
>-		trap.scause = csr_read(CSR_SCAUSE);
>-		trap.stval = csr_read(CSR_STVAL);
>-		trap.htval = csr_read(CSR_HTVAL);
>-		trap.htinst = csr_read(CSR_HTINST);
>-
> 		/* Syncup interrupts state with HW */
> 		kvm_riscv_vcpu_sync_interrupts(vcpu);
>
>diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
>index 2415722c01b8..892c6df97eaf 100644
>--- a/arch/riscv/kvm/vcpu_exit.c
>+++ b/arch/riscv/kvm/vcpu_exit.c
>@@ -126,17 +126,34 @@ unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
> 	return val;
> }
>
>+static int kvm_riscv_double_trap(struct kvm_vcpu *vcpu,
>+				 struct kvm_cpu_trap *trap)
>+{
>+	pr_err("Guest double trap");
>+	/* TODO: Implement SSE support */
>+
>+	return -EOPNOTSUPP;
>+}
>+
> /**
>  * kvm_riscv_vcpu_trap_redirect -- Redirect trap to Guest
>  *
>  * @vcpu: The VCPU pointer
>  * @trap: Trap details
>  */
>-void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>-				  struct kvm_cpu_trap *trap)
>+int kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>+				 struct kvm_cpu_trap *trap)
> {
> 	unsigned long vsstatus = csr_read(CSR_VSSTATUS);
>
>+	if (riscv_isa_extension_available(vcpu->arch.isa, SSDBLTRP)) {
>+		if (vsstatus & SR_SDT)
>+			return kvm_riscv_double_trap(vcpu, trap);
>+
>+		/* Set Double Trap bit to enable double trap detection */
>+		vsstatus |= SR_SDT;

I didn't get it.
Why do this without checking if current config allows us to do so ?
I am imagining we do this only when henvcfg for current vcpu says that DTE=1
for this this guest, right?

>+	}
>+
> 	/* Change Guest SSTATUS.SPP bit */
> 	vsstatus &= ~SR_SPP;
> 	if (vcpu->arch.guest_context.sstatus & SR_SPP)
>@@ -163,6 +180,8 @@ void kvm_riscv_vcpu_trap_redirect(struct kvm_vcpu *vcpu,
>
> 	/* Set Guest privilege mode to supervisor */
> 	vcpu->arch.guest_context.sstatus |= SR_SPP;
>+
>+	return 1;
> }
>
> /*
>@@ -185,10 +204,8 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 	case EXC_INST_ILLEGAL:
> 	case EXC_LOAD_MISALIGNED:
> 	case EXC_STORE_MISALIGNED:
>-		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV) {
>-			kvm_riscv_vcpu_trap_redirect(vcpu, trap);
>-			ret = 1;
>-		}
>+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>+			ret = kvm_riscv_vcpu_trap_redirect(vcpu, trap);
> 		break;
> 	case EXC_VIRTUAL_INST_FAULT:
> 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>@@ -204,6 +221,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
> 			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
> 		break;
>+	case EXC_DOUBLE_TRAP:
>+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
>+			ret = kvm_riscv_double_trap(vcpu, trap);
>+		break;
> 	default:
> 		break;
> 	}
>diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
>index 7a6abed41bc1..050e811204f2 100644
>--- a/arch/riscv/kvm/vcpu_insn.c
>+++ b/arch/riscv/kvm/vcpu_insn.c
>@@ -159,9 +159,8 @@ static int truly_illegal_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 	utrap.stval = insn;
> 	utrap.htval = 0;
> 	utrap.htinst = 0;
>-	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>
>-	return 1;
>+	return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> }
>
> static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
>@@ -175,9 +174,8 @@ static int truly_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 	utrap.stval = insn;
> 	utrap.htval = 0;
> 	utrap.htinst = 0;
>-	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>
>-	return 1;
>+	return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> }
>
> /**
>@@ -422,8 +420,7 @@ int kvm_riscv_vcpu_virtual_insn(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 							  &utrap);
> 			if (utrap.scause) {
> 				utrap.sepc = ct->sepc;
>-				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>-				return 1;
>+				return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> 			}
> 		}
> 		if (INSN_IS_16BIT(insn))
>@@ -478,8 +475,7 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 		if (utrap.scause) {
> 			/* Redirect trap if we failed to read instruction */
> 			utrap.sepc = ct->sepc;
>-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>-			return 1;
>+			return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> 		}
> 		insn_len = INSN_LEN(insn);
> 	}
>@@ -604,8 +600,7 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
> 		if (utrap.scause) {
> 			/* Redirect trap if we failed to read instruction */
> 			utrap.sepc = ct->sepc;
>-			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
>-			return 1;
>+			return kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
> 		}
> 		insn_len = INSN_LEN(insn);
> 	}
>diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
>index 5f7355e96008..fece0043871c 100644
>--- a/arch/riscv/kvm/vcpu_onereg.c
>+++ b/arch/riscv/kvm/vcpu_onereg.c
>@@ -36,6 +36,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
> 	/* Multi letter extensions (alphabetically sorted) */
> 	KVM_ISA_EXT_ARR(SMSTATEEN),
> 	KVM_ISA_EXT_ARR(SSAIA),
>+	KVM_ISA_EXT_ARR(SSDBLTRP),
> 	KVM_ISA_EXT_ARR(SSTC),
> 	KVM_ISA_EXT_ARR(SVINVAL),
> 	KVM_ISA_EXT_ARR(SVNAPOT),
>@@ -153,6 +154,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
> 	case KVM_RISCV_ISA_EXT_ZVKSED:
> 	case KVM_RISCV_ISA_EXT_ZVKSH:
> 	case KVM_RISCV_ISA_EXT_ZVKT:
>+	case KVM_RISCV_ISA_EXT_SSDBLTRP:
> 		return false;
> 	/* Extensions which can be disabled using Smstateen */
> 	case KVM_RISCV_ISA_EXT_SSAIA:
>diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
>index 76901f0f34b7..b839d578dc26 100644
>--- a/arch/riscv/kvm/vcpu_sbi.c
>+++ b/arch/riscv/kvm/vcpu_sbi.c
>@@ -456,10 +456,8 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>
> 	/* Handle special error cases i.e trap, exit or userspace forward */
> 	if (sbi_ret.utrap->scause) {
>-		/* No need to increment sepc or exit ioctl loop */
>-		ret = 1;
> 		sbi_ret.utrap->sepc = cp->sepc;
>-		kvm_riscv_vcpu_trap_redirect(vcpu, sbi_ret.utrap);
>+		ret = kvm_riscv_vcpu_trap_redirect(vcpu, sbi_ret.utrap);
> 		next_sepc = false;
> 		goto ecall_done;
> 	}
>diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
>index 0c26189aa01c..94d5eb9da788 100644
>--- a/arch/riscv/kvm/vcpu_switch.S
>+++ b/arch/riscv/kvm/vcpu_switch.S
>@@ -154,7 +154,6 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
> 	REG_L	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
> 	REG_L	t3, (KVM_ARCH_HOST_SCOUNTEREN)(a0)
> 	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
>-	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
>
> 	/* Save Guest SEPC */
> 	csrr	t0, CSR_SEPC
>@@ -171,8 +170,8 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
> 	/* Save Guest and Restore Host HSTATUS */
> 	csrrw	t4, CSR_HSTATUS, t4
>
>-	/* Save Guest and Restore Host SSTATUS */
>-	csrrw	t5, CSR_SSTATUS, t5
>+	/* Save Guest SSTATUS */
>+	csrr	t5, CSR_SSTATUS
>
> 	/* Store Guest CSR values */
> 	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
>@@ -206,6 +205,20 @@ SYM_FUNC_START(__kvm_riscv_switch_to)
> 	REG_L	s10, (KVM_ARCH_HOST_S10)(a0)
> 	REG_L	s11, (KVM_ARCH_HOST_S11)(a0)
>
>+	csrr	t1, CSR_SCAUSE
>+	csrr	t2, CSR_STVAL
>+	csrr	t3, CSR_HTVAL
>+	csrr	t4, CSR_HTINST
>+	REG_S	t0, (KVM_ARCH_TRAP_SEPC)(a1)
>+	REG_S	t1, (KVM_ARCH_TRAP_SCAUSE)(a1)
>+	REG_S	t2, (KVM_ARCH_TRAP_STVAL)(a1)
>+	REG_S	t3, (KVM_ARCH_TRAP_HTVAL)(a1)
>+	REG_S	t4, (KVM_ARCH_TRAP_HTINST)(a1)
>+
>+	/* Restore Host SSTATUS */
>+	REG_L	t5, (KVM_ARCH_HOST_SSTATUS)(a0)
>+	csrw	CSR_SSTATUS, t5
>+
> 	/* Return to C code */
> 	ret
> SYM_FUNC_END(__kvm_riscv_switch_to)
>-- 
>2.43.0
>
>

