Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E405554DB3
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 16:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358066AbiFVOo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 10:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359015AbiFVOoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 10:44:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4A2321
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:44:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id n12so9373153pfq.0
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 07:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mrZzVT+DaE4dzWmgVMu4jK9g1YT74nIx3X+44/NAXQg=;
        b=IC6NzNNl5plJ+Mah/Ys88FlUV0HKR4UEDn+8EWcpGwszqNs2BCiMWrbslIcRr3Ye9p
         bskeqLhIOV4fRI5pqFF/KtQ62BimoINWtFRayWhif8S+17Oq+91t5AROfQvGt0NMd9qj
         SDt96e1VcQw00j/SpEZ9GxD9rag0iJrtw4BHrraKeK0UFbyc3XkhqcA37Khuw9scLhj1
         J9h4Cbe+wQwktNBrLvovwyOYtB9uAtQwonLec5SuXU4hB4qdtTaFGFAiK6ESJVWnTjeh
         XHt8ukQkvuRO5Lj46bkGHDdhqgG1GPVH9aAwbQPHgfeUcxdjQFdRVehf5er9aSQydhje
         OIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mrZzVT+DaE4dzWmgVMu4jK9g1YT74nIx3X+44/NAXQg=;
        b=Wi+v83ZqWRx4RA3pvqsW2svN04q+eZdvqW1NGSho0d9Cfw77XxL7r/5taQ3zRYNB97
         Es2SfD7qs2SE9U6J619aOrPF1y8AHDm7PYT0TacTNQgSusYVLfhI246xXrkbICsAEdmE
         zIq65JQQNWCxjcC5+wow7Z5iu2V4+N1vgYssXKOQ0qV9gdV0yqzXmFaR6LrQiI0lVug9
         lekHL1PvbEzjBeF6JqcovfGEkR+a/gdIHt1eEdYwruxi/ACI568szgPfP+ZAdPvjGE2k
         QkJYbyK5ndOUX496jQUSaf9C8889v/lzJOMh5Strb/rYtA3gprHIX8TjYFANP+xGVtYs
         XT5Q==
X-Gm-Message-State: AJIora80xZb1Y17UGa2F3DGUZDVG2krNzAyIwmUC6HzFdR5DqM1OpHyo
        /URG8/vD2DTGiF7OXYZjyzf4Bg==
X-Google-Smtp-Source: AGRyM1vP49GIW1v9Yn+WDk/Pg//1m7fLQ9YSwDH2V6tqFEOanSJNzIWSKVVs6GHwZYQclEIqNb2HPg==
X-Received: by 2002:a63:555d:0:b0:3fd:5d54:2708 with SMTP id f29-20020a63555d000000b003fd5d542708mr3176104pgm.92.1655909050732;
        Wed, 22 Jun 2022 07:44:10 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id ik15-20020a170902ab0f00b0015e8d4eb2d8sm12852644plb.290.2022.06.22.07.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 07:44:09 -0700 (PDT)
Date:   Wed, 22 Jun 2022 14:44:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info)
 sub-leaves, if present
Message-ID: <YrMqtHzNSean+qkh@google.com>
References: <20220622092202.15548-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622092202.15548-1-pdurrant@amazon.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 22, 2022, Paul Durrant wrote:
> The scaling information in sub-leaf 1 should match the values in the
> 'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_info) which
> is shared with the guest. The offset values are not set since a TSC offset
> is already applied.
> The host TSC frequency should also be set in sub-leaf 2.

Explain why this is KVM's problem, i.e. why userspace is unable to set the correct
values.

> This patch adds a new kvm_xen_set_cpuid() function that scans for the

Please avoid "This patch".

> relevant CPUID leaf when the CPUID information is updated by the VMM and
> stashes pointers to the sub-leaves in the kvm_vcpu_xen structure.
> The values are then updated by a call to the, also new,
> kvm_xen_setup_tsc_info() function made at the end of
> kvm_guest_time_update() just before entering the guest.

This is not a helpful paragraph, it provides zero information that isn't obvious
from the code.

The changelog should read something like:

  Update Xen CPUID leaves that expose TSC frequency and scaling information
  to the guest <blah blah blah>.  Cache the leaves <blah blah blah>.

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

This can be called inside this if statement, no?

	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {

	}

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

This is a very, very misleading name.  It does not "set" anything.  Given that
this patch adds "set" and "setup", I expected the "set" to you know, set the CPUID
leaves and the "setup" to prepar for that, not the other way around.

If the leaves really do need to be cached, kvm_xen_after_set_cpuid() is probably
the least awful name.

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

Is it really necessary to cache the leave?  Guest CPUID isn't optimized, but it's
not _that_ slow, and unless I'm missing something updating the TSC frequency and
scaling info should be uncommon, i.e. not performance critical.
