Return-Path: <kvm+bounces-69027-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBMIG236c2mf0gAAu9opvQ
	(envelope-from <kvm+bounces-69027-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:47:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 149247B3C3
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:47:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 147C5306EA16
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D44D190664;
	Fri, 23 Jan 2026 22:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kgOFkDQC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4412DB7A9
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208327; cv=none; b=adEfAPV49vJYS/+3QGCRThg+ui2irycWyObs2Ej+klm0bY1gP6Ma/BXD5sZ0uJdkTEg8MgAzizMk+0CpL1RiLqz6f/c2iG0rcPdIfvFNhYAM3vB/uYNVgSIEwV6OmdRt+jfuUYVHOc4IAjGuEjH4y/CXn1fhb6i/eUKfxBqyLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208327; c=relaxed/simple;
	bh=9V0ElE/LIA1HrnEsfs19cXITptMFm7vKADHdbabnT6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TW6B/rWDc728MB76A6J8wrcireIGqaOekJmO8HSZhB6NbFXYsq79UTrtIM12BYIEqDsKXsI0+BBdpZ++fU/bVHGN2Iq4W8QU7oT7jriQEvC3WRCgUSfddW+LlWbVf45ouuLfxjgx7CdpTw9b0YC5lUEyKwo8V0dE5CsliK7RcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kgOFkDQC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a7a98ba326so28632485ad.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208324; x=1769813124; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GTDRhMyxfxwDC5vc3ZJ39I5CBO2ClzgRooXF3e1HA1E=;
        b=kgOFkDQCh1fGT/Yaa14+F/mCPRSBezB8xxjy9L3rbye66+Z5QX2TLcDCx6eeY0Ihxh
         m1B4RXOwHXHR1ITkmthKacVyMnXdzfodXrYqsnIXcX57hCGyTQIrjxeVlXqPWkZdRS1E
         TpgLxdfgyQmjLzCu+LalPM2pdwikebLYK8LxreuiLSP8Izbb/WlNxKCYK0pcbB28UytY
         fIEnTsP5tsafjXQwTVpjKFnIIvUhjW8XyylntH/H5FkXr8HY737fjqRvZtUIqmNRkR2V
         6wwSQ3HLcWgLaH5zF8DGOJLTnfsIHoyzfOWME6NZ8/4lVrXCQzOAh7nhxAfMgxt3lQKi
         Q+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208324; x=1769813124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GTDRhMyxfxwDC5vc3ZJ39I5CBO2ClzgRooXF3e1HA1E=;
        b=JG5bfUQQbJc8geRaFg3CxF7uCKUgkQIrTZUK0yPTZagdynmDESFvwdFo96Lip7XzV4
         XLd70cFTTfkhjWh3aAH8aQAl8MfZKq5X0e0OeAOXFwi8HHThbV3gV8ecqcMl0u1DE6IG
         ugwCemhOhNhmOT+Dzm2WOgaKTjdLGjhVTi/zr39RrnYSeBqY+xYewEQvQciAL9SnD+uW
         FkqPn/fjq26+4lyNofo5DcSKLWZ3ilfr/Svfuh/CcjPQPwYdV07nXm1n3pdzNQ/S5T++
         6S/M0WS1NJ4g5erx8ccFcCXqOFrRCNcXUJl7zFpwgKwpyuxTGBzdePIehtfzKYl6s0om
         L1zQ==
X-Gm-Message-State: AOJu0Yy2e3CYqC522YCfjbyCbK6Hyye6ws9Pxim1a4W4d1DOgYbLA5fw
	afKrp/6MG5ibUHmupx7Zm8gxCUB8aDGzfaJ3HQi5F21PnH/lgd8wDADRlANBaqu5tOTxWELclSi
	BXijzUA==
X-Received: from pjc6.prod.google.com ([2002:a17:90b:2f46:b0:34c:1d76:2fe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e744:b0:2a7:cb46:7069
 with SMTP id d9443c01a7336-2a7d2fbaf36mr61685695ad.25.1769208323961; Fri, 23
 Jan 2026 14:45:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:45:13 -0800
In-Reply-To: <20260123224514.2509129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123224514.2509129-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123224514.2509129-4-seanjc@google.com>
Subject: [PATCH v2 3/4] KVM: SVM: Optimize IRQ window inhibit handling
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69027-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 149247B3C3
X-Rspamd-Action: no action

IRQ windows represent times during which an IRQ can be injected into a
vCPU, and thus represent times when a vCPU is running with RFLAGS.IF=1
and GIF enabled (TPR/PPR don't matter since KVM controls interrupt
injection and it only injects one interrupt at a time). On SVM, when
emulating the local APIC (i.e., AVIC disabled), KVM detects IRQ windows
by injecting a dummy virtual interrupt through VMCB.V_IRQ and
intercepting virtual interrupts (INTERCEPT_VINTR). This intercept
triggers as soon as the guest enables interrupts and is about to take
the dummy interrupt, at which point the actual interrupt can be injected
through VMCB.EVENTINJ.

When AVIC is enabled, VMCB.V_IRQ is ignored by the hardware and so
detecting IRQ windows requires AVIC to be inhibited. However, this is
only necessary for ExtINTs since all other interrupts can be injected
either by directly setting IRR in the APIC backing page and letting the
AVIC hardware inject the interrupt into the guest, or via VMCB.V_NMI for
NMIs.

If AVIC is enabled but inhibited for some other reason, KVM has to
request for IRQ window inhibits every time it has to inject an interrupt
into the guest. This is because APICv inhibits are dynamic in nature, so
KVM has to be sure that AVIC is inhibited for purposes of discovering an
IRQ window even if the other inhibit is cleared in the meantime.

This is particularly problematic with APICV_INHIBIT_REASON_PIT_REINJ
which stays set throughout the life of the guest and results in KVM
rapidly toggling IRQ window inhibit resulting in contention on
apicv_update_lock.

Address this by setting and clearing APICV_INHIBIT_REASON_PIT_REINJ
lazily: if some other inhibit reason is already set, just increment the
IRQ window request count and do not update apicv_inhibit_reasons
immediately. If any other inhibit reason is set/cleared in the meantime,
re-evaluate APICV_INHIBIT_REASON_PIT_REINJ by checking the IRQ window
request count and update apicv_inhibit_reasons appropriately. Otherwise,
just the IRQ window request count is incremented/decremented each time
an IRQ window is requested. This reduces much of the contention on the
apicv_update_lock semaphore and does away with much of the performance
degradation.

Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2528dfffb42b..822644d23933 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10953,7 +10953,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
 
-	set_or_clear_apicv_inhibit(&new, reason, set);
+	if (reason != APICV_INHIBIT_REASON_IRQWIN)
+		set_or_clear_apicv_inhibit(&new, reason, set);
+
+	set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
+				   atomic_read(&kvm->arch.apicv_nr_irq_window_req));
 
 	if (!!old != !!new) {
 		/*
@@ -11001,6 +11005,26 @@ void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
 	if (!enable_apicv)
 		return;
 
+	/*
+	 * IRQ windows are requested either because of ExtINT injections, or
+	 * because APICv is already disabled/inhibited for another reason.
+	 * While ExtINT injections are rare and should not happen while the
+	 * vCPU is running its actual workload, it's worth avoiding thrashing
+	 * if the IRQ window is being requested because APICv is already
+	 * inhibited.  So, toggle the actual inhibit (which requires taking
+	 * the lock for write) if and only if there's no other inhibit.
+	 * kvm_set_or_clear_apicv_inhibit() always evaluates the IRQ window
+	 * count; thus the IRQ window inhibit call _will_ be lazily updated on
+	 * the next call, if it ever happens.
+	 */
+	if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
+		guard(rwsem_read)(&kvm->arch.apicv_update_lock);
+		if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
+			atomic_add(add, &kvm->arch.apicv_nr_irq_window_req);
+			return;
+		}
+	}
+
 	/*
 	 * Strictly speaking, the lock is only needed if going 0->1 or 1->0,
 	 * a la atomic_dec_and_mutex_lock.  However, ExtINTs are rare and
-- 
2.52.0.457.g6b5491de43-goog


