Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CABC4135C0
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 17:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233814AbhIUPD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 11:03:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233811AbhIUPDz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 11:03:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632236546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BT6/P6goCwmRLEI3gDKs1TsOEvArNLdaBojn/+x1GJw=;
        b=FxHQHVqszCFE/EU5HFaVmNPPvtwV2uYpyOO22/0eeuJf+yB6I2Hvi63T1nzwUSjqiHATfW
        vTZX90vwQ5Boi0OtLZOjt1OOiF1LQmLE6YhTbWxOwJ8JFdJPkMy6wHPdET3vBBrSMu774F
        R0HlhWMMDKa9NUAWkjjdXenv1yF7Rm8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-PoQUg-__NgW9uG8UdgfrJQ-1; Tue, 21 Sep 2021 11:02:23 -0400
X-MC-Unique: PoQUg-__NgW9uG8UdgfrJQ-1
Received: by mail-wr1-f69.google.com with SMTP id s13-20020a5d69cd000000b00159d49442cbso9056206wrw.13
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 08:02:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=BT6/P6goCwmRLEI3gDKs1TsOEvArNLdaBojn/+x1GJw=;
        b=M4FwYE0RLhtr23YMx5sj+ExNpNnpsP0fpare/BNIiZ1nIWlfv2UgIMtH5TBFxfc6WN
         11yG/S+ovwCmL1//P0oAR5kWcTKi3OsFFDRr9daJmGX86Hz4whMrOLOHrVEr3HQUsTxP
         PnF76FqjDqbhK8FIa5bRjfNK3QgXekNEVB1/sT5Ix+nK5/TgJAdbzt+ysWnX0nPQk+bI
         fowS8c/H2Xb6o1NdmpkzQBo1qgUIH6Ltm+XD1VATlFSRUzJzdvJKEuxwUV4t/hLCDqeM
         JNmTOw9gGvuTJlrj1peycNO1/9ISbJkj80iAo90TAlkJzwUMfdya7/kGzOlAFfaoo/In
         5cjQ==
X-Gm-Message-State: AOAM5324K0kNiXHKSYIBdMOHZ9gTlAkTbwZkvfa61iZZwRjaZxygVCJv
        feV0rVmwlzY6MnUmHn7egaosIx8B5+eqzandObIjmBw8ChjyW/NkmHjod/tm3jVZVT+t12Lyow4
        6F15ThcCRvWla
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr35206276wru.243.1632236542409;
        Tue, 21 Sep 2021 08:02:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXfOTTf9Hym6xRUCMK7DpPvA39/lnEthLRoZrq9k5RzXh51URGRevvF4LC9p+t+8kyj0LTwg==
X-Received: by 2002:a5d:4e90:: with SMTP id e16mr35206252wru.243.1632236542240;
        Tue, 21 Sep 2021 08:02:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n186sm3029803wme.31.2021.09.21.08.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 08:02:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 07/10] KVM: VMX: Drop explicit zeroing of MSR guest
 values at vCPU creation
In-Reply-To: <20210921000303.400537-8-seanjc@google.com>
References: <20210921000303.400537-1-seanjc@google.com>
 <20210921000303.400537-8-seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:02:20 +0200
Message-ID: <87r1di7z0j.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Don't zero out user return and nested MSRs during vCPU creation, and
> instead rely on vcpu_vmx being zero-allocated.  Explicitly zeroing MSRs
> is not wrong, and is in fact necessary if KVM ever emulates vCPU RESET
> outside of vCPU creation, but zeroing only a subset of MSRs is confusing.
>
> Poking directly into KVM's backing is also undesirable in that it doesn't
> scale and is error prone.  Ideally KVM would have a common RESET path for
> all MSRs, e.g. by expanding kvm_set_msr(), which would obviate the need
> for this out-of-bad code (to support standalone RESET).

Just thinking out loud: we can probably enhance KVM_SET_MSRS making it
possible for userspace VMM to set the default (as not every setting need
to survive RESET). Conveniently enough, 'struct kvm_msr_entry' has 32
bits reserved and we can bite off one for 'default' flag.

>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d44d07d5a02f..8d14066db3ea 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6819,10 +6819,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			goto free_vpid;
>  	}
>  
> -	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
> -		vmx->guest_uret_msrs[i].data = 0;
> +	for (i = 0; i < kvm_nr_uret_msrs; ++i)
>  		vmx->guest_uret_msrs[i].mask = -1ull;
> -	}
>  	if (boot_cpu_has(X86_FEATURE_RTM)) {
>  		/*
>  		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
> @@ -6879,8 +6877,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  	if (nested)
>  		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
> -	else
> -		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
>  
>  	vcpu_setup_sgx_lepubkeyhash(vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

