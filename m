Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17F4376235
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 10:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbhEGIiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 04:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233735AbhEGIiU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 04:38:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620376640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G4FGrNimJhV01IK3zZ0JL4RVVApImUVGYjkgoM4AFN0=;
        b=Y2HNdQlbgbxH2vQVugjm+WOuSYybEMSzpeo/904eTqrgVMcPHi6MKJ6MwzsUoXJxJXNBwR
        bo9eBc+7cq1ytvn0HB9Me+X3v1D5XHBjgctcsFrkHunNgQxj5/ETYrXPNoY/tJwvmrwoSk
        GdT1C5JplCQUBN16zN+JEM4+1weVP2Q=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-xIAYxamwOMyu0meP85BhHw-1; Fri, 07 May 2021 04:37:19 -0400
X-MC-Unique: xIAYxamwOMyu0meP85BhHw-1
Received: by mail-yb1-f200.google.com with SMTP id j63-20020a25d2420000b02904d9818b80e8so9148104ybg.14
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 01:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G4FGrNimJhV01IK3zZ0JL4RVVApImUVGYjkgoM4AFN0=;
        b=uIs+HnPhdjIPJp7dXofpGYX+VqhZU1TweeYyJjEf6Z+iWX3rF+uPMps2akf7RESgiQ
         8TGFNu7Q/9YmpeQQDISPWLMIRgL/0nYtACevHhQLm0lLDp0bUzcJ6cuKBGez6y8KYQYF
         vHNJXO7T9WVPGjpuSPEqEkuAwDnbm0rVmR0kNzx6VS+MNuXTt1HZsKJkWPQRfrdmbEuv
         KOozmhOdlJKYPUONpWacTFOHuKcnRFpK5IpWicVOTFHNIbGWdQxfaaCbcwD7dYDlLsgG
         6zD1AW4WAHhaQEKmUFeIAgOwf+ISbDdcYBDuFNRGr3KjQUi8guK8VkJ3OvorFEtZapdj
         qBJw==
X-Gm-Message-State: AOAM532+qMXi8qOXV5AstIq95wT5/toqWaM280cy8QfSFqLqesO9TQEe
        9lLZawr3TWEIeUzoTYAcz9HNScxY1gNKaI2+IAy4F+Go6jrgE9ebNDs0X/0zNqQC0qNnfK6pnIX
        wIGv6TTKMwb3rG5YRleU5UoreKr3a
X-Received: by 2002:a25:cccd:: with SMTP id l196mr12372288ybf.26.1620376638468;
        Fri, 07 May 2021 01:37:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxewIyOv51q5Ji9x8dEqFP2aSx4Up03TrbmnULK/VTdw16ioRy22PBDlbvyRSw6NJNCizaj7Ckva55HsAkki/w=
X-Received: by 2002:a25:cccd:: with SMTP id l196mr12372264ybf.26.1620376638189;
 Fri, 07 May 2021 01:37:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210506091859.6961-1-maxime.coquelin@redhat.com> <20210506155004.7e214d8f@redhat.com>
In-Reply-To: <20210506155004.7e214d8f@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 7 May 2021 10:37:04 +0200
Message-ID: <CAFqZXNswPM4nEoRwKjLY=zpnqXLF8SRAWWkhj1EL3CoODYB-=w@mail.gmail.com>
Subject: Re: [PATCH] vfio: Lock down no-IOMMU mode when kernel is locked down
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Maxime Coquelin <maxime.coquelin@redhat.com>,
        James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, kvm@vger.kernel.org,
        mjg59@srcf.ucam.org, Kees Cook <keescook@chromium.org>,
        Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 11:50 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Thu,  6 May 2021 11:18:59 +0200
> Maxime Coquelin <maxime.coquelin@redhat.com> wrote:
>
> > When no-IOMMU mode is enabled, VFIO is as unsafe as accessing
> > the PCI BARs via the device's sysfs, which is locked down when
> > the kernel is locked down.
> >
> > Indeed, it is possible for an attacker to craft DMA requests
> > to modify kernel's code or leak secrets stored in the kernel,
> > since the device is not isolated by an IOMMU.
> >
> > This patch introduces a new integrity lockdown reason for the
> > unsafe VFIO no-iommu mode.
>
> I'm hoping security folks will chime in here as I'm not familiar with
> the standard practices for new lockdown reasons.  The vfio no-iommu
> backend is clearly an integrity risk, which is why it's already hidden
> behind a separate Kconfig option, requires RAWIO capabilities, and
> taints the kernel if it's used, but I agree that preventing it during
> lockdown seems like a good additional step.
>
> Is it generally advised to create specific reasons, like done here, or
> should we aim to create a more generic reason related to unrestricted
> userspace DMA?
>
> I understand we don't want to re-use PCI_ACCESS because the vfio
> no-iommu backend is device agnostic, it can be used for both PCI and
> non-PCI devices.
>
> > Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> > ---
> >  drivers/vfio/vfio.c      | 13 +++++++++----
> >  include/linux/security.h |  1 +
> >  security/security.c      |  1 +
> >  3 files changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 5e631c359ef2..fe466d6ea5d8 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/rwsem.h>
> >  #include <linux/sched.h>
> > +#include <linux/security.h>
> >  #include <linux/slab.h>
> >  #include <linux/stat.h>
> >  #include <linux/string.h>
> > @@ -165,7 +166,8 @@ static void *vfio_noiommu_open(unsigned long arg)
> >  {
> >       if (arg != VFIO_NOIOMMU_IOMMU)
> >               return ERR_PTR(-EINVAL);
> > -     if (!capable(CAP_SYS_RAWIO))
> > +     if (!capable(CAP_SYS_RAWIO) ||
> > +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU))
> >               return ERR_PTR(-EPERM);
> >
> >       return NULL;
> > @@ -1280,7 +1282,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
> >       if (atomic_read(&group->container_users))
> >               return -EINVAL;
> >
> > -     if (group->noiommu && !capable(CAP_SYS_RAWIO))
> > +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> > +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
> >               return -EPERM;
> >
> >       f = fdget(container_fd);
> > @@ -1362,7 +1365,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
> >           !group->container->iommu_driver || !vfio_group_viable(group))
> >               return -EINVAL;
> >
> > -     if (group->noiommu && !capable(CAP_SYS_RAWIO))
> > +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> > +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
> >               return -EPERM;
> >
> >       device = vfio_device_get_from_name(group, buf);
> > @@ -1490,7 +1494,8 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
> >       if (!group)
> >               return -ENODEV;
> >
> > -     if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
> > +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> > +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU))) {
> >               vfio_group_put(group);
> >               return -EPERM;
> >       }
>
> In these cases where we're testing RAWIO, the idea is to raise the
> barrier of passing file descriptors to unprivileged users.  Is lockdown
> sufficiently static that we might really only need the test on open?
> The latter three cases here only make sense if the user were able to
> open a no-iommu context when lockdown is not enabled, then lockdown is
> later enabled preventing them from doing anything with that context...
> but not preventing ongoing unsafe usage that might already exist.  I
> suspect for that reason that lockdown is static and we really only need
> the test on open.  Thanks,

Note that SELinux now also implements the locked_down hook and that
implementation is not static like the Lockdown LSM's. It checks
whether the current task's SELinux domain has either integrity or
confidentiality permission granted by the policy, so for SELinux it
makes sense to have the lockdown hook called in these other places as
well.

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

