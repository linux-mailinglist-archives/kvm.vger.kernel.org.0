Return-Path: <kvm+bounces-54680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E671B26BC1
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF12A1CC33E6
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328C9246798;
	Thu, 14 Aug 2025 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Oi12IA5X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84E825A354
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186985; cv=none; b=W1x2ndt1FbwmSRh24+342ue0CVU+0+IIDEN1hdeOy+Vdj8PRbx2Zm/Io7UcHoDlXXBmIRwYNcQbs0H3CV8UPuPh5uLpqCDg7vRuuMFo2e2lN7b2kPY1pW21MqoB6NJYzzCe25qTMUUiMmFDqXkJZFwZC3x63jmEU3bIxkuhjeac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186985; c=relaxed/simple;
	bh=xDTORQO8wR4Y6gL1EQL3uPFlKMfbNy0CTvdho8dymHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9lxEfLoAEhVZsrnOEGF7fpvkgmEMWU+iShni0uIpernG8d8QtpgDXUsOHeZU9o2z5OdgLiL1IKwUhz7h0DejZeR8IGKYZc3mA08N9R7y3nc7KeKNcagodGc9DzGNZCR52O2kd/Z//VTzFhy6cizZK7tqb9uOCamWTRt/gx3sCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Oi12IA5X; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4717330f9eso769574a12.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 08:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755186983; x=1755791783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BjEBV0XycMWcBVpHucFxuLGWtwgSmQrzNPLz1/7S0Uc=;
        b=Oi12IA5XdEZLo1S0NmtaI10RG/YfdWwGmQLOBeaeeOWStcjl2Pj3RacbRbEFFpFiPJ
         vDAy8iMeqZ+JIPWKHXZjmZtJ9MJr9K2k2DJ5Cphp81h/njPgr7vs44xPFJVkKxpkutXB
         cKYOLFkg0cAZ43aijSeGotvdOinOrD8GEoGj7lszpYUbjFf3/1gcK1Q+FX2pEqAL1L5C
         xyyrtdV7ztAut0jbMBOa8dFGGZUZfxJa628msWG88Af9lk9++GALPDFDSj4UR3C2ibAd
         RIXI4vxEmNcQ0q34e5kvXmuHDJ/GmTXagaxtXvgb9MAGEtFQP0EDzl3EyxirE8NXqSIH
         eprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755186983; x=1755791783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BjEBV0XycMWcBVpHucFxuLGWtwgSmQrzNPLz1/7S0Uc=;
        b=t1KEqUtiJqdI+h7bEUsj1xQUiPkCKCgKnphW6NqXIUbPx8rwwIPcE9hIkDH/kY33s0
         PSa598K5LGr0uqJMdFZLR9NSw2/1nsRK8cUeGgPl0WBhPtjSWFNtPPql7HN3BOPauj6T
         wEQw8d2p1D/KS2A0j/CbscgfACm8KZXhyWaEoYl03RuQwJLZ0dbm/B/QtH8SHQ0yNgDm
         VPwx4G1cSpSarvhcu3mjPDmqHRft/A6m66Lo/6E0M6z3fAw3icJhXG7gmrzdtB29pi7r
         RmKNEzqqEEwcokiQN3glv0oFMTVBgM6hCSCY9aBsYhF6Pp3X+ZLE0WwKq8w/SeEzMYb0
         m5Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXh/NwAs+NBlDkYuQ19Mb7D7m9U829sjIPcJxB98+Qo+q5YHIjwe3/wh0istdHOid3rYQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YytkFjWljPLvnV673pCDzn3BmgVD5TlfwHGXRkJ+fni7H5CrftG
	AzLFYFeREg+hQPCR+ilbk9R6pb2soAhQ97YF+Eyo3k+ywPuwkNcbRgqo+kBgLf44h54=
X-Gm-Gg: ASbGncvOPDkTR+DtDGzqtsEo73TUHZDeUVqFrKo3N5s0/R4Bc+Pe8F/few58QWrRBu4
	6pxHa3aMZq7/MSJ449UaXKbjC9kmoCQCY475ve26ScurEM1CbCYuwQpDcMJAXolxo3ttEKnVQqQ
	ZI6GQZ6yCHgeKrFc+/C62KUhFkdqnXnx9Ha94hfm3KX2YGdOuN0KsddC3U3dJacltXhEiDsbPqj
	iGg5pNboeuycjVKLsh40suWOhyLh41JkC21FUtRU379c/6vLsffWWmONpetuSbRWPJQHDkzB+AZ
	YgQREct3Wi8FcQIx/Yq+0PXTz8EwaIyqIuVxqjP8wm/5bImtMnLTR1CZ3uI9ZEVty8DY0F7pC2P
	PuyC6rO9Q4DbgDCEbTAiZwszV2wTd6NgE+6J4W2zePAMk3ZwOPZPqa/OTeCfqMA==
X-Google-Smtp-Source: AGHT+IGItqFm8z55cDwxSzzGs3dPEK+gv7cx+ag71dX5oyptRWM4L/1ck05jILA7+mE1V8PQvvjeLQ==
X-Received: by 2002:a17:90b:5246:b0:311:eb85:96df with SMTP id 98e67ed59e1d1-32327a63a5cmr6292953a91.17.1755186983087;
        Thu, 14 Aug 2025 08:56:23 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233108e1d9sm2225500a91.29.2025.08.14.08.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 08:56:22 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 4/6] RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
Date: Thu, 14 Aug 2025 21:25:46 +0530
Message-ID: <20250814155548.457172-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250814155548.457172-1-apatel@ventanamicro.com>
References: <20250814155548.457172-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ONE_REG handling of SBI extension enable/disable registers and
SBI extension state registers is already under SBI implementation.
On similar lines, let's move copy_sbi_ext_reg_indices() under SBI
implementation.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 +-
 arch/riscv/kvm/vcpu_onereg.c          | 29 ++-------------------------
 arch/riscv/kvm/vcpu_sbi.c             | 27 ++++++++++++++++++++++++-
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 144c3f6d5eb9..212c31629bc8 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -78,6 +78,7 @@ void kvm_riscv_vcpu_sbi_request_reset(struct kvm_vcpu *vcpu,
 				      unsigned long pc, unsigned long a1);
 void kvm_riscv_vcpu_sbi_load_reset_state(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_reg_indices_sbi_ext(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
 				   const struct kvm_one_reg *reg);
 int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
@@ -87,7 +88,6 @@ int kvm_riscv_vcpu_set_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm_one_reg *
 int kvm_riscv_vcpu_get_reg_sbi(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 				struct kvm_vcpu *vcpu, unsigned long extid);
-bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 5843b0519224..0894ab517525 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -1060,34 +1060,9 @@ static inline unsigned long num_isa_ext_regs(const struct kvm_vcpu *vcpu)
 	return copy_isa_ext_reg_indices(vcpu, NULL);
 }
 
-static int copy_sbi_ext_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
-{
-	unsigned int n = 0;
-
-	for (int i = 0; i < KVM_RISCV_SBI_EXT_MAX; i++) {
-		u64 size = IS_ENABLED(CONFIG_32BIT) ?
-			   KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
-		u64 reg = KVM_REG_RISCV | size | KVM_REG_RISCV_SBI_EXT |
-			  KVM_REG_RISCV_SBI_SINGLE | i;
-
-		if (!riscv_vcpu_supports_sbi_ext(vcpu, i))
-			continue;
-
-		if (uindices) {
-			if (put_user(reg, uindices))
-				return -EFAULT;
-			uindices++;
-		}
-
-		n++;
-	}
-
-	return n;
-}
-
 static unsigned long num_sbi_ext_regs(struct kvm_vcpu *vcpu)
 {
-	return copy_sbi_ext_reg_indices(vcpu, NULL);
+	return kvm_riscv_vcpu_reg_indices_sbi_ext(vcpu, NULL);
 }
 
 static inline unsigned long num_sbi_regs(struct kvm_vcpu *vcpu)
@@ -1215,7 +1190,7 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcpu *vcpu,
 		return ret;
 	uindices += ret;
 
-	ret = copy_sbi_ext_reg_indices(vcpu, uindices);
+	ret = kvm_riscv_vcpu_reg_indices_sbi_ext(vcpu, uindices);
 	if (ret < 0)
 		return ret;
 	uindices += ret;
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 8b3c393e0c83..19e0e3d7b598 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -110,7 +110,7 @@ riscv_vcpu_get_sbi_ext(struct kvm_vcpu *vcpu, unsigned long idx)
 	return sext;
 }
 
-bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx)
+static bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx)
 {
 	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
 	const struct kvm_riscv_sbi_extension_entry *sext;
@@ -288,6 +288,31 @@ static int riscv_vcpu_get_sbi_ext_multi(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_riscv_vcpu_reg_indices_sbi_ext(struct kvm_vcpu *vcpu, u64 __user *uindices)
+{
+	unsigned int n = 0;
+
+	for (int i = 0; i < KVM_RISCV_SBI_EXT_MAX; i++) {
+		u64 size = IS_ENABLED(CONFIG_32BIT) ?
+			   KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
+		u64 reg = KVM_REG_RISCV | size | KVM_REG_RISCV_SBI_EXT |
+			  KVM_REG_RISCV_SBI_SINGLE | i;
+
+		if (!riscv_vcpu_supports_sbi_ext(vcpu, i))
+			continue;
+
+		if (uindices) {
+			if (put_user(reg, uindices))
+				return -EFAULT;
+			uindices++;
+		}
+
+		n++;
+	}
+
+	return n;
+}
+
 int kvm_riscv_vcpu_set_reg_sbi_ext(struct kvm_vcpu *vcpu,
 				   const struct kvm_one_reg *reg)
 {
-- 
2.43.0


