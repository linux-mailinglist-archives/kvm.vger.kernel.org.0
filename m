Return-Path: <kvm+bounces-68256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EB642D28B1B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 22:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F3466301D314
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EEB4326D76;
	Thu, 15 Jan 2026 21:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YkBMn2oU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C252529A31C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 21:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768512023; cv=pass; b=WU33OBNebZYizIxD6R8zRRPIcAMMhsom0mnj9HWD8DQX9UTWpoJ/E94I1ggPtgiyNDr/LBX3t56ph0kJU7EnStBApMi0E+aEhNw/az3BjdtODW2f/KLmlhr7pUQXJz5VD+6pcPpCz0Z9M9NU/4iqkWPbRbofTMRQZm1ncGsWz64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768512023; c=relaxed/simple;
	bh=eYRhOimyEZA67ZAsiGV5ilcKlE6hr4PbncHkBJl1NZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k45aFzL2o96mp8qDzV/WareI2gHNxulZsvXw2+CRfyKIuhyeVoPqT6wOe0LQ0NBTESdTalO2BEG6i2/8eRFFUGBHjPItEQOdSOMONyuX5iKOgiSYgAsNiXhQiagqCI8ZpN5Np3ZK6NyIri3cW4fJMcKPN7PbNBWhSgOVfs1j+1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YkBMn2oU; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee730612dso19395e9.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 13:20:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768512020; cv=none;
        d=google.com; s=arc-20240605;
        b=b2Rtx0ctZfxxFT5oCO/RIpebP7p7rspFpzYyBwaaD53fDHMObPdKHZ0qwljbQTQBoP
         sEPKiBBkbgZMu3pK3avcG9ZZPxQY4q9/lVWrVLcT2wOGHyJdXtLUr1vWpVfylN7J1bKG
         vfWv/0LGRZW+HLGBCSRMdHfEWgiU3ZCqqtmJcdzFPxBZZzvTlzskeaJe3jTSB4djFtqe
         S4G5Rg1m8umucOQnxVJJvO3F+A7cfn4qHDAFkr0bs/NcGn1me2A5TK60rETvMPmxgiIA
         Rp3wsRZ+5gUeKylm2tmaZtuRCADMSMD7SYq3eIKTfwfEez7/AGl75bGieIDhghAw7nc0
         2qng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
        fh=MxVgNEvwsE3KM7c6zs3uL3CshceKyip3tkHhbIJYkR0=;
        b=InrEE2JLgIt24At7hgehpj0a/33L9nqVxdsDXKjQRpYH1vQvx15MY7gk8pZRL3JnEb
         bT90EsGFuvRuGhVzWN9xyNNoxfutn6Ny9at71ot2jnxuFs5jWPEmQcB6MbshkgVyEDfX
         kDTenUHO9yvoNQAhqLWpj5OGJZANJTolQwe3raQnmjjzK8cfsAj3NUGmRgh5lIJj7LVL
         wlMCzCtcVGLWLCzHMPTSDu9Rw9Q8zp7wdyh0OWASALhGLA5aNG2u/+gokAt2aMwp1Uys
         6VgSmS1R+JL6xqRmT821jv1LTiYX44D31D2yBylkpHrYv+2bQFA3k4xDDDZKLuzeBK7x
         EBkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768512020; x=1769116820; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
        b=YkBMn2oUAkEL8brtNUN1HGcHpM8TGGKE2sN+qqpOIgdloOwPBJF3mYUtwjU5OJJ7Vm
         ACvAISQ7ATHfiAUCkOXo/jf3DL31nn1MULlTqemloShN73BiyF1mdchsILSEgmVJuXBA
         rLFiX8iMgH9dpVYsfwrc0HKTuPQpXy60eCWEIOeBcJFAuIdr/AhGd7euc0ZhaprD0y+9
         RNhE17ayI+qD+eNQktTC03vw1ZxLfb+1/aiAGoplfqDiLUC0ymX1zUc1k6pEpvYj7qn5
         X5CrF6qRCcE/Ln7KVnp4Qs/g5EQp0JletQZMamXKzzw2TtHHX+7y++7io3PhVMrcnsP9
         MSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768512020; x=1769116820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xRvJp5N0e4KhVjjvIK5jrU8g7ueyFapwThzALd0xDgc=;
        b=XqJIlm56H+GG9G6F4BO5AvId25SvKN+81QQM4eb3aq80+k28NI9j4HRyy3OhW1Dqxq
         9egMd6EAIDAOH7usxAB5TjACPxZdIMfFYCQw4A2tYs2Bl+J4CUrQAaaRtg/MEEb7//ax
         dW3IxEwuzEMXdOk5ItBUjwXYISfFK71Rh1t9mBVewxCiuq8VxWeaTTQAy51QARwpGkqP
         cSnJmKGovz9e6ek9N1j/SR9MpO54+JugnHuM7aB8R2+Uavzcn8U4QOV2VVZ8BJ2xIZaP
         otiPG80gGTsAi0RQyl5foIpwArZfRNJ5B6sv8h0qFVWWSJQAs9DO61qZ6pUffyFXmAnq
         +QjA==
X-Forwarded-Encrypted: i=1; AJvYcCU9abCmWdCFncd3xSHUKJiTiHIo8qlUWCn4qU57aI54A3WCUnTkum5e4g2yNA/OAFNP2c8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoBnX3e+H2Weohimdv6mpJghG8vI2au797IL9ZCOCS2AwZHYQX
	2oA6iVpIu3+9nt2psuv9beckBE2eP/1l+6zeRdvoXcKMySVTjz2ZKLzEOflGLJDtAEb1s1NNaQr
	z8/e5TQYGjEaTTUt7zqKr4r6YcxcplaxKR2Rxi3xv
X-Gm-Gg: AY/fxX6jPOyTDeQ1BlSw+n9a65YD3l8NGXPTuoZ2cCAsN4b0Am6QwjVIatZXfehYOHH
	FyXwBraSem0+LDeOvaYvzPJsV//zWabFwGMi5PMk40yiqPAX3I0ajkcLoRKEbIjWMWa0ez7AXG5
	iUXrGoaQvbqItbtHDlXkv3GYTDOaEImlr7W5YpQaIDkrxv1QcVfeVQVjP1RNKZPfJ4kXHlM44KI
	cY82lUlX4apSGUB6Cn7a0cljeFKJkh36QteVmfnOQaUmLcQbDIZ6GTden0bhwo6M4MnHBu9L1I1
	GrAsCkKhFF84I3Tem8ziKlxs
X-Received: by 2002:a05:600c:468a:b0:477:b358:d7a9 with SMTP id
 5b1f17b1804b1-480204bfffamr24575e9.17.1768512019664; Thu, 15 Jan 2026
 13:20:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115202849.2921-1-ankita@nvidia.com> <20260115202849.2921-3-ankita@nvidia.com>
In-Reply-To: <20260115202849.2921-3-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 15 Jan 2026 13:20:08 -0800
X-Gm-Features: AZwV_QhBtJQLpsGGps1RVbuG0tmlIx9i0vGhKXKUsXRR6UijAxEGWZEH6i07fe4
Message-ID: <CACw3F50xHwggyfJWoMKExGwP1-zPbc3ePsUDNjzVmuigixNG_A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vfio/nvgrace-gpu: register device memory for
 poison handling
To: ankita@nvidia.com
Cc: vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, jgg@ziepe.ca, 
	skolothumtho@nvidia.com, alex@shazbot.org, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, cjia@nvidia.com, zhiw@nvidia.com, kjaju@nvidia.com, 
	yishaih@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 12:29=E2=80=AFPM <ankita@nvidia.com> wrote:
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
>  drivers/vfio/pci/nvgrace-gpu/main.c | 113 +++++++++++++++++++++++++++-
>  1 file changed, 109 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-gpu/main.c
> index b45a24d00387..3be5d0d97aad 100644
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
> @@ -88,6 +90,80 @@ nvgrace_gpu_memregion(int index,
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
> +       return register_pfn_address_space(&region->pfn_address_space);
> +}
> +
>  static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  {
>         struct vfio_pci_core_device *vdev =3D
> @@ -114,14 +190,28 @@ static int nvgrace_gpu_open_device(struct vfio_devi=
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
> @@ -130,6 +220,11 @@ static void nvgrace_gpu_close_device(struct vfio_dev=
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
> @@ -247,6 +342,16 @@ static const struct vm_operations_struct nvgrace_gpu=
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

Thanks for fixing the nit, Ankit! In case you need it:

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

