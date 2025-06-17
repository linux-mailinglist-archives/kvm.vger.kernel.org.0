Return-Path: <kvm+bounces-49732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B593DADD889
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E80C19E5189
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED90E2F94B7;
	Tue, 17 Jun 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lMigVOHi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3592F9487
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178038; cv=none; b=rBgMxISHvh3tYYHjm2zflsF3ofxtce91jIGO/VlEfbOJgERyMUtCqylXQz/qi2HKhSqUmdBBj95zcrUuKWLJxYGa9H8OMh284Nnqbl2QYyJm2IsNqoD5BEh/csdvRfXe7H0JZEFAAJFpXDkOb+dJmix5UAAdPh7/6OsC9uDICsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178038; c=relaxed/simple;
	bh=uMykn24cLloyAD6efYiyBzsaO8dGZRlbU9DkqTRgsY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VuLwinFkhtwhmPCWj2vYv4ZM/XtlLX80Y5iWStuCANHnM5jTmslyagQ+CiOfKAdZbUBA4sHSItwkwK51gAw/Y9qrb5muJI2JSRKmp1RsxWAAHxun2mcNmxtx9kITx9B6AH9PE/QaKexqOT9r7Ch8yUM2RYdpGH+qgTwQnZnS3nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lMigVOHi; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a4f379662cso5130700f8f.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750178033; x=1750782833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBtlyJQHnn2XrK52w3tY8zONlrGnxASWOwYgRCPrevI=;
        b=lMigVOHikdTI/pwPMVVrs/uuiA9KEuqaNPgAfr5t4uO+m7YUwOfbD21J1ncCt3CutZ
         Y2Erf+2FeSWZqexxk7n4nDTik3GFAkv6pqF3BJqDgpk03zR7pON4NmsATxW5ih4yzYBn
         kMSjpamN6RDcjsMxDuOGb0canU+7KD+bYu5rnAI6C+uT9u+rEPPVW231w8ChMreuq2rO
         sXvy9rJyHWjEK2cFha91gdh8Em9tyl6Q+oSc5x7krDC/owI3ShNmyxjF2cJsTeo7N7by
         zozZ4p4lm5drNj30AUZ8XZySAceMhijb+JdH+6RCW5CUaPdb4tukmVmjbav2FrEaOJer
         K6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178033; x=1750782833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBtlyJQHnn2XrK52w3tY8zONlrGnxASWOwYgRCPrevI=;
        b=PFQlWSe07B2SZxtyDV/vVqx/3IthzVQdO2DYY2jFYOs6jfvXonRG3yzBhUdyAw4HUo
         LI5IYYivw5z2OxjBDXsl+I3dPchVCaRFA0ykT4B4+7pwBwj3kqLfBaTtsM7ZOIRIAWuQ
         ri0cj0bIvSG3V+5DqUJrB8ZxdaBhxSQuegZyn78FHtihn5ioCMzuZ+GXjmfwzyxElJ0l
         6mIcgErrQLX+USyDNLxy7L9xeI2OxESorKNw/Ij/pGih72hi3fW25kXwor3r3zaWgdJ/
         XXbS58lFsI+iVXkw6JAMX0VeX+MHJ/nwpNO72Kkik+L2UCHvBmerTEFkUR+tUeNmojW0
         XsZw==
X-Forwarded-Encrypted: i=1; AJvYcCUfslRV2/8grGipwyvLHVBFB8ToZvN5ttf/J7RYKcqZeY4dE3x79Jjd/djz3A1zGfucRqw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRUGFJ0DONXst6qArauMY26TliPNNetmW3ONyikBCKJCC21iWl
	pKKjsXzG7J04BViTPM88yOopN59YA89BTdFxfo/cv3aucQLrgCYumfLdPJagASg4IkE=
X-Gm-Gg: ASbGnct60mVX05is7UkJpD3+vM9cCBk4YDfyuLWSlvRx2fO3BlbdK/9EcaR3stix65J
	QUhDnBCqLoafpCcw+Am6scXSE0rshrDcydHL2MpZNhFaqFstqu4bENjSadN9Axlc9ot31Xht9Dp
	aRH52yxwg7wGANbZZeH0RMFHfNbIjP0AMK6a5DJJ8OCBGCOmywukIP8KmozWIJLPC5RdiM84ApT
	pa71aBhEaFf4ZKroxA68q2UYJLlRgzVOBZwtCHJKuth3yLqbgB4qalaDYLQoKzf/pkej4HB7YKt
	S35zpWgvvSHSzSD3ZI2r5NsRK2MReWmqxTmiNlaeCd8fTV29b6RBFJ+wxzR7NI0=
X-Google-Smtp-Source: AGHT+IH+3wu/JYRt2Cb67tCwy6ldv4JyxCS38r3+XwSF93HDvkOHA/dvMd3/djG9W8UPOVQhwyydqQ==
X-Received: by 2002:a05:6000:2582:b0:3a5:27ba:479c with SMTP id ffacd0b85a97d-3a5723af8b9mr11474110f8f.43.1750178033368;
        Tue, 17 Jun 2025 09:33:53 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b798d3sm14364723f8f.100.2025.06.17.09.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 09:33:52 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F3F655F845;
	Tue, 17 Jun 2025 17:33:51 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Cornelia Huck <cohuck@redhat.com>,
	qemu-arm@nongnu.org,
	Mark Burton <mburton@qti.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC PATCH 01/11] target/arm: allow gdb to read ARM_CP_NORAW regs (!upstream)
Date: Tue, 17 Jun 2025 17:33:41 +0100
Message-ID: <20250617163351.2640572-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250617163351.2640572-1-alex.bennee@linaro.org>
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Before this we suppress all ARM_CP_NORAW registers being listed under
GDB. This includes useful registers like CurrentEL which gets tagged
as ARM_CP_NO_RAW because it is one of the ARM_CP_SPECIAL_MASK
registers. These are registers TCG can directly compute because we
have the information at compile time but until now with no readfn.

Add a .readfn to return the CurrentEL and then loosen the restrictions
in arm_register_sysreg_for_feature to allow ARM_CP_NORAW registers to
be read if there is a readfn available.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-ID: <20250507165840.401623-1-alex.bennee@linaro.org>

---
vRFC
  - this is a useful debugging aid but a bit haphazard for
    up-streaming. See thread comments for details.
---
 target/arm/gdbstub.c |  6 +++++-
 target/arm/helper.c  | 15 ++++++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/target/arm/gdbstub.c b/target/arm/gdbstub.c
index ce4497ad7c..029678ac9a 100644
--- a/target/arm/gdbstub.c
+++ b/target/arm/gdbstub.c
@@ -282,7 +282,11 @@ static void arm_register_sysreg_for_feature(gpointer key, gpointer value,
     CPUARMState *env = &cpu->env;
     DynamicGDBFeatureInfo *dyn_feature = &cpu->dyn_sysreg_feature;
 
-    if (!(ri->type & (ARM_CP_NO_RAW | ARM_CP_NO_GDB))) {
+    if (!(ri->type & ARM_CP_NO_GDB)) {
+        /* skip ARM_CP_NO_RAW if there are no helper functions */
+        if ((ri->type & ARM_CP_NO_RAW) && !ri->readfn) {
+            return;
+        }
         if (arm_feature(env, ARM_FEATURE_AARCH64)) {
             if (ri->state == ARM_CP_STATE_AA64) {
                 arm_gen_one_feature_sysreg(&param->builder, dyn_feature,
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7631210287..8501c06b93 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -4996,6 +4996,17 @@ static void ic_ivau_write(CPUARMState *env, const ARMCPRegInfo *ri,
 }
 #endif
 
+/*
+ * Normally the current_el is known at translation time and we can
+ * emit the result directly in TCG code. However this helper exists
+ * only so we can also expose CURRENTEL to gdb.
+ */
+static uint64_t aa64_currentel_read(CPUARMState *env, const ARMCPRegInfo *ri)
+{
+    int el = arm_current_el(env);
+    return el;
+}
+
 static const ARMCPRegInfo v8_cp_reginfo[] = {
     /*
      * Minimal set of EL0-visible registers. This will need to be expanded
@@ -5034,7 +5045,9 @@ static const ARMCPRegInfo v8_cp_reginfo[] = {
     },
     { .name = "CURRENTEL", .state = ARM_CP_STATE_AA64,
       .opc0 = 3, .opc1 = 0, .opc2 = 2, .crn = 4, .crm = 2,
-      .access = PL1_R, .type = ARM_CP_CURRENTEL },
+      .access = PL1_R, .type = ARM_CP_CURRENTEL,
+      .readfn = aa64_currentel_read
+    },
     /*
      * Instruction cache ops. All of these except `IC IVAU` NOP because we
      * don't emulate caches.
-- 
2.47.2


