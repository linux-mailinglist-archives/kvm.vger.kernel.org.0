Return-Path: <kvm+bounces-66302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F52ACCE698
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 05:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA641301A1A3
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 04:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D582D3225;
	Fri, 19 Dec 2025 03:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrHAQ4/q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDF02C327D
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 03:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766116452; cv=none; b=tUFMUIDwoAuHnCQ/mwWeiUAzAE4cQ2lBpDhclCGqJLt40uROJQ2zeULsHHQBWZjDt44AOtLxuEiEgn3hnRf2HeZ8PjEcENXXf7KKhMYcuAPM2J1iOxohhVbgI0KrloPgdGk7hUdIP+nbCzNirvlvAaM13REKrBFZvE0j7lnjBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766116452; c=relaxed/simple;
	bh=Vm1yvhrALThablxTgf2Bk66kAYF/A5K0Ayh/8yyyxiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmtH9woMa7SXVFAUbUAZjQ0Rqm3z1Etc982zW6QyyAjHrWJgeYEDYgzhtV7+TR35G3BL8CBpV5zRDbvSs+Q+wmkDHIKsnWj8KjC9eNMfCfNCGCHT1tFEiSu8DACpS8BBlZ0Ou+Tj855fpObPQGyd6Nl1jS1Wcska1tkuL+OjtHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrHAQ4/q; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0b4320665so20100455ad.1
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 19:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766116450; x=1766721250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amuilco9pGT1STDJq/nTPkMUszn8Ukw2dbEwnl20qH0=;
        b=VrHAQ4/q6It+YU9HqJXDP8r7MkeSI8kDEfm6mTMPLKdJqRUeooqE46oBttXtqHYVD5
         M+Uob9M4u9DKBTeeXz6aLRXjGJa9byJGBh01jgIK2eaS1jMKOaMFdof3hSlp8kXpLPZ+
         qkXhmF5wXjdrPuhnesG2InHXdeKqRG6ClKDWZ5zV5Iqb1B+RDZdZDampoDmqUN6QVHlc
         JCUA9EDVXPisMNEz3827zz3+EBeYck3qOkn+HKiZyAaF0G7/OutzTHXyDFCv761/knGU
         hYZzvrl3BvKc6QrisnxFtDFfr2Bh4NrzXxWUTBrn8eRNS0DH4dXSI0LAqW2bOk03XS2t
         27pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766116450; x=1766721250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=amuilco9pGT1STDJq/nTPkMUszn8Ukw2dbEwnl20qH0=;
        b=G4rjcDU1KWRnyTRG0lv9E3duSJNE50yR+lbZrwtInweECWzTpRsPYqmEwDosRvf4q2
         l59rSkuro1lZJueHWc9qCLmzKps1QObAVBhZ/6VgtsOmmCjtaV2FlCchwlc1fEBEg/59
         0b8MjMNPDhMvT4k+kmqokLDynzEHaeDJJ8nTIam5DmPTevtGn/zDI2jYPxkYeqzqGlEL
         cgdgsyFRZGi1qZ9jpugdyEc3lnB0cM6kaFIhOpAOycgGgDRPkds/rPB4wHL2+dWFQWKF
         zrUYVy6FccyDNmGKWBVKhstp8y3oTOqEUfRUzxSJkMHRKXJms7qQYcR0DaKRXFy8D4wd
         BVHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa77mF/LAh01mKymsm2uy0/Bl8wgP+sHR1Tq0bvVqa7Tw/ECfqVSUaGHnWilpUPg7YMIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywrfch/4e0QCA22l699MuGC/OOX2jMNqbX/DCoa7xmRTR9Crp74
	EnpFIRWdNfK4uSyoerqKk8r72EIlAA14lOVbL8ABYs4+u6/90FdAzHdY
X-Gm-Gg: AY/fxX7xIO4YDGwV0e+gpDVaP8BAOr3Lsp1vgQf/39+czCaS7V40OzoGY0qi3+Z882O
	1q3boQ/R9mGuUTGUkgpD0CZMVIIlnXoeaIZJ+xavPjQWuR9/P6ow14iBFnAMPT3tK/qxnQQC5JN
	bAoeLad/I4XEwPsvtB/XD1epxl/z0z62z+4MJEbTJVCikiTzwJ5UXlN28XvAr1R5kZahoLIdFUg
	9kRaWsVEiaDgJhnjuTurpDdKWvcUug2dTyI12ZKU5vCX65r1Kb11z7TrHQ+k1PoT3+OBBxNt6RR
	GiuaiEkUoVVvoxamDAwDAGiW1+7apXyR6Dm5iezA2oboNU5EP4OHB4rZiNLR2WUdZN+huWthh0z
	Ajgzr/xuqoPaFq6i8WaTYJOdwjILwS+aQAtNDeDq76w1p3/AVIyi9APZrU0wvEXbodpTXgxAJmg
	U8zOLSR1AB4Q==
X-Google-Smtp-Source: AGHT+IGU7h1ZB61bV1O9bR0i7f90SpjRR6d9sACghaf5ssfNNxyJmctob1L6dzPqjLfMJm/y/IKHBA==
X-Received: by 2002:a17:902:db12:b0:2a0:9040:6377 with SMTP id d9443c01a7336-2a2f242aaddmr14800655ad.18.1766116449999;
        Thu, 18 Dec 2025 19:54:09 -0800 (PST)
Received: from wanpengli.. ([175.170.92.22])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d4d36esm7368135ad.63.2025.12.18.19.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 19:54:09 -0800 (PST)
From: Wanpeng Li <kernellwp@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v2 8/9] KVM: Implement IPI-aware directed yield candidate selection
Date: Fri, 19 Dec 2025 11:53:32 +0800
Message-ID: <20251219035334.39790-9-kernellwp@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251219035334.39790-1-kernellwp@gmail.com>
References: <20251219035334.39790-1-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wanpeng Li <wanpengli@tencent.com>

Integrate IPI tracking with directed yield to improve scheduling when
vCPUs spin waiting for IPI responses.

Implement priority-based candidate selection in kvm_vcpu_on_spin()
with three tiers:

Priority 1: Use kvm_vcpu_is_ipi_receiver() to identify confirmed IPI
targets within the recency window, addressing lock holders spinning
on IPI acknowledgment.

Priority 2: Leverage existing kvm_arch_dy_has_pending_interrupt() for
compatibility with arch-specific fast paths.

Priority 3: Fall back to conventional preemption-based logic when
yield_to_kernel_mode is requested, providing a safety net for non-IPI
scenarios.

Add kvm_vcpu_is_good_yield_candidate() helper to consolidate these
checks, preventing over-aggressive boosting while enabling targeted
optimization when IPI patterns are detected.

Performance testing (16 pCPUs host, 16 vCPUs/VM):

Dedup (simlarge):
  2 VMs: +47.1% throughput
  3 VMs: +28.1% throughput
  4 VMs:  +1.7% throughput

VIPS (simlarge):
  2 VMs: +26.2% throughput
  3 VMs: +12.7% throughput
  4 VMs:  +6.0% throughput

Gains stem from effective directed yield when vCPUs spin on IPI
delivery, reducing synchronization overhead. The improvement is most
pronounced at moderate overcommit (2-3 VMs) where contention reduction
outweighs context switching cost.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/kvm_main.c | 46 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ff771a872c6d..45ede950314b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3970,6 +3970,41 @@ bool __weak kvm_vcpu_is_ipi_receiver(struct kvm_vcpu *sender,
 	return false;
 }
 
+/*
+ * IPI-aware candidate selection for directed yield.
+ *
+ * Priority order:
+ *  1) Confirmed IPI receiver of 'me' within recency window (always boost)
+ *  2) Arch-provided fast pending interrupt hint (user-mode boost)
+ *  3) Kernel-mode yield: preempted-in-kernel vCPU (traditional boost)
+ *  4) Otherwise, be conservative and skip
+ */
+static bool kvm_vcpu_is_good_yield_candidate(struct kvm_vcpu *me,
+					     struct kvm_vcpu *vcpu,
+					     bool yield_to_kernel_mode)
+{
+	/* Priority 1: recently targeted IPI receiver */
+	if (kvm_vcpu_is_ipi_receiver(me, vcpu))
+		return true;
+
+	/* Priority 2: fast pending-interrupt hint (arch-specific) */
+	if (kvm_arch_dy_has_pending_interrupt(vcpu))
+		return true;
+
+	/*
+	 * Minimal preempted gate for remaining cases:
+	 * Require that the target has been preempted, and if yielding to
+	 * kernel mode, additionally require preempted-in-kernel.
+	 */
+	if (!READ_ONCE(vcpu->preempted))
+		return false;
+
+	if (yield_to_kernel_mode && !kvm_arch_vcpu_preempted_in_kernel(vcpu))
+		return false;
+
+	return true;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	int nr_vcpus, start, i, idx, yielded;
@@ -4017,15 +4052,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 		if (kvm_vcpu_is_blocking(vcpu) && !vcpu_dy_runnable(vcpu))
 			continue;
 
-		/*
-		 * Treat the target vCPU as being in-kernel if it has a pending
-		 * interrupt, as the vCPU trying to yield may be spinning
-		 * waiting on IPI delivery, i.e. the target vCPU is in-kernel
-		 * for the purposes of directed yield.
-		 */
-		if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
-		    !kvm_arch_dy_has_pending_interrupt(vcpu) &&
-		    !kvm_arch_vcpu_preempted_in_kernel(vcpu))
+		/* IPI-aware candidate selection */
+		if (!kvm_vcpu_is_good_yield_candidate(me, vcpu, yield_to_kernel_mode))
 			continue;
 
 		if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
-- 
2.43.0


