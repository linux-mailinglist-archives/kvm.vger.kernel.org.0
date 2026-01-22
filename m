Return-Path: <kvm+bounces-68829-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iEFKI05zcWkPHAAAu9opvQ
	(envelope-from <kvm+bounces-68829-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:46:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ECC160088
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 01:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1296A5A5CDC
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 00:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78052C11C6;
	Thu, 22 Jan 2026 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mjJpvstC"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F21BDCF
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 00:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769042748; cv=none; b=NslUnVFCTqmXDmhtlPLUVHryvD25oER08CSDNCzE/cm5qcrUYz7EsVwtvz9DwegCy4Ax0f/93c90Ix9QMbhWvza0eqWrT+UyYyhcHUIB4X9KCWpkHYJJfAOPmCb1QHH/1DiG1HzNC6r7FYCCJ1eksYqHf/6T+W45LbgWWTkAZ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769042748; c=relaxed/simple;
	bh=Yn18zfPoq4N5AAZKJXKiCqBF0ZyJRKNF/4t09DPLZcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPfOjtwMWMvS/R1ha5jQMGZuN82t9sh3hu1z/ZFZ2BrHym10p2x9wuVD4D1KHAUrbJ99qfpmzPYecNvOSB+oooHbjspyRpFETlHRvBkK+XJ12MgacgxEHgqd/xCPIZ49iu9eGhVSSgw9qQ51xXEUQieue1Jl1YBjYM/+XMZ1MDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mjJpvstC; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 Jan 2026 00:45:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769042727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E2i8hEOCXJm/GacmjdxeHPzmYdIqKcfkzTGRR5hVmdA=;
	b=mjJpvstClUP6/IUBCC2HESp8kLrAT0Xyq/6ZmmYwfNvjazTeaxDrhzzXJTkv6Xsynl9a9q
	kiDXjLcwj9Es2/pOtb9tTXAaK0PenQyJlNMwpkyYcAL9bFGerCDfa2GDroDuelUuwCV6F7
	11MPrm3JIUZ7IGU9luDmNl8rFZGevkY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: SVM: Fix nested NPF injection to set
 PFERR_GUEST_{PAGE,FINAL}_MASK
Message-ID: <sdyb3l4ihmcd7uxb6wivkyknmzy4bcctqyyidxq7hr2d2jfs6e@iz3fhfp6t4ss>
References: <20260121004906.2373989-1-chengkev@google.com>
 <20260121004906.2373989-2-chengkev@google.com>
 <aXFOPP3P-HE6YbEZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXFOPP3P-HE6YbEZ@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68829-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[linux.dev,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 1ECC160088
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 02:07:56PM -0800, Sean Christopherson wrote:
> On Wed, Jan 21, 2026, Kevin Cheng wrote:
> > When KVM emulates an instruction for L2 and encounters a nested page
> > fault (e.g., during string I/O emulation), nested_svm_inject_npf_exit()
> > injects an NPF to L1. However, the code incorrectly hardcodes
> > (1ULL << 32) for exit_info_1's upper bits when the original exit was
> > not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the fault
> > occurred on a page table page, preventing L1 from correctly identifying
> > the cause of the fault.
> > 
> > Set PFERR_GUEST_PAGE_MASK in the error code when a nested page fault
> > occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK when
> > the fault occurs on the final GPA-to-HPA translation.
> > 
> > Widen error_code in struct x86_exception from u16 to u64 to accommodate
> > the PFERR_GUEST_* bits (bits 32 and 33).
> 
> Please do this in a separate patch.  Intel CPUs straight up don't support 32-bit
> error codes, let alone 64-bit error codes, so this seemingly innocuous change
> needs to be accompanied by a lengthy changelog that effectively audits all usage
> to "prove" this change is ok.

Semi-jokingly, we can add error_code_hi to track the high bits and
side-step the problem for Intel (dejavu?).

> 
> > Update nested_svm_inject_npf_exit() to use fault->error_code directly
> > instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if neither
> > PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this would
> > indicate a bug in the page fault handling code.
> > 
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
[..]
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index de90b104a0dd5..f8dfd5c333023 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -40,18 +40,17 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> >  	struct vmcb *vmcb = svm->vmcb;
> >  
> >  	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
> > -		/*
> > -		 * TODO: track the cause of the nested page fault, and
> > -		 * correctly fill in the high bits of exit_info_1.
> > -		 */
> > -		vmcb->control.exit_code = SVM_EXIT_NPF;
> > -		vmcb->control.exit_info_1 = (1ULL << 32);
> > +		vmcb->control.exit_info_1 = fault->error_code;
> >  		vmcb->control.exit_info_2 = fault->address;
> >  	}
> >  
> > +	vmcb->control.exit_code = SVM_EXIT_NPF;
> >  	vmcb->control.exit_info_1 &= ~0xffffffffULL;
> >  	vmcb->control.exit_info_1 |= fault->error_code;
> 
> So... what happens when exit_info_1 already has PFERR_GUEST_PAGE_MASK, and then
> @fault sets PFERR_GUEST_FINAL_MASK?  Presumably that can't/shouldn't happen,
> but nothing in the changelog explains why such a scenario is
> impossible, and nothing in the code hardens KVM against such goofs.

I guess we can update the WARN below to check for that as well, and
fallback to the current behavior (set PFERR_GUEST_FINAL_MASK):

	fault_stage = vmcb->control.exit_info_1 &
			(PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK);
	if (WARN_ON_ONCE(fault_stage != PFERR_GUEST_FINAL_MASK &&
			 fault_stage != PFERR_GUEST_PAGE_MASK))
		vmcb->control.exit_info_1 |= PFERR_GUEST_FINAL_MASK;

> 
> > +	WARN_ON_ONCE(!(vmcb->control.exit_info_1 &
> > +		       (PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)));
> > +
> >  	nested_svm_vmexit(svm);
> >  }
> >  
> > -- 
> > 2.52.0.457.g6b5491de43-goog
> > 

