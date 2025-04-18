Return-Path: <kvm+bounces-43667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2C7A93A4B
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 18:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 364598E1EB6
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 16:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48194214A77;
	Fri, 18 Apr 2025 16:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKmZAGps"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5039F211488
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 16:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744992294; cv=none; b=BBLHtsepbGumjKrFrDl1KV0861kLxcaC5cwT952/XHI4ByUP+4i3iJFQzvy6cRYpkhZd7P+xodVzilTioMe/ZY0RVNVRIpQaqUQTFvgtLgbKRE3D4t7ukdkbccJ1ceG01rahPyqnCibIHwJ8YaBYG2+6U3+Avns8hHxyK4wKg+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744992294; c=relaxed/simple;
	bh=znknHZUg2wWS971narMX34cZA5FXencxC2zUYr97sTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m73uCdx7+wkakr/viQAiiBPiNZtgAqNmoDyANDNOBFjDa8dUabN1PBCnrJwG5dmKMyaMK0iSnqFcW3FAHynOqpOELb0/0jeVY1dJHkKVYo79NKoMmWqsgL1Hcg1GfogKdgO8WYI+1fH8sSCxysKlMHdwcH2x9sHURPG55xbNz+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OKmZAGps; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744992291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOPTQCdz+0Ot/RGoUAN1wHOg9+e7ndhF9yyERGKmMM4=;
	b=OKmZAGpsDCiqLsyRAqLhwqm69KXkdk2Oy2FNQt8PqfdN/RK8qQyYBG73CWHbAPhXFMvEcW
	2e6G9eaRy7aMdfDk22GlPyhvkG5MZvpDJaa5JbauX/C9cxNI6K0ybU/HlZNINCZU4uamjm
	94c8ZW39RxeonkpquS3JoDJvW9S+d3M=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-Vj7ia4T8OJy-DuRjdPoHnw-1; Fri, 18 Apr 2025 12:04:50 -0400
X-MC-Unique: Vj7ia4T8OJy-DuRjdPoHnw-1
X-Mimecast-MFC-AGG-ID: Vj7ia4T8OJy-DuRjdPoHnw_1744992289
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-85b46c0e605so35019039f.0
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 09:04:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744992289; x=1745597089;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bOPTQCdz+0Ot/RGoUAN1wHOg9+e7ndhF9yyERGKmMM4=;
        b=ka56oGpCh4O2krbleVpFyCdY00ozqplkGfXl/tR711w3ae2bfxJEt3P/1l6Qv7pY45
         jpobDj8jOeEHJ5hMAHlUCDLfxc+KoKOmUoOG+2o72EbDnmeCnQRu4YJ8smuY9MlxVDSh
         UhQ/W64lD9rxrx75uhPqxp+7JWZHAPzMn9IxcPKa8Eu8I9mAfmsbVccLOtZz3l0HrmjQ
         8GCPUXWIcamloS34iw6bPqH19Ak61Z/He2VQPrCyW5mkjV7sqNk2JUOExcQoFxqyLTsr
         Gc1KgcOMbLK+EfdtRoK4YBRSgeRU9LtjmQAlK8qsjqFXHcCkVJU6CbjGnZ355H974bHR
         DJ4A==
X-Forwarded-Encrypted: i=1; AJvYcCW0VBx9oZ0PJ0eQ9dvNK/hHH8iA0HB3OL/TJuBm6YLcKRtGv7ZclHCS+a/CxCOGfMo5wRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY1e2tyVzyOaFiGsgkOZ0caU8OiG9u5e8U+0UeymFZFXuV5GRv
	83WbJ0u52FrLNvav2zg0YFi6jAyYcxj7MuI1gW2jVIY78wQJiPNQTROyjK3UyCtuD6fN+JWIlgN
	rY5uz2SIXmWTADJlsYxsFtKaEjb7lRBRCkvuoj8waYcqmJnLCrQ==
X-Gm-Gg: ASbGnctR0XnOlixQkKKWkwBsPu0ZCPdTGyjnKuLcBzVqDjRvswGQxxxTC8HSGOVVdii
	ANUOt6Pu9zPAVyWQj6dDtExBNlq3YNpOYncFJapjmWyGGKJJ6Ua1rsvZLbgKfHkJVjvbTWxsgl6
	CIBRSgd+YyfuPhRJ33Mdk+9x89UsIsvgnYzXJDylIsSyWqP4sXylqel/uGriP3zPHa3+lP8qWWf
	briP00wqVu8Hd/UC5EsfZvSofcVOqlCbfNhNvUUXK8vjy8E4zlPEH15Q8jKCmF63HAGz55yhQXj
	b2krtsp7+E1YAYU=
X-Received: by 2002:a05:6602:1682:b0:856:2a52:ea02 with SMTP id ca18e2360f4ac-861dbf38990mr74570839f.5.1744992288983;
        Fri, 18 Apr 2025 09:04:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVwG98aXTGGp6nNbl/8oNzAiJOAJxxI7bUrGvTeBGftahrw7upMK5LI32smBv35ZjW3Gszsg==
X-Received: by 2002:a05:6602:1682:b0:856:2a52:ea02 with SMTP id ca18e2360f4ac-861dbf38990mr74568839f.5.1744992288485;
        Fri, 18 Apr 2025 09:04:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a3933bd4sm507928173.99.2025.04.18.09.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 09:04:47 -0700 (PDT)
Date: Fri, 18 Apr 2025 10:04:44 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, bhelgaas@google.com, will@kernel.org,
 joro@8bytes.org, robin.murphy@arm.com, iommu@lists.linux.dev,
 linux-pci@vger.kernel.org, vasant.hegde@amd.com,
 suravee.suthikulpanit@amd.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [bug report] Potential DEADLOCK due to
 vfio_pci_mmap_huge_fault()
Message-ID: <20250418100444.5bc9cd97.alex.williamson@redhat.com>
In-Reply-To: <20250417162113.GA113267@bhelgaas>
References: <20250417115200.31275-1-sarunkod@amd.com>
	<20250417162113.GA113267@bhelgaas>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Apr 2025 11:21:13 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Thomas since msi_setup_device_data() is in a call path]
> 
> On Thu, Apr 17, 2025 at 05:22:00PM +0530, Sairaj Kodilkar wrote:
> > Hi everyone,
> > I am seeing following errors on the host when I run FIO tests inside the
> > guest on the latest upstream kernel. This causes guest to hang. Can anyone help with this ? 

Can you please elaborate more on the configuration and failure?  The
lockdep splat is identifying a potential deadlock, the chances of
actually hitting it appear to be low and the detection of the deadlock
sequence shouldn't affect the guest.  What device(s) are being assigned,
what version of QEMU, how is FIO being used, is the lockdep issue only
encountered when FIO is run in the guest?

I've not seen similar with lockdep enabled in my testing and I don't
know why/how FIO in the guest would be unique it triggering this
detection.

> > I have done some cursory analysis of the trace and it seems the reason is
> > `vfio_pci_mmap_huge_fault`. I think following scenario is causing the
> > deadlock.
> > 
> >      CPU0                     CPU1                                    CPU2
> > (Trying do                      (Trying to perform                  (Receives fault
> > `vfio_pci_set_msi_trigger())     operation with sysfs               during vfio_pin_pages_remote())
> >                                  /sys/bus/pci/devices/<devid>) 
> >                             
> > ===================================================================================================
> > (A) vdev->memory_lock
> >     (vfio_msi_enable())
> >                                 (C) root->kernfs_rwsem
> >                                     (kernfs_fop_readdir())
> > (B) root->kernfs_rwsem
> >     (kernfs_add_one())
> >                                                                     (E) mm->mmap_lock
> >                                                                         (do_user_addr_fault())
> >                                 (D) mm->mmap_lock
> >                                    (do_user_addr_fault())
> >                                                                     (F) vdev->memory_lock
> >                                                                         (vfio_pci_mmap_huge_fault())

Hmm, it's not evident to me how to resolve this either.  Thanks for the
report, I'll continue to puzzle over it.  Thanks,

Alex

> > Here, there is circular dependency of A->B->C->D->E->F->A.
> > Please let me know if anyone encountered this. I will be happy to help!
> > ---------------------------------------------------------------------------------
> > 
> > [ 1457.982233] ======================================================
> > [ 1457.989494] WARNING: possible circular locking dependency detected
> > [ 1457.996764] 6.15.0-rc1-0af2f6be1b42-1744803490343 #1 Not tainted
> > [ 1458.003842] ------------------------------------------------------
> > [ 1458.011105] CPU 0/KVM/8259 is trying to acquire lock:
> > [ 1458.017107] ff27171d80a8e960 (&root->kernfs_rwsem){++++}-{4:4}, at: kernfs_add_one+0x34/0x380
> > [ 1458.027027]
> > [ 1458.027027] but task is already holding lock:
> > [ 1458.034273] ff27171e19663918 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_memory_lock_and_enable+0x2c/0x90 [vfio_pci_core]
> > [ 1458.047221]
> > [ 1458.047221] which lock already depends on the new lock.
> > [ 1458.047221]
> > [ 1458.057506]
> > [ 1458.057506] the existing dependency chain (in reverse order) is:
> > [ 1458.066629]
> > [ 1458.066629] -> #2 (&vdev->memory_lock){++++}-{4:4}:
> > [ 1458.074509]        __lock_acquire+0x52e/0xbe0
> > [ 1458.079778]        lock_acquire+0xc7/0x2e0
> > [ 1458.084764]        down_read+0x35/0x270
> > [ 1458.089437]        vfio_pci_mmap_huge_fault+0xac/0x1c0 [vfio_pci_core]
> > [ 1458.097135]        __do_fault+0x30/0x180
> > [ 1458.101918]        do_shared_fault+0x2d/0x1b0
> > [ 1458.107189]        do_fault+0x41/0x390
> > [ 1458.111779]        __handle_mm_fault+0x2f6/0x730
> > [ 1458.117339]        handle_mm_fault+0xd8/0x2a0
> > [ 1458.122606]        fixup_user_fault+0x7f/0x1d0
> > [ 1458.127963]        vaddr_get_pfns+0x129/0x2b0 [vfio_iommu_type1]
> > [ 1458.135073]        vfio_pin_pages_remote+0xd4/0x430 [vfio_iommu_type1]
> > [ 1458.142771]        vfio_pin_map_dma+0xd4/0x350 [vfio_iommu_type1]
> > [ 1458.149979]        vfio_dma_do_map+0x2dd/0x450 [vfio_iommu_type1]
> > [ 1458.157183]        vfio_iommu_type1_ioctl+0x126/0x1c0 [vfio_iommu_type1]
> > [ 1458.165076]        __x64_sys_ioctl+0x94/0xc0
> > [ 1458.170250]        do_syscall_64+0x72/0x180
> > [ 1458.175320]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 1458.181944]
> > [ 1458.181944] -> #1 (&mm->mmap_lock){++++}-{4:4}:
> > [ 1458.189446]        __lock_acquire+0x52e/0xbe0
> > [ 1458.194703]        lock_acquire+0xc7/0x2e0
> > [ 1458.199676]        down_read_killable+0x35/0x280
> > [ 1458.205229]        lock_mm_and_find_vma+0x96/0x280
> > [ 1458.210979]        do_user_addr_fault+0x1da/0x710
> > [ 1458.216638]        exc_page_fault+0x6d/0x200
> > [ 1458.221814]        asm_exc_page_fault+0x26/0x30
> > [ 1458.227274]        filldir64+0xee/0x170
> > [ 1458.231963]        kernfs_fop_readdir+0x102/0x2e0
> > [ 1458.237620]        iterate_dir+0xb1/0x2a0
> > [ 1458.242509]        __x64_sys_getdents64+0x88/0x130
> > [ 1458.248282]        do_syscall_64+0x72/0x180
> > [ 1458.253371]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 1458.260006]
> > [ 1458.260006] -> #0 (&root->kernfs_rwsem){++++}-{4:4}:
> > [ 1458.268012]        check_prev_add+0xf1/0xca0
> > [ 1458.273187]        validate_chain+0x610/0x6f0
> > [ 1458.278452]        __lock_acquire+0x52e/0xbe0
> > [ 1458.283711]        lock_acquire+0xc7/0x2e0
> > [ 1458.288678]        down_write+0x32/0x1d0
> > [ 1458.293442]        kernfs_add_one+0x34/0x380
> > [ 1458.298588]        kernfs_create_dir_ns+0x5a/0x90
> > [ 1458.304214]        internal_create_group+0x11e/0x2f0
> > [ 1458.310131]        devm_device_add_group+0x4a/0x90
> > [ 1458.315860]        msi_setup_device_data+0x60/0x110
> > [ 1458.321679]        pci_setup_msi_context+0x19/0x60
> > [ 1458.327398]        __pci_enable_msix_range+0x19d/0x640
> > [ 1458.333513]        pci_alloc_irq_vectors_affinity+0xab/0x110
> > [ 1458.340211]        vfio_pci_set_msi_trigger+0x8c/0x230 [vfio_pci_core]
> > [ 1458.347883]        vfio_pci_core_ioctl+0x2a6/0x420 [vfio_pci_core]
> > [ 1458.355164]        vfio_device_fops_unl_ioctl+0x81/0x140 [vfio]
> > [ 1458.362155]        __x64_sys_ioctl+0x93/0xc0
> > [ 1458.367295]        do_syscall_64+0x72/0x180
> > [ 1458.372336]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 1458.378932]
> > [ 1458.378932] other info that might help us debug this:
> > [ 1458.378932]
> > [ 1458.388965] Chain exists of:
> > [ 1458.388965]   &root->kernfs_rwsem --> &mm->mmap_lock --> &vdev->memory_lock
> > [ 1458.388965]
> > [ 1458.402717]  Possible unsafe locking scenario:
> > [ 1458.402717]
> > [ 1458.410064]        CPU0                    CPU1
> > [ 1458.415495]        ----                    ----
> > [ 1458.420939]   lock(&vdev->memory_lock);
> > [ 1458.425597]                                lock(&mm->mmap_lock);
> > [ 1458.432683]                                lock(&vdev->memory_lock);
> > [ 1458.440153]   lock(&root->kernfs_rwsem);
> > [ 1458.444905]
> > [ 1458.444905]  *** DEADLOCK ***
> > [ 1458.444905]
> > [ 1458.452589] 2 locks held by CPU 0/KVM/8259:
> > [ 1458.457627]  #0: ff27171e196636b8 (&vdev->igate){+.+.}-{4:4}, at: vfio_pci_core_ioctl+0x28a/0x420 [vfio_pci_core]
> > [ 1458.469499]  #1: ff27171e19663918 (&vdev->memory_lock){++++}-{4:4}, at: vfio_pci_memory_lock_and_enable+0x2c/0x90 [vfio_pci_core]
> > [ 1458.483306]
> > [ 1458.483306] stack backtrace:
> > [ 1458.488927] CPU: 169 UID: 0 PID: 8259 Comm: CPU 0/KVM Not tainted 6.15.0-rc1-0af2f6be1b42-1744803490343 #1 PREEMPT(voluntary)
> > [ 1458.488933] Hardware name: AMD Corporation RUBY/RUBY, BIOS RRR100EB 12/05/2024
> > [ 1458.488936] Call Trace:
> > [ 1458.488940]  <TASK>
> > [ 1458.488944]  dump_stack_lvl+0x78/0xe0
> > [ 1458.488954]  print_circular_bug+0xd5/0xf0
> > [ 1458.488965]  check_noncircular+0x14c/0x170
> > [ 1458.488970]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.488976]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.488980]  ? find_held_lock+0x32/0x90
> > [ 1458.488986]  ? local_clock_noinstr+0xd/0xc0
> > [ 1458.489001]  check_prev_add+0xf1/0xca0
> > [ 1458.489006]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489015]  validate_chain+0x610/0x6f0
> > [ 1458.489027]  __lock_acquire+0x52e/0xbe0
> > [ 1458.489032]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489035]  ? __lock_release+0x15d/0x2a0
> > [ 1458.489046]  lock_acquire+0xc7/0x2e0
> > [ 1458.489051]  ? kernfs_add_one+0x34/0x380
> > [ 1458.489060]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489063]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489067]  ? __lock_release+0x15d/0x2a0
> > [ 1458.489080]  down_write+0x32/0x1d0
> > [ 1458.489085]  ? kernfs_add_one+0x34/0x380
> > [ 1458.489090]  kernfs_add_one+0x34/0x380
> > [ 1458.489100]  kernfs_create_dir_ns+0x5a/0x90
> > [ 1458.489107]  internal_create_group+0x11e/0x2f0
> > [ 1458.489118]  devm_device_add_group+0x4a/0x90
> > [ 1458.489128]  msi_setup_device_data+0x60/0x110
> > [ 1458.489136]  pci_setup_msi_context+0x19/0x60
> > [ 1458.489144]  __pci_enable_msix_range+0x19d/0x640
> > [ 1458.489150]  ? pci_conf1_read+0x4e/0xf0
> > [ 1458.489154]  ? find_held_lock+0x32/0x90
> > [ 1458.489162]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489165]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489172]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489176]  ? mark_held_locks+0x40/0x70
> > [ 1458.489182]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489191]  pci_alloc_irq_vectors_affinity+0xab/0x110
> > [ 1458.489206]  vfio_pci_set_msi_trigger+0x8c/0x230 [vfio_pci_core]
> > [ 1458.489222]  vfio_pci_core_ioctl+0x2a6/0x420 [vfio_pci_core]
> > [ 1458.489231]  ? srso_alias_return_thunk+0x5/0xfbef5
> > [ 1458.489241]  vfio_device_fops_unl_ioctl+0x81/0x140 [vfio]
> > [ 1458.489252]  __x64_sys_ioctl+0x94/0xc0
> > [ 1458.489262]  do_syscall_64+0x72/0x180
> > [ 1458.489269]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [ 1458.489273] RIP: 0033:0x7f0898724ded
> > [ 1458.489279] Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
> > [ 1458.489282] RSP: 002b:00007f08965622a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [ 1458.489286] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0898724ded
> > [ 1458.489289] RDX: 00007f07800f6d00 RSI: 0000000000003b6e RDI: 000000000000001e
> > [ 1458.489291] RBP: 00007f08965622f0 R08: 00007f07800008e0 R09: 0000000000000001
> > [ 1458.489293] R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000000000
> > [ 1458.489295] R13: fffffffffffffb28 R14: 0000000000000007 R15: 00007ffd0ef83ae0
> > [ 1458.489315]  </TASK>  
> 


