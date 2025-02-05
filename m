Return-Path: <kvm+bounces-37291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C76EA282CA
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 04:25:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4C2116390E
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 03:25:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB194213252;
	Wed,  5 Feb 2025 03:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqRxDcW/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFE979FE;
	Wed,  5 Feb 2025 03:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738725941; cv=none; b=PVhjM1vtS/ny+h6kl32ddmjLKp/0+1bChYX1NHc33ov9qx/oqSvOstDWCQu8lYgb7CEuCNlaYEoQEIRRlfCoBFCzf/kFtn/CSeQWI/kpsbFZXDJW5kvNtYy+9yYF+xIeMSnCgh3Y/Su6snB7lSSNmFDLCFMK7SdK0Bu9ZIwZoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738725941; c=relaxed/simple;
	bh=nEvStiQZluP4sGDhPFUNuT4tExw8FTpN+d9SovUsQVA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=D9KPA5f14Ubebgjm9e+7bM7ZJSmnu9X6Q5dxO9zux0LinxiqY5YgTrrCd8EhBCAGTU42PVTrlva35kVKH9r7E7jf0U6YuFJhCiX4SpXO+bc6uO0LZWv5/0VPlBtBfqtMPvBwi+LxujtoFdbFS3yaxVi48cmRSzGhyKhTiWGz71E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqRxDcW/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21644aca3a0so147260955ad.3;
        Tue, 04 Feb 2025 19:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738725938; x=1739330738; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QlxObsSq6Tni1SGRfuKZwqhsI5HIjd3tLSL1ki8/QRk=;
        b=DqRxDcW/D9mtv0Ykic5cZVwrbFOXymNSbUHN5xJ78LRA72QoK5IZ5blaD2gdmu1ejw
         ZnBkMB4YWmhXK4xw07+0VnEx1iR4Qc5e6F0XZcOJySqbEe8ZqkKa3/FO4ie2a4scpczq
         w7F/XIthX+ueNTEai0zMAfyXK+nd/8tWs++6reSarAb6tEbIwAkgv/Ia54DxsDTXgZ8N
         xeDoc+vmpxluI2WRAYTwdDrPdWVSx6mygLKI3Bx7Q0htU59QcGifKRHGfPQrQPmbfFDN
         1UbOf6rxZMGqbBVfwo+gB+//r+5VfNk0JnR8roVwi+ToYrR4z9wkyKQL9ovCZ8SwVU28
         cNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738725938; x=1739330738;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QlxObsSq6Tni1SGRfuKZwqhsI5HIjd3tLSL1ki8/QRk=;
        b=FRE/yozabWzizKHW6THdSht7kFJHml4D8jkPlXN5S1OzR88nCXsXbCO6JEDmKBlf3p
         9MhfHKglsr/ndGD8TpN4EmuAZqPcMGLW8F3dNOEDH+qQG/fZVOBcyrJPWNDGXQDqFSPC
         4v2898LbqN/7eoxEyoO/QophBfPBzExwgJ70GuUKRwavQR/mEAio0Lqnp9bdhEAMqd3t
         9CYhNzLz7smyvF9gkC3vky75MHZeQSkCsJQ1vaD8gki9/Q1M5L/5bBOI14rK0wnvlfK5
         PaJKRKlq/II7Nit5fsgIvUv0Zk2zJb6DexOdoEBotJ+E+KEn6kx1Os9GxDAcraDEXVN0
         ZS2A==
X-Forwarded-Encrypted: i=1; AJvYcCXipBW/1nAr/zPTckCukKhRr73x95HGZHK+MsDi9Ye5CzK+qK9VFSd/CKhJKHF3nSIN6Plnk0keZi/Y9Pg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSKY2y8tK3Ld5nW2oCPvtQz61DrhlRUu9UroRxJONTnhjkw9y9
	3oQNXXDAuMrk8/+r6jwC7f97h7YE2XpySRTtTr0kc+OWYn6ABAR+
X-Gm-Gg: ASbGncsgzfZ89u8vWP/cvzP+tkfb1dF8rka+E9U7YHFfmw5L4rAegudEd8yRgK3vUha
	Vgw9jEOGb4BRNiCGLajG27m+HMb6/ncupNnvsjTSBkwbtU4MlR+A9m4dvV1vo6ghaiMovw0f6q6
	JMz2ZRBidqn866zjZ5jCEjfce3InLZEiutKKFdwFmdYfDkW23C4NfLu54mQp1OpLj/abTsSccik
	EAx9B5hLoc+BR+84efUdxcTYlQ6K9rSxW8jKY+kwp6nSFp5nbHdoc9h4BhMpBPsEsF5Z7xSWGWN
	2QWLMKbuTioolGXW3IvbQcJO0xSh7G7JcckXVA==
X-Google-Smtp-Source: AGHT+IFLe5Ci88h5iHRz3P5+FBqlq5Iz7syNYxUGXuILIe0Dmk1wOIJ/4bdQUuz/WhX3j5KSzPBA5g==
X-Received: by 2002:a17:902:da8c:b0:215:773a:c168 with SMTP id d9443c01a7336-21f17dde08emr23247305ad.1.1738725938540;
        Tue, 04 Feb 2025 19:25:38 -0800 (PST)
Received: from localhost.localdomain ([58.38.78.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de3308f72sm104175645ad.175.2025.02.04.19.25.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 04 Feb 2025 19:25:38 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: peterz@infradead.org,
	vincent.guittot@linaro.org,
	dan.carpenter@linaro.org,
	seanjc@google.com,
	mkoutny@suse.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2] sched: Don't define sched_clock_irqtime as static key
Date: Wed,  5 Feb 2025 11:24:38 +0800
Message-Id: <20250205032438.14668-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The sched_clock_irqtime was defined as a static key in commit 8722903cbb8f
('sched: Define sched_clock_irqtime as static key'). However, this change
introduces a 'sleeping in atomic context' warning, as shown below:

	arch/x86/kernel/tsc.c:1214 mark_tsc_unstable()
	warn: sleeping in atomic context

As analyzed by Dan, the affected code path is as follows:

vcpu_load() <- disables preempt
-> kvm_arch_vcpu_load()
   -> mark_tsc_unstable() <- sleeps

virt/kvm/kvm_main.c
   166  void vcpu_load(struct kvm_vcpu *vcpu)
   167  {
   168          int cpu = get_cpu();
                          ^^^^^^^^^^
This get_cpu() disables preemption.

   169
   170          __this_cpu_write(kvm_running_vcpu, vcpu);
   171          preempt_notifier_register(&vcpu->preempt_notifier);
   172          kvm_arch_vcpu_load(vcpu, cpu);
   173          put_cpu();
   174  }

arch/x86/kvm/x86.c
  4979          if (unlikely(vcpu->cpu != cpu) || kvm_check_tsc_unstable()) {
  4980                  s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
  4981                                  rdtsc() - vcpu->arch.last_host_tsc;
  4982                  if (tsc_delta < 0)
  4983                          mark_tsc_unstable("KVM discovered backwards TSC");

arch/x86/kernel/tsc.c
    1206 void mark_tsc_unstable(char *reason)
    1207 {
    1208         if (tsc_unstable)
    1209                 return;
    1210
    1211         tsc_unstable = 1;
    1212         if (using_native_sched_clock())
    1213                 clear_sched_clock_stable();
--> 1214         disable_sched_clock_irqtime();
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
kernel/jump_label.c
   245  void static_key_disable(struct static_key *key)
   246  {
   247          cpus_read_lock();
                ^^^^^^^^^^^^^^^^
This lock has a might_sleep() in it which triggers the static checker
warning.

   248          static_key_disable_cpuslocked(key);
   249          cpus_read_unlock();
   250  }

Let revert this change for now as {disable,enable}_sched_clock_irqtime
are used in many places, as pointed out by Sean, including the following:

The code path in clocksource_watchdog():

  clocksource_watchdog()
  |
  -> spin_lock(&watchdog_lock);
     |
     -> __clocksource_unstable()
        |
        -> clocksource.mark_unstable() == tsc_cs_mark_unstable()
           |
           -> disable_sched_clock_irqtime()

And the code path in sched_clock_register():

	/* Cannot register a sched_clock with interrupts on */
	local_irq_save(flags);

	...

	/* Enable IRQ time accounting if we have a fast enough sched_clock() */
	if (irqtime > 0 || (irqtime == -1 && rate >= 1000000))
		enable_sched_clock_irqtime();

	local_irq_restore(flags);

[lkp@intel.com: reported a build error in the prev version]

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain/
Debugged-by: Dan Carpenter <dan.carpenter@linaro.org>
Debugged-by: Sean Christopherson <seanjc@google.com>
Debugged-by: Michal Koutný <mkoutny@suse.com>
Fixes: 8722903cbb8f ("sched: Define sched_clock_irqtime as static key")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra" <peterz@infradead.org>
---
 kernel/sched/cputime.c | 8 ++++----
 kernel/sched/sched.h   | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

v1->v2: Fix a build error reported by kernel test robot

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5d9143dd0879..6dab4854c6c0 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -9,8 +9,6 @@
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
 
-DEFINE_STATIC_KEY_FALSE(sched_clock_irqtime);
-
 /*
  * There are no locks covering percpu hardirq/softirq time.
  * They are only modified in vtime_account, on corresponding CPU
@@ -24,14 +22,16 @@ DEFINE_STATIC_KEY_FALSE(sched_clock_irqtime);
  */
 DEFINE_PER_CPU(struct irqtime, cpu_irqtime);
 
+int sched_clock_irqtime;
+
 void enable_sched_clock_irqtime(void)
 {
-	static_branch_enable(&sched_clock_irqtime);
+	sched_clock_irqtime = 1;
 }
 
 void disable_sched_clock_irqtime(void)
 {
-	static_branch_disable(&sched_clock_irqtime);
+	sched_clock_irqtime = 0;
 }
 
 static void irqtime_account_delta(struct irqtime *irqtime, u64 delta,
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 38e0e323dda2..ab16d3d0e51c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3259,11 +3259,11 @@ struct irqtime {
 };
 
 DECLARE_PER_CPU(struct irqtime, cpu_irqtime);
-DECLARE_STATIC_KEY_FALSE(sched_clock_irqtime);
+extern int sched_clock_irqtime;
 
 static inline int irqtime_enabled(void)
 {
-	return static_branch_likely(&sched_clock_irqtime);
+	return sched_clock_irqtime;
 }
 
 /*
-- 
2.43.5


