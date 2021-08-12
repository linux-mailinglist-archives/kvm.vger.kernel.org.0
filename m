Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19C23EA52B
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbhHLNJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 09:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbhHLNJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 09:09:38 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECB4C0613D5
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 06:09:13 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id v10-20020a9d604a0000b02904fa9613b53dso7614925otj.6
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 06:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRqzbWQ5nIKrt8ACxqIhdjGTjjV3XNEnx9RLXFnLp9U=;
        b=af9F5gG94wT94ta0EmdCDZ8PMu/JYSODDydH43su3PYUH4Z+npHCVd+twnuabLyLNV
         AIRifFs11BXjl7YazhGbXPfY4lNp4+/FEqPxhzIGR0b3jyb4NHjP7kUl0QOJ/VbDYSCB
         zNvXzIbE8H6Z1AG4SI7PCxZR0ffFQ77Cz11R/oC77w/C3MuMlI+IVT+jryt6r3kbgt03
         UeVzl+KGq4v/L8c0z7v3ETQ1rM0re5bwSmmKhOrdWFpgq+zjfmf0rwokthr5pRl130jX
         oLOOYQm4tbe896knjGw2NJTQSh1bNrKbUMtFmPczK4ih0DP8ZsNDXMkHcnAvjd5BYv8M
         713Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRqzbWQ5nIKrt8ACxqIhdjGTjjV3XNEnx9RLXFnLp9U=;
        b=sEYQc5l+Gyy7aOVG6bwRuV/+LVYLJoaDxhqzjpwIPO8i84am8Ek3ypKERgHyv2CigE
         XwQWF5md4Lap/OjY4shbGkJbJwlrbfwujiCQCntzwkUkaf86t8DSIm0+q1TyXNvcN4jy
         Vb4M5iTcEDkh83HNEhUIYyqKvJu28+pebabNcHTAHwT5DhlM3aao8YCac91vthnnkT6u
         sTMxIlLRc5wtckUY5N6PxUvmkpac3r7oc3TIl5b8JOrLSkynNAX3pbLO2sGgivbDje1e
         9dW5M8FPNqtaPqLoOmrx88bSeCOBX364FkUc1siqg1Kw8g04cPKNnL7DPbK2KF3mBJxc
         NW1Q==
X-Gm-Message-State: AOAM530yVMJbYvULWe0RN9lgVilLx000NFZmOe4U3MB+C0uFWoT3rcuY
        NYN3DYkYpnJcmbGz8jvdYQfkMYHlMIYxSo3JRAPOVA==
X-Google-Smtp-Source: ABdhPJzOnqtXcXrXssuHj4ykZZNRW7+lUJI1VruW/y3wcegljhCDGPhQVqab0qVckurvGz4++zn4Vc5YQG/X0aDIIwE=
X-Received: by 2002:a05:6830:1095:: with SMTP id y21mr3282853oto.144.1628773752727;
 Thu, 12 Aug 2021 06:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-15-tabba@google.com>
 <20210812095743.GL5912@willie-the-truck>
In-Reply-To: <20210812095743.GL5912@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 12 Aug 2021 15:08:36 +0200
Message-ID: <CA+EHjTzE1w-ePBw+JZw-+ScSKWYExKw9HNTo8rNJAJnAUNf6tw@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Handle protected guests at 32 bits
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,


On Thu, Aug 12, 2021 at 11:57 AM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jul 19, 2021 at 05:03:45PM +0100, Fuad Tabba wrote:
> > Protected KVM does not support protected AArch32 guests. However,
> > it is possible for the guest to force run AArch32, potentially
> > causing problems. Add an extra check so that if the hypervisor
> > catches the guest doing that, it can prevent the guest from
> > running again by resetting vcpu->arch.target and returning
> > ARM_EXCEPTION_IL.
> >
> > Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
> > AArch32 systems")
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 24 ++++++++++++++++++++++++
> >  1 file changed, 24 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 8431f1514280..f09343e15a80 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -23,6 +23,7 @@
> >  #include <asm/kprobes.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_fixed_config.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  #include <asm/fpsimd.h>
> > @@ -477,6 +478,29 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
> >                       write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
> >       }
> >
> > +     /*
> > +      * Protected VMs might not be allowed to run in AArch32. The check below
> > +      * is based on the one in kvm_arch_vcpu_ioctl_run().
> > +      * The ARMv8 architecture doesn't give the hypervisor a mechanism to
> > +      * prevent a guest from dropping to AArch32 EL0 if implemented by the
> > +      * CPU. If the hypervisor spots a guest in such a state ensure it is
> > +      * handled, and don't trust the host to spot or fix it.
> > +      */
> > +     if (unlikely(is_nvhe_hyp_code() &&
> > +                  kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
> > +                  FIELD_GET(FEATURE(ID_AA64PFR0_EL0),
> > +                            PVM_ID_AA64PFR0_ALLOW) <
> > +                          ID_AA64PFR0_ELx_32BIT_64BIT &&
> > +                  vcpu_mode_is_32bit(vcpu))) {
> > +             /*
> > +              * As we have caught the guest red-handed, decide that it isn't
> > +              * fit for purpose anymore by making the vcpu invalid.
> > +              */
> > +             vcpu->arch.target = -1;
> > +             *exit_code = ARM_EXCEPTION_IL;
> > +             goto exit;
> > +     }
>
> Would this be better off inside the nvhe-specific run loop? Seems like we
> could elide fixup_guest_exit() altogether if we've detect that we're in
> AArch32 state when we shouldn't be and it would keep the code off the shared
> path.

Yes, it makes more sense and would result in cleaner code to have it
there, especially in the future where there's likely to be a separate
run loop for protected VMs. I'll move it.

Thanks,
/fuad
> Will
