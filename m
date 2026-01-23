Return-Path: <kvm+bounces-69025-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yFHCBS/6c2mf0gAAu9opvQ
	(envelope-from <kvm+bounces-69025-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:46:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA0F7B3AB
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2270D303D2D6
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7278D2D780C;
	Fri, 23 Jan 2026 22:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pLbnHm7w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8542BE03B
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208322; cv=none; b=omWQyW/OL1hn3toe4Z/NHwgb7q1caabmOjuR5M49/XJYdYK1aB2HqYJ+q89XrNp7pNx9QwqQOfJnwIRS2FV1dy1rhazYCBf/244opjHph5KkqsDn+3V6U+NPcI/el0LFxr8FMl2udf2EiHXodF9UmG2iJ61YNAh1eMw0vYd+GNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208322; c=relaxed/simple;
	bh=AiqWO8SpVo62e8X1WEFA3hq64LuUmaVr6HZPgUvbHnw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iIRFlqbiRmxvzG6O8+hDhr6HNws910chTHcTgRxV24iAc2NHbwnr1x0XEocE6axobyBrO1MTOuT6zAk/eLhGDFv/qubQT0Lp74TO0ser2Ls6qSqTivsERCqmyBNx6es2lHWaR+qSjK3yQpWJ8oDLeT8tUcu33gK/P4sfPVniWEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pLbnHm7w; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-352c7924ebcso2320503a91.3
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208320; x=1769813120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DgWvnMczPCtvjTL6g2NKbG8isQMgrKZUrFDimvKoHZM=;
        b=pLbnHm7w7faLELo+w27aFoHI3BlzJE07On7PeezbqLkXUW6c7vsGnnTlQYuFLxATtd
         HGL6F3dTtFqSr9EbeOGa6gxIaBIt17YXjawf1LY0G8bAG3YDZLOxECOPcb5d4hnOueZJ
         jr33yfQBVIjmCEHytJcHUh4wwgmrkSwBDboZ+yJN8zRVXdJLUFb4G9cr7hW4eYz6nVES
         efsQEQrpxte3Fl7/FZgd4F3+Vlc3rXa+xqOcxk/h2GQtsObCHEvBCx6PEUIQqS/V8L+u
         JSLqUX50Pv5ecx6ffiJ5ULkKBKr1jxbiu5yuqdpLucOaGilrH6oZoUkc73NWBZU+vUTi
         ELWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208320; x=1769813120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DgWvnMczPCtvjTL6g2NKbG8isQMgrKZUrFDimvKoHZM=;
        b=wzmKaQcNKPzD6s+k6YqVRLSJdFxZfGgzJZ2ZLFzQ04BoM8+K4u75izfcqnmY67Qi5f
         4lCjqE2j0geKK3UwiVCuoy+/OVkxdqRUmwZSvrAaJQMzUYTe09VxW4zOOR7v7pJPtUcw
         0GniU/7Lz9HKUiOQTSlxcyUz2KHihcdYiq0kgcDYafMpYWUPLUPb6ENWwOXF0Bb7M+y3
         lW0p40ucVQokQB6HH9q0jkylwfLrSDIrufpd1nICLLCAJuAY6huwe28a3B81CawCdRCc
         IWKzH2W0LYb+WlZsstTMLld99I+CLQwYmEOa89ANLHGNgs0EaHrqTWs4WhIs8dUSp1dA
         pWCw==
X-Gm-Message-State: AOJu0Yx26+eYAkYXlcYw/bGoV6nUnA3Y7r+Dfel+LctKeGfA+ASGV3Hy
	51LJF5yMgtcuojsh4/STAEv6Paw9jHU3KGjyBNqk7WzsuXKg+RaIiPUEJBt7Ozzvf9N4KHOdFXw
	P30Kqog==
X-Received: from pjbmi1.prod.google.com ([2002:a17:90b:4b41:b0:34c:2f02:7f5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b4a:b0:33f:eca0:47c6
 with SMTP id 98e67ed59e1d1-3536911dbefmr3269951a91.30.1769208320265; Fri, 23
 Jan 2026 14:45:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:45:11 -0800
In-Reply-To: <20260123224514.2509129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123224514.2509129-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123224514.2509129-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: SVM: Fix clearing IRQ window inhibit with nested guests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69025-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 6DA0F7B3AB
X-Rspamd-Action: no action

Clearing IRQ window inhibit today relies on interrupt window
interception, but that is not always reachable when nested guests are
involved.

If L1 is intercepting IRQs, then interrupt_window_interception() will
never be reached while L2 is active, because the only reason KVM
would set the V_IRQ intercept in vmcb02 would be on behalf of L1, i.e.
because of vmcb12.  svm_clear_vintr() always operates on (at least)
vmcb01, and VMRUN unconditionally sets GIF=1, which means that
enter_svm_guest_mode() will always do svm_clear_vintr() via
svm_set_gif(svm, true). I.e. KVM will keep the VM-wide inhibit set until
control transfers back to L1 *and* an interrupt window is triggered.

If L1 is not intercepting IRQs, KVM may immediately inject L1's ExtINT
into L2 if IRQs are enabled in L2 without taking an interrupt window
interception.

Address this by clearing the IRQ window inhibit when KVM actually
injects an interrupt and there are no further injectable interrupts.
That way, if L1 isn't intercepting IRQs, KVM will drop the inhibit as
soon as an interrupt is injected into L2. And if L1 is intercepting
IRQs, KVM will keep the inhibit until the IRQ is injected into L2. So,
AVIC won't be left inhibited.

Note, somewhat blindly invoking kvm_clear_apicv_inhibit() is both wrong
and suboptimal.  If the IRQWIN inhibit isn't set, then the vCPU will
unnecessarily take apicv_update_lock for write.  And if a _different_ vCPU
has an injectable IRQ, clearing IRQWIN may block that vCPU's ability to
inject its IRQ.  Defer fixing both issues to a future commit, as fixing
one problem without also fixing the other would also leave KVM in a
temporarily bad state, as would fixing both issues without fixing _this_
bug.  I.e. it's not feasible to fix each bug independently without there
being some remaining flaw in KVM.

Co-developed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7803d2781144..24b9c2275821 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3130,20 +3130,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	svm_clear_vintr(to_svm(vcpu));
 
-	/*
-	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
-	 * In this case AVIC was temporarily disabled for
-	 * requesting the IRQ window and we have to re-enable it.
-	 *
-	 * If running nested, still remove the VM wide AVIC inhibit to
-	 * support case in which the interrupt window was requested when the
-	 * vCPU was not running nested.
-
-	 * All vCPUs which run still run nested, will remain to have their
-	 * AVIC still inhibited due to per-cpu AVIC inhibition.
-	 */
-	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
-
 	++vcpu->stat.irq_window_exits;
 	return 1;
 }
@@ -3732,6 +3718,20 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
+	/*
+	 * If AVIC was inhibited in order to detect an IRQ window, and there's
+	 * no other injectable interrupts pending or L2 is active (see below),
+	 * then drop the inhibit as the window has served its purpose.
+	 *
+	 * If L2 is active, this path is reachable if L1 is not intercepting
+	 * IRQs, i.e. if KVM is injecting L1 IRQs into L2.  AVIC is locally
+	 * inhibited while L2 is active; drop the VM-wide inhibit to optimize
+	 * the case in which the interrupt window was requested while L1 was
+	 * active (the vCPU was not running nested).
+	 */
+	if (!kvm_cpu_has_injectable_intr(vcpu) || is_guest_mode(vcpu))
+		kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+
 	trace_kvm_inj_virq(intr->nr, intr->soft, reinjected);
 	++vcpu->stat.irq_injections;
 
-- 
2.52.0.457.g6b5491de43-goog


