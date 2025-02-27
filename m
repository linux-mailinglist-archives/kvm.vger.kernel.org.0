Return-Path: <kvm+bounces-39426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71162A47091
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7408216DEF9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAFC21348;
	Thu, 27 Feb 2025 00:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XVEjDOgP"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B20270042
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740617659; cv=none; b=a6zIEz0/9IdxtICNQAg/kg2KYmDm3g3vvaN3EpJmUvV6CCj6xvsFVb6zvZNEQdJIf5B2ls9y/Xc38j7iqjJOoYxY47cnT8QuJAdp0OGp8sLdk5oosbpaPNkQF+r1QYQEMB0r0/f9cIKUbuUP3kK7xwU2j/xmr86L34nH/q36JEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740617659; c=relaxed/simple;
	bh=klFXSyKvjrf3nXJRAJE5suBO86+4ldSxiHwyzeBR8qM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPMh1IGOFKEqJUEUTabxGR70TatpSJrsH+/jAh9MRLJ7NGolxe7y5otpIYTMdwA2/N6eBz761Dk6ELjZFfdxwLgJovUHhxOMylYuYBP8bnUvMYAyrycsfAGCqyXOAfUkd+sHsL1BRqHrFrRa4BjwyPb+gfBFuyq5I4lQhTXA93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XVEjDOgP; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 27 Feb 2025 00:54:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740617653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vz/+8IoEHab1BIpmoTnrc/mE2uJKVG5eZFJjwJ3003o=;
	b=XVEjDOgPXG/Lzl9n2RIxg9baXRPu/CFjW+3JGcUNmgLfu1R4rs4oJxUrFSRfn0syta+2Kg
	xh3XFo1UK4FU3w6Th3ys1h6nbrVdy8evgdlr5If7xfrADtVbE2655YJol9JHTh/M2xAk/Y
	TVm1KsQYDZWNWrliuVrIFAHkWth6W0c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/bugs: Use a static branch to guard IBPB on vCPU
 load
Message-ID: <Z7-3rjlZeFBI9zWq@google.com>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
 <20250219220826.2453186-5-yosry.ahmed@linux.dev>
 <Z74exImxJpQI9iyA@google.com>
 <59ea1984b2893be8a3a72855b022d16c67b857e9@linux.dev>
 <Z75G2L6N1vR3DslT@google.com>
 <Z76BTqmAJPV7lBbA@google.com>
 <Z7-1zv3Pb659rTj6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7-1zv3Pb659rTj6@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 26, 2025 at 04:46:06PM -0800, Sean Christopherson wrote:
> On Wed, Feb 26, 2025, Yosry Ahmed wrote:
> > On Tue, Feb 25, 2025 at 02:40:24PM -0800, Sean Christopherson wrote:
> > > On Tue, Feb 25, 2025, Yosry Ahmed wrote:
> > > > February 25, 2025 at 11:49 AM, "Sean Christopherson" <seanjc@google.com> wrote:
> > > > >
> > > > > On Wed, Feb 19, 2025, Yosry Ahmed wrote:
> > > > > > 
> > > > > > Instead of using X86_FEATURE_USE_IBPB to guard the IBPB execution in the
> > > > > >  vCPU load path, introduce a static branch, similar to switch_mm_*_ibpb. 
> > > > > > 
> > > > > >  This makes it obvious in spectre_v2_user_select_mitigation() what
> > > > > >  exactly is being toggled, instead of the unclear X86_FEATURE_USE_IBPB
> > > > > >  (which will be shortly removed). It also provides more fine-grained
> > > > > >  control, making it simpler to change/add paths that control the IBPB in
> > > > > >  the vCPU load path without affecting other IBPBs.
> > > > > > 
> > > > > >  Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > > > 
> > > > > >  ---
> > > > > > 
> > > > > >  arch/x86/include/asm/nospec-branch.h | 2 ++
> > > > > >  arch/x86/kernel/cpu/bugs.c | 5 +++++
> > > > > >  arch/x86/kvm/svm/svm.c | 2 +-
> > > > > >  arch/x86/kvm/vmx/vmx.c | 2 +-
> > > > > >  4 files changed, 9 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > >  diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > > > > >  index 7cbb76a2434b9..a22836c5fb338 100644
> > > > > >  --- a/arch/x86/include/asm/nospec-branch.h
> > > > > >  +++ b/arch/x86/include/asm/nospec-branch.h
> > > > > >  @@ -552,6 +552,8 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
> > > > > >  DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
> > > > > > 
> > > > DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
> > > > > >  
> > > > +DECLARE_STATIC_KEY_FALSE(vcpu_load_ibpb);
> > > > > > 
> > > > > 
> > > > > How about ibpb_on_vcpu_load? To make it easy for readers to understand exactly
> > > > > what the knob controls.
> > > > 
> > > > I was trying to remain consistent with the existing static branches' names,
> > > > but I am fine with ibpb_on_vcpu_load if others don't object.
> > > 
> > > I assumed as much :-)  I'm ok with vcpu_load_ibpb if that's what others prefer.
> > 
> > To be honest looking at this again I think I prefer consistency, so if
> > you don't mind and others don't chime in I'd rather keep it as-is.
> 
> Works for me.
> 
> Actually, looking at the names again, wouldn't "switch_vcpu_ibpb" be better?
> KVM doesn't do IBPB on every vCPU load or even every VMCS load, only when a
> different vCPU is being loaded.

Sold :)

> 
> > Alternatively I can rename all the static branches (e.g.
> > ibpb_always_on_switch_mm) :P
> 
> LOL, also works for me.

