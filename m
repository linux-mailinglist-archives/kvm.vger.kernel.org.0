Return-Path: <kvm+bounces-45044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4222AA5AD7
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A252A9A366A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED5627A921;
	Thu,  1 May 2025 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ONuLG8Rz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B0327817A
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080648; cv=none; b=nQUjRonKSPTnorSfEAsL8n2aI0d7oN6Uv0mq8X2w1h4fhe8VkM/ZtHZzIWH1KXewFThrBff2m+swgvXI5e8IQvQxqWgzU6SvhmJ+Oem7Hx54Jfqy2g7jJYruABITXm5aKmVULoQPOFl4kXplD4zBFa1SIXRTvmDW86Yf4Zq3Yn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080648; c=relaxed/simple;
	bh=vnIzZBwxHm69eEmYbCqGM2CYxnMJjmNfnNarfeby1MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiP6tnN9F/+gwU8yW8EcCCiLPMXHy6yD1LSewL3kBDKjz8duosp2fK819Xnms8I9BKneoWimU0/Glcxvc7ItF40elxI2QT52btg4/k6Ef0sUX9mNvYpDJAqyhCebLeo2FttAHVe8l/XdXcFM/+KrFjB1EhoRgH/23OejkqFKmJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ONuLG8Rz; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7396f13b750so849281b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080646; x=1746685446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFwygMkwhCb1ZWcyfCzBjn8oVpD1D7KxEaoA5Pyvsy0=;
        b=ONuLG8Rz4YYnc3XVka58IDoeDSHotpD5AFgAqHGGIJPAFxK1T+NIcQmVslGi7W6Izo
         ASs5I640MnPFyC97H83TG7nVPI1paomw7yL65AHLME61PgHMZM/LUWZu2hZV0WX1yjQJ
         pOFKomTbcZt9FuRgRUIWKmRqwPypny2biuRHOxp5C73+jqMKoA9HiDHQP7EujYDtdZuY
         RJe7RF9K5Zmd/S5UnQNB/9NgXoqghH9FGTyzMVBFsDYbfFgXsKGmsmR0IihXQFbLqjME
         0Md7UgUqsAldbntYcuz1kYT40inSmZjkVKxWPYZALpJVwqfDxNKetsBa0zcs0KInyd8t
         AYlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080646; x=1746685446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFwygMkwhCb1ZWcyfCzBjn8oVpD1D7KxEaoA5Pyvsy0=;
        b=fdVO9URbbVDPScVUB/plm+/sy0xtv1EuzP4by5KMBx9cSKr5y9jUFhG0uxmIlRKMvU
         9HB0cg8CGLwmXp/LlJc32GkLcAbOMDeObQKEcrufFt3JGLDjqAPIYpWZaFom/pAtY5kD
         sQeefkOzWtLnOfLvZW8p3+uZxlmLOiOEzUJb90mDs8PaLKiR//jg+kiufpFYhHQITqZv
         e64kXnNolY7mVVtFNA0psggaqs6Sq6sIfPlVGXbGD9S7X5PsUqMH0WL4DrZ2BUcAZXR/
         Cg3HlpsHU59nxaTZwU0DzX+f01E1XylVjxhMH04ru6SjK7jZwXR41SRwPlND8TOQAOXu
         IDag==
X-Forwarded-Encrypted: i=1; AJvYcCV3q3V7K2yF8Ore5X2Fj/HQeVuNqaxDtxPJ5fUwlkNlrarcPD0wGx3q2XbARRtrGl90f4s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6PtJX+zIWwndUlICEdFo6FDAyB+3gr8hJwbEHK9gI/V6WY9uc
	7dq82wQQ8IBWdWej/PAOI38q+vJU9x9+UWMnyDDpqEE9o+mUWATZqGzbxWDdlGw=
X-Gm-Gg: ASbGncuFe2lgAKM9xTMooFamMh+kNAbfIP0uJJSNNSpTw2njWYi1JIl3cnxG/Ohaz5B
	B3A3PRQBH83LnlW8WHi5Kh9JdaGWsRPN4HaN1OG6wjvB5oW17ncO32TR+QERmq+31+e5tJCLkaI
	Y19N3F7xDMEkN1AjMWbazGALea6q8e+5GdX5CqOv2AjCog197crL7gC1noEctb4o/IC7sgwvZa5
	pDjFco7ZbEWRdM/+9Zi79k61lArWqyeaep74yT553wlZl6wsIgX1+i/dSIHNzEGWnyTEY/n6gLA
	3BnbVXTN4fqMZnparaIpEnrb0PksKvKWKOLTJNwM
X-Google-Smtp-Source: AGHT+IFADJB2FcXdHj/QO2Pd1O841YT7LfIvcgx8grnyZrHZkJ2z2++hnDO5xALbvSxtkTgFKdc8yg==
X-Received: by 2002:a05:6a20:7f8d:b0:1ee:d8c8:4b7f with SMTP id adf61e73a8af0-20ba75f00f2mr2951744637.25.1746080645877;
        Wed, 30 Apr 2025 23:24:05 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:05 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 16/33] target/arm/debug_helper: only include common helpers
Date: Wed, 30 Apr 2025 23:23:27 -0700
Message-ID: <20250501062344.2526061-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid pulling helper.h which contains TARGET_AARCH64.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/debug_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 473ee2af38e..357bc2141ae 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
@@ -12,10 +12,12 @@
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "exec/exec-all.h"
-#include "exec/helper-proto.h"
 #include "exec/watchpoint.h"
 #include "system/tcg.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #ifdef CONFIG_TCG
 /* Return the Exception Level targeted by debug exceptions. */
 static int arm_debug_target_el(CPUARMState *env)
-- 
2.47.2


