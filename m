Return-Path: <kvm+bounces-39930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CFCBA4CDDF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A03F018958EC
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DDC230BE0;
	Mon,  3 Mar 2025 22:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oR+U18gD"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E59D1F1301
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741039624; cv=none; b=E095dB64UBA4wW+0W6jEW2mIi5Fa+6wy+LL8YTBth1ybEUaXCO2GKBa4W+OCupLDqIfLjPCN1RnYtQB9Q4CYoZsHOXiS8AmEepgoPAy0HnbbH3x8jLAhCPtDEfSEop61oF53TS7xBpKnlBjDxTVORB+A0dGSwG0p6glajwEh0/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741039624; c=relaxed/simple;
	bh=QeY9z0+heLtap8BgmoW1vF5Flfd7VVfdLHG+7vA0RM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sO57pUAudgINOFo3rWM0HlqwnME4BNXvb9HmwJ/0XbjMe4IBqkvRrbYeajI1XHxvfYFM+WD0CYwlEq8TzcRrRqxPCkf+BT8b1IfhJuAwydy7OC2ZIhsxPwWWRKrR7RZ+hSUnKVIPjnLkieu7c9pfScEHV0w/xrRPLI49UTZd+Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oR+U18gD; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 3 Mar 2025 22:06:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741039610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DQl5R4ebaZvP3xaAFBotmrLK16G34ov3SP3Vi7Kwp+U=;
	b=oR+U18gDDnv2P4Bbry71Vgi6YOA1sxdYR5UFhmEIZzwxhZs1setu4H8KOPQ71LncvVhc40
	mK0UgrNQzfcxueHIYkUqJzg0U6O0GyOXicTvqsQhlaoXrJpny35um+crfEm52u/YM2gB5G
	o8Amlm5l97w91jeGdaGd7COFeQ7dAvQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 08/13] KVM: nSVM: Flush both L1 and L2 ASIDs on
 KVM_REQ_TLB_FLUSH
Message-ID: <Z8Yn9va1xgIUvNUS@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-9-yosry.ahmed@linux.dev>
 <0ca86313d7fc0360009888243b1493c2bd44fb7b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ca86313d7fc0360009888243b1493c2bd44fb7b.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 08:58:04PM -0500, Maxim Levitsky wrote:
> On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> > KVM_REQ_TLB_FLUSH is used to flush all TLB entries for all contexts
> > (e.g. in kvm_flush_remote_tlbs()). Flush both L1 and L2 ASIDs in
> > svm_flush_tlb_all() to handle it appropriately.
> > 
> > This is currently not required as nested transitions do unconditional
> > TLB flushes, but this is a step toward eliminating that.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 1 -
> >  arch/x86/kvm/svm/svm.c    | 4 +++-
> >  2 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 0e9b0592c1f83..0735177b95a1d 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -491,7 +491,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
> >  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
> >  	 * things to fix before this can be conditional:
> >  	 *
> > -	 *  - Flush TLBs for both L1 and L2 remote TLB flush
> >  	 *  - Honor L1's request to flush an ASID on nested VMRUN
> >  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
> >  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 9e29f87d3bd93..8342c7eadbba8 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4044,7 +4044,9 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
> >  	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
> >  		hv_flush_remote_tlbs(vcpu->kvm);
> >  
> > -	svm_flush_tlb_asid(vcpu, svm->current_vmcb);
> > +	svm_flush_tlb_asid(vcpu, &svm->vmcb01);
> > +	if (svm->nested.initialized)
> > +		svm_flush_tlb_asid(vcpu, &svm->nested.vmcb02);
> >  }
> 
> This makes sense.
> 
> Note that this doesn't really flush the ASID used, but rather ensures
> that we will flush it on next entry via that vmcb. (because of new asid,
> that will be picked, or because we set tlb_ctl in that vmcb)

Right, what I mean by 'flush' here is to setup the flush. For SVM all
flushes are done on VM-enter anyway.

> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Thanks!

