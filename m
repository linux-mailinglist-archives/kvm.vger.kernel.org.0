Return-Path: <kvm+bounces-58150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC79AB89DE2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 001CE189ADC0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 14:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B6C030F94F;
	Fri, 19 Sep 2025 14:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6gI4Ftw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECA9304BD7
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758291712; cv=none; b=Mioa0CZautzlNespBl2e1cppNQ5C3pLKV1SAyr9PtoxaAWnq02DRFUqsX2zT+b4tXk4vm32d5Z99fFFv3xXXLPbPYnpZCOt/v9OCog2itQe0EqUzWd0uxHOAhbZySD/9Q3XUYRF1txFxz0QO3YJzHv81xgxyyLaJmW/xMy0JTrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758291712; c=relaxed/simple;
	bh=2enupyLx6F97KhRTrAfwg8Fz0mcQGLhYQ0KBpTHeq4I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gDMcJSMGDu7OZQIrCXxw6wfZvETHL/ienwr072ZpqdrbyN6UXEcB3WF+6ADwtjOWcdrsPOVbheBryPvYjt2fzVgYsSdIbgnV9Hugz1EpxAW1JGz/2G5TqpCqjFRyzHY8lVxiR3QAUZRhJ1QbWXtcYSvwH1NURlx1tkcUsesSRP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6gI4Ftw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32ee4998c4aso2116771a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758291710; x=1758896510; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/uLHhxqIz3m8Vu42q2Oa1AvnZOlqtDYHdgC57Vb9XU=;
        b=f6gI4FtwkVZ0ujdMpBFjSY0HmKeSV/JjK944DIg9d+3QUQkwUYmcJ0nK/q9Rq6wnsA
         /u0kfAocrisJDS3zvcrcuO4TbHRMqZAcq9Ro+vxrw6FfPb9Kil72hp/iOSbSlT8nsde6
         fw5TL2XTGPq1QSkXjnVxGfnGrPfEOtggD4fD0901ko9joB2XP7sLMpWy5A8U1c5jZ9ta
         XjTezV6TlAeEk60OSB8GlJT1jzNBkcQ0Q6kgp2pJyMejc2W/JeNEdQBekrxmvcJzqJeT
         rJ4jZ+o9dfnPpKR49Gc3yogC/kAzZDowCZKjphRrKFb6SVCMV/TmufS58AZSaRYGVP0D
         9tSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758291710; x=1758896510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/uLHhxqIz3m8Vu42q2Oa1AvnZOlqtDYHdgC57Vb9XU=;
        b=BKGHEZ13YFaEdb3GQddqcaT2tCDkEKTnGiATRktTkonpM17JhlTWZjgaRhEYCEOIZ+
         PsKsjH6a+Ew/VCxZvxaafbB4AERIkhAl0c9YmWw0Hmr+YI42x/lcBogInIoTI7wA9lQw
         SUlX51rY+B7jddNKVv90ueei/K93tBAin2AiqgTPFHoxOhBPdsJ0bcBJMsLLNEOxLZ2+
         0YGy/qcUqNXUvUMWRyWzqxd9Wxe87G3MCT7O+gYUA2Z8Y9YL2y015NvBeqLzy4/48ROD
         TWt2Yo12bda+L93laD11rC5e2CUwGO2hn0XdtF4jvr+U2O1+aOro+h2vYrnJl+hkOLop
         u2pA==
X-Forwarded-Encrypted: i=1; AJvYcCWODPTWRH3F2UAnQqFMP35bOEf+xkRIfl9U3FkYU8fwcRPhMNQ+373VJ8PgT9CFS/+nzS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMg/xqh/dvZnzwl85aHubAh27na1yUpx/YX+Je9gwa4cNGK+AP
	qzql7Dw5Nw1wSpodzPtO8zamA7X0OnLoc8jdWCXbGYZuqaiaPNgtl+tFKy5OXr9TDOkBhQ1fH5H
	zvpmrJw==
X-Google-Smtp-Source: AGHT+IHeBhJRfXhX1utSR8FjMcRgOkPNwY6NH5APDiYqEBsMttZnRUvgdZ5oli+OY4U49DKENaA5x4J3i7A=
X-Received: from pjbsq12.prod.google.com ([2002:a17:90b:530c:b0:32e:cc38:a694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f48:b0:32e:2059:ee88
 with SMTP id 98e67ed59e1d1-33097fd0ec5mr4556569a91.6.1758291710340; Fri, 19
 Sep 2025 07:21:50 -0700 (PDT)
Date: Fri, 19 Sep 2025 07:21:49 -0700
In-Reply-To: <i4znbv2qka5nswuirlbm6ycjmeqmxtfflz6rbukzsdpfte7p3e@wez3k34xsrqa>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919002136.1349663-1-seanjc@google.com> <20250919002136.1349663-3-seanjc@google.com>
 <i4znbv2qka5nswuirlbm6ycjmeqmxtfflz6rbukzsdpfte7p3e@wez3k34xsrqa>
Message-ID: <aM1mVMXptK-sko3f@google.com>
Subject: Re: [PATCH v3 2/6] KVM: SVM: Update "APICv in x2APIC without x2AVIC"
 in avic.c, not svm.c
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="us-ascii"

+Intel folks (question at the bottom regarding vt_x86_ops)

On Fri, Sep 19, 2025, Naveen N Rao wrote:
> On Thu, Sep 18, 2025 at 05:21:32PM -0700, Sean Christopherson wrote:
> > Set the "allow_apicv_in_x2apic_without_x2apic_virtualization" flag as part
> > of avic_hardware_setup() instead of handling in svm_hardware_setup(), and
> > make x2avic_enabled local to avic.c (setting the flag was the only use in
> > svm.c).
> > 
> > Opportunistically tag avic_hardware_setup() with __init to make it clear
> > that nothing untoward is happening with svm_x86_ops.
> > 
> > No functional change intended (aside from the side effects of tagging
> > avic_hardware_setup() with __init).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 6 ++++--
> >  arch/x86/kvm/svm/svm.c  | 4 +---
> >  arch/x86/kvm/svm/svm.h  | 3 +--
> >  3 files changed, 6 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 478a18208a76..683411442476 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -77,7 +77,7 @@ static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
> >  static u32 next_vm_id = 0;
> >  static bool next_vm_id_wrapped = 0;
> >  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
> > -bool x2avic_enabled;
> > +static bool x2avic_enabled;
> >  
> >  
> >  static void avic_set_x2apic_msr_interception(struct vcpu_svm *svm,
> > @@ -1147,7 +1147,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >   * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
> >   * - The mode can be switched at run-time.
> >   */
> > -bool avic_hardware_setup(void)
> > +bool __init avic_hardware_setup(struct kvm_x86_ops *svm_ops)
> >  {
> >  	if (!npt_enabled)
> >  		return false;
> > @@ -1182,6 +1182,8 @@ bool avic_hardware_setup(void)
> >  	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
> >  	if (x2avic_enabled)
> >  		pr_info("x2AVIC enabled\n");
> > +	else
> > +		svm_ops->allow_apicv_in_x2apic_without_x2apic_virtualization = true;
> 
> I'm not entirely convinced that this is better since svm_x86_ops fields 
> are now being updated outside of svm.c.

That doesn't bother me, e.g. the pmu_ops buried in svm_x86_ops come from
arch/x86/kvm/svm/pmu.c.  Eww, and arch/x86/kvm/svm/svm_onhyperv.h already accesses
svm_x86_ops, but in the grossest way possible.

FWIW, I don't love splitting the APIC virtualization updates between
svm_hardware_setup() and avic_hardware_setup(), but overall I do think that's the
best balance between bundling all code together and making it easy(ish) for
readers to figure out what's going on.

> But, I do see your point about  limiting x2avic_enabled to avic.c
> 
> Would it be better to name this field as svm_x86_ops here too, so it is 
> at least easy to grep and find?

I didn't want to create a potential variable shadowing "problem".  The alternative
would be to expose svm_x86_ops via svm.h.  That's not my first choice, but it's
the route that was taken for the TDX vs. VMX split (vt_init_ops and vt_x86_ops
are globally visible, even though they _could_ have been explicitly passed in
as parameters to {tdx,vmx}_hardware_setup()).

Question then.  Does anyone have a preference/opinion between explicitly passing
in ops to vendor specific helpers, vs. making {svm,vt}_x86_ops globally visible?

I don't love creating "hidden" dependencies, in quotes because in this case it's
relatively easy to establish that the setup() helpers modify {svm,vt}_x86_ops,
i.e. surprises should be rare.

On the other hand, I do agree it's helpful to be able to see exactly where
{svm,vt}_x86_ops are updated.

And most importantly, I want to be consistent between VMX and SVM, i.e. I want
to pick one and stick with it.

