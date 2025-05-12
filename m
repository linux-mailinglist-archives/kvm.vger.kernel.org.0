Return-Path: <kvm+bounces-46221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A83AB4231
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63EE41664AB
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143602BF3CC;
	Mon, 12 May 2025 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kZkJkPbe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDF52BEC3A
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073132; cv=none; b=LsI5o57lQsRyZnFBZRmZGiKCE4TAWgTvj1H1i2y4pBUHMW9P2G51QHU4B8mHalLRm2rh4nB7uUGD2/8z+SyJd7vX9zAAuqRxbO99FFWA5wfg6Zoaig/bL+Slnq0dI29CCcnU6Yy8sC1589log9msNXccgQTg2laWDfRk+JpRuP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073132; c=relaxed/simple;
	bh=7Bot/8BHKpD5OySw7BiL3gdiC2GvsWNnCf1ZN3RJSOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gX8jE0z3FysoRDOEKBtfP3/IPPBJkIawU9iWi8rJywJ2tXWF5PUZvr3ewkPc9LVFVad4L7uoLTCtN1KahlzLH92aSwuH9jO1bdHTgucENQgUCw8iMpMPsml9ZdFSwd1dNuiLQiAOC3LkUco/2nop2yvRzR0BO8w7cYthT1t/c+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kZkJkPbe; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22e331215dbso44905335ad.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073130; x=1747677930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aJInTwepDQvyARNpaPXuaRooiI+RbVpis9kB0Baf804=;
        b=kZkJkPbegZVYNtECyFEGSCnlTt1nPKjHjtJqZcf9gmmQdZ59qYgYHJ66G/t0rxPSSA
         mN8haSae37ZjtCg9SlF9FeuOo1IfAzL9t2u6Q4y//zGbHICByrx+CmYes2mPfMTHU7Du
         L4Bpl7K9q6O+UvXUX/FXWjaRo/CZDbBVS0fqOoEi44bWVGnuur/wYky72wts309wvSIn
         5BguhlcE54biFSbyZwad3yoOK4uV8QPRZZfSzzAakD+KTrUqKrOaRwEjIOE4KiCg8kLu
         xJBLJgCbG17QJ5T+ZJJQ9at24t8T/5ggqzvF8IL97fAex4yj7B4YF7jBkQqbUIj1s3uo
         m18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073130; x=1747677930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJInTwepDQvyARNpaPXuaRooiI+RbVpis9kB0Baf804=;
        b=puLwVREfa11yLn2KfJRRW+XNiCkdtMo3Oid9NF3i0qZblUWkWWqVA52oDcsh3hfb+p
         cX7D3tH1mXzrPSigrYD9VsQEyTCN+FDdJoBWx7c731WGPjV6q/XrJxi3EeXUvTyNxvEd
         nzbpFVNFSYU4ldq+HU4WUrza4Ra6qn4x4GCNKJanqNu72QTl6XcvnXNtOCAjPOJiwXD8
         vvPL1TRx+PIHQrNvxlq5INJbnaxXA+6v2YsdxeOnG+4r5eS3W2mLGyoRRTYRjQqFpVR0
         85nBbdeHf0nfm4SJrSu7yhHpEwNMTzixaR4VZMNtMeZFCN9ZbPfvhO9feJ5ZGqIq14ID
         rxkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNeW3Ryw5XMhVjyWyD3BVn3LExelEaDVE3fmXX+YQH9JCYAmP6Nqf6Wb7GQEvlF5OJaKo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBGEyurCt+kL2gUWrWj6b8SYcSwOAawvIlVw71qHXw3vsbef3P
	Qti9SGYWhtXPg8NfI5jXyCtPlYAbgpvJsiC5xGoRTYXcXcyDgYGiXZvDySeKqWQ=
X-Gm-Gg: ASbGncul1S6oxKmUIrTzUc+IwERXaVEqwKO/HHfDfi8Hh2OxeGLpEsut/tjp0UNH4O9
	N/f6gybpkJAawuXJUi6iEXvFtaxMEdg70P92ZUAwiJRBsiCC/Knb2vYImh91BV8azPlkWoKgTZl
	nr2Mko3qjOVZFGTVDxu5LIXhMCDVJ+h8GgPdmMGU6c1ZY9xKSO5ID+10XzofrMMTsoexN8Wx3rO
	n7S6YbZmFeCI4aQdadAv3wLcxsteLnsdTLDvWyWoT5bbzFXOrvh2jzlWHynKUCg5bh/tzY7k7bp
	9uDEFgrx6apdOS+6hzIXB3rHqtqdsx1AWuOKfPeF2rHCn9M+b/M=
X-Google-Smtp-Source: AGHT+IHxrzHChDFcYnRSVaKACPNNaf4kZqDUlSJo1+aUJyFrfDQpSCpvtq014nivMaomuT6gO5OwyA==
X-Received: by 2002:a17:902:dac9:b0:21f:5063:d3ca with SMTP id d9443c01a7336-2317cb41a37mr4886665ad.16.1747073129894;
        Mon, 12 May 2025 11:05:29 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:29 -0700 (PDT)
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
Subject: [PATCH v8 20/48] target/arm/helper: replace target_ulong by vaddr
Date: Mon, 12 May 2025 11:04:34 -0700
Message-ID: <20250512180502.2395029-21-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 3795dccd16b..d2607107eb9 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10621,7 +10621,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
     ARMCPU *cpu = ARM_CPU(cs);
     CPUARMState *env = &cpu->env;
     unsigned int new_el = env->exception.target_el;
-    target_ulong addr = env->cp15.vbar_el[new_el];
+    vaddr addr = env->cp15.vbar_el[new_el];
     unsigned int new_mode = aarch64_pstate_mode(new_el, true);
     unsigned int old_mode;
     unsigned int cur_el = arm_current_el(env);
-- 
2.47.2


