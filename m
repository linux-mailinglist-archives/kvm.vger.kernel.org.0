Return-Path: <kvm+bounces-51465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F332AF7166
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:02:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E944A1C822B8
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297E62E3AE2;
	Thu,  3 Jul 2025 11:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I0pAmuMM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E52222D78F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540474; cv=none; b=INBq1VeqT3rXP4RAFlvU6ZFilJ3upiD4GCMVd2ZVGz41EOCkfn77GrWugjpQDzvyPpZLnCbbTjzqwcQ96kclWTJtjrURBxHTQ9+fIu6dhjAQkWSUL2+GVJE+kFHL/DjtBY4RMvn0S6H97aiiLbzNy9VZeJSjrO5QH9zdPYVL9b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540474; c=relaxed/simple;
	bh=6Wf5FX+dz8XlDBijgwSIV2y7ZW1pAihEFaPp1iGelRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9dWTs6JBWrx2/9ZZ3+HmWN07UAj3h4ycUt7ODbV+ZT/z8tQoFfXtQHPOSOYZllIR6oD4akH4NcVpQafsn6sHFZQ6sXTYMuPogC35BHDafWBFui3kApuhrbKeS1MlUwNSFQJUY6p86T1IyKVtY4M6I/Le5+V7CaPP6HYphYYEdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I0pAmuMM; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4531e146a24so46635225e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540471; x=1752145271; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jox9I/hc4IW12DCVXl2QtoaQase5UN3XaHbWxSzsiYo=;
        b=I0pAmuMMVRkQuJVjj/kVJPE1CBkt2RSEdarE41XGHEAgt7+rr1r9ri4goY4syPof+B
         gGNTrsU4TfEkCfTzpVE/NMPVDRdhJ6hnVGfgHySQ8shaGrzOJTwt4ZrRlA9vVWZ8HwlT
         /zMpW6UkjGZ0fOcGckcGfQFvKlb0iHGk5bAE6rZ/lbCMdnf3O9aoGNxMvnrsk+sRkTxg
         PJfkbjT8JODnOE9gZ3/xfSVQCEPLaMN5HIhOxrgJzWM1IltbBxM/8nyV6eyawK+1rRqR
         gYHRaMji60/BQZw5cY/owVTqqmzFAC+GNvoTrm3puGyDrXTcJBleifioNBtV0ITThZMI
         z+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540471; x=1752145271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jox9I/hc4IW12DCVXl2QtoaQase5UN3XaHbWxSzsiYo=;
        b=KhrbcRKpZHOWrYrDKWxKVr+UdFZeKnx2fBZ6x2HDwzMrqtL4T2xm+F5p0fhmNyqg/A
         W0oDpYbq1jgFdEKiy6XxTiCN/wUrRSUaBHu2NR6czMJu79FAysU59ucslmeyI/0mrz7A
         5+dmaxGCd3bmmSk74353yu2MKQBEnujJxLpnbxT98DiVe/2MGHaHe1yXCC53q+CPR2hh
         jwggxYDfo8IYQjjBOrsPaGpZbEC1O6hjkD2clCZdRmiTULlE9sMYh94XOMHq/qVfIVAj
         kb2khkfFtcM1czuqkS78KFbCHgkjLptM0GrEAy0iEB1DNxjuHz5QSlM6jMXXIMgDAhuc
         lV7w==
X-Forwarded-Encrypted: i=1; AJvYcCWY2bIPVh2zt0IDYPPgoGvdPTglSAIHGR3MxnJJI86AydqSSltPivUe7UCRgS12MLOjk0c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzWPA1B1kkEC8inJN0SyvLnV7VcymImTzbUY0KAEOFNJJM09yA
	r4GRvM9Qi8qWaO/OuQU/nq5CEbynqvt8FNLW212C9uNqmAkqVziI8cmfVK+M8b03vkyDQLbDu6O
	rVH35Goc=
X-Gm-Gg: ASbGnctZ/RKbppu17fKp/md58zt46HAfWiGkYGiXaqBvDUmpy1uxfLu9z5BRa1NHeho
	ntQ7GpspNxGTEWtOtT/thXLJi9sbocJW3l2DxsoM6VW3bpeXBwfTaul28k5sP9iYHzS3k+dz+gd
	fL3QbCC7YU8jD0Uvu17DF5QCl1NCv9PTgT7pPVNKsODHAJii7IbSUIrJ35K21zOptTqQOclgQE3
	8tKLOh5sn4hU9QPic++fMWRYeVrfwqfasCI/ICWEqZlBPxpb6zdjZ5hD74Sl3xh/1z6HlErwt6E
	EurUFJgIqc5eENmpjcW40E1E4dPyjXb1sPo0TvJk51ADrs6mIw3fn+mY3j5tnQXBvV7AIvpkd00
	Dw9d7nSJHVuI=
X-Google-Smtp-Source: AGHT+IHAtbR+hufxeMURDPAweaVvkz8bA98tXT/yfuO0i+zP0XtJFFoPdGy8SpZsMLysHsZr5JSWzg==
X-Received: by 2002:a05:600c:8b43:b0:453:6424:48a2 with SMTP id 5b1f17b1804b1-454a3d23106mr69823115e9.10.1751540469774;
        Thu, 03 Jul 2025 04:01:09 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997e24bsm23541895e9.16.2025.07.03.04.01.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:09 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 62/69] accel: Always register AccelOpsClass::kick_vcpu_thread() handler
Date: Thu,  3 Jul 2025 12:55:28 +0200
Message-ID: <20250703105540.67664-63-philmd@linaro.org>
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

In order to dispatch over AccelOpsClass::kick_vcpu_thread(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::kick_vcpu_thread() mandatory.
Register the default cpus_kick_thread() for each accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/system/accel-ops.h | 1 +
 accel/kvm/kvm-accel-ops.c  | 1 +
 accel/qtest/qtest.c        | 1 +
 accel/xen/xen-all.c        | 1 +
 system/cpus.c              | 7 ++-----
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index dc8df9ba7dd..e1e6985a27c 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -43,6 +43,7 @@ struct AccelOpsClass {
     void *(*cpu_thread_routine)(void *);
     void (*thread_precreate)(CPUState *cpu);
     void (*create_vcpu_thread)(CPUState *cpu);
+    /* kick_vcpu_thread is mandatory. */
     void (*kick_vcpu_thread)(CPUState *cpu);
     bool (*cpu_thread_is_idle)(CPUState *cpu);
 
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index b79c04b6267..a4bcaa87c8d 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -81,6 +81,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_thread_routine = kvm_vcpu_thread_fn;
     ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
+    ops->kick_vcpu_thread = cpus_kick_thread;
     ops->synchronize_post_reset = kvm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 47fa9e38ce3..8e2379d6e37 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -66,6 +66,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
+    ops->kick_vcpu_thread = cpus_kick_thread;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
     ops->handle_interrupt = generic_handle_interrupt;
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index a51f4c5b2ad..18ae0d82db5 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -154,6 +154,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->thread_precreate = dummy_thread_precreate;
     ops->cpu_thread_routine = dummy_cpu_thread_routine;
+    ops->kick_vcpu_thread = cpus_kick_thread;
     ops->handle_interrupt = generic_handle_interrupt;
 }
 
diff --git a/system/cpus.c b/system/cpus.c
index efe1a5e211b..6c64ffccbb3 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -486,11 +486,7 @@ void cpus_kick_thread(CPUState *cpu)
 void qemu_cpu_kick(CPUState *cpu)
 {
     qemu_cond_broadcast(cpu->halt_cond);
-    if (cpus_accel->kick_vcpu_thread) {
-        cpus_accel->kick_vcpu_thread(cpu);
-    } else { /* default */
-        cpus_kick_thread(cpu);
-    }
+    cpus_accel->kick_vcpu_thread(cpu);
 }
 
 void qemu_cpu_kick_self(void)
@@ -670,6 +666,7 @@ void cpus_register_accel(const AccelOpsClass *ops)
 {
     assert(ops != NULL);
     assert(ops->create_vcpu_thread || ops->cpu_thread_routine);
+    assert(ops->kick_vcpu_thread);
     assert(ops->handle_interrupt);
     cpus_accel = ops;
 }
-- 
2.49.0


