Return-Path: <kvm+bounces-38481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 453B2A3A971
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E28D918983E7
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36091DE2BF;
	Tue, 18 Feb 2025 20:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nqxbP0nA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262091DE2B9;
	Tue, 18 Feb 2025 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.48.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910431; cv=none; b=AUqIIcuBJnOwDQjU6zgsufLp188jaIDc3qanC8+jb+TfGJ738Ujqnp0B30AMqzO9jUUa65OIBGPvMudd250lo7M0xRZTU5LsFMITyKeDBk/m/9e9XsG4IgwQYHvCugU1ItiEYLoGXyYRaMWQ+qfNjqyR+qIfn4bukDwTJlEGvZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910431; c=relaxed/simple;
	bh=3de8aP+eKUaiXgy4IvoYG4PKo51UnJ/CXdIDrpzv854=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ke9zcEsta5xL6yF6VuDW5aAYiW5CW/tWy7OCDCxf54uExz7/sk4TRXvqeguClym9+QxhfYterFgqOs/eBQsKcrgD+Oea+XeEQAjPYjj8SrT0WR5Bx/Mk/hdEPGiyNu1bY75N//KHkayl9ga97xiGUk1tAiL7E5HsZfgRmOP6QaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=nqxbP0nA; arc=none smtp.client-ip=52.95.48.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739910430; x=1771446430;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=UA7rd2+7E7E1EZQdxivdBtDuy5hSlsFld3c3zvaH5Do=;
  b=nqxbP0nA7FtVbrtesoyI42pvcZGFu4xZV5g66t54PlHrWz9D0t4pE0LA
   7KyiPlPN+HcnpXqSy1JxEANWz+Lclxag27vwWp6rVDjSmH021Lz3QBUwu
   PtCD5BxzKqQBeXh7qZ4vGaNGp9qmOO9LBgDr6SJu3fCorx/EfkC47sYu/
   I=;
X-IronPort-AV: E=Sophos;i="6.13,296,1732579200"; 
   d="scan'208";a="463706639"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 20:27:07 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:15387]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.2.102:2525] with esmtp (Farcaster)
 id 0fd69873-b657-487e-899c-6f013894b1e5; Tue, 18 Feb 2025 20:27:06 +0000 (UTC)
X-Farcaster-Flow-ID: 0fd69873-b657-487e-899c-6f013894b1e5
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 18 Feb 2025 20:27:05 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.227) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 18 Feb 2025 20:27:00 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <sieberf@amazon.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 2/3] kvm/x86: Add support for gtime halted
Date: Tue, 18 Feb 2025 22:26:02 +0200
Message-ID: <20250218202618.567363-3-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250218202618.567363-1-sieberf@amazon.com>
References: <20250218202618.567363-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The previous commit introduced the concept of guest time halted to allow
the hypervisor to track real guest CPU activity (halted cyles) with
mwait/hlt/pause pass through enabled.

This commits implements it for the x86 architecture. We track the number of
actual cycles executed by the guest by taking two reads on MSR_IA32_MPERF,
one before vcpu enter and the other after vcpu exit. These two reads happen
immediately before and after guest_timing_enter/exit_irqoff which are the
architecture independent points for gtime accounting. The difference between
the reads corresponds to the number of unhalted cycles. We get the number
of halted cycles by using the tsc difference with the unhalted cycles and
tolerate slight approximations.
---
 arch/x86/include/asm/tsc.h |  1 +
 arch/x86/kernel/tsc.c      | 13 +++++++++++++
 arch/x86/kvm/x86.c         | 26 ++++++++++++++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94408a784c8e..00ad09e7268e 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -37,6 +37,7 @@ extern void mark_tsc_async_resets(char *reason);
 extern unsigned long native_calibrate_cpu_early(void);
 extern unsigned long native_calibrate_tsc(void);
 extern unsigned long long native_sched_clock_from_tsc(u64 tsc);
+extern unsigned long long cycles2ns(unsigned long long cycles);

 extern int tsc_clocksource_reliable;
 #ifdef CONFIG_X86_TSC
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 34dec0b72ea8..80bb12357148 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -144,6 +144,19 @@ static __always_inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	return ns;
 }

+unsigned long long cycles2ns(unsigned long long cyc)
+{
+       struct cyc2ns_data data;
+       unsigned long long ns;
+
+       cyc2ns_read_begin(&data);
+       ns = mul_u64_u32_shr(cyc, data.cyc2ns_mul, data.cyc2ns_shift);
+       cyc2ns_read_end();
+
+       return ns;
+}
+EXPORT_SYMBOL(cycles2ns);
+
 static void __set_cyc2ns_scale(unsigned long khz, int cpu, unsigned long long tsc_now)
 {
 	unsigned long long ns_now;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02159c967d29..46975b0a63a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10688,6 +10688,19 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 	kvm_x86_call(set_apic_access_page_addr)(vcpu);
 }

+static bool needs_halted_accounting(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->kvm->arch.mwait_in_guest ||
+			vcpu->kvm->arch.hlt_in_guest ||
+			vcpu->kvm->arch.pause_in_guest) &&
+		boot_cpu_has(X86_FEATURE_APERFMPERF);
+}
+
+static long long get_unhalted_cycles(void)
+{
+	return __rdmsr(MSR_IA32_MPERF);
+}
+
 /*
  * Called within kvm->srcu read side.
  * Returns 1 to let vcpu_run() continue the guest execution loop without
@@ -10697,6 +10710,8 @@ static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 {
 	int r;
+	unsigned long long cycles, cycles_start = 0;
+	unsigned long long unhalted_cycles, unhalted_cycles_start = 0;
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
@@ -10968,6 +10983,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}

+	if (needs_halted_accounting(vcpu)) {
+		cycles_start = get_cycles();
+		unhalted_cycles_start = get_unhalted_cycles();
+	}
 	guest_timing_enter_irqoff();

 	for (;;) {
@@ -11060,6 +11079,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * acceptable for all known use cases.
 	 */
 	guest_timing_exit_irqoff();
+	if (needs_halted_accounting(vcpu)) {
+		cycles = get_cycles() - cycles_start;
+		unhalted_cycles = get_unhalted_cycles() -
+			unhalted_cycles_start;
+		if (likely(cycles > unhalted_cycles))
+			current->gtime_halted += cycles2ns(cycles - unhalted_cycles);
+	}

 	local_irq_enable();
 	preempt_enable();
--
2.43.0




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


