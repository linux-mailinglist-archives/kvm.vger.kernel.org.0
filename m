Return-Path: <kvm+bounces-51516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BA6AF7EFE
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC9FF5644B7
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93302BEC5C;
	Thu,  3 Jul 2025 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nx8Pfrdf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E6B2F198F
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564139; cv=none; b=IQ/zoW/Z4m0u3owtrGmE2V8MCgVYOVLHJNBfk87o8NOfcQrDTFN5tCr4db9Dj19Fg6IUOk7eZd5Cxy2GKX/vNdVutaklqnKyJzU4q7VeEKteLOgM2Efv3hdkjrb6l89i9BQgkqUPTSCmcJdUwq3unCSQXukGfSdyr+Tm96ZAapU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564139; c=relaxed/simple;
	bh=fnS20vRS5GpMEJ8qI2QGLeRkeeGeaZAMUMQuvLVJLLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XzJ0FaKt7JJBCuzjpwZKsomnv1K/qN9cqERwU8gPd4N5rTLShxsIqkeUDB6Cf/XBc+I2UYreGZErTRgyN5kmFMLcYc+mT5mWWwGbSl7pCP4PXZUArmne42Or2Pv0/+5MjZ0r4Ru7/sLtzDuyc7umLS+SK613o/Lbu3io/Ih0juM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Nx8Pfrdf; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3ab112dea41so32921f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564135; x=1752168935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3486zTUHknyNnHUemYDF582+L164Ncw9awD18XnK3g=;
        b=Nx8PfrdfLXBCLWcaYW6FpmvBe/5PLul3TiJbSLdoNMLDfUys0wEagsXVbmBOIKLpqL
         SxY8X9ajkPloC936+RcDPnVLdiz7PJvinoNfVwH7JJ803puq50M5VHYMJ2c+b/wFlrgr
         eF7xhrF5qMAtEMYFg41wm/3jLtlHDA0X6cUchaGXWxyHKrM3Ib/is63H1cDwZTxvQ3K+
         xvfelt5Ku+/643k2tu06pc6lpv6Mob/GubriSCBDQRx7ml7xNWblUa8kXkta03iF9w70
         stiXZ5JS99tixrbdcMvf2G/qLajk7mt7Mkxm5vImQQ/f2IYM5MCcwL5QrQEhyHlxAQVC
         N1Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564135; x=1752168935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w3486zTUHknyNnHUemYDF582+L164Ncw9awD18XnK3g=;
        b=K9VT2fvhngLlOMb6uaWiTUrotsYFjyUEiBgOcIiJNM8GtLQjDUZuDJSDcET7/CcZOm
         NCXVOnWPLbfHGnXUNNBXiQZ6t6V8Y10VOY2FmlC40zDwuFNdki6YTAr0qFedzHljBJnE
         T4FnvaA6UoUSDcdQOy/srncrgJL4iyDh9aVdVDeOsYy0za5qK8Y+4jHahrzM7/suMEsp
         aO/q81iX5uUCrkCaKuR28zBeRa2kTNab88/rSHHGzq012mds2yqyW6sEO5CisvSiXtis
         1aPaDLNfxG6nrSOfRL5g+fvKffhFewOMCjAojpRMQrLpL6IEQqXG93xJzlhU3geh57au
         2g2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVTkxDCdnRGaSEuwmEhW/ID6z1cZkbVaINi6rLcgsBWU/BQsKsPOnGvEitachLeoAIwD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmxlhprRCtjXrntjnksrjPZ3Xlhb2UWLaBNJDfq332IXKmHfyC
	v2JZQvUAjpJzY4dmCaeCxqhekzYLygaTItRRbPbf1qL7N5KGXIQUnAdzVAKmYaKjYIs=
X-Gm-Gg: ASbGncuPPpgCCnbCgWhSCgCUN8wNqjtihuzAAvSEbUTVVBW6IVD5ClKwY7jIE27Ztxf
	rKq6lV3IWOA5b0C3gFxfi7TTQLOXlZltd80H1EVX1nUxaIxu8QvE+schK5NtCtG/U78WY/qN6w6
	4CRiHgD1816ZDb4KgFavm13YLrL2nrvOn/Kz6mirjwQPXQi6b0RCrMg6+NS7ZV+FbRWpfJp4Zuo
	mruGMcA7TOiFkfrBJLT3YJtDonW77+ev3dVYFUnYVm2DC+aBTOZGR9KYDcWYoya6Zw8IRyKV9fv
	5cisucSn+yL38kaog1ATA+OQNYq/Z0z4YgTFonT002HP3fxFlM1D9+1E1xraA7zku6C4P9EpEzO
	FlU65Uxjui2/xKgNbjwm/cWZXbdRvNWh5RJYI
X-Google-Smtp-Source: AGHT+IFkhhlZSbMvBFh6UdUhOeDV184atk4sneL/YpRsGW7A5ClqyXIooVwAUEBKx8X5RV+czV8IYw==
X-Received: by 2002:a05:6000:220f:b0:3a8:2f65:373f with SMTP id ffacd0b85a97d-3b32cb36152mr3879437f8f.16.1751564135278;
        Thu, 03 Jul 2025 10:35:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b471b97382sm320521f8f.56.2025.07.03.10.35.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:35:34 -0700 (PDT)
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
	Warner Losh <imp@bsdimp.com>,
	Kyle Evans <kevans@freebsd.org>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v6 30/39] accel: Propagate AccelState to AccelClass::init_machine()
Date: Thu,  3 Jul 2025 19:32:36 +0200
Message-ID: <20250703173248.44995-31-philmd@linaro.org>
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

In order to avoid init_machine() to call current_accel(),
pass AccelState along.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/qemu/accel.h        | 2 +-
 accel/accel-system.c        | 2 +-
 accel/hvf/hvf-all.c         | 2 +-
 accel/kvm/kvm-all.c         | 2 +-
 accel/qtest/qtest.c         | 2 +-
 accel/tcg/tcg-all.c         | 2 +-
 accel/xen/xen-all.c         | 2 +-
 bsd-user/main.c             | 2 +-
 linux-user/main.c           | 2 +-
 target/i386/nvmm/nvmm-all.c | 2 +-
 target/i386/whpx/whpx-all.c | 2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 197badcb705..b040fa104b6 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -40,7 +40,7 @@ typedef struct AccelClass {
     /* Cached by accel_init_ops_interfaces() when created */
     AccelOpsClass *ops;
 
-    int (*init_machine)(MachineState *ms);
+    int (*init_machine)(AccelState *as, MachineState *ms);
     bool (*cpu_common_realize)(CPUState *cpu, Error **errp);
     void (*cpu_common_unrealize)(CPUState *cpu);
 
diff --git a/accel/accel-system.c b/accel/accel-system.c
index b5b368c6a9c..fb8abe38594 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -37,7 +37,7 @@ int accel_init_machine(AccelState *accel, MachineState *ms)
     int ret;
     ms->accelerator = accel;
     *(acc->allowed) = true;
-    ret = acc->init_machine(ms);
+    ret = acc->init_machine(accel, ms);
     if (ret < 0) {
         ms->accelerator = NULL;
         *(acc->allowed) = false;
diff --git a/accel/hvf/hvf-all.c b/accel/hvf/hvf-all.c
index 897a02eebe2..2cf2b18fd23 100644
--- a/accel/hvf/hvf-all.c
+++ b/accel/hvf/hvf-all.c
@@ -247,7 +247,7 @@ static MemoryListener hvf_memory_listener = {
     .log_sync = hvf_log_sync,
 };
 
-static int hvf_accel_init(MachineState *ms)
+static int hvf_accel_init(AccelState *as, MachineState *ms)
 {
     int x;
     hv_return_t ret;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 88fb6d36941..1b6b7006470 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2573,7 +2573,7 @@ static int kvm_setup_dirty_ring(KVMState *s)
     return 0;
 }
 
-static int kvm_init(MachineState *ms)
+static int kvm_init(AccelState *as, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
     static const char upgrade_note[] =
diff --git a/accel/qtest/qtest.c b/accel/qtest/qtest.c
index 5474ce73135..2b831260201 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -38,7 +38,7 @@ static void qtest_set_virtual_clock(int64_t count)
     qatomic_set_i64(&qtest_clock_counter, count);
 }
 
-static int qtest_init_accel(MachineState *ms)
+static int qtest_init_accel(AccelState *as, MachineState *ms)
 {
     return 0;
 }
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 0cff0f8a0f9..7ae7d552d9e 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -80,7 +80,7 @@ static void tcg_accel_instance_init(Object *obj)
 
 bool one_insn_per_tb;
 
-static int tcg_init_machine(MachineState *ms)
+static int tcg_init_machine(AccelState *as, MachineState *ms)
 {
     TCGState *s = TCG_STATE(current_accel());
     unsigned max_threads = 1;
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index c12c22de785..8279746f115 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -77,7 +77,7 @@ static void xen_setup_post(MachineState *ms, AccelState *accel)
     }
 }
 
-static int xen_init(MachineState *ms)
+static int xen_init(AccelState *as, MachineState *ms)
 {
     MachineClass *mc = MACHINE_GET_CLASS(ms);
 
diff --git a/bsd-user/main.c b/bsd-user/main.c
index 7c0a059c3ba..d0cc8e0088f 100644
--- a/bsd-user/main.c
+++ b/bsd-user/main.c
@@ -474,7 +474,7 @@ int main(int argc, char **argv)
                                  opt_one_insn_per_tb, &error_abort);
         object_property_set_int(OBJECT(accel), "tb-size",
                                 opt_tb_size, &error_abort);
-        ac->init_machine(NULL);
+        ac->init_machine(accel, NULL);
     }
 
     /*
diff --git a/linux-user/main.c b/linux-user/main.c
index 5ac5b55dc65..a9142ee7268 100644
--- a/linux-user/main.c
+++ b/linux-user/main.c
@@ -820,7 +820,7 @@ int main(int argc, char **argv, char **envp)
                                  opt_one_insn_per_tb, &error_abort);
         object_property_set_int(OBJECT(accel), "tb-size",
                                 opt_tb_size, &error_abort);
-        ac->init_machine(NULL);
+        ac->init_machine(accel, NULL);
     }
 
     /*
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index 2df49d7eeb4..b4a4d50e860 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -1152,7 +1152,7 @@ static struct RAMBlockNotifier nvmm_ram_notifier = {
 /* -------------------------------------------------------------------------- */
 
 static int
-nvmm_accel_init(MachineState *ms)
+nvmm_accel_init(AccelState *as, MachineState *ms)
 {
     int ret, err;
 
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index 94fd5fc7849..721c4782b9c 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2504,7 +2504,7 @@ static void whpx_set_kernel_irqchip(Object *obj, Visitor *v,
  * Partition support
  */
 
-static int whpx_accel_init(MachineState *ms)
+static int whpx_accel_init(AccelState *as, MachineState *ms)
 {
     struct whpx_state *whpx;
     int ret;
-- 
2.49.0


