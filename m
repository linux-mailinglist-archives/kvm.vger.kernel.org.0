Return-Path: <kvm+bounces-70451-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLgKBzYGhmkRJQQAu9opvQ
	(envelope-from <kvm+bounces-70451-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:18:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4358FF9FD
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:18:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 75E87309DFD5
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 15:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E786284B25;
	Fri,  6 Feb 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bKvpcRYh"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97A27E07E
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 15:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770390806; cv=none; b=f7sWTQMaE0W3fbsIMeeK6LQIQ7j6nBSs/C1+GhA7IpwZIw2cuFeK3alLLik9l8TqQFzPjzP2TXPDUW0+p/4ycRNW0gqBVYZ5K1Rh7yG7+TqNKZvFMX6NITwJVDoY3smqdgBl7iYEVa2CSZvYvQlNV1teU4w1EV66ci/6HCLvsjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770390806; c=relaxed/simple;
	bh=VGDpcZs4wh3X0ELZmDf1A8jLwy51JCWu68abSGJ8xsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1rX+2wYMdAFwCl8XFkAkn4PsM9NCH4DpWCo6vqTjWtXMMBRmB7e5bgGqdzcjsCO0qhj6gUuWbvHu4G14rs8LWxdzgN6npUsPypyxjq2AhWezCodsNsT6HRadJFvyYD/J0A4/2n8dmMCcahnnBuDJFty8nSbsOebtuAPtUxFSIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bKvpcRYh; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 6 Feb 2026 15:13:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770390794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6GhCiI1MVdQpzIRk///55B2tiiX9XgXKGwr6SedztNw=;
	b=bKvpcRYhAzUbuABI0lMmbeIGwXlb79s402IEmSIOlRev0pVGYE8272LcEpB11T483hxVPX
	1al711RWgUVS4OLJM3O880P0v9QxVb+rByBjZAfOU0ZTOMdVLEAkEh4dkMNN/++3qRtElX
	t3npxiRMVzB4cr+PmNbmFhT2AO6pLpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 01/26] KVM: SVM: Switch svm_copy_lbrs() to a macro
Message-ID: <usc5ysverr7gtt4itnw2s22s5hpfbtgwttm74i25gxbqm3b6cb@x2i4nzlo2wbz>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
 <20260115011312.3675857-2-yosry.ahmed@linux.dev>
 <aYU87QeMg8_kTM-G@google.com>
 <b92c2a7c7bcdc02d49eb0c0d481f682bf5d10c76@linux.dev>
 <aYVC-1Pk01kQVJqD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYVC-1Pk01kQVJqD@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70451-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: C4358FF9FD
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 05:25:15PM -0800, Sean Christopherson wrote:
> On Fri, Feb 06, 2026, Yosry Ahmed wrote:
> > February 5, 2026 at 4:59 PM, "Sean Christopherson" <seanjc@google.com> wrote:
> > > On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > > > In preparation for using svm_copy_lbrs() with 'struct vmcb_save_area'
> > > >  without a containing 'struct vmcb', and later even 'struct
> > > >  vmcb_save_area_cached', make it a macro. Pull the call to
> > > >  vmcb_mark_dirty() out to the callers.
> > > >  
> > > >  Macros are generally not preferred compared to functions, mainly due to
> > > >  type-safety. However, in this case it seems like having a simple macro
> > > >  copying a few fields is better than copy-pasting the same 5 lines of
> > > >  code in different places.
> > > >  
> > > >  On the bright side, pulling vmcb_mark_dirty() calls to the callers makes
> > > >  it clear that in one case, vmcb_mark_dirty() was being called on VMCB12.
> > > >  It is not architecturally defined for the CPU to clear arbitrary clean
> > > >  bits, and it is not needed, so drop that one call.
> > > >  
> > > >  Technically fixes the non-architectural behavior of setting the dirty
> > > >  bit on VMCB12.
> > > > 
> > > Stop. Bundling. Things. Together.
> > > 
> > > /shakes fist angrily
> > > 
> > > I was absolutely not expecting a patch titled "KVM: SVM: Switch svm_copy_lbrs()
> > > to a macro" to end with a Fixes tag, and I was *really* not expecting it to also
> > > be Cc'd for stable.
> > > 
> > > At a glance, I genuinely can't tell if you added a Fixes to scope the backport,
> > > or because of the dirty vmcb12 bits thing.
> > > 
> > > First fix the dirty behavior (and probably tag it for stable to avoid creating
> > > an unnecessary backport conflict), then in a separate patch macrofy the helper.
> > > Yeah, checkpatch will "suggest" that the stable@ patch should have Fixes, but
> > > for us humans, that's _useful_ information, because it says "hey you, this is a
> > > dependency for an upcoming fix!". As written, I look at this patch and go "huh?".
> > > (and then I look at the next patch and it all makes sense).
> > 
> > I agree, but fixing the dirty behavior on its own requires open-coding the
> > function, then the following patch would change it to a macro and use it
> > again. I was trying to minimize the noise of moving code back and forth..
> 
> I don't follow.  Isn't it just this?

Yeah ignore the previous comment, I was thinking about something else.

> 
> @@ -848,8 +859,6 @@ void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>         to_vmcb->save.br_to             = from_vmcb->save.br_to;
>         to_vmcb->save.last_excp_from    = from_vmcb->save.last_excp_from;
>         to_vmcb->save.last_excp_to      = from_vmcb->save.last_excp_to;
> -
> -       vmcb_mark_dirty(to_vmcb, VMCB_LBR);
>  }
>  
>  static void __svm_enable_lbrv(struct kvm_vcpu *vcpu)
> @@ -877,6 +886,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>                             (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
>                             (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
>  
> +       vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
> +

Although I would rather keep this in callers of svm_copy_lbrs(), instead
of hiding it here. For example, in nested_svm_vmexit(), this would be
wrong if the call to svm_switch_vmcb() was moved a bit later (which
would be wrong for other reasons, but the clean bit wouldn't be
obvious).

It also makes it obvious that we are specifically not dirtying vmcb12.

>         if (enable_lbrv && !current_enable_lbrv)
>                 __svm_enable_lbrv(vcpu);
>         else if (!enable_lbrv && current_enable_lbrv)
> @@ -3079,7 +3090,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>                         break;
>  
>                 svm->vmcb->save.dbgctl = data;
> -               vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
>                 svm_update_lbrv(vcpu);
>                 break;
>         case MSR_VM_HSAVE_PA:

