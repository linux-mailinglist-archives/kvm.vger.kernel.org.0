Return-Path: <kvm+bounces-71318-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gCGUOF+Llmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71318-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E1A15BF12
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 715A2303D8A7
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096362857EE;
	Thu, 19 Feb 2026 04:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KYhwXQQS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18942874E1
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473741; cv=none; b=CKbMkto7proMOYY4vHp2p26M9A4M/kW6dsbgEtutWc+09KwTe3fBPFVIBBplfSOQtSkmC28NLx9MWaZD0jLH9bLj/zKuHQ4HTAcD2NOtt8fcUtAAuFi1D9ayZ+ykDKPbzs37w/qN8/+fy9+sp1vXfIMkeLStihGTjpRstoju+aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473741; c=relaxed/simple;
	bh=GU/TEFEMEdmSpwmhKbq36oKhMA/IfwgZb4Pn/nsXGyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFxS3kzEybC/Adh9SieBlRWoK74Xi+AgM82jPhiN7V+94hSFTnCXJT2/gFZcUWHpCSQKWx8EVLBos44H4d33tZibbL57APDj3Lf1sCvMinUs+ztOOfV6D56ZP+37MeDzlc8slVwifdpJyy2df05ZIUg644ELwHwI4dwPPZmVCBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KYhwXQQS; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a929245b6aso4732795ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473738; x=1772078538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvHffU5N51i03Mxn26mXTr3v2G/A6vAtzhoWHQnpn8U=;
        b=KYhwXQQS/6gQG6cnPf07nnSHajiT8ki9BPBoXhItuzWE7o7kEeMiUjznm2bTwjKth/
         Mv/yiqdL8HQPZdJQvtWXyBvbIV7gOP2ENmk8a+g0G0GcAURbdaOGONofPjBfEnwwOcnH
         IKQO225M+dDSjWPwuC9DIKdq+p+IyYaPPMCxm+9MTHqx960EkJUHIVmmZ7Vmx5uoy001
         FRP9r7zprEvnPtzqWpirX/quWyuFXDvFZgO5EBl06gSo3LAVtchaUU2s6Ixuke0Oc+G9
         BVomPMTzotandjyxZ/LAHIsaka9uj9Z1/TGjYib4S6/XGpmbP/3a0pEruF6R1dm0YX14
         /B6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473738; x=1772078538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uvHffU5N51i03Mxn26mXTr3v2G/A6vAtzhoWHQnpn8U=;
        b=Q4Lgk2MoKmpzciW7g3aH9fA/SohQMJThbRbgbtes2tgkSie6oeNbR0jowlVBKL4e0d
         FaU3e3D5zlEjOXWzGxSVC6tgdi/LLSs6t6ACikWLpL6Ehh0uPGqItMNuG4udgUnC+C0n
         80FFzNICixeHdVd8grJtv9I8djO2YQvg9r9S41zBlZ1aeAeCtbWvXTqhFTVc5mVSdudv
         5RaT+BsSH3Zt7e/NtqJ9c8XUYjNiRGg/1juhLbuMhJcmw4p0snXswOl1LMjTlDiXB7/b
         vB4QZNGmAzF0UEkFrTm2v2qERXPApoBfVacs0NjfaGvH/HZpYCzQILpMnA0gY6tDKmpn
         sO/g==
X-Forwarded-Encrypted: i=1; AJvYcCUvWz9dfV0WIcD6AIDg9NgQdzA3B/FNsM91iaOjpeYarCj0GalEERwbEkzMatcOvBFAA7U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr/rNWoF7BorpqPpQN6H8Ks9M27KW3T8PKpb/75b27HGETPvbW
	me2Os4iSvQSC3A7aAFE1uzhq3uHLdrU0t/Jg4XAJeG3mms9LU9KuH5reljYpVgJIGpM=
X-Gm-Gg: AZuq6aIgJsWAdoi8x6+So8ohCHvhPkj6W+N0/fpEB2kyiuY2IlCsizVzGu0HUaMkFQ8
	Sr1cVqlg9T8gBe4J+0WbUV9k3GMKwYxS+KFi0c/3W5oQfyqhP5ICpK+IgazIkhBePz6/aWnHhmb
	Q+Ymv6K7QUl75G9YRo2m8eJo8EuCYERR3jGhVsfhvIHDdfXSLT5KHYRQ1+FFywHRitHZOC5yyoY
	dqZrgWJgOXeWAI0KGxlc+me8heXvH/Pic5cW+vs59nZeUaR5J37zLPYgEUn2HhxJjvSxoTis6tL
	4T/QYQq7lRrdlKQJp5sO6OY03IEKG7bGv0izcPdHrUlhUlU4l9Mj6AHmDwGn/Lrv/K0RmaAAYbR
	H0wX9Wt/ktcnUQzfZ5YbYFYzY2aWCoWRv69a+brqGpG7iNmnHAMchm+B5yh4G33hz5GNv+Af7lz
	mH7nd56zhWxfagYOc0ZL6G1V9xvnyI38BVdsHRIWCXb8YZtHBeFj0Uf/AD5j9BP9897sk0KA3vJ
	NbQ
X-Received: by 2002:a17:902:e748:b0:2a0:acf6:3de9 with SMTP id d9443c01a7336-2ad175a51d3mr155834565ad.58.1771473738159;
        Wed, 18 Feb 2026 20:02:18 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:17 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>
Subject: [PATCH v4 09/14] target/arm/tcg/psci.c: make compilation unit common
Date: Wed, 18 Feb 2026 20:01:45 -0800
Message-ID: <20260219040150.2098396-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71318-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 81E1A15BF12
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
index 6e9aed3e5de..85277dba8da 100644
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
 
@@ -68,6 +64,7 @@ arm_common_system_ss.add(files(
   'debug.c',
   'hflags.c',
   'neon_helper.c',
+  'psci.c',
   'tlb_helper.c',
   'tlb-insns.c',
   'vfp_helper.c',
-- 
2.47.3


