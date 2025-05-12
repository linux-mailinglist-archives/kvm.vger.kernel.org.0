Return-Path: <kvm+bounces-46236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25ECCAB4261
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34C06188424B
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402B82C10B5;
	Mon, 12 May 2025 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qm1Lwe2R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B942C0863
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073145; cv=none; b=U17fTH53njhJJRXFmU7HQvNBJICXXT57pJOVFNioHdXw2kSYZsS+DE0HNEcwMBenoCahLB086a1+SB/KvxZD8u/Dcshd0Kdujj3hhiqAIL86PReJpu6EJs+MnQk3ahncGp4h6iE9l1u7JPlVDOy4NMTwTqxraT/jR1CNRnWP++I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073145; c=relaxed/simple;
	bh=DL8s2PBLHUk7nnU51Iqv6TagZNVpZyAU1f2RZEfhC9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzTTgkXYj8ozFid52RifUBqPoYq6pZf4+b/WIa+IVlmK5slyQFd3gb4yVank+C+yKm23FkQTZyMnXbrgLN6NLj9Q2xuBVqBhNAk1ndupoa2wotjQ83Le11j+rwPwnvsvp+LbLVdHKCjYTsECb6tsrxLMgkMfFZCwkCh6A2StgJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qm1Lwe2R; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b1f7357b5b6so3000241a12.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073143; x=1747677943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=qm1Lwe2Rhfx5TF3HXrsBuBPs3W6yS++Rl+vguLklFcgbTXN8g3mshb2euLmsM3QXsZ
         TubGLBfMxuwZYIxYEu/NIpdYZNjuumFjGKUxVjpzcRzl+jo1M5z6C+M67MvZJ5rZZNXW
         0VJPI05jLSY9Xf/ckfwJ0aXxtemU0y6Q8YS08LImDJmKyAGL/PAO7dHTF/LwwinDPgmj
         wQh7iI7uvnOh1vz5dfPuQEQ2yVhASm259vGU50KlpkqTE6ifAg8FYgw6+D2wyeXgCAfR
         rY1PUz+i2hVAITp0CEVMeeNXXrNBY6FJR+3TE5GhiJfgI+bD1umPWAceEBy183jkrPRM
         nAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073143; x=1747677943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyeC1dYqzIyRbq0U6QJpnfGNVlqEyh7oNHL1QwbMptA=;
        b=aioSwG/U9XgsETX2XoPlGYdLilfglT83aL25d1xXztRWAJ5DOhc3FCesW7p5qd31w5
         Xd6EaBI8Jp727C0YWtor0AsH/C38I7ywvXuvVe4dbXEU59SaeOCuX9sZAGGGfuFk98Op
         tF6NqB3B3LKWcWxh8z09zQWswFrPYDzwiixX9GeC9Sd8Grhovek7DVBTWKiXKmviyM1C
         SiQzejO21FmqsnZ4jH5CJ7Kziq6y3s9Lu4Cv5MxSKRsqWdAHp22IXa2NN2myncm9CLvZ
         sdb2bqQ1/CYgffeyyfw0bSDMG+W1WpvpJoOpcJC87m4bj2ctnrTUjb0srkBxZSQQJurt
         0yQA==
X-Forwarded-Encrypted: i=1; AJvYcCX61bdniSo9/Gots0e3kriC2uns+478kP6C/3JHFrIQQCKmbnUqooJzI5bAuQPTywsVJOM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypaf+mpWr6oo0nZBPnUAOOkpcT5t1RHojkgy3fl3ewPlRAigGj
	aPSFBC6qeEeHWUdoV7aTjtNftqgtAY6Hs2UdPrXe4e2amqEsdvuvElR25QAFT98=
X-Gm-Gg: ASbGncsj+SXSQehYP41aMCu9yaUKjBxJyqFvrKLKa9Tc+pAEKuZBXoMnqjYlIHsmw9H
	sHVIxqxrZTb8TnvClttvX+Z4WrtgvbTJKALosDh2bQ3k/9va6+6erO4qd/FBoZfwJFf0aKXL97t
	AiFTJe1Wj8kSFiisHxqOr2CygHtUailpf/OWDDOn2OlDqpS5f34J6d/gxgQMiGC5uvYWy/30JFq
	R0P32PNO8iAVS/1FELz8pXaitmVgNFLgVPz/LNLOvRYpEIzH21pmFKUJGSszi1zuOZTgwg9CCzh
	SP6H9jGSB5PjFqM+iEEifIymiAEGSa5UUd04bqiJepaTOXQSzYaSo+7znKP8dA==
X-Google-Smtp-Source: AGHT+IFT4upvCT13/RFGLduTc6Ungq+/RISUi+LE8T4VFVW3aX9/HV2z1HHE/PfvAyjp7XZNfam/PA==
X-Received: by 2002:a17:902:d48c:b0:220:ea90:191e with SMTP id d9443c01a7336-22fc8b1b1b5mr213956255ad.4.1747073143030;
        Mon, 12 May 2025 11:05:43 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:42 -0700 (PDT)
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
Subject: [PATCH v8 35/48] target/arm/machine: remove TARGET_AARCH64 from migration state
Date: Mon, 12 May 2025 11:04:49 -0700
Message-ID: <20250512180502.2395029-36-pierrick.bouvier@linaro.org>
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

This exposes two new subsections for arm: vmstate_sve and vmstate_za.
Those sections have a ".needed" callback, which already allow to skip
them when not needed.

vmstate_sve .needed is checking cpu_isar_feature(aa64_sve, cpu).
vmstate_za .needed is checking ZA flag in cpu->env.svcr.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/machine.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/arm/machine.c b/target/arm/machine.c
index f7956898fa1..868246a98c0 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -241,7 +241,6 @@ static const VMStateDescription vmstate_iwmmxt = {
     }
 };
 
-#ifdef TARGET_AARCH64
 /* The expression ARM_MAX_VQ - 2 is 0 for pure AArch32 build,
  * and ARMPredicateReg is actively empty.  This triggers errors
  * in the expansion of the VMSTATE macros.
@@ -321,7 +320,6 @@ static const VMStateDescription vmstate_za = {
         VMSTATE_END_OF_LIST()
     }
 };
-#endif /* AARCH64 */
 
 static bool serror_needed(void *opaque)
 {
@@ -1102,10 +1100,8 @@ const VMStateDescription vmstate_arm_cpu = {
         &vmstate_pmsav7,
         &vmstate_pmsav8,
         &vmstate_m_security,
-#ifdef TARGET_AARCH64
         &vmstate_sve,
         &vmstate_za,
-#endif
         &vmstate_serror,
         &vmstate_irq_line_state,
         &vmstate_wfxt_timer,
-- 
2.47.2


