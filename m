Return-Path: <kvm+bounces-14101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE37389EE72
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E116E1C21210
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A439D15ECF1;
	Wed, 10 Apr 2024 09:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="nKaDTPkY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6A915DBA5
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 09:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712740282; cv=none; b=BjVtIiQ/IFbTFeEGf53eiLyjs20Ax30CPNbkB5xdyI0ZShXfyQQv7oq1AgPh5srvW7wjDucI1ZTsKNyIZpILlRk87RKR7JV+Is0IDTSJ8xYwsQL9pKO3KgL55WUpiYvrzzQGzR+e2Dvk3X+DMXOPDCVFSzpjmWi/CqFgzZkIUgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712740282; c=relaxed/simple;
	bh=7TJa65aVZsIDvLrvGp9e3paZD0UGS+Da2Fbvkii8Emw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bkSObY4EuQWIYolIDaPmCtMtRgW/E0CRumYQC6p+0VxYEIeZDJpRZlsbjmEnTHFV1Cx0Y5tirnCKaUumHfzkinFSu5zvnRa7P6BMGD//T2j4LXJ3D/DYdjrdxUWE/cSaNVeLkluD6/Eob4bkESnxZFqoyR9LV4wKfLt0Otyy4xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=nKaDTPkY; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-516d585c60bso1576401e87.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 02:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712740278; x=1713345078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t15PVccKugGeH48k2RjHxzRDqhwHnpwL852aH0G35EQ=;
        b=nKaDTPkY6MlAhfIM77n7fpW1iMGvr31pUchaJ9U9st8VEZ5rz2q6PWYjdAXELuYs3s
         lehD2Ra4DK+kuhHSX8aMR9AOk9eahrD4PI/EcNkj9XDgqQxSfw/+hU6kDZCMV8wpxV+G
         VKwpO1Fv5hdpgW/8Np62S2NqQnOcKwPgzBygqdgv0V5dhvUQwiunP0efmvKPBTnmigUP
         OYnlOwy0yR0GMbyP8OEiOgfK7L/bPulmRFGsWlHs/xu31ukdXJGh9tya2b452pKZH4dQ
         RkOvgHYJSyEkSt5J9tz97ODRXBsh/74ukF/3DgmeajSTPA0lzZDI4mIDJs5MoTBPVwpg
         +jEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712740278; x=1713345078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t15PVccKugGeH48k2RjHxzRDqhwHnpwL852aH0G35EQ=;
        b=XNHgZt4+C3gND511ZoIe2ujvdDMpaST+Y+b2MRtGdIIr7qC7K0W6DIZ9C6fEcf5KpQ
         uf0ZFUU9q3nlq0vYZ5KT9fC5M1ixUwHCmQs+uC8trdWDuGQmrOiQpUXip10cQehpsQoq
         bmYPymztyM0kJbcLMrVqk7WOEE/j3V7b+1T8VicUo7dNutrgPAUgItZMIGz885VSjlE3
         xxgWy01YpZa2AsIc3ltjAd58VzvShjV001gXgf3C0g3zL9d5/3XTq5V980eAh3Qk3otc
         oIQCBkQFdXkfmsmf/Os7mYKJH85n1oSvljIIree0Qga7ll1h4w7oVbPpUuZADq21PXyP
         J2HQ==
X-Forwarded-Encrypted: i=1; AJvYcCWurwG/bEcXaC+4ify4qVu5EjndrorCE7pdh9gZuZ3Fwh7PSwLdV5a9TlXkUqWrYs6ULhMGEo7zHe2IOVYKXmGMqn23
X-Gm-Message-State: AOJu0Yye46I/UlP3Lqedj4exS4WETMmlPNAcGBIDvs9JhmHMLt2NTgCN
	H4NkaoMnGmKAP/6oxIGHCKDaMF28RY1atsdOqobGeFwmhEIrxqbPA40IWMaHjpc=
X-Google-Smtp-Source: AGHT+IEJVPrhhNyrwtKSmL80bhwWSb7hKQIJxpwscC0mKQBtReP2KsNql54gMOZNVGMTZPZ+xSnEDw==
X-Received: by 2002:a19:8c16:0:b0:513:ec32:aa89 with SMTP id o22-20020a198c16000000b00513ec32aa89mr1163732lfd.2.1712740278556;
        Wed, 10 Apr 2024 02:11:18 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:999:a3a0:d4a6:5856:3e6c:3dff])
        by smtp.gmail.com with ESMTPSA id d6-20020a056000114600b003456c693fa4sm9079086wrx.93.2024.04.10.02.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 02:11:17 -0700 (PDT)
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
Subject: [PATCH 06/10] dt-bindings: riscv: add Zcmop ISA extension description
Date: Wed, 10 Apr 2024 11:10:59 +0200
Message-ID: <20240410091106.749233-7-cleger@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240410091106.749233-1-cleger@rivosinc.com>
References: <20240410091106.749233-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add description for the Zcmop (Compressed May-Be-Operations) ISA
extension which was ratified in commit c732a4f39a4 ("Zcmop is
ratified/1.0") of the riscv-isa-manual.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 516f57bdfeeb..902800b6dfe1 100644
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
-- 
2.43.0


