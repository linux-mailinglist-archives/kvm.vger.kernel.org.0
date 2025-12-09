Return-Path: <kvm+bounces-65593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77F90CB0FDB
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 21:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C58B30DC7E5
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 20:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16DF2FF177;
	Tue,  9 Dec 2025 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="slmFg5Yi"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C551A724C
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765310564; cv=none; b=ZHuFDLwC29oghAb/erhNs21MEENbC11c1ANEjvHtEJuX6dKH9pu+MBBLK+vWXs6g8bB6SxrD/p3LX9g0ypH5KtNNtXn4bncDHKlwg0Lk655KJ4L1rP+/9g3cMqC1wjUAjpEDMuMeZanwe3/s4W6FXOLYV8S3VaOGb3INMoFYjyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765310564; c=relaxed/simple;
	bh=Qn67Z1bOXmsWYygquny0KKhPpKQMoAyvpAsb81V1wdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMqJwry3uXDp6MtqIPHSTSDoS6oPdfKQyvni84R80dH/WPI3EtA0TqqPGSdhlgpNdCNDNjqv/BQneMdnIHi+Z7YYaTLPKuh1qykzxhjXlbvGtjS7wZScO1LBWZXiAgX51mpOsuT90pf3j5Zw8ktSwv6bGUW+uqxgu6N3gZfh2pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=slmFg5Yi; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 20:02:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765310550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FMDBleQOXV07/rPpyZlnRLa1LE6+aRZnqwPmXqENy18=;
	b=slmFg5Yi15EXoN9VZTBFDPjGjeYVWe8m3pj7o5G4Q2XIk5AMg7W9b1xY3KUEtjlp9vAwZc
	9bntyvlz5iy9uXMi60EUtdHxLM9CGA+HGHqevFN0Nr8qjs7ze7W6m1aHVUjGWZ5U8vvlCM
	+aHpDGGJB8wPOLZkZDPc2FDfhtgszP4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
Message-ID: <pit2u5dpjpchsbz3pyujk62smysco5z37i3z3qosdscx6bddqj@i6fjafx5fxlz>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev>
 <aThN-xUbQeFSy_F7@google.com>
 <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
 <aThp19OAXDoZlk3k@google.com>
 <fg5ipm56ejqp7p2j2lo5i5ouktzqggo3663eu4tna74u6paxpg@lque35ixlzje>
 <aThtjYG3OZTtdwUA@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThtjYG3OZTtdwUA@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 10:42:21AM -0800, Sean Christopherson wrote:
> On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > On Tue, Dec 09, 2025 at 10:26:31AM -0800, Sean Christopherson wrote:
> > > On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > > > > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > > > index f6fb70ddf7272..3e805a43ffcdb 100644
> > > > > > --- a/arch/x86/kvm/svm/svm.h
> > > > > > +++ b/arch/x86/kvm/svm/svm.h
> > > > > > @@ -552,7 +552,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
> > > > > >  
> > > > > >  static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> > > > > >  {
> > > > > > -	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > > > +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
> > > > > > +		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > > 
> > > > > I would rather rely on Kevin's patch to clear unsupported features.
> > > > 
> > > > Not sure how Kevin's patch is relevant here, could you please clarify?
> > > 
> > > Doh, Kevin's patch only touches intercepts.  What I was trying to say is that I
> > > would rather sanitize the snapshot (the approach Kevin's patch takes with the
> > > intercepts), as opposed to guarding the accessor.  That way we can't have bugs
> > > where KVM checks svm->nested.ctl.nested_ctl directly and bypasses the caps check.
> > 
> > I see, so clear SVM_NESTED_CTL_NP_ENABLE in
> > __nested_copy_vmcb_control_to_cache() instead.
> > 
> > If I drop the guest_cpu_cap_has() check here I will want to leave a
> > comment so that it's obvious to readers that SVM_NESTED_CTL_NP_ENABLE is
> > sanitized elsewhere if the guest cannot use NPTs. Alternatively, I can
> > just keep the guest_cpu_cap_has() check as documentation and a second
> > line of defense.
> > 
> > Any preferences?
> 
> Honestly, do nothing.  I want to solidify sanitizing the cache as standard behavior,
> at which point adding a comment implies that nested_npt_enabled() is somehow special,
> i.e. that it _doesn't_ follow the standard.

Does this apply to patch 12 as well? In that patch I int_vector,
int_state, and event_inj when copying them to VMCB02 in
nested_vmcb02_prepare_control(). Mainly because
nested_vmcb02_prepare_control() already kinda filters what to copy from
VMCB12 (e.g. int_ctl), so it seemed like a better fit.

Do I keep that as-is, or do you prefer that I also sanitize these fields
when copying to the cache in nested_copy_vmcb_control_to_cache()?

