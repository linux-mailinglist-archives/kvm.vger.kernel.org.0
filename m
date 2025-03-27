Return-Path: <kvm+bounces-42146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D210A73EB7
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FACE177FC3
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F4722424D;
	Thu, 27 Mar 2025 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yTEHu07m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC68221D88
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104186; cv=none; b=cvP1GP4P5vDVhKmeWXHGlZ+U0O+1aWeY7skr2ywpIqbd7AefkndS8qEUcabI/2zddBeMk+aB6sgI7ryCGizLtIk50T1l5bw5SiGwBmCprSBbO2uMOfNxJSB+82oejBVg4vos8KiIDLtyjXhyf+qOtNxK8Cz7ezAUzg/zmZysJSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104186; c=relaxed/simple;
	bh=9uaw/3nWEEI8fpgn1mvfhY/n4by+EQ3cBzz4yrA1qGo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jGQOP5gUWZV9gPfyY6rmH+V2o2+eEFmUKAvn3mP+VhlidMaKOWveRQVCV7rBGs/tAbqAKN4NKKr//a1k10flgYD39yI2+H5dGWv8/jZgx7E3+PMAvkmus/7RtzMqrEd7ubJ6SqGGHE2k6j31ggQuNMzxp+r4Bkc9AvjtqnlvRAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yTEHu07m; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22409077c06so45829455ad.1
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1743104183; x=1743708983; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ywNrrIlqtPHHPtOnGWyS/tkdlFoi23/SobZTYSCzB4=;
        b=yTEHu07mGxawXyUUfyU6yCA6LPlzcf+P0c91+7E44jz2lA0Q21Jg+PPP4/DkznQEUF
         hBlBp8c1daOJtE71F0lZ1yQfg4MAqXZlifZDmOyuljRGiVNc8egME619go329vBjaTGY
         Sok9FM5xOGH8GtoSrgS1lVwCyR8fhn/xUDo5sLbtnDW72dmskNWxzSa1whjVnjLiqZAJ
         Jp0rgEKBTTTdNbIrG/qL28ttvPX5DnUW2Zve/hK6ZDcBZ1DJgow51cx2aMum9SsJkyPt
         RR9JySJlRKe0WFn8amGmOhqPLstDPFUjdaPb7idFE4dU4VhnOlr72Fx71Zohqehzp5Ws
         K7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104183; x=1743708983;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ywNrrIlqtPHHPtOnGWyS/tkdlFoi23/SobZTYSCzB4=;
        b=qwzh/0lGnI7E0kPymTkrlmtOrOI68QburDVxUpglfic+a2DqZSzhgqhLv55fI4sWiF
         MideU9E3rjRr6qsIXVW35WVwNlxcMuA7oc8rqQb3JfjQuU0AJCHtgxKHbLbL9WI2uzck
         TtE4IpjfSDBdk69qqeeRMRjaO6gJRNFN+nry6BckQQ7JseGQCQfKOwES6AJzRzkYXADm
         ijNoovG5jS6zc+qWYIoUgbJ0mBLmw8Pi+qes0HY1UiNaFF3gK6qKzPtwJNBvivcbo16D
         oPAKOgVuPMFSi868CesFSSFCBelO+sCnH9bJR0D82SsId/PZ/vgncaORhonre7f7KEdx
         mPyA==
X-Forwarded-Encrypted: i=1; AJvYcCWGF0LBry+HQEfwWSUz5aq2fCP/eNcrneD3Afr3TG3Z7Osj5ePyb4pfuOSlCCHU0fmKX1M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzlZ+EPmfnaZRZyMBbSdbobyHTiwMNkxNjdd38QCprpNrwbP6T
	wXbbL2IbTZsZJvbPd0BEdDIq6MrRlqZzddnCBodvgDdrLkRMo34YRVav2hMHj8o=
X-Gm-Gg: ASbGnctrukVuRP4tVxMkmZh+w4BMx+ScWSQ5jgZcsJjas+DsuQthU+cQrAW7lWjFFyd
	eRdV1apuVt6H4qelRK5HVaitLKqxTVf6JWAJH23WgNPd+9g91aSpRaeCDi/P/LsD9BypeiNg+Ca
	A+kU2sRtYkKKiZesZIq+wgt46oD9yMAhJpr5UpArg57QkubeUJjbu88Ob0Tce29wKT5JB4dDxpo
	upMEQ37ff/gamX1CDrRW93001swOkMeaOn3rrigi+6CzrSNHRZ+yQSx1JcbkTpvKpYstnlE1nhq
	bG+XeHluzoRfyKTbHsiyLQhTLteLWHHYVmq5lf4L4y7zXh9C5O0ZKbq1Ew==
X-Google-Smtp-Source: AGHT+IELdinWh4rp6i4iXWGA5H/t+4IAyyZGzK+iwJMmKFoXazqziiKFSDj1cayIDmLBdm814eH0Qg==
X-Received: by 2002:a17:90b:5686:b0:2fe:a545:4c85 with SMTP id 98e67ed59e1d1-303a906c678mr7028440a91.27.1743104183029;
        Thu, 27 Mar 2025 12:36:23 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3039f6b638csm2624220a91.44.2025.03.27.12.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 12:36:22 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 27 Mar 2025 12:35:48 -0700
Subject: [PATCH v5 07/21] dt-bindings: riscv: add Smcntrpmf ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-counter_delegation-v5-7-1ee538468d1b@rivosinc.com>
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

Add the description for Smcntrpmf ISA extension

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 0520a9d8b1cd..c2025949295f 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -136,6 +136,12 @@ properties:
             mechanism in M-mode as ratified in the 20240326 version of the
             privileged ISA specification.
 
+        - const: smcntrpmf
+          description: |
+            The standard Smcntrpmf supervisor-level extension for the machine mode
+            to enable privilege mode filtering for cycle and instret counters as
+            ratified in the 20240326 version of the privileged ISA specification.
+
         - const: smmpm
           description: |
             The standard Smmpm extension for M-mode pointer masking as

-- 
2.43.0


