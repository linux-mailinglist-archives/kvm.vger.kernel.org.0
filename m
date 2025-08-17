Return-Path: <kvm+bounces-54849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E68B29302
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 14:34:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D044207504
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 12:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C05247280;
	Sun, 17 Aug 2025 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="M4MCmvi1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6F51E51FE
	for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 12:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755434033; cv=none; b=kZNVvM8J7OYe58ajHoMC5qFVNT1c/TT8GaU9TFHdcb8tFaj2SGLUyRbCmcijc8LaT9wPal/LuubgB4djgdn6gS1WIejwyqGlqauZeLBWW+1xuRgiJTQsQwfnnDLDHo/HKbUWm+OTy9zoBgQngP2+fPYJE5Q2jH6nIyiooXKyV1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755434033; c=relaxed/simple;
	bh=5HKxK+Boc/7ZdYflehjWFkppD0SyD2LOi7Sgi2n9lB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfCbm956gp1Ar3RrAHl2f2htVKSKaKy3nc7403kbQyPxZFVtfeDqeCU7yLlhgHBw4305v5tnI9q2CKVCqxZaP+ic/2CKtAkXokxUikAtAVxak+TSxN7OyA8gfIzQp/nhtrFVxPVXXydZwEBtwdI3GYc0S/NJkEn4ZboEyPk0H5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=M4MCmvi1; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-323266d2d9eso2455819a91.0
        for <kvm@vger.kernel.org>; Sun, 17 Aug 2025 05:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755434031; x=1756038831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Chrrw+dyIJSlBaNuFfzfLJBXunJM56lFjN13/1zM0cU=;
        b=M4MCmvi1nRUGO4AFRDArDaj2DmaTqlS4hp9RmR7dZRaCHJYi+EHO0F2W9ZJKPMl8PO
         buyIsKEq/Tk7wyT9kjIfnHCHpprVSdj5mO+VRDaklOBgZxJ8TF4ukH4bGDOTQS6BxgiO
         DGOAy9rHTpkcS+gFhU1zpvCDErLTqw3s0ea9cn9YqH64vOQS2yVMVU9xAOFwu4QIw1xj
         ij5K5qoqHjoEIo/o0jCL0ZtfrWa+tL/LNalwKd0QfpfyUMtklQfmDGnOrGpDpNTwCg7D
         H8dyjuFeS4xbmrbnlPV3ADTIzAOPdGU7uHTUc/gh6KgcjszpTuc3WRN1qLIWd4Cdvnhb
         0VPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755434031; x=1756038831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Chrrw+dyIJSlBaNuFfzfLJBXunJM56lFjN13/1zM0cU=;
        b=NBY7KPBs6vtswBuYxtBmVU6lWzCpXrhI8A0rzREobMac2Qko1iiqiboLz4YfHXkGMv
         Ar1hObUz2FHtJFU2SKD28WKZ+ukV0N/s/nUpgbSjcuPf0liJ5z708adGEHJCwlJOcck4
         MZF7yqbyzwkPQEuaeK2i9BiHL6sFQ48wl/wLyjAkgJPb85B/asiL+4yB+5Qh3oGN/2ZQ
         8/uxWSEBIzyB/bGDGFAleareLdfKSp89qCPmyFlM+RH/NU/dTq6cT2tmYRsn0vxQ8kgg
         Ga7QDj6ZXfDvUWCj6aC65cpirWu5QqzsLiDeXeb/yoprpGwF7n/YqtY5/nuHJKPWQzcH
         GmEw==
X-Forwarded-Encrypted: i=1; AJvYcCUHp0FJiL4BpoKaSfWJlJ1EqUkGwTG/IByxvhmOjhNAQqZ4jjCxlhmNcRXdgPpO381NJEY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEume4SuM09yDYmCNo7bo5ByOdGRw7q7BpRyu4OgZcqMvJmVkR
	wHaDag1uUxfnV3T4UOi7RStkqcuROmdGZFDbUVpnu049uQQ/Rh0kRfo3NNyOUD7F1Vw=
X-Gm-Gg: ASbGncty2LqDyKrd9szY9+Fhk5Jnhqt0crLU4nyo6zi9lHyHYumZBD6FKWNUx9/9Jl5
	NNpZ2j2DJfDfUfEaFIxjLqgsi8o9MDjVt8AH/znlVAlXLH/UdMG6pM8UNl4G458MdwPgxrZW5RQ
	4xRISdH+Q2hUwZTXI7Ctli1fRTbE8OqUWRFuJ7qa9o0EoZAPO4JPg2j1wuiDYNpnXIeVBCUqK9Y
	F3Wgb3EMikOwdrZl+LSl+eMGNJ4J6j2pg7D2AkZWxV0zoADuhsTao2pls0B8Ea3kNgjSDipuccX
	dSTIleLQshhGTxlq1LryZdKNL2EuZBG3SozmEUDTycXcbB1HDlzTDlBQbY7qAeFgT0fDMkGPipd
	OwI0Zkhst/EaongOlh9QvSf7nFKTUtZjUCn8hu+RUfaiSI6t05I0dwNE=
X-Google-Smtp-Source: AGHT+IETV30d+U1cTWNm+PcAX8EyUCyQ87TNGD5UPWd2IWqoSPinHs4gpy114d5b7XZmASQs/fhxjw==
X-Received: by 2002:a17:90b:1f8f:b0:312:959:dc4f with SMTP id 98e67ed59e1d1-3234db7148cmr7188813a91.5.1755434030859;
        Sun, 17 Aug 2025 05:33:50 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.202])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3232b291449sm4480912a91.0.2025.08.17.05.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 05:33:50 -0700 (PDT)
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
Subject: [PATCH v2 2/6] RISC-V: KVM: Introduce feature specific reset for SBI FWFT
Date: Sun, 17 Aug 2025 18:03:20 +0530
Message-ID: <20250817123324.239423-3-apatel@ventanamicro.com>
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

The SBI FWFT feature values must be reset upon VCPU reset so
introduce feature specific reset callback for this purpose.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_fwft.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
index 164a01288b0a..5a3bad0f9330 100644
--- a/arch/riscv/kvm/vcpu_sbi_fwft.c
+++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
@@ -30,6 +30,13 @@ struct kvm_sbi_fwft_feature {
 	 */
 	bool (*supported)(struct kvm_vcpu *vcpu);
 
+	/**
+	 * @reset: Reset the feature value irrespective whether feature is supported or not
+	 *
+	 * This callback is mandatory
+	 */
+	void (*reset)(struct kvm_vcpu *vcpu);
+
 	/**
 	 * @set: Set the feature value
 	 *
@@ -75,6 +82,13 @@ static bool kvm_sbi_fwft_misaligned_delegation_supported(struct kvm_vcpu *vcpu)
 	return misaligned_traps_can_delegate();
 }
 
+static void kvm_sbi_fwft_reset_misaligned_delegation(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_config *cfg = &vcpu->arch.cfg;
+
+	cfg->hedeleg &= ~MIS_DELEG;
+}
+
 static long kvm_sbi_fwft_set_misaligned_delegation(struct kvm_vcpu *vcpu,
 					struct kvm_sbi_fwft_config *conf,
 					unsigned long value)
@@ -124,6 +138,11 @@ static bool kvm_sbi_fwft_pointer_masking_pmlen_supported(struct kvm_vcpu *vcpu)
 	return fwft->have_vs_pmlen_7 || fwft->have_vs_pmlen_16;
 }
 
+static void kvm_sbi_fwft_reset_pointer_masking_pmlen(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.cfg.henvcfg &= ~ENVCFG_PMM;
+}
+
 static long kvm_sbi_fwft_set_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
 						   struct kvm_sbi_fwft_config *conf,
 						   unsigned long value)
@@ -180,6 +199,7 @@ static const struct kvm_sbi_fwft_feature features[] = {
 	{
 		.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
 		.supported = kvm_sbi_fwft_misaligned_delegation_supported,
+		.reset = kvm_sbi_fwft_reset_misaligned_delegation,
 		.set = kvm_sbi_fwft_set_misaligned_delegation,
 		.get = kvm_sbi_fwft_get_misaligned_delegation,
 	},
@@ -187,6 +207,7 @@ static const struct kvm_sbi_fwft_feature features[] = {
 	{
 		.id = SBI_FWFT_POINTER_MASKING_PMLEN,
 		.supported = kvm_sbi_fwft_pointer_masking_pmlen_supported,
+		.reset = kvm_sbi_fwft_reset_pointer_masking_pmlen,
 		.set = kvm_sbi_fwft_set_pointer_masking_pmlen,
 		.get = kvm_sbi_fwft_get_pointer_masking_pmlen,
 	},
@@ -321,11 +342,16 @@ static void kvm_sbi_ext_fwft_deinit(struct kvm_vcpu *vcpu)
 
 static void kvm_sbi_ext_fwft_reset(struct kvm_vcpu *vcpu)
 {
-	int i;
 	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
+	const struct kvm_sbi_fwft_feature *feature;
+	int i;
 
-	for (i = 0; i < ARRAY_SIZE(features); i++)
+	for (i = 0; i < ARRAY_SIZE(features); i++) {
 		fwft->configs[i].flags = 0;
+		feature = &features[i];
+		if (feature->reset)
+			feature->reset(vcpu);
+	}
 }
 
 const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_fwft = {
-- 
2.43.0


