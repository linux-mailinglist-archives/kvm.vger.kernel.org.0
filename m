Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFA525AEE
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 07:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377018AbiEMEys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 00:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354401AbiEMEyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 00:54:41 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB09150465
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 21:54:38 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id x11so2797408uao.2
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 21:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiRxr/t7wNKOjvRMER4B0Jh2KHLCS5zJmY50mG+94I8=;
        b=QEaAQd137V/0qcQwcimjbOQFJVE+JF1QCTSI8ieoeDleE87EyaM38TEnRBAp8VWt09
         BZVxYBgCXlhIhZNxuKoz5vDK+YdGoBy06DiUL9WSxghvyg+E2jel5EHkTzjjMzFuos79
         rX/l4FM6t2BmUolQ8z/fIccXKaMGzvQiWiJ/egnx/KQl579OjS5QX2UNpZ+/3rGH3LAI
         T0t4HfELVFp3+JaYkZVF4uLQEsgAYislhB2apLqeK2Uv8O9CIQc1oR8Vo5hpS5guLK86
         FB2W6EIMT00pZXFCWtkz1CRb/D7O2yr+Rv+8czPqx+JfEOK9BlO9h3P5fVuJlRkDVuz3
         d5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiRxr/t7wNKOjvRMER4B0Jh2KHLCS5zJmY50mG+94I8=;
        b=KM1h9391hvG6Wm0opo9MsF039punCezoDyFG82eiX89uc7AAG9pOoFwO3KiPmSepSr
         jv7WfEuAzYA3vSlFtRUkFw9Hqf7J4xuZYmUr332JhMS8oQypqr6QDhw7nb7OY9prWe15
         SwCQ79qTEBgRWES8Ksw8SG16XVDhkoQwThm/G0+/mG+v45DlKbH/DZ1dr6DdSIFS8SOa
         gQ2+TVEzoj/dXuLrGz1GlHyLURP+m9KeEIwpipOo8/DEOgJYx+4aAnV2h7DhGda6/gyl
         oMoyh0MBiXI5+mgIr7O6CSprFBvd09DlrqDXc9mDZiD9xPZNhbyyndoFaVSEfMsbUwX2
         lt8Q==
X-Gm-Message-State: AOAM533FlQ91p7hrZAHR0j9P9mpe13LQJaQmu5KZSM8inMhqf9NoIU66
        xIOU4QoTFjrnZadNCN+z/7ABi9L2QJ6JRvKkKkUF3Q==
X-Google-Smtp-Source: ABdhPJxXBDV3z6IjLcRqOGQmY7t7cOUYOxde4FYdXv9b+rpdPyyEdI0r/pURz/ckZDQqmrKEtg8PDnML8OEbZZQ+dIE=
X-Received: by 2002:a05:6130:32a:b0:365:88b6:fd2 with SMTP id
 ay42-20020a056130032a00b0036588b60fd2mr1779913uab.97.1652417677888; Thu, 12
 May 2022 21:54:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com> <20220412223134.1736547-5-juew@google.com>
 <YnwMlFmAL8lRxX7x@google.com>
In-Reply-To: <YnwMlFmAL8lRxX7x@google.com>
From:   Jue Wang <juew@google.com>
Date:   Thu, 12 May 2022 21:54:26 -0700
Message-ID: <CAPcxDJ50Fk5GBtNFA6OqTKYSn+es9ASs5KoMZF5NYvn0vRkprA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: Add support for MCG_CMCI_P and handling
 of injected UCNAs.
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

On Wed, May 11, 2022 at 12:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 12, 2022, Jue Wang wrote:
> > Note prior to this patch, the UCNA type of signaling can already be
> > processed by kvm_vcpu_ioctl_x86_set_mce and does not result in correct
> > CMCI signaling semantic.
>
> Same as before...
>
> UCNA should be spelled out at least once.

Rewrote the change log to include full context of this change and full
text definition of UCNA and CMCI.

>
> >
> > Signed-off-by: Jue Wang <juew@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c |  1 +
> >  arch/x86/kvm/x86.c     | 48 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 49 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index b730d799c26e..63aa2b3d30ca 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8035,6 +8035,7 @@ static __init int hardware_setup(void)
> >       }
> >
> >       kvm_mce_cap_supported |= MCG_LMCE_P;
> > +     kvm_mce_cap_supported |= MCG_CMCI_P;
>
> Is there really no hardware dependency on CMCI?  Honest question  If not, that
> should be explicitly called out in the changelog.

CMCI emulation does not depend on hardware, it only depends on vcpu's
lapic being available.

Updated the change log.
>
> >       if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
> >               return -EINVAL;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 73c64d2b9e60..eb6058ca1e70 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4775,6 +4775,50 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
> >       return r;
> >  }
> >
> > +static bool is_ucna(u64 mcg_status, u64 mci_status)
>
> Any reason not to take 'struct kvm_x86_mce *mce'?

Updated.

>
> > +{
> > +     return !mcg_status &&
> > +             !(mci_status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR));
>
> As someone who knows nothing about MCI encoding, can you add a function comment
> explaing, in detail, what's going on here?
>
> Also, my preference is to align the indentation on multi-line returns.  Paolo scoffs
> at this nit of mine, but he's obviously wrong ;-)

Added function comments in V3 and updated alignment.
>
>         return !mcg_status &&
>                !(mci_status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR));
>
> > +}
> > +
> > +static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu,
> > +             struct kvm_x86_mce *mce)
>
> Please align the params.  Actually, just let it run over, it's a single char.

Done.
>
> static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu, struct kvm_x86_mce *mce)
>
> > +{
> > +     u64 mcg_cap = vcpu->arch.mcg_cap;
> > +     unsigned int bank_num = mcg_cap & 0xff;
> > +     u64 *banks = vcpu->arch.mce_banks;
> > +
> > +     /* Check for legal bank number in guest */
>
> Eh, don't think this warrants a comment.

Removed.
>
> > +     if (mce->bank >= bank_num)
> > +             return -EINVAL;
> > +
> > +     /*
> > +      * UCNA signals should not set bits that are only used for machine check
> > +      * exceptions.
> > +      */
> > +     if (mce->mcg_status ||
> > +             (mce->status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR)))
>
> Unless mine eyes deceive me, this is the same as:
>
>         if (!is_ucna(mce->mcg_status, mce->status))
>

Good catch, also folded the MCI_STATUS_VAL and MCI_STATUS_UC checks
into is_ucna.
> > +             return -EINVAL;
> > +
> > +     /* UCNA must have VAL and UC bits set */
> > +     if (!(mce->status & MCI_STATUS_VAL) || !(mce->status & MCI_STATUS_UC))
> > +             return -EINVAL;
> > +
> > +     banks += 4 * mce->bank;
> > +     banks[1] = mce->status;
> > +     banks[2] = mce->addr;
> > +     banks[3] = mce->misc;
> > +     vcpu->arch.mcg_status = mce->mcg_status;
> > +
> > +     if (!(mcg_cap & MCG_CMCI_P) || !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))
>
> This one's worth wrapping, that's quite a long line, and there's a natural split point:
>
>         if (!(mcg_cap & MCG_CMCI_P) ||
>             !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))
>                 return 0;
>
>
Done.
> > +             return 0;
> > +
> > +     if (lapic_in_kernel(vcpu))
> > +             kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTCMCI);
> > +
> > +     return 0;
> > +}
> > +
> >  static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> >                                     struct kvm_x86_mce *mce)
> >  {
> > @@ -4784,6 +4828,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
> >
> >       if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
> >               return -EINVAL;
> > +
> > +     if (is_ucna(mce->mcg_status, mce->status))
> > +             return kvm_vcpu_x86_set_ucna(vcpu, mce);
> > +
> >       /*
> >        * if IA32_MCG_CTL is not all 1s, the uncorrected error
> >        * reporting is disabled
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
