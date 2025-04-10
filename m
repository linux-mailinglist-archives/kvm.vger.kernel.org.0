Return-Path: <kvm+bounces-43075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 520EFA83C99
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 10:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FB84174E04
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 08:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED7920F088;
	Thu, 10 Apr 2025 08:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wjg+PVCt"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC68F20B7F1;
	Thu, 10 Apr 2025 08:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744273018; cv=none; b=gsLZIWzxFuaZa5V+myDMqBYTla8XPbijFtWJZ0KSw5ykx377kKMf4WASHY4fbHqo7DtwcoYWIyqPlKCuToG9hHWu+TXkAxvMeRU1yWkMtZne+/v3spiezsDE6zxINrwo0vFe9UtC0xW8bwkPcF3cZlugEZTDi98Mvd3UJfbtrJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744273018; c=relaxed/simple;
	bh=RZTUHPBAWgXx1IJUnSAS0VY9DQxUo9jpKkYHvxOb8NM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pooNQ3ZY1tVMWVa3xMHxUzD1MmRxXKadU5ZUPTmnJ9II2vIYiF1FCTZ6wVjrlgDWsrvK8vPbErtHgR2HSdRu4RR++mEoef2XSMchX0PU1ysvrlLB/BVaS5Nsu5xu5ADRl7kmW7RkapQly4HaZNuH+deVKLVoSgT7lFAXc9db7LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wjg+PVCt; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uB+Z6x+VWnGWGieZgYK9ruFVlK20QbBkiLXO+vDsz2w=; b=Wjg+PVCtrtNOWu7AUd4A4kKRMN
	X7AvVDzvlWDxtYHCg+MYT4kRUd6r2iTn2US6oojoVMcGh033UfN5FIGcAqYYUqP+NBDE3tDrnS7TF
	GV7+w43k6VmvfmY1+6cyqopPdH79oktWgRSTQJ4DlWPHTvguEb/+HIMC1S+uKwsyYOXfar3VoqMvw
	/XMzNCdlye6wHEotel1CYkCZqH7xq/UZcXylgBuU52T2nKLvLUZmnlUb5gqOnHRsatb5ENs37fUYE
	Mg2RdH/RUY2KrIjBO0Epbebx1Nw6eTo1iSv1bvWXCpfrONOKn5leUL4JR+WJaWfpiQ+YtZqzJznDa
	XzdpvzRg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u2n5V-00000008mN2-1kUp;
	Thu, 10 Apr 2025 08:16:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 00A143003C4; Thu, 10 Apr 2025 10:16:40 +0200 (CEST)
Date: Thu, 10 Apr 2025 10:16:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
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
	Joey Gouly <joey.gouly@arm.com>, Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: move
 sev_lock/unlock_vcpus_for_migration to kvm_main.c
Message-ID: <20250410081640.GX9833@noisy.programming.kicks-ass.net>
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

On Tue, Apr 08, 2025 at 09:41:34PM -0400, Maxim Levitsky wrote:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 69782df3617f..71c0d8c35b4b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1368,6 +1368,77 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> +
> +/*
> + * Lock all VM vCPUs.
> + * Can be used nested (to lock vCPUS of two VMs for example)
> + */
> +int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i, j;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +
> +		if (trylock && !mutex_trylock_nested(&vcpu->mutex, role))
> +			goto out_unlock;
> +		else if (!trylock && mutex_lock_killable_nested(&vcpu->mutex, role))
> +			goto out_unlock;
> +
> +#ifdef CONFIG_PROVE_LOCKING
> +		if (!i)
> +			/*
> +			 * Reset the role to one that avoids colliding with
> +			 * the role used for the first vcpu mutex.
> +			 */
> +			role = MAX_LOCK_DEPTH - 1;
> +		else
> +			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> +#endif
> +	}

This code is all sorts of terrible.

Per the lockdep_assert_held() above, you serialize all these locks by
holding that lock, this means you can be using the _nest_lock()
annotation.

Also, the original code didn't have this trylock nonsense, and the
Changelog doesn't mention this -- in fact the Changelog claims no
change, which is patently false.

Anyway, please write like:

	kvm_for_each_vcpu(i, vcpu, kvm) {
		if (mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock))
			goto unlock;
	}

	return 0;

unlock:

	kvm_for_each_vcpu(j, vcpu, kvm) {
		if (j == i)
			break;

		mutex_unlock(&vcpu->mutex);
	}
	return -EINTR;

And yes, you'll have to add mutex_lock_killable_nest_lock(), but that
should be trivial.

