Return-Path: <kvm+bounces-45502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C59AAAD5D
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 001471BA03C5
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0047D3B199B;
	Mon,  5 May 2025 23:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d7pltRxu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CFA3754CB
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487244; cv=none; b=rpy7V0k2lYU7tms3yYh/5FQG2czjC/vjFkJvrHYcK322ZzFBiErRG+iNzK0OxAT/YnOTpDficUdtyM5IzwNccvZ9t7HWVmLtcIuNWOenRzyCr9nlAT+a7RPOdolYp8C865ALsRLYFjEuufRd9rKsuyIVAf/Mv+Xsv67sU9S+1f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487244; c=relaxed/simple;
	bh=kNN0k/EkWYYC5fsTIWhpf6NSLz0ZuY71fIN9SoJaaso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gAT+D7K9gnE0ljYHKREjRjPKna+E2rTsacyK5xuWT1z+rVn3YkBgQzPVVsu9pJec02Cy3cSIX9Q0xARmn4ldjehfSId0ZYcKj3rPct1+by3qvARsv8zwnCFKd4ra92ciYaHeqyaV3O8g9nQalw+m9mk6xBg8j9ZFprTjZvwCz9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d7pltRxu; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2264aefc45dso79081285ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487240; x=1747092040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZaY3toZMvHik6Oxfda0st+OdZGZoqXe3KmHGIqEM8+g=;
        b=d7pltRxuVEUi3u31LW4uMgH/rM8ekklR4I3XWQedT9RZkhBDzWuW3Ij4djeiEdoS8n
         irRf6O0tWWgwdO49lljb0JxJvXAMiu4KcJnm5FpGP06ybxnBn71acjakmWslzbjkAT6m
         AgCGoXODPHnB3/3qdVXNoWlKACyBi/CXdqOVGEw6R/AfNJKRezPhUplgyKmNQaAvChPN
         zRiVtBG9s9SU0fpX4vo0LvMJSxrdrNFbkhr5foNcqD/My4UWlaQQBAmKNlqjGe1UyyNo
         pSwVUP8zyQZKYvSILnpKny+E/rDWqDOB2wYPCNJeCtiqfK/hYatwkCwq7BLeXSlLrR8K
         wjaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487240; x=1747092040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZaY3toZMvHik6Oxfda0st+OdZGZoqXe3KmHGIqEM8+g=;
        b=FcbM2eVyJO0fphXJCTviQXIXw6Ueybb2bu3ZIiSaUWrKI7hvmgATgp67zznYw+pA/l
         olFGfHMUKWIlU6S2qSiWzt+OejCWjRobvpTRl5pca49r18BlDJEviJyLWBrLmiXLzn+o
         mvfKidlb1h/oMdk5lAcqVdl69NkMkbiWxHHuhEN8s5pVQqBpe27TeFyXsjwrSB4NsF5M
         or5B7JDrwD7wZw1Hc/JX0blqc/eFbh5bSmWWrw3387BA+cSQkBumh32jI9qnWl5/Iiov
         GAKfJZFulp9q2GZUjCiPYn31KOiJpcF3r0jkhDjO2hn+U4PTM7uhMuwCOKj8cA1bQ4yE
         W8lA==
X-Forwarded-Encrypted: i=1; AJvYcCXs8THqKJcAIkgNh9wn6XJc02tC3T6+dtL4Ta9D+0z0S0Pp5iu9GahWfN4ynQA0Wg6p7Lg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjR+Lnbwe9yxUfsY/hhNdSKBeARqof7kSh34D+dGG7IeaQ8m6b
	cPxs6+JqE35BwR3jGIljd3p20vP8o2og4gn+jnEJ48F/Bh/0MU6d4JsJBrtnFYBdj9gRnLiiHr6
	MWIQ=
X-Gm-Gg: ASbGncsvXnqmNWDEzaqNl+B84gbl93NK2kq2Mgw3s0jtnyEJlz2W9crrMEuOALzAVrI
	98kMJP9ruqswEBeiJyaBR1hPJH4HyGhBtIUHFRsjueYhFtJ/4vG9edIOGghCQulEm+KfcV2VdZS
	ecihbFhy2oIDbSGtJ3PDvkdWEWJqXokSCQu6CYmV00Yfh9qf7u3PHSJ4965K0OMc65/WJ0S7DlU
	3Iy8V2Ih4e1i4+pD1pyQGXCLPDkeTrnZZYLM+o2xr154g/XAknlTii1CUAmEVBJPBCp9KO84NaM
	TNaf7UdnpuTIMSW5+3cA1NG86MmdHh8XE2wLjXGQ
X-Google-Smtp-Source: AGHT+IEJpX9b4sIeMwievSiYenGx0avBZsdb5YYkcnnfwScYImSa6xg3N3nAjjr/lE8XrijHR6UurQ==
X-Received: by 2002:a17:903:1b2f:b0:223:f408:c3f7 with SMTP id d9443c01a7336-22e1ea47acbmr137947265ad.16.1746487240186;
        Mon, 05 May 2025 16:20:40 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:39 -0700 (PDT)
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
Subject: [PATCH v6 22/50] target/arm/helper: replace target_ulong by vaddr
Date: Mon,  5 May 2025 16:19:47 -0700
Message-ID: <20250505232015.130990-23-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
index 10384132090..7daf44e199d 100644
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


