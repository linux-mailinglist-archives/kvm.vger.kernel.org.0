Return-Path: <kvm+bounces-45317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3B5BAA840A
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34F89189441D
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E79F1A8419;
	Sun,  4 May 2025 05:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FpCIsOCR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A0A1A2391
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336583; cv=none; b=LfDdJJbwTH1+5NaEqgXU2LWltEI1eK7bYz1zT5wslItcBx/MVdlvbPwLxqOa7G+5hBsKybcdyd78W/xvoFYvfTzLRCQqlQIuhOmthaC9DILSctFAjOf3xt9QVxlatPYZTGKjASBaNiiJEmmFEqesBX00UVwc8C14kOhkrWfucdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336583; c=relaxed/simple;
	bh=xNgKnlzGDC9CBvIlOl8FIFdA3eOFJEcMOOekpB63OO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrcw072sYdgklEOpuPRUETEC4K6qxwfjZ8/E6BnX6KDMlpIzfcKlRDQDJWBl3spDu6xdHtD1pjX0G67olHyL2o0LJAZM+NkomACud0Ik5O7emorIA532H1dYzSzlsnx5y4GC/VJWK5SeCZG0ZwQUmMvFqVX+AMxYGCgBV3G/Wyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FpCIsOCR; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7399838db7fso3535956b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336581; x=1746941381; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39PScigtuz9820KEKAK4bxrnXJbLJRdrPn0GANchp1o=;
        b=FpCIsOCRWWHig9MzuZVEZW52nqfQVTkFX1LlpeLpimvOeiKbEKZ0tVyH8ZlrkGSJhg
         4UpEisEyXqsh9aV4S4w7hUphTFBjxIxcZ+QjW78e6KA6oHo1frDSihDhth9fd0Dv8M+z
         HvxyxAxBFn1vq5uqVOum2Co3tdIzbx032KHatwnqTAayA96L/2CjtGwnZTmSoE4y1slY
         /cQ54L5OK2Ye1ehPRpnIC4aY9IYM9sIuXGOHomZsRjct/6yw+Bvni5MQlFTbVVyYnjsJ
         v6Bo1ZKiArHMjt3GoETwnXXI7CPiY7xLTxF7Lbnb0xSzE9WtWVaSna8MGsiIFwltFq2O
         EecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336581; x=1746941381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39PScigtuz9820KEKAK4bxrnXJbLJRdrPn0GANchp1o=;
        b=ZvXpSF6fYer734/EQ596ignAp6FzDlB37o+goDJ+HkkW/gP6eCbwQrfbXQ/RHpoGQ4
         3VnaJ4p13wNIxHb4zhz16/Ry9cCjdJTObYt1pjOgWVR/3x6uWtc0QFh2NuAGk7TNiqeN
         Ouakgcaioo7NqjoaiRzPtioc8zFar8QEWGVXiHDD9l/Yz53iPcTXH/+cr9l3OYSAXlxw
         AFyEwLlXoPJ5WgPF4T2wwEDujjyampP4dhCVsNxm5nP2leSuaQYsHxc85o2i/dtSlJbu
         XOWHddQhuwoKR5lcfL7yDBrfjkCItk1n0FL/kjDubkiQpBJ66MssFci04fkji9pQN+Sb
         sJuQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2sYDLuPGpCQEFUrevZS2RSudTjR+X/wMIF/MLbl9CrdlV6ILYtQrEVjzulCBRxlVBoHI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+BIMCgabEy/5vSMaund1GHw+iFE595Bo31rgVkNwStFVtYCSN
	Y0KuPLsn9RJX+TtYI9AYPwJ3ZQHFJDIDQuhIaHM41X96dHj7jL0nCLOSPkotAgM=
X-Gm-Gg: ASbGncvOmHsdiFWHxxa0SO1K7xFrCNhzEc4+7L4xYkWmnP929tljZsnvnWkgt/PQqL6
	0mPREPrpwyxFEkyH9UII7kCRD1vCRNDPGR1GIOPqae6JxRkZA+xyTUN0jWhQJsSr6hOllcEqoqJ
	wdIc6egB9m/u5BkaWH9nGu+IcVySY3DKIo0C+X0uK0EJ0/eqarrDKs2MYfMXTTf1SULdJQShDJb
	EUp1qV/cEecrepSvqOxQk7n589S1+eR0a6wLWFJb5aDDN3qj+UJvzrjxno5O8hJVKDmHeFnLGHo
	FqIQP/ZGT16QHBBqAfyP+XOeXs/lm3qmWoW811mu
X-Google-Smtp-Source: AGHT+IGTptIceRjAxyTX2FKxG69Z0atmLZhDjlVRkXVmilsAn2sBjvy7HHkao4bpmRwP6OnfTy6E4Q==
X-Received: by 2002:a05:6a00:3b06:b0:736:b923:5323 with SMTP id d2e1a72fcca58-74049261a39mr15380704b3a.10.1746336581216;
        Sat, 03 May 2025 22:29:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:40 -0700 (PDT)
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
Subject: [PATCH v4 24/40] target/arm/helper: remove remaining TARGET_AARCH64
Date: Sat,  3 May 2025 22:28:58 -0700
Message-ID: <20250504052914.3525365-25-pierrick.bouvier@linaro.org>
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

They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
we can expose safely.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 1db40caec38..1dd9035f47e 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6566,9 +6566,7 @@ static void zcr_write(CPUARMState *env, const ARMCPRegInfo *ri,
      */
     new_len = sve_vqm1_for_el(env, cur_el);
     if (new_len < old_len) {
-#ifdef TARGET_AARCH64
         aarch64_sve_narrow_vq(env, new_len + 1);
-#endif
     }
 }
 
@@ -10645,9 +10643,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
          * Note that new_el can never be 0.  If cur_el is 0, then
          * el0_a64 is is_a64(), else el0_a64 is ignored.
          */
-#ifdef TARGET_AARCH64
         aarch64_sve_change_el(env, cur_el, new_el, is_a64(env));
-#endif
     }
 
     if (cur_el < new_el) {
@@ -11552,7 +11548,6 @@ void cpu_get_tb_cpu_state(CPUARMState *env, vaddr *pc,
     *cs_base = flags.flags2;
 }
 
-#ifdef TARGET_AARCH64
 /*
  * The manual says that when SVE is enabled and VQ is widened the
  * implementation is allowed to zero the previously inaccessible
@@ -11664,12 +11659,9 @@ void aarch64_sve_change_el(CPUARMState *env, int old_el,
 
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


