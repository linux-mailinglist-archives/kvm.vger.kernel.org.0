Return-Path: <kvm+bounces-71119-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNF9MK8Ok2k71QEAu9opvQ
	(envelope-from <kvm+bounces-71119-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:33:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 254021435BE
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 13:33:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55E6F3009B05
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 12:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2162E1DBB3A;
	Mon, 16 Feb 2026 12:33:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A0C18024;
	Mon, 16 Feb 2026 12:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771245219; cv=none; b=pzR48isuY+kMpKsferKR71TXYGkpxq3ravOIw6vg7CT4uAve8vtLBVP+bpK/irbxQ8icTw0OfgLoAGOrfpQr/pMtK98T1sNgn1L8y+XRAd4MhfXDmXExmPPuAAj46Pgj0z92Is7g5VuA739fIgMXwzrl8ctBk2M4J1XUd1Jdsa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771245219; c=relaxed/simple;
	bh=oVulCBIAyL2Z3oHyKN1bQey3QNZZKFbQdOzacwJbT6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KVHy179TYhhRb4upR3f4V73ZkKM9YGLJsobWM1YzBbMmegEiCEqhiM/ZKqdHCnCo/p9gJIB6hh8KyszB7fPMnMUDE8N0YxPH3ZMrzUBeIBBj928LchUmghxbh7qseyn2HKeWm8wpILdIB7OdJhzN6qYjSefNaA4lJ9UqtiDI2Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CBC5150C;
	Mon, 16 Feb 2026 04:33:31 -0800 (PST)
Received: from [10.57.56.155] (unknown [10.57.56.155])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 014843F73F;
	Mon, 16 Feb 2026 04:33:32 -0800 (PST)
Message-ID: <55fc4877-666c-4d5f-a167-5692f7cfbd0b@arm.com>
Date: Mon, 16 Feb 2026 12:33:31 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 00/46] arm64: Support for Arm CCA in KVM
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <aY4Sf4lMlWd9LyTo@p14s>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <aY4Sf4lMlWd9LyTo@p14s>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[steven.price@arm.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71119-lists,kvm=lfdr.de];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:url,arm.com:mid]
X-Rspamd-Queue-Id: 254021435BE
X-Rspamd-Action: no action

On 12/02/2026 17:48, Mathieu Poirier wrote:
> Hi Steven,
> 
> On Wed, Dec 17, 2025 at 10:10:37AM +0000, Steven Price wrote:
>> This series adds support for running protected VMs using KVM under the
>> Arm Confidential Compute Architecture (CCA). I've changed the uAPI
>> following feedback from Marc.
>>
>> The main change is that rather than providing a multiplex CAP and
>> expecting the VMM to drive the different stages of realm construction,
>> there's now just a minimal interface and KVM performs the necessary
>> operations when needed.
>>
>> This series is lightly tested and is meant as a demonstration of the new
>> uAPI. There are a number of (known) rough corners in the implementation
>> that I haven't dealt with properly.
>>
>> In particular please note that this series is still targetting RMM v1.0.
>> There is an alpha quality version of RMM v2.0 available[1]. Feedback was
>> that there are a number of blockers for merging with RMM v1.0 and so I
>> expect to rework this series to support RMM v2.0 before it is merged.
>> That will necessarily involve reworking the implementation.
>>
>> Specifically I'm expecting improvements in:
>>
>>  * GIC handling - passing state in registers, and allowing the host to
>>    fully emulate the GIC by allowing trap bits to be set.
>>
>>  * PMU handling - again providing flexibility to the host's emulation.
>>
>>  * Page size/granule size mismatch. RMM v1.0 defines the granule as 4k,
>>    RMM v2.0 provide the option for the host to change the granule size.
>>    The intention is that Linux would simply set the granule size equal
>>    to its page size which will significantly simplify the management of
>>    granules.
>>
>>  * Some performance improvement from the use of range-based map/unmap
>>    RMI calls.
>>
>> This series is based on v6.19-rc1. It is also available as a git
>> repository:
>>
>> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v12
>>
>> Work in progress changes for kvmtool are available from the git
>> repository below:
>>
>> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v10
> 
> The first thing to note is that branch cca/v10 does not compile due to function
> realm_configure_parameters() not being called anywhere.  Marking the function as
> [[maybe_unused]] solved the problem on my side.

This is in the kvmtool code - and yes I agree "work in progress" is a
bit generous for the current state of that code, "horrid ugly hacks to
get things working" is probably more accurate ;)

The issue here is that the two things that realm_configure_parameters()
set up (hash algorithm and RPV) are currently unsupported with the Linux
changes, but will need to be reintroduced in the future. So the contents
of the functions which set this up (using the old uAPI) are just #if 0'd
out.

Depending on the compile flags the code will compile with a warning, but
using __attribute__((unused)) would at least make this clear. I'd want
to avoid the "[[maybe_unused]]" as it's not used elsewhere in the code
base and limits compatibility.

> Using the FVP emulator, booting a Realm that includes EDK2 in its boot stack
> worked.  If EDK2 is not part of the boot stack and a kernel is booted directly
> from lkvm, mounting the initrd fails.  Looking into this issue further, I see
> that from a Realm kernel's perspective, the content of the initrd is either
> encrypted or has been trampled on.  

I can reproduce that, a quick fix is to change INITRD_ALIGN:

#define INITRD_ALIGN	SZ_64K

But the code was meant to be able to deal with an unaligned initrd -
I'll see if I can figure out what's going wrong.

Thanks,
Steve

> I'd be happy to provide more details on the above, just let me know.
> 
> Thanks,
> Mathieu
> 
>>
>> [1] https://developer.arm.com/documentation/den0137/latest/
>>
>> Jean-Philippe Brucker (7):
>>   arm64: RMI: Propagate number of breakpoints and watchpoints to
>>     userspace
>>   arm64: RMI: Set breakpoint parameters through SET_ONE_REG
>>   arm64: RMI: Initialize PMCR.N with number counter supported by RMM
>>   arm64: RMI: Propagate max SVE vector length from RMM
>>   arm64: RMI: Configure max SVE vector length for a Realm
>>   arm64: RMI: Provide register list for unfinalized RMI RECs
>>   arm64: RMI: Provide accurate register list
>>
>> Joey Gouly (2):
>>   arm64: RMI: allow userspace to inject aborts
>>   arm64: RMI: support RSI_HOST_CALL
>>
>> Steven Price (34):
>>   arm64: RME: Handle Granule Protection Faults (GPFs)
>>   arm64: RMI: Add SMC definitions for calling the RMM
>>   arm64: RMI: Add wrappers for RMI calls
>>   arm64: RMI: Check for RMI support at KVM init
>>   arm64: RMI: Define the user ABI
>>   arm64: RMI: Basic infrastructure for creating a realm.
>>   KVM: arm64: Allow passing machine type in KVM creation
>>   arm64: RMI: RTT tear down
>>   arm64: RMI: Activate realm on first VCPU run
>>   arm64: RMI: Allocate/free RECs to match vCPUs
>>   KVM: arm64: vgic: Provide helper for number of list registers
>>   arm64: RMI: Support for the VGIC in realms
>>   KVM: arm64: Support timers in realm RECs
>>   arm64: RMI: Handle realm enter/exit
>>   arm64: RMI: Handle RMI_EXIT_RIPAS_CHANGE
>>   KVM: arm64: Handle realm MMIO emulation
>>   KVM: arm64: Expose support for private memory
>>   arm64: RMI: Allow populating initial contents
>>   arm64: RMI: Set RIPAS of initial memslots
>>   arm64: RMI: Create the realm descriptor
>>   arm64: RMI: Add a VMID allocator for realms
>>   arm64: RMI: Runtime faulting of memory
>>   KVM: arm64: Handle realm VCPU load
>>   KVM: arm64: Validate register access for a Realm VM
>>   KVM: arm64: Handle Realm PSCI requests
>>   KVM: arm64: WARN on injected undef exceptions
>>   arm64: Don't expose stolen time for realm guests
>>   arm64: RMI: Always use 4k pages for realms
>>   arm64: RMI: Prevent Device mappings for Realms
>>   HACK: Restore per-CPU cpu_armpmu pointer
>>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>>   arm64: RMI: Enable PMU support with a realm guest
>>   KVM: arm64: Expose KVM_ARM_VCPU_REC to user space
>>   arm64: RMI: Enable realms to be created
>>
>> Suzuki K Poulose (3):
>>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>>   kvm: arm64: Don't expose unsupported capabilities for realm guests
>>   arm64: RMI: Allow checking SVE on VM instance
>>
>>  Documentation/virt/kvm/api.rst       |   78 +-
>>  arch/arm64/include/asm/kvm_emulate.h |   31 +
>>  arch/arm64/include/asm/kvm_host.h    |   13 +-
>>  arch/arm64/include/asm/kvm_rmi.h     |  137 +++
>>  arch/arm64/include/asm/rmi_cmds.h    |  508 ++++++++
>>  arch/arm64/include/asm/rmi_smc.h     |  269 +++++
>>  arch/arm64/include/asm/virt.h        |    1 +
>>  arch/arm64/kernel/cpufeature.c       |    1 +
>>  arch/arm64/kvm/Kconfig               |    2 +
>>  arch/arm64/kvm/Makefile              |    2 +-
>>  arch/arm64/kvm/arch_timer.c          |   37 +-
>>  arch/arm64/kvm/arm.c                 |  179 ++-
>>  arch/arm64/kvm/guest.c               |   95 +-
>>  arch/arm64/kvm/hypercalls.c          |    4 +-
>>  arch/arm64/kvm/inject_fault.c        |    5 +-
>>  arch/arm64/kvm/mmio.c                |   16 +-
>>  arch/arm64/kvm/mmu.c                 |  214 +++-
>>  arch/arm64/kvm/pmu-emul.c            |    6 +
>>  arch/arm64/kvm/psci.c                |   30 +
>>  arch/arm64/kvm/reset.c               |   13 +-
>>  arch/arm64/kvm/rmi-exit.c            |  207 ++++
>>  arch/arm64/kvm/rmi.c                 | 1663 ++++++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c            |   53 +-
>>  arch/arm64/kvm/vgic/vgic-init.c      |    2 +-
>>  arch/arm64/kvm/vgic/vgic-v2.c        |    6 +-
>>  arch/arm64/kvm/vgic/vgic-v3.c        |   14 +-
>>  arch/arm64/kvm/vgic/vgic.c           |   55 +-
>>  arch/arm64/kvm/vgic/vgic.h           |   20 +-
>>  arch/arm64/mm/fault.c                |   28 +-
>>  drivers/perf/arm_pmu.c               |   20 +
>>  include/kvm/arm_arch_timer.h         |    2 +
>>  include/kvm/arm_pmu.h                |    4 +
>>  include/kvm/arm_psci.h               |    2 +
>>  include/linux/perf/arm_pmu.h         |    7 +
>>  include/uapi/linux/kvm.h             |   42 +-
>>  35 files changed, 3650 insertions(+), 116 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/kvm_rmi.h
>>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>>  create mode 100644 arch/arm64/kvm/rmi-exit.c
>>  create mode 100644 arch/arm64/kvm/rmi.c
>>
>> -- 
>> 2.43.0
>>
>>


