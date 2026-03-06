Return-Path: <kvm+bounces-73030-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIfRC0e7qmmiVwEAu9opvQ
	(envelope-from <kvm+bounces-73030-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:32:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F19521FB1E
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BFD773064648
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBAA36403B;
	Fri,  6 Mar 2026 11:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ezl9wJNm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j7B0l3EV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA519273803
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 11:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772796721; cv=none; b=svAB8kQDHce9nErpxc7J2H37VpDZX8DiB9VeoW3NFgtMYix/AVJlY5pogSGCFyIJ2V8mkNQY5mk4IViLkndLZ7b0WHyFExV1q7yPxwtx2H4kDmIiF1AGz/CEwxBir3rnkN/CKA/BLGgsHL3DVUZFGP7ya4LPBtXZH4emVuCWNos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772796721; c=relaxed/simple;
	bh=IB/8T4bcRwqJW7qkPjt1Y/B1VUTQBSkGgXvL5lCG8i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d6vUvl5ZZhdji1Zd9lQyBU2Qo8FKMOStbHU93zBcfJ/kGzGP6dvgpF/shiPpYGaF+HbW+3G0ZaRFDzBjiUy3lZTcsrkn3ePGjq+RFTflkZW6xSOzbGw4XFsmg3vBtupPtDnpNBf+BlIO46yTXisIjOVRIEW/0cWEGt0eAWdVIic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ezl9wJNm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j7B0l3EV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772796719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mE/NjsbASrzJEKUSNMD1TI5Q2DNpk7Rf/uNUvjO5uY=;
	b=ezl9wJNmFKkChWpkRTq3CrmaCtRJFrff/wTLZUtnmT+Tandod9FjX+WM+EF5OlS7mNKI3M
	TkOvpeVwN7Ba1RSHbFxcUNRsZoM8LO6pk8GlqU39ZpVGQge3o2w60gFNs/+96NUSkOqMe5
	9Pe/H5VYM3czI4ruuV2htHf1OqEJpHo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-TBBHzao3OTOYGHN11ZxMxA-1; Fri, 06 Mar 2026 06:31:58 -0500
X-MC-Unique: TBBHzao3OTOYGHN11ZxMxA-1
X-Mimecast-MFC-AGG-ID: TBBHzao3OTOYGHN11ZxMxA_1772796717
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so67243875e9.3
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 03:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772796717; x=1773401517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+mE/NjsbASrzJEKUSNMD1TI5Q2DNpk7Rf/uNUvjO5uY=;
        b=j7B0l3EVCXEsFgrKbyPBhcYNY0iRy0nm6R44f8XiwMxxWOFtDd44Eb4AR9AG4KqWQ7
         8tuk/sRsoknW3nRnuVj8yazaXigIjS4Bbc2BK/NV5ypM6Yt8gpHx9X3XW1MvfyJtwfOj
         HQIOCFbhWlz5Pr6vFQyreqCDw06ogfMhBcDuFyuNoG65hUXYJUgcD73w+0VzjNPhcYib
         fLFhk6MPY5ielzdpZQbAwOAAeW55VGFZgdlXs8ZwojQeyF4rhxRY3X/eNOPqyv6CCQwt
         B5fCNz3Suk4w57CWF0R6GS1sLegPm2gy33MLrhUB7NgSOKcBuM4YcciNEBrxYUnmY5iA
         ONQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772796717; x=1773401517;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+mE/NjsbASrzJEKUSNMD1TI5Q2DNpk7Rf/uNUvjO5uY=;
        b=sicyTClbLhpv4ly4r7Eh8sHHZHVyGQuxLLg9kEKZlGxeXA1KpLG+UJSw3PFaHT0MtZ
         GbkDRFEJgZwYr/BbC6cpUEeiv+pWp6JzMRqbRgom/V4jGD/6Wurjwvdlwg9iL8RQLY3A
         Y7iZqAh76ItzTTIGNr8nNK4lHE/SXIqoxPXC5EZngVJu3f8EARL/Fu4QeY4yU3l7Xt5I
         HhCnw/mTpTHiwdXPMjaRsLEq9CiniN1EbGPx2MCGTzk9MIyXdvGjPQjWQ4tlZIJ4Qkwo
         trn+zok3GnWz/KpsSil0/VhyRTmk3HPjN5JIU9k5rMgxPRykh2pr+CPrUaLESgSrYZur
         bc+g==
X-Forwarded-Encrypted: i=1; AJvYcCW+dtnk+rzwQqIvCQj/BzkCj8+KuYpuCszbDhmgvC7sqPKKuFMhizyBo2av+rMr+ulvnXw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+yLiZZeGI4KfwsKFHuqDLeuKA6kwPMdL0hsuW2nbNJqLqI0PZ
	/ExvrKQud4P7YD3UtvUzLPezg/GziYI2k1SmvUsB78BsvcZnpmMJHa/TG7tfkzUR3W812RGAcdn
	LcZkkg/VqXH4Ijcs+pA5UbdL2RgeF3c4SxLH8kzpKa+XGDGad7deBiw==
X-Gm-Gg: ATEYQzwuNUN0H0/9i3KVDUeJHEjPbbRAtUWxew4IpxMLRyeS+8GybOUV9ADfc0GeaDJ
	Vb3CvYPeBjMGC1BJKZr2+VGLJ6rZAF7zKmCyfCIqwkwo3b4KQKx2Al8cEZFfkzzlDNcAl6nHegc
	woVV5EyEDiX3TqU6zqHfh7HM4s0vX/iQzVHXS0T8UQcTdt/1FlUkySPdFYyOfD/ddql+xlken6S
	9kOWsMbv+lXgUnHLE/X2CKxLB8rG+EYw3nKb5A+v5ntJNliR7ZQ69Z2HoRc85bC1QtXggYL4mD8
	ZxBdcSEccPEU0oR3BVMzv3+TAqtlWR9GDlbXfdoF7A9qSuc2Zcub7WHqkgMJvERaW+URnbpu3pZ
	VrqVX2Pf54O0UDT92EX1CVjer53nFK1w00tBxZzQuXBXMTL7hJsEe8TIAoTBZAXnx8rb3QBnLA3
	3vurL+BJ6EiqCj2Zucu1CmJuKA+yo=
X-Received: by 2002:a05:600c:a12:b0:483:badb:618f with SMTP id 5b1f17b1804b1-48526966b07mr26161155e9.25.1772796717282;
        Fri, 06 Mar 2026 03:31:57 -0800 (PST)
X-Received: by 2002:a05:600c:a12:b0:483:badb:618f with SMTP id 5b1f17b1804b1-48526966b07mr26160755e9.25.1772796716824;
        Fri, 06 Mar 2026 03:31:56 -0800 (PST)
Received: from [192.168.10.81] ([151.95.144.138])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-439dad8d840sm4118705f8f.8.2026.03.06.03.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 03:31:56 -0800 (PST)
Message-ID: <d9741f70-4af5-448b-a63d-5fdeb7e03ace@redhat.com>
Date: Fri, 6 Mar 2026 12:31:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: SVM: Populate FRED event data on event injection
To: Shivansh Dhiman <shivansh.dhiman@amd.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, xin@zytor.com,
 nikunj.dadhania@amd.com, santosh.shukla@amd.com
References: <20260129063653.3553076-1-shivansh.dhiman@amd.com>
 <20260129063653.3553076-5-shivansh.dhiman@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
In-Reply-To: <20260129063653.3553076-5-shivansh.dhiman@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9F19521FB1E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-73030-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,amd.com:email]
X-Rspamd-Action: no action

On 1/29/26 07:36, Shivansh Dhiman wrote:
> From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> 
> Set injected-event data (in EVENTINJDATA) when injecting an event,
> use EXITINTDATA for populating the injected-event data during
> reinjection.
> 
> Unlike IDT using some extra CPU register as part of an event
> context, e.g., %cr2 for #PF, FRED saves a complete event context
> in its stack frame, e.g., FRED saves the faulting linear address
> of a #PF into the event data field defined in its stack frame.
> 
> Populate the EVENTINJDATA during event injection. The event data
> will be pushed into a FRED stack frame for VM entries that inject
> an event using FRED event delivery.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Co-developed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>   arch/x86/kvm/svm/svm.c | 22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ddd8941af6f0..693b46d715b4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -374,6 +374,10 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
>   		| SVM_EVTINJ_VALID
>   		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
>   		| SVM_EVTINJ_TYPE_EXEPT;
> +
> +	if (is_fred_enabled(vcpu))
> +		svm->vmcb->control.event_inj_data = ex->event_data;
> +
>   	svm->vmcb->control.event_inj_err = ex->error_code;
>   }
>   
> @@ -4066,7 +4070,7 @@ static void svm_complete_soft_interrupt(struct kvm_vcpu *vcpu, u8 vector,
>   		kvm_rip_write(vcpu, svm->soft_int_old_rip);
>   }
>   
> -static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
> +static void svm_complete_interrupts(struct kvm_vcpu *vcpu, bool reinject_on_vmexit)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   	u8 vector;
> @@ -4111,6 +4115,7 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>   		break;
>   	case SVM_EXITINTINFO_TYPE_EXEPT: {
>   		u32 error_code = 0;
> +		u64 event_data = 0;
>   
>   		/*
>   		 * Never re-inject a #VC exception.
> @@ -4121,9 +4126,18 @@ static void svm_complete_interrupts(struct kvm_vcpu *vcpu)
>   		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR)
>   			error_code = svm->vmcb->control.exit_int_info_err;
>   
> +		/*
> +		 * FRED requires an additional field to pass injected-event
> +		 * data to the guest.
> +		 */
> +		if (is_fred_enabled(vcpu) && (vector == PF_VECTOR || vector == DB_VECTOR))
> +			event_data = reinject_on_vmexit ?
> +					svm->vmcb->control.exit_int_data :
> +					svm->vmcb->control.event_inj_data;

The new argument is not needed, just...

> @@ -4146,7 +4160,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>   	control->exit_int_info = control->event_inj;
>   	control->exit_int_info_err = control->event_inj_err;

... move event_inj into exit_int here, similar to the other fields:

	control->exit_int_data = control->event_inj_data;

Paolo

>   	control->event_inj = 0;
> -	svm_complete_interrupts(vcpu);
> +	svm_complete_interrupts(vcpu, false);
>   }
>   
>   static int svm_vcpu_pre_run(struct kvm_vcpu *vcpu)
> @@ -4382,7 +4396,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
>   
>   	trace_kvm_exit(vcpu, KVM_ISA_SVM);
>   
> -	svm_complete_interrupts(vcpu);
> +	svm_complete_interrupts(vcpu, true);
>   
>   	return svm_exit_handlers_fastpath(vcpu);
>   }


