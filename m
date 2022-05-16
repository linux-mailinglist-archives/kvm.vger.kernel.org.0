Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA152862A
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 15:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244236AbiEPN6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 09:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244192AbiEPN6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 09:58:16 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3303A1AC
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 06:58:07 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id n10so14537428pjh.5
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 06:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N6cpZam/M/XKxRuKp/6fbfT6Vs1erHH3zjEgge2faf0=;
        b=khv0o+3MVYNYERJ+hfeAt/OkcOafq35SOY+tNc3oVpCkvxhXEq9e2qIQDYVq96PpQT
         +cuxNol8CCVp33079jM//mpFtUa7eA/krfHws7sbxpraTgXKS1rz010nQgDHUTAvS1n4
         ziXbmG0JYN71C5Ut2Iw81ZreHZDzBJqF5QWmMXUnGpkZue//6JDBypHrMY0OE7X1LWkI
         9f0p2hcOsfXWxKdka+ONh3KQDQo3sGgjHcTUh35DkH5zzoZv87s4ahmsWvaGYe63CZAp
         QwJToKm2nIZ8WxRn6zK82AIKgruUF88iMx35EFDus7d67gT7GqTVHOYlLY1RnIyqNtoQ
         aDSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N6cpZam/M/XKxRuKp/6fbfT6Vs1erHH3zjEgge2faf0=;
        b=DrLD3Nt77ETVMRFGiIsqYCNswFLm2OhlaqF/IOnDDtw0gyne0YJlswgZ0GRMe03a2Z
         PhFc+xMOuRNkgmCGjLjndirSK9UZjd+sM4u7c61mXZjGCNGhOiIUkq01jV6irGMtB94m
         LkzcXe7mYWK4EN1D5alT7JnqKf6rnnx2OQUoIlPvBunj5RFw+NUoekaNdBbKIETfMtgk
         r+v89pMdsJD4vnDzo6i9y6U3Fu/wjQlQsZIaGiZLHKZ7zWGxui8cTcU2jpWreQrxeYKJ
         iQnuyT9rIjuIKnCI/T971s3aiGY4KJdK+tNDSRpa5RSNcSMhq1qoblGzex8KbC5gKTgt
         w1wg==
X-Gm-Message-State: AOAM530PqHv76LhIJ8Mhe7ATfIBGCC4tAiq/iYYWA98MOJx79FPPBMK/
        AQk2rgTZykEOGhfmZh5qj5FDGg==
X-Google-Smtp-Source: ABdhPJxjPTFJsuPLS/dq8WerHcw3/P8IKjsW6K0Io+IkGGa3+7knYweiV4hF4oJi+M3FINn56qLoWQ==
X-Received: by 2002:a17:903:2348:b0:15f:2b4a:29c2 with SMTP id c8-20020a170903234800b0015f2b4a29c2mr17894677plh.37.1652709486582;
        Mon, 16 May 2022 06:58:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x5-20020a63cc05000000b003dafd8f0760sm6769367pgf.28.2022.05.16.06.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 06:58:06 -0700 (PDT)
Date:   Mon, 16 May 2022 13:58:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yanfei Xu <yanfei.xu@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix the intel_pt PMI handling wrongly
 considered from guest
Message-ID: <YoJYah+Ct90aj1I5@google.com>
References: <20220515171633.902901-1-yanfei.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220515171633.902901-1-yanfei.xu@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022, Yanfei Xu wrote:
> When kernel handles the vm-exit caused by external interrupts and PMI,
> it always set a type of kvm_intr_type to handling_intr_from_guest to
> tell if it's dealing an IRQ or NMI.
> However, the further type judgment is missing in kvm_arch_pmi_in_guest().
> It could make the PMI of intel_pt wrongly considered it comes from a
> guest once the PMI breaks the handling of vm-exit of external interrupts.
> 
> Fixes: db215756ae59 ("KVM: x86: More precisely identify NMI from guest when handling PMI")
> Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 8 +++++++-
>  arch/x86/kvm/x86.h              | 6 ------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4ff36610af6a..308cf19f123d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1582,8 +1582,14 @@ static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>  		return -ENOTSUPP;
>  }
>  
> +enum kvm_intr_type {
> +	/* Values are arbitrary, but must be non-zero. */
> +	KVM_HANDLING_IRQ = 1,
> +	KVM_HANDLING_NMI,
> +};
> +
>  #define kvm_arch_pmi_in_guest(vcpu) \
> -	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
> +	((vcpu) && (vcpu)->arch.handling_intr_from_guest == KVM_HANDLING_NMI)

My understanding is that this isn't correct as a general change, as perf events
can use regular IRQs in some cases.  See commit dd60d217062f4 ("KVM: x86: Fix perf
timer mode IP reporting").

I assume there's got to be a way to know which mode perf is using, e.g. we should
be able to make this look something like:

	((vcpu) && (vcpu)->arch.handling_intr_from_guest == kvm_pmi_vector)


>  void kvm_mmu_x86_module_init(void);
>  int kvm_mmu_vendor_module_init(void);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 588792f00334..3bdf1bc76863 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -344,12 +344,6 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
>  	return kvm->arch.cstate_in_guest;
>  }
>  
> -enum kvm_intr_type {
> -	/* Values are arbitrary, but must be non-zero. */
> -	KVM_HANDLING_IRQ = 1,
> -	KVM_HANDLING_NMI,
> -};
> -
>  static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu,
>  					enum kvm_intr_type intr)
>  {
> -- 
> 2.32.0
> 
