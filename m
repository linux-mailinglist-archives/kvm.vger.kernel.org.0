Return-Path: <kvm+bounces-46467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89752AB67A8
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 11:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B3361B65C62
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B523222A4EF;
	Wed, 14 May 2025 09:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdb0oWYG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF291CEAC2;
	Wed, 14 May 2025 09:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747215339; cv=none; b=YiMtJQMiyRD5VuTYQTMBoiy8tCEL/OymlhtGGdTSb7Bap7BbF8V/mAe83ohBVB7vBfrY+uXQBlo0UzWh0fx/oF4vPCHSYKicwsFjIq6GahEcJrKIm9xgbgKDvEQBMsNcHgBcXfoBd13XOl+0wWHWXAuj8ONQMUx4KJJdWSWi2lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747215339; c=relaxed/simple;
	bh=N2PyXM6FROVcSjSIaLYgCMb3dTsbrl7AJSDQN1U1u04=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJP9YO/Iwj5CshpZx8yFI6w703mFLlUkxVlMNnutQNiMHaH2QgIxvQ95mV3PNMHDIlrynEek2GOa48qBkKGpBaOqgp1ITYBOVUzqctE0fyEPVTJz4p/4nTmSr6IMJmkRQXvP9TRSC8nBE/3EWZzBfxArF+WEKcVRSc/3DPqZ0Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdb0oWYG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEC1C4CEE9;
	Wed, 14 May 2025 09:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747215339;
	bh=N2PyXM6FROVcSjSIaLYgCMb3dTsbrl7AJSDQN1U1u04=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sdb0oWYGPRGVW14S3qNFZmDkY9UlrzgIiVO2KW3FIHise3aozpuClrVvg29x5PCuh
	 sA8kwGptwEpyb7KayZQCIuStyDbL/xBbLe3pxmOPlZwWD6odYjxty0XwWKh+8un3LZ
	 hVtwNKNkiPlVRZbFvrsa6Vg9WmK5sutPdaUztj/YtaRfyjDglPrnoLqtbB4+uL4/XA
	 kffcDcNjRtEIwbIaA5yQU28F4FHBTdKqRG93lwktG1yguWMZl0Zrl8ig4FMknu9NFm
	 a/rZx8I2ciedLFbT9r4p43cQCag6PXZlU6X1NpHcANKW/DWt2RkaWLgydaGgQMHMjN
	 9R4o4hpyLrVmw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF8WW-00Ens4-VE;
	Wed, 14 May 2025 10:35:37 +0100
Date: Wed, 14 May 2025 10:35:36 +0100
Message-ID: <86msbffsbb.wl-maz@kernel.org>
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
Subject: Re: [PATCH v5 5/6] KVM: arm64: use kvm_trylock_all_vcpus when locking all vCPUs
In-Reply-To: <20250512180407.659015-6-mlevitsk@redhat.com>
References: <20250512180407.659015-1-mlevitsk@redhat.com>
	<20250512180407.659015-6-mlevitsk@redhat.com>
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

On Mon, 12 May 2025 19:04:06 +0100,
Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> Use kvm_trylock_all_vcpus instead of a custom implementation when locking
> all vCPUs of a VM, to avoid triggering a lockdep warning, in the case in
> which the VM is configured to have more than MAX_LOCK_DEPTH vCPUs.
> 
> This fixes the following false lockdep warning:
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
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Acked-by: Marc Zyngier <maz@kernel.org>

Paolo: if you are queuing this for 6.16, please put it on a stable
branch so that I can merge it back in case of conflicts.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

