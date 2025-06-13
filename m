Return-Path: <kvm+bounces-49375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B95AD836F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E35B3A16C4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC2125BF1E;
	Fri, 13 Jun 2025 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="lmUgZLo8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81B125B2F0
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749797886; cv=none; b=HV46xDX5UA8Re/ODzsgyIzHmJ+3awt+FP4STKamHLGTGEb4wOeDB20n3EVQ/JCUJuARZPeXvWtuqZjuUDpHrWMibgcByF9vApiWYMqwe+/gkXYbgWHSx7Aorfwo4TfMniKv0z736qsTV7kF83sJXalfHcDNNqeqR+ga6rx61CW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749797886; c=relaxed/simple;
	bh=S4GPuCe590xZl2EuRNnIMDQ2EGVo96MnzdBawsw3VME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/oioyNny4brMmxdOVc7nG/eBjjiUx/Lgry+NvHFS/YaoKRMPiEz5dD0agnBYk8uAhIM+4ZJn9ua5jwY7KfzYFjKdf6rmfXTlkhTJoYCJKAlTnydIDdahcupvWKPVdUrpSn1+yCn8I9a9j3m3ogwNsPI0JMJN5ELMdGHpiJTwio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=lmUgZLo8; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235ae05d224so25537175ad.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749797884; x=1750402684; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKQfZHKenjLPRqEIi0Ln2Cx1EmVsnnUE8sKaMZB78eg=;
        b=lmUgZLo8xgCeCBp+1/EWNdUnInsVBoDGwGrDBLciCnihe9T6Jw8u29g1iqNDxoAUzE
         TYzBS9Z24/bZtrp3u07JvhkpjXQuDI5n5vDQWFyxX5M+sZEF+bmNySIXSuTWUhY46AmF
         XIt3Fm2uwyoHmdhH+oXuMCHy4totmmKIg9YOiMY7ULWdDP3LsiJ98J7yXz1hl6rUUkJ8
         9gnBU+n9EQv1yPdim4Am7qme8oblhE6eqILz9WcE1shAOTroaPepysiIKzGkYVWg61Ie
         UVYbtjxyaMpSSa5m+T4xLB392V6vJTexcX4ulPYYeuSTbfP+keNdSi76d+OXkWWaC+dL
         Z2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749797884; x=1750402684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bKQfZHKenjLPRqEIi0Ln2Cx1EmVsnnUE8sKaMZB78eg=;
        b=RLUbTf9fmZ4isgWTHBaPxfLSmJnV1ez6M2ZSIStkAKMeX0N1hqkcHEWCmr9D4UWTM6
         HloriEuxz42NmPwvegdDMUPXmZD0i0zsnSC/jVM5ZH4cHF81jo8hslYIyTGs4Nre8m+l
         3Vw1x6LWPz/Mr5xZZYsEDmbMNaMJUCTEp3t2Be2R2rMQ/PFT2oefg3/hnjyjDCww1aRZ
         wgdI+8Uflpj5+Rbf4pCs038lrwnibJeMFaiGTbmeidyfLARi7DQzekrb1svfq6R24L4i
         vpvqT1XK6ZNNTwvV+Zn+YMptaDD7Kn5B+FtDFKD2PkQakF3fnnS1hyHgf+LzVzL1ZZl6
         YnKg==
X-Forwarded-Encrypted: i=1; AJvYcCUVveD0P2OROVVOO58S1fUXRTwwpSaH+glPpyYn0KItvE4SMPjiAkPnFnr9c5eFnoFHrjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtNFD7B+cICvf+nPPK9n4OoOVEU8Pf0dgLz02e/uH3f/dSO5qe
	hPN0lmJeHCw2Z2DRNWMODvp0Eq3ZfcQKLz4S7zzs3nhHCqhmMTt/1DmQGgC4kUUVw8gPS7dbW9T
	CDZkPitU=
X-Gm-Gg: ASbGncuivNovUbytnXRQQUEBqpjMguKKK2kA5v20Yv50Z6zU5W1L5uSyy3nFPMyqVQ1
	u1A5CQ90pfYryN+jwP+2f/fP6U9u4rzOXLlIyaP/eVwq3YicoDnr+Mgimw6EDH/7tcXjiQr5ea1
	HZ7hq1vXbn2pp3Y0QUgZP0tX9BpbrUlalSr7pN8VH3SeS0phMeKnkD7fuDBqetmLy2EYoBmEbir
	F9S+xEzJnKHErWSYkyFS9SD3HrJ2mgP15qWKQnsXx7afZwE5AuApKRrK4FbQ23EwtrZIZVEF2O4
	6RrL5F4EPukMEAUBv8DCbkWi5buPMS0Nh868i0lwH7m9VeSeP/dbrkShOlsMVtu8mDl850yPWWV
	syfZttAwwv4HBhCnwwWc=
X-Google-Smtp-Source: AGHT+IG1oIFmYmo4nzolmhFmjeasCs1i1bS0vqnVVHiUcmyimhpiT1WD26mREN2ygRQRC/I3Yp7nzA==
X-Received: by 2002:a17:902:f647:b0:234:595d:a58e with SMTP id d9443c01a7336-2365fb73e68mr22915165ad.25.1749797883849;
        Thu, 12 Jun 2025 23:58:03 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49b7fsm2653022a91.24.2025.06.12.23.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:58:03 -0700 (PDT)
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
	Nutty Liu <liujingqi@lanxincomputing.com>
Subject: [PATCH v2 02/12] RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
Date: Fri, 13 Jun 2025 12:27:33 +0530
Message-ID: <20250613065743.737102-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250613065743.737102-1-apatel@ventanamicro.com>
References: <20250613065743.737102-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kvm_riscv_vcpu_aia_init() does not return any failure so drop
the return value which is always zero.

Reviewed-by: Nutty Liu<liujingqi@lanxincomputing.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h | 2 +-
 arch/riscv/kvm/aia_device.c      | 6 ++----
 arch/riscv/kvm/vcpu.c            | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 3b643b9efc07..0a0f12496f00 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -147,7 +147,7 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 
 int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
-int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 806c41931cde..b195a93add1c 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -509,12 +509,12 @@ void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_aia_imsic_reset(vcpu);
 }
 
-int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
+void kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
 
 	if (!kvm_riscv_aia_available())
-		return 0;
+		return;
 
 	/*
 	 * We don't do any memory allocations over here because these
@@ -526,8 +526,6 @@ int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
 	/* Initialize default values in AIA vcpu context */
 	vaia->imsic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
 	vaia->hart_index = vcpu->vcpu_idx;
-
-	return 0;
 }
 
 void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b467dc1f4c7f..f9fb3dbbe0c3 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -159,9 +159,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_riscv_vcpu_pmu_init(vcpu);
 
 	/* Setup VCPU AIA */
-	rc = kvm_riscv_vcpu_aia_init(vcpu);
-	if (rc)
-		return rc;
+	kvm_riscv_vcpu_aia_init(vcpu);
 
 	/*
 	 * Setup SBI extensions
-- 
2.43.0


