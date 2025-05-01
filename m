Return-Path: <kvm+bounces-45080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24319AA5DAB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 828359C4BB5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 11:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D94222572;
	Thu,  1 May 2025 11:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T9/U85yA"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBAE2E401;
	Thu,  1 May 2025 11:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746098175; cv=none; b=IUf00eHMg5l4SBJgRlxUDQjYrrpxuzk90jpDPUzj0I6zuL8oCPlqlWb8YJCE0btHk7WqIh82gfeP1Kvxj7ZBPjJAI2bd30GHQgKF2uLmKoGXdp3divG0v9AWKiZQGF0etG8YY0rRhIxEoMaaWaxYTZLjegzOkTJ5+39PSDAHSp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746098175; c=relaxed/simple;
	bh=SwSSX+bWsYo0Krc0eYqwPhxxTVgwr3IwX+8zNKHF+tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHYbCJTXS8KKa0jhJLdXzAwBn5VPubrGK/TIsKEr1baqSDq+LF+SaY8qC8LOmkIUNu4PCH0r7vT1wE7v2HPCoSHV5Qfr7X2e9BVMOEVutvxBjVo6SFI04yW2J1KLfuLQmBfczBiWbw7eY3hekbJlUZo5tPU3g4AfM7xg28teebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T9/U85yA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fDTwHpsnK1HXZhn01AWF6PLmK/DHwvlEcCJKIgKSjwU=; b=T9/U85yA6hIvoLlv4HtdStuKjP
	k6a+M4OL1L8OrIa901hPNKwtI82kA7+N0hMBR4zoBE4E7d8nz+08o7P3Hqnf+luSVJtZHm26QDQeL
	coxvHFky9Ql49FikfAU1SxOAuXLIYDOauM3z0FBIQq3Tir7getueoC3bLogxKBsh1TJEEzkYqaO8h
	09XEiOWi3RGIS1ZNaoLTFMCQegpfBzn1q8vB4AjvsBn0X+A1YyCqSj+RKU0GwXh7padrqDdihLm6T
	B92bH9jqwkkHgnw/yI9KSsUvXa44Jpy90QMruIl10CIFHO3WayAfe9wLnVOvJZd0v+25QAZwAnm2U
	0sx7Dndw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uARtR-0000000HaXn-0gzL;
	Thu, 01 May 2025 11:15:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A2CD8300230; Thu,  1 May 2025 13:15:52 +0200 (CEST)
Date: Thu, 1 May 2025 13:15:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>, x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>, Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>, Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 2/5] arm64: KVM: use mutex_trylock_nest_lock when
 locking all vCPUs
Message-ID: <20250501111552.GO4198@noisy.programming.kicks-ass.net>
References: <20250430203013.366479-1-mlevitsk@redhat.com>
 <20250430203013.366479-3-mlevitsk@redhat.com>
 <864iy4ivro.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864iy4ivro.wl-maz@kernel.org>

On Thu, May 01, 2025 at 09:24:11AM +0100, Marc Zyngier wrote:
> nit: in keeping with the existing arm64 patches, please write the
> subject as "KVM: arm64: Use ..."
> 
> On Wed, 30 Apr 2025 21:30:10 +0100,
> Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> [...]
> 
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 68fec8c95fee..d31f42a71bdc 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1914,49 +1914,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> >  	}
> >  }
> >  
> > -/* unlocks vcpus from @vcpu_lock_idx and smaller */
> > -static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> > -{
> > -	struct kvm_vcpu *tmp_vcpu;
> > -
> > -	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> > -		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> > -		mutex_unlock(&tmp_vcpu->mutex);
> > -	}
> > -}
> > -
> > -void unlock_all_vcpus(struct kvm *kvm)
> > -{
> > -	lockdep_assert_held(&kvm->lock);
> 
> Note this assertion...
> 
> > -
> > -	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> > -}
> > -
> > -/* Returns true if all vcpus were locked, false otherwise */
> > -bool lock_all_vcpus(struct kvm *kvm)
> > -{
> > -	struct kvm_vcpu *tmp_vcpu;
> > -	unsigned long c;
> > -
> > -	lockdep_assert_held(&kvm->lock);
> 
> and this one...
> 
> > -
> > -	/*
> > -	 * Any time a vcpu is in an ioctl (including running), the
> > -	 * core KVM code tries to grab the vcpu->mutex.
> > -	 *
> > -	 * By grabbing the vcpu->mutex of all VCPUs we ensure that no
> > -	 * other VCPUs can fiddle with the state while we access it.
> > -	 */
> > -	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> > -		if (!mutex_trylock(&tmp_vcpu->mutex)) {
> > -			unlock_vcpus(kvm, c - 1);
> > -			return false;
> > -		}
> > -	}
> > -
> > -	return true;
> > -}
> > -
> >  static unsigned long nvhe_percpu_size(void)
> >  {
> >  	return (unsigned long)CHOOSE_NVHE_SYM(__per_cpu_end) -
> 
> [...]
> 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 69782df3617f..834f08dfa24c 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1368,6 +1368,40 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Try to lock all of the VM's vCPUs.
> > + * Assumes that the kvm->lock is held.
> 
> Assuming is not enough. These assertions have caught a number of bugs,
> and I'm not prepared to drop them.
> 
> > + */
> > +int kvm_trylock_all_vcpus(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long i, j;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > +		if (!mutex_trylock_nest_lock(&vcpu->mutex, &kvm->lock))

This one includes an assertion that kvm->lock is actually held.

That said, I'm not at all sure what the purpose of all this trylock
stuff is here.

Can someone explain? Last time I asked someone said something about
multiple VMs, but I don't know enough about kvm to know what that means.

Are those vcpu->mutex another class for other VMs? Or what gives?

