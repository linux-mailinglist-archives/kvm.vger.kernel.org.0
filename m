Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6463335B5
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 07:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhCJGJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 01:09:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232187AbhCJGIr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 01:08:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615356526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLbXGXlVj3W3x6vIQEKd0idsguJpkcNlzgeMzT6qYhI=;
        b=adB2HZQZFYFRLS5IfYptFOQBMdv3aiQKr5Q9XqhTUpEKsiOCJefAqGejQhykvDlYbN1awE
        N0U20RF+lT9lcK7YxdW04ijCrRWRxmokgks/PbWoy1xdp9AhYAxjguSA4H3dc9l8KmS9ZK
        GdIyAjOzPuHQw7ooDOGg5TYGriJU8OI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-H8N7MSotP5y8QtlR9r70yw-1; Wed, 10 Mar 2021 01:08:45 -0500
X-MC-Unique: H8N7MSotP5y8QtlR9r70yw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CE2A107465C;
        Wed, 10 Mar 2021 06:08:43 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C46962461;
        Wed, 10 Mar 2021 06:08:38 +0000 (UTC)
Date:   Tue, 9 Mar 2021 23:08:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Peter Xu <peterx@redhat.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210309230837.394cb101@x1.home.shazbot.org>
In-Reply-To: <20210309234127.GM2356281@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
        <20210308132106.49da42e2@omen.home.shazbot.org>
        <20210308225626.GN397383@xz-x1>
        <6b98461600f74f2385b9096203fa3611@hisilicon.com>
        <20210309124609.GG2356281@nvidia.com>
        <20210309082951.75f0eb01@x1.home.shazbot.org>
        <20210309164004.GJ2356281@nvidia.com>
        <20210309184739.GD763132@xz-x1>
        <20210309122607.0b68fb9b@omen.home.shazbot.org>
        <20210309234127.GM2356281@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Mar 2021 19:41:27 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 09, 2021 at 12:26:07PM -0700, Alex Williamson wrote:
> 
> > In the new series, I think the fault handler becomes (untested):
> > 
> > static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > {
> >         struct vm_area_struct *vma = vmf->vma;
> >         struct vfio_pci_device *vdev = vma->vm_private_data;
> >         unsigned long base_pfn, pgoff;
> >         vm_fault_t ret = VM_FAULT_SIGBUS;
> > 
> >         if (vfio_pci_bar_vma_to_pfn(vma, &base_pfn))
> >                 return ret;
> > 
> >         pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;  
> 
> I don't think this math is completely safe, it needs to parse the
> vm_pgoff..
> 
> I'm worried userspace could split/punch/mangle a VMA using
> munmap/mremap/etc/etc in a way that does update the pg_off but is
> incompatible with the above.

parsing vm_pgoff is done in:

static int vfio_pci_bar_vma_to_pfn(struct vm_area_struct *vma,
                                   unsigned long *pfn)
{
        struct vfio_pci_device *vdev = vma->vm_private_data;
        struct pci_dev *pdev = vdev->pdev;
        int index;
        u64 pgoff;

        index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);

        if (index >= VFIO_PCI_ROM_REGION_INDEX ||
            !vdev->bar_mmap_supported[index] || !vdev->barmap[index])
                return -EINVAL;

        pgoff = vma->vm_pgoff &
                ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);

        *pfn = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;

        return 0;
}

But given Peter's concern about faulting individual pages, I think the
fault handler becomes:

static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
{
        struct vm_area_struct *vma = vmf->vma;
        struct vfio_pci_device *vdev = vma->vm_private_data;
        unsigned long vaddr, pfn;
        vm_fault_t ret = VM_FAULT_SIGBUS;

        if (vfio_pci_bar_vma_to_pfn(vma, &pfn))
                return ret;

        down_read(&vdev->memory_lock);

        if (__vfio_pci_memory_enabled(vdev)) {
                for (vaddr = vma->vm_start;
                     vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
                        ret = vmf_insert_pfn_prot(vma, vaddr, pfn,
                                        pgprot_decrypted(vma->vm_page_prot));
                        if (ret != VM_FAULT_NOPAGE) {
                                zap_vma_ptes(vma, vma->vm_start,
                                             vaddr - vma->vm_start);
                                break;
                        }
                }
        }

        up_read(&vdev->memory_lock);

        return ret;
}

Thanks,
Alex

