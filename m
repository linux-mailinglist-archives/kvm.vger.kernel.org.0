Return-Path: <kvm+bounces-37438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B32D1A2A221
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 08:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7F48188677F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 07:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829D622DF82;
	Thu,  6 Feb 2025 07:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="SB2rQw4N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DA022B5A1
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 07:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826609; cv=none; b=QFIk50SwU/y+4yiZDmPsKIv4QkD6DITyH5Xsevtr38Emc4eWsQX09Ngu9fsbkezuvu0BV6WpYrabSGjgLr8ofHeBgfUDaVfoeMT4sYwGXOGIJUfdwhIgz4RDrQXgGLrGoQShjKYxEkI983KWgxpyUEhTuCQLeHEGBsV2rDgBtrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826609; c=relaxed/simple;
	bh=YU98hLOSiq4vVYKNXLYyYXjb/N8ZYLqR11qx50WHeNE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JAQL+NXeKFsnYM9dRhcUX6wbru7Hy5J99E9aE6WvhNtstPtAASektFFmJ+1/+Q1XdZ++/XJdt8vvQksC+ZCF9TkIzC9DHc5M5VyKCgsv4BY2zHbGiMNNC3fY7RNPGURzrIePJ//nbuTtmfuy3naUI26kywGPxgTVWfPXj+LrI0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=SB2rQw4N; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f833af7a09so772959a91.2
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 23:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1738826607; x=1739431407; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d05MBVkD267pj0+O4130zpeTcKFWk4W9qDVXtG5klp0=;
        b=SB2rQw4NVuE78iGw0lPH6MPeT0z2tL1md4Lfy70fAXDPl0GZEKVFTlWDnG7O92nHoB
         6Pt88DOx83fddLI4RymBfClnnbQp+bD4HU+dhmM+/kPtjo+4YvP1s9S6ZSsFnNciArvI
         Ox5nbygNdGYX86dLtP1MZRVDWqWinMrs9S4XryUEJDnqpMrATmIi69wsaVuiIdJ5HRR1
         qQRKflVrGgzvlVsEXPwTkpSlaL1pxSPy9LXhuOVY00ln/0ER3D1rTq13+b+znKAQUkRR
         ARFENvkA3A3n8p9l+Uw5R9lHsiTDzEsdMfvz0V/hzN88BSkMznNBmEng8AHDV5SKZ2uS
         Tjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738826607; x=1739431407;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d05MBVkD267pj0+O4130zpeTcKFWk4W9qDVXtG5klp0=;
        b=RLEvX1LJCifWBV7EvPOcHHy9iqqJvFcH7DsZJS+10HRCqTc4VOlHDcppE4XHL4o187
         0cIGR8Dhk42MMm9pkKjZXdH6wCwBDUfKJ/O7UdE+MqshJMx0Eq0sVAq8LFtnkXsmd2lc
         pafqJLlmh3ci99qP4Y1pjluSLW+PeRDZuAHOpB+Pjs3WG81dDMrPpVhoPmA9+egzmsGZ
         d/8YwZbepPGKWnD3YNJ+k061ihfP1xXHWEC3sCeyj75LAvjtT7mIGIJ4PeH6R9NDkLnq
         3M4hJbqzxCRkKF+lTnIbdhMxOOjQ+T1BOzsweYzBvGT4WSAQbS0ViV+GmWAOKajXZPMK
         QCGA==
X-Forwarded-Encrypted: i=1; AJvYcCVE061nVJAg/5gw5w6wokIviFXyzcNkdBVG8WiHjQaDLdRQTHZiBVhTr+yoJlOgXklsUM8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLu3xNbuOBZKH1QLaSn0KdZW3W9Poy3wrygYDszLEtSS/qoXsL
	rtHPeip1Yxf/hbxkIzxnf6NAqkcZ7DefqVFnY3/VnBIoIZn+akh4wUhKP/XcY9Y=
X-Gm-Gg: ASbGncvPfLx/m7xFZzqY6dOpLpzlCrCZvR72IIh5h0JkyCzvwmZ4/YPCaZu0iuUr5ib
	f2EODPDQQnHdd3Y1mr9V6wU8UX1KACMML8vC98Cakkat3pitcU+FWen93ddO5yHdNrn9LCD2GzM
	VZSQodToqOyWGPEXmLos9XdAgPl5LtGnnxNeIEWye4D0EUMitOo8P+b789y60GX0bh2YibVkXFN
	CwQiPYYuHDG/KsNVSwoa1p9T153aQGJ9U0Jy/lmlPY1+0LimFkhmBhjEjkVlI1Vi4HJ7DiqSYXq
	2093sz17O155SsXFZ14rLixu0lWt
X-Google-Smtp-Source: AGHT+IFKe2kQczxclY80PslHuvYzWPmjNnKAp1q2ypYQZ9arePKPx5YXWSLFOApkuW37i5EznoN6cQ==
X-Received: by 2002:a17:90a:d410:b0:2ee:cd83:8fe7 with SMTP id 98e67ed59e1d1-2f9e08682a8mr9427110a91.35.1738826606814;
        Wed, 05 Feb 2025 23:23:26 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fa09a72292sm630883a91.27.2025.02.05.23.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 23:23:26 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
Date: Wed, 05 Feb 2025 23:23:12 -0800
Subject: [PATCH v4 07/21] dt-bindings: riscv: add Smcntrpmf ISA extension
 description
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250205-counter_delegation-v4-7-835cfa88e3b1@rivosinc.com>
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

Add the description for Smcntrpmf ISA extension

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 42e2494b126d..be9ebe927a64 100644
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


