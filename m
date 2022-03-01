Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC1B4C9032
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 17:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbiCAQVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 11:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiCAQVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 11:21:54 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3742B26E
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 08:21:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gb21so14492356pjb.5
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 08:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OyJ09A7qvWy9g8jkfUxvXZf1yir4cGwLA0viw7De7Wg=;
        b=merrIRFvjJolhv/qG/VrKrlxkqICVo4jfOaOwHQ3w/OWhJhS6O7KF09ulMKke6G/2s
         6tSBtnnig1rn98zTnGLcdqRkMixBrnTcmqPT6VADYi0HZDEMRuvaCVX+GPzcqhzMjFEx
         HqDGzRSOfhDv7qFjN6wgeNKzHai7v54XqjlJ6G+CPZyIEPM3xjgmaDS4SV5kP4YSTaiC
         7RNkb9k1FNp067iM6ipgig9dgxR4eJZ5kyPxMYnLr8z0uWQ/jhhN70pngkdQjA3RWeHl
         pSRWVct/xCwMZLSvowLzyYU5DWqZwJWP+8h24iOInGHOJlrcJUDfY5qs5kbhSidonEgS
         506Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OyJ09A7qvWy9g8jkfUxvXZf1yir4cGwLA0viw7De7Wg=;
        b=qdDbEyIAFtc9XpmTICe6NhkuK1Zz1yf0ZlrGCMJXW0P9an/9F8ZqnXu6rq0QoAIspO
         EM/VUJI8O17eUduKYrw720vuol7yhLXn+NBtfGs3ON79V2Ccq5kSZEfKWvVyB6eaLdi5
         16+EOUSNgeE9wlGmL1jreZMgMvIEWygrdjzjzH4Nyn+o1B29yrUz7bRJVO7Jw5ew4Qlb
         904vhIHtDGSmrAlxkeHjGeExUeYtTPDdtKtytGx7jt1sgoxRDAjy2MnUgraIRbJ4r41V
         IKxBeuTCYjrFzEeK7rBQ8I/eCkx4yAxSR8RLOfgxYMIWrQdwN0rxOzocVWjnWkWR32+2
         AlOg==
X-Gm-Message-State: AOAM5316hsASnELzdAvs1okE1N50SslFCplWK15wtQ9P/9z16NZJn44g
        pdWtQpkMaLx8QK4vIPT4DdYzWg==
X-Google-Smtp-Source: ABdhPJzrKSENplSPF1BCssuAgeos2pr1muB+975Yz7lx+H0xV0J5vTBBuAUbdF4sRGsHnUZDAztFKQ==
X-Received: by 2002:a17:902:7048:b0:151:6d4b:6118 with SMTP id h8-20020a170902704800b001516d4b6118mr9909600plt.50.1646151670176;
        Tue, 01 Mar 2022 08:21:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t1-20020a634441000000b00372cb183243sm13330538pgk.1.2022.03.01.08.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:21:09 -0800 (PST)
Date:   Tue, 1 Mar 2022 16:21:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Subject: Re: [PATCH 3/4] KVM: x86: SVM: use vmcb01 in avic_init_vmcb
Message-ID: <Yh5H8qRhbefuD9YF@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
 <20220301135526.136554-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301135526.136554-4-mlevitsk@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just "KVM: SVM:" for the shortlog, please.

On Tue, Mar 01, 2022, Maxim Levitsky wrote:
> Out of precation use vmcb01 when enabling host AVIC.
> No functional change intended.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/avic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index e23159f3a62ba..9656e192c646b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -167,7 +167,7 @@ int avic_vm_init(struct kvm *kvm)
>  
>  void avic_init_vmcb(struct vcpu_svm *svm)
>  {
> -	struct vmcb *vmcb = svm->vmcb;
> +	struct vmcb *vmcb = svm->vmcb01.ptr;

I don't like this change.  It's not bad code, but it'll be confusing because it
implies that it's legal for svm->vmcb to be something other than svm->vmcb01.ptr
when this is called.

If we want to guard AVIC, I'd much rather we do something like:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa841..dcc856bd628d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -992,8 +992,12 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 static void init_vmcb(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
-       struct vmcb_control_area *control = &svm->vmcb->control;
-       struct vmcb_save_area *save = &svm->vmcb->save;
+       struct vmcb *vmcb = svm->vmcb01.ptr;
+       struct vmcb_control_area *control = &vmcb->control;
+       struct vmcb_save_area *save = &vmcb->save;
+
+       if (WARN_ON_ONCE(vmcb != svm->vmcb))
+               svm_leave_nested(vcpu);

        svm_set_intercept(svm, INTERCEPT_CR0_READ);
        svm_set_intercept(svm, INTERCEPT_CR3_READ);


On a related topic, init_vmcb_after_set_cpuid() is broken for nested, it needs to
play nice with being called when svm->vmcb == &svm->nested.vmcb02, e.g. update
vmcb01 and re-merge (or just recalc?) vmcb02's intercepts.

>  	struct kvm_svm *kvm_svm = to_kvm_svm(svm->vcpu.kvm);
>  	phys_addr_t bpa = __sme_set(page_to_phys(svm->avic_backing_page));
>  	phys_addr_t lpa = __sme_set(page_to_phys(kvm_svm->avic_logical_id_table_page));
> -- 
> 2.26.3
> 
