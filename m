Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B24468345
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 08:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355004AbhLDIDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Dec 2021 03:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354886AbhLDIDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Dec 2021 03:03:07 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C82C061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 23:59:42 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id x7so4060160pjn.0
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 23:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/HNVa0CxFfdOsv36W3pOGvXrawzXJwdYz3KBqa4NE8A=;
        b=TeXbYPX+C4uPkxaaFLcgtGGJEujSGWZEHwDDrNsBd0VadDAJvtlEj0Iag/3oEQobME
         mSCi0i0sZxUT82ObDMEopmUc5fT1bocwKCmhlzBsTpDBbCM/IqCMysRkVQSU+hIZ7W7T
         LTv4Eu4l4MZEJbIFAIRPLCZ4Oft79rV92CR8Xiiu6hhYA3+cI+eJSANmXynO6hNagk+X
         PsCdOG46OFzs4b6BiZDMZmsQq2WBmlBcTLm2zeMSzGeWSsiUNSVYe8vzONKfJp3U3FZM
         b5P+jP/tiAN+/CZkQbUBIlshH4OQzIoWIa9LTfHBBeOTC7XD3aQW/gMTBYmwZQrugEgI
         PE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/HNVa0CxFfdOsv36W3pOGvXrawzXJwdYz3KBqa4NE8A=;
        b=7qVEA9NscW4WLQxNaI64fQSAaz+QJIYsq5cUT+q2TbAdQ57/6Ns2LX05Zz8In+u8at
         fUG+zE5ljbFGVBaXrijTfqimfYJkiPuE8ElC00tjHZD1l8v+lu6e9kZ+t4521nMPd2E8
         G0PYQlpZXhrK62wIp/f3nmkfV3AhSE/iwP+2Wp0r6vhJwA87/Bbpwil0Q07ffxtrG+jF
         LTan8lQVVTe0nGTRfy/cTW+BfTNDeDYV+jjSl3qYVWWGXeFDXX0z8hxTcOJ+WCuLIkty
         o/MnZMJx1wqG4lyUALoCSVt6F5LqWwjY6fE6copAfd3meuGjkFCVVPMejvMEXrIYVUB0
         /MtQ==
X-Gm-Message-State: AOAM532H7s0TTVJ98yKoMvtaZ4OvlNeX4ZPsMvJRf9PJs3xp4bG6Q+A8
        /EEbtxvlquhX65/qJtKaqRenkrQUm89Xqg5HydGpnw==
X-Google-Smtp-Source: ABdhPJz/LZkSzORmcnKM+1dzW2Nc3IsEy0R3q6edufSEOKTPTDCILwf40IG7uWOovBicDJ7eg3FHc1anE6oqqnkjUB0=
X-Received: by 2002:a17:90b:4acd:: with SMTP id mh13mr20584196pjb.230.1638604781530;
 Fri, 03 Dec 2021 23:59:41 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-5-reijiw@google.com>
 <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com> <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
 <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
In-Reply-To: <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 3 Dec 2021 23:59:25 -0800
Message-ID: <CAAeT=Fz2tLMDOkZ4kQYV0tS44MEtSUxPH71+XD3r+VyJxbjd_g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Dec 2, 2021 at 5:02 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/30/21 2:29 AM, Reiji Watanabe wrote:
> > Hi Eric,
> >
> > On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
> >>
> >> Hi Reiji,
> >>
> >> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> >>> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
> >>> userspace.
> >>>
> >>> The CSV2/CSV3 fields of the register were already writable and values
> >>> that were written for them affected all vCPUs before. Now they only
> >>> affect the vCPU.
> >>> Return an error if userspace tries to set SVE/GIC field of the register
> >>> to a value that conflicts with SVE/GIC configuration for the guest.
> >>> SIMD/FP/SVE fields of the requested value are validated according to
> >>> Arm ARM.
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> ---
> >>>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
> >>>  1 file changed, 103 insertions(+), 56 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 1552cd5581b7..35400869067a 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
> >>>               id_reg->init(id_reg);
> >>>  }
> >>>
> >>> +#define      kvm_has_gic3(kvm)               \
> >>> +     (irqchip_in_kernel(kvm) &&      \
> >>> +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >> you may move this macro to kvm/arm_vgic.h as this may be used in
> >> vgic/vgic-v3.c too
> >
> > Thank you for the suggestion. I will move that to kvm/arm_vgic.h.
> >
> >
> >>> +
> >>> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >>> +                                 const struct id_reg_info *id_reg, u64 val)
> >>> +{
> >>> +     int fp, simd;
> >>> +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
> >>> +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
> >>> +     int gic;
> >>> +
> >>> +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
> >>> +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
> >>> +     if (simd != fp)
> >>> +             return -EINVAL;
> >>> +
> >>> +     /* fp must be supported when sve is supported */
> >>> +     if (pfr0_has_sve && (fp < 0))
> >>> +             return -EINVAL;
> >>> +
> >>> +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> >>> +     if (vcpu_has_sve ^ pfr0_has_sve)
> >>> +             return -EPERM;
> >>> +
> >>> +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
> >>> +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
> >>> +             return -EPERM;
> >>
> >> Sometimes from a given architecture version, some lower values are not
> >> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
> >> Shouldn't we handle that kind of check?
> >
> > As far as I know, there is no way for guests to identify the
> > architecture revision (e.g. v8.1, v8.2, etc).  It might be able
> > to indirectly infer the revision though (from features that are
> > available or etc).
>
> OK. That sounds weird to me as we do many checks accross different IDREG
> settings but we may eventually have a wrong "CPU model" exposed by the
> user space violating those spec revision minima. Shouldn't we introduce
> some way for the userspace to provide his requirements? via new VCPU
> targets for instance?

Thank you for sharing your thoughts and providing the suggestion !

Does the "new vCPU targets" mean Armv8.0, armv8.1, and so on ?

The ID registers' consistency checking in the series is to not
promise more to userspace than what KVM (on the host) can provide,
and to not expose ID register values that are not supported on
any ARM v8 architecture for guests (I think those are what the
current KVM is trying to assure).  I'm not trying to have KVM
provide full consistency checking of ID registers to completely
prevent userspace's bugs in setting ID registers.

I agree that it's quite possible that userspace exposes such wrong
CPU models, and KVM's providing more consistency checking would be
nicer in general.  But should it be KVM's responsibility to completely
prevent such ID register issues due to userspace bugs ?

Honestly, I'm a bit reluctant to do that so far yet:)
If that is something useful that userspace or we (KVM developers)
really want or need, or such userspace issue could affect KVM,
I would be happy to add such extra consistency checking though.

Thanks,
Reiji
