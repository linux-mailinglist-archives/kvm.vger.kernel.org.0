Return-Path: <kvm+bounces-54737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0300B273D9
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:29:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4E821CC49D4
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4FB4481CD;
	Fri, 15 Aug 2025 00:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utoFyZjD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3EA203706
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217568; cv=none; b=L81uLHsu54QyWQO749NOEIYWgebvdvOpbPKctgN5UIhr8lN7Oa3anh8qvXH7SIhLlgTCNjRi5cJyqVZdB6eiAwcitgDcjDildcH3GHUkzjH3SeCR5wCcqA4HDwIU6iTbQ0CYl1AzuhlZbT0BEOSsZ1BTtnguUhNsgzrCH6ILMoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217568; c=relaxed/simple;
	bh=VztUK3cHn4S41Id+RLhikf3i5GOn/hYUcLl1EXozI3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rmB4aeZaINAuUNVCWHP5HfjdCKpI/yJsegR9KxcRdVnrp+ApGrq3ILrc/CwheGl3HwD9s5/dqrzOLDalCXy/WjN92YAtHVVQDnpJqWdOok2Oh1BizAlQtjTP1DmmhHjtp3CYhZXff50t3oMLZ0e+RQ24vcA9UbDZVvvLpVyhoac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utoFyZjD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-323267858edso1562600a91.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217567; x=1755822367; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j1EiiIuXzEcLgmSMmRJCG/oZIaaJYFDTMiB+4WGMfiE=;
        b=utoFyZjD0WuMFLSewnubw4yuLPoOncj7Z9+s9vPpqzJYkN5aaVfN0Mh5cGr9gM8AS7
         7z75O6+DWN0y3mh9sZL0Oltj+PfN8faAs+7JxPiGbLsLQ+eiOr3eYsdNwAKHv8VnwPhE
         xqtRCqMtaigIyV1hvdh+MdZ3kesESVLYWEKgFto1i0FUsqu2lqkMfvYZarI1UH/j40cM
         0Yy/NgsBvVsZ/84gDO/GT3VZARnD6TRedYiv/iy3JptoGYzkrw0cGqhPyDP54lacI/Is
         qn5HyfEYAd/KP1ciqyR4vyEyQo8lZDW+9LQMqgocFZneNhRUY3BIfT4zf1ga/WKgFccu
         oMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217567; x=1755822367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j1EiiIuXzEcLgmSMmRJCG/oZIaaJYFDTMiB+4WGMfiE=;
        b=xN6UcwBqOAAl1tvHMTbtgDTCWRH1fCIAvDNU2QzLdg0o44BPBCMw1AQ+kIFXC77lJD
         yX44jlQ+YCIMv2949xtePYSJbtkr/qPziL5cIKXpNPilxCI7Lp2jaW/y5YpJaZIxJTzM
         FTNeoQ57QfI2Xt+meeF97LZS5NBW3k0PIC9Vjt5d3ArE9MMhTQLFnxF3zRhcPyGlwMWE
         RFuh2vw0g8Ts6FqtDzasHFtjGRvJrr53aEYoDid8ngD3vwuBoXBYaO6jrlIbEwP1ft7J
         Jn9PW2/WSFWpz3r+4vL0qgBVav08qLUgjXdjUTffaDc0qNEFe0Ek1QxsFk2W1HIhxX7R
         DQGw==
X-Gm-Message-State: AOJu0Yyn7ScCckFhP1G8NjIuSKqByBUWRM9HyFhO8N/YVNiqrMOotpm5
	yUXBw/OSwL/MkjfC/dInUxnIwvfLYbnhSU4yJvD0ufMOtZ+0U8KpbXbKb85KYhWCC8iWF8Qisdw
	A79Pwfg==
X-Google-Smtp-Source: AGHT+IG3kNEPHVCTNCK6yFSl3v8wik71a42TL6j71aEhPq+q7dxE8jY14oeYIuRYtUdjc7Whn45/mLCZPpo=
X-Received: from pjbsc9.prod.google.com ([2002:a17:90b:5109:b0:31f:6644:4725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ad2:b0:312:2bb:aa89
 with SMTP id 98e67ed59e1d1-32341ee92abmr346654a91.20.1755217566760; Thu, 14
 Aug 2025 17:26:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:32 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-13-seanjc@google.com>
Subject: [PATCH 6.6.y 12/20] KVM: VMX: Handle KVM-induced preemption timer
 exits in fastpath for L2
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit 7b3d1bbf8d68d76fb21210932a5e8ed8ea80dbcc ]

Eat VMX treemption timer exits in the fastpath regardless of whether L1 or
L2 is active.  The VM-Exit is 100% KVM-induced, i.e. there is nothing
directly related to the exit that KVM needs to do on behalf of the guest,
thus there is no reason to wait until the slow path to do nothing.

Opportunistically add comments explaining why preemption timer exits for
emulating the guest's APIC timer need to go down the slow path.

Link: https://lore.kernel.org/r/20240110012705.506918-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4c991d514015..0ecc0e996386 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6034,13 +6034,26 @@ static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu)
 	if (vmx->req_immediate_exit)
 		return EXIT_FASTPATH_EXIT_HANDLED;
 
+	/*
+	 * If L2 is active, go down the slow path as emulating the guest timer
+	 * expiration likely requires synthesizing a nested VM-Exit.
+	 */
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
 	kvm_lapic_expired_hv_timer(vcpu);
 	return EXIT_FASTPATH_REENTER_GUEST;
 }
 
 static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 {
-	handle_fastpath_preemption_timer(vcpu);
+	/*
+	 * This non-fastpath handler is reached if and only if the preemption
+	 * timer was being used to emulate a guest timer while L2 is active.
+	 * All other scenarios are supposed to be handled in the fastpath.
+	 */
+	WARN_ON_ONCE(!is_guest_mode(vcpu));
+	kvm_lapic_expired_hv_timer(vcpu);
 	return 1;
 }
 
@@ -7258,7 +7271,12 @@ void noinstr vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx,
 
 static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
+	/*
+	 * If L2 is active, some VMX preemption timer exits can be handled in
+	 * the fastpath even, all other exits must use the slow path.
+	 */
+	if (is_guest_mode(vcpu) &&
+	    to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_PREEMPTION_TIMER)
 		return EXIT_FASTPATH_NONE;
 
 	switch (to_vmx(vcpu)->exit_reason.basic) {
-- 
2.51.0.rc1.163.g2494970778-goog


