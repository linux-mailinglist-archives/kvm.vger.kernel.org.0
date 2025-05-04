Return-Path: <kvm+bounces-45309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C53E4AA83FE
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37DE7179F66
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1958019CC3D;
	Sun,  4 May 2025 05:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d6PNm+t8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28431991D2
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336576; cv=none; b=mUKaA5vroqtRacIuYS4MLBXBlS8vWMKbX5O83R5j1HkcwI/99LfJ9BoFes4pQsuKjxAoVZs+puOCdbG5DLDInFtbUJWvJtRKaZYXhmxq0gNkDq79IHB51VWRI06Pm+obsjJ8kx/6/+afcGwAZute+RYmxRbvq1xPzkn23oKEalA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336576; c=relaxed/simple;
	bh=PpobY/Udi5mRt4jrxjOBsevMUQOfhFs6Kw8lbRo5UfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MskjQ+Bvvor58xdteJPgjL5QN6t7l4OhOXejkRE6yRgryARjj1I7YrXT0wVbWcXJ3BmMNyIEzRb5ECtdIB0HOJmFRE2TEh5YBFM0uqyh8j3DLEMMNPiV1aqAPLKF/SXWzI1Hn6oZp3eNHciXtISLrIDNQg2GwHtgxgrld0TtFN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d6PNm+t8; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736b0c68092so3043399b3a.0
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336574; x=1746941374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLs0hyci0rcituyWdBDtdIR1bhX23Pfro+/0t+Mt9oA=;
        b=d6PNm+t8Wm8eQqlaliZQJZnfxV6rG0Bm6fcrVnH4h8/DiNmfpdRLxL1K/2SvWPXn/H
         1yj6AcZ0f5iRTGB2R09O8J+YB1QH3MDEbjIqAjcM4IT6oK2+hQuth7W4TE7YVLODGpAB
         WSqoLnVAgw/1ATkyJM2VB6tmG9s6Ktw7UXbhc9/G9e4f347IuV8Ba4EC9TlFkkjEmf84
         TcBNebO//JvDRkHykjVny8q1i2xDqDeOJLlo5qC0OvybGkLAp4jzn4G2O7uOlKPynBkL
         A7yW9EYGkHmY2zEi+y+xLHDsqmJ9yk7ECsqB28dODmhk9FUZqwCgU3vS5Q3bizvQO6pU
         cmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336574; x=1746941374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLs0hyci0rcituyWdBDtdIR1bhX23Pfro+/0t+Mt9oA=;
        b=TSK3dlx+trn34N1jrzDillau0BDzH8dDxMWZtQcZjjMkO2aaXaedy9MmborE8tO5dc
         m7W8jCttGkmHiiUZcPcqe6R5Lh4OIfn+5q96j85GntVs05RbyMiZ7cn2KGW2vPxfyz2Y
         J1WLTd12vGnD7QdTq4Z9BNmeTp3c1Y3z2BLH5B3Mzzin1rmawgWQt6fjtKszykAQG7bE
         qhxXqHl9HtrLqC/NdglrfCB513XMD2el0jsO3vc4xuZU5KTQqQFhKQmhXiLbLf2N8ei9
         OQ68a7TsUr4VC2HXYKKoTKSwebuuQZfK0DMtUFJDDq974+HBSIYHYLWxz62IdqogERcE
         kc1A==
X-Forwarded-Encrypted: i=1; AJvYcCU8O0e9UaTNdqAunTEGqXUF/nfyFuQ8Zn79yKjc0gZ8flIsrrxeArKKXGQN93aEMMVcgAM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6tpJi9K1eR6RGG0kZl+JI5YllZ2s9u+IY520u//oU3U5qzxV9
	C9CkN+YZ8RGQ+7SrObCPy/3KbQdw4FKK/5SiPkWQyw9qK4pigna3s+QZWWUkR3ZswxwCKrVtkDe
	Oojs=
X-Gm-Gg: ASbGncvJfE7JVPOK2DXyfK3wsqydtHTu2804Yn7s7YyueTGmaJn1I8tpkbvg9vbMCs6
	a6L3NxTJ7wGaGWr0eJrTZZxob5XhzdeA77sCwHzU3Q3bqwU25pSeNLZVPRplRA6c+IlO9ZOe37+
	jFmRSOMrUbqXPvODE/i/6mdTDpm4e2M8rIZS2awQrpM+713zR39NDbpuj+RJgd7YYVv2mJVf7Ew
	BndH6aDj2qs1d7jMuc4jhwuMZXpmGl4h7bF0+5+TBtVLDDhhvm4dSkNDdI4iIlVKR1xryBASGnn
	LhDh/v/JD6f3GXBbNIr5my4OJIBhno5FddC0CMcI
X-Google-Smtp-Source: AGHT+IHqt8muxwIyNcbzrNrYudGYr25CIu8flyOznvSVMBbSVnp0yO/7Jx9BB+A2NmmCNDeJqM3yPw==
X-Received: by 2002:a05:6a00:9089:b0:736:b101:aed3 with SMTP id d2e1a72fcca58-7405890a880mr10396879b3a.1.1746336574322;
        Sat, 03 May 2025 22:29:34 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:33 -0700 (PDT)
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
Subject: [PATCH v4 16/40] target/arm/helper: use vaddr instead of target_ulong for probe_access
Date: Sat,  3 May 2025 22:28:50 -0700
Message-ID: <20250504052914.3525365-17-pierrick.bouvier@linaro.org>
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
 target/arm/helper.h            | 2 +-
 target/arm/tcg/op_helper.c     | 2 +-
 target/arm/tcg/translate-a64.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
index 38d49cbb9d8..33bc595c992 100644
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
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index 4f94fe179b0..395c0f5c18e 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -258,7 +258,7 @@ static void gen_address_with_allocation_tag0(TCGv_i64 dst, TCGv_i64 src)
 static void gen_probe_access(DisasContext *s, TCGv_i64 ptr,
                              MMUAccessType acc, int log2_size)
 {
-    gen_helper_probe_access(tcg_env, ptr,
+    gen_helper_probe_access(tcg_env, (TCGv_vaddr) ptr,
                             tcg_constant_i32(acc),
                             tcg_constant_i32(get_mem_index(s)),
                             tcg_constant_i32(1 << log2_size));
-- 
2.47.2


