Return-Path: <kvm+bounces-17875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64D858CB68C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:19:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9C7F1F229DC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6348E18B14;
	Wed, 22 May 2024 00:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EEZ1TY5w"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460001FA1;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337116; cv=none; b=JqsaHkUyXW2L1zukfWKS2IlsNAxlZwzrHJAlANOxGgfbcBE/G9LHafOQM784qgSKuk+K144Lk7qWhlZYPxmYAHnwuZC/v0qA8kUH8Mmfuu7VW4ZNRkRX9Z5wMkpROCiFf8tJHHCUuE5pHMxqExaK7FHA8zV9CD+hHuUAtMi3Y3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337116; c=relaxed/simple;
	bh=HCznYAv0EfRhddfdK9swdqfYALkzcbaaWAuEQfAFYNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKrsPKua+Vltx0q5Rti9k8RrFL18twW5iMPjDzreZPyzX8B8m4NQVo8QZLx7eeMoVLTIwItYXQ9n19dLH45c3A9L84t9UxQmyG2UKCBvDhJRddtuMqgm43P5MBiJMdZaUpfzN7CdaQa5wyETE4c4gpGynpIM4d39HbUBLK0KJBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EEZ1TY5w; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rpfo1oUoJzRPiJFA+UCmdgAFooGLVsmHebsz9FfSOoc=; b=EEZ1TY5wPykuLhCVJh5uP6hM35
	ftrXHSg0rWTUZ+E1OZFWASrHeJ06HHpuoEKMSU0S1vdRYwvc/8EJ0TbzWKRF6UF69QtcwmCIhsjTm
	2DAep9MG5iPtBH1m/3o3Cf+P4ddxHUj5knbaGqFIWzeWZXD7LbkWaZD5lRx9wkfzxT+NiV387F2QN
	NWpwQY4/NrPSDlJUOA9bM1/YxXHcV0pAo/9EJtfl9KS7iGaYJR7YLNp17D0WJWTvGQXQ6Gk7o5IWE
	TG5zaE5agJ15Oyx9p0HfTJGHCHnRnFBehvZIg3WP2qIE54+iQoO/lF6qfLKIUrX0dQQnlJ84i5h92
	Ltcl/O1g==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081I-2njD;
	Wed, 22 May 2024 00:18:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b53-1FYC;
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
Subject: [RFC PATCH v3 13/21] KVM: x86: Improve synchronization in kvm_synchronize_tsc()
Date: Wed, 22 May 2024 01:17:08 +0100
Message-ID: <20240522001817.619072-14-dwmw2@infradead.org>
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

When synchronizing to an existing TSC (either by explicitly writing zero,
or the legacy hack where the TSC is written within one second's worth of
the previously written TSC), the last_tsc_write and last_tsc_nsec values
were being misrecorded by __kvm_synchronize_tsc(). The *unsynchronized*
value of the TSC (perhaps even zero) was bring recorded, along with the
current time at which kvm_synchronize_tsc() was called. This could cause
*subsequent* writes to fail to synchronize correctly.

Fix that by resetting {data, ns} to the previous values before passing
them to __kvm_synchronize_tsc() when synchronization is detected. Except
in the case where the TSC is unstable and *has* to be synthesised from
the host clock, in which case attempt to create a nsec/tsc pair which is
on the correct line.

Furthermore, there were *three* different TSC reads used for calculating
the "current" time, all slightly different from each other. Fix that by
using kvm_get_time_and_clockread() where possible and using the same
host_tsc value in all cases.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea59694d712a..6ec43f39bdb0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -201,6 +201,10 @@ module_param(eager_page_split, bool, 0644);
 static bool __read_mostly mitigate_smt_rsb;
 module_param(mitigate_smt_rsb, bool, 0444);
 
+#ifdef CONFIG_X86_64
+static bool kvm_get_time_and_clockread(s64 *kernel_ns, u64 *tsc_timestamp);
+#endif
+
 /*
  * Restoring the host value for MSRs that are only consumed when running in
  * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
@@ -2753,14 +2757,22 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 {
 	u64 data = user_value ? *user_value : 0;
 	struct kvm *kvm = vcpu->kvm;
-	u64 offset, ns, elapsed;
+	u64 offset, host_tsc, ns, elapsed;
 	unsigned long flags;
 	bool matched = false;
 	bool synchronizing = false;
 
+#ifdef CONFIG_X86_64
+	if (!kvm_get_time_and_clockread(&ns, &host_tsc))
+#endif
+	{
+		ns = get_kvmclock_base_ns();
+		host_tsc = rdtsc();
+	}
+
 	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-	offset = kvm_compute_l1_tsc_offset(vcpu, rdtsc(), data);
-	ns = get_kvmclock_base_ns();
+
+	offset = kvm_compute_l1_tsc_offset(vcpu, host_tsc, data);
 	elapsed = ns - kvm->arch.last_tsc_nsec;
 
 	if (vcpu->arch.virtual_tsc_khz) {
@@ -2805,12 +2817,24 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
          */
 	if (synchronizing &&
 	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
+		/*
+		 * If synchronizing, the "last written" TSC value/time recorded
+		 * by __kvm_synchronize_tsc() should not change (i.e. should
+		 * be precisely the same as the existing generation)...
+		 */
+		data = kvm->arch.last_tsc_write;
+
 		if (!kvm_check_tsc_unstable()) {
 			offset = kvm->arch.cur_tsc_offset;
+			ns = kvm->arch.cur_tsc_nsec;
 		} else {
+			/*
+			 * ... unless the TSC is unstable and has to be
+			 * synthesised from the host clock in nanoseconds.
+			 */
 			u64 delta = nsec_to_cycles(vcpu, elapsed);
 			data += delta;
-			offset = kvm_compute_l1_tsc_offset(vcpu, rdtsc(), data);
+			offset = kvm_compute_l1_tsc_offset(vcpu, host_tsc, data);
 		}
 		matched = true;
 	}
-- 
2.44.0


