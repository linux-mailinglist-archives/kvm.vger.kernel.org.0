Return-Path: <kvm+bounces-46235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 911D8AB427A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D5653B3D99
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:21:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC072C108E;
	Mon, 12 May 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y/fKMWU9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ADB2C030D
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073144; cv=none; b=Vm1dayyB9WOJ4+Tv0gcNwjujMkSghiaUh1sqqxg/dYADTsSL/nLAedWsaCt5XPfjfD1OtwBnyPW9mye532YNkAFnWDOizP6r0IXezU8UJHfaSv7aiTRXf+K/pchvArcuyfHlFThooqGy++kkmmt5ILuK98n/mRGKkO93u9Qa+Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073144; c=relaxed/simple;
	bh=jmUdrboFzyga4mrTnDHClA3zNyFy9mK8dkNEdQa4KPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgbeMxLVVPJtgfmAQwgjB46yMhxvUxNqWBsk8QxrxcdY/Giy36bGIFRvft9kr/jDbNL+7QADEIrUNvVVLc5XIkzEDFKP1QRWCRbL9TrLo+BOtlq8ZDa5zs4X6r16KD8roJL3pJhpmp8a4znwt54jSW8w2PDLXdp/2o6neZTuhDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y/fKMWU9; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b1a1930a922so3516437a12.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073142; x=1747677942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=y/fKMWU9nJ0Z/xI39ZA+Kie50iOWOfVP6oH64++k2JQDr6nWhoM+IEiQ/LSps7lZOH
         VVRmKAgOSfMh7Kc4ft7WB+WjQ1j0AuEL8t/NQmHkQzNqw4mtyP0ykoFut5GNGiZeiTp4
         DCbaFQo3hVs+MVZoZiV/7YUo+m3UatN/vrsmQnxSM0rreyFWRCIeoKiAnenvwZauvJY4
         QECGOK03KKydHZB6gpEucdDZ77C0/PZbae1WlIB6u1RGmsoebmn0WatkCYDDM5UCYZDy
         a61ffZD1wnL06ojfRvcgetc6tKfPf/aSo6YIYbxgdqS64sZCr8ghmdwBllku4CigBPUQ
         vQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073142; x=1747677942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oONThx//EO5WSiuREF023HuwIIuJ5yNwT7cwhGAiXZE=;
        b=hlWBJMn3UjfNzCoTWPgLAyJQv4/dEaIfqNP5byvSoZ3lTvTmwhbDfxofgkDBpkm3T/
         4V78P3NrCMLB98SyrtHrmDsOwesiUV9vrPkeiPFohA3cnKk2a9dTuMKLaZaxS1DaswAR
         EF3zkJTF57FNmG9FW0yXj8XjJQv5XPB9+eNXdSMbt0F8TDyYEaTERgptx4Mdnolg4cUr
         Afi8Wowb+c3cvXbmeEPJDdBuzQu98FCm7LRFxVepVIQYECNexRa0r42hXjEuXCpiZVoE
         fCM6L4tbi+vTrjVVhNzQXf43Aeb376ag1agXYQhq/5q4LYb9KtQ0bLYUJhdYoKFEcUqf
         54Rw==
X-Forwarded-Encrypted: i=1; AJvYcCWumL78IgUNFWM3K9QCXZUkAEfX+2x/0KxTIMTJ9EcR3VXOw4O2MMQB+YQkdJCtx7BJYpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsViELcqY7r/Y9dBVT7lTS9GNIam1td70btZYabr0kWA2WeEo1
	dKQ0NRJYiLlzQsu42xFRAdxuE88JyZnAIBoAG/C/bn49t5sOXs1QEZMgaBPVfVmUBaQLYEwYu2f
	k
X-Gm-Gg: ASbGnctZwswKJ4II7ztXlw1AtqtlatHgY24LpchG1nFyD5NQ5QC1/m4m9lP0GzDKmnz
	73ZA9WCC/GlBTleTUbLQtdIHkhLRhX8WJlyjZrFdyAkiM4wOug+EAwb7k9qGkHKgbE0amnF5THs
	VPL3Ub1whxeLrUhbBPUdY0i0zMIjTIayELMuP+Cv/j0ztKqC8NuTauWahS2xeUGDBSbivAJE3Ib
	5tGWPhfIHwY8HKeRXLt5rvfLoxdMbJ5FGzNF6dZM8B/WtKsB1kfq/Bi1WXpBtNm4EMyq5Mkw03M
	Kb5hl07EbMkHWa9Hm07Ta5NPVoYsjGZ1RWtSQF54Wsp7T18bHzE=
X-Google-Smtp-Source: AGHT+IGDr/hFIV7zSeR1MqUCWj3qYIVaOAhK58NysAKE8oD7L9hcv/5zp8VBN5nkmjJpsYAWjgK61A==
X-Received: by 2002:a17:903:32c1:b0:224:c46:d167 with SMTP id d9443c01a7336-22fc8b51a28mr201435875ad.16.1747073142056;
        Mon, 12 May 2025 11:05:42 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 34/48] target/arm/machine: reduce migration include to avoid target specific definitions
Date: Mon, 12 May 2025 11:04:48 -0700
Message-ID: <20250512180502.2395029-35-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index 978249fb71b..f7956898fa1 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -6,7 +6,8 @@
 #include "kvm_arm.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "migration/cpu.h"
+#include "migration/qemu-file-types.h"
+#include "migration/vmstate.h"
 #include "target/arm/gtimer.h"
 
 static bool vfp_needed(void *opaque)
-- 
2.47.2


