Return-Path: <kvm+bounces-42567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC32A7A1FB
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9593A166192
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F5424EABF;
	Thu,  3 Apr 2025 11:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="TcrRN4mY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8828524DFFA
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 11:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679941; cv=none; b=KMtbarcHeeFD/ttB/suefv2meBv/0qH3FoOhMuxyI25pMwuvZ8Mjc/tnw1GdixVLWVCjJGIip3hupsWu+SR70G2fvkttO8R5yHMJ8qbV++mpcw/BTMKjhMXuuqt6ZNLkGJlWvUAN5VttldaaMcb4S3wikstO2wDPksVwXjXV4NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679941; c=relaxed/simple;
	bh=Azh59wZxXw0yOcy654yOp1KBuheFNdxSily/oCO2cqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzaE9BacNXRnmvxU5QzXNlrVaMkF5Yj43vwFhaC+fGUVPg3aV8sRMVF/m4B3IqRGiH3ghklUx7fRpUtSSjsiefzcbXPuQ/F70TlKw7bqpXHMSTRF5sOD8bDEd4y22S5gDM8iBAwziicz6STXf84Yau/oARy0Tezhv/b7UnJKd4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=TcrRN4mY; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3913290f754so61887f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 04:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1743679936; x=1744284736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4I41IipITScJpjVRL6TprMAJ/XjTheyblDpzSa8c88=;
        b=TcrRN4mYeUgNsDn/+x9gXg2oR+Oz5B25LI6av3I7R6/E8fY28yeVrv3Xg9pjJZtaO8
         FFQp6GdInoGSj4kqFMpdCXae9zqQuy+P+e5Ru8kGg+oFCq1pb30IpYYTD2L3DJsNvzO0
         Y5Ph69Q7IGlu0dqmx4FZtWQUesRBJoGMDFeVXhVTWyeXGvooTvimCAmDY9vbLQEbBaKL
         mnb0WjJEN/ag9xoP4/jS8FH9SqIYXIC1A44D6mku0LA8EwHLTvDovvx6a4jR3FO5Q4IK
         3iGvWaU5so2DofrVXZT186ByU9IrsI5GO+sstW/qjly4WdSOukdkh6+q1PEBmHPGT7J+
         f7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743679936; x=1744284736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v4I41IipITScJpjVRL6TprMAJ/XjTheyblDpzSa8c88=;
        b=gPOT9Jefm4ItP4jS/Y4OGxVGWx5PAR8vQIiVuKzm7Sbblct2+0+JStrG3Nitul+km2
         nGi5f+8JLcdPkxiOJ9wP0Lw+X2W7CQlYSCFsYSsX8NrojDRK7fFVMquMjeF8jiqLKqNM
         pmBSxhCigasGg4kSeoySj2IkqMSdp0dbXCzLbCT87PNjYAb4WQSLSsa0dreuILg6bau6
         UfSkdngYqI5QBlp+Zl2EVg2K6NRn5SgYhhKwaA8JoLWj7potM8mzx1TuOewOII+y8u6D
         VRuOQcIoWKA3T9pBCiV90WTGga2C1iaXQfytJRUpGt2eD5a2s3BK9KKjxa68aB7lflKJ
         OIxQ==
X-Gm-Message-State: AOJu0YwWFl9SepRt5h7ehvY2Sijbp6DAhntZuLII1D5TBYakg3TgCzOz
	mU6U5ptBPI5s8zsTzbn4dxwvl/9otFEofbKpMbvmSnpUIl3TE9obz0Pd61gHjQA=
X-Gm-Gg: ASbGncuAF0li4zSF6LMfcefDWxe1Yreh/vfoJ3jVLCsdluUFI3Kv7S4il4OVqyQ7edJ
	WeFLaTeL9l4njYz7f45Sa8dwEjL4Jz6C2zQ/glxFvNrWt1Iv26/zpiLAvf0aYW6MU/4U4D74zog
	hTfA7BwGxfiGjCCqo7jXJ4xfzkN3xsd/uLv9ggimoLPVRDnKolXB0Ot9BxkU3U8K8Fo4aLXQMNb
	za5epclPJHzs3/a/YiAVCjnQhcNE0qXh2J+2kPIvD3Yes8yzKeoE9o5jWWcDQN4GmD3FEXESD9M
	TwDRVDBDMym0v9jyH4h+I3C3qeZRUC7dqH4S1zFQ1H2GGSuF9jXFpk/4yLuDTlZqXL0oYYkDLZs
	vcQ==
X-Google-Smtp-Source: AGHT+IG37Xf9B62VUcljGsX2nc8emFPUfOIiPgop6kaEA0XU1nktX/EDvfLlLGCqE6Qni7LwKqU1Ng==
X-Received: by 2002:a5d:59ad:0:b0:39c:1258:17d5 with SMTP id ffacd0b85a97d-39c2483abcfmr3137958f8f.14.1743679935688;
        Thu, 03 Apr 2025 04:32:15 -0700 (PDT)
Received: from localhost (cst2-173-141.cust.vodafone.cz. [31.30.173.141])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3020d6b1sm1575928f8f.62.2025.04.03.04.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 04:32:14 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>
Subject: [PATCH 4/5] KVM: RISC-V: reset VCPU state when becoming runnable
Date: Thu,  3 Apr 2025 13:25:23 +0200
Message-ID: <20250403112522.1566629-7-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
References: <20250403112522.1566629-3-rkrcmar@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Beware, this patch is "breaking" the userspace interface, because it
fixes a KVM/QEMU bug where the boot VCPU is not being reset by KVM.

The VCPU reset paths are inconsistent right now.  KVM resets VCPUs that
are brought up by KVM-accelerated SBI calls, but does nothing for VCPUs
brought up through ioctls.

We need to perform a KVM reset even when the VCPU is started through an
ioctl.  This patch is one of the ways we can achieve it.

Assume that userspace has no business setting the post-reset state.
KVM is de-facto the SBI implementation, as the SBI HSM acceleration
cannot be disabled and userspace cannot control the reset state, so KVM
should be in full control of the post-reset state.

Do not reset the pc and a1 registers, because SBI reset is expected to
provide them and KVM has no idea what these registers should be -- only
the userspace knows where it put the data.

An important consideration is resume.  Userspace might want to start
with non-reset state.  Check ran_atleast_once to allow this, because
KVM-SBI HSM creates some VCPUs as STOPPED.

The drawback is that userspace can still start the boot VCPU with an
incorrect reset state, because there is no way to distinguish a freshly
reset new VCPU on the KVM side (userspace might set some values by
mistake) from a restored VCPU (userspace must set all values).

The advantage of this solution is that it fixes current QEMU and makes
some sense with the assumption that KVM implements SBI HSM.
I do not like it too much, so I'd be in favor of a different solution if
we can still afford to drop support for current userspaces.

For a cleaner solution, we should add interfaces to perform the KVM-SBI
reset request on userspace demand.  I think it would also be much better
if userspace was in control of the post-reset state.

Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h     |  1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  3 +++
 arch/riscv/kvm/vcpu.c                 |  9 +++++++++
 arch/riscv/kvm/vcpu_sbi.c             | 21 +++++++++++++++++++--
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 0c8c9c05af91..9bbf8c4a286b 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -195,6 +195,7 @@ struct kvm_vcpu_smstateen_csr {
 
 struct kvm_vcpu_reset_state {
 	spinlock_t lock;
+	bool active;
 	unsigned long pc;
 	unsigned long a1;
 };
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index aaaa81355276..2c334a87e02a 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -57,6 +57,9 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 				     u32 type, u64 flags);
 void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
                                       unsigned long pc, unsigned long a1);
+void __kvm_riscv_vcpu_set_reset_state(struct kvm_vcpu *vcpu,
+                                      unsigned long pc, unsigned long a1);
+void kvm_riscv_vcpu_sbi_request_reset_from_userspace(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
 				   const struct kvm_one_reg *reg);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b8485c1c1ce4..4578863a39e3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -58,6 +58,11 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_reset_state *reset_state = &vcpu->arch.reset_state;
 	void *vector_datap = cntx->vector.datap;
 
+	spin_lock(&reset_state->lock);
+	if (!reset_state->active)
+		__kvm_riscv_vcpu_set_reset_state(vcpu, cntx->sepc, cntx->a1);
+	spin_unlock(&reset_state->lock);
+
 	memset(cntx, 0, sizeof(*cntx));
 	memset(csr, 0, sizeof(*csr));
 
@@ -520,6 +525,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
+		if (riscv_vcpu_supports_sbi_ext(vcpu, KVM_RISCV_SBI_EXT_HSM) &&
+				vcpu->arch.ran_atleast_once &&
+				kvm_riscv_vcpu_stopped(vcpu))
+			kvm_riscv_vcpu_sbi_request_reset_from_userspace(vcpu);
 		WRITE_ONCE(vcpu->arch.mp_state, *mp_state);
 		break;
 	case KVM_MP_STATE_STOPPED:
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 3d7955e05cc3..77f9f0bd3842 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -156,12 +156,29 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
 	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
 }
 
+/* must be called with held vcpu->arch.reset_state.lock */
+void __kvm_riscv_vcpu_set_reset_state(struct kvm_vcpu *vcpu,
+                                      unsigned long pc, unsigned long a1)
+{
+	vcpu->arch.reset_state.active = true;
+	vcpu->arch.reset_state.pc = pc;
+	vcpu->arch.reset_state.a1 = a1;
+}
+
 void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
                                       unsigned long pc, unsigned long a1)
 {
 	spin_lock(&vcpu->arch.reset_state.lock);
-	vcpu->arch.reset_state.pc = pc;
-	vcpu->arch.reset_state.a1 = a1;
+	__kvm_riscv_vcpu_set_reset_state(vcpu, pc, a1);
+	spin_unlock(&vcpu->arch.reset_state.lock);
+
+	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
+}
+
+void kvm_riscv_vcpu_sbi_request_reset_from_userspace(struct kvm_vcpu *vcpu)
+{
+	spin_lock(&vcpu->arch.reset_state.lock);
+	vcpu->arch.reset_state.active = false;
 	spin_unlock(&vcpu->arch.reset_state.lock);
 
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
-- 
2.48.1


