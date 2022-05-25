Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733375341F5
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 19:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245556AbiEYREd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 13:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbiEYREa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 13:04:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACD1A5AA5
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:04:29 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 137so19401659pgb.5
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VkDubMGG5SCRMuHuQsS5DenNW7uQ4digBzOq9qw78dU=;
        b=IFiAsMCbtaaK4caxyL93pN5Zg7/qEiJ8IAhSaR8KOayM4ruJboictF39dqtBvUNN2R
         +DWLV4c4JkSXjo0BSZpbKyu+d8sxIcozAez3/JrOcGg35ngql4dwQBSZtvdrR1MCvEUA
         tw71zmbo/P12QACrbU7rS/QsDRi/RbuMyHNgLnO29m5KVMLtxwnBoXQ1sv7bciJH0wQ9
         Y2TmOJEtjN8uRC4oGAvDIj5Y6o8fCraaPaComfg17q33Y+3lM/1qwhE+zHbDnGqidbtp
         pqKXtT0bbAkG68gpAIq7P6xLsi2rJYpU3wJIVE4ZR26ay1R24a1g6ZVFYzUYwt8+Q29W
         UqCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VkDubMGG5SCRMuHuQsS5DenNW7uQ4digBzOq9qw78dU=;
        b=D49bSUe5n1jt7iYP9XXYVYfZe9s20+lDTVXeCJxuXmBfWGWnC+lNuZOpQrXxJTqTZG
         LxtkEYVBLN8YgWjv+7acsJIY1TE7GN1KEWNCFC9Als7niVIxkZ9sUYYYazygCUEohN4C
         2F0OYGTSZpdwyj0grRmI5l4Sxd9/Q1BrHpx6tKmU/oO0ruprsp7M4UwfBHE9p8JFAXKU
         od6ahTf94KQIPJzKzp93FJiTn7DxLV/oMzAOq/Vspw8WjapeIpQGM4o4Vt5dOPXrnb0m
         JyZ62C7OSuc8KxMfrRnlXEenQHb6Jl/Da1Iv/gHUm1QY/5ahFeMworWUVYkHW43ccu4w
         V0UQ==
X-Gm-Message-State: AOAM531weit4aEjE4UtHr2zZfxbLrkKWZtPYEs2qpvvdXX+bnjphzzPX
        IZ3do6VG2jwfGyW4vC4/WbY73g==
X-Google-Smtp-Source: ABdhPJzEn8wwx3OZB4S7CQBD3uuo9Aqp+I2lhgGC8u1pQXAaFVNKWAeVk1ybEkX3hf0O13RBwLCvvQ==
X-Received: by 2002:a65:4506:0:b0:3db:48b1:9ff5 with SMTP id n6-20020a654506000000b003db48b19ff5mr30116781pgq.89.1653498269065;
        Wed, 25 May 2022 10:04:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mm23-20020a17090b359700b001cd4989fec6sm1861910pjb.18.2022.05.25.10.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:04:28 -0700 (PDT)
Date:   Wed, 25 May 2022 17:04:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: VMX: do not disable interception for
 MSR_IA32_SPEC_CTRL on eIBRS
Message-ID: <Yo5hmcdRvE1UrI4y@google.com>
References: <20220520204115.67580-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520204115.67580-1-jon@nutanix.com>
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

On Fri, May 20, 2022, Jon Kohler wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 610355b9ccce..1c725d17d984 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2057,20 +2057,32 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
> 
>  		vmx->spec_ctrl = data;
> -		if (!data)
> +
> +		/*
> +		 * Disable interception on the first non-zero write, unless the
> +		 * guest is hosted on an eIBRS system and setting only

The "unless guest is hosted on an eIBRS system" blurb is wrong and doesn't match
the code.  Again, it's all about whether eIBRS is advertised to the guest.  With
some other minor tweaking to wrangle the comment to 80 chars...

		/*
                 * Disable interception on the first non-zero write, except if
		 * eIBRS is advertised to the guest and the guest is enabling
		 * _only_ IBRS.  On eIBRS systems, kernels typically set IBRS
		 * once at boot and never touch it post-boot.  All other bits,
		 * and IBRS on non-eIBRS systems, are often set on a per-task
		 * basis, i.e. change frequently, so the benefit of avoiding
		 * VM-exits during guest context switches outweighs the cost of
		 * RDMSR on every VM-Exit to save the guest's value.
		 */

> +		 * SPEC_CTRL_IBRS, which is typically set once at boot and never

Uber nit, when it makes sense, avoid regurgitating the code verbatim, e.g. refer
to "setting SPEC_CTRL_IBRS" as "enabling IBRS".  That little bit of abstraction
can sometimes help unfamiliar readers understand the effect of the code, whereas
copy+pasting bits of the code doesn't provide any additional context.

> +		 * touched again.  All other bits are often set on a per-task
> +		 * basis, i.e. may change frequently, so the benefit of avoiding
> +		 * VM-exits during guest context switches outweighs the cost of
> +		 * RDMSR on every VM-Exit to save the guest's value.
> +		 */
> +		if (!data ||
> +			(data == SPEC_CTRL_IBRS &&
> +			 (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)))

Align the two halves of the logical-OR, i.e.

		if (!data ||
		    (data == SPEC_CTRL_IBRS &&
		     (vcpu->arch.arch_capabilities & ARCH_CAP_IBRS_ALL)))
			break;
