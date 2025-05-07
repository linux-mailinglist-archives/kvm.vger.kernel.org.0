Return-Path: <kvm+bounces-45789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B68C1AAEF88
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E975E7BE7BB
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE65293455;
	Wed,  7 May 2025 23:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JSpifM+X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13AC729291B
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661385; cv=none; b=S5gitLujg7spWIJQCV4kYwhBqqJdXxigBV2MzATM+ReasDqRXBtrsX4cbJwYzrD1q4pnZ1RTXIEYZRjPAHi8glJNtgScKp6N9PkbPQBJtVAFAPYKCrE0Xdw6zq+5mWzPuKPTAJznUNhqtw+xVX7X3oNEewxfQpzw+hkiLTsJpYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661385; c=relaxed/simple;
	bh=90ovPSN8rDGgpQFp//tclRT7CNLKGFud403Xu4sCmsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CM0y0OACjH2TdBVfCqsD0sCwBcNIpGVyYCoYOxwnvyqM+/9SrXx6WlojZdSNZ/tnUNl9My1SFn34y9R8/ryvaulhDbcQJ4StXwzNVCb+/XG0Sa1fi2+JWtedZC9Lt6slfgQc99MaZbkyPrtKuwq4x73pDRlMNWSHDjnD7qzPmA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JSpifM+X; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22fa47d6578so412545ad.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661383; x=1747266183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzs2UwtIJQNFywCbX3keywjm1hoL8ZwFtVh1FsE0O+o=;
        b=JSpifM+X/Udm6va7vXDcen+CpWNHDFPSuYZLRSP9itK3QIweuD2SXYhm22C1cC2Hyc
         2naALV2D4wTPcvh45ODcxSgwiy6/Y51XmnHCJO/MvKmHqe2NerIjFPkoHw92cwwirZMT
         ES8ZTgL7eVh3C+3h2zCrTJUlo8DKpJCNPwbetzFVtymudINqtZ/HcoO7AhIi/GfOQQAs
         QOiSDz/zWK0/yyam7lU4NIdXQIAXBSmDhS9Pvka4toSFEid6JzP7lveQk+cEpJ3qJm95
         5RY3gtcmpFfwCJNinaLc0B8/AAqBz/dXfZQKZIO95RYZziqNwVFqZT6aRTJ0fFnx6/7O
         0ZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661383; x=1747266183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzs2UwtIJQNFywCbX3keywjm1hoL8ZwFtVh1FsE0O+o=;
        b=FxnUnW9hPPJrAgSlgLbikBWmXdA8n7yivRfXfziy8mLBuBuwzhzo4yhTpIkyDhLrS1
         YGRbgeKGcuP8pyWjKzkLgn52QKTCtDkuhYCU/pBZf/R/9X3N5aqZqwCIlkuqY3+Yj41F
         IDJMhu7su9NMUKgxkPreIwKYzIn7VtLXLQ1BdfjHdnqAi7hJGOHSELjBHZwiHLTFEpa1
         Vre95sKCINb+iHRtgWUFL3W3GveM4zrNsqgMcZPYu+mCV7z3AqEunq+9uDGyUQpPqpbd
         bLYl/tw8pA5+RiQY08F3eMcyAzvcp9TQo4ts5v8Jo04uAgl4IZFfXfhVUGM6ghOww+RR
         IpHg==
X-Forwarded-Encrypted: i=1; AJvYcCVq5DqS67H9PeB9+Pd5uoghDnVEWScEq5Kr/2GP+sK7mNeO2NwtjBRTGzpNxZk5guq6FlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YynwEs1TV+D44ahH9+/Ct/4HI753RrP0xTEvC5LHAKBXyqLR7Vt
	zYcr3RbXhzfo2aaFivtIbZoRXPVeshJCHKwL6+kUBYIeDET/GyY1SVFIC/A65rs=
X-Gm-Gg: ASbGnctM6EO6VcefazgOT/pWqOjYOTAlCrFzW3PKEs7QVWCdjZBxonSMJhoHnJeVwjB
	wOapVMhwj3hw5pTFDxVXfQkvwXdZIvMIDnO4zG2dEX1NRGfdMhWWrIBqeJVCda0EmP6xLM9Zwcq
	KabOONAXbFBQJ/CnQNFMaXhyvZur4tmGA7avKpiSnz3SQuorRGuhbGyZf8EpvBiqZWuuo4k7wTo
	dXH7ab3x2Z0xzG8iWP6VaWhpE4AxN8vIj7g/keKf7R1rCjTSTiUTeP2S5X2bT4Rox9DQTuTo81E
	ZlQSeA49mlToe5Hwx9yhl0twnS2GYq7hwLwM5WAo
X-Google-Smtp-Source: AGHT+IEBA0reiSqxw/k61eFRA3NP84FfIPAPz1InObOyyt1+kBS+UY/gwjXbg6ZmBzPN1LbTd/0qqQ==
X-Received: by 2002:a17:903:32ce:b0:226:3781:379d with SMTP id d9443c01a7336-22e5ece3fb5mr76592015ad.33.1746661383483;
        Wed, 07 May 2025 16:43:03 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:03 -0700 (PDT)
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
Subject: [PATCH v7 23/49] target/arm/helper: remove remaining TARGET_AARCH64
Date: Wed,  7 May 2025 16:42:14 -0700
Message-ID: <20250507234241.957746-24-pierrick.bouvier@linaro.org>
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

They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
we can expose safely.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 18ac8192331..e3ca4f5187d 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -29,6 +29,7 @@
 #include "qemu/guest-random.h"
 #ifdef CONFIG_TCG
 #include "accel/tcg/probe.h"
+#include "accel/tcg/getpc.h"
 #include "semihosting/common-semi.h"
 #endif
 #include "cpregs.h"
@@ -6565,9 +6566,7 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
 
@@ -10625,9 +10624,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
-#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
-#endif
     }
 
     if (cur_el < new_el) {
@@ -11418,7 +11415,6 @@ ARMMMUIdx arm_mmu_idx(CPUARMState *env)
     return arm_mmu_idx_el(env, arm_current_el(env));
 }
 
-#ifdef TARGET_AARCH64
 /*
  * The manual says that when SVE is enabled and VQ is widened the
  * implementation is allowed to zero the previously inaccessible
@@ -11530,12 +11526,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
     /* When changing vector length, clear inaccessible state.  */
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
-#endif
 
 #ifndef CONFIG_USER_ONLY
 ARMSecuritySpace arm_security_space(CPUARMState *env)
-- 
2.47.2


