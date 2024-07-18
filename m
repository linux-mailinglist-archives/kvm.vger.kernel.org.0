Return-Path: <kvm+bounces-21857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1B99350F7
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 18:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D8741C21B32
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 16:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2AF8145338;
	Thu, 18 Jul 2024 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="btCAZctD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7522F877
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721321790; cv=none; b=QtvY817+61aCNfQ1lGJR0G8dAYGUQ4vYuzogrmVKT9iiVXOE0+uT4T/y4Gt+jnCeDsYj+KG0QOuQPqM5VkErruBd6mhyB376sZ2xxtcnCrjxCrRYIFmG3DIJ1Qh0ruEwdZAbcoIM85txb9Z4MIjAo3IV7/zxRlTHEUblwI6xftY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721321790; c=relaxed/simple;
	bh=/kNrC96SLa9pMwYKkTiBRBrhLaOWqYWyF4WqRaXV5nY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ERYuHzeasNhgL6qW+YP4bcE4MK7QZ/YNqZmbvTfCZ/ABYIBorScjxPeWVVlBczkrfyPD1hrVx6i8sO5dTyXcDWskLthNh4Z6Fm13kmz55ncl+gMhuj9UQgSBaPTyk04g9tPsjKrVCd0zAxF5dS8WfDxCUMOT6dz0EaUkctb/u7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=btCAZctD; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4266ea6a412so4957345e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 09:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721321787; x=1721926587; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c08PzTn2tFJrcWBeS0gm34IumJSEF8qLdqwSHSTODjY=;
        b=btCAZctDDIaWkC8VouZn2lmOgFzS3ktEcO3kCHRZZMgoPu7UCakUa1chnOhtBGYXB3
         0gs5tqXZgGzyG2W2VvvoVhzP9NQMlvFwt4zVaCRae2NQpRcEjGfh6hPhjP4TUOTo8vBA
         QYO9O93idXfhZGw5l9v/fP1YHwMr69piGcyuZ09p0PrgbFcDJhDzPtSoryz9MW7Xw1jY
         6CWc4pb6HFPgwwt4E4hy6oag7A/5/DshiloVwk5LdOJN68eY/rB0JLdzdRQMm/vZC3HV
         9zM6M1NDTdGWOgNRWRKBun/jsGJyQejJHRPFNUK6ypqmLntr5spnJvVl2C+6b8IsWNtN
         l8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721321787; x=1721926587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c08PzTn2tFJrcWBeS0gm34IumJSEF8qLdqwSHSTODjY=;
        b=CaR9TXWjF7hampZNv6nLFxiJfdvNNuMIh4NVX41TVheR7VedIphis0t5NuR/k72rjW
         m8O2xeN9pLqTPUGJt67Q9G/pS9IjBpw7ra/EDlZ665vDFoa6CgxdoZkNtbIC//0Q6JR8
         GnG/J01CArVn9NFa6Y4T51B5SgZIlTIn+/Z+4wzKR5V9lBgDJQBOM+zw8lcWvpjlBabd
         DZRjn7EXPMYFMWYYx+jCPWW+uakPAcHhg84UrzmzlruSrJ4/SKo0D8vT151vjT95/95+
         /6MmJqDpz/zU2JLeM2yFORP/YsBCf5d247+YtJvRnphHrqFrto8lcRdErtl66lZpToVV
         ieeg==
X-Forwarded-Encrypted: i=1; AJvYcCX1kLvpfMBvVq1TCrcKOARU2Ov8nZSoG+a6xH1w0mmGgi/EpOWj+xMoG8ZRL9vpvFrT52L3aywkqkrKdXfYOBDCgkOW
X-Gm-Message-State: AOJu0YyujRLvIOiw6iaMvHOGS72tdTvOTG1t70GSz8b32lHR/kAGc7XH
	nVl0JSxRPJoFSqydelgm3ieLED0HH45HEL08cFKnx1WuvHtalUVrqcc0p+de8OIC2wQvq6IpoNA
	qzhTzVfLdyvUB9PZF5fCXd0/ViqGlAS4S1+VM
X-Google-Smtp-Source: AGHT+IHCRlJjFiV34H6eGFEE3lgXNolmOekCk6fiLh7LUhR040sGjR7vzN0sTWzI00yuNLk1UTieyf5oLyc3dDoui5M=
X-Received: by 2002:a05:6000:1:b0:368:714e:5a5e with SMTP id
 ffacd0b85a97d-368714e5c12mr324696f8f.2.1721321787111; Thu, 18 Jul 2024
 09:56:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240717222429.2011540-1-axelrasmussen@google.com> <20240717163143.49b914cb.alex.williamson@redhat.com>
In-Reply-To: <20240717163143.49b914cb.alex.williamson@redhat.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Thu, 18 Jul 2024 09:55:49 -0700
Message-ID: <CAJHvVchM52Av_4zUueN6KyK+Bzh19nVs2fH_sZPv5VVhtEQ6bw@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/3] Backport VFIO refactor to fix fork ordering bug
To: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>, 
	Eric Auger <eric.auger@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Kunwu Chan <chentao@kylinos.cn>, Leah Rumancik <leah.rumancik@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Stefan Hajnoczi <stefanha@redhat.com>, Yi Liu <yi.l.liu@intel.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2024 at 3:31=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Wed, 17 Jul 2024 15:24:26 -0700
> Axel Rasmussen <axelrasmussen@google.com> wrote:
>
> > 35e351780fa9 ("fork: defer linking file vma until vma is fully initiali=
zed")
> > switched the ordering of vm_ops->open() and copy_page_range() on fork. =
This is a
> > bug for VFIO, because it causes two problems:
> >
> > 1. Because open() is called before copy_page_range(), the range can con=
ceivably
> >    have unmapped 'holes' in it. This causes the code underneath untrack=
_pfn() to
> >    WARN.
> >
> > 2. More seriously, open() is trying to guarantee that the entire range =
is
> >    zapped, so any future accesses in the child will result in the VFIO =
fault
> >    handler being called. Because we copy_page_range() *after* open() (a=
nd
> >    therefore after zapping), this guarantee is violated.
> >
> > We can't revert 35e351780fa9, because it fixes a real bug for hugetlbfs=
. The fix
> > is also not as simple as just reodering open() and copy_page_range(), a=
s Miaohe
> > points out in [1]. So, although these patches are kind of large for sta=
ble, just
> > backport this refactoring which completely sidesteps the issue.
> >
> > Note that patch 2 is the key one here which fixes the issue. Patch 1 is=
 a
> > prerequisite required for patch 2 to build / work. This would almost be=
 enough,
> > but we might see significantly regressed performance. Patch 3 fixes tha=
t up,
> > putting performance back on par with what it was before.
> >
> > Note [1] also has a more full discussion justifying taking these backpo=
rts.
> >
> > I proposed the same backport for 6.9 [2], and now for 6.6. 6.6 is the o=
ldest
> > kernel which needs the change: 35e351780fa9 was reverted for unrelated =
reasons
> > in 6.1, and was never backported to 5.15 or earlier.
>
> AFAICT 35e351780fa9 was reverted in linux-6.6.y as well, so why isn't
> this one a 4-part series concluding with a new backport of that commit?
> I think without that, we don't need these in 6.6 either.  Thanks,

Ah! You are correct, I had failed to notice:

dd782da47 ("Revert "fork: defer linking file vma until vma is fully
initialized"")

in linux-6.6.y. So, please ignore this series for 6.6 then. :)

>
> Alex
>
> >
> > [1]: https://lore.kernel.org/all/20240702042948.2629267-1-leah.rumancik=
@gmail.com/T/
> > [2]: https://lore.kernel.org/r/20240717213339.1921530-1-axelrasmussen@g=
oogle.com
> >
> > Alex Williamson (3):
> >   vfio: Create vfio_fs_type with inode per device
> >   vfio/pci: Use unmap_mapping_range()
> >   vfio/pci: Insert full vma on mmap'd MMIO fault
> >
> >  drivers/vfio/device_cdev.c       |   7 +
> >  drivers/vfio/group.c             |   7 +
> >  drivers/vfio/pci/vfio_pci_core.c | 271 ++++++++-----------------------
> >  drivers/vfio/vfio_main.c         |  44 +++++
> >  include/linux/vfio.h             |   1 +
> >  include/linux/vfio_pci_core.h    |   2 -
> >  6 files changed, 125 insertions(+), 207 deletions(-)
> >
> > --
> > 2.45.2.993.g49e7a77208-goog
> >
>

