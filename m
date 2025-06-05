Return-Path: <kvm+bounces-48476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34AE3ACE9EB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5DE1177B6F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49D82046B3;
	Thu,  5 Jun 2025 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="djHsuOvx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACDF202C5D
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104123; cv=none; b=CXi9eENX0otK/sPPKhTyniIiGSJazCZ2a2Jen18+Cw+xyjXxrMZZatM/B6BnoTIPxS8No43XmRh4rH7qq08a0A/7hWJZqDuh543I9QrorQZIPgbS9piFL3W1sc5hWT+cZyS28J9Hz5W0UchgyLxjMidDdLHlNsMn+QpA/C3r/zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104123; c=relaxed/simple;
	bh=BTmeW5tzGEJWz7QXNK5VYjyFPuMYNsjSNN0CCr2FXlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y971mzwnPPXGc03jUsdcYKw3VQf+8yudXm/w9yxOu0Xp1pyr1uU2Supv6V/u/6oTq5oRjtO0P6ekw54O657E3mZxlt3/Gc38EwrQXufWEWCCmUEQfBkdOq+UQzAyeN2JjvFZFmGfU0chCakG9XErxN6uTXDMsh6e2QqLAZuN7QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=djHsuOvx; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-234fcadde3eso7541815ad.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104121; x=1749708921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ete+JrWOt0QHSA4tomw5kPck/IlNBcpn3GaqoFoCnO0=;
        b=djHsuOvxpGIZ+ixMEGXZjMe21zgGg2qe71dhpyU1DBpSap6Uun+H0QNir7ruy6hY7A
         +70QmION/j/hVTkTdid2/UJkyVExSzm+OfZP6/ksbFA//x+8x23xcNXuafLgjaTH1JQq
         tO0+ZGnKLXlRxH/eUt95bQYViYG4NZUz1m8SF2Y3VbY3hB3+otQqLTzcj2BS0AwGkzAq
         yUWzeJHUH4m8nAqUET2Z8OF30misHWnpjKvYOgoX/q49VqL1qFKr2CVEevMd8IPHZWyL
         d6MPpYIbrC7G0RV8ioqO9U6j8X0Y4HSEDq5fKO30BeXsfH4pq37MpinWPIv2Dr6M2+oq
         yIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104121; x=1749708921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ete+JrWOt0QHSA4tomw5kPck/IlNBcpn3GaqoFoCnO0=;
        b=L2/P2o7veSlPJGMAwXiYpdp72wwGty7Ej8g7qjkOZsZKz4wFouG7zEvhoNdsm23ZtY
         vzaDUOei5gO5XdQyfoTwQIvQd6L3dhon4NgVcOW+e0//8MNvtVRvX49zp+h48DYKp4DV
         B1Dk+qk/FM6LHBEVcxa+pgLEdnnq4AXIb+Uxch4XWw9kxqvVYVXLdCCfo62BuXwxqtZB
         6gllR9bDoL3n0vw0gJZtl39YxVmNdkmFDujLEb24g9xKyjq0tx/pacsBvD74EgC0Bp2G
         racrjJeV0lg0YwYnEwhXV5pHy++einz5BXBsTAdaoWa4vKZiVU1aJZCaif+uzs72sFQm
         v8VA==
X-Forwarded-Encrypted: i=1; AJvYcCWeOT7Q91yrs4OWXVr8l9aC1XoLb26lypjaefntMXRJ3RtmhfAwzF2eGivdNZCAkNk4FHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUxSHDxTbbVG9JpGerPNFiw5EHL0XGGKJBO9bYHXXNfQFY1EP5
	PUDhzfOeAE4HqCt4LviWd3PY+nEtvTvJbRpVXrWy+DayvSw2gO9tyD4PwUzdqt0iehY=
X-Gm-Gg: ASbGncvv02MCv3KrESfByjjK/SWoMq01lf4EXoFXzN/tdoDAU4fbHWT0JOp1iPInU/x
	FDDejd+0vjcge31idwC1xN5348HqWJeYLlG2bo3a5V/WgN7sdSHI80I3jxkA6r3ZhaRM/hyGmWK
	K20HWZpkZcxLUNGbtb3zn6vMbpwgbVrKW0V1vPVpDxahy9osWKzmM6RDf1wZEeCvuP9WSoIsPjo
	DhwDzJIMviEIYxT8ZBaunishsWrvlCQf58KKWH7qj0y/fG8I8t5J6fc3J2NMxOeyJAOgAtsn58z
	heWyiIKtYXF1bf37djRWxl3ZXbJvcEk7qHHC/pf9xDbH8bAOwPqRffwdTNdFapd4Y0n9HGVFCxZ
	5+ceK8w==
X-Google-Smtp-Source: AGHT+IH4OBU+MycjQPriNgZTJHSLbifpeWqdkPpUgu3tCEdkhvV1zsaXs7ozI9xOz34l1HXvk8nshQ==
X-Received: by 2002:a17:902:da8f:b0:235:f078:4733 with SMTP id d9443c01a7336-235f078524emr28994305ad.8.1749104120604;
        Wed, 04 Jun 2025 23:15:20 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:20 -0700 (PDT)
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
Subject: [PATCH 04/13] RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
Date: Thu,  5 Jun 2025 11:44:49 +0530
Message-ID: <20250605061458.196003-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kvm_riscv_vcpu_aia_init() does not return any failure so drop
the return value which is always zero.

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
index 43e472ff3e1a..5b7ed2d987db 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -539,12 +539,12 @@ void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
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
@@ -556,8 +556,6 @@ int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
 	/* Initialize default values in AIA vcpu context */
 	vaia->imsic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
 	vaia->hart_index = vcpu->vcpu_idx;
-
-	return 0;
 }
 
 void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 6a1914b21ec3..f98a1894d55b 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -160,9 +160,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
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


