Return-Path: <kvm+bounces-45370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B770AA8ACD
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F6411891D9F
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACBC1DD529;
	Mon,  5 May 2025 01:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oz1YefMx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C1A1C8619
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409971; cv=none; b=odYAS7IcetTi3a0pTXJ/Xvsf4aS1IElRpwppxMDH1+VGmmIYXzlwdJJGKXOt+W171zPwNNWNAeXZoSfcFqPWiE+YFAzs43HNIOuVhypc7vU29h5skxW2UQBg1B22fe3v3P1+ue/j8ncGHREYO1YKqLs2EAIlofN9B+kpx66C22g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409971; c=relaxed/simple;
	bh=kNN0k/EkWYYC5fsTIWhpf6NSLz0ZuY71fIN9SoJaaso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c74qH0GGh68jLRcEcTO/ywF5jXgX3/t+sJDUZdWe3J7DJ3tWAiWmrxNbbocwXUt4bG4+bpEF5BfhQQGUjAfn5/ARzIGHWmLgYekyKxhxtd1T4/4v28OK033qbcdhtFCRlZ1moHMTa/cJQ+iGeSKZzPQJNgYli6b909qQVbMHbnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oz1YefMx; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7406c6dd2b1so817352b3a.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409968; x=1747014768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZaY3toZMvHik6Oxfda0st+OdZGZoqXe3KmHGIqEM8+g=;
        b=oz1YefMxShNPRDWRbIjQYbE4P5EEGBRpIqfTAgJNs8jGwV6QHiug+umci9WPtNaUNA
         NbZxvFM9AKchBOMjO35p1KXyLOSi2cgBig/F1/a8T+eIrHjB3pHSxnkUQDAs5hJLexrV
         nSbWqqw6PMMS4VQuACpw4j6QJOlMJbIFFoDQehNujYcCso2YwWenoqfgVSbqTJt49906
         WrCZNvmqwTSDqeIXc8dVxrzwyjrqtRQkzeFHo3Pm1TtnYsRnVA0mG47Jp+6s3KoPLcWJ
         FRG1OafRfgXwwIfovZOl9KmNV9uhAZ6hI3mGxfbXNqtnGRfQ17RJbLjoNIXz6a0ZhXBC
         khtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409968; x=1747014768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZaY3toZMvHik6Oxfda0st+OdZGZoqXe3KmHGIqEM8+g=;
        b=UY6R7+T9rtAMKni8rYVSvkbnOb6a+JoshgKfeoTe6uau4fJpY6p6oEYygtNuh2L3Bw
         8cph9L68qSb5Hs22XAnGoFkYfJF+qL3cSEp5HR8RIYf9eurzu9pp2rMp8h/lRuHvN5Ae
         is0TMo4A0HBXXOVSD72LqyhD+k7BCyblOJhEBkyMJGlcBB6/3KglbRYYpbZzTFwe/rHG
         oJb4/VvwdWLLfjETBeCemVnDIjNKkiVG+j3ZMVAreyV3kNb16iCYAxrqF3JH0r87ht1q
         9dkHOJJZawgvnZnw+Ahr+rhprgbW+eEyA7VHB/fsPzdXdTpshKehUei1sVfHZC7L39xS
         fxXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZMnDb1GRgTBt31xZqGanFK1HOMURAsvhTpCSjzDAzcrAfsLcgS964kyYQUDvZLQZZSTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwspKrVAsF0OW9tWRTna771dj5s2mQBjSUNt4EFeo1b0BrNHF+4
	bJFFsrcIWdgfLMKLIjQrWHLslLX7ANqFVp53sudiPkKHusrjGxIV+Cm/aJf2o2Q=
X-Gm-Gg: ASbGnctIvBz05woDRoNSoRlFwf+2KzbDYxspsdcQldX9YIkTCouuAt830SdstWXC++i
	d3FPNGlFqjgkTD1HGHBK7/UGx065q0XxfpKCSMZFU7EAh3y/gjHkFqyEUGwjHnWuWP0hOl8N+Ba
	OkAmGxQT5Z1oXnYAQtZBrVAzOxIk1wXgtyPzlwEEc1KopZ7NZlCWMoXwLRYQlSQwfAWEJnmw/gn
	Z8xi+XUjEcND/vSykDjVkfuVWuHJ8HByaUxD0XjyzW0m/H+vnX00cbi6yJ/CR2O68ihUyCWm4N4
	y7+dSNFtAKQA+jUlml/HJqnLb+kTndvrjW3qwu2H
X-Google-Smtp-Source: AGHT+IGMm7xh0qrjrDmS5dokWUiqHyCM8ckPHkrd3OnayFEN11uivxurPNZNriZNLtkAQt4mHaKPwg==
X-Received: by 2002:a05:6a20:c890:b0:1ee:c8a4:c329 with SMTP id adf61e73a8af0-20bd47660fbmr21220313637.0.1746409968309;
        Sun, 04 May 2025 18:52:48 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:47 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 22/48] target/arm/helper: replace target_ulong by vaddr
Date: Sun,  4 May 2025 18:51:57 -0700
Message-ID: <20250505015223.3895275-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
 target/arm/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 10384132090..7daf44e199d 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10621,7 +10621,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
     unsigned int new_el = env->exception.target_el;
-    target_ulong addr = env->cp15.vbar_el[new_el];
+    vaddr addr = env->cp15.vbar_el[new_el];
     unsigned int new_mode = aarch64_pstate_mode(new_el, true);
     unsigned int old_mode;
     unsigned int cur_el = arm_current_el(env);
-- 
2.47.2


