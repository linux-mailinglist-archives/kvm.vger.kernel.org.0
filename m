Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4CE278497
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgIYJ7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:59:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727679AbgIYJ7H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:59:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601027945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIWorudu5DKNHzXnoue5cILqH4iEH+RSPM/BEmZzG2k=;
        b=VIL3PYCTDTbPSKb/YeT214KLGEBy5xpHEuoWnX6B2LFkyYmEcN1rnhrJ7FTlwX4kSqJmbQ
        t/wjjtUwHEMUz0PHInO75Ii1rFgr9kSVGZT33mb5JC07ESjPqDMDT/xfpByJHPuJ0gdelj
        belXy1UPlVhM4tHha9n7SHVPlzKUHw8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-niMVWo8KM5SvYCusK81xKg-1; Fri, 25 Sep 2020 05:59:03 -0400
X-MC-Unique: niMVWo8KM5SvYCusK81xKg-1
Received: by mail-wm1-f69.google.com with SMTP id y18so643344wma.4
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 02:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sIWorudu5DKNHzXnoue5cILqH4iEH+RSPM/BEmZzG2k=;
        b=UBdavluk8U9KN87tObFoI1KviPLu1Sj1+mr+DbTaaAVQuQEIR0UB7EIrOUd/DcqoFT
         a8mbLF3ZaWgGmztpqJBQJBFzJ3MdL0kTkJqskJ6GlXGPg2iv3TkvXRKnmrmUAxJL89GV
         KPQyAQea05VOAsa6CiyiE8KZqRiGaU3j4k3Y6wocK09wW5eA22hQryw37MNX1IAzNHfg
         JSqhJRlQ3dwIk3nGE/dpjmfLxpdw5hL5WL39N979hj2KEIjHtJPGG4CS9nLdUxFY8fJE
         8MuGUDkL5GBHo86ryz+KdRtBZRdICn6k+qPUE88XHyopCiNV+o7STXhTZMZFvVZ66pgB
         K/aA==
X-Gm-Message-State: AOAM531LWUIMz3gV4znoBMxLuPAQzuS6bU2R4/Dy/7AGHPohc5y3NR4x
        Pd2+NlWEKhuTssONdM59P/QcXgifIN2LzoWT07AyR/wgrx84uU1vOytnNknf0cjeBHx3b0MwQSZ
        6zTmrVJYnzYnL
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr3874323wrp.390.1601027942422;
        Fri, 25 Sep 2020 02:59:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVETDUosAe8jX3GP6x/0E34Oq++Rjm2SNpkUgf2wYb9c5WIOgKuqLnY9yCg+YdCgXPUTpIUg==
X-Received: by 2002:adf:ef4f:: with SMTP id c15mr3874297wrp.390.1601027942199;
        Fri, 25 Sep 2020 02:59:02 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id b84sm2618107wmd.0.2020.09.25.02.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 02:59:01 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd()
In-Reply-To: <20200924180429.10016-1-sean.j.christopherson@intel.com>
References: <20200924180429.10016-1-sean.j.christopherson@intel.com>
Date:   Fri, 25 Sep 2020 11:59:00 +0200
Message-ID: <87h7rmch3v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Explicitly check that kvm_x86_ops.tlb_remote_flush() points at Hyper-V's
> implementation for PV flushing instead of assuming that a non-NULL
> implementation means running on Hyper-V.  Wrap the related logic in
> ifdeffery as hv_remote_flush_tlb() is defined iff CONFIG_HYPERV!=n.
>
> Short term, the explicit check makes it more obvious why a non-NULL
> tlb_remote_flush() triggers EPTP shenanigans.  Long term, this will
> allow TDX to define its own implementation of tlb_remote_flush() without
> running afoul of Hyper-V.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 7 +++++--
>  arch/x86/kvm/vmx/vmx.h | 2 ++
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6f9a0c6d5dc5..a56fa9451b84 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3073,14 +3073,15 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  		eptp = construct_eptp(vcpu, pgd, pgd_level);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
> -		if (kvm_x86_ops.tlb_remote_flush) {
> +#if IS_ENABLED(CONFIG_HYPERV)
> +		if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
>  			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  			to_vmx(vcpu)->ept_pointer = eptp;
>  			to_kvm_vmx(kvm)->ept_pointers_match
>  				= EPT_POINTERS_CHECK;
>  			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  		}
> -
> +#endif
>  		if (!enable_unrestricted_guest && !is_paging(vcpu))
>  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
>  		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
> @@ -6956,7 +6957,9 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  static int vmx_vm_init(struct kvm *kvm)
>  {
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
> +#endif
>  
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest = true;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index d7ec66db5eb8..51107b7309bc 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -316,8 +316,10 @@ struct kvm_vmx {
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
>  	enum ept_pointers_status ept_pointers_match;
>  	spinlock_t ept_pointer_lock;
> +#endif

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

In case ept_pointers_match/ept_pointer_lock are useless for TDX we may
want to find better names for them to make it clear this is a Hyper-V
thingy (e.g. something like hv_tlb_ept_match/hv_tlb_ept_lock).

>  };
>  
>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);

-- 
Vitaly

