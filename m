Return-Path: <kvm+bounces-51515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 880DBAF7EFC
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F79F4E4169
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5892EF9AA;
	Thu,  3 Jul 2025 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oq58TtQo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB9FBF6
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564124; cv=none; b=qthoXKl8XXNNDCJlrwV8s8H8vHMHM3xqZ9S99Nwot9nYwmWduGkS0XvTBOXC+klWoJVXoe0i9sLnfiueV0TLRuMYr1uyQ0acX4TPjZ7smnoWleH3CowjOiUEUBKNrGST11aYWXYdtWUKQTrT/rxnlKcOZWsj0BfuL7tcrhHtusA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564124; c=relaxed/simple;
	bh=xe8IWt4dnXj1kemYK8kMp1Q1zItUCJLlW1muC8km7dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u0P2okcgWEosad45Bw3wh1IQgdvRRU0Ydg3qoS1Jr1RZsKolLnWxWN9RU6duHEtUIDLX0P8rkJXsXXDHk8XGuRN+aHkj/zEXwnIUiamvKeB3j2186FTspogpL+k+tbon47Xv4iq832wSxmskPDwrN4ZDv5mp6mGaVtB5/H/ak+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Oq58TtQo; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so1387405e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564121; x=1752168921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8Y0CRVizP1zJqDvu7p6UAH96w8jBU8Dg5EX+XjEepo=;
        b=Oq58TtQoZQxQuo68+NkXZLGJTmZmyf5RzFP6viX8lKAUSBpt/m2OhvWI48GMQGXA6U
         VyYaK+zvZ7lnmnzbSufBCoZ/CDk1MrIYrqYQMF/l/cuM7lVz0erUpjfTdalBQ6P1jHiS
         cH4O7cv+qt6gXVMk1EOmrgBQVognxHr+V7EJ0EbRHXGx2M7kSa97frvrpszR1a2z+8tE
         1dhCuDhn0H3d0ItBprp1GrrERXCEeDaQ0/x/bzZhvm/X544kSmTVzwX3Zmw/eSpaMB8C
         tB6ddDCox0jlXbZseraXALFpfEJUg6PFHrBKjf9nA1E5J67O/RYM5P9wTkQUGh4OAb8A
         Zi9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564121; x=1752168921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8Y0CRVizP1zJqDvu7p6UAH96w8jBU8Dg5EX+XjEepo=;
        b=hS+6nTp8COmLnhoM0C61ykeY6GfLaQxTrl2qX4hj+ryCftXbD7jfWjK1HrtKxUE+Z+
         e7oXjhhgruOcCBPXe8w+Z4vq9koZIGMwDME++w+Up4699GsCtQEBwD4ncpYuAyrqiG0y
         6XkL2/0/RnaMuPWz6b4BjoU3uvnenmWj4ZrFVhv2T8s3plWoQll9eOl/zTN/I1dYis2L
         1c2b8DneXfH/dMelm6jluLZm/6ETuVGu6ypgHxhJck9Gz3rOBuZgNw1iiRO2wzHO1BFL
         ldz/3i/4OyQRCTe3Clz2SbR+cSpRyc7A2HJ8JtLfi1qM25GcHTgqScakEMAKFCMJav6S
         7UXg==
X-Forwarded-Encrypted: i=1; AJvYcCUwsa/CYX7khXuETZua52YDW7VIQaegIj7b0neUfIIorAGdRj4b6xXqrASH2rwrdy2G0iI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYn+K1O7kGIF+OHro70MxbMaVxJtS5SPp2nzfk1AtsxgGmdUdI
	nS9qF7bopp+HVxE4krWir0pJrv8bXXWsJM/fYOODMp/CEcyZkTMlzQuy2E2pcP8YABo=
X-Gm-Gg: ASbGncvgap8X/8C4tV40qSdLJXfIs6A92Fdm8AmTVssmMRu7pstGepopEA6uT0i8h5b
	x77VccQ72y6VTKKiyXnbZBnGoNu+bN9v6upD0jvtpG6BU6vaCDzX8rvK6JwowCziSyvZxQrxehE
	/hW8D9mdWTk1yKvotlTxg1hkvl/lDVzfJ0rz2zw5Wz4RzT4aH3EZnBfpOm3CYXRMRcQtbL46mZX
	MWuvdlnnBTcmzXSa4hOvovBOq4RQQIqkyCS3pD/qgHSun3iqUml0A9gcei/bqqn1Q880d0Kfl4u
	D/3M/nNkoL4Mdr1IIES/XUmHGI3vm1ZQZJBucoy2oRqhgMfM3BoEkrNJg5bdDCYWSBkLzlAuKja
	DwaUQhcND/DZtUJo47Ge2WX3FR5icVyNHTo/eEEBQaQQjDfg=
X-Google-Smtp-Source: AGHT+IGUIGmRkNOsoFJDwtp7VUBuEXsARIcb9sOIxx6CN5f0AbT6nqsmy0amztwXgQM0zaIcj6KsKw==
X-Received: by 2002:a05:600c:4509:b0:441:ac58:eb31 with SMTP id 5b1f17b1804b1-454a3705065mr72661285e9.20.1751564121250;
        Thu, 03 Jul 2025 10:35:21 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b161e8fcsm3703765e9.7.2025.07.03.10.35.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:35:20 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
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
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v6 28/39] accel: Expose and register generic_handle_interrupt()
Date: Thu,  3 Jul 2025 19:32:34 +0200
Message-ID: <20250703173248.44995-29-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703173248.44995-1-philmd@linaro.org>
References: <20250703173248.44995-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/accel-ops.h        |  3 +++
 accel/hvf/hvf-accel-ops.c         |  1 +
 accel/kvm/kvm-accel-ops.c         |  1 +
 accel/qtest/qtest.c               |  1 +
 accel/xen/xen-all.c               |  1 +
 system/cpus.c                     | 10 ++++------
 target/i386/nvmm/nvmm-accel-ops.c |  1 +
 target/i386/whpx/whpx-accel-ops.c |  1 +
 8 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index d84eaa376c2..95a0f402cde 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -61,6 +61,7 @@ struct AccelOpsClass {
     void (*synchronize_pre_loadvm)(CPUState *cpu);
     void (*synchronize_pre_resume)(bool step_pending);
 
+    /* handle_interrupt is mandatory. */
     void (*handle_interrupt)(CPUState *cpu, int old_mask, int new_mask);
 
     /**
@@ -84,4 +85,6 @@ struct AccelOpsClass {
     void (*remove_all_breakpoints)(CPUState *cpu);
 };
 
+void generic_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
+
 #endif /* ACCEL_OPS_H */
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 2944e350ca9..a0248942f3a 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -353,6 +353,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->create_vcpu_thread = hvf_start_vcpu_thread;
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = hvf_cpu_synchronize_post_reset;
     ops->synchronize_post_init = hvf_cpu_synchronize_post_init;
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 99f61044da5..2a744092749 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -95,6 +95,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
     ops->synchronize_pre_loadvm = kvm_cpu_synchronize_pre_loadvm;
+    ops->handle_interrupt = generic_handle_interrupt;
 
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
     ops->update_guest_debug = kvm_update_guest_debug_ops;
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 612cede160b..5474ce73135 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -67,6 +67,7 @@ static void qtest_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->create_vcpu_thread = dummy_start_vcpu_thread;
     ops->get_virtual_clock = qtest_get_virtual_clock;
     ops->set_virtual_clock = qtest_set_virtual_clock;
+    ops->handle_interrupt = generic_handle_interrupt;
 };
 
 static const TypeInfo qtest_accel_ops_type = {
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index c150dd43cab..c12c22de785 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -153,6 +153,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
     ops->create_vcpu_thread = dummy_start_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 }
 
 static const TypeInfo xen_accel_ops_type = {
diff --git a/system/cpus.c b/system/cpus.c
index 13535a74e6f..f90b8be9eee 100644
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
@@ -674,6 +670,8 @@ void cpus_register_accel(const AccelOpsClass *ops)
 {
     assert(ops != NULL);
     assert(ops->create_vcpu_thread != NULL); /* mandatory */
+    assert(ops->handle_interrupt);
+
     cpus_accel = ops;
 }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index 21443078b72..a5517b0abf3 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -87,6 +87,7 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->create_vcpu_thread = nvmm_start_vcpu_thread;
     ops->kick_vcpu_thread = nvmm_kick_vcpu_thread;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = nvmm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = nvmm_cpu_synchronize_post_init;
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index b8bebe403c9..31cf15f0045 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -90,6 +90,7 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->create_vcpu_thread = whpx_start_vcpu_thread;
     ops->kick_vcpu_thread = whpx_kick_vcpu_thread;
     ops->cpu_thread_is_idle = whpx_vcpu_thread_is_idle;
+    ops->handle_interrupt = generic_handle_interrupt;
 
     ops->synchronize_post_reset = whpx_cpu_synchronize_post_reset;
     ops->synchronize_post_init = whpx_cpu_synchronize_post_init;
-- 
2.49.0


