Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623695A7A27
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiHaJZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiHaJZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371ED20BFB
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661937906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ssoc/+ImbqEK1XQddIJmGn8uecfdSMepzEcYgwttR+8=;
        b=Ma8bVx3J5qsYjWlV+vtPD9zOjciY1DT4BSydvz7njNWxPwZSVz48cw3amc5T01+1RuRVJq
        3tUqLKYYeR4Vtnri969d8JmDPRyMmc2DcPjGCS+OXW/T2Hp0iB/NhWXUKQrE/h0hetz/Oe
        T37yPiJ9l+bw5FaTsjz/WlQh5lVamIk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-6qdXFAAAO4WpO4_KyGXPVw-1; Wed, 31 Aug 2022 05:25:03 -0400
X-MC-Unique: 6qdXFAAAO4WpO4_KyGXPVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96D75185A7B2;
        Wed, 31 Aug 2022 09:25:02 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EEC432026D4C;
        Wed, 31 Aug 2022 09:25:00 +0000 (UTC)
Message-ID: <d3a9ab2033b8dedbb0c7cb683e724ee4210bb703.camel@redhat.com>
Subject: Re: [PATCH 02/19] KVM: SVM: Don't put/load AVIC when setting
 virtual APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 12:24:59 +0300
In-Reply-To: <20220831003506.4117148-3-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-3-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Move the VMCB updates from avic_refresh_apicv_exec_ctrl() into
> avic_set_virtual_apic_mode() and invert the dependency being said
> functions to avoid calling avic_vcpu_{load,put}() and
> avic_set_pi_irte_mode() when "only" setting the virtual APIC mode.
> 
> avic_set_virtual_apic_mode() is invoked from common x86 with preemption
> enabled, which makes avic_vcpu_{load,put}() unhappy.  Luckily, calling
> those and updating IRTE stuff is unnecessary as the only reason
> avic_set_virtual_apic_mode() is called is to handle transitions between
> xAPIC and x2APIC that don't also toggle APICv activation.  And if
> activation doesn't change, there's no need to fiddle with the physical
> APIC ID table or update IRTE.
> 
> The "full" refresh is guaranteed to be called if activation changes in
> this case as the only call to the "set" path is:
> 
> 	kvm_vcpu_update_apicv(vcpu);
> 	static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
> 
> and kvm_vcpu_update_apicv() invokes the refresh if activation changes:
> 
> 	if (apic->apicv_active == activate)
> 		goto out;
> 
> 	apic->apicv_active = activate;
> 	kvm_apic_update_apicv(vcpu);
> 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
> 
>   WARNING: CPU: 183 PID: 49186 at arch/x86/kvm/svm/avic.c:1081 avic_vcpu_put+0xde/0xf0 [kvm_amd]
>   CPU: 183 PID: 49186 Comm: stable Tainted: G           O       6.0.0-smp--fcddbca45f0a-sink #34
>   Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 10.48.0 01/27/2022
>   RIP: 0010:avic_vcpu_put+0xde/0xf0 [kvm_amd]
>    avic_refresh_apicv_exec_ctrl+0x142/0x1c0 [kvm_amd]
>    avic_set_virtual_apic_mode+0x5a/0x70 [kvm_amd]
>    kvm_lapic_set_base+0x149/0x1a0 [kvm]
>    kvm_set_apic_base+0x8f/0xd0 [kvm]
>    kvm_set_msr_common+0xa3a/0xdc0 [kvm]
>    svm_set_msr+0x364/0x6b0 [kvm_amd]
>    __kvm_set_msr+0xb8/0x1c0 [kvm]
>    kvm_emulate_wrmsr+0x58/0x1d0 [kvm]
>    msr_interception+0x1c/0x30 [kvm_amd]
>    svm_invoke_exit_handler+0x31/0x100 [kvm_amd]
>    svm_handle_exit+0xfc/0x160 [kvm_amd]
>    vcpu_enter_guest+0x21bb/0x23e0 [kvm]
>    vcpu_run+0x92/0x450 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x43e/0x6e0 [kvm]
>    kvm_vcpu_ioctl+0x559/0x620 [kvm]
> 
> Fixes: 05c4fe8c1bd9 ("KVM: SVM: Refresh AVIC configuration when changing APIC mode")
> Cc: stable@vger.kernel.org
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b1ade555e8d0..f3a74c8284cb 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -741,18 +741,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  	avic_handle_ldr_update(vcpu);
>  }
>  
> -void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> -{
> -	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
> -		return;
> -
> -	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
> -		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
> -		return;
> -	}
> -	avic_refresh_apicv_exec_ctrl(vcpu);
> -}
> -
>  static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>  {
>  	int ret = 0;
> @@ -1094,17 +1082,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>  }
>  
> -
> -void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> -	bool activated = kvm_vcpu_apicv_active(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || avic_mode == AVIC_MODE_NONE)
> +		return;
>  
>  	if (!enable_apicv)
>  		return;
>  
> -	if (activated) {
> +	if (kvm_vcpu_apicv_active(vcpu)) {
>  		/**
>  		 * During AVIC temporary deactivation, guest could update
>  		 * APIC ID, DFR and LDR registers, which would not be trapped
> @@ -1118,6 +1107,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  		avic_deactivate_vmcb(svm);
>  	}
>  	vmcb_mark_dirty(vmcb, VMCB_AVIC);
> +}
> +
> +void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +{
> +	bool activated = kvm_vcpu_apicv_active(vcpu);
> +
> +	if (!enable_apicv)
> +		return;
> +
> +	avic_set_virtual_apic_mode(vcpu);

This call is misleading - this will usually be called
when avic mode didn't change - I think we need a better name for
avic_set_virtual_apic_mode.

Other than that this makes sense.

Best regards,
	Maxim Levitsky

>  
>  	if (activated)
>  		avic_vcpu_load(vcpu, vcpu->cpu);


