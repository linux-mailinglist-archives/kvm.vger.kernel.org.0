Return-Path: <kvm+bounces-63236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0349C5E640
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 243314FA43D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF76B2C21D0;
	Fri, 14 Nov 2025 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YnW5BDIY"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0028D84F
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763139168; cv=none; b=OlVgJcajUplTl3DLPTtxp7AlL+nF08iDPpnJnGB/951lgyGgkbtTGadB4HAb+P8g1ziRiZk5GC0PFLNNSknnLiHZ3N7ZGfROgzx0W1tac8BbUP/wu3qjd9jZOzDS2R0yfxtvKhqe7iN15JOr8lMtzzZW01x541D1/gR1Ij+3TMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763139168; c=relaxed/simple;
	bh=J+woEYepazJSNt9YNRNQTE0n0oqUmlct4V9a+jNg6SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NA+07xlaFlQwnyIn2GOMR0W/UkHbtufSNPPR3pDmhbBkx3rcb86EEdgSy4E+5UWTnNa31+tabWg0SbiMobLKBEuQJuMTL2vSzDmbjRYyB5ym7VpaEh1/y1Ws2MvNp66ELhP6hrsW8kLtSX2jB47UiZaaLeGYLVUEsODPFH7gMdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YnW5BDIY; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 16:52:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763139162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=//sw+C17RnFVza/MgpE+dbMHlRJchErAG8BGBLaOJ8Q=;
	b=YnW5BDIY6QcylpUO5hEnexNGhRyCTK4m7GP1M2Pa62Na6fFFlCq4P1dB2+Z1Ws7olatMly
	SAkh4EvhNQwiyHXX7QGBBCBl8Gp+HTCT0YJONQZEBVxj5nBs2CCwhNI5HFMBOcu35zQLk7
	I3w9nKOoCFTkTUoGdxWxgxb+ixxFL+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: Fix redundant updates of LBR MSR intercepts
Message-ID: <ei6cdmnvhzyavfobamjkcq2ghdrxcv7ruxhcbzzycqlvaty7zr@5cjkfczxiqom>
References: <20251112013017.1836863-1-yosry.ahmed@linux.dev>
 <aRdaLrnQ8Xt77S8Y@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRdaLrnQ8Xt77S8Y@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 14, 2025 at 08:34:54AM -0800, Sean Christopherson wrote:
> On Wed, Nov 12, 2025, Yosry Ahmed wrote:
> > svm_update_lbrv() always updates LBR MSRs intercepts, even when they are
> > already set correctly. This results in force_msr_bitmap_recalc always
> > being set to true on every nested transition,
> 
> Nit, it's only on VMRUN, not on every transition (i.e. not on nested #VMEXIT).

How so? svm_update_lbrv() will also be called in nested_svm_vmexit(),
and it will eventually lead to force_msr_bitmap_recalc being set to
true.

I guess what you meant is the "undoing the Hyper-V optimization" part.
That is indeed only affected by the svm_update_lbrv() call in the nested
VMRUN path.

So we do set force_msr_bitmap_recalc on nested #VMEXIT, but it doesn't
really matter because we set it again on nested VMRUN before
nested_svm_merge_msrpm() is called.

> 
> > essentially undoing the hyperv optimization in nested_svm_merge_msrpm().
> 
> When something fixes a KVM test failures (selftests or KUT), please call that
> out in the changelog.  That way when other people encounter the failure, they'll
> get search hits and won't have to waste their time bisecting and/or debugging.
> 
> If you hadn't mentioned off-list that this was detected by hyperv_svm_test, I
> wouldn't have had the first clue as to why that test started failing.  Even with
> the hint, it still took me a few minutes to connect the dots.

Noted, makes sense. I thought the fix and the original patch are in such
quick succession that hopefully no one will run into it.

> 
> In general, be more explicit/detailed, e.g. "undoing the hyperv optimization" is
> unnecessarily vague, as the reader has to go look at the code to understand what
> you're talking about.  My philosophy with changelogs is that they are write-once,
> read-many, and so if you can save any time/effort for readers, it's almost always
> worth the extra time/effort on the "write" side.
> 
> And a nit: my strong preference is to lead with what is being changed, and then
> dive into the details of why, what's breaking, etc.  This is one of the few
> divergences from the tip-tree preferences.  From  Documentation/process/maintainer-kvm-x86.rst:
> 
>   Stating what a patch does before diving into details is preferred by KVM x86
>   for several reasons.  First and foremost, what code is actually being changed
>   is arguably the most important information, and so that info should be easy to
>   find. Changelogs that bury the "what's actually changing" in a one-liner after
>   3+ paragraphs of background make it very hard to find that information.

Noted.

> 
> E.g.
> 
> --
> Don't update the LBR MSR intercept bitmaps if they're already up-to-date,
> as unconditionally updating the intercepts forces KVM to recalculate the
> MSR bitmaps for vmcb02 on every nested VMRUN.  Functionally, the redundant
> updates are benign, but forcing an update neuters the Hyper-V optimization
> that allows KVM to skip refreshing the vmcb12 MSR bitmap if L1 marked the
> "nested enlightenments" as being clean, i.e. if L1 told KVM that no
> changes were made to the MSR bitmap since the last VMRUN.
> 
> Clobbering the Hyper-V optimization manifests as a failure in the
> hyperv_svm_test KVM selftest, which intentionally changes the MSR bitmap
> "without telling KVM about it" to verify that KVM honors the clean hint.
> 
>   ==== Test Assertion Failure ====
>   x86/hyperv_svm_test.c:120: vmcb->control.exit_code == 0x081
>   pid=193558 tid=193558 errno=4 - Interrupted system call
>      1	0x0000000000411361: assert_on_unhandled_exception at processor.c:659
>      2	0x0000000000406186: _vcpu_run at kvm_util.c:1699
>      3	 (inlined by) vcpu_run at kvm_util.c:1710
>      4	0x0000000000401f2a: main at hyperv_svm_test.c:175
>      5	0x000000000041d0d3: __libc_start_call_main at libc-start.o:?
>      6	0x000000000041f27c: __libc_start_main_impl at ??:?
>      7	0x00000000004021a0: _start at ??:?
>   vmcb->control.exit_code == SVM_EXIT_VMMCALL
> 
> Avoid using ....
> --  

Thanks!

> 
> > Fix it by keeping track of whether LBR MSRs are intercepted or not and
> > only doing the update if needed, similar to x2avic_msrs_intercepted.
> > 
> > Avoid using svm_test_msr_bitmap_*() to check the status of the
> > intercepts, as an arbitrary MSR will need to be chosen as a
> > representative of all LBR MSRs, and this could theoretically break if
> > some of the MSRs intercepts are handled differently from the rest.
> 
> For posterity, Yosry originally proposed (off-list) fixing this by having
> svm_set_intercept_for_msr() check for redundant updates, but I voted against
> that because updating MSR interception _should_ be rare (full CPUID updates and
> explicit MSR filter updates), and I don't want to risk hiding a bug/flaw elsewhere.
> I.e. if something is triggering frequent/unexpected MSR bitmap changes, I want
> that to be surfaced, not squashed/handled by the low level helpers.

Hmm, that was on-list though :P

https://lore.kernel.org/kvm/aRO5ItX_--ZDfnfM@google.com/

> 
>  
> > Also, using svm_test_msr_bitmap_*() makes backports difficult as it was
> > only recently introduced with no direct alternatives in older kernels.
> > 
> > Fixes: fbe5e5f030c2 ("KVM: nSVM: Always recalculate LBR MSR intercepts in svm_update_lbrv()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> With an updated changelog,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Tested-by: Sean Christopherson <seanjc@google.com>

Thanks!

Paolo, do you prefer a updated patch with the updated changelog, or
fixing it up when you apply it?

