Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36C4506D77
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbiDSNcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 09:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243854AbiDSNcM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 09:32:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A964222B0
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 06:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650374968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vapY5TIUoWDafiGsFUCebHPkFP3RpOV4GrGup1HHVXc=;
        b=B3mW8QYmbGZVqYPxATx700pzUm4BhMyXmbCbBcpAYIZ/clN6atWp4AZXWsjLjV4Das/UcV
        Ikr7uNWteBz5hut1N1c2+tH/VSqotxghCxarTYOjQglvMW0s23rtpsqznhNRHljgcu5p+Y
        mrjka7DrubIHwBg3aryH7mmJLS621jE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-eS6HrYYROeusVr9zU9VQrg-1; Tue, 19 Apr 2022 09:29:23 -0400
X-MC-Unique: eS6HrYYROeusVr9zU9VQrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C430D185A7B2;
        Tue, 19 Apr 2022 13:29:22 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7BFA2166B4F;
        Tue, 19 Apr 2022 13:29:19 +0000 (UTC)
Message-ID: <3fd0aabb6288a5703760da854fd6b09a485a2d69.camel@redhat.com>
Subject: Re: [PATCH v2 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is
 present
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 19 Apr 2022 16:29:18 +0300
In-Reply-To: <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> Currently, AVIC is inhibited when booting a VM w/ x2APIC support.
> This is because AVIC cannot virtualize x2APIC mode in the VM.
> With x2AVIC support, the APICV_INHIBIT_REASON_X2APIC is
> no longer enforced.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 19 +++++++++++++++++++
>  arch/x86/kvm/svm/svm.c  | 17 ++---------------
>  arch/x86/kvm/svm/svm.h  |  1 +
>  3 files changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 085a82e95cb0..abcf761c0c53 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -21,6 +21,7 @@
>  
>  #include <asm/irq_remapping.h>
>  
> +#include "cpuid.h"
>  #include "trace.h"
>  #include "lapic.h"
>  #include "x86.h"
> @@ -159,6 +160,24 @@ void avic_vm_destroy(struct kvm *kvm)
>  	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
>  }
>  
> +void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested)
> +{
> +	/*
> +	 * If the X2APIC feature is exposed to the guest,
> +	 * disable AVIC unless X2AVIC mode is enabled.
> +	 */
> +	if (avic_mode == AVIC_MODE_X1 &&
> +	    guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_X2APIC);
> +
> +	/*
> +	 * Currently, AVIC does not work with nested virtualization.
> +	 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
> +	 */
> +	if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_NESTED);
> +}
> +
>  int avic_vm_init(struct kvm *kvm)
>  {
>  	unsigned long flags;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b7dbd8bb2c0a..931998d1d8c4 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3961,7 +3961,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_cpuid_entry2 *best;
> -	struct kvm *kvm = vcpu->kvm;
>  
>  	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>  				    boot_cpu_has(X86_FEATURE_XSAVE) &&
> @@ -3982,21 +3981,9 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
>  	}
>  
> -	if (kvm_vcpu_apicv_active(vcpu)) {
> -		/*
> -		 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
> -		 * is exposed to the guest, disable AVIC.
> -		 */
> -		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
> -			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
> +	if (kvm_vcpu_apicv_active(vcpu))
> +		avic_vcpu_after_set_cpuid(vcpu, nested);
>  
> -		/*
> -		 * Currently, AVIC does not work with nested virtualization.
> -		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
> -		 */
> -		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> -			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_NESTED);
> -	}
>  	init_vmcb_after_set_cpuid(vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index e340c86941be..0312eec7c7f5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -583,6 +583,7 @@ int avic_init_vcpu(struct vcpu_svm *svm);
>  void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  void __avic_vcpu_put(struct kvm_vcpu *vcpu);
>  void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
> +void avic_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu, int nested);
>  void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
>  bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);

Hi!


I just got an idea, while writing a kvm selftest that would use AVIC,
and finding out that selftest code uploads the '-host' cpuid right away
which has x2apic enabled and that inhibits AVIC, and later clearing x2apic
in the cpuid doesn't un-inhibit it.
 
That can be fixed in few ways but that got me thinking:
 
Why do we inhibit AVIC when the guest uses x2apic, even without X2AVIC?
I think that if we didn't it would just work, and even work faster than
pure software x2apic.
 
My thinking is:
 
- when a vcpu itself uses its x2apic, even if its avic is not inhibited, 
the guest will write x2apic msrs which kvm intercepts and will correctly emulate a proper x2apic.
 
- vcpu peers will also use x2apic msrs and again it will work correctly 
(even when there are more than 256 vcpus).
 
- and the host + iommu will still be able to use AVIC's doorbell to send interrupts to the guest
and that doesn't need apic ids or anything, it should work just fine. 

Also AVIC should have no issues scanning IRR and injecting interrupts on VM entry, 
x2apic mode doesn't matter for that.
 
AVIC mmio can still be though discovered by the guest which is technically against x86 spec
(in x2apic mode, mmio supposed to not work) but that can be fixed easily by disabing
the AVIC memslot if any of the vCPUs are in x2apic mode, or this can be ignored since
it should not cause any issues.
We seem to have a quirk for that KVM_X86_QUIRK_LAPIC_MMIO_HOLE.
 
On top of all this, removing this inhibit will also allow to test AVIC with guest
which does have x2apic in the CPUID but doesn't use it (e.g kvm unit test, or
linux booted with nox2apic, which is also nice IMHO)
 
What do you think?

Best regards,
	Maxim Levitsky




