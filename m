Return-Path: <kvm+bounces-45516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C775FAAB04E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:35:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 849D83A683C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00DA3EF4C2;
	Mon,  5 May 2025 23:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lm6i2cty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF473B35AA
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487257; cv=none; b=e+fQAKA0hjKE8Tpuy/XJwbLsnpRK7i+gn4yqQJjSn46W8Xe3+U1NqvpwqV1jy3MploVaE8AZld/twxjA9uAUEYNqtN0q44yuJAroLLULgmIpfV9MFx+3EwcT3tx4XHA749vpolq9OdzOge39U2EsySJAQ3Cm+E9PbiTUZrjTwto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487257; c=relaxed/simple;
	bh=aSbnKH8pmC67CUwDq/sEyuDHXO2JperNLSdWSDUJY4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueeNaAqJYFS8NlT08rJ/ZVXnBFxujoH0TtrsCG9cRkCyTLNNYxSKUgq66sr7OFG2qMneEMY1SMGFxbq2XNxt2MC6H8ujn48ESrppEjGbGSi2NWwzShkeFujlL8hxkXRiOWYXrbAvdy1LCuZURX+YGCxjQillYkbUhcIInTCEZDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lm6i2cty; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-223fd89d036so56058275ad.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487254; x=1747092054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCBMR6tP31v0B0NBZf6LKRmnPLfJofFf8No/ewC08TY=;
        b=lm6i2ctyWZtvx5O5ENNz0ZN6lIpNCyVQzgwpprS7LgmL5rfiipdEXg+rFXb8B2SO/P
         4R3UfCE6i6rSgJ2BqAF67GnMRLij0ZM9dgUHJ12YG6nLz4cwrffi44AAnvl0O8P6nQup
         KeYprJ04OdqNYWByAM4hGXX7b6dwML2ylRbrYTtEtVKZ5NGBGssRnPlPIeHZmPlTiQz7
         auHp2ro95R9w4RuAZIhXur3FOSURrSSFgYxrf0F8bd64yPFHAKN7cMGji47VGFN3ldB/
         G3OfiIEZSAN487LRwFQhoflbiKMrQJEVAI5vR3W14D5Z2DcsxYrzSMFBtpp1i3B4iTpA
         OHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487254; x=1747092054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCBMR6tP31v0B0NBZf6LKRmnPLfJofFf8No/ewC08TY=;
        b=DS76JaMRijwqelsiLmrZVHnuisTqgKLu82U0wmSb3Osg7hyB+Nuy/Q/2Xi2Y7glDqh
         g1xz4g+dYerPMRX9cfRitV+KbN/QRCNgEYKSCadX9dDHu0A8vheNcyr5cjFiqYpiDwKb
         dAn3spCMWQTDwKUcQedUA6/zz6iJcY+Swv571B4NQRY6dP8LeauCkEw8YIDvy8P20WRM
         jhqIfRLHueCV66TWBRi1FfYsWfZHEDGpLw20JI4f17rRkeuk1vSZ1IiWSuO6Hs7TcKKS
         RMeJZbBoyE6MVCMlVbn3L8YIIiyeWmcHuFSGylqb5Nwu2K65QVeGNEleDwABQn3ZoonW
         YtNg==
X-Forwarded-Encrypted: i=1; AJvYcCV5xkAfKK1J3LUu6G3aJzjNNV2OT53ZgoGBMA13GinmkIUR1Zo0utjbAqKcRzYzAE40fRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwcLPuPLNCqbCqSGgRLugwQjzngcdmgvI06obA8XZQeBe4xn25
	0LZY/+KrEQ/cmrzQxzLuqdWSR8VatfTIpge05hoJxuNWG6Vo+/YWa9G0Yrf0Kwk=
X-Gm-Gg: ASbGnctCJQVvPfceUPhAGPYHoikiGSTzfmpoW8e80SOTwtA0RzGp5mgTZjtDMF88EKH
	dOJSkU5TUOQOxA/uW5gxFqI60d29cU4HoLdMFY+GtSJOQUe1ztHHEadqmHyPp33T57GHSFGX/fw
	CHHh+zDwdZdYXwCu0BR8t4N2z1kzepDSCagrXMQUelpLNefRfmP/9QSS04p9Pv5dTNPBTNfhqOY
	WGyZoDF5FL28+4LTFuLqHFzOKBLZh0gHuHwDyM/lfj/8kn93CdoCWMt7G5F1S+xib+Fet0Teo0M
	EKsa6XbiWidj9nL7RdOvuJSPCPM3fEILaJ/wOXdg
X-Google-Smtp-Source: AGHT+IEEWCUQlzVgGthYff6k9Jr792b5t/XjUuobOuK1wX1EdUQjPmf7ipfIT8E8WlUj0rABldNgmg==
X-Received: by 2002:a17:903:291:b0:225:ac99:ae08 with SMTP id d9443c01a7336-22e328b6d64mr17397715ad.5.1746487254221;
        Mon, 05 May 2025 16:20:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:53 -0700 (PDT)
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
Subject: [PATCH v6 38/50] target/arm/machine: move cpu_post_load kvm bits to kvm_arm_cpu_post_load function
Date: Mon,  5 May 2025 16:20:03 -0700
Message-ID: <20250505232015.130990-39-pierrick.bouvier@linaro.org>
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
 target/arm/kvm_arm.h |  4 +++-
 target/arm/kvm.c     | 13 ++++++++++++-
 target/arm/machine.c |  8 +-------
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index d156c790b66..00fc82db711 100644
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
index 8f68aa10298..8132f2345c5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -977,13 +977,24 @@ void kvm_arm_cpu_pre_save(ARMCPU *cpu)
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


