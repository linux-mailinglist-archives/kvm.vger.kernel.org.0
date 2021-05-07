Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E5737652E
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 14:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236861AbhEGMcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 08:32:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236687AbhEGMco (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 08:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620390704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8ZWnxuhYP/znADIXvr0zXi06seVsXloJf8ocVnr0GQY=;
        b=CVapc7onWuETDJ3V8XStNgeb8o1gY8rwdScLIXFzbOKcoB0W7sj+uV883+aSnHg0n2clRY
        M+pXQiouT8ZTWF/kgsB9TS2hMmRA3MeY3jTrx/gFW9Wnh6XEgpuYrzA0zacjz7PsN6QKbw
        OYn/Ur8wfBvqPPRNvY7KelKig6hLF/A=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-H3jZZecQNJKDzQoUaMHvcg-1; Fri, 07 May 2021 08:31:43 -0400
X-MC-Unique: H3jZZecQNJKDzQoUaMHvcg-1
Received: by mail-yb1-f200.google.com with SMTP id o186-20020a2528c30000b02904f824478356so9798978ybo.4
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 05:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZWnxuhYP/znADIXvr0zXi06seVsXloJf8ocVnr0GQY=;
        b=iCvVIdoEhSn4Jk1JbPK0MnbtyNNC8I+U/ShOOpPiwZmM3QLA+LKBi9QWcVeITiyBBU
         iY582uJxCpa/rRHkDat8KU92suqeGJi5q6sSEsa+ItmOUrBoX1n4uCNwedPdgYh3jnQW
         5igrvVTFw26uC6995YQhn9MTRWzlx+30BRXxpklE0KLV9NaxljhVO+hPxoVm7BvfhQa4
         nQUPvFbovMiAp3M0IvuYpiQPI3mvX/atimymEm55bUofr7tOuQCwsv8fcAe6Ld/uJ34e
         Aih3TV6cx54QsQmv+wA4Riu+kdVZPvX5AaFEhswJsbQZFg1xmHCdyCFdgs+PKbhxMlma
         dYVw==
X-Gm-Message-State: AOAM533CrJhrK32NyXl4GTMlE1Bwq7qsq26rvDFqDB4pIo1OY2py58J+
        gn+B4V3pPbGAT7m/eln5cNkll1vDEEnJsi6hG8gpopQrU7edL669zOhHsLQfduWqvUM6gxWDANs
        QIn43ksTJCEHBH4sTnrZMpqN/wQqM
X-Received: by 2002:a25:6886:: with SMTP id d128mr13040341ybc.227.1620390702161;
        Fri, 07 May 2021 05:31:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgn4lRmwCmgddYwQNaNYZ2/6Vqav0rPUA4Ui4HFMkUNwr3mrG/13QWjAo8m5vsDj7kbtEXN6LAeyuL1i2iASc=
X-Received: by 2002:a25:6886:: with SMTP id d128mr13040312ybc.227.1620390701899;
 Fri, 07 May 2021 05:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210506091859.6961-1-maxime.coquelin@redhat.com>
 <20210506155004.7e214d8f@redhat.com> <CAFqZXNswPM4nEoRwKjLY=zpnqXLF8SRAWWkhj1EL3CoODYB-=w@mail.gmail.com>
 <ee4b4bdb-79c1-b91c-2181-2e849cc77ef3@redhat.com>
In-Reply-To: <ee4b4bdb-79c1-b91c-2181-2e849cc77ef3@redhat.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 7 May 2021 14:31:28 +0200
Message-ID: <CAFqZXNsDGS-MOqkg1xc47D2RwSmOiekY4Thz84ZM=rJUJCXTBA@mail.gmail.com>
Subject: Re: [PATCH] vfio: Lock down no-IOMMU mode when kernel is locked down
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        James Morris <jmorris@namei.org>,
        David Howells <dhowells@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>, kvm@vger.kernel.org,
        mjg59@srcf.ucam.org, Kees Cook <keescook@chromium.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(Adding the SELinux list, Paul, and Stephen to Cc)

On Fri, May 7, 2021 at 11:11 AM Maxime Coquelin
<maxime.coquelin@redhat.com> wrote:
> On 5/7/21 10:37 AM, Ondrej Mosnacek wrote:
> > On Thu, May 6, 2021 at 11:50 PM Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> >> On Thu,  6 May 2021 11:18:59 +0200
> >> Maxime Coquelin <maxime.coquelin@redhat.com> wrote:
> >>
> >>> When no-IOMMU mode is enabled, VFIO is as unsafe as accessing
> >>> the PCI BARs via the device's sysfs, which is locked down when
> >>> the kernel is locked down.
> >>>
> >>> Indeed, it is possible for an attacker to craft DMA requests
> >>> to modify kernel's code or leak secrets stored in the kernel,
> >>> since the device is not isolated by an IOMMU.
> >>>
> >>> This patch introduces a new integrity lockdown reason for the
> >>> unsafe VFIO no-iommu mode.
> >>
> >> I'm hoping security folks will chime in here as I'm not familiar with
> >> the standard practices for new lockdown reasons.  The vfio no-iommu
> >> backend is clearly an integrity risk, which is why it's already hidden
> >> behind a separate Kconfig option, requires RAWIO capabilities, and
> >> taints the kernel if it's used, but I agree that preventing it during
> >> lockdown seems like a good additional step.
> >>
> >> Is it generally advised to create specific reasons, like done here, or
> >> should we aim to create a more generic reason related to unrestricted
> >> userspace DMA?
>
> I am fine with a more generic reason. I'm also not sure what is the best
> thing to do in term of granularity.
>
> >> I understand we don't want to re-use PCI_ACCESS because the vfio
> >> no-iommu backend is device agnostic, it can be used for both PCI and
> >> non-PCI devices.
>
> Right, that's why I created a new reason.
>
> >>> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
> >>> ---
> >>>  drivers/vfio/vfio.c      | 13 +++++++++----
> >>>  include/linux/security.h |  1 +
> >>>  security/security.c      |  1 +
> >>>  3 files changed, 11 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >>> index 5e631c359ef2..fe466d6ea5d8 100644
> >>> --- a/drivers/vfio/vfio.c
> >>> +++ b/drivers/vfio/vfio.c
> >>> @@ -25,6 +25,7 @@
> >>>  #include <linux/pci.h>
> >>>  #include <linux/rwsem.h>
> >>>  #include <linux/sched.h>
> >>> +#include <linux/security.h>
> >>>  #include <linux/slab.h>
> >>>  #include <linux/stat.h>
> >>>  #include <linux/string.h>
> >>> @@ -165,7 +166,8 @@ static void *vfio_noiommu_open(unsigned long arg)
> >>>  {
> >>>       if (arg != VFIO_NOIOMMU_IOMMU)
> >>>               return ERR_PTR(-EINVAL);
> >>> -     if (!capable(CAP_SYS_RAWIO))
> >>> +     if (!capable(CAP_SYS_RAWIO) ||
> >>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU))
> >>>               return ERR_PTR(-EPERM);
> >>>
> >>>       return NULL;
> >>> @@ -1280,7 +1282,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
> >>>       if (atomic_read(&group->container_users))
> >>>               return -EINVAL;
> >>>
> >>> -     if (group->noiommu && !capable(CAP_SYS_RAWIO))
> >>> +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> >>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
> >>>               return -EPERM;
> >>>
> >>>       f = fdget(container_fd);
> >>> @@ -1362,7 +1365,8 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
> >>>           !group->container->iommu_driver || !vfio_group_viable(group))
> >>>               return -EINVAL;
> >>>
> >>> -     if (group->noiommu && !capable(CAP_SYS_RAWIO))
> >>> +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> >>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU)))
> >>>               return -EPERM;
> >>>
> >>>       device = vfio_device_get_from_name(group, buf);
> >>> @@ -1490,7 +1494,8 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
> >>>       if (!group)
> >>>               return -ENODEV;
> >>>
> >>> -     if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
> >>> +     if (group->noiommu && (!capable(CAP_SYS_RAWIO) ||
> >>> +                     security_locked_down(LOCKDOWN_VFIO_NOIOMMU))) {
> >>>               vfio_group_put(group);
> >>>               return -EPERM;
> >>>       }
> >>
> >> In these cases where we're testing RAWIO, the idea is to raise the
> >> barrier of passing file descriptors to unprivileged users.  Is lockdown
> >> sufficiently static that we might really only need the test on open?
> >> The latter three cases here only make sense if the user were able to
> >> open a no-iommu context when lockdown is not enabled, then lockdown is
> >> later enabled preventing them from doing anything with that context...
> >> but not preventing ongoing unsafe usage that might already exist.  I
> >> suspect for that reason that lockdown is static and we really only need
> >> the test on open.  Thanks,
> >
> > Note that SELinux now also implements the locked_down hook and that
> > implementation is not static like the Lockdown LSM's. It checks
> > whether the current task's SELinux domain has either integrity or
> > confidentiality permission granted by the policy, so for SELinux it
> > makes sense to have the lockdown hook called in these other places as
> > well.
> >
>
> Thanks Ondrej for the insights, is there any plan for selinux to support
> finer granularity than integrity and confidentiality? I'm not sure it
> makes sense, but it might help to understand if we should choose between
> a "VFIO no-iommu mode" reason and a more generic userspace DMA one.

Looking at the ML discussion under the original patch posting [1],
having a finer granularity was preferred, but there was a concern that
the list of reasons would change too much, making the kernel <->
policy interface too unstable. Looking at the git log, the list of
lockdown reasons hasn't changed much since the original SELinux
implementation was added (there was just one addition, not counting
this patch), so it looks like switching SELinux to finer granularity
would be viable now.

I'm not sure whether the less or more generic variant would be better
here... Perhaps Stephen or Paul will have an opinion.

[1] https://lore.kernel.org/selinux/365ca063-6efd-8051-8d4b-5c8aef0d2e12@tycho.nsa.gov/T/

--
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

