Return-Path: <kvm+bounces-73216-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFKbIAWKq2kBeAEAu9opvQ
	(envelope-from <kvm+bounces-73216-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:14:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFFA722997C
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 03:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 287F430642D1
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 02:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EEC3054C7;
	Sat,  7 Mar 2026 02:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UFTIvws6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF442D9EDC
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 02:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772849654; cv=none; b=Y0RxweRaMf8oPCgBeounjgc/91UCW3YekCq2Vp3GfH1HaKdJ0oZqv17Xq14xUYpdK7rAufVrWF+TOkFSOZwLPp7PY34lD6eZcoIagFoNN9yNoZDMQlP6W1PtS+tYAjLDxZ6jwPdD990HRrKYqecUdzM2jvHgUKDFx0ZTHlvfepk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772849654; c=relaxed/simple;
	bh=Y395lIQ0hqDNqGEN3fx1A+kJN5RvFSfuHVtZgsHZG5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qaxBMppx+rCRZZKxf0Z+19jX03Ro0L5LcTIfQnRtH/J/R+UOaHoveNsuIVtlCQmX/MFd+jJ3PCfEAT1ePGOEmDxcrRKXGe7KhGX/ewa4UMNIhWXDfNvmbsFZQgoxLO89MXIZBcMYPx+ra1b6yoesJRBheOshG5CBT5mWBgIpT0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UFTIvws6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3598f4fbb13so6051890a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 18:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772849653; x=1773454453; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5mnZtdvwdg33I7WPQAij4vbG2jYvg3cJFZqosGMJQS0=;
        b=UFTIvws6GecO4dOZJGcxp07lVisgl5urt6Op9957xYHVXSkGJm0j+rErn5y+oyWv8S
         qyMTSxPYAh7vbQd9OispcdqwRrFpXassJXA71+x5kwctZcQ11HMi7dL0UEQ/r3meEvHk
         upvdgL49saUZL0sbsOmx9lMTL5XnMR0+qHQRoyFMsBcspD6DQTFEyzIBexcwKy8v0JyB
         4NclfqZlW/yjXNw3PgdRGuQOK4135zNaHqsmkgWVtISQs2q/pFJE9/h3Jso3KbrsA0AW
         iag5gYuPp/JOLbChx1xyEmSY+96PTxCbT4UAvgzGOGNOEkGI/F2GmMqMf9dRyoI01Z90
         UFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772849653; x=1773454453;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5mnZtdvwdg33I7WPQAij4vbG2jYvg3cJFZqosGMJQS0=;
        b=tB0tGGIy7yQVjHPKMGcKSKzk4GJqy2MF3JvSxUGaTQjFx1tGGejzgvvj5HXfeKaeKL
         GkEP+F3NVPXMNmXzFZou/e/Xq20SYRI48l7T8Ipe7wTZcKq2yekQlPDwTpmygNzAHwN5
         zQyicTCnNfU5t0uzGHuTbRCr902FzHHMlG8nKHtW4UYNwVSlgjNHdb8tL7S7bh6yJ8kv
         Tzf6OI39tKRKeJxVDfhxw9o0LYZUGJyc/09A/WWsd9iQvsUD7xhpwpqClO2qbK/0bC0x
         Uw6xbqXBNDB2LRDPIzOFG8ADehN5buaDOayhE0CHnJu9YRCK1tas3STJK2Si9t6jATCu
         Xxqg==
X-Forwarded-Encrypted: i=1; AJvYcCUDEkas7b/P7Kj1ACH0DLtP6mobldH2qoZ6o9JKMYhO89Af0uxaapzjLj6wsLTOTfM/d+k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3qwXfVM3kZY5SIvXwsqeNII7EM9z/3u+S1GQKZJyegwl40LSG
	20z4WCc9aLRvx6NMSXWuZeOOxi2D8XL4aflTGpcjdt64JQdO3FGqdlNR5mMjz4O11TSXmrIAi+0
	iFHJg8w==
X-Received: from pjso17.prod.google.com ([2002:a17:90a:c091:b0:359:8375:fab9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4e86:b0:359:97d3:5c5b
 with SMTP id 98e67ed59e1d1-359be2ef302mr3189152a91.20.1772849652958; Fri, 06
 Mar 2026 18:14:12 -0800 (PST)
Date: Fri, 6 Mar 2026 18:14:11 -0800
In-Reply-To: <20260129063653.3553076-8-shivansh.dhiman@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com> <20260129063653.3553076-8-shivansh.dhiman@amd.com>
Message-ID: <aauJ80pZrw_SfF31@google.com>
Subject: Re: [PATCH 7/7] KVM: SVM: Enable save/restore of FRED MSRs
From: Sean Christopherson <seanjc@google.com>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com, 
	nikunj.dadhania@amd.com, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: DFFA722997C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73216-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	URIBL_MULTI_FAIL(0.00)[amd.com:server fail,sea.lore.kernel.org:server fail];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.926];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:email]
X-Rspamd-Action: no action

On Thu, Jan 29, 2026, Shivansh Dhiman wrote:
> Set the FRED_VIRT_ENABLE bit (bit 4) in the VIRT_EXT field of VMCB to enable
> FRED Virtualization for the guest. This enables automatic save/restore of
> FRED MSRs. Also toggle this bit when setting CPUIDs, to support booting of
> secure guests.
> 
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 954df4eae90e..24579c149937 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1144,6 +1144,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu, bool init_event)
>  	save->fred_ssp3 = 0;
>  	save->fred_config = 0;
>  
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> +		svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;

This is completely unnecessary, no?  CPUID is empty at vCPU creation and so FRED
_can't_ be enabled before going through svm_vcpu_after_set_cpuid().

>  	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
>  	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
>  
> @@ -4529,6 +4532,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	if (guest_cpuid_is_intel_compatible(vcpu))
>  		guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
>  
> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
> +		svm->vmcb->control.virt_ext |= FRED_VIRT_ENABLE_MASK;

The flag needs to be cleared if FRED isn't supported, because KVM's wonderful
ABI allows userspace to modify CPUID however many times it wants before running
the vCPU.

> +
>  	if (sev_guest(vcpu->kvm))
>  		sev_vcpu_after_set_cpuid(svm);
>  }
> -- 
> 2.43.0
> 

