Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676EA6ADB6B
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 11:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjCGKIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 05:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGKId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 05:08:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5803D5071B
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 02:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678183660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V1JmY/X7PnOboq8EJYmDJS1+dUQ3/lbmiwhls6dYBpI=;
        b=dFcfymV3HusHCuvLeJSoyYlPo4XU7HRw8WZYsp3/kDhKcsOY0xBBoE8Zug1F3oqrA+tA2K
        VgvMHPS/kqJYNCBdbSQXQkIZDed0764+mwdADx9KqQzsM/2RxBR6JmYNDFJNlEZiOR1If0
        uYA3SxEnVWtCIkP0wt5jDGhKwkNvb94=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-WmlojaelNcCsSzw3ngC2Gg-1; Tue, 07 Mar 2023 05:07:39 -0500
X-MC-Unique: WmlojaelNcCsSzw3ngC2Gg-1
Received: by mail-qk1-f197.google.com with SMTP id e14-20020a05620a208e00b0074270b9960dso7057609qka.22
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 02:07:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678183659;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V1JmY/X7PnOboq8EJYmDJS1+dUQ3/lbmiwhls6dYBpI=;
        b=C8+e/PocXDgbl03mxjO92Xfw8ynl2v7vTl+KwmKz2K2dIklsh3c5vXUujYPoY1gxNq
         B8/SmN+OvL6cXRrXXm6AS2yqlegYVhTuTDxF14TBvp5KZej2/wrxjRt25ORZOCSB4+F/
         dCH5Omlggv/bCryIkYJbBiuQFjJZ6dIvSpp+hz/raPWbZe94GJVGycyXpiG7gL3ghbVm
         Z4f6brxaC/P8PgqZHIuDaVDnUw4EK7vENCjgQ7oN39FrfTMxEQahPXDEsHC6KkRUSzdO
         xpxsDEni3j25O4xOMe8qETjCi7OyPVyY9rS0qi12rCngycX6QO+mWLLOl7zSfUjhj0Oz
         TGUw==
X-Gm-Message-State: AO0yUKW0QAAVZurwt3Y4wWuEPNzSEQx4FyxLceU3G3/eJTs5KW/sBBDZ
        5utrwb8myVdRQaVkD2jrVvfIpm9Qs7buAwb6LKLIpiGhkPhwetKJhkWuI8dYRup+31O5RoQYwDm
        oUtVCy3mbIQbP
X-Received: by 2002:a05:622a:1b8b:b0:3b9:a372:e456 with SMTP id bp11-20020a05622a1b8b00b003b9a372e456mr21883571qtb.57.1678183658709;
        Tue, 07 Mar 2023 02:07:38 -0800 (PST)
X-Google-Smtp-Source: AK7set9jXvJ/iByIcmR56T2v/fG4zz6UvdsgF/Ku3RFa4sMV5+n5z41yjt+N0gTGyI4HFsr1IZghoQ==
X-Received: by 2002:a05:622a:1b8b:b0:3b9:a372:e456 with SMTP id bp11-20020a05622a1b8b00b003b9a372e456mr21883545qtb.57.1678183658360;
        Tue, 07 Mar 2023 02:07:38 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id e10-20020a05620a014a00b0071a02d712b0sm9293177qkn.99.2023.03.07.02.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 02:07:37 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
In-Reply-To: <c6bb4b57-f134-d992-7f30-be80151fb67e@linux.microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
 <87lek9zs05.fsf@redhat.com>
 <c6bb4b57-f134-d992-7f30-be80151fb67e@linux.microsoft.com>
Date:   Tue, 07 Mar 2023 11:07:33 +0100
Message-ID: <87a60ozxga.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:

> On 06/03/2023 18:52, Vitaly Kuznetsov wrote:
>> Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:
>> 
>>> TDP MMU has been broken on AMD CPUs when running on Hyper-V since v5.17.
>>> The issue was first introduced by two commmits:
>>>
>>> - bb95dfb9e2dfbe6b3f5eb5e8a20e0259dadbe906 "KVM: x86/mmu: Defer TLB
>>>   flush to caller when freeing TDP MMU shadow pages"
>>> - efd995dae5eba57c5d28d6886a85298b390a4f07 "KVM: x86/mmu: Zap defunct
>>>   roots via asynchronous worker"
>>>
>>> The root cause is that since then there are missing TLB flushes which
>>> are required by HV_X64_NESTED_ENLIGHTENED_TLB.
>> 
>> Please share more details on what's actually missing as you get them,
>> I'd like to understand which flushes can be legally avoided on bare
>> hardware and Hyper-V/VMX but not on Hyper-V/SVM.
>> 
>
> See the linked thread here
> https://lore.kernel.org/lkml/20d189fc-8d20-8083-b448-460cc0420151@linux.microsoft.com/#t
> for all the details/analyses but the summary was that either of these 2
> options would work, with a) having less flushes (footnote: less flushes is not necessarily
> better):
>
> a) adding a hyperv_flush_guest_mapping(__pa(root->spt) after kvm_tdp_mmu_get_vcpu_root_hpa's call to tdp_mmu_alloc_sp()
> b) adding a hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa) to svm_flush_tlb_current()
>
> These are only needed on Hyper-V/SVM because of how the enlightenment works (needs an explicit
> flush to rebuild L0 shadow page tables). Hyper-V/VMX does not need any changes and currently
> works. Let me know if you need more information on something here, I'll try to get it.
>

Ah, I missed the whole party! Thanks for the pointers!

>>>  The failure manifests
>>> as L2 guest VMs being unable to complete boot due to memory
>>> inconsistencies between L1 and L2 guests which lead to various
>>> assertion/emulation failures.

Which levels are we talking about here, *real* L1 and L2 or L1 and L2
from KVM's perspective (real L2 and L3)?

>>>
>>> The HV_X64_NESTED_ENLIGHTENED_TLB enlightenment is always exposed by
>>> Hyper-V on AMD and is always used by Linux. The TLB flush required by
>>> HV_X64_NESTED_ENLIGHTENED_TLB is much stricter than the local TLB flush
>>> that TDP MMU wants to issue. We have also found that with TDP MMU L2 guest
>>> boot performance on AMD is reproducibly slower compared to when TDP MMU is
>>> disabled.
>>>
>>> Disable TDP MMU when using SVM Hyper-V for the time being while we
>>> search for a better fix.
>> 
>> I'd suggest we go the other way around: disable
>> HV_X64_NESTED_ENLIGHTENED_TLB on SVM:
>
> Paolo suggested disabling TDP_MMU when HV_X64_NESTED_ENLIGHTENED_TLB is used, and
> I prefer that option too. The enlighenment does offer a nice performance advantage
> with non-TDP_MMU, and I did not see TDP_MMU perform any better compared to that.
> Afaik the code to use the enlightenment on Hyper-V/SVM was written/tested before
> TDP_MMU became the default.
>
> If you have a specific scenario in mind, we could test and see what the implications
> are there.

I don't have a strong opinion here, I've suggested a smaller change so
it's easier to backport it to stable kernels and easier to revert when a
proper fix comes to mainline. For performance implication, I'd only
consider non-nested scenarios from KVM's perspective (i.e. real L2 from
Hyper-V's PoV), as running L3 is unlikely a common use-case and, if I
understood correctly, is broken anyway.

>
>> 
>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
>> index 6981c1e9a809..be98da5a4277 100644
>> --- a/arch/x86/kvm/svm/svm_onhyperv.h
>> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
>> @@ -32,7 +32,8 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>>  
>>  static inline void svm_hv_hardware_setup(void)
>>  {
>> -       if (npt_enabled &&
>> +       /* A comment about missing TLB flushes */
>> +       if (!tdp_mmu_enabled && npt_enabled &&
>>             ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
>>                 pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
>>                 svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
>> 
>> this way we won't have a not-obvious-at-all MMU change on Hyper-V. I
>> understand this may have some performance implications but MMU switch
>> has some as well.
>> 
>>>
>>> Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/t/#u
>>> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
>>> ---
>>> Based on kvm-x86-mmu-6.3. The approach used here does not apply cleanly to
>>> <=v6.2. This would be needed in stable too, and I don't know about putting
>>> fixes tags.
>> 
>> Cc: stable@vger.kernel.org # 5.17.0 
>> 
>> should do)
>> 
>>>
>>> Jeremi
>>>
>>>  arch/x86/include/asm/kvm_host.h |  3 ++-
>>>  arch/x86/kvm/mmu/mmu.c          |  5 +++--
>>>  arch/x86/kvm/svm/svm.c          |  6 +++++-
>>>  arch/x86/kvm/svm/svm_onhyperv.h | 10 ++++++++++
>>>  arch/x86/kvm/vmx/vmx.c          |  3 ++-
>>>  5 files changed, 22 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>> index 4d2bc08794e4..a0868ae3688d 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -2031,7 +2031,8 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
>>>  void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>>>  
>>>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>> -		       int tdp_max_root_level, int tdp_huge_page_level);
>>> +		       int tdp_max_root_level, int tdp_huge_page_level,
>>> +		       bool enable_tdp_mmu);
>>>  
>>>  static inline u16 kvm_read_ldt(void)
>>>  {
>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>>> index c91ee2927dd7..5c0e28a7a3bc 100644
>>> --- a/arch/x86/kvm/mmu/mmu.c
>>> +++ b/arch/x86/kvm/mmu/mmu.c
>>> @@ -5787,14 +5787,15 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>>>  }
>>>  
>>>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>>> -		       int tdp_max_root_level, int tdp_huge_page_level)
>>> +		       int tdp_max_root_level, int tdp_huge_page_level,
>>> +		       bool enable_tdp_mmu)
>>>  {
>>>  	tdp_enabled = enable_tdp;
>>>  	tdp_root_level = tdp_forced_root_level;
>>>  	max_tdp_level = tdp_max_root_level;
>>>  
>>>  #ifdef CONFIG_X86_64
>>> -	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
>>> +	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && enable_tdp_mmu;
>>>  #endif
>>>  	/*
>>>  	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index d13cf53e7390..070c3f7f8c9f 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -4925,6 +4925,7 @@ static __init int svm_hardware_setup(void)
>>>  	struct page *iopm_pages;
>>>  	void *iopm_va;
>>>  	int r;
>>> +	bool enable_tdp_mmu;
>>>  	unsigned int order = get_order(IOPM_SIZE);
>>>  
>>>  	/*
>>> @@ -4991,9 +4992,12 @@ static __init int svm_hardware_setup(void)
>>>  	if (!boot_cpu_has(X86_FEATURE_NPT))
>>>  		npt_enabled = false;
>>>  
>>> +	enable_tdp_mmu = svm_hv_enable_tdp_mmu();
>>> +
>>>  	/* Force VM NPT level equal to the host's paging level */
>>>  	kvm_configure_mmu(npt_enabled, get_npt_level(),
>>> -			  get_npt_level(), PG_LEVEL_1G);
>>> +			  get_npt_level(), PG_LEVEL_1G,
>>> +			  enable_tdp_mmu);
>>>  	pr_info("Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>>>  
>>>  	/* Setup shadow_me_value and shadow_me_mask */
>>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
>>> index 6981c1e9a809..aa49ac5d66bc 100644
>>> --- a/arch/x86/kvm/svm/svm_onhyperv.h
>>> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
>>> @@ -30,6 +30,11 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>>>  		hve->hv_enlightenments_control.msr_bitmap = 1;
>>>  }
>>>  
>>> +static inline bool svm_hv_enable_tdp_mmu(void)
>>> +{
>>> +	return !(npt_enabled && ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB);
>>> +}
>>> +
>>>  static inline void svm_hv_hardware_setup(void)
>>>  {
>>>  	if (npt_enabled &&
>>> @@ -84,6 +89,11 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>>>  {
>>>  }
>>>  
>>> +static inline bool svm_hv_enable_tdp_mmu(void)
>>> +{
>>> +	return true;
>>> +}
>>> +
>>>  static inline void svm_hv_hardware_setup(void)
>>>  {
>>>  }
>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>> index c788aa382611..4d3808755d39 100644
>>> --- a/arch/x86/kvm/vmx/vmx.c
>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>> @@ -8442,7 +8442,8 @@ static __init int hardware_setup(void)
>>>  	vmx_setup_me_spte_mask();
>>>  
>>>  	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
>>> -			  ept_caps_to_lpage_level(vmx_capability.ept));
>>> +			  ept_caps_to_lpage_level(vmx_capability.ept),
>>> +			  true);
>>>  
>>>  	/*
>>>  	 * Only enable PML when hardware supports PML feature, and both EPT
>> 
>

-- 
Vitaly

