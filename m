Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E439865DCD8
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 20:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbjADTe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 14:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbjADTez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 14:34:55 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7F83C3AF
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 11:34:54 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a184so12809142pfa.9
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 11:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hec4l6+at5WSRcm7OYvARniaVMgLC26qEPf8vcDcszw=;
        b=lAfdpdRAWCHlsIepuddv34x9a8FqsGMAnXmLXaUtAv2nYJENBdHCf6oGBuVHkOjQjH
         EDqn7eTzgEfaRUJoy1w7rl0Pe4T+iZhj/dp2m8DMo/s9BBdQaRm3+Tur4By66hSmxtR6
         44IbGgoazsxg5JG7IkyHCUL1TFVLCRXWR/ludEle/oXzWhSL47e1blotcrmF9o17mHDX
         mjXtkCBFpPdMOH4t3ePqxZ4eIynrgSnEZf1VIbIR1D17Zz3Di3acZ2KZ1xpV3X9Bata8
         hXGoPEaQEpG1moN6GDs64l8VPW/u5i9rKgL8w41Y5ja256ZpPF0oc5aRU4yz0RQltWgH
         2KEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hec4l6+at5WSRcm7OYvARniaVMgLC26qEPf8vcDcszw=;
        b=uk+sDVVqCXqAgCDtK2pNDANTSNtRxFcG6tmL/J1W1rC5wFjIbGPhgsQqei3eGXT4bc
         S1xybEbmuBM8P/WYsVLK/ed2mVAbemm77YTy3vfnUxq0njN514Allv8RVQGjtA4xW/Ww
         NabncIW7fGGQshksTmZe8tKsp+ncuMiftsg/6iyBjSRj0CTXR/ZS1cK3mGE3v5BpM/uY
         yZ8rVuVr1kbGlglslYTwzRFbZJnxWxYFK0lLJqDtZrn7/dOajfdFokbR4diKJNjLYQcu
         +ntMEh8sLcEKqwWJDfPGuF0IFGUJlWfXr0hGsVWZWlu1kM+Kt0rlqTdiLsp80QZHtEbp
         /kqA==
X-Gm-Message-State: AFqh2kqCeikzF0gf5cLGSsroM5it5ihiylxxNbmKIvmXiUq6aixb5HrE
        SBGmEe6ENEUfq7bI5liqMq/JSQ==
X-Google-Smtp-Source: AMrXdXsy0gl5nkmrz2u2oeezJO6bgxcJOrlyv+1OHKLZ3HSm4tTUeMsCNRHvqfcfkmnVN/Li5pjVtw==
X-Received: by 2002:aa7:8084:0:b0:574:8995:c0d0 with SMTP id v4-20020aa78084000000b005748995c0d0mr3883534pff.1.1672860893603;
        Wed, 04 Jan 2023 11:34:53 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x24-20020aa78f18000000b0058134d2df41sm17961993pfr.146.2023.01.04.11.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 11:34:53 -0800 (PST)
Date:   Wed, 4 Jan 2023 19:34:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v6 1/2] KVM: x86/cpuid: generalize
 kvm_update_kvm_cpuid_base() and also capture limit
Message-ID: <Y7XU2R0f3pCYF9uz@google.com>
References: <20221220134053.15591-1-pdurrant@amazon.com>
 <20221220134053.15591-2-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220134053.15591-2-pdurrant@amazon.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022, Paul Durrant wrote:
> A sunsequent patch will need to acquire the CPUID leaf range for emulated
> Xen so explicitly pass the signature of the hypervisor we're interested in
> to the new function. Also introduce a new kvm_hypervisor_cpuid structure
> so we can neatly store both the base and limit leaf indices.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> ---
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> 
> v6:
>  - New in this version
> ---
>  arch/x86/include/asm/kvm_host.h |  7 ++++++-
>  arch/x86/kvm/cpuid.c            | 15 ++++++++-------
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f35f1ff4427b..ff201ad35551 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -710,6 +710,11 @@ struct kvm_queued_exception {
>  	bool has_payload;
>  };
>  
> +struct kvm_hypervisor_cpuid {
> +	u32 base;
> +	u32 limit;
> +};

Probably makes sense to place this above "struct kvm_vcpu_xen" right away to
avoid the (very minor) churn.

>  struct kvm_vcpu_arch {
>  	/*
>  	 * rip and regs accesses must go through
> @@ -826,7 +831,7 @@ struct kvm_vcpu_arch {
>  
>  	int cpuid_nent;
>  	struct kvm_cpuid_entry2 *cpuid_entries;
> -	u32 kvm_cpuid_base;
> +	struct kvm_hypervisor_cpuid kvm_cpuid;
>  
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0b5bf013fcb8..2468720f8d84 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -180,12 +180,13 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>  	return 0;
>  }
>  
> -static void kvm_update_kvm_cpuid_base(struct kvm_vcpu *vcpu)
> +static void kvm_update_hypervisor_cpuid(struct kvm_vcpu *vcpu, const char *hypervisor_signature,

Please wrap.  The 80 char limit is a soft limit, but should still be honored unless
there's a good reason to run over.

I also vote to name the param "sig" to keep line lengths short.

> +					struct kvm_hypervisor_cpuid *hypervisor_cpuid)

Since the struct is a 64-bit value, what about making this a pure getter that
returns a copy?

static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
							    const char *sig)
{
	struct kvm_hypervisor_cpuid cpuid = {};
	struct kvm_cpuid_entry2 *entry;
	u32 function;

	for_each_possible_hypervisor_cpuid_base(cpuid.base) {
		entry = kvm_find_cpuid_entry(vcpu, function);

		if (entry) {
			u32 signature[3];

			signature[0] = entry->ebx;
			signature[1] = entry->ecx;
			signature[2] = entry->edx;

			if (!memcmp(signature, sig, sizeof(signature))) {
				cpuid.base = function;
				cpuid.limit = entry->eax;
				break;
			}
		}
	}

	return cpuid;
}


	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
