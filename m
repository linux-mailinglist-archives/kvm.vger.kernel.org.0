Return-Path: <kvm+bounces-36603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC531A1C67F
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 07:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15FB616770C
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 06:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16EC19C54A;
	Sun, 26 Jan 2025 06:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCVLUG5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F3E645;
	Sun, 26 Jan 2025 06:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737874246; cv=none; b=rjxW9k64oImCPEAAVxExoG34OuV7FCEDNcxpNcqHWawWarHyoEn/0qXtW94oB6SaFaCW/e2jAEp7TYBKI3kxUbnM2pGYXy0ENwvLlMMmKDFLR/hUSIoUwOlDe24exXADfcETnvQtRVq9CHpjdMWwWMoVyvTdqz/Bqlm7Hb+Wmeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737874246; c=relaxed/simple;
	bh=/1NCANnSWVdbdYUtCP8PeQTgQx1Y8AQrWVNjxs4eYs4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=b2VLFI+oZh/sMWm5J7M4cVOSvoAUqiN0gjB7cMQHKKZHLCQK4ek/KtpSHY/AxE/n9067uACtbPE6z808HKLHDD/KsUUxMyPrOdmzSdR0ar2RnvOjfZu3Agho2jVJFMvE+Mzk20XDiaapMnu3fG15dcQWi4EnnzIKBWj6Hhaq6oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QCVLUG5D; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21661be2c2dso58219155ad.1;
        Sat, 25 Jan 2025 22:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737874244; x=1738479044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GYCGVQ9HJzl19CXFVPtFYu5eyoXbIFuI2r1CW6IQ5bs=;
        b=QCVLUG5D8LJqa310sFJAwKbbfA9UQhRgDYvrIjoi3cFtn0Ksbad4EyyYPsatNk09Oe
         m0/0rC9ER3GwIHAkiAtebaY4d8TXDHX1/e/lpHJ+3akSk8Ir8gFaP3HAytNZus8HL+WI
         utqNAR9aeCWNmJNEsNUnGkzhsU9YAterJ/2X8sOff+tX6kuWl/yvRfpptOsw421NVlZh
         jEXmLAPJJ2lQLkUlhwMpXBiX22pMnp9FhH6FsEqOmrt6AUzr7P/X3p554xjjKPPBGf/M
         iyX3lzAUzTrsFcEz//lT4mmlJbgERCJsXv1UoXls6fLn80ps22s9MkczEL+52xqUE74K
         xhbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737874244; x=1738479044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GYCGVQ9HJzl19CXFVPtFYu5eyoXbIFuI2r1CW6IQ5bs=;
        b=AFDFlqEPqz1P2DLwOz+OcWfkbj3Aj/ty8ccPqPT0nW2xit88NXSFJcAt2OzDbdFhB/
         /irswklrCtKGguML4LMcYKlZ7b0PJEuBOVuTi0antH/tqNSnittrhqHRIIi8PsksKf4O
         pkDHI0Q6z2h26JR7rgui+hixt+Vra2mi5HH3CbSkgeThzkSDCY4z9CJmTAqrhXpPQ5IR
         FiwISDHGQ8loYOdI3T/z4qWGzekJFykP1RA1AhCOzFueXzOR0szejTSaOyur7ONPONBa
         ccemZMESAgKPthYaaB43q40rrAnT+dSzSKAJZR/xKPdeqi38QnYPoYxUCisTskRPqt0Y
         j73A==
X-Forwarded-Encrypted: i=1; AJvYcCXfYHYyczlQhIsWfCwKzuKWMbn3lHrFbV7WengZnX8R4ILNvChJ6VJ9bqYV9Fp3ssOwHg2xac5zXN6J9lY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYcX9hShC9uBmXLUg+DNaBa/4xchNH5NHvXEfs/jysjn34JjYL
	m4z1zhz2JvhalwlqtknGJU4NDju9yeiy5albEDdC5qF1cQeS6cL2
X-Gm-Gg: ASbGncsGdGOavNQk7iF3Eoo1LHMsTKcpmnxNz7+Lwo3UqQHcfb0Aaws4c7DIyJXByD1
	ezaMMtUydL0KN+9jzYCneQ4HP4FoLVDf7S5+LlirZmJWelAPYfmE+NQ+P5CKbiyWNhZeteOFI5n
	Def76dM+H0dd5iQHs7CtWPW0OBtREdi2GbP0SG5XX7Dq+fTrIsHIIXxFRrQRMB8g3FyoP48ila4
	Oh2pViPQcbk4hDj4bCu6cyoDWcMD2KtdJk+RGp8RXz7b842eaLJvQItygGfNI0eURDuuiZ+OpqE
	184KVLRP9cHMFnEp6m0bJf2WqBg=
X-Google-Smtp-Source: AGHT+IGDsQQE+dMiWKtgPB8CByg1ZASB4VwmuHypQS1O1GKGF76HumKA4g0gIGmoOiIq8iV7ybCQwA==
X-Received: by 2002:a17:902:e548:b0:215:e98c:c5bb with SMTP id d9443c01a7336-21c3555353dmr563087785ad.28.1737874243666;
        Sat, 25 Jan 2025 22:50:43 -0800 (PST)
Received: from localhost.localdomain ([58.38.78.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414ef78sm41182885ad.207.2025.01.25.22.50.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jan 2025 22:50:43 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: dan.carpenter@linaro.org,
	seanjc@google.com,
	mkoutny@suse.com,
	vincent.guittot@linaro.org,
	peterz@infradead.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] sched: Don't define sched_clock_irqtime as static key
Date: Sun, 26 Jan 2025 14:50:37 +0800
Message-Id: <20250126065037.97935-1-laoar.shao@gmail.com>
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

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/37a79ba3-9ce0-479c-a5b0-2bd75d573ed3@stanley.mountain/
Debugged-by: Dan Carpenter <dan.carpenter@linaro.org>
Debugged-by: Sean Christopherson <seanjc@google.com>
Debugged-by: Michal Koutný <mkoutny@suse.com>
Fixes: 8722903cbb8f ("sched: Define sched_clock_irqtime as static key")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra" <peterz@infradead.org>
Cc: Vincent Guittot" <vincent.guittot@linaro.org>
---
 kernel/sched/cputime.c | 8 ++++----
 kernel/sched/sched.h   | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 5d9143dd0879..c7904ce2345a 100644
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
 
+static int sched_clock_irqtime;
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


