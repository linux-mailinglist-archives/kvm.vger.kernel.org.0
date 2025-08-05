Return-Path: <kvm+bounces-54039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F8FB1BAA0
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E26193AAE6A
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A7F29E110;
	Tue,  5 Aug 2025 19:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bopbRLrb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9F529DB64
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420742; cv=none; b=XRa7q75zkYdVU8nyBgOe/3EL+ohJejamMQ6gEYIW6zt8kNdIaI5s2UCzLGI9gg5RL/01ayvw4H44eli8uNTrc9uXDFPDFP1WrafPHvzFv5RipzhQmMUo6dxd4z+0qPXttAJFglBEMDtPJcRC2mxa8GrvpDue7zqa5nRDEEFPODc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420742; c=relaxed/simple;
	bh=J3s/+HhO0F/23Anh4HAPKQwoROmPWYLeSlo9ij8W49k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rYyEEDgwFuUey5gVwEZFw59dEGleyTC23C4xKgyvCg7c0hmv7wjRPwNaFlxXX3TXSNlYAp48OsNDSkMcDcAzL88r9spYb5SIMT8vxdCW3UTL87nsQ6FFH/3WVbkFHR2KlMNX2ks7TgsePWebFM1AJeXBf/XHgxW34clGEyZ/McM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bopbRLrb; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31eac278794so6046136a91.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420740; x=1755025540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=YozS3xn+VACq0+w8nwexO84fpxAPR1pw7uiWTT6tQo0=;
        b=bopbRLrbATJsDSF+5lYLguL8c8CmxJt/VQ/HEmlpupSzTlWWeNkU9kgoeXuekeQwfO
         S22at6wVdzLfonQlBb+gGP1N9nBnxlSMn246rNaBq+sazuP6nbrZapRoAH2g7N8gZdVC
         XUWoW3oZaa3Utn1lwGpARjrM31+rxrhbFYtg9dcKUUP888lzLKi3Ztk030aGdO8wiB3b
         4ERFyLJ2o8PYK2zHmv4cvPlVWy91cWtUk7AlKkwJN3TDbuVCLEKGfFfaVW8289pyILVk
         gRYkSC9DyXkAv57ZyOKPkLmNJOzzB5ePPfT85oVNQpwE2pbpB0D532CBj7dV9nUp3431
         2LOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420740; x=1755025540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YozS3xn+VACq0+w8nwexO84fpxAPR1pw7uiWTT6tQo0=;
        b=RJfCjGRaCJYMRCeDtwnAttnDX8BC12JF8w6GJS6jf4o0/GuzUVDOjPF7lneZ4xQ2EE
         tcF00q3dfGlWQPaTbmfKKnFXiXNotIq5LmYD6E627RJPZpoziNT1WfwxD2l07MmtgQ9P
         clEqN2gTnv6f2ZRt4ytBi3dXxK0SHK+yc8j04x9yf5I+6h26peDsUFNTmqafOOefjVjX
         /45J2xFjx6/jY65xZfjwq6EJbkOnkntkUCzn7HKzwlPG4eT/EJLFEMTEgi2Oi+EtF/cz
         Z+kGHOl4ng8iQMCVHL43c+sNALGrHHxT4psyNm9hOcqS8HozTerbcKmg3nB79lQTHFVY
         IFpQ==
X-Gm-Message-State: AOJu0YwX3CUuQsJWbhCL9UuruOfNQkDTu23TaOn2xOfBzkNmeEpUL+4w
	jTqfidApk7PJLvAB0FXL/qqx0okoVD3BFr/ZRSk5LPIYt3jlS2ONpOCrLLpKawpKWTfBc45de9T
	R248I9Q==
X-Google-Smtp-Source: AGHT+IHQCIBBLF4UPzRODvXLUW1O4/zaAQuZxCWjMgyqDmJ4I9AAEjiuFfAHOHrKIvXYXsSDfb0p1J6tmDo=
X-Received: from pjro3.prod.google.com ([2002:a17:90a:b883:b0:320:e3b2:68de])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c2:b0:321:59e7:c5c2
 with SMTP id 98e67ed59e1d1-32159e7c6d8mr3836032a91.9.1754420739953; Tue, 05
 Aug 2025 12:05:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:14 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-7-seanjc@google.com>
Subject: [PATCH 06/18] KVM: x86: Acquire SRCU in WRMSR fastpath iff
 instruction needs to be skipped
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Acquire SRCU in the WRMSR fastpath if and only if an instruction needs to
be skipped, i.e. only if the fastpath succeeds.  The reasoning in commit
3f2739bd1e0b ("KVM: x86: Acquire SRCU read lock when handling fastpath MSR
writes") about "avoid having to play whack-a-mole" seems sound, but in
hindsight unconditionally acquiring SRCU does more harm than good.

While acquiring/releasing SRCU isn't slow per se, the things that are
_protected_ by kvm->srcu are generally safe to access only in the "slow"
VM-Exit path.  E.g. accessing memslots in generic helpers is never safe,
because accessing guest memory with IRQs disabled is unless unsafe (except
when kvm_vcpu_read_guest_atomic() is used, but that API should never be
used in emulation helpers).

In other words, playing whack-a-mole is actually desirable in this case,
because every access to an asset protected by kvm->srcu warrants further
scrutiny.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63ca9185d133..69c668f4d2b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2158,10 +2158,8 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 msr = kvm_rcx_read(vcpu);
 	u64 data;
-	fastpath_t ret;
 	bool handled;
-
-	kvm_vcpu_srcu_read_lock(vcpu);
+	int r;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
@@ -2177,19 +2175,16 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	if (handled) {
-		if (!kvm_skip_emulated_instruction(vcpu))
-			ret = EXIT_FASTPATH_EXIT_USERSPACE;
-		else
-			ret = EXIT_FASTPATH_REENTER_GUEST;
-		trace_kvm_msr_write(msr, data);
-	} else {
-		ret = EXIT_FASTPATH_NONE;
-	}
+	if (!handled)
+		return EXIT_FASTPATH_NONE;
 
+	kvm_vcpu_srcu_read_lock(vcpu);
+	r = kvm_skip_emulated_instruction(vcpu);
 	kvm_vcpu_srcu_read_unlock(vcpu);
 
-	return ret;
+	trace_kvm_msr_write(msr, data);
+
+	return r ? EXIT_FASTPATH_REENTER_GUEST : EXIT_FASTPATH_EXIT_USERSPACE;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
-- 
2.50.1.565.gc32cd1483b-goog


