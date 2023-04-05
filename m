Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518456D882B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbjDEUY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDEUYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:24:53 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5564C21;
        Wed,  5 Apr 2023 13:24:51 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4e0ad2aa77fso472304e87.1;
        Wed, 05 Apr 2023 13:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680726289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7bGBU2amChf9VSLvjx9x2NsgYO154k1agCs2bfejtI=;
        b=nvtBMbWW2FPV97W8xfZ9Osx1LEiYvRQo78jbVtTnLDUBI68wEW53YmRiXoCx95HqVF
         qR3NK0fSkVHaVJHJ0PGxkA/fJVylAGIsIDCI1o8MZWHALUaKR6GbTr5r04nefDAm6lZp
         US/vGvP4+Scl4f2jwk/dO3hkXR2iBpoLYbnOGn0dDPytuY8RB0J/gGUL0PrYmMXo5gow
         o30Pc7yGwWAOQUS2e4GfG+4QIQlvW+27m0hnhYyUfkvuIwp+Yj9stH244itQHtgkEr13
         BBQzouGUuXGvzU/88sLGqpgpa/nvoOGTxFTVZcSgfURJRfv6106Aqf4XCu0ZBzYvxWbm
         QhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680726289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7bGBU2amChf9VSLvjx9x2NsgYO154k1agCs2bfejtI=;
        b=6Jy9gPZq33H3ycUCQZ+XpiAWHyelci8yKdS5dUJFmvFcHKe5eKTNbVtUlFh6lC0G9S
         dgvuxD6l17BEmGgZEacmaPSQNpb8ZohO/LbBviG6AMuKJZw7+3bqSY9Lf3EevahcHFmM
         xonFh148+dgSziAmQPHP3WCm1mRxhRYvo7Xx6+f5uhOq5s+IuQK+HbBJ5e8pOhckup0e
         L4njBx5ablnljLYkttnMWI/MPtRtHF1IX0cHKP8R7XWR+G5/4KzXDBmDZF18UZUz+T3+
         gN4qq4TCEQLOm9EZ7saj7r1cW62LUJj/5+ediFfu39T1Xh204z3PEKfMwDTMy8utkPBC
         dGug==
X-Gm-Message-State: AAQBX9eFi7rgoLlCp3fF/F7afI+m+P5jaqInplo/G4P+A4YIHD0aySvQ
        66OhKmlHe+vMMXMeS1e8kQs=
X-Google-Smtp-Source: AKy350aWWwjMz3kM8AO3ZsWhy9vCtRp+zieAq0a1+W55O0O03xHKWs0G/djXvt+fvVY7HssIuMVhjQ==
X-Received: by 2002:ac2:4462:0:b0:4eb:7fa:515 with SMTP id y2-20020ac24462000000b004eb07fa0515mr952369lfl.2.1680726289387;
        Wed, 05 Apr 2023 13:24:49 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id t26-20020ac24c1a000000b004b5480edf67sm2972361lfq.36.2023.04.05.13.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:24:49 -0700 (PDT)
Date:   Wed, 5 Apr 2023 23:24:35 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     <ankita@nvidia.com>
Cc:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <naoya.horiguchi@nec.com>, <maz@kernel.org>,
        <oliver.upton@linux.dev>, <aniketa@nvidia.com>, <cjia@nvidia.com>,
        <kwankhede@nvidia.com>, <targupta@nvidia.com>, <vsethi@nvidia.com>,
        <acurrid@nvidia.com>, <apopple@nvidia.com>, <jhubbard@nvidia.com>,
        <danw@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v3 6/6] vfio/nvgpu: register device memory for poison
 handling
Message-ID: <20230405232435.0000090a.zhi.wang.linux@gmail.com>
In-Reply-To: <20230405180134.16932-7-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
        <20230405180134.16932-7-ankita@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 11:01:34 -0700
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgpu-vfio-pci module maps QEMU VMA to device memory through
> remap_pfn_range(). The new mechanism to handle poison on memory not backed
> by struct page is leveraged here.
> 
> nvgpu-vfio-pci defines a function pfn_memory_failure() to get the ECC PFN
> from the MM. The function is registered with kernel MM along with the
> address space and PFN range through register_pfn_address_space().
> 
> Track poisoned PFN in the nvgpu-vfio-pci module as bitmap with a bit per
> PFN. The PFN is communicated by the kernel MM to the module through the
> failure function, which sets the appropriate bit in the bitmap.
> 
> Register a VMA fault ops for the module. It returns VM_FAULT_HWPOISON
> in case the bit for the PFN is set in the bitmap.
> 
> Clear bitmap on reset to reflect the clean state of the device memory
> after reset.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgpu/main.c | 116 ++++++++++++++++++++++++++++++++--
>  1 file changed, 110 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgpu/main.c b/drivers/vfio/pci/nvgpu/main.c
> index 2dd8cc6e0145..8ccd3fe33a0f 100644
> --- a/drivers/vfio/pci/nvgpu/main.c
> +++ b/drivers/vfio/pci/nvgpu/main.c
> @@ -5,6 +5,8 @@
>  
>  #include <linux/pci.h>
>  #include <linux/vfio_pci_core.h>
> +#include <linux/bitmap.h>
> +#include <linux/memory-failure.h>
>  
>  #define DUMMY_PFN \
>  	(((nvdev->mem_prop.hpa + nvdev->mem_prop.mem_length) >> PAGE_SHIFT) - 1)
> @@ -12,12 +14,78 @@
>  struct dev_mem_properties {
>  	uint64_t hpa;
>  	uint64_t mem_length;
> +	unsigned long *pfn_bitmap;
>  	int bar1_start_offset;
>  };
>  
>  struct nvgpu_vfio_pci_core_device {
>  	struct vfio_pci_core_device core_device;
>  	struct dev_mem_properties mem_prop;
> +	struct pfn_address_space pfn_address_space;
> +};
> +
> +void nvgpu_vfio_pci_pfn_memory_failure(struct pfn_address_space *pfn_space,
> +				       unsigned long pfn)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		pfn_space, struct nvgpu_vfio_pci_core_device, pfn_address_space);
> +
> +	/*
> +	 * MM has called to notify a poisoned page. Track that in the bitmap.
> +	 */
> +	__set_bit(pfn - (pfn_space->node.start), nvdev->mem_prop.pfn_bitmap);
> +}
> +
> +struct pfn_address_space_ops nvgpu_vfio_pci_pas_ops = {
> +	.failure = nvgpu_vfio_pci_pfn_memory_failure,
> +};
> +
> +static int
> +nvgpu_vfio_pci_register_pfn_range(struct nvgpu_vfio_pci_core_device *nvdev,
> +				  struct vm_area_struct *vma)
> +{
> +	unsigned long nr_pages;
> +	int ret = 0;
> +
> +	nr_pages = nvdev->mem_prop.mem_length >> PAGE_SHIFT;
> +
> +	nvdev->pfn_address_space.node.start = vma->vm_pgoff;
> +	nvdev->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
> +	nvdev->pfn_address_space.ops = &nvgpu_vfio_pci_pas_ops;
> +	nvdev->pfn_address_space.mapping = vma->vm_file->f_mapping;
> +
> +	ret = register_pfn_address_space(&(nvdev->pfn_address_space));
> +
> +	return ret;
> +}
> +
> +static vm_fault_t nvgpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	unsigned long mem_offset = vmf->pgoff - vmf->vma->vm_pgoff;
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		vmf->vma->vm_file->private_data,
> +		struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +	int ret;
> +
> +	/*
> +	 * Check if the page is poisoned.
> +	 */
> +	if (mem_offset < (nvdev->mem_prop.mem_length >> PAGE_SHIFT) &&
> +		test_bit(mem_offset, nvdev->mem_prop.pfn_bitmap))
> +		return VM_FAULT_HWPOISON;
> +
> +	ret = remap_pfn_range(vmf->vma,
> +			vmf->vma->vm_start + (mem_offset << PAGE_SHIFT),
> +			DUMMY_PFN, PAGE_SIZE,
> +			vmf->vma->vm_page_prot);
> +	if (ret)
> +		return VM_FAULT_ERROR;
> +
> +	return VM_FAULT_NOPAGE;
> +}
> +
> +static const struct vm_operations_struct nvgpu_vfio_pci_mmap_ops = {
> +	.fault = nvgpu_vfio_pci_fault,
>  };
>  
>  static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
> @@ -26,8 +94,9 @@ static int vfio_get_bar1_start_offset(struct vfio_pci_core_device *vdev)
>  
>  	pci_read_config_byte(vdev->pdev, 0x10, &val);
>  	/*
> -	 * The BAR1 start offset in the PCI config space depends on the BAR0size.
> -	 * Check if the BAR0 is 64b and return the approproiate BAR1 offset.
> +	 * The BAR1 start offset in the PCI config space depends on the BAR0
> +	 * size. Check if the BAR0 is 64b and return the approproiate BAR1
> +	 * offset.
>  	 */
>  	if (val & PCI_BASE_ADDRESS_MEM_TYPE_64)
>  		return VFIO_PCI_BAR2_REGION_INDEX;
> @@ -54,6 +123,16 @@ static int nvgpu_vfio_pci_open_device(struct vfio_device *core_vdev)
>  	return ret;
>  }
>  
> +void nvgpu_vfio_pci_close_device(struct vfio_device *core_vdev)
> +{
> +	struct nvgpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unregister_pfn_address_space(&(nvdev->pfn_address_space));
> +
> +	vfio_pci_core_close_device(core_vdev);
> +}
> +
>  int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
>  			struct vm_area_struct *vma)
>  {
> @@ -93,8 +172,11 @@ int nvgpu_vfio_pci_mmap(struct vfio_device *core_vdev,
>  		return ret;
>  
>  	vma->vm_pgoff = start_pfn + pgoff;
> +	vma->vm_ops = &nvgpu_vfio_pci_mmap_ops;
>  
> -	return 0;
> +	ret = nvgpu_vfio_pci_register_pfn_range(nvdev, vma);
> +
> +	return ret;
>  }
>  
>  long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> @@ -140,7 +222,14 @@ long nvgpu_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		}
>  
>  		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> -
> +	case VFIO_DEVICE_RESET:
> +		/*
> +		 * Resetting the GPU clears up the poisoned page. Reset the
> +		 * poisoned page bitmap.
> +		 */
> +		memset(nvdev->mem_prop.pfn_bitmap, 0,
> +		       nvdev->mem_prop.mem_length >> (PAGE_SHIFT + 3));
> +		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  	default:
>  		return vfio_pci_core_ioctl(core_vdev, cmd, arg);
>  	}
> @@ -151,7 +240,7 @@ static const struct vfio_device_ops nvgpu_vfio_pci_ops = {
>  	.init = vfio_pci_core_init_dev,
>  	.release = vfio_pci_core_release_dev,
>  	.open_device = nvgpu_vfio_pci_open_device,
> -	.close_device = vfio_pci_core_close_device,
> +	.close_device = nvgpu_vfio_pci_close_device,
>  	.ioctl = nvgpu_vfio_pci_ioctl,
>  	.read = vfio_pci_core_read,
>  	.write = vfio_pci_core_write,
> @@ -188,7 +277,20 @@ nvgpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
>  
>  	ret = device_property_read_u64(&(pdev->dev), "nvidia,gpu-mem-size",
>  				       &(nvdev->mem_prop.mem_length));
> -	return ret;
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * A bitmap is maintained to teack the pages that are poisoned. Each
                                       ^track?
> +	 * page is represented by a bit. Allocation size in bytes is
> +	 * determined by shifting the device memory size by PAGE_SHIFT to
> +	 * determine the number of pages; and further shifted by 3 as each
> +	 * byte could track 8 pages.
> +	 */
> +	nvdev->mem_prop.pfn_bitmap
> +		= vzalloc(nvdev->mem_prop.mem_length >> (PAGE_SHIFT + 3));
> +
> +	return 0;
>  }
>  
>  static int nvgpu_vfio_pci_probe(struct pci_dev *pdev,
> @@ -224,6 +326,8 @@ static void nvgpu_vfio_pci_remove(struct pci_dev *pdev)
>  	struct nvgpu_vfio_pci_core_device *nvdev = nvgpu_drvdata(pdev);
>  	struct vfio_pci_core_device *vdev = &nvdev->core_device;
>  
> +	vfree(nvdev->mem_prop.pfn_bitmap);
> +
>  	vfio_pci_core_unregister_device(vdev);
>  	vfio_put_device(&vdev->vdev);
>  }

