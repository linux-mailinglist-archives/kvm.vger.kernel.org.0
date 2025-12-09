Return-Path: <kvm+bounces-65586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B23CB0DA1
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:36:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03FA3300DC8E
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F6F302769;
	Tue,  9 Dec 2025 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rnsV+NrX"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4E022A7E4
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765305310; cv=none; b=Pa8spfDOFMKJ/MH+Ck8n0a5BYbaTpS7q4dLFDEDk0mV3ojzPG7oiVKxc4IYPDrD3iKxVwUO6XESJXwyqiGl8dBHFtCkhM93Vr9QTHGc5zz3D3eCG7JiLsdTyCIZ7eIxksnISTRl2bJY/AEsbkUoGibd05PyZNZT85EBAM4YcZN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765305310; c=relaxed/simple;
	bh=60aZR0yaWEPhwzE2rh3FLrcA0hRrVzZA0cNlad6oEcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unxXrydrIyacJh46RlFQmPdfMYkNir0Ul1i07JCwsXe1f4kfBbxyG/mL6I+763JpSHyhqmn0fbDD4FuqPLzB+NNBQoyKyrqfLeVAZpAD0j/+EXcbanMTGCQY/gLwClIiVCaPYzg/uN5QYCaOtwQkRS+fnLeSqfzan4m9hy1C17M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rnsV+NrX; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 18:35:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765305306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yhEuEXEA6Rz3W2+CSuhlpqKGg8YMOOtDEGEXvgDo3Q0=;
	b=rnsV+NrXEjq3sxhroJie13UetZkhNdA+UEmrGlmIXLgJnTJDAsHl4lu9Kyuu1YUMQ+/YbP
	t4XQrM8CodD05VgT7Thap24E8VNm1FFP99rtr0rPLEs7c4H7h1k4R2dKX/jkRpchAh3+eU
	S7Kg+S5E9YmM3Ek/1b+fHdF6lCh5gkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
Message-ID: <fg5ipm56ejqp7p2j2lo5i5ouktzqggo3663eu4tna74u6paxpg@lque35ixlzje>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev>
 <aThN-xUbQeFSy_F7@google.com>
 <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
 <aThp19OAXDoZlk3k@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThp19OAXDoZlk3k@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 10:26:31AM -0800, Sean Christopherson wrote:
> On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > On Tue, Dec 09, 2025 at 08:27:39AM -0800, Sean Christopherson wrote:
> > > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > > @@ -400,7 +405,12 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> > > >  	struct vcpu_svm *svm = to_svm(vcpu);
> > > >  	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
> > > >  
> > > > -	return __nested_vmcb_check_controls(vcpu, ctl);
> > > > +	/*
> > > > +	 * Make sure we did not enter guest mode yet, in which case
> > > 
> > > No pronouns.
> > 
> > I thought that rule was for commit logs. 
> 
> In KVM x86, it's a rule everywhere.  Pronouns often add ambiguity, and it's much
> easier to have a hard "no pronouns" rule than to try and enforce an inherently
> subjective "is this ambiguous or not" rule.
> 
> > There are plenty of 'we's in the KVM x86 code (and all x86 code for that
> > matter) :P
> 
> Ya, KVM is an 18+ year old code base.  There's also a ton of bare "unsigned" usage,
> and other things that are frowned upon and/or flagged by checkpatch.  I'm all for
> cleaning things up when touching the code, but I'm staunchly against "tree"-wide
> cleanups just to make checkpatch happy, and so there's quite a few historical
> violations of the current "rules".

Ack.

> 
> > > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > > index f6fb70ddf7272..3e805a43ffcdb 100644
> > > > --- a/arch/x86/kvm/svm/svm.h
> > > > +++ b/arch/x86/kvm/svm/svm.h
> > > > @@ -552,7 +552,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
> > > >  
> > > >  static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> > > >  {
> > > > -	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > > +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
> > > > +		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > > 
> > > I would rather rely on Kevin's patch to clear unsupported features.
> > 
> > Not sure how Kevin's patch is relevant here, could you please clarify?
> 
> Doh, Kevin's patch only touches intercepts.  What I was trying to say is that I
> would rather sanitize the snapshot (the approach Kevin's patch takes with the
> intercepts), as opposed to guarding the accessor.  That way we can't have bugs
> where KVM checks svm->nested.ctl.nested_ctl directly and bypasses the caps check.

I see, so clear SVM_NESTED_CTL_NP_ENABLE in
__nested_copy_vmcb_control_to_cache() instead.

If I drop the guest_cpu_cap_has() check here I will want to leave a
comment so that it's obvious to readers that SVM_NESTED_CTL_NP_ENABLE is
sanitized elsewhere if the guest cannot use NPTs. Alternatively, I can
just keep the guest_cpu_cap_has() check as documentation and a second
line of defense.

Any preferences?

