Return-Path: <kvm+bounces-46215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A3FAB422A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E87B81B60700
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F2512BE7AD;
	Mon, 12 May 2025 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GjDhRw6a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0502BDC39
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073126; cv=none; b=fPXmwiO1jk5cimTFZZdbJCM2VvjGhkpPeD36DaR40hWmOMwLvL8K5QiGoLer6sxc5+HbMZFRpKa/722cRMGOHEMt2woaImC3Uu3g8BgKb/FImDDfWgR6O49rnMVyL6I3NzOai1TlT1rzBa1L0pnVb8998ixjglrlBl6XQrkcXu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073126; c=relaxed/simple;
	bh=Ix/vh+WGsybYa5W3n/1eQPoqRR7H9WGdcnKgKP/tuSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nvv4P9BA+uMvruMNI4PHYL/QIDBjSJQxQKW971+JKHqAUZXuU681j1LzGEazlkJwvlPq1Bwb52ar8JrRC4frj1Qql7AezyIUWI54l7zSU8c5D1EQh/R3LZ4lrQrB7oyVNcm4yotbNFhg3qWk94pLauZL3zHvQoPYpRorC/mSGjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GjDhRw6a; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e09f57ed4so60545615ad.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073124; x=1747677924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylmW/mRzMuupLX6PASMDyZOaBb+Dv5gnstRJQXcdzYM=;
        b=GjDhRw6afXUq0WvVXL/mSt+oVhHQXgu8ncIh5WoSIEcgE5Fe1iOYAuq/k5pzQw+E40
         yicD511Yw5l4+uhwqM4Cz92IyBPkumdkZ+7QSXCILF7d1If0tWZUYdAu4goHnd2B17jM
         myPUmBZavxpJhvGkoGOz2DSWxQz9oofatbrb9A9unCdrDb+XZf3XFvnb3pvxpwW9ZclM
         lw4g9jGUw6Nqp6F8rzZPFmSNlNN8MTikBMKC+xbiCgcncuM4pjgBGZnKPlyvrOUU6Rbl
         U4ZeoPZWBAkgV/rzBxd9F9mbmL7/DF7qwkEGoDhUz9LYtGlxs6h9KpxbvTr8LVlgP2s2
         2mSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073124; x=1747677924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ylmW/mRzMuupLX6PASMDyZOaBb+Dv5gnstRJQXcdzYM=;
        b=G4V2vKNnEChduyUsbOEdyEGCG119B3VTKanpDPzec/wQSHgu6MyYNsGrw1WUS0YJC/
         DFDxGB76Fdu2bvC/unnugFFIvZl9GDlBYREWI4gZZi9t19U3xL+TvqueDm03h0UyJ1A7
         lH8emHC6k+mOkNutdNBUR7/lUtfBfBY4wqxiHxvNVjBFG2ZWF+iQmhY+R863wMSttKPb
         mrZx3x8T9mLWkjwpNKyviPzaZmbgTSmisr+MOqZWqlY/AxjsSXBX9F+Y90HJjOZRJ0wV
         vPisLKqTiZTzqe+yz0CSMYrRSQBo+5QCTRNOEOEqGD8R8TSWWR40BhE4gguHG7FT4Ckc
         ndEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlADjDf7hpiP95bXFndH/b8f1ynNliZpZSKVL2L+a2qC5AW1vLaMb7RhedIoS5+KwO2rI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWxKks0gAjF9DmPmK3jjN+4J8wCN+2TPSpSemR6ZCyjICLL3n3
	P+JrB5nSRhfpM/Ap8vwLAj/rWbGh+BCeWF4xa5sBJwL2V8A25xhYmhKNMN8LceA=
X-Gm-Gg: ASbGncs7sS0K9a3ZnStCBPkuuMF9QkTSDhVNrDR7m/XdPiafkVYPYtcrf1GGMiCmI2n
	xQ45jwx8hBPpeOs08SFGeRlsWYR4vg/ldDt+7ciqebP/tFxnjfNsWeJHxpbW9L4iozaDwgRTZa2
	rYTivXWTJxLvYt10aYhNZnhyLkDtu3lY1Jt6/HMKptctjOaJVlf7RS0aZHo5CU/f0ZVfJI9MRsp
	3xd1WIjI6WYlPg+Pp1m5FpoO5IXAvtWDst6fOFwsF14LJRdlJwVKAh1rLVtCN3Ceysl6qNPOb2r
	bGWzejd1EHH5nq4056NDUOYmhRaOCnr9SMA5sfg+58SSO3nwBkU=
X-Google-Smtp-Source: AGHT+IFnCAwgn7a7X5kZmBX+jZkAWwfoFbz5Gf/9MOjs3udFDxQLRtalnYZlQkwiO8PcKgx9CaND1w==
X-Received: by 2002:a17:903:1b0c:b0:22e:491b:20d5 with SMTP id d9443c01a7336-2317cb4d743mr5608975ad.26.1747073124392;
        Mon, 12 May 2025 11:05:24 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:24 -0700 (PDT)
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
Subject: [PATCH v8 14/48] target/arm/helper: use vaddr instead of target_ulong for probe_access
Date: Mon, 12 May 2025 11:04:28 -0700
Message-ID: <20250512180502.2395029-15-pierrick.bouvier@linaro.org>
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


