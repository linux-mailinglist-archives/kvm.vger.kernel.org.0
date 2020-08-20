Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE524C72C
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 23:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgHTV0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 17:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgHTV0N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 17:26:13 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32C2C061386
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 14:26:12 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id y30so753720ooj.3
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 14:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqKTYOEG1DwYjtBQ9y/f511uazsbR+LoedmcdkZBfe8=;
        b=A0ZQt9t964myH4QDetGdxWQIQxuyjhjFuuRs0X8Tw9MfjlHlpxGotJl1u5n2HibBbT
         3ZO83y0aI6ZvSnSicpML6Ay5paF16ZVsmi/Hu0oFon5u+dvmENv3bfa4prfr7Gngdb61
         YNzvQsu8/TS/8KOhz1gUFCq/R0UuoKhPctdFS2XIQBIj/itrRNkQvQ4HL5ChDIvpCm0I
         NEysrGxvx7lNCL0k33dVjNO1qeLN9/UlMwDr16ARJuNsoE0JiusEDhDb7uDTlWEhuuH4
         zkmoS/vVQkIl067M9CPxnDoBM9ax7eczf8QfKkjH6rzu3arOR6z0QjXew9oHzIueoXob
         vfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqKTYOEG1DwYjtBQ9y/f511uazsbR+LoedmcdkZBfe8=;
        b=Sp2v3dterQ0W6a1HKxip8dTu39EHwM5nBEF9i4wVr5oIMinDB9bqOhyP5jwNoW08NX
         sXYkhiUPMtyeJb4g0Byd0Qa9q0t4vh7v/8X4SqiSEBRAHs9G0Vm2fvIYZDqoHl2wgBuN
         IJr7td9KSWqVri4P5C2zjD9pPyyqaMBMiVKp6RJYzVtHOPiI6APaWuPVRupFQlDccikf
         ObQx4jArEI/lKM944SKr8CizGtGvX86flS+K5U5XnqZHAC/TREX0naUQRZjCGhYuhcBG
         z8wumuWLdrnhVHX6MkrOQVBgTIFSCFiIn/qZpfXhdQtoF1nL2iwdnnKJQeyv4snUuBNr
         1CMg==
X-Gm-Message-State: AOAM530UOSJnjA7B33Gzxt11HrvlAgQgLCQMj+LDVPf2NhhXAqk+B9fH
        0bDdb/7CNQeFCqa2pWZyGP5qBRs5mykFllUcBaw3Xg==
X-Google-Smtp-Source: ABdhPJyioHPMz5XS5FlItbQ0oss7WkHtSHvZnygv9matvE8GzQ/jiGfgLwBcuSybMid2JD/t3XGTQH9GsqJW/cvZn30=
X-Received: by 2002:a4a:d2d8:: with SMTP id j24mr443720oos.82.1597958771940;
 Thu, 20 Aug 2020 14:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200820133339.372823-1-mlevitsk@redhat.com> <20200820133339.372823-4-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-4-mlevitsk@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 14:26:00 -0700
Message-ID: <CALMp9eRoYLqFEGqcVf2tExGvG4bJwy6CURrHiAnYqQ9TrS4eDg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: SVM: refactor msr permission bitmap allocation
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 6:34 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> Replace svm_vcpu_init_msrpm with svm_vcpu_alloc_msrpm, that also allocates
> the msr bitmap and add svm_vcpu_free_msrpm to free it.
>
> This will be used later to move the nested msr permission bitmap allocation
> to nested.c
>
> No functional change intended.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 45 +++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d33013b9b4d7..7bb094bf6494 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -609,18 +609,29 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
>         msrpm[offset] = tmp;
>  }
>
> -static void svm_vcpu_init_msrpm(u32 *msrpm)
> +static u32 *svm_vcpu_alloc_msrpm(void)

I prefer the original name, since this function does more than allocation.

>  {
>         int i;
> +       u32 *msrpm;
> +       struct page *pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> +
> +       if (!pages)
> +               return NULL;
>
> +       msrpm = page_address(pages);
>         memset(msrpm, 0xff, PAGE_SIZE * (1 << MSRPM_ALLOC_ORDER));
>
>         for (i = 0; direct_access_msrs[i].index != MSR_INVALID; i++) {
>                 if (!direct_access_msrs[i].always)
>                         continue;
> -
>                 set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
>         }
> +       return msrpm;
> +}
> +
> +static void svm_vcpu_free_msrpm(u32 *msrpm)
> +{
> +       __free_pages(virt_to_page(msrpm), MSRPM_ALLOC_ORDER);
>  }
>
>  static void add_msr_offset(u32 offset)
> @@ -1172,9 +1183,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm;
>         struct page *vmcb_page;
> -       struct page *msrpm_pages;
>         struct page *hsave_page;
> -       struct page *nested_msrpm_pages;
>         int err;
>
>         BUILD_BUG_ON(offsetof(struct vcpu_svm, vcpu) != 0);
> @@ -1185,21 +1194,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>         if (!vmcb_page)
>                 goto out;
>
> -       msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> -       if (!msrpm_pages)
> -               goto free_page1;
> -
> -       nested_msrpm_pages = alloc_pages(GFP_KERNEL_ACCOUNT, MSRPM_ALLOC_ORDER);
> -       if (!nested_msrpm_pages)
> -               goto free_page2;
> -

Reordering the allocations does seem like a functional change to me,
albeit one that should (hopefully) be benign. For example, if the
MSRPM_ALLOC_ORDER allocations fail, in the new version of the code,
the hsave_page will be cleared, but in the old version of the code, no
page would be cleared.

>         hsave_page = alloc_page(GFP_KERNEL_ACCOUNT);

Speaking of clearing pages, why not add __GFP_ZERO to the flags above
and skip the clear_page() call below?

>         if (!hsave_page)
> -               goto free_page3;
> +               goto free_page1;
>
>         err = avic_init_vcpu(svm);
>         if (err)
> -               goto free_page4;
> +               goto free_page2;
>
>         /* We initialize this flag to true to make sure that the is_running
>          * bit would be set the first time the vcpu is loaded.
> @@ -1210,11 +1211,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>         svm->nested.hsave = page_address(hsave_page);
>         clear_page(svm->nested.hsave);
>
> -       svm->msrpm = page_address(msrpm_pages);
> -       svm_vcpu_init_msrpm(svm->msrpm);
> +       svm->msrpm = svm_vcpu_alloc_msrpm();
> +       if (!svm->msrpm)
> +               goto free_page2;
>
> -       svm->nested.msrpm = page_address(nested_msrpm_pages);
> -       svm_vcpu_init_msrpm(svm->nested.msrpm);
> +       svm->nested.msrpm = svm_vcpu_alloc_msrpm();
> +       if (!svm->nested.msrpm)
> +               goto free_page3;
>
>         svm->vmcb = page_address(vmcb_page);
>         clear_page(svm->vmcb);
> @@ -1227,12 +1230,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>
>         return 0;
>
> -free_page4:
> -       __free_page(hsave_page);
>  free_page3:
> -       __free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
> +       svm_vcpu_free_msrpm(svm->msrpm);
>  free_page2:
> -       __free_pages(msrpm_pages, MSRPM_ALLOC_ORDER);
> +       __free_page(hsave_page);
>  free_page1:
>         __free_page(vmcb_page);
>  out:

While you're here, could you improve these labels? Coding-style.rst says:

Choose label names which say what the goto does or why the goto exists.  An
example of a good name could be ``out_free_buffer:`` if the goto frees
``buffer``.
Avoid using GW-BASIC names like ``err1:`` and ``err2:``, as you would have to
renumber them if you ever add or remove exit paths, and they make correctness
difficult to verify anyway.
