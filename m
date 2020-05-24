Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D041DFC0B
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 02:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbgEXACL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 20:02:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388094AbgEXACJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 20:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590278526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lzVe4yseOekokt0xWutdOy0SRVtJNa4hqgRPx0ValMA=;
        b=QQuKJEyVm3JWl7Hs6QgoUFyjnNomtqyOILZtYCDDvqjvccHIYNZlnUJuxKWbDSN8ecwiSH
        53CbwM8b+unwwEUoE8EJ/5fpXHrMHHeJOz72Lgk9K5gkf2md2abTuMG6N4mKd4v0vbX3xc
        B+/mWM4OXHo2j+eKoJSmO9wke47tmHA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-HUKP8WGDMdS0Jt7KwtD7DA-1; Sat, 23 May 2020 20:02:04 -0400
X-MC-Unique: HUKP8WGDMdS0Jt7KwtD7DA-1
Received: by mail-qk1-f197.google.com with SMTP id p15so14861549qkk.15
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 17:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lzVe4yseOekokt0xWutdOy0SRVtJNa4hqgRPx0ValMA=;
        b=eM3Na+qGuo+sbcLQyfxL9MEcO7Ur88FGY6Iw4VtCkXMA5RzWDX6hsiW083/S7KMoQf
         fE9CdY+B+Ujx/mbfIAa8tEBvQ8P2cjYUetrxIci5X3DuWOiiA6yuEAVl6ZGFkGZNu8je
         f/E0ru/IJoAX0OKAjTa4pYJOIK//kANFgrwZNEw+t7I0lTHLVz5SIMLjt+MHaqMU9MLx
         uSOm755kGLiohmtwbVYigws/lAY2IlE8uau+Wi2CSdJ+q5iAt0RoO/ooctR9fXkMD0tZ
         RSIHpmQ8996dipjQGDQIiqTcnZOPkRKe1nNO3AY6Ww96Z4V1yp2Fxg2s/arUO3lcvGVg
         LITw==
X-Gm-Message-State: AOAM531EOIcYoNQRWWzydfWUTGeympyLC85rVnAr1VirI2m6zR4kWhZa
        zTRzqvyOCsW+18AuMNnG084vYvGtGIdDG76rozIhcysNQnAKHVXMwWFfchSMNp7neItQriMk5az
        dzpGl8V1ibkjQ
X-Received: by 2002:a37:9ac6:: with SMTP id c189mr21269868qke.398.1590278524200;
        Sat, 23 May 2020 17:02:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZ7JOf5p9PoChQF8XgwRUjCRcM/TrdnJvWGrlfSGHSuVMX0Ez6eTGo6asCaTttd5BxzKydhQ==
X-Received: by 2002:a37:9ac6:: with SMTP id c189mr21269854qke.398.1590278523935;
        Sat, 23 May 2020 17:02:03 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id o2sm12139909qtj.70.2020.05.23.17.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 17:02:03 -0700 (PDT)
Date:   Sat, 23 May 2020 20:02:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, cai@lca.pw,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200524000201.GD939059@xz-x1>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200523235257.GC939059@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(CC Andrea too)

On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
> On Sat, May 23, 2020 at 05:06:02PM -0600, Alex Williamson wrote:
> > On Sat, 23 May 2020 15:34:17 -0400
> > Peter Xu <peterx@redhat.com> wrote:
> > 
> > > Hi, Alex,
> > > 
> > > On Fri, May 22, 2020 at 01:17:43PM -0600, Alex Williamson wrote:
> > > > @@ -1346,15 +1526,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > > >  {
> > > >  	struct vm_area_struct *vma = vmf->vma;
> > > >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> > > > +	vm_fault_t ret = VM_FAULT_NOPAGE;
> > > > +
> > > > +	mutex_lock(&vdev->vma_lock);
> > > > +	down_read(&vdev->memory_lock);  
> > > 
> > > I remembered to have seen the fault() handling FAULT_FLAG_RETRY_NOWAIT at least
> > > in the very first version, but it's not here any more...  Could I ask what's
> > > the reason behind?  I probably have missed something along with the versions,
> > > I'm just not sure whether e.g. this would potentially block a GUP caller even
> > > if it's with FOLL_NOWAIT.
> > 
> > This is largely what v2 was about, from the cover letter:
> > 
> >     Locking in 3/ is substantially changed to avoid the retry scenario
> >     within the fault handler, therefore a caller who does not allow
> >     retry will no longer receive a SIGBUS on contention.
> > 
> > The discussion thread starts here:
> > 
> > https://lore.kernel.org/kvm/20200501234849.GQ26002@ziepe.ca/
> 
> [1]
> 
> > 
> > Feel free to interject if there's something that doesn't make sense,
> > the idea is that since we've fixed the lock ordering we never need to
> > release one lock to wait for another, therefore we can wait for the
> > lock.  I'm under the impression that we can wait for the lock
> > regardless of the flags under these conditions.
> 
> I see; thanks for the link.  Sorry I should probably follow up the discussion
> and ask the question earlier, anyway...
> 
> For what I understand now, IMHO we should still need all those handlings of
> FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> not sure what would be the side effect of that if fault() blocked it.  E.g.,
> the caller could be in an atomic context.
> 
> But now I also agree that VM_FAULT_SIGBUS is probably not correct there in the
> initial version [1] - I thought it was OK initially (after all after the
> multiple fault retry series we should always be with FAULT_FLAG_ALLOW_RETRY..).
> However after some thinking... it should be the common slow path where retry is
> simply not allowed.  So IMHO instead of SIGBUS there, we should also use all
> the slow path of the locks.  That'll be safe then because it's never going to
> be with FAULT_FLAG_RETRY_NOWAIT (FAULT_FLAG_RETRY_NOWAIT depends on
> FAULT_FLAG_ALLOW_RETRY).
> 
> A reference code could be __lock_page_or_retry() where the lock_page could wait
> just like we taking the sems/mutexes, and the previous SIGBUS case would
> corresponds to this chunk of __lock_page_or_retry():
> 
> 	} else {
> 		if (flags & FAULT_FLAG_KILLABLE) {
> 			int ret;
> 
> 			ret = __lock_page_killable(page);
> 			if (ret) {
> 				up_read(&mm->mmap_sem);
> 				return 0;
> 			}
> 		} else
> 			__lock_page(page);
> 		return 1;
> 	}
> 
> Thanks,
> 
> -- 
> Peter Xu

-- 
Peter Xu

