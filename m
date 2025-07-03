Return-Path: <kvm+bounces-51513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D17EAF7EEE
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B07E56050F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6C42F198F;
	Thu,  3 Jul 2025 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qNIsfONP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C5F28A1F8
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751564040; cv=none; b=Jr4MXp9mCwrxHdXaBaReQF4Csx7Mj9lfPvs46KM5jreLe6ib1kIZNnz/WIdURy8H48ab/xL9P0drG6YRkwED8zla0tD4WegkZ63i/cOTwl8y2s1NVnkTDi9LLQAoSbL9EqvNgMgf2pVVAzoHT708QvguVZ7Y+FmRzbkMRfj2DDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751564040; c=relaxed/simple;
	bh=ElRCM8h3CnJS4hvN+o/HrxEZcA90MnP+8HH9rnpCxAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RNTNH1WG3sjHkYd/f9M8GLks1TdaQgsf8sR1BMhdixCtOfksXm62BGcFCLzRy5E+vXzfJpU+wn7TM/ys1g0nlxyKrqtwnM8Ldr9KXoF8TWBBiUWEfFHVTbSc1JXtycihu9A6ccosWBEV2XSqWeI9i8EZGYDAWo1BZBAQ9IHRvBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qNIsfONP; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4537fdec33bso550875e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 10:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751564037; x=1752168837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/XChvbBlrGhhVuJVL/Zk7Vb78wLAovjWCdTr9DfryE=;
        b=qNIsfONPZ4om2UTXc27NBcuu7OEp5JkvW2Rne5WSEfLEnE56AWyt0S7QPEwtBl3IYd
         n7Uwf9k7B+9PH1IEKWCQScYwYXdWR7FFFjwUDyErZeFuBO/o+Bi0rFuYByxH01zDgzyo
         o8DMXvvJmKfAqm8yEXvVeXg6f9ORpKzQqxXS4oScb2ToFi5DIIw/fs6dSa9S8BSEZgYJ
         Ko3CUdUy9i03alerPAn8UVhmEUdjlpJKGUHtU5yWafZA5EzFoeuktPPS/w7foG1Lkcsm
         gU44QoFY7dGJRRt086agOJdNe0b2S97KdSxFNwU0a+K3uyqMBGkaMJsn7Vtu2Mg69TDC
         jAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751564037; x=1752168837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/XChvbBlrGhhVuJVL/Zk7Vb78wLAovjWCdTr9DfryE=;
        b=BgFNFuZTKha3FHDgOTenF5QboRVSWEbh9IXoJ2FALhzMDLhRbWflnDxUFRhHrLSzvq
         zVOXGAOIgq8CgM4lxx9CcLijSdmS6edI75+xR4SmITpXxCXr7rz8YsK1+fuuUduYqChs
         O768Er89+SV8R6nvP9QZCMHhF3PZP548gtMOcJY+6wGRBFs9bz3ETtqeWYhwG50xeJw2
         dI2r3t12eu3EeyHNqo8C01kLXSrycfYLrQGkrVp6CslAzeixIZ4Tr1Jt/7EpJ6KMLnla
         nC4v5J4VRzdyjU/hOwfbPNKj8MMSIJF7XAxB/g0QLF040mFYWQjWJEt4mWN9haLthDHg
         EmFw==
X-Forwarded-Encrypted: i=1; AJvYcCUYcqvY/9nrgGKVY3K1cNypXh+mWrK6NqQCoPV7CTNB5Ze/WxqlU05aIbfyH0icRSBxqdQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTLF1dDTsEqlS2D+MeUmIkL34czxCJO3diRZLUKaf82I320Nyi
	Qun4fAcDYnNWf0mMJTQOq3eTocxptgbf1phbVN0kE/n7FqJMPBAWXqkI41GMRTy6Xdw=
X-Gm-Gg: ASbGncuxShNfzjGow3BPFbIeyN7jd5O8SuQJUtjaAB8cznj6RG9a3o2qeNKRWmdJhQf
	9QaFq1rUz66glmGub8R66BQZk1uLIqnr3bn/NTTIJa85hT1fBO+KqX8c7k5xLPCqghmclKBQ3m/
	+LUsYvmhNjsaBGC0kdO8VGoCBvpwY5Oq7Yqt0XVBvd65cAEZcb0GV43tjbgl9nnyY2R5f33MDtZ
	jRYhcJ6EvgKeYh2DGYWQs2wBVz7K8W6iVyuYJUcqHxtfYvR0wfUQrSzIV7QB2celauBSDEOMgiD
	32RhMcN55+PGHEdazFknx7BcHrv0TcbM9tb21KvucVe3LMWceUL1ysCIrBt3OZGRqRCrtVJb68C
	y3uNKkSszz8E8qFB/oQ+aGE3PVcn6q4tlo0fM
X-Google-Smtp-Source: AGHT+IEjIcbV0/p4Gzpq8ssp7QneNZeB0/RBRlqRwz4r9eWXtga2gIBfvXxZyNMLZl6Wi93ElXZ5wA==
X-Received: by 2002:a05:600c:4e86:b0:453:c39:d0c6 with SMTP id 5b1f17b1804b1-454a3737eccmr66163065e9.32.1751564036915;
        Thu, 03 Jul 2025 10:33:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b47030c443sm344279f8f.11.2025.07.03.10.33.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 10:33:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org
Subject: [PATCH v6 13/39] accel: Move cpus_are_resettable() declaration to AccelClass
Date: Thu,  3 Jul 2025 19:32:19 +0200
Message-ID: <20250703173248.44995-14-philmd@linaro.org>
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

AccelOpsClass is for methods dealing with vCPUs.
When only dealing with AccelState, AccelClass is sufficient.

Move cpus_are_resettable() declaration to accel/accel-system.c.

In order to have AccelClass methods instrospect their state,
we need to pass AccelState by argument.

Adapt KVM handler.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h       |  1 +
 include/system/accel-ops.h |  1 -
 accel/accel-system.c       | 10 ++++++++++
 accel/kvm/kvm-accel-ops.c  |  6 ------
 accel/kvm/kvm-all.c        |  6 ++++++
 system/cpus.c              |  8 --------
 6 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index fb176e89bad..f987d16baaa 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -45,6 +45,7 @@ typedef struct AccelClass {
     void (*setup_post)(MachineState *ms, AccelState *accel);
     bool (*has_memory)(MachineState *ms, AddressSpace *as,
                        hwaddr start_addr, hwaddr size);
+    bool (*cpus_are_resettable)(AccelState *as);
 
     /* gdbstub related hooks */
     bool (*supports_guest_debug)(AccelState *as);
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 700df92ac6d..f19245d0a0e 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -33,7 +33,6 @@ struct AccelOpsClass {
     /* initialization function called when accel is chosen */
     void (*ops_init)(AccelOpsClass *ops);
 
-    bool (*cpus_are_resettable)(void);
     void (*cpu_reset_hold)(CPUState *cpu);
 
     void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
diff --git a/accel/accel-system.c b/accel/accel-system.c
index a0f562ae9ff..07b75dae797 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -62,6 +62,16 @@ void accel_setup_post(MachineState *ms)
     }
 }
 
+bool cpus_are_resettable(void)
+{
+    AccelState *accel = current_accel();
+    AccelClass *acc = ACCEL_GET_CLASS(accel);
+    if (acc->cpus_are_resettable) {
+        return acc->cpus_are_resettable(accel);
+    }
+    return true;
+}
+
 /* initialize the arch-independent accel operation interfaces */
 void accel_init_ops_interfaces(AccelClass *ac)
 {
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 96606090889..99f61044da5 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -78,11 +78,6 @@ static bool kvm_vcpu_thread_is_idle(CPUState *cpu)
     return !kvm_halt_in_kernel();
 }
 
-static bool kvm_cpus_are_resettable(void)
-{
-    return !kvm_enabled() || !kvm_state->guest_state_protected;
-}
-
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
 static int kvm_update_guest_debug_ops(CPUState *cpu)
 {
@@ -96,7 +91,6 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->create_vcpu_thread = kvm_start_vcpu_thread;
     ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
-    ops->cpus_are_resettable = kvm_cpus_are_resettable;
     ops->synchronize_post_reset = kvm_cpu_synchronize_post_reset;
     ops->synchronize_post_init = kvm_cpu_synchronize_post_init;
     ops->synchronize_state = kvm_cpu_synchronize_state;
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c8611552d19..88fb6d36941 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3979,6 +3979,11 @@ static void kvm_accel_instance_init(Object *obj)
     s->msr_energy.enable = false;
 }
 
+static bool kvm_cpus_are_resettable(AccelState *as)
+{
+    return !kvm_enabled() || !kvm_state->guest_state_protected;
+}
+
 /**
  * kvm_gdbstub_sstep_flags():
  *
@@ -3997,6 +4002,7 @@ static void kvm_accel_class_init(ObjectClass *oc, const void *data)
     ac->init_machine = kvm_init;
     ac->has_memory = kvm_accel_has_memory;
     ac->allowed = &kvm_allowed;
+    ac->cpus_are_resettable = kvm_cpus_are_resettable;
     ac->gdbstub_supported_sstep_flags = kvm_gdbstub_sstep_flags;
 #ifdef TARGET_KVM_HAVE_GUEST_DEBUG
     ac->supports_guest_debug = kvm_supports_guest_debug;
diff --git a/system/cpus.c b/system/cpus.c
index a43e0e4e796..4fb764ac880 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -195,14 +195,6 @@ void cpu_synchronize_pre_loadvm(CPUState *cpu)
     }
 }
 
-bool cpus_are_resettable(void)
-{
-    if (cpus_accel->cpus_are_resettable) {
-        return cpus_accel->cpus_are_resettable();
-    }
-    return true;
-}
-
 void cpu_exec_reset_hold(CPUState *cpu)
 {
     if (cpus_accel->cpu_reset_hold) {
-- 
2.49.0


