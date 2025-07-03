Return-Path: <kvm+bounces-51413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77C32AF7115
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BAD61C81234
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083602E266C;
	Thu,  3 Jul 2025 10:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cG4n5RVh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA152E2F12
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540199; cv=none; b=Ge7hRR6BgSC51WCWOBjtNYPlThx+/pxMjBi1ov25AHrRVi+JLko3sRx3XgYhveXcytMliv88JgPoq8Lxby6VYOmvKzmgoNkQ+p+sZm2VWbJ+5LGaqW9IH7IStqW7ojbJB5q/xPBLPT7hlrEY60MViJ5zOXl2mR7XguEotYtcuLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540199; c=relaxed/simple;
	bh=m6LFkGqCQRntqHDAsjsiXdgPZVQ+b51GcIz7wr7+ed8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJNW34HsbBYx0DErZTnBYCgNw+HKRs73ukucsKEc9rE1R1NksWInhkIqqoiy4H7i3j3+a+XSepoh0PjflnH2ixxpPsP2+DSKTPI94pRhrGByp8VyCRf2ELW2ZEuMZwetnqAcrvyvvwEm9GLq0NMlqIp7xN7Tknx5YO+mFI4dUgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cG4n5RVh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-453398e90e9so44617145e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540195; x=1752144995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pcxyecq1Uca5OV4SmO/+hJU9sxDq9D6xrBJnOg87yRs=;
        b=cG4n5RVhfjBINmUqBraT7dTCSEPYq//jeXHrWrTzUCnpEkHun1VqzdSREstcclOQn9
         QXK31OF6wCQyCWkuaexrRCOy/pSOfkM7IzRB2x9R76EwFWeZGg4PNCTHPaZ1DVZbMDiu
         jddlNFfgZ3P2ewEnJ3y2mFEMaFpPhAyPN3VilMtn+22aiSkbIODcy86Ordz2Ye9F1UzO
         S98GCunGEU9RF2vQW/ra4CJA0wm8Rcl6X82tU+wp23B1nOw5yFkvBY3ZW6kBGYwIZSRW
         oeYtCYKq3rN6CSoicfLOQlY/hHklSX/JYpHCw5z1M74TueSdGnQgJdnOr4WRAtu9juJc
         VOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540195; x=1752144995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pcxyecq1Uca5OV4SmO/+hJU9sxDq9D6xrBJnOg87yRs=;
        b=B+ZMGoFENCQg6M/cibplrbzUB/7Thsw7+EGRWU8mFtPR7wydeMZjtfgVtd0BgrSYz7
         T6wsCo3IJi1e62Hwx8VYHxYU3zrRjpQkPqYcqWBBj2V5ow+clPbIKTAgjaRFxbjSH7Zc
         txWdU1MQHvGfP3PJ3faCyknZM8opuNs81KEtFMWNzq1LT1MOdDvV5tOkD0nF1AnIKTxV
         ocmEFp6eBd2pWPY8/ieQsQmX9YBb3o1FceDU4D30iWbqy9Wxgc1zoUyg4ldZkbwLVA5W
         V/YnGVJVZDBXap8XCTDecbPpRfspA+LgF8GVFAjDN8SqOgadsCXdR4nxlh1mV6gFVznp
         96OQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2XJ54j6VSQ8mLXrz551D3IFLKArZqy4kYUEPMmxSvLGa933il75nsvNuIjN47FEX+/cs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1zDCVKq64aWbPyUvOT7cPwzC3XlQRShhn0tTSOOCeDaRGA5D1
	OiPgDmczpEZBimEEXxvHUIt1iMxnrP6As0ORGBXfoUwvEXLJ4OrVAaCR9JPdL3O6ViQ=
X-Gm-Gg: ASbGncv14HVuPeFU4zuavHrI0JZ6K3ZQos8ikNZ3Hwy8h3NIeRP6mqG/iEWVfdc6qZe
	0qNEXO5ux0IzAm9V/9PY8AMd+gz93QqhJ5ml4Tuuua5KTjMITWf87Q04cdMXzIqXrV9ep1++FrN
	JvpmMxZdfDS73wh4UHiYBHXONuvu0bxGql94ucFS5yBde6VrpLx0vma6J8erTXFHw14cuxH3mVR
	NeznU+ESrzs1QgruPQdJy7jy5OIURrFYi9F/u7mJMxC91SSrg60+CCKpo/wDtvDTImk2mobr6ZK
	ABY/NRMj65pt+6frBbEgSCI1k3sX0ctO0IfPtZ/fyGBsf6XjmGKn171RM7HqIHHVmQYvVdB6qe/
	jl+h94jyRWek=
X-Google-Smtp-Source: AGHT+IFMtoW6ZLHLTnNUUgjdqd0imX2oSHRMYLqbKiMG3n1p6ANBAFuifal1Ean/kUmUpIKdi4hCFg==
X-Received: by 2002:a05:600c:3b05:b0:43c:f6c6:578c with SMTP id 5b1f17b1804b1-454abd597f8mr25988155e9.15.1751540195258;
        Thu, 03 Jul 2025 03:56:35 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcef22sm23507545e9.19.2025.07.03.03.56.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:34 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
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
	xen-devel@lists.xenproject.org
Subject: [PATCH v5 10/69] accel: Propagate AccelState to AccelClass::init_machine()
Date: Thu,  3 Jul 2025 12:54:36 +0200
Message-ID: <20250703105540.67664-11-philmd@linaro.org>
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

In order to avoid init_machine() to call current_accel(),
pass AccelState along.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/qemu/accel.h        | 2 +-
 accel/accel-system.c        | 2 +-
 accel/hvf/hvf-accel-ops.c   | 2 +-
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
index 9dea3145429..b9a9b3593d8 100644
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
index 64bc991b1ce..913b7155d77 100644
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
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b9511103a75..6af849450e1 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -321,7 +321,7 @@ static void dummy_signal(int sig)
 
 bool hvf_allowed;
 
-static int hvf_accel_init(MachineState *ms)
+static int hvf_accel_init(AccelState *as, MachineState *ms)
 {
     int x;
     hv_return_t ret;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 17235f26464..264f288dc64 100644
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
index 92bed9264ce..8b109d4c03b 100644
--- a/accel/qtest/qtest.c
+++ b/accel/qtest/qtest.c
@@ -37,7 +37,7 @@ static void qtest_set_virtual_clock(int64_t count)
     qatomic_set_i64(&qtest_clock_counter, count);
 }
 
-static int qtest_init_accel(MachineState *ms)
+static int qtest_init_accel(AccelState *as, MachineState *ms)
 {
     return 0;
 }
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index 6e5dc333d59..d68fbb23773 100644
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
index de52a8f882a..1117f52bef0 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -76,7 +76,7 @@ static void xen_setup_post(MachineState *ms, AccelState *accel)
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
index f1c6120ccf1..eaae175aa5d 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -1153,7 +1153,7 @@ static struct RAMBlockNotifier nvmm_ram_notifier = {
 /* -------------------------------------------------------------------------- */
 
 static int
-nvmm_accel_init(MachineState *ms)
+nvmm_accel_init(AccelState *as, MachineState *ms)
 {
     int ret, err;
 
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index cf6d3e4cdd4..f0be840b7db 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -2505,7 +2505,7 @@ static void whpx_set_kernel_irqchip(Object *obj, Visitor *v,
  * Partition support
  */
 
-static int whpx_accel_init(MachineState *ms)
+static int whpx_accel_init(AccelState *as, MachineState *ms)
 {
     struct whpx_state *whpx;
     int ret;
-- 
2.49.0


