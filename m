Return-Path: <kvm+bounces-34607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AC2A02C11
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78C181885C46
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 15:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87FA51DD9AD;
	Mon,  6 Jan 2025 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="15pRzSOo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B48C14900B
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178570; cv=none; b=NpptGoDDRHlOFI8ttVXq2jM4J1Y5lZfftk6yephCeh3bLZnAZOe+cOq2xgvAdRYbNPd+3pIM0OY4tDNClAVxYo3dCU4huoFMPyXaEr1DUMeVVUDXKI6Ofrk1LtHDYgo+mKHWn1JgfJ/A9GnpUunLqX+GNGMAZrmjAY8uBBFim3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178570; c=relaxed/simple;
	bh=uuAHTstZa1Zpk6rx2ds/OHmd2ADhPuNSZeEnxaM5EGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OIzkEwHlW0bpaKmNEx35GsBPzuvHFwcG7QF792MFwl7Mz3mFilWHlVMd/PDppaRGHy3fP2cFA+zApsykVgSoZdLKJh+IPaHNE8bXnovz58M0Y7/LtKo+fwXWEW2R9O6kQQnjSs/XbDn6tFOigpIWlxXk9VwfBPWo4CD1+zJqJN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=15pRzSOo; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21636268e43so26715445ad.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 07:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736178566; x=1736783366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxBjx4Pwy3s9wNFrCu0QzGcTxzWHmeeGktVNtPbGFVU=;
        b=15pRzSOocDahB4E5LOkq53HyqOWAhjQVm/Hbhxl0GMhX9BQeclZOyK62doxPzduZey
         ET4TxGQXL6NhavzSqSQvs8ptSlt8llCu3qaV8Gku+HKrBU5AS5fdXjcEXtf1XTIitfNV
         LpRLTSQ3J3wT1SGxVzBFeHrqbXH8TnWZg91ldeiJuYW7RI4GUyFTTRqDAaa16lOu7mx4
         Br6D75cA5CK/95wB2XkE937AVnVx1X+FTsFIIyz7YTwN5sd5W63xZ2ll/pJemx/1Xs7P
         ApzpEkSQqxm75r/vSQj1ra6Cxm9iiicS4ANy8lIWx3tzpw0PtpyvoJyOG5zHlVBglI2S
         /QoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736178566; x=1736783366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mxBjx4Pwy3s9wNFrCu0QzGcTxzWHmeeGktVNtPbGFVU=;
        b=K5rdTEATGpm/W/Ljg0XjZzA86V6coaDjaNslAkit0I9Sa/hwubQpW9wTXCiBpuZdZF
         5IJ+99/gqLSoeU2qQ98XixoBe0nNHFrYtbPQJk3obJcM4kWoxpYt39sXpE7Z9a1dqqpH
         pf4E2A/OxX4gtl42WfddSZmGf2hxrBJBDqm+G1HxTy0aL+zLVvcrQSA9vQTIz2zsO/0K
         xttBvIPJBSxPbax5Fu8KJ71yH4zQdfwv1GYSj2Iwfbg1gW6wBiJJNSzc5FwznZwt1VNK
         83cah6i9mbJuvTI3z1a5tQxHntcL8OpfBrWt2m6VcGx7ig9S+OzTDPiV8E05jZIvanB0
         MshQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfioczGQ/Ww6ToNsX5DoDEqPYasbI+deZ7febORyg3tyHANngV+sjH8ysHWNyP+gaQkL4=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlo/nZLpulu1ZrtV7DrfHqBSu0FCOWbHToSv71XulTiHrw74V4
	8a371IzCMIpVR5pEM8WmIf3IGcmhpxn87vEG6VC39s66oM3WuzSghJ9F45coO9Q=
X-Gm-Gg: ASbGnct91BAn50jk4ei+1MmdvS9TgSwLNmqSqYkWzKY2fldEaYV9mIrJ0MsTEKHmy+7
	sBnbSqHEcdzLq5sUIWB2ZupKjIN5u5Htqx99hB/0J621SWIcofgdRcLhv+TyOHCOsEgoje2R/zE
	AeLPv0DoQvXNWvbAhk/c6Y7Awe1lp+t2jZrAIMVgaFbnx3K1Sxj0mZ6IUHAKArJ9N5vqqE3lMAD
	w5TuSBQrACy4FhKD29LlMwbybVEE+68w1mFEEF+2tVkSXRmGeH/rpuZ+Q==
X-Google-Smtp-Source: AGHT+IFBFcio9MaUGZCTb/Jg2857ywT0hQvVtOg6GlbEZCyc6I2hLialdck8Jevr/BDDD1XTJo/mLA==
X-Received: by 2002:a17:902:c406:b0:216:2bd7:1c4a with SMTP id d9443c01a7336-219e6ebb716mr872299045ad.26.1736178564924;
        Mon, 06 Jan 2025 07:49:24 -0800 (PST)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6967sm292479535ad.214.2025.01.06.07.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2025 07:49:24 -0800 (PST)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
Subject: [PATCH 3/6] RISC-V: KVM: add SBI extension init()/deinit() functions
Date: Mon,  6 Jan 2025 16:48:40 +0100
Message-ID: <20250106154847.1100344-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106154847.1100344-1-cleger@rivosinc.com>
References: <20250106154847.1100344-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The FWFT SBI extension will need to dynamically allocate memory and do
init time specific initialization. Add an init/deinit callbacks that
allows to do so.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 ++++++++
 arch/riscv/kvm/vcpu.c                 |  2 ++
 arch/riscv/kvm/vcpu_sbi.c             | 31 ++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index b96705258cf9..8c465ce90e73 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
 
 	/* Extension specific probe function */
 	unsigned long (*probe)(struct kvm_vcpu *vcpu);
+
+	/*
+	 * Init/deinit function called once during VCPU init/destroy. These
+	 * might be use if the SBI extensions need to allocate or do specific
+	 * init time only configuration.
+	 */
+	int (*init)(struct kvm_vcpu *vcpu);
+	void (*deinit)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long *reg_val);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e048dcc6e65e..3420a4a62c94 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -180,6 +180,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_sbi_deinit(vcpu);
+
 	/* Cleanup VCPU AIA context */
 	kvm_riscv_vcpu_aia_deinit(vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 6e704ed86a83..d2dbb0762072 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -486,7 +486,7 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
 	const struct kvm_riscv_sbi_extension_entry *entry;
 	const struct kvm_vcpu_sbi_extension *ext;
-	int idx, i;
+	int idx, i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
 		entry = &sbi_ext[i];
@@ -501,8 +501,37 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
+		if (ext->init) {
+			ret = ext->init(vcpu);
+			if (ret)
+				scontext->ext_status[idx] =
+					KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
+		}
+
 		scontext->ext_status[idx] = ext->default_disabled ?
 					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
 					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
 	}
 }
+
+void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
+	const struct kvm_riscv_sbi_extension_entry *entry;
+	const struct kvm_vcpu_sbi_extension *ext;
+	int idx, i;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		entry = &sbi_ext[i];
+		ext = entry->ext_ptr;
+		idx = entry->ext_idx;
+
+		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
+			continue;
+
+		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED || !ext->deinit)
+			continue;
+
+		ext->deinit(vcpu);
+	}
+}
-- 
2.47.1


