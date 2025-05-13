Return-Path: <kvm+bounces-46348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5A5AB5418
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 13:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6A73AC7D6
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 11:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54E028D8D0;
	Tue, 13 May 2025 11:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R/77HBPl"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65880B;
	Tue, 13 May 2025 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747136783; cv=none; b=Kw/xRaRFps6eQxxm239pMmummh+CPw7jz2jDVEKkuX+eatMCvgxJWkqzYbI91ukvLZwjNiKge1vtpqVw2bIMtU4X+QbJo7xOVJPuAbkbLnLpCskWkic3Z/YvPIWJVo8o9LRTkeFVRlThKS3F//hjZnsFIQ+OhYjrnPymR90GGEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747136783; c=relaxed/simple;
	bh=hscrpwVKyaQdOMWhRZbsTLwO/LT+TmPaak1LNECP3nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WE3wAXJ1tLoXdFx4quhza6QX4w/7bgevdrUmpC58fTbCbNlF/cSUyVJvh6zxtf7zTlVZGrOYmsN2xTTeS+oRl0orKiD7BR/ZEhqvZWIfrvqBS//5h9NJdRWzNiR+nNuTRWomYbsLcJxWaUCiXy2I6Q6Tr2BPliN8xPtX7+9f9Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R/77HBPl; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=18tp2DX9OqoEURmphhrYz22jloqtedKHeleStMqFFkQ=; b=R/77HBPlxz7Jum8NEPWrGPBjwE
	4r3P6T+wFFGwzaoeqhgdJnsP9Mxzbjull9ScpfQ7JZHGnj4jxu3e/2l2TNVxDjN9fugwytXJQwoIF
	zyDmzaBOe43guFLpPbsLM6EENBVyHkH6N6kdfYS75eNzrm4tpEsTOt1+gddIixIQy9PQFQ22hjSB3
	KItTKKBLPRW5Z1I5oJTAEYhP6MO2VNbVDpwJx07nxS5A/MIdZkPQwGHkd4ZNLQqGTW+QNPv5WKIV4
	weogKRyU69OnfeH2sjesQEI0Hlg4BUvmutzrlaYTz50S5jjH191xsx0R2bxeNKeJyvQHai2uaBAvq
	7hVJr0aw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uEo56-0000000Gy4a-1Ff1;
	Tue, 13 May 2025 11:45:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E256E30066A; Tue, 13 May 2025 13:45:55 +0200 (CEST)
Date: Tue, 13 May 2025 13:45:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Sebastian Ott <sebott@redhat.com>,
	Shusen Li <lishusen2@huawei.com>, Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Potapenko <glider@google.com>, kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Atish Patra <atishp@atishpatra.org>,
	Joey Gouly <joey.gouly@arm.com>, x86@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	linux-riscv@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexandre Ghiti <alex@ghiti.fr>, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvm-riscv@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH v5 0/6] KVM: lockdep improvements
Message-ID: <20250513114555.GF25763@noisy.programming.kicks-ass.net>
References: <20250512180407.659015-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512180407.659015-1-mlevitsk@redhat.com>

On Mon, May 12, 2025 at 02:04:01PM -0400, Maxim Levitsky wrote:
> This is	a continuation of my 'extract lock_all_vcpus/unlock_all_vcpus'
> patch series.
> 
> Implement the suggestion of using lockdep's "nest_lock" feature
> when locking all KVM vCPUs by adding mutex_trylock_nest_lock() and
> mutex_lock_killable_nest_lock() and use these functions	in the
> implementation of the
> kvm_trylock_all_vcpus()/kvm_lock_all_vcpus()/kvm_unlock_all_vcpus().
> 
> Those changes allow removal of a custom workaround that was needed to
> silence the lockdep warning in the SEV code and also stop lockdep from
> complaining in case of ARM and RISC-V code which doesn't include the above
> mentioned workaround.
> 
> Finally, it's worth noting that this patch series removes a fair
> amount of duplicate code by implementing the logic in one place.
> 
> V5: addressed review feedback.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (6):
>   locking/mutex: implement mutex_trylock_nested
>   locking/mutex: implement mutex_lock_killable_nest_lock
>   KVM: add kvm_lock_all_vcpus and kvm_trylock_all_vcpus
>   x86: KVM: SVM: use kvm_lock_all_vcpus instead of a custom
>     implementation
>   KVM: arm64: use kvm_trylock_all_vcpus when locking all vCPUs
>   RISC-V: KVM: use kvm_trylock_all_vcpus when locking all vCPUs
> 
>  arch/arm64/include/asm/kvm_host.h     |  3 --
>  arch/arm64/kvm/arch_timer.c           |  4 +-
>  arch/arm64/kvm/arm.c                  | 43 ----------------
>  arch/arm64/kvm/vgic/vgic-init.c       |  4 +-
>  arch/arm64/kvm/vgic/vgic-its.c        |  8 +--
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---
>  arch/riscv/kvm/aia_device.c           | 34 +------------
>  arch/x86/kvm/svm/sev.c                | 72 ++-------------------------
>  include/linux/kvm_host.h              |  4 ++
>  include/linux/mutex.h                 | 32 ++++++++++--
>  kernel/locking/mutex.c                | 21 +++++---
>  virt/kvm/kvm_main.c                   | 59 ++++++++++++++++++++++
>  12 files changed, 126 insertions(+), 170 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

