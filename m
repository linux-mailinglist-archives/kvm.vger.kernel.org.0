Return-Path: <kvm+bounces-39784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 58365A4A75D
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 02:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D801E188A11F
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 01:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41576224F6;
	Sat,  1 Mar 2025 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hSI0oZrU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8081B95B
	for <kvm@vger.kernel.org>; Sat,  1 Mar 2025 01:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740792237; cv=none; b=e2jJt9Gso3vjl1EMLylbfs+gjmBb4HcRFE84WZrC7t0Xm7SBcRqqRiazckZRsL7rJ9pcbCA713eFDdc1q3xiawDXO9b8PEN700xa0ZhYaBp09oG9kOL82xJ80F5Jr7zo5QSdMXBhA5CFkg1DtC3tULAfR19n9vMoYH5lCYam/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740792237; c=relaxed/simple;
	bh=o1p+ne+HAvY4DDZ63M6vfhpNc3u5cYCy3IlSrcF7C2I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=geZbpZ+91FDIAEXoiWS6n7fnW0PlLjYQ6cdMa8/hmRLn9p4wzvO5DCucThrKX4z5Hk4kU44jDp5n4+zC0PaiTT4fdJmivSkxSUfR3Tfy8d+hKZGuIFCyGAKZDszLzIu+zpkRXlM10Xp2QDeH1oDBakT3S2JI+5aOOx/waBvz/jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hSI0oZrU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740792234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8OAJrklYzp8/r3g4lixGYj7CZWiatxwAHqPRLaD3+jg=;
	b=hSI0oZrUIZCPaKBnaCxLwHPggXCoYcbVetrmiSMjfKGYvGO2TM5quCmpACSwYcvx8pE4va
	SyAYwk0tAun58+W5uSd3+QDoVN33PtmBjWgiGgxypslF9oGh9u5F4V87x57zQ6KCcR6yee
	oRnXjI8gybOZGqf1wJnLWb/oc+1B0M0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-ewfmorlXOEybmQ-wcShDdQ-1; Fri, 28 Feb 2025 20:23:50 -0500
X-MC-Unique: ewfmorlXOEybmQ-wcShDdQ-1
X-Mimecast-MFC-AGG-ID: ewfmorlXOEybmQ-wcShDdQ_1740792230
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e8993deec9so57698506d6.3
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 17:23:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740792230; x=1741397030;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8OAJrklYzp8/r3g4lixGYj7CZWiatxwAHqPRLaD3+jg=;
        b=oU8EWx7irdQAqQYUKXEjBVVUz+VRJDb3JqZYvOYKp5jdOB1f0A4Raqm14X0Tg+An1A
         loVZDoI/TVPilwccsdqvh8zE1MiaJaRtlkln+P/93VAMWVJ3bd5n/RuD0/GcJ05TqbgG
         gH7gA+d6z6JljcPJRQHo7uJ+L8wd415iv7AoRB11Zdy3OnlbwWBGksqJTNJjvUMu9Oyn
         ChO1LURpaQJ7pAxU/Tv9A1d+zxHk2fGpMPN0qDa/fT/wmmyDfUSZ5FDN7kz9em614OEx
         FurU3yZM0++Jt30EpdUswpNkijfulWqRQ4uUei8U0YiRu3Pd2lPTCCtSUspCZkWvkzny
         B/6A==
X-Gm-Message-State: AOJu0YxlUTs38Bx0ykWm6FWcb4kPCWtdAp9B+ztaAQwaLyQoge15X0rG
	TpRxEoNrhgrqMccAwCyRAt7szxmSaUItdOu6Ra/kKCVGEl1PgQHNkxKAVCM0hAsD0/zntqcNBxZ
	1/6cHyYEnqz6tLmCSaM4YGhmkqALL+Y4AfkBZgCC6mb2TyUejSQ==
X-Gm-Gg: ASbGncv+XE8FSrHch84MHs+sgK0982Va1qUZ4rdP9hJJqB25AT13BeNRLZKjc9v7zHJ
	NlMzCiuKaR3woRTyXnNExqRj6LITQYa3t6JuyIjlu8j8B9ygwzsywkYvoztZAh1p0ZJP5xs8IAU
	+ZVmct7CRH5XRkFxTnJ0wl0PhNzbnuDt9fINWzjcimZcx8axy+1eaiC9fN3uEanFVmneYBEjW02
	frXLRmq+cVZKpbhGuLRUMb+pms9kXpu9//SeTkNPyU06PnC9vyBg8cqjBlr1zAMD00RcTbtF3ag
	BpnxhwK9ld4NPf0=
X-Received: by 2002:ad4:574c:0:b0:6e6:64e8:28e7 with SMTP id 6a1803df08f44-6e8a0d0895amr88661476d6.15.1740792230268;
        Fri, 28 Feb 2025 17:23:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqrmNkALLpnsrIVr0ZBViMhrVD8kVQJKE0j3X/XcwAt87q8J9yjv80JpSGnSy0+3KHJEeJbA==
X-Received: by 2002:ad4:574c:0:b0:6e6:64e8:28e7 with SMTP id 6a1803df08f44-6e8a0d0895amr88661316d6.15.1740792229955;
        Fri, 28 Feb 2025 17:23:49 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976ccbefsm27878336d6.85.2025.02.28.17.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 17:23:49 -0800 (PST)
Message-ID: <7addde721e3f67bfa8ec5c9671f51d131f84bc6b.camel@redhat.com>
Subject: Re: [RFC PATCH 01/13] KVM: nSVM: Track the ASID per-VMCB
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2025 20:23:48 -0500
In-Reply-To: <20250205182402.2147495-2-yosry.ahmed@linux.dev>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-2-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-02-05 at 18:23 +0000, Yosry Ahmed wrote:
> The ASID is currently tracked per-vCPU, because the same ASID is used by
> L1 and L2. That ASID is flushed on every transition between L1 and L2.
> 
> Track the ASID separately for each VMCB (similar to the
> asid_generation), giving L2 a separate ASID. This is in preparation for
> doing fine-grained TLB flushes on nested transitions instead of
> unconditional full flushes.
> 
> The ASIDs are still not fully maintained (e.g. a remote flush will only
> flush the current ASID), so keep the TLB flush on every transition until
> this is sorted out.
> 
> L1's ASID will be flushed on KVM_REQ_TLB_FLUSH_GUEST if it is the
> active context, so remove the TODO in nested_svm_transition_tlb_flush()
> about it.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c |  1 -
>  arch/x86/kvm/svm/sev.c    |  2 +-
>  arch/x86/kvm/svm/svm.c    | 12 +++++++-----
>  arch/x86/kvm/svm/svm.h    |  2 +-
>  4 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 04c375bf1ac2a..bbe4f3ac9f250 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -495,7 +495,6 @@ static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>  	 *  - Honor L1's request to flush an ASID on nested VMRUN
>  	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
>  	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
> -	 *  - Flush L1's ASID on KVM_REQ_TLB_FLUSH_GUEST
>  	 *
>  	 * [*] Unlike nested EPT, SVM's ASID management can invalidate nested
>  	 *     NPT guest-physical mappings on VMRUN.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 799f8494b599c..b0adfd0537d00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3468,7 +3468,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
>  
>  	/* Assign the asid allocated with this SEV guest */
> -	svm->asid = asid;
> +	svm->current_vmcb->asid = asid;
>  
>  	/*
>  	 * Flush guest TLB:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a6..08340ae57777b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1335,8 +1335,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		save->g_pat = vcpu->arch.pat;
>  		save->cr3 = 0;
>  	}
> -	svm->current_vmcb->asid_generation = 0;
> -	svm->asid = 0;
> +	svm->vmcb01.asid_generation = 0;
> +	svm->vmcb01.asid = 0;
> +	svm->nested.vmcb02.asid_generation = 0;
> +	svm->nested.vmcb02.asid = 0;
>  
>  	svm->nested.vmcb12_gpa = INVALID_GPA;
>  	svm->nested.last_vmcb12_gpa = INVALID_GPA;
> @@ -1988,7 +1990,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
>  	}
>  
>  	svm->current_vmcb->asid_generation = sd->asid_generation;
> -	svm->asid = sd->next_asid++;
> +	svm->current_vmcb->asid = sd->next_asid++;
>  }
>  
>  static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
> @@ -4235,8 +4237,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  
>  	sync_lapic_to_cr8(vcpu);
>  
> -	if (unlikely(svm->asid != svm->vmcb->control.asid)) {
> -		svm->vmcb->control.asid = svm->asid;
> +	if (unlikely(svm->current_vmcb->asid != svm->vmcb->control.asid)) {
> +		svm->vmcb->control.asid = svm->current_vmcb->asid;
>  		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
>  	}
>  	svm->vmcb->save.cr2 = vcpu->arch.cr2;
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf872..ebbb0b1a64676 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -133,6 +133,7 @@ struct kvm_vmcb_info {
>  	unsigned long pa;
>  	int cpu;
>  	uint64_t asid_generation;
> +	u32 asid;
>  };
>  
>  struct vmcb_save_area_cached {
> @@ -247,7 +248,6 @@ struct vcpu_svm {
>  	struct vmcb *vmcb;
>  	struct kvm_vmcb_info vmcb01;
>  	struct kvm_vmcb_info *current_vmcb;
> -	u32 asid;
>  	u32 sysenter_esp_hi;
>  	u32 sysenter_eip_hi;
>  	uint64_t tsc_aux;

Hi,


I think it should be possible to eliminate separate ASID field (current_vmcb->asid/svm->asid)
completely and instead just use the value stored in the vmcb.

When there is a need to update it, KVM can also set the corresponding dirty bit
as done in svm_vcpu_run (new_asid also already does this when the asid generation increases)

Also KVM already sets the tlb_ctl directly in the vmcb.

What do you think?

Best regards,
	Maxim Levitsky






