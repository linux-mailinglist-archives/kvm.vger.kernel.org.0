Return-Path: <kvm+bounces-54677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F08EB26BD2
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 18:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E060AC0F3B
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 15:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E8B222560;
	Thu, 14 Aug 2025 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="fiz69Bs3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B2A204680
	for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755186967; cv=none; b=hYsiYubbQHXQZKLHmwe1YNd8/dOqdl74Mmx2qnlvhPdKmmVr3aMbJbNan0CO1MlEMPtweziw13FIlLeqbB+bMnkLA5cNACwKw61X4aVWsMvm3NlVR6XxdOxoVrx2S4Yo+v3tkjTowEYpuGz096XlRM2OqHtkPERcOWQXfnjdDK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755186967; c=relaxed/simple;
	bh=AMl3xYJNuSAGeF7OLy/Kzv4+2drH4oPVNI0DIJBBJPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6G2Rw44RPBjkpNemh7k4fI9kjvOblgSlSRqlft0ZolckG8MhFovhkpkAuQFlRSQx/bEuvLxP9QwR/v+rSVZoAJdK9q5T2gKwwWknz7+M2IzwUWtzU8+/z9rCxcs1+1uObz7djznY8AKqFf3jczKwqZ/ATE7s+9sPaYnf4maTOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=fiz69Bs3; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24457f47492so7787905ad.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 08:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755186966; x=1755791766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bm60/2Cr4w6uAzbvsdcbKrh6VNvMu+/Ils5A4Kn+0Hk=;
        b=fiz69Bs38/4zeuGfhRlrC409rA6lEj1VYNmfke5l81TWzPBup8G8xjG+Ix46y4RGnD
         tANIVvox1Lw+H8k6HCjSBfy475Iao8yS1/4G7BtiaPYU9pxFCHqtFJ+iwmpGHPOk7S4/
         SgvIYlk+1XRCUhPURCkSVHCFCNaLG70zX+XwHwSE8/XrzPrErUWjAWfU+t6Bd4/dpIRE
         OMSq8M3wYKY8Cpt1pEGXOaZ/LjyKOOiJBWLXe3yYgpODVdVSabxAKEvbI4W79O5fw2j/
         jrPsFqMgYeNvQX0Uq41CqV4WgUX7mPhmb8ZGwbNawawJAnvIIAFs+v6qp9Nu0ZDIIcCb
         jAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755186966; x=1755791766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bm60/2Cr4w6uAzbvsdcbKrh6VNvMu+/Ils5A4Kn+0Hk=;
        b=nxW1IBPXGvj5BApSpNBimdiL1naB5JENm4IUJvhmW+LpeuN3Kf3IgH8tnaVti8kRHY
         U4LfFOZ+1+wgsd4O2c1hHG2K27nJioYZzzuHSGdQghBf5uEEA7IJwM7aaRn9dpwjg2jp
         AvXvqeyOvaQBUzXbWQGoL+0sYKquZtrS+mjGcCu6a76okaWuCpiaRdYzQixH260ea6Gs
         ODjrey8FIsXcLyB+d2QEmxBtaH/yKJZnyEhMbhNbIMp+xDaSqL6xqc3qcHuBdzGWJu2m
         PQOkFhNQi+lwF1BaTGR4mNdQh62zjO5vBvf89AEH/FMGXNRPzIGrEft0G/IbR8y4Ettl
         jLyw==
X-Forwarded-Encrypted: i=1; AJvYcCWLOw38S+O/dZY0cnrrdLCPvyi5gPe+clKZ7KzAgeMjZ1nI1vTF/W4S85xFF8UWuEZSUfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJEJyCEdkQiwMRROyvtx55qMnw7c+Gcw1IVv8+4J3p558sT6Gd
	QLxNJFHVQZEZm12c0ny8HARXbPc54NtSmqij+bWSA1B5SG7P+Sm7VP1SsKkWKHSzkMo=
X-Gm-Gg: ASbGncuRhNFi1rtf/q8dpGmmvU3nm5aISdF+t/Rro7cRz74yGB3EFGrfh2fYWtT5Uen
	X1A0q1NsKaD/aXGD0/mT6mc5ItoJtJV6iYMhmxKrlxZLuHsMEpcxaSb6uwcG7z5s5q6HI75lkdV
	dTxCGKXy5/QxtULmJbDTYVJT3hgLuNvi3PO9gqkWjzS7VKBIX0zzhbrhU6IeMPvcJKTrN3WQcLx
	/P9SzrAtWE74l26sRyM8dEHfyhdVV9rabJ6dhpJy+xR4cvYrO8Y4aoiCQj0gWG+P6NtVK6k7vdT
	WAonAJelFHICPiLKZlPRjqHNKPcTRFeycrHU2LsZN1KaXT3Ojiz2ryvds7NdxnMMS4VKuUcNQIb
	ogQss8r877I77YzLfsXads/pXS9nDHXTCuQyqDI58rJ1tnOj5Fng/R8QvQOPgqQ==
X-Google-Smtp-Source: AGHT+IFZMx0P1JKNMfotkf1h9uD05/LbUJ3nHS+qqEqkenBGx5Rm/Php8OZMQlv5/iu6GkzqmdURRg==
X-Received: by 2002:a17:902:cccb:b0:23f:f065:f2be with SMTP id d9443c01a7336-244586a0e5bmr50715635ad.26.1755186965537;
        Thu, 14 Aug 2025 08:56:05 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233108e1d9sm2225500a91.29.2025.08.14.08.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 08:56:05 -0700 (PDT)
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
Subject: [PATCH 1/6] RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
Date: Thu, 14 Aug 2025 21:25:43 +0530
Message-ID: <20250814155548.457172-2-apatel@ventanamicro.com>
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

The hedeleg may be updated by ONE_REG interface before the VCPU
is run at least once hence set the initial value of hedeleg in
kvm_arch_vcpu_create() instead of kvm_riscv_vcpu_setup_config().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f001e56403f9..86025f68c374 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -133,6 +133,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	/* Mark this VCPU never ran */
 	vcpu->arch.ran_atleast_once = false;
+
+	vcpu->arch.cfg.hedeleg = KVM_HEDELEG_DEFAULT;
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 	bitmap_zero(vcpu->arch.isa, RISCV_ISA_EXT_MAX);
 
@@ -570,7 +572,6 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
 	}
 
-	cfg->hedeleg = KVM_HEDELEG_DEFAULT;
 	if (vcpu->guest_debug)
 		cfg->hedeleg &= ~BIT(EXC_BREAKPOINT);
 }
-- 
2.43.0


