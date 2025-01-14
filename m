Return-Path: <kvm+bounces-35463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC45A11487
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FAD71693BA
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A51A22489E;
	Tue, 14 Jan 2025 22:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="z78hADgw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E420022332D
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895508; cv=none; b=VY55ahUoAvcLImPs2hKkmtwWZw60lmHSPafHaslilecY0Y0rq0PV288MQavfT1p8g0fSpPfGxuCpmRg+mBsQcstAdcM/Uj0uQoc6Icv7N9dwuLXsd7FVNkgTBRI+UTc+rfrQab9S95SxIhwCs2LoQ4CtcHHCk9uGw7XaLvV3C9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895508; c=relaxed/simple;
	bh=D68shKs21+kEnfY1w7KDWjYLipkuW9L+m2trlxew00o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DQOzrrIgnpmi8oLUeidq5Px5FxWlZXcWr/JFIxeSW+K7fmGlp6jrpVsgbh8tmSP3pHKai5/bNJSMn0/vrXJqbWONtAyyUfiTcFemSfDPYRciCp6qIsouSIvGJixOk6Ac53/ofImw8jUobFC2EJrSeAP0EwEpDruMjsSgfbK4/Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=z78hADgw; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2165448243fso131786475ad.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895506; x=1737500306; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vL7HY0dEKrWKEMn+BoWLtPifTt6hhf+Eo5KcPrG96mI=;
        b=z78hADgwLxpEusLbp9FSTWSftxZzaPHS1NF7ZfWr072TjVH0SdLlbOfVx7MIijmLLM
         ogXPDoQ/rwMg4wARGkG0nAX6XUMgy8sYDHxucujPQs+0LtzqPIKma38WSP2NhvPCMO7t
         lNhjZwjD/ih1b1g8EAvxV/AOZ/G5NwgXqBqfG06V8BkmFP+o8rwmpQzChLnWnmKED10Z
         8C0IJZmZp+cLFwathbbGp42nH3LrvzN+dKuAzdljdNAVYof29yH/Gdz+Fl6nB6jpa2ji
         76aVX952RPzzHmuifn0Fzk8GMtRmXF/tQ8LAjPYHxAbkDe86HRE8M95r4HUjBqw4CHXe
         KUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895506; x=1737500306;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vL7HY0dEKrWKEMn+BoWLtPifTt6hhf+Eo5KcPrG96mI=;
        b=XIR5Ab4iBKkXqj9JP2nWqIc4IaMJEvXdnsWKhj91NNdekYtH6sBqqgnQOEtYNslNP2
         a+hIIFbvy31EnugOFUigOGx0ZgfEAoMfyb1EZxFwEG8vY7mxUbBM2MFfr5m8Y4D6ijut
         3pN50FNVuPjljlCko1JpKfXk0HAKtcVYQSUqKsnMct9WfmH5taGO5T8JLkg9rLJBDb19
         WAqEsnmHiNjhgiRl89Cyz+O9qm4cvP2RzbuYRPNTtucTjvVwSiM2nLbP0+eSwqyvBAcN
         /6lIYAeqEqYad/fDRT7mpGdi4WIyGP6hPpGlG0FTe6sTj3BakIB1+Q9C6RRDi2vUVROH
         ZuQg==
X-Forwarded-Encrypted: i=1; AJvYcCXHG8C7tpC9c426Y8kDBXSsJC4l2h5aMWn3atNNWi182AAHF81KiBoof4HeEJgcIdAJwWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDpe8nb8UQ27lmdWjf4vSNbVajWudxF2lXdYg+lIWabHFTTq71
	h0UuPS14fngDOmmPgJ2SlyTF4JXIGKDBwVrQIwjriTcx/aHYIblCKmwdhzlDbLo=
X-Gm-Gg: ASbGnctcoD3deIvaeEz9YWUo99NmlHk9HW78jE4w/DWyCoXlPBuUX5i/CBgKDEkA6+W
	MdQP8dXvFThAeVkE8Yo0vCu7VAUbyZpy9RKaoBfOHvfywGiPvp72uFE0PiM1+cwxrvltnQ6CwHm
	y0vFSlRtBv549U+lmqPUqxFPECtreQO4y3yhhma7iwMTK1tqnKRa6ZVvRNWYYSg0oJDHKtLrSY3
	S01/Xshux7eDLe0cQKh+qGuKUs9dgRidq4iC7tQRpD18tReF45+KEo0uDFHBojbZZf6Xw==
X-Google-Smtp-Source: AGHT+IGcOgG1DqtPgRuq87OenfYeI7iqhHkrnix8fM+hMVbZ5ICFTggWxOV4+kwRFEcps2WSmP9bRg==
X-Received: by 2002:a17:902:f685:b0:216:7761:cc36 with SMTP id d9443c01a7336-21a83fe4b6fmr435625665ad.43.1736895506247;
        Tue, 14 Jan 2025 14:58:26 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:25 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:30 -0800
Subject: [PATCH v2 05/21] RISC-V: Define indirect CSR access helpers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-5-8ba74cdb851b@rivosinc.com>
References: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
In-Reply-To: <20250114-counter_delegation-v2-0-8ba74cdb851b@rivosinc.com>
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
 Palmer Dabbelt <palmer@sifive.com>, Conor Dooley <conor@kernel.org>, 
 devicetree@vger.kernel.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-perf-users@vger.kernel.org, Atish Patra <atishp@rivosinc.com>
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


