Return-Path: <kvm+bounces-17881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B318CB69D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9292838E5
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43832B9D1;
	Wed, 22 May 2024 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wHI+7SJU"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FA91C01;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337117; cv=none; b=OAoHxouF6sZbehXEGrlxTbDTpuvHVrLS4YJYAwUUZkYQZ+TCaJrQe2ztrtrmtyTU7ZaWIVj3laHOupxdbRdgtUymeUECPc9bhH3x83npeDxWrMkea7A4A7tszkXB/VE4cLftDDRNvXW2iNdtTqtpaTBecRfk+X9U9Ce4K0/4+iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337117; c=relaxed/simple;
	bh=oreP581RFFJ0udRz/Em+dh8lxr/hYKZ4qCRmSQDE6AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc130ljcr03Xp4FXS7Sa9xCQKb0TWiGdj9VwoNEdJiNAMe50cOD+H3qpSmF/EHYLXAfsC5/jH56JclhWsERTyRQHJ6Q1zvyHspoy6IgLpkTDgVzLeYFHet35BvouAvZVLkzO0K+UX5oRatOJNcQWYUBmdvAko+fawzLGKA+ymaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wHI+7SJU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ApxpDJWImUR2W02lv4MOUaYvWzFyVZfupX+UUwfAxSw=; b=wHI+7SJUV3iS7w6V4ehqrOCF3n
	yFtiJrIeh+Ug2HJZBC0qvaIsgFAHAY6Ix60h+cxyLbDcsqqr+EnEbYoOoHjCfFetwUtorKCWY/FdG
	lkzmifzpU9ZNhI3JhX4NnokNxboEr/SsJswkMVm5gfWZo3CmScCCy3x/kQ4LW5WID/qL8ly98Jg/Y
	ZvijUMAx3EadFaOJ6C8NWWzYkCAltFxiCNWDlBmiedXbgKvDnJgsFPVwGCCdREumYqtCGvzwxNAlN
	1im12gWIV2da63n1pYe9xDdLgkVudc2yjX+l0ees2Wjjxx+13i8Ck4m4AKulwA9sRctVY7xxXeUoj
	xgSeo2JQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081F-1q4D;
	Wed, 22 May 2024 00:18:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b4g-00jJ;
	Wed, 22 May 2024 01:18:20 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paul Durrant <paul@xen.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jalliste@amazon.co.uk,
	sveith@amazon.de,
	zide.chen@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [RFC PATCH v3 08/21] KVM: x86: Avoid NTP frequency skew for KVM clock on 32-bit host
Date: Wed, 22 May 2024 01:17:03 +0100
Message-ID: <20240522001817.619072-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240522001817.619072-1-dwmw2@infradead.org>
References: <20240522001817.619072-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

Commit 53fafdbb8b21 ("KVM: x86: switch KVMCLOCK base to monotonic raw
clock") did so only for 64-bit hosts, by capturing the boot offset from
within the existing clocksource notifier update_pvclock_gtod().

That notifier was added in commit 16e8d74d2da9 ("KVM: x86: notifier for
clocksource changes") but only on x86_64, because its original purpose
was just to disable the "master clock" mode which is only supported on
x86_64.

Now that the notifier is used for more than disabling master clock mode,
(well, OK, more than a decade later but clocks are hard), enable it for
the 32-bit build too so that get_kvmclock_base_ns() can be unaffected by
NTP sync on 32-bit too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
---
 arch/x86/kvm/x86.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00a7c1188dec..44b3d2a0da5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2245,7 +2245,6 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	return kvm_set_msr_ignored_check(vcpu, index, *data, true);
 }
 
-#ifdef CONFIG_X86_64
 struct pvclock_clock {
 	int vclock_mode;
 	u64 cycle_last;
@@ -2303,13 +2302,6 @@ static s64 get_kvmclock_base_ns(void)
 	/* Count up from boot time, but with the frequency of the raw clock.  */
 	return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.offs_boot));
 }
-#else
-static s64 get_kvmclock_base_ns(void)
-{
-	/* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
-	return ktime_get_boottime_ns();
-}
-#endif
 
 static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
 {
@@ -9819,6 +9811,7 @@ static void pvclock_irq_work_fn(struct irq_work *w)
 }
 
 static DEFINE_IRQ_WORK(pvclock_irq_work, pvclock_irq_work_fn);
+#endif
 
 /*
  * Notification about pvclock gtod data update.
@@ -9826,26 +9819,26 @@ static DEFINE_IRQ_WORK(pvclock_irq_work, pvclock_irq_work_fn);
 static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
 			       void *priv)
 {
-	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 	struct timekeeper *tk = priv;
 
 	update_pvclock_gtod(tk);
 
+#ifdef CONFIG_X86_64
 	/*
 	 * Disable master clock if host does not trust, or does not use,
 	 * TSC based clocksource. Delegate queue_work() to irq_work as
 	 * this is invoked with tk_core.seq write held.
 	 */
-	if (!gtod_is_based_on_tsc(gtod->clock.vclock_mode) &&
+	if (!gtod_is_based_on_tsc(pvclock_gtod_data.clock.vclock_mode) &&
 	    atomic_read(&kvm_guest_has_master_clock) != 0)
 		irq_work_queue(&pvclock_irq_work);
+#endif
 	return 0;
 }
 
 static struct notifier_block pvclock_gtod_notifier = {
 	.notifier_call = pvclock_gtod_notify,
 };
-#endif
 
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
@@ -9984,9 +9977,10 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	if (pi_inject_timer == -1)
 		pi_inject_timer = housekeeping_enabled(HK_TYPE_TIMER);
-#ifdef CONFIG_X86_64
+
 	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
 
+#ifdef CONFIG_X86_64
 	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
 		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
 #endif
-- 
2.44.0


