Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C903398C5
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 21:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhCLU7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 15:59:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235079AbhCLU6z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 15:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615582734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqrwGSWs78kmFc+bZgFNWuIXo+lT3T9Q8DDXoclb0G4=;
        b=jBZSQEZ2l3aVpNqcDfR6cXl6+vOPcrraFOzJHNZMMByYd0UoF6uFFF4BETKVfi3z8eDrVq
        RuDvOIOGY76gRlSktoCCviP3OCJK0XxnoThyxlAxFkfZG1eebWx0YxK2HZs+PTI5yjMbtb
        bwDkJP31QjYnj9DXXLIQQZhWA4zdJ9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-nJHOhb7fOK239aU1O3cm5A-1; Fri, 12 Mar 2021 15:58:51 -0500
X-MC-Unique: nJHOhb7fOK239aU1O3cm5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 763838189C7;
        Fri, 12 Mar 2021 20:58:49 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E57FF5D9CC;
        Fri, 12 Mar 2021 20:58:44 +0000 (UTC)
Date:   Fri, 12 Mar 2021 13:58:44 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210312135844.5e97aac7@omen.home.shazbot.org>
In-Reply-To: <20210312130938.1e535e50@omen.home.shazbot.org>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
        <20210310181446.GZ2356281@nvidia.com>
        <20210310113406.6f029fcf@omen.home.shazbot.org>
        <20210310184011.GA2356281@nvidia.com>
        <20210312121611.07a313e3@omen.home.shazbot.org>
        <20210312194147.GH2356281@nvidia.com>
        <20210312130938.1e535e50@omen.home.shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 13:09:38 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Fri, 12 Mar 2021 15:41:47 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.12.0-rc1+ #18 Not tainted
> ------------------------------------------------------
> CPU 0/KVM/1406 is trying to acquire lock:
> ffffffffa5a58d60 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0x83/0xd0
> 
> but task is already holding lock:
> ffff94c0f3e8fb08 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: vfio_device_io_remap_mapping_range+0x31/0x120 [vfio]
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&mapping->i_mmap_rwsem){++++}-{3:3}:  
>        down_write+0x3d/0x70
>        dma_resv_lockdep+0x1b0/0x298
>        do_one_initcall+0x5b/0x2d0
>        kernel_init_freeable+0x251/0x298
>        kernel_init+0xa/0x111
>        ret_from_fork+0x22/0x30
> 
> -> #0 (fs_reclaim){+.+.}-{0:0}:  
>        __lock_acquire+0x111f/0x1e10
>        lock_acquire+0xb5/0x380
>        fs_reclaim_acquire+0xa3/0xd0
>        kmem_cache_alloc_trace+0x30/0x2c0
>        memtype_reserve+0xc3/0x280
>        reserve_pfn_range+0x86/0x160
>        track_pfn_remap+0xa6/0xe0
>        remap_pfn_range+0xa8/0x610
>        vfio_device_io_remap_mapping_range+0x93/0x120 [vfio]
>        vfio_pci_test_and_up_write_memory_lock+0x34/0x40 [vfio_pci]
>        vfio_basic_config_write+0x12d/0x230 [vfio_pci]
>        vfio_pci_config_rw+0x1b7/0x3a0 [vfio_pci]
>        vfs_write+0xea/0x390
>        __x64_sys_pwrite64+0x72/0xb0
>        do_syscall_64+0x33/0x40
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
..
> > Does current_gfp_context()/memalloc_nofs_save()/etc solve it?  

Yeah, we can indeed use memalloc_nofs_save/restore().  It seems we're
trying to allocate something for pfnmap tracking and that enables lots
of lockdep specific tests.  Is it valid to wrap io_remap_pfn_range()
around clearing this flag or am I just masking a bug?  Thanks,

Alex

