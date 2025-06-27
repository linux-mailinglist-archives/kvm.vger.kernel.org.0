Return-Path: <kvm+bounces-50979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F12D0AEB525
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 12:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 402D31C4160D
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2899E266562;
	Fri, 27 Jun 2025 10:37:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83892989A7;
	Fri, 27 Jun 2025 10:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020671; cv=none; b=cB22uGRpSSpS8OLRaMEum/etpYa1JtlKKlVJz+4aR3x6WcCPMubq8DQ7pAvUAUPFJjZDGOJnaUjNkGhqvwKLCymFKALYn9Ad7+Bv/tMMgHB9JueKOA461580HHZ9YgJk8R5W3TZTy5Q7Knvxzh13FsElaORvwFhNzFrJ+jFa+E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020671; c=relaxed/simple;
	bh=3O52TgpgRoSKwiLFYIvR9/AgjAWdfHaU9zTqfIjOXU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MP58kKkSKRlDRFw88DNzqIXvrWdOS7Byb/cC02iZsUvHAEpE/YltOeUjgw0qqlyIjbpCWTm2WM6/iWJ0iFDost2OUQGXYmP8MyLscSLzSCTx9N2mjHE7fm4j5olXLDiMIlJErFPJJi3DNkkPCvWEjICugM3B/v6xB+goNTyMnqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 023AB1A00;
	Fri, 27 Jun 2025 03:37:32 -0700 (PDT)
Received: from [10.1.31.20] (e122027.cambridge.arm.com [10.1.31.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A43443F58B;
	Fri, 27 Jun 2025 03:37:44 -0700 (PDT)
Message-ID: <f1cdef31-1427-48ea-a741-a48e8b366093@arm.com>
Date: Fri, 27 Jun 2025 11:37:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/43] arm64: Support for Arm CCA in KVM
To: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>,
 "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
 "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
Cc: 'Catalin Marinas' <catalin.marinas@arm.com>,
 'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
 'James Morse' <james.morse@arm.com>, 'Oliver Upton'
 <oliver.upton@linux.dev>, 'Suzuki K Poulose' <suzuki.poulose@arm.com>,
 'Zenghui Yu' <yuzenghui@huawei.com>,
 "'linux-arm-kernel@lists.infradead.org'"
 <linux-arm-kernel@lists.infradead.org>,
 "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
 'Joey Gouly' <joey.gouly@arm.com>,
 'Alexandru Elisei' <alexandru.elisei@arm.com>,
 'Christoffer Dall' <christoffer.dall@arm.com>,
 'Fuad Tabba' <tabba@google.com>,
 "'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>,
 'Ganapatrao Kulkarni' <gankulkarni@os.amperecomputing.com>,
 'Gavin Shan' <gshan@redhat.com>,
 'Shanker Donthineni' <sdonthineni@nvidia.com>,
 'Alper Gun' <alpergun@google.com>,
 "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
References: <20250611104844.245235-1-steven.price@arm.com>
 <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
Content-Language: en-GB
From: Steven Price <steven.price@arm.com>
In-Reply-To: <TYXPR01MB1886280D98B07E971424D62BC37BA@TYXPR01MB1886.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 25/06/2025 02:51, Emi Kisanuki (Fujitsu) wrote:
> We tested this patch in our internal simulator which is a hardware simulator for Fujitsu's next generation CPU known as Monaka. and it produced the expected results.
> 
> I have verified the following
> 1. Launching the realm VM using Internal simulator -> Successfully launched by disabling MPAM support in the ID register.
> 2. Running kvm-unit-tests (with lkvm) -> All tests passed except for PMU (as expected, since PMU is not supported by the Internal simulator).[1]
> 
> Tested-by: Emi Kisanuki <fj0570is@fujitsu.com> [1] https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/latest

Thank you for testing!

Regards,
Steve

> 
>> This series adds support for running protected VMs using KVM under the Arm
>> Confidential Compute Architecture (CCA).
>>
>> The related guest support was merged for v6.14-rc1 so you no longer need that
>> separately.
>>
>> There are a few changes since v8, many thanks for the review comments. The
>> highlights are below, and individual patches have a changelog.
>>
>>  * NV support is now upstream, so this series no longer conflicts.
>>
>>  * Tidied up RTT accounting by providing wrapper functions to call
>>    kvm_account_pgtable_pages() only when appropriate.
>>
>>  * Propagate the 'may_block' flag to enable cond_resched calls only when
>>    appropriate.
>>
>>  * Reduce code duplication between INIT_RIPAS and SET_RIPAS.
>>
>>  * Various code improvements from the reviews - many thanks!
>>
>>  * Rebased onto v6.16-rc1.
>>
>> Things to note:
>>
>>  * The magic numbers for capabilities and ioctls have been updated. So
>>    you'll need to update your VMM. See below for update kvmtool branch.
>>
>>  * Patch 42 increases KVM_VCPU_MAX_FEATURES to expose the new feature.
>>
>> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[1].
>>
>> This series is based on v6.16-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v9
>>
>> Work in progress changes for kvmtool are available from the git repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v7
>>
>> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
>>
>> Jean-Philippe Brucker (7):
>>   arm64: RME: Propagate number of breakpoints and watchpoints to
>>     userspace
>>   arm64: RME: Set breakpoint parameters through SET_ONE_REG
>>   arm64: RME: Initialize PMCR.N with number counter supported by RMM
>>   arm64: RME: Propagate max SVE vector length from RMM
>>   arm64: RME: Configure max SVE vector length for a Realm
>>   arm64: RME: Provide register list for unfinalized RME RECs
>>   arm64: RME: Provide accurate register list
>>
>> Joey Gouly (2):
>>   arm64: RME: allow userspace to inject aborts
>>   arm64: RME: support RSI_HOST_CALL
>>
>> Steven Price (31):
>>   arm64: RME: Handle Granule Protection Faults (GPFs)
>>   arm64: RME: Add SMC definitions for calling the RMM
>>   arm64: RME: Add wrappers for RMI calls
>>   arm64: RME: Check for RME support at KVM init
>>   arm64: RME: Define the user ABI
>>   arm64: RME: ioctls to create and configure realms
>>   KVM: arm64: Allow passing machine type in KVM creation
>>   arm64: RME: RTT tear down
>>   arm64: RME: Allocate/free RECs to match vCPUs
>>   KVM: arm64: vgic: Provide helper for number of list registers
>>   arm64: RME: Support for the VGIC in realms
>>   KVM: arm64: Support timers in realm RECs
>>   arm64: RME: Allow VMM to set RIPAS
>>   arm64: RME: Handle realm enter/exit
>>   arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
>>   KVM: arm64: Handle realm MMIO emulation
>>   arm64: RME: Allow populating initial contents
>>   arm64: RME: Runtime faulting of memory
>>   KVM: arm64: Handle realm VCPU load
>>   KVM: arm64: Validate register access for a Realm VM
>>   KVM: arm64: Handle Realm PSCI requests
>>   KVM: arm64: WARN on injected undef exceptions
>>   arm64: Don't expose stolen time for realm guests
>>   arm64: RME: Always use 4k pages for realms
>>   arm64: RME: Prevent Device mappings for Realms
>>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>>   arm64: RME: Enable PMU support with a realm guest
>>   arm64: RME: Hide KVM_CAP_READONLY_MEM for realm guests
>>   KVM: arm64: Expose support for private memory
>>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>>   KVM: arm64: Allow activating realms
>>
>> Suzuki K Poulose (3):
>>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>>   kvm: arm64: Don't expose debug capabilities for realm guests
>>   arm64: RME: Allow checking SVE on VM instance
>>
>>  Documentation/virt/kvm/api.rst       |   94 +-
>>  arch/arm64/include/asm/kvm_emulate.h |   40 +
>>  arch/arm64/include/asm/kvm_host.h    |   17 +-
>>  arch/arm64/include/asm/kvm_rme.h     |  139 ++
>>  arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
>>  arch/arm64/include/asm/rmi_smc.h     |  268 ++++
>>  arch/arm64/include/asm/virt.h        |    1 +
>>  arch/arm64/include/uapi/asm/kvm.h    |   49 +
>>  arch/arm64/kvm/Kconfig               |    1 +
>>  arch/arm64/kvm/Makefile              |    3 +-
>>  arch/arm64/kvm/arch_timer.c          |   48 +-
>>  arch/arm64/kvm/arm.c                 |  168 ++-
>>  arch/arm64/kvm/guest.c               |  108 +-
>>  arch/arm64/kvm/hypercalls.c          |    4 +-
>>  arch/arm64/kvm/inject_fault.c        |    5 +-
>>  arch/arm64/kvm/mmio.c                |   16 +-
>>  arch/arm64/kvm/mmu.c                 |  207 ++-
>>  arch/arm64/kvm/pmu-emul.c            |    6 +
>>  arch/arm64/kvm/psci.c                |   30 +
>>  arch/arm64/kvm/reset.c               |   23 +-
>>  arch/arm64/kvm/rme-exit.c            |  207 +++
>>  arch/arm64/kvm/rme.c                 | 1743
>> ++++++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c            |   53 +-
>>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>>  arch/arm64/kvm/vgic/vgic-v3.c        |    6 +-
>>  arch/arm64/kvm/vgic/vgic.c           |   60 +-
>>  arch/arm64/mm/fault.c                |   31 +-
>>  drivers/perf/arm_pmu.c               |   15 +
>>  include/kvm/arm_arch_timer.h         |    2 +
>>  include/kvm/arm_pmu.h                |    4 +
>>  include/kvm/arm_psci.h               |    2 +
>>  include/linux/perf/arm_pmu.h         |    5 +
>>  include/uapi/linux/kvm.h             |   29 +-
>>  33 files changed, 3790 insertions(+), 104 deletions(-)  create mode 100644
>> arch/arm64/include/asm/kvm_rme.h  create mode 100644
>> arch/arm64/include/asm/rmi_cmds.h  create mode 100644
>> arch/arm64/include/asm/rmi_smc.h  create mode 100644
>> arch/arm64/kvm/rme-exit.c  create mode 100644 arch/arm64/kvm/rme.c
>>
>> --
>> 2.43.0
> 


