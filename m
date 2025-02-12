Return-Path: <kvm+bounces-37983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9A2A32E3D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 19:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3861C16787C
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 18:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203FF210180;
	Wed, 12 Feb 2025 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aP8d3P6e"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728C32BD10
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384101; cv=none; b=Jga7AB5hPrZXJEVHSUv9XKInCneOZ6vJWLpctSxUnPljajvqMmXmOt3fqa+4fMY0FOLOEBBnUQWsDQNovwW8VbwxwZ/WM6XhQkRyf+DJ0RZRk4ArrvnZNIl0VTMaPxOPpmhgg+ZNmNgsPaoyOsCDGBhjE50+PkAKHtjkJ0g0NdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384101; c=relaxed/simple;
	bh=zLDJRvs70wYqGQ6heh8d49c//0pxVpIdmjoaju2R4Hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IBK4rjFjebpH5Jqc8Ta2UzH+ysASAkwj2gyOwlDSOewMVmCaHGEE0ucJED+YRQ5vhwqdyD0bRsHCnGbm8sxMW7dvuZk9jDJF7RAt/rHMBwUzH3/kzFDhQ0+x9OB7Moh6AJnL+11ju8vYPkWpBloGMZOVyRi8AtYBS+ZxwMwb34M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aP8d3P6e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739384098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XF/40IQWs4BwBtUo6IP+nSgER8pPSwk8DWnA0XWuGiU=;
	b=aP8d3P6e23LhH5ybgwr7O4lkPpn/bfW6xI0mkyb4z0T5WIiHuLLQr3w8X0KM9fdk4VfN9V
	XFzrsGa1/kZ4M/j5VQ+vmhVX624ZEJt8zZEtYL9w47EQ7cTGewU43hmSPKXQn0jZ3nMJXY
	uJOCi9au1lf2T29qBq58xuI0YVSeV6k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-1PC3ZSoENueQ2IgJvHWOZw-1; Wed, 12 Feb 2025 13:14:56 -0500
X-MC-Unique: 1PC3ZSoENueQ2IgJvHWOZw-1
X-Mimecast-MFC-AGG-ID: 1PC3ZSoENueQ2IgJvHWOZw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4393535043bso42365e9.1
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 10:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739384095; x=1739988895;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XF/40IQWs4BwBtUo6IP+nSgER8pPSwk8DWnA0XWuGiU=;
        b=gWeG/rpWlooQxQ+o5E0Fdahm4F0lulG8En6AluBPO/zAB1yAWcnOTd+aha9D6JD+Aw
         WXgf45aUQAf8dXVGEPErHALysIfZYZ0eKpd+yQD0ssXe2/BevKeQ/d08q4aT+FVIpv9Q
         kN/9SFnRYqBPXEkZHphru/ElMWecscL9fE8BOZ8fZI3JiN8F1DFYtkC+UcPcBRw8kDTD
         oXuwjEEkSuZwJhATWy+WfgVy2lImvIXzbMD6oyMGSv1KxXzU5YxM531ECKhYrSiPu8DG
         zblZYmw1lJrGupT5R84lglaT9Z4mM02tBZdbt2JhY/9fmTE9TcGsByeXHNpBpdORSKX7
         e8HA==
X-Forwarded-Encrypted: i=1; AJvYcCUJteicaXMZfDxjn6KmoAd0iMv/owGsqxTVg5qggu3mmTP31Vz6E2/U/9401kfXrmY2gjU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZMwOM5+7bA8UfjNbcaB0QuTSUO74irFY9jO4ehtaOObXqt+i/
	SjNmne5jtOSFrD1E0UDm2TqTn9Kwq1nkgruDfR/VEMmRbTyzI8bsBlhrMc7ZxXlR8i3oOokV3o/
	AZm1NxgmFv5uH2P/Df0/tzsd69rY05mNWx7c5MiYDrw9Patt31w==
X-Gm-Gg: ASbGncvm1NOh+Sm83V+1RNdttsnYWMs2kjJD0UMCuQne50+y/zvHAH/h/QOBm1qQzIN
	nMS/XkpfVZT+M2xdPKMlUz+0cGyEqbwXru3foLrVIR79wIztJygWp7u0ksWBTA8K5Azqt5gv261
	NNMHJT1M8EYBL0S2GTyX3RH8S+hJT39KcJz+iI3avMo5tOB/atZ6LdXrWfV1rhSJcmbCA0I+LvY
	IRrlhk/tYCOWhB082JrD+co91bC1GT8/K4H+tOT9UqGihw5IdAjtETlXTCJb3OkFnwKWmNVWDnP
	pHxhZ7qI77iE+fYxUS/5lXEOJNpBCIG0XQ59cvruN6H4BkkPRhDPr3Xkp5hGSDguqEVXrgAX2Fl
	KBVOZtUOHra0iwAg7Jllz/7yP+urOdw==
X-Received: by 2002:a05:600c:1d14:b0:439:4c1e:d810 with SMTP id 5b1f17b1804b1-43960810b94mr2933955e9.9.1739384095282;
        Wed, 12 Feb 2025 10:14:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECsm6HVlV6IGTPWEYk+a9RY12VPr76t/LEJpemYUy50x0/yVlPvIe/kHC0/vRzhl9a415K9g==
X-Received: by 2002:a05:600c:1d14:b0:439:4c1e:d810 with SMTP id 5b1f17b1804b1-43960810b94mr2933745e9.9.1739384094843;
        Wed, 12 Feb 2025 10:14:54 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:a600:1e3e:c75:d269:867a? (p200300cbc70ca6001e3e0c75d269867a.dip0.t-ipconnect.de. [2003:cb:c70c:a600:1e3e:c75:d269:867a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38deb4f7bacsm2479965f8f.58.2025.02.12.10.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 10:14:54 -0800 (PST)
Message-ID: <f9a6c330-2721-40ed-a8f4-95192e8312a8@redhat.com>
Date: Wed, 12 Feb 2025 19:14:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL v2 09/20] KVM: s390: move pv gmap functions into kvm
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, borntraeger@de.ibm.com
References: <20250131112510.48531-1-imbrenda@linux.ibm.com>
 <20250131112510.48531-10-imbrenda@linux.ibm.com>
 <d5ef124a-d353-4074-925e-a2721be3ce5d@redhat.com>
 <20250212184538.3c79d608@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250212184538.3c79d608@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.02.25 18:45, Claudio Imbrenda wrote:
> On Wed, 12 Feb 2025 17:55:18 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 31.01.25 12:24, Claudio Imbrenda wrote:
>>> Move gmap related functions from kernel/uv into kvm.
>>>
>>> Create a new file to collect gmap-related functions.
>>>
>>> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>>> [fixed unpack_one(), thanks mhartmay@linux.ibm.com]
>>> Link: https://lore.kernel.org/r/20250123144627.312456-6-imbrenda@linux.ibm.com
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>> Message-ID: <20250123144627.312456-6-imbrenda@linux.ibm.com>
>>> ---
>>
>> This patch breaks large folio splitting because you end up un-refing
>> the wrong folios after a split; I tried to make it work, but either
>> because of other changes in this patch (or in others), I
>> cannot get it to work and have to give up for today.
> 
> yes, I had also noticed that and I already have a fix ready. In fact my
> fix was exactly like yours, except that I did not pass the struct folio
> anymore to kvm_s390_wiggle_split_folio(), but instead I only pass a
> page and use page_folio() at the beginning, and I use
> split_huge_page_to_list_to_order() directly instead of split_folio()
>   
> unfortunately the fix does not fix the issue I'm seeing....
> 
> but putting printks everywhere seems to solve the issue, so it seems to
> be a race somewhere

It also doesn't work with a single vCPU for me. The VM is stuck in

With a two vCPUs (so one can report the lockup), I get:

[   62.645168] rcu: INFO: rcu_sched self-detected stall on CPU
[   62.645181] rcu:     0-....: (5999 ticks this GP) idle=0104/1/0x4000000000000002 softirq=2/2 fqs=2997
[   62.645186] rcu:     (t=6000 jiffies g=-1199 q=62 ncpus=2)
[   62.645191] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.14.0-427.33.1.el9_4.s390x #1
[   62.645194] Hardware name: IBM 3931 LA1 400 (KVM/Linux)
[   62.645195] Krnl PSW : 0704c00180000000 0000000024b3e776 (set_memory_decrypted+0x66/0xa0)
[   62.645206]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
[   62.645208] Krnl GPRS: 00000000ca004000 0000037f00000001 000000008092f000 0000000000000000
[   62.645210]            0000037fffb1bbc0 0000000000000001 0000000025e75208 000000008092f000
[   62.645211]            0000000080873808 0000037fffb1bcd8 0000000000001000 0000000025e75220
[   62.645213]            0000000080281500 00000000258aa480 0000000024c0b17a 0000037fffb1bb20
[   62.645220] Krnl Code: 0000000024b3e76a: a784000f            brc     8,0000000024b3e788
[   62.645220]            0000000024b3e76e: a7210fff            tmll    %r2,4095
[   62.645220]           #0000000024b3e772: a7740017            brc     7,0000000024b3e7a0
[   62.645220]           >0000000024b3e776: b9a40034            uvc     %r3,%r4,0
[   62.645220]            0000000024b3e77a: b2220010            ipm     %r1
[   62.645220]            0000000024b3e77e: 8810001c            srl     %r1,28
[   62.645220]            0000000024b3e782: ec12fffa017e        cij     %r1,1,2,0000000024b3e776
[   62.645220]            0000000024b3e788: a72b1000            aghi    %r2,4096
[   62.645232] Call Trace:
[   62.645234]  [<0000000024b3e776>] set_memory_decrypted+0x66/0xa0
[   62.645238]  [<0000000024c0b17a>] dma_direct_alloc+0x16a/0x2d0
[   62.645242]  [<0000000024c09b92>] dma_alloc_attrs+0x62/0x80
[   62.645243]  [<000000002546c950>] cio_gp_dma_create+0x60/0xa0
[   62.645248]  [<0000000025ebb712>] css_bus_init+0x102/0x1b8
[   62.645252]  [<0000000025ebb7ea>] channel_subsystem_init+0x22/0xf8
[   62.645254]  [<0000000024b149ac>] do_one_initcall+0x3c/0x200
[   62.645256]  [<0000000025e777be>] do_initcalls+0x11e/0x148
[   62.645260]  [<0000000025e77a34>] kernel_init_freeable+0x1cc/0x208
[   62.645262]  [<00000000254ad01e>] kernel_init+0x2e/0x170
[   62.645264]  [<0000000024b16fdc>] __ret_from_fork+0x3c/0x60
[   62.645266]  [<00000000254bb07a>] ret_from_fork+0xa/0x40


The removed PTE lock would only explain it if we would have a concurrent GUP etc.
from QEMU I/O ? Not sure.

To fix the wrong refcount freezing, doing exactly what folio splitting does
(migration PTEs, locking the pagecache etc., freezing->converting,
removing migration ptes) should work, but requires a bit of work.

-- 
Cheers,

David / dhildenb


