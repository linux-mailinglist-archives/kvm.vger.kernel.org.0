Return-Path: <kvm+bounces-55708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4510B34F89
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 01:09:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F4752A67DC
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 23:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC392C033C;
	Mon, 25 Aug 2025 23:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="GTT5fOzU"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EA723D7C3;
	Mon, 25 Aug 2025 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756163342; cv=none; b=kn5irwqVbgONcPwayA2oknlYpS0427wJMCJg1pF/wg5VZ1oATBGz3YNCg9ybFJGsncGGQkwViKO6Zd+oxbbUtzj8OikyCYvQ/m+ursH2PWSMYlhnO7dRB32e8vftUEO6oVg/RnHFmITyB1Mb/AdXCPterrC0xCEInUAiKmbc+AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756163342; c=relaxed/simple;
	bh=Fz172bfnT2fDc0B5BW9KQC8VQwSCH+A00nsF+R3Nznk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hz+aKgpJdS3JUod7kXUBD2/nkVJSpiysPW4oa4ySdYm3lpsEga2G1EqOQKu94HiY+ebSQtbFESFb6CiU8vrPHVEbe8eJSQWcuk4JbRcb1SlJ3du8gHgWHCDemEaKkRsqSQJDHZH2uLBS++ih/zQWEhX1jmSwA7teJ9QtS01DZSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=GTT5fOzU; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.64.0.200] (unknown [20.29.225.195])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1E032211829D;
	Mon, 25 Aug 2025 16:08:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1E032211829D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1756163339;
	bh=yjj+T4F6X5Rb2NiUbWNootXcw5MYUgeaYi89zI0rqQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GTT5fOzUX6bjgmJRyTtl5Nlh5JACcr0YCsgajA504/VguHTsD2kG9KDvDG5alk+gF
	 AlqgkFhhFVQMT3abN68Y5Bm44usX4MzHqG7q2W8uP1gfSybPvK8eBGyTYKXvPevQWI
	 Yg63eHOsilGGsMx/M0Y6URyOnRsPjGUV5RxxijdQ=
Message-ID: <3188ca61-2591-4576-9777-1671689b7235@linux.microsoft.com>
Date: Mon, 25 Aug 2025 16:08:45 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common
 APIs
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
References: <20250825200622.3759571-1-seanjc@google.com>
Content-Language: en-US
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
In-Reply-To: <20250825200622.3759571-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/25/2025 1:06 PM, Sean Christopherson wrote:
> Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
> deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
> more generic "virt" APIs (which ideally would have been done when MSHV root
> support was added).
> 
> Assuming all is well, maybe this could go through the tip tree?
> 
> The Hyper-V stuff and non-x86 architectures are compile-tested only.
> 

Thanks Sean, I can test the root partition changes.

A similar change will be needed in mshv_vtl_main.c since it also calls
mshv_do_pre_guest_mode_work() (hence the "common" in mshv_common.c).

Also, is it possible to make all the mshv driver changes in a single patch?
It seems like it would be cleaner than refactoring it in patches 1 & 2 and
then deleting all the refactored code in patch 5.

Thanks
Nuno

> Sean Christopherson (5):
>   Drivers: hv: Move TIF pre-guest work handling fully into mshv_common.c
>   Drivers: hv: Handle NEED_RESCHED_LAZY before transferring to guest
>   entry/kvm: KVM: Move KVM details related to signal/-EINTR into KVM
>     proper
>   entry: Rename "kvm" entry code assets to "virt" to genericize APIs
>   Drivers: hv: Use common "entry virt" APIs to do work before running
>     guest
> 
>  MAINTAINERS                                 |  2 +-
>  arch/arm64/kvm/Kconfig                      |  2 +-
>  arch/arm64/kvm/arm.c                        |  3 +-
>  arch/loongarch/kvm/Kconfig                  |  2 +-
>  arch/loongarch/kvm/vcpu.c                   |  3 +-
>  arch/riscv/kvm/Kconfig                      |  2 +-
>  arch/riscv/kvm/vcpu.c                       |  3 +-
>  arch/x86/kvm/Kconfig                        |  2 +-
>  arch/x86/kvm/vmx/vmx.c                      |  1 -
>  arch/x86/kvm/x86.c                          |  3 +-
>  drivers/hv/Kconfig                          |  1 +
>  drivers/hv/mshv.h                           |  2 --
>  drivers/hv/mshv_common.c                    | 22 ---------------
>  drivers/hv/mshv_root_main.c                 | 31 ++++-----------------
>  include/linux/{entry-kvm.h => entry-virt.h} | 19 +++++--------
>  include/linux/kvm_host.h                    | 17 +++++++++--
>  include/linux/rcupdate.h                    |  2 +-
>  kernel/entry/Makefile                       |  2 +-
>  kernel/entry/{kvm.c => virt.c}              | 15 ++++------
>  kernel/rcu/tree.c                           |  6 ++--
>  virt/kvm/Kconfig                            |  2 +-
>  21 files changed, 49 insertions(+), 93 deletions(-)
>  rename include/linux/{entry-kvm.h => entry-virt.h} (83%)
>  rename kernel/entry/{kvm.c => virt.c} (66%)
> 
> 
> base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00


