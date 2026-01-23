Return-Path: <kvm+bounces-68945-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6L7EKmDecmmNqgAAu9opvQ
	(envelope-from <kvm+bounces-68945-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 03:35:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3245B6FAEA
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 03:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8FEF2302EA9A
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 02:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C096352927;
	Fri, 23 Jan 2026 02:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9mbwyFG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B6314A82
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 02:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769135328; cv=none; b=JXT51vTP5LLdMyNF3RU772WVt7jtibIcqhsZqUjRgUkrt2oq0o+/O06YVDjbkKlBVV0G3JL76JjsvSjiR5NGO8p7aV0UPISEdi5FM1KO1dTUC8oNXZN+GU7SbYSHAA7oAbcW8ZWDrx36o2a1dqUeZqGwGxEU4awKV/MOffb3uRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769135328; c=relaxed/simple;
	bh=63dVKbKO3JaI73AE0k6OHvOIn2rPwCEpzEbehvxWxV0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SpM4NOYUUgSPgkraYwlgbHcqE7c1sjbCV62208NEmYJ0Lu4A9sA/W9OzHKPXRfQXSJTU9m+YV1McsLxrCEpxZTxJOAXLncTGMDsqG/3an7yd6L9pcR1xSsS2poJtEZcdb6JVTHBAnyRLm3EQgWj1Vg3tJUhF6TBgjX+whnSdtgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C9mbwyFG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6136af8e06so924128a12.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 18:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769135299; x=1769740099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=juptXMUWjnhIP87dblh4tSUOsWlzJL1NA0+WSTXGUFA=;
        b=C9mbwyFGgQvBAj3T/tLddPrt6uatxQtSjW9aL0o1qa3p6cwIRpkBm2evFXTtumCLtI
         0XvwnsXYDryEhWcslohva08aQyjeP89a7LnVQwPgPR2YWcHEPMSwD6M3b0e/TyMHe0Jt
         ZtOXKvxR9OQ/pNK4nVYy++9r/gdldSUj/ccw31LsOkVyJozFX+qH9f2PZtKRQrFojrE0
         nLfeBRkT7sa/RXC2HcH4T4eCX/37uqjwI2my6N1leriTwDyRDnt8qo78JIT5AnEHoL7F
         /n45G3uzutEDjLFdCLAcDrnXiOTFQo7os/11m/32iU/G8RcArr4ICeHlR0/99oMGfLM8
         tHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769135299; x=1769740099;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=juptXMUWjnhIP87dblh4tSUOsWlzJL1NA0+WSTXGUFA=;
        b=mKfDmIgMVQmjMb451ebU63iUd8XNIx+P9h2p7UgKvITeU3xRv3VyVgwC6wR80GRuon
         Qy01QMJWd4sYVDg2qslSNsTkK3ve+zA27fzfK4aeBdQvdgC55Kb2rKyzKGyrBPKUHxtd
         JzfX0vL6D1ZDIWzwn4zeQWVywEi1laIT6hKXkA6TXaKgWQtbbAcsy5OuLgksqa/vMwAg
         wE4+whGoT3HUuMYEWC/r4buLsvG/kWC3kh54gnwQAUTYvAFICi2xmjJRODOzriewixIL
         s5WuKQzUCbuXbWpYt7YyoHZaR30woyCWTGg7dkiHmB26+O/gDXAvpLeu8nVGm9agfnbd
         Zayg==
X-Gm-Message-State: AOJu0YwhgHk06uoMSRFqIVFvJW6lB+VyTdGHuPBFB8hVCalfyGgPiNJ/
	jToSx19uC6Ic/jp5z2byK94cPERqUpWCxKjkkM1RoOZpZs2s1kySFB3Fp+l7p9CHaWlXOlmGyK+
	7wqlGgA==
X-Received: from pgbeu11.prod.google.com ([2002:a05:6a02:478b:b0:c63:5307:a545])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:682:b0:371:7f31:17f
 with SMTP id adf61e73a8af0-38e6f863483mr1494983637.77.1769135298664; Thu, 22
 Jan 2026 18:28:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Jan 2026 18:28:16 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123022816.2283567-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Drop WARN on INIT/SIPI being blocked when vCPU is
 in Wait-For-SIPI
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68945-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm,59f2c3a3fc4f6c09b8cd];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3245B6FAEA
X-Rspamd-Action: no action

Drop the sanity check in kvm_apic_accept_events() that attempts to detect
KVM bugs by asserting that a vCPU isn't in Wait-For-SIPI if INIT/SIPI are
blocked, because if INIT is blocked, then it should be impossible for a
vCPU to get into WFS in the first place.  Unfortunately, syzbot is smarter
than KVM (and its maintainers), and circumvented the guards put in place
by commit 0fe3e8d804fd ("KVM: x86: Move INIT_RECEIVED vs. INIT/SIPI blocked
check to KVM_RUN") by swapping the order and stuffing VMXON after INIT, and
then triggering kvm_apic_accept_events() by way of KVM_GET_MP_STATE.

Simply drop the WARN as it hasn't detected any meaningful KVM bugs in
years (if ever?), and preventing userspace from clobbering guest state is
generally a non-goal.  More importantly, fully closing the hole would
likely require enforcing some amount of ordering in KVM's ioctls, which is
a much bigger risk than simply deleting the WARN.

Reported-by: syzbot+59f2c3a3fc4f6c09b8cd@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6925da1b.a70a0220.d98e3.00b0.GAE@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2e513f1c8988..46ba9df3b81d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3487,7 +3487,6 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	 * wait-for-SIPI (WFS).
 	 */
 	if (!kvm_apic_init_sipi_allowed(vcpu)) {
-		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
 		return 0;
 	}

base-commit: acdc5446135932ca974b82d9d9a17762c7a82493
-- 
2.52.0.457.g6b5491de43-goog


