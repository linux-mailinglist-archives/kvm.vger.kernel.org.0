Return-Path: <kvm+bounces-65887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7170BCB9952
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 19:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 002973093A9E
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 18:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56F7A309EE2;
	Fri, 12 Dec 2025 18:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T+Sg+btb"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2792D63E5
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765564747; cv=none; b=BPA6KMGr6cUBiligIoPOmnMM8t7HStg8SLoosNGoE/yLUWM1fifZoWkfaljVxS9yPa1cCoJGXHF10PgRXSq6TSNqrTK1XclgsUDHVp1qR1DCwLewVWtGRu/JqE4WTl3LzNJ36cPaS0FiBiJnvVSvg61ThyQ/OMd2Ak9Expa8yio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765564747; c=relaxed/simple;
	bh=ugsAxYUS9SCyFXBF83/tUkvvJ7g1dDLQggQVawaI32Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qK0sYcWRkUm4QcxjbTlWk92qivcgyLMWlxDTJzQSaLeBn+vv66l31dOXcjYCa/Sijcw5a/hPoX05rUHzSV+9e7EAwX8btw8RoQMWRMGdzmUrHTzrf3vyvr9dZ2h/us3fjER/C3CcaTFafhfNZ9XYyrnb6XrWFm8Bwjna6YBaEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T+Sg+btb; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 12 Dec 2025 18:38:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765564741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B6WpVlTtFAykjN1mH2MObKgqxHP2mRYBhEJpH91B0wU=;
	b=T+Sg+btbW+HivP2Serg6GSw+CNDcXGuiJpPh6oi9YT9H3Eb+DpUCc0INbrZ6USmlXb83tB
	vtN6IED80A3Kg7e9tcXEG1S0z9x5fFQQC9Yh2ywpU8b/SCcjVbPCBYuDxUhBSQ282IdgWw
	/GGs5Tm41bMwl4rTv1L6x8dRgY4MzyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
Message-ID: <sjxsi4udjj6acl5sm6u7vqxrplo5oshwgaoor2wmm3iza5h5fj@cbnzxcmwliwy>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev>
 <aThN-xUbQeFSy_F7@google.com>
 <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
 <aThp19OAXDoZlk3k@google.com>
 <fg5ipm56ejqp7p2j2lo5i5ouktzqggo3663eu4tna74u6paxpg@lque35ixlzje>
 <aThtjYG3OZTtdwUA@google.com>
 <pit2u5dpjpchsbz3pyujk62smysco5z37i3z3qosdscx6bddqj@i6fjafx5fxlz>
 <aTxftw3XcIrwyTzK@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTxftw3XcIrwyTzK@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Dec 12, 2025 at 10:32:23AM -0800, Sean Christopherson wrote:
> On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > On Tue, Dec 09, 2025 at 10:42:21AM -0800, Sean Christopherson wrote:
> > > On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > > > On Tue, Dec 09, 2025 at 10:26:31AM -0800, Sean Christopherson wrote:
> > > > > On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > > > > > > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > > > > > index f6fb70ddf7272..3e805a43ffcdb 100644
> > > > > > > > --- a/arch/x86/kvm/svm/svm.h
> > > > > > > > +++ b/arch/x86/kvm/svm/svm.h
> > > > > > > > @@ -552,7 +552,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
> > > > > > > >  
> > > > > > > >  static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> > > > > > > >  {
> > > > > > > > -	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > > > > > +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
> > > > > > > > +		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > > > > 
> > > > > > > I would rather rely on Kevin's patch to clear unsupported features.
> > > > > > 
> > > > > > Not sure how Kevin's patch is relevant here, could you please clarify?
> > > > > 
> > > > > Doh, Kevin's patch only touches intercepts.  What I was trying to say is that I
> > > > > would rather sanitize the snapshot (the approach Kevin's patch takes with the
> > > > > intercepts), as opposed to guarding the accessor.  That way we can't have bugs
> > > > > where KVM checks svm->nested.ctl.nested_ctl directly and bypasses the caps check.
> > > > 
> > > > I see, so clear SVM_NESTED_CTL_NP_ENABLE in
> > > > __nested_copy_vmcb_control_to_cache() instead.
> > > > 
> > > > If I drop the guest_cpu_cap_has() check here I will want to leave a
> > > > comment so that it's obvious to readers that SVM_NESTED_CTL_NP_ENABLE is
> > > > sanitized elsewhere if the guest cannot use NPTs. Alternatively, I can
> > > > just keep the guest_cpu_cap_has() check as documentation and a second
> > > > line of defense.
> > > > 
> > > > Any preferences?
> > > 
> > > Honestly, do nothing.  I want to solidify sanitizing the cache as standard behavior,
> > > at which point adding a comment implies that nested_npt_enabled() is somehow special,
> > > i.e. that it _doesn't_ follow the standard.
> > 
> > Does this apply to patch 12 as well? In that patch I int_vector,
> 
> I <something>?

I "sanitize" int_vector..

Sorry :D

> 
> > int_state, and event_inj when copying them to VMCB02 in
> > nested_vmcb02_prepare_control(). Mainly because
> > nested_vmcb02_prepare_control() already kinda filters what to copy from
> > VMCB12 (e.g. int_ctl), so it seemed like a better fit.
> > 
> > Do I keep that as-is, or do you prefer that I also sanitize these fields
> > when copying to the cache in nested_copy_vmcb_control_to_cache()?
> 
> I don't think I follow.  What would the sanitization look like?  Note, I don't
> think we need to completely sanitize _every_ field.  The key fields are ones
> where KVM consumes and/or acts on the field.

Patch 12 currently sanitizes what is copied from VMCB12 to VMCB02 for
int_vector, int_state, and event_inj in nested_vmcb02_prepare_control():

@@ -890,9 +893,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		(svm->nested.ctl.int_ctl & int_ctl_vmcb12_bits) |
 		(vmcb01->control.int_ctl & int_ctl_vmcb01_bits);

-	vmcb02->control.int_vector          = svm->nested.ctl.int_vector;
-	vmcb02->control.int_state           = svm->nested.ctl.int_state;
-	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
+	vmcb02->control.int_vector          = svm->nested.ctl.int_vector & SVM_INT_VECTOR_MASK;
+	vmcb02->control.int_state           = svm->nested.ctl.int_state & SVM_INTERRUPT_SHADOW_MASK;
+	vmcb02->control.event_inj           = svm->nested.ctl.event_inj & ~SVM_EVTINJ_RESERVED_BITS;
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;

My question was: given this:

> I want to solidify sanitizing the cache as standard behavior

Do you prefer that I move this sanitization when copying from L1's
VMCB12 to the cached VMCB12 in nested_copy_vmcb_control_to_cache()?

I initially made it part of nested_vmcb02_prepare_control() as it
already filters what to pick from the VMCB12 for some other related
fields like int_ctl based on what features are exposed to the guest.

