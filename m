Return-Path: <kvm+bounces-19081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D66D900B31
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 19:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCBA5288477
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 17:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7258E19CD0A;
	Fri,  7 Jun 2024 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PzUojqmZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC1E19B59A
	for <kvm@vger.kernel.org>; Fri,  7 Jun 2024 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717781179; cv=none; b=oE7sluQE5VVA8wsV4DRqWhIOl/wqsGOoFQ1vGVKRiL3IwwBHT6NNZo/bk3W8SvINiJBweqXreKvLkQh6I/3VtulILPcMggCtuP3fE3ms7E2poT0CDHG1BGy55Espq3AEevpcdf46DJentASsd03G4FuK1LPvxpXh3zrHdo1O1Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717781179; c=relaxed/simple;
	bh=zAGtRhmr0d/QTq2Bw5BvUsPFzARJJ399PRwhubtB1X8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KGggqYMR58oa4C0bqEIKprXFWp13iZhW8RlQWq94WKZHUTU1BikFjql32uJSs9gWAHsrO8lOX7QdnMySA9iiMC8A6m98RN/bYNHbmp5r99iXhnDh491wbUi6LL+RmcK9UWeACxw3wYUcRzrWtvNFOsiBkgbp/ORcMAS4Oe/TCV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PzUojqmZ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627956be166so44478267b3.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 10:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717781176; x=1718385976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kJHRfStFkUXfG21w/DoiKB1T7iExC1PuwpEo9VICX2Y=;
        b=PzUojqmZdHtO6oN3aENDkb5YvE/utaYvBgVvUyOnItrLoRMC1g+JugWGoBw8LjYMpt
         NXrddiGm+qv1ywuCQB4GBFEgsKG4IUWw2mFUV4ENt62+6vemNVBmfOHqCrVniCgcbqLi
         m6TDWWUMrlHDOYVbIEZdXbDHldQGcp8gIJfZ6JudjnFoUCXf1stnRt06bFhq6HCxTNvC
         6VZ+W7s/cbkOUK+qNPRU2bQLScYQeXDsAXnCqFTkjm0YfuO8nBAnZbnP7lVQuw8AzaZb
         H7TsmCSWB4jIGi0kTwoCb1xVl9SRR2+om3i9ox9MZPo1ZqmOeqCdr8cz24mlZ++sLpNQ
         XccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717781176; x=1718385976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kJHRfStFkUXfG21w/DoiKB1T7iExC1PuwpEo9VICX2Y=;
        b=wlzOgvXfpcRKsUKd2rKxLWQTNvDkzaOBdYvs4unI516oNcXW09QOZIvD6KSuz8JTlq
         EYTIQ70vbhbmU8NlbYA1uvUjwiB9vA9xZVBcD9cu/EXDrgXvLBHtOVRD5T9W78+Gur0d
         zzS0WsNBruaN2SYBl/0/52ApRblQuGFgpegcfWiI39A7gDaMxjbm/sprQu5aQ2t6DeNW
         AZUz4ZDV8uSMimpcgv0RJrFCjXWOvQa2Vym1q6MrqHH7vmbCSESSH6VNnbl/MuTrBvF2
         qhhN6Wq1h9rE0kQyJZ3f9RKwo9eKambWLoLURFY5zmp2SeAZpECbhEz4drJr+JUTaHlC
         y+CA==
X-Gm-Message-State: AOJu0YxJBONqob7FgG0a/rQkJUIR3nEbpHG3g3Psw1jII4DGqmykv2F7
	cmcQeGh30bjRmnIPGuoF0T8P5aYov/xF7pFsRfGY9mScukxOW/dByvlCNOkrWAS1OWM2migcB/D
	kSQ==
X-Google-Smtp-Source: AGHT+IEJgRrph+wkSRXAv3mYf/aI2eiFiQMIWYiL20qPih15C/254zU1LiwuO3jOFWmuqAnMD00vhDMjY/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1106:b0:df7:a340:45e5 with SMTP id
 3f1490d57ef6-dfaf6594155mr711835276.9.1717781176159; Fri, 07 Jun 2024
 10:26:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 10:26:05 -0700
In-Reply-To: <20240607172609.3205077-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240607172609.3205077-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240607172609.3205077-3-seanjc@google.com>
Subject: [PATCH 2/6] KVM: nVMX: Request immediate exit iff pending nested
 event needs injection
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When requesting an immediate exit from L2 in order to inject a pending
event, do so only if the pending event actually requires manual injection,
i.e. if and only if KVM actually needs to regain control in order to
deliver the event.

Avoiding the "immediate exit" isn't simply an optimization, it's necessary
to make forward progress, as the "already expired" VMX preemption timer
trick that KVM uses to force a VM-Exit has higher priority than events
that aren't directly injected.

At present time, this is a glorified nop as all events processed by
vmx_has_nested_events() require injection, but that will not hold true in
the future, e.g. if there's a pending virtual interrupt in vmcs02.RVI.
I.e. if KVM is trying to deliver a virtual interrupt to L2, the expired
VMX preemption timer will trigger VM-Exit before the virtual interrupt is
delivered, and KVM will effectively hang the vCPU in an endless loop of
forced immediate VM-Exits (because the pending virtual interrupt never
goes away).

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/vmx/nested.c       | 2 +-
 arch/x86/kvm/x86.c              | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5c0415899a07..473f7e1d245c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1836,7 +1836,7 @@ struct kvm_x86_nested_ops {
 	bool (*is_exception_vmexit)(struct kvm_vcpu *vcpu, u8 vector,
 				    u32 error_code);
 	int (*check_events)(struct kvm_vcpu *vcpu);
-	bool (*has_events)(struct kvm_vcpu *vcpu);
+	bool (*has_events)(struct kvm_vcpu *vcpu, bool for_injection);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
 			 struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0710486d42cc..9099c1d0c7cb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4032,7 +4032,7 @@ static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
 	       to_vmx(vcpu)->nested.preemption_timer_expired;
 }
 
-static bool vmx_has_nested_events(struct kvm_vcpu *vcpu)
+static bool vmx_has_nested_events(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	return nested_vmx_preemption_timer_pending(vcpu) ||
 	       to_vmx(vcpu)->nested.mtf_pending;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4157602c964e..5ec24d9cb231 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10534,7 +10534,7 @@ static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, true))
 		*req_immediate_exit = true;
 
 	/*
@@ -13182,7 +13182,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	if (is_guest_mode(vcpu) &&
 	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu))
+	    kvm_x86_ops.nested_ops->has_events(vcpu, false))
 		return true;
 
 	if (kvm_xen_has_pending_events(vcpu))
-- 
2.45.2.505.gda0bf45e8d-goog


