Return-Path: <kvm+bounces-47689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FAEAC3C3D
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D041E175413
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0931E5B72;
	Mon, 26 May 2025 09:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzMk5DsF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924911D5174
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748250073; cv=none; b=GQi2WM6cahD//VRmj7xeC3Xll5tme2W1p5l1nzL/GY40pTjUye/yclJC5of0i6ufA9LvzeUec6I3Tvl3rq/pItpJlOTDPi9l6WJhdQhBf0YsFWXEtO8AS/mp4HwBhlSB5OKG0lu7aKQ1UlwZccrYBr8+5n3FDbnY0Ewqa4daVFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748250073; c=relaxed/simple;
	bh=HMmZGc63G4qf+irXZd9FYJTELCE1byN7I7N8nEqc9xw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lIv3LND1FXVy5tvnmHM8ED9ck/gNxFEFayRe80NC8vqtdhby+FDCkAfQyEbj3TBxPm4g/R4DiA52z3fDji2YtoZGmy7nrPIfCrlLFi4VuTL1dfkZQPJxuP/754eIF0vhfZiPphYtvSOwXu/wCRL+6dmIY2afC9sfXmKL88Urpjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzMk5DsF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748250070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yii69Htghru3r/FFnGqYFRLxFqTtFhBxIyFBeettNTo=;
	b=gzMk5DsFkKmHsBIbqp6dMjccHkAfOdyix+zwpPN2nVKjD3hFGGmgm/A/zR4joA+pAgO7YY
	llBI7o0t/iS8qEvsOJPlG4ZlZjOZhsvXDmEyi7U33OOj6TJ6thD+ph2R0EKLjY+DsXgs8C
	dIu8w4iMoycP99TC6+AdHgqvojS8S0U=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-vpaO3rihMTW_N9327Oa_jg-1; Mon, 26 May 2025 05:01:07 -0400
X-MC-Unique: vpaO3rihMTW_N9327Oa_jg-1
X-Mimecast-MFC-AGG-ID: vpaO3rihMTW_N9327Oa_jg_1748250066
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4c8c60c5eso1192589f8f.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748250066; x=1748854866;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Yii69Htghru3r/FFnGqYFRLxFqTtFhBxIyFBeettNTo=;
        b=L2bnd2ty3ijJCsEE45C6ydTytLXFO4SRDKibFo9GrQdy5/9MSjGcGsnDn6ejm9rSGK
         2kFA74SibRZh1E1ruiOUUwohaiWFUKnwx3QbMbC5Bt9HuCB9sfJ1zW6T4oxw5fI1gzEx
         p1gHRJRq5BDDPGm1X3DPKm4YDGb7SEbXSXROPaRs1L+RFuktlIvJqIScjPGoba/YcgE/
         kbT1T1CFA8ENbCBILWqOY2qUGfWX/yWHIEDJgms/hnhQekVcPWIAHvLV99T1kwOmjTY5
         kVnhwJlfym7GhlSGAJGI1sUSaWGl95HMWeungCcjfCjT0m5ZMtijC8vJL4ijRkc2sg/y
         TsSA==
X-Forwarded-Encrypted: i=1; AJvYcCVCptypwtDSW/XuQdvBYuRbtdXZDgOWjGKwpOiOwa9qLnXBwu3QFFrSAOoJHgNEV2iWtZU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvHWjLY7cQyf3HwofZSaq36VkyEF/BKy7GZ8JmM3+IOMtDTEhF
	NafQQzJDZm2T8lt5f8xv/xPghRLurn5o4XHeAm9lD8UlC2PFkpRg8WNbkw7v4tfozZ0RAdU5zHs
	HWOHhqZB6qo6+BnTgBZHCb3c+Bo6YVWWhQrlsvXUE7uOZKzLYFTnC1w==
X-Gm-Gg: ASbGnct2OnHfbn6QNPlTm61+XjQk3rUZXeUUvvjp1tYlMKmqj7TomNip4vaDktb5j7G
	Ow7NmxuJpO0Cs6S7SJv+63OKVxltwFJPVj+iGztT5I77NH6aXL1RC3ObGQ51z5B6zH+fClkxlSG
	Ire54G1LmisAtSnMr9DtuOa5HpG5zMrrwBYk76nGu5HKD90547VDYwWA90srj7Ojd4GCZL5Ixkl
	Gc3i82meEEaDK8/5Y8LW22ucKWY5+RgdCansft/l5/t9HZLzxoK6Q9Nm4Z9YPrKnq41d4X3UHpa
	EMgreN9FBCaSDnk5WSIuIIBvmSM5NDwz6S1HVd/SGzMwe1qRxINzaIE4x8AiA48AzIv7SnCl/HH
	2CX4Oh0saICUxWLAChzXFOigzrQOblrFE496f0Nw=
X-Received: by 2002:a5d:64c8:0:b0:3a4:dc42:a0ac with SMTP id ffacd0b85a97d-3a4dc42a384mr1119873f8f.49.1748250065842;
        Mon, 26 May 2025 02:01:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbGkjz0lu7X/7b9wLMt2GxP0SvghKFiRjg2CjK0JWY/X67CqTDOAUtK4+to4ckuOKV4tu4mQ==
X-Received: by 2002:a5d:64c8:0:b0:3a4:dc42:a0ac with SMTP id ffacd0b85a97d-3a4dc42a384mr1119818f8f.49.1748250065345;
        Mon, 26 May 2025 02:01:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4481ca9f2d9sm234163805e9.19.2025.05.26.02.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:01:04 -0700 (PDT)
Message-ID: <e2e5c4ef-6647-49b2-a044-0634abd6a74e@redhat.com>
Date: Mon, 26 May 2025 11:01:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-5-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") highlighted that subsystems like VFIO may disable RAM block
> discard. However, guest_memfd relies on discard operations for page
> conversion between private and shared memory, potentially leading to
> stale IOMMU mapping issue when assigning hardware devices to
> confidential VMs via shared memory. To address this and allow shared
> device assignement, it is crucial to ensure VFIO system refresh its
> IOMMU mappings.
> 
> RamDiscardManager is an existing interface (used by virtio-mem) to
> adjust VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other. Therefore, similar actions are required for page
> conversion events. Introduce the RamDiscardManager to guest_memfd to
> facilitate this process.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> RamDiscardManager interface. Implementing it in HostMemoryBackend is
> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
> have a memory backend while others do not. Notably, virtual BIOS
> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
> backend.
> 
> To manage RAMBlocks with guest_memfd, define a new object named
> RamBlockAttribute to implement the RamDiscardManager interface. This
> object can store the guest_memfd information such as bitmap for shared
> memory, and handles page conversion notification. In the context of
> RamDiscardManager, shared state is analogous to populated and private
> state is treated as discard. The memory state is tracked at the host
> page size granularity, as minimum memory conversion size can be one page
> per request. Additionally, VFIO expects the DMA mapping for a specific
> iova to be mapped and unmapped with the same granularity. Confidential
> VMs may perform partial conversions, such as conversions on small
> regions within larger regions. To prevent such invalid cases and until
> cut_mapping operation support is available, all operations are performed
> with 4K granularity.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Revert to use RamDiscardManager interface instead of introducing
>        new hierarchy of class to manage private/shared state, and keep
>        using the new name of RamBlockAttribute compared with the
>        MemoryAttributeManager in v3.
>      - Use *simple* version of object_define and object_declare since the
>        state_change() function is changed as an exported function instead
>        of a virtual function in later patch.
>      - Move the introduction of RamBlockAttribute field to this patch and
>        rename it to ram_shared. (Alexey)
>      - call the exit() when register/unregister failed. (Zhao)
>      - Add the ram-block-attribute.c to Memory API related part in
>        MAINTAINERS.
> 
> Changes in v4:
>      - Change the name from memory-attribute-manager to
>        ram-block-attribute.
>      - Implement the newly-introduced PrivateSharedManager instead of
>        RamDiscardManager and change related commit message.
>      - Define the new object in ramblock.h instead of adding a new file.
> 
> Changes in v3:
>      - Some rename (bitmap_size->shared_bitmap_size,
>        first_one/zero_bit->first_bit, etc.)
>      - Change shared_bitmap_size from uint32_t to unsigned
>      - Return mgr->mr->ram_block->page_size in get_block_size()
>      - Move set_ram_discard_manager() up to avoid a g_free() in failure
>        case.
>      - Add const for the memory_attribute_manager_get_block_size()
>      - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>        callback.
> 
> Changes in v2:
>      - Rename the object name to MemoryAttributeManager
>      - Rename the bitmap to shared_bitmap to make it more clear.
>      - Remove block_size field and get it from a helper. In future, we
>        can get the page_size from RAMBlock if necessary.
>      - Remove the unncessary "struct" before GuestMemfdReplayData
>      - Remove the unncessary g_free() for the bitmap
>      - Add some error report when the callback failure for
>        populated/discarded section.
>      - Move the realize()/unrealize() definition to this patch.
> ---
>   MAINTAINERS                  |   1 +
>   include/system/ramblock.h    |  20 +++
>   system/meson.build           |   1 +
>   system/ram-block-attribute.c | 311 +++++++++++++++++++++++++++++++++++
>   4 files changed, 333 insertions(+)
>   create mode 100644 system/ram-block-attribute.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dacd6d004..3b4947dc74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3149,6 +3149,7 @@ F: system/memory.c
>   F: system/memory_mapping.c
>   F: system/physmem.c
>   F: system/memory-internal.h
> +F: system/ram-block-attribute.c
>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>   
>   Memory devices
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index d8a116ba99..09255e8495 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -22,6 +22,10 @@
>   #include "exec/cpu-common.h"
>   #include "qemu/rcu.h"
>   #include "exec/ramlist.h"
> +#include "system/hostmem.h"
> +
> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttribute, RAM_BLOCK_ATTRIBUTE)
>   
>   struct RAMBlock {
>       struct rcu_head rcu;
> @@ -42,6 +46,8 @@ struct RAMBlock {
>       int fd;
>       uint64_t fd_offset;
>       int guest_memfd;
> +    /* 1-setting of the bitmap in ram_shared represents ram is shared */

That comment looks misplaced, and the variable misnamed.

The commet should go into RamBlockAttribute and the variable should 
likely be named "attributes".

Also, "ram_shared" is not used at all in this patch, it should be moved 
into the corresponding patch.

> +    RamBlockAttribute *ram_shared;
>       size_t page_size;
>       /* dirty bitmap used during migration */
>       unsigned long *bmap;
> @@ -91,4 +97,18 @@ struct RAMBlock {
>       ram_addr_t postcopy_length;
>   };
>   
> +struct RamBlockAttribute {

Should this actually be "RamBlockAttributes" ?

> +    Object parent;
> +
> +    MemoryRegion *mr;


Should we link to the parent RAMBlock instead, and lookup the MR from there?


-- 
Cheers,

David / dhildenb


