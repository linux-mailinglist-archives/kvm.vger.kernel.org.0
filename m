Return-Path: <kvm+bounces-17880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8868CB69B
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0C751C222A2
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929A12868D;
	Wed, 22 May 2024 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JSgFE3+i"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D0C23BE;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337117; cv=none; b=M5FoCADKZuWuUNtLsA3wBfo5QCdo+hqF207hUnVxrFJZ0RySD1M58DRrzRMmhuTwCCPxhkEHPA+3rdMSMuSyxkhLvENFfdkhnjRakxHM4DcujJ8xSjkDrEz1BBK4TBwIz7Cs+BBLvgYO4IrO7Wa3FIN1xjxkP0tywvGOdvh+6Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337117; c=relaxed/simple;
	bh=KVL11mNFOe5FNqTLKijeVjwg5UuKyYE5qtUYky/f4y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ih800XFGsZhtifdKZtWecDb69zzL8MA8x0HojCY9ysU6sCke5Ub9h2DMd5hkU2NxrZZtRqbDCF6t/lPfcQCsvVE8G3UOf/BSjjLzEKn3P3w3VYaM9DIDQwFS5EwddokfuXfDIcdiSe/Tdop4muhf2Lz5ZZG4ZAv/cc+q897RtGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JSgFE3+i; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=79BDN/uYAypqTs1CgsRKyCVAI6kWKrtRRuhydi33cIU=; b=JSgFE3+icTIMsuKBoyYUY12zsI
	dhDWAZcaODw1byJCqBilCdnwDK+cwo5F77GfTZmwVbG7GiDkyt+phcO6ho52Ng4meUYqJTAusnyH3
	CmSdIxNedXOHUY4JkPwzdtBLXZVTe/S/v3MU89hzwbo1GYqlUY0bK2eWX9D8WG/A4ti6NsAVmePVe
	4ZynJ5Lg2GZpp0FB0qoSP2Np1hL+cq1Uw06hb6a5CWoXvBg7WTcectZfCWHniiClCo60uAi4mjIXE
	FpEq74A/G2GNwOt97HcooASYiJ67vpYSgq3smhmCSsdcnOcUEU6OLBZJSZ6L8VEwRJSiyoy6Vnvyy
	gawCo8iQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgT-0000000081W-18S4;
	Wed, 22 May 2024 00:18:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b5c-3lUa;
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
Subject: [RFC PATCH v3 21/21] sched/cputime: Cope with steal time going backwards or negative
Date: Wed, 22 May 2024 01:17:16 +0100
Message-ID: <20240522001817.619072-22-dwmw2@infradead.org>
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

In steal_account_process_time(), a delta is calculated between the value
returned by paravirt_steal_clock(), and this_rq()->prev_steal_time which
is assumed to be the *previous* value returned by paravirt_steal_clock().

However, instead of just assigning the newly-read value directly into
->prev_steal_time for use in the next iteration, ->prev_steal_time is
*incremented* by the calculated delta.

This used to be roughly the same, modulo conversion to jiffies and back,
until commit 807e5b80687c0 ("sched/cputime: Add steal time support to
full dynticks CPU time accounting") started clamping that delta to a
maximum of the actual time elapsed. So now, if the value returned by
paravirt_steal_clock() jumps by a large amount, instead of a *single*
period of reporting 100% steal time, the system will report 100% steal
time for as long as it takes to "catch up" with the reported value.
Which is up to 584 years.

But there is a benefit to advancing ->prev_steal_time only by the time
which was *accounted* as having been stolen. It means that any extra
time truncated by the clamping will be accounted in the next sample
period rather than lost. Given the stochastic nature of the sampling,
that is more accurate overall.

So, continue to advance ->prev_steal_time by the accounted value as
long as the delta isn't egregiously large (for which, use maxtime * 2).
If the delta is more than that, just set ->prev_steal_time directly to
the value returned by paravirt_steal_clock().

Fixes: 807e5b80687c0 ("sched/cputime: Add steal time support to full dynticks CPU time accounting")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 kernel/sched/cputime.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index af7952f12e6c..3a8a8b38966d 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -254,13 +254,21 @@ static __always_inline u64 steal_account_process_time(u64 maxtime)
 {
 #ifdef CONFIG_PARAVIRT
 	if (static_key_false(&paravirt_steal_enabled)) {
-		u64 steal;
-
-		steal = paravirt_steal_clock(smp_processor_id());
-		steal -= this_rq()->prev_steal_time;
-		steal = min(steal, maxtime);
+		u64 steal, abs_steal;
+
+		abs_steal = paravirt_steal_clock(smp_processor_id());
+		steal = abs_steal - this_rq()->prev_steal_time;
+		if (unlikely(steal > maxtime)) {
+			/*
+			 * If the delta isn't egregious, it can be counted
+			 * in the next time period. Only advance by maxtime.
+			 */
+			if (steal < maxtime * 2)
+				abs_steal = this_rq()->prev_steal_time + maxtime;
+			steal = maxtime;
+		}
 		account_steal_time(steal);
-		this_rq()->prev_steal_time += steal;
+		this_rq()->prev_steal_time = abs_steal;
 
 		return steal;
 	}
-- 
2.44.0


