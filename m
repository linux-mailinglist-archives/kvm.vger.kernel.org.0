Return-Path: <kvm+bounces-45496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D50AAAD64
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DED443BFADE
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2923E985F;
	Mon,  5 May 2025 23:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JepfwMZj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383CE3B17BF
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487240; cv=none; b=fiKGccSoUOCq2hp4fHxPywRp4bWfEhxAxwUgaPJ6tM4QFvxiUuiErApHyeZ3XUQqxQfiG0nzyGEb1INlwPv/3FIS6ieJNZzkh/d52kZlMUa7yqGjm6/PvkOPZQWIa1NdQ8XZp7EKjRmxpNSVTR8K6Ad4YVlkiCr2YfGj/wJ3Qt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487240; c=relaxed/simple;
	bh=6eg1WWrFLrfY5Gs8TGczDifr0kodUvtUH3+j4IU8lnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EbQtoOS9TSCzYo/c5NMVCKGdOThcTkzZL8RdJJpKZe9LK3kwUoYSNdO0JMlsqvFZMS995yTb9D8LnqX5OCPGVMYCo0GtPSWhlmlmBzjvdYkXZhnepZ0AmhLS3Q2JY+jogL1sBE6XnomBNgzDdW9H3pEVX7JZniYZPwKHoPpQSdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JepfwMZj; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2260c91576aso44836575ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487237; x=1747092037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgL5ekQCPVNJfHfcPabdFrIvM+ux1exN882JD3eB0JI=;
        b=JepfwMZjAFsdDAmmPNOuwkJMFFuFUDHPWx3mHnpc6UEIudSkDzIKavkjn+bUi05kIp
         baheBIORvmlpjEWDI2F9hSTgbwx9UukjkK6uKsVE/gxUXWNvMcuEH0SHV0w0/069E5U4
         eyQy21AFDBYBiR4zTyH1f5I5vPBHENa4ee+U8iuYKuCCDR9YuAcrYDElBhWIqMtAmr2g
         QrG6kEYBXZBjm+sK8/QrGd6p30lkUZeLfubFyulav2ZWKyRTEqWtC91Ja8H3fHKWlwZB
         YVVhvi8LqUfBOxwKvjOGgeveJjuPqgJQcM1Nqc+umg0B3LCTcQPE+F1YNOvPkU0naKYM
         XN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487237; x=1747092037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgL5ekQCPVNJfHfcPabdFrIvM+ux1exN882JD3eB0JI=;
        b=MwMAh/IhsJj4hER0sIbJ6A6mrteEOmDoYtAzQYzX99TD3yU4kiQ0B3yZPhhRvVM0rK
         8CxWNf83MAJW1tBFrOWvXjYuHS8OyCvUSEktRU7WkIoZmS0drWEb1B3sKrlmQGVrcZms
         bXbleXRl1q8AB5xtAxXImnVgNMSUYwQIay+/bwnDt2VHIGNIz2NHnD6qL5iVYr3SEHU8
         1ZUrVlBywr5V05KIUwl2KpynkCOw4NUp5GPKimAymkoruQXO9VMdP7JZNSwrj8hbTePP
         SW4qa1VxvRl8tjJ+NSd7quUf6qMrn3dACydKaN99ke7FgKhUx+gEicQ6tQZPwXpK8wKh
         Sv1g==
X-Forwarded-Encrypted: i=1; AJvYcCWPR4n0lZKIzc2M/f8uDS9Gm6TKiTUHw8PrmmpfqK0o+T720SCDbeeClxJckutbz2I/ee0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBiwewKIcjoC7JzDyO1TwbuXVLdgxGpzNOiQafIKBFEkfJwVme
	yW7H2hBqGJa3o6yqp72kujbUipD9DkKj7H7EllMkJ+K5LzalrgOxZrTFhKmD1C8=
X-Gm-Gg: ASbGncsClVqh6tr8zix9trIacg+/82A2IZV02Qfgp9Q8lf55XDevtkMVmDkRplPX0tG
	8gX2LL47CYzF+LzbuOvQNCVTnprTJHfEh8hVALPw2esGdDJZL5PXqPfrDutqZGVlguklqCePwo5
	4xD7lNT1e2brNFzeD9J5R0micXP2/BHtk7w8d9YOQCTa9RHs7+FVusvTro0ykhKwz1shT0cH+hE
	xio0qst5eCLU5quzeffJnnel7kXojDdrLBbd9MfQUCIA7OA5SF5Eurzb2db35xTYe1HkITHc1CB
	NzVGbGySXRPDcEcVV3FX++0kAqpkUXGn8dedIDFA
X-Google-Smtp-Source: AGHT+IE3nk/0V+BVylyx4venVIl99+/yB106zJ5mCx0F5wFDY1DkA2BWuWgtA/VYU3cAbsPYqddZLg==
X-Received: by 2002:a17:903:18e:b0:224:6ee:ad with SMTP id d9443c01a7336-22e1eb0c7fdmr138049205ad.44.1746487237553;
        Mon, 05 May 2025 16:20:37 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:37 -0700 (PDT)
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
Subject: [PATCH v6 19/50] target/arm/debug_helper: remove target_ulong
Date: Mon,  5 May 2025 16:19:44 -0700
Message-ID: <20250505232015.130990-20-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 357bc2141ae..50ef5618f51 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -381,7 +381,7 @@ bool arm_debug_check_breakpoint(CPUState *cs)
 {
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
-    target_ulong pc;
+    vaddr pc;
     int n;
 
     /*
-- 
2.47.2


