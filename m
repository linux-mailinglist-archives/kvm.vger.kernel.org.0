Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB781531F8
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 14:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBENhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 08:37:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58414 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726822AbgBENhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 08:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580909859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ZHZKV/jKaOSLjENoe5XZtmnBOqMNMYSGhSaLDt7Q6E=;
        b=ElcS/HnPYOcb2Uht3d8hsWwrHmhHlfQRbXH50H3GQKVX//eypOB//dQYD/4jUCbzoLIPVi
        2ZEua/6DHPH5LSnZSu54/wyDJj4fd1tFzkED9V6YfHCNzJDFIgnLv93jmISJQi4j4ivJ36
        TE9AYzI9+ggtWCK3v0nFHw6cGtKJQlw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-3JRHlBvEPGC23WjgbNljdA-1; Wed, 05 Feb 2020 08:37:28 -0500
X-MC-Unique: 3JRHlBvEPGC23WjgbNljdA-1
Received: by mail-wm1-f69.google.com with SMTP id u11so1007622wmb.4
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 05:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1ZHZKV/jKaOSLjENoe5XZtmnBOqMNMYSGhSaLDt7Q6E=;
        b=MakxClH6W44eNnJnPSUZCLEZqTWOYPO3yMRJmlBC1tHp6mdPTG43bDiZzPdREwj2es
         uOoWv/lE445KjyRP1jU/9Y/NQp9V7qB/+3D01jDNJwWVPZqe9Lc++NhMhyl7WU91WlPy
         GB/d2BJ2AEe3q++ecz6C6kpwKjbIsN4uBTc6g/mN0++K3y+Hc8lX9p28VkuSknY579G9
         t/anAXekiVIOnZt4Z80eBJRyyt1nH+hla1NKbYO8mmC50Orr7tO88v7bpf97KDrysgzF
         4GAgAhCF4eIayd5hEIqM5fEdMD41fmIf3OYkzWxogHpaBK5Jg2sJuWbmZNXCImFHGSgP
         d69Q==
X-Gm-Message-State: APjAAAXSRBbtm7rjOzGj/rsHIfOjb+PThboKfz89rLDeGm3/amsYE3hm
        zKJa+ZckyR/i3AqxNTXA7YHaa/N7jXvX8LBo7DnpVdY0mN03CwdYDlJY4AiCt5aActuordPJ2ol
        XDy2LcF7T2+ZH
X-Received: by 2002:a1c:9a56:: with SMTP id c83mr5908600wme.79.1580909847509;
        Wed, 05 Feb 2020 05:37:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwzFfXP0e0I4L4edLOhHxfXyc4Wmj97qyd8lGe4qqcytnp7OMRoH9/s3pDomwcVTc8YqdMMAg==
X-Received: by 2002:a1c:9a56:: with SMTP id c83mr5908575wme.79.1580909847254;
        Wed, 05 Feb 2020 05:37:27 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k13sm33844114wrx.59.2020.02.05.05.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 05:37:26 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/3] kvm: mmu: Separate generating and setting mmio ptes
In-Reply-To: <20200203230911.39755-2-bgardon@google.com>
References: <20200203230911.39755-1-bgardon@google.com> <20200203230911.39755-2-bgardon@google.com>
Date:   Wed, 05 Feb 2020 14:37:25 +0100
Message-ID: <87sgjpkve2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ben Gardon <bgardon@google.com> writes:

> Separate the functions for generating MMIO page table entries from the
> function that inserts them into the paging structure. This refactoring
> will facilitate changes to the MMU sychronization model to use atomic
> compare / exchanges (which are not guaranteed to succeed) instead of a
> monolithic MMU lock.
>
> No functional change expected.
>
> Tested by running kvm-unit-tests on an Intel Haswell machine. This
> commit introduced no new failures.
>
> This commit can be viewed in Gerrit at:
> 	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2359
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a9c593dec49bf..b81010d0edae1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -451,9 +451,9 @@ static u64 get_mmio_spte_generation(u64 spte)
>  	return gen;
>  }
>  
> -static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
> -			   unsigned int access)
> +static u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>  {
> +

Unneded newline.

>  	u64 gen = kvm_vcpu_memslots(vcpu)->generation & MMIO_SPTE_GEN_MASK;
>  	u64 mask = generation_mmio_spte_mask(gen);
>  	u64 gpa = gfn << PAGE_SHIFT;
> @@ -464,6 +464,17 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
>  	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
>  		<< shadow_nonpresent_or_rsvd_mask_len;
>  
> +	return mask;
> +}
> +
> +static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
> +			   unsigned int access)
> +{
> +	u64 mask = make_mmio_spte(vcpu, gfn, access);
> +	unsigned int gen = get_mmio_spte_generation(mask);
> +
> +	access = mask & ACC_ALL;
> +
>  	trace_mark_mmio_spte(sptep, gfn, access, gen);

'access' and 'gen' are only being used for tracing, would it rather make
sense to rename&move it to the newly introduced make_mmio_spte()? Or do
we actually need tracing for both?

Also, I dislike re-purposing function parameters.

>  	mmu_spte_set(sptep, mask);
>  }

-- 
Vitaly

