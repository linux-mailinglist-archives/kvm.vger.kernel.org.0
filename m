Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA618647850
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLHVzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiLHVy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:54:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A49D881
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mq8oV63M1unZbJY5qyv2v3uiyUc953tHIdO7sV0O7go=;
        b=fP/OkHhr6kuIYH/JhnqppieyO+vjWzqb8iEWEHAIlRK7m7zGWGmDPhnMPTUSFjiGn/GqVj
        1+fu/G069NyFYs4mbZDIGFzsGow5U9tcCEvfdCgJ6vWpYYLfVII3k01LXXngNiE5G+Gy2S
        prrb1Lx5JU3zXtirdkxvtgsPJgG+gsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-LI4v0INVNPW0cThlFCCAFQ-1; Thu, 08 Dec 2022 16:53:59 -0500
X-MC-Unique: LI4v0INVNPW0cThlFCCAFQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C292C803B38;
        Thu,  8 Dec 2022 21:53:58 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A2C5492CA2;
        Thu,  8 Dec 2022 21:53:57 +0000 (UTC)
Message-ID: <d24692562a38998931b1546b6b02c6aac560afa5.camel@redhat.com>
Subject: Re: [PATCH v4 08/32] KVM: SVM: Don't put/load AVIC when setting
 virtual APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:53:56 +0200
In-Reply-To: <20221001005915.2041642-9-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
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
> Rename the helper to reflect that it is also called during "refresh".
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
>  arch/x86/kvm/svm/svm.c  |  2 +-
>  arch/x86/kvm/svm/svm.h  |  2 +-
>  3 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3b2c88b168ba..97ad0661f963 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -747,18 +747,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
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
> @@ -1100,17 +1088,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
>  	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
>  }
>  
> -
> -void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
> +void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu)
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
> @@ -1124,6 +1113,16 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
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
> +	avic_refresh_virtual_apic_mode(vcpu);
>  
>  	if (activated)
>  		avic_vcpu_load(vcpu, vcpu->cpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 58f0077d9357..afae97ea9a06 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4798,7 +4798,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.enable_nmi_window = svm_enable_nmi_window,
>  	.enable_irq_window = svm_enable_irq_window,
>  	.update_cr8_intercept = svm_update_cr8_intercept,
> -	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
> +	.set_virtual_apic_mode = avic_refresh_virtual_apic_mode,
>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
>  	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 6a7686bf6900..7a95f50e80e7 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -646,7 +646,7 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
>  void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  void avic_ring_doorbell(struct kvm_vcpu *vcpu);
>  unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
> -void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
> +void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  
>  
>  /* sev.c */

Makes sense. I missed that during x2avic review. That warning about preemption is a good one.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


