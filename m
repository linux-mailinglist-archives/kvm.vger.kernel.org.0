Return-Path: <kvm+bounces-51467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90761AF716A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5965E188D99F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E1A2E426A;
	Thu,  3 Jul 2025 11:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mYYT2aRd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ED12E3B09
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540485; cv=none; b=ffF8liRDkmwYIe6qffsgKIO4VsViC5YDJHgEeBms3htoGQ+RpNumJw22PKi8s6EPV6EFCMexpVF3nfnPT4OY1t3KMQUpk9O5DF0xJyWI1KvajFdfvI/ZcFVUm1fxzdmH5ED+xA7feuzWa3YAdv+kzTGpZOXjlK2TOLrKbh6m8fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540485; c=relaxed/simple;
	bh=J8AVwd1nYli3gYi5Ujw0e4ywVZrwVWrabJwo9Kgfvw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRJ78EmxX5R6l97Pb9lwQO8dCRfO9SMh8Qrz1uvSVV0Wui0kEezTZelldmhtAX7D049l/m0a7Y02ec1tr8GL2Rgr1Y7Bvq366viTMYlsdOcA4eST77UsA9nVZ7rqrgXOmSeetLByI536CRAb38LEE+jFKu0lDOagFkx5S+4hXJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mYYT2aRd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45348bff79fso55595395e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540482; x=1752145282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzJU9cMvdw7qI1DsUYXk4sIGt7aNTKeIdxs9XPIRBAs=;
        b=mYYT2aRdggwIK98uOu3eIfOAc/ZhyKPeiLI30WEfJ5YcqnYYBFjuAV1CZZ1D4KyEKO
         P4E/3eeUpnmO/DkZomuEae5UNz0wGq+5XVvUsg0DNh1YBjd5SCYHKaqTX3oSlZYhAmZK
         v3m30dpJaNE37Aa8omcowPffaCpb3rSYFacOil3JHLlHRg3sLhSVdc9LRVb17wV01O3Y
         C5GySru4O37DD/bXIiJjaRY1JU+sdTl7OQwR/PzK4BHKzXJxfHw3xuxnj5SzAM+OVsO6
         +puDGizXEWMjxonF4KH8stsa6SASTGe8ITT/efHr+b1bQBLr7furEJEfa/3vHqgY5iUO
         sMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540482; x=1752145282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzJU9cMvdw7qI1DsUYXk4sIGt7aNTKeIdxs9XPIRBAs=;
        b=nkHLg1IrYIMS3u7hcOoDhSx/K8tBNcOuubHPbwOVeXyiWMfZa4eoqglwbPKe1oU/3Q
         iCxqI+n2X0Km6b/bllxrJ8k0Q0n66gYhVIcgTG6wGFia4se34x6iefYtEf0BKk6Fzpnb
         NS4/BmRzL6T/McAAleax9e7ndvBRekNw3zaQ/6LRxTZCaaWT9dx33HgxvpK6nr1YIFoo
         2aYueuX25Tv0TPhTD+2XTDEbIL1YnSPkyrNA3tpW/8NGcZjp0LXy3PVutMyncI6QvPqw
         wySDKMJiStbP5BOnlTdDD93FA5BmK733nb6Oo0gjokLbJAslMJKQpzz14dPt15QTO34q
         9StA==
X-Forwarded-Encrypted: i=1; AJvYcCW9lt1inIFqUXHF/Vv7SlecDFimsVeRNGU3vT1ePXONVSD4PwSmNyPbMH0wcgi00PwmkS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI3bqdFArB0fOUDYr1RqEvk6xFDX9MscQaUksxXJmoVy8R6ipU
	Drq66uVIpXmpn35GbvcAHf6iZ3VFvjl6bGGWHhDyd0uwPI5cKo0hZKSavNgRCFrJvpo=
X-Gm-Gg: ASbGncvg0viKq+mRa8skearD+Uj9uWT159w5qfxruBgUbwrLrMfvLva48qWRHLQ4c87
	jzD96vswfDRGfpRU/EIsWGxxVQeHylz2gZT55Vdx5GuTouUwEnBWaqxoYtZ37NXfrUgKtOf6Nj/
	bM9A3URV2Evv2W0D3n+t+HDLNa/7kW+pNQ1lCiPX1qj/1DjGNhYjwk1l+AEBeHXXRtYBu68Mhl6
	cvDD+aZL8bNGHFYAcsogEHb74se2xcrs2aHF9KbtVkJQbKN89D3j6LVRoan6ylDJKRQFkNPn5jH
	FHI7qeKxo0Cw3IMb3YZuPmt4DaGcYdj2LpbDGGp6TGY3fF7R7GFtFhzhZ4mH4QNHb/UCEbBPawp
	nzviTy2u5UdU=
X-Google-Smtp-Source: AGHT+IE9gr9T60NDzRkUuqivylovRxkkmt/fAWeG25n0gokPfhcpDnEXTvr0sTrW5HUyGajZcY1CBA==
X-Received: by 2002:a05:600c:4f84:b0:450:d37c:9fc8 with SMTP id 5b1f17b1804b1-454a3e1a96amr69146295e9.13.1751540481514;
        Thu, 03 Jul 2025 04:01:21 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e72c1sm18152198f8f.1.2025.07.03.04.01.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:21 -0700 (PDT)
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
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 64/69] accel: Always register AccelOpsClass::get_virtual_clock() handler
Date: Thu,  3 Jul 2025 12:55:30 +0200
Message-ID: <20250703105540.67664-65-philmd@linaro.org>
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

In order to dispatch over AccelOpsClass::get_virtual_clock(),
we need it always defined, not calling a hidden handler under
the hood. Make AccelOpsClass::get_virtual_clock() mandatory.
Register the default cpu_get_clock() for each accelerator.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
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


