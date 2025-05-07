Return-Path: <kvm+bounces-45786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F226AAEF6E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91A94615D4
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6A229292B;
	Wed,  7 May 2025 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OOu95m3l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855D629290F
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661384; cv=none; b=AIhxBcELHNnv+NSR7Cl42777gL9p31X5r8I0f2CtEOelbGOT+h5j8GKnIIzrDpajTu2t6B0In5PiocEvegCkeHe2mCu4xELn1+oDac4h/BD1U9YJ5rCL9Ncop/V9BQokPq76ms1WLh1o0xgnaVEgfsklmD0l9QmLXyOcJ2+3B1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661384; c=relaxed/simple;
	bh=YwI6EoJFFU4A0RUr2tMc/ShthCahYIs28sHQ/0WD40c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrkuKV7UAR6d+oeq9mxtbMO1PMb2PUbbzDbr0mJ7ytkpIfm+C+rnRuueVWgmdnYsfq/YPBFvOoFfPIONd7cfBRT3bG48yrnpnrxkh3qA6IO+Tv1NYhg8q7RQe7Slvzzpm/HnRireOPGWVzEXIP1YM5axEFjNFlbdu8pRiZXq5/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OOu95m3l; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-224341bbc1dso5853185ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661382; x=1747266182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAz2QB2SUYrr3XWzF2d2hg/x4+UA3WdNJnT5uCp92aY=;
        b=OOu95m3lZ2xR/MM+0AKmXGBL7ZJOelJLW18/mbyCHg4p1VqmC7JrdIq3FKN5LO1t61
         8tlPmAFAXNQqWdk5XUBV3jTbYHumn4QnY8ne1MyqCjpnolF0ElQP0/dSS02Dw7L8Dh90
         /g0pNGokImN8cKDBnPsDTlSqkESsGoGOQ7QHdBgKr+0v64TDwgqvfbwovQbsyaSx8CG3
         p5yC52ZRKap1kNeU7iTGACyxIo4fPjJpqaTt9jnPZvxj1N/PuKLGrU2pJenSaTx8U07n
         d1CCrS7sosIRhfIzKC6FRGAA9hoUXCiFfcpDKnc82C+GpzfhyBy0eiDGjy5Uq0roz9Tw
         RL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661382; x=1747266182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAz2QB2SUYrr3XWzF2d2hg/x4+UA3WdNJnT5uCp92aY=;
        b=Cq4DqbWVgMv/jqMXDvdQjGRsJ9cUPqcEgQxUpvJAAyY/6EI94QnlMqPY6bHR5FhZoN
         jKIHvpaWm0ZX5GhONwftA2zCVTyI4vjQYTYYqOB2yp6q1xh4ApZRWyXqMGLM8GFEjz35
         vMXPJ5c/ngYtpFaKqtS5hMLMC2HYLX5EvoB/ylqTCVBLVQoywkxujEqF6BePJq3EOp+5
         0hARMXjtHyYN+U46ekVX/im5Y4m782KXW1Rp1mhD22UAk0TNUIs8akkOAhBG3oDKVd7K
         Ne5mFznKb2RPKVkGa/zQ8hsN7qifR1KtpYEFV6bAD8P3gb32U6Sm1ppdiuyAFBP27oPl
         anPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwSdAsbOONrfs8uXAicNt35CHXCSO2dA6CBlUFW27p11XkNLbSmvllurUSAXww/Y+Ms+U=@vger.kernel.org
X-Gm-Message-State: AOJu0YygbE9pLpVBJ2KKqsZfjkYAkNvakiNh4qkUwUrNDbSefrErrnQj
	VgmpckGqAcdeG1/nhK7yeEt8PGI9kMNjFQ4wMhGU/E7v0ooSe3CyftSxUDTvKKs=
X-Gm-Gg: ASbGncuDRxfXVde9GQ5d/udeHi4C/2W+NnDaGmgkgU+BbwK6u2Z1Ajg2OYR9KLbhHZ/
	QOkY/nG2K5PaazNvfRrnyE0Umo6u4VoO/x4H3bG5eCwe7sxWu/nB3wHYu/ga6qJ10g+hehQk4Q9
	hHOUwi35Bcmwfs17OGZuHYA73OMCvKmPymnUOQe2c9PWxZOgtmLTtl9zChlHXY67KzlnlrcdgeP
	ddgSvusdQTP4Dmqn3N/K4/YqtgyU0nudMtmeToCz1VGAPZAisrgAdGYbDzhGKEmsjBkb0iGiy+K
	NoN9axvoNvKEFL8lGY4IpDiD1PrsL3Gd1tEx3UZc
X-Google-Smtp-Source: AGHT+IE38pdekqu2nTYznWLfBCmnQUl4ZsEQS33bpVJKG/HiFUEGF9CqGv5eA2fH3TQAGtumOTQcDQ==
X-Received: by 2002:a17:903:24b:b0:223:325c:89f6 with SMTP id d9443c01a7336-22e5ea1d4cbmr90104005ad.10.1746661381800;
        Wed, 07 May 2025 16:43:01 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:01 -0700 (PDT)
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
Subject: [PATCH v7 21/49] target/arm/helper: replace target_ulong by vaddr
Date: Wed,  7 May 2025 16:42:12 -0700
Message-ID: <20250507234241.957746-22-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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
index 941fc35d24d..2e57fa80b08 100644
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


