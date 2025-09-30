Return-Path: <kvm+bounces-59132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE6CABAC3D9
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 11:18:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EDBF19271AA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C5B221F0A;
	Tue, 30 Sep 2025 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X3XaC3tc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D045B1C84A6
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 09:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759223919; cv=none; b=dHoJNhkQCrj+aWhIU8tXGzhoxmVSOJ5wyCq99FL+qhmLJUAHc9vS8r2y95RQO/7jsGeDCRs4DzTrgOkRsOUFRDkC4voSvkf3RzvKnTWfeRdPCLNuYXsQcZPucyNZlodQ4UR4cOf7rZ/scuHd15ySn/K1O4XastIQSqJI+5XU2P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759223919; c=relaxed/simple;
	bh=8oEyMHYY0F5fzeCt+qocCDHnnka+9ofj6XWENzHI444=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f2ufZYXXyi6zQzY7qQ6RPisDjBELHxIwvzhBNp42+T/CZ2neyvLDonhvduhIqnB++5WIqfPnqZgmZV3qbGgkSy8GHf/OZEhQmyqiqqs4pNSypibbWb0uOnRFFXfq0r+RClS0olazVRrs2CKd+OYkuih03cCeCCzr7JoW7xoRvs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X3XaC3tc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759223916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d3jiynPnEzxxv2oRAoAk1Ku5mtXrOi1sVDTTsgV+r60=;
	b=X3XaC3tciOJPvV35OmmhhCQXlxBH3yBzFkFfCS2+wP313L4bDgibLPbecgUcyD+E64cMEu
	BSA6yeC/8hhUbUadSpYsYwBJkoKihva8rp+Osk6Ua2quu84oQXEyzzyK8wNTMiFBK9ZgK+
	ZrrcuPQR8B5ms1xO2aGBVnIB0M2wG4E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-nEgs6Uo-ME-00INjVHhqNA-1; Tue, 30 Sep 2025 05:18:35 -0400
X-MC-Unique: nEgs6Uo-ME-00INjVHhqNA-1
X-Mimecast-MFC-AGG-ID: nEgs6Uo-ME-00INjVHhqNA_1759223914
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e2d845ebeso41083865e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 02:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759223914; x=1759828714;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d3jiynPnEzxxv2oRAoAk1Ku5mtXrOi1sVDTTsgV+r60=;
        b=oJzBJGyMjJpzv/VH4XvBCs2h5Sdlq1c70f5LSo5uqZs03JxUtZkC+ozK8SgkrewjhO
         ro6tWtxIhgCUcC/eRoXOh4P7yfgZgIPSwWzQyWiM3398uDsDl+H0pi/9TIMm5VOhc5Pm
         HnnG95LtaGqm1oN7nievvIK74+VDEHvPMQ0/bAjr7Rnw/Keo0T/ZHCn45JewUTfzF9ta
         U1wVe3201eSYlNlSo/sTk4YNoszv5tM5tndR2ZOltFvwuAx71Bz1X5vWH0CUdh7rQke7
         Vac8hLY3YQ7P+NWJcEJy39jQnIasgNBgEhvgE95lJeU6ZTazeCOQzE4Ejoz/Y85TRGx8
         uYNw==
X-Forwarded-Encrypted: i=1; AJvYcCV2LBowixLbbvWFrIvvposmkU6O5S0y4TVwctQck7yOL6ikywgW6Ok531hgfcDYES1zx2s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwKrDL7pVLz6uLrqSgEvtTwePv4BUskUqVV40RTdW2DuRTTjE+
	LVyfszSMWIlumYRn4b/lQl9yIr+icFL1L7mHoi8MU2YR+QwJLz2tCzbS/US+kUI/VXcjC23joQN
	Np1Z+BSBrp9uvuLlP+xbc/Yu9/4ybuAqkCmiELSXwbwqirscmMkWwzw==
X-Gm-Gg: ASbGncsILwhGr3owOebN1ifvjLxtsBz7+m3f2FDakfb33CkFlDzlZGf9Lq9dS26rhiX
	Uks3kxY9kbA5GwFI02JZaqUDLkenl+GM2quF03gNIDUzMFAYWIsIegU6jmCT81sH4dDL7q74DJ8
	/G72ozV3czsrIn+7Rvk8Wy3SEcRJHiX/oe3ySUMtGFswSKmhgiM28KQT3zg+EmNDtDpPjgBjJx3
	zaNc88+8qLafBbq7GacObRDmiqWvvzLXSEf8WKETaf3cru3HCc9NO3Z2i148NizGVBJN3nd6H/B
	/RRcwYm/y0sB9u+eQzz21rSzCLe0giLlF/jJ5UhCtT0W3y5mZLHUCelB+qn/9UUlVzygkpNsfZT
	d7Nmxawyg2A==
X-Received: by 2002:a05:600c:4e52:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46e51fa6a03mr62469165e9.30.1759223913924;
        Tue, 30 Sep 2025 02:18:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEHA7zZRePx4N9OF9Phbhrr1b0KhGDD1FpkIOIr+WZAiVdK6e9WSFSf5gyO0we3QGfFVloHyA==
X-Received: by 2002:a05:600c:4e52:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46e51fa6a03mr62468955e9.30.1759223913515;
        Tue, 30 Sep 2025 02:18:33 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab6a514sm260322475e9.22.2025.09.30.02.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:18:33 -0700 (PDT)
Message-ID: <9993b187-7b44-4f9b-801d-fdfa6b309362@redhat.com>
Date: Tue, 30 Sep 2025 11:18:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] system/memory: Better describe @plen argument of
 flatview_translate()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Peter Xu <peterx@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Zhao Liu <zhao1.liu@intel.com>, David Hildenbrand <david@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 xen-devel@lists.xenproject.org, Stefano Garzarella <sgarzare@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
 Paul Durrant <paul@xen.org>, "Michael S. Tsirkin" <mst@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Jason Herne
 <jjherne@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Farman <farman@linux.ibm.com>
References: <20250930082126.28618-1-philmd@linaro.org>
 <20250930082126.28618-3-philmd@linaro.org>
 <525dd07f-ae64-4ba7-b3ec-b9fcd86aa8a5@redhat.com>
 <ededf937-5424-4cf7-8ea1-e07709db27f1@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 xsFNBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABzR5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT7CwXgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDzsFN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABwsFfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
In-Reply-To: <ededf937-5424-4cf7-8ea1-e07709db27f1@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2025 10.31, Philippe Mathieu-Daudé wrote:
> Hi Thomas,
> 
> On 30/9/25 10:24, Thomas Huth wrote:
>> On 30/09/2025 10.21, Philippe Mathieu-Daudé wrote:
>>> flatview_translate()'s @plen argument is output-only and can be NULL.
>>>
>>> When Xen is enabled, only update @plen_out when non-NULL.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   include/system/memory.h | 5 +++--
>>>   system/physmem.c        | 9 +++++----
>>>   2 files changed, 8 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/system/memory.h b/include/system/memory.h
>>> index aa85fc27a10..3e5bf3ef05e 100644
>>> --- a/include/system/memory.h
>>> +++ b/include/system/memory.h
>>> @@ -2992,13 +2992,14 @@ IOMMUTLBEntry 
>>> address_space_get_iotlb_entry(AddressSpace *as, hwaddr addr,
>>>    * @addr: address within that address space
>>>    * @xlat: pointer to address within the returned memory region section's
>>>    * #MemoryRegion.
>>> - * @len: pointer to length
>>> + * @plen_out: pointer to valid read/write length of the translated address.
>>> + *            It can be @NULL when we don't care about it.
>>>    * @is_write: indicates the transfer direction
>>>    * @attrs: memory attributes
>>>    */
>>>   MemoryRegion *flatview_translate(FlatView *fv,
>>>                                    hwaddr addr, hwaddr *xlat,
>>> -                                 hwaddr *len, bool is_write,
>>> +                                 hwaddr *plen_out, bool is_write,
>>>                                    MemTxAttrs attrs);
>>>   static inline MemoryRegion *address_space_translate(AddressSpace *as,
>>> diff --git a/system/physmem.c b/system/physmem.c
>>> index 8a8be3a80e2..86422f294e2 100644
>>> --- a/system/physmem.c
>>> +++ b/system/physmem.c
>>> @@ -566,7 +566,7 @@ iotlb_fail:
>>>   /* Called from RCU critical section */
>>>   MemoryRegion *flatview_translate(FlatView *fv, hwaddr addr, hwaddr *xlat,
>>> -                                 hwaddr *plen, bool is_write,
>>> +                                 hwaddr *plen_out, bool is_write,
>>>                                    MemTxAttrs attrs)
>>>   {
>>>       MemoryRegion *mr;
>>> @@ -574,13 +574,14 @@ MemoryRegion *flatview_translate(FlatView *fv, 
>>> hwaddr addr, hwaddr *xlat,
>>>       AddressSpace *as = NULL;
>>>       /* This can be MMIO, so setup MMIO bit. */
>>> -    section = flatview_do_translate(fv, addr, xlat, plen, NULL,
>>> +    section = flatview_do_translate(fv, addr, xlat, plen_out, NULL,
>>>                                       is_write, true, &as, attrs);
>>>       mr = section.mr;
>>> -    if (xen_enabled() && memory_access_is_direct(mr, is_write, attrs)) {
>>> +    if (xen_enabled() && plen_out && memory_access_is_direct(mr, is_write,
>>> +                                                             attrs)) {
>>>           hwaddr page = ((addr & TARGET_PAGE_MASK) + TARGET_PAGE_SIZE) - 
>>> addr;
>>> -        *plen = MIN(page, *plen);
>>> +        *plen_out = MIN(page, *plen_out);
>>>       }
>>
>> My question from the previous version is still unanswered:
>>
>> https://lore.kernel.org/qemu- 
>> devel/22ff756a-51a2-43f4-8fe1-05f17ff4a371@redhat.com/
> 
> This patches
> - checks for plen not being NULL
> - describes it as
>    "When Xen is enabled, only update @plen_out when non-NULL."
> - mention that in the updated flatview_translate() documentation
>    "It can be @NULL when we don't care about it." as documented for
>    the flatview_do_translate() callee in commit d5e5fafd11b ("exec:
>    add page_mask for flatview_do_translate")
> 
> before:
> 
>    it was not clear whether we can pass plen=NULL without having
>    to look at the code.
> 
> after:
> 
>    no change when plen is not NULL, we can pass plen=NULL safely
>    (it is documented).
> 
> I shouldn't be understanding your original question, do you mind
> rewording it?

Ah, you've updated the patch in v3 to include a check for plen_out in the 
if-statement! It was not there in v2. Ok, this should be fine now:

Reviewed-by: Thomas Huth <thuth@redhat.com>

I just re-complained since you did not respond to my mail in v2, and when I 
looked at the changelog in your v3 cover letter, you did not mention the 
modification here, so I blindly assumed that this patch was unchanged.

  Thomas


