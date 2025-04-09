Return-Path: <kvm+bounces-43033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7234AA832BE
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:46:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B29B0466981
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 20:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B8C214226;
	Wed,  9 Apr 2025 20:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xC8aSKQf"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8632135AD
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231538; cv=none; b=KKeDmnXTgS3AprN8256r9cDfGGnsTbW8YHY0Bc8oRSIqgojv8ZZIeKyNVy4LSKYS0vPk9IBRaLoCKaN/gZEGg7MM7MtlEcIvdPjXugdOAicFFj0HrSMs48Th1bq5swBFsWf5Kw1MkXVdkgikaq36AJm/llIk1Ns4ULNL2lNdpsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231538; c=relaxed/simple;
	bh=xOp9DXsMQrw85PtagiwlHyz33EONNax0oXOrZSgcHHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuV1gGQcIhEgiWP5JnY1bEZDiE76pkxpzcV7XmZt3CSbs7OLPu+8WIdfJi/sNcrMjzvFRrdFYcBC7fYMhuiIgLfUeicZjX282/TRokqlUVcEA+Et5idBhf1PQOdtjK2GB3JS5gV1/YibSBij28Yk8PQGSQ/Ab9W8CBZOTtzg/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xC8aSKQf; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 9 Apr 2025 13:45:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744231523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ENOcZPIItp2JvszVxj/GE2Qd8ZKfpfM4JflKxCvjNwk=;
	b=xC8aSKQfjMqodNcjkUTLUjs/zqCFYnuOpjbh5P9WpT5NQV26kzbmBYXpCKWYi7kZGBKsxL
	gZW41lEMVPwc0O3ZChQyXo3FcMfH90y50iz05hYThAcZmGJ8iVYi08BYw8+X5iWzs50Hx2
	w3VkprowZiWZQ4RRthwlJQvvZgV2B04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>, x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>, Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>, Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: move
 sev_lock/unlock_vcpus_for_migration to kvm_main.c
Message-ID: <Z_bcWBfhoUZfRzek@linux.dev>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
 <20250409014136.2816971-3-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409014136.2816971-3-mlevitsk@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 08, 2025 at 09:41:34PM -0400, Maxim Levitsky wrote:
> Move sev_lock/unlock_vcpus_for_migration to kvm_main and call the
> new functions the kvm_lock_all_vcpus/kvm_unlock_all_vcpus
> and kvm_lock_all_vcpus_nested.
> 
> This code allows to lock all vCPUs without triggering lockdep warning
> about reaching MAX_LOCK_DEPTH depth by coercing the lockdep into
> thinking that we release all the locks other than vcpu'0 lock
> immediately after we take them.
> 
> No functional change intended.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/sev.c   | 65 +++---------------------------------
>  include/linux/kvm_host.h |  6 ++++
>  virt/kvm/kvm_main.c      | 71 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 81 insertions(+), 61 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0bc708ee2788..7adc54b1f741 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1889,63 +1889,6 @@ enum sev_migration_role {
>  	SEV_NR_MIGRATION_ROLES,
>  };
>  
> -static int sev_lock_vcpus_for_migration(struct kvm *kvm,
> -					enum sev_migration_role role)
> -{
> -	struct kvm_vcpu *vcpu;
> -	unsigned long i, j;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (mutex_lock_killable_nested(&vcpu->mutex, role))
> -			goto out_unlock;
> -
> -#ifdef CONFIG_PROVE_LOCKING
> -		if (!i)
> -			/*
> -			 * Reset the role to one that avoids colliding with
> -			 * the role used for the first vcpu mutex.
> -			 */
> -			role = SEV_NR_MIGRATION_ROLES;
> -		else
> -			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> -#endif
> -	}
> -
> -	return 0;
> -
> -out_unlock:
> -
> -	kvm_for_each_vcpu(j, vcpu, kvm) {
> -		if (i == j)
> -			break;
> -
> -#ifdef CONFIG_PROVE_LOCKING
> -		if (j)
> -			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
> -#endif
> -
> -		mutex_unlock(&vcpu->mutex);
> -	}
> -	return -EINTR;
> -}
> -
> -static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *vcpu;
> -	unsigned long i;
> -	bool first = true;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (first)
> -			first = false;
> -		else
> -			mutex_acquire(&vcpu->mutex.dep_map,
> -				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
> -
> -		mutex_unlock(&vcpu->mutex);
> -	}
> -}
> -
>  static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  {
>  	struct kvm_sev_info *dst = to_kvm_sev_info(dst_kvm);
> @@ -2083,10 +2026,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  		charged = true;
>  	}
>  
> -	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
> +	ret = kvm_lock_all_vcpus_nested(kvm, false, SEV_MIGRATION_SOURCE);
>  	if (ret)
>  		goto out_dst_cgroup;
> -	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
> +	ret = kvm_lock_all_vcpus_nested(source_kvm, false, SEV_MIGRATION_TARGET);
>  	if (ret)
>  		goto out_dst_vcpu;
>  
> @@ -2100,9 +2043,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	ret = 0;
>  
>  out_source_vcpu:
> -	sev_unlock_vcpus_for_migration(source_kvm);
> +	kvm_unlock_all_vcpus(source_kvm);
>  out_dst_vcpu:
> -	sev_unlock_vcpus_for_migration(kvm);
> +	kvm_unlock_all_vcpus(kvm);
>  out_dst_cgroup:
>  	/* Operates on the source on success, on the destination on failure.  */
>  	if (charged)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1dedc421b3e3..30cf28bf5c80 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1015,6 +1015,12 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>  
>  void kvm_destroy_vcpus(struct kvm *kvm);
>  
> +int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role);
> +void kvm_unlock_all_vcpus(struct kvm *kvm);
> +
> +#define kvm_lock_all_vcpus(kvm, trylock) \
> +	kvm_lock_all_vcpus_nested(kvm, trylock, 0)
> +

Can you instead add lock / trylock variants of this?

kvm_trylock_all_vcpus(kvm) seems a bit more obvious in the calling code.

Thanks,
Oliver

