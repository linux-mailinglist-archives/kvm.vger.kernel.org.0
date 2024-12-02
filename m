Return-Path: <kvm+bounces-32808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA63A9DFA20
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 06:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9479F28158C
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 05:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE6D1F8AF8;
	Mon,  2 Dec 2024 05:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p2tVaeOb"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FCBF9EC
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 05:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733116278; cv=none; b=OrV3EqL3ufK92snqzFzNZdMCCZqtMkv0HmATxH/K6v25hbiiaFinywuFgKu4bCdemxM90WpOB3LuC3rYfB6tVs6GL7qUVDIQ7nrZLBJNs0J99k1q8wi1Ru24JIGAgxyaqYUkkSIhjLMm6icpbJLIm+USI5+ednFx1Y9wB42nlD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733116278; c=relaxed/simple;
	bh=DFIvOyxErt7/uLYYSwRb1DFMB1yTP5tXkHatqvHWs78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2qfJ/K5ojuQt7gFXfBMiHP2FOp4+zLWBsnHJrqUyfh9jYHS7QMjZauq+7H3zdRXkrlcaER77mYf2MQFN+YH6tBtZ75TeWGyLiHZnk8HlE9wiaZUKNyFsBCbm6Hgjmi/dMaJR+ydCbORFhBrYULKCefoldoT6uvrauOH5GYZrtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p2tVaeOb; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 2 Dec 2024 14:10:56 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733116271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8lbIh+01gXs5AzlZMdAt5ULUvPveI4iGrd6WK21lspQ=;
	b=p2tVaeObXwvbjHZkVLWmnfVhv5ZIkLgvbKIZcEEey/7fX4rxpHjm3LoLMkPoNK9inZyeJG
	gHPI6rFQVcyrt5nuLb+ECc0E7pwrOUwmFtTEKk5IFdHoH/WIC8sLU2GcSRuEY+xINt9Lmu
	Pzp6TGnEP33GV9gqwtH+eqQuLf5BXNw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v5 00/43] arm64: Support for Arm CCA in KVM
Message-ID: <Z01BYOgsLXV5yULk@vm3>
References: <20241004152804.72508-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004152804.72508-1-steven.price@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 04, 2024 at 04:27:21PM +0100, Steven Price wrote:
> This series adds support for running protected VMs using KVM under the
> Arm Confidential Compute Architecture (CCA).
> 
> The related guest support was posted[1] earlier. As with the guest this
> series moves to the "v1.0-rel0" version of the specification[2].
> 
> Almost all changes since v4[3] are either due to rebasing or minor
> changes to improve the code following review comments. There are two bug
> fixes:
> 
>  * Setting the GPRS on entry after an exit where the host is allowed to
>    change registers is now done in kvm_rec_enter(). This fixes a bug
>    where register updates done by user space were being ignored.
> 
>  * Drop the PTE_SHARED bit for unprotected page table entries - this bit
>    isn't controlled by the host and the RMM now enforces the bit is
>    zero.
> 
> Major limitations:
> 
>  * Only supports 4k host PAGE_SIZE (if PAGE_SIZE != 4k then the realm
>    extensions are disabled).
> 
>  * No support for huge pages when mapping the guest's pages. There is
>    some 'dead' code left over from before guest_mem was supported. This
>    is partly a current limitation of guest_memfd.
> 
> The ABI to the RMM (the RMI) is based on RMM v1.0-rel0 specification[2].
> 
> This series is based on v6.12-rc1. It is also available as a git
> repository:
> 
> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v5
> 
> Work in progress changes for kvmtool are available from the git
> repository below:
> 
> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v3
> 
> [1] https://lore.kernel.org/r/20241004144307.66199-1-steven.price%40arm.com
> [2] https://developer.arm.com/documentation/den0137/1-0rel0/
> [3] https://lore.kernel.org/r/20240821153844.60084-1-steven.price%40arm.com
> 
> Jean-Philippe Brucker (7):
>   arm64: RME: Propagate number of breakpoints and watchpoints to
>     userspace
>   arm64: RME: Set breakpoint parameters through SET_ONE_REG
>   arm64: RME: Initialize PMCR.N with number counter supported by RMM
>   arm64: RME: Propagate max SVE vector length from RMM
>   arm64: RME: Configure max SVE vector length for a Realm
>   arm64: RME: Provide register list for unfinalized RME RECs
>   arm64: RME: Provide accurate register list
> 
> Joey Gouly (2):
>   arm64: rme: allow userspace to inject aborts
>   arm64: rme: support RSI_HOST_CALL
> 
> Sean Christopherson (1):
>   KVM: Prepare for handling only shared mappings in mmu_notifier events
> 
> Steven Price (29):
>   arm64: RME: Handle Granule Protection Faults (GPFs)
>   arm64: RME: Add SMC definitions for calling the RMM
>   arm64: RME: Add wrappers for RMI calls
>   arm64: RME: Check for RME support at KVM init
>   arm64: RME: Define the user ABI
>   arm64: RME: ioctls to create and configure realms
>   arm64: kvm: Allow passing machine type in KVM creation
>   arm64: RME: Keep a spare page delegated to the RMM
>   arm64: RME: RTT tear down
>   arm64: RME: Allocate/free RECs to match vCPUs
>   arm64: RME: Support for the VGIC in realms
>   KVM: arm64: Support timers in realm RECs
>   arm64: RME: Allow VMM to set RIPAS
>   arm64: RME: Handle realm enter/exit
>   KVM: arm64: Handle realm MMIO emulation
>   arm64: RME: Allow populating initial contents
>   arm64: RME: Runtime faulting of memory
>   KVM: arm64: Handle realm VCPU load
>   KVM: arm64: Validate register access for a Realm VM
>   KVM: arm64: Handle Realm PSCI requests
>   KVM: arm64: WARN on injected undef exceptions
>   arm64: Don't expose stolen time for realm guests
>   arm64: RME: Always use 4k pages for realms
>   arm64: rme: Prevent Device mappings for Realms
>   arm_pmu: Provide a mechanism for disabling the physical IRQ
>   arm64: rme: Enable PMU support with a realm guest
>   kvm: rme: Hide KVM_CAP_READONLY_MEM for realm guests
>   arm64: kvm: Expose support for private memory
>   KVM: arm64: Allow activating realms
> 
> Suzuki K Poulose (4):
>   kvm: arm64: pgtable: Track the number of pages in the entry level
>   kvm: arm64: Include kvm_emulate.h in kvm/arm_psci.h
>   kvm: arm64: Expose debug HW register numbers for Realm
>   arm64: rme: Allow checking SVE on VM instance

On FVP, the v5+v7 kernel is unable to execute virt-manager:

Starting install...
Allocating 'test9.qcow2'                                    |    0 B  00:00 ...
Removing disk 'test9.qcow2'                                 |    0 B  00:00
ERROR    internal error: process exited while connecting to monitor: 2024-12-04T18:56:11.646168Z qemu-system-aarch64: -accel kvm: ioctl(KVM_CREATE_VM) failed: Invalid argument
2024-12-04T18:56:11.646520Z qemu-system-aarch64: -accel kvm: failed to initialize kvm: Invalid argument
Domain installation does not appear to have been successful.

Below is my virt-manager options:

virt-install --machine=virt --arch=aarch64 --name=test9 --memory=2048 --vcpu=1 --nographic --check all=off --features acpi=off --virt-type kvm --boot kernel=Image-cca,initrd=rootfs.cpio,kernel_args='earlycon console=ttyAMA0 rdinit=/sbin/init rw root=/dev/vda acpi=off' --qemu-commandline='-M virt,confidential-guest-support=rme0,gic-version=3 -cpu host -object rme-guest,id=rme0 -nodefaults' --disk size=4 --import --osinfo detect=on,require=off

Userland is Ubuntu 24.10, the VMM is Linaro's cca/2024-11-20:

https://git.codelinaro.org/linaro/dcap/qemu/-/tree/cca/2024-11-20?ref_type=heads

virt-install doesn't complain if I try to bring up a normal VM.

Thanks,
Itaru. 

> 
>  Documentation/virt/kvm/api.rst       |    3 +
>  arch/arm64/include/asm/kvm_emulate.h |   34 +
>  arch/arm64/include/asm/kvm_host.h    |   16 +-
>  arch/arm64/include/asm/kvm_pgtable.h |    2 +
>  arch/arm64/include/asm/kvm_rme.h     |  155 +++
>  arch/arm64/include/asm/rmi_cmds.h    |  510 ++++++++
>  arch/arm64/include/asm/rmi_smc.h     |  255 ++++
>  arch/arm64/include/asm/virt.h        |    1 +
>  arch/arm64/include/uapi/asm/kvm.h    |   49 +
>  arch/arm64/kvm/Kconfig               |    1 +
>  arch/arm64/kvm/Makefile              |    3 +-
>  arch/arm64/kvm/arch_timer.c          |   45 +-
>  arch/arm64/kvm/arm.c                 |  166 ++-
>  arch/arm64/kvm/guest.c               |   99 +-
>  arch/arm64/kvm/hyp/pgtable.c         |    5 +-
>  arch/arm64/kvm/hypercalls.c          |    4 +-
>  arch/arm64/kvm/inject_fault.c        |    2 +
>  arch/arm64/kvm/mmio.c                |   10 +-
>  arch/arm64/kvm/mmu.c                 |  185 ++-
>  arch/arm64/kvm/pmu-emul.c            |    7 +-
>  arch/arm64/kvm/psci.c                |   29 +
>  arch/arm64/kvm/reset.c               |   23 +-
>  arch/arm64/kvm/rme-exit.c            |  207 ++++
>  arch/arm64/kvm/rme.c                 | 1628 ++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c            |   83 +-
>  arch/arm64/kvm/vgic/vgic-v3.c        |    8 +-
>  arch/arm64/kvm/vgic/vgic.c           |   41 +-
>  arch/arm64/mm/fault.c                |   31 +-
>  drivers/perf/arm_pmu.c               |   15 +
>  include/kvm/arm_arch_timer.h         |    2 +
>  include/kvm/arm_pmu.h                |    4 +
>  include/kvm/arm_psci.h               |    2 +
>  include/linux/kvm_host.h             |    2 +
>  include/linux/perf/arm_pmu.h         |    5 +
>  include/uapi/linux/kvm.h             |   31 +-
>  virt/kvm/kvm_main.c                  |    7 +
>  36 files changed, 3569 insertions(+), 101 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_rme.h
>  create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>  create mode 100644 arch/arm64/include/asm/rmi_smc.h
>  create mode 100644 arch/arm64/kvm/rme-exit.c
>  create mode 100644 arch/arm64/kvm/rme.c
> 
> -- 
> 2.34.1
> 

