Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB8557E2D
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 16:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiFWOuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 10:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiFWOuK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 10:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7346046679
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655995808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XsUzgInIk3jiZ1t4PC5XKhl7+P7b0ZJHNMM8H/4Lgb0=;
        b=G1b0DroLI3+5IBzs2D7Re9S+IIuCr8WCtWRCZMUxM7r1LDvELo92kwb3EUabcjEk/EuaGd
        bhvJKFucBp3ds9BmGOry/D6mcu2zEKqwXWcKHC/quNpAHsgrJ2i5veBZAR5aSI+SWUL4PT
        nOVkyYbaJ2ylqxc/4CgT+TWQnteALDA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-4naS711kNJuc4SMJOVaJ1Q-1; Thu, 23 Jun 2022 10:50:04 -0400
X-MC-Unique: 4naS711kNJuc4SMJOVaJ1Q-1
Received: by mail-ed1-f71.google.com with SMTP id t14-20020a056402524e00b0043595a18b91so6478435edd.13
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 07:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XsUzgInIk3jiZ1t4PC5XKhl7+P7b0ZJHNMM8H/4Lgb0=;
        b=UpywI0YwU5CURFpQSn9lrxCe+5t5cV2uhplgNC2VKm7kbLePr1di8UFw4MVyUAS5E0
         sia1LVHD7Ri6FE9mZj3mc4kIHdP4b9Rl/1Z2/MvyB00j7mtKt1LuCM892PCD6ISbMLJn
         8wGThits77mB+lh5vLu2FJmVWoP8kNedxkEGGruzFqRwKIO1SjnYD9maDmYZ66jA0EvI
         c+4n3aeDUYGuM08hvEHX2htcWvp2QIuH7Rb/KMaJlqwdLUZtbbGQCId4s2X5th0NAulV
         r2V/Bt6DxHZ+myj9xvlhR+v4blPxxIMI5Rerunw6LjDcQBe3A485GOnI1X5oSov0NhWJ
         5Bgg==
X-Gm-Message-State: AJIora92OjO4nadF7vUb8IU3Nqp9jKq+F+GWSMmQPF8qSDbh0ZPhGoq8
        p8Ax+iUCkljEGW+EviowuxcyoCsI5Qu+P/nZOJk0I4T1n87NiYoLIoW6mFctQBobnsTHF9Cm0lZ
        F3keWHHNNy9bG
X-Received: by 2002:a05:6402:34cf:b0:435:a0b1:ae14 with SMTP id w15-20020a05640234cf00b00435a0b1ae14mr11192292edc.67.1655995803175;
        Thu, 23 Jun 2022 07:50:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1thQYBHEBmaRr7+ACAivoeMG9YF2NCID7VcMCZ29wz7mVQ3jCRGgp+p58BlvZ9mwrEmn6kIkw==
X-Received: by 2002:a05:6402:34cf:b0:435:a0b1:ae14 with SMTP id w15-20020a05640234cf00b00435a0b1ae14mr11192269edc.67.1655995802931;
        Thu, 23 Jun 2022 07:50:02 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m11-20020aa7d34b000000b00435a742e350sm4329642edr.75.2022.06.23.07.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:50:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2] MAINTAINERS: Reorganize KVM/x86 maintainership
In-Reply-To: <20220623143059.2626661-1-pbonzini@redhat.com>
References: <20220623143059.2626661-1-pbonzini@redhat.com>
Date:   Thu, 23 Jun 2022 16:50:01 +0200
Message-ID: <87tu8bwi1y.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> For the last few years I have been the sole maintainer of KVM, albeit
> getting serious help from all the people who have reviewed hundreds of
> patches.  The volume of KVM x86 alone has gotten to the point where one
> maintainer is not enough; especially if that maintainer is not doing it
> full time and if they want to keep up with the evolution of ARM64 and
> RISC-V at both the architecture and the hypervisor level.
>
> So, this patch is the first step in restoring double maintainership
> or even transitioning to the submaintainer model of other architectures.
>
> The changes here were mostly proposed by Sean offlist and they are twofold:
>
> - revisiting the set of KVM x86 reviewers.  It's important to have an
>   an accurate list of people that are actively reviewing patches ("R"),
>   as well as people that are able to act on bug reports ("M").  Otherwise,
>   voids to be filled are not easily visible.  The proposal is to split
>   KVM on Hyper-V, which is where Vitaly has been the main contributor
>   for quite some time now; likewise for KVM paravirt support, which
>   has been the main interest of Wanpeng and to which Vitaly has also
>   contributed (e.g., for async page faults).  Jim and Joerg have not been
>   particularly active (though Joerg has worked on guest support for AMD
>   SEV); knowing them a bit, I can't imagine they would object to their
>   removal or even be surprised, but please speak up if you do.
>
> - promoting Sean to maintainer for KVM x86 host support.  While for
>   now this changes little, let's treat it as a harbinger for future
>   changes.  The plan is that I would keep the final integration testing
>   for quite some time, and probably focus more on -rc work.  This will
>   give me more time to clean up my ad hoc setup and moving towards a
>   more public CI, with Sean focusing instead on next-release patches,
>   and the testing up to where kvm-unit-tests and selftests pass.  In
>   order to facilitate collaboration between Sean and myself, we'll
>   also formalize a bit more the various branches of kvm.git.
>
> Nothing is going to change with respect to handling pull requests to Linus
> and from other architectures, as well as maintainance of the generic code
> (which I expect and hope to be more important as architectures try to
> share more code) and documentation.  However, it's not a coincidence
> that my entry is now the last for x86, ready to be demoted to reviewer
> if/when the right time comes.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 97014ae3e5ed..968b622bc3ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10897,28 +10897,50 @@ F:	tools/testing/selftests/kvm/*/s390x/
>  F:	tools/testing/selftests/kvm/s390x/
>  
>  KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
> +M:	Sean Christopherson <seanjc@google.com>
>  M:	Paolo Bonzini <pbonzini@redhat.com>
> -R:	Sean Christopherson <seanjc@google.com>
> -R:	Vitaly Kuznetsov <vkuznets@redhat.com>
> -R:	Wanpeng Li <wanpengli@tencent.com>
> -R:	Jim Mattson <jmattson@google.com>
> -R:	Joerg Roedel <joro@8bytes.org>
>  L:	kvm@vger.kernel.org
>  S:	Supported
> -W:	http://www.linux-kvm.org
>  T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>  F:	arch/x86/include/asm/kvm*
> -F:	arch/x86/include/asm/pvclock-abi.h
>  F:	arch/x86/include/asm/svm.h
>  F:	arch/x86/include/asm/vmx*.h
>  F:	arch/x86/include/uapi/asm/kvm*
>  F:	arch/x86/include/uapi/asm/svm.h
>  F:	arch/x86/include/uapi/asm/vmx.h
> -F:	arch/x86/kernel/kvm.c
> -F:	arch/x86/kernel/kvmclock.c
>  F:	arch/x86/kvm/
>  F:	arch/x86/kvm/*/
>  
> +KVM PARAVIRT (KVM/paravirt)
> +M:	Paolo Bonzini <pbonzini@redhat.com>
> +R:	Wanpeng Li <wanpengli@tencent.com>
> +R:	Vitaly Kuznetsov <vkuznets@redhat.com>
> +L:	kvm@vger.kernel.org
> +S:	Supported
> +T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:	arch/x86/kernel/kvm.c
> +F:	arch/x86/kernel/kvmclock.c
> +F:	arch/x86/include/asm/pvclock-abi.h
> +F:	include/linux/kvm_para.h
> +F:	include/uapi/linux/kvm_para.h
> +F:	include/uapi/asm-generic/kvm_para.h
> +F:	include/asm-generic/kvm_para.h
> +F:	arch/um/include/asm/kvm_para.h
> +F:	arch/x86/include/asm/kvm_para.h
> +F:	arch/x86/include/uapi/asm/kvm_para.h
> +
> +KVM X86 HYPER-V (KVM/hyper-v)
> +M:	Vitaly Kuznetsov <vkuznets@redhat.com>
> +M:	Sean Christopherson <seanjc@google.com>
> +M:	Paolo Bonzini <pbonzini@redhat.com>
> +L:	kvm@vger.kernel.org
> +S:	Supported
> +T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:	arch/x86/kvm/hyperv.*
> +F:	arch/x86/kvm/kvm_onhyperv.*
> +F:	arch/x86/kvm/svm/svm_onhyperv.*

"arch/x86/kvm/svm/hyperv.*" is still missing) LGTM otherwise, and as it
has my name:

Acked-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> +F:	arch/x86/kvm/vmx/evmcs.*
> +
>  KERNFS
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  M:	Tejun Heo <tj@kernel.org>

-- 
Vitaly

