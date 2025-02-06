Return-Path: <kvm+bounces-37439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DDDA2A226
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AC923A74D0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:27:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C0122DFAE;
	Thu,  6 Feb 2025 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ye+lZv22"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA1322D4C4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826611; cv=none; b=cEXv8gQpLXelOUKfiHL6xsGZbOM7UoLwXPhPMsDktgMg1Zv8DvScsdb0Wc+vh4lRD8B/wNYHRcdncLnZSNGbAx0fjm9Ky0iVkcGDIjK/nZr/lcLVh/mDY5im5cITxsYptOSFK7GfJY/LO3P85ZUsmZ4hKt+5dNc9V/mOu6GvWeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826611; c=relaxed/simple;
	bh=HHH1zghcNvQXpV5wj4QvWZZiP+q6wghkX5W0XvlVWCI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CKRCAFOmz96QREhYtqmilZYbQo9F0ZSmbEidQxDB3Ry5DddimITW8dd8aJbnieXN0vlCYlr4Sa8HJmysZ2fLaFw+wgudtNGfVSbrXwpLdLs5Ez9nen+pwDXa1PZrrBfU56Xld1xJqJRWav5UjRjDgKh1QXq+9aFfsSYt8WEAg38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=Ye+lZv22; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f833af7a09so772987a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826608; x=1739431408; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1ycQPnopfj+lIzIUm/dRgw4jBMxR4nO8n6QcQamF/g=;
        b=Ye+lZv22CEuz7dWWpIM2ZTiVPxBwpKOSbRhu00GGh0FjXLSnrV1OWsoeb/TkThAJHE
         mzMowQHjO5q5HfVMUoagdVA9p1XcydJydamHWhWB620LKqMTIJQ+AhfTKy2UADwiGJGt
         P/HR7nMFjVm26+xWm26fqiCd9mNez0A+3/SHWad/38+YqUhHcnsF9HbX79r26IqByUhE
         0ro2qvteimqhiK9Yl7D8YmDd2ld8AZc6zbvNu0+R9sCzQmiM0Gcq8NHrJEdXFXFbeAIk
         qfcJP0XAVge/Ev15fbEzxq9Iu8k5DSAU5+M+WH2L6vn/etiIlBTijZL/xgX/0/VQJDmZ
         Hbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826608; x=1739431408;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S1ycQPnopfj+lIzIUm/dRgw4jBMxR4nO8n6QcQamF/g=;
        b=jBHE8A6me5aUpBBSMfEbpouUR7rh2LDKjXGPc/cdtI1pEJHPWLdSyUSVD+T6AnbuZB
         18YO7aY0kDsJ5EWZcOHYdLpWIZTVlyl+Dp7wQH0TuW6drya0CwKeRuj1jWSDPmeLytqz
         JW37kVQbbsMupD86D5MXygpVBrwNuidzvIiaZJZ8igwdYiluw46i0GE7iiJfZw5qAW8p
         +oAVk26vg+YDfLk8qcOwk1KH1xslcFI1ICWacV3iYr6QujN4O82JWa2yQ+xDU+oFnkFj
         xBl7fuV6/vPOOZSZJhsUYpsTd+8urI3EgPyChiQh6ADhvvR/+zAC7MpzujmU8+rw5dM+
         Dfxw==
X-Forwarded-Encrypted: i=1; AJvYcCWeMermPDDgZyEoSTbjrEmSEhj+dPEBGiNzpIRcJMkQQiMP4Cp+HjW4Y+oBvY50UNewqj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKq5PzTU+ZgPyuqANyQnBjOqwve9cPfSWZ7lNWfz95jzSJD3Hc
	o6GkM9g+z1z8C2UAqRw8DUFvW0M9E7mtKJu+P1kqCEWtJAt1rcxVGr4vOv9nh1k=
X-Gm-Gg: ASbGncvPieEWve0hrACH4JAjgqkRSH28Ns99EV5uqwP8syEocAV9wnIs7cdbGAwq0Tb
	8uDgvVom8Ae7SyFdx+9bzAOvdLDtpVPpIId2A5NREsi2PaiQtXGh71LlQBWTtVCFaoVru0teZz9
	S4E5yTyV0SPOOUSsdjEG4HS7iHYmiFmvF4LTcrjwHJnydr9/VYII0fFeW+FzfDiXaofl9BxqCJm
	qlqOAgQmyzJkQP33PQrJ6NVw920GY6zhZpmVjIWGsmsoxWcT1faK6G0pB4QBmwWEeCrSGrLnGcO
	BdEdKvANW0J10JzRyIixYy9VKl2r
X-Google-Smtp-Source: AGHT+IFwe864GICHNnq9EVCYpLvbwfcMr9HibfAj+2D5yDDYG7ZeHAVPjVfRo7yQfH146FLB/di+WQ==
X-Received: by 2002:a17:90b:1d87:b0:2ee:edae:780 with SMTP id 98e67ed59e1d1-2f9e0793401mr10185856a91.15.1738826608431;
        Wed, 05 Feb 2025 23:23:28 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:28 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:13 -0800
Subject: [PATCH v4 08/21] RISC-V: Add Sscfg extension CSR definition
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-8-835cfa88e3b1@rivosinc.com>
References: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
In-Reply-To: <20250205-counter_delegation-v4-0-835cfa88e3b1@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>, Kaiwen Xue <kaiwenx@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

From: Kaiwen Xue <kaiwenx@rivosinc.com>

This adds the scountinhibit CSR definition and S-mode accessible hpmevent
bits defined by smcdeleg/ssccfg. scountinhibit allows S-mode to start/stop
counters directly from S-mode without invoking SBI calls to M-mode. It is
also used to figure out the counters delegated to S-mode by the M-mode as
well.

Signed-off-by: Kaiwen Xue <kaiwenx@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 2ad2d492e6b4..42b7f4f7ec0f 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -224,6 +224,31 @@
 #define SMSTATEEN0_HSENVCFG		(_ULL(1) << SMSTATEEN0_HSENVCFG_SHIFT)
 #define SMSTATEEN0_SSTATEEN0_SHIFT	63
 #define SMSTATEEN0_SSTATEEN0		(_ULL(1) << SMSTATEEN0_SSTATEEN0_SHIFT)
+/* HPMEVENT bits. These are accessible in S-mode via Smcdeleg/Ssccfg */
+#ifdef CONFIG_64BIT
+#define HPMEVENT_OF			(_UL(1) << 63)
+#define HPMEVENT_MINH			(_UL(1) << 62)
+#define HPMEVENT_SINH			(_UL(1) << 61)
+#define HPMEVENT_UINH			(_UL(1) << 60)
+#define HPMEVENT_VSINH			(_UL(1) << 59)
+#define HPMEVENT_VUINH			(_UL(1) << 58)
+#else
+#define HPMEVENTH_OF			(_ULL(1) << 31)
+#define HPMEVENTH_MINH			(_ULL(1) << 30)
+#define HPMEVENTH_SINH			(_ULL(1) << 29)
+#define HPMEVENTH_UINH			(_ULL(1) << 28)
+#define HPMEVENTH_VSINH			(_ULL(1) << 27)
+#define HPMEVENTH_VUINH			(_ULL(1) << 26)
+
+#define HPMEVENT_OF			(HPMEVENTH_OF << 32)
+#define HPMEVENT_MINH			(HPMEVENTH_MINH << 32)
+#define HPMEVENT_SINH			(HPMEVENTH_SINH << 32)
+#define HPMEVENT_UINH			(HPMEVENTH_UINH << 32)
+#define HPMEVENT_VSINH			(HPMEVENTH_VSINH << 32)
+#define HPMEVENT_VUINH			(HPMEVENTH_VUINH << 32)
+#endif
+
+#define SISELECT_SSCCFG_BASE		0x40
 
 /* mseccfg bits */
 #define MSECCFG_PMM			ENVCFG_PMM
@@ -305,6 +330,7 @@
 #define CSR_SCOUNTEREN		0x106
 #define CSR_SENVCFG		0x10a
 #define CSR_SSTATEEN0		0x10c
+#define CSR_SCOUNTINHIBIT	0x120
 #define CSR_SSCRATCH		0x140
 #define CSR_SEPC		0x141
 #define CSR_SCAUSE		0x142

-- 
2.43.0


