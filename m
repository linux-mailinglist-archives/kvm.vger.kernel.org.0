Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2E37726EA
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 16:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjHGOEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 10:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbjHGODi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 10:03:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4185267
        for <kvm@vger.kernel.org>; Mon,  7 Aug 2023 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691416864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Qn1be9pgxXRNYtcAeFBlVlvM6Ax4kbHeWCXxtkTfV8=;
        b=B+v61c5ObCCEQV4MO6Gzs7Chhy9V5eM4Ta4JXm36KlPMmSGhcHsFSMNucqcvw7cbFYsyW4
        JKEgrHshmLRNICpiLAUeGVaRh3n3jjvMUGzqhaeySrB07KpLaabM76b8MuvMKXWuAhlyvd
        AswBjwaiub/Oqv2y8XEjQjuTQWumflI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-JT0ZI1yZOhmXBVfzoEvHqw-1; Mon, 07 Aug 2023 10:01:03 -0400
X-MC-Unique: JT0ZI1yZOhmXBVfzoEvHqw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a348facbbso346438766b.1
        for <kvm@vger.kernel.org>; Mon, 07 Aug 2023 07:01:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691416861; x=1692021661;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Qn1be9pgxXRNYtcAeFBlVlvM6Ax4kbHeWCXxtkTfV8=;
        b=EUijJkX7sgOLhUY+SxZqfC8yYOhxALTVkUMKP4Cyb0PRCFQjMHFsoPTZM9uEGMpMRY
         /aIPw7wgZogRKu0vQgo18kiAwibFcmqI1hRdIk9jYlj5kCUv+6SkJLePMUPmMEndnUaU
         YUKF3MExAsQMcJBjdNnC/WX0KVS/NjwoU2ElmyHCtUIQWepP7ifpMvX9Z6zoQ70Eo6Kq
         OeJ9mdGaBqQ99C3wNTP5B3frMeCVrvQQjJ6Oo8flqzxf5+JWYSeshT2JwTqX6l6Wg1HX
         8ZfHNFQ9LWzfXR6vAkwvMOpO29Wktv0PKbDdvr/RCp2OnJhYYm3geT1jQyP3iW67wGvI
         jPcA==
X-Gm-Message-State: AOJu0YyV2hkST7fEv7HME4KOmt1QJj3sdt4NEXvMY+wkMlVErCJ1gHfg
        xh/UWgOcOU5Nrq1KIAycnQbI4QFobHwkOKsKKzdP6DKKt7DqPKHTo6cD4zr8Ad0UN22TdeJ5gwo
        ArteyvFYW6Ygg
X-Received: by 2002:a17:906:109:b0:992:c5ad:18bc with SMTP id 9-20020a170906010900b00992c5ad18bcmr8728050eje.70.1691416861577;
        Mon, 07 Aug 2023 07:01:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhUcIre4dij7OZI2/1FXR32l47+F57mVyabdc+b9sFs4qS6Plod5Bv2FgIHEVsv/zVDpgQNg==
X-Received: by 2002:a17:906:109:b0:992:c5ad:18bc with SMTP id 9-20020a170906010900b00992c5ad18bcmr8728035eje.70.1691416861277;
        Mon, 07 Aug 2023 07:01:01 -0700 (PDT)
Received: from starship ([77.137.131.138])
        by smtp.gmail.com with ESMTPSA id l7-20020a1709066b8700b0099c53c4407dsm5278038ejr.78.2023.08.07.07.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 07:01:00 -0700 (PDT)
Message-ID: <43c18a3d57305cf52a1c3643fa8f714ae3769551.camel@redhat.com>
Subject: Re: [RFC PATCH] KVM: x86: inhibit APICv upon detecting direct APIC
 access from L2
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ake Koomsin <ake@igel.co.jp>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>
Date:   Mon, 07 Aug 2023 17:00:58 +0300
In-Reply-To: <20230807062611.12596-1-ake@igel.co.jp>
References: <20230807062611.12596-1-ake@igel.co.jp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У пн, 2023-08-07 у 15:26 +0900, Ake Koomsin пише:
> Current KVM does not expect L1 hypervisor to allow L2 guest to access
> APIC page directly when APICv is enabled. When this happens, KVM
> emulates the access itself resulting in interrupt lost.
> 
> As this kind of hypervisor is rare, it is simpler to inhibit APICv upon
> detecting direct APIC access from L2 to avoid unexpected interrupt lost.
> 
> Signed-off-by: Ake Koomsin <ake@igel.co.jp>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 ++++++
>  arch/x86/kvm/mmu/mmu.c          | 33 ++++++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.h          |  3 ++-
>  arch/x86/kvm/vmx/vmx.c          |  3 ++-
>  4 files changed, 36 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3bc146dfd38d..8764b11922a0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1188,6 +1188,12 @@ enum kvm_apicv_inhibit {
>  	APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
>  	APICV_INHIBIT_REASON_APIC_BASE_MODIFIED,
>  
> +	/*
> +	 * APICv is disabled because L1 hypervisor allows L2 guest to access
> +	 * APIC directly.
> +	 */
> +	APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS,
> +
>  	/******************************************************/
>  	/* INHIBITs that are relevant only to the AMD's AVIC. */
>  	/******************************************************/
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..c1150ef9fce1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4293,6 +4293,30 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true, NULL);
>  }
>  
> +static int __kvm_faultin_pfn_guest_mode(struct kvm_vcpu *vcpu,
> +					struct kvm_page_fault *fault)
> +{
> +	struct kvm_memory_slot *slot = fault->slot;
> +
> +	/* Don't expose private memslots to L2. */
> +	fault->slot = NULL;
> +	fault->pfn = KVM_PFN_NOSLOT;
> +	fault->map_writable = false;
> +
> +	/*
> +	 * APICv does not work when L1 hypervisor allows L2 guest to access
> +	 * APIC directly. As this kind of L1 hypervisor is rare, it is simpler
> +	 * to inhibit APICv when we detect direct APIC access from L2, and
> +	 * fallback to emulation path to avoid interrupt lost.
> +	 */
> +	if (unlikely(slot && slot->id == APIC_ACCESS_PAGE_PRIVATE_MEMSLOT &&
> +		     kvm_apicv_activated(vcpu->kvm)))
> +		kvm_set_apicv_inhibit(vcpu->kvm,
> +				      APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS);

Is there a good reason why KVM doesn't expose APIC memslot to a nested guest?
While nested guest runs, the L1's APICv is "inhibited" effectively anyway, so writes to this memslot
should update APIC registers and be picked up by APICv hardware when L1 resumes execution.

Since APICv alows itself to be inhibited due to other reasons, it means that just like AVIC, it should be able
to pick up arbitrary changes to APIC registers which happened while it was inhibited,
just like AVIC does.

I'll take a look at the code to see if APICv does this (I know AVIC's code much better that APICv's)

Is there a reproducer for this bug?

Best regards,
	Maxim Levitsky

> +
> +	return RET_PF_CONTINUE;
> +}
> +
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_memory_slot *slot = fault->slot;
> @@ -4307,13 +4331,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  		return RET_PF_RETRY;
>  
>  	if (!kvm_is_visible_memslot(slot)) {
> -		/* Don't expose private memslots to L2. */
> -		if (is_guest_mode(vcpu)) {
> -			fault->slot = NULL;
> -			fault->pfn = KVM_PFN_NOSLOT;
> -			fault->map_writable = false;
> -			return RET_PF_CONTINUE;
> -		}
> +		if (is_guest_mode(vcpu))
> +			return __kvm_faultin_pfn_guest_mode(vcpu, fault);
>  		/*
>  		 * If the APIC access page exists but is disabled, go directly
>  		 * to emulation without caching the MMIO access or creating a
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 18af7e712a5a..8d77932ee0fb 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -683,7 +683,8 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
> -	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED)	\
> +	BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED) |	\
> +	BIT(APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS)	\
>  )
>  
>  bool avic_hardware_setup(void);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index df461f387e20..f652397c9765 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8189,7 +8189,8 @@ static void vmx_hardware_unsetup(void)
>  	BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |		\
>  	BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
>  	BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |	\
> -	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED)	\
> +	BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |	\
> +	BIT(APICV_INHIBIT_REASON_L2_PASSTHROUGH_ACCESS)	\
>  )
>  
>  static void vmx_vm_destroy(struct kvm *kvm)



