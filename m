Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6854A63F469
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiLAPoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiLAPoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:44:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624FDB1D3
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669909384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uICPaEENN8EB00poBiDynBWP9unBSRZ6Eo0ZeloiILw=;
        b=ShDSpJFN0QDtH03IzK5wfnlyUH76O3c7dsbxoFK+KF0E2RVlEAR3LFhECLAXd86gw9UQ/X
        3FrWrq7UepVYdRDfFbakv+ciRtEt2VkXedgY1ubBB3Thq6PYJfP/roq+NZqQvA1N2Tkfx1
        mPSxDMX7PJPfke0HISThbxAYOMGvlMc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-eg5iIFi7OG-OHJRgfpbhSQ-1; Thu, 01 Dec 2022 10:43:03 -0500
X-MC-Unique: eg5iIFi7OG-OHJRgfpbhSQ-1
Received: by mail-wr1-f71.google.com with SMTP id k1-20020adfb341000000b0024215e0f486so532168wrd.21
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 07:43:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uICPaEENN8EB00poBiDynBWP9unBSRZ6Eo0ZeloiILw=;
        b=NzLciXUghGuPwGZtoK1OgLaT0GeLVib73bvQytNuH1DjB9R7teA8Pwd2QAz0U8fXsM
         sZJCGG/fWc64XlXjawnU4xriLFJCf1P6npfUq3OxVl8aPMb+q182+Be79mWG/qVdp6Ip
         gJBbus85kNcljWvmTfRBvfgSRmIY8SS8NJifOHEo6KxYREoUA1OjUinNg8V9sxTuK1db
         E9IUXq91OQ4ockdK2EbpoOUyIouxyOaAvgKlWSVxxZaGD2PAACGfJ7vPzpA9+qYq6lw+
         0W7GgUwh9+JzTEzqupBsK67HjJ6vlzqIH41piMo8ijuPlIi78fq3YI2e10THy6IajhAK
         1XWQ==
X-Gm-Message-State: ANoB5pk5awCNm5BT/DFZHLvYgE8M3DLIc7b0hk47PGLHmuv5X9iAjiAZ
        p8PKYGAefwMtqB0y7QnD1uXAVq8sSza1y8XQlG+OR02sdDBdcReqiDVDiPDmQkbpeHmoxeaWMrQ
        gzUJltf7DyUXV
X-Received: by 2002:adf:ecd2:0:b0:236:6fd9:9efa with SMTP id s18-20020adfecd2000000b002366fd99efamr39370657wro.101.1669909382063;
        Thu, 01 Dec 2022 07:43:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4imAxqHpsHzf4lwMnv25YvuYKadYTHsioCJaPqnZlFtnFG20xMn8tkXOhL/ZrHUpQYnEbeIQ==
X-Received: by 2002:adf:ecd2:0:b0:236:6fd9:9efa with SMTP id s18-20020adfecd2000000b002366fd99efamr39370625wro.101.1669909381800;
        Thu, 01 Dec 2022 07:43:01 -0800 (PST)
Received: from ovpn-194-141.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id bg28-20020a05600c3c9c00b003cfa3a12660sm9307122wmb.1.2022.12.01.07.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 07:43:00 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Subject: Re: [PATCH v2 10/50] KVM: VMX: Reset eVMCS controls in VP assist
 page during hardware disabling
In-Reply-To: <20221130230934.1014142-11-seanjc@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-11-seanjc@google.com>
Date:   Thu, 01 Dec 2022 16:42:58 +0100
Message-ID: <87h6yff7ul.fsf@ovpn-194-141.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Reset the eVMCS controls in the per-CPU VP assist page during hardware
> disabling instead of waiting until kvm-intel's module exit.  The controls
> are activated if and only if KVM creates a VM, i.e. don't need to be
> reset if hardware is never enabled.
>
> Doing the reset during hardware disabling will naturally fix a potential
> NULL pointer deref bug once KVM disables CPU hotplug while enabling and
> disabling hardware (which is necessary to fix a variety of bugs).  If the
> kernel is running as the root partition, the VP assist page is unmapped
> during CPU hot unplug, and so KVM's clearing of the eVMCS controls needs
> to occur with CPU hot(un)plug disabled, otherwise KVM could attempt to
> write to a CPU's VP assist page after it's unmapped.
>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++-----------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cea8c07f5229..d85d175dca70 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -551,6 +551,33 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static void hv_reset_evmcs(void)
> +{
> +	struct hv_vp_assist_page *vp_ap;
> +
> +	if (!static_branch_unlikely(&enable_evmcs))
> +		return;
> +
> +	/*
> +	 * KVM should enable eVMCS if and only if all CPUs have a VP assist
> +	 * page, and should reject CPU onlining if eVMCS is enabled the CPU
> +	 * doesn't have a VP assist page allocated.
> +	 */
> +	vp_ap = hv_get_vp_assist_page(smp_processor_id());
> +	if (WARN_ON_ONCE(!vp_ap))
> +		return;
> +

In case my understanding is correct, this may actually get triggered
for Hyper-V root partition: vmx_hardware_disable() gets called from
kvm_dying_cpu() which has its own CPUHP_AP_KVM_STARTING stage. VP page
unmapping happens in hv_cpu_die() which uses generic CPUHP_AP_ONLINE_DYN
(happens first on CPU oflining AFAIR). I believe we need to introduce a
new CPUHP_AP_HYPERV_STARTING stage and put it before
CPUHP_AP_KVM_STARTING so it happens after it upon offlining.

The issue is likely theoretical as Hyper-V root partition is a very
special case, I'm not sure whether KVM is used there and whether CPU
offlining is possible. In any case, WARN_ON_ONCE() is much better than
NULL pointer dereference we have now :-)

> +	/*
> +	 * Reset everything to support using non-enlightened VMCS access later
> +	 * (e.g. when we reload the module with enlightened_vmcs=0)
> +	 */
> +	vp_ap->nested_control.features.directhypercall = 0;
> +	vp_ap->current_nested_vmcs = 0;
> +	vp_ap->enlighten_vmentry = 0;
> +}
> +
> +#else /* IS_ENABLED(CONFIG_HYPERV) */
> +static void hv_reset_evmcs(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  /*
> @@ -2496,6 +2523,8 @@ static void vmx_hardware_disable(void)
>  	if (cpu_vmxoff())
>  		kvm_spurious_fault();
>  
> +	hv_reset_evmcs();
> +
>  	intel_pt_handle_vmx(0);
>  }
>  
> @@ -8462,27 +8491,8 @@ static void vmx_exit(void)
>  	kvm_exit();
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> -	if (static_branch_unlikely(&enable_evmcs)) {
> -		int cpu;
> -		struct hv_vp_assist_page *vp_ap;
> -		/*
> -		 * Reset everything to support using non-enlightened VMCS
> -		 * access later (e.g. when we reload the module with
> -		 * enlightened_vmcs=0)
> -		 */
> -		for_each_online_cpu(cpu) {
> -			vp_ap =	hv_get_vp_assist_page(cpu);
> -
> -			if (!vp_ap)
> -				continue;
> -
> -			vp_ap->nested_control.features.directhypercall = 0;
> -			vp_ap->current_nested_vmcs = 0;
> -			vp_ap->enlighten_vmentry = 0;
> -		}
> -
> +	if (static_branch_unlikely(&enable_evmcs))
>  		static_branch_disable(&enable_evmcs);
> -	}
>  #endif
>  	vmx_cleanup_l1d_flush();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

