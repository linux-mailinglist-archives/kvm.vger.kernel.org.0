Return-Path: <kvm+bounces-57896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79713B7F9AC
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:55:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1263F4A3AD5
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31FE32340D;
	Wed, 17 Sep 2025 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hpu5usbN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A893233F8
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116681; cv=none; b=b+AnNRFm7Kn6MvH1BnZJihLRYPi1+rfgWfiHSxeiIUfoT17joUMUY+BhX4A7lu1RMJ3u2RoYy9Z6vusLJrcYZ9Uq83LNl9iho/CfKm1D86emXWQXkz/IUhASadlO0XXHGVoe9DlWr4rihsRoy9Hl1RovWSqtGBlwG9sDoy48JJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116681; c=relaxed/simple;
	bh=ZJi7tdLPjgYbZFKjMGd/qK5hFXM6pG4kVFcidSClXdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qop1X8A4/pE3H+R1JhpAdjhyRnZwimvIYqexalmR7uh4WU6IW3YAHgj9oAXVGZCZDkQkL8BIlUJVEx7/ws+raMwi4wN2ujaa4jjHsMN2qd4AUEhEajcUKU3nqYgaUAc7aJhNeVgnakSYYShclZbhgCxItLznwg4FG4NXVUz/H4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hpu5usbN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54fd63ecb9so124774a12.1
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 06:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758116679; x=1758721479; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5UH8viusCcDJDonuj7qTEeANJ2KzlVzvu/LxOGcZpS0=;
        b=hpu5usbNbjYjcz14Td1kYjMn8K/9P21WwiRRbHlNHhp+KQM+C0oSzN/y7cV8Ij4pgv
         GicgxeTgr6YIKHIJ9loVIY9dp975lUs+o8AtOJ7EK1aRxwqAZ+SuXq64OTawsHz59vTJ
         9w9FDtzAYIU3DF1LvqIgY7OFhbQWRSHBdTiU8tAPef7ofePxAWem4sC8fMF2fxJTp3/g
         l06BPANKu7hdxyH6MDZHs4e1QHdeah4zZShzHJQYSWSGQMv6buR9RJgKnEdDDn6KpVpU
         09yP6/ITgRQomMRL1W8h/0cy5/PDZLF0ApojszG+EspP3Cd4oSxX+AojmeEtmv5yZgvd
         FeOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116679; x=1758721479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5UH8viusCcDJDonuj7qTEeANJ2KzlVzvu/LxOGcZpS0=;
        b=fGfZAWXWRA4CbrZzmB0fE/u1aneA35CezC+hrCkNh7v3fpCXUHEW30LyRrpY5NP7xe
         5DNxW5zBd8/9dWlZ51GrhuKhPpSTvQ6N4E3mGKMy1VomV0+Rah6yituLM3jpkuS7vZaY
         4wj5FgTwYzGF39TcB45d2u/goNLX26Zo8m7bHPmPQo8sKh7dt8qlsiLhYjvmTpp0PpaV
         0H0HwJSCAb9VgBI+g95nMrGFF5ya+5udGBt+DP87/gGgqdhNEGOBMKgo6cKdUYYKdnRP
         8CkekWpkveEKQV2XzAdrZPQjdUsIYTh1PbsExfDQNl4ag8V4laYuoEe8IpLQKpPzOvN+
         3Z/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXpMlj1RTwjnB/lAWvtb+E47joMIxtqtricgeG40ldpEXHqWgEGfkuEWDxUGDX8IzeZ9jo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD3T7ZXm1UWwDt/uls3qwFcv5ZhLhv5g9H4axyhw/ICASVvGty
	e+fTs02ld1QDqbgnlrHzHOlXhOifg/4fwKtzL9yInWwpJXGGf7UaOfPnKjBDfas+O62pKJh6JCL
	Hd5EgPA==
X-Google-Smtp-Source: AGHT+IGhehI8LJgcP8zwkG2TeOHjRw58cboMOoOVQPKm4GebZDbEptszXX70rPMnZZtPIWQQz7TjslWvf4U=
X-Received: from pjbqi4.prod.google.com ([2002:a17:90b:2744:b0:327:50fa:eff9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9189:b0:263:57a:bb52
 with SMTP id adf61e73a8af0-27aab860c10mr3156731637.53.1758116679338; Wed, 17
 Sep 2025 06:44:39 -0700 (PDT)
Date: Wed, 17 Sep 2025 06:44:37 -0700
In-Reply-To: <52cc9795-970e-4940-80d1-490daed636c4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-17-seanjc@google.com>
 <52cc9795-970e-4940-80d1-490daed636c4@linux.intel.com>
Message-ID: <aMq7RTmfPhfhDCtI@google.com>
Subject: Re: [PATCH v15 16/41] KVM: VMX: Set up interception for CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 17, 2025, Binbin Wu wrote:
> 
> 
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> > From: Yang Weijiang <weijiang.yang@intel.com>
> > 
> > Enable/disable CET MSRs interception per associated feature configuration.
> > 
> > Pass through CET MSRs that are managed by XSAVE, as they cannot be
> > intercepted without also intercepting XSAVE. However, intercepting XSAVE
> > would likely cause unacceptable performance overhead.
> Here may be a bit confusing about the description of "managed by XSAVE" because
> KVM has a function is_xstate_managed_msr(), and MSR_IA32_S_CET is not xstate
> managed in it.

Ooh, yeah, definitely confusing.  And the XSAVE part is also misleading to some
extent, because strictly speaking it's XSAVES/XRSTORS.  And performance isn't
the main concern, it's the complexity of emulating XSAVES/XRSTORS that's the
non-starter.  I think it's also worth calling out that the code intentionally
doesn't check XSAVES support.

  Disable interception for CET MSRs that can be accessed ia vXSAVES/XRSTORS,
  as accesses through XSTATE aren't subject to MSR interception checks, i.e.
  cannot be intercepted without intercepting and emulating XSAVES/XRSTORS,
  and KVM doesn't support emulating XSAVE/XRSTOR instructions.

  Don't condition interception on the guest actually having XSAVES as there
  is no benefit to intercepting the accesses.  The MSRs in question are
  either context switched by the CPU on VM-Enter/VM-Exit or by KVM via
  XSAVES/XRSTORS (KVM requires XSAVES to virtualization SHSTK), i.e. KVM is
  going to load guest values into hardware irrespective of XSAVES support.

> Otherwise,
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> 
> > MSR_IA32_INT_SSP_TAB is not managed by XSAVE, so it is intercepted.
> > 
> > Note, this MSR design introduced an architectural limitation of SHSTK and
> > IBT control for guest, i.e., when SHSTK is exposed, IBT is also available
> > to guest from architectural perspective since IBT relies on subset of SHSTK
> > relevant MSRs.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Tested-by: Mathias Krause <minipli@grsecurity.net>
> > Tested-by: John Allen <john.allen@amd.com>
> > Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Chao Gao <chao.gao@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/vmx.c | 19 +++++++++++++++++++
> >   1 file changed, 19 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 4fc1dbba2eb0..adf5af30e537 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4101,6 +4101,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
> >   void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> >   {
> > +	bool intercept;
> > +
> >   	if (!cpu_has_vmx_msr_bitmap())
> >   		return;
> > @@ -4146,6 +4148,23 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> >   		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
> >   					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
> > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
> > +		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> > +
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP, MSR_TYPE_RW, intercept);
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP, MSR_TYPE_RW, intercept);
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP, MSR_TYPE_RW, intercept);
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, intercept);
> > +	}
> > +
> > +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK) || kvm_cpu_cap_has(X86_FEATURE_IBT)) {
> > +		intercept = !guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) &&
> > +			    !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK);
> > +
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, intercept);
> > +		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, intercept);
> > +	}
> > +
> >   	/*
> >   	 * x2APIC and LBR MSR intercepts are modified on-demand and cannot be
> >   	 * filtered by userspace.
> 

