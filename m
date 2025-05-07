Return-Path: <kvm+bounces-45803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E19FAAEF85
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9A84503AE3
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E01C294A1D;
	Wed,  7 May 2025 23:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rXdVt1Fd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C8294A02
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661397; cv=none; b=XYqvlSBjuzKikJjawgTB0tekrVH3QGmVAXzjpds9kxvXWafpZo4F0ZyI/kSTyS73WbEox/6qt3USPBg7634Z/Bsr4KkODd/aqlMPh2ikDepL5pKMzdj2dzRhBlSZ12Qhd//bwWrS3FPopCYrfK4S3qScc+c/us+9Res/0LVFgzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661397; c=relaxed/simple;
	bh=nUEExklIC+f2qxmt7sIZe60ZDahNB1d4KEmoHf8Ivyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ridp7hPRX3Ure4rLAOd/e2OnwFjEgg4F91WlrVFIrQaulMOQyHtGAkKBbdHwgamc07ILEk2e2yQZrYRk9kLmGNmB6x6IRhFo/ikWiT2PZEbnOMzUFbXW5+cfkfoEmOI0cm+HkUqNQol5Cpg23AYfmQdY/OrpjuAqAgLf6obebpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rXdVt1Fd; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e8461d872so4775895ad.3
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661395; x=1747266195; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNwQBodHKU/YNnzJ0OLvvAjHAnJFIjZ/+9H8rnLNev8=;
        b=rXdVt1FdOE1R3825536GmVN4dfLy/PwQsZ7+NH8bJAeJnyPHSgcDiklQUPHVCeGVXK
         IE6wD9Q+vu6iWfnNhHR0XRdCFJJKDzlm/MZiiz39yoLVgL5SBIaDstszTdWYKhNfhN6u
         ToNE5/cryDSwto6jl/eEg5yW/pvTKGPsoN02Wti569saNHOPalkmAUJXg1Si8Syq0cDs
         HTfDRdHthFn0AZ01FljlgM3tZQICeFcOmDGZxMXQYCKkDwlQZa81WRytQYXEowMPKxcX
         a82aRRYleyyfSpyf16EeqFNoJ7OCUDTAZdyHCEI+SyHccfNPo2+4fEo6/mB3USRc5O7t
         criA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661395; x=1747266195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNwQBodHKU/YNnzJ0OLvvAjHAnJFIjZ/+9H8rnLNev8=;
        b=UL/70jPXiMztUKEqiZq0ggOPHdRLvwWbKSFIvkqCJuK8ppNqyL/Q0bzhtC7EL2NZ1K
         LAhRafL2TVH0xVSc0cNMz+fAUak3O1DCdtE7LRtHkcOTtsEKkcVF8Cs+MDdsSBprApI0
         b4PduYJ6vgilFtFcG8ZFPgJ6etilakPGztE/1AocKqWKIEIPEFXbI/k1J/28/flnKy1S
         Dn6//MBAk2aKHCyj148MdnNlJeTqVDE/ZyeO8R7gzAKCFhVw9FZ89mAamjq5wIRQ8G2w
         FPXiphyIbnS4emldw9TZnv+4Ul/pEBNa4yp71WXH05VpU1X1tgygZl0dclktvfeuHCnn
         2ubw==
X-Forwarded-Encrypted: i=1; AJvYcCWcnSvJv+V1OIEQgKpfs6cpRRQQB+js1tAwqoS/9vCzcYNqMheGjTaaHT6rY6wFIlLtvyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBq9puWwdUzSR60idaZ+38oPMCvbCJI/lQd9SMYrUwcfunWJuw
	2DwK9BumII54dWORWn41k6HTQcLYkM/MSV71nVmJ6Gkxiht9KxyTRXhs4YV5W3c=
X-Gm-Gg: ASbGncu8hLUK+E7YEl/Tl4biSETLbwwHmqRyUOoNEVRpRmpmk8q6tmekyxI0FjpJdFY
	Mk2ecY04nbwU5KsnIEBobZKjhtuKVWvyUU4Qc3xwaykOcWAPtXCjVpMV9crjU0dMggeJmcdGzsz
	BzHzFm1T1Xph76TfUHFupuCGQqN+mt7CfSXiFVOHmUz8el/SXriOBZrLzsJaDYyvCPzvaTCGrlr
	PxE/13xQAsenDqQPQp2SI/tM1nmfq8ljkQWfSdd8XmA0E/wZYWUlZxhEPfGqPCynhFPHCszcA55
	YFrkddgHzSeA+LC8jibHf7ww+fSlb0JgfxJxFs3q
X-Google-Smtp-Source: AGHT+IHzJdvFnh9XOsFcRbkcBf5qvX2uV6HTIjm/MkuKOh9F3IM/eLfP1ilS43wd1wjfnqd63Z7PaA==
X-Received: by 2002:a17:903:2b07:b0:223:5c33:56a2 with SMTP id d9443c01a7336-22e863e371emr16940145ad.28.1746661395022;
        Wed, 07 May 2025 16:43:15 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:43:14 -0700 (PDT)
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
Subject: [PATCH v7 37/49] target/arm/machine: move cpu_post_load kvm bits to kvm_arm_cpu_post_load function
Date: Wed,  7 May 2025 16:42:28 -0700
Message-ID: <20250507234241.957746-38-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


