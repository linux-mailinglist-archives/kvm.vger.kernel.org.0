Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6BD525AD8
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 06:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351159AbiEMEqQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 00:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244160AbiEMEqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 00:46:15 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8462F21268
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 21:46:12 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id y27so3670968vkl.8
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 21:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHYy548ygylCuSAwDXQbq+d6KNJ8BFi2EPzpzjEEpMs=;
        b=puz7BD39x/FySjnOJA9lE3jNfcaG+F5YcpOmvXfhuJi1B7huCPAOb2vis8wn5Dn4jQ
         upa8u3dzSsoCnlFBylrDajNEkkNaNv/bTFkMpQ84AgPH4mc4wwb7nmzm+17Mv1k68Qzs
         fddd3UovmTTB8JaSmvrbSN8ipZ4d/gPpJGF59gg0F/5oJWr1u0xGXE8m7MyaovhtQCmW
         uI1LYZcAB4/zXrQOCZJOatOInkjAOGQ6f3K/jM/DknXhb2q815ag9T+LANYbSjxoaeE3
         psEkZN/uBeRjygH3uBVxRo6PfLXYmuPzcyjjxtnGjJOtEG69OeFd1jMZUBCeTs+HM3My
         IG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHYy548ygylCuSAwDXQbq+d6KNJ8BFi2EPzpzjEEpMs=;
        b=Uh58q8yjudOk9qv72QxvWsgh8gtEeGfsNWrO6G7xyXBsAf2uvHsGCcVacSFANqj1pC
         FOj8vBOOgktJNDiTaEhwIte5/aGXgA/0Bci3IM4Q5nfr0XxpruSF99Wh75Bu6XVAPHbp
         2+a17rTlqSDjgojhoh2ItRwoHvzvKN1JQZ2z4EKYVuuFUOwg8yJtjb4PKfeRkFop4Dlq
         6TOB9QRsOH5SXwK8049YRHfrtBABwH40l0c2e6QKPJwnOrIKsIKo4YJd/pcYDZSndfpI
         A4+EYolvq7jWwWczr830zOevCQMzsDmvY5bDhxE6AIFAyy3Z3yBmtsljtq+R7grWi8tM
         Enig==
X-Gm-Message-State: AOAM531oZveHdmzbGc1FxTyr8Ux5NBI/Bfbz592vrrszd0u2YrPOM79l
        aEJ1V9dfN0j+bi2ZctZNOvTpWhlJevuezPhCaSm1gA==
X-Google-Smtp-Source: ABdhPJwZSdpd5l3svuUA38xYh/sMlur//ikhaNPZ0sq3a0Al8XoMVWXk8YRHOwzJtU7/T0PrjPhTGa/8PVdbxhJ/Okc=
X-Received: by 2002:a1f:4188:0:b0:349:54be:cc27 with SMTP id
 o130-20020a1f4188000000b0034954becc27mr1454248vka.33.1652417171306; Thu, 12
 May 2022 21:46:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com> <20220412223134.1736547-4-juew@google.com>
 <YnwH2zRlGvwkjCAC@google.com>
In-Reply-To: <YnwH2zRlGvwkjCAC@google.com>
From:   Jue Wang <juew@google.com>
Date:   Thu, 12 May 2022 21:45:59 -0700
Message-ID: <CAPcxDJ74+8s7s0sqpb-tib1fwRVupUGZwRv0jhJ57rDA4acLEw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: x86: Add support for MSR_IA32_MCx_CTL2 MSRs.
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

Thanks a lot, Sean.

On Wed, May 11, 2022 at 12:00 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Jue Wang wrote:
> > Note the support of CMCI (MCG_CMCI_P) is not enabled in
> > kvm_mce_cap_supported yet.
>
> You can probably guess what I would say here :-)  A reader should not have to go
> wade through Intel's SDM to understand the relationship between CTL2 and CMCI.

Included details in the change log for V3 about CTL2 and CMCI_P
register / bits. Also rewrote the change log so they contain full text
form of UCNA and CMCI, and a complete context of this patch series.


>
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/x86.c              | 50 +++++++++++++++++++++++++--------
> >  2 files changed, 40 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index ec9830d2aabf..639ef92d01d1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -800,6 +800,7 @@ struct kvm_vcpu_arch {
> >       u64 mcg_ctl;
> >       u64 mcg_ext_ctl;
> >       u64 *mce_banks;
> > +     u64 *mci_ctl2_banks;
> >
> >       /* Cache MMIO info */
> >       u64 mmio_gva;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index eb4029660bd9..73c64d2b9e60 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3167,6 +3167,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >       unsigned bank_num = mcg_cap & 0xff;
> >       u32 msr = msr_info->index;
> >       u64 data = msr_info->data;
> > +     u32 offset;
> >
> >       switch (msr) {
> >       case MSR_IA32_MCG_STATUS:
> > @@ -3180,10 +3181,22 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                       return 1;
> >               vcpu->arch.mcg_ctl = data;
> >               break;
> > +     case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>
> This is wrong.  Well, incomplete.  It will allow writes to MSRs that do not exist,
> i.e. if bank_num >= offset < KVM_MAX_MCE_BANKS.
>
> I believe this will suffice and is also the simplest?
>
>                 if (msr >= MSR_IA32_MCx_CTL2(bank_num))
>                         return 1;
>
> Actually, tying in with the array_index_nopsec() comments below, if this captures
> the last MSR in a variable, then the overrun is much more reasonable (sample idea
> at the bottom).
>
> > +             if (!(mcg_cap & MCG_CMCI_P) &&
> > +                             (data || !msr_info->host_initiated))
>
> Funky indentation.  Should be:
>
>                 if (!(mcg_cap & MCG_CMCI_P) &&
>                     (data || !msr_info->host_initiated))
>                         return 1;

Updated, I need to further fix my VIM configs.

>
> > +                     return 1;
> > +             /* An attempt to write a 1 to a reserved bit raises #GP */
> > +             if (data & ~(MCI_CTL2_CMCI_EN | MCI_CTL2_CMCI_THRESHOLD_MASK))
> > +                     return 1;
> > +             offset = array_index_nospec(
> > +                             msr - MSR_IA32_MC0_CTL2,
> > +                             MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
>
> My preference would be to let this run over (by a fair amount)
>
>                 offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
>                                             MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
>
> But if we use a local variable, there's no overrun:
>
>         case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>                 last_msr = MSR_IA32_MCx_CTL2(bank_num) - 1;
>                 if (msr > last_msr)
>                         return 1;
>
>                 if (!(mcg_cap & MCG_CMCI_P) && (data || !msr_info->host_initiated))
>                         return 1;
>                 /* An attempt to write a 1 to a reserved bit raises #GP */
>                 if (data & ~(MCI_CTL2_CMCI_EN | MCI_CTL2_CMCI_THRESHOLD_MASK))
>                         return 1;
>                 offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
>                                             last_msr + 1 - MSR_IA32_MC0_CTL2);
>                 vcpu->arch.mci_ctl2_banks[offset] = data;
>                 break;
>
Updated to use this version.
>
> And if we go that route, in a follow-up patch at the end of the series, clean up
> the "default" path to hoist the if-statement into a proper case statement (unless
> I've misread the code), e.g. with some opportunstic cleanup:
>
>         case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
>                 last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
>                 if (msr > last_msr)
>                         return 1;
>
>                 offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
>                                             last_msr + 1 - MSR_IA32_MC0_CTL);
>
>                 /*
>                  * Only 0 or all 1s can be written to IA32_MCi_CTL, though some
>                  * Linux kernels clear bit 10 in bank 4 to workaround a BIOS/GART
>                  * TLB issue on AMD K8s, ignore this to avoid an uncatched #GP in
>                  * the guest.
>                  */
>                 if ((offset & 0x3) == 0 &&
>                     data != 0 && (data | (1 << 10)) != ~(u64)0)
>                         return -1;
>
>                 /* MCi_STATUS */
>                 if (!msr_info->host_initiated && (offset & 0x3) == 1 &&
>                     data != 0 && !can_set_mci_status(vcpu))
>                         return -1;
>
>                 vcpu->arch.mce_banks[offset] = data;
>                 break;
>
> Actually, rereading that, isn't "return -1" wrong?  That will cause kvm_emulate_wrmsr()
> to exit to userspace, not inject a #GP.
>
> *sigh*  Yep, indeed, the -1 gets interpreted as -EPERM and kills the guest.
>
> Scratch the idea of doing the above on top, I'll send separate patches and a KUT
> testcase.  I'll Cc you on the patches, it'd save Paolo a merge conflict (or you a
> rebase) if this series is based on top of that bugfix + cleanup.

I will base this series on top of the bugfix + cleanup series.

>
> > +             vcpu->arch.mci_ctl2_banks[offset] = data;
> > +             break;
> >       default:
> >               if (msr >= MSR_IA32_MC0_CTL &&
> >                   msr < MSR_IA32_MCx_CTL(bank_num)) {
> > -                     u32 offset = array_index_nospec(
> > +                     offset = array_index_nospec(
> >                               msr - MSR_IA32_MC0_CTL,
> >                               MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
> >
> > @@ -3489,7 +3502,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                       return 1;
> >               }
> >               break;
> > -     case 0x200 ... 0x2ff:
> > +     case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
> > +     case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
> >               return kvm_mtrr_set_msr(vcpu, msr, data);
> >       case MSR_IA32_APICBASE:
> >               return kvm_set_apic_base(vcpu, msr_info);
> > @@ -3646,6 +3660,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >       case MSR_IA32_MCG_CTL:
> >       case MSR_IA32_MCG_STATUS:
> >       case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> > +     case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> >               return set_msr_mce(vcpu, msr_info);
> >
> >       case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
> > @@ -3750,6 +3765,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
> >       u64 data;
> >       u64 mcg_cap = vcpu->arch.mcg_cap;
> >       unsigned bank_num = mcg_cap & 0xff;
> > +     u32 offset;
> >
> >       switch (msr) {
> >       case MSR_IA32_P5_MC_ADDR:
> > @@ -3767,10 +3783,18 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
> >       case MSR_IA32_MCG_STATUS:
> >               data = vcpu->arch.mcg_status;
> >               break;
> > +     case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
>

> Same comments as the WRMSR path.  I'll also handle the "default" case in my cleanup.

Updated similarly as the WRMSR path. Thanks again, I will base V3 on
the cleanup + fix series.

>
> > +             if (!(mcg_cap & MCG_CMCI_P) && !host)
> > +                     return 1;
> > +             offset = array_index_nospec(
> > +                             msr - MSR_IA32_MC0_CTL2,
> > +                             MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
> > +             data = vcpu->arch.mci_ctl2_banks[offset];
> > +             break;
> >       default:
> >               if (msr >= MSR_IA32_MC0_CTL &&
> >                   msr < MSR_IA32_MCx_CTL(bank_num)) {
> > -                     u32 offset = array_index_nospec(
> > +                     offset = array_index_nospec(
> >                               msr - MSR_IA32_MC0_CTL,
> >                               MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
> >
>
> ...
>
> > @@ -11126,9 +11152,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> >               goto fail_free_lapic;
> >       vcpu->arch.pio_data = page_address(page);
> >
> > -     vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
> > +     vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
> > +                                    GFP_KERNEL_ACCOUNT);
>
> Switching to kcalloc() should be a separate patch.

Done.

>
> > +     vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
> >                                      GFP_KERNEL_ACCOUNT);
> > -     if (!vcpu->arch.mce_banks)
> > +     if (!vcpu->arch.mce_banks | !vcpu->arch.mci_ctl2_banks)
>
> This wants to be a logical-OR, not a bitwise-OR.
>
> Oh, and vcpu->arch.mci_ctl2_banks needs to be freed if a later step fails.

Thanks for the catch, fixed in V3.

>
> >               goto fail_free_pio_data;
> >       vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
> >
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
