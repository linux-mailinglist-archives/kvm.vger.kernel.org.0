Return-Path: <kvm+bounces-21232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE70292C3CE
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D38F1F23671
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3559D182A6A;
	Tue,  9 Jul 2024 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DmgJZp/W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9581B86E1
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552513; cv=none; b=mifPq/aKZu1UfTspG8wU9P+D+kK+30Iw6cs08szuJCA1hAA9o9eRk/icqKi2pspM/2UAzm1XpkVPf+gAbYpdOtH05mWUwlmwunLh/AwuuIhrxJFvHw+Yq67v+OOu6/LBla+M2GoJPp5C7/+O8v0fgzFyeJM4O6yL1fYVKxHUqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552513; c=relaxed/simple;
	bh=GL5HvXrhTnvH+rd/+8oEb5fbI99ZD4Bj2rNYIrD+RDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y/Jd7S5A/pLUjuG2rzN0+ltFgxZVFWLGPCgIyOjCwRbhMFofCeAnzC8K/MJgrhNOh2MiAF07tJ1CeJS4o7D+cO2QSni78UKhXPwuFdoI38PcG8nNXHYLBd1HwOH7hNBQIoHwZOwXOd9wdyeb4OZlhQs0QnqDGJcJ/48jbzFxjMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DmgJZp/W; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-767c010fe18so2677558a12.2
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 12:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720552511; x=1721157311; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FRa7ZGzc8RaHWEqAnxaXdSPq2q3+qsWc7fj1GOqpbLM=;
        b=DmgJZp/WIsyxxVR+jIMi7TRv62HCHDfhWXPgxQtJhv1KuOMkNwchA3aSyVz3f6TEl6
         TIAubrnwbQh2yxoh7IE10OW3aTkXinvnkPCqUMe8R0UfMUo3Tr9H7QB7c8KzOvShZOIB
         1312BrOJz9/asS3I+10Z5rG1vIANJEfuPT1TurVKsPvjABKSX2+I/PHpqOq+wetW1lfd
         OiJAMN+HjwVJj10OnlZi4If00GhwMGeoaIOVWAn2qSOHgFh+32Af39BsBNL8MLWXeRcW
         OZzWCiMjfv2dY5tB8NifJTOBDECR6FUaICMhH8X5ijzNc3NGCeCsABsBpfR1cwI+iQ+w
         z/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720552511; x=1721157311;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FRa7ZGzc8RaHWEqAnxaXdSPq2q3+qsWc7fj1GOqpbLM=;
        b=GqHLa2/VpT/Ad6jLr2gH5jf/Z0eCLWdsGHB57KQvFqcAl06PP9oscIL/oy+I0c2/NQ
         Lo5e75m4NOR3nlOgxbVbTLXDfo4CFhZ5oFuOIWAZnXCyb7+Y3zt5/jqYbEG0MfEkCBHb
         W5RYT5sKmM+vbm6G7LEMBU2SYIoiVouvWe0gKS56uIrSCD28sc7dw2ABC8SWkmEWHB3t
         16MTDN0jPXkFNAxvJmljZ1Ux4lzIALyjcGvjPuHznb6hIHQDBWMYucDosimelS5Vuhap
         Qosg81u84PJSSI1CHvRwWZqR9dlzl9J42snO4Xu99PG9Jlpo+ObbKX+eNkO1Mw1RciTd
         NGNw==
X-Forwarded-Encrypted: i=1; AJvYcCXcA1MptiwJe4yqd6xH6lZe4waiQqKvQoqgRzUiFIhWise0K9R16V7zFAULNI46BVyaFRlalrCtIpOUYGrcvaRgpDXL
X-Gm-Message-State: AOJu0YxoxeXDKmwb3g4xni+nnVb+/Ak9RVDjhuuy31lQgSb1lxrQEtHm
	RZBtY7coucPsFRvQwt/rj8ld2t/NM/zvdLLwJinseY8esJcVFL3W7tTkVvR42oJJ112QkkKl4ds
	ayg==
X-Google-Smtp-Source: AGHT+IEBlgoKo2SXuEYo/1nV2K0XpxZIpDEQZ5fuzNWKnNDIVX1Sc5c97+FM4pmyhIYhXb8m8qVsHhcobIk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4660:0:b0:75b:fd10:a196 with SMTP id
 41be03b00d2f7-77db448a3b0mr17807a12.1.1720552511201; Tue, 09 Jul 2024
 12:15:11 -0700 (PDT)
Date: Tue, 9 Jul 2024 12:15:09 -0700
In-Reply-To: <46361f0c834a25ad0a45ca2f1813ade603d29201.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-48-seanjc@google.com>
 <46361f0c834a25ad0a45ca2f1813ade603d29201.camel@redhat.com>
Message-ID: <Zo2MPSccg3AEz4qM@google.com>
Subject: Re: [PATCH v2 47/49] KVM: x86: Drop superfluous host XSAVE check when
 adjusting guest XSAVES caps
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> > Drop the manual boot_cpu_has() checks on XSAVE when adjusting the guest's
> > XSAVES capabilities now that guest cpu_caps incorporates KVM's support.
> > The guest's cpu_caps are initialized from kvm_cpu_caps, which are in turn
> > initialized from boot_cpu_data, i.e. checking guest_cpu_cap_has() also
> > checks host/KVM capabilities (which is the entire point of cpu_caps).
> > 
> > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 1 -
> >  arch/x86/kvm/vmx/vmx.c | 3 +--
> >  2 files changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 06770b60c0ba..4aaffbf22531 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4340,7 +4340,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	 * the guest read/write access to the host's XSS.
> >  	 */
> >  	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
> > -			     boot_cpu_has(X86_FEATURE_XSAVE) &&
> >  			     boot_cpu_has(X86_FEATURE_XSAVES) &&
> >  			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
> 
> >  
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 741961a1edcc..6fbdf520c58b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7833,8 +7833,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> >  	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
> >  	 * set if and only if XSAVE is supported.
> >  	 */
> 
> 
> > -	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
> > -	    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> > +	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
> >  		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
> 
> Hi,
> 
> I have a question about this code, even before the patch was applied:
> 
> While it is obviously correct to disable XSAVES when XSAVE not supported, I
> wonder: There are a lot more cases like that and KVM explicitly doesn't
> bother checking them, e.g all of the AVX family also depends on XSAVE due to
> XCR0.
> 
> What makes XSAVES/XSAVE dependency special here? Maybe we can remove this
> code to be consistent?

Because that would result in VMX and SVM behavior diverging with respect to
whether guest_cpu_cap_has(X86_FEATURE_XSAVES).  E.g. for AMD it would be 100%
accurate, but for Intel it would be accurate if and only if XSAVE is supported.

In practice that isn't truly problematic, because checks on XSAVES from common
code are gated on guest CR4.OSXSAVE=1, i.e. implicitly check XSAVE support.  But
the potential danger of sublty divergent behavior between VMX and SVM isn't worth
making AVX vs. XSAVES consistent within VMX, especially since VMX vs. SVM would
still be inconsistent.

> AMD portion of this patch, on the other hand does makes sense, due to a lack
> of a separate XSAVES intercept.

FWIW, AMD also needs precise tracking in order to passthrough XSS for SEV-ES.

