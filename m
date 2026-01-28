Return-Path: <kvm+bounces-69348-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIBOOYoxemkx4gEAu9opvQ
	(envelope-from <kvm+bounces-69348-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:55:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75863A4BDE
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 16:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AF46C30C0E0C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 15:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ECB2FE044;
	Wed, 28 Jan 2026 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PgWJ3kav"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1611D2DF155
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615329; cv=none; b=FVNLEfJMQEBLfWZSz8HV32O9REH+GkbYRZddxmPH4hQhg7fEmFjtqUt0pmuuhik5wZh7xd35UlTxWn+AsO39u7fN2QAluQ5llIwFsGKmmVodLhXuAYs169cCFEzjQ71q/ZWL0ADYVx+W6jModYuQzrgJ2zLTqprr0QKB0hOmh9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615329; c=relaxed/simple;
	bh=Sb5lx8wcmOIcmrBPTDWeyOw5V7RXpjDotqSy/wtN8qE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hs4JiPrXfIBLK4hvVrP7d7ukte5Y9Kll6wLnYtevwOdJcHQo1pX1cREwWgD62tTNA7Sy+WWhJqq1+HOH3ijTFIK9ANwzjQY7mSNIJUqyZVVrUlQm/XZjMC1Eqg+oyepkoodc7qfO4jbWm0n8t40B9Qzu7hLPelgB6ekHe87kPNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PgWJ3kav; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c52d37d346dso3771215a12.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769615327; x=1770220127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bxEy9VvqAL8/BKao3q7Inu40Czt6ZIhDXQ1ldAn5S+U=;
        b=PgWJ3kav/Gb4jyl6F3l+0canN6Myy56J+SG+xeX2HcecHCxZOsVkyc47lRF2Pd5j13
         WpuZS7b7toKY6Ecx4BApUfFESwD98aR/MR8UbLohroX6W7pS2wrMjcQmJpf8sXChY3di
         aASYURl+d/J2eJ+ubD83qcmCHog61lE9hP0IgpHEw9ejVcVEbRkPYOH8QvPIPjqPV7JY
         Zpc12dTMtWxWtl1xQO49j43K841MxTSmwGGqlzayyv+7ZyYI1rhivxqLb1OwS+Vo+y/9
         0vv5XH4gJAxAHWIKmpBTPXxQgtp6AVOLln71/Yr8SNo3sV+1EknA/ePhFQ6sQ9OOgncZ
         19Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769615327; x=1770220127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bxEy9VvqAL8/BKao3q7Inu40Czt6ZIhDXQ1ldAn5S+U=;
        b=XL0RIp4tOHsH5EnGQLkE2uz4M/G7v0LYkGY7le1GgmabiTYSWjzgmIcSQZBky9xEP3
         qAVN9nt6+JVp16nTbBQeJxqkgR6fH0WhrkRPIjTBQkzZz3lOrXXftNkAJ0KKmzKqm9mp
         TfKsanrs6o3/yS9kbvC4AE7sQhkOqMsrgHuxI/AIyLPFBMuSqF2vLZp11Nh0e2w26RSf
         2D/mArxx8hAFWiTcYkwuVn2IjnrW0jFzsqgThjzDpbe0PiOoW8kGo18TkviuP//ofGF4
         fCJH8HhVbLXI7tquTteHgE6kKypra3GSJAT2t8VVRuPw84rikNw1/RBxzGutiRh0OUwb
         0PEg==
X-Forwarded-Encrypted: i=1; AJvYcCUd1yByisYeuPRlWJFP/FPVtAjZX8+j/xHP1rKYX4dvfueWrtGJ0vJyzPnq8exWCSrQFwc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGEyqOFS3G/R45vnu7UGfLIVFGlDagf8tafOU68lAFSiZpUXnD
	7Pf8pwuXlrMY4ggW5C3m76/PrL2babsfyr5m7IM+V/vJSlgI8kQsBbu+Fu6lKGagwrhsUNkRx2Y
	I6UNUrg==
X-Received: from pgjc12.prod.google.com ([2002:a63:d14c:0:b0:c63:4e84:fe71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:46c4:b0:38e:90d3:49c5
 with SMTP id adf61e73a8af0-38ec64523c3mr5081613637.53.1769615327300; Wed, 28
 Jan 2026 07:48:47 -0800 (PST)
Date: Wed, 28 Jan 2026 07:48:45 -0800
In-Reply-To: <sdyb3l4ihmcd7uxb6wivkyknmzy4bcctqyyidxq7hr2d2jfs6e@iz3fhfp6t4ss>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com> <20260121004906.2373989-2-chengkev@google.com>
 <aXFOPP3P-HE6YbEZ@google.com> <sdyb3l4ihmcd7uxb6wivkyknmzy4bcctqyyidxq7hr2d2jfs6e@iz3fhfp6t4ss>
Message-ID: <aXov3WWozd2UIFXw@google.com>
Subject: Re: [PATCH 1/3] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69348-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 75863A4BDE
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Yosry Ahmed wrote:
> On Wed, Jan 21, 2026 at 02:07:56PM -0800, Sean Christopherson wrote:
> > On Wed, Jan 21, 2026, Kevin Cheng wrote:
> > > When KVM emulates an instruction for L2 and encounters a nested page
> > > fault (e.g., during string I/O emulation), nested_svm_inject_npf_exit()
> > > injects an NPF to L1. However, the code incorrectly hardcodes
> > > (1ULL << 32) for exit_info_1's upper bits when the original exit was
> > > not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the fault
> > > occurred on a page table page, preventing L1 from correctly identifying
> > > the cause of the fault.
> > > 
> > > Set PFERR_GUEST_PAGE_MASK in the error code when a nested page fault
> > > occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK when
> > > the fault occurs on the final GPA-to-HPA translation.
> > > 
> > > Widen error_code in struct x86_exception from u16 to u64 to accommodate
> > > the PFERR_GUEST_* bits (bits 32 and 33).
> > 
> > Please do this in a separate patch.  Intel CPUs straight up don't support 32-bit
> > error codes, let alone 64-bit error codes, so this seemingly innocuous change
> > needs to be accompanied by a lengthy changelog that effectively audits all usage
> > to "prove" this change is ok.
> 
> Semi-jokingly, we can add error_code_hi to track the high bits and
> side-step the problem for Intel (dejavu?).

Technically, it would require three fields: u16 error_code, u16 error_code_hi,
and u32 error_code_ultra_hi.  :-D

Isolating the (ultra) hi flags is very tempting, but I worry that it would lead
to long term pain, e.g. because inevitably we'll forget to grab the hi flags at
some point.  I'd rather audit the current code and ensure that KVM truncates the
error code as needed.

VMX is probably a-ok, e.g. see commit eba9799b5a6e ("KVM: VMX: Drop bits 31:16
when shoving exception error code into VMCS").  I'd be more worred SVM, where
it's legal to shove a 32-bit value into the error code, i.e. where KVM might not
have existing explicit truncation.

> > > Update nested_svm_inject_npf_exit() to use fault->error_code directly
> > > instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if neither
> > > PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this would
> > > indicate a bug in the page fault handling code.
> > > 
> > > Signed-off-by: Kevin Cheng <chengkev@google.com>
> [..]
> > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > index de90b104a0dd5..f8dfd5c333023 100644
> > > --- a/arch/x86/kvm/svm/nested.c
> > > +++ b/arch/x86/kvm/svm/nested.c
> > > @@ -40,18 +40,17 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
> > >  	struct vmcb *vmcb = svm->vmcb;
> > >  
> > >  	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
> > > -		/*
> > > -		 * TODO: track the cause of the nested page fault, and
> > > -		 * correctly fill in the high bits of exit_info_1.
> > > -		 */
> > > -		vmcb->control.exit_code = SVM_EXIT_NPF;
> > > -		vmcb->control.exit_info_1 = (1ULL << 32);
> > > +		vmcb->control.exit_info_1 = fault->error_code;
> > >  		vmcb->control.exit_info_2 = fault->address;
> > >  	}
> > >  
> > > +	vmcb->control.exit_code = SVM_EXIT_NPF;
> > >  	vmcb->control.exit_info_1 &= ~0xffffffffULL;
> > >  	vmcb->control.exit_info_1 |= fault->error_code;
> > 
> > So... what happens when exit_info_1 already has PFERR_GUEST_PAGE_MASK, and then
> > @fault sets PFERR_GUEST_FINAL_MASK?  Presumably that can't/shouldn't happen,
> > but nothing in the changelog explains why such a scenario is
> > impossible, and nothing in the code hardens KVM against such goofs.
> 
> I guess we can update the WARN below to check for that as well, and
> fallback to the current behavior (set PFERR_GUEST_FINAL_MASK):
> 
> 	fault_stage = vmcb->control.exit_info_1 &
> 			(PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK);
> 	if (WARN_ON_ONCE(fault_stage != PFERR_GUEST_FINAL_MASK &&
> 			 fault_stage != PFERR_GUEST_PAGE_MASK))
> 		vmcb->control.exit_info_1 |= PFERR_GUEST_FINAL_MASK;

Except that doesn't do the right thing if both bits are set.  And we can use
hweight64(), which is a single POPCNT on modern CPUs.

Might be easiest to add something like PFERR_GUEST_FAULT_STAGE_MASK, then do:

	/*
	 * All nested page faults should be annotated as occuring on the final
	 * translation *OR* the page walk.  Arbitrarily choose "final" if KVM
	 * is buggy and enumerated both or none.
	 */
	if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
				   PFERR_GUEST_FAULT_STAGE_MASK) != 1)) {
		vmcb->control.exit_info_1 &= ~PFERR_GUEST_FAULT_STAGE_MASK;	
		vmcb->control.exit_info_1 |= PFERR_GUEST_FINAL_MASK;
	}

