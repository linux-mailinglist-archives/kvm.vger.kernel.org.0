Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5387C22F715
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgG0Ry0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgG0RyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:54:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D68F22070B;
        Mon, 27 Jul 2020 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595872465;
        bh=unMSJDnD2gWLTML1FM1rBLALcFOdgrns4RDfOVlwcHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bRy7I4HwiHk9XhVEHfOpH7jRBh+/gmX/4zTdLMuHZocsjrmXYlcFzfEh4VKId7V6N
         k1trcJiNZ9rs8X507MqUnf+oBbvYHo+Wl+FK3cTW/y1maUeoAjW8Y0mYztRXMvx2hQ
         sxga2LKttu4KI2Lyd4POThxbsKIU1s9IF2T+oVi0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k07KR-00FNyz-FA; Mon, 27 Jul 2020 18:54:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 27 Jul 2020 18:54:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 3/5] KVM: arm64: pvtime: Fix stolen time accounting across
 migration
In-Reply-To: <20200711100434.46660-4-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-4-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <7f982e4cb6a839f698482686a6be57b3@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-11 11:04, Andrew Jones wrote:
> When updating the stolen time we should always read the current
> stolen time from the user provided memory, not from a kernel
> cache. If we use a cache then we'll end up resetting stolen time
> to zero on the first update after migration.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 -
>  arch/arm64/kvm/pvtime.c           | 23 +++++++++--------------
>  include/linux/kvm_host.h          | 19 +++++++++++++++++++
>  3 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index c3e6fcc664b1..b01f52b61572 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -343,7 +343,6 @@ struct kvm_vcpu_arch {
> 
>  	/* Guest PV state */
>  	struct {
> -		u64 steal;
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index db5ef097a166..025b5f3a97ef 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -13,26 +13,22 @@
>  void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> +	u64 base = vcpu->arch.steal.base;
>  	u64 last_steal = vcpu->arch.steal.last_steal;
> -	u64 steal;
> -	__le64 steal_le;
> -	u64 offset;
> +	u64 offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
> +	u64 steal = 0;
>  	int idx;
> -	u64 base = vcpu->arch.steal.base;
> 
>  	if (base == GPA_INVALID)
>  		return;
> 
> -	/* Let's do the local bookkeeping */
> -	steal = vcpu->arch.steal.steal;
> -	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> -	steal += vcpu->arch.steal.last_steal - last_steal;
> -	vcpu->arch.steal.steal = steal;
> -
> -	steal_le = cpu_to_le64(steal);
>  	idx = srcu_read_lock(&kvm->srcu);
> -	offset = offsetof(struct pvclock_vcpu_stolen_time, stolen_time);
> -	kvm_put_guest(kvm, base + offset, steal_le, u64);
> +	if (!kvm_get_guest(kvm, base + offset, steal, u64)) {
> +		steal = le64_to_cpu(steal);
> +		vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +		steal += vcpu->arch.steal.last_steal - last_steal;
> +		kvm_put_guest(kvm, base + offset, cpu_to_le64(steal), u64);
> +	}
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
> 
> @@ -68,7 +64,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	 * Start counting stolen time from the time the guest requests
>  	 * the feature enabled.
>  	 */
> -	vcpu->arch.steal.steal = 0;
>  	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> 
>  	idx = srcu_read_lock(&kvm->srcu);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d564855243d8..e2fc655f0b5b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -749,6 +749,25 @@ int kvm_write_guest_offset_cached(struct kvm
> *kvm, struct gfn_to_hva_cache *ghc,
>  int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache 
> *ghc,
>  			      gpa_t gpa, unsigned long len);
> 
> +#define __kvm_get_guest(kvm, gfn, offset, x, type)			\
> +({									\
> +	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
> +	type __user *__uaddr = (type __user *)(__addr + offset);	\

Passing the type around is pretty ugly. Can't you use something like:

typeof(x) __user *__uaddr = (typeof(__uaddr))(__addr + offset);

which would avoid passing this type around? kvm_put_guest could
use the same treatment.

Yes, it forces the caller to rigorously type the inputs to the
macro. But they should do that anyway.

> +	int __ret = -EFAULT;						\
> +									\
> +	if (!kvm_is_error_hva(__addr))					\
> +		__ret = get_user(x, __uaddr);				\
> +	__ret;								\
> +})
> +
> +#define kvm_get_guest(kvm, gpa, x, type)				\
> +({									\
> +	gpa_t __gpa = gpa;						\
> +	struct kvm *__kvm = kvm;					\
> +	__kvm_get_guest(__kvm, __gpa >> PAGE_SHIFT,			\
> +			offset_in_page(__gpa), x, type);		\
> +})
> +
>  #define __kvm_put_guest(kvm, gfn, offset, value, type)			\
>  ({									\
>  	unsigned long __addr = gfn_to_hva(kvm, gfn);			\

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
