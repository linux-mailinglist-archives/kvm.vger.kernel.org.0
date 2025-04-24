Return-Path: <kvm+bounces-44213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B430BA9B56B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B569D1BA54AE
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFA728FFF8;
	Thu, 24 Apr 2025 17:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Bnm+M5Jw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333FD28F948
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516117; cv=none; b=bnMM/myNP31IANn8e7XpvsrRX2bmCHnu5j2B2ekyv6tFOZwAFd3Jtooy02G/MgdqPQJ+UTlvF/jKy7A9mMf/w2tA5RtpChqb5ToX5rOnaAf9zjOQDl3EDr0tGiu4wJEJ+qSRFqNqOIhS1NoCNAMXmy+cm3emz7yaAf+7ZP8MrEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516117; c=relaxed/simple;
	bh=NXa9HEO5RKY1D2k9IbxsxMtK9lSmU2PJg0VdH4XU874=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6d2ijvzEoE43JIym4Tp20xpiIptRsiyoPmyxXnysMV6GrCVLpoDACtHefuklr+ZWthWhe/gJcIy9mrdMe55cogZrhMJUz3I+V92CPt5PhCjnknOlKpDa3U47xY8n7NAZ+WDBtQDSHIMFbJDreA/HnHirDZGZUAV/Y433iZOb+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Bnm+M5Jw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22d95f0dda4so20311325ad.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516115; x=1746120915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/KHThPTp9HBECdAqxs4JY6wN99GqOifsmOPr7rqjaok=;
        b=Bnm+M5Jw3DAc3lwaZErrhiqa5TB0lLR8Ik327yAAsdeOP28hQnBQ4LKxfNYm1hP7SX
         UpWMjhrwgKf7Rk3qk6luqq+Dp0Z9b0aDLBRteFGku9gBNRlXnpWft7QxcLT1RKX2ZT/A
         97Wuj2dp1oWPftm75fnE9wOoRZlr/AWtTruJOVynhSHaFtGK7U/MaL5qHOvuN3X8rX6T
         6q108FZvYqhRlWUaIvtEvLzoL19DkrRTkcazg2a3l59IScl0bHUnNorCvfy7j1mkLzPH
         j+ZVbXoKBp1zQsf4EQmCWNEIk0CE/6vmT0JvlAsyHGpF880XZJZlq5bqM1T2rduGoKNQ
         pGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516115; x=1746120915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/KHThPTp9HBECdAqxs4JY6wN99GqOifsmOPr7rqjaok=;
        b=M7Bp05mMPvmzdp6hm0U/up/wwBoaRkT3EeV8CnGJbhrKXzrtylvDfntBZZCGRMY9Z9
         ffPIa0v3fUn/+iyskbu6QAKKOojk9ckjhwqX3oYMB8faBKJ7YpP6xb9xcx/dnIDUB+zz
         06Ki9v5fwyvguSRtGXVsktUbOw4C6hwgyRfmmxcEUEMSPhQumQ/13COBInZ3LJGaOny0
         vBZldbu4anAUV96eZ8YnExFYlgkk8phiW/5SaljFuLw3vsF9Hy/Zk+e4GFt9tpvu5140
         C8POo/p7r4J+TxeH6Dbt08PIWjSnWeKg/Ym4XDa2tuTyB1r7ojlzuwelgAE6JvZIzSER
         vltA==
X-Forwarded-Encrypted: i=1; AJvYcCXRWiQ4jHshcrDm9CUn0a5GZxvCYR4RynOghTalUdTPtFUn85Z7r0YZ31d1I69TmX9hudI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3jc9okJYrvywsCidropwNGsOzM9q7RODChNZVWgloZEfuOcfO
	OaINlvLB/6Boc+uiQbKsJrVSdjYidicdI7rU9ufPVRpVetVEIDSNcZFIQf1Q3Mw=
X-Gm-Gg: ASbGncvLox5morHjrI6DKSGOHn1p3w64jvEnSRB1gLsroUvB8fkHaVHcD0UnxGYozn0
	8C61fEmBHZ6ozNt++kvrQbhV/k0WS0/yULLGCFL4XXjFJzPlHVy3YjUQTvwPIiHbwV9ss4hqu43
	pFaoY73n/wnfb0j5sMnAEgkP6z+59JHF1QxNAfrBzkFmMjdwyNVZn8OqwE6A/jZ4+AhNNIXPkTb
	/OBXlYcef7zitR43VI8vfi5uVeFcasgloQ9CSC29GCyeidPL7i5dIT/jNqiM9oPxOOkKFjj1I/d
	6VbP9D4SuxKJxVCIcv6jU2raY+NZKpQ2kfHorhddpQ==
X-Google-Smtp-Source: AGHT+IHk7ifeDzXStWRadJ48a4Rbu1GdvPFHAeWe+THKzkAyDqtofKTCbTRnNG+8lnQC3H+eIm6QNA==
X-Received: by 2002:a17:902:d489:b0:220:ff3f:6cba with SMTP id d9443c01a7336-22db3d71b30mr52646935ad.38.1745516115638;
        Thu, 24 Apr 2025 10:35:15 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:35:14 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>
Subject: [PATCH v6 11/14] RISC-V: KVM: add SBI extension init()/deinit() functions
Date: Thu, 24 Apr 2025 19:31:58 +0200
Message-ID: <20250424173204.1948385-12-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424173204.1948385-1-cleger@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
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
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
 arch/riscv/kvm/vcpu.c                 |  2 ++
 arch/riscv/kvm/vcpu_sbi.c             | 26 ++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 4ed6203cdd30..bcb90757b149 100644
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
index 60d684c76c58..877bcc85c067 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -185,6 +185,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_sbi_deinit(vcpu);
+
 	/* Cleanup VCPU AIA context */
 	kvm_riscv_vcpu_aia_deinit(vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index d1c83a77735e..3139f171c20f 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -508,5 +508,31 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
 		scontext->ext_status[idx] = ext->default_disabled ?
 					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
 					KVM_RISCV_SBI_EXT_STATUS_ENABLED;
+
+		if (ext->init && ext->init(vcpu) != 0)
+			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
+	}
+}
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
+		if (scontext->ext_status[idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE ||
+		    !ext->deinit)
+			continue;
+
+		ext->deinit(vcpu);
 	}
 }
-- 
2.49.0


