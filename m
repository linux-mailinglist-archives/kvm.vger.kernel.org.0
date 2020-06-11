Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADBB1F631C
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 09:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFKH7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 03:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgFKH7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 03:59:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A277B204EA;
        Thu, 11 Jun 2020 07:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591862346;
        bh=OosHKHNgy/JfsuiXlWm6kqNlEzxuPgPk1Y8ZZaJeWD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xdnE9ijSYCm2ieKcA6MjTtuO04MHTQe1Et0EXVKYQCTKFPlQEVb9Yfj8kMl8AR13w
         Qa+QrSTirgnpvN11t74TOELy0TkE+PQGhIX4EOiSYHH4YRZ7TbRRaDjLYoA1zHsodf
         +Qk2xXT4keuJXovgH5hLfKz2s8TnNRSdO4NRUwV4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jjI77-0021Wl-9L; Thu, 11 Jun 2020 08:59:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Jun 2020 08:59:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 17/21] KVM: arm64: Use common code's approach for
 __GFP_ZERO with memory caches
In-Reply-To: <20200605213853.14959-18-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-18-sean.j.christopherson@intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <6cc08074c289cbea7b9c1deeaf18c63f@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, pfeiner@google.com, pshier@google.com, junaids@google.com, bgardon@google.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2020-06-05 22:38, Sean Christopherson wrote:
> Add a "gfp_zero" member to arm64's 'struct kvm_mmu_memory_cache' to 
> make
> the struct and its usage compatible with the common 'struct
> kvm_mmu_memory_cache' in linux/kvm_host.h.  This will minimize code
> churn when arm64 moves to the common implementation in a future patch, 
> at
> the cost of temporarily having somewhat silly code.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 1 +
>  arch/arm64/kvm/arm.c              | 2 ++
>  arch/arm64/kvm/mmu.c              | 5 +++--
>  3 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index abbdf9703e20..2385dede96e0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -105,6 +105,7 @@ struct kvm_arch {
>   */
>  struct kvm_mmu_memory_cache {
>  	int nobjs;
> +	gfp_t gfp_zero;
>  	void *objects[KVM_NR_MEM_OBJS];
>  };
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 45276ed50dd6..4c98c6b4d850 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -270,6 +270,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.target = -1;
>  	bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> 
> +	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
> +
>  	/* Set up the timer */
>  	kvm_timer_vcpu_init(vcpu);
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9398b66f8a87..688213ef34f0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -131,7 +131,8 @@ static int mmu_topup_memory_cache(struct
> kvm_mmu_memory_cache *cache, int min)
>  	if (cache->nobjs >= min)
>  		return 0;
>  	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		page = (void *)__get_free_page(GFP_PGTABLE_USER);
> +		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |

This is definitely a change in the way we account for guest
page tables allocation, although I find it bizarre that not
all architectures account for it the same way.

It seems logical to me that nested page tables would be accounted
against userspace, but I'm willing to be educated on the matter.

Another possibility is that depending on the context, some allocations
should be accounted on either the kernel or userspace (NV on arm64
could definitely do something like that). If that was the case,
maybe moving most of the GFP_* flags into the per-cache flags,
and have the renaming that Ben suggested earlier.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
