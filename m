Return-Path: <kvm+bounces-17892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 342938CB6AA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 592171C2265D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D84F55C29;
	Wed, 22 May 2024 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QGp7ATVq"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B83D23CB;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337118; cv=none; b=NAQkKAdEjIRe93QH9FjEhH+lUtV0PYqa66JgMjkcfNbH45Fij5c4VYQKxetpnW8QM4w0SNqFyWmac+FZNe3X2xQHCJqI7ZsMkYjA+cUGITOhTwl0MtsCySREawbXkGKWC3bYTb9QKxx5khnQyrLN79yKnABVZT31t4aJVGmVp9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337118; c=relaxed/simple;
	bh=i/X4Px4t4zPvYCWMwNatb+AuPH91Q8kGeOi8Z43z2rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blO1fw/oruXmpa8agapbAOC6DexiH201h6mOfPb4owoC888NtWpnBgBZebWIG4QAuoNzNDATNDZWifxiwdMWX3WUFVfKSGbA+1Oqr5bu1MqxSXfcFXLn6Tke3s/Up3H8XU0sR6ZnvILK/7fbNCYxdhWL/XnhGetghGS5I+8RJG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QGp7ATVq; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xQUXte1/Vs9XT7uE6il9bTk47fOO+ibxXP0230KCstA=; b=QGp7ATVqGd73t5igypMM/GYkxQ
	DsKnBbBj3fQhLliY44MlFxAvq+3MqXEslirWam3ZbrRLuRW2kQqecsjz+optlv8JmGCnqlSv9t97y
	I9VqS0JUo0esf9msBtCzoPRTAEAVZSIl0DE2BItPDh4woUS3nApkKpAHpy7prptCxa16NEkHhNjiH
	sgVMudntGq1jZWi6xZifrvP63trGRyvk11ciah/x7eSLS4W97DbQ4B1Ic/aixz/cgIMRhmOhNpyba
	YPXF72J8DENArzRBOVVSA43pE68/+EwDSRZbPLxLV7+TLH0HWenIpcFk+F45GcgcUkQatxSxUZhne
	k8/NSLpQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081O-3qqf;
	Wed, 22 May 2024 00:18:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b5F-2Ius;
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
Subject: [RFC PATCH v3 16/21] KVM: x86: Factor out kvm_use_master_clock()
Date: Wed, 22 May 2024 01:17:11 +0100
Message-ID: <20240522001817.619072-17-dwmw2@infradead.org>
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

Both kvm_track_tsc_matching() and pvclock_update_vm_gtod_copy() make a
decision about whether the KVM clock should be in master clock mode.

They use *different* criteria for the decision though. This isn't really
a problem; it only has the potential to cause unnecessary invocations of
KVM_REQ_MASTERCLOCK_UPDATE if the masterclock was disabled due to TSC
going backwards, or the guest using the old MSR. But it isn't pretty.

Factor the decision out to a single function. And document the historical
reason why it's disabled for guests that use the old MSR_KVM_SYSTEM_TIME.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e21b8c075bf6..437412b36cae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2518,6 +2518,27 @@ static inline bool gtod_is_based_on_tsc(int mode)
 }
 #endif
 
+static bool kvm_use_master_clock(struct kvm *kvm)
+{
+	struct kvm_arch *ka = &kvm->arch;
+
+	/*
+	 * The 'old kvmclock' check is a workaround (from 2015) for a
+	 * SUSE 2.6.16 kernel that didn't boot if the system_time in
+	 * its kvmclock was too far behind the current time. So the
+	 * mode of just setting the reference point and allowing time
+	 * to proceed linearly from there makes it fail to boot.
+	 * Despite that being kind of the *point* of the way the clock
+	 * is exposed to the guest. By coincidence, the offending
+	 * kernels used the old MSR_KVM_SYSTEM_TIME, which was moved
+	 * only because it resided in the wrong number range. So the
+	 * workaround is activated for *all* guests using the old MSR.
+	 */
+	return ka->all_vcpus_matched_tsc &&
+		!ka->backwards_tsc_observed &&
+		!ka->boot_vcpu_runs_old_kvmclock;
+}
+
 static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
@@ -2550,7 +2571,7 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 	 * To use the masterclock, the host clocksource must be based on TSC
 	 * and all vCPUs must have matching TSC frequencies.
 	 */
-	bool use_master_clock = ka->all_vcpus_matched_tsc &&
+	bool use_master_clock = kvm_use_master_clock(vcpu->kvm) &&
 				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
 
 	/*
@@ -3096,9 +3117,7 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 					&ka->master_cycle_now);
 
 	ka->use_master_clock = host_tsc_clocksource
-				&& ka->all_vcpus_matched_tsc
-				&& !ka->backwards_tsc_observed
-				&& !ka->boot_vcpu_runs_old_kvmclock;
+				&& kvm_use_master_clock(kvm);
 
 	/*
 	 * When TSC scaling is in use (which can thankfully only happen
-- 
2.44.0


