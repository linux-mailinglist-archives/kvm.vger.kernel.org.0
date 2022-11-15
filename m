Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55988629454
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 10:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237647AbiKOJba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 04:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiKOJbV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 04:31:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF7F001
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 01:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668504620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PI4QkJgg5xRejZYnaDkrohoS+PcA0MTFv2A75peo2zg=;
        b=JkU0WQcmtoZTK94+GGlj6Z+rGcg0ySjV9BzywnJ6cXqZ0cetxDn08u3ca5TjnZVvoAD1nF
        7g/RwCmMCzotuwVvZ73w69wyghXSrilVXQQs64Gv32gkj69cnHEjjs5TIOjDhhrWh6ycy4
        wwnIKxyzyK0hTb+eZyF/3gG0OItPCPo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-r68Q1EGYNyWuAw3BcReuFQ-1; Tue, 15 Nov 2022 04:30:18 -0500
X-MC-Unique: r68Q1EGYNyWuAw3BcReuFQ-1
Received: by mail-ej1-f70.google.com with SMTP id nc4-20020a1709071c0400b0078a5ceb571bso6892805ejc.4
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 01:30:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PI4QkJgg5xRejZYnaDkrohoS+PcA0MTFv2A75peo2zg=;
        b=2w8BA7CUJPyAVWXXPLkZRTepzuSCP3dJ3g8HIs+rpVWAYuph+Lu7ovxQ3EJXIsjBZR
         HftMaEJp5hRdhLLclMrkiC0PpaN0xxbLSdmtj+ieCuY/TRTNqzyfycqUsBn68MUQeX2V
         xmZRjEELZOgKj18IFWkh5f5ZFI/Wg3MFSP1X7eK7OdATbwekvG7ycyHks1YS1/Z8VzPj
         gjYlu+Uo4HzAzWzU3SzD6f+GeAt3dUOcY7rNK3sWFIFTi+4gfyDvLbkQh+t7ByVY90nU
         2EiOtagax4jtRdCD/xtp1xuEEjK8VqqwvAphmO6vak/sWcPrxLA1RXm762rg/fhMNLf3
         VTvQ==
X-Gm-Message-State: ANoB5pkLPPh9BRthwQZ+xP2NjA0RTYQ9CxKzbPBEWiCDjM1D6VHvWf5R
        fgf9W8EMjjIV8QeTG+CihIFZ7RIJP8b7if2SnUIwRNWB+EJUT4uw97RW47c+uOea9SnpDWMwPm1
        7e66GISUBQJ5C
X-Received: by 2002:a50:fe13:0:b0:461:565e:8779 with SMTP id f19-20020a50fe13000000b00461565e8779mr14489174edt.387.1668504617480;
        Tue, 15 Nov 2022 01:30:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Zsa4CnM7XTxV75wUJGjjLzRgPV7NQ4412B1eIJSCcezAuycjNE+mpvlda5nQMKDxwK/vVkA==
X-Received: by 2002:a50:fe13:0:b0:461:565e:8779 with SMTP id f19-20020a50fe13000000b00461565e8779mr14489153edt.387.1668504617196;
        Tue, 15 Nov 2022 01:30:17 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ew13-20020a056402538d00b004642b35f89esm5950875edb.9.2022.11.15.01.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 01:30:16 -0800 (PST)
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
In-Reply-To: <Y22nrQ7aziK0NMOE@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-11-seanjc@google.com>
 <87mt98qfi2.fsf@ovpn-194-252.brq.redhat.com> <Y22nrQ7aziK0NMOE@google.com>
Date:   Tue, 15 Nov 2022 10:30:14 +0100
Message-ID: <87sfikmuop.fsf@redhat.com>
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

> On Thu, Nov 03, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> > +	/*
>> > +	 * Reset everything to support using non-enlightened VMCS access later
>> > +	 * (e.g. when we reload the module with enlightened_vmcs=0)
>> > +	 */
>> > +	for_each_online_cpu(cpu) {
>> > +		vp_ap =	hv_get_vp_assist_page(cpu);
>> > +
>> > +		if (!vp_ap)
>> > +			continue;
>> > +
>> > +		vp_ap->nested_control.features.directhypercall = 0;
>> > +		vp_ap->current_nested_vmcs = 0;
>> > +		vp_ap->enlighten_vmentry = 0;
>> > +	}
>> 
>> Unrelated to your patch but while looking at this code I got curious
>> about why don't we need a protection against CPU offlining here. Turns
>> out that even when we offline a CPU, its VP assist page remains
>> allocated (see hv_cpu_die()), we just write '0' to the MSR and thus
>
> Heh, "die".  Hyper-V is quite dramatic.
>
>> accessing the page is safe. The consequent hv_cpu_init(), however, does
>> not restore VP assist page when it's already allocated:
>> 
>> # rdmsr -p 24 0x40000073
>> 10212f001
>> # echo 0 > /sys/devices/system/cpu/cpu24/online 
>> # echo 1 > /sys/devices/system/cpu/cpu24/online 
>> # rdmsr -p 24 0x40000073
>> 0
>> 
>> The culprit is commit e5d9b714fe402 ("x86/hyperv: fix root partition
>> faults when writing to VP assist page MSR"). A patch is inbound.
>> 
>> 'hv_root_partition' case is different though. We do memunmap() and reset
>> VP assist page to zero so it is theoretically possible we're going to
>> clash. Unless I'm missing some obvious reason why module unload can't
>> coincide with CPU offlining, we may be better off surrounding this with
>> cpus_read_lock()/cpus_read_unlock(). 
>
> I finally see what you're concerned about.  If a CPU goes offline and its assist
> page is unmapped, zeroing out the nested/eVMCS stuff will fault.
>
> I think the real problem is that the purging of the eVMCS is in the wrong place.
> Move the clearing to vmx_hardware_disable() and then the CPU hotplug bug goes
> away once KVM disables hotplug during hardware enabling/disable later in the series.
> There's no need to wait until module exit, e.g. it's not like it costs much to
> clear a few variables, and IIUC the state is used only when KVM is actively using
> VMX/eVMCS.
>
> However, I believe there's a second bug.  KVM's CPU online hook is called before
> Hyper-V's online hook (CPUHP_AP_ONLINE_DYN).  Before this series, which moves KVM's
> hook from STARTING to ONLINE, KVM's hook is waaaay before Hyper-V's.  That means
> that hv_cpu_init()'s allocation of the VP assist page will come _after_ KVM's
> check in vmx_hardware_enable()
>
> 	/*
> 	 * This can happen if we hot-added a CPU but failed to allocate
> 	 * VP assist page for it.
> 	 */
> 	if (static_branch_unlikely(&enable_evmcs) &&
> 	    !hv_get_vp_assist_page(cpu))
> 		return -EFAULT;
>
> I.e. CPU hotplug will never work if KVM is running VMs as a Hyper-V guest.  I bet
> you can repro by doing a SUSPEND+RESUME.
>
> Can you try to see if that's actually a bug?  If so, the only sane fix seems to
> be to add a dedicated ONLINE action for Hyper-V.  

It seems we can't get away without a dedicated stage for Hyper-V anyway,
e.g. see our discussion with Michael:

https://lore.kernel.org/linux-hyperv/878rkqr7ku.fsf@ovpn-192-136.brq.redhat.com/

All these issues are more or less "theoretical" as there's no real CPU
hotplug on Hyper-V/Azure. Yes, it is possible to trigger problems by
doing CPU offline/online but I don't see how this may come handy outside
of testing envs.

> Per patch
>
>   KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
>
> from this series, CPUHP_AP_KVM_ONLINE needs to be before CPUHP_AP_SCHED_WAIT_EMPTY
> to ensure there are no tasks, i.e. no vCPUs, running on the to-be-unplugged CPU.
>
> Back to the original bug, proposed fix is below.  The other advantage of moving
> the reset to hardware disabling is that the "cleanup" is just disabling the static
> key, and at that point can simply be deleted as there's no need to disable the
> static key when kvm-intel is unloaded since kvm-intel owns the key.  I.e. this
> patch (that we're replying to) would get replaced with a patch to delete the
> disabling of the static key.
>

From a quick glance looks good to me, I'll try to find some time to work
on this issue. I will likely end up proposing a dedicated CPU hotplug
stage for Hyper-V (which needs to happen before KVM's
CPUHP_AP_KVM_ONLINE on CPU hotplug and after on unplug) anyway.

Thanks for looking into this!

> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 10 Nov 2022 17:28:08 -0800
> Subject: [PATCH] KVM: VMX: Reset eVMCS controls in VP assist page during
>  hardware disabling
>
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
> index aca88524fd1e..ae13aa3e8a1d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -552,6 +552,33 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
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
> @@ -2497,6 +2524,8 @@ static void vmx_hardware_disable(void)
>  	if (cpu_vmxoff())
>  		kvm_spurious_fault();
>  
> +	hv_reset_evmcs();
> +
>  	intel_pt_handle_vmx(0);
>  }
>  
> @@ -8463,27 +8492,8 @@ static void vmx_exit(void)
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
>  
>
> base-commit: 5f47ba6894477dfbdc5416467a25fb7acb47d404

-- 
Vitaly

