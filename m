Return-Path: <kvm+bounces-44214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 017D2A9B570
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01FB91BA5A5A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C2529290C;
	Thu, 24 Apr 2025 17:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="piLuddr3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3616628FFFE
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516126; cv=none; b=QwqBHzx3Hyl++zqgq5olfv6qGHY8jEkOgvqCfLlO9RoMA6yil3OoIVHEKSifx83Fdribinxz7MuFlyAdCMAQxYu93HwY4Uvpqnwb1N6ifG7ajzd4atvY7wO/kkM/laCz0kjufXxms7J/f4l6UQr6s5L05CLYF3SW9UULqHowr+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516126; c=relaxed/simple;
	bh=H5I3SSDmXjwRUib3TL18xTg/rVQsrKqfiODBF/E5v6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ezxbvFwf7wC1oLUrBjtQjni7bgV+kWn69BHfk55DGNQZxdOEKYqznP/WA4GX640yQhrM+AoZOC6vqM0RwYBIs6ow8u9D5M7iH18oU+AaTbQIeL2rEWQFMQhuL8v9cXl0xqFBEoqr+SRZCDWDp/vnRPlmp2k8n0s/YDxLV9MOAvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=piLuddr3; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223fd89d036so17392525ad.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516124; x=1746120924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RIWI5J13lSlmUc75M0Yyv1OmkFoJoZE6o7hXZ4HO9lg=;
        b=piLuddr39WucrnUpSovPPxF106ssOv8MhhhKgyW4GKp+1DpjBxJe834YHMl8YqbX4W
         rpiRVxGC1wte+vgJUO+vacRFwnEjU1guUPYO2VJyV/g1LjcS7eELlRaB5apVwpexO5as
         I7pAit2WbiAq2Ef+3GGH8x1LlGKJhnR83nBwYDn364l/MFPeAfhI2jbHZI7cb9GsuDVu
         OMsA9Ia1fjm5yyV1aabmYxR4CCxYczeoLwdzgw1ufqQTMymW3lXjFDqM/vOAIhaTIOHh
         ZEH9xhIdmfIVPx2D8mpTBaN5vmIi2W6dO9tdeFg6OeCTsbikmnCSg1bww0JgyUtil9v2
         czwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516124; x=1746120924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RIWI5J13lSlmUc75M0Yyv1OmkFoJoZE6o7hXZ4HO9lg=;
        b=JHay0V7S9J+vFNAfdUCFh0+LF+dNZK+BjCRhNiQ3pWBqy32h2pMX1H/l+F52imqlGe
         eU7EAR8kbHl5Dj9BycGjPAu56axeXjYHzdf/KSkyCEpd+Lus/lIv3fchmqkNf2XhSgzC
         e09adOCzkY+l/4PExaG+iyQ3YlViVijAcQLLEnwO2S6dkb1Pp1M6zRWXgqfDwu2jobUS
         4dEmH0ZfISRy0TQlE6FllHoy9vAO+RDZLXcik1lk7Fi0QTkxbFGmsUczSThsyWxKpydc
         B/mx5nVyjJxIK4fLanbDNYh5rIhs/iI5SIcvpGajFtjrnnDz6K5/WBXqBlHetR2x5ywH
         /kBg==
X-Forwarded-Encrypted: i=1; AJvYcCWyNf+fTKJGzFh1tlCA37LC/AgPEqY/Wvp1u9GCk18t1QwlbEQsZBkfj2oa2Em3RzzFb7g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqPyt5X8EYKuz9iY5v+IDz10F455ZrI/lXE2SMDz/eK5sbaYyD
	ipYsDI/J8CVp8URDR62mmFlxd3lEweRk2Mo+tjbKlXjpSjTGD+XGzgsiIcCbgBE=
X-Gm-Gg: ASbGnct5f1XPaCqLzH4PcMBm6hKQXK4hwG8DmHtI92JEHKLX2e1XxKjkqxS/574UlrS
	jOAuEhSi7sOMZEjbzUo2srjQIAPU4wcyoXbMtuLg5D/lgxk8SyZIHZBZJXz4XWySth6tm07cyW/
	5Z90JkO+Y3SwtkDJ/ODKU9TmMykECH0/I5wtnRgQWxe2kJjQi6m6U+kEwIuwon4wKBtJVXfiUij
	lfyuQD0xGifPfgnhzYv7DIrZFb44+ErcPGPUZWcHYMWyq/wlVCL/1bRw7gRYTbVK3A7C3elgygC
	apz6rEJeTSUb7/qYbvlkGCgpcygejgrbM/m5t+R5tg==
X-Google-Smtp-Source: AGHT+IEMgeNDdBBhoNSxcm3znhBhdeT3XXPb2Z1/mSRltyTQzf0eyhuWj16KlTi3Qs15Rz0vFa6sUg==
X-Received: by 2002:a17:903:3203:b0:216:794f:6d7d with SMTP id d9443c01a7336-22dbd46f99fmr4326145ad.48.1745516124524;
        Thu, 24 Apr 2025 10:35:24 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:35:23 -0700 (PDT)
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
Subject: [PATCH v6 12/14] RISC-V: KVM: add SBI extension reset callback
Date: Thu, 24 Apr 2025 19:31:59 +0200
Message-ID: <20250424173204.1948385-13-cleger@rivosinc.com>
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

Currently, only the STA extension needed a reset function but that's
going to be the case for FWFT as well. Add a reset callback that can be
implemented by SBI extensions.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h     |  1 -
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  2 ++
 arch/riscv/kvm/vcpu.c                 |  2 +-
 arch/riscv/kvm/vcpu_sbi.c             | 24 ++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_sta.c         |  3 ++-
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 0e9c2fab6378..4fa02e082142 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -407,7 +407,6 @@ void __kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
 
-void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
 
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index bcb90757b149..cb68b3a57c8f 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -57,6 +57,7 @@ struct kvm_vcpu_sbi_extension {
 	 */
 	int (*init)(struct kvm_vcpu *vcpu);
 	void (*deinit)(struct kvm_vcpu *vcpu);
+	void (*reset)(struct kvm_vcpu *vcpu);
 };
 
 void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
@@ -78,6 +79,7 @@ bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu);
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
 				   unsigned long *reg_val);
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 877bcc85c067..542747e2c7f5 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -94,7 +94,7 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.hfence_tail = 0;
 	memset(vcpu->arch.hfence_queue, 0, sizeof(vcpu->arch.hfence_queue));
 
-	kvm_riscv_vcpu_sbi_sta_reset(vcpu);
+	kvm_riscv_vcpu_sbi_reset(vcpu);
 
 	/* Reset the guest CSRs for hotplug usecase */
 	if (loaded)
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 3139f171c20f..50be079b5528 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -536,3 +536,27 @@ void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
 		ext->deinit(vcpu);
 	}
 }
+
+void kvm_riscv_vcpu_sbi_reset(struct kvm_vcpu *vcpu)
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
+		if (scontext->ext_status[idx] != KVM_RISCV_SBI_EXT_STATUS_ENABLED ||
+		    !ext->reset)
+			continue;
+
+		ext->reset(vcpu);
+	}
+}
+
diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index 5f35427114c1..cc6cb7c8f0e4 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -16,7 +16,7 @@
 #include <asm/sbi.h>
 #include <asm/uaccess.h>
 
-void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
+static void kvm_riscv_vcpu_sbi_sta_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.sta.shmem = INVALID_GPA;
 	vcpu->arch.sta.last_steal = 0;
@@ -156,6 +156,7 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_sta = {
 	.extid_end = SBI_EXT_STA,
 	.handler = kvm_sbi_ext_sta_handler,
 	.probe = kvm_sbi_ext_sta_probe,
+	.reset = kvm_riscv_vcpu_sbi_sta_reset,
 };
 
 int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu,
-- 
2.49.0


