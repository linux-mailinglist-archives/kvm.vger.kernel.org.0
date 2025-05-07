Return-Path: <kvm+bounces-45804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B52AAEF87
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11725503BA4
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38E2291881;
	Wed,  7 May 2025 23:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mdbWzEhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75788294A14
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661398; cv=none; b=jvVo9VnqCg0Djl90+cVm+BminIpSLfosgXh9O3Zn4BnKT2h7Yq/jqSEdF7ScWh6J3zX+GYJM5bMi23Bfr/sZp8AfQ7YmffvvlGSgpqxCGlBeCm4uuX/0DJ/BGdklp1r87onstZc6hlWtFf644TI6tH8DEd9BhwCkiC6wm3kz2/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661398; c=relaxed/simple;
	bh=xkc01XmwPbQQqW2DLbPjrYSssEz2ZnunsGIPKKJvDsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdZBEIKuiRwH8AUshoXZ4TIXfwiw8Q388VFjoHdLagHRCceDLAgO461fGKAmYRhX3c4i5myWjHyEe93BOjcKr1sNXngwMVZwrfYddHLjnzNHD+V+9uPeT1qBAZcjFZkzRXDBRVdqEYYOSrS8GNJVfDkcdlKcQoGbVaApmY+IzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mdbWzEhd; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22fa414c497so1205115ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661396; x=1747266196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=mdbWzEhdMOOcMSbTKyIkG49phYQwitLVFY023DcynmvMN/OZqtj0k2XgibckKuh2cV
         wYszLG8v3T2sBUb2IvaMma+d78an4dXWBljc6oEOSo5MpjwvD03ppu5Pd3EQ+M4m+p/x
         NgD6jtnOhAo3E85H3a8O4ECaJAnVNTAXym8AnpBGAf+OSFn88MiszuVcmjA3bs/5J+U4
         DdT/i2H9bTOccNax3dSl4Iqon41ggt7ibwo2czzJzDGuT6ImR+ivv0+DM2GuTXKjxVCA
         9eVjVuFit1sZvfc9JI1NTWi51TTEJLH7mQIXnGcNQG0HroO6aTgED3mW2pnzyIZgOxJ2
         z1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661396; x=1747266196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjvN9GkUlSXmzEXtUb9+tptKE6zBbBhkZRx0p6n3iY0=;
        b=FXUKwj5MOf6T6jFTQJMRymdQoYo0hMZL2yE8sG+LsKye7ierLEba3RRteQBgyXvH1X
         M8gpNJsLjX7mZVB6IPBTa1DRW/zL5oAnwuAm5bIlVrv6JubFOq2MfujzLkzcF9rg5LQB
         dtKIjsk81YMPAmYgmt0l2l89L4dxFEfHac9agg6VLbjyt1C8/vJ0joZwDPNVikITzvMh
         zkpdobHLJx4g4ThaiVOyFQbkAk0C5Wvz5tuc32WZbO8tZYKNbxD/yHgDzXTH+0GUbnXv
         uU3MyUwPZahTwnAJQNDIQ4M2BgdleHVnmmKQr2SeVXDk0m2nYq+sh3VxXcCZ5eKbm65K
         ktIg==
X-Forwarded-Encrypted: i=1; AJvYcCVuJAMUhavx/y8LSWGGN+rcKnKTmZSLD204tjvo2xx/PqmFvdHq3WsFSdiPbn7UURJ8pXU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpkvum6QqGUrk4K6vGzTtD6KrwMG6+7BJeQHlEd3zgdPWSJbDp
	XnJqbtZugVMXGsk5tL5gZj+4kzXwKChjSKnoK60g7xBwNrupYsQgw2CjnbOqrlI=
X-Gm-Gg: ASbGncts3vMTBkxs6YHsHUjK232X5WnVCIawCNxKl+MwCnBEypLlbROp2VfG36cLptP
	yFZ0mHfuqsuQIlVb6oSZg5H/XrCIHlp0xXAzGh2x6VdULT2Kb0rd3YKJkIUWT76P/yOtC+hsxi9
	56DwY4pH1r+FOl95eajfBLpZYPOgJbmqLGGgvH7vIQylQUaSeg6e+5Hlna8E1ixLmQigAR36o2H
	6/X/VqJgE26xF68pUTpN2y0YHM2TGUksdWqTt/Ul4SmcjDPkCKTbPrkACO9iPwgzSPhg5+d3Q88
	n6AIz3KZbM1H7q5ld8E3nRoY9NXcXskoHFnwQzWC
X-Google-Smtp-Source: AGHT+IEuW/a8CQcTYfwo7IA2UdMnmDxumG/5lG8CAIvP1ZR+VlXIRxuwUzfmpdZQuGHUomKTI4zmHg==
X-Received: by 2002:a17:902:daca:b0:223:5379:5e4e with SMTP id d9443c01a7336-22e5ea70aedmr96320185ad.10.1746661395849;
        Wed, 07 May 2025 16:43:15 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:15 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 38/49] target/arm/kvm-stub: add missing stubs
Date: Wed,  7 May 2025 16:42:29 -0700
Message-ID: <20250507234241.957746-39-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those become needed once kvm_enabled can't be known at compile time.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/kvm-stub.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/target/arm/kvm-stub.c b/target/arm/kvm-stub.c
index 4806365cdc5..34e57fab011 100644
--- a/target/arm/kvm-stub.c
+++ b/target/arm/kvm-stub.c
@@ -109,3 +109,13 @@ void arm_cpu_kvm_set_irq(void *arm_cpu, int irq, int level)
 {
     g_assert_not_reached();
 }
+
+void kvm_arm_cpu_pre_save(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+bool kvm_arm_cpu_post_load(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
-- 
2.47.2


