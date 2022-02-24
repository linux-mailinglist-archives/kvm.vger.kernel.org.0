Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1914C241A
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 07:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiBXGdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 01:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiBXGdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 01:33:00 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B39A9E02
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 22:32:29 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d187so995875pfa.10
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 22:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sYr99btjNTWEFNut0mb3PVrtN8rcpoOwvOaTLkgqYy0=;
        b=a+LOwzF5lzDECLaXU5NlyXjxhd9hdgKj2SifQ0n7qYgDOD7cFelQDqpDYtFdD5zfbW
         IYE947PfF0pfkSvU76f+Lj+ma0++tfZikaMvkdCGFqwbzl3zkIChzoLw8rjOh42aA4tQ
         T0gnZm9RzWVb/GYbfQzvRaLVS1PtEeLX0mBeO3TNG48Uw04BvCeFi9LgPI5DXe1wLwll
         VkrUWWyruEmVPyw+nYXE2QwX4NMSjsMlyGVbntjMaxDwcUW+xOohnLnhykdvAL60+Ajp
         xVZiLmSk2QKvbbivZsZ8Ily264mJUkNZgP+NbEBz1KheVCvAD8ghONd8Fj3YDQEwyVR5
         OtQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sYr99btjNTWEFNut0mb3PVrtN8rcpoOwvOaTLkgqYy0=;
        b=ClyPZYphA0+UG6DDUih9+k4cguKmnqlP0ddR/Bt7ywoUv7bbAvMjMjta2nZdrRo9Th
         gRenlA0rdrYiX740nCo6857OaZxUj8QnzFFT+1uGFOS5t7ZldjGaZxOCUwlVVaYn/uOQ
         97AhRiwZSWhs0OqTzbg9JDp2GXsJnrmrw+y4qR2oZ2SNPAVxvQiy7PF8OLTHEyQS+rhd
         shm0eJ/eeUMq1EWEJwMwaVd8YA1722cpd0g5C/JrvCmn6xG3qQcFsak4IuUkj+KB72KK
         gIp8ul+j/bBulECwQwymDAkOrfluYfD7jbHW1epPDnXulkiX0dh9qG4tEmtbLY7c0Wcd
         2wfg==
X-Gm-Message-State: AOAM533MKzHO6vGnVpCNFu4DDNNruuurZt/sU5RmQBJZO0WM3CWAeKMd
        l4YC29Hjr1oO5y04XpN2av4Cn3brbOq/Y8d69VVhSg==
X-Google-Smtp-Source: ABdhPJxy+hQPYHL1gH+M5yt+rbHWMaKEV2iXUpDUODPI6GqUNWYbbv55cDAcFy2+qDfAFoy2YtBDJhMVr8Qy3viTVEk=
X-Received: by 2002:a63:5525:0:b0:372:c376:74f1 with SMTP id
 j37-20020a635525000000b00372c37674f1mr1158862pgb.433.1645684348485; Wed, 23
 Feb 2022 22:32:28 -0800 (PST)
MIME-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com> <20220223041844.3984439-3-oupton@google.com>
In-Reply-To: <20220223041844.3984439-3-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 23 Feb 2022 22:32:12 -0800
Message-ID: <CAAeT=FyfOzk6CS2BuXcJdxhRHWj9MVZgXULrHsC344WV-kUepA@mail.gmail.com>
Subject: Re: [PATCH v3 02/19] KVM: arm64: Create a helper to check if IPA is valid
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

On Tue, Feb 22, 2022 at 8:19 PM Oliver Upton <oupton@google.com> wrote:
>
> Create a helper that tests if a given IPA fits within the guest's
> address space.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h      | 9 +++++++++
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 +-
>  2 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 81839e9a8a24..78e8be7ea627 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -111,6 +111,7 @@ alternative_cb_end
>  #else
>
>  #include <linux/pgtable.h>
> +#include <linux/kvm_host.h>
>  #include <asm/pgalloc.h>
>  #include <asm/cache.h>
>  #include <asm/cacheflush.h>
> @@ -147,6 +148,14 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>  #define kvm_phys_size(kvm)             (_AC(1, ULL) << kvm_phys_shift(kvm))
>  #define kvm_phys_mask(kvm)             (kvm_phys_size(kvm) - _AC(1, ULL))
>
> +/*
> + * Returns true if the provided IPA exists within the VM's IPA space.
> + */
> +static inline bool kvm_ipa_valid(struct kvm *kvm, phys_addr_t guest_ipa)
> +{
> +       return !(guest_ipa & ~kvm_phys_mask(kvm));
> +}
> +
>  #include <asm/kvm_pgtable.h>
>  #include <asm/stage2_pgtable.h>
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index c6d52a1fd9c8..e3853a75cb00 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -27,7 +27,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
>         if (addr + size < addr)
>                 return -EINVAL;
>
> -       if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
> +       if (!kvm_ipa_valid(kvm, addr) || addr + size > kvm_phys_size(kvm))
>                 return -E2BIG;
>
>         return 0;

Reviewed-by: Reiji Watanabe <reijiw@google.com>

It looks like we can use the helper for kvm_handle_guest_abort()
in arch/arm64/kvm/mmu.c as well though.
----------
<...>
        /* Userspace should not be able to register out-of-bounds IPAs */
        VM_BUG_ON(fault_ipa >= kvm_phys_size(vcpu->kvm));
<...>
----------

Thanks,
Reiji
