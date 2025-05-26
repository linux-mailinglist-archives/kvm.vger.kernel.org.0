Return-Path: <kvm+bounces-47694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FF8AC3C7B
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 575173ABE4D
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451E01E261F;
	Mon, 26 May 2025 09:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQ9xRXhm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6025569
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748251033; cv=none; b=ai850Ol0j6J6U65eZJawKkMHRcw8jqNvHppbRBAsXfjpXBopc1rUd96x7fAstZZfJF4YJVshB2NrJahANjac/jhNKw/iYD/iROWfzhdh9ojRLCUUMX5sy8RQCXc/DuBSb1VQ2wC2+svYtAshvLBA3TxqTaeZW2Mb2I90qXHS/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748251033; c=relaxed/simple;
	bh=pya/cD8e9MLLqdaJj6yQKfgAdVG7Ia/e/idOtoiWqW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lk7u09i40BOuiwBfu6sLqnfTT7uFwIMRWYYhDQ95EUNbWyjlopA9++a2ELYYmkA97RmVUpQkNXNO1QOIN143GyERUuoZqKS0BSrMzAy6/3Pnjh9NbdJV5v6aHI5rA63b4AJ/3722PZMntP1J5AY+90VaWTKuNQLD/Zh85pgjAPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eQ9xRXhm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748251030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vrgnwX+XpO3oZxobtIJdJoGMB7i4IfflekNRWvQhTmg=;
	b=eQ9xRXhmkiyihGB8mbtcnzIkBH2Ye6iCd9SUUpDdup1PHrSuwZfNCjuBJKmrSHKU9AiQ+V
	IXNCOdXyXI0TjN7X8HHdYX7Gg2uGB+fX6tR4c1jpdTUyk8FXEVCxbTreVRSAiiziFPDFNC
	ogYlevcegwV9PI3w2SVIyvSclwyFxRw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-HdDA80tlPhqr4JV7lcuCyA-1; Mon, 26 May 2025 05:17:08 -0400
X-MC-Unique: HdDA80tlPhqr4JV7lcuCyA-1
X-Mimecast-MFC-AGG-ID: HdDA80tlPhqr4JV7lcuCyA_1748251027
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so15525405e9.2
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748251027; x=1748855827;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vrgnwX+XpO3oZxobtIJdJoGMB7i4IfflekNRWvQhTmg=;
        b=oe8cFCOnFptVOVGOfRpe4y7CVeRlw2LG14ILeYX+MaFUP9f+A37ViWKNuxHhC9HIbS
         nCU/DB5g3UxzAsGeh5x1Ibs8tl72OpMw5G0jYuBSaQ7lARIbKaxvUASw9qxP7FwGKLKv
         7UuZyDJz/zhbRjXy0/SiO8+wYaK56rOslGYD+/VNA76hW7/EI2cWn29s92mvp+EkiEdv
         y7kOboe3YjZjVqefG/b6x998xK4Oo88NxUiMyyCKQcPHnzEUoN9BwbTgVvukyL9/AJwW
         8pXkgGKG8DBhAut8TrVZo15a9pocPyiXGF2ZiE3IY9bqjIfrk4cYrVsr4pswsAtORN42
         3YVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6uMxfLiqQKRG49nwBwbIbr5eGKqZKLYLlOItwTYtbThXe2P0CkwQVMzAbNBL9vrdbvAw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypw3fP9JTyw+wsXY8gLTs7qVy7vqZaTaq5107lR63GZLGhhQT2
	i6RFAxgkpzQNgg7C4Wa3AYSUhLEzE57p7w38tWFfT6NczcaoWSaZF2cNEARswaIkhP4jfcGecKN
	1z9Nr6wGTMbNZ/eORKE/0XmMyrxtKGMCc01T6fum4ohl6Ib5s4Zb6CA==
X-Gm-Gg: ASbGnct84TeStwe0PA1Fsi8gHvUC5/IMPkBKXZ2APHw7Y158S9g+naV+AMTLn6/p7rm
	Ib6r3ndQeEAzfKF8ChDlKrmMV+oZrPkbhpGAkUnHpZ1m7uZIKWrCS0LCip6cFwG8jfa0altDFFh
	ZDO/i10AgoWIND6pCiMo4TAph6e2/XNQrDjiXptK015dDekEKJ92VArQXSduYicI5LBKFPXUYgU
	m7wtCjOwvjV3MDOfJsW0+kL4dHGyBl8RvOgwPipycPA1CAD73Ske2zrHvJ8jmonyWZF1RmZDahr
	uO4ov13M1KT+6H84tcGeMRz7fOTfeI5fILLHOBfilX9CXZM72Hp3BU2+dCU7HLx9oT/JfRbYIva
	kJcPoSu/0K0eUPcweXcSBVEDakmY0HNo1U0XW7xY=
X-Received: by 2002:a05:6000:40ce:b0:3a4:dd02:f566 with SMTP id ffacd0b85a97d-3a4dd02f6admr831234f8f.22.1748251027285;
        Mon, 26 May 2025 02:17:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAitxi3kXFt+sI/5NwSXKjBu+jB+tHOfkfiw7eNaviG6loQkSMcXUPVMmhcpMahbRnI5Nisg==
X-Received: by 2002:a05:6000:40ce:b0:3a4:dd02:f566 with SMTP id ffacd0b85a97d-3a4dd02f6admr831214f8f.22.1748251026872;
        Mon, 26 May 2025 02:17:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4dc1172ecsm1414743f8f.48.2025.05.26.02.17.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:17:06 -0700 (PDT)
Message-ID: <6b5957fa-8036-40b6-b79d-db5babb5f7b9@redhat.com>
Date: Mon, 26 May 2025 11:17:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/10] ram-block-attribute: Add more error handling
 during state changes
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
 <20250520102856.132417-11-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-11-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> The current error handling is simple with the following assumption:
> - QEMU will quit instead of resuming the guest if kvm_convert_memory()
>    fails, thus no need to do rollback.
> - The convert range is required to be in the desired state. It is not
>    allowed to handle the mixture case.
> - The conversion from shared to private is a non-failure operation.
> 
> This is sufficient for now as complext error handling is not required.
> For future extension, add some potential error handling.
> - For private to shared conversion, do the rollback operation if
>    ram_block_attribute_notify_to_populated() fails.
> - For shared to private conversion, still assert it as a non-failure
>    operation for now. It could be an easy fail path with in-place
>    conversion, which will likely have to retry the conversion until it
>    works in the future.
> - For mixture case, process individual blocks for ease of rollback.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   system/ram-block-attribute.c | 116 +++++++++++++++++++++++++++--------
>   1 file changed, 90 insertions(+), 26 deletions(-)
> 
> diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
> index 387501b569..0af3396aa4 100644
> --- a/system/ram-block-attribute.c
> +++ b/system/ram-block-attribute.c
> @@ -289,7 +289,12 @@ static int ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
>           }
>           ret = rdl->notify_discard(rdl, &tmp);
>           if (ret) {
> -            break;
> +            /*
> +             * The current to_private listeners (VFIO dma_unmap and
> +             * KVM set_attribute_private) are non-failing operations.
> +             * TODO: add rollback operations if it is allowed to fail.
> +             */
> +            g_assert(ret);
>           }
>       }
>   

If it's not allowed to fail for now, then patch #8 does not make sense 
and should be dropped :)

The implementations (vfio) should likely exit() instead on unexpected 
errors when discarding.



Why not squash all the below into the corresponding patch? Looks mostly 
like handling partial conversions correctly (as discussed previously)?

> @@ -300,7 +305,7 @@ static int
>   ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
>                                           uint64_t offset, uint64_t size)
>   {
> -    RamDiscardListener *rdl;
> +    RamDiscardListener *rdl, *rdl2;
>       int ret = 0;
>   
>       QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> @@ -315,6 +320,20 @@ ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
>           }
>       }
>   
> +    if (ret) {
> +        /* Notify all already-notified listeners. */
> +        QLIST_FOREACH(rdl2, &attr->rdl_list, next) {
> +            MemoryRegionSection tmp = *rdl2->section;
> +
> +            if (rdl == rdl2) {
> +                break;
> +            }
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +                continue;
> +            }
> +            rdl2->notify_discard(rdl2, &tmp);
> +        }
> +    }
>       return ret;
>   }
>   
> @@ -353,6 +372,9 @@ int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
>       const int block_size = ram_block_attribute_get_block_size(attr);
>       const unsigned long first_bit = offset / block_size;
>       const unsigned long nbits = size / block_size;
> +    const uint64_t end = offset + size;
> +    unsigned long bit;
> +    uint64_t cur;
>       int ret = 0;
>   
>       if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
> @@ -361,32 +383,74 @@ int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
>           return -1;
>       }
>   
> -    /* Already discard/populated */
> -    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
> -         to_private) ||
> -        (ram_block_attribute_is_range_populated(attr, offset, size) &&
> -         !to_private)) {
> -        return 0;
> -    }
> -
> -    /* Unexpected mixture */
> -    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
> -         to_private) ||
> -        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
> -         !to_private)) {
> -        error_report("%s, the range is not all in the desired state: "
> -                     "(offset 0x%lx, size 0x%lx), %s",
> -                     __func__, offset, size,
> -                     to_private ? "private" : "shared");
> -        return -1;
> -    }
> -
>       if (to_private) {
> -        bitmap_clear(attr->bitmap, first_bit, nbits);
> -        ret = ram_block_attribute_notify_to_discard(attr, offset, size);
> +        if (ram_block_attribute_is_range_discard(attr, offset, size)) {
> +            /* Already private */
> +        } else if (!ram_block_attribute_is_range_populated(attr, offset,
> +                                                           size)) {
> +            /* Unexpected mixture: process individual blocks */
> +            for (cur = offset; cur < end; cur += block_size) {
> +                bit = cur / block_size;
> +                if (!test_bit(bit, attr->bitmap)) {
> +                    continue;
> +                }
> +                clear_bit(bit, attr->bitmap);
> +                ram_block_attribute_notify_to_discard(attr, cur, block_size);
> +            }
> +        } else {
> +            /* Completely shared */
> +            bitmap_clear(attr->bitmap, first_bit, nbits);
> +            ram_block_attribute_notify_to_discard(attr, offset, size);
> +        }
>       } else {
> -        bitmap_set(attr->bitmap, first_bit, nbits);
> -        ret = ram_block_attribute_notify_to_populated(attr, offset, size);
> +        if (ram_block_attribute_is_range_populated(attr, offset, size)) {
> +            /* Already shared */
> +        } else if (!ram_block_attribute_is_range_discard(attr, offset, size)) {
> +            /* Unexpected mixture: process individual blocks */
> +            unsigned long *modified_bitmap = bitmap_new(nbits);
> +
> +            for (cur = offset; cur < end; cur += block_size) {
> +                bit = cur / block_size;
> +                if (test_bit(bit, attr->bitmap)) {
> +                    continue;
> +                }
> +                set_bit(bit, attr->bitmap);
> +                ret = ram_block_attribute_notify_to_populated(attr, cur,
> +                                                           block_size);
> +                if (!ret) {
> +                    set_bit(bit - first_bit, modified_bitmap);
> +                    continue;
> +                }
> +                clear_bit(bit, attr->bitmap);
> +                break;
> +            }
> +
> +            if (ret) {
> +                /*
> +                 * Very unexpected: something went wrong. Revert to the old
> +                 * state, marking only the blocks as private that we converted
> +                 * to shared.
> +                 */
> +                for (cur = offset; cur < end; cur += block_size) {
> +                    bit = cur / block_size;
> +                    if (!test_bit(bit - first_bit, modified_bitmap)) {
> +                        continue;
> +                    }
> +                    assert(test_bit(bit, attr->bitmap));
> +                    clear_bit(bit, attr->bitmap);
> +                    ram_block_attribute_notify_to_discard(attr, cur,
> +                                                          block_size);
> +                }
> +            }
> +            g_free(modified_bitmap);
> +        } else {
> +            /* Complete private */
> +            bitmap_set(attr->bitmap, first_bit, nbits);
> +            ret = ram_block_attribute_notify_to_populated(attr, offset, size);
> +            if (ret) {
> +                bitmap_clear(attr->bitmap, first_bit, nbits);
> +            }
> +        }
>       }
>   
>       return ret;


-- 
Cheers,

David / dhildenb


