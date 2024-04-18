Return-Path: <kvm+bounces-15074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 279ED8A9A0E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 14:44:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A12D1C21C26
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E6415FD07;
	Thu, 18 Apr 2024 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="2zNrumNW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6AD147C60
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 12:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713444239; cv=none; b=G7WlCcdN1FdkFNI2TIAHUsgID2N1WWWk1jzV9doWzZ9U0aSiwBgOxR76VIdlhyxK9zDhDyz7AgcB9OoPX2ARXruoiBkZrBmrbuVwzOcNOeA/aotRmSs01y3gJL/WKYuNPHTA3Ik2EdYM3e4XDmhGYK1tvo3ZBSj378qkL+1HQGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713444239; c=relaxed/simple;
	bh=keUOTcQpJ+9Spm7ZO1wTme35teQ5D7BlxcLl00vQb1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o93U81DAPK5jgd+dOiMQJSsWoWNaGyV3OZoifQIbi/EAEd+CtAO1zobI6gRlNy9CxAQWJ0l2Wk/yLcvq1/uLWobXE3KuvmnOSIvLieu6nlex/dQMT5+O4OYKhbKxuwBR+3NwLEDYvIo/9Z+Xtu2+vnoLiJFzNBVWfhuAU3ojEe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=2zNrumNW; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-347c6d6fc02so116278f8f.1
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 05:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713444235; x=1714049035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrjU6l9W7DikYIaMYJG/SdZ2oUTcGtwCnDHe7Ekc7IE=;
        b=2zNrumNWxQWNhSEDA3BqSlQilsh7yLZQ9sMPLJTdL10wRRSJCJ2YKL1Ua8ePsJnwCe
         csUNqMEtEnX5kOfXu9TjBCAhYce9No9hJ/qKIMsUZj/nHoRz0xvNEtFUAsM+CnAmiKVD
         JjmLVjoJ5k50Rgi3rDs5tprdOQgVeMyOe05qCYkUT6tPBPYS567NYUn3qqZ3vjlf/0XJ
         vuECuSqUrQKfX89j21oipCASHFXsorpxKGST2JPaTJIb+chzySvpq8SCIi6i9EFQwKf9
         BjGuyw4PxWG2EcKOU4o0KfDXNDeSUKjXSx+VdcfPrt1cTYfu0dQuA1gQxGOu6Wz6Uuyk
         XokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713444235; x=1714049035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zrjU6l9W7DikYIaMYJG/SdZ2oUTcGtwCnDHe7Ekc7IE=;
        b=WTVXaQPwYX09Zq2J7IKktltZiB1KMtf5H7KW5wio8pNXgpYoh1qX1oGqmzYdcwomcL
         XkmED7O6H3n+aOYQn5hpKcZgqYj5XL4Mgtn19tykxWSAYWor3orQb6JOie/6d1DEyQRU
         bdgmQ8dlUxL97Z411lezxgmKsppxF4lFofHRyM2CFG94kHMNhroAmIFIfkHI4GlFc7yY
         /5KgTe0Hv4F+KiSQY4AyFKRsvYQC/BJS0eoHcd9fZxeXSUDkYHZUOHp76w+eKSh3NRvD
         nGO5UD4B75ZKRmpCFeJ8H2fKM29VY3NWzUyhYUwd2TxEY+EZP0m+9OxCH51zTY25UYe7
         iQlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWT7dJFHbp5SW8shsXwSRiw24t83znzM3whCLdFRiblz1ByHtc0U+AbRMY6KgJRSUkKewR4n28jNlV/RV7pDMSs10m5
X-Gm-Message-State: AOJu0YwllWyaH7/XSPQXv0N3R5vQKc0+4BS0rsD7NHkHBqycc6b7qZdw
	eFGJqO6v0fXzS0ZwJFkut5K4lXCq3L6lIY6PFAXbcn6sPRG7WflWUytQJMpRyUs=
X-Google-Smtp-Source: AGHT+IFFx4DMJCN/eGlinw4D8WxSb2s5Led6zbc0ypunbHRPKVqfx9J88kY5VuS8nvJuPPTEq99jAg==
X-Received: by 2002:a05:600c:55d7:b0:418:ef65:4b5f with SMTP id jq23-20020a05600c55d700b00418ef654b5fmr805438wmb.3.1713444235113;
        Thu, 18 Apr 2024 05:43:55 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:7b64:4d1d:16d8:e38b])
        by smtp.gmail.com with ESMTPSA id bi18-20020a05600c3d9200b00418d5b16fa2sm3373412wmb.30.2024.04.18.05.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 05:43:54 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Anup Patel <anup@brainfault.org>,
	Shuah Khan <shuah@kernel.org>
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@atishpatra.org>,
	linux-doc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 01/12] dt-bindings: riscv: add Zca, Zcf, Zcd and Zcb ISA extension description
Date: Thu, 18 Apr 2024 14:42:24 +0200
Message-ID: <20240418124300.1387978-2-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240418124300.1387978-1-cleger@rivosinc.com>
References: <20240418124300.1387978-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add description for Zca, Zcf, Zcd and Zcb extensions which are part the
Zc* standard extensions for code size reduction. Additional validation
rules are added since Zcb depends on Zca, Zcf, depends on Zca and F, Zcd
depends on Zca and D and finally, Zcf can not be present on rv64.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 .../devicetree/bindings/riscv/extensions.yaml | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 616370318a66..db7daf22b863 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -220,6 +220,38 @@ properties:
             instructions as ratified at commit 6d33919 ("Merge pull request #158
             from hirooih/clmul-fix-loop-end-condition") of riscv-bitmanip.
 
+        - const: zca
+          description: |
+            The Zca extension part of Zc* standard extensions for code size
+            reduction, as ratified in commit 8be3419c1c0 ("Zcf doesn't exist on
+            RV64 as it contains no instructions") of riscv-code-size-reduction,
+            merged in the riscv-isa-manual by commit dbc79cf28a2 ("Initial seed
+            of zc.adoc to src tree.").
+
+        - const: zcb
+          description: |
+            The Zcb extension part of Zc* standard extensions for code size
+            reduction, as ratified in commit 8be3419c1c0 ("Zcf doesn't exist on
+            RV64 as it contains no instructions") of riscv-code-size-reduction,
+            merged in the riscv-isa-manual by commit dbc79cf28a2 ("Initial seed
+            of zc.adoc to src tree.").
+
+        - const: zcd
+          description: |
+            The Zcd extension part of Zc* standard extensions for code size
+            reduction, as ratified in commit 8be3419c1c0 ("Zcf doesn't exist on
+            RV64 as it contains no instructions") of riscv-code-size-reduction,
+            merged in the riscv-isa-manual by commit dbc79cf28a2 ("Initial seed
+            of zc.adoc to src tree.").
+
+        - const: zcf
+          description: |
+            The Zcf extension part of Zc* standard extensions for code size
+            reduction, as ratified in commit 8be3419c1c0 ("Zcf doesn't exist on
+            RV64 as it contains no instructions") of riscv-code-size-reduction,
+            merged in the riscv-isa-manual by commit dbc79cf28a2 ("Initial seed
+            of zc.adoc to src tree.").
+
         - const: zfa
           description:
             The standard Zfa extension for additional floating point
@@ -489,5 +521,51 @@ properties:
             Registers in the AX45MP datasheet.
             https://www.andestech.com/wp-content/uploads/AX45MP-1C-Rev.-5.0.0-Datasheet.pdf
 
+    allOf:
+      # Zcb depends on Zca
+      - if:
+          contains:
+            const: zcb
+        then:
+          contains:
+            const: zca
+      # Zcd depends on Zca and D
+      - if:
+          contains:
+            const: zcd
+        then:
+          allOf:
+            - contains:
+                const: zca
+            - contains:
+                const: d
+      # Zcf depends on Zca and F
+      - if:
+          contains:
+            const: zcf
+        then:
+          allOf:
+            - contains:
+                const: zca
+            - contains:
+                const: f
+
+allOf:
+  # Zcf extension does not exists on rv64
+  - if:
+      properties:
+        riscv,isa-extensions:
+          contains:
+            const: zcf
+        riscv,isa-base:
+          contains:
+            const: rv64i
+    then:
+      properties:
+        riscv,isa-extensions:
+          not:
+            contains:
+              const: zcf
+
 additionalProperties: true
 ...
-- 
2.43.0


