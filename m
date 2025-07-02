Return-Path: <kvm+bounces-51339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61EF3AF6239
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0887B4A63BF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 19:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A6B2BE654;
	Wed,  2 Jul 2025 19:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D6FtEC9I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B1C2BE65D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482824; cv=none; b=FJYfx3cDvEP0YezPlUVhBLJUHDo8Nu4zRQHHZw4xKJfBV2Bm7wgAfWxphkFtT1/sT/g0KVjmVolxk+N8vuLio1+m+JuJ/YbkmbEuML3xTNkMUwlCOya3MZbFyRmua7rfeP9XnqIFPpXsej+PeKYdgVmr+ctTb3PCh56/c+EcN+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482824; c=relaxed/simple;
	bh=I3FUaEQVUvsUaEf9lozQ2QFIVcbb+jXlM9CrywHH2eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIEywB/BcYczEplOSuBCRZ9ryQZhFc0O26FWq1m8FfYBbX8IL/7nx/Xrxs5EhkKFuK7dTOpsZmBbnD1oK5IYvpeIu7wuRRAysqypmLIk35HQGl7YrdLybjh+unV45/e7LyWGevqOWkpqUt09YubcNNQkZZzD7Si29m1PsiuSpr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D6FtEC9I; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a536ecbf6fso4245935f8f.2
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 12:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482821; x=1752087621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tpiuwut0yPfLD1eGlX+EYtVIl2/TnFL9WqDtVZoJUMA=;
        b=D6FtEC9IRBPoBZg2/NP900/oc/nitNgUBOb3UCNckdRqjnV/rFX1zRD8Kw/8TmFGh8
         0Gbf6Zy08f/+QRr+QhTGyRPyEoVyKWgD3kXYOrKG7yowaWvPoRb/zmqiRJ9QBle3UPbB
         4bKh1NReFnUBu0c8X/l03Ca/EGmcPV6PJ5aF/NEJaAvNdKO5fzc8CFbLvwW/3yEv9147
         rDyTDOgzgpd7RxM4dCx/pZrxa8j42TKNGo2lw0L56T83npbwvGp2Bm5BBH7KENShuVGO
         FF/NEbzuPo523L+FMYtMsOKgIfyvyofxf8M2Z1SM+TCsXDPQcOvhPany6NsuiH9baI8J
         XFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482821; x=1752087621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tpiuwut0yPfLD1eGlX+EYtVIl2/TnFL9WqDtVZoJUMA=;
        b=S2qbBVu+8tpa9V7wxnn3ZeUm5BuTGAsa2xAInNo+5Hk6TykhnXSStG9Uu5BhyX+Yff
         7RT8BDAc69KZhVVDpyMtjoVBoUQgzS72L9voX6wGIZ03xF0X2msO7v3k/Y3kRoSg2kSO
         DDXBOL7d7qzLYz3s03KKsZ+TM1aWE8a8XyYGfzKvcmUZUi9A9J4AtlXEG2NjsEAhDdM7
         BqB+yWmtvtKya2NhRcuzYNUbTGgQu4HxmkCQIKMFArszBKBI9A+XoV8CekfSIAJDLpZ0
         z0XP7zif3uArXpQLJVoBUs1Ozs+BqoiovWnvGXRJhToVfp6HVGeZxRn34qa+/SMVQ6G7
         IMbg==
X-Forwarded-Encrypted: i=1; AJvYcCVUpvn8NLyAy1Z3bTtIP6b00EAcsMeAfW8IjsdBYfJSIKphraVb1YLakNDKnvy1eQwjpks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj1V4CzD2xWJ8I5GpJ0xrZwhKQGtXWQ806uz6ogrgSaGE+D5A0
	SSeDp69U8J9de/1CxQtKk19t0+jPCyX0m4QjgkVpZ9+L7kJ8CGwGfPGkX2h5Y1UQTQ4=
X-Gm-Gg: ASbGncsX1STuHBU+kwPib9GDpvzTEOpXo2EBitE5rl9Dhybwz+EeDVYfG38vfYpWGch
	yRBC3D9a6KSHBvvgOy9uN5DB6qE4EctFC8PkmiDMiKOofec6LsDI8DhUmRGBTG2wcJbUjh10nx7
	gep0jxGtosZ8CJTo7cG1IEe87VE5Y+CnKw+sIY4vva46Mm6eUO/IBZw5sQsz4HxbnFrQgSErK1g
	0LNCWoiK+3A74TYfgMrid7U6sOYEOaOwvmeGKoKbyMb23gwphPzaIPgBkcsEGLe385eyECgGdVz
	v7N/xYjIKQtXwUE2rGDsZ+IAEeIggFpXgF854E3+jMq1FfJS3Gnkk6rcIjh2NjAFVMSZ4hrXMDm
	jwi5Ct56UwHZ/eMEOWs0Vw48MZ0GXzl3BPNPB
X-Google-Smtp-Source: AGHT+IF4lYebmXSJDkkpbBSrLVcnunRXwUEzJB3h3bw75jfnHK3g6xjQIPKWwyLiIUvuXZNP2uw57w==
X-Received: by 2002:a05:6000:1886:b0:3a5:8600:7cff with SMTP id ffacd0b85a97d-3b1fd74c4b7mr3684763f8f.1.1751482820568;
        Wed, 02 Jul 2025 12:00:20 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e61f48sm16952111f8f.93.2025.07.02.12.00.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 12:00:19 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v4 59/65] accel: Always register AccelOpsClass::get_virtual_clock() handler
Date: Wed,  2 Jul 2025 20:53:21 +0200
Message-ID: <20250702185332.43650-60-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to dispatch over AccelOpsClass::get_virtual_clock(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::get_virtual_clock() mandatory.
Register the default cpus_kick_thread() for each accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/accel-ops.h        | 2 ++
 accel/hvf/hvf-accel-ops.c         | 1 +
 accel/kvm/kvm-accel-ops.c         | 1 +
 accel/tcg/tcg-accel-ops.c         | 2 ++
 accel/xen/xen-all.c               | 1 +
 system/cpus.c                     | 7 ++++---
 target/i386/nvmm/nvmm-accel-ops.c | 1 +
 target/i386/whpx/whpx-accel-ops.c | 1 +
 8 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 8683cd37716..d5154acc75a 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -82,6 +82,8 @@ struct AccelOpsClass {
      * fetch time. The set function is needed if the accelerator wants
      * to track the changes to time as the timer is warped through
      * various timer events.
+     *
+     * get_virtual_clock() is mandatory.
      */
     int64_t (*get_virtual_clock)(void);
     void (*set_virtual_clock)(int64_t time);
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 17776e700eb..cf623a1ea47 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -369,6 +369,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->update_guest_debug = hvf_update_guest_debug;
 
     ops->get_elapsed_ticks = cpu_get_ticks;
+    ops->get_virtual_clock = cpu_get_clock;
     ops->get_vcpu_stats = hvf_get_vcpu_stats;
 };
 
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index f27228d4cd9..dde498e0626 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -97,6 +97,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 #endif
 
     ops->get_elapsed_ticks = cpu_get_ticks;
+    ops->get_virtual_clock = cpu_get_clock;
 }
 
 static const TypeInfo kvm_accel_ops_type = {
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index f22f5d73abe..780e9debbc4 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -207,6 +207,7 @@ static void tcg_accel_ops_init(AccelClass *ac)
         ops->kick_vcpu_thread = mttcg_kick_vcpu_thread;
         ops->handle_interrupt = tcg_handle_interrupt;
         ops->get_elapsed_ticks = cpu_get_ticks;
+        ops->get_virtual_clock = cpu_get_clock;
     } else {
         ops->create_vcpu_thread = rr_start_vcpu_thread;
         ops->kick_vcpu_thread = rr_kick_vcpu_thread;
@@ -217,6 +218,7 @@ static void tcg_accel_ops_init(AccelClass *ac)
             ops->get_elapsed_ticks = icount_get;
         } else {
             ops->handle_interrupt = tcg_handle_interrupt;
+            ops->get_virtual_clock = cpu_get_clock;
             ops->get_elapsed_ticks = cpu_get_ticks;
         }
     }
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index 48d458bc4c7..85fb9d1606c 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -158,6 +158,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->kick_vcpu_thread = cpus_kick_thread;
     ops->handle_interrupt = generic_handle_interrupt;
     ops->get_elapsed_ticks = cpu_get_ticks;
+    ops->get_virtual_clock = cpu_get_clock;
 }
 
 static const TypeInfo xen_accel_ops_type = {
diff --git a/system/cpus.c b/system/cpus.c
index d32b89ecf7b..6c99756346a 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -216,10 +216,10 @@ int64_t cpus_get_virtual_clock(void)
      *
      * XXX
      */
-    if (cpus_accel && cpus_accel->get_virtual_clock) {
-        return cpus_accel->get_virtual_clock();
+    if (!cpus_accel) {
+        return cpu_get_clock();
     }
-    return cpu_get_clock();
+    return cpus_accel->get_virtual_clock();
 }
 
 /*
@@ -666,6 +666,7 @@ void cpus_register_accel(const AccelOpsClass *ops)
     assert(ops->kick_vcpu_thread);
     assert(ops->handle_interrupt);
     assert(ops->get_elapsed_ticks);
+    assert(ops->get_virtual_clock);
     cpus_accel = ops;
 }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index 4deff57471c..a2e84cb087a 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -86,6 +86,7 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_pre_loadvm = nvmm_cpu_synchronize_pre_loadvm;
 
     ops->get_elapsed_ticks = cpu_get_ticks;
+    ops->get_virtual_clock = cpu_get_clock;
 }
 
 static const TypeInfo nvmm_accel_ops_type = {
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index f47033a502c..d27e89dd9c5 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -89,6 +89,7 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, const void *data)
     ops->synchronize_pre_loadvm = whpx_cpu_synchronize_pre_loadvm;
 
     ops->get_elapsed_ticks = cpu_get_ticks;
+    ops->get_virtual_clock = cpu_get_clock;
 }
 
 static const TypeInfo whpx_accel_ops_type = {
-- 
2.49.0


