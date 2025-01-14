Return-Path: <kvm+bounces-35468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95067A114BF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D224D1885DFA
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43EEA226183;
	Tue, 14 Jan 2025 22:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="w2fdmRb0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5D7225A25
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736895519; cv=none; b=OUH+w49zYLxN+JBSVxMvXg77ciLLli1Yt65JNgGvV6fLOVi8W5ku6kEhUD56wqDueIzahHk3ZfJqWd+gXrvn0Mhbn6K/azvrhMYjh+xMKV88N6cUDPrOAWmCoFAE7emEb5HY68u5q14wDY78Q/EOqyQXC/bl9CZo2RhTC5WvMxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736895519; c=relaxed/simple;
	bh=M17AKGnLSOGsyrsPp58PAylY7BhMnNO/WhD7kYk69x8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uhI4dCu3jM9tA7ZXBkl10f0OKpH1YbmL0wLPkxsjT8oDC5GSRatoqZygx68QEw936PVMKy8kiO+1E1mPmMiIm8rUTVXY/IdLcWpZu9AffyuASjiQ7OnVoXTfCxTEYWRJUw6yznkuw9pFWuZsGcFNuWRVpGAhs/KhDmgxFZx4PsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=w2fdmRb0; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-215770613dbso73960265ad.2
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1736895515; x=1737500315; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSUuZKac707LuCWRbpc/uEIITHPwqnfXyOde6qyF0KE=;
        b=w2fdmRb0Lu6O/+NCmizugEoN0b4vuHppXLbHX3zKiMlKvVgfqw4D5ocqt9mPMCxnYw
         Tb1TBRTlG2mZ/96iHmZNJZW/BvAj2DVsC6d2uUzapn1FjGRLeQJrK4AF8ZpNVCmFwjvG
         D9940gLMuewRCPwDUc/R3BR3IhrDpJdkfhWv/xjVdakwkZfKFxdHewYc/WOQf8tYAe7I
         tOWQ1IxNtusPbBC762pn5j2BGAJgAZAECssK5wxjEm02KjBOX1c2+UJeznb5mPAn3vMb
         pZB9UulZxhlZcE/zDzXawsLzGaZN2iF7GUbPxr740tmS9Qk3vRSWLlwqHFqqX/PfUI+V
         yZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736895515; x=1737500315;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSUuZKac707LuCWRbpc/uEIITHPwqnfXyOde6qyF0KE=;
        b=NS9ugyveUPQs/KOTQQ0JMdLToogPNiyMkzYkz4T2ESdIhraDWOd0wGrYTToRZcDBhc
         IbZYpvTecT1kPeTr+GCV98Eb+MfXC1uOs4o8I/Vlr3ynF+Vztr/7uNE12UxgQEbk1IzB
         hngRAWR/SxAInYsLwx62YtJJ4DQYEO0WO7Fr6YEdEvci59hp2zzLy8lK0oEfdzptt+ch
         MPE3oQBUqs45XX/sj1X9zczJGsT/FcqoksE3tns+Xetv8gNSTuiLQkkZviAxdtUlqLwB
         p80b/qisw5RyTiRRWo3O+uJ+OLgcs/VVW4BTW8pv1HUwB9uVE92WRP7sTQO1t9QFnBNQ
         U9Yg==
X-Forwarded-Encrypted: i=1; AJvYcCUOcr/onQsNHlUGZsx5Ov9AXhCNaHk0v6nSlngjBnIf1zkm3ZWtMZWefH2etYlHbdrciW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya9VEOYpfGUShnbmYksaOQZCZaFXKLKzKFJrMpv3qrADoPlLW/
	1Uw26zBWElHI1WybfQc/h5bUDSNa9m7lCsATHejqJjl+n4ufKq8WUAbd7cIkKnQ=
X-Gm-Gg: ASbGncvVFNGPRk5+pRGi8PAEpOGEGMHSV78+PAvtmfrYj5ATueLtXd0XkyUTEDb0wIL
	r0DgJiKVmhJbRlZ/Zmj3/IRNz+SseymerdvEPWkZlSDwSrBcGQ6SrLK46iRSbJqhHYQSgpyOlCM
	RIc365AOyYda8y0wkNaW3kofCaqP3drBN+BYtRGSAjSF0Ra8D2KH9F6iH3u/5ScaRGOb5C5uIKU
	6c1hTo0uhgNkLaJrUPq0yqgPlkwy8+IQmYK6+8ONsIsGGFFEZcfbORcxLEjhfx/YnDK4Q==
X-Google-Smtp-Source: AGHT+IEVXqMvOPJKvg7ygF7bUQZEZYrWqGn1DZ1M4rQTQIthH3shh5ppL8RzzhsKIbon/t/bsr22sw==
X-Received: by 2002:a17:903:41c3:b0:216:6590:d472 with SMTP id d9443c01a7336-21a83f4e4f8mr388644205ad.21.1736895515542;
        Tue, 14 Jan 2025 14:58:35 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f10df7asm71746105ad.47.2025.01.14.14.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 14:58:34 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Tue, 14 Jan 2025 14:57:35 -0800
Subject: [PATCH v2 10/21] dt-bindings: riscv: add Smcntrpmf ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250114-counter_delegation-v2-10-8ba74cdb851b@rivosinc.com>
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

Add the description for Smcntrpmf ISA extension

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index c8685fb1fb42..848354e3048f 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -135,6 +135,13 @@ properties:
 	    directlyi accessible in the supervisor mode. This extension depend
 	    on Sscsrind, Zihpm, Zicntr extensions.
 
+	- const: smcntrpmf
+	  description: |
+	    The standard Smcntrpmf supervisor-level extension for the machine mode
+	    to enable privilege mode filtering for cycle and instret counters.
+	    The Ssccfg extension depends on this as *cfg CSRs are available only
+	    if smcntrpmf is present.
+
         - const: smmpm
           description: |
             The standard Smmpm extension for M-mode pointer masking as

-- 
2.34.1


