Return-Path: <kvm+bounces-71626-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHyALBPVnWk0SQQAu9opvQ
	(envelope-from <kvm+bounces-71626-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:42:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01076189F0C
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 17:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 10991308D775
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 16:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F5D3A7F7E;
	Tue, 24 Feb 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFo3fpxZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7403A0E8B
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 16:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771951373; cv=none; b=aCBeeaQ1ylkr3yIFlrw9H18+aVsaLS+uPzZSqORtV3yFVbGNCGkhUcEXmwjXiyTNGRSmhSN1lzVkWcy6rGXnlhtPnq8jFRFTvVU7Qs/Juan8m7NYFUxbq5nR6W32tz8mu6S8btMxC6HAN1M6LrEcGBBuwrWvQ4uOz+Cbx480mk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771951373; c=relaxed/simple;
	bh=ODroX7pEkE68Id3LG+RYxgXBCxTWHzl2NUircz3UZdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NZEa/T3jFW4dgXB2kZP1FSONMqn/DdtkY1j7uYITnQz5RyXR2Zhf/KuYuiouJkMCNAyPJwjuWXVBtmrpBOuSRHkNgK/5IRHq8mkaXjY/pzn0maQOYG7ScRTLSa62fEwxuc0p7MaabcKKSlXfH9d1r8iwMngC7xYnN0UV79w08H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HFo3fpxZ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6136af8e06so3582233a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 08:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771951372; x=1772556172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CP4EsAwpHYE+IGSWrzqHNH3+l9etWFVewl+Rp1oQURQ=;
        b=HFo3fpxZTiMe/KYQlY871g0hic0jukNF91HYi8uDn47qF2wWLkOx/Ob8PJtvea+a+D
         JZEyJw/FHC65nN8bg95IgRG7tnzlvjGnztlJsyXlbASCLn7Hoq+kBDWAt7tWQ+A5NOfY
         DZt7eXtTu9DmLAfVSoorIUjhc+C3gLwwCWtahkTTm1LOV+77NzkCKRrUaBSHkBcCKB27
         LdRAW8PQbO7F4oockxvnKK9e3w7wSJq11RscmS+XtlQXsB9zTMLtJeolvC7l50t4Fvfg
         FujJ1HnuXQ3ocGaySS9hUeZAWrWt83UcQOoWKT8ToFZtG5FbEIjbcT5FIwCv7XfaZWBW
         QOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771951372; x=1772556172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CP4EsAwpHYE+IGSWrzqHNH3+l9etWFVewl+Rp1oQURQ=;
        b=bToj3JdlBBe80v+wgZdod2TjVwhGxJwjjdGZVjiYSR29Annm2ON+yKPLaRJIBnpG9K
         Cp+0RxjiPwSB132F47eH+yLCvKfz9UB36VHx4izalG0xTx/V9Pq4f+nyPeRV4953L9nN
         DYkeF48kou+8n8UNXHDxuMRDw/L3xSnvYoEzT4FnCIrqx2PPZvj0ojDMfbdu/HDv0l+D
         o09gW9g9/HNT8g5ja8XLrji2vhaJdIv18lPnD+KSRGLqE7TlI6snJ7Ram5o/ci801DSX
         Z2kiGjCz6xDAChhOcevt5eD3meL4TYdqN0FaeOz8JLhaSak6ggX1avQRsM+sQ0ekxm2d
         kXkw==
X-Forwarded-Encrypted: i=1; AJvYcCW4XWf4Nm/fxhGSAxv5EGn1Iy7Y7NeRc1QsFL8VJfNaN+rDctfVHwJvs2WHdRHH51NITW8=@vger.kernel.org
X-Gm-Message-State: AOJu0YykvtAAqKDzwVvyM57prXRqb4DDSXI2fhZVd7lgCQwUz9ascY+D
	goPs1rBtJoX4/BzGn+pyDcd/ewI1f7AN48co/ckUY6U5bsYLpQgGwjPGgN9mzDzMUvta5fTLwK5
	9fqwrNw==
X-Received: from pjl15.prod.google.com ([2002:a17:90b:2f8f:b0:34a:a9d5:99d6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5828:b0:349:3fe8:e7de
 with SMTP id 98e67ed59e1d1-358ae8c2744mr10231475a91.28.1771951371920; Tue, 24
 Feb 2026 08:42:51 -0800 (PST)
Date: Tue, 24 Feb 2026 08:42:50 -0800
In-Reply-To: <20260224071822.369326-3-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com> <20260224071822.369326-3-chengkev@google.com>
Message-ID: <aZ3VCq4s7l9f4JTw@google.com>
Subject: Re: [PATCH V2 2/4] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71626-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 01076189F0C
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Kevin Cheng wrote:
> When KVM emulates an instruction for L2 and encounters a nested page
> fault (e.g., during string I/O emulation), nested_svm_inject_npf_exit()
> injects an NPF to L1. However, the code incorrectly hardcodes
> (1ULL << 32) for exit_info_1's upper bits when the original exit was
> not an NPF. This always sets PFERR_GUEST_FINAL_MASK even when the fault
> occurred on a page table page, preventing L1 from correctly identifying
> the cause of the fault.
> 
> Set PFERR_GUEST_PAGE_MASK in the error code when a nested page fault
> occurs during a guest page table walk, and PFERR_GUEST_FINAL_MASK when
> the fault occurs on the final GPA-to-HPA translation.
> 
> Widen error_code in struct x86_exception from u16 to u64 to accommodate
> the PFERR_GUEST_* bits (bits 32 and 33).

Stale comment as this was moved to a separate patch.

> Update nested_svm_inject_npf_exit() to use fault->error_code directly
> instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if neither
> PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this would
> indicate a bug in the page fault handling code.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/paging_tmpl.h  | 22 ++++++++++------------
>  arch/x86/kvm/svm/nested.c       | 19 +++++++++++++------
>  3 files changed, 25 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ff07c45e3c731..454f84660edfc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -280,6 +280,8 @@ enum x86_intercept_stage;
>  #define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
>  #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
>  #define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
> +#define PFERR_GUEST_FAULT_STAGE_MASK \
> +	(PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)
>  #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
>  #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
>  #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 37eba7dafd14f..f148c92b606ba 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -385,18 +385,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  		real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(table_gfn),
>  					     nested_access, &walker->fault);
>  
> -		/*
> -		 * FIXME: This can happen if emulation (for of an INS/OUTS
> -		 * instruction) triggers a nested page fault.  The exit
> -		 * qualification / exit info field will incorrectly have
> -		 * "guest page access" as the nested page fault's cause,
> -		 * instead of "guest page structure access".  To fix this,
> -		 * the x86_exception struct should be augmented with enough
> -		 * information to fix the exit_qualification or exit_info_1
> -		 * fields.
> -		 */
> -		if (unlikely(real_gpa == INVALID_GPA))
> +		if (unlikely(real_gpa == INVALID_GPA)) {
> +#if PTTYPE != PTTYPE_EPT

I would rather swap the order of patches two and three, so that we end up with
a "positive" if-statement.  I.e. add EPT first so that we get (spoiler alert):

#if PTTYPE == PTTYPE_EPT
			walker->fault.exit_qualification |= EPT_VIOLATION_GVA_IS_VALID;
#else
			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
#endif

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd5..1013e814168b5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -40,18 +40,25 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>  	struct vmcb *vmcb = svm->vmcb;
>  
>  	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
> -		/*
> -		 * TODO: track the cause of the nested page fault, and
> -		 * correctly fill in the high bits of exit_info_1.
> -		 */
> -		vmcb->control.exit_code = SVM_EXIT_NPF;
> -		vmcb->control.exit_info_1 = (1ULL << 32);
> +		vmcb->control.exit_info_1 = fault->error_code;
>  		vmcb->control.exit_info_2 = fault->address;
>  	}
>  
> +	vmcb->control.exit_code = SVM_EXIT_NPF;
>  	vmcb->control.exit_info_1 &= ~0xffffffffULL;
>  	vmcb->control.exit_info_1 |= fault->error_code;
>  
> +	/*
> +	 * All nested page faults should be annotated as occurring on the
> +	 * final translation *or* the page walk. Arbitrarily choose "final"
> +	 * if KVM is buggy and enumerated both or neither.
> +	 */
> +	if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
> +				   PFERR_GUEST_FAULT_STAGE_MASK) != 1)) {
> +		vmcb->control.exit_info_1 &= ~PFERR_GUEST_FAULT_STAGE_MASK;
> +		vmcb->control.exit_info_1 |= PFERR_GUEST_FINAL_MASK;
> +	}

This is all kinds of messy.  KVM _appears_ to still rely on the hardware-reported
address + error_code

	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
		vmcb->control.exit_info_1 = fault->error_code;
		vmcb->control.exit_info_2 = fault->address;
	}

But then drops bits 31:0 in favor of the fault error code.  Then even more
bizarrely, bitwise-ORs bits 63:32 and WARNs if multiple bits in
PFERR_GUEST_FAULT_STAGE_MASK are set.  In practice, the bitwise-OR of 63:32 is
_only_ going to affect PFERR_GUEST_FAULT_STAGE_MASK, because the other defined
bits are all specific to SNP, and KVM doesn't support nested virtualization for
SEV+.

So I don't understand why this isn't simply:

	vmcb->control.exit_code = SVM_EXIT_NPF;
	vmcb->control.exit_info_1 = fault->error_code;

	/*
	 * All nested page faults should be annotated as occurring on the
	 * final translation *or* the page walk. Arbitrarily choose "final"
	 * if KVM is buggy and enumerated both or neither.
	 */
	if (WARN_ON_ONCE(hweight64(vmcb->control.exit_info_1 &
				   PFERR_GUEST_FAULT_STAGE_MASK) != 1)) {
		vmcb->control.exit_info_1 &= ~PFERR_GUEST_FAULT_STAGE_MASK;
		vmcb->control.exit_info_1 |= PFERR_GUEST_FINAL_MASK;
	}

Which would more or less align with the proposed nEPT handling.

> +
>  	nested_svm_vmexit(svm);
>  }
>  
> -- 
> 2.53.0.414.gf7e9f6c205-goog
> 

