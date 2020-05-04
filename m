Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13571C45D1
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbgEDS04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:26:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730118AbgEDS04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 14:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588616814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f8hEJtqxQTUIVsiO/XcAAleCIDpB5yp3KKKiKVQXTqA=;
        b=OvyY/vGErCLLPHqA/1CAz7ciCppgwHj0dThp4momerPo0AoLI2endKPlRPRcrM0FMMeqq9
        LebCunYXppsD05BPWi2Ik2/hIU6GXA7WcXSp4Tr2T6AB9L3WlAP+ffOwQRC7WWavLZTGh2
        NpJccwQzbJJrTRToXK0Pen6qdAGDKGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-DgZBVvuaM-eCuTUtT1P35w-1; Mon, 04 May 2020 14:26:50 -0400
X-MC-Unique: DgZBVvuaM-eCuTUtT1P35w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB4F98014D9;
        Mon,  4 May 2020 18:26:49 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2403C10027A6;
        Mon,  4 May 2020 18:26:44 +0000 (UTC)
Date:   Mon, 4 May 2020 12:26:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
Message-ID: <20200504122643.52267e44@x1.home>
In-Reply-To: <20200501234849.GQ26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
        <158836917028.8433.13715345616117345453.stgit@gimli.home>
        <20200501234849.GQ26002@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 May 2020 20:48:49 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, May 01, 2020 at 03:39:30PM -0600, Alex Williamson wrote:
> 
> >  static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
> >  			    struct vm_area_struct *vma)
> >  {
> > @@ -1346,15 +1450,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  {
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > +	vm_fault_t ret = VM_FAULT_NOPAGE;
> >  
> > -	if (vfio_pci_add_vma(vdev, vma))
> > -		return VM_FAULT_OOM;
> > +	/*
> > +	 * Zap callers hold memory_lock and acquire mmap_sem, we hold
> > +	 * mmap_sem and need to acquire memory_lock to avoid races with
> > +	 * memory bit settings.  Release mmap_sem, wait, and retry, or fail.
> > +	 */
> > +	if (unlikely(!down_read_trylock(&vdev->memory_lock))) {
> > +		if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
> > +			if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
> > +				return VM_FAULT_RETRY;
> > +
> > +			up_read(&vma->vm_mm->mmap_sem);
> > +
> > +			if (vmf->flags & FAULT_FLAG_KILLABLE) {
> > +				if (!down_read_killable(&vdev->memory_lock))
> > +					up_read(&vdev->memory_lock);
> > +			} else {
> > +				down_read(&vdev->memory_lock);
> > +				up_read(&vdev->memory_lock);
> > +			}
> > +			return VM_FAULT_RETRY;
> > +		}
> > +		return VM_FAULT_SIGBUS;
> > +	}  
> 
> So, why have the wait? It isn't reliable - if this gets faulted from a
> call site that can't handle retry then it will SIGBUS anyhow?

Do such call sites exist?  My assumption was that half of the branch
was unlikely to ever occur.

> The weird use of a rwsem as a completion suggest that perhaps using
> wait_event might improve things:
> 
> disable:
>   // Clean out the vma list with zap, then:
> 
>   down_read(mm->mmap_sem)

I assume this is simplifying the dance we do in zapping to first take
vma_lock in order to walk vma_list, to find a vma from which we can
acquire the mm, drop vma_lock, get mmap_sem, then re-get vma_lock
below.  Also accounting that vma_list might be empty and we might need
to drop and re-acquire vma_lock to get to another mm, so we really
probably want to set pause_faults at the start rather than at the end.

>   mutex_lock(vma_lock);
>   list_for_each_entry_safe()
>      // zap and remove all vmas
> 
>   pause_faults = true;
>   mutex_write(vma_lock);
> 
> fault:
>   // Already have down_read(mmap_sem)
>   mutex_lock(vma_lock);
>   while (pause_faults) {
>      mutex_unlock(vma_lock)
>      wait_event(..., !pause_faults)
>      mutex_lock(vma_lock)
>   }

Nit, we need to test the memory enable bit setting somewhere under this
lock since it seems to be the only thing protecting it now.

>   list_add()
>   remap_pfn()
>   mutex_unlock(vma_lock)

The read and write file ops would need similar mechanisms.

> enable:
>   pause_faults = false
>   wake_event()

Hmm, vma_lock was dropped above and not re-acquired here.  I'm not sure
if it was an oversight that pause_faults was not tested in the disable
path, but this combination appears to lead to concurrent writers and
serialized readers??

So yeah, this might resolve a theoretical sigbus if we can't retry to
get the memory_lock ordering correct, but we also lose the concurrency
that memory_lock provided us.

> 
> The only requirement here is that while inside the write side of
> memory_lock you cannot touch user pages (ie no copy_from_user/etc)

I'm lost at this statement, I can only figure the above works if we
remove memory_lock.  Are you referring to a different lock?  Thanks,

Alex

