Return-Path: <kvm+bounces-64835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D55DC8D0A2
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 08:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3FD374E387B
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 07:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EDF31577B;
	Thu, 27 Nov 2025 07:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qE5psS1/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qE5psS1/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BF031BC96
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 07:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227404; cv=none; b=Z6q9VKJgPA4EZKp2FTiUuGqifLnAYfR2WVIotvu0K/g/kf9qol9vmjgNsPzIQ0u7ZU0IkgXZoLjCD22hGi8PuD+pJ57sc79XB7or34qcsvcyc6NHTlxsDIinSWcY2Tq6KiwsJur/igPtDoRlRACO6JEzS1P8K7ewpG+kNVJfafA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227404; c=relaxed/simple;
	bh=44+f+JTzNvJ0ZD3KR8roNXF7QE+gpcAoqnBmqF/7w6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+OMHGXp6U/c1THzKYxme2zl0x9ThqxENpaSbuDOCcHedYEVB3i0TygvPfH5iRclGP6fHfTy9hlL7QUmcgS0QZ7FFPv6BOqwC/IN3WO4Z+LU3NC5K77NbxtiA9SD7h/5fSUpg8FG14My52FvayOMjWUe7NRKx/AFaHbPcl7xUng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qE5psS1/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qE5psS1/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B4A433691;
	Thu, 27 Nov 2025 07:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764227400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLasP3YriVQxy2lyLTd3qvWbSz8xbbix/xncP62Dsck=;
	b=qE5psS1/rHm1GUZifBh+SnhvqvrUEY/YuteNJJHprmGbY7vf6EizgAaRNeuzhMFzWvAEfu
	4IWqh1TTZNkuZrauFs9XuPellnUOMPkGVa04UCO+ahUREX3kHS8L2nf3hl2LNPAV8eJYJy
	JFBRHevjZaCQcX52xaOobx9JtUZNkis=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764227400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLasP3YriVQxy2lyLTd3qvWbSz8xbbix/xncP62Dsck=;
	b=qE5psS1/rHm1GUZifBh+SnhvqvrUEY/YuteNJJHprmGbY7vf6EizgAaRNeuzhMFzWvAEfu
	4IWqh1TTZNkuZrauFs9XuPellnUOMPkGVa04UCO+ahUREX3kHS8L2nf3hl2LNPAV8eJYJy
	JFBRHevjZaCQcX52xaOobx9JtUZNkis=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 611CB3EA63;
	Thu, 27 Nov 2025 07:09:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dpI4Fkf5J2nAXQAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 27 Nov 2025 07:09:59 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	xen-devel@lists.xenproject.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH v4 12/21] x86/paravirt: Move paravirt_sched_clock() related code into tsc.c
Date: Thu, 27 Nov 2025 08:08:35 +0100
Message-ID: <20251127070844.21919-13-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127070844.21919-1-jgross@suse.com>
References: <20251127070844.21919-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -6.80
X-Spam-Flag: NO

The only user of paravirt_sched_clock() is in tsc.c, so move the code
from paravirt.c and paravirt.h to tsc.c.

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/paravirt.h    | 12 ------------
 arch/x86/include/asm/timer.h       |  1 +
 arch/x86/kernel/kvmclock.c         |  1 +
 arch/x86/kernel/paravirt.c         |  7 -------
 arch/x86/kernel/tsc.c              | 10 +++++++++-
 arch/x86/xen/time.c                |  1 +
 drivers/clocksource/hyperv_timer.c |  2 ++
 7 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 766a7cee3d64..b69e75a5c872 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -14,20 +14,8 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/cpumask.h>
-#include <linux/static_call_types.h>
 #include <asm/frame.h>
 
-u64 dummy_sched_clock(void);
-
-DECLARE_STATIC_CALL(pv_sched_clock, dummy_sched_clock);
-
-void paravirt_set_sched_clock(u64 (*func)(void));
-
-static __always_inline u64 paravirt_sched_clock(void)
-{
-	return static_call(pv_sched_clock)();
-}
-
 __visible void __native_queued_spin_unlock(struct qspinlock *lock);
 bool pv_is_native_spin_unlock(void);
 __visible bool __native_vcpu_is_preempted(long cpu);
diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 23baf8c9b34c..fda18bcb19b4 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -12,6 +12,7 @@ extern void recalibrate_cpu_khz(void);
 extern int no_timer_check;
 
 extern bool using_native_sched_clock(void);
+void paravirt_set_sched_clock(u64 (*func)(void));
 
 /*
  * We use the full linear equation: f(x) = a + b*x, in order to allow
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index ca0a49eeac4a..b5991d53fc0e 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -19,6 +19,7 @@
 #include <linux/cc_platform.h>
 
 #include <asm/hypervisor.h>
+#include <asm/timer.h>
 #include <asm/x86_init.h>
 #include <asm/kvmclock.h>
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 42991d471bf3..4e37db8073f9 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -60,13 +60,6 @@ void __init native_pv_lock_init(void)
 		static_branch_enable(&virt_spin_lock_key);
 }
 
-DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
-
-void paravirt_set_sched_clock(u64 (*func)(void))
-{
-	static_call_update(pv_sched_clock, func);
-}
-
 static noinstr void pv_native_safe_halt(void)
 {
 	native_safe_halt();
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 87e749106dda..554b54783a04 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -266,19 +266,27 @@ u64 native_sched_clock_from_tsc(u64 tsc)
 /* We need to define a real function for sched_clock, to override the
    weak default version */
 #ifdef CONFIG_PARAVIRT
+DEFINE_STATIC_CALL(pv_sched_clock, native_sched_clock);
+
 noinstr u64 sched_clock_noinstr(void)
 {
-	return paravirt_sched_clock();
+	return static_call(pv_sched_clock)();
 }
 
 bool using_native_sched_clock(void)
 {
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
+
+void paravirt_set_sched_clock(u64 (*func)(void))
+{
+	static_call_update(pv_sched_clock, func);
+}
 #else
 u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
+void paravirt_set_sched_clock(u64 (*func)(void)) { }
 #endif
 
 notrace u64 sched_clock(void)
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index e4754b2fa900..6f9f665bb7ae 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -19,6 +19,7 @@
 #include <linux/sched/cputime.h>
 
 #include <asm/pvclock.h>
+#include <asm/timer.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/cpuid.h>
diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 10356d4ec55c..e9f5034a1bc8 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -535,6 +535,8 @@ static __always_inline void hv_setup_sched_clock(void *sched_clock)
 	sched_clock_register(sched_clock, 64, NSEC_PER_SEC);
 }
 #elif defined CONFIG_PARAVIRT
+#include <asm/timer.h>
+
 static __always_inline void hv_setup_sched_clock(void *sched_clock)
 {
 	/* We're on x86/x64 *and* using PV ops */
-- 
2.51.0


