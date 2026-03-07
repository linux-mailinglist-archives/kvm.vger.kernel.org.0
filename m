Return-Path: <kvm+bounces-73212-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMrRKpCHq2mFdwEAu9opvQ
	(envelope-from <kvm+bounces-73212-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:04:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5C122990E
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:04:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B370E30364CE
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDAF1BD035;
	Sat,  7 Mar 2026 02:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0sELIEwE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D70F7263B
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 02:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772849033; cv=none; b=FscRA/mksgNLSG+6TTU12RhOviWwGF8kcpIUuJNDw6zLURtFU7/6fwUR38vf3RIykjcrmNhJSIZ7IuqlPgEyMxZVTVS0TUy6kQylPYfiHcMMV4FBnfuMwT8jdaQDMToOwCKVGBJlcMDbEKYzb8UNJrDnEUAUBEGkUrhEoN0S4nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772849033; c=relaxed/simple;
	bh=kGFM2OEDfmv6N2k4xQbb1jTGC3yaGAZBId/wgDyIdwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fj11DFBfDStxJ3wfjOPLZz63n1+YY3Wdu6JvXOx97GBtRnvlFE7PomZnAarrWfJQy+LH5UzIDZr0jMWDfjtU6qMRitqYQ4i1N7htLZGAkmCQuJ86PuLdZqavUfXZoCwhR8vPodccjQQflJBnltCOKdfg1vSoA8uMgNRfpo/VXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0sELIEwE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae65d5cc57so190349895ad.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772849031; x=1773453831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C5HIEJXR2MAQS7zpR+bu3onDxrctknEq1HMvD7IIdz4=;
        b=0sELIEwEP3KMc77zbZ7HSvWYehBni9Mub2h4lRIPxp0xp5fW7PQDLbEHubHL08ppy3
         fIj50hiVaGPgjO8wvM2Hv2yfHtmBtOKL8TdH4M8tFgu7WUnGS1YBo/loEU1wpLTAjkgu
         hv76wneMnrHLRE3Zvf4wBg9xUJVYG92d6LB2k/EinObkuElKto3FzdKq7nUAcVsPfOy6
         FCoLyKtBcNk78OYJBmAGee+Sg1iicb1tC3Xokh2JatzT6bkpJ9sKTYcDKrOdzYidxIOq
         Ws+wiWLi42WAnr9gnVtr8fWTeHbhW1nJkifiJesFbCKEjuJ3xTUjGOD2dGAy3/FHyPyj
         hCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772849031; x=1773453831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C5HIEJXR2MAQS7zpR+bu3onDxrctknEq1HMvD7IIdz4=;
        b=W+LQOX9aCHIKVlNpG1y573/H+p36/f8mexqKZvTevz/C9QVPE3OEDiPTNZoBpEAGxr
         J9anLwqzSWNyY2SdWi3c3oHJBI+PSf6Xke+OJokCDtOpm1rLSeSh9RPXl4UaXzs6ZIwL
         gwgC2zk+g/YcF2uNcvx6If4bEPUjnm0810q7oQddgDh4bbJQZnC08rZFNLA+vfESHtGs
         OPnBN6i2DxABy2FveVCe2zllmGl31dIwURUT8WTksGSZcJYHM4kvtHwMpvMfEGhmcNya
         yfiRsOYwl6snsRuAZb8sVyarYQLLLS6fbZ3ICNGAgJT/ABJh0gYWlI3OJH+eHnF/vDpB
         Lxew==
X-Forwarded-Encrypted: i=1; AJvYcCUHcgZf5lgzGSXWp1kyVrZgW7TVzyOY3WT8M518Tl7q6VuuVme7sZe5o7LYSgDwGKoS6dA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8Ac4Wu0KEWNPkfn/k/v1vaUcvf+sOojF7PwDL1FXkDliTvc+t
	fBfI8BT400KShgRWQSGIO6oMveiJH89AoKCY/LW0WHnTCg7qqnJXkyXV5m77heV4bkVfvpbqGMn
	Kj564kg==
X-Received: from pltf4.prod.google.com ([2002:a17:902:74c4:b0:2ae:42f6:31a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e786:b0:2ae:588a:f3e5
 with SMTP id d9443c01a7336-2ae8243b580mr37713045ad.30.1772849030541; Fri, 06
 Mar 2026 18:03:50 -0800 (PST)
Date: Fri, 6 Mar 2026 18:03:49 -0800
In-Reply-To: <20260129063653.3553076-7-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com> <20260129063653.3553076-7-shivansh.dhiman@amd.com>
Message-ID: <aauHhQsIzJo68bW_@google.com>
Subject: Re: [PATCH 6/7] KVM: SVM: Dump FRED context in dump_vmcb()
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 6E5C122990E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73212-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.925];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
> Add fields related to FRED to dump_vmcb() to dump FRED context.
> 
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 374589784206..954df4eae90e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3319,6 +3319,8 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
>  	pr_err("%-20s%016llx\n", "allowed_sev_features:", control->allowed_sev_features);
>  	pr_err("%-20s%016llx\n", "guest_sev_features:", control->guest_sev_features);
> +	pr_err("%-20s%016llx\n", "exit_int_data:", control->exit_int_data);
> +	pr_err("%-20s%016llx\n", "event_inj_data:", control->event_inj_data);
>  
>  	if (sev_es_guest(vcpu->kvm)) {
>  		save = sev_decrypt_vmsa(vcpu);
> @@ -3434,6 +3436,25 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  		       "r14:", vmsa->r14, "r15:", vmsa->r15);
>  		pr_err("%-15s %016llx %-13s %016llx\n",
>  		       "xcr0:", vmsa->xcr0, "xss:", vmsa->xss);
> +
> +		pr_err("%-27s %d %-18s%016llx\n",
> +		       "is_fred_enabled:", is_fred_enabled(vcpu),
> +		       "guest_evntinjdata:", vmsa->guest_event_inj_data);
> +		pr_err("%-12s %016llx %-18s%016llx\n",
> +		       "fred_config:", vmsa->fred_config,
> +		       "guest_exitintdata:", vmsa->guest_exit_int_data);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_rsp0:", vmsa->fred_rsp0,
> +		       "fred_rsp1:", vmsa->fred_rsp1);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_rsp2:", vmsa->fred_rsp2,
> +		       "fred_rsp3:", vmsa->fred_rsp3);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_stklvls:", vmsa->fred_stklvls,
> +		       "fred_ssp1:", vmsa->fred_ssp1);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_ssp2:", vmsa->fred_ssp2,
> +		       "fred_ssp3:", vmsa->fred_ssp3);
>  	} else {
>  		pr_err("%-15s %016llx %-13s %016lx\n",
>  		       "rax:", save->rax, "rbx:",
> @@ -3461,6 +3482,24 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  		       "r14:", vcpu->arch.regs[VCPU_REGS_R14],
>  		       "r15:", vcpu->arch.regs[VCPU_REGS_R15]);
>  #endif
> +		pr_err("%-26s %d %-18s %016llx\n",
> +		       "is_fred_enabled:", is_fred_enabled(vcpu),
> +		       "guest_evntinjdata:", save->guest_event_inj_data);
> +		pr_err("%-12s%016llx %-18s%016llx\n",
> +		       "fred_config:", save->fred_config,
> +		       "guest_exitintdata:", save->guest_exit_int_data);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_rsp0:", save->fred_rsp0,
> +		       "fred_rsp1:", save->fred_rsp1);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_rsp2:", save->fred_rsp2,
> +		       "fred_rsp3:", save->fred_rsp3);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_stklvls:", save->fred_stklvls,
> +		       "fred_ssp1:", save->fred_ssp1);
> +		pr_err("%-15s %016llx %-13s %016llx\n",
> +		       "fred_ssp2:", save->fred_ssp2,
> +		       "fred_ssp3:", save->fred_ssp3);

These should all be gated on guest_cpu_cap_has(X86_FEATURE_FRED).  Just because
KVM can read and print garbage doesn't mean it should.

