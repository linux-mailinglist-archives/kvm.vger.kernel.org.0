Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF4287087
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 10:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgJHINS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 04:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgJHINS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 04:13:18 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6254AC0613D4
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 01:13:18 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id f10so4747746otb.6
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 01:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6GE5pSnNRg0KlyvewB9QKOrrd6/Nut8BwJvyodyZJd4=;
        b=hMW7zxgBaxDt7Z8CMDWn3cCXSOY5QqOrFQ/uoN1baUlAIhOFYy+4SzujzZvv4Ur9FN
         onPuYsY03fgo4HL/In06Uiy/3ynGYwzwiQV3wfZ6whnso50XlzhHTRy/QZJCTuip3uEr
         ueKV+xdznXeh2dJB78HPK0Klt6lkMJnLUSyGA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6GE5pSnNRg0KlyvewB9QKOrrd6/Nut8BwJvyodyZJd4=;
        b=txXHXPYnCuXOUAuZB9lXear7qjh2nal/CzfBQIbsbKUW6V5jnreYd9Bn1y/TlbD1jB
         1nGKdr7DAw73lUQtE5tPT/WxL0WqX7rVVxXLQDpZr7al8gAS2HOW2c3oN2EDI8vuqxVV
         4++xtQ+K+AKpSHfCGlCpn/sk+nzqD7hWI4oFn+dLw5OrYS3Ao7wSwksDDrtoGPsKdyQD
         qiXaaL4ure1rFtFW2GT+WYMRXjRscznNmucyDI/1GJI6W/1FDjkut0uVjeWNGQ+XIVsY
         OlxNCyMRlwpT8P6TyHrwp/1bfnG5bOk0j63aAx/+DFVzPvFKRn6cvM5AqT/6WISUGu6p
         QP5w==
X-Gm-Message-State: AOAM5313pRRVLpSAAeRSHdA7OveJp+ZK0V5+GEw9sWL+kqVHCix0zUcm
        dk6A9A0T3FjfIULGGPkgYug5WjndGqZ4Mr/pjjSo5A==
X-Google-Smtp-Source: ABdhPJzi+1LyDtM+RDWyhibTLQ/9o198dN3ibfXFnaztfI6BQhE6ckMA8Uych0T6Rb8ANf5SnQ1gmeZGjO89xISEbKU=
X-Received: by 2002:a05:6830:1647:: with SMTP id h7mr4572127otr.281.1602144797647;
 Thu, 08 Oct 2020 01:13:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-11-daniel.vetter@ffwll.ch> <CAPcyv4hBL68A7CZa+YnooufDH2tevoxrx32DTJMQ6OHRnec7QQ@mail.gmail.com>
 <20201007232448.GC5177@ziepe.ca> <CAPcyv4jA9fe40r_2SfrCtOaeE85V88TA3NNQZOmQMNj=MdsPyw@mail.gmail.com>
In-Reply-To: <CAPcyv4jA9fe40r_2SfrCtOaeE85V88TA3NNQZOmQMNj=MdsPyw@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 8 Oct 2020 10:13:06 +0200
Message-ID: <CAKMK7uHg48-fTR1L78p7q5vxD=Kgr_fBEj1pDLaYeuvTGSSFig@mail.gmail.com>
Subject: Re: [PATCH 10/13] PCI: revoke mappings like devmem
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 8, 2020 at 9:50 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Oct 7, 2020 at 4:25 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Wed, Oct 07, 2020 at 12:33:06PM -0700, Dan Williams wrote:
> > > On Wed, Oct 7, 2020 at 11:11 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > >
> > > > Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims
> > > > the region") /dev/kmem zaps ptes when the kernel requests exclusive
> > > > acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, this is
> > > > the default for all driver uses.
> > > >
> > > > Except there's two more ways to access pci bars: sysfs and proc mmap
> > > > support. Let's plug that hole.
> > >
> > > Ooh, yes, lets.
> > >
> > > >
> > > > For revoke_devmem() to work we need to link our vma into the same
> > > > address_space, with consistent vma->vm_pgoff. ->pgoff is already
> > > > adjusted, because that's how (io_)remap_pfn_range works, but for the
> > > > mapping we need to adjust vma->vm_file->f_mapping. Usually that's done
> > > > at ->open time, but that's a bit tricky here with all the entry points
> > > > and arch code. So instead create a fake file and adjust vma->vm_file.
> > >
> > > I don't think you want to share the devmem inode for this, this should
> > > be based off the sysfs inode which I believe there is already only one
> > > instance per resource. In contrast /dev/mem can have multiple inodes
> > > because anyone can just mknod a new character device file, the same
> > > problem does not exist for sysfs.
> >
> > The inode does not come from the filesystem char/mem.c creates a
> > singular anon inode in devmem_init_inode()
>
> That's not quite right, An inode does come from the filesystem I just
> arranged for that inode's i_mapping to be set to a common instance.
>
> > Seems OK to use this more widely, but it feels a bit weird to live in
> > char/memory.c.
>
> Sure, now that more users have arrived it should move somewhere common.
>
> > This is what got me thinking maybe this needs to be a bit bigger
> > generic infrastructure - eg enter this scheme from fops mmap and
> > everything else is in mm/user_iomem.c
>
> It still requires every file that can map physical memory to have its
> ->open fop do
>
>        inode->i_mapping = devmem_inode->i_mapping;
>        filp->f_mapping = inode->i_mapping;
>
> I don't see how you can centralize that part.

btw, why are you setting inode->i_mapping? The inode is already
published, changing that looks risky. And I don't think it's needed,
vma_link() only looks at filp->f_mapping, and in our drm_open() we
only set that one.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
