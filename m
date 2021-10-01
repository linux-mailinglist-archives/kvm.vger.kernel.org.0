Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23241E764
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 08:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352071AbhJAGGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 02:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbhJAGGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 02:06:41 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A5DC06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 23:04:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p1so950078pfh.8
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 23:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2wqNWElK598ybE2Qe8b3dIJWb4ay7c1EVylkxkO37M=;
        b=N++DXUpWfiG2mjIuDrz8lQsYFnE7bx09S5IgCMnyYfhp84Sw7ybrZt8R/ckr8Z7x2y
         HEpGbgda/PBlPLK4cVgN36cffhya6xEriD/QEGYUmZo0DEqSTUS4wyKKza362uj0wx94
         kPGYaXMnXeVRyYIsofGtkFl0btMQDSMK47TpPD3eH7eaBjoUpuiTSPZKiJiuSIrB2KGR
         Rz04WESPIval8ta1OWjwafhWswE8GpfkeS29u/WAVfS5oSjxf2KcyhCtzkxs9leVxrYr
         JLvtSUP9yBbPUj4YOISw6jKrfwJzsXuNC5meApCa8hrQq4hm0WVoOsGfDOwbY5BGWoPY
         Trjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2wqNWElK598ybE2Qe8b3dIJWb4ay7c1EVylkxkO37M=;
        b=MhfIxNmEEvEhCbKiwSD+4JV6djB2iO8FKCa5+XwScvAijJSOpRCs5PFnuVy/36PrLu
         uBuTxsh2ls0r93oscI4VxQeWmMsn7CHEUPDxvOxwOWjIpzwQEDHXR/npPke3JQVpRnkS
         ylPu3m53GGQMiaCagxDQdu5sifpCMpahacNUywW3RUSb9lfUEW+7NYwKswU6wbmc9uMz
         oUoHf3/JHUcu/cSOJCBG7RttB0Uo90BNLLItmLoylAYp/QRQ/YN9CF2IAMkrE6exLkl+
         cnt2fu/4XHEv4w795iBrZ2NFs2xeWfc63nnaR3hOHt3YeLBZbtQPF3lWugEWjQ5wPFqL
         /X2A==
X-Gm-Message-State: AOAM532IbC8YK7W1zMHn7Z/aJDEHtaJ3WNlrQyi4TR0GiWn8eN4l0k0T
        RTDmcAhsJ97wvA+olS0FutZoawSTo8a+wU8+cbV8Rg==
X-Google-Smtp-Source: ABdhPJz5HfFFIeXgipaL9sR3oaEPdPGSeCu2dY2viPYbBLHdo2XPRjZRYoOs4Wc0+pSoq2L+LTC210m4iC4eHs5H21I=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr8430611pfn.82.1633068297060; Thu, 30 Sep
 2021 23:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com> <20210923191610.3814698-4-oupton@google.com>
In-Reply-To: <20210923191610.3814698-4-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 30 Sep 2021 23:04:41 -0700
Message-ID: <CAAeT=FxXsJdnrQCr4m-LcADr=WX5pKEa2OdeTf3bRGM08iC3Uw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: Encapsulate reset request logic in a
 helper function
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 23, 2021 at 12:16 PM Oliver Upton <oupton@google.com> wrote:
>
> In its implementation of the PSCI function, KVM needs to request that a
> target vCPU resets before its next entry into the guest. Wrap the logic
> for requesting a reset in a function for later use by other implemented
> PSCI calls.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 59 +++++++++++++++++++++++++------------------
>  1 file changed, 35 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 310b9cb2b32b..bb59b692998b 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -64,9 +64,40 @@ static inline bool kvm_psci_valid_affinity(unsigned long affinity)
>         return !(affinity & ~MPIDR_HWID_BITMASK);
>  }
>
> -static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +static void kvm_psci_vcpu_request_reset(struct kvm_vcpu *vcpu,
> +                                       unsigned long entry_addr,
> +                                       unsigned long context_id,
> +                                       bool big_endian)
>  {
>         struct vcpu_reset_state *reset_state;
> +
> +       lockdep_assert_held(&vcpu->kvm->lock);
> +
> +       reset_state = &vcpu->arch.reset_state;
> +       reset_state->pc = entry_addr;
> +
> +       /* Propagate caller endianness */
> +       reset_state->be = big_endian;
> +
> +       /*
> +        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> +        * the general purpose registers are undefined upon CPU_ON.
> +        */
> +       reset_state->r0 = context_id;
> +
> +       WRITE_ONCE(reset_state->reset, true);
> +       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +
> +       /*
> +        * Make sure the reset request is observed if the change to
> +        * power_state is observed.
> +        */
> +       smp_wmb();
> +       vcpu->arch.power_off = false;
> +}
> +
> +static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> +{
>         struct kvm *kvm = source_vcpu->kvm;
>         struct kvm_vcpu *vcpu = NULL;
>         unsigned long cpu_id;
> @@ -90,29 +121,9 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>                         return PSCI_RET_INVALID_PARAMS;
>         }
>
> -       reset_state = &vcpu->arch.reset_state;
> -
> -       reset_state->pc = smccc_get_arg2(source_vcpu);
> -
> -       /* Propagate caller endianness */
> -       reset_state->be = kvm_vcpu_is_be(source_vcpu);
> -
> -       /*
> -        * NOTE: We always update r0 (or x0) because for PSCI v0.1
> -        * the general purpose registers are undefined upon CPU_ON.
> -        */
> -       reset_state->r0 = smccc_get_arg3(source_vcpu);
> -
> -       WRITE_ONCE(reset_state->reset, true);
> -       kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> -
> -       /*
> -        * Make sure the reset request is observed if the change to
> -        * power_state is observed.
> -        */
> -       smp_wmb();
> -
> -       vcpu->arch.power_off = false;
> +       kvm_psci_vcpu_request_reset(vcpu, smccc_get_arg2(source_vcpu),
> +                                   smccc_get_arg3(source_vcpu),
> +                                   kvm_vcpu_is_be(source_vcpu));
>         kvm_vcpu_wake_up(vcpu);
>
>         return PSCI_RET_SUCCESS;
> --
> 2.33.0.685.g46640cef36-goog

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Not directly related to the patch, but the (original) code doesn't
do any sanity checking for the entry address although the PSCI spec says:

"INVALID_ADDRESS is returned when the entry point address is known
by the implementation to be invalid, because it is in a range that
is known not to be available to the caller."


Thanks,
Reiji
