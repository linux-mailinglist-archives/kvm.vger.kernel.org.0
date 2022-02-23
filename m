Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5C74C0CA3
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 07:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235631AbiBWGh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 01:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbiBWGhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 01:37:55 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A1E6A068
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 22:37:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d3so22259143wrf.1
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 22:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dC+NRabJbEOE/6LY0GzfZ35HZRTTtu1cDQJ3h6XWVws=;
        b=UwcxHVgokN1y78HXIoukjj/WDywvL/2uWGwuPWDbQyaNYL92apBPnBflnwJEyxzGB1
         uPWtwx0PTNA7idkZooQKJlcEnqeoIJ47lsoaBz3sHVdjMI1OuKms227agxs2Mt6y8Xt1
         x87/KHKdNKDyIVa0NlXwbkfOD9YfoKYtnZyGpvQlkFpfXJ8N/GcHn8Z8DtJH1NHkG2RE
         y1GJOYsRFEx4TnXAGK5XVlydmfWcYtp5zd990YOjHN1skaUimAAbRtGR/I633uczTotA
         rOLLjvHGR5BdezgLhh6F4jUfR1jeEpT9g/a1PJbrJXRx0fpEt1sVP6OqEALqNkJ5eiZm
         s9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dC+NRabJbEOE/6LY0GzfZ35HZRTTtu1cDQJ3h6XWVws=;
        b=GSEpm2m9fTKKxMbSQnpUJ/TziaPxVzyx4B3865S4zCx9g+pkd3Ezok2ftnrKpEQWua
         Fqu+kzxjRcHg+XNFIF9x+gF5dZTQDHBLtJnD3P2oq5g2kWqJD30AGs828wdH1H9ewk87
         8B7qYVyWrfoIn65/62NlwWsm4VYSkMat2re034mxUoMwX6Z/VXRGJCLAB9Vws5eqjtSr
         KoXqw5bRVl+H9lQZ2Mr8IRb4xcgF/GX4zompieSrL8y8pVa5cZ31l43VBXI03Zy2r2gY
         Rxm4LltKlvRXJCHNjmbplMUDRwGdLXPG0a/R/dWhLoXzct5dSjqlnubCid9l7Cm+VN7c
         HxRA==
X-Gm-Message-State: AOAM532QqKkkjERMGn0vHPhJMngPa1h6oYcqSSb6tbCwzT+1WTTxtnH8
        2VXHe1MB4Y9J9ea47YjuKL6CVMLS/xlEUUk3WdaD/g==
X-Google-Smtp-Source: ABdhPJwKqNyKzIug73OWQJYmoCEu7Jp5fQjJlzs9qnjv5zwxFqIS5dHZi/tZ2zJuR+3fTVZYcrjfy7IDYca3QmiBaZQ=
X-Received: by 2002:adf:d1cc:0:b0:1ea:8355:88cc with SMTP id
 b12-20020adfd1cc000000b001ea835588ccmr5477832wrd.313.1645598246300; Tue, 22
 Feb 2022 22:37:26 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-11-oupton@google.com>
In-Reply-To: <20220223041844.3984439-11-oupton@google.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 23 Feb 2022 12:07:14 +0530
Message-ID: <CAAhSdy1yY+fQMUZ=2g1JSsZ=jZXFPGxTYk_sM3kURTJ+t_z3Wg@mail.gmail.com>
Subject: Re: [PATCH v3 10/19] KVM: Create helper for setting a system event exit
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 9:49 AM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that appropriately configures kvm_run for a system event
> exit.
>
> No functional change intended.
>
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oupton@google.com>

Looks good to me.

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/arm64/kvm/psci.c         | 4 +---
>  arch/riscv/kvm/vcpu_sbi_v01.c | 4 +---
>  arch/x86/kvm/x86.c            | 6 ++----
>  include/linux/kvm_host.h      | 7 +++++++
>  4 files changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 41adaaf2234a..2bb8d047cde4 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -193,9 +193,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
>                 tmp->arch.mp_state = KVM_MP_STATE_STOPPED;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
> -       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> -       vcpu->run->system_event.type = type;
> -       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +       kvm_vcpu_set_system_event_exit(vcpu, type);
>  }
>
>  static void kvm_psci_system_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
> index 07e2de14433a..7a197d5658d7 100644
> --- a/arch/riscv/kvm/vcpu_sbi_v01.c
> +++ b/arch/riscv/kvm/vcpu_sbi_v01.c
> @@ -24,9 +24,7 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
>                 tmp->arch.power_off = true;
>         kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
>
> -       memset(&run->system_event, 0, sizeof(run->system_event));
> -       run->system_event.type = type;
> -       run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +       kvm_vcpu_set_system_event_exit(vcpu, type);
>  }
>
>  static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7131d735b1ef..109751f89ee3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9903,14 +9903,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
>                         kvm_vcpu_reload_apic_access_page(vcpu);
>                 if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
> -                       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -                       vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
> +                       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_CRASH);
>                         r = 0;
>                         goto out;
>                 }
>                 if (kvm_check_request(KVM_REQ_HV_RESET, vcpu)) {
> -                       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> -                       vcpu->run->system_event.type = KVM_SYSTEM_EVENT_RESET;
> +                       kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_RESET);
>                         r = 0;
>                         goto out;
>                 }
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f11039944c08..9085a1b1569a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2202,6 +2202,13 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>
> +static inline void kvm_vcpu_set_system_event_exit(struct kvm_vcpu *vcpu, u32 type)
> +{
> +       memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
> +       vcpu->run->system_event.type = type;
> +       vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> --
> 2.35.1.473.g83b2b277ed-goog
>
