Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F37AE705
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 09:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbjIZHjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 03:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbjIZHjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 03:39:16 -0400
X-Greylist: delayed 948 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Sep 2023 00:39:09 PDT
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [IPv6:2001:41d0:203:375::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9468392;
        Tue, 26 Sep 2023 00:39:09 -0700 (PDT)
Date:   Tue, 26 Sep 2023 16:38:57 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695713947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xYp1rdqrFOjO23K/4G/Pj62TX8riTffcX69tavICJ0=;
        b=SwrFLDRgZjNBfQAQ9EQHTpsWpVLkPRMa2WxZ6nyxV9YyR7X/B0/gDt96mzvLkSYjl9MJ47
        +Kh8YVVFAd/X34brhmFR88XxJAfJad2R097TRJk9ULXn5qc+nuyUxU0hGS9ti2U62rmLKp
        8050BZUkH0pNSQ0BoNa8nO7qwtaEM4Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Naoya Horiguchi <naoya.horiguchi@linux.dev>
To:     ankita@nvidia.com
Cc:     jgg@nvidia.com, alex.williamson@redhat.com,
        akpm@linux-foundation.org, tony.luck@intel.com, bp@alien8.de,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, aniketa@nvidia.com,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        vsethi@nvidia.com, acurrid@nvidia.com, anuaggarwal@nvidia.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 4/4] vfio/nvgpu: register device memory for poison
 handling
Message-ID: <20230926073857.GB1344149@ik1-406-35019.vs.sakura.ne.jp>
References: <20230920140210.12663-1-ankita@nvidia.com>
 <20230920140210.12663-5-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230920140210.12663-5-ankita@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023 at 07:32:10PM +0530, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
> (Qemu) using remap_pfn_range() without adding the memory to the kernel.
> The device memory pages are not backed by struct page. Patches 1-3
> implements the mechanism to handle ECC/poison on memory page without
> struct page and expose a registration function. This new mechanism is
> leveraged here.
>  
> The module registers its memory region with the kernel MM for ECC handling
> using the register_pfn_address_space() registration API exposed by the
> kernel. It also defines a failure callback function pfn_memory_failure()
> to get the poisoned PFN from the MM.
>  
> The module track poisoned PFN as a bitmap with a bit per PFN. The PFN is
> communicated by the kernel MM to the module through the failure function,
> which sets the appropriate bit in the bitmap.
>  
> The module also defines a VMA fault ops for the module. It returns
> VM_FAULT_HWPOISON in case the bit for the PFN is set in the bitmap.
> 
> [1] https://lore.kernel.org/all/20230915025415.6762-1-ankita@nvidia.com/
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---

...

> @@ -406,6 +494,19 @@ nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
>  
>  	nvdev->memlength = memlength;
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +	/*
> +	 * A bitmap is maintained to track the pages that are poisoned. Each
> +	 * page is represented by a bit. Allocation size in bytes is
> +	 * determined by shifting the device memory size by PAGE_SHIFT to
> +	 * determine the number of pages; and further shifted by 3 as each
> +	 * byte could track 8 pages.
> +	 */
> +	nvdev->pfn_bitmap
> +		= vzalloc((nvdev->memlength >> PAGE_SHIFT)/BITS_PER_TYPE(char));
> +	if (!nvdev->pfn_bitmap)
> +		ret = -ENOMEM;
> +#endif
>  	return ret;
>  }
>  

I assume that memory failure is a relatively rare event (otherwise the device
is simply broken and it's better to stop using it), so the bitmap is mostly
full of zeros.
I think that the size of device memory is on the order of 100GB, then the
bitmap size is about 3.2MB, which might be not too large in modern systems,
but using other data structure with smaller memory footprint like hash table
can be more beneficial?

Thanks,
Naoya Horiguchi
