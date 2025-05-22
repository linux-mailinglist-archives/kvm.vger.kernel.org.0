Return-Path: <kvm+bounces-47413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 975D6AC1596
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFE02189E926
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7392A24111D;
	Thu, 22 May 2025 20:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="EmodXX6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320ED23D29A
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946144; cv=none; b=PGFd/QfJ1C5Ztejecl+p9GquPYv9s4HdTzmhJZV5uj1FaOdCFFQb60A67LehYJ7cECJ2M1p3e63Vuhe+O8IDTa1tpi3LjqU/6aBDP9VRBDD7KB3GcSayc42DEZcX4O2WHR5zEO3mkzC0rXM5KJRcJMb/eYAOgtbVHjChp83hgAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946144; c=relaxed/simple;
	bh=Kfu3qjguXcD15PsXrkFssgDsTb4P7cLTlIpPbs5OhkA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QGI6Pn+lQPwyb5PivL9pHWm+N1K+9+UxW9cWGk1ryN/07DCIWDDRPWDNarg/iET2qaE8dw7i8+AbdeO2Q3bgCLcFzQm1FEqRDCrnSK6IVLQKwHOUKZDu6AmXYN8YzMPk2yem+G6MAE4Sk1DjfSrsteNzUWoIFJYwO1EGx12O24E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=EmodXX6G; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-30e93626065so5755427a91.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747946141; x=1748550941; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VtEdIrem9+Yu9wt2wQL5f6sWXSENwBasckRwFklDCAs=;
        b=EmodXX6GOsjziBt63toFQYDVo+ze5Gs8xvGtwStneRItik17ii+Zm+0u5XfDznzJDl
         4T+gDJKRf4zacs1SJ0wsLl4qNYcUfgSMmeR2WRUTo2QJxnK+RS89gchZBPMiR2wf3Gxa
         X5IgK/BwKzm+A9zjs4TwQWbwc/yJviG8j9RWStmPADYyl/fjiEcklZgcs0qBgf5kebEK
         0QfuUc/H/gbtkSyRGAKkt344UGqxY4ek24fkcLOIIOleMk4uy90q+749kqz/W0BDaxlu
         MErYTa6WYFCwvLzs3quUtARKP73ntj/Dy75VHh5Hpx4/KJMVqOUzXjjMH0NhyoXX3kd8
         ACtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747946141; x=1748550941;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VtEdIrem9+Yu9wt2wQL5f6sWXSENwBasckRwFklDCAs=;
        b=l1wlVFKDWg5Otskcw60A+6XBluBqfUG8b9XSQKm38QhSvMy3lT70IDocwt2oCtr1jO
         9A4NEdzv+xdIq6cNzdOM8Efl5rW1xmVWx5eB3U2LGCYqbqGgOAX3MLYTYKc9RQm/lYrn
         6WZwNJ844BzoJygj5dwRxczd8C8hHfKOOiDY5gqpdQkn4ZWSOaUzo6swhgB1QW3k8l+t
         rLJlajnTLPuA1UlCPIpXsoZGO6ZDA0gsu73IRP96UmkN2Y8vI0MTwzl3P3+ElRtL3umE
         kHmsvi6FArSVuT0DHVfUtyqjbLynl9TFq57Ds1TCyeI9YdxtUx3wLDfxD6eei78GpwKf
         Vcdg==
X-Gm-Message-State: AOJu0YyMNprTASHvFIkaPZknE6QecucgMbbfHUjeC241BNGQrsKs7q2U
	1ez9oQJMUisZroSvR2Jxe+MGBYfu9g3eWsCAKoH/T95chrmqqoRX85JNXQCOmCnlFl0=
X-Gm-Gg: ASbGncuJTEwk7sor5U0w57VC2Qi5a9EexHugHZ7W33qTRNpT8SsEys55H6+vytSkQXP
	vHcxbyORXHmhkyrBXF5mHdtRg4Xx2jrvSQ9qE2w4SBcoh9JGKhL0BrsBZH54862HyGTu0SPfNf4
	Od9bgk1rlQrSFY9hQM4J41R5iuIr/xeS8efygI25Yvdz3Zl+v9L6Ha9vKDdDu1BwISqzt7QeWcv
	iFkFOmAnCvnhScy9hCwkYOQe3/2Hhh0p0C5arPyd2wQkc4D53EYAAub+EgbHYF4Q8BzWERplKhn
	WMgK/7YLAJjzXEK98R61BIsGve21r6O9QeC8jCUlvG7I3TllrHElATFd9T8iFnt+
X-Google-Smtp-Source: AGHT+IGqDOgucStiU9mIVygqIjkW9gQFkzXHNqcolrSvYh0x1SWTXJ0keMr/XGvbvYLot1jB1dLQqg==
X-Received: by 2002:a17:90b:3dc7:b0:310:8d73:d9d9 with SMTP id 98e67ed59e1d1-3108d73da51mr15859023a91.18.1747946141494;
        Thu, 22 May 2025 13:35:41 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b229csm5932754a91.10.2025.05.22.13.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:35:41 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 13:35:29 -0700
Subject: [PATCH v2 5/5] RISC-V: KVM: Remove the boot time enabling of
 hstateen bits
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-kvm_lazy_enable_stateen-v2-5-b7a84991f1c4@rivosinc.com>
References: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
In-Reply-To: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

All the existing hstateen bits can be enabled at runtime upon
first access now. Remove the default enabling at bootime now.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 02635bac91f1..aa8f7f67646a 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -562,16 +562,6 @@ static void kvm_riscv_vcpu_setup_config(struct kvm_vcpu *vcpu)
 	    !riscv_isa_extension_available(isa, SVADE))
 		cfg->henvcfg |= ENVCFG_ADUE;
 
-	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN)) {
-		cfg->hstateen0 |= SMSTATEEN0_HSENVCFG;
-		if (riscv_isa_extension_available(isa, SSAIA))
-			cfg->hstateen0 |= SMSTATEEN0_AIA_IMSIC |
-					  SMSTATEEN0_AIA |
-					  SMSTATEEN0_AIA_ISEL;
-		if (riscv_isa_extension_available(isa, SMSTATEEN))
-			cfg->hstateen0 |= SMSTATEEN0_SSTATEEN0;
-	}
-
 	cfg->hedeleg = KVM_HEDELEG_DEFAULT;
 	if (vcpu->guest_debug)
 		cfg->hedeleg &= ~BIT(EXC_BREAKPOINT);

-- 
2.43.0


