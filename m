Return-Path: <kvm+bounces-11727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D95D887A7D0
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 13:53:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 083481C20D9C
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 12:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441E840BF5;
	Wed, 13 Mar 2024 12:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="D9qsVO4T"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EF63D9E;
	Wed, 13 Mar 2024 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710334415; cv=none; b=r98zRarGeZEBi+8cfhZ6lpSMA06T+Qyj63g15PJeVS/wN1asaqfe0NA2DNZOKQKHKN0i0zV8YaWoJI8IWNSLLGB3HNNamSv86I87hkeXTVLJyjLVKNv81SjYJ5tNSFbdyvnJsDvgDVIB+N19Pl6WzvmHO1n5Db+kdLBhQMNOEak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710334415; c=relaxed/simple;
	bh=JFpLv+BKn2mQz+jfIHO+FBVXuiWGmVu6uQT4zynTdI8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pT9gJq8GlCCurtY4EXzP297NmSg306ll8I2tVTTNW+8imWej5EMRVtEDJszLfBwTiP2gB59O2rkA+zQu08UTAGoHkl0kAjh9xrcvPQo4tKJv9aYtKJS9oI4fxzfWWZK7pcEbyrWDvGZsx600C5VRWgWsR1dFSqx1K3enwkCbwfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=D9qsVO4T; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1710334408;
	bh=pHJqCqZCSnBo7TibBzZr69lpF8JZp8rZX05ia5gTyLg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=D9qsVO4ToatVFVLije71EjN1eaIAzKjvSpzxBi2F2YQ9joA4cR2ieVDnB2pBRK1ht
	 F/XSYGIaNeQo1zI0zEUEhvD2K3LFzQyh7LqA1t3Qj3UGMHprlB4GAawRGCnwJZDTs+
	 k3hDWUTpJDIF8qKZ7NkiipUcOns0Ptf2gEqjtqTfVg0Ch+aima/HUgFGXb06DtBKtN
	 17I6Zhnb/zuNBkN31It2/I9+EG0wRpMidcL+S2vGvFbczHWxFKfUcR48ehYUE0gxpE
	 xosPYMCgOtX52oRISDqS4pPV1m6NjnssSkTJXeNaBC5ed3YBDE9cFYrLa7F1hy6G3u
	 UGnq4+s6xFPUw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Tvr6D64K6z4wqM;
	Wed, 13 Mar 2024 23:53:24 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>,
 tpearson@raptorengineering.com, alex.williamson@redhat.com,
 linuxppc-dev@lists.ozlabs.org
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
 brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
 jgg@ziepe.ca, robh@kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, aik@amd.com, msuchanek@suse.de, jroedel@suse.de,
 vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Subject: Re: [RFC PATCH 3/3] pseries/iommu: Enable DDW for VFIO TCE create
In-Reply-To: <171026728072.8367.13581504605624115205.stgit@linux.ibm.com>
References: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
 <171026728072.8367.13581504605624115205.stgit@linux.ibm.com>
Date: Wed, 13 Mar 2024 23:53:21 +1100
Message-ID: <87zfv22szi.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Shivaprasad,

Shivaprasad G Bhat <sbhat@linux.ibm.com> writes:
> The commit 9d67c9433509 ("powerpc/iommu: Add \"borrowing\"
> iommu_table_group_ops") implemented the "borrow" mechanism for
> the pSeries SPAPR TCE. It did implement this support partially
> that it left out creating the DDW if not present already.
>
> The patch here attempts to fix the missing gaps.
>  - Expose the DDW info to user by collecting it during probe.
>  - Create the window and the iommu table if not present during
>    VFIO_SPAPR_TCE_CREATE.
>  - Remove and recreate the window if the pageshift and window sizes
>    do not match.
>  - Restore the original window in enable_ddw() if the user had
>    created/modified the DDW. As there is preference for DIRECT mapping
>    on the host driver side, the user created window is removed.
>
> The changes work only for the non-SRIOV-VF scenarios for PEs having
> 2 DMA windows.

This crashes on powernv.

Full log at https://github.com/linuxppc/linux-snowpatch/actions/runs/8253875566/job/22577897225.

[    0.958561][    T1] pci_bus 0002:01: Configuring PE for bus
[    0.959699][    T1] pci 0002:01     : [PE# fd] Secondary bus 0x0000000000000001 associated with PE#fd
[    0.961692][    T1] pci 0002:01:00.0: Configured PE#fd
[    0.962424][    T1] pci 0002:01     : [PE# fd] Setting up 32-bit TCE table at 0..80000000
[    0.966424][    T1] IOMMU table initialized, virtual merging enabled
[    0.967544][    T1] pci 0002:01     : [PE# fd] Setting up window#0 0..ffffffff pg=10000
[    0.969362][    T1] pci 0002:01     : [PE# fd] Enabling 64-bit DMA bypass
[    0.971386][    T1] pci 0002:01:00.0: Adding to iommu group 0
[    0.973481][    T1] BUG: Unable to handle kernel instruction fetch (NULL pointer?)
[    0.974388][    T1] Faulting instruction address: 0x00000000
[    0.975578][    T1] Oops: Kernel access of bad area, sig: 11 [#1]
[    0.976476][    T1] LE PAGE_SIZE=64K MMU=Hash SMP ERROR: Error: saw oops/warning etc. while expecting NR_CPUS=2048 NUMA PowerNV
[    0.977777][    T1] Modules linked in:
[    0.978570][    T1] CPU: 1 PID: 1 Comm: swapper/1 Not tainted 6.8.0-rc6-g80dcb4e6d0aa #1
[    0.979766][    T1] Hardware name: IBM PowerNV (emulated by qemu) POWER8 0x4d0200 opal:v6.8-104-g820d43c0 PowerNV
[    0.981197][    T1] NIP:  0000000000000000 LR: c00000000005653c CTR: 0000000000000000
[    0.982221][    T1] REGS: c000000003687420 TRAP: 0480   Not tainted  (6.8.0-rc6-g80dcb4e6d0aa)
[    0.983400][    T1] MSR:  9000000000009033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44004422  XER: 00000000
[    0.984742][    T1] CFAR: c000000000056538 IRQMASK: 0 
[    0.984742][    T1] GPR00: c000000000056520 c0000000036876c0 c0000000015b9800 c00000000363ae58 
[    0.984742][    T1] GPR04: c00000000352f0a0 c0000000026d4748 0000000000000001 0000000000000000 
[    0.984742][    T1] GPR08: 0000000000000000 c000000002716668 0000000000000003 0000000000008000 
[    0.984742][    T1] GPR12: 0000000000000000 c000000002be0000 c0000000000110cc 0000000000000000 
[    0.984742][    T1] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000 
[    0.984742][    T1] GPR20: 0000000000000000 0000000000000000 0000000000000000 0000000000000001 
[    0.984742][    T1] GPR24: c0000000014681d8 0000000000000000 c000000003068a00 0000000000000001 
[    0.984742][    T1] GPR28: c000000003068a00 0000000000000000 c00000000363ae58 c00000000352f0a0 
[    0.994647][    T1] NIP [0000000000000000] 0x0
[    0.995699][    T1] LR [c00000000005653c] spapr_tce_platform_iommu_attach_dev+0x74/0xc8
[    0.997399][    T1] Call Trace:
[    0.997897][    T1] [c0000000036876c0] [c000000000056514] spapr_tce_platform_iommu_attach_dev+0x4c/0xc8 (unreliable)
[    0.999383][    T1] [c000000003687700] [c000000000b383dc] __iommu_attach_device+0x44/0xfc
[    1.000476][    T1] [c000000003687730] [c000000000b38574] __iommu_device_set_domain+0xe0/0x170
[    1.001728][    T1] [c0000000036877c0] [c000000000b3869c] __iommu_group_set_domain_internal+0x98/0x1c0
[    1.003014][    T1] [c000000003687820] [c000000000b3bb10] iommu_setup_default_domain+0x544/0x650
[    1.004306][    T1] [c0000000036878e0] [c000000000b3d3b4] __iommu_probe_device+0x5b0/0x604
[    1.005500][    T1] [c000000003687950] [c000000000b3d454] iommu_probe_device+0x4c/0xb0
[    1.006563][    T1] [c000000003687990] [c00000000005648c] iommu_add_device+0x3c/0x78
[    1.007590][    T1] [c0000000036879b0] [c0000000000db920] pnv_pci_ioda_dma_dev_setup+0x168/0x73c
[    1.008918][    T1] [c000000003687a60] [c0000000000729f4] pcibios_bus_add_device+0x80/0x328
[    1.010077][    T1] [c000000003687ac0] [c000000000a49fa0] pci_bus_add_device+0x30/0x11c
[    1.011169][    T1] [c000000003687b30] [c000000000a4a0e4] pci_bus_add_devices+0x58/0xb4
[    1.012230][    T1] [c000000003687b70] [c000000000a4a118] pci_bus_add_devices+0x8c/0xb4
[    1.013301][    T1] [c000000003687bb0] [c00000000201a3c8] pcibios_init+0xd8/0x140
[    1.014314][    T1] [c000000003687c30] [c000000000010d58] do_one_initcall+0x80/0x2f8
[    1.015349][    T1] [c000000003687d00] [c000000002005b0c] kernel_init_freeable+0x31c/0x510
[    1.016470][    T1] [c000000003687de0] [c0000000000110f8] kernel_init+0x34/0x25c
[    1.017527][    T1] [c000000003687e50] [c00000000000debc] ret_from_kernel_user_thread+0x14/0x1c
[    1.018778][    T1] --- interrupt: 0 at 0x0
[    1.019525][    T1] Code: XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX 
[    1.022234][    T1] ---[ end trace 0000000000000000 ]---
[    1.022983][    T1] 
[    2.023819][    T1] note: swapper/1[1] exited with irqs disabled
[    2.025051][    T1] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.027371][    T1] Rebooting in 10 seconds.


cheers

