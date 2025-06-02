Return-Path: <kvm+bounces-48214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B98EACBC9B
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B02B3A4DE7
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 21:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2843122172D;
	Mon,  2 Jun 2025 21:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i7KOcwzB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CB62C3253
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 21:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748898659; cv=none; b=gevNCy9+N7G+coegYXX7AlCjDXfzV+nVWRTlKMVhg3N1jEdTsutyecZ+/hi3KGRW08z4X6bApVI2pFt7I3oGh8YoL8kzQO7ZDamQY5iuDnheWxhkXDStAlyDukustATtUmk35eIMIwyiPkaxgKPEaNFXzg8yZIsXiSzMlzsEVy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748898659; c=relaxed/simple;
	bh=RqSfEWGC0kKtz1FWlrxXGh3ZlWwHSjz6hlyKpHH+17c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=inPZYnomXLIkgaxfAvSwDTqy+JjBkZnhu5tnivEDkdpGqSQM9gPEuZcUMmFcblENHiseD0VlPyv36aXlUKAH6DxnnsaX+1cpU7V76ivqd3AKv2dDdvRekpL6mBVQ5u2RTg5IF09HPSlTSKeV6NQ1gDWwKtUjjNk7e42FJqiumgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i7KOcwzB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748898656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OzQhT/qXyjZ2tB40NxqOTXT2Lyi6oiwytVUne15HM9g=;
	b=i7KOcwzB7dVN5NLkkr8ldLQMBwsnpZY/eim/j0TCFNh7M9KiOsTesQCSVGZ7A9/DEHR5Bc
	+R6LA/LIFDT7c534JrT1C39CV5uZbKnD5hiUX0rrsd+amFm2SdIZ6UQtUPEdyZ3czC1s/U
	zu8gEciqt6W+tdSGXTUA/5HIaTsreUE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-t6JZ2jcENi6Mtzz7dDEV0Q-1; Mon, 02 Jun 2025 17:10:54 -0400
X-MC-Unique: t6JZ2jcENi6Mtzz7dDEV0Q-1
X-Mimecast-MFC-AGG-ID: t6JZ2jcENi6Mtzz7dDEV0Q_1748898654
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so29776045e9.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 14:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748898653; x=1749503453;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OzQhT/qXyjZ2tB40NxqOTXT2Lyi6oiwytVUne15HM9g=;
        b=ZIuo/Z4k/RdCQxwv+KTY+QexeMBcIvvG5SSln0pKRZ8YFDyq0TKkBg2LN2/nbMmXo+
         1h9vhg2eg9QsJfNfwDV8uJ7duIzxVTWVkA8H+td1ZfqfxEGR3dpmSxke0kNS77CXSMA1
         MfCxZDIE2OGlA2AdBURnXPDQW6NG/gThIWcTOh4mUp+iOPqgfXBBuewyc5FLYWNVpZ8p
         ne+J1Zh/EmkzvWPlBtFC6lTWbaddoflh6XagkMDpZvz62rU5G6U7qkW5o2lw9UcLx9TM
         +QU4fa9sYN4ZKTZSMnMc0ZRMzNJnfflr5Tkkm7Qwpkq6eMkLO4p6DlKW5ukz//GTqDcY
         r7VA==
X-Forwarded-Encrypted: i=1; AJvYcCWrZXyKkEE0nR2qpAU9nX6WjtRcPnOl4r0NfWdoT8KeCgbXSjrsYEA7iEbeqK/K7xRJxGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlyDxw3GfYf69hA1FXZNxeJGC3w4OBld9LYC0vyuYUNXvOhvkK
	LuV/4x3dFGcPW+5tvLHJ5iisL62LvvJcDsikjsB7o6rfuEJQ0kK6gVxlttqEB/X4IDsiw9xeetY
	iAmA/3dV6nnroUU+02uKkO8kuQPHqEfriq6imDi9YzmvvSZP+79g24w==
X-Gm-Gg: ASbGncvi5oY24Xz3F1B8h/8a2ixs+of8dnVfJdDJ3B1XM4q604xgwveJxBagly5fdOb
	T6NWIKRnkH0X4qCg3CtwEMD8fLGA87H2/SQXlC935nGQJwy9bNDjcwUafO4CO0zewTLFOuiNnKh
	UDxerJTZIBFcEULISFllIhIypvVWfL7TK3EF2pekv1C5Kwg7z8bhZ5E5bksZAiU1VxYdCt7Fpfq
	QqX/uyHGYgJNryC1WKlH8DcHqH7mDOkJ0hS4Fo9wSKL5fiWpbTRMgmLcF+XgaUITsV7yzH7s15c
	d3ofW9TGGS8heTs68tRjRSgsNITe6aaUZMH+afC7ZinN0CA1Qg7aken8Fr14OxleXwLgpU/1YFN
	UjXOqCUIQZgNzQpm7FqKxvAH/lB9chFgVRXlC7Mw=
X-Received: by 2002:a05:600c:5294:b0:43c:f513:958a with SMTP id 5b1f17b1804b1-450d883b9admr121721415e9.13.1748898653528;
        Mon, 02 Jun 2025 14:10:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn3HgJukX8eJRxBQZddzjAWn8SPEFrZCYlCmhbjON02y2UdyFHpnwRUCVi40uKvOcZ82Auhw==
X-Received: by 2002:a05:600c:5294:b0:43c:f513:958a with SMTP id 5b1f17b1804b1-450d883b9admr121721315e9.13.1748898653137;
        Mon, 02 Jun 2025 14:10:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f34:a300:1c2c:f35e:e8e5:488e? (p200300d82f34a3001c2cf35ee8e5488e.dip0.t-ipconnect.de. [2003:d8:2f34:a300:1c2c:f35e:e8e5:488e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fb00ccsm136512135e9.17.2025.06.02.14.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 14:10:52 -0700 (PDT)
Message-ID: <2278c8cb-a547-4f8d-a8fb-cce38fa3b5f2@redhat.com>
Date: Mon, 2 Jun 2025 23:10:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250530083256.105186-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.05.25 10:32, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") highlighted that subsystems like VFIO may disable RAM block
> discard. However, guest_memfd relies on discard operations for page
> conversion between private and shared memory, potentially leading to
> the stale IOMMU mapping issue when assigning hardware devices to
> confidential VMs via shared memory. To address this and allow shared
> device assignement, it is crucial to ensure the VFIO system refreshes
> its IOMMU mappings.
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
> RamBlockAttributes to implement the RamDiscardManager interface. This
> object can store the guest_memfd information such as bitmap for shared
> memory and the registered listeners for event notification. In the
> context of RamDiscardManager, shared state is analogous to populated, and
> private state is signified as discarded. To notify the conversion events,
> a new state_change() helper is exported for the users to notify the
> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
> shared mapping.
> 
> Note that the memory state is tracked at the host page size granularity,
> as the minimum conversion size can be one page per request and VFIO
> expects the DMA mapping for a specific iova to be mapped and unmapped
> with the same granularity. Confidential VMs may perform partial
> conversions, such as conversions on small regions within larger ones.
> To prevent such invalid cases and until DMA mapping cut operation
> support is available, all operations are performed with 4K granularity.
> 
> In addition, memory conversion failures cause QEMU to quit instead of
> resuming the guest or retrying the operation at present. It would be
> future work to add more error handling or rollback mechanisms once
> conversion failures are allowed. For example, in-place conversion of
> guest_memfd could retry the unmap operation during the conversion from
> shared to private. For now, keep the complex error handling out of the
> picture as it is not required.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v6:
>      - Change the object type name from RamBlockAttribute to
>        RamBlockAttributes. (David)
>      - Save the associated RAMBlock instead MemoryRegion in
>        RamBlockAttributes. (David)
>      - Squash the state_change() helper introduction in this commit as
>        well as the mixture conversion case handling. (David)
>      - Change the block_size type from int to size_t and some cleanup in
>        validation check. (Alexey)
>      - Add a tracepoint to track the state changes. (Alexey)
> 
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
> ---
>   MAINTAINERS                   |   1 +
>   include/system/ramblock.h     |  21 ++
>   system/meson.build            |   1 +
>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>   system/trace-events           |   3 +
>   5 files changed, 506 insertions(+)
>   create mode 100644 system/ram-block-attributes.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dacd6d004..8ec39aa7f8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3149,6 +3149,7 @@ F: system/memory.c
>   F: system/memory_mapping.c
>   F: system/physmem.c
>   F: system/memory-internal.h
> +F: system/ram-block-attributes.c
>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>   
>   Memory devices
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index d8a116ba99..1bab9e2dac 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -22,6 +22,10 @@
>   #include "exec/cpu-common.h"
>   #include "qemu/rcu.h"
>   #include "exec/ramlist.h"
> +#include "system/hostmem.h"
> +
> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>   
>   struct RAMBlock {
>       struct rcu_head rcu;
> @@ -91,4 +95,21 @@ struct RAMBlock {
>       ram_addr_t postcopy_length;
>   };
>   
> +struct RamBlockAttributes {
> +    Object parent;
> +
> +    RAMBlock *ram_block;
> +
> +    /* 1-setting of the bitmap represents ram is populated (shared) */
> +    unsigned bitmap_size;
> +    unsigned long *bitmap;

So, initially, all memory starts out as private, correct?

I guess this mimics what kvm_set_phys_mem() ends up doing, when it does 
the kvm_set_memory_attributes_private() call.

So there is a short period of inconsistency, between creating the 
RAMBlock and mapping it into the PA space.

It might be wroth spelling that out / documenting it somewhere.

-- 
Cheers,

David / dhildenb


