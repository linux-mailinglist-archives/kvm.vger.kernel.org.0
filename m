Return-Path: <kvm+bounces-65588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0905ECB0DB7
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1464930C0CBB
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F75130276D;
	Tue,  9 Dec 2025 18:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V4hTyXCl"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB4B22A7E4
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765305514; cv=none; b=hip3pDFD4++lhMnmrhdhHZ/7bGpTyAoGtAPSv4OcPNe6ZAlWYb3mBkphl1kmuas5Bo28NQsagYjTrbHq0GS4yzRsJOH953sasxwFU3kKvpFU8Wk1YY7KWjFtxZmwf5XNzrpiX3dv0Z/6J/QKQu92TAF0WlCfjH8xkVEW9pH3M/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765305514; c=relaxed/simple;
	bh=6qqPbCCVyeKB52kTMZN2FinP3wDGBsn7gnJV/nWZiW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0mmbgW+og1a7f2IzQ4sCohVl3QG6yN3dPYHhqlGGbdYt5gl0/B9XjFQN8ZRB1/M5wmIXaRLJnapNQAsg/t0tUeIF164bf0Hm2ZFWSB02IOQ+OZBwUb7NsBFD22jXhrSyhBI/Ivbg+0qcJ7Lx57EcM+xyfk2rKhN60q2XoI8k8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V4hTyXCl; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 18:38:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765305510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HP1V+n7pe2pQa/fp7HM+XDUO3hEHAMNYJkUuhndvQAc=;
	b=V4hTyXClbARdWwuw8HhYMg4k5vXC/YU3iFJ0f81QlsZjdkTp8+V3zy5iL5VQGFAb/bG/E9
	aIdi/dndu59xhGu5gAFk5vFF951OV+lQl9c1Ezh7JOaMDNhU2QrhK5iA2fBM80B0gVWcRU
	/bK49H23hmEDA0PWP5qxCMTNfQRmgf8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 13/13] KVM: nSVM: Only copy NP_ENABLE from VMCB01's
 misc_ctl
Message-ID: <7gbwdgvzv4amhdonuhsjx4nuxe6rt5gy2weuk5ctxgqunl3sxy@bmrvy6uf7h6r>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-14-yosry.ahmed@linux.dev>
 <aThNAPkIRcTxsUMr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aThNAPkIRcTxsUMr@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 08:23:28AM -0800, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > The 'misc_ctl' field in VMCB02 is taken as-is from VMCB01. However, the
> > only bit that needs to copied is NP_ENABLE.
> 
> Nit, explicitly state that all other existing bits are for SEV right away, e.g.
> 
>   However, the only bit that needs to copied is NP_ENABLE, as all other known
>   bits in misc_ctl are related to SEV guests, and KVM doesn't support nested
>   virtualization for SEV guests.

Ack.

> 
> > This is a nop now because other bits are for SEV guests, which do not support
> > nested.  Nonetheless, this hardens against future bugs if/when other bits are
> > set for L1 but should not be set for L2.
> > 
> > Opportunistically add a comment explaining why NP_ENABLE is taken from
> > VMCB01 and not VMCB02.
> > 
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 503cb7f5a4c5f..4e278c1f9e6b3 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -837,8 +837,16 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> >  						V_NMI_BLOCKING_MASK);
> >  	}
> >  
> > -	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
> > -	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl;
> > +	/*
> > +	 * Copied from vmcb01.  msrpm_base can be overwritten later.
> > +	 *
> > +	 * NP_ENABLE in vmcb12 is only used for consistency checks.  If L1
> > +	 * enables NPTs, KVM shadows L1's NPTs and uses those to run L2. If L1
> > +	 * disables NPT, KVM runs L2 with the same NPTs used to run L1. For the
> > +	 * latter, L1 runs L2 with shadow page tables that translate L2 GVAs to
> > +	 * L1 GPAs, so the same NPTs can be used for L1 and L2.
> > +	 */
> > +	vmcb02->control.misc_ctl = vmcb01->control.misc_ctl & SVM_MISC_CTL_NP_ENABLE;
> >  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
> >  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
> >  
> > -- 
> > 2.51.2.1041.gc1ab5b90ca-goog
> > 

