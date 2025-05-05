Return-Path: <kvm+bounces-45493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 468F3AAAD69
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09D343B200A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53115305732;
	Mon,  5 May 2025 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z11/McDI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE7F28B401
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487238; cv=none; b=h5rkd9D0qRODUiP9XiUxi8gUp0B2GVv1DXbsLec+51iy9nccYi0fRyL0lqvi9hMqFq99lSoGWg5xvYWpMrzDRHJKSjZ6Us8ZKXtIHL52E9w7tMVhL/PZDU/hrDe6JpYEvoKovp/GvMVu16XpuZn6gECmalv8tMGVUyWu8zWrvVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487238; c=relaxed/simple;
	bh=CkAdY2E+HfkrFgmcg94oXmRlHQ13EAlM5xXysCqxA8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqfT1UofBmuq1io5LiE4iHaJ0K+bOFoXBIGbf2CGv82HrB2tyBiWRx22CswObU+AmD5nLvo7dSIRxgUcw8rmLvx/H4q+SBnte83Dv7UpzoORkhjrL2bvP+WRbgjJB1L9WTtHl97VlbyJxUTJjM5sRydteeHOKgPW0GBkQDjCf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z11/McDI; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22c33ac23edso55093025ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487235; x=1747092035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nYwtbXWo/TvD/k3nLDnPjIkSoANte4qu/UhShUcHmQ4=;
        b=Z11/McDIqMkEkPGwzz4Z9ga5DjFfkCWFrrq9Owx+Ap4JMwfIHym1CD628VerC4q0Bw
         Afk7Ow8GJ5E2xC4MW7BiPf1KR8iaXpgbP41NgOq0Kz4HLpkCnEkkROtXNZcK7tAaxt6Q
         X5HCcYoAsVGReCbonhXpPGEnVTQNLIZMzpVO1B68uULGkuJsQhUrhtK58T+/S/aLXvgl
         vpH4ySDRNXIxuxMgEdXo/oiNPpIa6BS2Esr/JiIZpxQfVxDldd4rRrnuSkKnPjIFDhET
         iWSIA4n8TVmPIPLQaiAK42WD/1TbDpgPnfS6oG3wZJqgAg87CzZVTEy8C3EWV4SX8ce9
         6dYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487235; x=1747092035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYwtbXWo/TvD/k3nLDnPjIkSoANte4qu/UhShUcHmQ4=;
        b=TXDafpPvt5FZuaB0HixJmSP5GSoLKfKETVsXyyJSzOdsauHQ3yTDGmI5dEXF0yWOBt
         tJRJ4WPxN0TV0piEGMUNRsvBZikITNNVKxoApbfdkA+o1NGboDBf7RRKut0dD9UFUQLw
         57U2GUQG8zVgiO9T6N12Zd2Z6gFqIGOLgpScUXy0RLifUs5wWgVMO3RGAWseOX247nYt
         0VLvKfsAbBaeD1jVnaRTmhTL6tzU285SHjf5k+WcStH0KLxCJyp8xVmhlxvLuCZ79raQ
         zo/0Y26y/zMe+OACWV5vaI84ZVBe9sj0fV7UmX+S9kiSfl+O9wxy4jz1N7kwv8EkkGRf
         Knmg==
X-Forwarded-Encrypted: i=1; AJvYcCXvf+CGsjIY7rlRo+ucwXynd/SggTj+wv5gyYMTIg+Qb2zviWy6joV4+/QL3ovOR70VxP8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuvrFWQn8fMTqfGWxuKW6lARUhSkF4apoUnFliYcZJCLQUuSAa
	8aEREmSe4FQYOCwxew2ApNSS90s+C4i2M4h0paYw1i6IZ7UhPs3CN+tCWZ33Skg=
X-Gm-Gg: ASbGncvl3vd6vwhnU3xR4zl9lgLAgGMAlpX/m2Ql+o9WY+xuP56PGhJAAtBo7inKDSR
	EjTW+8JpcAuX1zdJzXSUZn09U1dXyklUj88eZLEB1WvJ4WepjyQhSRG8Y58MAj7NhRSDzkmXXPq
	dGApEDAmkN16Fa6mFIMNKYnupGr4+ETbPvVDrbaislLVfiFxQZLCDiIjKxipxDPUasuHekVnXLJ
	oKP+iHwJH4YzCJbkEeCYlg1kqiFiwMYwb+WeejLgeqmhOvJLbl0+89/NFBNmdw2IciUI8QbYbNt
	Ocrtcz3jO/8Mct6jaeUF0js9fjIC13ray+DTr0tS
X-Google-Smtp-Source: AGHT+IEZ6VqsUNG24iDMT3idG7vLgb1bzL1cG05Jn05ziI2xH8ByDBSw6lb+7MbuYw17U4nXGnFALw==
X-Received: by 2002:a17:903:d5:b0:22e:4203:9f33 with SMTP id d9443c01a7336-22e42041dd8mr586475ad.33.1746487234785;
        Mon, 05 May 2025 16:20:34 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:34 -0700 (PDT)
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
Subject: [PATCH v6 16/50] target/arm/helper: use vaddr instead of target_ulong for probe_access
Date: Mon,  5 May 2025 16:19:41 -0700
Message-ID: <20250505232015.130990-17-pierrick.bouvier@linaro.org>
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
-- 
2.47.2


