Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A582617F86
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiKCO3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiKCO32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 10:29:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA771D0
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 07:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667485706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xJXDTOdlX1XyIcsWYcqglWBdRZQ9xmr4YB2PW91lUtk=;
        b=Y8o9aQnZ3G3tLMJAZhZOeEpVNqHwShtj8XyuSqKyvSHEtYaovx5MipVGXOSFwKPYMiPHbR
        OGiMYMs2835Og8eywbo9aF8e/jeJTsYjzGGzqZSUHJo0uulT43/vrmIR0A0AIc92xJmNrJ
        Z7W7qs5oLWx+iOyBPtrtly30VAio/IE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-WQs2UdpsOCGeH5yvewqqtw-1; Thu, 03 Nov 2022 10:28:25 -0400
X-MC-Unique: WQs2UdpsOCGeH5yvewqqtw-1
Received: by mail-ej1-f69.google.com with SMTP id hp16-20020a1709073e1000b007adf5a83df7so1380423ejc.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 07:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xJXDTOdlX1XyIcsWYcqglWBdRZQ9xmr4YB2PW91lUtk=;
        b=a6DnjurYH1y+pCM0rXpqG8qYY5S0nFdzXq+1Jnsu1lEXT9UHqs+SErLRLOXzd2UOnr
         lNoAG2BdgeMGpCcQKu/6roDwVMEAh+DmRedZYfA1dSpZj499N72SwSjf+lMEyqTFbqxc
         Nc8CJXBxFgZk0YZf3jRvZdDKW+pGy44Xw35aBALcpSQEBo4TkWnnNJOS7QmzQQ6OaaBv
         miFYXO8/d0TuOidoC+TeIezlOsvhZFFyihvnEvHpqzFRcXVh9hMrHflgSIy2ZNfpKLb1
         6oJJQpGtAuTTarQdt2t/wXPC+JboFjFn+RBVlPEhwa7cE64wLNCOim9UbvPrHc3av/qb
         ES6Q==
X-Gm-Message-State: ACrzQf0JIVXQzLzPPOMDQ3ycZM82ENywa/DHomj8lTVPwYegqVCYWam5
        VKsWMLWf99nsC58zyz3vK5LS0kqX9lYzoTJN0Rk1vq41rV9sHdDoIOtOmIg5csWzoVZzH//weOA
        yqgklGpKluwMI
X-Received: by 2002:a17:907:6da3:b0:78e:2a5f:5aaf with SMTP id sb35-20020a1709076da300b0078e2a5f5aafmr29209491ejc.554.1667485703929;
        Thu, 03 Nov 2022 07:28:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4/BLSlzeBmBH2wK2ozHzek7JvfdOrTUEgVR1Jkq3btzgsJIv9L2s0vi2zOnPRlcAj1lu9eWg==
X-Received: by 2002:a17:907:6da3:b0:78e:2a5f:5aaf with SMTP id sb35-20020a1709076da300b0078e2a5f5aafmr29209446ejc.554.1667485703617;
        Thu, 03 Nov 2022 07:28:23 -0700 (PDT)
Received: from ovpn-194-252.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r18-20020a1709061bb200b0073d7bef38e3sm558528ejg.45.2022.11.03.07.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 07:28:22 -0700 (PDT)
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
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>,
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
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 10/44] KVM: VMX: Clean up eVMCS enabling if KVM
 initialization fails
In-Reply-To: <20221102231911.3107438-11-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-11-seanjc@google.com>
Date:   Thu, 03 Nov 2022 15:28:21 +0100
Message-ID: <87mt98qfi2.fsf@ovpn-194-252.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> To make it obvious that KVM doesn't have a lurking bug, cleanup eVMCS
> enabling if kvm_init() fails even though the enabling doesn't strictly
> need to be unwound.  eVMCS enabling only toggles values that are fully
> contained in the VMX module, i.e. it's technically ok to leave the values
> as-is since they'll disappear entirely when the module is unloaded, but
> doing proper cleanup is relatively simple, and having a chunk of code
> that isn't unwound is confusing.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 137 +++++++++++++++++++++++------------------
>  1 file changed, 78 insertions(+), 59 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 05a747c9a9ff..b3fd4049de01 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -524,6 +524,8 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
>  static unsigned long host_idt_base;
>  
>  #if IS_ENABLED(CONFIG_HYPERV)
> +static struct kvm_x86_ops vmx_x86_ops __initdata;
> +
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
>  
> @@ -552,6 +554,71 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static __init void hv_setup_evmcs(void)
> +{
> +	int cpu;
> +
> +	if (!enlightened_vmcs)
> +		return;
> +
> +	/*
> +	 * Enlightened VMCS usage should be recommended and the host needs
> +	 * to support eVMCS v1 or above.
> +	 */
> +	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
> +	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
> +	     KVM_EVMCS_VERSION) {
> +
> +		/* Check that we have assist pages on all online CPUs */
> +		for_each_online_cpu(cpu) {
> +			if (!hv_get_vp_assist_page(cpu)) {
> +				enlightened_vmcs = false;
> +				break;
> +			}
> +		}
> +
> +		if (enlightened_vmcs) {
> +			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
> +			static_branch_enable(&enable_evmcs);
> +		}
> +
> +		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> +			vmx_x86_ops.enable_direct_tlbflush
> +				= hv_enable_direct_tlbflush;
> +
> +	} else {
> +		enlightened_vmcs = false;
> +	}
> +}
> +static void hv_cleanup_evmcs(void)
> +{
> +	struct hv_vp_assist_page *vp_ap;
> +	int cpu;
> +
> +	if (!static_branch_unlikely(&enable_evmcs))
> +		return;
> +
> +	/*
> +	 * Reset everything to support using non-enlightened VMCS access later
> +	 * (e.g. when we reload the module with enlightened_vmcs=0)
> +	 */
> +	for_each_online_cpu(cpu) {
> +		vp_ap =	hv_get_vp_assist_page(cpu);
> +
> +		if (!vp_ap)
> +			continue;
> +
> +		vp_ap->nested_control.features.directhypercall = 0;
> +		vp_ap->current_nested_vmcs = 0;
> +		vp_ap->enlighten_vmentry = 0;
> +	}

Unrelated to your patch but while looking at this code I got curious
about why don't we need a protection against CPU offlining here. Turns
out that even when we offline a CPU, its VP assist page remains
allocated (see hv_cpu_die()), we just write '0' to the MSR and thus
accessing the page is safe. The consequent hv_cpu_init(), however, does
not restore VP assist page when it's already allocated:

# rdmsr -p 24 0x40000073
10212f001
# echo 0 > /sys/devices/system/cpu/cpu24/online 
# echo 1 > /sys/devices/system/cpu/cpu24/online 
# rdmsr -p 24 0x40000073
0

The culprit is commit e5d9b714fe402 ("x86/hyperv: fix root partition
faults when writing to VP assist page MSR"). A patch is inbound.

'hv_root_partition' case is different though. We do memunmap() and reset
VP assist page to zero so it is theoretically possible we're going to
clash. Unless I'm missing some obvious reason why module unload can't
coincide with CPU offlining, we may be better off surrounding this with
cpus_read_lock()/cpus_read_unlock(). 

> +
> +	static_branch_disable(&enable_evmcs);
> +}
> +
> +#else /* IS_ENABLED(CONFIG_HYPERV) */
> +static void hv_setup_evmcs(void) {}
> +static void hv_cleanup_evmcs(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  /*
> @@ -8435,29 +8502,8 @@ static void vmx_exit(void)
>  
>  	kvm_exit();
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
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
> +	hv_cleanup_evmcs();
>  
> -			if (!vp_ap)
> -				continue;
> -
> -			vp_ap->nested_control.features.directhypercall = 0;
> -			vp_ap->current_nested_vmcs = 0;
> -			vp_ap->enlighten_vmentry = 0;
> -		}
> -
> -		static_branch_disable(&enable_evmcs);
> -	}
> -#endif
>  	vmx_cleanup_l1d_flush();
>  
>  	allow_smaller_maxphyaddr = false;
> @@ -8468,43 +8514,12 @@ static int __init vmx_init(void)
>  {
>  	int r, cpu;
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	/*
> -	 * Enlightened VMCS usage should be recommended and the host needs
> -	 * to support eVMCS v1 or above. We can also disable eVMCS support
> -	 * with module parameter.
> -	 */
> -	if (enlightened_vmcs &&
> -	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
> -	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
> -	    KVM_EVMCS_VERSION) {
> -
> -		/* Check that we have assist pages on all online CPUs */
> -		for_each_online_cpu(cpu) {
> -			if (!hv_get_vp_assist_page(cpu)) {
> -				enlightened_vmcs = false;
> -				break;
> -			}
> -		}
> -
> -		if (enlightened_vmcs) {
> -			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
> -			static_branch_enable(&enable_evmcs);
> -		}
> -
> -		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
> -			vmx_x86_ops.enable_direct_tlbflush
> -				= hv_enable_direct_tlbflush;
> -
> -	} else {
> -		enlightened_vmcs = false;
> -	}
> -#endif
> +	hv_setup_evmcs();
>  
>  	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
> -		return r;
> +		goto err_kvm_init;
>  
>  	/*
>  	 * Must be called after kvm_init() so enable_ept is properly set
> @@ -8514,10 +8529,8 @@ static int __init vmx_init(void)
>  	 * mitigation mode.
>  	 */
>  	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> -	if (r) {
> -		vmx_exit();
> -		return r;
> -	}
> +	if (r)
> +		goto err_l1d_flush;
>  
>  	vmx_setup_fb_clear_ctrl();
>  
> @@ -8542,5 +8555,11 @@ static int __init vmx_init(void)
>  		allow_smaller_maxphyaddr = true;
>  
>  	return 0;
> +
> +err_l1d_flush:
> +	vmx_exit();
> +err_kvm_init:
> +	hv_cleanup_evmcs();
> +	return r;
>  }
>  module_init(vmx_init);

-- 
Vitaly

