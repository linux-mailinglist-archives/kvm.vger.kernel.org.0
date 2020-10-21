Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9C2952EB
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 21:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441997AbgJUT0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 15:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504500AbgJUT0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 15:26:03 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3EEC0613D4
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 12:26:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id h10so3308726oie.5
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 12:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a/Gb9HcqyOMYoS5cL3Mt5peyKXCWIbiLEmXmAVK4Hps=;
        b=U3XYCOdjuUNVKWCdmns9iMe0roViquFzK9csIWb7yZp6wryx/eNlxOudPUYOzPTKCW
         R7lbsTyx1KoDy1l//OTwTi/0983AWoWL+Ua3VHte5mlvaOxbpvb15Bv6y7VNPPwB6/vu
         tbUXkmbe0y5ZTXPxSG0YA1KiqHumdnE8YKYuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a/Gb9HcqyOMYoS5cL3Mt5peyKXCWIbiLEmXmAVK4Hps=;
        b=PAebqC44uyuNulG8N6vhOAXHP7RwH69GrCc5v/RLNRZPKUhSzoh2iAAWbz6FXIx6KZ
         3h9yn6QJ9xVPa+2lTuz8xTj3YQBmlJAM9nWB/FvW6dgcjPN6ectoYRfRAF/1f7SswJiM
         35QXVlHgJgvUIX5tR0bWnrT0HNmZqAuxyn2p03KcvfO3h2rYU9qaeVZohZCtRIAIcWHJ
         8RDvXogvYIMRl5cOh5M5O8lxQjNeHqm3Tyw4Id1OPZ+MeaNQr7UqxwYJdniXbjA0JUZl
         uDJAGQwoql8Cr+GEqVGXow3z9bM6pfpF3ro/5fWCJKUWqJSp6h+R7Ey7BFe4P8282Bqa
         0UaA==
X-Gm-Message-State: AOAM531xCT93EzPYDLsa1yS/YfUjBpinVWhspz7P6tmjuCDi+VnGQ42O
        NSFbYMUYJoui8azEVAJ0KqQdaL5kTOUUrR276X41WQ==
X-Google-Smtp-Source: ABdhPJzKXpPxrAZFssctpwQnMpLd8XkoDOj8a4x2BaU8FAudQbPjd+HCkzpXS4SNO9WctUhK8bbnBXSWU4xkUF0giQE=
X-Received: by 2002:aca:cc01:: with SMTP id c1mr3370927oig.128.1603308362927;
 Wed, 21 Oct 2020 12:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
 <20201021085655.1192025-15-daniel.vetter@ffwll.ch> <CAPcyv4gj=+SkL9LKPf1XixQkNmygp3X45n-QpxajZyM8TqKv1w@mail.gmail.com>
In-Reply-To: <CAPcyv4gj=+SkL9LKPf1XixQkNmygp3X45n-QpxajZyM8TqKv1w@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 21 Oct 2020 21:25:52 +0200
Message-ID: <CAKMK7uH5EJtAGcTsi=a84dkQdFNcy9DxHTUS6Dd=bCxwi4XQXw@mail.gmail.com>
Subject: Re: [PATCH v3 14/16] resource: Move devmem revoke code to resource framework
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        David Hildenbrand <david@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 8:59 PM Dan Williams <dan.j.williams@intel.com> wro=
te:
>
> On Wed, Oct 21, 2020 at 1:57 AM Daniel Vetter <daniel.vetter@ffwll.ch> wr=
ote:
> >
> > We want all iomem mmaps to consistently revoke ptes when the kernel
> > takes over and CONFIG_IO_STRICT_DEVMEM is enabled. This includes the
> > pci bar mmaps available through procfs and sysfs, which currently do
> > not revoke mappings.
> >
> > To prepare for this, move the code from the /dev/kmem driver to
> > kernel/resource.c.
> >
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.com>
> > --
> > v3:
> > - add barrier for consistency and document why we don't have to check
> >   for NULL (Jason)
> > ---
> >  drivers/char/mem.c     |  85 +---------------------------------
> >  include/linux/ioport.h |   6 +--
> >  kernel/resource.c      | 101 ++++++++++++++++++++++++++++++++++++++++-
> >  3 files changed, 102 insertions(+), 90 deletions(-)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 5502f56f3655..53338aad8d28 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -31,9 +31,6 @@
> >  #include <linux/uio.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/security.h>
> > -#include <linux/pseudo_fs.h>
> > -#include <uapi/linux/magic.h>
> > -#include <linux/mount.h>
> >
> >  #ifdef CONFIG_IA64
> >  # include <linux/efi.h>
> > @@ -809,42 +806,6 @@ static loff_t memory_lseek(struct file *file, loff=
_t offset, int orig)
> >         return ret;
> >  }
> >
> > -static struct inode *devmem_inode;
> > -
> > -#ifdef CONFIG_IO_STRICT_DEVMEM
> > -void revoke_devmem(struct resource *res)
> > -{
> > -       /* pairs with smp_store_release() in devmem_init_inode() */
> > -       struct inode *inode =3D smp_load_acquire(&devmem_inode);
> > -
> > -       /*
> > -        * Check that the initialization has completed. Losing the race
> > -        * is ok because it means drivers are claiming resources before
> > -        * the fs_initcall level of init and prevent /dev/mem from
> > -        * establishing mappings.
> > -        */
> > -       if (!inode)
> > -               return;
> > -
> > -       /*
> > -        * The expectation is that the driver has successfully marked
> > -        * the resource busy by this point, so devmem_is_allowed()
> > -        * should start returning false, however for performance this
> > -        * does not iterate the entire resource range.
> > -        */
> > -       if (devmem_is_allowed(PHYS_PFN(res->start)) &&
> > -           devmem_is_allowed(PHYS_PFN(res->end))) {
> > -               /*
> > -                * *cringe* iomem=3Drelaxed says "go ahead, what's the
> > -                * worst that can happen?"
> > -                */
> > -               return;
> > -       }
> > -
> > -       unmap_mapping_range(inode->i_mapping, res->start, resource_size=
(res), 1);
> > -}
> > -#endif
> > -
> >  static int open_port(struct inode *inode, struct file *filp)
> >  {
> >         int rc;
> > @@ -864,7 +825,7 @@ static int open_port(struct inode *inode, struct fi=
le *filp)
> >          * revocations when drivers want to take over a /dev/mem mapped
> >          * range.
> >          */
> > -       filp->f_mapping =3D inode->i_mapping;
> > +       filp->f_mapping =3D iomem_get_mapping();
> >
> >         return 0;
> >  }
> > @@ -995,48 +956,6 @@ static char *mem_devnode(struct device *dev, umode=
_t *mode)
> >
> >  static struct class *mem_class;
> >
> > -static int devmem_fs_init_fs_context(struct fs_context *fc)
> > -{
> > -       return init_pseudo(fc, DEVMEM_MAGIC) ? 0 : -ENOMEM;
> > -}
> > -
> > -static struct file_system_type devmem_fs_type =3D {
> > -       .name           =3D "devmem",
> > -       .owner          =3D THIS_MODULE,
> > -       .init_fs_context =3D devmem_fs_init_fs_context,
> > -       .kill_sb        =3D kill_anon_super,
> > -};
> > -
> > -static int devmem_init_inode(void)
> > -{
> > -       static struct vfsmount *devmem_vfs_mount;
> > -       static int devmem_fs_cnt;
> > -       struct inode *inode;
> > -       int rc;
> > -
> > -       rc =3D simple_pin_fs(&devmem_fs_type, &devmem_vfs_mount, &devme=
m_fs_cnt);
> > -       if (rc < 0) {
> > -               pr_err("Cannot mount /dev/mem pseudo filesystem: %d\n",=
 rc);
> > -               return rc;
> > -       }
> > -
> > -       inode =3D alloc_anon_inode(devmem_vfs_mount->mnt_sb);
> > -       if (IS_ERR(inode)) {
> > -               rc =3D PTR_ERR(inode);
> > -               pr_err("Cannot allocate inode for /dev/mem: %d\n", rc);
> > -               simple_release_fs(&devmem_vfs_mount, &devmem_fs_cnt);
> > -               return rc;
> > -       }
> > -
> > -       /*
> > -        * Publish /dev/mem initialized.
> > -        * Pairs with smp_load_acquire() in revoke_devmem().
> > -        */
> > -       smp_store_release(&devmem_inode, inode);
> > -
> > -       return 0;
> > -}
> > -
> >  static int __init chr_dev_init(void)
> >  {
> >         int minor;
> > @@ -1058,8 +977,6 @@ static int __init chr_dev_init(void)
> >                  */
> >                 if ((minor =3D=3D DEVPORT_MINOR) && !arch_has_dev_port(=
))
> >                         continue;
> > -               if ((minor =3D=3D DEVMEM_MINOR) && devmem_init_inode() =
!=3D 0)
> > -                       continue;
> >
> >                 device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
> >                               NULL, devlist[minor].name);
> > diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> > index 6c2b06fe8beb..8ffb61b36606 100644
> > --- a/include/linux/ioport.h
> > +++ b/include/linux/ioport.h
> > @@ -302,11 +302,7 @@ struct resource *devm_request_free_mem_region(stru=
ct device *dev,
> >  struct resource *request_free_mem_region(struct resource *base,
> >                 unsigned long size, const char *name);
> >
> > -#ifdef CONFIG_IO_STRICT_DEVMEM
> > -void revoke_devmem(struct resource *res);
> > -#else
> > -static inline void revoke_devmem(struct resource *res) { };
> > -#endif
> > +extern struct address_space *iomem_get_mapping(void);
> >
> >  #endif /* __ASSEMBLY__ */
> >  #endif /* _LINUX_IOPORT_H */
> > diff --git a/kernel/resource.c b/kernel/resource.c
> > index 841737bbda9e..a92fed5b9997 100644
> > --- a/kernel/resource.c
> > +++ b/kernel/resource.c
> > @@ -18,12 +18,15 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/fs.h>
> >  #include <linux/proc_fs.h>
> > +#include <linux/pseudo_fs.h>
> >  #include <linux/sched.h>
> >  #include <linux/seq_file.h>
> >  #include <linux/device.h>
> >  #include <linux/pfn.h>
> >  #include <linux/mm.h>
> > +#include <linux/mount.h>
> >  #include <linux/resource_ext.h>
> > +#include <uapi/linux/magic.h>
> >  #include <asm/io.h>
> >
> >
> > @@ -1112,6 +1115,58 @@ resource_size_t resource_alignment(struct resour=
ce *res)
> >
> >  static DECLARE_WAIT_QUEUE_HEAD(muxed_resource_wait);
> >
> > +static struct inode *iomem_inode;
> > +
> > +#ifdef CONFIG_IO_STRICT_DEVMEM
> > +static void revoke_iomem(struct resource *res)
> > +{
> > +       /* pairs with smp_store_release() in iomem_init_inode() */
> > +       struct inode *inode =3D smp_load_acquire(&iomem_inode);
> > +
> > +       /*
> > +        * Check that the initialization has completed. Losing the race
> > +        * is ok because it means drivers are claiming resources before
> > +        * the fs_initcall level of init and prevent /dev/mem from
>
> How about:
>
> s,/dev/mem,iomem_get_mapping() users,
>
> ...now that this facility is generalized?
>
> > +        * establishing mappings.
> > +        */
> > +       if (!inode)
> > +               return;
> > +
> > +       /*
> > +        * The expectation is that the driver has successfully marked
> > +        * the resource busy by this point, so devmem_is_allowed()
> > +        * should start returning false, however for performance this
> > +        * does not iterate the entire resource range.
> > +        */
> > +       if (devmem_is_allowed(PHYS_PFN(res->start)) &&
> > +           devmem_is_allowed(PHYS_PFN(res->end))) {
> > +               /*
> > +                * *cringe* iomem=3Drelaxed says "go ahead, what's the
> > +                * worst that can happen?"
> > +                */
> > +               return;
> > +       }
> > +
> > +       unmap_mapping_range(inode->i_mapping, res->start, resource_size=
(res), 1);
> > +}
> > +struct address_space *iomem_get_mapping(void)
> > +{
> > +       /*
> > +        * This function is only called from file open paths, hence gua=
ranteed
> > +        * that fs_initcalls have completed and no need to check for NU=
LL. But
> > +        * since revoke_iomem can be called before the initcall we stil=
l need
> > +        * the barrier to appease checkers.
> > +        */
> > +       return smp_load_acquire(&iomem_inode)->i_mapping;
> > +}
> > +#else
> > +static void revoke_iomem(struct resource *res) {}
> > +struct address_space *iomem_get_mapping(void)
> > +{
> > +       return NULL;
> > +}
> > +#endif
> > +
> >  /**
> >   * __request_region - create a new busy resource region
> >   * @parent: parent resource descriptor
> > @@ -1179,7 +1234,7 @@ struct resource * __request_region(struct resourc=
e *parent,
> >         write_unlock(&resource_lock);
> >
> >         if (res && orig_parent =3D=3D &iomem_resource)
> > -               revoke_devmem(res);
> > +               revoke_iomem(res);
> >
> >         return res;
> >  }
> > @@ -1713,4 +1768,48 @@ static int __init strict_iomem(char *str)
> >         return 1;
> >  }
> >
> > +static int iomem_fs_init_fs_context(struct fs_context *fc)
> > +{
> > +       return init_pseudo(fc, DEVMEM_MAGIC) ? 0 : -ENOMEM;
> > +}
> > +
> > +static struct file_system_type iomem_fs_type =3D {
> > +       .name           =3D "iomem",
> > +       .owner          =3D THIS_MODULE,
> > +       .init_fs_context =3D iomem_fs_init_fs_context,
> > +       .kill_sb        =3D kill_anon_super,
> > +};
> > +
> > +static int __init iomem_init_inode(void)
> > +{
> > +       static struct vfsmount *iomem_vfs_mount;
> > +       static int iomem_fs_cnt;
> > +       struct inode *inode;
> > +       int rc;
> > +
> > +       rc =3D simple_pin_fs(&iomem_fs_type, &iomem_vfs_mount, &iomem_f=
s_cnt);
> > +       if (rc < 0) {
> > +               pr_err("Cannot mount iomem pseudo filesystem: %d\n", rc=
);
> > +               return rc;
> > +       }
> > +
> > +       inode =3D alloc_anon_inode(iomem_vfs_mount->mnt_sb);
> > +       if (IS_ERR(inode)) {
> > +               rc =3D PTR_ERR(inode);
> > +               pr_err("Cannot allocate inode for iomem: %d\n", rc);
> > +               simple_release_fs(&iomem_vfs_mount, &iomem_fs_cnt);
> > +               return rc;
> > +       }
> > +
> > +       /*
> > +        * Publish /dev/mem initialized.
>
> Similar potential fixup:
>
> "Publish iomem revocation inode initialized"

Yeah makes sense I fix up the comments, I'll do that in v4. Need to
fix up my mangeld sob line anyway :-)

Thanks for taking a careful look at this!

Cheers, Daniel

> Other than that:
>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
