Return-Path: <kvm+bounces-42149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C33E1A73EC1
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14F67173B7E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3346422D7B3;
	Thu, 27 Mar 2025 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="mc+RteOD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944DE227EBF
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104190; cv=none; b=AzqPcU+E8orK2AdTF2Pkcx3QRkDDkD7Y/Vfkbet5wjIThAdEv00+t1pvFQWvfNYMLVrmZ8cLnrGaQe6c+f6uPYkip4XYJnN67KhQ4cvIdIxfVHIz92/cZmIRSF9rRBdH6Jyh2gux/oFjqyGcS4ed/i6iGuoqphOMHfyDrG7Dccg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104190; c=relaxed/simple;
	bh=EkNrWyE7gZuhyFfs0t3q1tgbnM9o2fsa3xwOomvHUnc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LCUgnENVHPGnU1ulHjveGIKMAHFbIeFAnd7Gtsjhv5dj0hmSTyUckihkuO54lb0RcKEQndSlzVzUGSLuAApqOb77If918tM6wZckArph/3LeeQCMDpdJg8W5xjreSDYtMGVV/eMu22YlEJ/cTswFEhXxttCmTyvRjMyajrwxqKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=mc+RteOD; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22548a28d0cso40640665ad.3
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104188; x=1743708988; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s83Mk6RgxI6aiEowidkzKeBlKABMqOiz10QGBc1rI7A=;
        b=mc+RteODRCSeVrFarz3JsKoIhHa5q1wdakkeM3mJFVy3oA8lvmcyfMRbWnp37Kdn0X
         7QChlqsQiT95iZE/DcfgKcyNN0mrTdGjexYGdQD9L+ZrkeeAvnAFNCUY7BhJVva05x9Z
         ZzzrKdFib7vOyhDiaezS9+5s6gfJJs4tp0Mi0Qc6hX5Z82gy058M9aB07jEgY21F2W6a
         Sd69gM4Lxm2hfIHmLsl1zP1q/4lcRG66dfoSNm3F6k/f5cJly3YeOG7keSxnB8FS+ghj
         K4HhA9/TrQjkAUArW6J0T61kRKEob9C78kyR9Qw6GKJvOXCjFgmZS5DeedCwv6A5N8kI
         u/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104188; x=1743708988;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s83Mk6RgxI6aiEowidkzKeBlKABMqOiz10QGBc1rI7A=;
        b=sOEJ0J39tkx28hFLtYX+Y5w7K85OTrm2gYor7UzZcKMxV/Mf82Tfg+m4hgv9bTQ4SM
         eahZZC67kIAo2ylULokaj7uGZOyicxppqSOBi21o/esASmMI0xhZ+WiyOS+8BLwB3mUO
         XYHsb1CFVGXb6xFJ2qyiVKsksCu9bfoKecU9Yk052tyAnQ4xXakrOQxhZSgdmiaNhi2y
         ZwpFtdrxUc5tc88lw7BPARqM0Nij4QSvmq5G6uf0h7VC3OkehZkOg6rRS+fTk1n5YF2C
         nK4KfP7VflbL9b91XGP0vZzBqUd4dNZmXnAG31jikBkLxiHIXecYHB9sr5pOPQx8s2DV
         bLvA==
X-Forwarded-Encrypted: i=1; AJvYcCW9HlWzL5s8MLgrkCpPDNq6ySwLKS6c4epgnUxjCJU1EGNwxyBRYlSlFP3LQjt/KxlKGFk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/jbQxDMUjC1/hKQbzPZvJdrS1Y+YS3FkrQj2/SST4ArVDhcyB
	t4N38bjoQ66HXmt1n2whh+uzwE8TfqcS43LjsJy2XQxxdmOoxoNa2ai/QlyJSN0=
X-Gm-Gg: ASbGncuUDBd6q4Gzhay7nBo7zSlMYXsoM5ewdKIPng95Y9lm9ilnFF9Cpg6rFBlXLVY
	JWLnK25GERIgkJ6zy8FDn3usScidXXzig3AfuZG1ZurksqcKgx4t7NBYzKL3XrX4VqbzCQ8HJfT
	qxy7/qgHW6v3hzEJ3XrugZeUEaleKqrp7oOISIIU6f4CwiabqvOU8u/M4H54qBLH3CeUhAAPaMA
	CPVcSfp+LVlRZCu+PBBM5CxfXlq8KN858OelfSIOiqgxB83OYpJluOQkqacY96IEojp0bUUIxKy
	49gQ8kgQO086baNZ7K1xIQN3n0SqlspCGwJLlAGCPExenw+yh4oWeV/asw==
X-Google-Smtp-Source: AGHT+IHcFi2A17uZl//MFCIpfjuKn+EFOYp/l4E4mHRTjmt5boV1yhfvP5TVOYsG92qRlQyi5Fyr8Q==
X-Received: by 2002:a17:902:db0a:b0:220:f59b:6e6 with SMTP id d9443c01a7336-228047fbe38mr65571275ad.8.1743104187938;
        Thu, 27 Mar 2025 12:36:27 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:27 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:51 -0700
Subject: [PATCH v5 10/21] dt-bindings: riscv: add Counter delegation ISA
 extensions description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-counter_delegation-v5-10-1ee538468d1b@rivosinc.com>
References: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
In-Reply-To: <20250327-counter_delegation-v5-0-1ee538468d1b@rivosinc.com>
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
X-Mailer: b4 0.15-dev-42535

Add description for the Smcdeleg/Ssccfg extension.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../devicetree/bindings/riscv/extensions.yaml      | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index c2025949295f..f34bc66940c0 100644
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
@@ -695,6 +710,36 @@ properties:
         then:
           contains:
             const: zca
+      # Smcdeleg depends on Sscsrind, Zihpm, Zicntr
+      - if:
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
+      - if:
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


