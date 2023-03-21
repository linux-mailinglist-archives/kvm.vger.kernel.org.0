Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500586C3798
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCURDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 13:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjCURDi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 13:03:38 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F10D113F5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:03:36 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d22-20020a63d716000000b00502e3fb8ff3so3704473pgg.10
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679418216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s88kzjqGlagqEXVo9XjzjUeRm/I+cP9wLXL5YwG7idk=;
        b=BEy8TtenxqVrrlUsFqyOwp6GIhLr0wSFVmB7Tt6hci9hPwQa98lt0YkHPzgUFSOWkE
         8oMZxk7+IJKcDc2YiDHTNR/VzN/hrw29oyF437DJ4vLvKl7FXWVlJLVIxv6aPCGqAN/S
         ycXUMHtd9tVgZAh2gPXbIvlD5NCaN6DhGSr/9J3W6gUrdr8W0yhSejvQN8Sn4UjU/zOu
         L2mbLthYKCWGfrOJGlZlKTGFta2McvoCFaR9Yr6FNXabt+Q7t0FsBIgYbf25HA9rkHeL
         AOpaM6HQN8y+GGW4RYoCyPorqUy8HLiBWHIMb7gNpx5WxOCfnRB2HIAN696aK7tDxGWy
         ypnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679418216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s88kzjqGlagqEXVo9XjzjUeRm/I+cP9wLXL5YwG7idk=;
        b=L6svmZ2jG4Lol45r/GrgwKlx+EitmUjlM+ydBwLo/r3v7UFjoSNkB4yB8n6SHwscpL
         /URf6r5vtjygU1f7wgYAvFhEE60RPvDw5cDkEkKDsyEQpqmqi0Y66oXqAswKYZN0z0et
         vVlq/Q5xZU9WcYU5IU5jReZsrP5bg26BXal9GGhLc1wvo9dpCyVi1frCCRp67bO6RG8o
         TQ9rDIsI8oo3OZKdS2yk9888Ip6LEGwJvcfLUGReTz7zSRLRgvnV6wKYgaGcvs9tMVFo
         GGJHhH5cayafJhrnRobRee9rP+CnkpyFzEBhKH1G2YoQ09oT4vKEJ4ZwMS6AtdzDmHTJ
         jS/A==
X-Gm-Message-State: AO0yUKVoTpNH0bg1OwRHAlq8RJFgN+1Sj+TmX2UoebvRBtss39JhurAy
        GYXp6buHqOIxha5kX6zxK2N4IqkA2cs=
X-Google-Smtp-Source: AK7set/VZWTCBnYSar6fhOHZnlNzbcEGhwJu9Nqpv3WXM/FFy2EGednN4uJWJphNvqd4g8brjrJ4mCPiD4E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:26c4:b0:625:9327:7686 with SMTP id
 p4-20020a056a0026c400b0062593277686mr281894pfw.2.1679418216321; Tue, 21 Mar
 2023 10:03:36 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:03:34 -0700
In-Reply-To: <20230320225159.92771-1-graf@amazon.com>
Mime-Version: 1.0
References: <20230320225159.92771-1-graf@amazon.com>
Message-ID: <ZBnjZg6jxPtBPXc2@google.com>
Subject: Re: [PATCH] KVM: x86: Allow restore of some sregs with protected state
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Sabin Rapan <sabrapan@amazon.com>,
        Peter Gonda <pgonda@google.com>
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

+Peter

On Mon, Mar 20, 2023, Alexander Graf wrote:
> With protected state (like SEV-ES and SEV-SNP), KVM does not have direct
> access to guest registers. However, we deflect modifications to CR0,

Please avoid pronouns in changelogs and comments.

> CR4 and EFER to the host. We also carry the apic_base register and learn
> about CR8 directly from a VMCB field.
> 
> That means these bits of information do exist in the host's KVM data
> structures. If we ever want to resume consumption of an already
> initialized VMSA (guest state), we will need to also restore these
> additional bits of KVM state.

For some definitions of "need".  I've looked at this code multiple times in the
past, and even posted patches[1], but I'm still unconvinced that trapping
CR0, CR4, and EFER updates is necessary[2], which is partly why series to fix
this stalled out.

 : If KVM chugs along happily without these patches, I'd love to pivot and yank out
 : all of the CR0/4/8 and EFER trapping/tracking, and then make KVM_GET_SREGS a nop
 : as well.

[1] https://lore.kernel.org/all/20210507165947.2502412-1-seanjc@google.com
[2] https://lore.kernel.org/all/YJla8vpwqCxqgS8C@google.com

> Prepare ourselves for such a world by allowing set_sregs to set the
> relevant fields. This way, it mirrors get_sregs properly that already
> exposes them to user space.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/x86/kvm/x86.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7713420abab0..88fa8b657a2f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11370,7 +11370,8 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
>  	int idx;
>  	struct desc_ptr dt;
>  
> -	if (!kvm_is_valid_sregs(vcpu, sregs))
> +	if (!vcpu->arch.guest_state_protected &&
> +	    !kvm_is_valid_sregs(vcpu, sregs))

This is broken, userspace shouldn't be allowed to stuff complete garbage just
because guest state is protected.

>  		return -EINVAL;
>  
>  	apic_base_msr.data = sregs->apic_base;
> @@ -11378,8 +11379,19 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
>  	if (kvm_set_apic_base(vcpu, &apic_base_msr))
>  		return -EINVAL;
>  
> -	if (vcpu->arch.guest_state_protected)
> +	if (vcpu->arch.guest_state_protected) {
> +		/*
> +		 * While most actual guest state is hidden from us,
> +		 * CR{0,4,8}, efer and apic_base still hold KVM state
> +		 * with protection enabled, so let's allow restoring
> +		 */
> +		kvm_set_cr8(vcpu, sregs->cr8);
> +		kvm_x86_ops.set_efer(vcpu, sregs->efer);
> +		kvm_x86_ops.set_cr0(vcpu, sregs->cr0);

Use static_call().  This code is also broken in that it doesn't set mmu_reset_needed.
This patch also misses the problematic behavior in svm_set_cr0().

And I don't like having a completely separate one-off flow for protected guests.
It's more code and arguably uglier, but I would prefer to explicitly skip each
chunk as needed so that we aren't effectively maintaining multiple flows.

Easiest thing is probably to just resurrect my aforementioned series, pending the
result of the discussion on whether or not KVM should be trapping CR0/CR4/EFER
writes in the first place.
