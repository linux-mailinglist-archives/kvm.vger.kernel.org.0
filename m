Return-Path: <kvm+bounces-65661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A761CB3742
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 17:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A717F31B9FA6
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 16:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D503271F0;
	Wed, 10 Dec 2025 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hYqDDIla"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2824A3271F1
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765383402; cv=none; b=tiJILXbAP/a0ykTEXEkrQ8KkA7nf62y6mpgrQOiFDjPsEfFUN7qzZuhHAFBmT8rOFd5USW1Qn48y9GC9WwJOCp7zvDty/X8LwRWauVL62l9f5/53fc1yGuhdcAD9KKvS6k/sXw0BYJ6fKjXZCcoWVaA70tkqgqTDMXCjVc34oWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765383402; c=relaxed/simple;
	bh=TKFFj9rGF0zLN5qCoPJduzj6mJRFknHTNglT+iktPdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZr58VLJk0Z3CBNXMvgJvPI8otrtO4JPKvoDqanSEoPRYgMHfi3naCa/T4xoeq/7hqEZsCAt3Rs+2NxTx4DXjXWishT6MVQ9do0G+xfBLxG6QS6y5QHyH3ZFOIDn101QXil+rROiSFzN1wyuXn07DU8v0OMYEhsJVE1E4SG3g48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hYqDDIla; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 10 Dec 2025 16:16:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765383388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kdb4e5CBOLhxzZJozjNLpejNR2Z9AHRhqo03oKk4EXg=;
	b=hYqDDIlaRSsMond/6QCG7/oIYNTJDWXa518e9LtisXw0g2nbLQEirQG5xzgoz3HbRU5KD6
	khBo7ZElx6gLMCgBxJqNg+XP7D0A55zqaA+4sNqAxZKz/c7jKs6fEfHkVssjzPX+Can4ab
	1Q174RUL0sRjErp4ewRmuOJJIO4omKA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
Message-ID: <rckoq7j5pbe7rkszw7d7kkcyjpjpmdwexyrlcw2hyf6cgzpohf@scxmalwv6buz>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-12-yosry.ahmed@linux.dev>
 <aThKPT9ItrrDZdSd@google.com>
 <ttlhqevbe7rq5ns4vyk6e2dtlflbrkcfdabwr63jfnszshhiqs@z7ixbtq6zsla>
 <aThz5p655rk8D1KS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThz5p655rk8D1KS@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 11:09:26AM -0800, Sean Christopherson wrote:
> On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > On Tue, Dec 09, 2025 at 08:11:41AM -0800, Sean Christopherson wrote:
> > > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > > Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> > > > the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> > > > simplifies the flow of nested_svm_vmrun() and removes all jumps to
> > > > cleanup labels.
> > > > 
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
> > > >  1 file changed, 13 insertions(+), 15 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index a48668c36a191..89830380cebc5 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> > > >  
> > > >  	nested_svm_hv_update_vm_vp_ids(vcpu);
> > > >  
> > > > +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> > > 
> > > This is silly, just do:
> > 
> > Ack. Any objections to just dropping from_vmrun and moving
> > kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES) to svm_leave_smm()? I
> > like the consistency of completely relying on from_vmrun or not at all
> 
> Zero objections.  When I was initially going through this, I actually thought you
> were _adding_ the flag and was going to yell at you :-)

Ugh from_vmrun is also plumbed into nested_svm_load_cr3() as
reload_pdptrs. Apparently we shouldn't do that in the call path from
svm_leave_smm()? Anyway, seems like it'll be non-trivial to detangle (at
least for me, I have 0 understanding of SMM), so I will leave it as-is.

