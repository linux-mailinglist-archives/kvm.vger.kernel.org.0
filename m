Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3AD56C470
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbiGHXEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbiGHXED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 19:04:03 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A11F37199
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 16:04:02 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id d187so22526022vsd.10
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 16:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ibwq3Y6+sPRoptrmKqieJnTu1vXCJ5pC3WFZxR8P4fc=;
        b=YMpy6sOl3ytCXl2B/aO/fumKNEVDOQAI7CayXg9owawzYUSnSFrtJLGhHG56wJrPpS
         f5yoFkz8x/HPg/eRbpT5XpdJAc/lXyo/Ox3AKmb9Lfr5mryc2EEch0WIEa6y/+Ke7DcJ
         26+4uHRQWgwXzsW2Ky1Phy9vVZ+paF1bOaSMeBQmC+WqzBHL/1XvK+yGifTKcrs277fa
         mlBLj1afSCRcaoyuubo9AK64p9uQG8BX1M3OgbPKhHBEpoqXVxoUxDdEvQiFlIaHDfy0
         LqNRWFZtaZrwiQkwkQpJEQvK44ofFBkqcurQB2Dlzj7TmRN9NGn1crcMzG5HR7FUOGrr
         r8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ibwq3Y6+sPRoptrmKqieJnTu1vXCJ5pC3WFZxR8P4fc=;
        b=3i8xgyqtD/3cDmCkyCCYf3Jv1fkWNdSa82V/tkefn+Jis4IhN9I5Xy1Qw+EMeZniRd
         pomo3LHwYJenFTXcwK++UEVbk32AV2TSL0mN0CpmArjBaYtEqFEdUWUntJHIpKxToXzj
         C5wLRnSrZdLzJBFB4bkSLtX1Pt/WYzB6ZWbrph+ag46wD5CsgCV65C9JD2IXhVA1amCc
         W/KT9id8/9Rw2pvu1KZVPlwYO1+lzerCCgSU69AwMs5PKF6/xNvkRVTaGn6ngJ+5XmoG
         sGfvV1Ylcerc2yflUjCrtfwAZh9EroTTkMDkKVmCBK4IJyOt4Udq8coO1DDsHV4sWQbk
         vhTg==
X-Gm-Message-State: AJIora8BhI6fyHa0Fm9oVbGdM1U96kzsgl5scEJM/h7C6TRXUQb/L1Ew
        gmf6XGW4kBu+8OdF9Y+pKgQyh7RnVRQfYcaUuJIVsw==
X-Google-Smtp-Source: AGRyM1vqMri5C1ekPowbg9IeMKeeCd9tRHDLqJm13jwa2sIBw+XNbLJxjDNVf4Zepb23k6RDA1242bwlMleI+QL/LXQ=
X-Received: by 2002:a67:c002:0:b0:354:43c2:9245 with SMTP id
 v2-20020a67c002000000b0035443c29245mr2516535vsi.35.1657321440459; Fri, 08 Jul
 2022 16:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220706145957.32156-1-juew@google.com> <20220706145957.32156-2-juew@google.com>
 <Ysi2yH+PJZe+i5DT@google.com>
In-Reply-To: <Ysi2yH+PJZe+i5DT@google.com>
From:   Jue Wang <juew@google.com>
Date:   Fri, 8 Jul 2022 16:03:49 -0700
Message-ID: <CAPcxDJ69geB4J4hLOwnjMh__3xr2J7-zfq_i=w7gRhexXoWaCQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: Fix access to vcpu->arch.apic when the
 irqchip is not in kernel
To:     Sean Christopherson <seanjc@google.com>,
        Jue Wang <wangjue.smth@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Siddh Raman Pant <code@siddh.me>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>
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

Thanks Sean.

+cc another email to stay in the loop.

On Fri, Jul 8, 2022 at 3:59 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jul 06, 2022, Jue Wang wrote:
> > Fix an access to vcpu->arch.apic when KVM_X86_SETUP_MCE is called
> > without KVM_CREATE_IRQCHIP called or KVM_CAP_SPLIT_IRQCHIP is
> > enabled.
> >
> > Reported-by: https://syzkaller.appspot.com/bug?id=10b9b238e087a6c9bef2cc48bee2375f58fabbfc
> >
> > Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4322a1365f74..5913f90ec3f2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4820,8 +4820,9 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
> >               if (mcg_cap & MCG_CMCI_P)
> >                       vcpu->arch.mci_ctl2_banks[bank] = 0;
> >       }
> > -     vcpu->arch.apic->nr_lvt_entries =
> > -             KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
> > +     if (lapic_in_kernel(vcpu))
> > +             vcpu->arch.apic->nr_lvt_entries =
> > +                     KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
>
> This is incomplete.  If there's a "new" LVT entry, then it needs to be initialized
> (masked), and the APIC version needs to be updated to reflect the up-to-date number
> of LVT entries.
>
> This is what I came up with, again compile tested only, will formally post next
> week.
>
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 8 Jul 2022 15:48:10 -0700
> Subject: [PATCH] KVM: x86: Fix handling of APIC LVT updates when userspace
>  changes MCG_CAP
>
> Add a helper to update KVM's in-kernel local APIC in response to MCG_CAP
> being changed by userspace to fix multiple bugs.  First and foremost,
> KVM needs to check that there's an in-kernel APIC prior to dereferencing
> vcpu->arch.apic.  Beyond that, any "new" LVT entries need to be masked,
> and the APIC version register needs to be updated as it reports out the
> number of LVT entries.
>
> Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> Reported-by: syzbot+8cdad6430c24f396f158@syzkaller.appspotmail.com
> Cc: Siddh Raman Pant <code@siddh.me>
> Cc: Jue Wang <juew@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 19 +++++++++++++++++++
>  arch/x86/kvm/lapic.h |  1 +
>  arch/x86/kvm/x86.c   |  4 ++--
>  3 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 1540d01ecb67..50354c7a2dc1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -433,6 +433,25 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>         kvm_lapic_set_reg(apic, APIC_LVR, v);
>  }
>
> +void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu)
> +{
> +       int nr_lvt_entries = kvm_apic_calc_nr_lvt_entries(vcpu);
> +       struct kvm_lapic *apic = vcpu->arch.apic;
> +       int i;
> +
> +       if (!lapic_in_kernel(vcpu) || nr_lvt_entries == apic->nr_lvt_entries)
> +               return;
> +
> +       /* Initialize/mask any "new" LVT entries. */
> +       for (i = apic->nr_lvt_entries; i < nr_lvt_entries; i++)
> +               kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
> +
> +       apic->nr_lvt_entries = nr_lvt_entries;
> +
> +       /* The number of LVT entries is reflected in the version register. */
> +       kvm_apic_set_version(vcpu);
> +}
> +
>  static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
>         [LVT_TIMER] = LVT_MASK,      /* timer mode mask added at runtime */
>         [LVT_THERMAL_MONITOR] = LVT_MASK | APIC_MODE_MASK,
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 762bf6163798..117a46df5cc1 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -99,6 +99,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
>  void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
> +void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
>  bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
>                            int shorthand, unsigned int dest, int dest_mode);
>  int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb37d11dec2d..801c3cfd3db5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4893,8 +4893,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>                 if (mcg_cap & MCG_CMCI_P)
>                         vcpu->arch.mci_ctl2_banks[bank] = 0;
>         }
> -       vcpu->arch.apic->nr_lvt_entries =
> -               KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
> +
> +       kvm_apic_after_set_mcg_cap(vcpu);
>
>         static_call(kvm_x86_setup_mce)(vcpu);
>  out:
>
> base-commit: 03d84f96890662681feee129cf92491f49247d28
> --
>
