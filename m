Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C577A451F
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 10:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235516AbjIRIsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 04:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbjIRIs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 04:48:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D567E137
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 01:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695026801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ne/6wvHEM171/1YnTSavkevXbhaVIZD2o3rmnI4AXAc=;
        b=UKTzksy8AVDt14/rn6akbJ7ffdDC4vkvOBosr3+mCTaxSrcYX5klQcuL2Gxz4t1Mt/bPVX
        Ur4M2F4iPRo0a5O8f+MBtZFLUor2u44nH18efzU5iiHA/kQhUDhIZDDF9x62f/N9QLROYZ
        cJ90fUihwsauwmxctklZpegPBb4IvRE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-pwyuw9W3MPqGkCvpWcOP3g-1; Mon, 18 Sep 2023 04:46:31 -0400
X-MC-Unique: pwyuw9W3MPqGkCvpWcOP3g-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50076a3fd35so4895847e87.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 01:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695026789; x=1695631589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ne/6wvHEM171/1YnTSavkevXbhaVIZD2o3rmnI4AXAc=;
        b=Ba8hMjLUjmPhcUdWz+YmbKgFusIaE0d+cLDzJA4fryIZZHG/ZyuQLyaanEdzt1yFxb
         StreGsqgah875OiuONF6XH7TaqFF/d/8/2H34MaGhXYgb7JYKpudCESq0euQewCmets/
         6xFfQNhZmGrU+Mgdh4KeaFHM7J4qJMv2QyCdg1FqlaRrmIqJDRaYu9Yls1jT4D61w2Zg
         2e4SpunOCY7x2x97KbApFxcXON/q6I9degfoI5eBeZRRFNyAwg8ZgvrC+BgxAaVaLv15
         cTAv6HLWskkgZPXkS2WQl/3eTHLhp4jgKJJsnyB1TMRMlQUZbWd9lM3I90R3OEunRRyo
         3hNQ==
X-Gm-Message-State: AOJu0YxRU8tlRvhkrzXJ/WXGXd/WZcMM/S/4pmfYDg3blgeyAA2ZkgMJ
        dfT6LrlyUqKGb7vdriZwq58SgMoV4s5vqwyraU9DJULck09YceOxS7MFA3wliVotTcJR0kKN0RM
        Ct0yKnStJGMsIyCUssf9P5KhCsGfk
X-Received: by 2002:a05:6512:3d27:b0:503:5d8:da33 with SMTP id d39-20020a0565123d2700b0050305d8da33mr5511660lfv.20.1695026789532;
        Mon, 18 Sep 2023 01:46:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgMCrTK06HsA1jmrN2m8hmh2JeHg5MHIGzt2YqOFrbMXyCjP3e56ikeAOpp3+Aew9hlguYd0zxzDgNAWMVZ90=
X-Received: by 2002:a05:6512:3d27:b0:503:5d8:da33 with SMTP id
 d39-20020a0565123d2700b0050305d8da33mr5511649lfv.20.1695026789253; Mon, 18
 Sep 2023 01:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230912030008.3599514-1-lulu@redhat.com> <20230912030008.3599514-3-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-3-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 18 Sep 2023 16:46:18 +0800
Message-ID: <CACGkMEuOYWYYGta5VoZaURVxrBFwU+1aNwoh7RyT1woQCNHJtg@mail.gmail.com>
Subject: Re: [RFC v2 2/4] vduse: Add file operation for mmap
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, maxime.coquelin@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 12, 2023 at 11:00=E2=80=AFAM Cindy Lu <lulu@redhat.com> wrote:
>
> Add the operation for mmap, The user space APP will
> use this function to map the pages to userspace
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vdpa/vdpa_user/vduse_dev.c | 63 ++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/=
vduse_dev.c
> index 4c256fa31fc4..2c69f4004a6e 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -1388,6 +1388,67 @@ static struct vduse_dev *vduse_dev_get_from_minor(=
int minor)
>         return dev;
>  }
>
> +static vm_fault_t vduse_vm_fault(struct vm_fault *vmf)
> +{
> +       struct vduse_dev *dev =3D vmf->vma->vm_file->private_data;
> +       struct vm_area_struct *vma =3D vmf->vma;
> +       u16 index =3D vma->vm_pgoff;
> +       struct vduse_virtqueue *vq;
> +       struct vdpa_reconnect_info *info;
> +
> +       if (index =3D=3D 0) {
> +               info =3D &dev->reconnect_status;
> +       } else {
> +               vq =3D &dev->vqs[index - 1];
> +               info =3D &vq->reconnect_info;
> +       }
> +       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> +       if (remap_pfn_range(vma, vmf->address & PAGE_MASK, PFN_DOWN(info-=
>addr),
> +                           PAGE_SIZE, vma->vm_page_prot))
> +               return VM_FAULT_SIGBUS;
> +       return VM_FAULT_NOPAGE;
> +}
> +
> +static const struct vm_operations_struct vduse_vm_ops =3D {
> +       .fault =3D vduse_vm_fault,
> +};
> +
> +static int vduse_dev_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct vduse_dev *dev =3D file->private_data;
> +       struct vdpa_reconnect_info *info;
> +       unsigned long index =3D vma->vm_pgoff;
> +       struct vduse_virtqueue *vq;
> +
> +       if (vma->vm_end - vma->vm_start !=3D PAGE_SIZE)
> +               return -EINVAL;
> +       if ((vma->vm_flags & VM_SHARED) =3D=3D 0)
> +               return -EINVAL;
> +
> +       if (index > 65535)
> +               return -EINVAL;
> +
> +       if (index =3D=3D 0) {
> +               info =3D &dev->reconnect_status;
> +       } else {
> +               vq =3D &dev->vqs[index - 1];
> +               info =3D &vq->reconnect_info;
> +       }
> +
> +       if (info->index !=3D index)
> +               return -EINVAL;

Under which case could we meet this?

> +
> +       if (info->addr & (PAGE_SIZE - 1))
> +               return -EINVAL;

And this?

> +       if (vma->vm_end - vma->vm_start !=3D info->size)
> +               return -EOPNOTSUPP;
> +
> +       vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTDUMP);

Why do you use VM_IO, VM_PFNMAP and VM_DONTDUMP?

Thanks

> +       vma->vm_ops =3D &vduse_vm_ops;
> +
> +       return 0;
> +}
> +
>  static int vduse_dev_open(struct inode *inode, struct file *file)
>  {
>         int ret;
> @@ -1420,6 +1481,8 @@ static const struct file_operations vduse_dev_fops =
=3D {
>         .unlocked_ioctl =3D vduse_dev_ioctl,
>         .compat_ioctl   =3D compat_ptr_ioctl,
>         .llseek         =3D noop_llseek,
> +       .mmap           =3D vduse_dev_mmap,
> +
>  };
>
>  static struct vduse_dev *vduse_dev_create(void)
> --
> 2.34.3
>

