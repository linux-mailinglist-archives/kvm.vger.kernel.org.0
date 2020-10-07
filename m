Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E49B286AD5
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 00:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJGWYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 18:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbgJGWYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 18:24:10 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FC1C0613D5
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 15:24:09 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id i5so3841343edr.5
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 15:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zic23vwE4RxhL64QubFNAgrR6bPLwF/Sw808vPXOvcE=;
        b=QQSRcBFI6KAV++JS9/GFj7Fmw4j7a/iMiUg1ZTuLmVxWhkZMKv0QD8k1ukWq7eq/is
         aqhku7tesefyyeplMfP+uZ40G5Eu5h32eX3quWRsYX4t93t8hfPAksy+eKFnntLzh659
         XKe6EgVkLvN8qFLGttYIbd5R75etFF329oIsGVg7tFamYwMf914oOqvj5Aj57gMZmmXn
         BdX+R3HH+c0ZbeHsryryJmXxzi8LbxHVyDfXa28xyWATs9steaqxyt3ORz7tJ5iS3p0B
         /C9lomlbRYU4nllCvXcMpiVBxaPdCxNSDAwt+Wnv7NkDlHC0AVoEJJmmbnIbcEEDMbkk
         VNvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zic23vwE4RxhL64QubFNAgrR6bPLwF/Sw808vPXOvcE=;
        b=d/Se5u3/0olPLmJ7K1cKaKpdyWpzOPR2iw/nDl9MjdWWyxUvs3qtodz99leGp/OZFE
         a/Vk2kxfsmfpMHapppa+FswN5LcoqJoNitE4v9CcCAViuILycNt+vuGjdULyiCoLplrI
         g5d52EcwlcRh64t0v9LE284x0WirqlYCR3rq0OaWVGEQgoqnPqn9nNsXyH6Dg1YxLDCS
         vX+j1rhsknVAh6x+Nam4AhxuDMhCGhlhgR9kDq/EYZ02KTd3RXGw0HREKX0TmQczvJYJ
         TJFVFcdyKTvpPCXbRvIybDh/r9pjaHFYejoBO+V2ThGPSyeX/nA4AZDl2cjIZ0+H8bgl
         fc8g==
X-Gm-Message-State: AOAM533z85WZSSAAf+gX/hIhHfzuS6i3cLJNi+/oQJ/m7rTuQPkgmlVZ
        4RzvCLM6NZ3xOYp/nlGq6i0/q4PWaCLEg6XB45yugA==
X-Google-Smtp-Source: ABdhPJyEbSoLmGrub89sZew46mtuYR5cC3wqZnDpHg2eEdBRv6ndP1ZtRmu/HFaFG/gOZx15NdgN0Q/4bhJSTz4VXAk=
X-Received: by 2002:a50:d0d0:: with SMTP id g16mr5862132edf.18.1602109448239;
 Wed, 07 Oct 2020 15:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201007164426.1812530-1-daniel.vetter@ffwll.ch>
 <20201007164426.1812530-11-daniel.vetter@ffwll.ch> <CAPcyv4hBL68A7CZa+YnooufDH2tevoxrx32DTJMQ6OHRnec7QQ@mail.gmail.com>
 <CAKMK7uFoxiPdjO-yhd-mKqumnTpjcENEReb1sOYhOwRRCL0wpQ@mail.gmail.com>
In-Reply-To: <CAKMK7uFoxiPdjO-yhd-mKqumnTpjcENEReb1sOYhOwRRCL0wpQ@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 7 Oct 2020 15:23:57 -0700
Message-ID: <CAPcyv4jGxsB5so8mKqYrsn2CEc7nO2yPvzZZ_mvM_-R=BZfKHg@mail.gmail.com>
Subject: Re: [PATCH 10/13] PCI: revoke mappings like devmem
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
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

On Wed, Oct 7, 2020 at 12:49 PM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
> On Wed, Oct 7, 2020 at 9:33 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Wed, Oct 7, 2020 at 11:11 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > >
> > > Since 3234ac664a87 ("/dev/mem: Revoke mappings when a driver claims
> > > the region") /dev/kmem zaps ptes when the kernel requests exclusive
> > > acccess to an iomem region. And with CONFIG_IO_STRICT_DEVMEM, this is
> > > the default for all driver uses.
> > >
> > > Except there's two more ways to access pci bars: sysfs and proc mmap
> > > support. Let's plug that hole.
> >
> > Ooh, yes, lets.
> >
> > > For revoke_devmem() to work we need to link our vma into the same
> > > address_space, with consistent vma->vm_pgoff. ->pgoff is already
> > > adjusted, because that's how (io_)remap_pfn_range works, but for the
> > > mapping we need to adjust vma->vm_file->f_mapping. Usually that's done
> > > at ->open time, but that's a bit tricky here with all the entry points
> > > and arch code. So instead create a fake file and adjust vma->vm_file.
> >
> > I don't think you want to share the devmem inode for this, this should
> > be based off the sysfs inode which I believe there is already only one
> > instance per resource. In contrast /dev/mem can have multiple inodes
> > because anyone can just mknod a new character device file, the same
> > problem does not exist for sysfs.
>
> But then I need to find the right one, plus I also need to find the
> right one for the procfs side. That gets messy, and I already have no
> idea how to really test this. Shared address_space is the same trick
> we're using in drm (where we have multiple things all pointing to the
> same underlying resources, through different files), and it gets the
> job done. So that's why I figured the shared address_space is the
> cleaner solution since then unmap_mapping_range takes care of
> iterating over all vma for us. I guess I could reimplement that logic
> with our own locking and everything in revoke_devmem, but feels a bit
> silly. But it would also solve the problem of having mutliple
> different mknod of /dev/kmem with different address_space behind them.
> Also because of how remap_pfn_range works, all these vma do use the
> same pgoff already anyway.

True, remap_pfn_range() makes sure that ->pgoff is an absolute
physical address offset for all use cases. So you might be able to
just point proc_bus_pci_open() at the shared devmem address space. For
sysfs it's messier. I think you would need to somehow get the inode
from kernfs_fop_open() to adjust its address space, but only if the
bin_file will ultimately be used for PCI memory.
