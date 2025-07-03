Return-Path: <kvm+bounces-51416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5F6AF7125
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4DE4E7AF79F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1376E2E3AEB;
	Thu,  3 Jul 2025 10:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lFGrfcfc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA042E2F04
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540214; cv=none; b=fjKBqKpOIjqPFygQmqfkDCP7FQQq2G6EUv04I9PI3BdBiVDiEd8HzGvk+QkXp1OAn4HPSwdGi68XcBSPOdB7lJ5hA4YvCnsW3iV2EpZddnr3E3r2CfDby4B517BpRAHjSJR75UFl9K1gKWQA5F7VrBBFLH+z+MOXOvyCZiy5F3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540214; c=relaxed/simple;
	bh=6pMUS2JpXIMKgT1NiluqOOtX1o+nxF11JUrHYf3gX6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m+ZR/YkIo9yWOQnFk90FJztIMC8hxtDJQxlkByN0HiThb58mNpw3DW7OJN8NKLDVDh3pP07sFiHLMeFgI/qkY+XqzmRC7YJNt6mUyeDylUZHK8PI3ZSF5FONzIGsTwyg2gDt8bTqjEFeLmT8zVOiPhp3dw7B8kGzFXGmr/Sm8p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lFGrfcfc; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4539cd7990cso5150635e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540211; x=1752145011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Etx308N3I1KijyhBGAM+HBbz94lNBN0h4vUS6IObI1U=;
        b=lFGrfcfcHBahRFD7jBzAzhxe259i7wWg7UXUkEbqdxdWwNE9DfQSE8P/gFjvZPM5n4
         ESWE7PZXQpixzSt3esAghMD4DgFJAYmm0cmxWFe241tLuPU0JLr9jTVdh8X8vNNmEFHQ
         ID+jGF6CS0P1IO82fVjpZGBBtqK42rDOYdNQUpmu4F3797fOXYqA4aBDZEFOt5+ODp2H
         W9+vTzR9QrlJ8ZbpuhRzeFpFYIRFyN/0aFT20XRx5TJtlF5eAzg7zDHNtmoqWj9a0IQd
         ezDj2su6GSTxVTC4iti1HGfvxWCa6BJRH1FBJcHy3/WfbinBrQX9SgsHUYUenwvM5ydg
         HiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540211; x=1752145011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Etx308N3I1KijyhBGAM+HBbz94lNBN0h4vUS6IObI1U=;
        b=ZfizTwch1OtauXsEnbvs4O2EUO1cnlGNcUPcJFaZIR4OYRLW4x3El4oyYCLN7QGIl0
         Q4ndSP8HaPOqYnGyrwkEhycp0+MwLkdSlsYOLVIkTQ8ejpLZ8sR+uDjBAlX6+pi1E37P
         yRXlGa4VU29sIiEXdXoqUlwHwJX/HwwEdq57+Eva8JLUzGRfL9aqUmcETYCivM3ScNxM
         PYe3qre9IskBzSHuN0JVeg4hpI0WlpSm76AyaOGU8d48AZ0mS9kwRHxr+yVtH7+9sQeJ
         iKDT7zZWuYYHzvJt1Qu44v2K3yHhQWLHNqZ2AjjkfADRmJAOMrs4/tH/MukaEaGs4QM5
         WbtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy/XOFAc3tr0l5CF0eGnMvfH+faeBP3c2Cllfn7PrZSFIwzXG3vMnBBvtYoXySJKmMyHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyY6VjPtipn9VIwXiurIJnvOximuys8eFzu5h8LHDZmxIuGANoR
	SaDQC3jYpNBi+iHWaWsXbTHDwMy96zwIiHzdJwb5UlhV2oekx8/JqbuQ0x1FgI/l+Nk=
X-Gm-Gg: ASbGnctgVDAigZnmiGuVOJJIpIDNb3HVXfkLzhorkIukdOlpE62iasafiNxaEOcfioJ
	12QtJHHvhR3hRdX4oU1909OhD69/fTX3MJGZLiw/xl/l8uiNPRA3rNNSt5qgT0jP1zK6gEQYIlz
	2I/urthUQqLefAU0F0p5OExDk1Gow0U7pwVXS93WQ2phVaOxE8iDlvc4SOsG1lSGtZbREAWXAA6
	M9Cz5LxvEETlzBh3LIL9Ytqp3lL5DSct4SC10xOfaZ7fHIB3kzVnOHEsjnlNqWm4y1UUGZkqd4B
	fs6OSxeScYEUFaNrGta/zulzfeiKgPZM0qr3+eis2jchFA+fHkzuuhNM/atABQtYOv4z8e3A3be
	sfVmDiPrHVp0=
X-Google-Smtp-Source: AGHT+IFDMhcqD9OD8PTNB4St7Q2h+FxmR1znYA477JI4wwctyCKqRNqqzjvxSeSTmu7diYiHb036qg==
X-Received: by 2002:a05:600c:8b23:b0:453:69dc:2621 with SMTP id 5b1f17b1804b1-454ab34b49bmr23227735e9.12.1751540210986;
        Thu, 03 Jul 2025 03:56:50 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9966919sm24286555e9.7.2025.07.03.03.56.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:50 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 13/69] accel/tcg: Prefer local AccelState over global current_accel()
Date: Thu,  3 Jul 2025 12:54:39 +0200
Message-ID: <20250703105540.67664-14-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-all.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index d68fbb23773..c674d5bcf78 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -82,7 +82,7 @@ bool one_insn_per_tb;
 
 static int tcg_init_machine(AccelState *as, MachineState *ms)
 {
-    TCGState *s = TCG_STATE(current_accel());
+    TCGState *s = TCG_STATE(as);
     unsigned max_threads = 1;
 
 #ifndef CONFIG_USER_ONLY
-- 
2.49.0


