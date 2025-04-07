Return-Path: <kvm+bounces-42833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48607A7DA4B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 11:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF858166F91
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112F522FE0F;
	Mon,  7 Apr 2025 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxAp8AZF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624EE4C91
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744019617; cv=none; b=FcqZtjWIgHnT02OPTFItLG+bS9I6QXxC/rxgVlLOzmSaP7/OQBgaspRA/B5ytmCCqwfaYcpiMcpqtXx0z8++45FJeBkeuL6ZSmih0OsrdbRGRc1aCar8y09KTF0/P+RbRfhWexWNf8UrIKIORgjJg3XmHxculpXaiw5ndAxvF+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744019617; c=relaxed/simple;
	bh=i6HOEx6U+t3hakZilL8BScgITf9Mg6mkL5kKw04Mkq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U4VTB3KWCgBuCWCZtcWWj6n3njzZn3thYWNfT+cdHxvhYWrCC9/Ng+4Zbw1e4QrBQ/x+usL4+aGGClTXdQLQtBgXrGpKOUnP8Ftx6ojO8I0yFZ0NjdiHc1LMa70Bz+eMdDDfJ6l+ySrjqqSoaLckxgu4+YiXCDDyae1SS0l6c6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxAp8AZF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744019615; x=1775555615;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i6HOEx6U+t3hakZilL8BScgITf9Mg6mkL5kKw04Mkq0=;
  b=NxAp8AZFHCnnmYwZkYtR2T7WAv5r4MZlnvLFttTFcVtcp8WO0/Sy7P1L
   l+Rfj471NYE1bCbfyryoI78jbReDS8v6XzwuW6anSlKXxzAu1GiJuHvU/
   4qiDAlWDSn+Ax+ftmJ8MM2rricdJkzG2h+UQV/0LCqM1MsMOWyUKaBNUr
   ZXIRpd/ZrKa/AtX+PLS3XTlbukRleMZ+QMIryYxSNVonwtsc+ipfq7PM8
   99LKHWrOWbX6me+SD1cLha5QpCDuqut5RhEuqo/Ij+8QA4dq8M+VJIjgr
   lBXH0DTO62kSPLOf9IEvg/u4HliCPBwHKPkflgWgHdiDYptTZp69TLltg
   g==;
X-CSE-ConnectionGUID: n4cLgS7pSeGY6sbg6r3sKA==
X-CSE-MsgGUID: ll6SfuQ2R7emyM9Hamre/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11396"; a="70768122"
X-IronPort-AV: E=Sophos;i="6.15,194,1739865600"; 
   d="scan'208";a="70768122"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 02:53:34 -0700
X-CSE-ConnectionGUID: f4meV5P6TWCKozmqFV6YdA==
X-CSE-MsgGUID: oaKcKQR6RsiwDi/RB1BHGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,194,1739865600"; 
   d="scan'208";a="127908583"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 02:53:30 -0700
Message-ID: <81a45a5e-f0a6-4f82-867d-57d5bda3c73d@intel.com>
Date: Mon, 7 Apr 2025 17:53:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/13] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-3-chenyi.qiang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250407074939.18657-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
> Modify memory_region_set_ram_discard_manager() to return false if a
> RamDiscardManager is already set in the MemoryRegion. 

It doesn't return false, but -EBUSY.

> The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> a MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - No change.
> 
> Changes in v3:
>      - Move set_ram_discard_manager() up to avoid a g_free()
>      - Clean up set_ram_discard_manager() definition
> 
> Changes in v2:
>      - newly added.
> ---
>   hw/virtio/virtio-mem.c | 29 ++++++++++++++++-------------
>   include/exec/memory.h  |  6 +++---
>   system/memory.c        | 10 +++++++---
>   3 files changed, 26 insertions(+), 19 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 21f16e4912..d0d3a0240f 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1049,6 +1049,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> +    /*
> +     * Set ourselves as RamDiscardManager before the plug handler maps the
> +     * memory region and exposes it via an address space.
> +     */
> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> +                                              RAM_DISCARD_MANAGER(vmem))) {
> +        error_setg(errp, "Failed to set RamDiscardManager");
> +        ram_block_coordinated_discard_require(false);
> +        return;
> +    }
> +
>       /*
>        * We don't know at this point whether shared RAM is migrated using
>        * QEMU or migrated using the file content. "x-ignore-shared" will be
> @@ -1124,13 +1135,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>       vmem->system_reset->vmem = vmem;
>       qemu_register_resettable(obj);
> -
> -    /*
> -     * Set ourselves as RamDiscardManager before the plug handler maps the
> -     * memory region and exposes it via an address space.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> -                                          RAM_DISCARD_MANAGER(vmem));
>   }
>   
>   static void virtio_mem_device_unrealize(DeviceState *dev)
> @@ -1138,12 +1142,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>   
> -    /*
> -     * The unplug handler unmapped the memory region, it cannot be
> -     * found via an address space anymore. Unset ourselves.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
> -
>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>       object_unref(OBJECT(vmem->system_reset));
>   
> @@ -1156,6 +1154,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       virtio_del_queue(vdev, 0);
>       virtio_cleanup(vdev);
>       g_free(vmem->bitmap);
> +    /*
> +     * The unplug handler unmapped the memory region, it cannot be
> +     * found via an address space anymore. Unset ourselves.
> +     */
> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>       ram_block_coordinated_discard_require(false);
>   }
>   
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 3bebc43d59..390477b588 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -2487,13 +2487,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>    *
>    * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
>    * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned.
> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>    *
>    * @mr: the #MemoryRegion
>    * @rdm: #RamDiscardManager to set
>    */
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm);
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a
> diff --git a/system/memory.c b/system/memory.c
> index b17b5538ff..62d6b410f0 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2115,12 +2115,16 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>       return mr->rdm;
>   }
>   
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm)
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm)
>   {
>       g_assert(memory_region_is_ram(mr));
> -    g_assert(!rdm || !mr->rdm);
> +    if (mr->rdm && rdm) {
> +        return -EBUSY;
> +    }
> +
>       mr->rdm = rdm;
> +    return 0;
>   }
>   
>   uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,


