Return-Path: <kvm+bounces-70073-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COa2IyBIgmnzRgMAu9opvQ
	(envelope-from <kvm+bounces-70073-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:10:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C658DE100
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:10:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C261312E852
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 19:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75C126ED3D;
	Tue,  3 Feb 2026 19:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wS8scghd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBEF30DED1
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 19:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770145639; cv=none; b=EJAHRc03uP4Z2xnPLHxKF/T/yLHklPpxehCvXVPXuw8zir8FeiUMCOex+OCzASNY6Sq2jSC+55gFjdCSKvCeda1X0/wm76yzQHpCZ0gsR87a57EKLwtvendaUG0lh+NJ2NJhkYKx33x85VFKwJU0II0sj/yRszcycguutJGEPG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770145639; c=relaxed/simple;
	bh=9hyIXB/FNUlxKg1ThDH1maGsP4uK7gUz0rXhRQbPk1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ryDntjieC5OEQav/oYMfZZ4QQSnd6YDBAuBvPESW6Ag8l3rw67qNa5ZMP/jF1gNspEgxW7aHK4eOVhnBYPRpkJZDooNGe5X7czBqda/kyCO4rROz6uvRNxpVdQeUXKH6pMBxv3bSISsRfSZqYONnLDPgEQBdXncPgQcbFoGmcEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wS8scghd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ec823527eso10992258a91.2
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 11:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770145638; x=1770750438; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pGnImD+wgFSEc5hkJXl+UKRVx3rx9cNOjjp3chQhybs=;
        b=wS8scghdrK5AOFmWuR156e/iYAUyAnTEiOWIKM36GGBQCzcDUyKYkD8t+XayPj45E7
         jYvuo1+pOi9GTU8pMV3B/6VjCBH7aafcIzda6I5gu6IanP+ZIn3EKT/LL9oAPIdsE216
         vZSkFODXQ+y4OzFjqb4fHe4lCP2fisZ7QsfhhB9Jrgr8zLbJ42Mxewa4DOhaNVr5Ao27
         cdCPwAHAvdOw5FomipR1pLwj9ZQq5PwemQn6zs+sKzUs12XOwJOYUQyLq68ISeEauoCB
         4kw7BX/R0Eg0En5ok4KssFAIr9Eji6SIooUdwJDh7BjzJdGgH5thlajs5GWRVYtCnOBr
         sZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770145638; x=1770750438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pGnImD+wgFSEc5hkJXl+UKRVx3rx9cNOjjp3chQhybs=;
        b=MMfJuvyAyWSgFJ+9RkxfNVT6nftlPmOJKihD6Q89clqII0tW7KMV9z05z4/p5Y3MhU
         w6wuYshUjRIQc1R7UoUiZ38otxjkoJOkI6v+4QZK3St/Spto+DfDn5BrK8ep4ejX+68k
         lfyKsGLeVLWRNXgqPLj6ZM9Xtq0rH+vvDSv8+5UNuHEuVRgw0ki2msntSipCwre0BAzS
         K9COl8tEVtdAXIPCSHnEDKnvBFpyn+5cVm77DP1y8GcV2hkLuVth+rtz5+RE8rnABcoa
         ChEuyvsHWkL2oHKAjtLsxUSXqZ0FFQF8nQ1aOyN110uvvu4QftKeE0urp3lJryEfcCWt
         aCVA==
X-Gm-Message-State: AOJu0YzwECVgwTWD+B7hhE6EUMTuboA2x8vQJgF+omyWOiO8TPuyDWyC
	YSRaqzK8cFqumMkhbNth84UxsNKjaz4h+gqN/nSj+6UjgVrhAL0zyi3MezVV7xdG5Dx+tYKHked
	9FJ+Ipw==
X-Received: from pjzh18.prod.google.com ([2002:a17:90a:ea92:b0:352:ba50:2819])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2cc6:b0:34c:2db6:57d6
 with SMTP id 98e67ed59e1d1-3548717eeb4mr277122a91.19.1770145637977; Tue, 03
 Feb 2026 11:07:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Feb 2026 11:07:10 -0800
In-Reply-To: <20260203190711.458413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203190711.458413-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Naveen N Rao <naveen@kernel.org>, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70073-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3C658DE100
X-Rspamd-Action: no action

Explicitly set/clear CR8 write interception when AVIC is (de)activated to
fix a bug where KVM leaves the interception enabled after AVIC is
activated.  E.g. if KVM emulates INIT=>WFS while AVIC is deactivated, CR8
will remain intercepted in perpetuity.

On its own, the dangling CR8 intercept is "just" a performance issue, but
combined with the TPR sync bug fixed by commit d02e48830e3f ("KVM: SVM:
Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active"), the danging
intercept is fatal to Windows guests as the TPR seen by hardware gets
wildly out of sync with reality.

Note, VMX isn't affected by the bug as TPR_THRESHOLD is explicitly ignored
when Virtual Interrupt Delivery is enabled, i.e. when APICv is active in
KVM's world.  I.e. there's no need to trigger update_cr8_intercept(), this
is firmly an SVM implementation flaw/detail.

WARN if KVM gets a CR8 write #VMEXIT while AVIC is active, as KVM should
never enter the guest with AVIC enabled and CR8 writes intercepted.

Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
Cc: stable@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Cc: Naveen N Rao (AMD) <naveen@kernel.org>
Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++++--
 arch/x86/kvm/svm/svm.c  | 9 +++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 44e07c27b190..13a4a8949aba 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -189,12 +189,12 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
-
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 	vmcb->control.avic_physical_id |= avic_get_max_physical_id(vcpu);
-
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 
+	svm_clr_intercept(svm, INTERCEPT_CR8_WRITE);
+
 	/*
 	 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
 	 * accesses, while interrupt injection to a running vCPU can be
@@ -226,6 +226,8 @@ static void avic_deactivate_vmcb(struct vcpu_svm *svm)
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
 
+	svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
+
 	/*
 	 * If running nested and the guest uses its own MSR bitmap, there
 	 * is no need to update L0's msr bitmap
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e8313fdc5465..aa3ab22215f5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1077,8 +1077,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
 	svm_set_intercept(svm, INTERCEPT_CR0_WRITE);
 	svm_set_intercept(svm, INTERCEPT_CR3_WRITE);
 	svm_set_intercept(svm, INTERCEPT_CR4_WRITE);
-	if (!kvm_vcpu_apicv_active(vcpu))
-		svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
+	svm_set_intercept(svm, INTERCEPT_CR8_WRITE);
 
 	set_dr_intercepts(svm);
 
@@ -2674,9 +2673,11 @@ static int dr_interception(struct kvm_vcpu *vcpu)
 
 static int cr8_write_interception(struct kvm_vcpu *vcpu)
 {
-	int r;
-
 	u8 cr8_prev = kvm_get_cr8(vcpu);
+	int r;
+
+	WARN_ON_ONCE(kvm_vcpu_apicv_active(vcpu));
+
 	/* instruction emulation calls kvm_set_cr8() */
 	r = cr_interception(vcpu);
 	if (lapic_in_kernel(vcpu))
-- 
2.53.0.rc2.204.g2597b5adb4-goog


