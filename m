Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9512968D824
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjBGNG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjBGNG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:06:27 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473553A59F;
        Tue,  7 Feb 2023 05:05:47 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id e2so5615937iot.11;
        Tue, 07 Feb 2023 05:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXW6KJjSl/14WnK5/Cozb5DZDDl3Rz7gP+uZX13BYEQ=;
        b=kQre80ZXRD/+STet/ShaaHOWuCYLhnjimY+XyKotPv7kf7CTMARAt6HcUCIfk/dazp
         a5P4x1fTutCe0WLTt4gjd5BRNSCHNBk3+degLasWCbnira/j1WeaqNhMDbq0dqrKGApM
         3Iord7V1i2lkj9PWc1Uqm92dOofWXdoBb+nckyC6W8dtjokqgMuV6ob4j7g19mSB4icx
         FbIZRyDOjp6SU8Y/8oV+z3giUTs6WYYzDTQJh8U6SHQBo6V+kcJqXftC1/1/ZsIGT9sv
         OupNIXTxBl3kHnAA468HqKxiaZzMJqFeK5lBDBeC0svCesNWmonc/Xt6SJV4E4EvDlvu
         kxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXW6KJjSl/14WnK5/Cozb5DZDDl3Rz7gP+uZX13BYEQ=;
        b=i7STw47tgwg70p0d7ocUIUB6z3jO7UY4hTFaH32FsAOP/YSICUxz2c7oVD9s3nJMyu
         4XcTJ5vBxA5rFR/WvjcSTMtehWIxg6Ha42+Gr9fwLQILyXpYJ06fRHPFnzdGJ5Uz57TT
         e31LqwtMwvEgatLVAoPgTvARgYuLqS1EcfvnoD5ECuICwNXkMurUYu/26hLz7oG8EYrO
         Jn281rEwCIWPR6aAte2ELtdd/iZpGLZ0jCIjzYGLQdkuMOnw/7GjfCG734IzDbCmGREg
         UKUsTU4+qIoa79+WZlq+F8CcFBwOUeBd3ZV9Njz+Vsd2nUqlOSmR8KCXbGEuLbrOWiK+
         2JpQ==
X-Gm-Message-State: AO0yUKXYbzCA4PDegaVFFptDVuCpqY6dEZ2l2R9YAEekqK1mEL0SPzTN
        1MzEGgPK0ijubacScnwFXQ0=
X-Google-Smtp-Source: AK7set9VSExZPQRpgj8kPF8t2b8Blfhc41Cf+GeiZjCOQYJkE8FTqJwstgFSOvO9eFEhrOVjsFeNlw==
X-Received: by 2002:a6b:7d4c:0:b0:715:f031:a7f5 with SMTP id d12-20020a6b7d4c000000b00715f031a7f5mr2288236ioq.1.1675775140895;
        Tue, 07 Feb 2023 05:05:40 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id b8-20020a05663805a800b003c29ccd3019sm1174965jar.44.2023.02.07.05.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:05:40 -0800 (PST)
Date:   Tue, 7 Feb 2023 15:05:35 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 4/6] KVM: x86: Make use of kvm_read_cr*_bits() when
 testing bits
Message-ID: <20230207150535.00004453@gmail.com>
In-Reply-To: <20230201194604.11135-5-minipli@grsecurity.net>
References: <20230201194604.11135-1-minipli@grsecurity.net>
        <20230201194604.11135-5-minipli@grsecurity.net>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Feb 2023 20:46:02 +0100
Mathias Krause <minipli@grsecurity.net> wrote:

> Make use of the kvm_read_cr{0,4}_bits() helper functions when we only
> want to know the state of certain bits instead of the whole register.
> 
> This not only makes the intend cleaner, it also avoids a VMREAD in case
> the tested bits aren't guest owned.
                    ^
The patch comment is a little confusing. Not sure if I misunderstood here:

Check the code of kvm_read_cr0_bits

static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
{
        ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
        if ((tmask & vcpu->arch.cr0_guest_owned_bits) &&
            !kvm_register_is_available(vcpu, VCPU_EXREG_CR0))
                static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_CR0);
        return vcpu->arch.cr0 & mask;
}

I suppose the conditions that can avoids a VMREAD is to avoid the vmread in
static_call(kvm_x86_cache_reg):

Conditions are not triggering vmread:

1) The test bits are guest_owned_bits and cache register is available.
2) The test bits are *not* guest_owned bits.

I agree that this makes the intend cleaner, but not sure the later statement
is true in the patch comment. If the test bits are not guest owned, it will
not reach static_call(kvm_x86_cache_reg).
> 
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/pmu.c     | 4 ++--
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d939d3b84e6f..d9922277df67 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -439,9 +439,9 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	if (!pmc)
>  		return 1;
>  
> -	if (!(kvm_read_cr4(vcpu) & X86_CR4_PCE) &&
> +	if (!(kvm_read_cr4_bits(vcpu, X86_CR4_PCE)) &&
>  	    (static_call(kvm_x86_get_cpl)(vcpu) != 0) &&
> -	    (kvm_read_cr0(vcpu) & X86_CR0_PE))
> +	    (kvm_read_cr0_bits(vcpu, X86_CR0_PE)))
>  		return 1;
>  
>  	*data = pmc_read_counter(pmc) & mask;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c8198c8a9b55..d3b49e0b6c32 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5487,7 +5487,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>  		break;
>  	case 3: /* lmsw */
>  		val = (exit_qualification >> LMSW_SOURCE_DATA_SHIFT) & 0x0f;
> -		trace_kvm_cr_write(0, (kvm_read_cr0(vcpu) & ~0xful) | val);
> +		trace_kvm_cr_write(0, (kvm_read_cr0_bits(vcpu, ~0xful) | val));
>  		kvm_lmsw(vcpu, val);
>  
>  		return kvm_skip_emulated_instruction(vcpu);
> @@ -7547,7 +7547,7 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
>  		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>  
> -	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
> +	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
>  		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>  			cache = MTRR_TYPE_WRBACK;
>  		else

