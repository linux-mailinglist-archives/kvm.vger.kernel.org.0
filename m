Return-Path: <kvm+bounces-17883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 885178CB6A0
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAC801C2236C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 00:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0075B2E414;
	Wed, 22 May 2024 00:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SCljgJWZ"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2D0256D;
	Wed, 22 May 2024 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716337117; cv=none; b=nGl09i76ImBTQMYegtLhkbmBYlpJQZkJQeQh4CHQ/vRg9oeGD+Mr/uuiwthdgCx+LDdRFU/vS7venx4MIbZfDZTPCW+nnLRsBPrGjSVnWBS9+9g7LCzMcc0ZiR/jhat19sjN5Fgo6zFqSS4wU3XxueGL01gI+z8N5MPwDtkT6Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716337117; c=relaxed/simple;
	bh=07eSngWz+9jx6RkQX35twC/OKE280FpQ1BmC8vXdBok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Weu2yjSjokuGookx6TovyHjKV4Oj4NTGsrEk6ZAkFqJWF4NJ1SGa9yjdpTXWHPDBBkfEpF2f1FO+Dcq3BslfEJmaIUj5vIokzHVWMzFGY9KV4fI4dgYDVfKMby2dohjCaI8uxY8gPn0rnLZ978Yt5xxi+KXHxkj5Sn3XnW+dFbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SCljgJWZ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OmweRF0G6hTSjtF84Zdt7iHWrVKRuTqpAbQV/jWkI40=; b=SCljgJWZsFLC7Qtev6dUm0B0+4
	Cobp7GKqulWXCxbNaAc9xTzkH1iEBupHTU89+l3WYmeXnDzDvaLI5tD0Rbao3Z2oUt0Un8E1feVX0
	+Zi/ukuO3AtgggWcyEy0vOV4tje1Kp2fR+MAA9T977tQemk4S4U2Nz0S8RZCDmTrRbBZMbHFb0w1s
	E4QNAII+wCrm1mAECjgx9y1xEWl6gI/S5Q6A8uyguI/QwiRkRBCSmlapk0O0bvT8rzvtJ0PKSbwqW
	CH2cxMM6unToJBa6hXul2fuY+eOpVOC4hiixVLIbr2n39bmhvqNnPYrp/ItQ3sbl67vfPPlhF5m24
	ipDlL/xg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-0000000081J-3NXt;
	Wed, 22 May 2024 00:18:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9ZgS-00000002b57-1eiF;
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
Subject: [RFC PATCH v3 14/21] KVM: x86: Kill cur_tsc_{nsec,offset,write} fields
Date: Wed, 22 May 2024 01:17:09 +0100
Message-ID: <20240522001817.619072-15-dwmw2@infradead.org>
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

These pointlessly duplicate the last_tsc_{nsec,offset,write} values.

The only place they were used was where the TSC is stable and a new vCPU
is being synchronized to the previous setting, in which case the 'last_'
value is definitely identical.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/x86.c              | 19 ++++++++-----------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b01c1d000fff..7d06f389a607 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1354,9 +1354,6 @@ struct kvm_arch {
 	u32 last_tsc_khz;
 	u64 last_tsc_offset;
 	u64 last_tsc_scaling_ratio;
-	u64 cur_tsc_nsec;
-	u64 cur_tsc_write;
-	u64 cur_tsc_offset;
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ec43f39bdb0..ab5d55071253 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2713,11 +2713,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	lockdep_assert_held(&kvm->arch.tsc_write_lock);
 
 	/*
-	 * We also track th most recent recorded KHZ, write and time to
-	 * allow the matching interval to be extended at each write.
+	 * Track the last recorded kHz (and associated scaling ratio for
+	 * calculating the guest TSC), and offset.
 	 */
-	kvm->arch.last_tsc_nsec = ns;
-	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
 	kvm->arch.last_tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
 	kvm->arch.last_tsc_offset = offset;
@@ -2736,10 +2734,9 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 		 *
 		 * These values are tracked in kvm->arch.cur_xxx variables.
 		 */
+		kvm->arch.last_tsc_nsec = ns;
+		kvm->arch.last_tsc_write = tsc;
 		kvm->arch.cur_tsc_generation++;
-		kvm->arch.cur_tsc_nsec = ns;
-		kvm->arch.cur_tsc_write = tsc;
-		kvm->arch.cur_tsc_offset = offset;
 		kvm->arch.nr_vcpus_matched_tsc = 0;
 	} else if (vcpu->arch.this_tsc_generation != kvm->arch.cur_tsc_generation) {
 		kvm->arch.nr_vcpus_matched_tsc++;
@@ -2747,8 +2744,8 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 
 	/* Keep track of which generation this VCPU has synchronized to */
 	vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
-	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
-	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
+	vcpu->arch.this_tsc_nsec = kvm->arch.last_tsc_nsec;
+	vcpu->arch.this_tsc_write = kvm->arch.last_tsc_write;
 
 	kvm_track_tsc_matching(vcpu);
 }
@@ -2825,8 +2822,8 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 		data = kvm->arch.last_tsc_write;
 
 		if (!kvm_check_tsc_unstable()) {
-			offset = kvm->arch.cur_tsc_offset;
-			ns = kvm->arch.cur_tsc_nsec;
+			offset = kvm->arch.last_tsc_offset;
+			ns = kvm->arch.last_tsc_nsec;
 		} else {
 			/*
 			 * ... unless the TSC is unstable and has to be
-- 
2.44.0


