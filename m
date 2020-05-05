Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37A91C5E6C
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgEERMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 13:12:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27382 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729199AbgEERMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 13:12:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588698756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VY3mpgQiTbdJZabwq0nBtN+dwhOXmFZGPofJwgyYIco=;
        b=Hc8H8EsdMccFu/5LJ/jPO8LL88hQHeFcPBV9PjumlMMDz2LJORsJcwuQlpLHHIUntBYDEF
        v4c5YPCmT2xPSrZzj8SrTaPYpTp1/e+WkgAJgprmyE9D2ygcB6e6Metuppp9n4hAcW/yg5
        tG2YHjJAI8HG0oX5+s6PnbRdGB2kv7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-rAjydpGcNrm94b73QhlXSQ-1; Tue, 05 May 2020 13:12:32 -0400
X-MC-Unique: rAjydpGcNrm94b73QhlXSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AD3D107ACCA;
        Tue,  5 May 2020 17:12:31 +0000 (UTC)
Received: from w520.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BEE95F7E2;
        Tue,  5 May 2020 17:12:28 +0000 (UTC)
Date:   Tue, 5 May 2020 11:12:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
Message-ID: <20200505111227.02ac9cee@w520.home>
In-Reply-To: <20200504200123.GA26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
        <158836917028.8433.13715345616117345453.stgit@gimli.home>
        <20200501234849.GQ26002@ziepe.ca>
        <20200504122643.52267e44@x1.home>
        <20200504184436.GZ26002@ziepe.ca>
        <20200504133552.3d00c77d@x1.home>
        <20200504200123.GA26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 17:01:23 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, May 04, 2020 at 01:35:52PM -0600, Alex Williamson wrote:
> 
> > Ok, this all makes a lot more sense with memory_lock still in the
> > picture.  And it looks like you're not insisting on the wait_event, we
> > can block on memory_lock so long as we don't have an ordering issue.
> > I'll see what I can do.  Thanks,  
> 
> Right, you can block on the rwsem if it is ordered properly vs
> mmap_sem.

This is what I've come up with, please see if you agree with the logic:

void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
{
        struct vfio_pci_mmap_vma *mmap_vma, *tmp;

        /*
         * Lock ordering:
         * vma_lock is nested under mmap_sem for vm_ops callback paths.
         * The memory_lock semaphore is used by both code paths calling
         * into this function to zap vmas and the vm_ops.fault callback
         * to protect the memory enable state of the device.
         *
         * When zapping vmas we need to maintain the mmap_sem => vma_lock
         * ordering, which requires using vma_lock to walk vma_list to
         * acquire an mm, then dropping vma_lock to get the mmap_sem and
         * reacquiring vma_lock.  This logic is derived from similar
         * requirements in uverbs_user_mmap_disassociate().
         *
         * mmap_sem must always be the top-level lock when it is taken.
         * Therefore we can only hold the memory_lock write lock when
         * vma_list is empty, as we'd need to take mmap_sem to clear
         * entries.  vma_list can only be guaranteed empty when holding
         * vma_lock, thus memory_lock is nested under vma_lock.
         *
         * This enables the vm_ops.fault callback to acquire vma_lock,
         * followed by memory_lock read lock, while already holding
         * mmap_sem without risk of deadlock.
         */
        while (1) {
                struct mm_struct *mm = NULL;

                mutex_lock(&vdev->vma_lock);
                while (!list_empty(&vdev->vma_list)) {
                        mmap_vma = list_first_entry(&vdev->vma_list,
                                                    struct vfio_pci_mmap_vma,
                                                    vma_next);
                        mm = mmap_vma->vma->vm_mm;
                        if (mmget_not_zero(mm))
                                break;

                        list_del(&mmap_vma->vma_next);
                        kfree(mmap_vma);
                        mm = NULL;
                }

                if (!mm)
                        break;
                mutex_unlock(&vdev->vma_lock);

                down_read(&mm->mmap_sem);
                if (mmget_still_valid(mm)) {
                        mutex_lock(&vdev->vma_lock);
                        list_for_each_entry_safe(mmap_vma, tmp,
                                                 &vdev->vma_list, vma_next) {
                                struct vm_area_struct *vma = mmap_vma->vma;

                                if (vma->vm_mm != mm)
                                        continue;

                                list_del(&mmap_vma->vma_next);
                                kfree(mmap_vma);

                                zap_vma_ptes(vma, vma->vm_start,
                                             vma->vm_end - vma->vm_start);
                        }
                        mutex_unlock(&vdev->vma_lock);
                }
                up_read(&mm->mmap_sem);
                mmput(mm);
        }

        down_write(&vdev->memory_lock);
        mutex_unlock(&vdev->vma_lock);
}

As noted in the comment, the fault handler can simply do:

mutex_lock(&vdev->vma_lock);
down_read(&vdev->memory_lock);

This should be deadlock free now, so we can drop the retry handling

Paths needing to acquire memory_lock with vmas zapped (device reset,
memory bit *->0 transition) call this function, perform their
operation, then simply release with up_write(&vdev->memory_lock).  Both
the read and write version of acquiring memory_lock can still occur
outside this function for operations that don't require flushing all
vmas or otherwise touch vma_lock or mmap_sem (ex. read/write, MSI-X
vector table access, writing *->1 to memory enable bit).

I still need to work on the bus reset path as acquiring memory_lock
write locks across multiple devices seems like it requires try-lock
behavior, which is clearly complicated, or at least messy in the above
function.

Does this seem like it's going in a reasonable direction?  Thanks,

Alex

