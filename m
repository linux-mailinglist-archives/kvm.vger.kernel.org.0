Return-Path: <kvm+bounces-51327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 474E0AF61E7
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 961171C471EF
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C540221F06;
	Wed,  2 Jul 2025 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cOczZGER"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5DB2F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482486; cv=none; b=K0YGeQi5FnELOBNaHweRFC5jxcKSqho7LQx02/zGchvgAyS3fz5vmNSmNrp1Gp89oKq4iRuWVJXjt6tpU0/ymJo60VN4BqZah6Jh1h1UqK2KBLPV3BOusH/4WsTXarTdfe6MjsCz2Sq2nGHAsjNFv6xGoPfcD34y9JI0nOIHXuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482486; c=relaxed/simple;
	bh=m6LFkGqCQRntqHDAsjsiXdgPZVQ+b51GcIz7wr7+ed8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P96I6plGUc0nzTtTfXCRCi1G/+S22WZRxdaerxRYMbb/vaoKzU3Gbd/cGdQUYvvhCcsW0U8xaC8BBOX5KvIx9iVCR2Cv1+KPe4u/k27CJVs4ioSNdqf0SK3pKg+2bY3NeGy+Rm496iNtSIXCzlb0lSjossI79IWrKJbDcQVqI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cOczZGER; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45348bff79fso48502035e9.2
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482482; x=1752087282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pcxyecq1Uca5OV4SmO/+hJU9sxDq9D6xrBJnOg87yRs=;
        b=cOczZGER3EO34qDEQb/n4qHASF5B9ONAz9RtbyYKjnxZbVdxqaQU7FYUcjnHsJZS1q
         0UuWj+XdrEHmnEI2GwUaX1K7R6JBY5wSDiGmCu2MTcg+DUG2wxfF+wisDc4HfGbxpE/3
         FXs0yIXb9seuIj7kVPYJDA+WSnzAMHvfOCy9cH7o0nz/BnNMZCNNRGdvB9wEK2k7Y3YY
         zKsG2xgPWyPQxLSkYqG9oAMtfkG7vhWazlh1t87YARnEOK1lmxep4oOOrNKzCBIG2QlB
         ltRdZjeM/ZvEhECAmaXdhjyuCe5I4Hi20CXE0bQH+mJkfxssklXzOw1YyhquIYK9YTmS
         IsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482482; x=1752087282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pcxyecq1Uca5OV4SmO/+hJU9sxDq9D6xrBJnOg87yRs=;
        b=Znud3v9dd+6eYZjM4cuO16S/94nQoEl04M5S34s5JZhFrZbPn5aXylzf7LLeEkseem
         6oz3URG9STGBrVoyOOKpgsINj9npnSHWNq91Wo3mPE2Ziybuw9ndESuVzVLJ4j4kEaJo
         7vTA23FCVh7u4Ba+GBz7Gl050yqRzVHHhaHeuxAEexpLce4dYanU41Q1NgjK7j53sjDA
         s5GyVqA9fDWkrzgtORicSOFPNZ7661J2ej/KcT5dw3pGR6KIL35f4r3FRopwWswqNVe8
         ZEoQzKO6+i7ByhG3L0Q54AncpwIsAllKNxgvtyqcHZzooFKIb7Nc0KrmSBwIPXU+imRf
         2Mrw==
X-Forwarded-Encrypted: i=1; AJvYcCW4IYs7wrsIdS8hPf0bltK8wEhQ+h3NJ/lMpLIk5Dh5lTzPFPLt9lmo4kpc4dIixic1gPA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzY8JlbuTDy7BmtRzPTKUlksIII37ks3BGWLlBcygBxig9o77Ef
	1BoL7kKbCEhJ3uwcwtbwL0p0OF1D8RetWYJUkb3dsjf7isu2VEw6iKtJVUVbqPOM37A=
X-Gm-Gg: ASbGncsOMTN8pPLIU1QpBLQxqwv7p59nGMyETcyAJ99nPOqcAhhfqsrQ9vmckM3MClz
	ASUarukdxv8nzh159A9L/YdhX8iHE0SYvIXA393d/1y5pBdq+j8k/wzFN7tHwR4fq5LHTmGitat
	XHChIJ4NQPIBrv0kClcETlnOhop/kii+eoDpXeSJEzvvXXkvtXNWpDtfccmehVh80t3lGN4Tk7z
	od85wAs9drSQB4eN34iAtb3yNQmWW16Ubv7T+NDoGsmIrutTLTk3oc+VudDNjF9uDnRF8CwfUU1
	a0J9REZ5taG+Xrsr1M1s1pmn6VlB1LwEYaVz7UuBQB63qJcNzsChrELrOSR1clc1q//vIj2+XoP
	KthN1Ej8bnrlrEpUe0Yk7rDsJaVLDwIr3fM9syLlJheiMU0E=
X-Google-Smtp-Source: AGHT+IG2xbJ0vrnlKXjnJOXC1pKqbgrk71RyrOx0GBs5KhAxvWN6hGdVgbklFARA84XuaOzPgh1qcg==
X-Received: by 2002:a05:600c:3b07:b0:450:30e4:bdf6 with SMTP id 5b1f17b1804b1-454a3704fd2mr40210905e9.19.1751482481564;
        Wed, 02 Jul 2025 11:54:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9966a00sm5940465e9.3.2025.07.02.11.54.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:54:41 -0700 (PDT)
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
Subject: [PATCH v4 09/65] accel: Propagate AccelState to AccelClass::init_machine()
Date: Wed,  2 Jul 2025 20:52:31 +0200
Message-ID: <20250702185332.43650-10-philmd@linaro.org>
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


