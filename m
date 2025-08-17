Return-Path: <kvm+bounces-54847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EFAB292FC
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 315C71B2256F
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5CF120B803;
	Sun, 17 Aug 2025 12:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Oi98nZUz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0FAEED7
	for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 12:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755434022; cv=none; b=O6raG7d7IW/bQdEF6+J7i1xwydOANqT18kvG5nj/enxS0UbOcMwF/ytsrWiIIOfuADj8yxnkn1yzKJH5GXpzR8VlffUDsB+N83PaZ1GQXQgPPMuomJOcFG0o2gv+9LKnqf6qd6+4jiwyhYur8k/TQjRGq0veL7+HWAihUshvl+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755434022; c=relaxed/simple;
	bh=ECKA1N0ozZJky6qyb2l/wy6+UK0bWtlFcU0qrSDIIRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cPfYr1QPt8WQbYbDZ8ZJOL9aKw96N+PCqfSU9LxI4oK816szEeBtiCmJuPcNEZWYtmunalr8D+6/GYPCA4vJZhpP6DmfC0TOg0HclvS5RLNgUOApty52chFo5B+exqJtJ3asUiq60J4Bfn/8XuXGfFOm1+sBFEuFVSPw1WYxXc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Oi98nZUz; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-321cf75482fso3841554a91.0
        for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 05:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755434021; x=1756038821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7WbiJIeRAyXPasTR+StFJQvgx7M5MTQOS33x2RRGox8=;
        b=Oi98nZUz3eFNu6StdJOhD12R2OhNoCrURlEhYdQkxKC5OaV6aV8jhT0lr32WEx11DA
         UQOZvYVP/UkMFehC9ZosdQN9Uw4U4V0ccpvZyL0jxJfo0Fc60By5nB3pEysZTUq2U1o0
         LUDOowDwSPNSjlqrefxDghYkSjijpxTa/xpmigKWZqTr7WnuLFn806/6eLoGveWO2bTx
         cGbda4Wl2Wa0nuA/0s/vC10J2WPluqlYxoI8Sp095mXdnzR02rWXY5SVJ2Hg7oi/FgmP
         hATlvHirGYWAtH4BFJWCOKZrFWnJrx1iVhFbPf3Vc2OiY46yCxSekMcU3nmlCKC1u3FS
         vOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755434021; x=1756038821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7WbiJIeRAyXPasTR+StFJQvgx7M5MTQOS33x2RRGox8=;
        b=a0B3g1TLeM0DJ4zOf8K53zSmnJOglzPcmmaT7oXNGwZ4W+FftGgZ/cXDVOxULZ3OK8
         mZig7bLC4mpLqdkZ9pLfKg0LNU2hj1J7CYBLQ8tRYNovtY3ia/ROO8CQ+3AEnwx3mgfZ
         65AQlckiCl6etdCUKi6H+ruCMcprQv7WBbEzjxnAwYs1Ols6dkG2uz+o94c0TG/HjreN
         xfnaIKD2gXWcojLRMm/IIKWUCnPn/geohzaKRVa9r/kFnYcq4QtwARUoYG2TdButwkaw
         mQiF2q0yX4L54n5LaaXaGLZgfQ0GLxaLxDziNN61X3XZhxNIjwVMOCxeINKnRXLsv2IR
         YqAg==
X-Forwarded-Encrypted: i=1; AJvYcCXp2iLrZAXImueeK+IoHWleayBk4VF4oBk6SEtFKsYo3nmyHV01paz5+oTXfWbCmorIXw0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCA+O3Hcx28zsip6l8XXQ6xgj6O03qdZAz41uqUBIfEOygcIVT
	Mdec36U11K53afMfIRpPHbWQ/IAFBpYv2OhFth10GDH0CgEJBXIjzAiWpik9JWDzNMs=
X-Gm-Gg: ASbGncuMpdlzXOn1aPfOUA56xLiOIHAWt3ektttHxBR2QLsVJtnMG9rSt4J78+FigA/
	hI5rVTSuAJPDLAL0IGh0DS/Zr6VN4kNe/t40afu5s000578/m4wToqARuCTelCf7UsoS6qxddjb
	fbOKPXA2mkFSXxnSB4extnWoyfAcxLfk3C7Sm1DpL/VV1iojk4LvasoomNkONR4YCDywRDc5y9u
	RKqrJ11BUIUFpKijfWu9VL9nygtiXgn7C9HCVLw1v95qk+2cY9Pzm7x3sKvssJZc+MTYIdzAEh4
	kOTmlvSh7t0Ysz+VAGrzNl9no5g4W2RO3P1p7jSwabsS+aUkHWJ5CY5zxiKj5WW6rK/azZiS9+u
	G4M97Hd5zboF86nv0jibikpClm99YFYo0vjbkMKWGFt/nRvum6Wh5jAQnUSARHVtUkg==
X-Google-Smtp-Source: AGHT+IFVbDDjII11gSvR9Q4jewkTQtbKL3ViUFZFZq0yfpKxvIKgRxHNfx519E/5M9iV986Io2UJ3g==
X-Received: by 2002:a17:90b:3c8c:b0:320:e145:26f3 with SMTP id 98e67ed59e1d1-323296f24bdmr20313460a91.8.1755434020703;
        Sun, 17 Aug 2025 05:33:40 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.202])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232b291449sm4480912a91.0.2025.08.17.05.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 05:33:40 -0700 (PDT)
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
Subject: [PATCH v2 0/6] ONE_REG interface for SBI FWFT extension
Date: Sun, 17 Aug 2025 18:03:18 +0530
Message-ID: <20250817123324.239423-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds ONE_REG interface for SBI FWFT extension implemented
by KVM RISC-V. This was missed out in accepted SBI FWFT patches for
KVM RISC-V.

These patches can also be found in the riscv_kvm_fwft_one_reg_v2 branch
at: https://github.com/avpatel/linux.git

Changes since v1:
 - Dropped have_state in PATCH4 as suggested by Drew
 - Added Drew's Reviewed-by in appropriate patches

Anup Patel (6):
  RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
  RISC-V: KVM: Introduce feature specific reset for SBI FWFT
  RISC-V: KVM: Introduce optional ONE_REG callbacks for SBI extensions
  RISC-V: KVM: Move copy_sbi_ext_reg_indices() to SBI implementation
  RISC-V: KVM: Implement ONE_REG interface for SBI FWFT state
  KVM: riscv: selftests: Add SBI FWFT to get-reg-list test

 arch/riscv/include/asm/kvm_vcpu_sbi.h         |  22 +-
 arch/riscv/include/uapi/asm/kvm.h             |  14 ++
 arch/riscv/kvm/vcpu.c                         |   3 +-
 arch/riscv/kvm/vcpu_onereg.c                  |  60 +-----
 arch/riscv/kvm/vcpu_sbi.c                     | 172 ++++++++++++---
 arch/riscv/kvm/vcpu_sbi_fwft.c                | 198 ++++++++++++++++--
 arch/riscv/kvm/vcpu_sbi_sta.c                 |  63 ++++--
 .../selftests/kvm/riscv/get-reg-list.c        |  28 +++
 8 files changed, 433 insertions(+), 127 deletions(-)

-- 
2.43.0


