Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C67E4165E5
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbhIWTTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242839AbhIWTTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:19:16 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708BC061757
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:17:44 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so9941459otb.10
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LljGpfowrgivlRJFftpyDSU2BC04nSpPhM5eTXaFlr8=;
        b=RAEdX72B6FJ8jw2x0FecoX4YekDfJKpt4KQDs/G7WIW+nNaklHbXDWQAUYj0t/JaJA
         W6hAufJVFkCXJxttIR9GzclXE2yluJI6Bwx53jtS0jbPDjn1rlKV6tBgBi4ArQLfsZCi
         Cn6S6RQyKUVhromBPbhmSLdKQCprrgOesWVX0ED1SN/D63o/DXwt4XTlk33AJPUYBK6R
         wLtbGlC8TXtukuJd+LDL+BkSYLD/qSgLHPM/TmI5pJq7f+uqj1ABsIC00RlD+0Nka0Gu
         mvuMEdkYIFQ171A8dVY0zC5YcScytshrd/pyp7zQDJqlNYIx5SnZso5D+J3/EI/CELhR
         D6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LljGpfowrgivlRJFftpyDSU2BC04nSpPhM5eTXaFlr8=;
        b=vJ7izN3v76bLVbiEmxC8jBerl1lM+XveXSVsGvm8zGwMb+407wgscL4ZewfXlHtWNU
         xt8CjLKXZoeMHM/cqbEtiMkDSgeBrlYuttKSI7gJarZYr5w8xK5hph23zH5dqRU32gQN
         AZ84D+VTRMKxFwXQ8m9jpOauIlDWAu3yyuxjvMBLKG+mpfRtUNcS33v+cVwNRt4+Be4R
         8CjJUiHiUYgmMiyfHbeLlGknr1j+Y310B+ClH5g1yNQDJ4N9Uvux9JMkTE4hYdGDlINS
         J12QTdd3b4i3Ualq+PFOXcwKE7EgQgIKUyxPsQ3wTsYJ3CwPeF9HEfbV5KjeEYDSabxT
         WamQ==
X-Gm-Message-State: AOAM531kJeschU75hXr/lyaWvB7y/D0VQpXbU6gEFji7AsdVFTVPlVBe
        qY4RmoeP3PU42kyUsBHBSKdIacU4bnNZLDyCjH5k6pIZ85GUaQ==
X-Google-Smtp-Source: ABdhPJy3a+ciB5HUuEkyF15D9a+i+PcNr0ycw4p0pLC+2f3JAb7ZPosK7g7KqsUO3QngeZ/iGwl0M1spnBB1SuLc6LI=
X-Received: by 2002:a9d:71d4:: with SMTP id z20mr309962otj.29.1632424663779;
 Thu, 23 Sep 2021 12:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-22-brijesh.singh@amd.com>
 <YUt8KOiwTwwa6xZK@work-vm> <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
In-Reply-To: <b3f340dc-ceee-3d04-227d-741ad0c17c49@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 23 Sep 2021 12:17:32 -0700
Message-ID: <CAA03e5FTpmCXqsB9OZfkxVY4TQb8n5KfRiFAsmd6jjvbb1DdCQ@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 21/45] KVM: SVM: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 11:09 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
>
> On 9/22/21 1:55 PM, Dr. David Alan Gilbert wrote:
> > * Brijesh Singh (brijesh.singh@amd.com) wrote:
> >> Implement a workaround for an SNP erratum where the CPU will incorrectly
> >> signal an RMP violation #PF if a hugepage (2mb or 1gb) collides with the
> >> RMP entry of a VMCB, VMSA or AVIC backing page.
> >>
> >> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> >> backing   pages as "in-use" in the RMP after a successful VMRUN.  This is
> >> done for _all_ VMs, not just SNP-Active VMs.
> > Can you explain what 'globally enabled' means?
>
> This means that SNP is enabled in  host SYSCFG_MSR.Snp=1. Once its
> enabled then RMP checks are enforced.
>
>
> > Or more specifically, can we trip this bug on public hardware that has
> > the SNP enabled in the bios, but no SNP init in the host OS?
>
> Enabling the SNP support on host is 3 step process:
>
> step1 (bios): reserve memory for the RMP table.
>
> step2 (host): initialize the RMP table memory, set the SYSCFG msr to
> enable the SNP feature
>
> step3 (host): call the SNP_INIT to initialize the SNP firmware (this is
> needed only if you ever plan to launch SNP guest from this host).
>
> The "SNP globally enabled" means the step 1 to 2. The RMP checks are
> enforced as soon as step 2 is completed.

It might be good to update the code to reflect this reply, such that
the new `snp_safe_alloc_page()` function introduced in this patch only
deviates from "normal" page allocation logic when these two conditions
are met. We could introduce a global variable, `snp_globally_enabled`
that defaults to false and gets set to true after we write the SYSCFG
MSR.

> thanks
>
> >
> > Dave
> >
> >> If the hypervisor accesses an in-use page through a writable translation,
> >> the CPU will throw an RMP violation #PF.  On early SNP hardware, if an
> >> in-use page is 2mb aligned and software accesses any part of the associated
> >> 2mb region with a hupage, the CPU will incorrectly treat the entire 2mb
> >> region as in-use and signal a spurious RMP violation #PF.
> >>
> >> The recommended is to not use the hugepage for the VMCB, VMSA or
> >> AVIC backing page. Add a generic allocator that will ensure that the page
> >> returns is not hugepage (2mb or 1gb) and is safe to be used when SEV-SNP
> >> is enabled.
> >>
> >> Co-developed-by: Marc Orr <marcorr@google.com>
> >> Signed-off-by: Marc Orr <marcorr@google.com>
> >> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> >> ---
> >>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
> >>  arch/x86/include/asm/kvm_host.h    |  1 +
> >>  arch/x86/kvm/lapic.c               |  5 ++++-
> >>  arch/x86/kvm/svm/sev.c             | 35 ++++++++++++++++++++++++++++++
> >>  arch/x86/kvm/svm/svm.c             | 16 ++++++++++++--
> >>  arch/x86/kvm/svm/svm.h             |  1 +
> >>  6 files changed, 56 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> >> index a12a4987154e..36a9c23a4b27 100644
> >> --- a/arch/x86/include/asm/kvm-x86-ops.h
> >> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> >> @@ -122,6 +122,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
> >>  KVM_X86_OP_NULL(migrate_timers)
> >>  KVM_X86_OP(msr_filter_changed)
> >>  KVM_X86_OP_NULL(complete_emulated_msr)
> >> +KVM_X86_OP(alloc_apic_backing_page)
> >>
> >>  #undef KVM_X86_OP
> >>  #undef KVM_X86_OP_NULL
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index 974cbfb1eefe..5ad6255ff5d5 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1453,6 +1453,7 @@ struct kvm_x86_ops {
> >>      int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >>
> >>      void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> >> +    void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
> >>  };
> >>
> >>  struct kvm_x86_nested_ops {
> >> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> >> index ba5a27879f1d..05b45747b20b 100644
> >> --- a/arch/x86/kvm/lapic.c
> >> +++ b/arch/x86/kvm/lapic.c
> >> @@ -2457,7 +2457,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
> >>
> >>      vcpu->arch.apic = apic;
> >>
> >> -    apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >> +    if (kvm_x86_ops.alloc_apic_backing_page)
> >> +            apic->regs = static_call(kvm_x86_alloc_apic_backing_page)(vcpu);
> >> +    else
> >> +            apic->regs = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> >>      if (!apic->regs) {
> >>              printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
> >>                     vcpu->vcpu_id);
> >> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >> index 1644da5fc93f..8771b878193f 100644
> >> --- a/arch/x86/kvm/svm/sev.c
> >> +++ b/arch/x86/kvm/svm/sev.c
> >> @@ -2703,3 +2703,38 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> >>              break;
> >>      }
> >>  }
> >> +
> >> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> >> +{
> >> +    unsigned long pfn;
> >> +    struct page *p;
> >> +
> >> +    if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> >> +            return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);

Continuing my other comment, above: if we introduce a
`snp_globally_enabled` var, we could use that here, rather than
`cpu_feature_enabled(X86_FEATURE_SEV_SNP)`.

> >> +
> >> +    /*
> >> +     * Allocate an SNP safe page to workaround the SNP erratum where
> >> +     * the CPU will incorrectly signal an RMP violation  #PF if a
> >> +     * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
> >> +     * or AVIC backing page. The recommeded workaround is to not use the
> >> +     * hugepage.
> >> +     *
> >> +     * Allocate one extra page, use a page which is not 2mb aligned
> >> +     * and free the other.
> >> +     */
> >> +    p = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> >> +    if (!p)
> >> +            return NULL;
> >> +
> >> +    split_page(p, 1);
> >> +
> >> +    pfn = page_to_pfn(p);
> >> +    if (IS_ALIGNED(__pfn_to_phys(pfn), PMD_SIZE)) {
> >> +            pfn++;
> >> +            __free_page(p);
> >> +    } else {
> >> +            __free_page(pfn_to_page(pfn + 1));
> >> +    }
> >> +
> >> +    return pfn_to_page(pfn);
> >> +}
> >> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >> index 25773bf72158..058eea8353c9 100644
> >> --- a/arch/x86/kvm/svm/svm.c
> >> +++ b/arch/x86/kvm/svm/svm.c
> >> @@ -1368,7 +1368,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >>      svm = to_svm(vcpu);
> >>
> >>      err = -ENOMEM;
> >> -    vmcb01_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +    vmcb01_page = snp_safe_alloc_page(vcpu);
> >>      if (!vmcb01_page)
> >>              goto out;
> >>
> >> @@ -1377,7 +1377,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
> >>               * SEV-ES guests require a separate VMSA page used to contain
> >>               * the encrypted register state of the guest.
> >>               */
> >> -            vmsa_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> >> +            vmsa_page = snp_safe_alloc_page(vcpu);
> >>              if (!vmsa_page)
> >>                      goto error_free_vmcb_page;
> >>
> >> @@ -4539,6 +4539,16 @@ static int svm_vm_init(struct kvm *kvm)
> >>      return 0;
> >>  }
> >>
> >> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> >> +{
> >> +    struct page *page = snp_safe_alloc_page(vcpu);
> >> +
> >> +    if (!page)
> >> +            return NULL;
> >> +
> >> +    return page_address(page);
> >> +}
> >> +
> >>  static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>      .hardware_unsetup = svm_hardware_teardown,
> >>      .hardware_enable = svm_hardware_enable,
> >> @@ -4667,6 +4677,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >>      .complete_emulated_msr = svm_complete_emulated_msr,
> >>
> >>      .vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> >> +
> >> +    .alloc_apic_backing_page = svm_alloc_apic_backing_page,
> >>  };
> >>
> >>  static struct kvm_x86_init_ops svm_init_ops __initdata = {
> >> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> >> index d1f1512a4b47..e40800e9c998 100644
> >> --- a/arch/x86/kvm/svm/svm.h
> >> +++ b/arch/x86/kvm/svm/svm.h
> >> @@ -575,6 +575,7 @@ void sev_es_create_vcpu(struct vcpu_svm *svm);
> >>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
> >>  void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
> >>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> >> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
> >>
> >>  /* vmenter.S */
> >>
> >> --
> >> 2.17.1
> >>
> >>
