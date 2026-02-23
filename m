Return-Path: <kvm+bounces-71533-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eLcuC43OnGllKQQAu9opvQ
	(envelope-from <kvm+bounces-71533-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:02:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C59B17DF07
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C3A0B3088724
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F562352F9B;
	Mon, 23 Feb 2026 22:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wUj0KcU2"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B54C378D64
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 22:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884080; cv=none; b=mZA5mgRnMIQsJl+po39D956HQ5bhXG5i1jRoFDqwJ2ZKj13wVEX7+Q8PvhZ1tnTIFJ40x4qWXsteLGV+5v45wCEssBvd4dwHDJHExpa5ZvJA7tgNYp9y4r5dL6k+VlqUV0k5SSX0sj1sV5rLwsciQd5JmFKcnhNctSMe/vctdG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884080; c=relaxed/simple;
	bh=zWF+NCtRpADOtervza2C6aEMKwILmnR5dL4511kYPCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pa3urPuzpOQVFBTvsbuxiGp0oPJaqYlWYU8zvh8TDE/7TfVmVxZyxRJKN+tPAEs3Sr9r6YswHtZN2P2j/yjXO1mqYB1e+dr2KU+gLQ5lTYWxZ/dYKJcMnHwUgPj6ecUNJ3RujNKsAFGTfvafQrxtduRUvwnFXFiHaB/D1R2kjL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wUj0KcU2; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771884075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dQ83U9m/a2e/Ppu23P+Ba2u8ukzma9Tyb85B1ba0jL0=;
	b=wUj0KcU2u3twEozHnhtzONURKNXsZg1wa54+uqk7M1Cb+Q5UBE10EcRoFAf45Ri3Lh1KYe
	A0u38NwuJltTJJ1ig+ZCqoet3V276pYKLIMbW2QhjeRhpQSuIzidujmWXPCC89Fok6WTHK
	dgGazTdMymJtpd7kYAdK0Ee26PC7J3k=
From: Bart Van Assche <bart.vanassche@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 01/62] kvm: Make pi_enable_wakeup_handler() easier to analyze
Date: Mon, 23 Feb 2026 14:00:01 -0800
Message-ID: <20260223220102.2158611-2-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-1-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71533-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	RCVD_COUNT_THREE(0.00)[3];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bart.vanassche@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,acm.org:email]
X-Rspamd-Queue-Id: 9C59B17DF07
X-Rspamd-Action: no action

From: Bart Van Assche <bvanassche@acm.org>

The Clang thread-safety analyzer does not support comparing expressions
that use per_cpu(). Hence introduce a new local variable to capture the
address of a per-cpu spinlock. This patch prepares for enabling the
Clang thread-safety analyzer.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 arch/x86/kvm/vmx/posted_intr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 4a6d9a17da23..f8711b7b85a8 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -164,6 +164,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 	struct vcpu_vt *vt = to_vt(vcpu);
 	struct pi_desc old, new;
+	raw_spinlock_t *wakeup_lock;
 
 	lockdep_assert_irqs_disabled();
 
@@ -179,11 +180,11 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 	 * entirety of the sched_out critical section, i.e. the wakeup handler
 	 * can't run while the scheduler locks are held.
 	 */
-	raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu),
-			     PI_LOCK_SCHED_OUT);
+	wakeup_lock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
+	raw_spin_lock_nested(wakeup_lock, PI_LOCK_SCHED_OUT);
 	list_add_tail(&vt->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
-	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
+	raw_spin_unlock(wakeup_lock);
 
 	WARN(pi_test_sn(pi_desc), "PI descriptor SN field set before blocking");
 

