Return-Path: <kvm+bounces-37833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5029A306E8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 10:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01EC31889067
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5065B1F1314;
	Tue, 11 Feb 2025 09:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nKQSqQbl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A0A1F12ED;
	Tue, 11 Feb 2025 09:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739265905; cv=none; b=mjireCsmNKyvqDlYxTTHgDJYo28c3Ui/2DQ6AsA4tnkrnHtPzXq1T1BzIqKP+bJ8Ab59dsh1dmFKl0dQ8trAoNl/jyTZ/W7MoxfzmP0FZxGsT93K/z12c0dFO42PnOuDDbw7zWYj8yGi+j7EnlJJlQyGKt+PG0DTSJQCQiaTiFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739265905; c=relaxed/simple;
	bh=SR5LwxmHxJbxL8Gifp96GYWy5xT2GbIst98vLDN4fPM=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2S2XNbwVIlam8pjTatyOrxNpI1bxdjHdDrM2Y95qlsfiA1tbI6QxR41a8OkTynPMpVh5bMbWCo6ub1+ucWoB+h6bWYUP3TF8IX0JbtFL0/N/WfdRQHobwb2hWOibAObe3okgPUy7rlld2lV1aQ+Gyky7UHzUZ2cAHySWcALflU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nKQSqQbl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA367C4CEDD;
	Tue, 11 Feb 2025 09:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739265904;
	bh=SR5LwxmHxJbxL8Gifp96GYWy5xT2GbIst98vLDN4fPM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nKQSqQblbizWzWsqck6Hc+bJ/6neD3u0R68/NnK5rihuQCNG77Xa8rUqHiFr6zsvw
	 uaKplYQY9Mq/jgzYt0q5jiqsb7lU7WgWIOEScwVGVTAcNch+Q+f4I7ZBk0RDjyX0qr
	 5sKta5E6pe+eqebn+Jk2rhlerAUMmr4GQyf7GrEusSZaOt645nVnyjvmE7hR3ET6dz
	 teUdrQa7OcInc4drcdmLbmzwL7OqFhVNL5E/KjRg9zBUys3rsFMF5zL6oGZJSj02YP
	 hp6pnbkEbr9ptXSbTIO07SqrSm068K3hQSrzRfqxQ6oLfetn9pv5Je0vmN0KZvrkSQ
	 MvZ043GdJFFhQ==
Received: from [104.132.45.111] (helo=wait-a-minute.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thmVp-002uM5-Fz;
	Tue, 11 Feb 2025 09:25:01 +0000
Date: Tue, 11 Feb 2025 09:24:54 +0000
Message-ID: <87seok25qx.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm-riscv@lists.infradead.org,
	Ingo Molnar <mingo@redhat.com>,
	linux-riscv@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Anup Patel <anup@brainfault.org>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Atish Patra <atishp@atishpatra.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] KVM: arm64: switch to using kvm_lock/unlock_all_vcpus
In-Reply-To: <20250211000917.166856-3-mlevitsk@redhat.com>
References: <20250211000917.166856-1-mlevitsk@redhat.com>	<20250211000917.166856-3-mlevitsk@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.4
 (x86_64-pc-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 104.132.45.111
X-SA-Exim-Rcpt-To: mlevitsk@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com, jingzhangos@google.com, oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, rdunlap@infradead.org, suzuki.poulose@arm.com, palmer@dabbelt.com, yuzenghui@huawei.com, kvm-riscv@lists.infradead.org, mingo@redhat.com, linux-riscv@lists.infradead.org, joey.gouly@arm.com, paul.walmsley@sifive.com, tglx@linutronix.de, bhelgaas@google.com, aou@eecs.berkeley.edu, kvmarm@lists.linux.dev, glider@google.com, x86@kernel.org, seanjc@google.com, anup@brainfault.org, jiangkunkun@huawei.com, atishp@atishpatra.org, catalin.marinas@arm.com, will@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 11 Feb 2025 00:09:16 +0000,
Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> Switch to kvm_lock/unlock_all_vcpus instead of arm's own
> version.
> 
> This fixes lockdep warning about reaching maximum lock depth:
> 
> [  328.171264] BUG: MAX_LOCK_DEPTH too low!
> [  328.175227] turning off the locking correctness validator.
> [  328.180726] Please attach the output of /proc/lock_stat to the bug report
> [  328.187531] depth: 48  max: 48!
> [  328.190678] 48 locks held by qemu-kvm/11664:
> [  328.194957]  #0: ffff800086de5ba0 (&kvm->lock){+.+.}-{3:3}, at: kvm_ioctl_create_device+0x174/0x5b0
> [  328.204048]  #1: ffff0800e78800b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> [  328.212521]  #2: ffff07ffeee51e98 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> [  328.220991]  #3: ffff0800dc7d80b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> [  328.229463]  #4: ffff07ffe0c980b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> [  328.237934]  #5: ffff0800a3883c78 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> [  328.246405]  #6: ffff07fffbe480b8 (&vcpu->mutex){+.+.}-{3:3}, at: lock_all_vcpus+0x16c/0x2a0
> 
> No functional change intended.

Actually plenty of it. This sort of broad assertion is really an
indication of the contrary.

> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h     |  3 ---
>  arch/arm64/kvm/arch_timer.c           |  8 +++----
>  arch/arm64/kvm/arm.c                  | 32 ---------------------------
>  arch/arm64/kvm/vgic/vgic-init.c       | 11 +++++----
>  arch/arm64/kvm/vgic/vgic-its.c        | 18 ++++++++-------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 21 ++++++++++--------
>  6 files changed, 33 insertions(+), 60 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7cfa024de4e3..bba97ea700ca 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1234,9 +1234,6 @@ int __init populate_sysreg_config(const struct sys_reg_desc *sr,
>  				  unsigned int idx);
>  int __init populate_nv_trap_config(void);
>  
> -bool lock_all_vcpus(struct kvm *kvm);
> -void unlock_all_vcpus(struct kvm *kvm);
> -
>  void kvm_calculate_traps(struct kvm_vcpu *vcpu);
>  
>  /* MMIO helpers */
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 231c0cd9c7b4..3af1da807f9c 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1769,7 +1769,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>  
>  	mutex_lock(&kvm->lock);
>  
> -	if (lock_all_vcpus(kvm)) {
> +	ret = kvm_lock_all_vcpus(kvm);
> +
> +	if (!ret) {
>  		set_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &kvm->arch.flags);
>  
>  		/*
> @@ -1781,9 +1783,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>  		kvm->arch.timer_data.voffset = offset->counter_offset;
>  		kvm->arch.timer_data.poffset = offset->counter_offset;
>  
> -		unlock_all_vcpus(kvm);
> -	} else {
> -		ret = -EBUSY;
> +		kvm_unlock_all_vcpus(kvm);
>  	}

This is a userspace ABI change. This ioctl is documented as being able
to return -EINVAL or -EBUSY, and nothing else other than 0. Yet the
new helper returns -EINTR, which you blindly forward to userspace.

>  
>  	mutex_unlock(&kvm->lock);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 071a7d75be68..f58849c5b4f0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1895,38 +1895,6 @@ static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
>  	}
>  }
>  
> -void unlock_all_vcpus(struct kvm *kvm)
> -{
> -	lockdep_assert_held(&kvm->lock);
> -
> -	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> -}
> -
> -/* Returns true if all vcpus were locked, false otherwise */
> -bool lock_all_vcpus(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *tmp_vcpu;
> -	unsigned long c;
> -
> -	lockdep_assert_held(&kvm->lock);
> -
> -	/*
> -	 * Any time a vcpu is in an ioctl (including running), the
> -	 * core KVM code tries to grab the vcpu->mutex.
> -	 *
> -	 * By grabbing the vcpu->mutex of all VCPUs we ensure that no
> -	 * other VCPUs can fiddle with the state while we access it.
> -	 */
> -	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> -		if (!mutex_trylock(&tmp_vcpu->mutex)) {
> -			unlock_vcpus(kvm, c - 1);
> -			return false;
> -		}
> -	}
> -
> -	return true;
> -}

The semantics are different.

Other than the return values mentioned above, the new version fails on
signal delivery, which isn't expected.  The guarantee given to
userspace is that unless a vcpu thread is currently in KVM, the
locking will succeed. Not "will succeed unless something that is
outside of your control happens".

The arm64 version is also built around a mutex_trylock() because we
don't want to wait forever until the vcpu's mutex is released. We want
it now, or never. That's consistent with the above requirement on
userspace.

We can argue whether or not these are good guarantees (or
requirements) to give to (or demand from) userspace, but that's what
we have, and I'm not prepared to break any of it.

At the end of the day, the x86 locking serves completely different
purposes. It wants to gracefully wait for vcpus to exit and is happy
to replay things, because migration (which is what x86 seems to be
using this for) is a stupidly long process. Our locking is designed to
either succeed or fail quickly, because some of the lock paths are on
the critical path for VM startup and configuration.

So for this series to be acceptable, you'd have to provide the same
semantics. It is probably doable with a bit of macro magic, at the
expense of readability.

What I would also like to see is for this primitive to be usable with
scoped_cond_guard(), which would make the code much more readable.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

