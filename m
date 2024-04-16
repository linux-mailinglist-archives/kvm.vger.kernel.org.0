Return-Path: <kvm+bounces-14824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9B08A736D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 20:45:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F7211C20506
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 18:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476C7137C33;
	Tue, 16 Apr 2024 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Wdos2Ywa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6499A136E0A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 18:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293085; cv=none; b=bPApRvM8Gn3IO3z2tvo5EVJV1jAp54BUjTd2klK08d3pBQ4x00U+wIBKGaZQDVK5NPxjAKimYNnXWuwtMJO0lHKXRc+I0Ya3AQq9dC6ZWcq11zG3wEdqje1L1mP7UTvSK6m3zkjKnsUkvb/lmGQC24Kyqhfh5v1Aj6G1Aod1F5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293085; c=relaxed/simple;
	bh=CuOqtFD3uDjWgSKj5f6SchwsQQ87ZPABcb+EozPDHPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBq3dfvky4KivRvhC1yrfMskoDpFtxZKyhKucPymHUQJwvNdkiTK2HBoxqezdE8hEfTW9HGUnPW6Z7f8QgRWINqpSHA72Mi4f93l2aKQc0FiJc+futDIcFkxUuoe8C2agTH1VcNAwkPS3dAQta7KG8aDh5H13H5hSCPqRlbxtuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Wdos2Ywa; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ed2170d89fso32287b3a.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 11:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713293083; x=1713897883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1oS0ksNazYXtVOBgFTjTYlhVVLdg1h0owq7BrHVbdc=;
        b=Wdos2Ywa9+hjrZJeFwukyHXee3wiVmXUzjJSqijHsmv0x4OIN1kUJVbtJtWiKyXE/d
         IB2Wm+luu3Jg1apcKyJdcstelP6BC7i7agNKpbQtnf0RVHBBso8fbeKsNUg9YGoz/L1C
         84A9Uj21qqRUZBlDZb5IcEIryeZgeBWz/oHhZfpJ8l3yy6EvyKQb0afrwJ7mIJ0wZ2sV
         rGX71hkzXKjCylGZdf+/wWs9F/cSvq2zoTnQVig613fLU/Nzf3tz8dfbwiukl952BASL
         ndJPjKLdIWN1VvOaLNDy9+KexN9g44Fr+Hx8eCmSMmlP5qP5qOOaqKxlVqIZWMKl9AGz
         Kayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713293083; x=1713897883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1oS0ksNazYXtVOBgFTjTYlhVVLdg1h0owq7BrHVbdc=;
        b=LnJMk2RYai3nTh7UMuq5TSkbDh7hJfiBlzqJZCyPXp52pjTrATyR2RHpyfeHTRvcBb
         R+FyH/nJLoNsjlUViGZgpjCsG6IgmuGWZrZXi6SBDwfouepT4N7oTyX/DUah8pDLz2AV
         wlJ7M4nClBckQ2CWqQ7BvopnoDVePIQ7GOZvnaCbD1ZYhfWQn56crpfx0yipCznMLezi
         ynEpungpDQqrGKNBEn+f/KvyHf1LuqxcMAarzdDNhXQE5Kdh4iaffPHd+J2KCFd2L2mG
         yrghZKHwDTEae5YIbcsjyUnm+0zxxZWKZUuoICDC7WqmamxukWdk4IJxZRzHUNnW93aG
         ONaw==
X-Forwarded-Encrypted: i=1; AJvYcCUi/6qC2WjEL9Mx5LQ750qsLKx9vtrch9bXcUpQFnnfA/cUfajLvL6E9/cRgUQcWLPZIy3FHlXlOdqXbw7u2S2iAkO6
X-Gm-Message-State: AOJu0Yxbb7FCYFTlNzp/oSO/ye7KNo8et70BEOMIZ1SFpvGvAcGgmQtx
	viUjRrNLfE40YYJHuNF1kBe5a+TuwH6VjHvgxeuq9d4BIU7Murt7ytvnX0t9s6M=
X-Google-Smtp-Source: AGHT+IFCEO++RSNi2s4BPgY/cFtIWMTnHZE2PMfQmZHO7SJaFE1gAV8eT+53+kwpYpGgaU41aAh/DA==
X-Received: by 2002:a17:90a:7c06:b0:2a2:7494:15df with SMTP id v6-20020a17090a7c0600b002a2749415dfmr4080891pjf.9.1713293082701;
        Tue, 16 Apr 2024 11:44:42 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id o19-20020a17090aac1300b002a269828bb8sm8883645pjq.40.2024.04.16.11.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 11:44:42 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Anup Patel <anup@brainfault.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Juergen Gross <jgross@suse.com>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Shuah Khan <shuah@kernel.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	x86@kernel.org
Subject: [PATCH v7 01/24] RISC-V: Fix the typo in Scountovf CSR name
Date: Tue, 16 Apr 2024 11:43:58 -0700
Message-Id: <20240416184421.3693802-2-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240416184421.3693802-1-atishp@rivosinc.com>
References: <20240416184421.3693802-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The counter overflow CSR name is "scountovf" not "sscountovf".

Fix the csr name.

Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
Reviewed-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 2 +-
 drivers/perf/riscv_pmu_sbi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 2468c55933cd..9d1b07932794 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -281,7 +281,7 @@
 #define CSR_HPMCOUNTER30H	0xc9e
 #define CSR_HPMCOUNTER31H	0xc9f
 
-#define CSR_SSCOUNTOVF		0xda0
+#define CSR_SCOUNTOVF		0xda0
 
 #define CSR_SSTATUS		0x100
 #define CSR_SIE			0x104
diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 8cbe6e5f9c39..3e44d2fb8bf8 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -27,7 +27,7 @@
 
 #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
 asm volatile(ALTERNATIVE_2(						\
-	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
+	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
 	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
 		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
 		CONFIG_ERRATA_THEAD_PMU,				\
-- 
2.34.1


