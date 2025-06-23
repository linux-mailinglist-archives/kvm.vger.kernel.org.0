Return-Path: <kvm+bounces-50323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B274EAE3FF2
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8BBD189AAEE
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D962475C8;
	Mon, 23 Jun 2025 12:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BhLAgm0V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44E023D2BF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681192; cv=none; b=Y1Rkxfa8KQoB8kqeW1imAgJzzhIBrv6UoizBz3Lwo3O+z8SxnAyoAPSsPDZmxWY5npULgwI1QK6SSGwTwLrPd/AGU64ISs7I7sZLUZuQSOMzTi+oPtyxPKj2XVzEenMBcl1xcRoO2Yuh2und2L5ydBtNuY14UpQEbUCprkE3Kwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681192; c=relaxed/simple;
	bh=FQHY1qz4XsXm0Rl3aIb6rLi3Nuv1xWtajQO3g+IgjzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oa0h0lX94EFfX91Rhi+J1cIKppqPOM9627NVCVG5T1tSZCh+LK0NOOVstjD1+txi4MEydeC13aUH2b06PXLLYRAz88nMAavQs3+M4MG/nIYmB27PeUoYiZg4TxSWSyrjt2nhakOzlFtOsZ0Li3426rc3e2Z/t1rpTLuzJjmEJjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BhLAgm0V; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-450cb2ddd46so24183285e9.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681189; x=1751285989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MZYDDWvDMspPzhkKxydUFPlizzWHJdNmtQlGNWnBP18=;
        b=BhLAgm0V5TOTt5SbCqomhW13TwrYr1Qt5HSAS6TpHrKWn1+oiSRwUauk56TWMz4RMP
         klIaKgOK8dtXL8wzGrOK+cF4U/z2rSvk7j5Vsq99aHG9VSB9uNP1V2CmaVy4i4z9kDt9
         mfiOJu+VAwWQets0Ta+uUwS6DPTqZQbv3KJnf0L+SolWDQq2TVCXZ2MIOM0jxRe7RkmV
         KIHPinpDPOEW8mFlH7DLq+02B0pSkePTd0k4gQI0BBGWeIYCsAK33U9SuNAfazD4M8G3
         V8LCy9ZwyRCeXi6h/U64ulkAZoZZmtSbrnNUsp85T8gRdfYiOUCp7jCTPy1KmPGV+L+j
         3e0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681189; x=1751285989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MZYDDWvDMspPzhkKxydUFPlizzWHJdNmtQlGNWnBP18=;
        b=ohy0b+yDWxWBqiKA0idK5/92+KVpjPOLMUkvrX1ln/D4cOYly+qYUkAKLgCQAX2M3v
         DFdy5Zf6GBVHa0GQzaYekVw/eB1g2e03b7+1cyavAibQ39Xn+j8LSvEZOESWXkaMEJ75
         nhn14oQtRdW6eE6/d2uLiANzB3ZS9X68ksabT9ILGZWhFUS+zUXk9qf1F6SbZfMJ23tE
         CZtNtHi/TebbWLCWwKivuYSJYnYs0ahcJQYOj+DEfUdkmWD5eM42MzFvuf15KjnZG25T
         Hdh9Ks8HE8B86v75fiqafJLFseRQ97DmToOJVt3A1Ir2uDJTzBACFWDRdWjxPHC5ximA
         yAsg==
X-Forwarded-Encrypted: i=1; AJvYcCW0p3r56DUQmXFJKJqClhlj1iBk1ea1xOZipMiZJ9w01ugxgVFgZ65WvW8cL72wnRaF9Kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMEqNj6RkHb+tfCR8n2htLPDOBjTq1qRk8xUZP6AmWNPI3kN5y
	VHurQF4jFGjxGVjCz0+UpMzofy1ifdaqWfeeRCGeDN8/Lu5d9K79FaUnPUzvGMZ/uC0=
X-Gm-Gg: ASbGncujf377HK0WcQXk+sr0s7Mzee8ZYU6MAhtRCdnroAO5RXAZFMB6Vf+L/k/UTYH
	stkQ6sTuy4lANJjWwaBTg7JQvS10IBmApDo2GPCLBk6Y3eux1+51F1Me6IFeTg/N4BxGc4I6BQ5
	8tny441jc4RBDOvM2xJiGUaMinmOOYkg7Kna/kTklQD4m70sViuaVuZJ+PAJsAF+YgZEvf11t83
	ac0jSnCbvxvSbbaoD6j71YFg2UnNMCWXaclHK+GuT4H9Xsqwc4xyXhmSTHl+4AarpiMR+47CYja
	DD/VL2d0AWclVaJd/+wFa0dDxTImyvbbPCzdXHix1HIlAII9aUZHOzDxhfXGxozJbyrJ6uILTy1
	S1zdlep3qSFeJrve+7jXucsC/HKefWqLrg6Vm
X-Google-Smtp-Source: AGHT+IGt+hN6QhdH8hKFCVkO4jTWulC9IJ1I0tIA0BlYCZoOOrf5ORdSOfgPjNgKAX8CHSeqYE/nlA==
X-Received: by 2002:a05:600c:1d14:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-4536b4be314mr77860915e9.0.1750681189099;
        Mon, 23 Jun 2025 05:19:49 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453646cb57fsm110694655e9.1.2025.06.23.05.19.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:48 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 12/26] target/arm: Restrict system register properties to system binary
Date: Mon, 23 Jun 2025 14:18:31 +0200
Message-ID: <20250623121845.7214-13-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Do not expose the following system-specific properties on user-mode
binaries:

 - psci-conduit
 - cntfrq (ARM_FEATURE_GENERIC_TIMER)
 - rvbar (ARM_FEATURE_V8)
 - has-mpu (ARM_FEATURE_PMSA)
 - pmsav7-dregion (ARM_FEATURE_PMSA)
 - reset-cbar (ARM_FEATURE_CBAR)
 - reset-hivecs (ARM_FEATURE_M)
 - init-nsvtor (ARM_FEATURE_M)
 - init-svtor (ARM_FEATURE_M_SECURITY)
 - idau (ARM_FEATURE_M_SECURITY)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/cpu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index eb0639de719..e5b70f5de81 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1500,6 +1500,7 @@ static void arm_cpu_initfn(Object *obj)
  * 0 means "unset, use the default value". That default might vary depending
  * on the CPU type, and is set in the realize fn.
  */
+#ifndef CONFIG_USER_ONLY
 static const Property arm_cpu_gt_cntfrq_property =
             DEFINE_PROP_UINT64("cntfrq", ARMCPU, gt_cntfrq_hz, 0);
 
@@ -1509,7 +1510,6 @@ static const Property arm_cpu_reset_cbar_property =
 static const Property arm_cpu_reset_hivecs_property =
             DEFINE_PROP_BOOL("reset-hivecs", ARMCPU, reset_hivecs, false);
 
-#ifndef CONFIG_USER_ONLY
 static const Property arm_cpu_has_el2_property =
             DEFINE_PROP_BOOL("has_el2", ARMCPU, has_el2, true);
 
@@ -1532,6 +1532,7 @@ static const Property arm_cpu_has_neon_property =
 static const Property arm_cpu_has_dsp_property =
             DEFINE_PROP_BOOL("dsp", ARMCPU, has_dsp, true);
 
+#ifndef CONFIG_USER_ONLY
 static const Property arm_cpu_has_mpu_property =
             DEFINE_PROP_BOOL("has-mpu", ARMCPU, has_mpu, true);
 
@@ -1544,6 +1545,7 @@ static const Property arm_cpu_pmsav7_dregion_property =
             DEFINE_PROP_UNSIGNED_NODEFAULT("pmsav7-dregion", ARMCPU,
                                            pmsav7_dregion,
                                            qdev_prop_uint32, uint32_t);
+#endif
 
 static bool arm_get_pmu(Object *obj, Error **errp)
 {
@@ -1731,6 +1733,7 @@ static void arm_cpu_post_init(Object *obj)
                                         "Set on/off to enable/disable aarch64 "
                                         "execution state ");
     }
+#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_CBAR) ||
         arm_feature(&cpu->env, ARM_FEATURE_CBAR_RO)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_cbar_property);
@@ -1746,7 +1749,6 @@ static void arm_cpu_post_init(Object *obj)
                                        OBJ_PROP_FLAG_READWRITE);
     }
 
-#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_EL3)) {
         /* Add the has_el3 state CPU property only if EL3 is allowed.  This will
          * prevent "has_el3" from existing on CPUs which cannot support EL3.
@@ -1818,6 +1820,7 @@ static void arm_cpu_post_init(Object *obj)
         qdev_property_add_static(DEVICE(obj), &arm_cpu_has_dsp_property);
     }
 
+#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_PMSA)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_has_mpu_property);
         if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
@@ -1854,8 +1857,6 @@ static void arm_cpu_post_init(Object *obj)
                                    &cpu->psci_conduit,
                                    OBJ_PROP_FLAG_READWRITE);
 
-    qdev_property_add_static(DEVICE(obj), &arm_cpu_cfgend_property);
-
     if (arm_feature(&cpu->env, ARM_FEATURE_GENERIC_TIMER)) {
         qdev_property_add_static(DEVICE(cpu), &arm_cpu_gt_cntfrq_property);
     }
@@ -1864,7 +1865,6 @@ static void arm_cpu_post_init(Object *obj)
         kvm_arm_add_vcpu_properties(cpu);
     }
 
-#ifndef CONFIG_USER_ONLY
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64) &&
         cpu_isar_feature(aa64_mte, cpu)) {
         object_property_add_link(obj, "tag-memory",
@@ -1882,6 +1882,7 @@ static void arm_cpu_post_init(Object *obj)
         }
     }
 #endif
+    qdev_property_add_static(DEVICE(obj), &arm_cpu_cfgend_property);
 }
 
 static void arm_cpu_finalizefn(Object *obj)
-- 
2.49.0


