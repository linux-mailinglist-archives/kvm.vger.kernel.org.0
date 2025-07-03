Return-Path: <kvm+bounces-51464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8A2AF716B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F13B05278E1
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4657C2D4B53;
	Thu,  3 Jul 2025 11:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z5i2Syuo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EEA2F872
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540472; cv=none; b=LC1Q/rZmaRromcF+9YI50bj3VLNs780hqCHWQKFkeX7hgJW28sIS+fv9nrGV/kluvhnqhoQWymHEjCW4MGVvG/kx/g+2lGeSdF7bK4JRJ2UwnHuDWu02daQQd5r4yabzJyfao/DHMd5xyoTR7yNY9DfulAZt12sjl9vgap1kb4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540472; c=relaxed/simple;
	bh=ZOyQIV2Bubph1gy15C0++DdW4vsvyWiNL54UY70Lu7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ddXkdIc+l67pHrwKk2aUuQ7fBZAyEtX8JEmFIO5y5LQfaHKYBwRQiFrT3uDgeo00BRF71RNh7LhEvw2wLV0xN3gdek/IW+g7YqxojJe2x8qhPu+8M7A8B2zIreO82/G56oeZ4JBo+FTBDwoxSbP91c8aMPGC4MYPwEcVmcmlkUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=z5i2Syuo; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-454aaade1fbso8479255e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540469; x=1752145269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wspTc+l3MR08+xJCCFDeyBx7BUrOtzx13ywN/0VFZp4=;
        b=z5i2SyuoWVApDuOB0VlYiAuyAHPXKBH4fG7scKchA1a5MMRzwCCUDO7/4aItM2WIWj
         sI9InyN4HTJtwlS0SydROIW6qpPTMA2mKrooXYY3mbZNrOjiaGxIYJToTwSUUfyDBLfp
         QHlXgtFH6cAie6++5e/Zw7wqePYa18zn63oXf74zZlCEiqkoQ+KRHyC6joERcNiPMtft
         K8t8Y0+ULEBUDPH1Juotza//8cStSIT/KyqTJHbCRXPQBAC4heXa4SBwdwd72udLgVDH
         4N1H0FJNJ4RyUKnUT48EGpR81C7hWmWdRTWw3GHzEMo1UlT4Vyk30MR7ROFdf3NyjquG
         W4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540469; x=1752145269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wspTc+l3MR08+xJCCFDeyBx7BUrOtzx13ywN/0VFZp4=;
        b=h1N2iB60NPnOWm6GafO0688IfRelu99D313o2GJqwPd7twaLO/jgX26jH2KhPhIOzx
         Kzpz2Fbce45QJwWrPmUxfzOyfTdBkcXvBGu4IUjaw2dVJuYS5c8f+uwS87kVFx+GBt7p
         AvZaPAat5UOclcuf7oVRV82aUTOcEby8XTQ/2Xs7DwUqjQJLnKQ1IMAUIu/v7+7nfSya
         0yYtHD6wb02QQLapBUZynN/eHA89vSCmNn869+566HRynjSpLSPY6+SZMA5eB+/zqveD
         Z3FYaGR94OmbZleFd3yGvEssNkcPDfqhEADody5hu4WUBbKOkJchldCrF06kxlDkjesc
         e5wQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzLCXnVCsvFjUhHdoZ818OYVN/RvKfyT4niaIHDWnlbSnKaUgSdpAv5jC11rgfZ4Uj3FA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4ToN3vTZ8ji1lqdXAZYW+yw6ZEM0THmHSYv68emmHCuktNlNI
	UeTcKMdOTaCeabAo6IV1Kc/Dj8nNUE19+nxZyrxduYsEGktHOOX0CUSv25FnchZvEOo=
X-Gm-Gg: ASbGncvGO3mJtZr5/ms3Bh5jBhKCmRKx2pzTbe7STME0o7e7LACej+/tQyDSiqBDl3P
	nHqr3BztQDTfc4daMJM80Meo4KV48tcrpkLNXZVZRV9W5i5YeUmoXFNGGBf/+Oalmh4NhQoJKnH
	MwJIFliO28VBXXEFPBokMc42aLzhDb5K6RW4YHJlluWxXZjGNzsCYFEdnJAUs3bTwUXFjV/stwG
	vA6bAFNNH3d3UJNPU3zwmCR60uvk4UBXB4HvRvfaniouM8beVVgHJ3cVsVwnYctAGqg6ArvrfQd
	YC/ASvTe8jmnMx+IrTx3r688wleX+J/cWTF3I9FEptQ7QdiSNGEUxxkkiZ06wNsCwOhcqy1KnYM
	aoBhpgQLsDvw=
X-Google-Smtp-Source: AGHT+IHAZ1QJQAR/SkCmpVyP5d+/RVl33yWqBUHoBvJQia/1ayRud+BeMI+m9TmrFuVOLmZ8hctUPQ==
X-Received: by 2002:a05:600c:3504:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-454a36e7842mr54691115e9.7.1751540464162;
        Thu, 03 Jul 2025 04:01:04 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcebd4sm23536465e9.26.2025.07.03.04.01.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:03 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 61/69] accel: Expose and register generic_handle_interrupt()
Date: Thu,  3 Jul 2025 12:55:27 +0200
Message-ID: <20250703105540.67664-62-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to dispatch over AccelOpsClass::handle_interrupt(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::handle_interrupt() mandatory.
Expose generic_handle_interrupt() prototype and register it
for each accelerator.

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/system/accel-ops.h        | 3 +++
 accel/hvf/hvf-accel-ops.c         | 1 +
 accel/kvm/kvm-accel-ops.c         | 1 +
 accel/qtest/qtest.c               | 1 +
 accel/xen/xen-all.c               | 1 +
 system/cpus.c                     | 9 +++------
 target/i386/nvmm/nvmm-accel-ops.c | 1 +
 target/i386/whpx/whpx-accel-ops.c | 1 +
 8 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 6d0791d73a4..dc8df9ba7dd 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -67,6 +67,7 @@ struct AccelOpsClass {
     void (*synchronize_state)(CPUState *cpu);
     void (*synchronize_pre_loadvm)(CPUState *cpu);
 
+    /* handle_interrupt is mandatory. */
     void (*handle_interrupt)(CPUState *cpu, int old_mask, int new_mask);
 
     /* get_vcpu_stats: Append statistics of this @cpu to @buf */
@@ -93,4 +94,6 @@ struct AccelOpsClass {
     void (*remove_all_breakpoints)(CPUState *cpu);
 };
 
+void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
+
 #endif /* ACCEL_OPS_H */
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b61f08330f1..420630773c8 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -355,6 +355,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_thread_routine = hvf_cpu_thread_fn,
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = hvf_cpu_synchronize_post_reset;
     ops->synchronize_post_init = hvf_cpu_synchronize_post_init;
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 841024148e1..b79c04b6267 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -85,6 +85,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+    ops->handle_interrupt = generic_handle_interrupt;
 
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
     ops->update_guest_debug = kvm_update_guest_debug_ops;
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 9f30098d133..47fa9e38ce3 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -68,6 +68,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
+    ops->handle_interrupt = generic_handle_interrupt;
 };
 
 static const TypeInfo qtest_accel_ops_type = {
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index e2ad42c0d18..a51f4c5b2ad 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -154,6 +154,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
+    ops->handle_interrupt = generic_handle_interrupt;
 }
 
 static const TypeInfo xen_accel_ops_type = {
diff --git a/system/cpus.c b/system/cpus.c
index 8c2647f5f19..efe1a5e211b 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -246,7 +246,7 @@ int64_t cpus_get_elapsed_ticks(void)
     return cpu_get_ticks();
 }
 
-static void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
+void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask)
 {
     if (!qemu_cpu_is_self(cpu)) {
         qemu_cpu_kick(cpu);
@@ -261,11 +261,7 @@ void cpu_interrupt(CPUState *cpu, int mask)
 
     cpu->interrupt_request |= mask;
 
-    if (cpus_accel->handle_interrupt) {
-        cpus_accel->handle_interrupt(cpu, old_mask, cpu->interrupt_request);
-    } else {
-        generic_handle_interrupt(cpu, old_mask, cpu->interrupt_request);
-    }
+    cpus_accel->handle_interrupt(cpu, old_mask, cpu->interrupt_request);
 }
 
 /*
@@ -674,6 +670,7 @@ void cpus_register_accel(const AccelOpsClass *ops)
 {
     assert(ops != NULL);
     assert(ops->create_vcpu_thread || ops->cpu_thread_routine);
+    assert(ops->handle_interrupt);
     cpus_accel = ops;
 }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index bef6f61b776..d568cc737b1 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -77,6 +77,7 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_thread_routine = qemu_nvmm_cpu_thread_fn;
     ops->kick_vcpu_thread = nvmm_kick_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = nvmm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = nvmm_cpu_synchronize_post_init;
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 8cbc6f4e2d8..fbffd952ac4 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -80,6 +80,7 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->cpu_thread_routine = whpx_cpu_thread_fn;
     ops->kick_vcpu_thread = whpx_kick_vcpu_thread;
     ops->cpu_thread_is_idle = whpx_vcpu_thread_is_idle;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = whpx_cpu_synchronize_post_reset;
     ops->synchronize_post_init = whpx_cpu_synchronize_post_init;
-- 
2.49.0


