Return-Path: <kvm+bounces-59081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2535BAB707
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58C053A98CB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 05:03:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07775246774;
	Tue, 30 Sep 2025 05:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQXMQfpq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83E22EB10
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 05:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759208576; cv=none; b=EFPVHZ5fdmebRrHYbk0Lw2iyq6lAkDsajel74axHSUBeRLsRKxI4Ry5/mhVVFJyxnFBvAPVZTBqFJgwHtmGY9183skU/dCXE7XUYSPPO1owgdj6xwMxMa1sBqv0yHXnGPlEoadeQMei454h5i6LYFi1v2/lfdkHDQE29H6NV4tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759208576; c=relaxed/simple;
	bh=8PZrXcvd9ulQodjiqKHotmC5rzaSWKRPRJlXe6xTA+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFkwgTzNPQEr0z1PdY+xL9UjVH/MupuiFBZzJ2PyQ3ccG93DrGAmxY/aIvUGQiNNZPZclfRUR420BJU/fuiSVLtJ8kofzhQvCuoT2LP7PT75CADlTM9oJwUX0gnfGGK9zDWRkbHQP62jhboeaKXRV2TLIXjBWLfCh05CfAhHXkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AQXMQfpq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759208573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bL+RjxGqhOdRGXNtIbLqiRsKj/Y3K4D3P43i5DVXnfw=;
	b=AQXMQfpq1Zl5N4RYltApZW3u303kJCD1/VkTpgsnrj6lWjsmZ5+i+nn3RYxLepKO8DPvzJ
	4p1d77uUfoO7yhrwIMHXujgHD6INXjrkWZXKD31hL77eaB1VpNZDBEy0O8jE/q5MM6x97b
	dsfHC41DeBRhRQ1/M21XkazW9jULsbQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-oWfBo0dxMpiY5-sNUvcuwA-1; Tue, 30 Sep 2025 01:02:52 -0400
X-MC-Unique: oWfBo0dxMpiY5-sNUvcuwA-1
X-Mimecast-MFC-AGG-ID: oWfBo0dxMpiY5-sNUvcuwA_1759208571
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b335ec149a8so467302266b.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 22:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759208571; x=1759813371;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bL+RjxGqhOdRGXNtIbLqiRsKj/Y3K4D3P43i5DVXnfw=;
        b=chPOx3Zp/2XtymaPHFmIBF2Um+8A6kFfrrJkX+F2LKgvj0RuClNy2Q/+ot12PM4uuw
         Ks9uzihowhSHUbqcQCnJzU1apL7NhE4u+BAwKuT0CacR3XgY9JLeaLRGtjbZ8rlTNVyA
         1efFjhOXhc1wz47oZMc1aHKrvba/GU6KSfcJaToE3W9bNlFmvE4ZnRiult9TQxtMVyGZ
         euTYtWH+N9aHtcDrspfyjDPu/Ywdu5YthAYmVRF3cm7ty+JydTFbXhsPPw2hkqisXMAR
         BuqMWO/LwAaI9MPjxZuiaX/38E3fKRaJD+rwm27F9QX9nGh6JqKkjfADz0UYAAMNaw0g
         is7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVjARWNdltNXEBG8/nQWxVRWbcvqW1OPoPkWsdBX3oLu7KCnL5f5da7MRoqcTjn00qMhg0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7vHt/geNv+2Nhz6X4FMqbQz2SGPUkUD8h6rIn05dW/kY4hHV1
	CibA3NZtg5/w/X+FN5QWRD6TV4GA78HtrgMVLE0Yce/2uE1Yy92FS3+4oopqZ8i1csMAlVyGiFM
	IizJhI2NRGfTatfOPG2vQLwfkissljVbzqhPQYppns2lMYZTk26ApIA==
X-Gm-Gg: ASbGncvtB6QgTYeNQsRBdIWxykKfB1tuBfWjiuDyykS++bO1QggG1J4kODYUsaFu3d5
	B6BooOhBSyQGwiixuOoeENji+qfG28emGNTW2eY4fMsdsPH0vP9cyh9wpir4anGQTxWgrt5+dF/
	FYbhh3zp6m93B8c/5Jw6QcUiiuHRQ/qdg3hPiNTAAMKPCaCoPmRm1EOALVOLfows+R+9l/da3qk
	IxO1QfqkeZ25M4j48Zmc3rcWXPjifg7d5v8JCRSPn9KrxyzLLeMC60uiNwpqvQDJ5PSCw7G2PWI
	Ef9r1aU1bSQop+j9vh4BmNFVnUuTD4hCL5O3pGazl7Ye026xWIOYS5UkkChaPogH6tsNpb9adag
	wnP/5yJ3t6w==
X-Received: by 2002:a17:906:f5a0:b0:b41:a571:21b0 with SMTP id a640c23a62f3a-b41a5712270mr236498266b.39.1759208570375;
        Mon, 29 Sep 2025 22:02:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxIe1/gUAycFtpVQcR4b+NsqR4Pre+MyQnotThndZ321+xPzQyp6FkW4vxaOLRMNcnkRphAA==
X-Received: by 2002:a17:906:f5a0:b0:b41:a571:21b0 with SMTP id a640c23a62f3a-b41a5712270mr236492866b.39.1759208569870;
        Mon, 29 Sep 2025 22:02:49 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353efb88ebsm1061296766b.32.2025.09.29.22.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 22:02:49 -0700 (PDT)
Message-ID: <193cd8a8-2c4c-4c2c-af22-622b74c332ee@redhat.com>
Date: Tue, 30 Sep 2025 07:02:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/17] system/physmem: Un-inline
 cpu_physical_memory_read/write()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 qemu-s390x@nongnu.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-15-philmd@linaro.org>
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
In-Reply-To: <20250930041326.6448-15-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
> Un-inline cpu_physical_memory_read() and cpu_physical_memory_write().

What's the reasoning for this patch?

  Thomas

> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/exec/cpu-common.h | 12 ++----------
>   system/physmem.c          | 10 ++++++++++
>   2 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index 6c7d84aacb4..6e8cb530f6e 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -133,16 +133,8 @@ void cpu_address_space_destroy(CPUState *cpu, int asidx);
>   
>   void cpu_physical_memory_rw(hwaddr addr, void *buf,
>                               hwaddr len, bool is_write);
> -static inline void cpu_physical_memory_read(hwaddr addr,
> -                                            void *buf, hwaddr len)
> -{
> -    cpu_physical_memory_rw(addr, buf, len, false);
> -}
> -static inline void cpu_physical_memory_write(hwaddr addr,
> -                                             const void *buf, hwaddr len)
> -{
> -    cpu_physical_memory_rw(addr, (void *)buf, len, true);
> -}
> +void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
> +void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len);
>   void *cpu_physical_memory_map(hwaddr addr,
>                                 hwaddr *plen,
>                                 bool is_write);
> diff --git a/system/physmem.c b/system/physmem.c
> index 70b02675b93..6d6bc449376 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -3188,6 +3188,16 @@ void cpu_physical_memory_rw(hwaddr addr, void *buf,
>                        buf, len, is_write);
>   }
>   
> +void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
> +{
> +    cpu_physical_memory_rw(addr, buf, len, false);
> +}
> +
> +void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
> +{
> +    cpu_physical_memory_rw(addr, (void *)buf, len, true);
> +}
> +
>   /* used for ROM loading : can write in RAM and ROM */
>   MemTxResult address_space_write_rom(AddressSpace *as, hwaddr addr,
>                                       MemTxAttrs attrs,


