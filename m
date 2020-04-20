Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F891B1605
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 21:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgDTTkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 15:40:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725897AbgDTTkP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 15:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587411613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gb6733bTywEo+X53Gf9DvL48p1l5FujRdQzUC56SatQ=;
        b=iGiMxq0dXSDiMCzpNAGe78VFTXWEjxOxYB0vbxCeo6XNlH7IVzZDb9ocMe6N6RU12Af/bN
        kPhkTcPNhXivFyb3ufsrmJT2gn8gzk4NqcGV7dCENkmaVqwSyj4jHx6wh/a2v1sGv2iJv/
        lo9sE3ILhu/nQV5xH9CK2puG04jEpCI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-h-sWRbVyOS2icP-624wgIg-1; Mon, 20 Apr 2020 15:40:09 -0400
X-MC-Unique: h-sWRbVyOS2icP-624wgIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D3FF1B2C983;
        Mon, 20 Apr 2020 19:40:08 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B24C910013A1;
        Mon, 20 Apr 2020 19:40:07 +0000 (UTC)
Date:   Mon, 20 Apr 2020 13:40:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] vfio/type1: Fix VA->PA translation for PFNMAP VMAs in
 vaddr_get_pfn()
Message-ID: <20200420134005.456151fe@w520.home>
In-Reply-To: <20200416225057.8449-1-sean.j.christopherson@intel.com>
References: <20200416225057.8449-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Thu, 16 Apr 2020 15:50:57 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Use follow_pfn() to get the PFN of a PFNMAP VMA instead of assuming that
> vma->vm_pgoff holds the base PFN of the VMA.  This fixes a bug where
> attempting to do VFIO_IOMMU_MAP_DMA on an arbitrary PFNMAP'd region of
> memory calculates garbage for the PFN.
> 
> Hilariously, this only got detected because the first "PFN" calculated
> by vaddr_get_pfn() is PFN 0 (vma->vm_pgoff==0), and iommu_iova_to_phys()
> uses PA==0 as an error, which triggers a WARN in vfio_unmap_unpin()
> because the translation "failed".  PFN 0 is now unconditionally reserved
> on x86 in order to mitigate L1TF, which causes is_invalid_reserved_pfn()
> to return true and in turns results in vaddr_get_pfn() returning success
> for PFN 0.  Eventually the bogus calculation runs into PFNs that aren't
> reserved and leads to failure in vfio_pin_map_dma().  The subsequent
> call to vfio_remove_dma() attempts to unmap PFN 0 and WARNs.
> 
>   WARNING: CPU: 8 PID: 5130 at drivers/vfio/vfio_iommu_type1.c:750 vfio_unmap_unpin+0x2e1/0x310 [vfio_iommu_type1]
>   Modules linked in: vfio_pci vfio_virqfd vfio_iommu_type1 vfio ...
>   CPU: 8 PID: 5130 Comm: sgx Tainted: G        W         5.6.0-rc5-705d787c7fee-vfio+ #3
>   Hardware name: Intel Corporation Mehlow UP Server Platform/Moss Beach Server, BIOS CNLSE2R1.D00.X119.B49.1803010910 03/01/2018
>   RIP: 0010:vfio_unmap_unpin+0x2e1/0x310 [vfio_iommu_type1]
>   Code: <0f> 0b 49 81 c5 00 10 00 00 e9 c5 fe ff ff bb 00 10 00 00 e9 3d fe
>   RSP: 0018:ffffbeb5039ebda8 EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: ffff9a55cbf8d480 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff9a52b771c200
>   RBP: 0000000000000000 R08: 0000000000000040 R09: 00000000fffffff2
>   R10: 0000000000000001 R11: ffff9a51fa896000 R12: 0000000184010000
>   R13: 0000000184000000 R14: 0000000000010000 R15: ffff9a55cb66ea08
>   FS:  00007f15d3830b40(0000) GS:ffff9a55d5600000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000561cf39429e0 CR3: 000000084f75f005 CR4: 00000000003626e0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Call Trace:
>    vfio_remove_dma+0x17/0x70 [vfio_iommu_type1]
>    vfio_iommu_type1_ioctl+0x9e3/0xa7b [vfio_iommu_type1]
>    ksys_ioctl+0x92/0xb0
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x4c/0x180
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   RIP: 0033:0x7f15d04c75d7
>   Code: <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 81 48 2d 00 f7 d8 64 89 01 48
> 
> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> I'm mostly confident this is correct from the standpoint that it generates
> the correct VA->PA.  I'm far less confident the end result is what VFIO
> wants, there appears to be a fair bit of magic going on that I don't fully
> understand, e.g. I'm a bit mystified as to how this ever worked in any
> capacity.

Yeah, that magic was copied from KVM's hva_to_pfn(), which split this
part out into hva_to_pfn_remapped() in 92176a8ede57 and then in
add6a0cd1c5b adopted a follow_pfn() approach, but also added forcing a
user fault and retry mechanism, iiuc.  Cc'ing Paolo and Andrea to see
if we should consider something similar.  We'd be forcing the fault on
user mapping, not first access though, so I'm not sure if it's still
useful.
 
> Mapping PFNMAP VMAs into the IOMMU without using a mmu_notifier also
> seems dangerous, e.g. if the subsystem associated with the VMA
> unmaps/remaps the VMA then the IOMMU will end up with stale
> translations.

The original use case was to support mapping MMIO ranges between
devices to support p2p within a VM instance, so remapping the VMA was
not a concern.  But yes, as this might be used beyond that limited
case for something like rdma, it should be expanded.  Patches?

> Last thought, using PA==0 for the error seems unnecessarily risky,
> e.g. why not use something similar to KVM_PFN_ERR_* or an explicit
> return code?

We're just consuming what the IOMMU driver provide.  Both Intel and AMD
return zero for a page not found.  In retrospect, yeah, we probably
should have balked at that.

>  drivers/vfio/vfio_iommu_type1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c index 85b32c325282..c2ada190c5cb
> 100644 --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -342,8 +342,8 @@ static int vaddr_get_pfn(struct mm_struct *mm,
> unsigned long vaddr, vma = find_vma_intersection(mm, vaddr, vaddr +
> 1); 
>  	if (vma && vma->vm_flags & VM_PFNMAP) {
> -		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) +
> vma->vm_pgoff;
> -		if (is_invalid_reserved_pfn(*pfn))
> +		if (!follow_pfn(vma, vaddr, pfn) &&
> +		    is_invalid_reserved_pfn(*pfn))
>  			ret = 0;
>  	}
>  done:

Should we consume that error code?

	ret = follow_pfn(vma, vaddr, pfn);
	if (!ret && !is_invalid_reserved_pfn(*pfn))
		ret = -EINVAL;

Thanks,
Alex

