Return-Path: <kvm+bounces-67423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DF0D04B67
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3DAEE3067D67
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3695C296BA5;
	Thu,  8 Jan 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X6CTESnE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3D928D8DA
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891639; cv=pass; b=e1L4OS9fGuBoOQ0NeRZbkBtfniKwz2fBtsXok0k2FCuoKA8ZwvIc2P2gXi6kU+FiX+aETtbAbbhNDjbEDRgUzrkayPKXF4kisEf3AMbmRa7QjL76pO09VoQWrcm6bfBcMlvhP7ouIsQnsA2m2/cDCBUixrU91Yho+D5K5SxVrGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891639; c=relaxed/simple;
	bh=u83SlZZNZvCy2zikP7LnUWuUj1FBTUjOvlcDa3WriKg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BArhzXjFLNw2ooIGcArDcnEebqm6LZKO78TJ6x3wJOFMDtpwJxnk4ux2egfc4xie6JguWTlmFlkSJuW/pdUizIdYvbUrjj8dRw1KtjZFRCUPE9xGbxOwUCVccNgDnVBkd7enD2zNW2VlNqxXTIuzzfz5DT1ZMMIAvnJH2SsuMh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X6CTESnE; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so161875e9.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 09:00:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767891636; cv=none;
        d=google.com; s=arc-20240605;
        b=RgXBwtilmhW6SiJ3MYZBVrOnEBWzqtgFWqPFBl7sy86NGlhdeaFgBWbW4qgf6bLtW2
         HvbOE1EMk8s8tTfgirE7Anl5ErOah2j5nwifyf6T+77OxlqVJmSDbWcsKEU0TIlPuJEL
         DWyt3CEZ8Tde7ePYFRw/xWztpi6VzEsk2YEnZCSojCX/SvS2/yYFyA9363Z/FhXF71+a
         lbzb+5jBcxAVnbHQ0EoCyaq1AaRsab5Y4ZLGGnQYittUYUm4S6o1USbV93ZoTwhK9zRZ
         G3yWVClrk3abE0hj+++wQzIwXwC99rnNHCHoiDLKK+CrA/yx8hquoNcZ0qDyBceZGYXd
         03Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
        fh=SKFy1fuWl+n+95ezY9GuLv4b+TCF8Wu1t2ugGFx1tU0=;
        b=H/ma7P85zmLoTY2aXy2I+LXhU93Ixe0SqhKRx33j5+RW4tDV2GRgiGdShkTtEZJmEG
         LhKrtRwBOnOtqFmtLzTrJxCCobCWKSCksuYmNCfyh8EGmMrdVylrHtIyvDWPt1oVUhM6
         LUlraSPPAjiNGZ3ZKrMMIdgs8/lFI1VBF3Nnm/9wjehk8vhrxKnpHlb4qCLpMb2l/0Ft
         c5qhOZwuE1hK6pkFuMn0JrTa8rOHMHfGIr6oRCUTg2etSzEMy+cV9WASfi2RRa2PtUIH
         lP0XdpDz3EWGGCu47VTb24R1wpEu1lFt3BQ+pmKCJecv1E8LMB5dUYFUrNrNxA5OdeNY
         fXXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767891636; x=1768496436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
        b=X6CTESnEvS1UqgCt005Z8M6rvXUx24wCU23U4fIbBIlKSHhS2Pb+TO3gGKvbHTb2vH
         paUCGMfvbprO9xfmPGEE2/REwyO9Xssv1YwtxESF7NezIAXHi4YivyWqmMsUdoe/V+gf
         fZfLbof8QX6lVK0zXPAXq50N5WWj44XQEew4vd/KaVzEfL2U6jCj389LnFewttdInrza
         UXYxeI142fDfSi3eSEsCWFLK6KIqE7zW3phO6++JhItSCtyuOjusXpaLSdAQhvheWdho
         xCwsp5Bq7+uCkVr8J70jTahVHUrW4isQrNwEQEEouC05JRe5zMJqWCQ/3VJhYS/k9h39
         rtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767891636; x=1768496436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MqePBLtbIicL/DWj2eUilSA1KB5F3elpw15Vvzk8jeM=;
        b=CHd4gY6xLD7dACA16Q9ZYXM68DT3F/RpnzxNjFSWHUyhjqBdDwPRNg21TEFKwLIOmN
         rrhkWp4+w8bDN6986dwpoQVJUmw5SFqsuAg2ONCejC0/IG/Zmxzy34A/aDnu4OTT6xQH
         6ms8MCZfaLH01Pra7PMYRywZ+vV/HtsogCR5/iXJ4UfYC+tJOt3SZeGoFj3ItE1OOBGD
         WEQx31HJPOkRoVO6rK9UzNp+3ud/s9QMSuDG89nclihn39QCmUlB+l9l46ZLPUgYmuJK
         vSGGk5l8HlO2Ut1D4RMJCdr7RPikIRWwW7lvdyr646lM3mhyYUBBxOI7KcHVvVDADD92
         W2Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXDcgyPxCQTLkUmwU2b1VvylcG5UlUYnZMyHEnFi85/mLdvwt44cMKk9W+89o+7aspUMnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFnW7WROBU3XvlFp83o/Fk892fyh9jwqILV0Eujn9/RUJ507qU
	K6mdbfmv89uuIeoFt1gYfR/1kUV9TfadjT5P2w+5SGeDAYWL6+KiSuxhmK7z/Bh41DcF9A2CqMz
	KXGq7zj4dJpobyyzpCtf/pl72Yz0HCsexnt9sXCq/
X-Gm-Gg: AY/fxX4lcWEJzRvfcBVM6x9Xxkzt5xxSr06wDZkNoBalClG2pHWSCTA13iGLY3DFc99
	/Dtfte+XohRZ7FyixDmsZNziG7w71+9hyuMwtwIif+0kkrd8le9MLfYXsZ3KQrH1AVXd3WLigcY
	V6Nvkcdpd++lFdr4PC2XDbDTWhR9wBn2pRR7thaNZjiRVBC+46+OTbTjkOjz7tsW2PFSdPJG/ul
	1ZHOghjHmK+ha/F90EmRK3hvlpe+PNlsI0516BbyGgeN0VmNJHqgzDwTcfOBbPaJKjmYK7hln+q
	aZWut4xz56pJKjPELku9iiaOQIRf
X-Received: by 2002:a05:600c:c04f:b0:47b:e29f:c63f with SMTP id
 5b1f17b1804b1-47d8ac29207mr513175e9.11.1767891631095; Thu, 08 Jan 2026
 09:00:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260108153548.7386-1-ankita@nvidia.com> <20260108153548.7386-3-ankita@nvidia.com>
In-Reply-To: <20260108153548.7386-3-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 8 Jan 2026 09:00:19 -0800
X-Gm-Features: AQt7F2pWPhT0eCqMnR2VcSZQSmqDj9xv_IbsaURHMRa3NGydFYcQ5GkWfgoWDic
Message-ID: <CACw3F52rHjxv8gWzz6_YdR038CiA1=JxUD6YuW4As=rQ2oMdag@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] vfio/nvgrace-gpu: register device memory for
 poison handling
To: ankita@nvidia.com
Cc: vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, jgg@ziepe.ca, 
	skolothumtho@nvidia.com, alex@shazbot.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, cjia@nvidia.com, zhiw@nvidia.com, kjaju@nvidia.com, 
	yishaih@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 7:36=E2=80=AFAM <ankita@nvidia.com> wrote:
>
> From: Ankit Agrawal <ankita@nvidia.com>
>
> The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
> without adding the memory to the kernel. The device memory pages are PFNM=
AP
> and not backed by struct page. The module can thus utilize the MM's PFNMA=
P
> memory_failure mechanism that handles ECC/poison on regions with no struc=
t
> pages.
>
> The kernel MM code exposes register/unregister APIs allowing modules to
> register the device memory for memory_failure handling. Make nvgrace-gpu
> register the GPU memory with the MM on open.
>
> The module registers its memory region, the address_space with the
> kernel MM for ECC handling and implements a callback function to convert
> the PFN to the file page offset. The callback functions checks if the
> PFN belongs to the device memory region and is also contained in the
> VMA range, an error is returned otherwise.
>
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.co=
m/ [1]
>
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
>  1 file changed, 112 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-gpu/main.c
> index b45a24d00387..d3e5fee29180 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -9,6 +9,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/pci-p2pdma.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/memory-failure.h>
>
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -49,6 +50,7 @@ struct mem_region {
>                 void *memaddr;
>                 void __iomem *ioaddr;
>         };                      /* Base virtual address of the region */
> +       struct pfn_address_space pfn_address_space;
>  };
>
>  struct nvgrace_gpu_pci_core_device {
> @@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
>         return NULL;
>  }
>
> +static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvde=
v,
> +                               unsigned int index,
> +                               unsigned long pfn,
> +                               pgoff_t *pfn_offset_in_region)
> +{
> +       struct mem_region *region;
> +       unsigned long start_pfn, num_pages;
> +
> +       region =3D nvgrace_gpu_memregion(index, nvdev);
> +       if (!region)
> +               return -EINVAL;
> +
> +       start_pfn =3D PHYS_PFN(region->memphys);
> +       num_pages =3D region->memlength >> PAGE_SHIFT;
> +
> +       if (pfn < start_pfn || pfn >=3D start_pfn + num_pages)
> +               return -EFAULT;
> +
> +       *pfn_offset_in_region =3D pfn - start_pfn;
> +
> +       return 0;
> +}
> +
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *=
vma);

Any reason not to define vma_to_nvdev() here directly, but later?

> +
> +static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +                                       unsigned long pfn,
> +                                       pgoff_t *pgoff)
> +{
> +       struct nvgrace_gpu_pci_core_device *nvdev;
> +       unsigned int index =3D
> +               vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +       pgoff_t vma_offset_in_region =3D vma->vm_pgoff &
> +               ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +       pgoff_t pfn_offset_in_region;
> +       int ret;
> +
> +       nvdev =3D vma_to_nvdev(vma);
> +       if (!nvdev)
> +               return -ENOENT;
> +
> +       ret =3D pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_re=
gion);
> +       if (ret)
> +               return ret;
> +
> +       /* Ensure PFN is not before VMA's start within the region */
> +       if (pfn_offset_in_region < vma_offset_in_region)
> +               return -EFAULT;
> +
> +       /* Calculate offset from VMA start */
> +       *pgoff =3D vma->vm_pgoff +
> +                (pfn_offset_in_region - vma_offset_in_region);
> +
> +       return 0;
> +}
> +
> +static int
> +nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
> +                                       struct mem_region *region)
> +{
> +       int ret;
> +       unsigned long pfn, nr_pages;
> +
> +       pfn =3D PHYS_PFN(region->memphys);
> +       nr_pages =3D region->memlength >> PAGE_SHIFT;
> +
> +       region->pfn_address_space.node.start =3D pfn;
> +       region->pfn_address_space.node.last =3D pfn + nr_pages - 1;
> +       region->pfn_address_space.mapping =3D core_vdev->inode->i_mapping=
;
> +       region->pfn_address_space.pfn_to_vma_pgoff =3D nvgrace_gpu_pfn_to=
_vma_pgoff;
> +
> +       ret =3D register_pfn_address_space(&region->pfn_address_space);
> +
> +       return ret;

nit: I believe "ret" is unnecessary here.


> +}
> +
>  static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  {
>         struct vfio_pci_core_device *vdev =3D
> @@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_devi=
ce *core_vdev)
>          * memory mapping.
>          */
>         ret =3D vfio_pci_core_setup_barmap(vdev, 0);
> -       if (ret) {
> -               vfio_pci_core_disable(vdev);
> -               return ret;
> +       if (ret)
> +               goto error_exit;
> +
> +       if (nvdev->resmem.memlength) {
> +               ret =3D nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev=
, &nvdev->resmem);
> +               if (ret && ret !=3D -EOPNOTSUPP)
> +                       goto error_exit;
>         }
>
> -       vfio_pci_core_finish_enable(vdev);
> +       ret =3D nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev=
->usemem);
> +       if (ret && ret !=3D -EOPNOTSUPP)
> +               goto register_mem_failed;
>
> +       vfio_pci_core_finish_enable(vdev);
>         return 0;
> +
> +register_mem_failed:
> +       if (nvdev->resmem.memlength)
> +               unregister_pfn_address_space(&nvdev->resmem.pfn_address_s=
pace);
> +error_exit:
> +       vfio_pci_core_disable(vdev);
> +       return ret;
>  }
>
>  static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> @@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_dev=
ice *core_vdev)
>                 container_of(core_vdev, struct nvgrace_gpu_pci_core_devic=
e,
>                              core_device.vdev);
>
> +       if (nvdev->resmem.memlength)
> +               unregister_pfn_address_space(&nvdev->resmem.pfn_address_s=
pace);
> +
> +       unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
> +
>         /* Unmap the mapping to the device memory cached region */
>         if (nvdev->usemem.memaddr) {
>                 memunmap(nvdev->usemem.memaddr);
> @@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu=
_vfio_pci_mmap_ops =3D {
>  #endif
>  };
>
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *=
vma)
> +{
> +       /* Check if this VMA belongs to us */
> +       if (vma->vm_ops !=3D &nvgrace_gpu_vfio_pci_mmap_ops)
> +               return NULL;
> +
> +       return vma->vm_private_data;
> +}
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>                             struct vm_area_struct *vma)
>  {
> --
> 2.34.1
>
>

