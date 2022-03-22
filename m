Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50D24E38D1
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 07:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiCVGXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 02:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbiCVGXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 02:23:00 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36292654B
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:21:31 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o23so11934370pgk.13
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 23:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MlDVg50YOyjTrz+LPUvEMuC6Q+pwMUWQRH23N2WfOcc=;
        b=AHY2JoSjeQQi3359E/W6STlGQYdMXpKomemMmvkLNZQy5hHXR4Co1gqq+Gh3p5JD/O
         xEy6fzMw9mzkCLbGwnC/du4WMi7LW37LozJD/eGywB6UEoCtGpOtw6cSiIAAHUYsKWY8
         P2DJwgyKWVMoJ6Ywdh7+MNchNmXhc1ecmGvPdZmjmOYBngzGKPt7HlAJJy/ZIjPeVQpR
         kmPDOq8Z6auQKmfF7LJTxnNAnoowN/5jTzaUJXpYOyPrFsCVKaJ/fpg9m/uPz3O2p40R
         ijyc27Egq12zX8JSLGiXXxNd4Fz8LW2r3oikCsyFlEf0y2ZVv66+eU/wSz/PfJAhrZcf
         puvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MlDVg50YOyjTrz+LPUvEMuC6Q+pwMUWQRH23N2WfOcc=;
        b=kEnmphyUaNo2Bl4vuQG1KlQIlIw2CllD1WOp0iWKS7kNhVs178ThTuJ4LBwszbbrn6
         mjsVoiWNE1AOtoqGvgxMPVtDMv7GYd3eRRa/7y0JSffId2vXcwDIThA8JlV2avSyzssD
         PGI4h3hkYDZYXChke7f7KGgCs4bJwtVhAmhS5F8uayHtA51TC4n2FyzZJz1B6FDqcII3
         yP6EMUZUrQTp4OvBwd41aTS6bRh8XeWKG1sJpAADMJ9HAoKT9P6af1/O0VN3B4Vl8h3s
         J0p4+mm6iKsTfohG22L7vlZXpMIHJygK0G49yRZg2BQjfoYg+wmMG/yTXn17G3ZgDH/2
         k7dw==
X-Gm-Message-State: AOAM533xbvmmQ10Z9ivsY3e6G/V6Dub0goqN5OmVNcpj1tL6BF835vgs
        7iI/RkQ4GdaRSrgZiL+m5HImHPvwJAvxdzGmHof1uA==
X-Google-Smtp-Source: ABdhPJyNn1n4A3z47W3l0VM7ClAP6U5wbTDDu4CEdq0uRf0Y68tMVZ7ErqtRab9q+EEQ5/UbjMjJg5vJQ4miclPcAVA=
X-Received: by 2002:a65:56cb:0:b0:378:82ed:d74 with SMTP id
 w11-20020a6556cb000000b0037882ed0d74mr20755604pgs.491.1647930091046; Mon, 21
 Mar 2022 23:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311174001.605719-9-oupton@google.com>
In-Reply-To: <20220311174001.605719-9-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 21 Mar 2022 23:21:15 -0700
Message-ID: <CAAeT=FwmU1Ej8zc4wB15TRRH6dH9xK7621gO12ib2QjHW11=NA@mail.gmail.com>
Subject: Re: [PATCH v4 08/15] KVM: arm64: Return a value from check_vcpu_requests()
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
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

Hi Oliver,

On Fri, Mar 11, 2022 at 9:41 AM Oliver Upton <oupton@google.com> wrote:
>
> A subsequent change to KVM will introduce a vCPU request that could
> result in an exit to userspace. Change check_vcpu_requests() to return a
> value and document the function. Unconditionally return 1 for now.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/arm.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7c297ddc8177..8eed0556ccaa 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -648,7 +648,16 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
>         preempt_enable();
>  }
>
> -static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> +/**
> + * check_vcpu_requests - check and handle pending vCPU requests
> + * @vcpu:      the VCPU pointer
> + *
> + * Return: 1 if we should enter the guest
> + *        0 if we should exit to userspace
> + *        <= 0 if we should exit to userspace, where the return value indicates
> + *        an error

Nit: Shouldn't "<= 0" be "< 0" ?

Thanks,
Reiji


> + */
> +static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
>         if (kvm_request_pending(vcpu)) {
>                 if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> @@ -678,6 +687,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
>                         kvm_pmu_handle_pmcr(vcpu,
>                                             __vcpu_sys_reg(vcpu, PMCR_EL0));
>         }
> +
> +       return 1;
>  }
>
>  static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
> @@ -793,7 +804,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 if (!ret)
>                         ret = 1;
>
> -               check_vcpu_requests(vcpu);
> +               if (ret > 0)
> +                       ret = check_vcpu_requests(vcpu);
>
>                 /*
>                  * Preparing the interrupts to be injected also
> --
> 2.35.1.723.g4982287a31-goog
>
