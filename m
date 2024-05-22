Return-Path: <kvm+bounces-17877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C48C8CB698
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3326E2839DD
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EB62557F;
	Wed, 22 May 2024 00:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lp8+UIrh"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD6A1859;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337116; cv=none; b=nBO7A9zCXSxNK3IBIOMqrsUhc1FSd7kiHLCl5BORoYtmmE91AdIYJewm0MYgjKAxNCZmwQOUZUqIAczpywaRTOEUdxaIdcVKGIdVc2NUVrsb4UJ5nLMIaeVb9xScRt4KgBiuAfPSa5R6En5pdhiJCRTTiSUpUzbcVpvo12twi24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337116; c=relaxed/simple;
	bh=mwKQQD8/+RYFodyxB6WV+wW8JDfeqo6IS57yFs+a5y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs56dqdX/KUVxmHI0pPYI5MYvJG2xOMMtSd4i+lIdKFq4wRwOebiY4F3Dac2SLqYCsCI7JETZBebxkSAm0HpKhjZItV40zlVS9aYYQSM4QNCEHVJfNnMv5XwrCyQHuPLC1CbOO5irJzdSaB4O85zLKEgNB3Py6ava6vaeWF0DZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lp8+UIrh; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=07Y/gmhH+tDbkleYF4YdcC7uHOHG3j1TevROlC+ybZw=; b=lp8+UIrhY0uk+s4nzCKz1chSd1
	aiez4Mf+p5x7mPwrSKmuq9YxGQG5onWFTTsYHmG1eM7mJON4j0J0NB0BYC9JN2XuOGBE8JJ2uNRr6
	atomFV4C4iHDX9dM/4rAmI24h7At7/5kucU3kX/Z9MnYUmToAgdGMWT6Dg+qiTbi7x81h2gDfdmdE
	/0Ilv3xV/SoIP95syynuoFZM2J73BdoclasrzHw/W+4OwwXWuwW7XYf65U+Uu26cMkzIu3me7kbhG
	KutKz4AFe7bxDkurif4fv9sSXrVlN9dO8IugCqpSVE9hJpSNMAdXOwin04ritUH1G+wy+65xidz+n
	nRvIrbLw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081G-1oWQ;
	Wed, 22 May 2024 00:18:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b4o-0X19;
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
Subject: [RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
Date: Wed, 22 May 2024 01:17:05 +0100
Message-ID: <20240522001817.619072-11-dwmw2@infradead.org>
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

There was some confusion in kvm_update_guest_time() when software needs
to advance the guest TSC.

In master clock mode, there are two points of time which need to be taken
into account. First there is the master clock reference point, stored in
kvm->arch.master_kernel_ns (and associated host TSC ->master_cycle_now).
Secondly, there is the time *now*, at the point kvm_update_guest_time()
is being called.

With software TSC upscaling, the guest TSC is getting further and further
ahead of the host TSC as time elapses. So at time "now", the guest TSC
should be further ahead of the host, than it was at master_kernel_ns.

The adjustment in kvm_update_guest_time() was not taking that into
account, and was only advancing the guest TSC by the appropriate amount
for master_kernel_ns, *not* the current time.

Fix it to calculate them both correctly.

Since the KVM clock reference point in master_kernel_ns might actually
be *earlier* than the reference point used for the guest TSC
(vcpu->last_tsc_nsec), this might lead to a negative delta. Fix the
compute_guest_tsc() function to cope with negative numbers, which
then means there is no need to force a master clock update when the
guest TSC is written.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/x86.c | 73 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89918ba266cd..e09dc44978ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2491,10 +2491,19 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
-	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
-				      vcpu->arch.virtual_tsc_mult,
-				      vcpu->arch.virtual_tsc_shift);
-	tsc += vcpu->arch.this_tsc_write;
+	s64 delta = kernel_ns - vcpu->arch.this_tsc_nsec;
+	u64 tsc = vcpu->arch.this_tsc_write;
+
+	/* pvclock_scale_delta cannot cope with negative deltas */
+	if (delta >= 0)
+		tsc += pvclock_scale_delta(delta,
+					   vcpu->arch.virtual_tsc_mult,
+					   vcpu->arch.virtual_tsc_shift);
+	else
+		tsc -= pvclock_scale_delta(-delta,
+					   vcpu->arch.virtual_tsc_mult,
+					   vcpu->arch.virtual_tsc_shift);
+
 	return tsc;
 }
 
@@ -2505,7 +2514,7 @@ static inline bool gtod_is_based_on_tsc(int mode)
 }
 #endif
 
-static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
+static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
 	struct kvm_arch *ka = &vcpu->kvm->arch;
@@ -2522,12 +2531,9 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
 
 	/*
 	 * Request a masterclock update if the masterclock needs to be toggled
-	 * on/off, or when starting a new generation and the masterclock is
-	 * enabled (compute_guest_tsc() requires the masterclock snapshot to be
-	 * taken _after_ the new generation is created).
+	 * on/off.
 	 */
-	if ((ka->use_master_clock && new_generation) ||
-	    (ka->use_master_clock != use_master_clock))
+	if ((ka->use_master_clock != use_master_clock))
 		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 
 	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
@@ -2705,7 +2711,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
-	kvm_track_tsc_matching(vcpu, !matched);
+	kvm_track_tsc_matching(vcpu);
 }
 
 static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
@@ -3300,8 +3306,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		kernel_ns = get_kvmclock_base_ns();
 	}
 
-	tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
-
 	/*
 	 * We may have to catch up the TSC to match elapsed wall clock
 	 * time for two reasons, even if kvmclock is used.
@@ -3313,11 +3317,46 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 *	very slowly.
 	 */
 	if (vcpu->tsc_catchup) {
-		u64 tsc = compute_guest_tsc(v, kernel_ns);
-		if (tsc > tsc_timestamp) {
-			adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
-			tsc_timestamp = tsc;
+		uint64_t now_host_tsc, now_guest_tsc;
+		int64_t adjustment;
+
+		/*
+		 * First, calculate what the guest TSC should be at the
+		 * time (kernel_ns) which will be placed in the hvclock.
+		 * This may be the *current* time, or it may be the time
+		 * of the master clock reference. This is 'tsc_timestamp'.
+		 */
+		tsc_timestamp = compute_guest_tsc(v, kernel_ns);
+
+		now_guest_tsc = tsc_timestamp;
+		now_host_tsc = host_tsc;
+
+#ifdef CONFIG_X86_64
+		/*
+		 * If the master clock was used, calculate what the guest
+		 * TSC should be *now* in order to advance to that.
+		 */
+		if (use_master_clock) {
+			int64_t now_kernel_ns;
+
+			if (!kvm_get_time_and_clockread(&now_kernel_ns,
+							&now_host_tsc)) {
+				now_kernel_ns = get_kvmclock_base_ns();
+				now_host_tsc = rdtsc();
+			}
+			now_guest_tsc = compute_guest_tsc(v, now_kernel_ns);
 		}
+#endif
+		/*
+		 * Calculate the delta between what the guest TSC *should* be,
+		 * and what it actually is according to kvm_read_l1_tsc().
+		 */
+		adjustment = now_guest_tsc - kvm_read_l1_tsc(v, now_host_tsc);
+
+		if (adjustment > 0)
+			adjust_tsc_offset_guest(v, adjustment);
+	} else {
+		tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
 	}
 
 	local_irq_restore(flags);
-- 
2.44.0


