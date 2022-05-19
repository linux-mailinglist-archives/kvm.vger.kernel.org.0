Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9A352DAB3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbiESQz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241988AbiESQzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:55:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AE2663C7
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:55:22 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i24so5643582pfa.7
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fbRv1nP7pTqnBz+sNfZ4tvpe8QTnEEoJ7rGEyN4925Q=;
        b=NlEMnrL1wW3fdyUxfE79H9YKA08o4qU+R83BNF4EgYN1cw3zLCwLQRh0UUNy8jsgaW
         lh5GqvoVBqk+o21K5cK+qXjAuNRBqngjQJpCjNtE0H22z4d7gNLw9px10kbPevPTCOZo
         cm+d0+5Tl4z0B20qtEo97MXoLONED9j4gMp06GLYi8IioDmsnUosJWwH3R2UXeI50B+Y
         Dfz9rAnYpYkgl9qP8KnBJnRgCxNPwNbXvT5v7eDKy4noIKvXGL5S6mBSB33tJTkWiaIL
         eywS3+VPl8lSdoz2EXE2fdPxXfmOKy58HyUzW2znCkVQe921F9Kzhs0rUpz/ac4b69yM
         G7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fbRv1nP7pTqnBz+sNfZ4tvpe8QTnEEoJ7rGEyN4925Q=;
        b=Ga4oLy1YlXJVucH1JDJBOhNa6cW8tAbTkA0WHLXObCOHUbFryRom5CWKtqC9tFJaNU
         FpV/jsjR8tk39LC++Wpbh+iRTaN0J31V52XtVr7FmXnwT/y4IJOEXgViF7zmc7xJE5ec
         DUfLc0cH7Zt6YMueQ+ZCXBDsxIZfSTOALKMPkjyMXKZSDLR+jpTcOPhYhmsQmnrwq5He
         Jrr9jci0yR4j+gvP/i36HHgTMu+CIyEH51/yVn1cc1gJ/GJoLiTqy0wQ7T/ZFfODjDt5
         3qKtXdJxzZk9bgLRQG/pOzgsyB3xD23S43WJTY9ca4PzcaaTGRIQKFsaQ8WG0lYzV9Qw
         pxLQ==
X-Gm-Message-State: AOAM532C4p87kRDVA/nJf1PTD88/3g5qe4ms5dx/AQz7uoATOoox3gqy
        054VDpgie1hsIFyh3woiwbjuT5FLzgQkuw==
X-Google-Smtp-Source: ABdhPJxhTLHIK7S/JfndVkiqYIReuohqOcVCUwV7I1Rl2NWw0SBdey4MuXGnvj/UoimJME0mze89Mg==
X-Received: by 2002:a63:1347:0:b0:3f2:8963:ca0a with SMTP id 7-20020a631347000000b003f28963ca0amr4750270pgt.424.1652979321995;
        Thu, 19 May 2022 09:55:21 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t9-20020aa79389000000b0051829b1595dsm4262274pfe.130.2022.05.19.09.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:55:21 -0700 (PDT)
Date:   Thu, 19 May 2022 16:55:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 14/19] KVM: x86: rename .set_apic_access_page_addr
 to reload_apic_access_page
Message-ID: <YoZ2dh+ZujErT5nk@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-15-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427200314.276673-15-mlevitsk@redhat.com>
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

On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> This will be used on SVM to reload shadow page of the AVIC physid table
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2f73ce87a1e3..ad744ab99734c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9949,12 +9949,12 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>  		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>  }
>  
> -static void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
> +static void kvm_vcpu_reload_apic_pages(struct kvm_vcpu *vcpu)
>  {
>  	if (!lapic_in_kernel(vcpu))
>  		return;
>  
> -	static_call_cond(kvm_x86_set_apic_access_page_addr)(vcpu);
> +	static_call_cond(kvm_x86_reload_apic_pages)(vcpu);
>  }
>  
>  void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
> @@ -10071,7 +10071,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu))
>  			vcpu_load_eoi_exitmap(vcpu);
>  		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
> -			kvm_vcpu_reload_apic_access_page(vcpu);
> +			kvm_vcpu_reload_apic_pages(vcpu);

My vote is to add a new request and new kvm_x86_ops hook instead of piggybacking
KVM_REQ_APIC_PAGE_RELOAD.  The usage in kvm_arch_mmu_notifier_invalidate_range()
very subtlies relies on the memslot and vma being allocated/controlled by KVM.

The use in avic_physid_shadow_table_flush_memslot() is too similar in that it
also deals with memslot changes, but at the same time is _very_ different in that
it's dealing with user controlled memslots.
