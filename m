Return-Path: <kvm+bounces-38456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C604A3A2E6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 17:33:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BC88165049
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 16:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4082D26E64C;
	Tue, 18 Feb 2025 16:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M4RZSxhC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAE1B6D18
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739896398; cv=none; b=qChmKYWr2wKkxfgy9h8rMIUq/QweekLtBiKMlicahSDf3Lew19q1+/MUj69Q4n7z3+ZWbmO8ut5ZR0NPFco06pR8UkXmtZOsC/HtspkHdlogT8HITwN3obqJsLPpPF7H2/F0KBlIC95ux+kNjkGhsPIUTzMQUq04KKFEJTCBi+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739896398; c=relaxed/simple;
	bh=haR3ZcF6zF9YuGmjTaoxjtDtA3g0eiYzi+hVai/4eOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OtjGViuTKxdag+mWWnGCSguCYTLpmVik3Q+7LvsqgO6M9/IrHyZmhY0ujUkb5qgRLHX48sI6D7UMJFr4LP088Tkb2NYUtvzTAHx24Prt2T314sjef9G4IY7ooqIUYalm4ZHb0moyKk1dmEFzbTYLEvsIzYNIWEu51yj6MIP1iEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M4RZSxhC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220e7d654acso107711715ad.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739896396; x=1740501196; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ALDAjApXvzBVsvNdS4XOKHnDSW6U2RJBTi7UgERfwg=;
        b=M4RZSxhCQKkTZFmnJItr60ZI9UnLOTWws/uXOo4PhBjrjc0KDUiSU0pQkorZscuzEZ
         dR5f3RnHLDhCg3OtnqHJRdb9LtcCuV5o/HLurEB7qVgNvfdQIMSqVy/TBnHS2HJKT7BD
         CttLfa0AmNBV1mj/mdNHI2N9OyRL08cdD9+gbeH8fjhvIVCCN98+bCOwxttYrqjsfx8P
         pm9PJvXaj8yDZQWBR9af16rSRbxLINBmTnXhmTCTLbQrChnaWxL9NoanpYa7662tfCbI
         kX1kUO4BwR8Fj3j6qrJZCmx3OAa4V2dIYmNRdSM2Up2nfw7iQk6TbVqBWh4svaDs5SS3
         ik9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739896396; x=1740501196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ALDAjApXvzBVsvNdS4XOKHnDSW6U2RJBTi7UgERfwg=;
        b=XO9xFfYqqfBQ3BELVWBkKD3kSEbEtwrc+yWCH/gl+jwB2eCGi+QtTtgQZlLBMtiHnb
         +e0mbPYx3rg8UED6o7rJKSYinG+1plenAbjnB55OcQuGh6wS3mLqIf1n/lW9Z7n0cQl7
         FCRNzshg2dj/3TR2UqIR9563ZgMWIswMXu8o9U5yiAwpymRfYfzG3X6aDyhKLJSGMVNw
         j/vUobiWQ7A3rMpUhdu83c/qbdI2PpO6VJU1A6v8b5qJaqZkIQuwcnHaa3+2FePqIPfw
         C7mVS9PvL7+8xjuegybyvrSMnaSTWI4CgsVzhhcr2miDjbtVY5JEvtaIFaA/ieHUYIH3
         cdhg==
X-Forwarded-Encrypted: i=1; AJvYcCXnZfohmmFYwbcAqYtqD5VPJD3LELSVXUILSkLR0QJ84z+fTYqUJJA6jjZwJJB12pu6P3M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFtTZdf9TFEevffTkRbzn2/WiPexmAlEMrrBAUyMjJSuXynPT9
	lMsxk83g6AMNlqri45YXGkfZHenYRQxB+oLFcCMmF+kHy8yjFN0e1QyFE1vfEcl/IDtK8zneGg1
	zIQ==
X-Google-Smtp-Source: AGHT+IHKvlgPmZU3etqmp5/W7+L+qd2h4JSM3V9roDOCzzQzTgxjLYGh9pHFETsmqY9dHuv31ZkaXyutW38=
X-Received: from plbkz4.prod.google.com ([2002:a17:902:f9c4:b0:220:efca:379c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f546:b0:215:6c5f:d142
 with SMTP id d9443c01a7336-2216ef12768mr3670395ad.20.1739896396260; Tue, 18
 Feb 2025 08:33:16 -0800 (PST)
Date: Tue, 18 Feb 2025 08:33:14 -0800
In-Reply-To: <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215011437.1203084-1-seanjc@google.com> <20250215011437.1203084-2-seanjc@google.com>
 <DC438DC0-CC4B-4EE2-ABA8-8E0F9D15DD46@infradead.org>
Message-ID: <Z7S2SpH3CtqCVlBc@google.com>
Subject: Re: [PATCH v2 1/5] KVM: x86/xen: Restrict hypercall MSR to unofficial
 synthetic range
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Durrant <paul@xen.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>, 
	David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Sat, Feb 15, 2025, David Woodhouse wrote:
> On 15 February 2025 02:14:33 CET, Sean Christopherson <seanjc@google.com> wrote:
> >diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> >index a909b817b9c0..5b94825001a7 100644
> >--- a/arch/x86/kvm/xen.c
> >+++ b/arch/x86/kvm/xen.c
> >@@ -1324,6 +1324,15 @@ int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
> > 	     xhc->blob_size_32 || xhc->blob_size_64))
> > 		return -EINVAL;
> > 
> >+	/*
> >+	 * Restrict the MSR to the range that is unofficially reserved for
> >+	 * synthetic, virtualization-defined MSRs, e.g. to prevent confusing
> >+	 * KVM by colliding with a real MSR that requires special handling.
> >+	 */
> >+	if (xhc->msr &&
> >+	    (xhc->msr < KVM_XEN_MSR_MIN_INDEX || xhc->msr > KVM_XEN_MSR_MAX_INDEX))
> >+		return -EINVAL;
> >+
> > 	mutex_lock(&kvm->arch.xen.xen_lock);
> > 
> > 	if (xhc->msr && !kvm->arch.xen_hvm_config.msr)
> 
> I'd still like to restrict this to ensure it doesn't collide with MSRs that
> KVM expects to emulate. But that can be a separate patch, as discussed.

I think that has to go in userspace.  If KVM adds on-by-default, i.e. unguarded,
conflicting MSR emulation, then KVM will have broken userspace regardless of
whether or not KVM explicitly rejects KVM_XEN_HVM_CONFIG based on emulated MSRs.

If we assume future us are somewhat competent and guard new MSR emulation with a
feature bit, capability, etc., then rejecting KVM_XEN_HVM_CONFIG isn't obviously
better, or even feasible in some cases.  E.g. if the opt-in is done via guest
CPUID, then KVM is stuck because KVM_XEN_HVM_CONFIG can (and generally should?)
be called before vCPUs are even created.  Even if the opt-in is VM-scoped, e.g.
a capabilitiy, there are still ordering issues as userpace would see different
behavior depending on the order between KVM_XEN_HVM_CONFIG and the capability.

And if the MSR emulation is guarded, rejecting KVM_XEN_HVM_CONFIG without a
precise check is undesirable, because KVM would unnecessarily break userspace.

> This patch should probably have a docs update too.

Gah, forgot that.

