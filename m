Return-Path: <kvm+bounces-43578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B81BA91C0A
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BA09445382
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D709E24E4A1;
	Thu, 17 Apr 2025 12:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="XpBQMCuX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856332441B8
	for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 12:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892738; cv=none; b=CoR2J9g3XyZAT6vWBCV+KHG1eDFvs8tMgrUHMJmJV0iRW9M1FxXGYjRKI3PxFwxDUTusi8gMXTBSYe66HZk+6lTR9OgCADvxJRsADu/+KIHWUd18J2l/InYQaJsLRrHiIBtgUYontf6TXZfyV47gDGzRojjFs6WMhkoPd+Uwusk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892738; c=relaxed/simple;
	bh=H5I3SSDmXjwRUib3TL18xTg/rVQsrKqfiODBF/E5v6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G6oR3zGv5v7RaofrR1HDY4GYp1P3ghUosIxtvEARLOW/7scX57qvgHkY7N0gRBOm0sHDrIjYMum4nqEFZeWuZwVW9P+pNHU6BJf72gSTwKDVW11fB/lysS4n7HQR0cBe1zsbTqx8Oe+0E5ux++KS9s1116p1fHGLlyMubV9YAA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=XpBQMCuX; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224191d92e4so7414615ad.3
        for <kvm@vger.kernel.org>; Thu, 17 Apr 2025 05:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1744892736; x=1745497536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RIWI5J13lSlmUc75M0Yyv1OmkFoJoZE6o7hXZ4HO9lg=;
        b=XpBQMCuXAyDB11UWoArkfLcN7EhswpqfbfknbC1ohQpeyaijdj8NnI7eNKYdG9SdJ9
         L5ieRIgVw3cebhF07DqstpRT60jXzn/bstssdCO5AwAI548ClCWIapyPKjIDNtn6424E
         jhByHaFEWxUltJn/l8wiawskYcErI32YJgpXwGwu/RC5a0qiWRHMrZ6hblXHkQHSxipe
         2g1XpCBRtGxG0U6q8xeou9KN5H2OhqyNt8mXzn/qvQyqrhYkZei5yR+vJeQQXucf2ghL
         RaM2O2D7rVqCB3I7kXt3OBeZviQVJS//NPTdcvv0ipFcdrDHHYY1iwtG83FS0F4OixOL
         c7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892736; x=1745497536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RIWI5J13lSlmUc75M0Yyv1OmkFoJoZE6o7hXZ4HO9lg=;
        b=bLl088JY50ceWscW5l4pHIaSeiPNxUeEr5Pi60Bzt+Ep9+D0CodMzegNEMpNU34lRj
         nfzL+tzVfyRkujwIrt+RZCbd/SkRKza7w67blXhwyEI8fOUQd+fL1AAnnk5zY/PYha6h
         QZF52Py85QwnBs09JfRaUYhuSsW0F7j9SQ6VLhnOvOQsPfP361TTskldK8GDDYIhMEfX
         AVNZ4Bzk3tJIaUbt3Ri9+cYAnjxB28GwLX0sOAFt6pXsp0h32QW1XcpmHibZXNK2amjt
         3taMa2M3j1vNh56s4boKGUkw9KZokFH9TuVRSR3GsQFo4rxB42vdipSg6RvanKAR3lKc
         v+qA==
X-Forwarded-Encrypted: i=1; AJvYcCWAock5MJSoJMnfY4uoRWlFHTstajAL0l4cIro1WXNW9seAJztvxkLozxpptVkJD4cxrNg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi8ib2ZfvdFRwZHdRDVPAmvQxAzhMwwJz6AnV1BNh+k3+vGOib
	NkAjFnwuAaMd3/Sa40TiWYwesSNVIcyeYDxz4SdEZBzXcgey7LRtSl3DTAZ4AsQ=
X-Gm-Gg: ASbGncvIjY/QwF3jWbISyJL9R+/4XYKMiuxmTyZxvw6RxUshT03cgCAHCkk5qeczPvl
	PFrZO8m1lIhmqeccWyqB55dOFNtSGRHl8W0g+lCWPu8j8U8gAG66vyibC7kul9LfL2LAI8YsmP9
	DIefcZoZWzPTbV3eznUBFWcdolMDmd+pqyS1JGcjl5dp6b07rcOt9zgeyhBqdHviS1ulk/+yJ0D
	p8hvCRfHFVaxOyHMSzk+1KhFakokaVoFC3YiEZdUyIkq2JutjTEdkUzPsPipNJbAUpTXfFFpyzg
	MEsbYgJhmM1+5LJfC53ZzawsBmj85/TcaKPcDQWJ0Q==
X-Google-Smtp-Source: AGHT+IH/XOfIZJN1QIMfxSpPHyEBOL2TQ9imzdZAMvoYmfc/2OhjJtEou81N2JqUbXrpk40zrfv2Kw==
X-Received: by 2002:a17:903:1905:b0:224:10b9:357a with SMTP id d9443c01a7336-22c359743ffmr95085905ad.32.1744892735913;
        Thu, 17 Apr 2025 05:25:35 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c3ee1a78dsm18489415ad.253.2025.04.17.05.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 05:25:35 -0700 (PDT)
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
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v5 11/13] RISC-V: KVM: add SBI extension reset callback
Date: Thu, 17 Apr 2025 14:19:58 +0200
Message-ID: <20250417122337.547969-12-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417122337.547969-1-cleger@rivosinc.com>
References: <20250417122337.547969-1-cleger@rivosinc.com>
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


