Return-Path: <kvm+bounces-49374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 29396AD836D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:58:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 252F017516B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499DE25B680;
	Fri, 13 Jun 2025 06:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="f+nTcRQC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1593E25B2E2
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749797881; cv=none; b=lSqSFyo7DN/ERn/8d6r2qePEdARnuE7aHDg8/ccXvU7w9j4e+hROD508DV9OG1GDFBvwIdKbwXwzUfM7JuqSVHMPh8OQfVelMQ1aa7Rx+cZHOGJMAHEk9qrYVj/Tm2uLrEZwodm+TEHcv9KNf5pu11G3Ix9Rt2tvq1h1QqrHWaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749797881; c=relaxed/simple;
	bh=staaIYNl2k7avfOSLFZ5XPO76ZWP6t7i2gV9awbxnvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTxeZr/RFgANzeIv9DJ8o6h7EzQ8/KQgDcM4MsuziCYAFrQCVfLwvUsknTWPYoINfk8Gu4fGT9PbxpykWxsWlehn69+HQQeYDQysFTryTheJjd3nikaXTjI1AL26qvibuC4KZabDTbPe2JzTZV0QSO4fEbsAwZdZv5FuN5K1NJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=f+nTcRQC; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3139027b825so1312375a91.0
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749797879; x=1750402679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymMx2/Jj5SWc9oh0oJCNF6LPBe8+NWhSuF7K3lIaf9M=;
        b=f+nTcRQCK4s49Lx1hQmY6hhN5HSOPVDiSLxu65TgcWDTkDI3dmEH4e48FumePTyzGH
         K44McB3d2TyYLjlG2vRc6idIxVudguYpXvhsLSHmw980+honqpqeImxENi9Xmo2cj86y
         YVqBwy17bkXNTAH/mK++Ie2X6ddn6Vod1K/tXyAAUBxDSPwDkE+C0ztw4VNNUUPtwgd0
         9zCAvnebKzyC08dmW/CkuevmAGaW79AV/XbTkJkWPfb8DTJoLIrz4tD19tFrfRPq92HZ
         VfQwtOCQU4X4pDAXA3pQ0jlQtAYaPBOpqX2/VF5eeZ3zfTdBzonKmHWqnZj8qt190E6G
         YpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749797879; x=1750402679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymMx2/Jj5SWc9oh0oJCNF6LPBe8+NWhSuF7K3lIaf9M=;
        b=siJ5LRLQEfv3cqoPvTGO6iJdB5bIDWRugsDe9BUUaj/s3QFC2ImSUKxQPyDzhc8e6G
         VQ13EKNoreKVqEBeqOZyKbTu3jtFu5TB14kcDDK9Xi5IEUgVWxSMQoY+SFxU7IMGLoYX
         f3OO8dzl9VjBzw4h31IjA9Z36sBGbOYjRFS1WZyvL5IygIr3pu74DzvbDij91EPjqISa
         S48v+R/6ylgs+jdDGf3PoHBj7e9zwPA0GBuDLbAhQ3DLdMmGjgGgke0wplXvlIOSo64E
         5WcBw9vFNCTv7ihbbZj1OVCHCrz4Us1hWNCsBjRIjk4RoL/46thlMr3/DNdBBolkvVil
         BmJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZgK5Dz7Cgf4Suk4fIGIj7NP/yIw5bMl8rlI1TQwmXGDy7YTqkFI8o9HQUSWgAnxCWRzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1sf/v5gZiG2Mo4vomtlSeZFse2I5Ab6Nc4x0csTIqE81DJHpV
	XbqEJ8ZnNTdzasouOIIaMoPRqbDorWw2kNifLYZg4qmiIvDI/1BUDIdVcSCysb6H5zE=
X-Gm-Gg: ASbGncsjkcB5rZq2jQS80nom/lMQn8BwxblufW7XmGHV2zh+LLq64xFX7rl/Poj88Wv
	MVlWXsJMQYotvEl0oZZyB4wydhQg6Y7d3PRnRIWl41/Anf2c1yJo4SPPGxfrd4+Z93eqzVxOyCR
	sw8tS6wwWrB25u23TG/DMfqu/OifzSHGl3Hd0U3jlxs7CUiHohNqHDpB1N9LHf7IRtxnjuAqI7N
	4S7HuTR81F0PXaRE3/RlJdPzVpUZ48s2P7HGa0Wa4gKXdAf8ljAq4dH5gom0kvikbPdraa+J8g2
	ihOYXX1Y+FaNS3+Gsv6lNJC7zy+VGfkR5VBr00elybVYi5Cwydmqd05MCQ4eAqd/3M6YSZBrdbn
	Cm5TlS1yqBYZ2g4URo84=
X-Google-Smtp-Source: AGHT+IFbsRijVxYSu1XTO+0N6i4HTy+vctiYUi4v1qHZj513C6U95CzPutsxwPcR26VA49ZdTmRG4g==
X-Received: by 2002:a17:90b:1a88:b0:311:b0ec:135f with SMTP id 98e67ed59e1d1-313d9eeab31mr3207474a91.30.1749797879252;
        Thu, 12 Jun 2025 23:57:59 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49b7fsm2653022a91.24.2025.06.12.23.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:57:58 -0700 (PDT)
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
Subject: [PATCH v2 01/12] RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
Date: Fri, 13 Jun 2025 12:27:32 +0530
Message-ID: <20250613065743.737102-2-apatel@ventanamicro.com>
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

The kvm_riscv_vcpu_alloc_vector_context() does return an error code
upon failure so don't ignore this in kvm_arch_vcpu_create().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 303aa0a8a5a1..b467dc1f4c7f 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -148,8 +148,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	spin_lock_init(&vcpu->arch.reset_state.lock);
 
-	if (kvm_riscv_vcpu_alloc_vector_context(vcpu))
-		return -ENOMEM;
+	rc = kvm_riscv_vcpu_alloc_vector_context(vcpu);
+	if (rc)
+		return rc;
 
 	/* Setup VCPU timer */
 	kvm_riscv_vcpu_timer_init(vcpu);
-- 
2.43.0


