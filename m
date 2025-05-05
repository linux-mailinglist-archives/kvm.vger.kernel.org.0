Return-Path: <kvm+bounces-45503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F20AAB039
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:34:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CFBE7BCFDE
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6D72305F2D;
	Mon,  5 May 2025 23:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MpzgtKFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6A82F8BC2
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487245; cv=none; b=lhz42jZBN4D+9jT4pOkKRmAEruY0hmfa/nYOd59YXJcOOVHRxuXIY8Sp27/ls+Ru6HPk1M5PNORQokHAYCJDpQD9QoX1Mfj9StCaxYZnwxW5tusFQdDF0meKak1gH6QSBC4vZv4itX9dY/LUBKfcoU2jI/q443e9dcOQKlAXguE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487245; c=relaxed/simple;
	bh=sOxadGRh6q8JpsoyihDnsqMHi2X7Vww7qOjy9/V9yqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUAzYhK+tSY/Son36Hyb5mGvaRkQUxcJD/X6P48oWs6m7NY1gM5E0/VsqsndJXbjtmJg2l6R4QTDIg/rJ3Z/ahBJUaXXrSk/TQIxqWTv05B5tRQJ1wAJ4NnjDs9REsdW/ThjN6HJSPVvaPtzpRw8N6dwQiRHDq0DueC5M94NtVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MpzgtKFu; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-30820167b47so4721720a91.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487242; x=1747092042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tgtkzpe8JxmQvRJXZCyTrKxE1atR2TmNo3Re2v0+pHY=;
        b=MpzgtKFuVRlj+Wx/qjyuArVLT+fN98kR2AecEhBVV+YeufdFHYTbuKxi7O13vB4rZn
         sMY8202gHBKg6J4tRNi8FwGj/CWTJoqeq47l47nFAfYummi35gH0t+kFX0NkjdUjycP5
         KAVXmbLqxyhURbznlnL0S5dlZ0o195BTWoKO5TnVWvSHRKG1AUYizvUdcYL3WmVcdLip
         xDmL/RDY5TNOZYxqSwyJ2otiiQTBEjwNIAamCJclC/wIWI3M9G0+aXmvX5vpXzmLNJ1Q
         yMpe9aucB/vUhXfnez/Icw+8Ysj78/Vr43i+kUsVS7nPf6UIvHmxurkeyhbtUf7ivsYH
         LqDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487242; x=1747092042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tgtkzpe8JxmQvRJXZCyTrKxE1atR2TmNo3Re2v0+pHY=;
        b=TaoYQZokwUULJFrKpIu9XxgY755A9fxjnwNq3fOoRuxUq0DWws0okTnf6sqJIsQ0RT
         ZU7EzuDE78rV/3yIQk0Iq0r/m5sL74yCrgYe41pptyTl2yMkBLDBpmEkZAmAHG374Vwc
         Pbm4NUlI4PJNQoCL8/lsmHM2T2jfNwthtQm+uJGKTLdabc15DFHAQawS9nADQlmATdvv
         i5l8QcEGLTOaJ1rTbBqHsFJwuwL7VmufMvomKLoOPLbH+pL9DQD1QRgSKX3/kCtdBdEl
         53XF1qBugaAqgckGso6u6dBiw6jf0W3f3HVmtBcwE74KGgmZmpHGMT49DfSu67FtKodX
         3f7w==
X-Forwarded-Encrypted: i=1; AJvYcCXLSRU31nGQH6I3wNc9VlWYmEYs6Xmp/OL+pTa75OiOgGNXvaDZam9yYBLjI4OGLTPaziM=@vger.kernel.org
X-Gm-Message-State: AOJu0YygEtw+DS+y0h6NmxY1w+YL+O5yUDCYonWjozgwFdGknrx/9P8+
	v9BKAzyiNjbJlXdcnjcwk2h/jKvMsbDbNi4zXZrck1ql8brHIVsUSnCY2WHvBIg=
X-Gm-Gg: ASbGncuHeEAnjmwulNBMB7CXT1SLwjruzmy2P6clZTL3g4Ux21ppIV/3Y8BjHhl/8Dr
	OsANJv2kLR9vSXPTRG1ERTqwEk4BnzKCtX8A1XCluIT6X2WozsDHhkywoLwm33LX8G6Ivo5lVWd
	OpbNemVsNOPs6BeDu4pGrsiSgIMpgCL4cy58GTJvREwLA4fUHO1mZpNRl+A1x+l28mO24LqeOx2
	G/GqgJ9T6EbBPr+0HK7d/vjFpHba30SKYfiSASGEKoLRDfJKIwdziA4VHl0j4jmBwYVI3HgquLF
	12bkwNd0pjTLv2egW6aIu/B8ataUfSPu4SSeBAzX
X-Google-Smtp-Source: AGHT+IGWkM8Y93kjIHnya9pzfJRAlQyMK/kyKFEpmMjkEHy8e5TjRZCSQClHRiEUpiFWdNLxftt7RQ==
X-Received: by 2002:a17:90b:544e:b0:2fa:3174:e344 with SMTP id 98e67ed59e1d1-30a7bb28833mr2024932a91.14.1746487241836;
        Mon, 05 May 2025 16:20:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:41 -0700 (PDT)
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
Subject: [PATCH v6 24/50] target/arm/helper: remove remaining TARGET_AARCH64
Date: Mon,  5 May 2025 16:19:49 -0700
Message-ID: <20250505232015.130990-25-pierrick.bouvier@linaro.org>
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

They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
we can expose safely.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7e07ed04a5b..ef9594eec29 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6565,9 +6565,7 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
 
@@ -10625,9 +10623,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
-#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
-#endif
     }
 
     if (cur_el < new_el) {
@@ -11527,7 +11523,6 @@ void cpu_get_tb_cpu_state(CPUARMState *env, vaddr *pc,
     *cs_base = flags.flags2;
 }
 
-#ifdef TARGET_AARCH64
 /*
  * The manual says that when SVE is enabled and VQ is widened the
  * implementation is allowed to zero the previously inaccessible
@@ -11639,12 +11634,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
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


