Return-Path: <kvm+bounces-70790-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNZuOCiSi2kTWQAAu9opvQ
	(envelope-from <kvm+bounces-70790-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B15811EF6A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C3D61306A303
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD0D3375A7;
	Tue, 10 Feb 2026 20:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xsByiHD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E203358D6
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754553; cv=none; b=HWLIiZS46rg9KD87K5u2ugYN6H8wqUxoBYvo5OfnTXY/i3x/cx7XTjD9ln4kjslqIAQD6zGtUln/nqMXA5uJaSI8HWRK0dVZ6c2EReWA+WcaJZ+hnOTMUtM1Eu3lHRD38x/DMD554p9v8alelriQq2FSWAqd9yUA0/xzWVzyJLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754553; c=relaxed/simple;
	bh=Jr4xTkdy3jBXk4gup1SBDMvXJaSVwZOKDUih1OJynlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pFaJuSauxwSxWnb55ta9YQHA+ZuWWxNPZbhk7ERvyB5wxnj9y9tu6asZJX3GzYuVsG3GPq8d4VC/cjFKf3Qk8v+s4H0gWyEWqSnmwa4wa6DhJrahBv/EUS9sXauctdBTfhzZpLKk48a+ZID0kSZsgtLeYwOloVG74x9yRNzh2lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xsByiHD1; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a9042df9a2so24112245ad.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754551; x=1771359351; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YT0JTFA3AzBVK9ga3zHInUh8zrTWOg2tWQne/H6KqWQ=;
        b=xsByiHD1KSCHd3z12Rd3u+zypYYOW68pP2r8DinpnKiZabS3CXrSrNa+y07H3guz+C
         Iz13MnMRqIVtmpnFO2Eq6maXJb1qqpZTdXwStAufXQrgGTfw14k0L4mhnTYrtScU7xll
         MlOOlpnZUVBkwIMX5DJVF/dQZvBa55gt33XnfqWtXJDDt4pwY5GDncSjX78/y68UiCwP
         OnB1jb3XLjZpZx1Si50VEMrceMSN59Gr/bZHvsGBJiipTRC9NAk1MWoUvr1lRD/1wgjD
         +aBAJ19XrsW0mropyZmC2+aZRBUA0QyHVnIc8aeqouxfUUrGeJqijeUDB54M3SQm/dPW
         vTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754551; x=1771359351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YT0JTFA3AzBVK9ga3zHInUh8zrTWOg2tWQne/H6KqWQ=;
        b=fCdJkh2xs8pq1ym4eVCCM4f/HnNMPLbObMAPSrA8kEajFkm0m8v7i6iZ3kh3+kQysl
         OA4pWATM4pYIhlLqKXUUDOWw6otMJceD8Sg4Vw/awZoGD3SsOMtDprKqHZMJJb5Pq4zw
         hGtANYyvUw8tlM/1cUpQNhyg7t0qaPy7Qo0EeMGPFfosXp1HDHoKmM0hjmMycE7Ema/x
         XCBZqdWaHQ4MIZcKdIZEC81tPu2uLu0OOk8FuKfQ9Lbd4nX690AWk9ekxRO0oItP9d3p
         gZNqyQr/5xvo0NQCFjmyLJIoSkyLbeTBy/AkHMAAOD8vFVUyiQ2eGStgJnOOHQCVIiGU
         oXhA==
X-Forwarded-Encrypted: i=1; AJvYcCXNTgQRhqLzdQpS91R37dkmIZZRwZ77AOUL6Usy+nclLiD1FyBOL1ppCNRSGKSaUlbYTW4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9S4jl9p4fJQRAWB+belnhAsuG88qW9oZLYnKFq7P6edGOPULP
	g4b8uS7MWPARwx4MtInp+2q9LXiqacgPOvXnaEqBfoJDK+rvISdFl4ThkC6CRYKYZFg=
X-Gm-Gg: AZuq6aLUkwk5877EuVBUkZunzY4leLJIoKONKISuyYwa6MxJxtt08CjeufeE92UkTFB
	PBTFanbl9KozYUlw8cE9/5jMK3sxo1XOrYh7EFmqn+Ahm2pA+j0YT5ojzCP/evAwN6mnQ6Yjy2V
	MEO0S/nKZ9UQhnivvFoVfrq7TyVcKNqhCvs1CmsmYKFaWjt0pvY+2tFev+tQtAv/+9vrSLIKaxQ
	pLMuk2ms0V2vtYRPL/5j7OvanGJa2ukLcm+T6RjuQEhkzynsZ9xGJA6yK4MqZg4ZAuJ69mLSsyG
	zpzyccsUS4IBX1SNSuGWXs6MW1h4lU0kmJzHo5Fgnyn7qJ8nfJ416V2IiQkxmeFIuoohjcmFJrw
	KZ16sPJxe0Uofu8ipCpNOF3GKEgu8VuqEc+Yp3mbhA2WyVcHdkOSGhcbrpVudLw9/TH574i/o3K
	SrQf1qm24pktbGii03qFQraPb+9n5RdF6F47bgltJEXM8iRAmqlQYDtPQqLBV0jt+7ZpzxMJLe5
	4lA
X-Received: by 2002:a17:902:f68a:b0:2ab:2311:e4ef with SMTP id d9443c01a7336-2ab27f6bf8bmr3637375ad.54.1770754551253;
        Tue, 10 Feb 2026 12:15:51 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:50 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 07/12] target/arm/tcg/psci.c: make compilation unit common
Date: Tue, 10 Feb 2026 12:15:35 -0800
Message-ID: <20260210201540.1405424-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70790-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 9B15811EF6A
X-Rspamd-Action: no action

Now that helper.h does not contain TARGET_AARCH64 identifier, we can
move forward with this file.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/psci.c      | 2 +-
 target/arm/tcg/meson.build | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
index bca6058e41a..56754bde951 100644
--- a/target/arm/tcg/psci.c
+++ b/target/arm/tcg/psci.c
@@ -68,7 +68,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
     CPUARMState *env = &cpu->env;
     uint64_t param[4];
     uint64_t context_id, mpidr;
-    target_ulong entry;
+    uint64_t entry;
     int32_t ret = 0;
     int i;
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 1b115656c46..144a8cd9474 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -49,10 +49,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'sve_helper.c',
 ))
 
-arm_system_ss.add(files(
-  'psci.c',
-))
-
 arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
@@ -67,6 +63,7 @@ arm_common_system_ss.add(files(
   'cpregs-at.c',
   'hflags.c',
   'neon_helper.c',
+  'psci.c',
   'tlb_helper.c',
   'tlb-insns.c',
   'vfp_helper.c',
-- 
2.47.3


