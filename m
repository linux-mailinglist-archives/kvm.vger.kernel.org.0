Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A587716B422
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgBXWfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:35:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46411 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728172AbgBXWfH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 17:35:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582583706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGnkB6e4rdFBUfguG9BeEQeU6ECqpXRq/vYlYfJS/aw=;
        b=enM1YaDFSNbOFAabMQouBtgoAxr7XcGZrvtSvZyPHJSxhMdaFoQ21lND/Opa38fdBSS9qP
        BqrGlV31GnNeEMjBnHMEfZYRcMYEA5aPwzcjF6XwfZ3SIuiZ6NOKFNwM7r7i7q+xmhRO5m
        AXrnqcH+k5gNkvo0ZKczmjcVwz+47w0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-vuoGvLxFNdalsX2-3CF_rg-1; Mon, 24 Feb 2020 17:35:05 -0500
X-MC-Unique: vuoGvLxFNdalsX2-3CF_rg-1
Received: by mail-wr1-f70.google.com with SMTP id u18so6258096wrn.11
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 14:35:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yGnkB6e4rdFBUfguG9BeEQeU6ECqpXRq/vYlYfJS/aw=;
        b=VUboPsXL7ouE6RbZHlObkvx0ifrlCZn5yRtM69Db31vtbDaWBO4DfYNe01JLtwLjad
         MgCGhXtZWX8YBQgbEztQk5MTeROmID4l/L1TCy9X4Fj81iD/tkx2reA90T1XH5Qk820F
         pkiVrV8shAV4ncr9R+e80oIgqWwuSZ7q1UYYkn6hOxKoJv1PeoQmYsgT5X6vdwKLX/Kx
         c+fWBIov7M7sCgfs+fd+KYSy7HQZybom5Qs7W8POOIqaJdYLrhVW5JoAFyZ17sPnfxOc
         X8/osL7R1Y/W+vEMYP5dhi7eo1fUXBwntYJfNSJgK4sKeiv4H1Zu9F56icfGJZa/v2Vp
         7OUg==
X-Gm-Message-State: APjAAAXGnghXhy8d/GOuNs+9cDxC2cxXOMO62a3jFwZNlFSqS5FDgYCr
        MtJly8yHaKdumQIcTWviCY0RtiSWSCT9DnX9pmj/AIW9W+YJixAkaWz4ltAegxaxLO7VBuqSiOt
        +43GhTzMvKspo
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr1256914wmo.12.1582583702843;
        Mon, 24 Feb 2020 14:35:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqy++wkv+vMfKzZP77WxbT9tm+gsw/vNmEl88TVeAOdOQffIk6KvSuRzUsDyoIfzLyfWlc1f4Q==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr1256893wmo.12.1582583702544;
        Mon, 24 Feb 2020 14:35:02 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o4sm19960420wrx.25.2020.02.24.14.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:35:01 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 47/61] KVM: x86: Squash CPUID 0x2.0 insanity for modern CPUs
In-Reply-To: <20200201185218.24473-48-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-48-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 23:35:00 +0100
Message-ID: <87r1yjmx63.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Rework CPUID 0x2.0 to be a normal CPUID leaf if it returns "01" in AL,
> i.e. EAX & 0xff.
>
> Long ago, Intel documented CPUID 0x2.0 as being a stateful leaf, e.g. a
> version of the SDM circa 1995 states:
>
>   The least-significant byte in register EAX (register AL) indicates the
>   number of times the CPUID instruction must be executed with an input
>   value of 2 to get a complete description of the processors's caches
>   and TLBs.  The Pentium Pro family of processors will return a 1.
>
> A 2000 version of the SDM only updated the paragraph to reference
> Intel's new processory family:
>
>   The first member of the family of Pentium 4 processors will return a 1.
>
> Fast forward to the present, and Intel's SDM now states:
>
>   The least-significant byte in register EAX (register AL) will always
>   return 01H.  Software should ignore this value and not interpret it as
>   an information descriptor.
>
> AMD's APM simply states that CPUID 0x2 is reserved.
>
> Given that CPUID itself was introduced in the Pentium, odds are good
> that the only Intel CPU family that *maybe* implemented a stateful CPUID
> was the P5.  Which obviously did not support VMX, or KVM.
>
> In other words, KVM's emulation of a stateful CPUID 0x2.0 has likely
> been dead code from the day it was introduced.  This is backed up by
> commit 0fdf8e59faa5c ("KVM: Fix cpuid iteration on multiple leaves per
> eac"), whichs show that the stateful iteration code was completely
> broken when it was introduced by commit 0771671749b59 ("KVM: Enhance
> guest cpuid management"), i.e. not actually tested.
>
> Although it's _extremely_ tempting to yank KVM's stateful code, leave it
> in for now but annotate all its code paths as "unlikely".  The code is
> relatively contained, and if by some miracle there is someone running KVM
> on a CPU with a stateful CPUID 0x2, more power to 'em.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 47f61f4497fb..ab2a34337588 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -405,9 +405,6 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>  		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
>  
>  	switch (function) {
> -	case 2:
> -		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
> -		break;
>  	case 4:
>  	case 7:
>  	case 0xb:
> @@ -483,17 +480,31 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		 * it since we emulate x2apic in software */
>  		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
>  		break;
> -	/* function 2 entries are STATEFUL. That is, repeated cpuid commands
> -	 * may return different values. This forces us to get_cpu() before
> -	 * issuing the first command, and also to emulate this annoying behavior
> -	 * in kvm_emulate_cpuid() using KVM_CPUID_FLAG_STATE_READ_NEXT */
>  	case 2:
> +		/*
> +		 * On ancient CPUs, function 2 entries are STATEFUL.  That is,
> +		 * CPUID(function=2, index=0) may return different results each
> +		 * time, with the least-significant byte in EAX enumerating the
> +		 * number of times software should do CPUID(2, 0).
> +		 *
> +		 * Modern CPUs (quite likely every CPU KVM has *ever* run on)
> +		 * are less idiotic.  Intel's SDM states that EAX & 0xff "will
> +		 * always return 01H. Software should ignore this value and not
> +		 * interpret it as an informational descriptor", while AMD's
> +		 * APM states that CPUID(2) is reserved.
> +		 */
> +		max_idx = entry->eax & 0xff;
> +		if (likely(max_idx <= 1))
> +			break;
> +
> +		entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
>  		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
>  
> -		for (i = 1, max_idx = entry->eax & 0xff; i < max_idx; ++i) {
> +		for (i = 1; i < max_idx; ++i) {
>  			entry = do_host_cpuid(array, 2, 0);
>  			if (!entry)
>  				goto out;
> +			entry->flags |= KVM_CPUID_FLAG_STATEFUL_FUNC;
>  		}
>  		break;
>  	/* functions 4 and 0x8000001d have additional index. */
> @@ -903,7 +914,7 @@ static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
>  		return 0;
>  	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
>  		return 0;
> -	if ((e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
> +	if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
>  	    !(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
>  		return 0;
>  	return 1;
> @@ -920,7 +931,7 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
>  
>  		e = &vcpu->arch.cpuid_entries[i];
>  		if (is_matching_cpuid_entry(e, function, index)) {
> -			if (e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC)
> +			if (unlikely(e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC))
>  				move_to_next_stateful_cpuid_entry(vcpu, i);
>  			best = e;
>  			break;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

but your history digging results make me think that killing the whole
'statefulness' thing is not a bad idea at all :-)

-- 
Vitaly

