Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFB81C4637
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEDSoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEDSoi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 14:44:38 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6BBC061A0E
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 11:44:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c10so647247qka.4
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 11:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eFQctCe/dUZcz9pj+1iw+95XaaxxZkwekF/8gFv+X+I=;
        b=fnUNBFaCK4+a91BpF02wWvgKcp8W/gk5WMYI+uqoJSKsOzN3jnpWZmUt5zplVm6N6i
         ANzUs52EYdWhOesq1Dld/5Q9Ij6hz/oiOwnbfBcFyar978eH11GpO8ahNKkcrJYLm6KU
         7HJaxrtIVA/NciTcmqcohCpLPnd98S8pJxLtATLoEiDTPXO6Z9Qvl54ecyMg5w+AWSVU
         k1I+D/M0NQ09KtjgMlpxnu/TjsepQ2wJTS6DjYBwwqXdXrVPavk5shrHEbvrLdYCMFYB
         wr/939Jp9Ju6OeiQDl70haAvvtG0cAbFzOf/MyAJOC9xEre4OzLMoyYU9aAKQF6H4wQa
         jh4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eFQctCe/dUZcz9pj+1iw+95XaaxxZkwekF/8gFv+X+I=;
        b=J58J4PDOnPL9DGlFE2KSAYQUhAUW6m0q3imFX++5AVFx5Ia/tEch+hd4COtCpBZrmF
         hAu+BTXfp/bDxaQnoPx7QYnkywqcNTdlUd8kOrae+Ogy6baKXSU/fZrt+VCYnA+L/rgt
         Bcr+qkSvSHGOUvjzdg11o93H3m82MYFDAV7wGFkW2iFXoaGcTBa9fuDtIxa9cG0mNp21
         A9hOY2f7ofs8BARuSm4y+sbx93rzCp39bE3UJ+LYVZ/aCkcfG7iwvBNmnoQeYyQQwK9I
         EsZFVCrdD7x6Ap05hi1c1SzVIQjBbmLGDtEelWdGsTsyN6G2vZYSTnzF6VR5/VXX3Zma
         7zrw==
X-Gm-Message-State: AGi0PuYsSzf7IFN7pG2sRFO3YOD69ZnEaes/klM6Kt0VYty8rAMXzzYn
        xcqZeqmhvKPkHKzai0dAoataFRu483M=
X-Google-Smtp-Source: APiQypLiC/JxSnNk15n3xK+Aa5cf5pPTYGXyYyNqnACTvOvqJ+2FJphkUMAJpCpXShloqlbeCGQCRA==
X-Received: by 2002:a37:a753:: with SMTP id q80mr641311qke.492.1588617877043;
        Mon, 04 May 2020 11:44:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id n23sm4011594qtk.12.2020.05.04.11.44.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 May 2020 11:44:36 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jVg4y-0001qE-4G; Mon, 04 May 2020 15:44:36 -0300
Date:   Mon, 4 May 2020 15:44:36 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 3/3] vfio-pci: Invalidate mmaps and block MMIO access on
 disabled memory
Message-ID: <20200504184436.GZ26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
 <158836917028.8433.13715345616117345453.stgit@gimli.home>
 <20200501234849.GQ26002@ziepe.ca>
 <20200504122643.52267e44@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504122643.52267e44@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 12:26:43PM -0600, Alex Williamson wrote:
> On Fri, 1 May 2020 20:48:49 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Fri, May 01, 2020 at 03:39:30PM -0600, Alex Williamson wrote:
> > 
> > >  static int vfio_pci_add_vma(struct vfio_pci_device *vdev,
> > >  			    struct vm_area_struct *vma)
> > >  {
> > > @@ -1346,15 +1450,49 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > >  {
> > >  	struct vm_area_struct *vma = vmf->vma;
> > >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > > +	vm_fault_t ret = VM_FAULT_NOPAGE;
> > >  
> > > -	if (vfio_pci_add_vma(vdev, vma))
> > > -		return VM_FAULT_OOM;
> > > +	/*
> > > +	 * Zap callers hold memory_lock and acquire mmap_sem, we hold
> > > +	 * mmap_sem and need to acquire memory_lock to avoid races with
> > > +	 * memory bit settings.  Release mmap_sem, wait, and retry, or fail.
> > > +	 */
> > > +	if (unlikely(!down_read_trylock(&vdev->memory_lock))) {
> > > +		if (vmf->flags & FAULT_FLAG_ALLOW_RETRY) {
> > > +			if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
> > > +				return VM_FAULT_RETRY;
> > > +
> > > +			up_read(&vma->vm_mm->mmap_sem);
> > > +
> > > +			if (vmf->flags & FAULT_FLAG_KILLABLE) {
> > > +				if (!down_read_killable(&vdev->memory_lock))
> > > +					up_read(&vdev->memory_lock);
> > > +			} else {
> > > +				down_read(&vdev->memory_lock);
> > > +				up_read(&vdev->memory_lock);
> > > +			}
> > > +			return VM_FAULT_RETRY;
> > > +		}
> > > +		return VM_FAULT_SIGBUS;
> > > +	}  
> > 
> > So, why have the wait? It isn't reliable - if this gets faulted from a
> > call site that can't handle retry then it will SIGBUS anyhow?
> 
> Do such call sites exist?  My assumption was that half of the branch
> was unlikely to ever occur.

hmm_range_fault() for instance doesn't set ALLOW_RETRY, I assume there
are enough other case to care about, but am not so sure

> > The weird use of a rwsem as a completion suggest that perhaps using
> > wait_event might improve things:
> > 
> > disable:
> >   // Clean out the vma list with zap, then:
> > 
> >   down_read(mm->mmap_sem)
> 
> I assume this is simplifying the dance we do in zapping to first take
> vma_lock in order to walk vma_list, to find a vma from which we can
> acquire the mm, drop vma_lock, get mmap_sem, then re-get vma_lock
> below.  

No, that has to stay..

> Also accounting that vma_list might be empty and we might need
> to drop and re-acquire vma_lock to get to another mm, so we really
> probably want to set pause_faults at the start rather than at the end.

New vmas should not created/faulted while vma_lock is held, so the
order shouldn't matter..

> >   mutex_lock(vma_lock);
> >   list_for_each_entry_safe()
> >      // zap and remove all vmas
> > 
> >   pause_faults = true;
> >   mutex_write(vma_lock);
> > 
> > fault:
> >   // Already have down_read(mmap_sem)
> >   mutex_lock(vma_lock);
> >   while (pause_faults) {
> >      mutex_unlock(vma_lock)
> >      wait_event(..., !pause_faults)
> >      mutex_lock(vma_lock)
> >   }
> 
> Nit, we need to test the memory enable bit setting somewhere under this
> lock since it seems to be the only thing protecting it now.

I was thinking you'd keep the same locking for the memory enable bit,
the pause_faults is a shadow of that bit with locking connected to
vma_lock..

> >   list_add()
> >   remap_pfn()
> >   mutex_unlock(vma_lock)
> 
> The read and write file ops would need similar mechanisms.

Keep using the rwsem?

> > enable:
> >   pause_faults = false
> >   wake_event()
> 
> Hmm, vma_lock was dropped above and not re-acquired here.

I was thinking this would be under a continous rwlock

> I'm not sure if it was an oversight that pause_faults was not tested
> in the disable path, but this combination appears to lead to
> concurrent writers and serialized readers??

? pause_faults only exists to prevent the vm_ops fault callback from
progressing to a fault. I don't think any concurrancy is lost

> > The only requirement here is that while inside the write side of
> > memory_lock you cannot touch user pages (ie no copy_from_user/etc)
> 
> I'm lost at this statement, I can only figure the above works if we
> remove memory_lock.  Are you referring to a different lock?  Thanks,

No

This is just an approach to avoid the ABBA deadlock problem when using
a rwsem by using a looser form of lock combined witih the already
correctly nested vma_lock.

Stated another way, you can keep the existing memory_lock as is, if it
is structured like this:

disable:
 down_read(mmap_sem)
 mutex_lock(vma_lock)
 list_for_each_entry_safe()
      // zap and remove all vmas
 down_write(memory_lock)   // Now inside vma_lock!
 mutex_unlock(vma_lock)
 up_read(mmap_sem

 [ do the existing stuff under memory_lock ]


fault:
  mutex_lock(vma_lock)
  down_write(memory_lock)
  remap_pfn
  up_write(memory_lock)
  mutex_unlock(vma_lock)

enable:
  up_write(memory_lock)

Ie the key is to organize things to move the down_write(memory_lock)
to be under the mmap_sem/vma_lock

Jason
