Return-Path: <kvm+bounces-44210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6966A9B55E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 19:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E23F91B682D4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BDAF28EA44;
	Thu, 24 Apr 2025 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wHcmUuPW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E6328E61D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 17:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745516090; cv=none; b=eHoBErl2W1hpqaXHNPj4PTuGVYhsvDiIyt7qSDm4AaBYdZOWeEAsOv8SsZeL+R5U74aMzPIo6fD8pgeSmY9NaP4UCYUojw7zxbdctxQdK/5aelWZJF1Tkj1F4hOTuWvW5FlrFAeycOa1mAtQX/3vpXNQ2YDkGclOl43Fx1EHcFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745516090; c=relaxed/simple;
	bh=lWMV9a4rt/vMMWmMpqg6bQDMprZkvJOCqC9l111y6iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ujk5KOAeuJ+zfMD140SFtwr/NkHNOUWvtk3O3xJj43VK+BXNKyodc5ltKXWeuUQb5qieWnOR0n60U+nCDnEASXKTc6+IhgdCxFUAr0/Yd6hEmvrE5pQ1cdKY1zwT7T1ZR6ls6TpSEDcAG+mPXA0mUVBaJSjbz/ALFUq6JGwpN7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wHcmUuPW; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2264aefc45dso21639725ad.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1745516088; x=1746120888; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=we6/kXNuYG+zbvuEeQnBBO4wnOzYcP3bTDt7ONOTsDY=;
        b=wHcmUuPWGRmmHh+l/O3BtgPlyIa0Qjr5FnO4TpEPCijXV8zlFsvYrmUQOkfUNStBSY
         TtBsypfbrlP+r42ZEG2sCxiLhd2PIn1Y5uuqfzi23Cu+nnZLaqHH7dqboq8Bx0UQxNsj
         m6so04F4CzXWonpJQMY7RwEDdJFKcC5xPSLLpDyUa2+NusGVhm6NmLkNoLidI1+eXATW
         Sp38RAORh8miaCUlqTxuvQLUEWZyVTpqfkSzgIv1NT4i5AmcWbQmIPQXAVtko0UKrrqp
         pu5EAVXqaW93pxn+cf+RjtMDyPJm4ikhQ6Bw9mCTEL2fDjieF656gyiGIT2PmofeonnO
         l/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745516088; x=1746120888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=we6/kXNuYG+zbvuEeQnBBO4wnOzYcP3bTDt7ONOTsDY=;
        b=RdDGWIulkxL7okcWkE0kBGcX7bd/4RivTGUacIL43/7mQloOCm/nVH06sNwU2ZsiNB
         wmmL3Vo1SHw/WGP+XQg8xPvsVCKztj4ISBC3Lulna85HDsOOHWEIwvx6/NxaVJJSY9vP
         I3Zx9/CLyVcY6PWaDxA/sG3WUQ0BTMXu5bQZfzQI2nLQtAvBdobE+bnHcp05AH+smhmH
         lewJNkSawrGmlxV3S26z5k9Ok/OkZy4n2Dp5vW8LivIEp8W8lh1baulfmZ76IO+/2ACI
         QrRi7VQTDCZBP2SB14KgfjWSqteJkqDCuIQyV/+CiIHxUH6LXIQfvzzsP4daTs1vzmkb
         apQw==
X-Forwarded-Encrypted: i=1; AJvYcCXvjYIFCLwc8odN3tQWUiu6F0YTkiFhUIgbY5IcAhPEKIsX8ALbuYtkgNRQJF5+zQHGxt0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa6av7fBGbO5uQb/4udA1uQJ92hKO0R48aV492vg7zNypvtzVh
	qDZJMPKhPMeTxGcvR0KCqcq+K2t8rfzbAOLuxq0J4Bbh4gNW1gJdH4jJhvpx+xY=
X-Gm-Gg: ASbGncvm80lggz5V4IAerTb5kkivcYNR5/Lz/c25YOq75CPTp6Bf0/ZDc3jhQfCjCpX
	U/E7poyXGhaM/Ri4poJq2yuUVYNh8FGPjZQtu+uiYAMliOGq8uSlMCWcyc15kAR0iCpv3t0SUfw
	Io4gj2kxYPVBAZhxoduuC4D+L4vhOizTmbDSYQctjRa/fPHCcA5HZkD/4TKv0w/5gvwCM7ZtWfb
	T0go/LDYMDofCE3gFQc5itVU5Z1hQY48Nl0CVKsx+MAa2e+SZ92D5iWm+B9l9s3/GN+2kGO6mld
	IJ3Y6Xzz0eSyumb5Oklv1Qo+h30n2/+p/WTbe89N9g==
X-Google-Smtp-Source: AGHT+IH/QMJyzwx6cGAw+XwgapY2Ztj34NBA/q3W1YmtI9wSx+YU+sJYTDmY372LJ5cZOrin5uzqng==
X-Received: by 2002:a17:90b:5144:b0:309:f407:5ad1 with SMTP id 98e67ed59e1d1-309f5533ac7mr921807a91.14.1745516088230;
        Thu, 24 Apr 2025 10:34:48 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db5100c4esm16270255ad.173.2025.04.24.10.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 10:34:47 -0700 (PDT)
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
Subject: [PATCH v6 08/14] riscv: misaligned: use correct CONFIG_ ifdef for misaligned_access_speed
Date: Thu, 24 Apr 2025 19:31:55 +0200
Message-ID: <20250424173204.1948385-9-cleger@rivosinc.com>
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

misaligned_access_speed is defined under CONFIG_RISCV_SCALAR_MISALIGNED
but was used under CONFIG_RISCV_PROBE_UNALIGNED_ACCESS. Fix that by
using the correct config option.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kernel/traps_misaligned.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index e1fe39cc6709..e02e9b4b0fc5 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -362,7 +362,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
+#ifdef CONFIG_RISCV_SCALAR_MISALIGNED
 	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
 #endif
 
-- 
2.49.0


