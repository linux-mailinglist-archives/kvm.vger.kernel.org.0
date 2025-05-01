Return-Path: <kvm+bounces-45043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 243EBAA5AD6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D16441BA776E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0488126B2CE;
	Thu,  1 May 2025 06:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yscy7R09"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D1627781B
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080646; cv=none; b=Shi21NPBvm6pHjVWQLgLH3zYDHJJvpbEP0fVz5BT80/K1oyZDtjQvhz92YgMgNpy8aRj/n/l8b3RnrvZDHY4uVw6cM4BE+lEANJNO26slmLHqRJAoU58qtdVILRK/l4JlFkjzKxUdTyAkV9IpbCEA8Ae3aTO8BMtf62Omxb/NAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080646; c=relaxed/simple;
	bh=uLf06Zd6mwzqo9+FiczvxBcPq6muvexgZemG6ugV6iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxMeIXbp/JMKPzwsIlzy7BMKEmDingMCRIaZcWlhaKK14ScWnWzKjHfO33yNTDDwZt9vg7OwK3BmJnbzKIzs4SLkJIetkbZVv2xjMPn1mgSBoTdW0IIQy6WPLVHDK3/YKRYbr+iddtTTPJrrYGR/Cz26CrX2mtXJ6yGELcT3+qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Yscy7R09; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-736aaeed234so664462b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080644; x=1746685444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nytbMb4sgZrZygEF1t706bwsFhUC7rAu+zrbjRJ37jY=;
        b=Yscy7R09BwMYsXQynS1Dmur6VAAEHKdqDTxxEycmeimw1A3I2qtxxBnzWmtZdX3CBV
         tpuiYMtjDU3PocbFwWwPdIEf4oeLCCLosN9p5/CQ5F+O7rAAJpGxuVO2Mj3Ki6YB46LU
         F7ltMF9yelv5MVpVYcOiLR7wtpUz+ST+mQw0f+To7K31W0m4k08MH0oY9cVIzNuGA/x/
         SubX/GzOKc3OmN8tRPgKRLzgz5KzLOK0XIIfHbNCkIH6yFjuXRfb3hNCVBbcDQ3eoG9E
         xUjHRdVrfDCWs1dyJzBHxekz64R+2rYnYH5LSWlhbCDAE52jKb4igk0RddrKtYebpfA1
         Ft8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080644; x=1746685444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nytbMb4sgZrZygEF1t706bwsFhUC7rAu+zrbjRJ37jY=;
        b=vQSaPiCl2t7a3dAKfuhMjreBB3i/2APnHakk18z44iKRhgG1KtIW6yk2va3K3ywUc/
         ch+0YBlI32q/ZlMtcPpn+c7/WmBIksru7OZ7AOu+DUH1Nlo+bebI7aBuuZqJmNkWrjyP
         wEY5ehc0sEqRv52Zm03itMWwbQ5iZ6ofApZ8IGB9W4YYxTIeiEmMdmbom6Yr8+kke0Wv
         fyw+kDHZSkZOFA31uKm9LSx8esx5tmuwdwgp4WYW1LgP7Fzf38VmB6TEcGHbQaeGwEYb
         9XjKlqha7oRvuko4fskQJo0MdaPT3lucW4oUZT0VL45rNq1ohKstpNPeUiEfZxHVitzl
         QNNQ==
X-Forwarded-Encrypted: i=1; AJvYcCX90fl1YB4UnnkhslmjbBB97ZiihbgwxESBC3xZevsH3DEDdshe/KX0vLkqeFk2h8DdgIM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTh8rrH3NLdz+hUZK1YXfCq53BK876RhBBLMxlnqBu0aW/5nm2
	lFd3NFpmhbWWKGGMY9kEaWV0W3HFMC8T1yqyaoT2H3xKmAv89nkDy/SKHyOip9E=
X-Gm-Gg: ASbGnctEQO85M8uzI3oEXo6LPxuddLLAoiH985bysA6KcNCYlSPfLLlxdnfVLw/IZ+p
	7PELpJsEpyNhAlBi1tauIv/LbPj2jAOBrXpd6y3kDtLrYxNAmXVyOeaCjexaTrrhp3gAG8fE5Kj
	DEqMkV3FVks3EpPesLwAtD4oQxQYewfPkSWDzvUxVm6/u6wKmBrk0Fzp/EMOz49JqpG4sQi/BcV
	zKCrLeoeAu45PuYA2u0tXcB959/ccsUG4gskj6F9LMWp0/AEjzAZxlKgqaW9NAEKYr3dNpQhRhK
	Nnp6UO6iL7gUgu5OedtPgUchjH+V5EYW/uFLYOWn
X-Google-Smtp-Source: AGHT+IHfkV3iPRLyjYnlQE65kamxUee+Atz7k3DbAE140bq5p4dc3YmLffIe7x96k+PR8VB6puKHcQ==
X-Received: by 2002:a05:6a00:179e:b0:730:95a6:375f with SMTP id d2e1a72fcca58-740491a556cmr2192248b3a.3.1746080643897;
        Wed, 30 Apr 2025 23:24:03 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:03 -0700 (PDT)
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
Subject: [PATCH v3 14/33] target/arm/helper: user i64 for probe_access
Date: Wed, 30 Apr 2025 23:23:25 -0700
Message-ID: <20250501062344.2526061-15-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.h        | 2 +-
 target/arm/tcg/op_helper.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/arm/helper.h b/target/arm/helper.h
index 450c9d841bf..f870b707c7f 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -104,7 +104,7 @@ DEF_HELPER_FLAGS_1(rebuild_hflags_a32_newel, TCG_CALL_NO_RWG, void, env)
 DEF_HELPER_FLAGS_2(rebuild_hflags_a32, TCG_CALL_NO_RWG, void, env, int)
 DEF_HELPER_FLAGS_2(rebuild_hflags_a64, TCG_CALL_NO_RWG, void, env, int)
 
-DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, tl, i32, i32, i32)
+DEF_HELPER_FLAGS_5(probe_access, TCG_CALL_NO_WG, void, env, i64, i32, i32, i32)
 
 DEF_HELPER_1(vfp_get_fpscr, i32, env)
 DEF_HELPER_2(vfp_set_fpscr, void, env, i32)
diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
index 38d49cbb9d8..32344bd06d1 100644
--- a/target/arm/tcg/op_helper.c
+++ b/target/arm/tcg/op_helper.c
@@ -1222,7 +1222,7 @@ uint32_t HELPER(ror_cc)(CPUARMState *env, uint32_t x, uint32_t i)
     }
 }
 
-void HELPER(probe_access)(CPUARMState *env, target_ulong ptr,
+void HELPER(probe_access)(CPUARMState *env, uint64_t ptr,
                           uint32_t access_type, uint32_t mmu_idx,
                           uint32_t size)
 {
-- 
2.47.2


