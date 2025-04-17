Return-Path: <kvm+bounces-43584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A32A92293
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 18:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2417A179B28
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 16:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66D9254AFE;
	Thu, 17 Apr 2025 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHiRebIN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12375253B59;
	Thu, 17 Apr 2025 16:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744906876; cv=none; b=loAbKY+2jp5xRk7k1ih4NMPt3AAQajiCjrB0TBXxjESx5F1VS0PhTdiJkqDCcaEZ8cv97uFU1cM89OgcgxEp9biTRSAUdC1Aj9yysoIlAiuHPrBukgiW8dnC5DX25EfmEaGr80kQnETUR7w3aBS87w79yT4EFMcyijtufrP52VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744906876; c=relaxed/simple;
	bh=wyX4lbJqpujDpt2SeJaFK9mS1tgXuoY4Hg/9OutBGSs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Jq4zAgIblIebLUKyO9w8pbqJevOilzH6ada2sx1b0OzFoi8LYyAmFicR5MfYaPjTTCaTNMEP9p820i68Qt/PEkte064FrOzFYb3rgcl29dPCahKQLV/c4ZZCbfAchv2hm+19PhEsnk32dmKe3h3e/Sg2l7CYvZQl7qg8zI7QBRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHiRebIN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A038C4CEE4;
	Thu, 17 Apr 2025 16:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744906875;
	bh=wyX4lbJqpujDpt2SeJaFK9mS1tgXuoY4Hg/9OutBGSs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=kHiRebINgRV0QY1UvT81pYcajboacUIi9FBxESi9yEjA1uCj/HGzyo6FSgaQoqZGp
	 CzzaGe+tTK5ZfJ5LxSBKMYwMej/elCZCUF7HFT2JuwtFaChC/BOstpv7XcMYDAjX9b
	 HXfHNWoN/gwElZKTr1pstr479AcoYruPUSGdXTXvbFez1ImUGxG9XCV51mJtawSWQY
	 CVzOGgJxxXHcxkU0bqXR3JiXoCvfJxbYhO1GW+WfvnF2iN+6ScoiKwzgYN4DYJpgPX
	 JqPwEynIBn/DCaxTC9F3Cd3jCqxIM2UZYoZJpCsDlC4GkBmdZhkIfoFlhOEvNTYK7/
	 tnyx6yxS80AxQ==
Date: Thu, 17 Apr 2025 11:21:13 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, bhelgaas@google.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, iommu@lists.linux.dev,
	linux-pci@vger.kernel.org, vasant.hegde@amd.com,
	suravee.suthikulpanit@amd.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [bug report] Potential DEADLOCK due to vfio_pci_mmap_huge_fault()
Message-ID: <20250417162113.GA113267@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417115200.31275-1-sarunkod@amd.com>

[+cc Thomas since msi_setup_device_data() is in a call path]

On Thu, Apr 17, 2025 at 05:22:00PM +0530, Sairaj Kodilkar wrote:
> Hi everyone,
> I am seeing following errors on the host when I run FIO tests inside the
> guest on the latest upstream kernel. This causes guest to hang. Can anyone help with this ? 
> 
> I have done some cursory analysis of the trace and it seems the reason is
> `vfio_pci_mmap_huge_fault`. I think following scenario is causing the
> deadlock.
> 
>      CPU0                     CPU1                                    CPU2
> (Trying do                      (Trying to perform                  (Receives fault
> `vfio_pci_set_msi_trigger())     operation with sysfs               during vfio_pin_pages_remote())
>                                  /sys/bus/pci/devices/<devid>) 
>                             
> ===================================================================================================
> (A) vdev->memory_lock
>     (vfio_msi_enable())
>                                 (C) root->kernfs_rwsem
>                                     (kernfs_fop_readdir())
> (B) root->kernfs_rwsem
>     (kernfs_add_one())
>                                                                     (E) mm->mmap_lock
>                                                                         (do_user_addr_fault())
>                                 (D) mm->mmap_lock
>                                    (do_user_addr_fault())
>                                                                     (F) vdev->memory_lock
>                                                                         (vfio_pci_mmap_huge_fault())
> 
> 
> Here, there is circular dependency of A->B->C->D->E->F->A.
> Please let me know if anyone encountered this. I will be happy to help!
> ---------------------------------------------------------------------------------
> 
> [ 1457.982233] ======================================================
> [ 1457.989494] WARNING: possible circular locking dependency detected
> [ 1457.996764] 6.15.0-rc1-0af2f6be1b42-1744803490343 #1 Not tainted
> [ 1458.003842] ------------------------------------------------------
> [ 1458.011105] CPU 0/KVM/8259 is trying to acquire lock:
> [ 1458.017107] ff27171d80a8e960 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_add_one+0x34/0x380
> [ 1458.027027]
> [ 1458.027027] but task is already holding lock:
> [ 1458.034273] ff27171e19663918 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_memory_lock_and_enable+0x2c/0x90 [vfio_pci_core]
> [ 1458.047221]
> [ 1458.047221] which lock already depends on the new lock.
> [ 1458.047221]
> [ 1458.057506]
> [ 1458.057506] the existing dependency chain (in reverse order) is:
> [ 1458.066629]
> [ 1458.066629] -> #2 (&vdev->memory_lock){++++}-{4:4}:
> [ 1458.074509]        __lock_acquire+0x52e/0xbe0
> [ 1458.079778]        lock_acquire+0xc7/0x2e0
> [ 1458.084764]        down_read+0x35/0x270
> [ 1458.089437]        vfio_pci_mmap_huge_fault+0xac/0x1c0 [vfio_pci_core]
> [ 1458.097135]        __do_fault+0x30/0x180
> [ 1458.101918]        do_shared_fault+0x2d/0x1b0
> [ 1458.107189]        do_fault+0x41/0x390
> [ 1458.111779]        __handle_mm_fault+0x2f6/0x730
> [ 1458.117339]        handle_mm_fault+0xd8/0x2a0
> [ 1458.122606]        fixup_user_fault+0x7f/0x1d0
> [ 1458.127963]        vaddr_get_pfns+0x129/0x2b0 [vfio_iommu_type1]
> [ 1458.135073]        vfio_pin_pages_remote+0xd4/0x430 [vfio_iommu_type1]
> [ 1458.142771]        vfio_pin_map_dma+0xd4/0x350 [vfio_iommu_type1]
> [ 1458.149979]        vfio_dma_do_map+0x2dd/0x450 [vfio_iommu_type1]
> [ 1458.157183]        vfio_iommu_type1_ioctl+0x126/0x1c0 [vfio_iommu_type1]
> [ 1458.165076]        __x64_sys_ioctl+0x94/0xc0
> [ 1458.170250]        do_syscall_64+0x72/0x180
> [ 1458.175320]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1458.181944]
> [ 1458.181944] -> #1 (&mm->mmap_lock){++++}-{4:4}:
> [ 1458.189446]        __lock_acquire+0x52e/0xbe0
> [ 1458.194703]        lock_acquire+0xc7/0x2e0
> [ 1458.199676]        down_read_killable+0x35/0x280
> [ 1458.205229]        lock_mm_and_find_vma+0x96/0x280
> [ 1458.210979]        do_user_addr_fault+0x1da/0x710
> [ 1458.216638]        exc_page_fault+0x6d/0x200
> [ 1458.221814]        asm_exc_page_fault+0x26/0x30
> [ 1458.227274]        filldir64+0xee/0x170
> [ 1458.231963]        kernfs_fop_readdir+0x102/0x2e0
> [ 1458.237620]        iterate_dir+0xb1/0x2a0
> [ 1458.242509]        __x64_sys_getdents64+0x88/0x130
> [ 1458.248282]        do_syscall_64+0x72/0x180
> [ 1458.253371]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1458.260006]
> [ 1458.260006] -> #0 (&root->kernfs_rwsem){++++}-{4:4}:
> [ 1458.268012]        check_prev_add+0xf1/0xca0
> [ 1458.273187]        validate_chain+0x610/0x6f0
> [ 1458.278452]        __lock_acquire+0x52e/0xbe0
> [ 1458.283711]        lock_acquire+0xc7/0x2e0
> [ 1458.288678]        down_write+0x32/0x1d0
> [ 1458.293442]        kernfs_add_one+0x34/0x380
> [ 1458.298588]        kernfs_create_dir_ns+0x5a/0x90
> [ 1458.304214]        internal_create_group+0x11e/0x2f0
> [ 1458.310131]        devm_device_add_group+0x4a/0x90
> [ 1458.315860]        msi_setup_device_data+0x60/0x110
> [ 1458.321679]        pci_setup_msi_context+0x19/0x60
> [ 1458.327398]        __pci_enable_msix_range+0x19d/0x640
> [ 1458.333513]        pci_alloc_irq_vectors_affinity+0xab/0x110
> [ 1458.340211]        vfio_pci_set_msi_trigger+0x8c/0x230 [vfio_pci_core]
> [ 1458.347883]        vfio_pci_core_ioctl+0x2a6/0x420 [vfio_pci_core]
> [ 1458.355164]        vfio_device_fops_unl_ioctl+0x81/0x140 [vfio]
> [ 1458.362155]        __x64_sys_ioctl+0x93/0xc0
> [ 1458.367295]        do_syscall_64+0x72/0x180
> [ 1458.372336]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1458.378932]
> [ 1458.378932] other info that might help us debug this:
> [ 1458.378932]
> [ 1458.388965] Chain exists of:
> [ 1458.388965]   &root->kernfs_rwsem --> &mm->mmap_lock --> &vdev->memory_lock
> [ 1458.388965]
> [ 1458.402717]  Possible unsafe locking scenario:
> [ 1458.402717]
> [ 1458.410064]        CPU0                    CPU1
> [ 1458.415495]        ----                    ----
> [ 1458.420939]   lock(&vdev->memory_lock);
> [ 1458.425597]                                lock(&mm->mmap_lock);
> [ 1458.432683]                                lock(&vdev->memory_lock);
> [ 1458.440153]   lock(&root->kernfs_rwsem);
> [ 1458.444905]
> [ 1458.444905]  *** DEADLOCK ***
> [ 1458.444905]
> [ 1458.452589] 2 locks held by CPU 0/KVM/8259:
> [ 1458.457627]  #0: ff27171e196636b8 (&vdev->igate){+.+.}-{4:4}, at: vfio_pci_core_ioctl+0x28a/0x420 [vfio_pci_core]
> [ 1458.469499]  #1: ff27171e19663918 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_memory_lock_and_enable+0x2c/0x90 [vfio_pci_core]
> [ 1458.483306]
> [ 1458.483306] stack backtrace:
> [ 1458.488927] CPU: 169 UID: 0 PID: 8259 Comm: CPU 0/KVM Not tainted 6.15.0-rc1-0af2f6be1b42-1744803490343 #1 PREEMPT(voluntary)
> [ 1458.488933] Hardware name: AMD Corporation RUBY/RUBY, BIOS RRR100EB 12/05/2024
> [ 1458.488936] Call Trace:
> [ 1458.488940]  <TASK>
> [ 1458.488944]  dump_stack_lvl+0x78/0xe0
> [ 1458.488954]  print_circular_bug+0xd5/0xf0
> [ 1458.488965]  check_noncircular+0x14c/0x170
> [ 1458.488970]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.488976]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.488980]  ? find_held_lock+0x32/0x90
> [ 1458.488986]  ? local_clock_noinstr+0xd/0xc0
> [ 1458.489001]  check_prev_add+0xf1/0xca0
> [ 1458.489006]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489015]  validate_chain+0x610/0x6f0
> [ 1458.489027]  __lock_acquire+0x52e/0xbe0
> [ 1458.489032]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489035]  ? __lock_release+0x15d/0x2a0
> [ 1458.489046]  lock_acquire+0xc7/0x2e0
> [ 1458.489051]  ? kernfs_add_one+0x34/0x380
> [ 1458.489060]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489063]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489067]  ? __lock_release+0x15d/0x2a0
> [ 1458.489080]  down_write+0x32/0x1d0
> [ 1458.489085]  ? kernfs_add_one+0x34/0x380
> [ 1458.489090]  kernfs_add_one+0x34/0x380
> [ 1458.489100]  kernfs_create_dir_ns+0x5a/0x90
> [ 1458.489107]  internal_create_group+0x11e/0x2f0
> [ 1458.489118]  devm_device_add_group+0x4a/0x90
> [ 1458.489128]  msi_setup_device_data+0x60/0x110
> [ 1458.489136]  pci_setup_msi_context+0x19/0x60
> [ 1458.489144]  __pci_enable_msix_range+0x19d/0x640
> [ 1458.489150]  ? pci_conf1_read+0x4e/0xf0
> [ 1458.489154]  ? find_held_lock+0x32/0x90
> [ 1458.489162]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489165]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489172]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489176]  ? mark_held_locks+0x40/0x70
> [ 1458.489182]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489191]  pci_alloc_irq_vectors_affinity+0xab/0x110
> [ 1458.489206]  vfio_pci_set_msi_trigger+0x8c/0x230 [vfio_pci_core]
> [ 1458.489222]  vfio_pci_core_ioctl+0x2a6/0x420 [vfio_pci_core]
> [ 1458.489231]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 1458.489241]  vfio_device_fops_unl_ioctl+0x81/0x140 [vfio]
> [ 1458.489252]  __x64_sys_ioctl+0x94/0xc0
> [ 1458.489262]  do_syscall_64+0x72/0x180
> [ 1458.489269]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [ 1458.489273] RIP: 0033:0x7f0898724ded
> [ 1458.489279] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> [ 1458.489282] RSP: 002b:00007f08965622a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [ 1458.489286] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0898724ded
> [ 1458.489289] RDX: 00007f07800f6d00 RSI: 0000000000003b6e RDI: 000000000000001e
> [ 1458.489291] RBP: 00007f08965622f0 R08: 00007f07800008e0 R09: 0000000000000001
> [ 1458.489293] R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
> [ 1458.489295] R13: fffffffffffffb28 R14: 0000000000000007 R15: 00007ffd0ef83ae0
> [ 1458.489315]  </TASK>

