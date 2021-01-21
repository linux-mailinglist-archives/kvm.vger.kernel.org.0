Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4362FE03A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 04:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbhAUDxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbhAUDAQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 22:00:16 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB34C061757
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 18:47:58 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h11so1146069ioh.11
        for <kvm@vger.kernel.org>; Wed, 20 Jan 2021 18:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZuZwVwOsZXIOujfnIrxLKTPXUJWWrKVtgOfGA4Pmxcc=;
        b=rAvotTwBl5KLgiR4US39m4jfoz7lvXHt1NdGI+44pOxnkBet0V8jxd9ArSwnceucNr
         Qks1HI2P4AskGsXEhdYai6qGHIJcaTkSCvg9GLRdu1FwQZDQhAyrvbr7uazHMniZVqtt
         sz2EksMDBRt6r1KUJJWCXC4EHKIIjuidKXJhTvziyzWrSkzUWZSTOUthD0gwfyjHIrrR
         wv4o8rF75/1FpTLYmm20vHPDFQJWnimgp0u6yqaZP9OO/M37nzG35egW4kccik8O+oUA
         J4IxHjVw/h7u5sCy0CVAbSo6Q04nj6oud2Y3IoddcOzDd9uq9uI6FyCPJc70ze52W2Yl
         LErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZuZwVwOsZXIOujfnIrxLKTPXUJWWrKVtgOfGA4Pmxcc=;
        b=UBiDHg/WUIY41x8RFgr0c0FeF69jxnsvZsBeBE/CTD5gLoPQk7CS04XCDWDmdYz52W
         /ICY59fi7T7gXCRaesV8bdr9f2yNCavwnyJ0JzearZ65GO9UKWgyPeEbpVKrPAHjh71C
         X2Bys36HCCQ+EyumMSH3QpIV4aNHTx/Qna6VmX2OX7KyaaKbapCyiZeA6Q+hc8QImGtR
         P4r/BR3saqo8bCntvgngil6XglMHISgNknFvACZdBMfhy4BThHsMJ55Fz1Bx7bPt/Pvy
         UGGGqxPWh75KKGuQzJcJ8u5GWNUhymvv82NXxtepNXcpdjnnaqY8nhlSVToGM/NMLzo8
         wrqQ==
X-Gm-Message-State: AOAM530UMIAXfPdZlKwpwRvmjXpcnhtUi55ogKvONlc+Jas+Uh1N6oWa
        C0SU6+L61wsNXn7KisAOf/aKb94nmeM6Q28OL3BYIqL6bACf
X-Google-Smtp-Source: ABdhPJw6Z9tFUIfjoZ5sNIubIzD9q8AVypNcofze1omMchFdn7eRSu9jaXQcWVZL91Lj16mcXw41odGzzDTSy7u44A4=
X-Received: by 2002:a5d:9a8e:: with SMTP id c14mr9273183iom.178.1611197277522;
 Wed, 20 Jan 2021 18:47:57 -0800 (PST)
MIME-Version: 1.0
References: <20201210160002.1407373-1-maz@kernel.org> <20201210160002.1407373-64-maz@kernel.org>
In-Reply-To: <20201210160002.1407373-64-maz@kernel.org>
From:   Haibo Xu <haibo.xu@linaro.org>
Date:   Thu, 21 Jan 2021 10:47:45 +0800
Message-ID: <CAJc+Z1G6QEEiUh=KLdS6Xut7q63zZ6zQxfpGCkCtY5tTSXPeZw@mail.gmail.com>
Subject: Re: [PATCH v3 63/66] KVM: arm64: nv: Allocate VNCR page when required
To:     Marc Zyngier <maz@kernel.org>
Cc:     arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 at 00:04, Marc Zyngier <maz@kernel.org> wrote:
>
> If running a NV guest on an ARMv8.4-NV capable system, let's
> allocate an additional page that will be used by the hypervisor
> to fulfill system register accesses.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 ++-
>  arch/arm64/kvm/nested.c           | 8 ++++++++
>  arch/arm64/kvm/reset.c            | 1 +
>  3 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 78630bd5124d..dada0678c28e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -523,7 +523,8 @@ struct kvm_vcpu_arch {
>   */
>  static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
>  {
> -       if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
> +       if (unlikely(cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
> +                    r >= __VNCR_START__ && ctxt->vncr_array))
>                 return &ctxt->vncr_array[r - __VNCR_START__];
>
>         return (u64 *)&ctxt->sys_regs[r];
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index eef8f9873814..88147ec99755 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -47,6 +47,12 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>         if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>                 return -EINVAL;
>
> +       if (cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT)) {
> +               vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> +               if (!vcpu->arch.ctxt.vncr_array)
> +                       return -ENOMEM;
> +       }
> +

If KVM_ARM_VCPU_INIT was called multiple times, the above codes would
try to allocate a new page
without free-ing the previous one. Besides that, the following
kvm_free_stage2_pgd() call would fail in the
second call with the error message "kvm_arch already initialized?".
I think a possible fix is to add a new flag to indicate whether the NV
related meta data have been initialized,
and only initialize them for the first call.

>         mutex_lock(&kvm->lock);
>
>         /*
> @@ -64,6 +70,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>                     kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
>                         kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
>                         kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
> +                       free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
> +                       vcpu->arch.ctxt.vncr_array = NULL;
>                 } else {
>                         kvm->arch.nested_mmus_size = num_mmus;
>                         ret = 0;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 2d2c780e6c69..d281eb39036f 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -150,6 +150,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
>         kfree(vcpu->arch.sve_state);
> +       free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>  }
>
>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> --
> 2.29.2
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
