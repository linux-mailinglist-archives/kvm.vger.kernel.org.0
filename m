Return-Path: <kvm+bounces-47691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CAD5AC3C59
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A4787A4D45
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 728001E834B;
	Mon, 26 May 2025 09:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+bPj0Wz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F981D63C0
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748250378; cv=none; b=UcMg6MkwYgxw/NTL9VHOj8SlJRe7ZFyKuF+ZCXJZkXHhjdGeinSN1hxk6GJB1Fn2GtUm209EtlST3kca9Tn++ygRKnJtycde2do3N6ZNLyyx4KunJ8xGyZSqQv8grxV4kFgOJoKUeAAFF0+9vAhc6Hb/jQbL5ZLh4bVAh8G4K+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748250378; c=relaxed/simple;
	bh=yf5k6vkSJ0YQzn0dRtbvc2hxgxqy+ulxY0L/qu36frs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pz0+7Z1EbxT12YK8eLSwCetU/pd711vpm7vVXf5t2yvPDO3werqJr9KkNbhFlfaVEVpIg61fWsJZWvZ/gER54mvJuq+nA2katrXzSi9uWWLKfkPr8DDQzO1A8B0LEc34dEUcVIHn1LczdsOUiHzjUvESWkPCZJWCLrz+ii2bs9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a+bPj0Wz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748250375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ETfJt7uNoG4312JPyvmiSg2Go85laadRukbqwKIKcNo=;
	b=a+bPj0WzYnfA3FTbpEG6BWRvGVkYCamNXImQIhGzPK7UMxTl/Pihb548zrvvW1mx4spVp0
	eTHixS/pprGjKc+BcMMChxBb8UdPdB0oXVcR4MVunprYr3AdfhLZJryYBDIfV6KU4p6iMF
	62+na9n/Efr4qjngbKl6oOQMCKjD6jg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479--dElRPRnORqPazTCKMFrZA-1; Mon, 26 May 2025 05:06:13 -0400
X-MC-Unique: -dElRPRnORqPazTCKMFrZA-1
X-Mimecast-MFC-AGG-ID: -dElRPRnORqPazTCKMFrZA_1748250373
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-442dc6f0138so9271015e9.0
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748250373; x=1748855173;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ETfJt7uNoG4312JPyvmiSg2Go85laadRukbqwKIKcNo=;
        b=tTm+GjxRReJutgROJaHdeWKPzNCw7DaOsxAP5Ljj1h0F6P3YNw3uOyeNOKKdqh8YEq
         XvYFjGUHxNE+ZXot5+gjBxA3KTiSz830l1UFH47FPYuhphAogvMbbnH5A3lhTZmhAuMj
         cY78p1rbWbgkH2jzi12ozQ6e8lRPkYCXnRr/YuMVWveQOwI3RPXxlgjuVFE4A1UzoVWJ
         o1uWn6sWQuHvcIvtIMitTEoRU01/I5QD48MpbVrGvr0bGFZ8FSKmiOACM6TOIK199Anl
         l38mT8LdzdovZOVrog3K98ap3ifpwQvulrrJiOXuGUW7wp/K2JzM0HOlMFGDqlUGy4uj
         5Q6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXWoe2KPsqRzmV1C4/a6qXyxNBuQwZRIkWhKrxkUF7mAAjhLxAzurrAwI0/KH6tvM4s00g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp0iyVKafB2Pk46UGs+JRyeVXyL2t2DhanQ3Ot1OM+bmh1P9g3
	dlAJ686NxOcr5Chiy5FbbLHcqT+jToBkrikfVXvdtObUlW8gdhhtbVOqBHvgQ0kUIFa/fK8aLbe
	UuGns1giDwqbQRpaD8k3KNVUuXGpIMUn0u1S5JW23V5rU57Cl7B6h/g==
X-Gm-Gg: ASbGncvv79i0DAiH3NmrzGhnjkDASKqgcnTwjz6AhNla/8FP67WGCSBUEknGad97Zur
	n+gUrA/msnBmomNMoctVzheaWFf5J+yHbHWvYTNDth8TRbVVG/evcwdvwMHkwrrHHTys3GtStqe
	6xTNl+9jmUFLmRxL4Gh0w91hS+aVoui43q0ublZVaVrwpYMABBGEKerR9p/GJFFjTZe0StCORD1
	JPFq6XwAiDEmQwGwZyX2PdzZw4P/YMiBBE7MJiuc+ieRr35c1P4DN7cYxaLZKyi+PCcMzyQ72JS
	wD+Nmb8pVmSPNprsjNMVvTodSVS0iWInasY3RAOCXS0tRxxD4k6HsuVhgMI9NTwa6QPEx9RqxSH
	jHwOpt/JQ/3RMi2PXfhoQCTtC8qIMDdlJKkpJpY4=
X-Received: by 2002:a05:600c:22c1:b0:442:dc6e:b9a6 with SMTP id 5b1f17b1804b1-44c91dcc104mr58685685e9.17.1748250372649;
        Mon, 26 May 2025 02:06:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQajF7W8Ky0PnIT7msrygsvDZEux0zYBVRLwzJpWPDsN6a9kDdML90ZGzqQbLcEjqC9qLnlg==
X-Received: by 2002:a05:600c:22c1:b0:442:dc6e:b9a6 with SMTP id 5b1f17b1804b1-44c91dcc104mr58685415e9.17.1748250372190;
        Mon, 26 May 2025 02:06:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f7d975f4sm228362635e9.39.2025.05.26.02.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:06:11 -0700 (PDT)
Message-ID: <d22512b9-d5f0-4e0f-9a4c-530767953f3c@redhat.com>
Date: Mon, 26 May 2025 11:06:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/10] memory: Attach RamBlockAttribute to
 guest_memfd-backed RAMBlocks
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
 <20250520102856.132417-7-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-7-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> A new field, ram_shared, was introduced in RAMBlock to link to a
> RamBlockAttribute object, which centralizes all guest_memfd state
> information (such as fd and shared_bitmap) within a RAMBlock.
> 
> Create and initialize the RamBlockAttribute object upon ram_block_add().
> Meanwhile, register the object in the target RAMBlock's MemoryRegion.
> After that, guest_memfd-backed RAMBlock is associated with the
> RamDiscardManager interface, and the users will execute
> RamDiscardManager specific handling. For example, VFIO will register the
> RamDiscardListener as expected. The live migration path needs to be
> avoided since it is not supported yet in confidential VMs.
> 
> Additionally, use the ram_block_attribute_state_change() helper to
> notify the registered RamDiscardListener of these changes.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Revert to use RamDiscardManager interface.
>      - Move the object_new() into the ram_block_attribute_create()
>        helper.
>      - Add some check in migration path.
> 
> Changes in v4:
>      - Remove the replay operations for attribute changes which will be
>        handled in a listener in following patches.
>      - Add some comment in the error path of realize() to remind the
>        future development of the unified error path.
> 
> Changes in v3:
>      - Use ram_discard_manager_reply_populated/discarded() to set the
>        memory attribute and add the undo support if state_change()
>        failed.
>      - Didn't add Reviewed-by from Alexey due to the new changes in this
>        commit.
> 
> Changes in v2:
>      - Introduce a new field memory_attribute_manager in RAMBlock.
>      - Move the state_change() handling during page conversion in this patch.
>      - Undo what we did if it fails to set.
>      - Change the order of close(guest_memfd) and memory_attribute_manager cleanup.
> ---
>   accel/kvm/kvm-all.c |  9 +++++++++
>   migration/ram.c     | 28 ++++++++++++++++++++++++++++
>   system/physmem.c    | 14 ++++++++++++++
>   3 files changed, 51 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 51526d301b..2d7ecaeb6a 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3089,6 +3089,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>       rb = qemu_ram_block_from_host(addr, false, &offset);
>   
> +    ret = ram_block_attribute_state_change(RAM_BLOCK_ATTRIBUTE(mr->rdm),
> +                                           offset, size, to_private);
> +    if (ret) {
> +        error_report("Failed to notify the listener the state change of "
> +                     "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> +                     start, size, to_private ? "private" : "shared");
> +        goto out_unref;
> +    }
> +
>       if (to_private) {
>           if (rb->page_size != qemu_real_host_page_size()) {
>               /*
> diff --git a/migration/ram.c b/migration/ram.c
> index c004f37060..69c9a42f16 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -890,6 +890,13 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
>   
>       if (rb->mr && rb->bmap && memory_region_has_ram_discard_manager(rb->mr)) {
>           RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
> +
> +        if (object_dynamic_cast(OBJECT(rdm), TYPE_RAM_BLOCK_ATTRIBUTE)) {
> +            error_report("%s: Live migration for confidential VM is not "
> +                         "supported yet.", __func__);
> +            exit(1);
> +        }
>

These checks seem conceptually wrong.

I think if we were to special-case specific implementations, we should 
do so using a different callback.

But why should we bother at all checking basic live migration handling 
("unsupported for confidential VMs") on this level, and even just 
exit()'ing the process?

All these object_dynamic_cast() checks in this patch should be dropped.

-- 
Cheers,

David / dhildenb


