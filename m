Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E782EB13F
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 18:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbhAERUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 12:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAERUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 12:20:51 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660E9C061793
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 09:20:11 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id iq13so15991pjb.3
        for <kvm@vger.kernel.org>; Tue, 05 Jan 2021 09:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1pPTiUUmwCILGPwhqjMlwzdtjWGk5FIG2OkWDCPGKCI=;
        b=St40kywpxzGWUQJd/PTqmSp7Jly2sPjPC7KB2YdngnWIp+3e+N0nbh2JSmwihXWJCR
         mUUSEIaD5/Sjrp0JY0tqAbfaEBzr7JfQzxJFtQ3njvG6I8mV2BoW7Co2RIzbgA7CzlxQ
         rIsaSONJQQTKM0qbal8BS+leW3BfFGo0FrYU5DnlXlOXDXE7IcC2eOELl16KFSSR0mfF
         fo6VkDbLSTUl9X6jh5OBzSspXl+2SCBX2HADmvsYAizYZ5boi3ThNvZjypkPl+lxdekC
         tM8d4NUFKIvYicaYOIxBDVVym8Px2ENHemIRqsbXkQJeeP5WZ8t/t11IF1oiECO8rgtn
         SNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1pPTiUUmwCILGPwhqjMlwzdtjWGk5FIG2OkWDCPGKCI=;
        b=KXcuNcQQh7YLEn7OjbyJppJ2v3+EVAZU7VL3xeNalT/VZzx67j9t5y+VFaWjpcEaJD
         3ilqVvQG1z6AjIWEFE712f4duN7jgEULr93C3Z3F3Bd6L1VcGNHo7RAHSum3sCRHCiMP
         pKTI9IXjTA8vzr2Tqdt9Ix7RfFufEKHWjQdJCEs7KuiTWZuPrC75JbcVWXbU1zs0XJoc
         8DSaQre0M3CUfYqCgcCQF9AFLQ1U7Sin/59VNSnpxbtbrMlFUhIOR21ZyreEiNeL4STx
         aYcSrFxw2sKOnDaypQeB68FNpN4WSgcTBoInl9sLB+OtfY3Pnjs39YnW3ATlGIZsNwbt
         hw6Q==
X-Gm-Message-State: AOAM533MGaL38WPJfszyi0e6fQJBD9FTun4+OMoCcaGaP5ozK2Fe+ceh
        5INTM9bMmNthu0Xh9qZIlUVBNw==
X-Google-Smtp-Source: ABdhPJw6GzCJksECMVDlqVq/QteStNuKR9J7lDD7rWOeSSJOM7ScY+4Nt3tgCDF+gJbIo/kAKlaOLw==
X-Received: by 2002:a17:902:d916:b029:da:3e9e:cd7c with SMTP id c22-20020a170902d916b02900da3e9ecd7cmr330723plz.27.1609867210796;
        Tue, 05 Jan 2021 09:20:10 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id 14sm7319pfy.55.2021.01.05.09.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 09:20:10 -0800 (PST)
Date:   Tue, 5 Jan 2021 09:20:03 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 1/3] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <X/Sfw15OWarseivB@google.com>
References: <20210105143749.557054-1-michael.roth@amd.com>
 <20210105143749.557054-2-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105143749.557054-2-michael.roth@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 05, 2021, Michael Roth wrote:
> @@ -3703,16 +3688,9 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	if (sev_es_guest(svm->vcpu.kvm)) {
>  		__svm_sev_es_vcpu_run(svm->vmcb_pa);
>  	} else {
> -		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
> -
> -#ifdef CONFIG_X86_64
> -		native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> -#else
> -		loadsegment(fs, svm->host.fs);
> -#ifndef CONFIG_X86_32_LAZY_GS
> -		loadsegment(gs, svm->host.gs);
> -#endif
> -#endif
> +		__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs,
> +			       page_to_phys(per_cpu(svm_data,
> +						    vcpu->cpu)->save_area));

Does this need to use __sme_page_pa()?

>  	}
>  
>  	/*

...

> diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
> index 6feb8c08f45a..89f4e8e7bf0e 100644
> --- a/arch/x86/kvm/svm/vmenter.S
> +++ b/arch/x86/kvm/svm/vmenter.S
> @@ -33,6 +33,7 @@
>   * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
>   * @vmcb_pa:	unsigned long
>   * @regs:	unsigned long * (to guest registers)
> + * @hostsa_pa:	unsigned long
>   */
>  SYM_FUNC_START(__svm_vcpu_run)
>  	push %_ASM_BP
> @@ -47,6 +48,9 @@ SYM_FUNC_START(__svm_vcpu_run)
>  #endif
>  	push %_ASM_BX
>  
> +	/* Save @hostsa_pa */
> +	push %_ASM_ARG3
> +
>  	/* Save @regs. */
>  	push %_ASM_ARG2
>  
> @@ -154,6 +158,12 @@ SYM_FUNC_START(__svm_vcpu_run)
>  	xor %r15d, %r15d
>  #endif
>  
> +	/* "POP" @hostsa_pa to RAX. */
> +	pop %_ASM_AX
> +
> +	/* Restore host user state and FS/GS base */
> +	vmload %_ASM_AX

This VMLOAD needs the "handle fault on reboot" goo.  Seeing the code, I think
I'd prefer to handle this in C code, especially if Paolo takes the svm_ops.h
patch[*].  Actually, I think with that patch it'd make sense to move the
existing VMSAVE+VMLOAD for the guest into svm.c, too.  And completely unrelated,
the fault handling in svm/vmenter.S can be cleaned up a smidge to eliminate the
JMPs.

Paolo, what do you think about me folding these patches into my series to do the
above cleanups?  And maybe sending a pull request for the end result?  (I'd also
like to add on a patch to use the user return MSR mechanism for MSR_TSC_AUX).

[*] https://lkml.kernel.org/r/20201231002702.2223707-8-seanjc@google.com

> +
>  	pop %_ASM_BX
>  
>  #ifdef CONFIG_X86_64
> -- 
> 2.25.1
> 
