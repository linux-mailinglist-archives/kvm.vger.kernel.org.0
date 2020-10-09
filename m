Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C62288E95
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389673AbgJIQRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 12:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389662AbgJIQRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 12:17:14 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9765C0613D5
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 09:17:14 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id x62so10705318oix.11
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 09:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nv6hxgJE6F13m8yrGBTnSqZNZeOQ+Nxj6uvnt0DeaLw=;
        b=EvqJ0t1jWB/MleGe/MtVqHEC19LuB4vdffCzjYJUI+lxhU9U54wbBOutBCe29gT+w4
         ZNShBzOks2mhBhdFQSJR05pDUpm1H1IgkZS1vM4A3Cnp+vb36ohdzoM9byZGPc/MygcG
         GAXx68ht3Cjkiuyg6pWky7O6QrRb/1exBUPXVKWw6FjYcc4KvxWnG5mtx6hSQDwODtnO
         zJISoRNysIJ3KMpm9Q8opO0483kbLk2Xeala5PhHFcZvG8qHRj1DMYOI1q3w19b6Cv9P
         w7FXz3OLrjbzGEnQz5eEwACyrvTl6BxIwjjLTDTSJaowwOQ4GXN2aY4oUvlYmzPmn1ti
         zApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nv6hxgJE6F13m8yrGBTnSqZNZeOQ+Nxj6uvnt0DeaLw=;
        b=jT34ssSP+IjagGLWlPImbFn+hhQiVrfGjFQot9BKVCZYXX6ziTYE4qrJcxnDHp9vpg
         nIKANbATBy1/VmLfMsLP0J344MMfpcVXpjsnUezS+M8fKaNaytxGDpfoKBelZXXd0Vch
         3kAhg1dicGTdk6n7ORb+RMsTrwV5ulaTsawtFJhFPJnEg8jrL7SJhfMTrdlBjVk4Jmt4
         HRwsSo+JJnNVptN8lIXb3eIJnfCYaKIqHJ5GFTbXSVN/sKWNzq45zuS+wLovjYi1TcdQ
         NZKrGjNTUo5L4DMN4uV2E9nfLy6oRQx8/2JOPWgB6oKoew6hE4RiFHNJ8cUGXT0HgZNZ
         9pPA==
X-Gm-Message-State: AOAM530Sz+ceeUydxaWa3RKkc2dVc0uqHgCGuSRbSi/7aH8s8PqLglXA
        9vitXVVZiPVTOe14QRMEsOTI39RqfbtuyecgIDh8bA==
X-Google-Smtp-Source: ABdhPJxxzc9zLpycYReAvd3jJ3fYqaypxWgmnH6JI44BhzCNS3bW9E+/wFhaW3h5AKLb8WYy5mcCWl1oF0+kmsPex5s=
X-Received: by 2002:aca:5b05:: with SMTP id p5mr2779753oib.6.1602260233764;
 Fri, 09 Oct 2020 09:17:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com> <20200710154811.418214-8-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-8-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Oct 2020 09:17:02 -0700
Message-ID: <CALMp9eSbY6FjZAXt7ojQrX_SC_Lyg24dTGFZdKZK7fARGA=3hg@mail.gmail.com>
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 8:48 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> Check guest physical address against it's maximum physical memory. If
> the guest's physical address exceeds the maximum (i.e. has reserved bits
> set), inject a guest page fault with PFERR_RSVD_MASK set.
>
> This has to be done both in the EPT violation and page fault paths, as
> there are complications in both cases with respect to the computation
> of the correct error code.
>
> For EPT violations, unfortunately the only possibility is to emulate,
> because the access type in the exit qualification might refer to an
> access to a paging structure, rather than to the access performed by
> the program.
>
> Trapping page faults instead is needed in order to correct the error code,
> but the access type can be obtained from the original error code and
> passed to gva_to_gpa.  The corrections required in the error code are
> subtle. For example, imagine that a PTE for a supervisor page has a reserved
> bit set.  On a supervisor-mode access, the EPT violation path would trigger.
> However, on a user-mode access, the processor will not notice the reserved
> bit and not include PFERR_RSVD_MASK in the error code.
>
> Co-developed-by: Mohammed Gamal <mgamal@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
>  arch/x86/kvm/vmx/vmx.h |  3 ++-
>  2 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 770b090969fb..de3f436b2d32 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4790,9 +4790,15 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>
>         if (is_page_fault(intr_info)) {
>                 cr2 = vmx_get_exit_qual(vcpu);
> -               /* EPT won't cause page fault directly */
> -               WARN_ON_ONCE(!vcpu->arch.apf.host_apf_flags && enable_ept);
> -               return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
> +               if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
> +                       /*
> +                        * EPT will cause page fault only if we need to
> +                        * detect illegal GPAs.
> +                        */
> +                       kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
> +                       return 1;
> +               } else
> +                       return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
>         }
>
>         ex_no = intr_info & INTR_INFO_VECTOR_MASK;
> @@ -5308,6 +5314,18 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>                PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
>
>         vcpu->arch.exit_qualification = exit_qualification;
> +
> +       /*
> +        * Check that the GPA doesn't exceed physical memory limits, as that is
> +        * a guest page fault.  We have to emulate the instruction here, because
> +        * if the illegal address is that of a paging structure, then
> +        * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
> +        * would also use advanced VM-exit information for EPT violations to
> +        * reconstruct the page fault error code.
> +        */
> +       if (unlikely(kvm_mmu_is_illegal_gpa(vcpu, gpa)))
> +               return kvm_emulate_instruction(vcpu, 0);
> +

Is kvm's in-kernel emulator up to the task? What if the instruction in
question is AVX-512, or one of the myriad instructions that the
in-kernel emulator can't handle? Ice Lake must support the advanced
VM-exit information for EPT violations, so that would seem like a
better choice.

>         return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>  }
>
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index b0e5e210f1c1..0d06951e607c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -11,6 +11,7 @@
>  #include "kvm_cache_regs.h"
>  #include "ops.h"
>  #include "vmcs.h"
> +#include "cpuid.h"
>
>  extern const u32 vmx_msr_index[];
>
> @@ -552,7 +553,7 @@ static inline bool vmx_has_waitpkg(struct vcpu_vmx *vmx)
>
>  static inline bool vmx_need_pf_intercept(struct kvm_vcpu *vcpu)
>  {
> -       return !enable_ept;
> +       return !enable_ept || cpuid_maxphyaddr(vcpu) < boot_cpu_data.x86_phys_bits;
>  }
>
>  void dump_vmcs(void);
> --
> 2.26.2
>
