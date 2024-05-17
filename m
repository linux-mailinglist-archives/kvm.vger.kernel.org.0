Return-Path: <kvm+bounces-17592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B85138C8456
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CFC6B2275B
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 09:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A722C848;
	Fri, 17 May 2024 09:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nbBbDwom"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A072561F;
	Fri, 17 May 2024 09:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715939813; cv=none; b=HUuC9hW6hM80EhKu1QbxZgalt4QSYd0ueyMvDD5GvdeKnEwrjTh2era1I2LTxYIT6FmrK9JM+231n6uLh0vT6WcJVOk/0I8oI1N9Q62OTPcKH7AQ/FrRe4JzPayoM2ZLQjwhAgK4IbQ/6h7+voghHlWs08kaAf5KwZxFSgXWavE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715939813; c=relaxed/simple;
	bh=KUl64RGT5p1k4DfrRgABpkdROBGYZ7VEd5IkWTHMINw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ssA6V2XMrAQ6BH9mIFfPfHIdHMw7U4RZfI6O4t5pOmdP/0r1xdA/duUGs87gWiIEoPXMP/i1V88Vat7JJyqPBQSnGVw0lVfXYBoBGbCxfXYYVYI1vJ+zhor1A8d/yH07TT51AFXB0uq+k8svXN3LmgjBufv0Xq0lqbKYzusWzYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nbBbDwom; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715939812; x=1747475812;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KUl64RGT5p1k4DfrRgABpkdROBGYZ7VEd5IkWTHMINw=;
  b=nbBbDwomt3PT8FDUdfTH/kNtUQrMw6domVJhkoakKkc00L/SOQYOMRk/
   WFcOmpvRgP3UjDvWc7rG3akU6tyK6ufawTiWUkOBRKlMQOG+c03YvHZXh
   V0CeZVoReNg1NFYpYJOb+UL19P19Fe3cKjjMcuwMkDNzpcVuQ+NZ3B+zW
   IMY5XYbN5kPbAvB8aY7ZR313abaoqk+WgrMcR8Y4NiVVWjjiKyxKAzIJE
   Xos0LYLBNqIKwo5lJy51GCDmA3j+gqCZJCDM7aO+xTyalOmiWqjyXQ9NK
   oWYr4zZ+Maln47ZOe1u87HPV8QMOtumo0CjUdDGLZwudPUt+2z9rGHIh+
   A==;
X-CSE-ConnectionGUID: EI9PrTJwSHSy09c0zpM2Ew==
X-CSE-MsgGUID: lvS1hlnYRkmOyOaWeUCd8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12218195"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="12218195"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 02:56:51 -0700
X-CSE-ConnectionGUID: yTxcteB6QFaIFYfsYrnX0Q==
X-CSE-MsgGUID: PRUoyf06SmaUfh/6w6JRSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="32163178"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 02:56:50 -0700
Date: Fri, 17 May 2024 02:56:49 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <20240517095649.GB412700@ls.amr.corp.intel.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
 <20240507154459.3950778-8-pbonzini@redhat.com>
 <ZkVHh49Hn8gB3_9o@google.com>
 <Zka1cub00xu37mHP@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zka1cub00xu37mHP@google.com>

On Thu, May 16, 2024 at 06:40:02PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Wed, May 15, 2024, Sean Christopherson wrote:
> > On Tue, May 07, 2024, Paolo Bonzini wrote:
> > > @@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> > >  	if (is_invalid_opcode(intr_info))
> > >  		return handle_ud(vcpu);
> > >  
> > > +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
> > > +		return -EIO;
> > 
> > I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
> > the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
> > still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.
> > 
> > I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
> > there's another bug lurking.
> 
> *sigh*
> 
> AFAICT, I'm hitting a hardware issue.  The #VE occurs when the CPU does an A/D
> assist on an entry in the L2's PML4 (L2 GPA 0x109fff8).  EPT A/D bits are disabled,
> and KVM has write-protected the GPA (hooray for shadowing EPT entries).  The CPU
> tries to write the PML4 entry to do the A/D assist and generates what appears to
> be a spurious #VE.
> 
> Isaku, please forward this to the necessary folks at Intel.  I doubt whatever
> is broken will block TDX, but it would be nice to get a root cause so we at least
> know whether or not TDX is a ticking time bomb.

Sure, let me forward it.
I tested it lightly myself.  but I couldn't reproduce it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

