Return-Path: <kvm+bounces-4396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 180B281200F
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 21:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE3EB1F21958
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 20:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E5E5A10C;
	Wed, 13 Dec 2023 20:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="WVRAl3R2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F39EAC
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:33:23 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-33644eeb305so159530f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 12:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702499601; x=1703104401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNQI5S3fkIj7NrMfmbJzF3XH+7YYWzemWytVmilYcq0=;
        b=WVRAl3R21xwQkMOpR9necNcoq1nhk76GBd68uOazMxzmHArxHwjifNh9CG06V4Wzzg
         BSjMSJ+wBbzwrFQmczmBbONh3QEz3YQ9R7Ig/s0lbAjA49zFIsoXVVI3QWXcw7buEjMG
         KEP6wPYQyCaAAxa6+/kxsrJInjc3XZwLHP21MJpLuoL+5c4pdRpMjgvr/i/oXSCCqCnG
         SwhM9xppkygpBJBVOPlX/KjkZFKD38RkBykcAsY4KC84mCNV057omKgcvebGjWD1fG0n
         kMez+90O1CF0ThqC9ZCe2Eqgw+sSeEExP1Nsy9CNEbulRw9+z/jtyL0SRsm3tZ72ZCBp
         gwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702499601; x=1703104401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qNQI5S3fkIj7NrMfmbJzF3XH+7YYWzemWytVmilYcq0=;
        b=YRqhgLTNW9S2rCxxKQ5mM6Gy+1XMO/v6FO7fJeTj8/XnElT2iDghsqbnADrY4Hi0Mz
         QYU0RwmUME7glzAQoa4ImqJNr4yadwlegIP4iqyQ6r2qNeH/D4pkeRbzuW0YuPJyGqaS
         v9rjVLqdASja6TDCgudWe6zcWUqfEPe2PNaYPfoPtZ73EIbob+aaKyNnWbwniAPKPEFC
         OzsGnpM+sa9QxCOfziQ4NOdwZgf4HEXk5g0DUXr2gb4QpN+EVwnzX4J8daTQ09rrzdIM
         0ZgcstVjkfN4dDx1cqIIsennZjo7zLOCQciBtkB+0b27UNyiDv+NT0x4Yr9kzKRyVANr
         wJeQ==
X-Gm-Message-State: AOJu0YzF9zArb5SATOXlReCQyREdwAfsmlgblk73k5asrJ7JAMdDxOAd
	drbkMG8faC4e+Nl2Xk2ONy5E4A==
X-Google-Smtp-Source: AGHT+IG3reTNU+mJ6s5WyJ1mAvW4tTpIucH1hcfMu/iPtp1tRfvP2HWAF0mMX3m2L1tivm7yEvDWGA==
X-Received: by 2002:a05:6000:174d:b0:336:36fb:84c8 with SMTP id m13-20020a056000174d00b0033636fb84c8mr990697wrf.107.1702499601505;
        Wed, 13 Dec 2023 12:33:21 -0800 (PST)
Received: from alex-rivos.ba.rivosinc.com (amontpellier-656-1-456-62.w92-145.abo.wanadoo.fr. [92.145.124.62])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d458a000000b00336463625c0sm136243wrq.51.2023.12.13.12.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 12:33:21 -0800 (PST)
From: Alexandre Ghiti <alexghiti@rivosinc.com>
To: Russell King <linux@armlinux.org.uk>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v2 3/4] riscv: mm: Only compile pgtable.c if MMU
Date: Wed, 13 Dec 2023 21:30:00 +0100
Message-Id: <20231213203001.179237-4-alexghiti@rivosinc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231213203001.179237-1-alexghiti@rivosinc.com>
References: <20231213203001.179237-1-alexghiti@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All functions defined in there depend on MMU, so no need to compile it
for !MMU configs.

Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/mm/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index 3a4dfc8babcf..2c869f8026a8 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -13,10 +13,9 @@ endif
 KCOV_INSTRUMENT_init.o := n
 
 obj-y += init.o
-obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o
+obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o pgtable.o
 obj-y += cacheflush.o
 obj-y += context.o
-obj-y += pgtable.o
 obj-y += pmem.o
 
 ifeq ($(CONFIG_MMU),y)
-- 
2.39.2


