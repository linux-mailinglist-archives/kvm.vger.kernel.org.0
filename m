Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C4A447E35
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 11:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbhKHKrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 05:47:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236375AbhKHKru (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 05:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636368306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VTSmHbqqSQvifdLdpVQlqsft6HJ/KGW9ivh0sBkTcnM=;
        b=gUB2PtSyNkA5iSnzc49zkQkCUDq3TTWs2dPBP1drAXdWJtHtElvVRvQOGUHn563Ooj8oKP
        S3Kf0DIpNEMpJTqYRu8siqp1rAYRJt1foziLdLI1pqlf2e3o+9oE+O/AhMrLYKS9lgBGvj
        S6lKD4Ifb6YNjytjWGurdrQW9bGBfR0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-nSxNgE_EOLyFiC35-UZOFA-1; Mon, 08 Nov 2021 05:45:05 -0500
X-MC-Unique: nSxNgE_EOLyFiC35-UZOFA-1
Received: by mail-wm1-f71.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso9968985wms.4
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 02:45:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VTSmHbqqSQvifdLdpVQlqsft6HJ/KGW9ivh0sBkTcnM=;
        b=XEP71ilI1k3WHlyR1SBmfqJss4OLvxz5WzcuMSggR7TDMY8hCPHgq4DZ2+xeRUvUWb
         y9LCVHMPdMjzaIlDdtYF7qIQgacONYpqFVfHbO/EbWltq3jr1QE15X56LWGH8wW4S3tg
         944cR8Nv+of8kgn6iF2pu0Lh108cIdWGmiRXFntCu9gdJJIWsdR0Vm/74m7U61nmILAG
         9u3VreFR4cntMSjpqUWZ6bYYJGScvQ3eIGOICEuNWixFPhpTF01x6HWKbtqOi4cVDU0B
         5qjIU9Or56ZFzjK0pcRNUpbxu2D0fzSFw7yjZQO1+RuiBxKlEoVCYWbneEbbBXxxHgqv
         1aIQ==
X-Gm-Message-State: AOAM532hnHe7VKze9Mn5+k3+mxm1ptaWerNMkJM1G7q2Jm9f8YroNKBZ
        +DvzLaqlvsM1F6pxeMsqHfjHWtkIe4rcmhOp80fksebKViW2s4vU5p7VXt2Crdiy/JTWuhv8p/e
        JwvDNdSoGFxFv
X-Received: by 2002:a1c:f219:: with SMTP id s25mr52439141wmc.31.1636368304027;
        Mon, 08 Nov 2021 02:45:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy+OjBeFQYyOHk42k/QpgIEMo3TEv/Zo2iGPgSiIpGWDzDok3lX/dRPrqbc8dRXx64Y8RIF8g==
X-Received: by 2002:a1c:f219:: with SMTP id s25mr52439118wmc.31.1636368303827;
        Mon, 08 Nov 2021 02:45:03 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h16sm18256650wrm.27.2021.11.08.02.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 02:45:03 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Kele Huang <huangkele@bytedance.com>, pbonzini@redhat.com
Cc:     chaiwen.cc@bytedance.com, xieyongji@bytedance.com,
        dengliang.1214@bytedance.com, pizhenwei@bytedance.com,
        wanpengli@tencent.com, seanjc@google.com, huangkele@bytedance.com,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] KVM: x86: SVM: don't expose PV_SEND_IPI feature with AVIC
In-Reply-To: <20211108095931.618865-1-huangkele@bytedance.com>
References: <20211108095931.618865-1-huangkele@bytedance.com>
Date:   Mon, 08 Nov 2021 11:45:02 +0100
Message-ID: <87ilx3j58x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kele Huang <huangkele@bytedance.com> writes:

> Currently, AVIC is disabled if x2apic feature is exposed to guest
> or in-kernel PIT is in re-injection mode.
>
> We can enable AVIC with options:
>
>   Kmod args:
>   modprobe kvm_amd avic=1 nested=0 npt=1
>   QEMU args:
>   ... -cpu host,-x2apic -global kvm-pit.lost_tick_policy=discard ...
>
> When LAPIC works in xapic mode, both AVIC and PV_SEND_IPI feature
> can accelerate IPI operations for guest. However, the relationship
> between AVIC and PV_SEND_IPI feature is not sorted out.
>
> In logical, AVIC accelerates most of frequently IPI operations
> without VMM intervention, while the re-hooking of apic->send_IPI_xxx
> from PV_SEND_IPI feature masks out it. People can get confused
> if AVIC is enabled while getting lots of hypercall kvm_exits
> from IPI.
>
> In performance, benchmark tool
> https://lore.kernel.org/kvm/20171219085010.4081-1-ynorov@caviumnetworks.com/
> shows below results:
>
>   Test env:
>   CPU: AMD EPYC 7742 64-Core Processor
>   2 vCPUs pinned 1:1
>   idle=poll
>
>   Test result (average ns per IPI of lots of running):
>   PV_SEND_IPI 	: 1860
>   AVIC 		: 1390
>
> Besides, disscussions in https://lkml.org/lkml/2021/10/20/423
> do have some solid performance test results to this.
>
> This patch fixes this by masking out PV_SEND_IPI feature when
> AVIC is enabled in setting up of guest vCPUs' CPUID.
>
> Signed-off-by: Kele Huang <huangkele@bytedance.com>
> ---
>  arch/x86/kvm/cpuid.c   |  4 ++--
>  arch/x86/kvm/svm/svm.c | 13 +++++++++++++
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2d70edb0f323..cc22975e2ac5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -194,8 +194,6 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		best->ecx |= XFEATURE_MASK_FPSSE;
>  	}
>  
> -	kvm_update_pv_runtime(vcpu);
> -
>  	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>  
> @@ -208,6 +206,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	/* Invoke the vendor callback only after the above state is updated. */
>  	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
>  
> +	kvm_update_pv_runtime(vcpu);
> +
>  	/*
>  	 * Except for the MMU, which needs to do its thing any vendor specific
>  	 * adjustments to the reserved GPA bits.
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b36ca4e476c2..b13bcfb2617c 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4114,6 +4114,19 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
>  			kvm_request_apicv_update(vcpu->kvm, false,
>  						 APICV_INHIBIT_REASON_NESTED);
> +
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) &&
> +				!(nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))) {
> +			/*
> +			 * PV_SEND_IPI feature masks out AVIC acceleration to IPI.
> +			 * So, we do not expose PV_SEND_IPI feature to guest when
> +			 * AVIC is enabled.
> +			 */
> +			best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> +			if (best && enable_apicv &&
> +					(best->eax & (1 << KVM_FEATURE_PV_SEND_IPI)))
> +				best->eax &= ~(1 << KVM_FEATURE_PV_SEND_IPI);
> +		}

Personally, I'd prefer this to be done in userspace (e.g. QEMU) as with
this patch it becomes very un-obvious why in certain cases some feature
bits are missing. This also breaks migration from KVM pre-patch to KVM
post-patch with e.g. KVM_CAP_ENFORCE_PV_FEATURE_CPUID: the feature will
just disappear from underneath the guest.

What we don't have in KVM is something like KVM_GET_RECOMMENDED_CPUID
at least for KVM PV/Hyper-V features. We could've made it easier for
userspace to make 'default' decisions.

>  	}
>  	init_vmcb_after_set_cpuid(vcpu);
>  }

-- 
Vitaly

