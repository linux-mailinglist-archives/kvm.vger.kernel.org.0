Return-Path: <kvm+bounces-39037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C68A42ADA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:15:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 679CC178333
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2153266582;
	Mon, 24 Feb 2025 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LlGCkfy7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909226618B
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420805; cv=none; b=WEUxYMoOtC+BGNVkqxeIOYQe8hkcbwdfvlDvP43QES+cntRlNiqGLlcdY6JUnReOMVhhOSnuFAEpNTR7FFI4yOhiR1RWv8NdJzU2Xx0rj1SpV/dN/2x3tA2N9c1npLXy+hOZYWpufBJhE5ootfjIEewyFJYq1BASKB52DvFSgPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420805; c=relaxed/simple;
	bh=zwSWGWyJCEqK3EgjGabcufzz2Jhjt4Tt0eIREMYq5xA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OKPLrLB2DqXGZt+2LDQjPO55XOju3vStM9y8x1rJGJ0XkMyxsZEq6IlckUVln6QH1SaGdQ9wzOCuSJBZWFNVxbrxVgL2grJW2HddDKfQiT0bApMw8inlGt45nGweJF4r0Isthyr1kabCn8KLivEY3qWNQRzMpJBImfkARDR6q84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LlGCkfy7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc3e239675so15514279a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740420803; x=1741025603; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SjCEk+WFV+Lt1J63H68Pzj8aW0CM7jW9ariY2ENn4Ss=;
        b=LlGCkfy7idYMbaSni37wbcu/8ZlAYxX7CgZMyjTP/B/WOy6X374UWy++xBjFqnDzbf
         hNlJ3TK4DlHfoe4AzxTUJbtIUj8jrHLGjhnlR0GtdsbpDsnGx6vBQaIf8hRs8ZBioK2B
         4QyuaUmQoqA5dNwXZidoWmLkzH9FjZvtog9N2nKbxrrmRp+/ikMz5qim+rSNZUaQAL9m
         ALyoMRgO+a5z9TnLjUzjSyLWhtcVJEzvDveP7AjG+/S2ggLCwZY8nuHvcaU5WoS/fxih
         eq85405icowB/jdkuOWpsLqB5c3FrtksguqXCDaMWCtXF+1guaksvs7gDPXzUsFT4JNq
         aSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740420803; x=1741025603;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SjCEk+WFV+Lt1J63H68Pzj8aW0CM7jW9ariY2ENn4Ss=;
        b=gH7kTpxOvD+D9SThxphNTjallH73xa4dVOwQ8aSiy7GLRmK2Mvd9wLG6p35CA4yH/P
         37aGTgEYehWBUEmhzDlUuRvaD1h4EWV2zPy09JsRsfQDLoe4J1lnCGrcZAGS+Kg9R4Kd
         2QjwSEN7nj/qMUVdI+wd1Ys5/LSnWsZCp4Uawp9EgplJV7ygnV3UMyyZJCTeaRhUeOma
         QDZwqLsNr8R9CDb9ve0vIhlHIi42zExyS8NvlOYkUz9l/tnqS0uEApUoukvAVElfv107
         KlWlGrIgqhkLqzNxeBaN/LCmvowPYMhkGWfB+0Nsmhou/OP5j884/5MqKo5a+2DcIlfa
         E2KA==
X-Gm-Message-State: AOJu0YyL84LO7Wt9OVJKe0o4ufNZBPLgNU4Dt8as1GXZyTXaBGUl8LTY
	+fgFVae7c45lapfyYJvMdArf6o83t9jqxeZ37916xIyKEMMU9w6Dm2a/g6vJNoOmBhrL3AIzZPC
	PFQ==
X-Google-Smtp-Source: AGHT+IF6iZ+0KnJbLkR7ipaAO8QY66e/umbqhD486EcnVcJk5vQzaxugiBscCRQPNOCplDffUclBGodmEyg=
X-Received: from pjbqx15.prod.google.com ([2002:a17:90b:3e4f:b0:2fc:3022:36b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f4e:b0:2f9:c56b:6ec8
 with SMTP id 98e67ed59e1d1-2fce86adf4emr24553254a91.10.1740420803640; Mon, 24
 Feb 2025 10:13:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 10:13:15 -0800
In-Reply-To: <20250224181315.2376869-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224181315.2376869-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224181315.2376869-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rangemachine@gmail.com, 
	whanos@sergal.fun, Ravi Bangoria <ravi.bangoria@amd.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Snapshot the host's DEBUGCTL after disabling IRQs, as perf can toggle
debugctl bits from IRQ context, e.g. when enabling/disabling events via
smp_call_function_single().  Taking the snapshot (long) before IRQs are
disabled could result in KVM effectively clobbering DEBUGCTL due to using
a stale snapshot.

Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09c3d27cc01a..a2cd734beef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4991,7 +4991,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10984,6 +10983,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-- 
2.48.1.658.g4767266eb4-goog


