Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07891DDEAB
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 06:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgEVESd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 00:18:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726338AbgEVESc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 00:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590121110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5UcabcYwS7Q37jKQLcoxL8oANrbrO+HN6bgFPAaKujM=;
        b=NthJa6JLDSBl+c1sPuq9NrRvLjuHBs+95p/crGGo2boQQcLLxRxrI5PSxCs+NYMXKJof2h
        AJX36YybQxPEWVMx4Cv71Pus4G8jg5F8Fb83pd/qn9tUPyptlHS7pDqwO06IcPuyT9xio0
        7xOv1M01MKj1lkvU9hEcb7AEWb/bLhY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-QknEDGz0NkCN83rKaw8fPA-1; Fri, 22 May 2020 00:18:26 -0400
X-MC-Unique: QknEDGz0NkCN83rKaw8fPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F17280058A;
        Fri, 22 May 2020 04:18:25 +0000 (UTC)
Received: from x1.home (ovpn-114-203.phx2.redhat.com [10.3.114.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E57BB648D7;
        Fri, 22 May 2020 04:18:23 +0000 (UTC)
Date:   Thu, 21 May 2020 22:18:23 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Qian Cai <cai@lca.pw>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200521221823.7a08f29a@x1.home>
In-Reply-To: <20200522023906.GA17414@ovpn-112-192.phx2.redhat.com>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
        <158871570274.15589.10563806532874116326.stgit@gimli.home>
        <20200522023906.GA17414@ovpn-112-192.phx2.redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 May 2020 22:39:06 -0400
Qian Cai <cai@lca.pw> wrote:

> On Tue, May 05, 2020 at 03:55:02PM -0600, Alex Williamson wrote:
> []
> vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > +	vm_fault_t ret = VM_FAULT_NOPAGE;
> >  
> > -	if (vfio_pci_add_vma(vdev, vma))
> > -		return VM_FAULT_OOM;
> > +	mutex_lock(&vdev->vma_lock);
> > +	down_read(&vdev->memory_lock);  
> 
> This lock here will trigger,
> 
> [17368.321363][T3614103] ======================================================
> [17368.321375][T3614103] WARNING: possible circular locking dependency detected
> [17368.321399][T3614103] 5.7.0-rc6-next-20200521+ #116 Tainted: G        W        
> [17368.321410][T3614103] ------------------------------------------------------
> [17368.321433][T3614103] qemu-kvm/3614103 is trying to acquire lock:
> [17368.321443][T3614103] c000200fb2328968 (&kvm->lock){+.+.}-{3:3}, at: kvmppc_irq_bypass_add_producer_hv+0xd4/0x3b0 [kvm_hv]
> [17368.321488][T3614103] 
> [17368.321488][T3614103] but task is already holding lock:
> [17368.321533][T3614103] c0000000016f4dc8 (lock#7){+.+.}-{3:3}, at: irq_bypass_register_producer+0x80/0x1d0
> [17368.321564][T3614103] 
> [17368.321564][T3614103] which lock already depends on the new lock.
> [17368.321564][T3614103] 
> [17368.321590][T3614103] 
> [17368.321590][T3614103] the existing dependency chain (in reverse order) is:
> [17368.321625][T3614103] 
> [17368.321625][T3614103] -> #4 (lock#7){+.+.}-{3:3}:
> [17368.321662][T3614103]        __mutex_lock+0xdc/0xb80
> [17368.321683][T3614103]        irq_bypass_register_producer+0x80/0x1d0
> [17368.321706][T3614103]        vfio_msi_set_vector_signal+0x1d8/0x350 [vfio_pci]
> [17368.321719][T3614103]        vfio_msi_set_block+0xb0/0x1e0 [vfio_pci]
> [17368.321752][T3614103]        vfio_pci_set_msi_trigger+0x13c/0x3e0 [vfio_pci]
> [17368.321787][T3614103]        vfio_pci_set_irqs_ioctl+0x134/0x2c0 [vfio_pci]
> [17368.321821][T3614103]        vfio_pci_ioctl+0xe10/0x1460 [vfio_pci]
> [17368.321855][T3614103]        vfio_device_fops_unl_ioctl+0x44/0x70 [vfio]
> [17368.321879][T3614103]        ksys_ioctl+0xd8/0x130
> [17368.321888][T3614103]        sys_ioctl+0x28/0x40
> [17368.321910][T3614103]        system_call_exception+0x108/0x1d0
> [17368.321932][T3614103]        system_call_common+0xf0/0x278
> [17368.321951][T3614103] 
> [17368.321951][T3614103] -> #3 (&vdev->memory_lock){++++}-{3:3}:
> [17368.321988][T3614103]        lock_release+0x190/0x5e0
> [17368.322009][T3614103]        __mutex_unlock_slowpath+0x68/0x410
> [17368.322042][T3614103]        vfio_pci_mmap_fault+0xe8/0x1f0 [vfio_pci]
> vfio_pci_mmap_fault at drivers/vfio/pci/vfio_pci.c:1534
> [17368.322066][T3614103]        __do_fault+0x64/0x220
> [17368.322086][T3614103]        handle_mm_fault+0x12f0/0x19e0
> [17368.322107][T3614103]        __do_page_fault+0x284/0xf70
> [17368.322116][T3614103]        handle_page_fault+0x10/0x2c
> [17368.322136][T3614103] 
> [17368.322136][T3614103] -> #2 (&mm->mmap_sem){++++}-{3:3}:
> [17368.322160][T3614103]        __might_fault+0x84/0xe0
> [17368.322182][T3614103]        _copy_to_user+0x3c/0x120
> [17368.322206][T3614103]        kvm_vcpu_ioctl+0x1ec/0xac0 [kvm]
> [17368.322239][T3614103]        ksys_ioctl+0xd8/0x130
> [17368.322270][T3614103]        sys_ioctl+0x28/0x40
> [17368.322301][T3614103]        system_call_exception+0x108/0x1d0
> [17368.322334][T3614103]        system_call_common+0xf0/0x278
> [17368.322375][T3614103] 
> [17368.322375][T3614103] -> #1 (&vcpu->mutex){+.+.}-{3:3}:
> [17368.322411][T3614103]        __mutex_lock+0xdc/0xb80
> [17368.322446][T3614103]        kvmppc_xive_release+0xd8/0x260 [kvm]
> [17368.322484][T3614103]        kvm_device_release+0xc4/0x110 [kvm]
> [17368.322518][T3614103]        __fput+0x154/0x3b0
> [17368.322562][T3614103]        task_work_run+0xd8/0x170
> [17368.322583][T3614103]        do_exit+0x4f8/0xeb0
> [17368.322604][T3614103]        do_group_exit+0x78/0x160
> [17368.322625][T3614103]        get_signal+0x230/0x1440
> [17368.322657][T3614103]        do_notify_resume+0x130/0x3e0
> [17368.322677][T3614103]        syscall_exit_prepare+0x1a4/0x280
> [17368.322687][T3614103]        system_call_common+0xf8/0x278
> [17368.322718][T3614103] 
> [17368.322718][T3614103] -> #0 (&kvm->lock){+.+.}-{3:3}:
> [17368.322753][T3614103]        __lock_acquire+0x1fe4/0x3190
> [17368.322774][T3614103]        lock_acquire+0x140/0x9a0
> [17368.322805][T3614103]        __mutex_lock+0xdc/0xb80
> [17368.322838][T3614103]        kvmppc_irq_bypass_add_producer_hv+0xd4/0x3b0 [kvm_hv]
> [17368.322888][T3614103]        kvm_arch_irq_bypass_add_producer+0x40/0x70 [kvm]
> [17368.322925][T3614103]        __connect+0x118/0x150
> [17368.322956][T3614103]        irq_bypass_register_producer+0x198/0x1d0
> [17368.322989][T3614103]        vfio_msi_set_vector_signal+0x1d8/0x350 [vfio_pci]
> [17368.323024][T3614103]        vfio_msi_set_block+0xb0/0x1e0 [vfio_pci]
> [17368.323057][T3614103]        vfio_pci_set_irqs_ioctl+0x134/0x2c0 [vfio_pci]
> [17368.323091][T3614103]        vfio_pci_ioctl+0xe10/0x1460 [vfio_pci]
> [17368.323124][T3614103]        vfio_device_fops_unl_ioctl+0x44/0x70 [vfio]
> [17368.323156][T3614103]        ksys_ioctl+0xd8/0x130
> [17368.323176][T3614103]        sys_ioctl+0x28/0x40
> [17368.323208][T3614103]        system_call_exception+0x108/0x1d0
> [17368.323229][T3614103]        system_call_common+0xf0/0x278
> [17368.323259][T3614103] 
> [17368.323259][T3614103] other info that might help us debug this:
> [17368.323259][T3614103] 
> [17368.323295][T3614103] Chain exists of:
> [17368.323295][T3614103]   &kvm->lock --> &vdev->memory_lock --> lock#7
> [17368.323295][T3614103] 
> [17368.323335][T3614103]  Possible unsafe locking scenario:
> [17368.323335][T3614103] 
> [17368.323368][T3614103]        CPU0                    CPU1
> [17368.323410][T3614103]        ----                    ----
> [17368.323429][T3614103]   lock(lock#7);
> [17368.323447][T3614103]                                lock(&vdev->memory_lock);
> [17368.323503][T3614103]                                lock(lock#7);
> [17368.323535][T3614103]   lock(&kvm->lock);
> [17368.323554][T3614103] 
> [17368.323554][T3614103]  *** DEADLOCK ***
> [17368.323554][T3614103] 
> [17368.323590][T3614103] 3 locks held by qemu-kvm/3614103:
> [17368.323609][T3614103]  #0: c000001f8daa2900 (&vdev->igate){+.+.}-{3:3}, at: vfio_pci_ioctl+0xdf0/0x1460 [vfio_pci]
> [17368.323626][T3614103]  #1: c000001f8daa2b88 (&vdev->memory_lock){++++}-{3:3}, at: vfio_pci_set_irqs_ioctl+0xe8/0x2c0 [vfio_pci]
> [17368.323646][T3614103]  #2: c0000000016f4dc8 (lock#7){+.+.}-{3:3}, at: irq_bypass_register_producer+0x80/0x1d0


Thanks for the report.  I think this means that we're spanning too much
code by holding memory_lock across the entire MSI-X related ioctl, we
need to only wrap the callouts that touch the vector table space, which
should avoid us ever calling through kvm code with that lock held.
Thanks,

Alex

> [17368.323779][T3614103] 
> [17368.323779][T3614103] stack backtrace:
> [17368.323835][T3614103] CPU: 84 PID: 3614103 Comm: qemu-kvm Tainted: G        W         5.7.0-rc6-next-20200521+ #116
> [17368.323963][T3614103] Call Trace:
> [17368.324012][T3614103] [c000200d4260f380] [c00000000079cb38] dump_stack+0xfc/0x174 (unreliable)
> [17368.324147][T3614103] [c000200d4260f3d0] [c0000000001ed958] print_circular_bug+0x2d8/0x350
> [17368.324231][T3614103] [c000200d4260f470] [c0000000001edc40] check_noncircular+0x270/0x330
> [17368.324328][T3614103] [c000200d4260f570] [c0000000001f4ce4] __lock_acquire+0x1fe4/0x3190
> [17368.324427][T3614103] [c000200d4260f710] [c0000000001f0ec0] lock_acquire+0x140/0x9a0
> [17368.324513][T3614103] [c000200d4260f840] [c000000000ad643c] __mutex_lock+0xdc/0xb80
> [17368.324620][T3614103] [c000200d4260f960] [c0080000101e952c] kvmppc_irq_bypass_add_producer_hv+0xd4/0x3b0 [kvm_hv]
> [17368.324747][T3614103] [c000200d4260fa10] [c0080000103ec698] kvm_arch_irq_bypass_add_producer+0x40/0x70 [kvm]
> [17368.324845][T3614103] [c000200d4260fa30] [c000000000ad0558] __connect+0x118/0x150
> [17368.324943][T3614103] [c000200d4260fa70] [c000000000ad0838] irq_bypass_register_producer+0x198/0x1d0
> [17368.325048][T3614103] [c000200d4260fab0] [c00800000ffc5460] vfio_msi_set_vector_signal+0x1d8/0x350 [vfio_pci]
> [17368.325178][T3614103] [c000200d4260fb70] [c00800000ffc5688] vfio_msi_set_block+0xb0/0x1e0 [vfio_pci]
> [17368.325273][T3614103] [c000200d4260fbe0] [c00800000ffc6f2c] vfio_pci_set_irqs_ioctl+0x134/0x2c0 [vfio_pci]
> [17368.325389][T3614103] [c000200d4260fc40] [c00800000ffc4be8] vfio_pci_ioctl+0xe10/0x1460 [vfio_pci]
> [17368.325487][T3614103] [c000200d4260fd30] [c00800000fc805ec] vfio_device_fops_unl_ioctl+0x44/0x70 [vfio]
> [17368.325598][T3614103] [c000200d4260fd50] [c0000000005a30b8] ksys_ioctl+0xd8/0x130
> [17368.325681][T3614103] [c000200d4260fda0] [c0000000005a3138] sys_ioctl+0x28/0x40
> [17368.325787][T3614103] [c000200d4260fdc0] [c000000000039e78] system_call_exception+0x108/0x1d0
> [17368.325872][T3614103] [c000200d4260fe20] [c00000000000c9f0] system_call_common+0xf0/0x278
> 
> > +
> > +	if (!__vfio_pci_memory_enabled(vdev)) {
> > +		ret = VM_FAULT_SIGBUS;
> > +		mutex_unlock(&vdev->vma_lock);
> > +		goto up_out;
> > +	}
> > +
> > +	if (__vfio_pci_add_vma(vdev, vma)) {
> > +		ret = VM_FAULT_OOM;
> > +		mutex_unlock(&vdev->vma_lock);
> > +		goto up_out;
> > +	}
> > +
> > +	mutex_unlock(&vdev->vma_lock);
> >  
> >  	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> >  			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
> > -		return VM_FAULT_SIGBUS;
> > +		ret = VM_FAULT_SIGBUS;
> >  
> > -	return VM_FAULT_NOPAGE;
> > +up_out:
> > +	up_read(&vdev->memory_lock);
> > +	return ret;
> >  }  
> 

