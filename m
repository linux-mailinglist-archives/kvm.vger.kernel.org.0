Return-Path: <kvm+bounces-73214-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wN8vOoOIq2m1dwEAu9opvQ
	(envelope-from <kvm+bounces-73214-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:08:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 856AC229952
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AF1483063743
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 538D0303A12;
	Sat,  7 Mar 2026 02:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dczEejAh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3052D7DF1
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 02:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772849270; cv=none; b=J9vKBxjnSXyojUqLr7kqqE6Lcw6MwMh1VUn6x6z8bsbeqsyxGPP1RqG2Brtt5xYTKypDwND3VvcukP8WNSs03vRiCg2yBy3WIfUbLk0pmLj2Jq4gXid1Vb09nukrZsEWx0wtS6IAj6EIJxApGmf0ALLTPy57hMfAMAND+/17osY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772849270; c=relaxed/simple;
	bh=3sc9rZiiq36ueqWM059KBxT6+A6RthyIHTF1VY/DBaM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fJyLKXUJOkH0ET5Xg2K0p1mbXPXMkmYQDzyNJnqylquAOJIrABgLRozaXlBxx0+jSGSZ3e6s5EvGvszbSQBm9pRsxItZzkFWTSyPLDT608LiuXiDM038kDHqQ2BDPEokqG13WqVhjfkHvUj1AioXguhV5D8ESIuxiAzr9A5xMcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dczEejAh; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c737ced4036so1943454a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772849269; x=1773454069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ilXWzcjnLXmIAzaRJucVhEiEYC21vz/WZzo4IJKH/uA=;
        b=dczEejAhE37KI9kYsUwnBg4EkWbpaFiVKtzFiOpK9hqgxAPru+hN+jmRg7wXj5JWiv
         awLqI92clnloJj6kw7GTRYmYVe4l1xXT9CmiNUxplItIbtwVVD9LhJfAQFPOfsg7VDk5
         fSTkRWW1Y5p/HbtLcDGaA80m1YxCKRGC4tzUUtcgu3h3j0XUW76AbC6jOxgqrEtyezHF
         N8fhqZtMerSst4y4pRLx76uB6l2zsTZNNcjPx7/oE1D03UmMliIviJ/9aS6kuLilpW8w
         qS0aVs2HiwqR1tY++dQ3k/vS2f5utt7on0ptMUzzmcTU3HLq+6LfTFRo4NT280607kTb
         FPoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772849269; x=1773454069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ilXWzcjnLXmIAzaRJucVhEiEYC21vz/WZzo4IJKH/uA=;
        b=X3zeWxHA+dh1XJsMr0Rx+HeLnK7EuexF16KXqqTc616qQYzDPseFVbNF9/JkwX0oxY
         3u6BWkcpi9k4UW/BDdpo3Sl7wKpX3UDcar0bPtsQQzECGfp+F7a9c0VD1WD9e21ubUDP
         u+PhVZVwyBZETdtIiQuPGJ0bxr5wvFj+O1333uLY6AVlMugft3CSlEZZOVsYPKqUWCRP
         gmBrUR1Jlr35DRMQ6QTuXUHulW0n9Kqje70udNypUHg4AQBE2wL3ERyAXZMz1j2Ah4Gl
         tmmyeave0HYL+/MPuRXI0Y31c16AF204AviQ33rmHaDFXzsEKJ9WEqscwuE5aCCsKqMc
         fZeg==
X-Forwarded-Encrypted: i=1; AJvYcCVGXImOIgrHyNlJ1wEOIq5AJfXp/sdTIS2qnc7pUkmK0zJZDpaLzt/qoc2YTophck6yD3w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzqgIaqTKjiDx5cCoNAL6XDhkLx+AEoB+zVDzX6J4NPNkbyMW7
	L31Tfjx9h2Vhv5e521qYtRGEyZL9gQi6DPUfcvHILQH8LwP0swfE7qnmGhlv/EOeiTqa95brM8R
	1REAKCQ==
X-Received: from pfbna2.prod.google.com ([2002:a05:6a00:3e02:b0:829:8d7b:fdc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b483:b0:821:7ee2:b692
 with SMTP id d2e1a72fcca58-829a2d83acbmr3414209b3a.2.1772849268680; Fri, 06
 Mar 2026 18:07:48 -0800 (PST)
Date: Fri, 6 Mar 2026 18:07:47 -0800
In-Reply-To: <20260129063653.3553076-6-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com> <20260129063653.3553076-6-shivansh.dhiman@amd.com>
Message-ID: <aauIc-wOXr__Qn1u@google.com>
Subject: Re: [PATCH 5/7] KVM: SVM: Support FRED nested exception injection
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 856AC229952
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73214-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.932];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:email]
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> 
> Set the SVM nested exception bit in EVENT_INJECTION_CTL when
> injecting a nested exception using FRED event delivery to
> ensure:
>   1) A nested exception is injected on a correct stack level.
>   2) The nested bit defined in FRED stack frame is set.
> 
> The event stack level used by FRED event delivery depends on whether
> the event was a nested exception encountered during delivery of an
> earlier event, because a nested exception is "regarded" as happening
> on ring 0.  E.g., when #PF is configured to use stack level 1 in
> IA32_FRED_STKLVLS MSR:
>   - nested #PF will be delivered on the stack pointed by FRED_RSP1
>     MSR when encountered in ring 3 and ring 0.
>   - normal #PF will be delivered on the stack pointed by FRED_RSP0
>     MSR when encountered in ring 3.
> 
> The SVM nested-exception support ensures a correct event stack level is
> chosen when a VM entry injects a nested exception.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
> ---
>  arch/x86/include/asm/svm.h | 1 +
>  arch/x86/kvm/svm/svm.c     | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index c2f3e03e1f4b..f4a9781c1d6c 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -657,6 +657,7 @@ static inline void __unused_size_checks(void)
>  
>  #define SVM_EVTINJ_VALID (1 << 31)
>  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> +#define SVM_EVTINJ_NESTED_EXCEPTION    (1 << 13)
>  
>  #define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
>  #define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 693b46d715b4..374589784206 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -363,6 +363,7 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_queued_exception *ex = &vcpu->arch.exception;
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +	bool nested = is_fred_enabled(vcpu) && ex->nested;

Reverse fir-tree please (swap this with the line above it).  Similar to my comment
on the VMX series, us is_nested to avoid shadowing the global nested.

