Return-Path: <kvm+bounces-36191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C58F8A18761
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 22:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B66C03A4891
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355071F78EF;
	Tue, 21 Jan 2025 21:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0BS6eXCV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEDD1B6D15
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737495306; cv=none; b=aMGCfVs01OBQwGSk3gWhuM5ODtLteHrAR7w25Y9UYTGEKNQ+bJiCsj68hDYTWKC4x0lLklA/G5Y0g70+aMwEqv2tx1DHAcmGxveWFukSKuGlyLNS1rvPI283a/Zjz5IOc7RIG/wFiORyZ4EYUZfvQY6trLwCRebGEeLJB+qVpH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737495306; c=relaxed/simple;
	bh=ZdeUQCgKv+G4ZltrhXT9EZhUktYhwjtSOka13MJCPRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GcGZKNKxqvfva/ui/UuUuGC1lUbE3/K9oz2E/HcG6AieBhgxIj6ta1rsn2oNFjet4ZyGYwcWtHd643uy8zPDhXPk2gnC6M+Lf13DpTIhCkGKUnOjbJfZS/fQ7RNk+VF4E76olVQT5Gai2sY2G9yw1aind20098GtMc45512dTfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0BS6eXCV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f129f7717fso11456390a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 13:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737495304; x=1738100104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rHy0GY6Njm08MRG9uSqRKT7dNmOD2c5Qi53aCcHjiD4=;
        b=0BS6eXCVMB76iNE7MZM0/aILMn1dRGcgdUlkt79mh68trIQ9YtIJmfzeu18xlw5CN5
         p6MFGccZIaA9dl2lfW4diTeDSMPE9K/zK/u/zkLOE3q5r/bLhQJePoTAAYfz0Gfqrjg4
         ksYtgdEnnLROCXLLVTRXkF5nFYVPDVrsMxIM82htz/hNWfymRX3A64dwuOFlUOXDZfNI
         feTYlMCTrFclfm5v1ty6mCoe6goot/kxYzO25KRqbiNqWcA8AzxuPZVaZBRcHxD8dxfI
         a5c2WQDf/sr6phUf7/cJE3gBnWjNtDlZW/yaMSAMqXT0HuMUJ6cUD8c3CPLA43YnagVd
         pzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737495304; x=1738100104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rHy0GY6Njm08MRG9uSqRKT7dNmOD2c5Qi53aCcHjiD4=;
        b=DuiZvHtlnYlzzqMyJmAvUTwCfxET+USzomAHfLgFH84k2yzJXU/tDIJ43Z2wutcF3z
         2wtWqhOIzkpcCmIuC5AnITIYA5LrkJN29HlQEzr6LbVCZL+gl1hB8IoiSIOqAMMwDFIu
         nsVxvVsaAlVTxYBOTqGN/+s0cFlrKFdDRpEbckcl6WcuxU7ZoZnm7664vbXyMRyZ7pbN
         JbqnWnYAXbhJxRkoulGsamh5kaDnkWXEc8CXS3RiOBVQ93yLEFB5cfIGm0XYSponqCXW
         Jz0JZhQZ57MAMRGE679XF9R+Pwr9VBnsEeo5i6Kc1jRk5J3SjdmZORCynm0hxGAmKk2g
         YIBg==
X-Gm-Message-State: AOJu0YwyyAQYsuGY6+1y8vHnq7W/eOOXhjIRY1twz7MNiWwmDlYNMJjb
	/Z7xp03/SfVwxufcyVszoqbhj1/emVbzvJdgLiHwKZ7dfUw+xgNyEpTIMdNKxaBWGXQaTal5Qvq
	NAw==
X-Google-Smtp-Source: AGHT+IGoxNW0yFXsf/fkdROo5LbBUUnTi0SAmqjfhARkYZUORhUuyYHYzoOSWeqloiRoU5FRt0RETCSUpUA=
X-Received: from pfbdw14.prod.google.com ([2002:a05:6a00:368e:b0:725:cd3b:3256])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2448:b0:725:322a:922c
 with SMTP id d2e1a72fcca58-72daf9abd78mr30814934b3a.3.1737495304192; Tue, 21
 Jan 2025 13:35:04 -0800 (PST)
Date: Tue, 21 Jan 2025 13:35:02 -0800
In-Reply-To: <20250119162749.665030-1-kentaishiguro@sslab.ics.keio.ac.jp>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z4rM2abMZvurfFDO@google.com> <20250119162749.665030-1-kentaishiguro@sslab.ics.keio.ac.jp>
Message-ID: <Z5ATBhDUAH4ZK4Fw@google.com>
Subject: Re: [RFC] Para-virtualized TLB flush for PV-waiting vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Kenta Ishiguro wrote:
> Thank you for your comments.
> I understood the scenario of why my previous change was unsafe.
> 
> Also, I like the concept of KVM_VCPU_IN_HOST for tracking whether a vCPU is
> scheduled out because it can be helpful to understand the vCPU's situation
> from guests.
> 
> I have tested the attached changes, but I found that the performance
> improvement was somewhat limited. The boundary-checking code prevents
> KVM from setting KVM_VCPU_IN_HOST and KVM_VCPU_PREEMPTED, which may be
> contributing to this limitation.  I think this is a conservative
> approach to avoid using stale TLB entries.
> I referred to this patch:
> https://lore.kernel.org/lkml/20220614021116.1101331-1-sashal@kernel.org/
> Since PV waiting causes the most significant overhead, is it possible to
> allow guests to perform PV flush if vCPUs are PV waiting and scheduled out?

Hmm, yes?  The "right now kvm_vcpu_check_block() is doing memory accesses" issue
was mostly addressed by commit 26844fee6ade ("KVM: x86: never write to memory from
kvm_vcpu_check_block()").

  It would in principle be okay to report the vCPU as preempted also
  if it is sleeping in kvm_vcpu_block(): a TLB flush IPI will incur the
  vmentry/vmexit overhead unnecessarily, and optimistic spinning is
  also unlikely to succeed.  However, leave it for later because right
  now kvm_vcpu_check_block() is doing memory accesses.  Even
  though the TLB flush issue only applies to virtual memory address,
  it's very much preferrable to be conservative.

I say mostly because there are technically reads to guest memory via cached
objects, specifically vmx_has_nested_events()'s use of the nested Posted Interrupt
Descriptor (PID).  But a vCPU's PID is referenced directly via physical address
in the VMCS, so there are no TLB flushing concerns on that front.

I think this would be safe/correct.  Key word "think".

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5193c3dfbce1..691cf4cfe5d4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2350,16 +2350,6 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
                irq->delivery_mode == APIC_DM_LOWEST);
 }
 
-static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
-{
-       kvm_x86_call(vcpu_blocking)(vcpu);
-}
-
-static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
-{
-       kvm_x86_call(vcpu_unblocking)(vcpu);
-}
-
 static inline int kvm_cpu_get_apicid(int mps_cpu)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f3ad13a8ac7..4f8d0b000e93 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11170,6 +11170,18 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
        return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
 }
 
+void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+       vcpu->arch.at_instruction_boundary = true;
+       kvm_x86_call(vcpu_blocking)(vcpu);
+}
+
+void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+       kvm_x86_call(vcpu_unblocking)(vcpu);
+       vcpu->arch.at_instruction_boundary = false;
+}
+
 /* Called within kvm->srcu read side.  */
 static inline int vcpu_block(struct kvm_vcpu *vcpu)
 {

