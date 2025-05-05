Return-Path: <kvm+bounces-45385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D4CAA8AE1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74AA21893DD2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA801F8EF6;
	Mon,  5 May 2025 01:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KKQ2Iru1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1D01F461A
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409986; cv=none; b=avcQXfOJzyloHgQXBrA94hlacjjJIS8I1e7RPIfCHxItY59U+F7+DYpbNVFyqvp2k/ZxpzdWRu6h+GgflisBzSaifi3w7BYgnXrbjt0WxzEoCcGmGDwQPZWbtdxBQGBebW0TwLvelXwqGawf+9QGbnWZSB8u7PDC+/6K2mDjlFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409986; c=relaxed/simple;
	bh=aSbnKH8pmC67CUwDq/sEyuDHXO2JperNLSdWSDUJY4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEPIvT8zJy0dY8aynu5X82NzWzb7+GvVmKoIg09Oa4S4As4mVLuJ+pmTiZuY9b3c2W6l0EXOJDIo8b4PqJvpD1YjKawSSw4cnuL9Ttqg6S22+HO3Bik7TJ4jBtiTaMefMmGhnzsy6NlU0ai5f2zyL5zI6PbT3TfaJiH1XtH1Rk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KKQ2Iru1; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso5500229b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409984; x=1747014784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCBMR6tP31v0B0NBZf6LKRmnPLfJofFf8No/ewC08TY=;
        b=KKQ2Iru1AF/CXrRheXl6CeaU5l+gpFy4ILYcG2ZPjExv+bbIj+khWndnPDd+Q7uXmF
         Wr1nGB/Rls5Na58NizjRe6OrHiihVCAEe2Bpnp2hFv9OBI8jFQZ04/s3oB4BGUGpIXh+
         sGqsXBGgat4aDQ9IogtrUM/PeWzR02+o1c5oCYKizEz7RdhLjzHNpLLt2R7Ts+qm96Ik
         8WqaEfMmsFsdnM5ahRyQoxYJ/gopiYRYwLxXkx2rWoXx/H3iI9X0ySQoJUUu1rZ4HiJA
         l2Uwctn158Fq52SZ+kWHOElu+k6Uc+sGMd0qIHnt0fX29dxG473Np/IAfadisYPYlkbe
         xlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409984; x=1747014784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCBMR6tP31v0B0NBZf6LKRmnPLfJofFf8No/ewC08TY=;
        b=vQMOfZeAAdNFaZMAh9kO21SWUjcWyHagG4EER1Hn9OGPaaOXFsfNdh8FrAO21M2qUr
         5VsCqirZsmv8mkHqrNo4LOb8BX6pcRRtQF0nWgsrWFgxLb10FT+qdqQxhtbnqEXVXZnB
         1hkp1iom2s9oHw4ehyYmQUDJQ/PzUVGA8CSfaWWqVsW8Vvw/c695YkPuGcOI92mb+atr
         BUtFEEIfJUmYRymPpwm1fLZIpsirvg8IN2Nl8V/9EySjco/CGnglB8/9kP1/mPcrm0Xm
         EZF4Oj+CO7SeUhZA5klSegFWW31EAmjILkjdG9iEN4FX4yZx4ZIE+mU4/iuv+eGTnPay
         yuZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZuLSOqlvA91AbzTHnTaLLR/55uI76Gu1NxaTsBSPjiAg1YxDewRgs/nYG6RU37c8j2bc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBuQKyyXvE63RQNRtiYD8TU9ZQ1b5WwHigu1XGMa3ht+pboYNT
	Fzo4l4YXn5s/fqaLGf9IBM827Zk4iKhqqHDboE6M0o8Z7CNbUaTbbaj+1mbD+28=
X-Gm-Gg: ASbGncv8VvdvQL2oPeUSq6VC7/llBXVv+nA9e7zQMYpp4BZ7QQq2lJnfqEeURLSFczP
	3TZHlpIcCJkUU0AcS9Lb99nuwIi3/McrFOULu7BJCuB3zqUqq7nP1/7KLMpC1LowLyx9GEs+nCF
	4WVlotqbXm9sHwcOUSGXchCN++iSebiJ3DSVsnEVq21yxjg3N62EyJUc0YgYL2WUftMFjR1wjKm
	Z33D0TDlIRitnsiW8HnFBYlLbF1JHPElt9bAJ4c3n/Dkm5ZDgGjUp98RJbP9SD9Z10oDERyPIbO
	Si6J0cWtTNAqF0AEvMrbAgcmhml6CVks+444SuuO
X-Google-Smtp-Source: AGHT+IE14LFS/k60IBKIkWbmJ21gqOAFxrj51tLDJH6tuiS+nErdOLx6heXp6VXr6xQ79bIRJuVdBw==
X-Received: by 2002:a05:6a21:3295:b0:1f5:8e54:9f10 with SMTP id adf61e73a8af0-20e979c9932mr8906025637.34.1746409983790;
        Sun, 04 May 2025 18:53:03 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:53:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 38/48] target/arm/machine: move cpu_post_load kvm bits to kvm_arm_cpu_post_load function
Date: Sun,  4 May 2025 18:52:13 -0700
Message-ID: <20250505015223.3895275-39-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


