Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6B253D2FA
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 22:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347094AbiFCUyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 16:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiFCUyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 16:54:52 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F5F30F71
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 13:54:50 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id t25so14391595lfg.7
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 13:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qNZZxsWjFD4c6PyC0A80dpLKqSoXJxfufqC0DpcPbGg=;
        b=bdH60gL6Tlru9/88opK0AzZDuOZWHXp4jkbi8XFAiMqvL4PkH8zhNcSZ2J+7fHhlnF
         qWo2USukfg5NYATnhHuRutpvsYJfy0ZOObvj1hYNkOi7KhslsiXrXhq8BXiKYww86K5d
         gwmzQOcZJKJwEfAMUKV3Gd3n+aToGcBxTkV9iGBiSVSrm4t+Fv1ULMTnwUgoP5+fuELg
         1lyyF7cR5cTZD1M/lZb/0j3Gcop0BX1Gu/4NSS0EMAzPxTR6utNfsIPktQg2FJ4CXsUX
         IuybykxLC7MNkaNFZytv2Ey6WRZKYEy8e7jxiSj1jfhAg17iwPqbQs6bQmm0ZO8cbru0
         GTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qNZZxsWjFD4c6PyC0A80dpLKqSoXJxfufqC0DpcPbGg=;
        b=XHl7AI34FtyJ80N/kVBf+1O+JduXtqQam2Y1YZG+gsQmuiD/AFYTD2cuzkaUi9zbYe
         AtE8AxX4scCS2y6HBR4hNkXJ8w1nvAEk2gO6/bvGVDGVU5n4dsQDCVJf5lGwlNJBFZww
         WlojWP3mB14kM75pvuKL1vxVEPUyv6Vc9Ez333ygrv/w3hyNc+8StRg4eyA4ntGtOw+y
         Lr6rpgLoHscDw+l60xShxDj6fPd7dxf8vRAvnH7/inb7ibk47ezOwwnoAhLuEFAAjcuE
         0Bc4km6VhZ49h1wxc4vcCcj23FoXCxj2yVVHt9oJu+PxZ35r0GtYetsdMT/Ii45TAOCe
         ABYA==
X-Gm-Message-State: AOAM5305WOFZ4E0UmUuVKR0Gnifqn3qeerQLfZO6M2EqfzRkC5KdhkY+
        CbhF+ZSTQJ06R1YCC0oJ+YjDhnekvBRPZ+V/8iMyow==
X-Google-Smtp-Source: ABdhPJyc6dEglhu0gzDyQ7n310Ck6t6RjULKa8Rcl1GgttW/dspLXr2I3lgT/qh9YPhdlLLmWuHOyHPPv/9pBHhv2hM=
X-Received: by 2002:a19:dc18:0:b0:478:b167:4e80 with SMTP id
 t24-20020a19dc18000000b00478b1674e80mr7955815lfg.250.1654289688928; Fri, 03
 Jun 2022 13:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220520173638.94324-1-juew@google.com> <20220520173638.94324-8-juew@google.com>
In-Reply-To: <20220520173638.94324-8-juew@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 3 Jun 2022 13:54:22 -0700
Message-ID: <CALzav=fa7dZ7qT761sxh3dCyj9VUvPGC32Gwo5+1+Aegd6sQ1A@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] KVM: x86: Enable CMCI capability by default and
 handle injected UCNA errors
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Greg Thelen <gthelen@google.com>,
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

On Fri, May 20, 2022 at 10:37 AM Jue Wang <juew@google.com> wrote:
>
> Make KVM support the CMCI capability by default by adding MCG_CMCI_P to
> kvm_mce_cap_supported. A vCPU can request for this capability via
> KVM_X86_SETUP_MCE. Uncorrectable Error No Action required (UCNA) injection
> reuses the MCE injection ioctl KVM_X86_SET_MCE.
>
> Neither of the CMCI and UCNA emulations depends on hardware.
>
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c |  1 +
>  arch/x86/kvm/x86.c     | 50 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 610355b9ccce..1aed964ee4ee 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8037,6 +8037,7 @@ static __init int hardware_setup(void)
>         }
>
>         kvm_mce_cap_supported |= MCG_LMCE_P;
> +       kvm_mce_cap_supported |= MCG_CMCI_P;
>
>         if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
>                 return -EINVAL;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f8ab592f519b..d0b1bb6e5e4a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4826,6 +4826,52 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>         return r;
>  }
>
> +/*
> + * Validate this is an UCNA error by checking the MCG_STATUS and MCi_STATUS
> + * registers that none of the bits for Machine Check Exceptions are set and
> + * both the VAL (valid) and UC (uncorrectable) bits are set.
> + * UCNA - UnCorrectable No Action required
> + * SRAR - Software Recoverable Action Required
> + * MCI_STATUS_PCC - Processor Context Corrupted
> + * MCI_STATUS_S - Signaled as a Machine Check Exception
> + * MCI_STATUS_AR - This MCE is "software recoverable action required"
> + */
> +static bool is_ucna(struct kvm_x86_mce *mce)
> +{
> +       return  !mce->mcg_status &&
> +               !(mce->status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR)) &&
> +               (mce->status & MCI_STATUS_VAL) &&
> +               (mce->status & MCI_STATUS_UC);
> +}
> +
> +static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu, struct kvm_x86_mce *mce)
> +{
> +       u64 mcg_cap = vcpu->arch.mcg_cap;
> +       unsigned int bank_num = mcg_cap & 0xff;
> +       u64 *banks = vcpu->arch.mce_banks;
> +
> +       if (mce->bank >= bank_num)
> +               return -EINVAL;

Drop this check. The caller already checks it.

> +
> +       if (!is_ucna(mce))
> +               return -EINVAL;

Drop this check. The only caller of this function already checks is_ucna().

> +
> +       banks += 4 * mce->bank;

The caller also computes banks. Perhaps just pass that in rather that
re-calculating it here?

Also, calculating banks should probably use array_index_nospec() since
the index is untrusted (coming from userspace).

> +       banks[1] = mce->status;
> +       banks[2] = mce->addr;
> +       banks[3] = mce->misc;
> +       vcpu->arch.mcg_status = mce->mcg_status;
> +
> +       if (!(mcg_cap & MCG_CMCI_P) ||
> +           !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))
> +               return 0;
> +
> +       if (lapic_in_kernel(vcpu))
> +               kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTCMCI);
> +
> +       return 0;
> +}
> +
>  static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>                                       struct kvm_x86_mce *mce)
>  {
> @@ -4835,6 +4881,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>
>         if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
>                 return -EINVAL;
> +
> +       if (is_ucna(mce))
> +               return kvm_vcpu_x86_set_ucna(vcpu, mce);
> +
>         /*
>          * if IA32_MCG_CTL is not all 1s, the uncorrected error
>          * reporting is disabled
> --
> 2.36.1.124.g0e6072fb45-goog
>
