Return-Path: <kvm+bounces-45781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9D34AAEF67
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13A311BA7AD8
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516EE2920AE;
	Wed,  7 May 2025 23:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YUK0c2xx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096972918DA
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661378; cv=none; b=LsLS5zwZnaXS1FAOrfgyprlxJCCDXiqCQAxWBGKX1R6WbQyUo05eDMCXBWryWK42jARznVlzWQCdjXloo//3By/5WMbMBQD8F+MHo7mApiuMYLm21+MAwxJEIY/g5ezSsQvW9fn/6eQGAH5gOsRdacAQOKl6QSQqJzzS+Oh0ZHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661378; c=relaxed/simple;
	bh=Ix/vh+WGsybYa5W3n/1eQPoqRR7H9WGdcnKgKP/tuSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc7Hupx4UFvAEPX+C6BsLONxpru7dJJKc8paeL1PaqvYb4gg8Ta4iP9tbLNPYPYDXbGYJiiLS7aLtmK8zjp8s43eEzDUByVAtkUWLEXaRyW3hFiGVhW+RrXh3ZKMidxNwIQYYRbc+S7bRm+zu0S2X3xTBikrRfzcOMx3iXWC/iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YUK0c2xx; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22e15aea506so4831115ad.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661376; x=1747266176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylmW/mRzMuupLX6PASMDyZOaBb+Dv5gnstRJQXcdzYM=;
        b=YUK0c2xxrsao+JY8xrnFMv2kAiYeGLNPHbKHACOOp/eOVhWqxKxTlyHwrFK/RhJFoX
         Y8o91rMuXM8VOKApP7mROKnIZuoCbe+uoHHF0oiviuhmFom7FZdVH7szTey046LRsrj0
         HCyngXYt9SHr9tdeFTSQG4QOZZsz+ndAmt0I9axGQmj5eelATMpngJfb8yF3vv2Ee+pP
         VxM3xPWqgqGkCM6i++j2bOLWiJDYnaxOhHUkARxckKIvM7gRMwfnlOGTVQ+izdcaMX77
         d8YwW3JkfTtICed4oHIzwAoRjry0mUuEukGKDo8PAUyMmnftoM+DiNTGQztYU4UPqhAG
         AlFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661376; x=1747266176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ylmW/mRzMuupLX6PASMDyZOaBb+Dv5gnstRJQXcdzYM=;
        b=TkgUIoNxcynLLSZPp6lKkP1CstInP2fnUvVI9bvJvFXbEoZB03gduH1+5rjQRdGDSX
         iC3YuKq8XG4oAe+BlY48ayLYiOtfQTvuLdBL8B2/ajim3HBQ0Sw9SDFE92XBg8hiooKl
         E99EfajjgZC0BQkSA3zQJwp8FqaWZ1crGPQ7iojtwg4j6Xea/nUtKEBiAXrvT9Kp1qvW
         ZwXQ6Dh4GpWXzAeO+uVYHb2Nz5bziPSAQWiX0VEKdh1gu7uks+i/nQuMjfmgPTx/OhVe
         nxxbNHsS/rSJqFLgzIGUE8PXCgmJ9LBDH9P7W4JHBTTOsdfjiPUck93UH1JoHq0T9fNp
         ubBA==
X-Forwarded-Encrypted: i=1; AJvYcCXpj5y1A7MwKXleiczwKtanfszviMwWYdFa6ayIWoIx1FCLA0783NwEa6mslFxNb3BN4Zc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqQOxGKDY2/5AB6tO07fp6QcGRTj+zeeMQXcVzoZuu6Xirg1zs
	/8q3YEixzP/1NcyT8GI1ozwTo/4c6tMxaVyuhTHt6gEuUWilkf/uJtsfjR1qSZw=
X-Gm-Gg: ASbGncsFD8YwnSCTvKYF7f1ut3ua0jH4RYRjfeJ2Xg2PSyjaN6Fo6UIidmQwNg1pfsq
	9oB6SCPRc/jMKVR4HwyjiyRqjcMQmfBNDfObNDNash9Yr/pjI4IJBV4X8hTr4DOjZLcDM2bG6jv
	PBHzsbhYDFs2v9wHwIxv+ncjh38SX+3kjuIy6fZhLs/TODvoOPZW8l60ttGjgjhvoMmMe5aQEEG
	E5FPjsmlE1SLZbKHpPJEWlA9vs+EqJKl17kTc02ZyMA2HMcf74hdmfwhk7kMVfG6vqkrmNqaLXW
	4BE0inT35P2Z9e8ZyT/G2EpH8tg2Zm+c0TRFa2kI
X-Google-Smtp-Source: AGHT+IEpWx9aGe5EwvwUP443E+5HNMG+cmlLCI/w0wtSLqbMMqVFdYEOw13y2ya2bBtZ4ZjIU1REbw==
X-Received: by 2002:a17:902:d487:b0:220:c813:dfcc with SMTP id d9443c01a7336-22e8e24a912mr20255915ad.40.1746661376490;
        Wed, 07 May 2025 16:42:56 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:56 -0700 (PDT)
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
Subject: [PATCH v7 15/49] target/arm/helper: use vaddr instead of target_ulong for probe_access
Date: Wed,  7 May 2025 16:42:06 -0700
Message-ID: <20250507234241.957746-16-pierrick.bouvier@linaro.org>
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

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.h        | 2 +-
 target/arm/tcg/op_helper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/helper.h b/target/arm/helper.h
index 95b9211c6f4..0a4fc90fa8b 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -104,7 +104,7 @@ DEF_HELPER_FLAGS_1(rebuild_hflags_a32_newel, TCG_CALL_NO_RWG, void, env)
 DEF_HELPER_FLAGS_2(rebuild_hflags_a32, TCG_CALL_NO_RWG, void, env, int)
 DEF_HELPER_FLAGS_2(rebuild_hflags_a64, TCG_CALL_NO_RWG, void, env, int)
 
-DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, tl, i32, i32, i32)
+DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, vaddr, i32, i32, i32)
 
 DEF_HELPER_1(vfp_get_fpscr, i32, env)
 DEF_HELPER_2(vfp_set_fpscr, void, env, i32)
diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
index dc3f83c37dc..575e566280b 100644
--- a/target/arm/tcg/op_helper.c
+++ b/target/arm/tcg/op_helper.c
@@ -1222,7 +1222,7 @@ uint32_t HELPER(ror_cc)(CPUARMState *env, uint32_t x, uint32_t i)
     }
 }
 
-void HELPER(probe_access)(CPUARMState *env, target_ulong ptr,
+void HELPER(probe_access)(CPUARMState *env, vaddr ptr,
                           uint32_t access_type, uint32_t mmu_idx,
                           uint32_t size)
 {
-- 
2.47.2


