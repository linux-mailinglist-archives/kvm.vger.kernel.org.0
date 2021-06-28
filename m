Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1B53B66F4
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 18:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhF1Qt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 12:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231742AbhF1Qt0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 12:49:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624898819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7MifffiS+acjcOIrb7s3F8SlUQ2sNfURVZ4a746RSsA=;
        b=D2fjS8EMGyyEH+k9v5W/LXnsvkOviK/VIh7GK71/q8Qfp651f5CYctPUfkBiiEDp+fZk/e
        9uVXTgce9GTnFDDpDSHabwqvnjGbMNCK4qIFpOr2KpolWneSS3GE6E1WXpasOuHAfV4Cul
        qCx5x2OW0+Jii1NJhzmBFA+vESslgIc=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-rkrOAkOYN1Wq_E0bUC8XcQ-1; Mon, 28 Jun 2021 12:46:58 -0400
X-MC-Unique: rkrOAkOYN1Wq_E0bUC8XcQ-1
Received: by mail-ot1-f70.google.com with SMTP id a60-20020a9d26420000b0290448d2be15e6so13501365otb.23
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 09:46:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MifffiS+acjcOIrb7s3F8SlUQ2sNfURVZ4a746RSsA=;
        b=dpVOOrzCmcDNjDMF/77DX/nWdfo3VMkWYM91Q6Xeal9LbbgDaTQ8+7JUnPf+KJ4PNu
         XnNhkrGgcNf9imjQmKk51CNlfZ5d1aQyCz8ac+6JsRqgW6CpKsA8kZsAvu5u/oX+pExH
         ag4UV1SZZFaZHAHoc8TTKxU27V4YOlCKTpZh1lRplCXgXEbfXOMsE9o0oZrHNd+CeYiY
         6uhJQ+vUCzQFAUoJkgoBfMjRZLsMtFFSuiR4Cp81N70zg7Fotlbj47niwdb0To+HH4cq
         KS39ZrSmesOEEsa/h+9rB/xfcZ9lZ9SQ0oiSw90dQrSQ7qH1yjCV0BtPlBaTWzadxkWr
         +vqQ==
X-Gm-Message-State: AOAM5335gZ4eU2ByguLLhgqXcaebgrYe6O5GL9IbWbg+d6w1zIan0t98
        9gqSKArGRJSLDvx7k65pexSqdAJwLzbBfpAwjmfXY1/gWXkVRr8MCP+GOBdkX3Wm9B3SEst3Sfm
        5vw4p7ci26Q0x
X-Received: by 2002:aca:5dc6:: with SMTP id r189mr21612175oib.164.1624898816649;
        Mon, 28 Jun 2021 09:46:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUUwiSUZg0XsDMMhjRSmwKfYYb3ef1s71inHnWG0QtR4WyEMBmcy/t6OcgoQ5y2A8XA54hGw==
X-Received: by 2002:aca:5dc6:: with SMTP id r189mr21612161oib.164.1624898816387;
        Mon, 28 Jun 2021 09:46:56 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id y5sm3458144otq.5.2021.06.28.09.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 09:46:55 -0700 (PDT)
Date:   Mon, 28 Jun 2021 10:46:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH v2] vfio/pci: Handle concurrent vma faults
Message-ID: <20210628104653.4ca65921.alex.williamson@redhat.com>
In-Reply-To: <161540257788.10151.6284852774772157400.stgit@gimli.home>
References: <161540257788.10151.6284852774772157400.stgit@gimli.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Mar 2021 11:58:07 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> vfio_pci_mmap_fault() incorrectly makes use of io_remap_pfn_range()
> from within a vm_ops fault handler.  This function will trigger a
> BUG_ON if it encounters a populated pte within the remapped range,
> where any fault is meant to populate the entire vma.  Concurrent
> inflight faults to the same vma will therefore hit this issue,
> triggering traces such as:
> 
> [ 1591.733256] kernel BUG at mm/memory.c:2177!
> [ 1591.739515] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> [ 1591.747381] Modules linked in: vfio_iommu_type1 vfio_pci vfio_virqfd vfio pv680_mii(O)
> [ 1591.760536] CPU: 2 PID: 227 Comm: lcore-worker-2 Tainted: G O 5.11.0-rc3+ #1
> [ 1591.770735] Hardware name:  , BIOS HixxxxFPGA 1P B600 V121-1
> [ 1591.778872] pstate: 40400009 (nZcv daif +PAN -UAO -TCO BTYPE=--)
> [ 1591.786134] pc : remap_pfn_range+0x214/0x340
> [ 1591.793564] lr : remap_pfn_range+0x1b8/0x340
> [ 1591.799117] sp : ffff80001068bbd0
> [ 1591.803476] x29: ffff80001068bbd0 x28: 0000042eff6f0000
> [ 1591.810404] x27: 0000001100910000 x26: 0000001300910000
> [ 1591.817457] x25: 0068000000000fd3 x24: ffffa92f1338e358
> [ 1591.825144] x23: 0000001140000000 x22: 0000000000000041
> [ 1591.832506] x21: 0000001300910000 x20: ffffa92f141a4000
> [ 1591.839520] x19: 0000001100a00000 x18: 0000000000000000
> [ 1591.846108] x17: 0000000000000000 x16: ffffa92f11844540
> [ 1591.853570] x15: 0000000000000000 x14: 0000000000000000
> [ 1591.860768] x13: fffffc0000000000 x12: 0000000000000880
> [ 1591.868053] x11: ffff0821bf3d01d0 x10: ffff5ef2abd89000
> [ 1591.875932] x9 : ffffa92f12ab0064 x8 : ffffa92f136471c0
> [ 1591.883208] x7 : 0000001140910000 x6 : 0000000200000000
> [ 1591.890177] x5 : 0000000000000001 x4 : 0000000000000001
> [ 1591.896656] x3 : 0000000000000000 x2 : 0168044000000fd3
> [ 1591.903215] x1 : ffff082126261880 x0 : fffffc2084989868
> [ 1591.910234] Call trace:
> [ 1591.914837]  remap_pfn_range+0x214/0x340
> [ 1591.921765]  vfio_pci_mmap_fault+0xac/0x130 [vfio_pci]
> [ 1591.931200]  __do_fault+0x44/0x12c
> [ 1591.937031]  handle_mm_fault+0xcc8/0x1230
> [ 1591.942475]  do_page_fault+0x16c/0x484
> [ 1591.948635]  do_translation_fault+0xbc/0xd8
> [ 1591.954171]  do_mem_abort+0x4c/0xc0
> [ 1591.960316]  el0_da+0x40/0x80
> [ 1591.965585]  el0_sync_handler+0x168/0x1b0
> [ 1591.971608]  el0_sync+0x174/0x180
> [ 1591.978312] Code: eb1b027f 540000c0 f9400022 b4fffe02 (d4210000)
> 
> Switch to using vmf_insert_pfn() to allow replacing mappings, and
> include decrypted memory protection as formerly provided by
> io_remap_pfn_range().  Tracking of vmas is also updated to
> prevent duplicate entries.
> 
> Fixes: 11c4cd07ba11 ("vfio-pci: Fault mmaps to enable vma tracking")
> Reported-by: Zeng Tao <prime.zeng@hisilicon.com>
> Suggested-by: Zeng Tao <prime.zeng@hisilicon.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> v2: Set decrypted pgprot in mmap, use non-_prot vmf_insert_pfn()
>     as suggested by Jason G.

IIRC, there were no blocking issues on this patch as an interim fix to
resolve the concurrent fault issues with io_remap_pfn_range().
Unfortunately it also got no Reviewed-by or Tested-by feedback.  I'd
like to put this in for v5.14 (should have gone in earlier).  Any final
comments?  Thanks,

Alex

> 
>  drivers/vfio/pci/vfio_pci.c |   30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578..73e125d73640 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1573,6 +1573,11 @@ static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
>  {
>  	struct vfio_pci_mmap_vma *mmap_vma;
>  
> +	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
> +		if (mmap_vma->vma == vma)
> +			return 0; /* Swallow the error, the vma is tracked */
> +	}
> +
>  	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
>  	if (!mmap_vma)
>  		return -ENOMEM;
> @@ -1612,31 +1617,31 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> -	vm_fault_t ret = VM_FAULT_NOPAGE;
> +	unsigned long vaddr = vma->vm_start, pfn = vma->vm_pgoff;
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
>  
>  	mutex_lock(&vdev->vma_lock);
>  	down_read(&vdev->memory_lock);
>  
> -	if (!__vfio_pci_memory_enabled(vdev)) {
> -		ret = VM_FAULT_SIGBUS;
> -		mutex_unlock(&vdev->vma_lock);
> +	if (!__vfio_pci_memory_enabled(vdev))
>  		goto up_out;
> +
> +	for (; vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
> +		ret = vmf_insert_pfn(vma, vaddr, pfn);
> +		if (ret != VM_FAULT_NOPAGE) {
> +			zap_vma_ptes(vma, vma->vm_start, vaddr - vma->vm_start);
> +			goto up_out;
> +		}
>  	}
>  
>  	if (__vfio_pci_add_vma(vdev, vma)) {
>  		ret = VM_FAULT_OOM;
> -		mutex_unlock(&vdev->vma_lock);
> -		goto up_out;
> +		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
>  	}
>  
> -	mutex_unlock(&vdev->vma_lock);
> -
> -	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> -			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
> -		ret = VM_FAULT_SIGBUS;
> -
>  up_out:
>  	up_read(&vdev->memory_lock);
> +	mutex_unlock(&vdev->vma_lock);
>  	return ret;
>  }
>  
> @@ -1702,6 +1707,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
>  
>  	vma->vm_private_data = vdev;
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>  	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
>  
>  	/*
> 

