Return-Path: <kvm+bounces-46237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2CDAB42FC
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6B8B7AFF0E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE872C0863;
	Mon, 12 May 2025 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zVhKnK+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866B42C1083
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073146; cv=none; b=rJcmPGAKshXVM3Xjkje02U0V6oSTewmuM67igcbiXk5B3J5WfxeFEevjUlgr7oL7qg8P7W+4phb6AgIUBtuAhfOdDEFUKwJJVC162nvxKuS+yw4YQaFcSwrKdua/+1TSORpeBMoFOJBYWAd8vo0IxzVnMiFqEZtRRaGE1cyWygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073146; c=relaxed/simple;
	bh=nUEExklIC+f2qxmt7sIZe60ZDahNB1d4KEmoHf8Ivyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rq4Mt6LqWtumM0DlcygDG+wPZXIR2zW49Gosi007E5dRGCOzOFVa7M62CsRnCuleT8dfEToWuR1nFLCKJ81mxCaPfuT+MvjLfdUOWxUWlYJQaR4B4QoCuN/EpYvI0m633KDLuTAL3wq/6VaWza49p/U/fL4RvuWH3PJTjdU5Vzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zVhKnK+p; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22c33e4fdb8so40917855ad.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073144; x=1747677944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNwQBodHKU/YNnzJ0OLvvAjHAnJFIjZ/+9H8rnLNev8=;
        b=zVhKnK+p7Us1QukvkDGK/2BE84IFXktg5ay8YUmJSNAwU2cGX07tOYABTmSoxP8QMU
         UTY3rTTX/lTu0qjM78vQ6kJQa7F2HK5G2l3dHjQKWWH6g3ed0jjBAQ2Ijzsf9cJPQe18
         NtVn/r8jMYukNWTHSVz/dj9Jg7+R4KoS6CTYrxKI6LgjmZOnvvoeY9jDvEl9XQzDRqBQ
         q9cVaO7Dw36/i+tmn+mKCLYQgiLYwYrsQjEmfgMU4akjJRTVHLEumOVYT47qXGXmFOBz
         IFvrCIUF2zgPTM4Q2enHxGYp3EkrcGUnGw64FO4tWfOPTXwxhj1pUuYHlsP/K+W2sF1z
         bjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073144; x=1747677944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNwQBodHKU/YNnzJ0OLvvAjHAnJFIjZ/+9H8rnLNev8=;
        b=CKfEGdFqFxrmHvjJ+v8xDnddRR/QTxYmGayjfF/bViPmzk782Wctr2exoBntCZmrOx
         03ftbLsGblywtnjNgdzfKKdwFn48WqbuH50UYA2/KTOjNvlW8F6MBDuxOxV25OLLxtGx
         TkhCXYff9/RM/8Jznx9kxXco2aRib+QoPWrwmleiStGCHAO/pLCFiecNKMbV9Wdah6PM
         u/qimy48MkUR/GtkfkXCnbL1t+fK1Uym32HYKKh9bH7HTNmumwNH4TQ4o1mKaSxjtquC
         g2UwQ/MKPL2lAzRbQYBTKuSSefGERQSgbbUHrN54edms1X+9G0W1d4uVk8O4sdhynzfv
         TPzg==
X-Forwarded-Encrypted: i=1; AJvYcCVfeiOKEwpJc6m+DKCmHcQFVCbrO3cD3Zo6DwJMPwS19In/VKlTnBdygwCnSk4N6kc7hFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDuSMR21HcZ5kof19d4TwqWE1ONy/+yFaIO65+gT8HJIU+ngr2
	xhpTreKOFM+CCQ8Ri8FPslhlnlhJMq8iWIwEhllACQqd+6T6TK3vUyLyL1j9syU=
X-Gm-Gg: ASbGncsdKa2b79JP70x0yHTrZgxmn7WPf5Zo/B7i4ro1qlH4mFrlRmmjwOWKY6HxiRg
	u2B0d8/Z5RU0ZYhAAiTMX95t6EoEUlNkBWTnjBn2p9eRftTa9Kn2Evahhw0sk5hrVQqS8Gdq0Um
	8ctZILEZ6B8vvH5h2t+QjWJRVMyBzxqwdAcCd9vMQSmul76ic6w/X5hUB3628FON+WZGgyjRyqv
	LfUfwLZI/OyS52kCULjlB8c3+lKIGhMR/fMBWfNTwNEJTgRjLQHMuPfeG3Qirmf3S8CBxMYv/I2
	rrNxVTzLNtXlh4OynVvZkcCzcLUXjD1WmZgPXqHEtRdezQWWrawgsb2DgIfAug==
X-Google-Smtp-Source: AGHT+IHsdPyvkI06Br8pyqXwcLuHQL+6O0ZNsb9aqM/OXtXPB4NrBUBCNdmarJacg2dltIYJwQG2/A==
X-Received: by 2002:a17:902:e5cf:b0:223:5e54:c521 with SMTP id d9443c01a7336-22fc894f1f8mr197858765ad.0.1747073143901;
        Mon, 12 May 2025 11:05:43 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:43 -0700 (PDT)
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
Subject: [PATCH v8 36/48] target/arm/machine: move cpu_post_load kvm bits to kvm_arm_cpu_post_load function
Date: Mon, 12 May 2025 11:04:50 -0700
Message-ID: <20250512180502.2395029-37-pierrick.bouvier@linaro.org>
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
 target/arm/kvm_arm.h |  4 +++-
 target/arm/kvm.c     | 13 ++++++++++++-
 target/arm/machine.c |  8 +-------
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index b638e09a687..c4178d1327c 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -83,8 +83,10 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu);
  * @cpu: ARMCPU
  *
  * Called from cpu_post_load() to update KVM CPU state from the cpreg list.
+ *
+ * Returns: true on success, or false if write_list_to_kvmstate failed.
  */
-void kvm_arm_cpu_post_load(ARMCPU *cpu);
+bool kvm_arm_cpu_post_load(ARMCPU *cpu);
 
 /**
  * kvm_arm_reset_vcpu:
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b6c39ca61fa..a08a269ad61 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -938,13 +938,24 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu)
     }
 }
 
-void kvm_arm_cpu_post_load(ARMCPU *cpu)
+bool kvm_arm_cpu_post_load(ARMCPU *cpu)
 {
+    if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
+        return false;
+    }
+    /* Note that it's OK for the TCG side not to know about
+     * every register in the list; KVM is authoritative if
+     * we're using it.
+     */
+    write_list_to_cpustate(cpu);
+
     /* KVM virtual time adjustment */
     if (cpu->kvm_adjvtime) {
         cpu->kvm_vtime = *kvm_arm_get_cpreg_ptr(cpu, KVM_REG_ARM_TIMER_CNT);
         cpu->kvm_vtime_dirty = true;
     }
+
+    return true;
 }
 
 void kvm_arm_reset_vcpu(ARMCPU *cpu)
diff --git a/target/arm/machine.c b/target/arm/machine.c
index 868246a98c0..e442d485241 100644
--- a/target/arm/machine.c
+++ b/target/arm/machine.c
@@ -976,15 +976,9 @@ static int cpu_post_load(void *opaque, int version_id)
     }
 
     if (kvm_enabled()) {
-        if (!write_list_to_kvmstate(cpu, KVM_PUT_FULL_STATE)) {
+        if (!kvm_arm_cpu_post_load(cpu)) {
             return -1;
         }
-        /* Note that it's OK for the TCG side not to know about
-         * every register in the list; KVM is authoritative if
-         * we're using it.
-         */
-        write_list_to_cpustate(cpu);
-        kvm_arm_cpu_post_load(cpu);
     } else {
         if (!write_list_to_cpustate(cpu)) {
             return -1;
-- 
2.47.2


