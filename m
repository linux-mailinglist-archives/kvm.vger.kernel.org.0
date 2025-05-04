Return-Path: <kvm+bounces-45329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97E06AA8418
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:32:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C282A7AC006
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933AF1D5CC4;
	Sun,  4 May 2025 05:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fpKBsexu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1A1B85CA
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336593; cv=none; b=R9ZFdQQE7Fxi0G2ZrEgmppgnel4qWC4zelAwWKMmU18N4qyoxgeH74K1pY/vupIWxezEVZtP2leE03UTQbWWVy72zCC3h6UAtdZhrDqggML5T9GWYIeXbjVmXvxsuANQWgP9fQ9ErWj4jsuVVjRgMmC8E9AKSfiVJeoxqBGnTvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336593; c=relaxed/simple;
	bh=BLgPWLNUA76iribJw3QW2z/C8jb8t1bvCFXsSDXpEHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6KT0taCf8HZh6cfuRzA88eI1NFqzikCrGhe5ic2xpFCZx7fpgT0bAt0pbEbFjADniXdbZmRo0vXoMRVftYuJJ/7kqJVuGr2zMYXlj5ygIYgrAdrs1RKMFLswQWDYxotR4tL+tn79kAyhDsSR2DaHgEEsM/tCJr0F3X2TZh3gz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fpKBsexu; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso3518668b3a.2
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336591; x=1746941391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0KjypDvOEyLd05aeE7s1LeHvssR3Eurt4FNPjX1WjXo=;
        b=fpKBsexuxf7KeFm6RPka2AcULCa5XfrQ0v77ThXwfYHPTGS3Vi5iYOcGI3kIs+1el3
         H4pwjYUMEP3YaSFdUvNvAu1nlFGC9IJ1JY9Xrgp5X7UFdeUqgdJ2qWuY0LZctr6tV5uQ
         OyaNawtoxACFVB0GoculiS7DVC5CqNF6u9XcgUA/zDE9FAn3AkrqhWj1xDyBCbV3Nu8t
         qrkHdobnxRj66f9dSbPdG0qq/B8GjW2gY26NnLZvqcgzzeO5lBQV378hAisNrrw0E2Ku
         gX/f1xmoKbHnmo6nKgJbaZEPTJtNDftktuABuMdht/xhMaRyMf+mxum/5/Lbe2uqv4hH
         195A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336591; x=1746941391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0KjypDvOEyLd05aeE7s1LeHvssR3Eurt4FNPjX1WjXo=;
        b=bnLYXBbIyhapNGWx+rPl3hNiI1fBlWmqdqjPNilOk4jmSkHd2/NUq4ie/YqMYEs0K1
         pjilZPZJuqrvg6cIcw//EZjMvA6xrnj5C+8P0PB6N+/V2CkGT/uyOtELHTsXS6dYEIcx
         y6MNXjKDh8KqlMzEc8OKNSS+4VoiB3oD57V/ZCGHQ/6uszGe7+Bvko3X2mDkRl2plwbq
         gw5Tvtnt/CmU3vDde4vw/wi2Qk5+utobSk8f4MOApUmxDmDMnGMIfgXLqOWnvfaBGRSQ
         24CpWfGuSqIY3eJlax1pS55RWD/O70b5r94bxss4Uy6eLAhQZloVJeQMe7YUGGPD8O1v
         H1YQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3kU3VlHzfV6P3aK7SnjhCMSpqqwoN0KrzD26pJ220ucTvV5wmeJKn+gO8peMwzb81GzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLzIjGlPeyd82/i74JncKP+uRisnnOsWEEwKzmaQFKONSzd9qh
	nqvqwnkJNbZ8PNh7DomKenRNVlYuKD1htkIQY4TOp+hboB8UJ8XCZVp7NtJXJPY455Drtes4A/L
	OUpg=
X-Gm-Gg: ASbGnctolGiirZhojZquJRMjFWZABCjH9RsVkS6OZO5UuTun4DL/MH5bO/VauVhPy4n
	mKWcdzpPhzMiwwr3PlsvT//EqopO4flV2ghzQVyU849QPnjInWaUrThz57QolCWLNoGQ/SPWS9F
	dJrRsHc+2XLXC94Rhtjv9jc0dr7r6mJt9+WzQ6X+pzh4WcVtb0g7BPhl048UdB98Ob/3/IaVgSM
	kxxBVGyoKfP8iN0iDej7i80Mb7fhtCaZ7Yyx2ycvK1Sy8EGF+G9FUO1hAarE8YApZvu8zH7UTOS
	9d00HFwtxLywFnddhtvP0kuE0ghgdtxHsSNwiRAn
X-Google-Smtp-Source: AGHT+IEHFx3XlGD3TXNpfIJs6MWCdr6hv+E8rDZjKYKBFe/d1SiWDCfxWojjHKMrjf9s3puH1FQGBQ==
X-Received: by 2002:a05:6a00:ab86:b0:736:ab1d:83c4 with SMTP id d2e1a72fcca58-740587626dbmr11929604b3a.0.1746336591648;
        Sat, 03 May 2025 22:29:51 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:51 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 36/40] target/arm/machine: reduce migration include to avoid target specific definitions
Date: Sat,  3 May 2025 22:29:10 -0700
Message-ID: <20250504052914.3525365-37-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


