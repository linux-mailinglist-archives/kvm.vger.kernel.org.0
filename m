Return-Path: <kvm+bounces-42566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B96EAA7A1F6
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 301381765DA
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0644C24EAA3;
	Thu,  3 Apr 2025 11:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="f/LkW38F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9006F24E01B
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743679941; cv=none; b=G7WhYZebO60eMXY885PMxF4uia7o/8GKzveiK/4gkSZFIwcvOEvGcwtp//DQESWjypCfgEpOv6WTxjrN+1+09TJ5wt1Tc8uVyJlivJQYeLZELWhuzEBAzIlW+L7A/nOBrpixdKGk+uZIcTA6C5UFwxBnSqHCq4Xr8f71uOb1D40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743679941; c=relaxed/simple;
	bh=WO1z1H1Mibkl/wzBNl7Xjb98G13d2MySStzMJVGKot4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CnEq6C+AuNLsL0uBjm/Hlnr75FMTTZXS4IQrikJPb7OYGMQu1YSfHYmlLxS4jZDpzxdO9haJ68I1Gl+va1dm4X6wGE6vGQk2gwNbvmA8NPTVoC4NsrVOkMnVmggOGJRElV2dEYOu+AWeSkHVNq0u4Ckwi7ZXhx8dHqu7oVVzNV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=f/LkW38F; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfe99f2a7so257185e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 04:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1743679937; x=1744284737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oR6PqtGhCEjz92xi+hsij6mLCExpfkTVXIEuhpc1C/o=;
        b=f/LkW38FRYON0y8kpjoZFjil6pP8fLd8oniJFXr1bEkEpq6WdN5ZzbcoV1aXz9HSyY
         JrEF9Exkrk68qlkGIGDJr57o7qmz56uG3momgxS2Qi7l/OahGTE03F3Sjz53Q+rTogbv
         X96N1l4uYRUoDk7boqGB2s+iUkyG8Gh64Fty2fDMCZ9gravHeyPgzLikaNP1qlhkIP3B
         xsU9NCSEmMyoakNAIHfobWwT0x7pfDYrtuqDQwuqmLxW+Ve7TfmOor06AYuDTsTG7RJP
         OVH2d/sEvVztIsdsWaO42kobRsJV24OnzaZNGF1HWCJfFrZ4M1SbBSCoN2rvQnbPlTtV
         dfZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743679937; x=1744284737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oR6PqtGhCEjz92xi+hsij6mLCExpfkTVXIEuhpc1C/o=;
        b=smYFM+JEI90X9MFEEJ0tzGa7AdX/+Q3e+KqU5V10blky+SaKRQNvKJS6ozB3mKfLZz
         HHTBzmDqKnt7aLJAEgB7dAYitERmeX33sB1jIu5eSOcprd6GmGk1pyUCRod2XlQJsrnw
         VRS2qDuComC2c+inkYIi8ZAJUuMNx5wo5pDIFdi2xLYm16lA1J2VO6wHIsBQwx+6iKfa
         5mt/9gNlnB3O0MIeALEMYPNh8SIvNCzFOUSFQ5/0lnqsPk6p4FNhMHSNpZmOy4Wqrx1p
         augNkk7m5WafePiIl5z370iRdvJit1z/iz7GpB2JA9hpcKza8imb3MXnqksux1A+PaSG
         m3rg==
X-Gm-Message-State: AOJu0Yw8f30dOXszoLDFBKnfpJEEAntw/dWHY1MedD/YT9MDIYTNKiHC
	yzPuX/oXW9FYnvHt9XJjbVWT38tqKuoJyLTrFLvx6e4xldVDPtVoDkSk8cyG+Is=
X-Gm-Gg: ASbGncuHcihv27hbQsmeZ2CthBr40OaNaNvo1Ga1/1Yp1BEOaCTRlOCe4oXxsk9En8i
	/MdM2Lmi6dWuJGTS0CIqCGHgoiSnbO85rhe03CvBzrMt5gTLDJV9r/bpHZ+HySScOc0e8m36F6M
	+K0wgxczsR57z5+beMykpVT95yTeCF4zz8v3XYQnmci0UlAH7FkoXGPdYM+49dHd3b8sZqeAgTC
	KSNQAZK9LDTsUtaidsUyT03JYTwdKs+Fm2NqmsL2vnsA10T+0m9lu9ID+CKPZEsNyPacwMDIanA
	5UM8mM66FnYt4VdmMoaB3Cw6y4eSDFANUNGClKO+z5C0a5z9mnOnXFucwpTFn50ig+/6LDuvMKJ
	BHw==
X-Google-Smtp-Source: AGHT+IFLuPHIJtkY001V8NzGfGDvy4KWQWKKGAIqS8lFxrZ1d/GjyGP4Yf4pmkBcRsFqmKnj2gYoIw==
X-Received: by 2002:a05:600c:1d12:b0:439:8c80:6aee with SMTP id 5b1f17b1804b1-43db62bc0femr69162255e9.4.1743679936757;
        Thu, 03 Apr 2025 04:32:16 -0700 (PDT)
Received: from localhost (cst2-173-141.cust.vodafone.cz. [31.30.173.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec169b4e4sm19424775e9.20.2025.04.03.04.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 04:32:16 -0700 (PDT)
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
Subject: [PATCH 5/5] KVM: RISC-V: reset smstateen CSRs
Date: Thu,  3 Apr 2025 13:25:24 +0200
Message-ID: <20250403112522.1566629-8-rkrcmar@ventanamicro.com>
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

Not resetting smstateen is a potential security hole, because VU might
be able to access state that VS does not properly context-switch.

Fixes: 81f0f314fec9 ("RISCV: KVM: Add sstateen0 context save/restore")
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 4578863a39e3..ac0fa50bc489 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -65,6 +65,7 @@ static void kvm_riscv_vcpu_context_reset(struct kvm_vcpu *vcpu)
 
 	memset(cntx, 0, sizeof(*cntx));
 	memset(csr, 0, sizeof(*csr));
+	memset(&vcpu->arch.smstateen_csr, 0, sizeof(vcpu->arch.smstateen_csr));
 
 	/* Restore datap as it's not a part of the guest context. */
 	cntx->vector.datap = vector_datap;
-- 
2.48.1


