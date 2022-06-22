Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75D25547AB
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242604AbiFVJjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 05:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiFVJjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 05:39:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60D553981E
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 02:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655890789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zGC3+hajwdWXYkAwBxTJS1WZ7tKXGTLNEGKHzh0auOk=;
        b=CeJ8UO0WQN/Jkpw5j9qtrkVGyx/lk6ppQuWEIGrVhKcCVULsYOUYyJnC565u3N+9c32dFz
        3vcAOZMVpe6SbcLn+EY+DHcPTYD12AVTQOiMzTQdTrQoid1QYCQOZphJYF6sy6YWdMSKxv
        F0TMGzi6bd71gTtUVD66m5w+78aowHA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-eTwMPTjtN_-oLmGEaJ1DoQ-1; Wed, 22 Jun 2022 05:39:47 -0400
X-MC-Unique: eTwMPTjtN_-oLmGEaJ1DoQ-1
Received: by mail-wm1-f72.google.com with SMTP id be12-20020a05600c1e8c00b0039c506b52a4so453091wmb.1
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 02:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zGC3+hajwdWXYkAwBxTJS1WZ7tKXGTLNEGKHzh0auOk=;
        b=CAHFHq1rbZ2tdpHshvpmw7g381/BJuGr5yYEYwKIlAq5F4tRjU4QGAsdN8JgsBElQU
         eeRH57LNRAyYr/dynqhbgMguGzapF3bt6DWP+7VNVp1P8OQUblVCvzzq4NtPtMSUH6CC
         QAy4PSvPPdz98CVCRftW2H0fmbjoMSkCylECiQGeCU5uAEN0/f81j50oKpMAk9zi9Y/k
         dnpEU+9zL5qGkrqm6htqMp7ldUhL8Uhop5RjZ5rZR/+7nKEp3WvS13D4djUZI2hqUPeQ
         oUIv3e5LNthH2OnVL5glNqlnQoTgJv7UWknbRu7EBFQXvTmswRGp5blyjXyahKU9QjNL
         lj9A==
X-Gm-Message-State: AJIora8jm+nPhkkoWO9c62iojYFweOMC/ghCdkCGrbDABcGtb5znE4Z+
        feLCPeeLtgTZnhDi/+phGXeWAxe44opfb4yhNvHihQYPQSTVfN1coNOpCtTl5JL0o4wWtPEKc0N
        an56GQm6zgrKR
X-Received: by 2002:a5d:6309:0:b0:21b:9455:cf with SMTP id i9-20020a5d6309000000b0021b945500cfmr2430540wru.354.1655890786575;
        Wed, 22 Jun 2022 02:39:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sL4VhXlaGXQpTlLZlOBnHBP0ua+JV6dZROeb3F6ClKWm547YbFM5TeoUidB1jgo2ZaOL5BNw==
X-Received: by 2002:a5d:6309:0:b0:21b:9455:cf with SMTP id i9-20020a5d6309000000b0021b945500cfmr2430501wru.354.1655890786239;
        Wed, 22 Jun 2022 02:39:46 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y6-20020a5d6206000000b0021350f7b22esm20581038wru.109.2022.06.22.02.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 02:39:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
In-Reply-To: <20220622092202.15548-1-pdurrant@amazon.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
Date:   Wed, 22 Jun 2022 11:39:44 +0200
Message-ID: <87wnd9xcin.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paul Durrant <pdurrant@amazon.com> writes:

> The scaling information in sub-leaf 1 should match the values in the
> 'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_info) which
> is shared with the guest. The offset values are not set since a TSC offset
> is already applied.
> The host TSC frequency should also be set in sub-leaf 2.
>
> This patch adds a new kvm_xen_set_cpuid() function that scans for the
> relevant CPUID leaf when the CPUID information is updated by the VMM and
> stashes pointers to the sub-leaves in the kvm_vcpu_xen structure.
> The values are then updated by a call to the, also new,
> kvm_xen_setup_tsc_info() function made at the end of
> kvm_guest_time_update() just before entering the guest.
>
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/cpuid.c            |  2 ++
>  arch/x86/kvm/x86.c              |  1 +
>  arch/x86/kvm/xen.c              | 41 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/xen.h              | 10 ++++++++
>  5 files changed, 56 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1038ccb7056a..f77a4940542f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -638,6 +638,8 @@ struct kvm_vcpu_xen {
>  	struct hrtimer timer;
>  	int poll_evtchn;
>  	struct timer_list poll_timer;
> +	struct kvm_cpuid_entry2 *tsc_info_1;
> +	struct kvm_cpuid_entry2 *tsc_info_2;
>  };
>  
>  struct kvm_vcpu_arch {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d47222ab8e6e..eb6cd88c974a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -25,6 +25,7 @@
>  #include "mmu.h"
>  #include "trace.h"
>  #include "pmu.h"
> +#include "xen.h"
>  
>  /*
>   * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
> @@ -310,6 +311,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
>  
>  	kvm_hv_set_cpuid(vcpu);
> +	kvm_xen_set_cpuid(vcpu);
>  
>  	/* Invoke the vendor callback only after the above state is updated. */
>  	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00e23dc518e0..8b45f9975e45 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3123,6 +3123,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	if (vcpu->xen.vcpu_time_info_cache.active)
>  		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
>  	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
> +	kvm_xen_setup_tsc_info(v);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 610beba35907..a016ff85264d 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -10,6 +10,9 @@
>  #include "xen.h"
>  #include "hyperv.h"
>  #include "lapic.h"
> +#include "cpuid.h"
> +
> +#include <asm/xen/cpuid.h>
>  
>  #include <linux/eventfd.h>
>  #include <linux/kvm_host.h>
> @@ -1855,3 +1858,41 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
>  	if (kvm->arch.xen_hvm_config.msr)
>  		static_branch_slow_dec_deferred(&kvm_xen_enabled);
>  }
> +
> +void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	u32 base = 0;
> +	u32 function;
> +
> +	for_each_possible_hypervisor_cpuid_base(function) {
> +		struct kvm_cpuid_entry2 *entry = kvm_find_cpuid_entry(vcpu, function, 0);
> +
> +		if (entry &&
> +		    entry->ebx == XEN_CPUID_SIGNATURE_EBX &&
> +		    entry->ecx == XEN_CPUID_SIGNATURE_ECX &&
> +		    entry->edx == XEN_CPUID_SIGNATURE_EDX) {
> +			base = function;
> +			break;
> +		}
> +	}
> +	if (!base)
> +		return;
> +
> +	function = base | XEN_CPUID_LEAF(3);
> +	vcpu->arch.xen.tsc_info_1 = kvm_find_cpuid_entry(vcpu, function, 1);
> +	vcpu->arch.xen.tsc_info_2 = kvm_find_cpuid_entry(vcpu, function, 2);
> +}

Imagine the following scenario: CPUID data was supplied with Xen CPUID
leaves first and then got updated with new information which doesn't
have Xen CPUID info (e.g. has Hyper-V signature instead of Xen in the
same 0x40000000 leaf). Won't arch.xen.tsc_info_1/arch.xen.tsc_info_2
pointers become dangling here after we free the old CPUID data ...

> +
> +void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpuid_entry2 *entry = vcpu->arch.xen.tsc_info_1;
> +
> +	if (entry) {
> +		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
> +		entry->edx = vcpu->arch.hv_clock.tsc_shift;

... just to crash everything here?

> +	}
> +
> +	entry = vcpu->arch.xen.tsc_info_2;
> +	if (entry)
> +		entry->eax = vcpu->arch.hw_tsc_khz;
> +}
> diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
> index 532a535a9e99..1afb663318a9 100644
> --- a/arch/x86/kvm/xen.h
> +++ b/arch/x86/kvm/xen.h
> @@ -32,6 +32,8 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
>  int kvm_xen_setup_evtchn(struct kvm *kvm,
>  			 struct kvm_kernel_irq_routing_entry *e,
>  			 const struct kvm_irq_routing_entry *ue);
> +void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu);
> +void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu);
>  
>  static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
>  {
> @@ -135,6 +137,14 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
>  {
>  	return false;
>  }
> +
> +static inline void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +static inline void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu)
> +{
> +}
>  #endif
>  
>  int kvm_xen_hypercall(struct kvm_vcpu *vcpu);

-- 
Vitaly

