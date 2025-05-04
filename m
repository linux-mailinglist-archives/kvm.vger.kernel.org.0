Return-Path: <kvm+bounces-45331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0747AA841A
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:33:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16AD77AC3A2
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4023A183CC3;
	Sun,  4 May 2025 05:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YJFuAyaM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018A31CBA18
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336595; cv=none; b=tWwd/NAcaINVj4wGwGLsePFXLftYBoWrT0+FtpjKZZGM3SgT90Lgh+YlDg48BaoXUDfNjD8OP0PAKm0/jNGZD9Qlqwg/NOr38yvIjYVC/aK9n/UXa17DkWKM7kKM+aAZExvpehQyABh5HxAEfpyLLyRw3hWiKNNTES+9T2IftXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336595; c=relaxed/simple;
	bh=qAMbnkxTs5WuRfgaHlucgPdQBhZR1diod+ewjEZNWr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWVmeuS+p4kI4tusPPP59K4pz9m825NNpBcNmYalM9oCpSHGPJ0nUBruL1S17JcmfwqAJYbbGpgLrNsmfjC3xc6rOC3uem/xY24NOLdvVM0o/1L7unniUWCKNm/DzFkOvpvhkNoQ1vH2kvvDSNyfAJZeLc5jQZsmfpVln2ERpTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YJFuAyaM; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7394945d37eso2841267b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336593; x=1746941393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/CSUL0IAfSicZGUxwfQSMF+CcpH0uxTg/tJpwo9blQ=;
        b=YJFuAyaMWV3gBUSMWFv834Jx+c5f9CCVDOUX8oQreJlvXBZigz9U62IFLp7C1OBVfP
         gwItrIVltIGdmqc+vXfFuO1flKwXmk1+RoHIvpLNqm7ClymM/j5J5oU2iGPlCGUE8U2x
         tWASDOGZqhNvDTywpEvycjghkoFWvJj/xcw3Y1TYkIV8Ct4z0TD1yCbphEaOwAQLe/6E
         cqQzW+x99CsVgrv4wdBzpuNARoSXJ3dmFfuwq5VI7DomAnrHZW3ElDuxYc2AvNZaPnO/
         8eFdhuql9EG6rXEl4ufsJGi1aTNGOBrg71ZUe0g9VAYwUoNA67U6ZWSkEUKikh8yaFSL
         iN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336593; x=1746941393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/CSUL0IAfSicZGUxwfQSMF+CcpH0uxTg/tJpwo9blQ=;
        b=Z5A892e1xyNIxke49yxYL580wb1hn++srhFyqBjO7X+0nLfNu6vvVM4f9HlkUZeAsb
         FaxmDa2VR5DqAB8moDKY/M3zNZVgr35erERKiVdqcg76m6U0Rf3iEDSnlm9n1lSpff6+
         6d3X+g9lpkabhWOKMtnWi3Zm/5sZS1IOozS4FZuqV0lazeBr2hs488xG8HVSm//kdfJI
         3hpzs+Q1IWe9BqG+/iLEEFG0OOvBqWT7Rw4sSrcHpHqcLxxDyccLdGTcDjcsqBn0ep+S
         6YqbeeaY5nyfcDhFiVY2cjDGikbt/Ga+AaYS31fkmNCRuic4Fmeot0ndxsuLBstfrC4Y
         PBOQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+ykr3M7FMCR8ofshyjm5x9tuubPfyWA1KNtspe5EoxJZK4C5Zp0E6AswzYz7EOqYQ5g0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0xZMJ7cSDveDxQ7TUT7iQW4OeUBxnZgaWfPVN4u+YvACDRDKW
	hiktKqd8ESjYLvrTW+jErVzBuyF8JKeQH98K/SH+e4rE8WiYQEO5Lb+EMUQnUqk=
X-Gm-Gg: ASbGncvruwEpT9bWdbMY5so9VRVnves8PDu9Z38IFXmFdLxZHeZwY42JROliYGRl1pC
	rS6aeVl3v2xxb1BmROABw2f/qjdRNTGL3UAJ7dD4xZMs0aWJBDnpm7e0khyt6A5SvDd6EWNd0Ez
	1Cpk/DmUlkakh7Flg0wgS3yZvfCIeSC7OnaHuBEXfxNbUG2BSqvpoJyRgYO49RHECozoauBrtPw
	FhBYEFBa0FX+cNlZH7LyMDXaElQm1VghGCA8gG7qm6pwkOcNipp98HnPWZnpqDUtZE4WXl24GZL
	FPfHUnEteOqn9dL7wNRpnCR9LicUR5Vb1lmPXHHO
X-Google-Smtp-Source: AGHT+IHywaMkGvwrUiu+pF63431wfSDN2JgGeySP4RmqHLBWsgAcUe/WGEW4xlqLjZ4SRwwgqz4yuQ==
X-Received: by 2002:a05:6a00:414a:b0:736:3ea8:4805 with SMTP id d2e1a72fcca58-7406f0aca49mr4036802b3a.7.1746336593306;
        Sat, 03 May 2025 22:29:53 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 38/40] target/arm/machine: move cpu_post_load kvm bits to kvm_arm_cpu_post_load function
Date: Sat,  3 May 2025 22:29:12 -0700
Message-ID: <20250504052914.3525365-39-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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


