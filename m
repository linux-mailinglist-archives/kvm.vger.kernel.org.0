Return-Path: <kvm+bounces-36726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBB7A203A5
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66D041887636
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8211DF986;
	Tue, 28 Jan 2025 05:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="rWvoqtiH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1B21DEFE3
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 04:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738040399; cv=none; b=i69aybdoluCoSDRTE1AXK7jdHvR9sx9LerNBX/r2lUmdwsG8MPQLjelOCEAw2/AyzMcl6TRXVH7++krdf0gdxNIeF73g0Vpq4IVkljHlwBuke8v8AtQdeYUdTOc58fJpcKAsKtbZ+eIRn6JWr3DK2OW2521bNQSjrOITC5EWDiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738040399; c=relaxed/simple;
	bh=D68shKs21+kEnfY1w7KDWjYLipkuW9L+m2trlxew00o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Tt+1wH8IBgaIDMDPJ6k+8cT0KZDLOs8pWnLlt2JTT4HNj9TSr4AWo5aLfQarOFgBkOM4v/nNv+RXQjCrGCS1hN3u8cDLUfUpwxMg4LSnI2hUGKEmxYETWbRIie5HZJFWIxyo+KHBcpOpbo3FX/CCFIfo0CZFAz/Tx/aJ5BEj1fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=rWvoqtiH; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2f44353649aso6915578a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 20:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738040397; x=1738645197; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vL7HY0dEKrWKEMn+BoWLtPifTt6hhf+Eo5KcPrG96mI=;
        b=rWvoqtiHJF6Uqbzrl058lK83Ee1lMOUOQFr5xBtygdG1eRwif6aPE65cqI/1Q4eQp9
         prf9EHktOtYByKoETlf3ZaFPYF/S/FRz5BXELCzBerF4tdFzoR7h2OjbOTLiqxNRDWKv
         N/edfHX4dn9iDXfmc+67FIOMwQp9pAkuM3WUeHcdagQ3VwO9dv/NmgaRofyh8JoP2BVn
         WGEmGC7gwouSxzOKpvZ3hFrdZu6eHBfjjEcoxJyeTr+ibQOFR5i88sU+vH45xjvFGNGc
         xRmdAd5ucg1vplboFBEkWPGWPFeYZRX6M0+cfk9rxRHl6KTaVRrbDKZFcHsnMTJfUSi4
         7xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738040397; x=1738645197;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vL7HY0dEKrWKEMn+BoWLtPifTt6hhf+Eo5KcPrG96mI=;
        b=RqXmOYvRhV9haVnUtAk4hx6W44YheGB+vymbH8QfXwA6X66GONsHFa/zcDLkAZdphB
         cSRCFdBK44mu4brRIvgYrYw9iiDyamyJM45B8oPM04fxfhTuJCDyQdeR8bIG4P3owpl4
         btWQzrzzziewTESGkZkDnZPxSATGKWSouAUxWGAYkEfvrn+OkS7es8aQu+Sl/MtmcvS+
         6UPl4D4wutaopainIX04SPevlahC77FcQYkMzQCv6IIEcVo6G3C6bWRSFLD89Hpi8cAY
         47t2H/RxCfJwTx0y+iU3IQUWbRqaUxaawbrodNEYp+mVQ/999/4sqbsE/JNMJvU2yAy5
         IXOA==
X-Forwarded-Encrypted: i=1; AJvYcCVTBMY/jJv4sqjGIz1tqmyHkzd0PqJGuQHnRwvP1clm4ENaK7/nnf1ww04ogD42tSQkJ1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxELUND81PSfj5IGjWOT8S7Y0ge53Z1tYdt9LEvJIq/5xh9Zh6o
	nBMJ8JZo4MVbM9LFlrm4BmaE8v6sffJ4COYMIlE0CFJ9/Bgw+uCuf5dwoRunyQY=
X-Gm-Gg: ASbGncvBC4PVpe9eDDzWox1uNKrLxm4sZZhTGgt8tSUkkWDG8fKYp5vNRxe3C00aM+2
	dPxzPfTksQgQZA8/lcRkSn0LhS3GId2ELfhBZe23BwHTUTuoktSGHHj3GuuwurjfveJn5CI3FpM
	FZarZYv4NlYwcTAA8fa09e/B0jvaxWu/PFWyiIyRdtNvidhbr40G+lSPoxQDpj6L5FO1WVDgpLf
	uOpMKgHHE8XHFqi0j54a8FTUm9SUwHw1VfMzo96ZxTQoi5x0Igsw3G9ZQti3li9kBmuj9WIrdUD
	aS6ZRyB3gNMzMtD6p3GXAtmGJ7ik
X-Google-Smtp-Source: AGHT+IEydkqGnMas9EixfltXBAZwEmzDNcAGB6aZaVaiRCrDSr5UAXUAKLQCmfBM6LnRIdbwcEstgw==
X-Received: by 2002:a17:90a:da8e:b0:2ea:5e0c:2847 with SMTP id 98e67ed59e1d1-2f782d37703mr53064728a91.22.1738040397475;
        Mon, 27 Jan 2025 20:59:57 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa5a7f7sm8212776a91.11.2025.01.27.20.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 20:59:57 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Mon, 27 Jan 2025 20:59:46 -0800
Subject: [PATCH v3 05/21] RISC-V: Define indirect CSR access helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250127-counter_delegation-v3-5-64894d7e16d5@rivosinc.com>
References: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
In-Reply-To: <20250127-counter_delegation-v3-0-64894d7e16d5@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atishp@atishpatra.org>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, weilin.wang@intel.com
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Conor Dooley <conor@kernel.org>, devicetree@vger.kernel.org, 
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

The indriect CSR requires multiple instructions to read/write CSR.
Add a few helper functions for ease of usage.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/csr_ind.h | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/riscv/include/asm/csr_ind.h b/arch/riscv/include/asm/csr_ind.h
new file mode 100644
index 000000000000..d36e1e06ed2b
--- /dev/null
+++ b/arch/riscv/include/asm/csr_ind.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 Rivos Inc.
+ */
+
+#ifndef _ASM_RISCV_CSR_IND_H
+#define _ASM_RISCV_CSR_IND_H
+
+#include <asm/csr.h>
+
+#define csr_ind_read(iregcsr, iselbase, iseloff) ({	\
+	unsigned long value = 0;			\
+	unsigned long flags;				\
+	local_irq_save(flags);				\
+	csr_write(CSR_ISELECT, iselbase + iseloff);	\
+	value = csr_read(iregcsr);			\
+	local_irq_restore(flags);			\
+	value;						\
+})
+
+#define csr_ind_write(iregcsr, iselbase, iseloff, value) ({	\
+	unsigned long flags;					\
+	local_irq_save(flags);					\
+	csr_write(CSR_ISELECT, iselbase + iseloff);		\
+	csr_write(iregcsr, value);				\
+	local_irq_restore(flags);				\
+})
+
+#define csr_ind_warl(iregcsr, iselbase, iseloff, warl_val) ({	\
+	unsigned long old_val = 0, value = 0;			\
+	unsigned long flags;					\
+	local_irq_save(flags);					\
+	csr_write(CSR_ISELECT, iselbase + iseloff);		\
+	old_val = csr_read(iregcsr);				\
+	csr_write(iregcsr, warl_val);				\
+	value = csr_read(iregcsr);				\
+	csr_write(iregcsr, old_val);				\
+	local_irq_restore(flags);				\
+	value;							\
+})
+
+#endif

-- 
2.34.1


