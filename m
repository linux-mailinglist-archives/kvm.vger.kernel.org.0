Return-Path: <kvm+bounces-44675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF51AA0187
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CB6A1B6183A
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 05:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338E6274FDC;
	Tue, 29 Apr 2025 05:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YlKkycQn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10F12749EF
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 05:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745902827; cv=none; b=X8ZyFqe5t4sWYGa0GmANqP+pjs81egImbjaQiN2xfyOgXsf0koOhe87mdTiAV34IyftYy3hhnkr/UhiRd/XFmMCOc6XF4D+tvoovJ2rV8q+yeYupW2V/ujEsCvqbrCi1qG8b90KA5NYy1/ulZmE7XdLxiWM31YXWH2wXGc8UNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745902827; c=relaxed/simple;
	bh=Z8ceVxz9B5LixIq0JHJb3jdimuwPCT2DJfxgfWaOKlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJXrNyGv+bXipW+vGuyQYYgvDyCW1JY2rT192jvJXdX2TQo/dUUJKOLNXm6+HAc3rTIsblVQZYSMT3XRLsdYoKncvUAgt6DnEhNWLX/EzqBz+bQjltFFuW4iXlhVdrQTzgSTGGlcMOjGjLTYMHblloW/xW58CpQNlgYV2BEC8T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YlKkycQn; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-227b828de00so55707075ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 22:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745902825; x=1746507625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lofZ2Bm8qaw0g+MX7QK5XKjfJFx9l5xRSef1IWMqPI=;
        b=YlKkycQnM2jI7bG+uIpVeX8qmYYCKC8ZFHC+RcU98dTVrQsHv8VBkP/TsU78lN9Xot
         q5lcl1safSUHaS8D1+tMytTzMnrWCzq9/eJa1J1YE7CBPVDcKvIj9dWwiBRU2F1SYY9a
         SwINLZ7fzyoYM/SJK4ik4AOteZK6/70B3slF4+JnKQyL3s/RXWtnciqyH1PocFiocwzJ
         pxgy4LW3Tu1Jd4YTW/YyQ6Z56b323myG3zrAuGGs0T0CoPrIQEMHSMAWINtaF3FF/TIM
         O+eiEnRdffhs/Wq+38C4xN1qj2+lBhSGDkj+cfvb28c2ZXIrT8SNMsSHL+58YMGjcmUK
         JcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745902825; x=1746507625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3lofZ2Bm8qaw0g+MX7QK5XKjfJFx9l5xRSef1IWMqPI=;
        b=dULw+cSzK0y+6Cte0Kq9/1eDfD68xB1BkFi1ajwjkqG4YuxgQbEb+lrsjqJ8iGW/Rk
         KrEAAZAnx1GQcyWsQTyLevFYMNNf6ecPT6ZEw9QORrh0pjFuInz0B2rfs+YChzZyYbgh
         eiI5w3/wS7z0p4XHUqrY9M2wh5+PZ8sx/Mdh/5Xd/dyq9fxDyt0JKPj06AqZFbv6tty/
         IRo/6ykydCEiy/h/QfaIVvmlwiBTeEftNj8cYkn7oH33UxofNey90aO6QIJKcOBeA4B1
         rvq7dqyF5WQhNhCgi3aU1orDJYqqSNEDDbUITVKxVe+Dhybiw+QU/6HtzMf2+THDpB7Y
         olRw==
X-Forwarded-Encrypted: i=1; AJvYcCU5mNMTstZhO9bK6tk2mYopjvzbOPD9tJL8SIz60zFJK8BKNbZhrRakeov1a9z80d9wuqs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6pcnb+MOmY05sHsSnGQis2EqyfJoT2fdZmXBSzkkuYHKbqTUL
	TklG0ID01mN2tAXR5i7Wl9GAcDlJpqx47Tbk2GZ1OCwkW/LUG8ZMBrL1GUjlO2s=
X-Gm-Gg: ASbGncvR2I4NDDZsdpxiQZ5n206mq4+yTfMvo5TX1MV/BcvfiPtZEEbwPmL6lZeholb
	aTQDX4JpNzAAsVbAdnxAGZKm855ZI1rA+4C2kdG7x0+RyVWetz1gfjkTp/P3PtgORuMCXEGl8ED
	eA/aShbL7+WvwozqPFMqWI+2cwUE32fMYYaRx6YF+GYO4n0VjKFXeLMd/vLgGQKD5f8lM1WgeKf
	SbCjwB4EgJlY1rqt1qQ3i/FP9V3sAcqUiWdZj5pJ6sW0I/YCCNdUTUfq2rXxk1vyORs9+EvSzqq
	BQ3qi2aoW2bzwjr4KZpG/W5wxjGnlRP9oHwFJbA3fFMvARgHgDs=
X-Google-Smtp-Source: AGHT+IHKajVGWFwx2GV64yYYge6HnuSIfHi7SBgyTCx5wiAVxc+fYk17l7nH2nNKkMp7ATQMXoSv6g==
X-Received: by 2002:a17:902:f70f:b0:22c:2492:b96b with SMTP id d9443c01a7336-22de7015dfcmr25481425ad.15.1745902825364;
        Mon, 28 Apr 2025 22:00:25 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db4dbd6f7sm93004015ad.76.2025.04.28.22.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 22:00:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	richard.henderson@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 10/13] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Mon, 28 Apr 2025 22:00:07 -0700
Message-ID: <20250429050010.971128-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/cpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 85e886944f6..48ebaf614ee 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1213,8 +1213,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1372,15 +1370,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-#else
-
-static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-- 
2.47.2


