Return-Path: <kvm+bounces-46424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BF1AB6364
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED28A189BA94
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32460204C2E;
	Wed, 14 May 2025 06:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="kA9EM3jb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450DF202C21
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747205021; cv=none; b=smo0JtZXwgOlnoUZKbJfOMFH21S5aRTvw8+xNE40as/lTfMyE+GBuQkNvxjkNI9za1t2OtWNs2Oy8kD3XSwrut3FOHOGFQ8TeGeIzqz9pE6TsDTi+TXB+mgPKeORerLXtMw03YwjoKboxrFwDaPrdJE6XxT3sT+Caynho0Uz3bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747205021; c=relaxed/simple;
	bh=7RSHYTYY1vXkWnRHaetO5zTLkSzSS1sFy2vz/tAGQDo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Br4hq38Wqs5/jdJQvLqblsQ/MuNkHGn/JaHmeW4fKXc0oWxdl84SG4wul9JSwt6MnWQkMp+F89mNb+KpDXMBTUm0HVcOlge6EK4Wlt4W0ydzeK+S88wf6Pz5z4x8FoY7DXg/IBpiH4CEX197zyLO5UQT3cRHzJHpMgYWxzPp9U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=kA9EM3jb; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22d95f0dda4so74727765ad.2
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 23:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747205018; x=1747809818; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yONrDaNM2oGU1RPbJmb0bt05qkmK93VY4fZWYkh3HDI=;
        b=kA9EM3jbsIfV9gfsm2NyI6o3PZdeGuiEKgZTLjpZNMnMUbCfLrPUZbu3MBIaCO11kn
         AE1Wy3ArQD/MTSVJYZlqhpc4DMsATfMUfK5SUV/foN2egitGMihrw9S1d9xdn1ABpfvz
         fD8ZUtD0PopLm2nBTprOEJg+Fs31fNr6jI0mDWPeDNZaPnfM5PBwSTl6X8ZSS+MQy2l2
         WPV/00y6m0h4Q41OWF/VP0x0Qh2Tz3/bLs1RpbX1F+wv+iZnfG0XcLbCG7L2kyblW5kz
         pYSptE0CWUgBRhjRRLrSNF3G1ItkAvxcNMjR5iwOQ98bg0YYeCkdkZvJIWAjsAQUgJ4F
         hD4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747205018; x=1747809818;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yONrDaNM2oGU1RPbJmb0bt05qkmK93VY4fZWYkh3HDI=;
        b=ezBMK+nGudSqc5zEpAhUXbwDQWgY5IDEYpe15mlg3Syx7+xXAno6PkWREk6U1YlcKS
         fJq5/QgQ1raBF6rJEMSm7trBDjHvsABIzhKNlMdlcM4l3lU82SNnFRjctEWIUhUPMkBm
         yGpUvhmdOi5vo0o1J4QIzxO27o2NtHpj+uMKoUQWRJaUlvkM398BaJ9KynhFs+/75Hrq
         5t0XpAKV9UXDrPEfyg7BXc2SoNY0lbZwp2fQXzIB+jWQebvj80g9gryQ4pkSQ2DBDOR6
         PQYecntAp5zAiPYom0Cy+v2UHAnl6qzevg6HnUnhn4xnsVDBKJn1R/s45miK3wDL2VzL
         EQZQ==
X-Gm-Message-State: AOJu0Yz5F19IJvVARarSl15IrWVfNOus6wiBJ8mnNp8wtdnMV7ddjeAo
	OwBUN5jcqPzT3byfuaJe8x+TBcjTK4u1agHV+cmvlbvocBGGA5eBxHG7LsLfyd4=
X-Gm-Gg: ASbGncupH3VSW6rxeAWzmonbWAVvIC4ETfLEOrCALh34cfczawIGAUtmsvbWCBqWN5n
	bqRHCJDgXDxKv5pJGMiIZyIeBhd+/8jbWRiSz8jqQBnJ5iPsGbE/wxBk/+EhZKxNBQZFvil8ua9
	EbfL6BuLrBlR/GRMNko9oTean0YPMie/9V5669lXsYjOv4V2UtC7jxPGbmmgCx6gfwG7tDz5Zps
	RUXYzXmcOwPshiLsTKc84IJ+Hlwb/AVEUzTijTq4PCXp3AwkGQwvevFr45CATsIbYZ+88N8rBd3
	Yz58McZm4R29ffV6uZUeVPWWOsln1u+6X3+y/f52by6Mttr0K8xWZczVlCVDQFVc
X-Google-Smtp-Source: AGHT+IEoClrF6lVQwqc84P3HpmaPMlZK//yuTk+XbXPKwiAjohsYztxOGGMEpufYrZ8rdGMMsjvwEA==
X-Received: by 2002:a17:903:2f85:b0:223:5ca8:5ecb with SMTP id d9443c01a7336-23198143b9bmr30190855ad.42.1747205018359;
        Tue, 13 May 2025 23:43:38 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc7544e49sm91978485ad.51.2025.05.13.23.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 23:43:37 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 13 May 2025 23:43:30 -0700
Subject: [PATCH] RISC-V: KVM: Disable instret/cycle for VU mode by default
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com>
X-B4-Tracking: v=1; b=H4sIAJE7JGgC/x2MQQqAIBAAvxJ7TijDjL4SIaVr7cXCLQmkvycdB
 2YmA2MkZBirDBETMR2hQFtXYPclbCjIFQbZSNWothOeHsP2uMOFEYNJLLxzQy+VsnrVULozYpH
 +5zS/7wdhSXygYwAAAA==
X-Change-ID: 20250513-fix_scounteren_vs-fdd86255c7b7
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

The KVM virtualizes PMU in RISC-V and disables all counter access except
TM bit by default vi hstateen CSR. There is no benefit in enabling CY/TM
bits in scounteren for the guest user space as it can't be run without
hcounteren anyways.

Allow only TM bit which matches the hcounteren default setting.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 60d684c76c58..873593bfe610 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -146,8 +146,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
 		return -ENOMEM;
 
-	/* By default, make CY, TM, and IR counters accessible in VU mode */
-	reset_csr->scounteren = 0x7;
+	/* By default, only TM should be accessible in VU mode */
+	reset_csr->scounteren = 0x2;
 
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);

---
base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
change-id: 20250513-fix_scounteren_vs-fdd86255c7b7
--
Regards,
Atish patra


