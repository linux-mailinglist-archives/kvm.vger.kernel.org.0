Return-Path: <kvm+bounces-67357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDDFD018F2
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 09:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4DF3F31081B0
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 08:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D537C335093;
	Thu,  8 Jan 2026 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sg0Ah/VO"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D073659FD
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 07:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767859196; cv=none; b=oB0Ke3Orm1H66fHBSo3mLFlLIvBTgk8BWMtYM8F7aOmOndSxP5hdLULLjgsdOk8Vfk04P1vkmt5f6a833yp2ZkxasDaT72OnfFlJo/BJPiWkmebk1ALoVV8Anqicu80QjomRmibZJiApN+1Kd2pC9Rh9vs0RmKLDuPJfOLhL+gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767859196; c=relaxed/simple;
	bh=XIQgbGfyI5/B7aBhiiYpYV6qVfzyoscRfYaj8AhHw/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mMBHFEHFiI6cL1J2lcTs1LtUknQUIsJlo70M28A5SMimhJ0jnmjbVxWPDub0eGYGbGPeeBX8GKLL1ifM3budgVhXqN1VB7KBxWkE3fH5Q1WPNfmixk9vFJgoJJFgORgNSvUBvIPVODE1+1LLFoyF8c0PDDBEs8IqabqQ++FXaws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sg0Ah/VO; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 8 Jan 2026 07:59:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767859171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4LEqZ8ACZ6e8ETcPjAD3s8K1nWDc/6G9zH434BO144I=;
	b=sg0Ah/VOOkHkNeE0zWeHF7091VyqesyBmKOBTHTz3o8T7dv5qfifoqxT4VbENgZwUee+BL
	tWIsNQ11KqKlmp1hj9AKVJzWhxeIi3vefSgeO9TgJnnTMTBipXSAxdXI6hklyRY+sn1BRl
	Hm66Mj4vTNj1RIEf8MBqjBo2Ozx1dwQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if
 L2 is active
Message-ID: <z3i7gmjq6e4hsokfemknvpdeubnifivvl4xxf4pvrlqdtv4mkq@bvhftx7fsdbk>
References: <20251230205641.4092235-1-seanjc@google.com>
 <shaevlgw5h7i3oxtoj6yqun3mklwdi6nng3noypxeqevnuqlcu@urfhn55x7owk>
 <aV7Be9k2KBEQCisT@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV7Be9k2KBEQCisT@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 07, 2026 at 12:26:35PM -0800, Sean Christopherson wrote:
> On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> > On Tue, Dec 30, 2025 at 12:56:41PM -0800, Sean Christopherson wrote:
> 
> > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > index fdab0ad49098..9084e0dfa15c 100644
> > > --- a/arch/x86/kvm/x86.h
> > > +++ b/arch/x86/kvm/x86.h
> > > @@ -172,9 +172,9 @@ static inline void kvm_nested_vmexit_handle_ibrs(struct kvm_vcpu *vcpu)
> > >  		indirect_branch_prediction_barrier();
> > >  }
> > >  
> > > -static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
> > > +static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
> > >  {
> > > -	return vcpu->arch.last_vmentry_cpu != -1;
> > > +	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
> > >  }
> > 
> > To make this self-contained (e.g. for readers not coming from
> > kvm_set_cpuid()), should we add a comment here about is_guest_mode()
> > only possibly being true with last_vmentry_cpu == -1 if userspace does
> > the set CPUID, set nested state, set CPUID again dance?
> 
> Ya.  If this looks good, I'll add it when applying.
> 
> /*
>  * Disallow modifying CPUID and feature MSRs, which affect the core virtual CPU
>  * model exposed to the guest and virtualized by KVM, if the vCPU has already
>  * run or is in guest mode (L2).  In both cases, KVM has already consumed the
>  * current virtual CPU model, and doesn't support "unwinding" to react to the
>  * new model.
>  *
>  * Note, the only way is_guest_mode() can be true with 'last_vmentry_cpu == -1'
>  * is if userspace sets CPUID and feature MSRs (to enable VMX/SVM), then sets
>  * nested state, and then attempts to set CPUID and/or feature MSRs *again*.
>  */
> static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
> {
> 	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
> }

Looks good to me.

