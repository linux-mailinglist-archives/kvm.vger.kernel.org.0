Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802FC740B24
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbjF1IWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233734AbjF1IJu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JpBHuqgFMq924SVEU5PVhg79o4Lnwc8I8AxFIOnjXWg=;
        b=fMfl6euZA067R+jIl3zAYJQ+D9q+2XCPBwIftum3T7zP02ZawvlzFEHzWWWmSKO1SCHmyj
        oHZ2ACDsNdQqk/lqli1/hHPZvL1Ksp8+BzRZwnCBiWumDlfvZrICSfAdUBNRrTRUwOQe4s
        8SHn8znRRmbQ0Ry/sD+TjIoVzVuQPdQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-EHM_cE6KNKu5VrAofFxsKQ-1; Wed, 28 Jun 2023 04:08:53 -0400
X-MC-Unique: EHM_cE6KNKu5VrAofFxsKQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b699c5f238so28643721fa.3
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 01:08:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687939732; x=1690531732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpBHuqgFMq924SVEU5PVhg79o4Lnwc8I8AxFIOnjXWg=;
        b=IWza6a32ikhme15RrwNGa07z+0e2d92poeqOhcl506DNvhfeTk4K/y6q9niMewcCKN
         u3cLfQmj20Aact65UDa8lHPBeObyMXdnrHKO6BTRMennpDOWaH3KYj13uULHkDyI9Wim
         w5vqc4Uw99CbMadldFXbilswOm/T95qh1d0OxJZEzlmys79xWURwMjQoUv87qeiReX8l
         WdnPmSt5f5w9yaubo9HNRrIYUA6tOmedyn2QaoJ/N4a6qGUiCmBhYQ3AD69WZs2FGWco
         /4nC7nCiKZbTLbQKKlm4PTsXEeZqcx3XPLYU7LqYp8zN9CTjeu2KkXU8CituA+XRGvPH
         44Ow==
X-Gm-Message-State: AC+VfDw7WU8yWCkoljIDYQGD0XhhaBeTaYS408xqmm2Xt4snodWDHdqT
        goLQltmBWaeXmr0DXBGLy+ENHACemRZI5Ik4mn9BerSVerv5Qbj6aRcnLfNAwm9KqIx5iNLq8st
        T5feV2eOCnPcQ9QSDRjVB5l+gdCch
X-Received: by 2002:a2e:6a10:0:b0:2b6:a76b:c39e with SMTP id f16-20020a2e6a10000000b002b6a76bc39emr4223201ljc.35.1687939731899;
        Wed, 28 Jun 2023 01:08:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5+2Gicsdplyts+dFUSGHhnRnz2PbkDycBiBNT+Jwcbz1g8KzKNLvTR0NgEfWGTD+ab672YFJAqtl48gc9cCKM=
X-Received: by 2002:a2e:6a10:0:b0:2b6:a76b:c39e with SMTP id
 f16-20020a2e6a10000000b002b6a76bc39emr4223191ljc.35.1687939731611; Wed, 28
 Jun 2023 01:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230628065919.54042-1-lulu@redhat.com> <20230628065919.54042-3-lulu@redhat.com>
In-Reply-To: <20230628065919.54042-3-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 28 Jun 2023 16:08:39 +0800
Message-ID: <CACGkMEuzrFP96qcFL0M=nGiQ9t57-EzOhZmB3No-8T8pMAWTxw@mail.gmail.com>
Subject: Re: [RFC 2/4] vduse: Add file operation for mmap
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 2:59=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> From: Your Name <you@example.com>
>
> Add the operation for mmap, The user space APP will
> use this function to map the pages to userspace

Please be specific in the log. E.g why and what the main goal for this mmap=
.

>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 49 ++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index f845dc46b1db..1b833bf0ae37 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1313,6 +1313,54 @@ static struct vduse_dev *vduse_dev_get_from_minor(=
int minor)
>         return dev;
>  }
>
> +
> +static vm_fault_t vduse_vm_fault(struct vm_fault *vmf)
> +{
> +       struct vduse_dev *dev =3D vmf->vma->vm_file->private_data;
> +       struct vm_area_struct *vma =3D vmf->vma;
> +       u16 index =3D vma->vm_pgoff;
> +
> +       struct vdpa_reconnect_info *info;
> +       info =3D &dev->reconnect_info[index];
> +
> +       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> +       if (remap_pfn_range(vma, vmf->address & PAGE_MASK, PFN_DOWN(info-=
>addr),
> +                           PAGE_SIZE, vma->vm_page_prot))

I'm not sure if this can work e.g do we want to use separate pages for
each virtqueue (I think the answer is yes).

> +               return VM_FAULT_SIGBUS;
> +       return VM_FAULT_NOPAGE;
> +}
> +
> +static const struct vm_operations_struct vduse_vm_ops =3D {
> +       .fault =3D vduse_vm_fault,
> +};
> +
> +static int vduse_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct vduse_dev *dev =3D file->private_data;
> +       struct vdpa_reconnect_info *info;
> +       unsigned long index =3D vma->vm_pgoff;
> +
> +       if (vma->vm_end - vma->vm_start !=3D PAGE_SIZE)
> +               return -EINVAL;
> +       if ((vma->vm_flags & VM_SHARED) =3D=3D 0)
> +               return -EINVAL;
> +
> +       if (index > 65535)
> +               return -EINVAL;
> +
> +       info =3D &dev->reconnect_info[index];
> +       if (info->addr & (PAGE_SIZE - 1))
> +               return -EINVAL;
> +       if (vma->vm_end - vma->vm_start !=3D info->size) {
> +               return -ENOTSUPP;
> +       }

How can userspace know the correct size (info->size) here?

> +
> +       vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP=
);

Why do you need VM_IO, VM_PFNMAP and VM_DONTDUMP here?

Thanks

> +       vma->vm_ops =3D &vduse_vm_ops;
> +
> +       return 0;
> +}
> +
>  static int vduse_dev_open(struct inode *inode, struct file *file)
>  {
>         int ret;
> @@ -1345,6 +1393,7 @@ static const struct file_operations vduse_dev_fops =
=3D {
>         .unlocked_ioctl =3D vduse_dev_ioctl,
>         .compat_ioctl   =3D compat_ptr_ioctl,
>         .llseek         =3D noop_llseek,
> +       .mmap           =3D vduse_mmap,
>  };
>
>  static struct vduse_dev *vduse_dev_create(void)
> --
> 2.34.3
>

