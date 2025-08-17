Return-Path: <kvm+bounces-54848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5866AB292FF
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:34:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C2CB4E2DC5
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A52FB244688;
	Sun, 17 Aug 2025 12:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GWnzBVip"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B272405F5
	for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 12:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755434027; cv=none; b=HjqNbVKokfllUxRjnruNtfT10H93ykCOCkPl3Toe6m+4eiVcy+xnwcgi0qS3i9BccOSp0DYJSBMWEzRNN3zZg/MeIP2j3f+LxFA6V+VM1NjsC3SrdJeMlZmrEPH46Vrf9phrGzFvEPm29wUdo8y/lIrYCmBUpC1MexgreJy3DPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755434027; c=relaxed/simple;
	bh=BGEWapcJO5F2Bt9H9CNcjKlUy6pXszyUchO3+rDe18U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6vSpPr0ZoUn7Yz5gUou/xJRZnhJzT8jtJtxFMYUQHDasF97O4154sq7cuizsADWKjGsoPgcwP+dU12PSWtAmb9UzN+QUnScHPsXxQEU7MEwpC9doIGjVcYySNY1mjfUugzW/KNJlTnOHpImHXY0Zh/80aQRCMn7IoYy0UaWaas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GWnzBVip; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-323267bc2eeso2314316a91.1
        for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 05:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755434026; x=1756038826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdtyVjgEpxnmEVvN9KL7OGdIrEXqBJ3Mt9H1T0gTjFI=;
        b=GWnzBVips+KwEYwZ+kznUnRVo0g7347isNIKytAm2M6Cgcm5wr0w1PnO0mNfoq03ny
         6JdvQA6NOVPXhug+CrZNmGUHAp+I0Kc1CWJRy7FohMr09vlzegal+nFaipNwptaO4A57
         1xbohDlLW/k1BL4s7y1R50gdMycw8yuGb1gofRr0ec7uDdT85i9oTqlTBapiMpIuL2Px
         aBXmZQS6vP1LR1jU/Qydtvw+fBDvpm2O+bDgPkr/PkLWOHFq49IZ9ciW/WgUgJOt7DxE
         RtpmIqGech9XoIF8A+yLLEDBga1WDhFDzvQIG02F/hZYt1wSe57F0rzweDbOMR+iXE0U
         lU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755434026; x=1756038826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdtyVjgEpxnmEVvN9KL7OGdIrEXqBJ3Mt9H1T0gTjFI=;
        b=XLCDp9UiaugtB2tz9ht/1x0lMbfhsHP1EYNQCwzSXFE1lBNyDE8rtJRk+Q29Qquqt3
         1licpmzVez1msarKgGtaGM659rVb1XTVVX0txZmKtoQLrT+W7l+jc47pYrIwbbj8vXBg
         Q5fqb0zy3d4m/WZ/rEppp9BPneSUqjcTWN0XnwTxgbxX7V6g5l+yvla1NagF0fAprg4o
         5St32ZUtbQIgIN/eHaUclNH/M6e3/CSsrMhzfLuPK7GI3Z+73CmQbeo0OKM4RQImODfy
         I/HnQbLUdSKkXyfm2XJHrH6rhkf8AkdgDlkGx93mrdh2jXRwkcvQLhx8NEvRFVttb5YH
         X1EA==
X-Forwarded-Encrypted: i=1; AJvYcCV1vGGzghPt1rmiCKw1qXss9yRsSa3LnyxOB3oSHf5hZUVYuUMSEECBjcu+ZS2oEXfukbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX95O9onNV2dP8Tg9qh76dRPWoifrsildmsjRf9tNnBoNHhKkL
	dqJdVn1zbnnX4Ryq7nF4nhRO1SLuC1MEtyFDOkZepyEZJ5V2Ks+MVylf9sQwUgg4ehgaIXbViZH
	2IUQg
X-Gm-Gg: ASbGncvaToAqrABmlLbBwWR3MHOhcM8VOo0r0BcMNWNNQrvlAt+WEA/avUxNa54aHpw
	GsLQ4uquW0g3EDGMPf3zMybDR05wdYngmKxa/lsf9yqkz2iAY1hi7Qi/e3iTPlquTjRbZOMLnk6
	PHkgAz8M/oNyGP1T14UftfuXQ35eD73GAPHoUdRw5O0MhXJblVWPC2k4bxZeLXMkaWO2WDviTmb
	Uzpcl5BVX1a4qD77vkuj1N9XUaEPOdaYRRjqpxK0vINzR5vfQ9KUt8U0prTXx8WNCdKinjycAJU
	b6JKGgpJlwVSldzDhgPYX743V3UESK+NSJAtlr+pRvl5AySDKIlMiMJZsIOFVbe8l9TKxshpyMO
	BXQ217i2BopuPr8MLlnomRic65Dfj7dOul1CQH/jlm6WxAlT8egcSmQU=
X-Google-Smtp-Source: AGHT+IEDEZ+sKN9pizGMbZuUmdosnGUt8+j6ILexLeYj3eWsbGW9HTYMbtimVNOhIKuNFlbVtoY1Dw==
X-Received: by 2002:a17:90b:2d43:b0:31e:c62b:477b with SMTP id 98e67ed59e1d1-32341ec4ed7mr12210812a91.11.1755434025641;
        Sun, 17 Aug 2025 05:33:45 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.202])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232b291449sm4480912a91.0.2025.08.17.05.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 05:33:45 -0700 (PDT)
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
Subject: [PATCH v2 1/6] RISC-V: KVM: Set initial value of hedeleg in kvm_arch_vcpu_create()
Date: Sun, 17 Aug 2025 18:03:19 +0530
Message-ID: <20250817123324.239423-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250817123324.239423-1-apatel@ventanamicro.com>
References: <20250817123324.239423-1-apatel@ventanamicro.com>
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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


