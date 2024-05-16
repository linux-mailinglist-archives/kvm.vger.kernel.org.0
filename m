Return-Path: <kvm+bounces-17550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1051C8C7B8A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 19:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3385E1C209D4
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 17:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503BF156F40;
	Thu, 16 May 2024 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGArkPiL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7462B15886B
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 17:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715881471; cv=none; b=g4LHKTNUZNZcmTXwKz5cdEgOJbTBgpDpvwIDs/tCcopTEpVHaWATlpRv4J6yomXEaRZU4imH37xlIVCX808ozyCCwTwO6setCEHN/543oIn4xK/hkm0g6mYusaJKvlmwklY4mGxOY9w9wazxJ40S/Gl+m1VEtMl2p/C+3D3p+1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715881471; c=relaxed/simple;
	bh=B1U+4h2SxlsbghvWiEpMg6YBTgDFDdPFNa8ff1nfVIk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PY2ErXa9TDpvGYU6BQTIQYy9dX2+jT1Tv7COQwQKt24vmcJoKG/PTPvJ8q9QePFlIXp1vTYagC13xfIOlKbc0zZTM2tt2PPRI3Kq8L5GX9UC7TbvkIH3s+Dy0sAUhuXs/xugJJ09q7fP8dREPPlYtXKjrnF7KCWv7O4KY9EeBA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGArkPiL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715881468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BQl6SpLEVPRP+ruCRwb57yCIXw+q+M0vW5A2InGGx3U=;
	b=gGArkPiLwP0jWt+tvK+0/5K++Bd23oRzJBZoF2oqZFRkGbInsFaJql7Dqve/+RpMkepMHa
	lpjc/sYZP2crX9EaPukSVR5cOfGnYfwpxQgpwBdOF8KYtBGtd4KOczhlYs2+fBPhORxcaf
	T7tHE7E/BjGqq4dqjbbXTcFGk91w6kQ=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-P-wliZv1NLK8JGilnP4llw-1; Thu, 16 May 2024 13:44:26 -0400
X-MC-Unique: P-wliZv1NLK8JGilnP4llw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7e1b65780b7so883346239f.2
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 10:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715881466; x=1716486266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQl6SpLEVPRP+ruCRwb57yCIXw+q+M0vW5A2InGGx3U=;
        b=IE+TgOO6iOQpG9e1wyxsQAX5s1UJ2QsolfuEom500ZWEJnMqDEUWyyZepjFy7huL5r
         ffz9Fj3qijdswoYZ79ZmAKsC462CQ/JZRA54dlqrLtFFsnnS1Im7qwkl8i8MUkj211Yz
         0KkSwjbYyt6yesjXrpVSr7bbcTdh5SqMdwEaZmNWwSRRbcuEjJkZ8mmW3qP+FxwxXYP/
         J4npFIuAKNqWCwsnvGJjxwo081fiN162Qqzqv20uIKG36sQZB6JmYrvOk1cmS3fWkJiq
         c7pqSnu26LpnVcRBCbBOWE2PEhCOb8hWBh5Dsffw0nYVZYL748tEnqDtvUgHZHoOGykB
         XYfg==
X-Gm-Message-State: AOJu0YypZRtLOaKvmTm7IfdOjS+KlBLc7o+uOBtKgN/T6HaLHy9it+G6
	Z77VkylsXlVPRMF5fx6rLtGMICBb4dlQ4qEEWdKvdYHzsROs9JhJ5Frcuo8b8ffIEEzT6Nb3J82
	GpzMK+V7qfzRm8s3uewXtk+AQAZb62T+AefsxYICFEHc0KUh/1A==
X-Received: by 2002:a05:6602:27c1:b0:7e1:89ca:3b5d with SMTP id ca18e2360f4ac-7e1b51bdae1mr2844595139f.8.1715881465829;
        Thu, 16 May 2024 10:44:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2vqeQY7LCjBc38PXgjMshmtLVhV5MalYRM4eDCDkOpXaffiFVX+3gleot0si3RAwKRk+Vdw==
X-Received: by 2002:a05:6602:27c1:b0:7e1:89ca:3b5d with SMTP id ca18e2360f4ac-7e1b51bdae1mr2844591939f.8.1715881465246;
        Thu, 16 May 2024 10:44:25 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e20e88615asm80361339f.38.2024.05.16.10.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 10:44:24 -0700 (PDT)
Date: Thu, 16 May 2024 11:44:22 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/pci: Collect hot-reset devices to local buffer
Message-ID: <20240516114422.376d6f83.alex.williamson@redhat.com>
In-Reply-To: <SN7PR11MB7540EA4D26E4F13E52904167C3E22@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <20240503143138.3562116-1-alex.williamson@redhat.com>
	<SN7PR11MB7540EA4D26E4F13E52904167C3E22@SN7PR11MB7540.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 13 May 2024 07:51:25 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, May 3, 2024 10:32 PM
> >=20
> > Lockdep reports the below circular locking dependency issue.  The
> > mmap_lock acquisition while holding pci_bus_sem is due to the use of
> > copy_to_user() from within a pci_walk_bus() callback.
> >=20
> > Building the devices array directly into the user buffer is only for
> > convenience.  Instead we can allocate a local buffer for the array,
> > bounded by the number of devices on the bus/slot, fill the device
> > information into this local buffer, then copy it into the user buffer
> > outside the bus walk callback.
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: possible circular locking dependency detected
> > 6.9.0-rc5+ #39 Not tainted
> > ------------------------------------------------------
> > CPU 0/KVM/4113 is trying to acquire lock:
> > ffff99a609ee18a8 (&vdev->vma_lock){+.+.}-{4:4}, at: vfio_pci_mmap_fault=
+0x35/0x1a0
> > [vfio_pci_core]
> >=20
> > but task is already holding lock:
> > ffff99a243a052a0 (&mm->mmap_lock){++++}-{4:4}, at: vaddr_get_pfns+0x3f/=
0x170
> > [vfio_iommu_type1]
> >=20
> > which lock already depends on the new lock.
> >=20
> > the existing dependency chain (in reverse order) is:
> >  =20
> > -> #3 (&mm->mmap_lock){++++}-{4:4}: =20
> >        __lock_acquire+0x4e4/0xb90
> >        lock_acquire+0xbc/0x2d0
> >        __might_fault+0x5c/0x80
> >        _copy_to_user+0x1e/0x60
> >        vfio_pci_fill_devs+0x9f/0x130 [vfio_pci_core]
> >        vfio_pci_walk_wrapper+0x45/0x60 [vfio_pci_core]
> >        __pci_walk_bus+0x6b/0xb0
> >        vfio_pci_ioctl_get_pci_hot_reset_info+0x10b/0x1d0 [vfio_pci_core]
> >        vfio_pci_core_ioctl+0x1cb/0x400 [vfio_pci_core]
> >        vfio_device_fops_unl_ioctl+0x7e/0x140 [vfio]
> >        __x64_sys_ioctl+0x8a/0xc0
> >        do_syscall_64+0x8d/0x170
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >  =20
> > -> #2 (pci_bus_sem){++++}-{4:4}: =20
> >        __lock_acquire+0x4e4/0xb90
> >        lock_acquire+0xbc/0x2d0
> >        down_read+0x3e/0x160
> >        pci_bridge_wait_for_secondary_bus.part.0+0x33/0x2d0
> >        pci_reset_bus+0xdd/0x160
> >        vfio_pci_dev_set_hot_reset+0x256/0x270 [vfio_pci_core]
> >        vfio_pci_ioctl_pci_hot_reset_groups+0x1a3/0x280 [vfio_pci_core]
> >        vfio_pci_core_ioctl+0x3b5/0x400 [vfio_pci_core]
> >        vfio_device_fops_unl_ioctl+0x7e/0x140 [vfio]
> >        __x64_sys_ioctl+0x8a/0xc0
> >        do_syscall_64+0x8d/0x170
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >  =20
> > -> #1 (&vdev->memory_lock){+.+.}-{4:4}: =20
> >        __lock_acquire+0x4e4/0xb90
> >        lock_acquire+0xbc/0x2d0
> >        down_write+0x3b/0xc0
> >        vfio_pci_zap_and_down_write_memory_lock+0x1c/0x30 [vfio_pci_core]
> >        vfio_basic_config_write+0x281/0x340 [vfio_pci_core]
> >        vfio_config_do_rw+0x1fa/0x300 [vfio_pci_core]
> >        vfio_pci_config_rw+0x75/0xe50 [vfio_pci_core]
> >        vfio_pci_rw+0xea/0x1a0 [vfio_pci_core]
> >        vfs_write+0xea/0x520
> >        __x64_sys_pwrite64+0x90/0xc0
> >        do_syscall_64+0x8d/0x170
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >  =20
> > -> #0 (&vdev->vma_lock){+.+.}-{4:4}: =20
> >        check_prev_add+0xeb/0xcc0
> >        validate_chain+0x465/0x530
> >        __lock_acquire+0x4e4/0xb90
> >        lock_acquire+0xbc/0x2d0
> >        __mutex_lock+0x97/0xde0
> >        vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
> >        __do_fault+0x31/0x160
> >        do_pte_missing+0x65/0x3b0
> >        __handle_mm_fault+0x303/0x720
> >        handle_mm_fault+0x10f/0x460
> >        fixup_user_fault+0x7f/0x1f0
> >        follow_fault_pfn+0x66/0x1c0 [vfio_iommu_type1]
> >        vaddr_get_pfns+0xf2/0x170 [vfio_iommu_type1]
> >        vfio_pin_pages_remote+0x348/0x4e0 [vfio_iommu_type1]
> >        vfio_pin_map_dma+0xd2/0x330 [vfio_iommu_type1]
> >        vfio_dma_do_map+0x2c0/0x440 [vfio_iommu_type1]
> >        vfio_iommu_type1_ioctl+0xc5/0x1d0 [vfio_iommu_type1]
> >        __x64_sys_ioctl+0x8a/0xc0
> >        do_syscall_64+0x8d/0x170
> >        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >=20
> > other info that might help us debug this:
> >=20
> > Chain exists of:
> >   &vdev->vma_lock --> pci_bus_sem --> &mm->mmap_lock
> >
> >  Possible unsafe locking scenario:
> >=20
> > block dm-0: the capability attribute has been deprecated.
> >        CPU0                    CPU1
> >        ----                    ----
> >   rlock(&mm->mmap_lock);
> >                                lock(pci_bus_sem);
> >                                lock(&mm->mmap_lock);
> >   lock(&vdev->vma_lock);
> >=20
> >  *** DEADLOCK ***
> >
> > 2 locks held by CPU 0/KVM/4113:
> >  #0: ffff99a25f294888 (&iommu->lock#2){+.+.}-{4:4}, at: vfio_dma_do_map=
+0x60/0x440
> > [vfio_iommu_type1]
> >  #1: ffff99a243a052a0 (&mm->mmap_lock){++++}-{4:4}, at: vaddr_get_pfns+=
0x3f/0x170
> > [vfio_iommu_type1]
> >=20
> > stack backtrace:
> > CPU: 1 PID: 4113 Comm: CPU 0/KVM Not tainted 6.9.0-rc5+ #39
> > Hardware name: Dell Inc. PowerEdge T640/04WYPY, BIOS 2.15.1 06/16/2022
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x64/0xa0
> >  check_noncircular+0x131/0x150
> >  check_prev_add+0xeb/0xcc0
> >  ? add_chain_cache+0x10a/0x2f0
> >  ? __lock_acquire+0x4e4/0xb90
> >  validate_chain+0x465/0x530
> >  __lock_acquire+0x4e4/0xb90
> >  lock_acquire+0xbc/0x2d0
> >  ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
> >  ? lock_is_held_type+0x9a/0x110
> >  __mutex_lock+0x97/0xde0
> >  ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
> >  ? lock_acquire+0xbc/0x2d0
> >  ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
> >  ? find_held_lock+0x2b/0x80
> >  ? vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
> >  vfio_pci_mmap_fault+0x35/0x1a0 [vfio_pci_core]
> >  __do_fault+0x31/0x160
> >  do_pte_missing+0x65/0x3b0
> >  __handle_mm_fault+0x303/0x720
> >  handle_mm_fault+0x10f/0x460
> >  fixup_user_fault+0x7f/0x1f0
> >  follow_fault_pfn+0x66/0x1c0 [vfio_iommu_type1]
> >  vaddr_get_pfns+0xf2/0x170 [vfio_iommu_type1]
> >  vfio_pin_pages_remote+0x348/0x4e0 [vfio_iommu_type1]
> >  vfio_pin_map_dma+0xd2/0x330 [vfio_iommu_type1]
> >  vfio_dma_do_map+0x2c0/0x440 [vfio_iommu_type1]
> >  vfio_iommu_type1_ioctl+0xc5/0x1d0 [vfio_iommu_type1]
> >  __x64_sys_ioctl+0x8a/0xc0
> >  do_syscall_64+0x8d/0x170
> >  ? rcu_core+0x8d/0x250
> >  ? __lock_release+0x5e/0x160
> >  ? rcu_core+0x8d/0x250
> >  ? lock_release+0x5f/0x120
> >  ? sched_clock+0xc/0x30
> >  ? sched_clock_cpu+0xb/0x190
> >  ? irqtime_account_irq+0x40/0xc0
> >  ? __local_bh_enable+0x54/0x60
> >  ? __do_softirq+0x315/0x3ca
> >  ? lockdep_hardirqs_on_prepare.part.0+0x97/0x140
> >  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > RIP: 0033:0x7f8300d0357b
> > Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3=
 66 0f 1f 84 00 00 00 00
> > 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b =
0d 75 68 0f 00 f7 d8
> > 64 89 01 48
> > RSP: 002b:00007f82ef3fb948 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8300d0357b
> > RDX: 00007f82ef3fb990 RSI: 0000000000003b71 RDI: 0000000000000023
> > RBP: 00007f82ef3fb9c0 R08: 0000000000000000 R09: 0000561b7e0bcac2
> > R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
> > R13: 0000000200000000 R14: 0000381800000000 R15: 0000000000000000
> >  </TASK>
> >=20
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++------------
> >  1 file changed, 49 insertions(+), 29 deletions(-)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index d94d61b92c1a..d8c95cc16be8 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -778,25 +778,26 @@ static int vfio_pci_count_devs(struct pci_dev *pd=
ev, void
> > *data)
> >  }
> >=20
> >  struct vfio_pci_fill_info {
> > -	struct vfio_pci_dependent_device __user *devices;
> > -	struct vfio_pci_dependent_device __user *devices_end;
> >  	struct vfio_device *vdev;
> > +	struct vfio_pci_dependent_device *devices;
> > +	int nr_devices;
> >  	u32 count;
> >  	u32 flags;
> >  };
> >=20
> >  static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
> >  {
> > -	struct vfio_pci_dependent_device info =3D {
> > -		.segment =3D pci_domain_nr(pdev->bus),
> > -		.bus =3D pdev->bus->number,
> > -		.devfn =3D pdev->devfn,
> > -	};
> > +	struct vfio_pci_dependent_device *info;
> >  	struct vfio_pci_fill_info *fill =3D data;
> >=20
> > -	fill->count++;
> > -	if (fill->devices >=3D fill->devices_end)
> > -		return 0;
> > +	/* The topology changed since we counted devices */
> > +	if (fill->count >=3D fill->nr_devices)
> > +		return -EAGAIN; =20
>=20
> Will if (fill->count =3D=3D fill->nr_devices) enough? The vfio_pci_for_ea=
ch_slot_or_bus()
> loop should stop when the fill->count reaches to fill->nr_devices. =F0=9F=
=98=8A So fill->count
> will not be > fill->nr_devices.

Yes, testing for equality would be sufficient here.  I suppose it's
a matter of personal preference whether to generate an error on any
condition that requires it or only the possible scenario.

> > +
> > +	info =3D &fill->devices[fill->count++];
> > +	info->segment =3D pci_domain_nr(pdev->bus);
> > +	info->bus =3D pdev->bus->number;
> > +	info->devfn =3D pdev->devfn;
> >=20
> >  	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
> >  		struct iommufd_ctx *iommufd =3D vfio_iommufd_device_ictx(fill->vdev);
> > @@ -809,19 +810,19 @@ static int vfio_pci_fill_devs(struct pci_dev *pde=
v, void *data)
> >  		 */
> >  		vdev =3D vfio_find_device_in_devset(dev_set, &pdev->dev);
> >  		if (!vdev) {
> > -			info.devid =3D VFIO_PCI_DEVID_NOT_OWNED;
> > +			info->devid =3D VFIO_PCI_DEVID_NOT_OWNED;
> >  		} else {
> >  			int id =3D vfio_iommufd_get_dev_id(vdev, iommufd);
> >=20
> >  			if (id > 0)
> > -				info.devid =3D id;
> > +				info->devid =3D id;
> >  			else if (id =3D=3D -ENOENT)
> > -				info.devid =3D VFIO_PCI_DEVID_OWNED;
> > +				info->devid =3D VFIO_PCI_DEVID_OWNED;
> >  			else
> > -				info.devid =3D VFIO_PCI_DEVID_NOT_OWNED;
> > +				info->devid =3D VFIO_PCI_DEVID_NOT_OWNED;
> >  		}
> >  		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
> > -		if (info.devid =3D=3D VFIO_PCI_DEVID_NOT_OWNED)
> > +		if (info->devid =3D=3D VFIO_PCI_DEVID_NOT_OWNED)
> >  			fill->flags &=3D ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
> >  	} else {
> >  		struct iommu_group *iommu_group;
> > @@ -830,13 +831,10 @@ static int vfio_pci_fill_devs(struct pci_dev *pde=
v, void *data)
> >  		if (!iommu_group)
> >  			return -EPERM; /* Cannot reset non-isolated devices */
> >=20
> > -		info.group_id =3D iommu_group_id(iommu_group);
> > +		info->group_id =3D iommu_group_id(iommu_group);
> >  		iommu_group_put(iommu_group);
> >  	}
> >=20
> > -	if (copy_to_user(fill->devices, &info, sizeof(info)))
> > -		return -EFAULT;
> > -	fill->devices++;
> >  	return 0;
> >  }
> >=20
> > @@ -1258,10 +1256,11 @@ static int vfio_pci_ioctl_get_pci_hot_reset_inf=
o(
> >  {
> >  	unsigned long minsz =3D
> >  		offsetofend(struct vfio_pci_hot_reset_info, count);
> > +	struct vfio_pci_dependent_device *devices =3D NULL;
> >  	struct vfio_pci_hot_reset_info hdr;
> >  	struct vfio_pci_fill_info fill =3D {};
> >  	bool slot =3D false;
> > -	int ret =3D 0;
> > +	int ret, count;
> >=20
> >  	if (copy_from_user(&hdr, arg, minsz))
> >  		return -EFAULT;
> > @@ -1277,9 +1276,23 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
> >  	else if (pci_probe_reset_bus(vdev->pdev->bus))
> >  		return -ENODEV;
> >=20
> > -	fill.devices =3D arg->devices;
> > -	fill.devices_end =3D arg->devices +
> > -			   (hdr.argsz - sizeof(hdr)) / sizeof(arg->devices[0]);
> > +	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
> > +					    &count, slot); =20
>=20
> Is it necessary to have a warn_on like below? There was such a warn_on in
> the before. (dropped in commit b56b7aabcf3cf as the device counting was
> dropped)
>=20
> WARN_ON(!count); /* Should always be at least one */

I don't recall that we ever triggered that WARN_ON.  It seems to me
that the code works if we get a zero device count and we'll either
return success with a zero device count to the user or we'd trigger the
-EAGAIN error you previously noted if the topology were to change.  The
latter would at least make sense to userspace because a zero device
count certainly doesn't.

Let's add back the WARN_ON test and return -ERANGE if we get a zero
device count.=20

> Other than the two nits, this patch looks good to me.

Thanks, Yi.  I committed this to the vfio next branch last week and I
generally don't force an update to linux-next for an additional R-b,
but let me follow-up with the trivial addition above.  Thanks,

Alex


