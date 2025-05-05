Return-Path: <kvm+bounces-45490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AADECAAAD3E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D635188B265
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B073E71AA;
	Mon,  5 May 2025 23:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GgQ5MKI8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC1B3B0A27
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487229; cv=none; b=nk43xnQIDifzR4RfIVFFH9ZE0r0Px2/8m5BbL/CT+HktesBgyiIlo4FufuFmsXbXvP3HJft1SG19rT2xuP2v+yk2FJ+vHmLnk3ytFzRwSnPjDUEL1ldP77S2RzW45eM4PSZ1IDhbHdYj0P3PRiNRI5F2vBC65md8zXYUkhsCSw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487229; c=relaxed/simple;
	bh=1hAGtngwcXI/K1ZVwOSxlRZCzxWzI2kpJ8rbj0YHGnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqr83Om5LkZcTp5y2kVU5jjWJ25oJG/gVXDxxejFwFip6u08EzLrUWZ42xVvklH5WOfYtjY3Pv9F6PsU8/DmwRxVA7Z3454wNd1wm56shmL95pNbJ/VW8t8RKd/Dd/pS3qMzfAAhD+hxm+a1yoQBYBKIAeKzDcOoNstbK8sVxsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GgQ5MKI8; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b07d607dc83so4192992a12.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487226; x=1747092026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=GgQ5MKI8C2SamSAiW3NSCjwbWQjlIXFlm/dmiJDwApgUl/OokEoZJxEQ2hwZY7LIL2
         zU7ofVaLhq4esmpQJBb1ZywI0mcjTIzfxTjAvfOVln3UT5tCDiMnbc2GL116ABAARa85
         xabkBiC0BbxeGfSJx87jxyqBiUoSOUNB/yb5vglNUgkMdQsa6i/SCLKIQob/q1LCL3Cd
         H38BiXGhoirhV8/opjqqpteAj6sebHRGYEvyLE/N5YG+X2CNWCv5KW4DB40ugLW/xbHa
         1VAf4J9WR3CcUu7BaKhmey6SA1wnB4tKFQ7qvUpOcOuNegRG19Y6vyKNlXyDyJPOjamG
         hWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487226; x=1747092026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hckfD0sziqBh1sSWGP9c0OUCVTgvBeVKgVHtB7xMeJ4=;
        b=fWo+JSRxj+dH2z4m+rJ6SvBnJsXeStgOG2vqhjXeAG/lwj3T9Zt9nkMmrsvG5N1hJF
         cD5mguPvUXhHoU4jTFq4GrClaVYK5BrXfz+/w7kg2gMgPl7BqzWnrzl3eDVNavneazXJ
         L9jWtVbIAGKCm3sDmKT4K5RYsry/ep05idvNJcEKaGZ0Oc59+0ARefB0qQF0fEBdEnp8
         Z6KP8thBlavA8vzJZ0ezQAC+PjPnZgy+FCyUEtyXAWCoG6xHubZbRcCwKvlWa/4YncX8
         V74zQR5WC+l/nXvLMRly4nwmfYDz5NyaMH9awxVMMu/ysrB3MehZ6ElKgUdJdHkoNPuL
         4TFg==
X-Forwarded-Encrypted: i=1; AJvYcCUBY6WzSi5LVHadaPsiimdVbcXz9JzMEiG19DnWbWZOotMofmZ+MGyRvG/NrBCQB/+8PHI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcmMFY+jKdIEJETqDrz+FruLRSZwVEppgWjn7oaOH7rLVjNCV9
	sKbOCPSlCfwAbG8zDUxBaB05iGtvr/VEAI1ZPcI6Norkk4TWDG9QeTOruUOhRsk=
X-Gm-Gg: ASbGncuPK3EDoRbj1Ok+K++bFzRo+X4jhlaH5Ll9ZO51LithRb1q3Zjo5sWp62gMi6+
	HIHbj5WGSpsw0QFrksKKW0EUdiR7JiupEhV1DE49RUo7v8e1ETauFXR7PMxA6pd2rhRlP3g6f/f
	0rMWBDXbeuQbJCPeo0pg2UIS7+bh8ixIk54baL+QBz9eLH/5+cDMefntojXaQ93RXLd0/F3nCQQ
	TAUuXS2VkTGq4ecnsCiOPinrH95d2cR3A7/ubNZPpkWGZnLYKVGYgYY67NWcXES0Cvta0Ydwbss
	86J/U24/gMBa0lzsyFFNezZlErqhzXCFnuiQZL18
X-Google-Smtp-Source: AGHT+IEKId2hWCnJS/+NSIvZmGDfi3jgk5Oq8x6EKCRZTAN5kZeEu43KoC+oMuNp2EoM3sdXTPMLDw==
X-Received: by 2002:a17:90b:1cd0:b0:301:1bce:c255 with SMTP id 98e67ed59e1d1-30a61a50832mr12860527a91.27.1746487225925;
        Mon, 05 May 2025 16:20:25 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:25 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 06/50] target/arm/kvm-stub: add kvm_arm_reset_vcpu stub
Date: Mon,  5 May 2025 16:19:31 -0700
Message-ID: <20250505232015.130990-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Needed in target/arm/cpu.c once kvm is possible.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 2b73d0598c1..e34d3f5e6b4 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -99,3 +99,8 @@ void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_reset_vcpu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


