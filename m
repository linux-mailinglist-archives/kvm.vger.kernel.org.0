Return-Path: <kvm+bounces-42345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0326AA77FF1
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:15:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0A14188E293
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:14:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740A321CC58;
	Tue,  1 Apr 2025 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GmbzESzK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF2121ABB4
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523906; cv=none; b=u5rlKqT2UBQ9aCvzIexyfYcDObFS1q4So8WDY8MfCWCt3u2briBQKwoYmXncHMVCWtJxXAstYxxXYJ/fadVvfIEuEBfNPoJOBcu4SLbClCbUeaMo5cnYcI/QY12Y4qv4SfPxOHRDjdvxuCF+uUs5oBOKBU0VF+rtBz84o6kXbKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523906; c=relaxed/simple;
	bh=kEadPKdm26YjO/piLtcno0OXMST7Rw/BeIh7YNl9zus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxWuyqVGJEygTmELte1Z9rgn9qPn1oq2PMDm0baq3leB8112jp4hbbgifyEMWxg9WI8l6xXtdInaD4w+ZTZrpDRTHo/lwIvJW3zZQGaxWm/eYDI0xsZEYarJrss+2C7GHF3UDiBIkb0XrIu14HXunmOwZxhSWH1eziye3UN1s98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GmbzESzK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hCHXVPRRw32Pd1RYLwaglPcIyP0wPV42w+9KPzLStsA=;
	b=GmbzESzKf2ZKYhtDpaTa0hBcu3oFmbrSlTcqSzLBIj8dyi6/r6o34yS6M592hy4q0XUMb8
	8oJa0gKHBx5wR6YrfzPzptQ+RHvfFPhKXfaUWkEtgzH+9jdbtUWY0RNSEndC25Sa2SskY/
	o0wc+4oybRSOsHB23xqfw8vDptv9gPA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-vCxPSDnUPGyKSUlD0VwT1Q-1; Tue, 01 Apr 2025 12:11:39 -0400
X-MC-Unique: vCxPSDnUPGyKSUlD0VwT1Q-1
X-Mimecast-MFC-AGG-ID: vCxPSDnUPGyKSUlD0VwT1Q_1743523898
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912fe32b08so3300901f8f.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523898; x=1744128698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hCHXVPRRw32Pd1RYLwaglPcIyP0wPV42w+9KPzLStsA=;
        b=tO6Mxve/ireBG+LVvJiqw8CCnClgBT52MjWe2cqjfufsfGkbvX267Lqq0eb4hQm+8E
         RbQ5gKB3T4Ea/+NrCfOE5UW2vUARg3Ao/3b3SaL83HzS+wQ5f6eJIey7coWjeMmAQMe/
         cyPOvMUT6oKNVRV+td9h12JPl7u7hkxHbpsRzg7zRMCrejx608JNauzvaUo79LCVzPQZ
         gK0eKwp5stbV0/mnt3o1tzM4oVcawMWOeWC04FkBI1SRypH6iyzTY+uA+7H/WbYSawKD
         kjGF1v6ycRm1K4B9UZLZnZPUj4T/Wd6LsW2NX2CjG5/zDA0jNJZv3BqLXlEfBwC8ns2B
         T8bw==
X-Forwarded-Encrypted: i=1; AJvYcCXABvhThrUSDo3/o1+qg7PlWTFYeWVwhHVTWKYwfydoYtYu0c7Vyfbo+ijpdJ7tWco0shU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3gkgNNNoKDL+auMDeP2C1YnIHpdSo+/qTfu5xIlRUtTrqK2BW
	pj/Lp7lTZep1TJvELQQ9gLe3OiSqHvkCvIbIGaheTJ4TwoA1jWTCkRY2M4KlblX3XkKjKBM8+Ep
	BUim35RdoSENxdZ8fKOEFiqN2qMthDk0PsWF4b/FPjnuksAAqyg==
X-Gm-Gg: ASbGncunziyTBmjCVHzicBsiggCletoxeyJwnb0LloMuDeSKVFfZ+czizDgYMVnMF5w
	ulrZdBTvrswQs4YU46B9nKHFb80cZo2+GRMkwtOrL61XYkuDODDhd6bvEHrNO/s4uoDCDQRjX8X
	40HnugKq7A83HS8YhjTyzV8mkWG2Iv7+SYCIAFl9fXotVu6xsZRi9kjrbFFLgcInHpx1wPfCcOd
	+TCfReof+ychMqJCMtmfDuuY98XUKpJUKXj02LhDYqCzfClcLRa4RqO/p2MLafUi4gyh5dcutqZ
	7gkuuL7s0fD+3mIhiw0V5w==
X-Received: by 2002:a05:6000:2910:b0:391:39bd:a381 with SMTP id ffacd0b85a97d-39c120e3eebmr11210915f8f.30.1743523896326;
        Tue, 01 Apr 2025 09:11:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqqHlFfEfqmQu9lXk0Qp8CQTjqYvrEJE3OM2uPTiGullHjMI6tXRieoqUgnFZx9Yd8mHv74A==
X-Received: by 2002:a05:6000:2910:b0:391:39bd:a381 with SMTP id ffacd0b85a97d-39c120e3eebmr11210831f8f.30.1743523895269;
        Tue, 01 Apr 2025 09:11:35 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b662c05sm14316291f8f.23.2025.04.01.09.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:33 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 10/29] KVM: share statistics for same vCPU id on different planes
Date: Tue,  1 Apr 2025 18:10:47 +0200
Message-ID: <20250401161106.790710-11-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Statistics are protected by vcpu->mutex; because KVM_RUN takes the
plane-0 vCPU mutex, there is no race on applying statistics for all
planes to the plane-0 kvm_vcpu struct.

This saves the burden on the kernel of implementing the binary stats
interface for vCPU plane file descriptors, and on userspace of gathering
info from multiple planes.  The disadvantage is a slight loss of
information, and an extra pointer dereference when updating stats.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/arm.c                 |  2 +-
 arch/arm64/kvm/handle_exit.c         |  6 +--
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c |  4 +-
 arch/arm64/kvm/mmio.c                |  4 +-
 arch/loongarch/kvm/exit.c            |  8 ++--
 arch/loongarch/kvm/vcpu.c            |  2 +-
 arch/mips/kvm/emulate.c              |  2 +-
 arch/mips/kvm/mips.c                 | 30 +++++++-------
 arch/mips/kvm/vz.c                   | 18 ++++-----
 arch/powerpc/kvm/book3s.c            |  2 +-
 arch/powerpc/kvm/book3s_hv.c         | 46 ++++++++++-----------
 arch/powerpc/kvm/book3s_hv_rm_xics.c |  8 ++--
 arch/powerpc/kvm/book3s_pr.c         | 22 +++++-----
 arch/powerpc/kvm/book3s_pr_papr.c    |  2 +-
 arch/powerpc/kvm/powerpc.c           |  4 +-
 arch/powerpc/kvm/timing.h            | 28 ++++++-------
 arch/riscv/kvm/vcpu.c                |  2 +-
 arch/riscv/kvm/vcpu_exit.c           | 10 ++---
 arch/riscv/kvm/vcpu_insn.c           | 16 ++++----
 arch/riscv/kvm/vcpu_sbi.c            |  2 +-
 arch/riscv/kvm/vcpu_sbi_hsm.c        |  2 +-
 arch/s390/kvm/diag.c                 | 18 ++++-----
 arch/s390/kvm/intercept.c            | 20 +++++-----
 arch/s390/kvm/interrupt.c            | 48 +++++++++++-----------
 arch/s390/kvm/kvm-s390.c             |  8 ++--
 arch/s390/kvm/priv.c                 | 60 ++++++++++++++--------------
 arch/s390/kvm/sigp.c                 | 50 +++++++++++------------
 arch/s390/kvm/vsie.c                 |  2 +-
 arch/x86/kvm/debugfs.c               |  2 +-
 arch/x86/kvm/hyperv.c                |  4 +-
 arch/x86/kvm/kvm_cache_regs.h        |  4 +-
 arch/x86/kvm/mmu/mmu.c               | 18 ++++-----
 arch/x86/kvm/mmu/tdp_mmu.c           |  2 +-
 arch/x86/kvm/svm/sev.c               |  2 +-
 arch/x86/kvm/svm/svm.c               | 18 ++++-----
 arch/x86/kvm/vmx/tdx.c               |  8 ++--
 arch/x86/kvm/vmx/vmx.c               | 20 +++++-----
 arch/x86/kvm/x86.c                   | 40 +++++++++----------
 include/linux/kvm_host.h             |  5 ++-
 virt/kvm/kvm_main.c                  | 19 ++++-----
 40 files changed, 285 insertions(+), 283 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0160b4924351..94fae442a8b8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1187,7 +1187,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		ret = kvm_arm_vcpu_enter_exit(vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
-		vcpu->stat.exits++;
+		vcpu->stat->exits++;
 		/*
 		 * Back from guest
 		 *************************************************************/
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 512d152233ff..b4f69beedd88 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -38,7 +38,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 {
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
-	vcpu->stat.hvc_exit_stat++;
+	vcpu->stat->hvc_exit_stat++;
 
 	/* Forward hvc instructions to the virtual EL2 if the guest has EL2. */
 	if (vcpu_has_nv(vcpu)) {
@@ -132,10 +132,10 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 
 	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
-		vcpu->stat.wfe_exit_stat++;
+		vcpu->stat->wfe_exit_stat++;
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
-		vcpu->stat.wfi_exit_stat++;
+		vcpu->stat->wfi_exit_stat++;
 	}
 
 	if (esr & ESR_ELx_WFx_ISS_WFxT) {
diff --git a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
index b63f4e1c1033..b7c3f3b8cc26 100644
--- a/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
+++ b/arch/arm64/kvm/hyp/nvhe/gen-hyprel.c
@@ -266,7 +266,7 @@ static void init_elf(const char *path)
 	}
 
 	/* mmap() the entire ELF file read-only at an arbitrary address. */
-	elf.begin = mmap(0, stat.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	elf.begin = mmap(0, stat->st_size, PROT_READ, MAP_PRIVATE, fd, 0);
 	if (elf.begin == MAP_FAILED) {
 		close(fd);
 		fatal_perror("Could not mmap ELF file");
@@ -276,7 +276,7 @@ static void init_elf(const char *path)
 	close(fd);
 
 	/* Get pointer to the ELF header. */
-	assert_ge(stat.st_size, sizeof(*elf.ehdr), "%lu");
+	assert_ge(stat->st_size, sizeof(*elf.ehdr), "%lu");
 	elf.ehdr = elf_ptr(Elf64_Ehdr, 0);
 
 	/* Check the ELF magic. */
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index ab365e839874..96c5fd5146ba 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -221,14 +221,14 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 		/* We handled the access successfully in the kernel. */
 		if (!is_write)
 			memcpy(run->mmio.data, data_buf, len);
-		vcpu->stat.mmio_exit_kernel++;
+		vcpu->stat->mmio_exit_kernel++;
 		kvm_handle_mmio_return(vcpu);
 		return 1;
 	}
 
 	if (is_write)
 		memcpy(run->mmio.data, data_buf, len);
-	vcpu->stat.mmio_exit_user++;
+	vcpu->stat->mmio_exit_user++;
 	run->exit_reason	= KVM_EXIT_MMIO;
 	return 0;
 }
diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index ea321403644a..ee5b3673efc8 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -31,7 +31,7 @@ static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
 
 	rd = inst.reg2_format.rd;
 	rj = inst.reg2_format.rj;
-	++vcpu->stat.cpucfg_exits;
+	++vcpu->stat->cpucfg_exits;
 	index = vcpu->arch.gprs[rj];
 
 	/*
@@ -264,7 +264,7 @@ int kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 int kvm_emu_idle(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.idle_exits;
+	++vcpu->stat->idle_exits;
 	trace_kvm_exit_idle(vcpu, KVM_TRACE_EXIT_IDLE);
 
 	if (!kvm_arch_vcpu_runnable(vcpu))
@@ -884,7 +884,7 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 
 	switch (code) {
 	case KVM_HCALL_SERVICE:
-		vcpu->stat.hypercall_exits++;
+		vcpu->stat->hypercall_exits++;
 		kvm_handle_service(vcpu);
 		break;
 	case KVM_HCALL_USER_SERVICE:
@@ -893,7 +893,7 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
 			break;
 		}
 
-		vcpu->stat.hypercall_exits++;
+		vcpu->stat->hypercall_exits++;
 		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
 		vcpu->run->hypercall.nr = KVM_HCALL_USER_SERVICE;
 		vcpu->run->hypercall.args[0] = kvm_read_reg(vcpu, LOONGARCH_GPR_A0);
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 552cde722932..470c79e79281 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -330,7 +330,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 		ret = kvm_handle_fault(vcpu, ecode);
 	} else {
 		WARN(!intr, "vm exiting with suspicious irq\n");
-		++vcpu->stat.int_exits;
+		++vcpu->stat->int_exits;
 	}
 
 	if (ret == RESUME_GUEST)
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index 0feec52222fb..c9f83b500078 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -947,7 +947,7 @@ enum emulation_result kvm_mips_emul_wait(struct kvm_vcpu *vcpu)
 	kvm_debug("[%#lx] !!!WAIT!!! (%#lx)\n", vcpu->arch.pc,
 		  vcpu->arch.pending_exceptions);
 
-	++vcpu->stat.wait_exits;
+	++vcpu->stat->wait_exits;
 	trace_kvm_exit(vcpu, KVM_TRACE_EXIT_WAIT);
 	if (!vcpu->arch.pending_exceptions) {
 		kvm_vz_lose_htimer(vcpu);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 60b43ea85c12..77637d201699 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1199,7 +1199,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 	case EXCCODE_INT:
 		kvm_debug("[%d]EXCCODE_INT @ %p\n", vcpu->vcpu_id, opc);
 
-		++vcpu->stat.int_exits;
+		++vcpu->stat->int_exits;
 
 		if (need_resched())
 			cond_resched();
@@ -1210,7 +1210,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 	case EXCCODE_CPU:
 		kvm_debug("EXCCODE_CPU: @ PC: %p\n", opc);
 
-		++vcpu->stat.cop_unusable_exits;
+		++vcpu->stat->cop_unusable_exits;
 		ret = kvm_mips_callbacks->handle_cop_unusable(vcpu);
 		/* XXXKYMA: Might need to return to user space */
 		if (run->exit_reason == KVM_EXIT_IRQ_WINDOW_OPEN)
@@ -1218,7 +1218,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		break;
 
 	case EXCCODE_MOD:
-		++vcpu->stat.tlbmod_exits;
+		++vcpu->stat->tlbmod_exits;
 		ret = kvm_mips_callbacks->handle_tlb_mod(vcpu);
 		break;
 
@@ -1227,7 +1227,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 			  cause, kvm_read_c0_guest_status(&vcpu->arch.cop0), opc,
 			  badvaddr);
 
-		++vcpu->stat.tlbmiss_st_exits;
+		++vcpu->stat->tlbmiss_st_exits;
 		ret = kvm_mips_callbacks->handle_tlb_st_miss(vcpu);
 		break;
 
@@ -1235,52 +1235,52 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		kvm_debug("TLB LD fault: cause %#x, PC: %p, BadVaddr: %#lx\n",
 			  cause, opc, badvaddr);
 
-		++vcpu->stat.tlbmiss_ld_exits;
+		++vcpu->stat->tlbmiss_ld_exits;
 		ret = kvm_mips_callbacks->handle_tlb_ld_miss(vcpu);
 		break;
 
 	case EXCCODE_ADES:
-		++vcpu->stat.addrerr_st_exits;
+		++vcpu->stat->addrerr_st_exits;
 		ret = kvm_mips_callbacks->handle_addr_err_st(vcpu);
 		break;
 
 	case EXCCODE_ADEL:
-		++vcpu->stat.addrerr_ld_exits;
+		++vcpu->stat->addrerr_ld_exits;
 		ret = kvm_mips_callbacks->handle_addr_err_ld(vcpu);
 		break;
 
 	case EXCCODE_SYS:
-		++vcpu->stat.syscall_exits;
+		++vcpu->stat->syscall_exits;
 		ret = kvm_mips_callbacks->handle_syscall(vcpu);
 		break;
 
 	case EXCCODE_RI:
-		++vcpu->stat.resvd_inst_exits;
+		++vcpu->stat->resvd_inst_exits;
 		ret = kvm_mips_callbacks->handle_res_inst(vcpu);
 		break;
 
 	case EXCCODE_BP:
-		++vcpu->stat.break_inst_exits;
+		++vcpu->stat->break_inst_exits;
 		ret = kvm_mips_callbacks->handle_break(vcpu);
 		break;
 
 	case EXCCODE_TR:
-		++vcpu->stat.trap_inst_exits;
+		++vcpu->stat->trap_inst_exits;
 		ret = kvm_mips_callbacks->handle_trap(vcpu);
 		break;
 
 	case EXCCODE_MSAFPE:
-		++vcpu->stat.msa_fpe_exits;
+		++vcpu->stat->msa_fpe_exits;
 		ret = kvm_mips_callbacks->handle_msa_fpe(vcpu);
 		break;
 
 	case EXCCODE_FPE:
-		++vcpu->stat.fpe_exits;
+		++vcpu->stat->fpe_exits;
 		ret = kvm_mips_callbacks->handle_fpe(vcpu);
 		break;
 
 	case EXCCODE_MSADIS:
-		++vcpu->stat.msa_disabled_exits;
+		++vcpu->stat->msa_disabled_exits;
 		ret = kvm_mips_callbacks->handle_msa_disabled(vcpu);
 		break;
 
@@ -1317,7 +1317,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			run->exit_reason = KVM_EXIT_INTR;
 			ret = (-EINTR << 2) | RESUME_HOST;
-			++vcpu->stat.signal_exits;
+			++vcpu->stat->signal_exits;
 			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_SIGNAL);
 		}
 	}
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index ccab4d76b126..c37fd7b3e608 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -1162,7 +1162,7 @@ static enum emulation_result kvm_vz_gpsi_lwc2(union mips_instruction inst,
 	rd = inst.loongson3_lscsr_format.rd;
 	switch (inst.loongson3_lscsr_format.fr) {
 	case 0x8:  /* Read CPUCFG */
-		++vcpu->stat.vz_cpucfg_exits;
+		++vcpu->stat->vz_cpucfg_exits;
 		hostcfg = read_cpucfg(vcpu->arch.gprs[rs]);
 
 		switch (vcpu->arch.gprs[rs]) {
@@ -1491,38 +1491,38 @@ static int kvm_trap_vz_handle_guest_exit(struct kvm_vcpu *vcpu)
 	trace_kvm_exit(vcpu, KVM_TRACE_EXIT_GEXCCODE_BASE + gexccode);
 	switch (gexccode) {
 	case MIPS_GCTL0_GEXC_GPSI:
-		++vcpu->stat.vz_gpsi_exits;
+		++vcpu->stat->vz_gpsi_exits;
 		er = kvm_trap_vz_handle_gpsi(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GSFC:
-		++vcpu->stat.vz_gsfc_exits;
+		++vcpu->stat->vz_gsfc_exits;
 		er = kvm_trap_vz_handle_gsfc(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_HC:
-		++vcpu->stat.vz_hc_exits;
+		++vcpu->stat->vz_hc_exits;
 		er = kvm_trap_vz_handle_hc(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GRR:
-		++vcpu->stat.vz_grr_exits;
+		++vcpu->stat->vz_grr_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GVA:
-		++vcpu->stat.vz_gva_exits;
+		++vcpu->stat->vz_gva_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GHFC:
-		++vcpu->stat.vz_ghfc_exits;
+		++vcpu->stat->vz_ghfc_exits;
 		er = kvm_trap_vz_handle_ghfc(cause, opc, vcpu);
 		break;
 	case MIPS_GCTL0_GEXC_GPA:
-		++vcpu->stat.vz_gpa_exits;
+		++vcpu->stat->vz_gpa_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
 	default:
-		++vcpu->stat.vz_resvd_exits;
+		++vcpu->stat->vz_resvd_exits;
 		er = kvm_trap_vz_no_handler_guest_exit(gexccode, cause, opc,
 						       vcpu);
 		break;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d79c5d1098c0..7ea6955cd96c 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -178,7 +178,7 @@ void kvmppc_book3s_dequeue_irqprio(struct kvm_vcpu *vcpu,
 
 void kvmppc_book3s_queue_irqprio(struct kvm_vcpu *vcpu, unsigned int vec)
 {
-	vcpu->stat.queue_intr++;
+	vcpu->stat->queue_intr++;
 
 	set_bit(kvmppc_book3s_vec2irqprio(vec),
 		&vcpu->arch.pending_exceptions);
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 86bff159c51e..6e94ffc0bb6b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -238,7 +238,7 @@ static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 
 	waitp = kvm_arch_vcpu_get_wait(vcpu);
 	if (rcuwait_wake_up(waitp))
-		++vcpu->stat.generic.halt_wakeup;
+		++vcpu->stat->generic.halt_wakeup;
 
 	cpu = READ_ONCE(vcpu->arch.thread_cpu);
 	if (cpu >= 0 && kvmppc_ipi_thread(cpu))
@@ -1633,7 +1633,7 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 	struct kvm_run *run = vcpu->run;
 	int r = RESUME_HOST;
 
-	vcpu->stat.sum_exits++;
+	vcpu->stat->sum_exits++;
 
 	/*
 	 * This can happen if an interrupt occurs in the last stages
@@ -1662,13 +1662,13 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
 		fallthrough;
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
-		vcpu->stat.dec_exits++;
+		vcpu->stat->dec_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
 	case BOOK3S_INTERRUPT_H_DOORBELL:
 	case BOOK3S_INTERRUPT_H_VIRT:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->stat->ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 	/* SR/HMI/PMI are HV interrupts that host has handled. Resume guest.*/
@@ -1971,7 +1971,7 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	int r;
 	int srcu_idx;
 
-	vcpu->stat.sum_exits++;
+	vcpu->stat->sum_exits++;
 
 	/*
 	 * This can happen if an interrupt occurs in the last stages
@@ -1992,22 +1992,22 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 	switch (vcpu->arch.trap) {
 	/* We're good on these - the host merely wanted to get our attention */
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
-		vcpu->stat.dec_exits++;
+		vcpu->stat->dec_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->stat->ext_intr_exits++;
 		r = RESUME_HOST;
 		break;
 	case BOOK3S_INTERRUPT_H_DOORBELL:
 	case BOOK3S_INTERRUPT_H_VIRT:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->stat->ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 	/* These need to go to the nested HV */
 	case BOOK3S_INTERRUPT_NESTED_HV_DECREMENTER:
 		vcpu->arch.trap = BOOK3S_INTERRUPT_HV_DECREMENTER;
-		vcpu->stat.dec_exits++;
+		vcpu->stat->dec_exits++;
 		r = RESUME_HOST;
 		break;
 	/* SR/HMI/PMI are HV interrupts that host has handled. Resume guest.*/
@@ -4614,7 +4614,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	cur = start_poll = ktime_get();
 	if (vc->halt_poll_ns) {
 		ktime_t stop = ktime_add_ns(start_poll, vc->halt_poll_ns);
-		++vc->runner->stat.generic.halt_attempted_poll;
+		++vc->runner->stat->generic.halt_attempted_poll;
 
 		vc->vcore_state = VCORE_POLLING;
 		spin_unlock(&vc->lock);
@@ -4631,7 +4631,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 		vc->vcore_state = VCORE_INACTIVE;
 
 		if (!do_sleep) {
-			++vc->runner->stat.generic.halt_successful_poll;
+			++vc->runner->stat->generic.halt_successful_poll;
 			goto out;
 		}
 	}
@@ -4643,7 +4643,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 		do_sleep = 0;
 		/* If we polled, count this as a successful poll */
 		if (vc->halt_poll_ns)
-			++vc->runner->stat.generic.halt_successful_poll;
+			++vc->runner->stat->generic.halt_successful_poll;
 		goto out;
 	}
 
@@ -4657,7 +4657,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
 	trace_kvmppc_vcore_blocked(vc->runner, 1);
-	++vc->runner->stat.halt_successful_wait;
+	++vc->runner->stat->halt_successful_wait;
 
 	cur = ktime_get();
 
@@ -4666,29 +4666,29 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 
 	/* Attribute wait time */
 	if (do_sleep) {
-		vc->runner->stat.generic.halt_wait_ns +=
+		vc->runner->stat->generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(start_wait);
 		KVM_STATS_LOG_HIST_UPDATE(
-				vc->runner->stat.generic.halt_wait_hist,
+				vc->runner->stat->generic.halt_wait_hist,
 				ktime_to_ns(cur) - ktime_to_ns(start_wait));
 		/* Attribute failed poll time */
 		if (vc->halt_poll_ns) {
-			vc->runner->stat.generic.halt_poll_fail_ns +=
+			vc->runner->stat->generic.halt_poll_fail_ns +=
 				ktime_to_ns(start_wait) -
 				ktime_to_ns(start_poll);
 			KVM_STATS_LOG_HIST_UPDATE(
-				vc->runner->stat.generic.halt_poll_fail_hist,
+				vc->runner->stat->generic.halt_poll_fail_hist,
 				ktime_to_ns(start_wait) -
 				ktime_to_ns(start_poll));
 		}
 	} else {
 		/* Attribute successful poll time */
 		if (vc->halt_poll_ns) {
-			vc->runner->stat.generic.halt_poll_success_ns +=
+			vc->runner->stat->generic.halt_poll_success_ns +=
 				ktime_to_ns(cur) -
 				ktime_to_ns(start_poll);
 			KVM_STATS_LOG_HIST_UPDATE(
-				vc->runner->stat.generic.halt_poll_success_hist,
+				vc->runner->stat->generic.halt_poll_success_hist,
 				ktime_to_ns(cur) - ktime_to_ns(start_poll));
 		}
 	}
@@ -4807,7 +4807,7 @@ static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 			kvmppc_core_prepare_to_enter(v);
 			if (signal_pending(v->arch.run_task)) {
 				kvmppc_remove_runnable(vc, v, mftb());
-				v->stat.signal_exits++;
+				v->stat->signal_exits++;
 				v->run->exit_reason = KVM_EXIT_INTR;
 				v->arch.ret = -EINTR;
 				wake_up(&v->arch.cpu_run);
@@ -4848,7 +4848,7 @@ static int kvmppc_run_vcpu(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.state == KVMPPC_VCPU_RUNNABLE) {
 		kvmppc_remove_runnable(vc, vcpu, mftb());
-		vcpu->stat.signal_exits++;
+		vcpu->stat->signal_exits++;
 		run->exit_reason = KVM_EXIT_INTR;
 		vcpu->arch.ret = -EINTR;
 	}
@@ -5047,7 +5047,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 		for (;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (signal_pending(current)) {
-				vcpu->stat.signal_exits++;
+				vcpu->stat->signal_exits++;
 				run->exit_reason = KVM_EXIT_INTR;
 				vcpu->arch.ret = -EINTR;
 				break;
@@ -5070,7 +5070,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 	return vcpu->arch.ret;
 
  sigpend:
-	vcpu->stat.signal_exits++;
+	vcpu->stat->signal_exits++;
 	run->exit_reason = KVM_EXIT_INTR;
 	vcpu->arch.ret = -EINTR;
  out:
diff --git a/arch/powerpc/kvm/book3s_hv_rm_xics.c b/arch/powerpc/kvm/book3s_hv_rm_xics.c
index f2636414d82a..59f740a88581 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_xics.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_xics.c
@@ -132,7 +132,7 @@ static void icp_rm_set_vcpu_irq(struct kvm_vcpu *vcpu,
 	int hcore;
 
 	/* Mark the target VCPU as having an interrupt pending */
-	vcpu->stat.queue_intr++;
+	vcpu->stat->queue_intr++;
 	set_bit(BOOK3S_IRQPRIO_EXTERNAL, &vcpu->arch.pending_exceptions);
 
 	/* Kick self ? Just set MER and return */
@@ -713,14 +713,14 @@ static int ics_rm_eoi(struct kvm_vcpu *vcpu, u32 irq)
 
 	/* Handle passthrough interrupts */
 	if (state->host_irq) {
-		++vcpu->stat.pthru_all;
+		++vcpu->stat->pthru_all;
 		if (state->intr_cpu != -1) {
 			int pcpu = raw_smp_processor_id();
 
 			pcpu = cpu_first_thread_sibling(pcpu);
-			++vcpu->stat.pthru_host;
+			++vcpu->stat->pthru_host;
 			if (state->intr_cpu != pcpu) {
-				++vcpu->stat.pthru_bad_aff;
+				++vcpu->stat->pthru_bad_aff;
 				xics_opal_set_server(state->host_irq, pcpu);
 			}
 			state->intr_cpu = -1;
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 83bcdc80ce51..8cbf7ecc796d 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -493,7 +493,7 @@ static void kvmppc_set_msr_pr(struct kvm_vcpu *vcpu, u64 msr)
 	if (msr & MSR_POW) {
 		if (!vcpu->arch.pending_exceptions) {
 			kvm_vcpu_halt(vcpu);
-			vcpu->stat.generic.halt_wakeup++;
+			vcpu->stat->generic.halt_wakeup++;
 
 			/* Unset POW bit after we woke up */
 			msr &= ~MSR_POW;
@@ -776,13 +776,13 @@ static int kvmppc_handle_pagefault(struct kvm_vcpu *vcpu,
 			return RESUME_HOST;
 		}
 		if (data)
-			vcpu->stat.sp_storage++;
+			vcpu->stat->sp_storage++;
 		else if (vcpu->arch.mmu.is_dcbz32(vcpu) &&
 			 (!(vcpu->arch.hflags & BOOK3S_HFLAG_DCBZ32)))
 			kvmppc_patch_dcbz(vcpu, &pte);
 	} else {
 		/* MMIO */
-		vcpu->stat.mmio_exits++;
+		vcpu->stat->mmio_exits++;
 		vcpu->arch.paddr_accessed = pte.raddr;
 		vcpu->arch.vaddr_accessed = pte.eaddr;
 		r = kvmppc_emulate_mmio(vcpu);
@@ -1103,7 +1103,7 @@ static int kvmppc_exit_pr_progint(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 		}
 	}
 
-	vcpu->stat.emulated_inst_exits++;
+	vcpu->stat->emulated_inst_exits++;
 	er = kvmppc_emulate_instruction(vcpu);
 	switch (er) {
 	case EMULATE_DONE:
@@ -1138,7 +1138,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	int r = RESUME_HOST;
 	int s;
 
-	vcpu->stat.sum_exits++;
+	vcpu->stat->sum_exits++;
 
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	run->ready_for_interrupt_injection = 1;
@@ -1152,7 +1152,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	case BOOK3S_INTERRUPT_INST_STORAGE:
 	{
 		ulong shadow_srr1 = vcpu->arch.shadow_srr1;
-		vcpu->stat.pf_instruc++;
+		vcpu->stat->pf_instruc++;
 
 		if (kvmppc_is_split_real(vcpu))
 			kvmppc_fixup_split_real(vcpu);
@@ -1180,7 +1180,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 			int idx = srcu_read_lock(&vcpu->kvm->srcu);
 			r = kvmppc_handle_pagefault(vcpu, kvmppc_get_pc(vcpu), exit_nr);
 			srcu_read_unlock(&vcpu->kvm->srcu, idx);
-			vcpu->stat.sp_instruc++;
+			vcpu->stat->sp_instruc++;
 		} else if (vcpu->arch.mmu.is_dcbz32(vcpu) &&
 			  (!(vcpu->arch.hflags & BOOK3S_HFLAG_DCBZ32))) {
 			/*
@@ -1201,7 +1201,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	{
 		ulong dar = kvmppc_get_fault_dar(vcpu);
 		u32 fault_dsisr = vcpu->arch.fault_dsisr;
-		vcpu->stat.pf_storage++;
+		vcpu->stat->pf_storage++;
 
 #ifdef CONFIG_PPC_BOOK3S_32
 		/* We set segments as unused segments when invalidating them. So
@@ -1256,13 +1256,13 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 	case BOOK3S_INTERRUPT_HV_DECREMENTER:
 	case BOOK3S_INTERRUPT_DOORBELL:
 	case BOOK3S_INTERRUPT_H_DOORBELL:
-		vcpu->stat.dec_exits++;
+		vcpu->stat->dec_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_EXTERNAL:
 	case BOOK3S_INTERRUPT_EXTERNAL_HV:
 	case BOOK3S_INTERRUPT_H_VIRT:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->stat->ext_intr_exits++;
 		r = RESUME_GUEST;
 		break;
 	case BOOK3S_INTERRUPT_HMI:
@@ -1331,7 +1331,7 @@ int kvmppc_handle_exit_pr(struct kvm_vcpu *vcpu, unsigned int exit_nr)
 			r = RESUME_GUEST;
 		} else {
 			/* Guest syscalls */
-			vcpu->stat.syscall_exits++;
+			vcpu->stat->syscall_exits++;
 			kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
 			r = RESUME_GUEST;
 		}
diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
index b2c89e850d7a..8f007a86de40 100644
--- a/arch/powerpc/kvm/book3s_pr_papr.c
+++ b/arch/powerpc/kvm/book3s_pr_papr.c
@@ -393,7 +393,7 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
 	case H_CEDE:
 		kvmppc_set_msr_fast(vcpu, kvmppc_get_msr(vcpu) | MSR_EE);
 		kvm_vcpu_halt(vcpu);
-		vcpu->stat.generic.halt_wakeup++;
+		vcpu->stat->generic.halt_wakeup++;
 		return EMULATE_DONE;
 	case H_LOGICAL_CI_LOAD:
 		return kvmppc_h_pr_logical_ci_load(vcpu);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index ce1d91eed231..a39919dbaffb 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -352,7 +352,7 @@ int kvmppc_st(struct kvm_vcpu *vcpu, ulong *eaddr, int size, void *ptr,
 	struct kvmppc_pte pte;
 	int r = -EINVAL;
 
-	vcpu->stat.st++;
+	vcpu->stat->st++;
 
 	if (vcpu->kvm->arch.kvm_ops && vcpu->kvm->arch.kvm_ops->store_to_eaddr)
 		r = vcpu->kvm->arch.kvm_ops->store_to_eaddr(vcpu, eaddr, ptr,
@@ -395,7 +395,7 @@ int kvmppc_ld(struct kvm_vcpu *vcpu, ulong *eaddr, int size, void *ptr,
 	struct kvmppc_pte pte;
 	int rc = -EINVAL;
 
-	vcpu->stat.ld++;
+	vcpu->stat->ld++;
 
 	if (vcpu->kvm->arch.kvm_ops && vcpu->kvm->arch.kvm_ops->load_from_eaddr)
 		rc = vcpu->kvm->arch.kvm_ops->load_from_eaddr(vcpu, eaddr, ptr,
diff --git a/arch/powerpc/kvm/timing.h b/arch/powerpc/kvm/timing.h
index 45817ab82bb4..529f32e7aaf1 100644
--- a/arch/powerpc/kvm/timing.h
+++ b/arch/powerpc/kvm/timing.h
@@ -45,46 +45,46 @@ static inline void kvmppc_account_exit_stat(struct kvm_vcpu *vcpu, int type)
 	*/
 	switch (type) {
 	case EXT_INTR_EXITS:
-		vcpu->stat.ext_intr_exits++;
+		vcpu->stat->ext_intr_exits++;
 		break;
 	case DEC_EXITS:
-		vcpu->stat.dec_exits++;
+		vcpu->stat->dec_exits++;
 		break;
 	case EMULATED_INST_EXITS:
-		vcpu->stat.emulated_inst_exits++;
+		vcpu->stat->emulated_inst_exits++;
 		break;
 	case DSI_EXITS:
-		vcpu->stat.dsi_exits++;
+		vcpu->stat->dsi_exits++;
 		break;
 	case ISI_EXITS:
-		vcpu->stat.isi_exits++;
+		vcpu->stat->isi_exits++;
 		break;
 	case SYSCALL_EXITS:
-		vcpu->stat.syscall_exits++;
+		vcpu->stat->syscall_exits++;
 		break;
 	case DTLB_REAL_MISS_EXITS:
-		vcpu->stat.dtlb_real_miss_exits++;
+		vcpu->stat->dtlb_real_miss_exits++;
 		break;
 	case DTLB_VIRT_MISS_EXITS:
-		vcpu->stat.dtlb_virt_miss_exits++;
+		vcpu->stat->dtlb_virt_miss_exits++;
 		break;
 	case MMIO_EXITS:
-		vcpu->stat.mmio_exits++;
+		vcpu->stat->mmio_exits++;
 		break;
 	case ITLB_REAL_MISS_EXITS:
-		vcpu->stat.itlb_real_miss_exits++;
+		vcpu->stat->itlb_real_miss_exits++;
 		break;
 	case ITLB_VIRT_MISS_EXITS:
-		vcpu->stat.itlb_virt_miss_exits++;
+		vcpu->stat->itlb_virt_miss_exits++;
 		break;
 	case SIGNAL_EXITS:
-		vcpu->stat.signal_exits++;
+		vcpu->stat->signal_exits++;
 		break;
 	case DBELL_EXITS:
-		vcpu->stat.dbell_exits++;
+		vcpu->stat->dbell_exits++;
 		break;
 	case GDBELL_EXITS:
-		vcpu->stat.gdbell_exits++;
+		vcpu->stat->gdbell_exits++;
 		break;
 	}
 }
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 60d684c76c58..55fb16307cc6 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -967,7 +967,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_riscv_vcpu_enter_exit(vcpu, &trap);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
-		vcpu->stat.exits++;
+		vcpu->stat->exits++;
 
 		/* Syncup interrupts state with HW */
 		kvm_riscv_vcpu_sync_interrupts(vcpu);
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 6e0c18412795..73116dd903e5 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -195,27 +195,27 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	switch (trap->scause) {
 	case EXC_INST_ILLEGAL:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ILLEGAL_INSN);
-		vcpu->stat.instr_illegal_exits++;
+		vcpu->stat->instr_illegal_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_LOAD_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_LOAD);
-		vcpu->stat.load_misaligned_exits++;
+		vcpu->stat->load_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_STORE_MISALIGNED:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_MISALIGNED_STORE);
-		vcpu->stat.store_misaligned_exits++;
+		vcpu->stat->store_misaligned_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_LOAD_ACCESS:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_LOAD);
-		vcpu->stat.load_access_exits++;
+		vcpu->stat->load_access_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_STORE_ACCESS:
 		kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_ACCESS_STORE);
-		vcpu->stat.store_access_exits++;
+		vcpu->stat->store_access_exits++;
 		ret = vcpu_redirect(vcpu, trap);
 		break;
 	case EXC_INST_ACCESS:
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 97dec18e6989..43911b8a3f1b 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -201,14 +201,14 @@ void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
 
 static int wfi_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 {
-	vcpu->stat.wfi_exit_stat++;
+	vcpu->stat->wfi_exit_stat++;
 	kvm_riscv_vcpu_wfi(vcpu);
 	return KVM_INSN_CONTINUE_NEXT_SEPC;
 }
 
 static int wrs_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 {
-	vcpu->stat.wrs_exit_stat++;
+	vcpu->stat->wrs_exit_stat++;
 	kvm_vcpu_on_spin(vcpu, vcpu->arch.guest_context.sstatus & SR_SPP);
 	return KVM_INSN_CONTINUE_NEXT_SEPC;
 }
@@ -335,7 +335,7 @@ static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 		if (rc > KVM_INSN_EXIT_TO_USER_SPACE) {
 			if (rc == KVM_INSN_CONTINUE_NEXT_SEPC) {
 				run->riscv_csr.ret_value = val;
-				vcpu->stat.csr_exit_kernel++;
+				vcpu->stat->csr_exit_kernel++;
 				kvm_riscv_vcpu_csr_return(vcpu, run);
 				rc = KVM_INSN_CONTINUE_SAME_SEPC;
 			}
@@ -345,7 +345,7 @@ static int csr_insn(struct kvm_vcpu *vcpu, struct kvm_run *run, ulong insn)
 
 	/* Exit to user-space for CSR emulation */
 	if (rc <= KVM_INSN_EXIT_TO_USER_SPACE) {
-		vcpu->stat.csr_exit_user++;
+		vcpu->stat->csr_exit_user++;
 		run->exit_reason = KVM_EXIT_RISCV_CSR;
 	}
 
@@ -576,13 +576,13 @@ int kvm_riscv_vcpu_mmio_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (!kvm_io_bus_read(vcpu, KVM_MMIO_BUS, fault_addr, len, data_buf)) {
 		/* Successfully handled MMIO access in the kernel so resume */
 		memcpy(run->mmio.data, data_buf, len);
-		vcpu->stat.mmio_exit_kernel++;
+		vcpu->stat->mmio_exit_kernel++;
 		kvm_riscv_vcpu_mmio_return(vcpu, run);
 		return 1;
 	}
 
 	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
+	vcpu->stat->mmio_exit_user++;
 	run->exit_reason = KVM_EXIT_MMIO;
 
 	return 0;
@@ -709,13 +709,13 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	if (!kvm_io_bus_write(vcpu, KVM_MMIO_BUS,
 			      fault_addr, len, run->mmio.data)) {
 		/* Successfully handled MMIO access in the kernel so resume */
-		vcpu->stat.mmio_exit_kernel++;
+		vcpu->stat->mmio_exit_kernel++;
 		kvm_riscv_vcpu_mmio_return(vcpu, run);
 		return 1;
 	}
 
 	/* Exit to userspace for MMIO emulation */
-	vcpu->stat.mmio_exit_user++;
+	vcpu->stat->mmio_exit_user++;
 	run->exit_reason = KVM_EXIT_MMIO;
 
 	return 0;
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e..b500bcaf7b11 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -121,7 +121,7 @@ void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
 
 	vcpu->arch.sbi_context.return_handled = 0;
-	vcpu->stat.ecall_exit_stat++;
+	vcpu->stat->ecall_exit_stat++;
 	run->exit_reason = KVM_EXIT_RISCV_SBI;
 	run->riscv_sbi.extension_id = cp->a7;
 	run->riscv_sbi.function_id = cp->a6;
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 3070bb31745d..519671760674 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -82,7 +82,7 @@ static int kvm_sbi_hsm_vcpu_get_status(struct kvm_vcpu *vcpu)
 		return SBI_ERR_INVALID_PARAM;
 	if (kvm_riscv_vcpu_stopped(target_vcpu))
 		return SBI_HSM_STATE_STOPPED;
-	else if (target_vcpu->stat.generic.blocking)
+	else if (target_vcpu->stat->generic.blocking)
 		return SBI_HSM_STATE_SUSPENDED;
 	else
 		return SBI_HSM_STATE_STARTED;
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 74f73141f9b9..359d562f7b81 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -24,7 +24,7 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 
 	start = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
 	end = vcpu->run->s.regs.gprs[vcpu->arch.sie_block->ipa & 0xf] + PAGE_SIZE;
-	vcpu->stat.instruction_diagnose_10++;
+	vcpu->stat->instruction_diagnose_10++;
 
 	if (start & ~PAGE_MASK || end & ~PAGE_MASK || start >= end
 	    || start < 2 * PAGE_SIZE)
@@ -74,7 +74,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 3, "diag page reference parameter block at 0x%llx",
 		   vcpu->run->s.regs.gprs[rx]);
-	vcpu->stat.instruction_diagnose_258++;
+	vcpu->stat->instruction_diagnose_258++;
 	if (vcpu->run->s.regs.gprs[rx] & 7)
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 	rc = read_guest_real(vcpu, vcpu->run->s.regs.gprs[rx], &parm, sizeof(parm));
@@ -145,7 +145,7 @@ static int __diag_page_ref_service(struct kvm_vcpu *vcpu)
 static int __diag_time_slice_end(struct kvm_vcpu *vcpu)
 {
 	VCPU_EVENT(vcpu, 5, "%s", "diag time slice end");
-	vcpu->stat.instruction_diagnose_44++;
+	vcpu->stat->instruction_diagnose_44++;
 	kvm_vcpu_on_spin(vcpu, true);
 	return 0;
 }
@@ -170,7 +170,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	int tid;
 
 	tid = vcpu->run->s.regs.gprs[(vcpu->arch.sie_block->ipa & 0xf0) >> 4];
-	vcpu->stat.instruction_diagnose_9c++;
+	vcpu->stat->instruction_diagnose_9c++;
 
 	/* yield to self */
 	if (tid == vcpu->vcpu_id)
@@ -194,7 +194,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 5,
 			   "diag time slice end directed to %d: yield forwarded",
 			   tid);
-		vcpu->stat.diag_9c_forward++;
+		vcpu->stat->diag_9c_forward++;
 		return 0;
 	}
 
@@ -205,7 +205,7 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	return 0;
 no_yield:
 	VCPU_EVENT(vcpu, 5, "diag time slice end directed to %d: ignored", tid);
-	vcpu->stat.diag_9c_ignored++;
+	vcpu->stat->diag_9c_ignored++;
 	return 0;
 }
 
@@ -215,7 +215,7 @@ static int __diag_ipl_functions(struct kvm_vcpu *vcpu)
 	unsigned long subcode = vcpu->run->s.regs.gprs[reg] & 0xffff;
 
 	VCPU_EVENT(vcpu, 3, "diag ipl functions, subcode %lx", subcode);
-	vcpu->stat.instruction_diagnose_308++;
+	vcpu->stat->instruction_diagnose_308++;
 	switch (subcode) {
 	case 3:
 		vcpu->run->s390_reset_flags = KVM_S390_RESET_CLEAR;
@@ -247,7 +247,7 @@ static int __diag_virtio_hypercall(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	vcpu->stat.instruction_diagnose_500++;
+	vcpu->stat->instruction_diagnose_500++;
 	/* No virtio-ccw notification? Get out quickly. */
 	if (!vcpu->kvm->arch.css_support ||
 	    (vcpu->run->s.regs.gprs[1] != KVM_S390_VIRTIO_CCW_NOTIFY))
@@ -301,7 +301,7 @@ int kvm_s390_handle_diag(struct kvm_vcpu *vcpu)
 	case 0x500:
 		return __diag_virtio_hypercall(vcpu);
 	default:
-		vcpu->stat.instruction_diagnose_other++;
+		vcpu->stat->instruction_diagnose_other++;
 		return -EOPNOTSUPP;
 	}
 }
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 610dd44a948b..74d01f67a257 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -57,7 +57,7 @@ static int handle_stop(struct kvm_vcpu *vcpu)
 	int rc = 0;
 	uint8_t flags, stop_pending;
 
-	vcpu->stat.exit_stop_request++;
+	vcpu->stat->exit_stop_request++;
 
 	/* delay the stop if any non-stop irq is pending */
 	if (kvm_s390_vcpu_has_irq(vcpu, 1))
@@ -93,7 +93,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 {
 	int viwhy = vcpu->arch.sie_block->ipb >> 16;
 
-	vcpu->stat.exit_validity++;
+	vcpu->stat->exit_validity++;
 	trace_kvm_s390_intercept_validity(vcpu, viwhy);
 	KVM_EVENT(3, "validity intercept 0x%x for pid %u (kvm 0x%pK)", viwhy,
 		  current->pid, vcpu->kvm);
@@ -106,7 +106,7 @@ static int handle_validity(struct kvm_vcpu *vcpu)
 
 static int handle_instruction(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.exit_instruction++;
+	vcpu->stat->exit_instruction++;
 	trace_kvm_s390_intercept_instruction(vcpu,
 					     vcpu->arch.sie_block->ipa,
 					     vcpu->arch.sie_block->ipb);
@@ -249,7 +249,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 	psw_t psw;
 	int rc;
 
-	vcpu->stat.exit_program_interruption++;
+	vcpu->stat->exit_program_interruption++;
 
 	/*
 	 * Intercept 8 indicates a loop of specification exceptions
@@ -307,7 +307,7 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 	psw_t newpsw;
 	int rc;
 
-	vcpu->stat.exit_external_interrupt++;
+	vcpu->stat->exit_external_interrupt++;
 
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		newpsw = vcpu->arch.sie_block->gpsw;
@@ -388,7 +388,7 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 
 static int handle_partial_execution(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.exit_pei++;
+	vcpu->stat->exit_pei++;
 
 	if (vcpu->arch.sie_block->ipa == 0xb254)	/* MVPG */
 		return handle_mvpg_pei(vcpu);
@@ -416,7 +416,7 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 	code = vcpu->run->s.regs.gprs[reg1];
 	addr = vcpu->run->s.regs.gprs[reg2];
 
-	vcpu->stat.instruction_sthyi++;
+	vcpu->stat->instruction_sthyi++;
 	VCPU_EVENT(vcpu, 3, "STHYI: fc: %llu addr: 0x%016llx", code, addr);
 	trace_kvm_s390_handle_sthyi(vcpu, code, addr);
 
@@ -465,7 +465,7 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 	psw_t oldpsw, newpsw;
 	int rc;
 
-	vcpu->stat.exit_operation_exception++;
+	vcpu->stat->exit_operation_exception++;
 	trace_kvm_s390_handle_operexc(vcpu, vcpu->arch.sie_block->ipa,
 				      vcpu->arch.sie_block->ipb);
 
@@ -609,10 +609,10 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu)
 
 	switch (vcpu->arch.sie_block->icptcode) {
 	case ICPT_EXTREQ:
-		vcpu->stat.exit_external_request++;
+		vcpu->stat->exit_external_request++;
 		return 0;
 	case ICPT_IOREQ:
-		vcpu->stat.exit_io_request++;
+		vcpu->stat->exit_io_request++;
 		return 0;
 	case ICPT_INST:
 		rc = handle_instruction(vcpu);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 07ff0e10cb7f..7576df5305c3 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -479,7 +479,7 @@ static int __must_check __deliver_cpu_timer(struct kvm_vcpu *vcpu)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	int rc = 0;
 
-	vcpu->stat.deliver_cputm++;
+	vcpu->stat->deliver_cputm++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CPU_TIMER,
 					 0, 0);
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -503,7 +503,7 @@ static int __must_check __deliver_ckc(struct kvm_vcpu *vcpu)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	int rc = 0;
 
-	vcpu->stat.deliver_ckc++;
+	vcpu->stat->deliver_ckc++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_CLOCK_COMP,
 					 0, 0);
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -707,7 +707,7 @@ static int __must_check __deliver_machine_check(struct kvm_vcpu *vcpu)
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 						 KVM_S390_MCHK,
 						 mchk.cr14, mchk.mcic);
-		vcpu->stat.deliver_machine_check++;
+		vcpu->stat->deliver_machine_check++;
 		rc = __write_machine_check(vcpu, &mchk);
 	}
 	return rc;
@@ -719,7 +719,7 @@ static int __must_check __deliver_restart(struct kvm_vcpu *vcpu)
 	int rc = 0;
 
 	VCPU_EVENT(vcpu, 3, "%s", "deliver: cpu restart");
-	vcpu->stat.deliver_restart_signal++;
+	vcpu->stat->deliver_restart_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_RESTART, 0, 0);
 
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -746,7 +746,7 @@ static int __must_check __deliver_set_prefix(struct kvm_vcpu *vcpu)
 	clear_bit(IRQ_PEND_SET_PREFIX, &li->pending_irqs);
 	spin_unlock(&li->lock);
 
-	vcpu->stat.deliver_prefix_signal++;
+	vcpu->stat->deliver_prefix_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_SIGP_SET_PREFIX,
 					 prefix.address, 0);
@@ -769,7 +769,7 @@ static int __must_check __deliver_emergency_signal(struct kvm_vcpu *vcpu)
 	spin_unlock(&li->lock);
 
 	VCPU_EVENT(vcpu, 4, "%s", "deliver: sigp emerg");
-	vcpu->stat.deliver_emergency_signal++;
+	vcpu->stat->deliver_emergency_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
 					 cpu_addr, 0);
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
@@ -802,7 +802,7 @@ static int __must_check __deliver_external_call(struct kvm_vcpu *vcpu)
 	spin_unlock(&li->lock);
 
 	VCPU_EVENT(vcpu, 4, "%s", "deliver: sigp ext call");
-	vcpu->stat.deliver_external_call++;
+	vcpu->stat->deliver_external_call++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 					 KVM_S390_INT_EXTERNAL_CALL,
 					 extcall.code, 0);
@@ -854,7 +854,7 @@ static int __must_check __deliver_prog(struct kvm_vcpu *vcpu)
 	ilen = pgm_info.flags & KVM_S390_PGM_FLAGS_ILC_MASK;
 	VCPU_EVENT(vcpu, 3, "deliver: program irq code 0x%x, ilen:%d",
 		   pgm_info.code, ilen);
-	vcpu->stat.deliver_program++;
+	vcpu->stat->deliver_program++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_PROGRAM_INT,
 					 pgm_info.code, 0);
 
@@ -1004,7 +1004,7 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
 		   ext.ext_params);
-	vcpu->stat.deliver_service_signal++;
+	vcpu->stat->deliver_service_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
 					 ext.ext_params, 0);
 
@@ -1028,7 +1028,7 @@ static int __must_check __deliver_service_ev(struct kvm_vcpu *vcpu)
 	spin_unlock(&fi->lock);
 
 	VCPU_EVENT(vcpu, 4, "%s", "deliver: sclp parameter event");
-	vcpu->stat.deliver_service_signal++;
+	vcpu->stat->deliver_service_signal++;
 	trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id, KVM_S390_INT_SERVICE,
 					 ext.ext_params, 0);
 
@@ -1091,7 +1091,7 @@ static int __must_check __deliver_virtio(struct kvm_vcpu *vcpu)
 		VCPU_EVENT(vcpu, 4,
 			   "deliver: virtio parm: 0x%x,parm64: 0x%llx",
 			   inti->ext.ext_params, inti->ext.ext_params2);
-		vcpu->stat.deliver_virtio++;
+		vcpu->stat->deliver_virtio++;
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 				inti->type,
 				inti->ext.ext_params,
@@ -1177,7 +1177,7 @@ static int __must_check __deliver_io(struct kvm_vcpu *vcpu,
 			inti->io.subchannel_id >> 1 & 0x3,
 			inti->io.subchannel_nr);
 
-		vcpu->stat.deliver_io++;
+		vcpu->stat->deliver_io++;
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 				inti->type,
 				((__u32)inti->io.subchannel_id << 16) |
@@ -1205,7 +1205,7 @@ static int __must_check __deliver_io(struct kvm_vcpu *vcpu,
 		VCPU_EVENT(vcpu, 4, "%s isc %u", "deliver: I/O (AI/gisa)", isc);
 		memset(&io, 0, sizeof(io));
 		io.io_int_word = isc_to_int_word(isc);
-		vcpu->stat.deliver_io++;
+		vcpu->stat->deliver_io++;
 		trace_kvm_s390_deliver_interrupt(vcpu->vcpu_id,
 			KVM_S390_INT_IO(1, 0, 0, 0),
 			((__u32)io.subchannel_id << 16) |
@@ -1290,7 +1290,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	struct kvm_s390_gisa_interrupt *gi = &vcpu->kvm->arch.gisa_int;
 	u64 sltime;
 
-	vcpu->stat.exit_wait_state++;
+	vcpu->stat->exit_wait_state++;
 
 	/* fast path */
 	if (kvm_arch_vcpu_runnable(vcpu))
@@ -1476,7 +1476,7 @@ static int __inject_prog(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_program++;
+	vcpu->stat->inject_program++;
 	VCPU_EVENT(vcpu, 3, "inject: program irq code 0x%x", irq->u.pgm.code);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_PROGRAM_INT,
 				   irq->u.pgm.code, 0);
@@ -1518,7 +1518,7 @@ static int __inject_pfault_init(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_pfault_init++;
+	vcpu->stat->inject_pfault_init++;
 	VCPU_EVENT(vcpu, 4, "inject: pfault init parameter block at 0x%llx",
 		   irq->u.ext.ext_params2);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_PFAULT_INIT,
@@ -1537,7 +1537,7 @@ static int __inject_extcall(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_extcall_info *extcall = &li->irq.extcall;
 	uint16_t src_id = irq->u.extcall.code;
 
-	vcpu->stat.inject_external_call++;
+	vcpu->stat->inject_external_call++;
 	VCPU_EVENT(vcpu, 4, "inject: external call source-cpu:%u",
 		   src_id);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_EXTERNAL_CALL,
@@ -1562,7 +1562,7 @@ static int __inject_set_prefix(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	struct kvm_s390_prefix_info *prefix = &li->irq.prefix;
 
-	vcpu->stat.inject_set_prefix++;
+	vcpu->stat->inject_set_prefix++;
 	VCPU_EVENT(vcpu, 3, "inject: set prefix to %x",
 		   irq->u.prefix.address);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_SIGP_SET_PREFIX,
@@ -1583,7 +1583,7 @@ static int __inject_sigp_stop(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_stop_info *stop = &li->irq.stop;
 	int rc = 0;
 
-	vcpu->stat.inject_stop_signal++;
+	vcpu->stat->inject_stop_signal++;
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_SIGP_STOP, 0, 0);
 
 	if (irq->u.stop.flags & ~KVM_S390_STOP_SUPP_FLAGS)
@@ -1607,7 +1607,7 @@ static int __inject_sigp_restart(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_restart++;
+	vcpu->stat->inject_restart++;
 	VCPU_EVENT(vcpu, 3, "%s", "inject: restart int");
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_RESTART, 0, 0);
 
@@ -1620,7 +1620,7 @@ static int __inject_sigp_emergency(struct kvm_vcpu *vcpu,
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_emergency_signal++;
+	vcpu->stat->inject_emergency_signal++;
 	VCPU_EVENT(vcpu, 4, "inject: emergency from cpu %u",
 		   irq->u.emerg.code);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_EMERGENCY,
@@ -1641,7 +1641,7 @@ static int __inject_mchk(struct kvm_vcpu *vcpu, struct kvm_s390_irq *irq)
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 	struct kvm_s390_mchk_info *mchk = &li->irq.mchk;
 
-	vcpu->stat.inject_mchk++;
+	vcpu->stat->inject_mchk++;
 	VCPU_EVENT(vcpu, 3, "inject: machine check mcic 0x%llx",
 		   irq->u.mchk.mcic);
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_MCHK, 0,
@@ -1672,7 +1672,7 @@ static int __inject_ckc(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_ckc++;
+	vcpu->stat->inject_ckc++;
 	VCPU_EVENT(vcpu, 3, "%s", "inject: clock comparator external");
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_CLOCK_COMP,
 				   0, 0);
@@ -1686,7 +1686,7 @@ static int __inject_cpu_timer(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s390_local_interrupt *li = &vcpu->arch.local_int;
 
-	vcpu->stat.inject_cputm++;
+	vcpu->stat->inject_cputm++;
 	VCPU_EVENT(vcpu, 3, "%s", "inject: cpu timer external");
 	trace_kvm_s390_inject_vcpu(vcpu->vcpu_id, KVM_S390_INT_CPU_TIMER,
 				   0, 0);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 020502af7dc9..46759021e924 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4133,7 +4133,7 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
 	if (get_lowcore()->avg_steal_timer * 100 / (TICK_USEC << 12) >=
 	    READ_ONCE(halt_poll_max_steal)) {
-		vcpu->stat.halt_no_poll_steal++;
+		vcpu->stat->halt_no_poll_steal++;
 		return true;
 	}
 	return false;
@@ -4898,7 +4898,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 		trace_kvm_s390_major_guest_pfault(vcpu);
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
-		vcpu->stat.pfault_sync++;
+		vcpu->stat->pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
 		flags &= ~FOLL_NOWAIT;
 		goto try_again;
@@ -4960,7 +4960,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 
 	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
-		vcpu->stat.exit_null++;
+		vcpu->stat->exit_null++;
 		break;
 	case PGM_SECURE_STORAGE_ACCESS:
 	case PGM_SECURE_STORAGE_VIOLATION:
@@ -5351,7 +5351,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
-	vcpu->stat.exit_userspace++;
+	vcpu->stat->exit_userspace++;
 out:
 	vcpu_put(vcpu);
 	return rc;
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 1a49b89706f8..6ff66373f115 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -31,7 +31,7 @@
 
 static int handle_ri(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_ri++;
+	vcpu->stat->instruction_ri++;
 
 	if (test_kvm_facility(vcpu->kvm, 64)) {
 		VCPU_EVENT(vcpu, 3, "%s", "ENABLE: RI (lazy)");
@@ -52,7 +52,7 @@ int kvm_s390_handle_aa(struct kvm_vcpu *vcpu)
 
 static int handle_gs(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_gs++;
+	vcpu->stat->instruction_gs++;
 
 	if (test_kvm_facility(vcpu->kvm, 133)) {
 		VCPU_EVENT(vcpu, 3, "%s", "ENABLE: GS (lazy)");
@@ -87,7 +87,7 @@ static int handle_set_clock(struct kvm_vcpu *vcpu)
 	u8 ar;
 	u64 op2;
 
-	vcpu->stat.instruction_sck++;
+	vcpu->stat->instruction_sck++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -126,7 +126,7 @@ static int handle_set_prefix(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_spx++;
+	vcpu->stat->instruction_spx++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -164,7 +164,7 @@ static int handle_store_prefix(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_stpx++;
+	vcpu->stat->instruction_stpx++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -194,7 +194,7 @@ static int handle_store_cpu_address(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_stap++;
+	vcpu->stat->instruction_stap++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -261,7 +261,7 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 	bool unlocked;
 	int rc;
 
-	vcpu->stat.instruction_iske++;
+	vcpu->stat->instruction_iske++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -308,7 +308,7 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 	bool unlocked;
 	int rc;
 
-	vcpu->stat.instruction_rrbe++;
+	vcpu->stat->instruction_rrbe++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -359,7 +359,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 	bool unlocked;
 	int rc;
 
-	vcpu->stat.instruction_sske++;
+	vcpu->stat->instruction_sske++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -438,7 +438,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 
 static int handle_ipte_interlock(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_ipte_interlock++;
+	vcpu->stat->instruction_ipte_interlock++;
 	if (psw_bits(vcpu->arch.sie_block->gpsw).pstate)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 	wait_event(vcpu->kvm->arch.ipte_wq, !ipte_lock_held(vcpu->kvm));
@@ -452,7 +452,7 @@ static int handle_test_block(struct kvm_vcpu *vcpu)
 	gpa_t addr;
 	int reg2;
 
-	vcpu->stat.instruction_tb++;
+	vcpu->stat->instruction_tb++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -486,7 +486,7 @@ static int handle_tpi(struct kvm_vcpu *vcpu)
 	u64 addr;
 	u8 ar;
 
-	vcpu->stat.instruction_tpi++;
+	vcpu->stat->instruction_tpi++;
 
 	addr = kvm_s390_get_base_disp_s(vcpu, &ar);
 	if (addr & 3)
@@ -548,7 +548,7 @@ static int handle_tsch(struct kvm_vcpu *vcpu)
 	struct kvm_s390_interrupt_info *inti = NULL;
 	const u64 isc_mask = 0xffUL << 24; /* all iscs set */
 
-	vcpu->stat.instruction_tsch++;
+	vcpu->stat->instruction_tsch++;
 
 	/* a valid schid has at least one bit set */
 	if (vcpu->run->s.regs.gprs[1])
@@ -593,7 +593,7 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.sie_block->ipa == 0xb235)
 			return handle_tsch(vcpu);
 		/* Handle in userspace. */
-		vcpu->stat.instruction_io_other++;
+		vcpu->stat->instruction_io_other++;
 		return -EOPNOTSUPP;
 	} else {
 		/*
@@ -702,7 +702,7 @@ static int handle_stfl(struct kvm_vcpu *vcpu)
 	int rc;
 	unsigned int fac;
 
-	vcpu->stat.instruction_stfl++;
+	vcpu->stat->instruction_stfl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -751,7 +751,7 @@ int kvm_s390_handle_lpsw(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_lpsw++;
+	vcpu->stat->instruction_lpsw++;
 
 	if (gpsw->mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -780,7 +780,7 @@ static int handle_lpswe(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_lpswe++;
+	vcpu->stat->instruction_lpswe++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -804,7 +804,7 @@ static int handle_lpswey(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_lpswey++;
+	vcpu->stat->instruction_lpswey++;
 
 	if (!test_kvm_facility(vcpu->kvm, 193))
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
@@ -834,7 +834,7 @@ static int handle_stidp(struct kvm_vcpu *vcpu)
 	int rc;
 	u8 ar;
 
-	vcpu->stat.instruction_stidp++;
+	vcpu->stat->instruction_stidp++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -900,7 +900,7 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	int rc = 0;
 	u8 ar;
 
-	vcpu->stat.instruction_stsi++;
+	vcpu->stat->instruction_stsi++;
 	VCPU_EVENT(vcpu, 3, "STSI: fc: %u sel1: %u sel2: %u", fc, sel1, sel2);
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
@@ -1044,7 +1044,7 @@ static int handle_epsw(struct kvm_vcpu *vcpu)
 {
 	int reg1, reg2;
 
-	vcpu->stat.instruction_epsw++;
+	vcpu->stat->instruction_epsw++;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -1076,7 +1076,7 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	unsigned long start, end;
 	unsigned char key;
 
-	vcpu->stat.instruction_pfmf++;
+	vcpu->stat->instruction_pfmf++;
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
@@ -1256,7 +1256,7 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 4, "ESSA: release %d pages", entries);
 	gmap = vcpu->arch.gmap;
-	vcpu->stat.instruction_essa++;
+	vcpu->stat->instruction_essa++;
 	if (!vcpu->kvm->arch.use_cmma)
 		return kvm_s390_inject_program_int(vcpu, PGM_OPERATION);
 
@@ -1345,7 +1345,7 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_lctl++;
+	vcpu->stat->instruction_lctl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1384,7 +1384,7 @@ int kvm_s390_handle_stctl(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_stctl++;
+	vcpu->stat->instruction_stctl++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1418,7 +1418,7 @@ static int handle_lctlg(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_lctlg++;
+	vcpu->stat->instruction_lctlg++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1456,7 +1456,7 @@ static int handle_stctg(struct kvm_vcpu *vcpu)
 	u64 ga;
 	u8 ar;
 
-	vcpu->stat.instruction_stctg++;
+	vcpu->stat->instruction_stctg++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1508,7 +1508,7 @@ static int handle_tprot(struct kvm_vcpu *vcpu)
 	int ret, cc;
 	u8 ar;
 
-	vcpu->stat.instruction_tprot++;
+	vcpu->stat->instruction_tprot++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1572,7 +1572,7 @@ static int handle_sckpf(struct kvm_vcpu *vcpu)
 {
 	u32 value;
 
-	vcpu->stat.instruction_sckpf++;
+	vcpu->stat->instruction_sckpf++;
 
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
@@ -1589,7 +1589,7 @@ static int handle_sckpf(struct kvm_vcpu *vcpu)
 
 static int handle_ptff(struct kvm_vcpu *vcpu)
 {
-	vcpu->stat.instruction_ptff++;
+	vcpu->stat->instruction_ptff++;
 
 	/* we don't emulate any control instructions yet */
 	kvm_s390_set_psw_cc(vcpu, 3);
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 55c34cb35428..79cf7f77fec6 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -306,61 +306,61 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
 
 	switch (order_code) {
 	case SIGP_SENSE:
-		vcpu->stat.instruction_sigp_sense++;
+		vcpu->stat->instruction_sigp_sense++;
 		rc = __sigp_sense(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_EXTERNAL_CALL:
-		vcpu->stat.instruction_sigp_external_call++;
+		vcpu->stat->instruction_sigp_external_call++;
 		rc = __sigp_external_call(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_EMERGENCY_SIGNAL:
-		vcpu->stat.instruction_sigp_emergency++;
+		vcpu->stat->instruction_sigp_emergency++;
 		rc = __sigp_emergency(vcpu, dst_vcpu);
 		break;
 	case SIGP_STOP:
-		vcpu->stat.instruction_sigp_stop++;
+		vcpu->stat->instruction_sigp_stop++;
 		rc = __sigp_stop(vcpu, dst_vcpu);
 		break;
 	case SIGP_STOP_AND_STORE_STATUS:
-		vcpu->stat.instruction_sigp_stop_store_status++;
+		vcpu->stat->instruction_sigp_stop_store_status++;
 		rc = __sigp_stop_and_store_status(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_STORE_STATUS_AT_ADDRESS:
-		vcpu->stat.instruction_sigp_store_status++;
+		vcpu->stat->instruction_sigp_store_status++;
 		rc = __sigp_store_status_at_addr(vcpu, dst_vcpu, parameter,
 						 status_reg);
 		break;
 	case SIGP_SET_PREFIX:
-		vcpu->stat.instruction_sigp_prefix++;
+		vcpu->stat->instruction_sigp_prefix++;
 		rc = __sigp_set_prefix(vcpu, dst_vcpu, parameter, status_reg);
 		break;
 	case SIGP_COND_EMERGENCY_SIGNAL:
-		vcpu->stat.instruction_sigp_cond_emergency++;
+		vcpu->stat->instruction_sigp_cond_emergency++;
 		rc = __sigp_conditional_emergency(vcpu, dst_vcpu, parameter,
 						  status_reg);
 		break;
 	case SIGP_SENSE_RUNNING:
-		vcpu->stat.instruction_sigp_sense_running++;
+		vcpu->stat->instruction_sigp_sense_running++;
 		rc = __sigp_sense_running(vcpu, dst_vcpu, status_reg);
 		break;
 	case SIGP_START:
-		vcpu->stat.instruction_sigp_start++;
+		vcpu->stat->instruction_sigp_start++;
 		rc = __prepare_sigp_re_start(vcpu, dst_vcpu, order_code);
 		break;
 	case SIGP_RESTART:
-		vcpu->stat.instruction_sigp_restart++;
+		vcpu->stat->instruction_sigp_restart++;
 		rc = __prepare_sigp_re_start(vcpu, dst_vcpu, order_code);
 		break;
 	case SIGP_INITIAL_CPU_RESET:
-		vcpu->stat.instruction_sigp_init_cpu_reset++;
+		vcpu->stat->instruction_sigp_init_cpu_reset++;
 		rc = __prepare_sigp_cpu_reset(vcpu, dst_vcpu, order_code);
 		break;
 	case SIGP_CPU_RESET:
-		vcpu->stat.instruction_sigp_cpu_reset++;
+		vcpu->stat->instruction_sigp_cpu_reset++;
 		rc = __prepare_sigp_cpu_reset(vcpu, dst_vcpu, order_code);
 		break;
 	default:
-		vcpu->stat.instruction_sigp_unknown++;
+		vcpu->stat->instruction_sigp_unknown++;
 		rc = __prepare_sigp_unknown(vcpu, dst_vcpu);
 	}
 
@@ -387,34 +387,34 @@ static int handle_sigp_order_in_user_space(struct kvm_vcpu *vcpu, u8 order_code,
 		return 0;
 	/* update counters as we're directly dropping to user space */
 	case SIGP_STOP:
-		vcpu->stat.instruction_sigp_stop++;
+		vcpu->stat->instruction_sigp_stop++;
 		break;
 	case SIGP_STOP_AND_STORE_STATUS:
-		vcpu->stat.instruction_sigp_stop_store_status++;
+		vcpu->stat->instruction_sigp_stop_store_status++;
 		break;
 	case SIGP_STORE_STATUS_AT_ADDRESS:
-		vcpu->stat.instruction_sigp_store_status++;
+		vcpu->stat->instruction_sigp_store_status++;
 		break;
 	case SIGP_STORE_ADDITIONAL_STATUS:
-		vcpu->stat.instruction_sigp_store_adtl_status++;
+		vcpu->stat->instruction_sigp_store_adtl_status++;
 		break;
 	case SIGP_SET_PREFIX:
-		vcpu->stat.instruction_sigp_prefix++;
+		vcpu->stat->instruction_sigp_prefix++;
 		break;
 	case SIGP_START:
-		vcpu->stat.instruction_sigp_start++;
+		vcpu->stat->instruction_sigp_start++;
 		break;
 	case SIGP_RESTART:
-		vcpu->stat.instruction_sigp_restart++;
+		vcpu->stat->instruction_sigp_restart++;
 		break;
 	case SIGP_INITIAL_CPU_RESET:
-		vcpu->stat.instruction_sigp_init_cpu_reset++;
+		vcpu->stat->instruction_sigp_init_cpu_reset++;
 		break;
 	case SIGP_CPU_RESET:
-		vcpu->stat.instruction_sigp_cpu_reset++;
+		vcpu->stat->instruction_sigp_cpu_reset++;
 		break;
 	default:
-		vcpu->stat.instruction_sigp_unknown++;
+		vcpu->stat->instruction_sigp_unknown++;
 	}
 	VCPU_EVENT(vcpu, 3, "SIGP: order %u for CPU %d handled in userspace",
 		   order_code, cpu_addr);
@@ -447,7 +447,7 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu)
 	trace_kvm_s390_handle_sigp(vcpu, order_code, cpu_addr, parameter);
 	switch (order_code) {
 	case SIGP_SET_ARCHITECTURE:
-		vcpu->stat.instruction_sigp_arch++;
+		vcpu->stat->instruction_sigp_arch++;
 		rc = __sigp_set_arch(vcpu, parameter,
 				     &vcpu->run->s.regs.gprs[r1]);
 		break;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index a78df3a4f353..904a3d84c1b3 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1456,7 +1456,7 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 	unsigned long scb_addr;
 	int rc;
 
-	vcpu->stat.instruction_sie++;
+	vcpu->stat->instruction_sie++;
 	if (!test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_SIEF2))
 		return -EOPNOTSUPP;
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 999227fc7c66..ff31d1bb49ec 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -24,7 +24,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_timer_advance_ns_fops, vcpu_get_timer_advance_ns, N
 static int vcpu_get_guest_mode(void *data, u64 *val)
 {
 	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
-	*val = vcpu->stat.guest_mode;
+	*val = vcpu->stat->guest_mode;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6ebeb6cea6c0..c6592e7f40a2 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1988,7 +1988,7 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
 		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
 			kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
 
-		++vcpu->stat.tlb_flush;
+		++vcpu->stat->tlb_flush;
 	}
 	return 0;
 
@@ -2390,7 +2390,7 @@ static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
 
 	trace_kvm_hv_hypercall_done(result);
 	kvm_hv_hypercall_set_result(vcpu, result);
-	++vcpu->stat.hypercalls;
+	++vcpu->stat->hypercalls;
 
 	ret = kvm_skip_emulated_instruction(vcpu);
 
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 36a8786db291..1b9232aad730 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -225,7 +225,7 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hflags |= HF_GUEST_MASK;
-	vcpu->stat.guest_mode = 1;
+	vcpu->stat->guest_mode = 1;
 }
 
 static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
@@ -237,7 +237,7 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
 		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
 	}
 
-	vcpu->stat.guest_mode = 0;
+	vcpu->stat->guest_mode = 0;
 }
 
 static inline bool is_guest_mode(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 04e4b041e248..2d8953163fa0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3014,7 +3014,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	bool write_fault = fault && fault->write;
 
 	if (unlikely(is_noslot_pfn(pfn))) {
-		vcpu->stat.pf_mmio_spte_created++;
+		vcpu->stat->pf_mmio_spte_created++;
 		mark_mmio_spte(vcpu, sptep, gfn, pte_access);
 		return RET_PF_EMULATE;
 	}
@@ -3689,7 +3689,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	walk_shadow_page_lockless_end(vcpu);
 
 	if (ret != RET_PF_INVALID)
-		vcpu->stat.pf_fast++;
+		vcpu->stat->pf_fast++;
 
 	return ret;
 }
@@ -4446,7 +4446,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	 * truly spurious and never trigger emulation
 	 */
 	if (r == RET_PF_FIXED)
-		vcpu->stat.pf_fixed++;
+		vcpu->stat->pf_fixed++;
 }
 
 static inline u8 kvm_max_level_for_order(int order)
@@ -6262,7 +6262,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		vcpu->stat.pf_taken++;
+		vcpu->stat->pf_taken++;
 
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type, NULL);
@@ -6278,11 +6278,11 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 						&emulation_type);
 
 	if (r == RET_PF_FIXED)
-		vcpu->stat.pf_fixed++;
+		vcpu->stat->pf_fixed++;
 	else if (r == RET_PF_EMULATE)
-		vcpu->stat.pf_emulate++;
+		vcpu->stat->pf_emulate++;
 	else if (r == RET_PF_SPURIOUS)
-		vcpu->stat.pf_spurious++;
+		vcpu->stat->pf_spurious++;
 
 	/*
 	 * None of handle_mmio_page_fault(), kvm_mmu_do_page_fault(), or
@@ -6396,7 +6396,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 	 * done here for them.
 	 */
 	kvm_mmu_invalidate_addr(vcpu, vcpu->arch.walk_mmu, gva, KVM_MMU_ROOTS_ALL);
-	++vcpu->stat.invlpg;
+	++vcpu->stat->invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
 
@@ -6418,7 +6418,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 
 	if (roots)
 		kvm_mmu_invalidate_addr(vcpu, mmu, gva, roots);
-	++vcpu->stat.invlpg;
+	++vcpu->stat->invlpg;
 
 	/*
 	 * Mappings not reachable via the current cr3 or the prev_roots will be
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b23b1b2e60a8..72f81c99d665 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1181,7 +1181,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
 	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
-		vcpu->stat.pf_mmio_spte_created++;
+		vcpu->stat->pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
 		ret = RET_PF_EMULATE;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..827dbe4d2b3b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4306,7 +4306,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					    svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
-		++vcpu->stat.nmi_window_exits;
+		++vcpu->stat->nmi_window_exits;
 		svm->nmi_masked = false;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		ret = 1;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f692794d18a2..f6a435ff7e2d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1577,7 +1577,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 
 	svm_prepare_host_switch(vcpu);
 
-	++vcpu->stat.host_state_reload;
+	++vcpu->stat->host_state_reload;
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
@@ -2238,7 +2238,7 @@ static int io_interception(struct kvm_vcpu *vcpu)
 	int size, in, string;
 	unsigned port;
 
-	++vcpu->stat.io_exits;
+	++vcpu->stat->io_exits;
 	string = (io_info & SVM_IOIO_STR_MASK) != 0;
 	in = (io_info & SVM_IOIO_TYPE_MASK) != 0;
 	port = io_info >> 16;
@@ -2268,7 +2268,7 @@ static int smi_interception(struct kvm_vcpu *vcpu)
 
 static int intr_interception(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.irq_exits;
+	++vcpu->stat->irq_exits;
 	return 1;
 }
 
@@ -2592,7 +2592,7 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(sev_es_guest(vcpu->kvm));
 
-	++vcpu->stat.nmi_window_exits;
+	++vcpu->stat->nmi_window_exits;
 	svm->awaiting_iret_completion = true;
 
 	svm_clr_iret_intercept(svm);
@@ -3254,7 +3254,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	 */
 	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
 
-	++vcpu->stat.irq_window_exits;
+	++vcpu->stat->irq_window_exits;
 	return 1;
 }
 
@@ -3664,7 +3664,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 		svm->nmi_masked = true;
 		svm_set_iret_intercept(svm);
 	}
-	++vcpu->stat.nmi_injections;
+	++vcpu->stat->nmi_injections;
 }
 
 static bool svm_is_vnmi_pending(struct kvm_vcpu *vcpu)
@@ -3695,7 +3695,7 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
 	 * the NMI is "injected", but for all intents and purposes, passing the
 	 * NMI off to hardware counts as injection.
 	 */
-	++vcpu->stat.nmi_injections;
+	++vcpu->stat->nmi_injections;
 
 	return true;
 }
@@ -3716,7 +3716,7 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
 			   vcpu->arch.interrupt.soft, reinjected);
-	++vcpu->stat.irq_injections;
+	++vcpu->stat->irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
 				       SVM_EVTINJ_VALID | type;
@@ -4368,7 +4368,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		/* Track VMRUNs that have made past consistency checking */
 		if (svm->nested.nested_run_pending &&
 		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
-                        ++vcpu->stat.nested_run;
+			++vcpu->stat->nested_run;
 
 		svm->nested.nested_run_pending = 0;
 	}
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 84369f539fb2..cf894f572321 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -813,7 +813,7 @@ static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)
 	if (!vt->guest_state_loaded)
 		return;
 
-	++vcpu->stat.host_state_reload;
+	++vcpu->stat->host_state_reload;
 	wrmsrl(MSR_KERNEL_GS_BASE, vt->msr_host_kernel_gs_base);
 
 	if (tdx->guest_entered) {
@@ -1082,7 +1082,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 
 void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.nmi_injections;
+	++vcpu->stat->nmi_injections;
 	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
 	/*
 	 * From KVM's perspective, NMI injection is completed right after
@@ -1321,7 +1321,7 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
 	u64 size, write;
 	int ret;
 
-	++vcpu->stat.io_exits;
+	++vcpu->stat->io_exits;
 
 	size = tdx->vp_enter_args.r12;
 	write = tdx->vp_enter_args.r13;
@@ -2072,7 +2072,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	case EXIT_REASON_EXCEPTION_NMI:
 		return tdx_handle_exception_nmi(vcpu);
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
-		++vcpu->stat.irq_exits;
+		++vcpu->stat->irq_exits;
 		return 1;
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 19dc85e5ac37..02458bb0b486 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1361,7 +1361,7 @@ static void vmx_prepare_switch_to_host(struct vcpu_vmx *vmx)
 
 	host_state = &vmx->loaded_vmcs->host_state;
 
-	++vmx->vcpu.stat.host_state_reload;
+	++vmx->vcpu.stat->host_state_reload;
 
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
@@ -4922,7 +4922,7 @@ void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(irq, vcpu->arch.interrupt.soft, reinjected);
 
-	++vcpu->stat.irq_injections;
+	++vcpu->stat->irq_injections;
 	if (vmx->rmode.vm86_active) {
 		int inc_eip = 0;
 		if (vcpu->arch.interrupt.soft)
@@ -4959,7 +4959,7 @@ void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->vnmi_blocked_time = 0;
 	}
 
-	++vcpu->stat.nmi_injections;
+	++vcpu->stat->nmi_injections;
 	vmx->loaded_vmcs->nmi_known_unmasked = false;
 
 	if (vmx->rmode.vm86_active) {
@@ -5353,7 +5353,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 
 static __always_inline int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.irq_exits;
+	++vcpu->stat->irq_exits;
 	return 1;
 }
 
@@ -5373,7 +5373,7 @@ static int handle_io(struct kvm_vcpu *vcpu)
 	exit_qualification = vmx_get_exit_qual(vcpu);
 	string = (exit_qualification & 16) != 0;
 
-	++vcpu->stat.io_exits;
+	++vcpu->stat->io_exits;
 
 	if (string)
 		return kvm_emulate_instruction(vcpu, 0);
@@ -5633,7 +5633,7 @@ static int handle_interrupt_window(struct kvm_vcpu *vcpu)
 
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
-	++vcpu->stat.irq_window_exits;
+	++vcpu->stat->irq_window_exits;
 	return 1;
 }
 
@@ -5811,7 +5811,7 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu)
 		return -EIO;
 
 	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
-	++vcpu->stat.nmi_window_exits;
+	++vcpu->stat->nmi_window_exits;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	return 1;
@@ -6062,7 +6062,7 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual = vmx_get_exit_qual(vcpu);
 	bool context_invalid = exit_qual & NOTIFY_VM_CONTEXT_INVALID;
 
-	++vcpu->stat.notify_window_exits;
+	++vcpu->stat->notify_window_exits;
 
 	/*
 	 * Notify VM exit happened while executing iret from NMI,
@@ -6666,7 +6666,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 			return;
 	}
 
-	vcpu->stat.l1d_flush++;
+	vcpu->stat->l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
 		native_wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
@@ -7450,7 +7450,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		 */
 		if (vmx->nested.nested_run_pending &&
 		    !vmx_get_exit_reason(vcpu).failed_vmentry)
-			++vcpu->stat.nested_run;
+			++vcpu->stat->nested_run;
 
 		vmx->nested.nested_run_pending = 0;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98a36df7cf62..2c8bdb139b75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -949,7 +949,7 @@ static int complete_emulated_insn_gp(struct kvm_vcpu *vcpu, int err)
 
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 {
-	++vcpu->stat.pf_guest;
+	++vcpu->stat->pf_guest;
 
 	/*
 	 * Async #PF in L2 is always forwarded to L1 as a VM-Exit regardless of
@@ -3607,7 +3607,7 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
+	++vcpu->stat->tlb_flush;
 	kvm_x86_call(flush_tlb_all)(vcpu);
 
 	/* Flushing all ASIDs flushes the current ASID... */
@@ -3616,7 +3616,7 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
+	++vcpu->stat->tlb_flush;
 
 	if (!tdp_enabled) {
 		/*
@@ -3641,7 +3641,7 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 
 static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
-	++vcpu->stat.tlb_flush;
+	++vcpu->stat->tlb_flush;
 	kvm_x86_call(flush_tlb_current)(vcpu);
 }
 
@@ -5067,11 +5067,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	 * preempted if and only if the VM-Exit was due to a host interrupt.
 	 */
 	if (!vcpu->arch.at_instruction_boundary) {
-		vcpu->stat.preemption_other++;
+		vcpu->stat->preemption_other++;
 		return;
 	}
 
-	vcpu->stat.preemption_reported++;
+	vcpu->stat->preemption_reported++;
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
@@ -8874,7 +8874,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	++vcpu->stat.insn_emulation_fail;
+	++vcpu->stat->insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
 	if (emulation_type & EMULTYPE_VMWARE_GP) {
@@ -9119,7 +9119,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	r = x86_decode_insn(ctxt, insn, insn_len, emulation_type);
 
 	trace_kvm_emulate_insn_start(vcpu);
-	++vcpu->stat.insn_emulation;
+	++vcpu->stat->insn_emulation;
 
 	return r;
 }
@@ -9285,7 +9285,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		}
 		r = 0;
 	} else if (vcpu->mmio_needed) {
-		++vcpu->stat.mmio_exits;
+		++vcpu->stat->mmio_exits;
 
 		if (!vcpu->mmio_is_write)
 			writeback = false;
@@ -10011,7 +10011,7 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	struct kvm_vcpu *target = NULL;
 	struct kvm_apic_map *map;
 
-	vcpu->stat.directed_yield_attempted++;
+	vcpu->stat->directed_yield_attempted++;
 
 	if (single_task_running())
 		goto no_yield;
@@ -10034,7 +10034,7 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	if (kvm_vcpu_yield_to(target) <= 0)
 		goto no_yield;
 
-	vcpu->stat.directed_yield_successful++;
+	vcpu->stat->directed_yield_successful++;
 
 no_yield:
 	return;
@@ -10061,7 +10061,7 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 	unsigned long a3 = kvm_rsi_read(vcpu);
 	int op_64_bit = is_64_bit_hypercall(vcpu);
 
-	++vcpu->stat.hypercalls;
+	++vcpu->stat->hypercalls;
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
@@ -10916,7 +10916,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
 	    kvm_xen_has_interrupt(vcpu)) {
-		++vcpu->stat.req_event;
+		++vcpu->stat->req_event;
 		r = kvm_apic_accept_events(vcpu);
 		if (r < 0) {
 			r = 0;
@@ -11048,7 +11048,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 
 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
-		++vcpu->stat.exits;
+		++vcpu->stat->exits;
 	}
 
 	/*
@@ -11099,11 +11099,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
 	 * An instruction is required after local_irq_enable() to fully unblock
 	 * interrupts on processors that implement an interrupt shadow, the
-	 * stat.exits increment will do nicely.
+	 * stat->exits increment will do nicely.
 	 */
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
 	local_irq_enable();
-	++vcpu->stat.exits;
+	++vcpu->stat->exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
@@ -11321,7 +11321,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 			kvm_vcpu_ready_for_interrupt_injection(vcpu)) {
 			r = 0;
 			vcpu->run->exit_reason = KVM_EXIT_IRQ_WINDOW_OPEN;
-			++vcpu->stat.request_irq_exits;
+			++vcpu->stat->request_irq_exits;
 			break;
 		}
 
@@ -11346,7 +11346,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 	 * managed by userspace, in which case userspace is responsible for
 	 * handling wake events.
 	 */
-	++vcpu->stat.halt_exits;
+	++vcpu->stat->halt_exits;
 	if (lapic_in_kernel(vcpu)) {
 		if (kvm_vcpu_has_events(vcpu) || vcpu->arch.pv.pv_unhalted)
 			state = KVM_MP_STATE_RUNNABLE;
@@ -11515,7 +11515,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false);
-	++vcpu->stat.fpu_reload;
+	++vcpu->stat->fpu_reload;
 	trace_kvm_fpu(0);
 }
 
@@ -11564,7 +11564,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			r = -EINTR;
 			kvm_run->exit_reason = KVM_EXIT_INTR;
-			++vcpu->stat.signal_exits;
+			++vcpu->stat->signal_exits;
 		}
 		goto out;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dbca418d64f5..d2e0c0e8ff17 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -393,7 +393,8 @@ struct kvm_vcpu {
 	bool ready;
 	bool scheduled_out;
 	struct kvm_vcpu_arch arch;
-	struct kvm_vcpu_stat stat;
+	struct kvm_vcpu_stat *stat;
+	struct kvm_vcpu_stat __stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
 	struct kvm_dirty_ring dirty_ring;
 
@@ -2489,7 +2490,7 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_INTR;
-	vcpu->stat.signal_exits++;
+	vcpu->stat->signal_exits++;
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b08fea91dc74..dce89a2f0a31 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3632,7 +3632,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool waited = false;
 
-	vcpu->stat.generic.blocking = 1;
+	vcpu->stat->generic.blocking = 1;
 
 	preempt_disable();
 	kvm_arch_vcpu_blocking(vcpu);
@@ -3654,7 +3654,7 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_unblocking(vcpu);
 	preempt_enable();
 
-	vcpu->stat.generic.blocking = 0;
+	vcpu->stat->generic.blocking = 0;
 
 	return waited;
 }
@@ -3662,16 +3662,16 @@ bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
 static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
 					  ktime_t end, bool success)
 {
-	struct kvm_vcpu_stat_generic *stats = &vcpu->stat.generic;
+	struct kvm_vcpu_stat_generic *stats = &vcpu->stat->generic;
 	u64 poll_ns = ktime_to_ns(ktime_sub(end, start));
 
-	++vcpu->stat.generic.halt_attempted_poll;
+	++vcpu->stat->generic.halt_attempted_poll;
 
 	if (success) {
-		++vcpu->stat.generic.halt_successful_poll;
+		++vcpu->stat->generic.halt_successful_poll;
 
 		if (!vcpu_valid_wakeup(vcpu))
-			++vcpu->stat.generic.halt_poll_invalid;
+			++vcpu->stat->generic.halt_poll_invalid;
 
 		stats->halt_poll_success_ns += poll_ns;
 		KVM_STATS_LOG_HIST_UPDATE(stats->halt_poll_success_hist, poll_ns);
@@ -3735,9 +3735,9 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
 
 	cur = ktime_get();
 	if (waited) {
-		vcpu->stat.generic.halt_wait_ns +=
+		vcpu->stat->generic.halt_wait_ns +=
 			ktime_to_ns(cur) - ktime_to_ns(poll_end);
-		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat.generic.halt_wait_hist,
+		KVM_STATS_LOG_HIST_UPDATE(vcpu->stat->generic.halt_wait_hist,
 				ktime_to_ns(cur) - ktime_to_ns(poll_end));
 	}
 out:
@@ -3782,7 +3782,7 @@ bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
 	if (__kvm_vcpu_wake_up(vcpu)) {
 		WRITE_ONCE(vcpu->ready, true);
-		++vcpu->stat.generic.halt_wakeup;
+		++vcpu->stat->generic.halt_wakeup;
 		return true;
 	}
 
@@ -4174,6 +4174,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
 	vcpu->run = page_address(page);
 
 	vcpu->plane0 = vcpu;
+	vcpu->stat = &vcpu->__stat;
 	kvm_vcpu_init(vcpu, kvm, id);
 
 	r = kvm_arch_vcpu_create(vcpu);
-- 
2.49.0


