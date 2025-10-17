Return-Path: <kvm+bounces-60356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 22966BEAFD9
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 19:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B38474E7FB7
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 17:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0E92FE570;
	Fri, 17 Oct 2025 17:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfReh0RU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7482FD1A9
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720884; cv=none; b=aI3L0NqJ18HptK6SU5B5H1l74WnNEgl8xHyVxgZUEIq4uNchJQvRTpuR6cgSZP/JIfEO0sJ4xCH+G1/yU0uUpMBFOBXJT2T9M7t98P0+KoFMMGbJinVJE6Hvusq4Qwd1wdzFypzpRBjpziCzqNZT1oM4hQWRuvNElle+KnwxmPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720884; c=relaxed/simple;
	bh=bcMDBONJ+ncOPzZRA73hCKIdlAtAQLycr5+hTmdlizE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCxsq1GFJmHtJzFDHMMcH+00lhWElfhlWsUT8A3kPJN1/ZQSSeKUTSG2b+GTWBAJf8Hr7jR8V+ya5RShP08GkX04AqpSaJ86GBLJPlLhfTkAF4ZdqQj5PPSxtYB6UpW+dCfbXH8OnDgW6B+1o0koTiXxROKUuM9LI9Gy7ZNV1E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfReh0RU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760720881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Z24I92BnG9R28uKM3ytM2okJi6Ci8baUDtE0rgRavFw=;
	b=CfReh0RU0e2l+JZa/+EyyRGL7RGrqBPwkpwwzYSU+C4Ob6YORnpROwYPZ64AciqHvp2nrN
	Q2cN/PuqUp5vULKDL7LFvoWRFFE1AZp2EAA32HzTHsc+Qzqhkk6wL/0Yv6fLghCGl7yGlS
	KkF4tLQECC8RZMd2rYsral5+vbL+/cE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-lWDm8NZkN6C67aqvAYlyow-1; Fri, 17 Oct 2025 13:08:00 -0400
X-MC-Unique: lWDm8NZkN6C67aqvAYlyow-1
X-Mimecast-MFC-AGG-ID: lWDm8NZkN6C67aqvAYlyow_1760720879
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47108163eeaso11908755e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 10:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760720879; x=1761325679;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z24I92BnG9R28uKM3ytM2okJi6Ci8baUDtE0rgRavFw=;
        b=BJJ5SXdEarML4EOh8R3PLoYbwyhxz5skblLUd0V5iubWWrGxvCbtPSvcQLyxiFTMcZ
         TP1SKeATyZQGq5SEnpfx4Me4g1ZqnUb210JnDKy9OT0PR7l7/MN0l4s4zCJuLCj5g7Sd
         N3AjjulCSPxkLbYLpDOM4TGjrDEce2VDbDdR3o0B2nRasw/KOxkJm2qvpLbTKBri3JQZ
         FtaNN92Ap1vExvXkKycYpo9yRS5jP94wO7ttNI7BXxtHw23su1DPkrKOWHHnMZgeQ1/U
         spY8QW4v9/rWV3H/dOjsF8U+ICh6t+gBPb4xC7Kkt2b+VoF21Dosul3OsWKHHyzNDF74
         BZ3A==
X-Forwarded-Encrypted: i=1; AJvYcCWSCdHnSXalWVZt9wt7Yu6bjgY8fQ1/Ll2Kvv8I4sJCr4f3oEepCwtNwNbZmH1Ow7kj6BY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKA01KFutzHJ0iadpUzuP7ggU4A73WqvJsMOdXJHby0rAjATrO
	PTv745W/lrrpd0Lw/eH9HcR7Xw5gBJ+L3jIaBvELY2UokFI9ZblxZ6JXKdDLWzsIrHbQi/uKu4O
	eCsHM4pn6U+vXPoGzc21FbJLowL9H3XmYA1FcY7bDGear9FwPalhVPw==
X-Gm-Gg: ASbGncuTw87OHNh5M3a/xNIwr8Ijgkk/74eUY4ntrWk1k5XZxgNoRskuTfY6yxC95vq
	DvQHSDzubzzFYjZu91ekyifaPhMnAo+JIvXqMUbbcFzqHFH66FR2GWF84ODn6qM6vxZvJdTVRM8
	LRkm7AtnVCMgVJFgxtcAftkdq6bdYTknZxWaeNwC9mYh4yqsOaSwwHORfuqc8OvBqoJaXJhl8p0
	46Lb2RROPtm9qkuPz9Exy+wFGanoWU7yKtqISsuBUgKvl4AWXL7+TkUdX8DHYHhaKbLsDTx7iCq
	EaTj8WLuvb+aZ7nqjwiWPnUPO+jUoCVId/L3onmcivnL34TjeOp7xmwuVsm/1S/RRJskVJ0xQmf
	1gx4r288sZ13svvjKxm9Qbz9Mky3IgE6KellAYWykiuhvXQ7kmfqfCztZL+ijwuOTEHotWeSJID
	cwytRci2FvoMXvoNFzndTDjxg8Xl0=
X-Received: by 2002:a05:600c:8b8c:b0:46e:4287:a85e with SMTP id 5b1f17b1804b1-471178a4af1mr32117635e9.13.1760720879264;
        Fri, 17 Oct 2025 10:07:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0wYIRs5BvgxV0rKkXoRn76PeLh5TeG9Gq12PJQFOLbCPpMAp+gPbGh/AVsOgKNhG3Gab2NQ==
X-Received: by 2002:a05:600c:8b8c:b0:46e:4287:a85e with SMTP id 5b1f17b1804b1-471178a4af1mr32117185e9.13.1760720878815;
        Fri, 17 Oct 2025 10:07:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm123442385e9.3.2025.10.17.10.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 10:07:58 -0700 (PDT)
Message-ID: <84349344-b127-41f6-99f1-10f907c2bd07@redhat.com>
Date: Fri, 17 Oct 2025 19:07:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Christian Borntraeger <borntraeger@linux.ibm.com>, balbirs@nvidia.com
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
 <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.25 17:20, Christian Borntraeger wrote:
> 
> 
> Am 17.10.25 um 17:07 schrieb David Hildenbrand:
>> On 17.10.25 17:01, Christian Borntraeger wrote:
>>> Am 17.10.25 um 16:54 schrieb David Hildenbrand:
>>>> On 17.10.25 16:49, Christian Borntraeger wrote:
>>>>> This patch triggers a regression for s390x kvm as qemu guests can no longer start
>>>>>
>>>>> error: kvm run failed Cannot allocate memory
>>>>> PSW=mask 0000000180000000 addr 000000007fd00600
>>>>> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
>>>>> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
>>>>> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
>>>>> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>>>>> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
>>>>> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
>>>>> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
>>>>> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
>>>>>
>>>>> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?
>>>>
>>>> Only when running KVM guests and apart from that everything else seems to be fine?
>>>
>>> We have other weirdness in linux-next but in different areas. Could that somehow be
>>> related to use disabling THP for the kvm address space?
>>
>> Not sure ... it's a bit weird. I mean, when KVM disables THPs we essentially just remap everything to be mapped by PTEs. So there shouldn't be any PMDs in that whole process.
>>
>> Remapping a file THP (shmem) implies zapping the THP completely.
>>
>>
>> I assume in your kernel config has CONFIG_ZONE_DEVICE and CONFIG_ARCH_ENABLE_THP_MIGRATION set, right?
> 
> yes.
> 
>>
>> I'd rule out copy_huge_pmd(), zap_huge_pmd() a well.
>>
>>
>> What happens if you revert the change in mm/pgtable-generic.c?
> 
> That partial revert seems to fix the issue
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 0c847cdf4fd3..567e2d084071 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>    
>           if (pmdvalp)
>                   *pmdvalp = pmdval;
> -       if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
> +       if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))

Okay, but that means that effectively we stumble over a PMD entry that 
is not a migration entry but still non-present.

And I would expect that it's a page table, because otherwise the change
wouldn't make a difference.

And the weird thing is that this only triggers sometimes, because if
it would always trigger nothing would ever work.

Is there some weird scenario where s390x might set a left page table 
mapped in a PMD to non-present?

Staring at the definition of pmd_present() on s390x it's really just

	return (pmd_val(pmd) & _SEGMENT_ENTRY_PRESENT) != 0;


Maybe this is happening in the gmap code only and not actually in the 
core-mm code?

-- 
Cheers

David / dhildenb


