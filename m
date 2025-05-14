Return-Path: <kvm+bounces-46466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBBAAB679B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 11:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF9391B65A69
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9ACF22A7FC;
	Wed, 14 May 2025 09:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oAqFqcpm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C3227E8A;
	Wed, 14 May 2025 09:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747215235; cv=none; b=B76UWwN9vWPC4WzfxkJrb3VljHpOKbTjZgZuAPVDmAS0kHtYK1gDSgL9ogVvT058S8Ld9W4zO5vecw3ZzgMiRfzn1NtIxFZ7zUlOUg7Tio95R3mD55afjt/+VLq8mYP07ywlnmxTLba+HPA9f/mwM3F8Yf4wFY8ATINh00ZhzDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747215235; c=relaxed/simple;
	bh=001qyor2xDVXczQ1I1uPsfetah7D3sKu1ILOVywqFnk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=goWf0DO5l/T9yiK+dvpM0wRWtQ0HuuEggh8wFvvOF4+Y304Oke925OXf6bHfNrYg/bUJjwTxrYRPF3yJMFY+d4GprFfUXVnbTeBHcD467z76eqiJ0uIxb3wKKr6+QYldQKq7p82izdxYm1Aksuw/ak2xIq2xtmRo1aNLTXESwlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oAqFqcpm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45060C4CEE9;
	Wed, 14 May 2025 09:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747215234;
	bh=001qyor2xDVXczQ1I1uPsfetah7D3sKu1ILOVywqFnk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oAqFqcpmzH/13hbR8m/oQ4XroGsKo3tle3aJJsWrsQtLYro2z+PLvjOsuG88n/OxJ
	 34FvuHxK9/XH2rEkDkqevKA3Zm4RLx3TeYfuRmhdCmm/8LPM9f2joGVL1/H9yAQ2w7
	 qw+hk6NEElGhiwaleELGFNnRJkOZ8sTl5xHlheBLypOX+6C8a5S5AV5fGR3Ea5F2Iz
	 3/OiHuAPYPcgR16yDChngd6pC8mELRDahRp+jzf2AFxHuz/0wOYB28RUt92XcHMVGT
	 V5A4ofsYMhlnn1DcsOUps8IUWyew4W6IuckFhHB5U55kOM/su9P9yW9kj58iy2KjS3
	 ibRlwfrHxQdpg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF8Up-00Ennz-DL;
	Wed, 14 May 2025 10:33:51 +0100
Date: Wed, 14 May 2025 10:33:50 +0100
Message-ID: <86o6vvfse9.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shusen Li <lishusen2@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Anup Patel <anup@brainfault.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Potapenko <glider@google.com>,
	kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Atish Patra <atishp@atishpatra.org>,
	Joey Gouly <joey.gouly@arm.com>,
	x86@kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	linux-riscv@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvm-riscv@lists.infradead.org,
	Ingo Molnar <mingo@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH v5 3/6] KVM: add kvm_lock_all_vcpus and kvm_trylock_all_vcpus
In-Reply-To: <20250512180407.659015-4-mlevitsk@redhat.com>
References: <20250512180407.659015-1-mlevitsk@redhat.com>
	<20250512180407.659015-4-mlevitsk@redhat.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: mlevitsk@redhat.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, jingzhangos@google.com, hpa@zytor.com, sebott@redhat.com, lishusen2@huawei.com, longman@redhat.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, bhelgaas@google.com, bp@alien8.de, anup@brainfault.org, will@kernel.org, palmer@dabbelt.com, glider@google.com, kvmarm@lists.linux.dev, keisuke.nishimura@inria.fr, yuzenghui@huawei.com, peterz@infradead.org, atishp@atishpatra.org, joey.gouly@arm.com, x86@kernel.org, seanjc@google.com, andre.przywara@arm.com, jiangkunkun@huawei.com, linux-riscv@lists.infradead.org, rdunlap@infradead.org, pbonzini@redhat.com, boqun.feng@gmail.com, catalin.marinas@arm.com, alex@ghiti.fr, linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, oliver.upton@linux.dev, kvm-riscv@lists.infradead.org, mingo@redhat.com, paul.walmsley@sifive.com, aou@eecs.berkeley.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 12 May 2025 19:04:04 +0100,
Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> In a few cases, usually in the initialization code, KVM locks all vCPUs
> of a VM to ensure that userspace doesn't do funny things while KVM performs
> an operation that affects the whole VM.
> 
> Until now, all these operations were implemented using custom code,
> and all of them share the same problem:
> 
> Lockdep can't cope with simultaneous locking of a large number of locks of
> the same class.
> 
> However if these locks are taken while another lock is already held,
> which is luckily the case, it is possible to take advantage of little known
> _nest_lock feature of lockdep which allows in this case to have an
> unlimited number of locks of same class to be taken.
> 
> To implement this, create two functions:
> kvm_lock_all_vcpus() and kvm_trylock_all_vcpus()
> 
> Both functions are needed because some code that will be replaced in
> the subsequent patches, uses mutex_trylock, instead of regular mutex_lock.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Acked-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Without deviation from the norm, progress is not possible.

