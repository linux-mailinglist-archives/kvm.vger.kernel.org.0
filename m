Return-Path: <kvm+bounces-24355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD92954265
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54123B27ADC
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 07:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D1F12F588;
	Fri, 16 Aug 2024 07:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="3fUmAGb9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541CA85283
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 07:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723792127; cv=none; b=Y2v3sVimN1aZH8JLsjlgE1BaaHpQBsDMhkFeOze4m6SQzJxMsJvNXyJNumo2ueWXAa3iajIeQV9pKQ7nLZsz/K6WztAlR74dFq52xOaD+4QtquQlls5339241m1F1iVwZpESJszWc97zS9bspe4e85uOGXH4RipZLPZ5U3QMUA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723792127; c=relaxed/simple;
	bh=CZ69ixTJ13HXS+S3ulrEg8gSIWyr0fCR/AmVgmn5v7Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C833fkfDUu8NQ2+EvhwbhFZG1MpgfTUqIMcLdjSwjhmLbFmL7XMMhYla9CmmcU0AlhMuOPirS1e9/xycASRXMfg6tLCiMqMf3moz37m+ErmwBQHq59K2wCmQEaLhgdgyo/dXY74xTTY6oh0IG1WVHFvkcei0jfZjtxIcpyi7GTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=3fUmAGb9; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-70d316f0060so1975951b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 00:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1723792125; x=1724396925; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pw60AMQmDUGOq7sBB5Z5rKu5bDKRw5A77nRIXJhY5Ak=;
        b=3fUmAGb94wUm7RJckuykwdufiwHQK90BN9qEXO1t2LZt/56F/r++zN7K1CvbC4mOUO
         yIksmgzh2frMgoGX97VXS7Kb9rstHOZjWkp0rnxHS8s1fv8isnDAoj46GhfbionvJVlD
         3NbxVt8yWVvfnqRcNbCmxjxmEMVpzC6PoBYHe97P7MEj7eMntjVRnLaLSI81zJfrLgNM
         c5ewS60AlkglnAmEug5DiWYvpZ70OBx3vb6GnUYlCLd+Kvw4fPtIambPNxoUzLZ3ZgIv
         ZFsjUa2k1DV7nol4DSq83i9LhpWLQWFy5CJ73haZJ5sdcQ9YuJuLIXPTANVpoQ+X3ZIq
         I5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723792125; x=1724396925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pw60AMQmDUGOq7sBB5Z5rKu5bDKRw5A77nRIXJhY5Ak=;
        b=rKQxk6grO1XB27C6nK/S763/R62W84p6veon+skVANl0MxK1ID3hc3BG4li9kLDtyt
         3Mrsjsc+fi8naooDmEW59qJ3L4IMVVKW5mFIjmQX2Tzqa5C0E9GRcKOZRYb2ScfNc79+
         7HVbOcmssVwNDBplhf8YPSDkv6dVnJnE3A9/y3zSwegAEAQxL8TC3wNvmnPgHmF3PyT9
         6W+q35etyMnXa2p69NeU8Lqz2dSQXOOHRj2hMylboOOK3GSHR87/re/jH1CE0fGFhEYZ
         uHdQTAjLVWnFcAtpUObMqTOSHOhr3/aASfL+GFuJvgjVv8QLfMRNRuB2YgRId9f0vqAq
         WZBw==
X-Gm-Message-State: AOJu0YyAHFAdrvghLIxqN2vSCBuqdDYnE/E7NobMDvUwjAEp5WDBROaj
	WY5Dd6wsnGfR0uvB8uadnmGefCTW2fgYZPhWo660tDEpHYByYdMPU8X1nnkzfiY=
X-Google-Smtp-Source: AGHT+IGfPiFtzcHt7xqywSUtWik5isvNee8OUxNOoMhtzMTbtl8SwHVtQ2tadLTbV6ViRAikB2BvDQ==
X-Received: by 2002:a05:6a20:244b:b0:1c8:aa88:f10a with SMTP id adf61e73a8af0-1c8f85f45e0mr7807946637.10.1723792125575;
        Fri, 16 Aug 2024 00:08:45 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b636bcabsm2293792a12.90.2024.08.16.00.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:08:45 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Fri, 16 Aug 2024 00:08:09 -0700
Subject: [PATCH 2/2] RISC-V: KVM: Fix to allow hpmcounter31 from the guest
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240816-kvm_pmu_fixes-v1-2-cdfce386dd93@rivosinc.com>
References: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
In-Reply-To: <20240816-kvm_pmu_fixes-v1-0-cdfce386dd93@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

The csr_fun defines a count parameter which defines the total number
CSRs emulated in KVM starting from the base. This value should be
equal to total number of counters possible for trap/emulation (32).

Fixes: a9ac6c37521f ("RISC-V: KVM: Implement trap & emulate for hpmcounters")

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_pmu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
index c309daa2d75a..1d85b6617508 100644
--- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
+++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
@@ -65,11 +65,11 @@ struct kvm_pmu {
 
 #if defined(CONFIG_32BIT)
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
-{.base = CSR_CYCLEH,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm }, \
-{.base = CSR_CYCLE,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm },
+{.base = CSR_CYCLEH,	.count = 32,	.func = kvm_riscv_vcpu_pmu_read_hpm }, \
+{.base = CSR_CYCLE,	.count = 32,	.func = kvm_riscv_vcpu_pmu_read_hpm },
 #else
 #define KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS \
-{.base = CSR_CYCLE,	.count = 31,	.func = kvm_riscv_vcpu_pmu_read_hpm },
+{.base = CSR_CYCLE,	.count = 32,	.func = kvm_riscv_vcpu_pmu_read_hpm },
 #endif
 
 int kvm_riscv_vcpu_pmu_incr_fw(struct kvm_vcpu *vcpu, unsigned long fid);

-- 
2.34.1


