Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F177B339805
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 21:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhCLUKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 15:10:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234653AbhCLUJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 15:09:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615579788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jyz52keAoIKnP4MO3/5Lr7keCuYbmY1/k6xZpVT/8EI=;
        b=clj84phO4ijnJ/uGKeAklKA2NuPecoRl+dZpF0wOOZaQuchFUwRJ39r9yTtYtU+mup/VM/
        Ctl8E9Y39AD92u+lqLoyc69QC6l+233UHcaxOBAdataT2d1f02ixktcVVjhikOsicOss54
        /mpgK29bNDCNLgximE8imS+PEdOXwSU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-OSk_6vnuNbKzkCrXTnd6Sg-1; Fri, 12 Mar 2021 15:09:45 -0500
X-MC-Unique: OSk_6vnuNbKzkCrXTnd6Sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E644984B9A1;
        Fri, 12 Mar 2021 20:09:43 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 716FE6087C;
        Fri, 12 Mar 2021 20:09:39 +0000 (UTC)
Date:   Fri, 12 Mar 2021 13:09:38 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210312130938.1e535e50@omen.home.shazbot.org>
In-Reply-To: <20210312194147.GH2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
        <20210310181446.GZ2356281@nvidia.com>
        <20210310113406.6f029fcf@omen.home.shazbot.org>
        <20210310184011.GA2356281@nvidia.com>
        <20210312121611.07a313e3@omen.home.shazbot.org>
        <20210312194147.GH2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 15:41:47 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 12, 2021 at 12:16:11PM -0700, Alex Williamson wrote:
> > On Wed, 10 Mar 2021 14:40:11 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:
> > >   
> > > > > I think after the address_space changes this should try to stick with
> > > > > a normal io_rmap_pfn_range() done outside the fault handler.    
> > > > 
> > > > I assume you're suggesting calling io_remap_pfn_range() when device
> > > > memory is enabled,    
> > > 
> > > Yes, I think I saw Peter thinking along these lines too
> > > 
> > > Then fault just always causes SIGBUS if it gets called  
> > 
> > Trying to use the address_space approach because otherwise we'd just be
> > adding back vma list tracking, it looks like we can't call
> > io_remap_pfn_range() while holding the address_space i_mmap_rwsem via
> > i_mmap_lock_write(), like done in unmap_mapping_range().  lockdep
> > identifies a circular lock order issue against fs_reclaim.  Minimally we
> > also need vma_interval_tree_iter_{first,next} exported in order to use
> > vma_interval_tree_foreach().  Suggestions?  Thanks,  
> 
> You are asking how to put the BAR back into every VMA when it is
> enabled again after it has been zap'd?

Exactly.
 
> What did the lockdep splat look like? Is it a memory allocation?


======================================================
WARNING: possible circular locking dependency detected
5.12.0-rc1+ #18 Not tainted
------------------------------------------------------
CPU 0/KVM/1406 is trying to acquire lock:
ffffffffa5a58d60 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0x83/0xd0

but task is already holding lock:
ffff94c0f3e8fb08 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: vfio_device_io_remap_mapping_range+0x31/0x120 [vfio]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&mapping->i_mmap_rwsem){++++}-{3:3}:
       down_write+0x3d/0x70
       dma_resv_lockdep+0x1b0/0x298
       do_one_initcall+0x5b/0x2d0
       kernel_init_freeable+0x251/0x298
       kernel_init+0xa/0x111
       ret_from_fork+0x22/0x30

-> #0 (fs_reclaim){+.+.}-{0:0}:
       __lock_acquire+0x111f/0x1e10
       lock_acquire+0xb5/0x380
       fs_reclaim_acquire+0xa3/0xd0
       kmem_cache_alloc_trace+0x30/0x2c0
       memtype_reserve+0xc3/0x280
       reserve_pfn_range+0x86/0x160
       track_pfn_remap+0xa6/0xe0
       remap_pfn_range+0xa8/0x610
       vfio_device_io_remap_mapping_range+0x93/0x120 [vfio]
       vfio_pci_test_and_up_write_memory_lock+0x34/0x40 [vfio_pci]
       vfio_basic_config_write+0x12d/0x230 [vfio_pci]
       vfio_pci_config_rw+0x1b7/0x3a0 [vfio_pci]
       vfs_write+0xea/0x390
       __x64_sys_pwrite64+0x72/0xb0
       do_syscall_64+0x33/0x40
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&mapping->i_mmap_rwsem);
                               lock(fs_reclaim);
                               lock(&mapping->i_mmap_rwsem);
  lock(fs_reclaim);

 *** DEADLOCK ***

2 locks held by CPU 0/KVM/1406:
 #0: ffff94c0f9c71ef0 (&vdev->memory_lock){++++}-{3:3}, at: vfio_basic_config_write+0x19a/0x230 [vfio_pci]
 #1: ffff94c0f3e8fb08 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: vfio_device_io_remap_mapping_range+0x31/0x120 [vfio]

stack backtrace:
CPU: 3 PID: 1406 Comm: CPU 0/KVM Not tainted 5.12.0-rc1+ #18
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
Call Trace:
 dump_stack+0x7f/0xa1
 check_noncircular+0xcf/0xf0
 __lock_acquire+0x111f/0x1e10
 lock_acquire+0xb5/0x380
 ? fs_reclaim_acquire+0x83/0xd0
 ? pat_enabled+0x10/0x10
 ? memtype_reserve+0xc3/0x280
 fs_reclaim_acquire+0xa3/0xd0
 ? fs_reclaim_acquire+0x83/0xd0
 kmem_cache_alloc_trace+0x30/0x2c0
 memtype_reserve+0xc3/0x280
 reserve_pfn_range+0x86/0x160
 track_pfn_remap+0xa6/0xe0
 remap_pfn_range+0xa8/0x610
 ? lock_acquire+0xb5/0x380
 ? vfio_device_io_remap_mapping_range+0x31/0x120 [vfio]
 ? lock_is_held_type+0xa5/0x120
 vfio_device_io_remap_mapping_range+0x93/0x120 [vfio]
 vfio_pci_test_and_up_write_memory_lock+0x34/0x40 [vfio_pci]
 vfio_basic_config_write+0x12d/0x230 [vfio_pci]
 vfio_pci_config_rw+0x1b7/0x3a0 [vfio_pci]
 vfs_write+0xea/0x390
 __x64_sys_pwrite64+0x72/0xb0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f80176152ff
Code: 08 89 3c 24 48 89 4c 24 18 e8 3d f3 ff ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 12 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 6d f3 ff ff 48 8b
RSP: 002b:00007f7efa5f72f0 EFLAGS: 00000293 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f80176152ff
RDX: 0000000000000002 RSI: 00007f7efa5f736c RDI: 000000000000002d
RBP: 000055b66913d530 R08: 0000000000000000 R09: 000000000000ffff
R10: 0000070000000004 R11: 0000000000000293 R12: 0000000000000004
R13: 0000000000000102 R14: 0000000000000002 R15: 000055b66913d530

> Does current_gfp_context()/memalloc_nofs_save()/etc solve it?

Will investigate...
 
> The easiest answer is to continue to use fault and the
> vmf_insert_page()..
> 
> But it feels like it wouuld be OK to export enough i_mmap machinery to
> enable this. Cleaner than building your own tracking, which would
> still have the same ugly mmap_sem inversion issue which was preventing
> this last time.

Yup, I'd rather fault than add that back, but I'm not sure we have a
mapping function compatible with this framework.  Thanks,

Alex

