Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B50F1DDD40
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 04:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgEVCjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 22:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgEVCjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 22:39:17 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE08C061A0E
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 19:39:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id v4so7283453qte.3
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 19:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VGfZyDb4rtYU2EbQOp1mVugB2T8F3YSTVsAVGe7Ovo8=;
        b=lhBGTBW8TEB2GPylriwczSZuGgch37qATzQYoUbEIhb6eWAPwEDCzhkphkJOJs9qwF
         XbyTeHod5KFSQfhSYiE8yAf3tzHZXeC3XkMC/M8Ef+00kD75l2941BXoYQKewyl9WVrX
         XOh/SD/kGBWOXupBarM39a0RK5it9WpVqz+3AbHQzA+B5VTn376FiZMeod8qTD5RDdbX
         6h4NL5IMNBIehmhCV0XyzX+tsZUkNgSUcboynAaCRAJmHsPfT0ikr8irHDHNL0cWMt+1
         GHkLOy2Z4Q5wQXtMqc+B4Si/IH47PmXl/ZGa5n30F03gmiPjLySBTsPjp6UbUdYJqIVk
         u6Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VGfZyDb4rtYU2EbQOp1mVugB2T8F3YSTVsAVGe7Ovo8=;
        b=ReLonIkgtoMZRxQH+CynVvIFUONBYTmu+A31SBCHmVTAHpYNqI1fnnzEtTaYa2Ho7A
         zNiZkwq7q4/FLAWto88s3+yjgb06MyV5gJPp73kS+OT7RUrlRqKOdbP2PMoVHtbdOpIP
         7DcXZvmqxHXwN+3C4tbNggjYQJJaYaS2HjPtkW4M205F7ObVE3hNKQD+zIdSfXV/TIOA
         G6co/KGEFNnp2892U+GFMtOIN3/S3LtcjiL1BuP0gEn7XXg/Yq6bTkCIPAF1VCGreQeX
         72pwYtKaoxLaREp+iQPRc1R3vaQdxdAfCausNAEbV1GiKW2B00YGGQyG1P7yUAk6M5Ip
         7X4w==
X-Gm-Message-State: AOAM533ZWWC5id1VGEWkwWZ5tjBi7Wf9RP/7vSZZAB5Ipog/gVL2OqvX
        isvca8n2u4RQTUR6DiHaw4GtRA==
X-Google-Smtp-Source: ABdhPJxF85bicZk/Jf7ZPUHqV6BX7sgtTGjKtL9roq9knQMil7yhye69NDSiUNVzOVMezQamVPRgag==
X-Received: by 2002:aed:37ca:: with SMTP id j68mr13796074qtb.276.1590115156174;
        Thu, 21 May 2020 19:39:16 -0700 (PDT)
Received: from ovpn-112-192.phx2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id q54sm6936206qtj.38.2020.05.21.19.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 19:39:15 -0700 (PDT)
Date:   Thu, 21 May 2020 22:39:06 -0400
From:   Qian Cai <cai@lca.pw>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200522023906.GA17414@ovpn-112-192.phx2.redhat.com>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871570274.15589.10563806532874116326.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158871570274.15589.10563806532874116326.stgit@gimli.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 05, 2020 at 03:55:02PM -0600, Alex Williamson wrote:
[]
vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> +	vm_fault_t ret = VM_FAULT_NOPAGE;
>  
> -	if (vfio_pci_add_vma(vdev, vma))
> -		return VM_FAULT_OOM;
> +	mutex_lock(&vdev->vma_lock);
> +	down_read(&vdev->memory_lock);

This lock here will trigger,

[17368.321363][T3614103] ======================================================
[17368.321375][T3614103] WARNING: possible circular locking dependency detected
[17368.321399][T3614103] 5.7.0-rc6-next-20200521+ #116 Tainted: G        W        
[17368.321410][T3614103] ------------------------------------------------------
[17368.321433][T3614103] qemu-kvm/3614103 is trying to acquire lock:
[17368.321443][T3614103] c000200fb2328968 (&kvm->lock){+.+.}-{3:3}, at: kvmppc_irq_bypass_add_producer_hv+0xd4/0x3b0 [kvm_hv]
[17368.321488][T3614103] 
[17368.321488][T3614103] but task is already holding lock:
[17368.321533][T3614103] c0000000016f4dc8 (lock#7){+.+.}-{3:3}, at: irq_bypass_register_producer+0x80/0x1d0
[17368.321564][T3614103] 
[17368.321564][T3614103] which lock already depends on the new lock.
[17368.321564][T3614103] 
[17368.321590][T3614103] 
[17368.321590][T3614103] the existing dependency chain (in reverse order) is:
[17368.321625][T3614103] 
[17368.321625][T3614103] -> #4 (lock#7){+.+.}-{3:3}:
[17368.321662][T3614103]        __mutex_lock+0xdc/0xb80
[17368.321683][T3614103]        irq_bypass_register_producer+0x80/0x1d0
[17368.321706][T3614103]        vfio_msi_set_vector_signal+0x1d8/0x350 [vfio_pci]
[17368.321719][T3614103]        vfio_msi_set_block+0xb0/0x1e0 [vfio_pci]
[17368.321752][T3614103]        vfio_pci_set_msi_trigger+0x13c/0x3e0 [vfio_pci]
[17368.321787][T3614103]        vfio_pci_set_irqs_ioctl+0x134/0x2c0 [vfio_pci]
[17368.321821][T3614103]        vfio_pci_ioctl+0xe10/0x1460 [vfio_pci]
[17368.321855][T3614103]        vfio_device_fops_unl_ioctl+0x44/0x70 [vfio]
[17368.321879][T3614103]        ksys_ioctl+0xd8/0x130
[17368.321888][T3614103]        sys_ioctl+0x28/0x40
[17368.321910][T3614103]        system_call_exception+0x108/0x1d0
[17368.321932][T3614103]        system_call_common+0xf0/0x278
[17368.321951][T3614103] 
[17368.321951][T3614103] -> #3 (&vdev->memory_lock){++++}-{3:3}:
[17368.321988][T3614103]        lock_release+0x190/0x5e0
[17368.322009][T3614103]        __mutex_unlock_slowpath+0x68/0x410
[17368.322042][T3614103]        vfio_pci_mmap_fault+0xe8/0x1f0 [vfio_pci]
vfio_pci_mmap_fault at drivers/vfio/pci/vfio_pci.c:1534
[17368.322066][T3614103]        __do_fault+0x64/0x220
[17368.322086][T3614103]        handle_mm_fault+0x12f0/0x19e0
[17368.322107][T3614103]        __do_page_fault+0x284/0xf70
[17368.322116][T3614103]        handle_page_fault+0x10/0x2c
[17368.322136][T3614103] 
[17368.322136][T3614103] -> #2 (&mm->mmap_sem){++++}-{3:3}:
[17368.322160][T3614103]        __might_fault+0x84/0xe0
[17368.322182][T3614103]        _copy_to_user+0x3c/0x120
[17368.322206][T3614103]        kvm_vcpu_ioctl+0x1ec/0xac0 [kvm]
[17368.322239][T3614103]        ksys_ioctl+0xd8/0x130
[17368.322270][T3614103]        sys_ioctl+0x28/0x40
[17368.322301][T3614103]        system_call_exception+0x108/0x1d0
[17368.322334][T3614103]        system_call_common+0xf0/0x278
[17368.322375][T3614103] 
[17368.322375][T3614103] -> #1 (&vcpu->mutex){+.+.}-{3:3}:
[17368.322411][T3614103]        __mutex_lock+0xdc/0xb80
[17368.322446][T3614103]        kvmppc_xive_release+0xd8/0x260 [kvm]
[17368.322484][T3614103]        kvm_device_release+0xc4/0x110 [kvm]
[17368.322518][T3614103]        __fput+0x154/0x3b0
[17368.322562][T3614103]        task_work_run+0xd8/0x170
[17368.322583][T3614103]        do_exit+0x4f8/0xeb0
[17368.322604][T3614103]        do_group_exit+0x78/0x160
[17368.322625][T3614103]        get_signal+0x230/0x1440
[17368.322657][T3614103]        do_notify_resume+0x130/0x3e0
[17368.322677][T3614103]        syscall_exit_prepare+0x1a4/0x280
[17368.322687][T3614103]        system_call_common+0xf8/0x278
[17368.322718][T3614103] 
[17368.322718][T3614103] -> #0 (&kvm->lock){+.+.}-{3:3}:
[17368.322753][T3614103]        __lock_acquire+0x1fe4/0x3190
[17368.322774][T3614103]        lock_acquire+0x140/0x9a0
[17368.322805][T3614103]        __mutex_lock+0xdc/0xb80
[17368.322838][T3614103]        kvmppc_irq_bypass_add_producer_hv+0xd4/0x3b0 [kvm_hv]
[17368.322888][T3614103]        kvm_arch_irq_bypass_add_producer+0x40/0x70 [kvm]
[17368.322925][T3614103]        __connect+0x118/0x150
[17368.322956][T3614103]        irq_bypass_register_producer+0x198/0x1d0
[17368.322989][T3614103]        vfio_msi_set_vector_signal+0x1d8/0x350 [vfio_pci]
[17368.323024][T3614103]        vfio_msi_set_block+0xb0/0x1e0 [vfio_pci]
[17368.323057][T3614103]        vfio_pci_set_irqs_ioctl+0x134/0x2c0 [vfio_pci]
[17368.323091][T3614103]        vfio_pci_ioctl+0xe10/0x1460 [vfio_pci]
[17368.323124][T3614103]        vfio_device_fops_unl_ioctl+0x44/0x70 [vfio]
[17368.323156][T3614103]        ksys_ioctl+0xd8/0x130
[17368.323176][T3614103]        sys_ioctl+0x28/0x40
[17368.323208][T3614103]        system_call_exception+0x108/0x1d0
[17368.323229][T3614103]        system_call_common+0xf0/0x278
[17368.323259][T3614103] 
[17368.323259][T3614103] other info that might help us debug this:
[17368.323259][T3614103] 
[17368.323295][T3614103] Chain exists of:
[17368.323295][T3614103]   &kvm->lock --> &vdev->memory_lock --> lock#7
[17368.323295][T3614103] 
[17368.323335][T3614103]  Possible unsafe locking scenario:
[17368.323335][T3614103] 
[17368.323368][T3614103]        CPU0                    CPU1
[17368.323410][T3614103]        ----                    ----
[17368.323429][T3614103]   lock(lock#7);
[17368.323447][T3614103]                                lock(&vdev->memory_lock);
[17368.323503][T3614103]                                lock(lock#7);
[17368.323535][T3614103]   lock(&kvm->lock);
[17368.323554][T3614103] 
[17368.323554][T3614103]  *** DEADLOCK ***
[17368.323554][T3614103] 
[17368.323590][T3614103] 3 locks held by qemu-kvm/3614103:
[17368.323609][T3614103]  #0: c000001f8daa2900 (&vdev->igate){+.+.}-{3:3}, at: vfio_pci_ioctl+0xdf0/0x1460 [vfio_pci]
[17368.323626][T3614103]  #1: c000001f8daa2b88 (&vdev->memory_lock){++++}-{3:3}, at: vfio_pci_set_irqs_ioctl+0xe8/0x2c0 [vfio_pci]
[17368.323646][T3614103]  #2: c0000000016f4dc8 (lock#7){+.+.}-{3:3}, at: irq_bypass_register_producer+0x80/0x1d0
[17368.323779][T3614103] 
[17368.323779][T3614103] stack backtrace:
[17368.323835][T3614103] CPU: 84 PID: 3614103 Comm: qemu-kvm Tainted: G        W         5.7.0-rc6-next-20200521+ #116
[17368.323963][T3614103] Call Trace:
[17368.324012][T3614103] [c000200d4260f380] [c00000000079cb38] dump_stack+0xfc/0x174 (unreliable)
[17368.324147][T3614103] [c000200d4260f3d0] [c0000000001ed958] print_circular_bug+0x2d8/0x350
[17368.324231][T3614103] [c000200d4260f470] [c0000000001edc40] check_noncircular+0x270/0x330
[17368.324328][T3614103] [c000200d4260f570] [c0000000001f4ce4] __lock_acquire+0x1fe4/0x3190
[17368.324427][T3614103] [c000200d4260f710] [c0000000001f0ec0] lock_acquire+0x140/0x9a0
[17368.324513][T3614103] [c000200d4260f840] [c000000000ad643c] __mutex_lock+0xdc/0xb80
[17368.324620][T3614103] [c000200d4260f960] [c0080000101e952c] kvmppc_irq_bypass_add_producer_hv+0xd4/0x3b0 [kvm_hv]
[17368.324747][T3614103] [c000200d4260fa10] [c0080000103ec698] kvm_arch_irq_bypass_add_producer+0x40/0x70 [kvm]
[17368.324845][T3614103] [c000200d4260fa30] [c000000000ad0558] __connect+0x118/0x150
[17368.324943][T3614103] [c000200d4260fa70] [c000000000ad0838] irq_bypass_register_producer+0x198/0x1d0
[17368.325048][T3614103] [c000200d4260fab0] [c00800000ffc5460] vfio_msi_set_vector_signal+0x1d8/0x350 [vfio_pci]
[17368.325178][T3614103] [c000200d4260fb70] [c00800000ffc5688] vfio_msi_set_block+0xb0/0x1e0 [vfio_pci]
[17368.325273][T3614103] [c000200d4260fbe0] [c00800000ffc6f2c] vfio_pci_set_irqs_ioctl+0x134/0x2c0 [vfio_pci]
[17368.325389][T3614103] [c000200d4260fc40] [c00800000ffc4be8] vfio_pci_ioctl+0xe10/0x1460 [vfio_pci]
[17368.325487][T3614103] [c000200d4260fd30] [c00800000fc805ec] vfio_device_fops_unl_ioctl+0x44/0x70 [vfio]
[17368.325598][T3614103] [c000200d4260fd50] [c0000000005a30b8] ksys_ioctl+0xd8/0x130
[17368.325681][T3614103] [c000200d4260fda0] [c0000000005a3138] sys_ioctl+0x28/0x40
[17368.325787][T3614103] [c000200d4260fdc0] [c000000000039e78] system_call_exception+0x108/0x1d0
[17368.325872][T3614103] [c000200d4260fe20] [c00000000000c9f0] system_call_common+0xf0/0x278

> +
> +	if (!__vfio_pci_memory_enabled(vdev)) {
> +		ret = VM_FAULT_SIGBUS;
> +		mutex_unlock(&vdev->vma_lock);
> +		goto up_out;
> +	}
> +
> +	if (__vfio_pci_add_vma(vdev, vma)) {
> +		ret = VM_FAULT_OOM;
> +		mutex_unlock(&vdev->vma_lock);
> +		goto up_out;
> +	}
> +
> +	mutex_unlock(&vdev->vma_lock);
>  
>  	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
>  			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
> -		return VM_FAULT_SIGBUS;
> +		ret = VM_FAULT_SIGBUS;
>  
> -	return VM_FAULT_NOPAGE;
> +up_out:
> +	up_read(&vdev->memory_lock);
> +	return ret;
>  }
