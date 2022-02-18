Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527164BBD7D
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237874AbiBRQ3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:29:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbiBRQ3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:29:47 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7285BD2E
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:29:30 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m13-20020a17090aab0d00b001bbe267d4d1so797834pjq.0
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IM/2+LCRnBwBlETtyOQ6tMfj541R3srotOuDDw7AKd4=;
        b=jbLeCTL7uGnFnam5Oj94kEFSX7Z/4IIJEoP4W46A9eUJzPRbpWS6PHGUiIDBJNcWa1
         5D71MDvTTcbym6lOtyWDAd0mMz/gWPfS80dELeultve59mL23j3A+UCMUK1S6GcswgQn
         L52lbFb5xWPYu0zwbUNzswEgYD7QzSJr7xHCQMKjUn8KvpYNa1D7igV+FwOtPc3GvWkM
         294Kihi5R/Y1yEZCKb5gb+M0AVWtuLbvWVWUOLMFgCZMf0tuxnxGIMkoo90PFy7oEKco
         hUGHv/VlBTCwJrnE5PWxeVaX1XSP1jNwa+1Zz323VfutRPkleH1CAZn3c9T42bu9KoMk
         yyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IM/2+LCRnBwBlETtyOQ6tMfj541R3srotOuDDw7AKd4=;
        b=8HXi1M+x8G+EtA73JuQofGcUFrmF7G21zivYGrKM4ifKRwwriKaYanIwxghR6eidxe
         5oiC3oPqZl45esUwk+rpK6VWQ/judbUYqXEXwJo0NWAye4SM9kpa0X1LvopLh2zUIw5J
         WICK0U6/xETenA95CRSVUWOBatKTDyNC6YQw6qhmrfxs7XaF7j5uNxnDKScfrAfHW16q
         SpgQMRyTOhNjMa+rBrZeidM/W4gd/aH3AT9dsznGlmsOnp1MlnIHVluBbifgYTp0AVSM
         +AKpSxGQLzXA8Uu5vVbEO2qBQv3QK4CkuBLlA074BkH18gdeZhihNU/d+WBYb0R045ph
         cXiw==
X-Gm-Message-State: AOAM531Wz5FQqXNhFx9JBRVtuviJc3ermuU3x0P60qIsXfpFKFT/YgYo
        aPQP+ljSEWvBJ+LRhptuT0QewWxbZ9LAEA==
X-Google-Smtp-Source: ABdhPJwgthkvW072K2HIaeRND5ZZua6z8HKJ8Gade9siRk2cxiCwayXURG9BFbtaUjkPQ/qqyK9new==
X-Received: by 2002:a17:902:eb8e:b0:14d:9788:1461 with SMTP id q14-20020a170902eb8e00b0014d97881461mr8397501plg.129.1645201769333;
        Fri, 18 Feb 2022 08:29:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w198sm3711928pff.96.2022.02.18.08.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 08:29:28 -0800 (PST)
Date:   Fri, 18 Feb 2022 16:29:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 6/6] KVM: x86: allow defining return-0 static calls
Message-ID: <Yg/JZZ+i67HDKCVK@google.com>
References: <20220217180831.288210-1-pbonzini@redhat.com>
 <20220217180831.288210-7-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217180831.288210-7-pbonzini@redhat.com>
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

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> A few vendor callbacks are only used by VMX, but they return an integer
> or bool value.  Introduce KVM_X86_OP_OPTIONAL_RET0 for them: if a func is
> NULL in struct kvm_x86_ops, it will be changed to __static_call_return0
> when updating static calls.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h | 15 +++++++++------
>  arch/x86/include/asm/kvm_host.h    |  4 ++++
>  arch/x86/kvm/svm/avic.c            |  5 -----
>  arch/x86/kvm/svm/svm.c             | 20 --------------------
>  arch/x86/kvm/x86.c                 |  2 +-
>  kernel/static_call.c               |  1 +
>  6 files changed, 15 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c0ec066a8599..29affccb353c 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -10,7 +10,9 @@ BUILD_BUG_ON(1)
>   *
>   * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
>   * a NULL definition, for example if "static_call_cond()" will be used
> - * at the call sites.
> + * at the call sites.  KVM_X86_OP_OPTIONAL_RET0() can be used likewise
> + * to make a definition optional, but in this case the default will
> + * be __static_call_return0.

__static_call_return0()

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ab1c4778824a..d3da64106685 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -131,6 +131,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
>  				*(((struct kvm_x86_ops *)0)->func));
>  #define KVM_X86_OP_OPTIONAL KVM_X86_OP
> +#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
>  #include <asm/kvm-x86-ops.h>
>  EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
>  EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
> @@ -12016,7 +12017,6 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return (is_guest_mode(vcpu) &&
> -			kvm_x86_ops.guest_apic_has_interrupt &&
>  			static_call(kvm_x86_guest_apic_has_interrupt)(vcpu));

Can you opportunistically align the indentation and drop the outer parantheses? I.e.

	return is_guest_mode(vcpu) &&
	       static_call(kvm_x86_guest_apic_has_interrupt)(vcpu);

>  }
>  
> diff --git a/kernel/static_call.c b/kernel/static_call.c
> index 43ba0b1e0edb..76abd46fe6ee 100644
> --- a/kernel/static_call.c
> +++ b/kernel/static_call.c
> @@ -503,6 +503,7 @@ long __static_call_return0(void)
>  {
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(__static_call_return0)

This doesn't compile, it needs a semicolon.
