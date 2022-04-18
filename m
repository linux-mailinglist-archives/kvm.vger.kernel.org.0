Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9E56505500
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 15:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbiDRNMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 09:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243804AbiDRNK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 09:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEBDF38BDE
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 05:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kvBGtvq2+A80caQWmYJHxDl/MnDcbsZjkU5C1EhGvl0=;
        b=h2mb7C0wAjrNLZO6wUs7x9iUX7xY+/rFHQHQHo4/qHsmtf+DugLUXSuj41LEuzn/JfG3b4
        ArqMh1JDBBEkc8QIL95gA8nMlMePNHH/Tu32aQSYlgRaF+EvzPiy1EIt1ewpJPfL3GcfK/
        4WkSUAa9LculLP6b3q8zfbAZxLUK6Rw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-sxdqhMqSMDeFCnGNL5GFDg-1; Mon, 18 Apr 2022 08:49:30 -0400
X-MC-Unique: sxdqhMqSMDeFCnGNL5GFDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1EC785A5A8;
        Mon, 18 Apr 2022 12:49:29 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CED6B112D400;
        Mon, 18 Apr 2022 12:49:26 +0000 (UTC)
Message-ID: <227adbe6e8d82ad4c5a803c117d4231808a0e451.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Defer APICv updates while L2 is active
 until L1 is active
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gaoning Pan <pgn@zju.edu.cn>,
        Yongkang Jia <kangel@zju.edu.cn>
Date:   Mon, 18 Apr 2022 15:49:25 +0300
In-Reply-To: <20220416034249.2609491-3-seanjc@google.com>
References: <20220416034249.2609491-1-seanjc@google.com>
         <20220416034249.2609491-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-04-16 at 03:42 +0000, Sean Christopherson wrote:
> Defer APICv updates that occur while L2 is active until nested VM-Exit,
> i.e. until L1 regains control.  vmx_refresh_apicv_exec_ctrl() assumes L1
> is active and (a) stomps all over vmcs02 and (b) neglects to ever updated
> vmcs01.  E.g. if vmcs12 doesn't enable the TPR shadow for L2 (and thus no
> APICv controls), L1 performs nested VM-Enter APICv inhibited, and APICv
> becomes unhibited while L2 is active, KVM will set various APICv controls
> in vmcs02 and trigger a failed VM-Entry.  The kicker is that, unless
> running with nested_early_check=1, KVM blames L1 and chaos ensues.
> 
> The obvious elephant in the room is whether or not KVM needs to disallow
> APICv in L2 if it is inhibited in L1.  Luckily, that's largely a moot
> point as the only dynamic inhibit conditions that affect VMX are Hyper-V
> and IRQ blocking.  IRQ blocking is firmly a debug-only feature, and L1
> probably deserves whatever mess it gets by enabling AutoEOI while running
> L2 with APICv enabled.

Let me explain:
 
a vCPU either runs L1 or it "sort of" runs both L1 and L2 in regard to
how it sends/receives interrupts: 

Sending interrupts while nested: 
   While in guest mode, a vCPU can in theory use both L2's and L1's APIC 
   (if L2 has access to L1's APIC mmio/msrs). 

Receiving interrupts while nested: 
 
   While in guest mode, a vCPU can receive interrupts that target either L1 or L2 code it "runs".
   Later request will hopefully cause it to jump to the the interrupt handler without VMexit,
   while the former will cause VMexit, and let L1 run again.
 
   On AVIC interrupt requests can come from either L1 or L2, while on APICv 
   they have to come from L1, because APICv doesn't yet support nested IPI virtualization.
 
 
Another thing to note is that pretty much, APICv/AVIC inhibition is for 
L1 use of APICv/AVIC only.

In fact I won't object to rename the inhibition functions to explicitly state this.
 
When L2 uses APICv/AVIC, we just safely passthrough its usage to the real hardware.

If we were to to need to inhibit it, we would have to emulate APICv/AVIC so that L1 would
still think that it can use it - thankfully there is no need for that.


So how it all works together:
 
Sending interrupts while nested:
 
   - only L2's avic/apicv is accelerated because its settings are in vmcb/vmcs02.
 
   - if L1 allows L2 to access its APIC, then it accessed through regular MMIO/msr 
     interception and should still work.
     (this reminds me to write a unit test for this)
 
 
Receiving interrupts while nested:
 
  - Interrupts that target L2 are received via APICv/AVIC which is active in vmcb/vmcs02
 
    This APICv/AVIC should never be inhibited because it merely works on behalf of L1's hypervisor,
    which should decide if it wants to inhibit it.
 
    In fact even if L1's APICv/AVIC is always inhibited (e.g when L1 uses x2apic on AMD),
    L2 should still be able to use APICv/AVIC just fine - and it does work *very fine* with my nested AVIC code.
 
    Another way to say it, is that the whole APICv/AVIC inhibition mechanism is 
    in fact L1'1 APICv/AVIC inhibition,
    and there is nothing wrong when L1's APICv/AVIC is inhibited while L2 is running:
 
    That just means that vCPUs which don't run L2, will now stop using AVIC/APICv.
    It will also update the private memslot, which also only L1 uses, while L2 will continue
    using its APICv/AVIC as if nothing happened (it doesn't use this private memslot,
    but should itself map the apic mmio in its own EPT/NPT tables).
 
 
 - Interrupts that target L1: here there is a big difference between APICv and AVIC:

   On APICv, despite the fact that vmcs02 uses L2' APICv, we can still receive them
   as normal interrupts, due to the trick that we use different posted interrupt vectors.

   So for receiving, L1's APICv still "sort of works" while L2 is running,
   and with help of the interrupt handler will cause L2 to vmexit to L1 when such
   interrupt is received.
 
   That is why on APICv there is no need to inhibit L1's APICv when entering nested guest,
   because from peer POV, this vCPU's APICv is running just fine.
 

   On AVIC however, there is only one doorbell, and this is why I have to inhibit the AVIC
   while entering the nested guest, although the update it does to vmcb01 is not really needed,

   but what is needed is to inhibit this vCPU peers from sending it interrupts via AVIC
   (this includes clearing is_running bit in physid table, in IOMMU, and also clearing
   per-vcpu avic enabled bit, so that KVM doesn't send IPIs to this vCPU as well).
 
 
 
Having said all that, delaying L1's APICv inhibition to the next nested VM exit should not
cause any issues, as vmcs01 is not active at all while running nested,
and APICv inhibition is all about changing vmcs01 settings.

(That should be revised when IPI virtualization is merged).
 
On AVIC I don't bother with that, as inhibition explicitly updates vmcb01 and 
L1's physid page and should not have any impact on L2.
 
 
So I am not against this patch, but please update the commit message with the fact that it is all right to 
have L1 APICv inhibited/uninhibited while running nested, even though it is not likely
to happen with APICv.
 
Best regards,
	Maxim Levitsky
 


> 
> Lack of dynamic toggling is also why this scenario is all but impossible
> to encounter in KVM's current form.  But a future patch will pend an
> APICv update request _during_ vCPU creation to plug a race where a vCPU
> that's being created doesn't get included in the "all vCPUs request"
> because it's not yet visible to other vCPUs.  If userspaces restores L2
> after VM creation (hello, KVM selftests), the first KVM_RUN will occur
> while L2 is active and thus service the APICv update request made during
> VM creation.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 5 +++++
>  arch/x86/kvm/vmx/vmx.c    | 5 +++++
>  arch/x86/kvm/vmx/vmx.h    | 1 +
>  3 files changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a6688663da4d..f5cb18e00e78 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4640,6 +4640,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  	}
>  
> +	if (vmx->nested.update_vmcs01_apicv_status) {
> +		vmx->nested.update_vmcs01_apicv_status = false;
> +		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> +	}
> +
>  	if ((vm_exit_reason != -1) &&
>  	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
>  		vmx->nested.need_vmcs12_to_shadow_sync = true;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cf8581978bce..4c407a34b11e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4174,6 +4174,11 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	if (is_guest_mode(vcpu)) {
> +		vmx->nested.update_vmcs01_apicv_status = true;
> +		return;
> +	}
> +
>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>  	if (cpu_has_secondary_exec_ctrls()) {
>  		if (kvm_vcpu_apicv_active(vcpu))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9c6bfcd84008..b98c7e96697a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -183,6 +183,7 @@ struct nested_vmx {
>  	bool change_vmcs01_virtual_apic_mode;
>  	bool reload_vmcs01_apic_access_page;
>  	bool update_vmcs01_cpu_dirty_logging;
> +	bool update_vmcs01_apicv_status;
>  
>  	/*
>  	 * Enlightened VMCS has been enabled. It does not mean that L1 has to


