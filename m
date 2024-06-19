Return-Path: <kvm+bounces-19970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C4090E9CB
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5E5828904E
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE46E15381C;
	Wed, 19 Jun 2024 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="wUUzwOEC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4C41386C9
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796957; cv=none; b=hKCsiZfJgHtHWFRjf/H2czTfCosCjaW9jVOK/N4kPmmbR4c21U4T4L08siVH5fFkdCdJkt9seV7QgpBZ33uTQ0rglGKc0YXANN87eHCH7pUb2F5hMQsc/p3vOJWySMLPsVad7E/duABEtMzQ7HJUgoOS5grrnigFGGRTgg8BiTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796957; c=relaxed/simple;
	bh=CrKAOy7k0+pjuu86NYcz9soXvE3vBpfFpNBDnQzttWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CtFXj3BmY9VTQbQzaGSSovK9IdEKQQxGPcOWH1xkcDzsJPuiDtnl1EnQWox87J4XTeIkk+VucKZhKMdTDAWjKI/cieL2rr2HnXLHatk1r6P9d2f0Of1KFE378l03owG60pImizKDDoKoWep6tEoIfxw3qXjKBeH+oJTTXnrQADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=wUUzwOEC; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ec18643661so5916151fa.0
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1718796954; x=1719401754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Sy3W3sT66nFUHkOIAcy9zXa+nQEQXWEM2cv9eUy8eQ=;
        b=wUUzwOECPCVwh3p5FPioz4zaoVQNYZEcklpIGHuphPAxznlyaYIQcrB8YC2Q9wxm5K
         XShXtspD4i4k9ZgpO0WD1O4ySWYecCMV5azMIGGzIVVqlcv3QLBoXu3ehlzG53igPmKG
         75TlGhDlBw6DULADG4Y2u9o7aNHIJYJx0PxxtDes9aToDpa8nrZo2kznNzkEhhZv9XaJ
         r88yWRPsPwSh+wCm/CMq8RK8g25wjQopxG5D0wvfQesGsDNmgPVuun7jJ+ydizP4cWni
         K7zgjQjMxpUAfLpsDGiVwwpkSjXFAaUS2Q1HYXKpysfNcKISwmLaSsZuM5ZOnaCxcc8N
         AIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796954; x=1719401754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Sy3W3sT66nFUHkOIAcy9zXa+nQEQXWEM2cv9eUy8eQ=;
        b=eVOamom3PoaYaGrVHUnbJv/a3NUGAnv3DOoWOnFS5j8l40y1ERh9LU8DUVUv2LQ4fi
         8wT/Agdc0u+eQjZW5Ug2FS5kcydb806gZyRrp1Rse/EEmxF+hrJWruDvkftkyfjUb1CL
         +qCsPd775fhO6gPHiEE6++XhkSSRqo2pkOGrcrM7LoslgoWn/iW8vZZl/Hrrl4PN39ue
         bDX/ufIZJINZThX/AQZhBOrNRaf7eF+PxoQKr2PE23vq6g9cP/WEl/YuiPwdjV4yj7D4
         1RGy1JPHliFC9sZgHXqMF+BHcKfHnSYYh/gSy7i3e3vtDPN8sqesEKydlr8D5npI6hKD
         WIvw==
X-Forwarded-Encrypted: i=1; AJvYcCWjpHKFkLIe3lmW4u63HTvqiV5MbeOtNy9ePbTJoKyIPJF7n5AA0x4nImemQJKtoq89BBNLLBfx/pdoYspoVCYiD9P2
X-Gm-Message-State: AOJu0Yw09iUeeY16RFDzEsTeRgbbmKMiLg6Rq+xlAdtmSQDpBe3QlJFC
	ak9Z11ZubAHZ+4ZViRsSlaxmwXtFuUFUhYzqJEKGc+h/jOLhq+SVqumgI2H0OI4=
X-Google-Smtp-Source: AGHT+IFRciAFte3oPxe/TYNtXAvR1m3s7pGZfdqa/xJwJUVeVl2PdQBNkhgvRY1kSbpJQmQp281hYw==
X-Received: by 2002:a05:6512:b22:b0:52c:cd07:37b6 with SMTP id 2adb3069b0e04-52ccd0738b3mr880416e87.1.1718796954087;
        Wed, 19 Jun 2024 04:35:54 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:e67b:7ea9:5658:701a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422870e9681sm266192075e9.28.2024.06.19.04.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:35:52 -0700 (PDT)
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
	linux-kselftest@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v7 12/16] dt-bindings: riscv: add Zcmop ISA extension description
Date: Wed, 19 Jun 2024 13:35:22 +0200
Message-ID: <20240619113529.676940-13-cleger@rivosinc.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619113529.676940-1-cleger@rivosinc.com>
References: <20240619113529.676940-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add description for the Zcmop (Compressed May-Be-Operations) ISA
extension which was ratified in commit c732a4f39a4c ("Zcmop is
ratified/1.0") of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
 .../devicetree/bindings/riscv/extensions.yaml        | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index e34d06633278..33f1a86efed8 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -252,6 +252,11 @@ properties:
             merged in the riscv-isa-manual by commit dbc79cf28a2 ("Initial seed
             of zc.adoc to src tree.").
 
+        - const: zcmop
+          description:
+            The standard Zcmop extension version 1.0, as ratified in commit
+            c732a4f39a4 ("Zcmop is ratified/1.0") of the riscv-isa-manual.
+
         - const: zfa
           description:
             The standard Zfa extension for additional floating point
@@ -579,6 +584,13 @@ properties:
                 const: zca
             - contains:
                 const: f
+      # Zcmop depends on Zca
+      - if:
+          contains:
+            const: zcmop
+        then:
+          contains:
+            const: zca
 
 allOf:
   # Zcf extension does not exist on rv64
-- 
2.45.2


