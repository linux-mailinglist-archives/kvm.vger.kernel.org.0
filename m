Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D9C2FB3E2
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 09:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbhASIT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 03:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbhASITU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 03:19:20 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57385C0613D3
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 00:18:07 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id o11so19009791ote.4
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 00:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WfFJuLm0JWFKIZSr35gVwj0xg2AYZzNEcuLqFUXW2+8=;
        b=PbkKRo7SNg95R94SiZevOw2BEtiFlTjvdHUYcZPMAnSrGIckYOkeHga/KY6+b/RNEu
         RQKckLdL5MSMzGFd7lJcRzJqnGxbYjtG1EOrlYplFzb90mxOoz3o6SCb0Xws/78s2/JW
         OCW0F7fS42A6taX0chOn4gczjDBvyZIQbF25k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WfFJuLm0JWFKIZSr35gVwj0xg2AYZzNEcuLqFUXW2+8=;
        b=uOSqMGLQwtCSczJ3hhaKTqIuz2RCYZxuxyh9FhwJBFxR+5GytTNOLEMroZyzI84Fbj
         Le0QBGX2njH5Oe6K3/RSxmd1TvBtm8YcUzU3X/fTZialbQCkNdpkAldmQY6YmsH+9tgN
         UUD3yXE9BoG43Zn1XvhjSgs0zu3AJLzuAlProzeR4x1eWrMRtaVt72+cDOXmY1pljmck
         W2QH8nOQ5/9OaBxZXJyyqf6Dlog1HdRWlXhcsYa1SOAsVf4vWq4Aiuzab8woeijkN57z
         4GSa/GI9DI2xq12DoK2AHTmbFRiksSkQ4HhewZp7g3Ak5067XJNZuwmuv3Yx2PJBcltN
         G3aA==
X-Gm-Message-State: AOAM532j+jTNSa0C4ocXA9RsuK7zMVPPrOq83CF2S3C5UhlYDNJiDUM3
        SZVVzxkiVkTYx2TcRJsVQx/Css5GAaVDIL77SUksoA==
X-Google-Smtp-Source: ABdhPJzaeODA4sJQGtFnmlEJhEIejHm5tUfJ6WBUJaaM4JSKW7UsD8q5H1JPOzhq7vW/xPspCH7j/ySdSzg97qcaAUI=
X-Received: by 2002:a9d:23ca:: with SMTP id t68mr2659337otb.281.1611044286607;
 Tue, 19 Jan 2021 00:18:06 -0800 (PST)
MIME-Version: 1.0
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch> <20201127164131.2244124-13-daniel.vetter@ffwll.ch>
In-Reply-To: <20201127164131.2244124-13-daniel.vetter@ffwll.ch>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 19 Jan 2021 09:17:55 +0100
Message-ID: <CAKMK7uGrdDrbtj0OyzqQc0CGrQwc2F3tFJU9vLfm2jjufAZ5YQ@mail.gmail.com>
Subject: Re: [PATCH v7 12/17] PCI: Revoke mappings like devmem
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 27, 2020 at 5:42 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims
> the region") /dev/kmem zaps ptes when the kernel requests exclusive
> acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, this is
> the default for all driver uses.
>
> Except there's two more ways to access PCI BARs: sysfs and proc mmap
> support. Let's plug that hole.
>
> For revoke_devmem() to work we need to link our vma into the same
> address_space, with consistent vma->vm_pgoff. ->pgoff is already
> adjusted, because that's how (io_)remap_pfn_range works, but for the
> mapping we need to adjust vma->vm_file->f_mapping. The cleanest way is
> to adjust this at at ->open time:
>
> - for sysfs this is easy, now that binary attributes support this. We
>   just set bin_attr->mapping when mmap is supported
> - for procfs it's a bit more tricky, since procfs pci access has only
>   one file per device, and access to a specific resources first needs
>   to be set up with some ioctl calls. But mmap is only supported for
>   the same resources as sysfs exposes with mmap support, and otherwise
>   rejected, so we can set the mapping unconditionally at open time
>   without harm.
>
> A special consideration is for arch_can_pci_mmap_io() - we need to
> make sure that the ->f_mapping doesn't alias between ioport and iomem
> space. There's only 2 ways in-tree to support mmap of ioports: generic
> pci mmap (ARCH_GENERIC_PCI_MMAP_RESOURCE), and sparc as the single
> architecture hand-rolling. Both approach support ioport mmap through a
> special pfn range and not through magic pte attributes. Aliasing is
> therefore not a problem.
>
> The only difference in access checks left is that sysfs PCI mmap does
> not check for CAP_RAWIO. I'm not really sure whether that should be
> added or not.
>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> --
> v2:
> - Totally new approach: Adjust filp->f_mapping at open time. Note that
>   this now works on all architectures, not just those support
>   ARCH_GENERIC_PCI_MMAP_RESOURCE
> ---
>  drivers/pci/pci-sysfs.c | 4 ++++
>  drivers/pci/proc.c      | 1 +
>  2 files changed, 5 insertions(+)
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index d15c881e2e7e..3f1c31bc0b7c 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -929,6 +929,7 @@ void pci_create_legacy_files(struct pci_bus *b)
>         b->legacy_io->read =3D pci_read_legacy_io;
>         b->legacy_io->write =3D pci_write_legacy_io;
>         b->legacy_io->mmap =3D pci_mmap_legacy_io;
> +       b->legacy_io->mapping =3D iomem_get_mapping();
>         pci_adjust_legacy_attr(b, pci_mmap_io);
>         error =3D device_create_bin_file(&b->dev, b->legacy_io);
>         if (error)
> @@ -941,6 +942,7 @@ void pci_create_legacy_files(struct pci_bus *b)
>         b->legacy_mem->size =3D 1024*1024;
>         b->legacy_mem->attr.mode =3D 0600;
>         b->legacy_mem->mmap =3D pci_mmap_legacy_mem;
> +       b->legacy_io->mapping =3D iomem_get_mapping();

Unlike the normal pci stuff below, the legacy files here go boom
because they're set up much earlier in the boot sequence. This only
affects HAVE_PCI_LEGACY architectures, which aren't that many. So what
should we do here now:
- drop the devmem revoke for these
- rework the init sequence somehow to set up these files a lot later
- redo the sysfs patch so that it doesn't take an address_space
pointer, but instead a callback to get at that (since at open time
everything is set up). Imo rather ugly
- ditch this part of the series (since there's not really any takers
for the latter parts it might just not make sense to push for this)
- something else?

Bjorn, Greg, thoughts?

Issuge got reported by Stephen on a powerpc when trying to build
linux-next with this patch included.

Thanks, Daniel

>         pci_adjust_legacy_attr(b, pci_mmap_mem);
>         error =3D device_create_bin_file(&b->dev, b->legacy_mem);
>         if (error)
> @@ -1156,6 +1158,8 @@ static int pci_create_attr(struct pci_dev *pdev, in=
t num, int write_combine)
>                         res_attr->mmap =3D pci_mmap_resource_uc;
>                 }
>         }
> +       if (res_attr->mmap)
> +               res_attr->mapping =3D iomem_get_mapping();
>         res_attr->attr.name =3D res_attr_name;
>         res_attr->attr.mode =3D 0600;
>         res_attr->size =3D pci_resource_len(pdev, num);
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index 3a2f90beb4cb..9bab07302bbf 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -298,6 +298,7 @@ static int proc_bus_pci_open(struct inode *inode, str=
uct file *file)
>         fpriv->write_combine =3D 0;
>
>         file->private_data =3D fpriv;
> +       file->f_mapping =3D iomem_get_mapping();
>
>         return 0;
>  }
> --
> 2.29.2
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
