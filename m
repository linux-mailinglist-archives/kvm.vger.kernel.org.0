Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B6F43FCC5
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 14:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhJ2M6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 08:58:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230273AbhJ2M6i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Oct 2021 08:58:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635512169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d0L5NlzkxXwUpiuMJl7fVIMjjxlsJowOl0CPT1kdun0=;
        b=ZQHPPyL/bqC3JPlm8Pp8CKmTLa0syt/xHZhSzoRAUYXoo9JVqogpzw24Vnmbt24D9rlnZ5
        s1Re6xCGdg2Z0p5Fe+0Nwh3zb1I345g9kS9aTJnn1spxiabSKEIuLyeFZtsNM3bvq6t39S
        f5RrDjn0w+yPGkvzmBPxL2Yu6DyOI34=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-K5EoP40jNT-kFtS9Ei-55A-1; Fri, 29 Oct 2021 08:56:08 -0400
X-MC-Unique: K5EoP40jNT-kFtS9Ei-55A-1
Received: by mail-ed1-f70.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso9120171edb.7
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 05:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=d0L5NlzkxXwUpiuMJl7fVIMjjxlsJowOl0CPT1kdun0=;
        b=LrhaQyOs2EpB7KwmHoSGiGKDrjmTHsDyRx0qY93oCNaXd1eJo3m1XYHxIVCm07IVic
         naqv9bWDOVXlfhJYUhCtJN+NfA4QAhRMsu+UZix9qImBbVuuiP0da/8TSVNDI2s67Fbl
         gqwYT7v9DTZRoA804B3aeFYjf29jQWEWEBtBVIvgNC0rWYNm2YK9tPftfHf1CuxQD6dC
         +l9KRarOLwUPvE5nKxZaR3I1KpNd243la2tb4J7SLEteftYx8T6yYCFX3bxpjyF4jH4Q
         3UknM6QBxmT8SObwPB0T05mGVkpYK7YoJ979diFGiT2xFTMfh5aln24Li9Vs6LYLnzpt
         n44w==
X-Gm-Message-State: AOAM5330jwMb4eD8azYqWGyumHDwdhuteCXjiPPFGfl65zTnOyQySP3x
        RmQQAqC5NmS7hmBaElC/q1lVw+kUeMDHl1rFuo15WqPZXFxENP57IcsH7klngzw8CvhcqDnwJs6
        nfzlWtCFBZmpQ
X-Received: by 2002:a17:907:3e19:: with SMTP id hp25mr6777842ejc.72.1635512166886;
        Fri, 29 Oct 2021 05:56:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7OP0JFnb/I+DV9ovvS4NRvD8P3XfBnwRLB5GvR+8tmzIzPlvDUB4lPXF2A/ATmGs1ilsBpA==
X-Received: by 2002:a17:907:3e19:: with SMTP id hp25mr6777798ejc.72.1635512166571;
        Fri, 29 Oct 2021 05:56:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m3sm3548604edc.36.2021.10.29.05.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 05:56:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] KVM: x86: Shove vp_bitmap handling down into
 sparse_set_to_vcpu_mask()
In-Reply-To: <20211028213408.2883933-1-seanjc@google.com>
References: <20211028213408.2883933-1-seanjc@google.com>
Date:   Fri, 29 Oct 2021 14:56:05 +0200
Message-ID: <87pmrokn16.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Move the vp_bitmap "allocation" that's need to handle mismatched vp_index
> values down into sparse_set_to_vcpu_mask() and drop __always_inline from
> said helper.  The vp_bitmap mess is a detail that's specific to the sparse
> translation and does not need to be exposed to the caller.
>
> The underlying motivation is to fudge around a compilation warning/error
> when CONFIG_KASAN_STACK=y, which is selected (and can't be unselected) by
> CONFIG_KASAN=y when compiling with gcc (clang/LLVM is a stack hog in some
> cases so it's opt-in for clang).  KASAN_STACK adds a redzone around every
> stack variable, which pushes the Hyper-V functions over the default limit
> of 1024.  With CONFIG_KVM_WERROR=y, this breaks the build.  Shuffling which
> function is charged with vp_bitmap gets all functions below the default
> limit.
>
> Regarding the __always_inline, prior to commit f21dd494506a ("KVM: x86:
> hyperv: optimize sparse VP set processing") the helper, then named
> hv_vcpu_in_sparse_set(), was a tiny bit of code that effectively boiled
> down to a handful of bit ops.  The __always_inline was understandable, if
> not justifiable.  Since the aforementioned change, sparse_set_to_vcpu_mask()
> is a chunky 350-450+ bytes of code without KASAN=y, and balloons to 1100+
> with KASAN=y.  In other words, it has no business being forcefully inlined.
>
> Reported-by: Ajay Garg <ajaygargnsit@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>
> Vitaly (and anyone with extensive KVM + Hyper-V knowledge), it would be
> really helpful to get better coverage in kvm-unit-tests.

I can't agree more. This *is* in my backlog but unfortunately I can't
give any forcast on when I'll get to it :-(

>  There's a smoke
> test for this in selftests, but it's not really all that interesting.  It
> took me over an hour and a half just to get a Linux guest to hit the
> relevant flows.  Most of that was due to QEMU 5.1 bugs (doesn't advertise
> HYPERCALL MSR by default)

This should be fixed already, right?

>  and Linux guest stupidity (silently disables
> itself if said MSR isn't available), but it was really annoying to have to
> go digging through QEMU to figure out how to even enable features that are
> extensive/critical enough to warrant their own tests.
>
> /wave to the clang folks for the pattern patch on the changelog ;-)
>
>  arch/x86/kvm/hyperv.c | 55 ++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 27 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 4f15c0165c05..80018cfab5c7 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1710,31 +1710,36 @@ int kvm_hv_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>  		return kvm_hv_get_msr(vcpu, msr, pdata, host);
>  }
>  
> -static __always_inline unsigned long *sparse_set_to_vcpu_mask(
> -	struct kvm *kvm, u64 *sparse_banks, u64 valid_bank_mask,
> -	u64 *vp_bitmap, unsigned long *vcpu_bitmap)
> +static void sparse_set_to_vcpu_mask(struct kvm *kvm, u64 *sparse_banks,
> +				    u64 valid_bank_mask, unsigned long *vcpu_mask)
>  {
>  	struct kvm_hv *hv = to_kvm_hv(kvm);
> +	bool has_mismatch = atomic_read(&hv->num_mismatched_vp_indexes);
> +	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
>  	struct kvm_vcpu *vcpu;
>  	int i, bank, sbank = 0;
> +	u64 *bitmap;
>  
> -	memset(vp_bitmap, 0,
> -	       KVM_HV_MAX_SPARSE_VCPU_SET_BITS * sizeof(*vp_bitmap));
> +	BUILD_BUG_ON(sizeof(vp_bitmap) >
> +		     sizeof(*vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS));
> +
> +	/* If vp_index == vcpu_idx for all vCPUs, fill vcpu_mask directly. */
> +	if (likely(!has_mismatch))
> +		bitmap = (u64 *)vcpu_mask;
> +
> +	memset(bitmap, 0, sizeof(vp_bitmap));

... but in the unlikely case has_mismatch == true 'bitmap' is still
uninitialized here, right? How doesn't it crash?

>  	for_each_set_bit(bank, (unsigned long *)&valid_bank_mask,
>  			 KVM_HV_MAX_SPARSE_VCPU_SET_BITS)
> -		vp_bitmap[bank] = sparse_banks[sbank++];
> +		bitmap[bank] = sparse_banks[sbank++];
>  
> -	if (likely(!atomic_read(&hv->num_mismatched_vp_indexes))) {
> -		/* for all vcpus vp_index == vcpu_idx */
> -		return (unsigned long *)vp_bitmap;
> -	}
> +	if (likely(!has_mismatch))
> +		return;
>  
> -	bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
> +	bitmap_zero(vcpu_mask, KVM_MAX_VCPUS);
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		if (test_bit(kvm_hv_get_vpindex(vcpu), (unsigned long *)vp_bitmap))

'vp_bitmap' also doesn't seem to be assigned to anything, I'm really
confused :-(

Didn't you accidentally mix up 'vp_bitmap' and 'bitmap'?

> -			__set_bit(i, vcpu_bitmap);
> +			__set_bit(i, vcpu_mask);
>  	}
> -	return vcpu_bitmap;
>  }
>  
>  struct kvm_hv_hcall {
> @@ -1756,9 +1761,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_tlb_flush_ex flush_ex;
>  	struct hv_tlb_flush flush;
> -	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
> -	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
> -	unsigned long *vcpu_mask;
> +	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>  	u64 valid_bank_mask;
>  	u64 sparse_banks[64];
>  	int sparse_banks_len;
> @@ -1842,11 +1845,9 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	if (all_cpus) {
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH_GUEST);
>  	} else {
> -		vcpu_mask = sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
> -						    vp_bitmap, vcpu_bitmap);
> +		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
>  
> -		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST,
> -					    vcpu_mask);
> +		kvm_make_vcpus_request_mask(kvm, KVM_REQ_TLB_FLUSH_GUEST, vcpu_mask);

We're not bound by 80-char limit anymore, are we? :-)

>  	}
>  
>  ret_success:
> @@ -1879,9 +1880,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_send_ipi_ex send_ipi_ex;
>  	struct hv_send_ipi send_ipi;
> -	u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
> -	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
> -	unsigned long *vcpu_mask;
> +	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
>  	unsigned long valid_bank_mask;
>  	u64 sparse_banks[64];
>  	int sparse_banks_len;
> @@ -1937,11 +1936,13 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	if ((vector < HV_IPI_LOW_VECTOR) || (vector > HV_IPI_HIGH_VECTOR))
>  		return HV_STATUS_INVALID_HYPERCALL_INPUT;
>  
> -	vcpu_mask = all_cpus ? NULL :
> -		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask,
> -					vp_bitmap, vcpu_bitmap);
> +	if (all_cpus) {
> +		kvm_send_ipi_to_many(kvm, vector, NULL);
> +	} else {
> +		sparse_set_to_vcpu_mask(kvm, sparse_banks, valid_bank_mask, vcpu_mask);
>  
> -	kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
> +		kvm_send_ipi_to_many(kvm, vector, vcpu_mask);
> +	}
>  
>  ret_success:
>  	return HV_STATUS_SUCCESS;

-- 
Vitaly

