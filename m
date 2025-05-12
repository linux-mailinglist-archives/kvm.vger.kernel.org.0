Return-Path: <kvm+bounces-46223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86253AB423A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E797F16E81B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8042BF96C;
	Mon, 12 May 2025 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U1TMv4s4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643432BF3C0
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073134; cv=none; b=WIFVZrqnnsNR9BKFQGmi/7cbkKunqSA7weFrDwLgwRYm7wVAE/+SzRgX5I904+3xdT37KOSQlCsg/nJ2jZUNrbnuIEHvssWRuFbCDNYAN3DEfVRTPW94RLPMfKARcVMYrWxHmQ0sj8p5e42EElXz/IkOIZW1EB+JT1lSIEzkIHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073134; c=relaxed/simple;
	bh=tZh69ADPoa8BGKnVUC7QOrC98CkpyE3YFEBrIYEQvvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJUZl4zIH5nUmWqZE7Znj87+ks1YoVm1gLe9DkhMGRzjLw2/C0hrqY9vCZOYU2kd3xIwtxtkvQS8dXEwMC80AgDrS0qh/JfFqkZDzEy2n9+0RnXbb+Wx8HNzhYG/jPPIAv22T8FZu2Pdf1Zh3z1gvlWOD1FShQn62i8LDOIZO5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U1TMv4s4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22fa47d6578so48223035ad.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073131; x=1747677931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QH1qfLH+/zCru9XWBwZx/jkW56FRhaJPBlyr85eQl0I=;
        b=U1TMv4s4DT4vBYoVu6LuRAb0B0h14yKCoEYrpvz1SuzCqpv/J6F3cXBokV2GNyPH+m
         2OJTnPt8VBO0lrFiBMkPGi4+UuimCwWW1aLh73ZEHn4ohtPCNNSEhwLROn8nNPlhveZD
         H5ZPjYvmQ6t6HEleYn6FmvntEwfopTjyPzaGkN36Gd+bbHZG45OfI6oGeiacW8gNQkQo
         UGAQbdMhnK1biBJSYQi6LL1uQwP3KQle9qae+7BP13XzGTBHZkXajMB3ObhRgnRZRtwT
         yLTRWnPEL58Fb0n55/mO9i1UkNE1eGu9XrPX1EFXWCKnB6e73lXRmIlau7nsI1edyHpr
         YkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073131; x=1747677931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QH1qfLH+/zCru9XWBwZx/jkW56FRhaJPBlyr85eQl0I=;
        b=dh+op+0qQhctkp7nDuqwQ5n+uJ2P8GbB7xAcksyEvrFl1FmK2Qoy4J5YuCJbFoADHz
         +0wBjUOBv801SNE9sm6FkF5LPcXmH3IOXe2TQuusT6A6OnWS+5MRarVMIZcjqra0lcrX
         fsTutkdogULfugazzCMKHM2HoOV8Toljr7ETpBxbmWh0/UwcmgdL6QVQI3jKTcNpar4x
         sParIxFA2+iOW7Skj9ifXV0M6FcDwZvGM3YogQiyHiCZNPuPMCH6K5ZxtQL/5jQ01C2r
         7GgABfaUGwkAaqi0uybB8jGE5BaAcms95/XuHDCJGcwfbd321wHBhEnOa41AZYBF0k4W
         77Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXJNtVaZVcAn86GstrvYx9cgSSFLv/0zScLN1BupZfgrVcQAZxjumC28SSiGeIQFS8Tg40=@vger.kernel.org
X-Gm-Message-State: AOJu0Yye0pKzC4PEYO/J1FSGD+DWHmJPG9mf24Z0fi2WdKUY35uJH636
	1bldstAu+r7TeVTOTZWuFJLGWIRmy3prkZEc06C4KH2x8ibU5scSE8J9pUHEWEU=
X-Gm-Gg: ASbGnctpGpnPxm5BRbLAO1p3LC0X27TkYpcI94hvazteC1PXPpX4r1us4hfP3fddLqv
	2cA/NKluv/s3a+KHCLb8cgcci60jluj0a3ns9i/JqRxmZPrCinu/ru1ZqHk2EP8Tj580XmCqlMI
	J0VU+Ur6oc5nlNAk1uY6YIFHQQayXdcLY/TvhyXa6dcQqLbeBM1LTkrwEcAvVPfS37Uoi5ncZ74
	+JNj87QtHvj6OMaKpwPg5rpcO+dgR+BSYfTqZFLTGgFTFSpFNEjbM9lzKbTNxZdd5LA5xK7KQe3
	HESwnbMi7uQPpVbdSIN8GChXC5oIlInJsNyQVnePm9Olztwf1xA=
X-Google-Smtp-Source: AGHT+IE3cGskjzjRojgLkr1I7mB9wKn6lFQ8dcZYSyN1P9AGSzZnigX6VHGug8trK7WU8FJVQVXhIg==
X-Received: by 2002:a17:902:c406:b0:22e:7e00:4288 with SMTP id d9443c01a7336-22fc91cb78bmr201982785ad.53.1747073131634;
        Mon, 12 May 2025 11:05:31 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:31 -0700 (PDT)
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
Subject: [PATCH v8 22/48] target/arm/helper: remove remaining TARGET_AARCH64
Date: Mon, 12 May 2025 11:04:36 -0700
Message-ID: <20250512180502.2395029-23-pierrick.bouvier@linaro.org>
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

They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
we can expose safely.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 92a975bbf78..aae8554e8f2 100644
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


