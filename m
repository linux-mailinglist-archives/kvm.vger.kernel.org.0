Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867BC6C3646
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjCUPyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCUPx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:53:59 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C005F24C80
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:53:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c8-20020a170902d48800b001a1e0fd4085so1676574plg.20
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679414036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gZp01Rn4tqbPj9Z82BD/d2+ZmCT49AJw0nC/ltwMDVY=;
        b=Nhcg+t282xiguVmADwEfUKwdCoSQyDx6iNSxZ7/vAItPKm4V70LVUhn8gh/t82HQKS
         SpqD6eS2IfI7mjzegtK4arZjF4HLjCjSOE8aW68DV67tf5wdafu5HaXk3no2AnwgaYwN
         25xOuIjDyyFz+vL2xpulQf8AQsdMxNVZigRNTN01kOBLHoMNAR7/SanP2prL+cakIyon
         x2UEyYYEqkMjV5jdCo8VJl8xwe9udzlYTJHR2X5f/QOr3IHdt5sgvnRbN/6ISbjzmaIe
         sFeY9+GkPrzniOBMnFuFAWzArHjMnZyodhpyT+87EHtCFiPoqlnTkZR2dGbzlkXDmcrC
         XI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679414036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gZp01Rn4tqbPj9Z82BD/d2+ZmCT49AJw0nC/ltwMDVY=;
        b=p+XdqE9GsdLV3kaOrtGQtjlvZEKo0cvFdB47oYIpKQ9PktxqQ20rpUhkx/G4mvNt3A
         U+3aSKFOedi1Q3ei0++42OA7QI4lEFZHj9Yve5mqrUHHZ+Lz1WcCbnrGT4zIxg8ALuVo
         SFaLBEOO5BtekG0c+M8zoLs/oipz2vKdQzWV6dCtHDSahGXKm8FF9V6erAmzIgP3pE1h
         iBn4RU3ZPS4SaIOoVIXURv0QaXCtBCJDC6qwbgJ7GDckCJVK3U8LKcY9jb7fjcY3n2L3
         4SmyzACHvfd2ru2HcmzevWEjSoWXva1gSu1R7zXYRlSk3vDoo3Xnwc7GQkbiF2nUFu6E
         aq4w==
X-Gm-Message-State: AO0yUKVPwmAhtw4H8OQWp/VDEHhNnepK5dMFRXFcdjwzuS1xbTe9t30K
        DNsS1F+cWcBChdJQ4gxT9aNzig1vpws=
X-Google-Smtp-Source: AK7set94+nG4nPDfSmz93lC/MZag7w71RUNP7Z1exgiM34ZI3xEyzi4v/muyiVDLdA0LiIGWAsuKYmAKf8c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:4106:0:b0:503:2535:44c3 with SMTP id
 w6-20020a654106000000b00503253544c3mr817451pgp.4.1679414036786; Tue, 21 Mar
 2023 08:53:56 -0700 (PDT)
Date:   Tue, 21 Mar 2023 08:53:55 -0700
In-Reply-To: <20230320221002.4191007-2-oliver.upton@linux.dev>
Mime-Version: 1.0
References: <20230320221002.4191007-1-oliver.upton@linux.dev> <20230320221002.4191007-2-oliver.upton@linux.dev>
Message-ID: <ZBnTE5hCGUOSK3BW@google.com>
Subject: Re: [PATCH 01/11] KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023, Oliver Upton wrote:
> The 'longmode' field is a bit annoying as it blows an entire __u32 to
> represent a boolean value. Since other architectures are looking to add
> support for KVM_EXIT_HYPERCALL, now is probably a good time to clean it
> up.
> 
> Redefine the field (and the remaining padding) as a set of flags.
> Preserve the existing ABI by using the lower 32 bits of the field to
> indicate if the guest was in long mode at the time of the hypercall.

Setting all of bits 31:0 doesn't strictly preserve the ABI, e.g. will be a
breaking change if userspace does something truly silly like

	if (vcpu->run->hypercall.longmode == true)
		...

It's likely unnecessary paranoia, but at the same time it's easy to avoid.

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 9 +++++++++
>  arch/x86/kvm/x86.c              | 5 ++++-
>  include/uapi/linux/kvm.h        | 9 +++++++--
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7f467fe05d42..ab7b7b1d7c9d 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -559,4 +559,13 @@ struct kvm_pmu_event_filter {
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
>  
> +/*
> + * x86-specific KVM_EXIT_HYPERCALL flags.
> + *
> + * KVM previously used a u32 field to indicate the hypercall was initiated from
> + * long mode. As such, the lower 32 bits of the flags are used for long mode to
> + * preserve ABI.
> + */
> +#define KVM_EXIT_HYPERCALL_LONG_MODE	GENMASK_ULL(31, 0)

For the uapi, I think it makes sense to do:

  #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)

and then somewhere internally do:

  /* Snarky comment goes here. */
  #define KVM_EXIT_HYPERCALL_MBZ	GENMASK_ULL(31, 1)

>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7713420abab0..c61c2b0c73bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9803,7 +9803,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		vcpu->run->hypercall.args[0]  = gpa;
>  		vcpu->run->hypercall.args[1]  = npages;
>  		vcpu->run->hypercall.args[2]  = attrs;
> -		vcpu->run->hypercall.longmode = op_64_bit;
> +		vcpu->run->hypercall.flags    = 0;
> +		if (op_64_bit)
> +			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
> +

And add a runtime assertion to make sure we don't botch this in the future:

		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);

>  		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
>  		return 0;
>  	}
