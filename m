Return-Path: <kvm+bounces-60215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E5C3CBE50F0
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A7D6E4F1AD1
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3509231842;
	Thu, 16 Oct 2025 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eDny30yn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A153D43169
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 18:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760639341; cv=none; b=cDp8v378+Dw7xru4t+ccFEGHE6DqH5hAk7ADzdJKMjh5AqK+M/5lEu275y5nT61AtwgBYSqjvd1CyYbbcPVaOl4F+j7S4+Ksyqn7/6ZeYAq+QwRxbVU5D+FXjF/qwbCnaLAUpWL+AEG1UqCrZg1LxR64a/DCSB5cFjAhzQZoZ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760639341; c=relaxed/simple;
	bh=UF3AwMJu8GdTcVj3UtSmXMsr6jhKvVHZX0CWdAKeoIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JOeofAKX+qH5WQDbIpIKQ5QfX9eLMlwy+rMQbmlRv6ItYLCZ8kMCil/OHxJrBEMWSMBo6aEu+ISneQ2/eVYBYXGcHVhZ8TAsuBOpQycJrWpqUVza4eRqzT0QDpw9F6rGJOzgj+Z/lDasimiGrDb7dCYMPHxfRynwSJWCaqtPYKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eDny30yn; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so1293484a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760639339; x=1761244139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0fRYlwOE6ipOvEeK9Cj1tZOghAnrxlLNVjHWdV3e+uk=;
        b=eDny30yn3KmTBFNI7dbooNArLHBMEX8bIyXdBkFuguFTSmUBjCf0L3JonlTPhpADFS
         ISEVpMgv5CODyMLaOHWRwuR3IYNEDOaa6D2vUADw2/9gVrzRcybKOsQDVQINPo46U3BF
         5qpeqare5+FXqz/ZFy2bB0JjtKob3ix4FDyhBJonW7A+1D+waIhga9W4fPDonm4qmvUv
         aWodADDfr+w/UUyInjcImVwjNluja/9OOFTTsafMgFQQbpauL22WJzyc52dE3SCv0bqr
         0gOJ9aQnxTLw3MrJdeiLhYfJj7m3ySNtTXdL5TZCr4CdSym9X21BbFLGlwXy0BumYqof
         5DgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760639339; x=1761244139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0fRYlwOE6ipOvEeK9Cj1tZOghAnrxlLNVjHWdV3e+uk=;
        b=L38lbezhmVfEVEYbFI57M4j5DGTcd/FxjqQ6sloo9ihfzpP2X/oenXUBo6mQ9ClxdU
         cbIk0xHhYBlVcRStvPxFEQYkU6qh9TCC/hbayDiwR3TAaEmMM/Crf1fHeNmh8haWheuu
         pre9CgE5xae9N19one/dkbN6PGWcOMC57YOMSDZBNY8XKn1UQRHy7rNLRjTMgFO2oUSm
         S7hNrn7j7WwEUn+TyJc+QOg7Nx3JfP95PHKrAsUkrXGA3tp/tWOQZzmBmtT2SKn6dgrH
         RbQb3rI/IRQRwIwttFmpbbjN5EMQcHDBbkBwFL0mAQJzwaGz3ix8UEFpmC98EUwjdCDl
         8slQ==
X-Forwarded-Encrypted: i=1; AJvYcCXb5ukLif9SGTcKz25oQNXUKZSKSFKemwcSzcKY0go5WLWWKMj29/lqSN0GqCjaoBlClHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbTNOj/7QJcvoIotu+1cCjLaulEpApM4HIOnEWoWtcMEkgNzF1
	DorMY6LpzF72G2ON1HQsj8PR0pdTrzkURzjrJfT++q4wLHCMSddvYEseT6mivSmK+v/rfTpbEfm
	Ugg5i/A==
X-Google-Smtp-Source: AGHT+IGsN3Wc8ow+0kQfebQAOlEk+HH7ZqsKXkWse6wxgZajxLhoda5hRvaTMuKi10EUGgABBMrroNhH0NI=
X-Received: from pjbsc12.prod.google.com ([2002:a17:90b:510c:b0:33b:9db7:e905])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b09:b0:32e:d600:4fe9
 with SMTP id 98e67ed59e1d1-33bcf85ceacmr1083277a91.4.1760639338931; Thu, 16
 Oct 2025 11:28:58 -0700 (PDT)
Date: Thu, 16 Oct 2025 11:28:57 -0700
In-Reply-To: <456146b7-e4f3-46d4-8b30-8b0ccb250f08@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251014231042.1399849-1-seanjc@google.com> <b12f4ba6-bf52-4378-a107-f519eb575281@intel.com>
 <aO-oTw_l9mU1blRo@google.com> <456146b7-e4f3-46d4-8b30-8b0ccb250f08@intel.com>
Message-ID: <aPE5aZpsDYpIqngX@google.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Xiaoyao Li wrote:
> On 10/15/2025 9:57 PM, Sean Christopherson wrote:
> > On Wed, Oct 15, 2025, Xiaoyao Li wrote:
> > > On 10/15/2025 7:10 AM, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 76271962cb70..f64a1eb241b6 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> > > >    	case EXIT_REASON_NOTIFY:
> > > >    		/* Notify VM exit is not exposed to L1 */
> > > >    		return false;
> > > > +	case EXIT_REASON_SEAMCALL:
> > > > +	case EXIT_REASON_TDCALL:
> > > > +		/*
> > > > +		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
> > > > +		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
> > > > +		 * never want or expect such an exit.
> > > > +		 */
> > > 
> > > The i.e. part is confusing? It is exactly forwarding the EXITs to L1, while
> > > it says L1 should never want or expect such an exit.
> > 
> > Gah, the comment is right, the code is wrong.
> 
> So the intent was to return false here? to let L0 handle the exit?

Correct.

> Then I have a question, why not implement it in nested_vmx_l0_wants_exit()?
> what's the reason and rule here?

The basic gist of "l0/l1 wants exit" is that each entity (L0 and L1) should act
independently.  And if both L0 and L1 "want" the exit, then L0 wins.

E.g. for EXIT_REASON_EXTERNAL_INTERRUPT, KVM _always_ wants the exit because KVM
unconditionally runs with PIN_BASED_EXT_INTR_MASK set.  But L1 might want the
exit too, i.e. if it too is running with PIN_BASED_EXT_INTR_MASK.  But L1 doesn't
get the exit because L0's desire trumps L1.

Other exit are less straightfoward.  E.g. EXIT_REASON_EXCEPTION_NMI is filled with
conditionals because KVM needs to determine if the exception was due to something
KVM did, i.e. if the exception needs to be resolved by KVM, or if it the exception
isn't at all related to KVM and thus isn't "want" by L0.  But the exception may
still be routed to L0, e.g. if L1 doesn't want it.

For this particular case, L1 _can't_ want the exit, because the exit simply shouldn't
exist from L1's perspective.  Whether or not L0 wants the exit can't really be
known, because that would require predicting the future.  E.g. in the unlikely
case that KVM somehow virtualized some piece of TDX and thus exposed SEAMCALL
and/or TDCALL exits to L1, then nested_vmx_l1_wants_exit() _must_ be updated,
if only to consult the L1 VMXON state.  But L0's wants may or may not change;
if there are no scenarios where KVM/L0 "wants" the exit, then there wouldn't be
a need to modify nested_vmx_l0_wants_exit().

And so the most future-resistant location for this particular case is
nested_vmx_l1_wants_exit().

