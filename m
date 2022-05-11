Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D4523CF9
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 21:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244095AbiEKTA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 15:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346513AbiEKTAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 15:00:54 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E565FBF
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 12:00:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y41so2737856pfw.12
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 12:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qvVhHhulHY/XSijmAEOvwJkg0FttEPo5JxhK3PsoSPs=;
        b=k2E1UV+yGTq3/x8h/3CXg6VlPy5s/ES8EkDKvRCmwXBtUkCLj/+X+diR4nlseGw7e0
         +dwR0UCIygo8DO+K65/5mcYY/iKkIdRjoN4ErW0wLsHLpgOEfZk0yG142uHU1povhORk
         /v37Ytat4+cgYTm3D8uB7BEMKQu7rN1HsogojoY9XMWzopQ5nVNTuHx/zuptHrQ6utgN
         OyZWzxq7idnisgFmX0MAiYQwHAq9kU3igDB/ZIwF0ImPGQ8WV6SbPn1XsKAbsL+y9BX4
         hGGSfH4ybbqX6s2jQMl2yIzmxeVWHuyAYymB0fvyDC/qQK5pnqzKdqqVzmS/iyp3Tjqj
         K27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qvVhHhulHY/XSijmAEOvwJkg0FttEPo5JxhK3PsoSPs=;
        b=mGg6/JRII04iHa7jqA5Oxyq95bE22a2kh/w1F2jJGy2jQQY7s0lKsjbE98huI4jzYz
         VAzaU5VErkB4BNA26MeSoyYzsrQAUEABFibk5pjft/wQ+oVcoKFXWzNdhRm/7ziPcdQB
         X0YRL7EfvVuSZVG7xjS4gX8wplsNzrd5KFezm0Y+OhmBbYKpiDwT2LzZ+atHQyQkQNcF
         GWowbSYZkdP9Q3UINLOlNlePaxRKb+obU4TlvmZJGYm1Mo4BMyIZWWYAFZu2WY0pG0ZL
         X/aYCTl0Sjda5kgLWCqsPFUmQ46wvwhz9AQu8MsQqiP6JHk7zbHpzOkAeAEYJ+Xr84ik
         TSTQ==
X-Gm-Message-State: AOAM531zml7U6xC2ndw6yrleOuU9Dkh1cmxxb72E7On9QQmbQlXYj80P
        bzIhyjo74HMomm68s+lip4RIlQ==
X-Google-Smtp-Source: ABdhPJyfpZeRaARQHajAKGL25wxgSt6VgdfaW1uzcC0VfH/hnVSlkB5LSebB9Z1VeBvKYDFu+0n2bA==
X-Received: by 2002:a05:6a00:8c2:b0:510:98ac:96c9 with SMTP id s2-20020a056a0008c200b0051098ac96c9mr19460258pfu.18.1652295646784;
        Wed, 11 May 2022 12:00:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w18-20020a634912000000b003c14af505f4sm237773pga.12.2022.05.11.12.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 12:00:46 -0700 (PDT)
Date:   Wed, 11 May 2022 19:00:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: x86: Add support for MSR_IA32_MCx_CTL2 MSRs.
Message-ID: <YnwH2zRlGvwkjCAC@google.com>
References: <20220412223134.1736547-1-juew@google.com>
 <20220412223134.1736547-4-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412223134.1736547-4-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Jue Wang wrote:
> Note the support of CMCI (MCG_CMCI_P) is not enabled in
> kvm_mce_cap_supported yet.

You can probably guess what I would say here :-)  A reader should not have to go
wade through Intel's SDM to understand the relationship between CTL2 and CMCI.

> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 50 +++++++++++++++++++++++++--------
>  2 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index ec9830d2aabf..639ef92d01d1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -800,6 +800,7 @@ struct kvm_vcpu_arch {
>  	u64 mcg_ctl;
>  	u64 mcg_ext_ctl;
>  	u64 *mce_banks;
> +	u64 *mci_ctl2_banks;
>  
>  	/* Cache MMIO info */
>  	u64 mmio_gva;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb4029660bd9..73c64d2b9e60 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3167,6 +3167,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	unsigned bank_num = mcg_cap & 0xff;
>  	u32 msr = msr_info->index;
>  	u64 data = msr_info->data;
> +	u32 offset;
>  
>  	switch (msr) {
>  	case MSR_IA32_MCG_STATUS:
> @@ -3180,10 +3181,22 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		vcpu->arch.mcg_ctl = data;
>  		break;
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:

This is wrong.  Well, incomplete.  It will allow writes to MSRs that do not exist,
i.e. if bank_num >= offset < KVM_MAX_MCE_BANKS.

I believe this will suffice and is also the simplest?

		if (msr >= MSR_IA32_MCx_CTL2(bank_num))
			return 1;

Actually, tying in with the array_index_nopsec() comments below, if this captures
the last MSR in a variable, then the overrun is much more reasonable (sample idea
at the bottom).

> +		if (!(mcg_cap & MCG_CMCI_P) &&
> +				(data || !msr_info->host_initiated))

Funky indentation.  Should be:

		if (!(mcg_cap & MCG_CMCI_P) &&
		    (data || !msr_info->host_initiated))
			return 1;

> +			return 1;
> +		/* An attempt to write a 1 to a reserved bit raises #GP */
> +		if (data & ~(MCI_CTL2_CMCI_EN | MCI_CTL2_CMCI_THRESHOLD_MASK))
> +			return 1;
> +		offset = array_index_nospec(
> +				msr - MSR_IA32_MC0_CTL2,
> +				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);

My preference would be to let this run over (by a fair amount)

		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
					    MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);

But if we use a local variable, there's no overrun:

	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
		last_msr = MSR_IA32_MCx_CTL2(bank_num) - 1;
		if (msr > last_msr)
			return 1;

		if (!(mcg_cap & MCG_CMCI_P) && (data || !msr_info->host_initiated))
			return 1;
		/* An attempt to write a 1 to a reserved bit raises #GP */
		if (data & ~(MCI_CTL2_CMCI_EN | MCI_CTL2_CMCI_THRESHOLD_MASK))
			return 1;
		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
					    last_msr + 1 - MSR_IA32_MC0_CTL2);
		vcpu->arch.mci_ctl2_banks[offset] = data;
		break;


And if we go that route, in a follow-up patch at the end of the series, clean up
the "default" path to hoist the if-statement into a proper case statement (unless
I've misread the code), e.g. with some opportunstic cleanup:

	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
		last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
		if (msr > last_msr)
			return 1;

		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
					    last_msr + 1 - MSR_IA32_MC0_CTL);

		/*
		 * Only 0 or all 1s can be written to IA32_MCi_CTL, though some
		 * Linux kernels clear bit 10 in bank 4 to workaround a BIOS/GART
		 * TLB issue on AMD K8s, ignore this to avoid an uncatched #GP in
		 * the guest.
		 */
		if ((offset & 0x3) == 0 &&
		    data != 0 && (data | (1 << 10)) != ~(u64)0)
			return -1;

		/* MCi_STATUS */
		if (!msr_info->host_initiated && (offset & 0x3) == 1 &&
		    data != 0 && !can_set_mci_status(vcpu))
			return -1;

		vcpu->arch.mce_banks[offset] = data;
		break;

Actually, rereading that, isn't "return -1" wrong?  That will cause kvm_emulate_wrmsr()
to exit to userspace, not inject a #GP.

*sigh*  Yep, indeed, the -1 gets interpreted as -EPERM and kills the guest.

Scratch the idea of doing the above on top, I'll send separate patches and a KUT
testcase.  I'll Cc you on the patches, it'd save Paolo a merge conflict (or you a
rebase) if this series is based on top of that bugfix + cleanup.

> +		vcpu->arch.mci_ctl2_banks[offset] = data;
> +		break;
>  	default:
>  		if (msr >= MSR_IA32_MC0_CTL &&
>  		    msr < MSR_IA32_MCx_CTL(bank_num)) {
> -			u32 offset = array_index_nospec(
> +			offset = array_index_nospec(
>  				msr - MSR_IA32_MC0_CTL,
>  				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
>  
> @@ -3489,7 +3502,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  		}
>  		break;
> -	case 0x200 ... 0x2ff:
> +	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> +	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
>  		return kvm_mtrr_set_msr(vcpu, msr, data);
>  	case MSR_IA32_APICBASE:
>  		return kvm_set_apic_base(vcpu, msr_info);
> @@ -3646,6 +3660,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_MCG_CTL:
>  	case MSR_IA32_MCG_STATUS:
>  	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>  		return set_msr_mce(vcpu, msr_info);
>  
>  	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> @@ -3750,6 +3765,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>  	u64 data;
>  	u64 mcg_cap = vcpu->arch.mcg_cap;
>  	unsigned bank_num = mcg_cap & 0xff;
> +	u32 offset;
>  
>  	switch (msr) {
>  	case MSR_IA32_P5_MC_ADDR:
> @@ -3767,10 +3783,18 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>  	case MSR_IA32_MCG_STATUS:
>  		data = vcpu->arch.mcg_status;
>  		break;
> +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:

Same comments as the WRMSR path.  I'll also handle the "default" case in my cleanup.

> +		if (!(mcg_cap & MCG_CMCI_P) && !host)
> +			return 1;
> +		offset = array_index_nospec(
> +				msr - MSR_IA32_MC0_CTL2,
> +				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
> +		data = vcpu->arch.mci_ctl2_banks[offset];
> +		break;
>  	default:
>  		if (msr >= MSR_IA32_MC0_CTL &&
>  		    msr < MSR_IA32_MCx_CTL(bank_num)) {
> -			u32 offset = array_index_nospec(
> +			offset = array_index_nospec(
>  				msr - MSR_IA32_MC0_CTL,
>  				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
>  

...

> @@ -11126,9 +11152,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  		goto fail_free_lapic;
>  	vcpu->arch.pio_data = page_address(page);
>  
> -	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
> +	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
> +				       GFP_KERNEL_ACCOUNT);

Switching to kcalloc() should be a separate patch.

> +	vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
>  				       GFP_KERNEL_ACCOUNT);
> -	if (!vcpu->arch.mce_banks)
> +	if (!vcpu->arch.mce_banks | !vcpu->arch.mci_ctl2_banks)

This wants to be a logical-OR, not a bitwise-OR.

Oh, and vcpu->arch.mci_ctl2_banks needs to be freed if a later step fails.

>  		goto fail_free_pio_data;
>  	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
>  
> -- 
> 2.35.1.1178.g4f1659d476-goog
> 
