Return-Path: <kvm+bounces-42367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05EE3A7805E
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23BED3B2207
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACD0BA42;
	Tue,  1 Apr 2025 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ww4OEtH6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C67C20E70F
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743524290; cv=none; b=n5IryaAbFLKQAF36DGl4UHN1hy9sAlUsfDjPE2dir0HLLY7mDCVz7FDDNSyi959o8c1/EDnUHF9Fxvura7hlj5UI3xGnge1OfiOhTBwtdEg/Go8m+CHv2FCM6xXydQaGY2Z6cqpxpJUnhLUAF9w4lNMVm4j6h+cr6uH61ndGO6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743524290; c=relaxed/simple;
	bh=fWIBQmUTb72aiRc41495d8ZZdXdCbxu4pWmWZnHxDTI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3UAdqTX4elfROuUtYzAs1WYEKXQT+Wfl8fHqD8wYRj4aMTKmZeNtT+zpkkKgImlClrDJBh6EDp2G3n5lFz/LtEHoYSpRikMDmsTmYwOgmOuX9iymDcRMCPfZmq7WYR2UIz2lfAkcdi7PvZuWCmH6w5y3buASJ9trBNxLp7KJy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ww4OEtH6; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2241ae15dcbso133802405ad.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743524288; x=1744129088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=i3CvVTiTohY/MD7XlD1mUCUkTV809OhWBxe9COdH9yw=;
        b=Ww4OEtH6tuLU/NSLZstG5erzVN/7+B0EIZapBgN3R2x3xqT464z72ozfZ5LmHgBCXv
         gXkomsRveJK+KlUqZk8iBHnbevFYuI1KWwtk9XJdcC5A2bM7R3nmpthidlosdcXvEpTY
         ivXCqQApfj0GEkl5rl46UBzFMEu0i/16zz4rS2rw6Iz8h9GH23QkjAFi+aAlU4knkZq8
         6/Ps525KhbQjgP7IpiinqardQu566IpZCAUllUO4c9q2rjRh/wIk/hBLDPgLRdeTOMj6
         NyPpb0oEE3/9csHvoeUqqTZg7e6qzcfyU4YRHrmqSxPqUw1ALROE93MbZfinv3WhHu/E
         5C2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743524288; x=1744129088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i3CvVTiTohY/MD7XlD1mUCUkTV809OhWBxe9COdH9yw=;
        b=Akan+KezyMBLvaUrlsfGHxnR57JrsPdLWpG4SlcB80Cw3Ygcrs1b1XW/RgXRi9ewC4
         1fTMUu3q0HflLeu7fPpBIg5aEYAMc7j2lryYGNaPOqbe1q5KtE9Y4feFvjEh7kG8DmXk
         VmXobpU3rXcWChCtIcVfr+iIt1CnaUTKCloGUw9b+o/eEQb89wG6kHuGjfK1rm7W2cmS
         nXWfuDP2qPkrJ5jTE+7OPj8rRke8XPF5Fke6dEyxf2Ec91r6gPQnjw8/b47PyEeWG92L
         xPbewwka6x2F0noiAmCe3RjSG6qagGWg85KzmhRA47sypkB8Kgzqb4mbbgkEm+fTXW1O
         UoBw==
X-Gm-Message-State: AOJu0Yx/cn/PFPIFn8J5NmX7RWVcqo2r0f3ggeZ+pichc5jHZNtQk0HT
	MWorvmBovatd3cIhUYdwyom2aCtkFXw3XZjAdAxEU/E/7qjH1BcbjC9Qd8Ub83tu1K8Z/U+a365
	uLg==
X-Google-Smtp-Source: AGHT+IGYMlELE54qVypHagndgMfq83OicwY6JnNyZsP/+GL6myxIy23X8uMt9Qym6qCfe654bpzCkDka+5E=
X-Received: from pfhh22.prod.google.com ([2002:a05:6a00:2316:b0:730:5761:84af])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e88f:b0:223:5c33:56a8
 with SMTP id d9443c01a7336-2292f9e51f9mr223551505ad.35.1743524287794; Tue, 01
 Apr 2025 09:18:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 09:18:02 -0700
In-Reply-To: <20250401161804.842968-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161804.842968-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401161804.842968-2-seanjc@google.com>
Subject: [PATCH v3 1/3] KVM: VMX: Don't send UNBLOCK when starting device
 assignment without APICv
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When starting device assignment, i.e. potential IRQ bypass, don't blast
KVM_REQ_UNBLOCK if APICv is disabled/unsupported.  There is no need to
wake vCPUs if they can never use VT-d posted IRQs (sending UNBLOCK guards
against races being vCPUs blocking and devices starting IRQ bypass).

Opportunistically use kvm_arch_has_irq_bypass() for all relevant checks in
the VMX Posted Interrupt code so that all checks in KVM x86 incorporate
the same information (once AMD/AVIC is given similar treatment).

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 7 +++----
 arch/x86/kvm/x86.c             | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index ec08fa3caf43..16121d29dfd9 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -134,9 +134,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 
 static bool vmx_can_use_vtd_pi(struct kvm *kvm)
 {
-	return irqchip_in_kernel(kvm) && enable_apicv &&
-		kvm_arch_has_assigned_device(kvm) &&
-		irq_remapping_cap(IRQ_POSTING_CAP);
+	return irqchip_in_kernel(kvm) && kvm_arch_has_irq_bypass() &&
+	       kvm_arch_has_assigned_device(kvm);
 }
 
 /*
@@ -254,7 +253,7 @@ bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu)
  */
 void vmx_pi_start_assignment(struct kvm *kvm)
 {
-	if (!irq_remapping_cap(IRQ_POSTING_CAP))
+	if (!kvm_arch_has_irq_bypass())
 		return;
 
 	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..a5ea4b4c7036 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13556,6 +13556,7 @@ bool kvm_arch_has_irq_bypass(void)
 {
 	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
 }
+EXPORT_SYMBOL_GPL(kvm_arch_has_irq_bypass);
 
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
-- 
2.49.0.472.ge94155a9ec-goog


