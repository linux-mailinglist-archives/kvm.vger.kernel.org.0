Return-Path: <kvm+bounces-37441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 045E9A2A229
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:28:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A1861888A6E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F48622F16C;
	Thu,  6 Feb 2025 07:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="sfuo5oMe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA5022E3E8
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826614; cv=none; b=jDg8rtJG2Qj+8ny83u5CpjStS/ePoFkVWlmRZa6yGc4Q3o4k+GtcwJfKry6WV9wpR8ixULn1IO7hioGmHs+pL1PvVxwrAiYgZyG2aEpAWICCxDtDS56idMStVAnR7ivPlh/PpIApTKm80Dl0R7wOgYXFohqCsBMZGY+DACCHsak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826614; c=relaxed/simple;
	bh=SZGcyybVo7K7BymyY7cT9hBPC2J7AQxoReUyWoh5bqE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jjzrfk3w6rTS9Vw470ERvLgJgVUnBVUQQr35q+FArCJXF91dImgPJUaz+441CPqbUe4ndkvmv0i3uFASks7BTmf38hWSOTdj15MboFPtZSWR8cCFvNUL1E3A05nWXaD/m12O0/peQZiK01jpxtROqwV6ip79Jb+Ivv4Xdw1Emlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=sfuo5oMe; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21f2cfd821eso10432105ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826612; x=1739431412; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bxHoYiVqgOBhm1wpVoVRMHPjl115bpEgggXMBP5Q3iA=;
        b=sfuo5oMe2mPuc6Qh0aH6nbYrt0D83ceFgFw1rJllq1fTqZ1AOctcDNf6i9QmBPANPE
         1fS9WQQ3PzNtZsyj8FhNfMdZHzFC5pemZhlm81BE22ha5y0+Y3As1uIK6sfQtumnV2q9
         Xi/c3TFuaEEXOmQKtwmh5ejHrfAyuWutNvEXC/yhCejxFfuW4NqG4C5Xcrg0uYyIB8/W
         oGB0e8u5A57HXyWkUFyDU1OxYo8ceTdyCIA0cZmK5eGlDwSM/1stNO44BVbYQW+gCyzt
         h+YQgpTnT/xl0H9xJHh7O0KLELYYRLiy7Tinotm/HvrBQxCAqsUNP9jVWtSv7liibayY
         zQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826612; x=1739431412;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxHoYiVqgOBhm1wpVoVRMHPjl115bpEgggXMBP5Q3iA=;
        b=eVR/eBXQFsnBlE3ncML0jyBk3RpunTnx7NKmp8Aln83nnq3AP+MGcQOxQyoCODnwQM
         SQXnsFFN4EL2yOqGDikKX7XSo51vHubrekF5MzacA+Z72JIC4RfVjm60C4WWPAoJm7+C
         yJ97EhEqtmDeTLuYWd9zX8pXqLzSiUBv+2e1xF2gewkmFFW8zPFxtOyt0pZplZd7He/l
         yHHvuYd0jp5RmpRp1/GzmS88Z0uRT5rAHOe2Xmez1KIuq32OuPAMWrYUtLGIiRor3Vhs
         diLanDREh/qLLdqyBckSol6GLbbXPAnaQinmH3GoRfflrBJSNdtEFjhVDqRn1PDUZQ0z
         XGhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR10fvfFZLB/YWZvbcK8/lm0K27V8lGcfunVKxlf04GQ7FHvbE0ruabHkeOju0qZRAa6s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLhB9tHu34TSuQNSBFcBgrHumxuLwTpGPjg6WfejvjAM/bJ4g+
	qzv4g+6n9uD6LP2fy5utmwnNhSpZ51RAT+EO93GaT34kac9f57yY1R+b9SAl+xE=
X-Gm-Gg: ASbGncsmz81etJwSlifNpP6aePhNGIc6hZQfunvYe0YsIVliQwiNKcaPj6+ljYiBZG/
	O3r5xMBdubsBdMij4KstbGkKCKLkY3K4Bb6Et0pwfN90n0BV2IPHVfbpyG+K4bxhJ4qTTWNq1sO
	leXA+MHfoOhWc7PqrFXTAjqecgYZyqhiEXZWXZcasWjQ7aMrhakjvEUZmUixAiyCWbFkEieQf84
	+yev8r+pjoMLePXz/NeALmiDWSdXLDUqPLNTFEWOa4+OF+sI+O7g6aenH3pjtero+Re1YA0h028
	SGBvcjKXpObdpY5sZpXL7XvS1pjr
X-Google-Smtp-Source: AGHT+IHdxb765FF/tuEHMIXniBEbzBGChueSqoBlXVwelYSzs5G+a6kTSb+Hcc24wmC4wtSYLVHKkg==
X-Received: by 2002:a17:902:f64b:b0:216:7c33:8994 with SMTP id d9443c01a7336-21f17f32366mr113621535ad.53.1738826611778;
        Wed, 05 Feb 2025 23:23:31 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:31 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:15 -0800
Subject: [PATCH v4 10/21] dt-bindings: riscv: add Counter delegation ISA
 extensions description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-10-835cfa88e3b1@rivosinc.com>
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
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-13183

Add description for the Smcdeleg/Ssccfg extension.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../devicetree/bindings/riscv/extensions.yaml      | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index be9ebe927a64..b20dc75457d2 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -128,6 +128,13 @@ properties:
             changes to interrupts as frozen at commit ccbddab ("Merge pull
             request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
 
+        - const: smcdeleg
+          description: |
+            The standard Smcdeleg supervisor-level extension for the machine mode
+            to delegate the hpmcounters to supvervisor mode so that they are
+            directlyi accessible in the supervisor mode as ratified in the
+            20240213 version of the privileged ISA specification.
+
         - const: smcsrind
           description: |
             The standard Smcsrind supervisor-level extension extends the
@@ -175,6 +182,14 @@ properties:
             behavioural changes to interrupts as frozen at commit ccbddab
             ("Merge pull request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
 
+        - const: ssccfg
+          description: |
+            The standard Ssccfg supervisor-level extension for configuring
+            the delegated hpmcounters to be accessible directly in supervisor
+            mode as ratified in the 20240213 version of the privileged ISA
+            specification. This extension depends on Sscsrind, Smcdeleg, Zihpm,
+            Zicntr extensions.
+
         - const: sscofpmf
           description: |
             The standard Sscofpmf supervisor-level extension for count overflow
@@ -685,6 +700,36 @@ properties:
         then:
           contains:
             const: zca
+      # Smcdeleg depends on Sscsrind, Zihpm, Zicntr
+      - If:
+          contains:
+            const: smcdeleg
+        then:
+          allOf:
+            - contains:
+                const: sscsrind
+            - contains:
+                const: zihpm
+            - contains:
+                const: zicntr
+      # Ssccfg depends on Smcdeleg, Sscsrind, Zihpm, Zicntr, Sscofpmf, Smcntrpmf
+      - If:
+          contains:
+            const: ssccfg
+        then:
+          allOf:
+            - contains:
+                const: smcdeleg
+            - contains:
+                const: sscsrind
+            - contains:
+                const: sscofpmf
+            - contains:
+                const: smcntrpmf
+            - contains:
+                const: zihpm
+            - contains:
+                const: zicntr
 
 allOf:
   # Zcf extension does not exist on rv64

-- 
2.43.0


