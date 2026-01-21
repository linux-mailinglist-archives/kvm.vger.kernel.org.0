Return-Path: <kvm+bounces-68800-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 61R2HsVOcWkvCAAAu9opvQ
	(envelope-from <kvm+bounces-68800-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:10:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BF5385E8AF
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 266DE589E5F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A222F30EF67;
	Wed, 21 Jan 2026 22:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1yhOQ+B8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34866225760
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769033280; cv=none; b=Zg8wwehb0IvwhqYF6jbdgNep+IVzCTTFbCLzm3Xstv6e2VNBAGwGPh5HxfDaOgaLEFTC89GPWithk4LT8YorKY4vCaOvm2qd0uUi2OKyQzHNzLuwrB3qecELNNKFwbrgFDTgoKQgCr1Djcb3kwdAejcToLNM2QANMyUtO3hRBb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769033280; c=relaxed/simple;
	bh=lHVMYe2KCM2N7/rhEHczvrqD6RA4pBXqpJ57axvtCPw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gX221VRRz4adZi3QknHaf2z9fV+P91Uypm/yPVNfhL15xOvDVxw+3cUCoCp8BiQXT5dkhp0K1DWyLpXMT2CEksTVUTwYIOSgSXnN4LEJp2lmELAb4NynfHDYUVZ7nQkrHA4ktyGMCg7gcJVZIUZpgYddRZhJz0lP7Mbvp7MNwPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1yhOQ+B8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac819b2f2so300158a91.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769033278; x=1769638078; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QNy4RZ+2NxivQKrDbpPCmQkSdtVEcbjgLH8xYIIEmew=;
        b=1yhOQ+B8J5roNiEwBN6Xnz1AJQNLqaQgONRb1N3uq6/yjYkOoeN4NXb1jxZ558REOi
         nNYswAzkHHPXVT8cze9ZrSEGjREbjcofk7ogFhtTHqvDLwSzazmvZTR/CkLUfKWfri+5
         sZ4IxcVR84RJVcAPmIQDRukiKsDvyTyDT8TMRMFHpNEA2xPuw0eSy8wWHi4m5MnL/xeM
         6jGJjE3Frl2LdTXr0+PYfLwt0zmzTyrE5/fQKaCPkmCpScoauYNwtCorTR69RLROThA9
         iLoTFOMf5v6flNZHundKlKXXEQng0KZ43OeH/Osb5dPRsP9MFKcm571JWrMMT3pcURGe
         EjfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769033278; x=1769638078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QNy4RZ+2NxivQKrDbpPCmQkSdtVEcbjgLH8xYIIEmew=;
        b=EXehbZLNeDZLj1nsLow8GonlqungC7hRjn/mg5NOxyrJ/cFokuOmJftmDXJ8BVd3VI
         WfIhmekdLLIJPzl7AHOItzMIoeowZZDRKC9mjxKPDFHS9RxZ6Gmbq2rZKXhWD7o1vo6/
         mMq92ihT9lAl3IjImS+NtpBbAJVsM6byNgWxicuep6Xcp8JqwYtCFcGLJw33ltcTE0Aw
         7QnkbZ2sDDmFxoTIpXK4bss6k9xLkScxCfikmtLzYQJHeX1IWY4u2xBnsg87DIvL339r
         H8CyrRsQpEsIsU5mn7roBWh8dMUTVgX0IpIXAHgaQ+OOT7ZVRmbYWaBU2MJF2gVD3uvI
         IrOg==
X-Forwarded-Encrypted: i=1; AJvYcCXNBVlIjdjPYFxClmNYSvMeRIAbsD5sGcea4YCHlybADlIA+MHWueRFYEejbZHSJXJifJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTcUn6k5g8nitFtiid9CqFrjXAGNskIarnJhnD4RArg9vO6xtd
	T8sVZMy2lpqBX/MxXL/lOjxfXhpCshoOxPRmwMLyH69/uNTOGXUO5MisYOuwODEqMXyw6VNqBhH
	owEo1Ng==
X-Received: from pjbpv11.prod.google.com ([2002:a17:90b:3c8b:b0:34c:489a:f4c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d83:b0:34c:c866:81f2
 with SMTP id 98e67ed59e1d1-352c3e2140cmr5045240a91.4.1769033278534; Wed, 21
 Jan 2026 14:07:58 -0800 (PST)
Date: Wed, 21 Jan 2026 14:07:56 -0800
In-Reply-To: <20260121004906.2373989-2-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com> <20260121004906.2373989-2-chengkev@google.com>
Message-ID: <aXFOPP3P-HE6YbEZ@google.com>
Subject: Re: [PATCH 1/3] KVM: SVM: Fix nested NPF injection to set PFERR_GUEST_{PAGE,FINAL}_MASK
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	TAGGED_FROM(0.00)[bounces-68800-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[213.196.21.55:from];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RBL_SENDERSCORE_REPUT_BLOCKED(0.00)[213.196.21.55:from];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	DNSWL_BLOCKED(0.00)[52.25.139.140:received,209.85.216.74:received,213.196.21.55:from];
	DWL_DNSWL_BLOCKED(0.00)[google.com:dkim];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[52.25.139.140:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: BF5385E8AF
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Kevin Cheng wrote:
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

Please do this in a separate patch.  Intel CPUs straight up don't support 32-bit
error codes, let alone 64-bit error codes, so this seemingly innocuous change
needs to be accompanied by a lengthy changelog that effectively audits all usage
to "prove" this change is ok.

> Update nested_svm_inject_npf_exit() to use fault->error_code directly
> instead of hardcoding the upper bits. Also add a WARN_ON_ONCE if neither
> PFERR_GUEST_FINAL_MASK nor PFERR_GUEST_PAGE_MASK is set, as this would
> indicate a bug in the page fault handling code.
> 
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/kvm_emulate.h     |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h | 22 ++++++++++------------
>  arch/x86/kvm/svm/nested.c      | 11 +++++------
>  3 files changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index fb3dab4b5a53e..ff4f9b0a01ff7 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -22,7 +22,7 @@ enum x86_intercept_stage;
>  struct x86_exception {
>  	u8 vector;
>  	bool error_code_valid;
> -	u16 error_code;
> +	u64 error_code;
>  	bool nested_page_fault;
>  	u64 address; /* cr2 or nested page fault gpa */
>  	u8 async_page_fault;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 901cd2bd40b84..923179bfd5c74 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -379,18 +379,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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
> +			walker->fault.error_code |= PFERR_GUEST_PAGE_MASK;
> +#endif

Why exclude EPT?  EPT doesn't use the error code _verbatim_, but EPT shares the
concept/reporting of intermediate vs. final walks.

>  			return 0;
> +		}
>  
>  		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(real_gpa));
>  		if (!kvm_is_visible_memslot(slot))
> @@ -446,8 +440,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  #endif
>  
>  	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
> -	if (real_gpa == INVALID_GPA)
> +	if (real_gpa == INVALID_GPA) {
> +#if PTTYPE != PTTYPE_EPT
> +		walker->fault.error_code |= PFERR_GUEST_FINAL_MASK;
> +#endif

Same thing here.

>  		return 0;
> +	}
>  
>  	walker->gfn = real_gpa >> PAGE_SHIFT;
>  
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd5..f8dfd5c333023 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -40,18 +40,17 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
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

So... what happens when exit_info_1 already has PFERR_GUEST_PAGE_MASK, and then
@fault sets PFERR_GUEST_FINAL_MASK?  Presumably that can't/shouldn't happen, but
nothing in the changelog explains why such a scenario is impossible, and nothing
in the code hardens KVM against such goofs.

> +	WARN_ON_ONCE(!(vmcb->control.exit_info_1 &
> +		       (PFERR_GUEST_FINAL_MASK | PFERR_GUEST_PAGE_MASK)));
> +
>  	nested_svm_vmexit(svm);
>  }
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

