Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5911E287AC8
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 19:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgJHRQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 13:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbgJHRQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 13:16:31 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B547C061755
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 10:16:31 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id u126so7022415oif.13
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 10:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cJwmJXmW0n/BmBUTL74IPviQIG2habiKD0MU6pN8zhU=;
        b=MVbqu90hJmyrd+sPPkFw6E75unJ8rLwKVenxZgPlZQ0sDsjzqGtKeUBv82TcScacos
         yekx36c3FkXtWDgWxhXXmugd3dPf2By3cV1JwiAspr3dL9gnVzSAVLnXNq7o/V7irYdI
         7mZVqNu2dmuv8QMF1QlWFB/Rs/OIshbHRXrbM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cJwmJXmW0n/BmBUTL74IPviQIG2habiKD0MU6pN8zhU=;
        b=kGMUB8xr0wAWF7W0a3f/jOg4KFBSqZ+nF3q1CNgEY0ItZzqymsn7JsVvqZf/UgWYf6
         T7sMC31qwOnSlrIg+P5aahiVdOIPeZol/thsAXDK7/ffViDw1HB+OLIHdIttg3nwUE4l
         DW48kC4ftIbhZAwjCpu6oLGkmeuskkdWRCfOwQJ4G9OJvroTQiFnuNKN+WktEmLqsc8Z
         XHe6vuZlLbUItxhEbsWn1lv72Uwo92hfNMby2zoVsbrxf6hRohUiV+wZZX1YjTdABIK0
         doodjW7oywl8FZwj1TphNb9WLGkj2Znppushvo91g7THQXEQSGhv0iQ4owZGYneq+P/U
         a4uA==
X-Gm-Message-State: AOAM532SRzeLTktezlmSgmUnHP6CcRJdFDf4+YcJQ/sb2+DB+MdIX/Wz
        h5GQPkqLXdqPqbGqNrzD5LDpDVT/ux2QWSVCjQlNDA==
X-Google-Smtp-Source: ABdhPJzf3e2p0tuIJ1xApDWpklSlKGyjhh7bQmds7tEcm9rrUTBDyTXsYZhQ+pIZOdsswK//Z2G6wQ7JuLDsqNpcK5Y=
X-Received: by 2002:a05:6808:206:: with SMTP id l6mr5847034oie.128.1602177390724;
 Thu, 08 Oct 2020 10:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-9-daniel.vetter@ffwll.ch> <20201008184440.4c3bebed@thinkpad>
In-Reply-To: <20201008184440.4c3bebed@thinkpad>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 8 Oct 2020 19:16:19 +0200
Message-ID: <CAKMK7uFFLB0gXcRt48Da30S+Mt8R+bhx=BGwcTg-b-MMVjcFGw@mail.gmail.com>
Subject: Re: [PATCH 08/13] s390/pci: Remove races against pte updates
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Niklas Schnelle <schnelle@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 8, 2020 at 6:44 PM Gerald Schaefer
<gerald.schaefer@linux.ibm.com> wrote:
>
> On Wed,  7 Oct 2020 18:44:21 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> > Way back it was a reasonable assumptions that iomem mappings never
> > change the pfn range they point at. But this has changed:
> >
> > - gpu drivers dynamically manage their memory nowadays, invalidating
> > ptes with unmap_mapping_range when buffers get moved
> >
> > - contiguous dma allocations have moved from dedicated carvetouts to
> > cma regions. This means if we miss the unmap the pfn might contain
> > pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> >
> > - even /dev/mem now invalidates mappings when the kernel requests that
> > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> > ("/dev/mem: Revoke mappings when a driver claims the region")
> >
> > Accessing pfns obtained from ptes without holding all the locks is
> > therefore no longer a good idea. Fix this.
> >
> > Since zpci_memcpy_from|toio seems to not do anything nefarious with
> > locks we just need to open code get_pfn and follow_pfn and make sure
> > we drop the locks only after we've done. The write function also needs
> > the copy_from_user move, since we can't take userspace faults while
> > holding the mmap sem.
> >
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> > Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> > Cc: linux-s390@vger.kernel.org
> > ---
> >  arch/s390/pci/pci_mmio.c | 98 +++++++++++++++++++++++-----------------
> >  1 file changed, 57 insertions(+), 41 deletions(-)
>
> Looks good, thanks. Also survived some basic function test. Only some
> minor nitpick, see below.
>
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>
> >
> > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > index 401cf670a243..4d194cb09372 100644
> > --- a/arch/s390/pci/pci_mmio.c
> > +++ b/arch/s390/pci/pci_mmio.c
> > @@ -119,33 +119,15 @@ static inline int __memcpy_toio_inuser(void __iom=
em *dst,
> >       return rc;
> >  }
> >
> > -static long get_pfn(unsigned long user_addr, unsigned long access,
> > -                 unsigned long *pfn)
> > -{
> > -     struct vm_area_struct *vma;
> > -     long ret;
> > -
> > -     mmap_read_lock(current->mm);
> > -     ret =3D -EINVAL;
> > -     vma =3D find_vma(current->mm, user_addr);
> > -     if (!vma)
> > -             goto out;
> > -     ret =3D -EACCES;
> > -     if (!(vma->vm_flags & access))
> > -             goto out;
> > -     ret =3D follow_pfn(vma, user_addr, pfn);
> > -out:
> > -     mmap_read_unlock(current->mm);
> > -     return ret;
> > -}
> > -
> >  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
> >               const void __user *, user_buffer, size_t, length)
> >  {
> >       u8 local_buf[64];
> >       void __iomem *io_addr;
> >       void *buf;
> > -     unsigned long pfn;
> > +     struct vm_area_struct *vma;
> > +     pte_t *ptep;
> > +     spinlock_t *ptl;
> >       long ret;
> >
> >       if (!zpci_is_enabled())
> > @@ -158,7 +140,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long,=
 mmio_addr,
> >        * We only support write access to MIO capable devices if we are =
on
> >        * a MIO enabled system. Otherwise we would have to check for eve=
ry
> >        * address if it is a special ZPCI_ADDR and would have to do
> > -      * a get_pfn() which we don't need for MIO capable devices.  Curr=
ently
> > +      * a pfn lookup which we don't need for MIO capable devices.  Cur=
rently
> >        * ISM devices are the only devices without MIO support and there=
 is no
> >        * known need for accessing these from userspace.
> >        */
> > @@ -176,21 +158,37 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned lon=
g, mmio_addr,
> >       } else
> >               buf =3D local_buf;
> >
> > -     ret =3D get_pfn(mmio_addr, VM_WRITE, &pfn);
> > +     ret =3D -EFAULT;
> > +     if (copy_from_user(buf, user_buffer, length))
> > +             goto out_free;
> > +
> > +     mmap_read_lock(current->mm);
> > +     ret =3D -EINVAL;
> > +     vma =3D find_vma(current->mm, mmio_addr);
> > +     if (!vma)
> > +             goto out_unlock_mmap;
> > +     ret =3D -EACCES;
> > +     if (!(vma->vm_flags & VM_WRITE))
> > +             goto out_unlock_mmap;
> > +     if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > +             goto out_unlock_mmap;
>
> That check for VM_IO | VM_PFNMAP was previously hidden inside follow_pfn(=
),
> and that would have returned -EINVAL in this case. With your change, we
> now return -EACCES. Not sure how important that is, but it feels wrong.
> Maybe move the VM_IO | VM_PFNMAP check up, before the ret =3D -EACCES?

I tried to keep the errno unchanged, but fumbled this. Will fix in the
next round, thanks a lot for reviewing and testing.

For merging I think this one here would be best through the s390 tree,
since it can be merged without any of the others in here.

Thanks, Daniel

>
> [...]
> > @@ -306,22 +306,38 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned long=
, mmio_addr,
> >               buf =3D local_buf;
> >       }
> >
> > -     ret =3D get_pfn(mmio_addr, VM_READ, &pfn);
> > +     mmap_read_lock(current->mm);
> > +     ret =3D -EINVAL;
> > +     vma =3D find_vma(current->mm, mmio_addr);
> > +     if (!vma)
> > +             goto out_unlock_mmap;
> > +     ret =3D -EACCES;
> > +     if (!(vma->vm_flags & VM_WRITE))
> > +             goto out_unlock_mmap;
> > +     if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > +             goto out_unlock_mmap;
>
> Same here with VM_IO | VM_PFNMAP and -EINVAL.



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
