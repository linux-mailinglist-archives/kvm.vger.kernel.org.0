Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDF32DE072
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 10:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733140AbgLRJfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 04:35:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgLRJfU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 04:35:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608284033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6szuUC/E+b51oLf2cT47Z8pxpNkrhEO7MYClDvDXDJs=;
        b=aUS4NBcnukzPJbnnLqNpKmJnhVFkFOA36/sM+/L5+mM4zc2qG3JE5cXt91oxn04d/qU9k5
        lrDBwT3u8G2EfCumaC0ZfQ55v2TCMJ6g+Ly5Nyzn3NiDlL5zBFHV1jGimq9tcsRCvTpVno
        mdkPq3LiVg7dpMOhPM9VrAioqe5zX00=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-fVujkVEKNVOXmQpo3lBzcA-1; Fri, 18 Dec 2020 04:33:49 -0500
X-MC-Unique: fVujkVEKNVOXmQpo3lBzcA-1
Received: by mail-ed1-f69.google.com with SMTP id n18so873825eds.2
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 01:33:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6szuUC/E+b51oLf2cT47Z8pxpNkrhEO7MYClDvDXDJs=;
        b=Tz7HhTPys7qcXcv1mrekwgaP0sX8pbuItjyLxWjUrYecr6BeD7iuySS1ollaua3CUv
         dAF6tdEgsOiR6jExFur74KQUYVRiPvyzWWC7slZ1CNafowHYEsUO2lzEmng+6ctUytlL
         KoF8LlilfVVI0TTn+WGuwUSHy0yk166pUi1zAvUoTXhb2E8n3tc6xO7SZhX4qNgz74gQ
         sIZTGWMBxFFjeIGM/1qx/GlCBcizEM7ZOTEqUhx2MWfUpWnZSfJtAMhMpohyHCx6Jnfi
         +HyW30NGAZl7k/4Dh4A3ajEM6jgDsdeX1YLCMpZMWRqU+m1ZjifeCJq0ynl5KJWITJap
         3I6A==
X-Gm-Message-State: AOAM533HgwZ4yRmm7hWoQL9DwoKS55YVwZhCznfJ3xe69ShuUMFWUk5L
        CoiyKwFZDmqHhpvaON2eXj4m0nc09rLIrWvdqfb+GQYyiuGLoMqrY7jeRJ7Ea1Q5R6yGzMqb0wr
        d5ayYWCw8DhmZ
X-Received: by 2002:aa7:c652:: with SMTP id z18mr3389737edr.60.1608284028697;
        Fri, 18 Dec 2020 01:33:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/ns2TM1N8Va0SMdnRxXx42M29Uge5oKuIU7+km2Y8+qK4HKaDt+nvTWh+zrYr37Ey9luaag==
X-Received: by 2002:aa7:c652:: with SMTP id z18mr3389731edr.60.1608284028520;
        Fri, 18 Dec 2020 01:33:48 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d13sm10988021edx.27.2020.12.18.01.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 01:33:47 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Optimize not-present/MMIO SPTE check
 in get_mmio_spte()
In-Reply-To: <20201218003139.2167891-5-seanjc@google.com>
References: <20201218003139.2167891-1-seanjc@google.com>
 <20201218003139.2167891-5-seanjc@google.com>
Date:   Fri, 18 Dec 2020 10:33:47 +0100
Message-ID: <87lfdvtq4k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Check only the terminal leaf for a "!PRESENT || MMIO" SPTE when looking
> for reserved bits on valid, non-MMIO SPTEs.  The get_walk() helpers
> terminate their walks if a not-present or MMIO SPTE is encountered, i.e.
> the non-terminal SPTEs have already been verified to be regular SPTEs.
> This eliminates an extra check-and-branch in a relatively hot loop.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4798a4472066..769855f5f0a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3511,7 +3511,7 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
>  	return leaf;
>  }
>  
> -/* return true if reserved bit is detected on spte. */
> +/* return true if reserved bit(s) are detected on a valid, non-MMIO SPTE. */
>  static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  {
>  	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
> @@ -3534,11 +3534,20 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  		return reserved;
>  	}
>  
> +	*sptep = sptes[leaf];
> +
> +	/*
> +	 * Skip reserved bits checks on the terminal leaf if it's not a valid
> +	 * SPTE.  Note, this also (intentionally) skips MMIO SPTEs, which, by
> +	 * design, always have reserved bits set.  The purpose of the checks is
> +	 * to detect reserved bits on non-MMIO SPTEs. i.e. buggy SPTEs.
> +	 */
> +	if (!is_shadow_present_pte(sptes[leaf]))
> +		leaf++;
> +
>  	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
>  
> -	for (level = root; level >= leaf; level--) {
> -		if (!is_shadow_present_pte(sptes[level]))
> -			break;
> +	for (level = root; level >= leaf; level--)
>  		/*
>  		 * Use a bitwise-OR instead of a logical-OR to aggregate the
>  		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
> @@ -3546,7 +3555,6 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  		 */
>  		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level]) |
>  			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
> -	}
>  
>  	if (reserved) {
>  		pr_err("%s: detect reserved bits on spte, addr 0x%llx, dump hierarchy:\n",
> @@ -3556,8 +3564,6 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  			       sptes[level], level);
>  	}
>  
> -	*sptep = sptes[leaf];
> -
>  	return reserved;
>  }

FWIW (as I got a bit lost in tdp-mmu code when checking that
is_shadow_present_pte() is always performed)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

