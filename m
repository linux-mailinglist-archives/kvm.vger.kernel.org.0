Return-Path: <kvm+bounces-21270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1BC92CB4C
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D53A2848AA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 06:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2E871747;
	Wed, 10 Jul 2024 06:46:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BB024A08
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 06:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720593963; cv=none; b=ezEp1Olb8h57Bo6alKKJypZgwnJZoqZqS1ggpHDIP6zzCm3LnVuq1kTPAadeKcxfyRyLRY6kyyPzRvdRTCCH9NHupvzrshJl2YFHFdj/k3ZyWjE/DCtKIgPZQS3UOJP25ggxpSmKQwhztLKU0Tnnl4G3ntpJ14r6q1M6yrUFH+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720593963; c=relaxed/simple;
	bh=rjxdIKcaUXlPXDV1eujiA5N1EnyN7T2oOR3DLcoxbvY=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BSGN9rV5kOP4IZGZQgN/vsUUBHhjXaj9D2c12arE/HavEn5wRA7Jc7sm/a1jlSwd4ylAFWqbbkMwFX7S7RaqvYPSA9r/rzx7Jq+So5laxZ4+hr+H6pBcxgOsXgiPYR/Jlyy+T1MXB6O5xGRXc0g0ZlvZcNHS4k9PcB6vRr9heeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WJpDp58XXzQkM5;
	Wed, 10 Jul 2024 14:42:02 +0800 (CST)
Received: from kwepemd500014.china.huawei.com (unknown [7.221.188.63])
	by mail.maildlp.com (Postfix) with ESMTPS id 578CF140416;
	Wed, 10 Jul 2024 14:45:58 +0800 (CST)
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemd500014.china.huawei.com (7.221.188.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Wed, 10 Jul 2024 14:45:52 +0800
Subject: Re: [PATCH v3 00/17] KVM: arm64: Allow using VHE in the nVHE
 hypervisor
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
	<yuzenghui@huawei.com>, Quentin Perret <qperret@google.com>, Will Deacon
	<will@kernel.org>, Fuad Tabba <tabba@google.com>, "guoyang (C)"
	<guoyang2@huawei.com>
References: <20230609162200.2024064-1-maz@kernel.org>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <5ab07210-ad44-616c-cd15-0ac954453fcf@huawei.com>
Date: Wed, 10 Jul 2024 14:45:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd500014.china.huawei.com (7.221.188.63)

Hi Marz,

I'm trying to learn pKVM and have a question.

Why pKVM developed on E2H=0 firstly? It tried to avoid host access guest memory

with stage2 translation, and it seems not necessarily rely on HCR_EL2.E2H=0.

Is hVHE an alternative plan of pKVM ? To allow pKVM run on E2H res1 system ?


Thanks for your help.

Nianyao Tang.


On 6/10/2023 0:21, Marc Zyngier wrote:
> KVM (on ARMv8.0) and pKVM (on all revisions of the architecture) use
> the split hypervisor model that makes the EL2 code more or less
> standalone. In the later case, we totally ignore the VHE mode and
> stick with the good old v8.0 EL2 setup.
>
> This is all good, but means that the EL2 code is limited in what it
> can do with its own address space. This series proposes to remove this
> limitation and to allow VHE to be used even with the split hypervisor
> model. This has some potential isolation benefits[1], and eventually
> allow systems that do not support HCR_EL2.E2H==0 to run pKVM.
>
> We introduce a new "mode" for KVM called hVHE, in reference to the
> nVHE mode, and indicating that only the hypervisor is using VHE. Note
> that this is all this series does. No effort is made to improve the VA
> space management, which will be the subject of another series if this
> one ever makes it.
>
> This has been tested on a M1 box (bare metal) as well as as a nested
> guest on M2, both with the standard nVHE and protected modes, with no
> measurable change in performance.
>
> Note: the last patch of this series is not a merge candidate.
>
> Thanks,
>
>         M.
>
> [1] https://www.youtube.com/watch?v=1F_Mf2j9eIo&list=PLbzoR-pLrL6qWL3v2KOcvwZ54-w0z5uXV&index=11
>
> * From v2:
>   - Use BUILD_BUG_ON() to prevent the use of is_kernel_in_hyp_mode()
>     form hypervisor context
>   - Validate that all CPUs are VHE-capable before flipping the
>     capability
>
> * From v1:
>   - Fixed CNTHCTL_EL2 setup when switching from E2H=0 to E2H=1
>     Amusingly, this was found on NV...
>   - Rebased on 6.4-rc2
>
> Marc Zyngier (17):
>   KVM: arm64: Drop is_kernel_in_hyp_mode() from
>     __invalidate_icache_guest_page()
>   arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
>   arm64: Turn kaslr_feature_override into a generic SW feature override
>   arm64: Add KVM_HVHE capability and has_hvhe() predicate
>   arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
>   arm64: Allow EL1 physical timer access when running VHE
>   arm64: Use CPACR_EL1 format to set CPTR_EL2 when E2H is set
>   KVM: arm64: Remove alternatives from sysreg accessors in VHE
>     hypervisor context
>   KVM: arm64: Key use of VHE instructions in nVHE code off
>     ARM64_KVM_HVHE
>   KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
>   KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
>   KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set
>   KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration
>   KVM: arm64: Program the timer traps with VHE layout in hVHE mode
>   KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set
>   arm64: Allow arm64_sw.hvhe on command line
>   KVM: arm64: Terrible timer hack for M1 with hVHE
>
>  arch/arm64/include/asm/arch_timer.h     |  8 ++++
>  arch/arm64/include/asm/cpufeature.h     |  5 +++
>  arch/arm64/include/asm/el2_setup.h      | 26 ++++++++++++-
>  arch/arm64/include/asm/kvm_arm.h        |  4 +-
>  arch/arm64/include/asm/kvm_asm.h        |  1 +
>  arch/arm64/include/asm/kvm_emulate.h    | 33 +++++++++++++++-
>  arch/arm64/include/asm/kvm_hyp.h        | 37 +++++++++++++-----
>  arch/arm64/include/asm/kvm_mmu.h        |  3 +-
>  arch/arm64/include/asm/virt.h           | 12 +++++-
>  arch/arm64/kernel/cpufeature.c          | 21 +++++++++++
>  arch/arm64/kernel/hyp-stub.S            | 10 ++++-
>  arch/arm64/kernel/idreg-override.c      | 25 ++++++++-----
>  arch/arm64/kernel/image-vars.h          |  3 ++
>  arch/arm64/kernel/kaslr.c               |  6 +--
>  arch/arm64/kvm/arch_timer.c             |  5 +++
>  arch/arm64/kvm/arm.c                    | 12 +++++-
>  arch/arm64/kvm/fpsimd.c                 |  4 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  9 +++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 17 ++++++++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 27 ++++++++++---
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 28 ++++++++------
>  arch/arm64/kvm/hyp/nvhe/timer-sr.c      | 25 +++++++++++--
>  arch/arm64/kvm/hyp/pgtable.c            |  6 ++-
>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>  arch/arm64/kvm/sys_regs.c               |  2 +-
>  arch/arm64/tools/cpucaps                |  1 +
>  drivers/irqchip/irq-apple-aic.c         | 50 ++++++++++++++++++++++++-
>  28 files changed, 320 insertions(+), 64 deletions(-)
>


