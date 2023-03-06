Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F406ACB86
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 18:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCFRz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 12:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjCFRzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 12:55:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62D43E616
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 09:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678125183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T38aicOap2L3dNrO05NaSlkk1BAlJFKJpc6HTRG+yuU=;
        b=Vpzadfa3/Cb97pyc7MDQCFh5ubObKPBBFZXeqfg54pTd3AqqGXztzRPyeXBzK5HToyJwRD
        y1J/JWEXET2O5/mdXUon+lQomtDCrUgWl8+AhNS5o6s/ApH4UfmJJ/7rFRCDGL2M5kU3Tq
        sizz9xt0XTeH31XyNZl7HzseDSzmXyc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-TsafV26sMFmALN-XNg6vKA-1; Mon, 06 Mar 2023 12:53:01 -0500
X-MC-Unique: TsafV26sMFmALN-XNg6vKA-1
Received: by mail-wm1-f69.google.com with SMTP id p22-20020a7bcc96000000b003e2036a1516so7062155wma.7
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 09:53:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678125180;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T38aicOap2L3dNrO05NaSlkk1BAlJFKJpc6HTRG+yuU=;
        b=dVp0HW4U/Y4NcIA+DDvoACOVu50Ya9XO/zGAhrszzBFUPno9KhqdWlGqTzVfH0PDwC
         AGGbRQ9F2MVMaOCSedlVR8PIzW5xYo4lQtFeWJzRRaN73oO6o9CJgbqIGtlhy7lzjqwQ
         Rkm88elwHu43DzLUFbWe50B3rLj97P6uD5mvEZguPaDFVgmVu5yG3ne1Q2gd8n+7FgJ4
         nVDv6ScOq0UR7s5nLwJhfYfBjt3NrKXSpAM7Rij5L5sy4+Xn3bdtBDRGbljtzQWi8UXj
         +xo+VcRS0WUGMClDiwM1qBS9/KRCagHHIbZ5i0Dada5ig5RYSpw2GF1zyqGgS7AjVncc
         F1UQ==
X-Gm-Message-State: AO0yUKU55PwCGBkH1Xmtgbooy1dSHoAHmOE+ry04yzESR/bukDHW4UXG
        8VQ9e5613KycSZa6jVsExsGg4OPZuvc1/GQ4gw085jbTlVF4XfJzUouQ02QBskfoVAqy/sBhPw4
        iUTYB9k4UIzDh
X-Received: by 2002:a05:600c:19d2:b0:3eb:37ce:4c38 with SMTP id u18-20020a05600c19d200b003eb37ce4c38mr10211158wmq.3.1678125180573;
        Mon, 06 Mar 2023 09:53:00 -0800 (PST)
X-Google-Smtp-Source: AK7set+DQ6Hj585upRJSMuaCrimvzjCLUzKELwmvcMSrnRwhWcJzXaCnhc/QXuhs5e0ugUZqBN78lw==
X-Received: by 2002:a05:600c:19d2:b0:3eb:37ce:4c38 with SMTP id u18-20020a05600c19d200b003eb37ce4c38mr10211140wmq.3.1678125180274;
        Mon, 06 Mar 2023 09:53:00 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id v12-20020a05600c12cc00b003de2fc8214esm10560271wmd.20.2023.03.06.09.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 09:52:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [PATCH] KVM: SVM: Disable TDP MMU when running on Hyper-V
In-Reply-To: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
References: <20230227171751.1211786-1-jpiotrowski@linux.microsoft.com>
Date:   Mon, 06 Mar 2023 18:52:58 +0100
Message-ID: <87lek9zs05.fsf@redhat.com>
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

Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:

> TDP MMU has been broken on AMD CPUs when running on Hyper-V since v5.17.
> The issue was first introduced by two commmits:
>
> - bb95dfb9e2dfbe6b3f5eb5e8a20e0259dadbe906 "KVM: x86/mmu: Defer TLB
>   flush to caller when freeing TDP MMU shadow pages"
> - efd995dae5eba57c5d28d6886a85298b390a4f07 "KVM: x86/mmu: Zap defunct
>   roots via asynchronous worker"
>
> The root cause is that since then there are missing TLB flushes which
> are required by HV_X64_NESTED_ENLIGHTENED_TLB.

Please share more details on what's actually missing as you get them,
I'd like to understand which flushes can be legally avoided on bare
hardware and Hyper-V/VMX but not on Hyper-V/SVM.

>  The failure manifests
> as L2 guest VMs being unable to complete boot due to memory
> inconsistencies between L1 and L2 guests which lead to various
> assertion/emulation failures.
>
> The HV_X64_NESTED_ENLIGHTENED_TLB enlightenment is always exposed by
> Hyper-V on AMD and is always used by Linux. The TLB flush required by
> HV_X64_NESTED_ENLIGHTENED_TLB is much stricter than the local TLB flush
> that TDP MMU wants to issue. We have also found that with TDP MMU L2 guest
> boot performance on AMD is reproducibly slower compared to when TDP MMU is
> disabled.
>
> Disable TDP MMU when using SVM Hyper-V for the time being while we
> search for a better fix.

I'd suggest we go the other way around: disable
HV_X64_NESTED_ENLIGHTENED_TLB on SVM:

diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index 6981c1e9a809..be98da5a4277 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -32,7 +32,8 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 
 static inline void svm_hv_hardware_setup(void)
 {
-       if (npt_enabled &&
+       /* A comment about missing TLB flushes */
+       if (!tdp_mmu_enabled && npt_enabled &&
            ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
                pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
                svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;

this way we won't have a not-obvious-at-all MMU change on Hyper-V. I
understand this may have some performance implications but MMU switch
has some as well.

>
> Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/t/#u
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> ---
> Based on kvm-x86-mmu-6.3. The approach used here does not apply cleanly to
> <=v6.2. This would be needed in stable too, and I don't know about putting
> fixes tags.

Cc: stable@vger.kernel.org # 5.17.0 

should do)

>
> Jeremi
>
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          |  5 +++--
>  arch/x86/kvm/svm/svm.c          |  6 +++++-
>  arch/x86/kvm/svm/svm_onhyperv.h | 10 ++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  3 ++-
>  5 files changed, 22 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4d2bc08794e4..a0868ae3688d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2031,7 +2031,8 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
>  void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>  
>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> -		       int tdp_max_root_level, int tdp_huge_page_level);
> +		       int tdp_max_root_level, int tdp_huge_page_level,
> +		       bool enable_tdp_mmu);
>  
>  static inline u16 kvm_read_ldt(void)
>  {
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c91ee2927dd7..5c0e28a7a3bc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5787,14 +5787,15 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  }
>  
>  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> -		       int tdp_max_root_level, int tdp_huge_page_level)
> +		       int tdp_max_root_level, int tdp_huge_page_level,
> +		       bool enable_tdp_mmu)
>  {
>  	tdp_enabled = enable_tdp;
>  	tdp_root_level = tdp_forced_root_level;
>  	max_tdp_level = tdp_max_root_level;
>  
>  #ifdef CONFIG_X86_64
> -	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;
> +	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled && enable_tdp_mmu;
>  #endif
>  	/*
>  	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d13cf53e7390..070c3f7f8c9f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4925,6 +4925,7 @@ static __init int svm_hardware_setup(void)
>  	struct page *iopm_pages;
>  	void *iopm_va;
>  	int r;
> +	bool enable_tdp_mmu;
>  	unsigned int order = get_order(IOPM_SIZE);
>  
>  	/*
> @@ -4991,9 +4992,12 @@ static __init int svm_hardware_setup(void)
>  	if (!boot_cpu_has(X86_FEATURE_NPT))
>  		npt_enabled = false;
>  
> +	enable_tdp_mmu = svm_hv_enable_tdp_mmu();
> +
>  	/* Force VM NPT level equal to the host's paging level */
>  	kvm_configure_mmu(npt_enabled, get_npt_level(),
> -			  get_npt_level(), PG_LEVEL_1G);
> +			  get_npt_level(), PG_LEVEL_1G,
> +			  enable_tdp_mmu);
>  	pr_info("Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
>  
>  	/* Setup shadow_me_value and shadow_me_mask */
> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
> index 6981c1e9a809..aa49ac5d66bc 100644
> --- a/arch/x86/kvm/svm/svm_onhyperv.h
> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
> @@ -30,6 +30,11 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  		hve->hv_enlightenments_control.msr_bitmap = 1;
>  }
>  
> +static inline bool svm_hv_enable_tdp_mmu(void)
> +{
> +	return !(npt_enabled && ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB);
> +}
> +
>  static inline void svm_hv_hardware_setup(void)
>  {
>  	if (npt_enabled &&
> @@ -84,6 +89,11 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
>  {
>  }
>  
> +static inline bool svm_hv_enable_tdp_mmu(void)
> +{
> +	return true;
> +}
> +
>  static inline void svm_hv_hardware_setup(void)
>  {
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..4d3808755d39 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8442,7 +8442,8 @@ static __init int hardware_setup(void)
>  	vmx_setup_me_spte_mask();
>  
>  	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
> -			  ept_caps_to_lpage_level(vmx_capability.ept));
> +			  ept_caps_to_lpage_level(vmx_capability.ept),
> +			  true);
>  
>  	/*
>  	 * Only enable PML when hardware supports PML feature, and both EPT

-- 
Vitaly

