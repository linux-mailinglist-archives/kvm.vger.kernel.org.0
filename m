Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E838287082
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 10:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgJHIKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 04:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbgJHIKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 04:10:07 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C52C0613D4
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 01:10:05 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id l4so4728320ota.7
        for <kvm@vger.kernel.org>; Thu, 08 Oct 2020 01:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wCjCa64MStwiq1yR7OaeNvk7N1NN2BleqQckjLbhNYU=;
        b=C53LylVZwMO0g2+JAqtSBtMgpBv+ulmsaRO6I2h41YCH/cKnnJ2tt3EfS3lZw6Rhw0
         MUO4icylwPq5djGkpDWWyO5lhz5aT49NTtxjLsnsfxd1PvP6W6t98VP0roBxwIJCy+Bl
         vpajr9+5TXFrcHadQv/pRUWTQ9v7fI3MyQ+kM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wCjCa64MStwiq1yR7OaeNvk7N1NN2BleqQckjLbhNYU=;
        b=NoYprkV+bPYsQh8LZuOCTdCwEL5WreAGfgVDAeGnpeR6syCzIAbuZHLR3K3PQ4ez4t
         vS73OpGNNfp0UOB5gQrIWDPgUoEBnEvri9j2AZK6EPvoMCKCta0CVtYuFQiOyZYWUvyo
         ToOFUmy1Zh0ohtMsk1R8BQk5QG532LFqsydUHw0kLgeRnhhdRVpaV8LlceYnjQjMu+Mj
         zD5UuVDeymTUz1KtSpChEEIwM+1ME8RyIurJUcVhcubypQmhifjR3/NCzpCdB9h44zvj
         EExFOh6L1wel9JjLPh9oHeVr/Cy1WksE4mRw0tPQJmyBqU8oqWbDaW6pjpAVArYKTO3m
         s6WA==
X-Gm-Message-State: AOAM530OB2XvFne2TPU8/y8a4zxKL0MBsdJaMXkWqozoInuStUnPNxiw
        64KFVTOme3J4CqRMidW3c4DQnVzeUTElT/YhVp6krw==
X-Google-Smtp-Source: ABdhPJz2Aux80kUsEM7YHCXCuraur5IrUAmiithdZ9pp1HS0einrpaKxMEfTYuxGd6kEaO0zfYuPyPuQ741ZEEETeSg=
X-Received: by 2002:a05:6830:1e56:: with SMTP id e22mr4190355otj.303.1602144605250;
 Thu, 08 Oct 2020 01:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-11-daniel.vetter@ffwll.ch> <CAPcyv4hBL68A7CZa+YnooufDH2tevoxrx32DTJMQ6OHRnec7QQ@mail.gmail.com>
 <CAKMK7uFoxiPdjO-yhd-mKqumnTpjcENEReb1sOYhOwRRCL0wpQ@mail.gmail.com>
 <CAPcyv4jGxsB5so8mKqYrsn2CEc7nO2yPvzZZ_mvM_-R=BZfKHg@mail.gmail.com> <CAPcyv4iN1q0LUVTO6igMKPe-8hnR5ULF+mBnWy6bdXfY2M6YmA@mail.gmail.com>
In-Reply-To: <CAPcyv4iN1q0LUVTO6igMKPe-8hnR5ULF+mBnWy6bdXfY2M6YmA@mail.gmail.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 8 Oct 2020 10:09:54 +0200
Message-ID: <CAKMK7uEETcQrPBC=4URQZtD73nA9MvQpBx-TOv95bdwzNOOA2g@mail.gmail.com>
Subject: Re: [PATCH 10/13] PCI: revoke mappings like devmem
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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

On Thu, Oct 8, 2020 at 12:29 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Wed, Oct 7, 2020 at 3:23 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Wed, Oct 7, 2020 at 12:49 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > >
> > > On Wed, Oct 7, 2020 at 9:33 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > > >
> > > > On Wed, Oct 7, 2020 at 11:11 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > > > >
> > > > > Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims
> > > > > the region") /dev/kmem zaps ptes when the kernel requests exclusive
> > > > > acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, this is
> > > > > the default for all driver uses.
> > > > >
> > > > > Except there's two more ways to access pci bars: sysfs and proc mmap
> > > > > support. Let's plug that hole.
> > > >
> > > > Ooh, yes, lets.
> > > >
> > > > > For revoke_devmem() to work we need to link our vma into the same
> > > > > address_space, with consistent vma->vm_pgoff. ->pgoff is already
> > > > > adjusted, because that's how (io_)remap_pfn_range works, but for the
> > > > > mapping we need to adjust vma->vm_file->f_mapping. Usually that's done
> > > > > at ->open time, but that's a bit tricky here with all the entry points
> > > > > and arch code. So instead create a fake file and adjust vma->vm_file.
> > > >
> > > > I don't think you want to share the devmem inode for this, this should
> > > > be based off the sysfs inode which I believe there is already only one
> > > > instance per resource. In contrast /dev/mem can have multiple inodes
> > > > because anyone can just mknod a new character device file, the same
> > > > problem does not exist for sysfs.
> > >
> > > But then I need to find the right one, plus I also need to find the
> > > right one for the procfs side. That gets messy, and I already have no
> > > idea how to really test this. Shared address_space is the same trick
> > > we're using in drm (where we have multiple things all pointing to the
> > > same underlying resources, through different files), and it gets the
> > > job done. So that's why I figured the shared address_space is the
> > > cleaner solution since then unmap_mapping_range takes care of
> > > iterating over all vma for us. I guess I could reimplement that logic
> > > with our own locking and everything in revoke_devmem, but feels a bit
> > > silly. But it would also solve the problem of having mutliple
> > > different mknod of /dev/kmem with different address_space behind them.
> > > Also because of how remap_pfn_range works, all these vma do use the
> > > same pgoff already anyway.
> >
> > True, remap_pfn_range() makes sure that ->pgoff is an absolute
> > physical address offset for all use cases. So you might be able to
> > just point proc_bus_pci_open() at the shared devmem address space. For
> > sysfs it's messier. I think you would need to somehow get the inode
> > from kernfs_fop_open() to adjust its address space, but only if the
> > bin_file will ultimately be used for PCI memory.

Just read the code  a bit more, and for proc it's impossible. There's
only a single file, and before you mmap it you have to call a few
ioctl to select the right pci resource on that device you want to
mmap. Which includes legacy ioport stuff, and at least for now those
don't get revoked (maybe they should, but I'm looking at iomem here
now). Setting the mapping too early in ->open means that on
architectures which can do ioport as mmaps (not many, but powerpc is
among them) we'd shoot down these mmaps too.

Looking at the code there's the generic implementation, which consults
pci_iobar_pfn. And the only other implementation for sparc looks
similar, they separate iomem vs ioport through different pfn. So I
think this should indeed work.

> To me this seems like a new sysfs_create_bin_file() flavor that
> registers the file with the common devmem address_space.

Hm I think we could just add a i_mapping member to bin_attributes and
let the normal open code set that up for us. That should work.
mmapable binary sysfs file is already a similar special case.
-Daniel




--
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
