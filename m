Return-Path: <kvm+bounces-36095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9333BA17A1F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 10:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AC8F188B88B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 09:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B3111BEF91;
	Tue, 21 Jan 2025 09:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GDyeM+Zy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8F1BE251
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737451602; cv=none; b=uqjZv7ks+cV/hgVOKXRfEwJn2magvRAU9P0X7jGPQhgYvnt1ekJDlZaos60GbXeIy0D5/5D4jn7+nx2+/srAacqRaWJmg+h3HoiWVCrd4NjXrgTDx42uV5nPdW0mTnoJTGzXLpjyizxeGdPbj2yzApWOC5UAfHIPETTWyxgxDt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737451602; c=relaxed/simple;
	bh=+4qHIO/5yaoxVj9LY5aXGgBGmztqDImqyvEQ4eH6te0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IZeYhP0ZhsvvA7g9S6BmjdjwZOJCbgNgCEhQ9ckIG30vJ7V143kAQ7ocEd7WzrKpTOVuo9Sn1yDGm66XSFmFmqEpZ7iXoouxUHWqZQKY7eLkvpo+SsvdaXCkep8WvHrJYgk7z4xcAjX9D7o204D0DANoinuuVnMmxEujqUUPNXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GDyeM+Zy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737451599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Nv+vRHKxKx7LPGUXqTR2Bw4vWrO1fycMkwgZg/uT7Sc=;
	b=GDyeM+Zy1SDO4wwv4RuCPGikVj2F6wPsGFwRxS1R0oYO1xFvafgxoLMPz6MMQ/qNiKQBuz
	xV333uWFATjsSmQ9Y9bS4TDoPBm7PxB4y1oUJhr3jqn8u2KMjZodJLI4cLSfue3LorMXO5
	2WIaImF3w/8wEgj/SfbZg3hL7GyrWb0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-JqrfnQqHNhulkZ5BPjqd3g-1; Tue, 21 Jan 2025 04:26:38 -0500
X-MC-Unique: JqrfnQqHNhulkZ5BPjqd3g-1
X-Mimecast-MFC-AGG-ID: JqrfnQqHNhulkZ5BPjqd3g
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38bf4913659so2982950f8f.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 01:26:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737451597; x=1738056397;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nv+vRHKxKx7LPGUXqTR2Bw4vWrO1fycMkwgZg/uT7Sc=;
        b=Ip8wyt4CFFwameBXBqU91yE8gNji6ycRKPrGVB21aKC/Hvn3aG58ULvb7U/bNJYB2D
         XXRUCKqmZU9Mll5/27bI6rJGrTsPIl5GCsc4YthM3Q+odDoDl4JtXROlLSCYua4jZL29
         e7CIR86U0Hsbj4Hmkms27LLXVYXin2ttm12AWOGaFjqEiVhNyot6Nxyc4LL7Q6As6IPY
         DNyZbyXgez8IJhmeC4mhqM1TQUIzo1Bp/qoGx0je7ToCr6qDkeKz8chh3Kvwz0GcwYxr
         MMTQrbi1/HkE9MfeMtsyBsVitCfmvsd0DlLLJkylqiuiNKfp5uG6zS2gKynNmSNgNdjw
         eL9g==
X-Forwarded-Encrypted: i=1; AJvYcCW2lp8k8X4C4StTTsfPOFUQ1kSUumSV2MoSQWPrZcNmR3IX8VV4kg/K4XQ7p687bdZ+Yd0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcmbF9e7dDbN/7rNWzyd2PJePSRv4P9lJ7H/fBXb9OSvk+ovBq
	wpEAQXN+WW26kwWrJhZnEfzX2bzRw69Tl2itMIHeA4havohg9Ay9L4X+rDxzFBKFbAoyXzRvmRZ
	d9FBK1HeEwbdXKLiw/qWD+bc8HYapZbLDZjNuKjIHDZUih+bwVw==
X-Gm-Gg: ASbGncuBOLbLSVoIpX3S3bGilhA51Vhd5vRtYFXmQi4PxnVkMHEwmYhhj2tt+udnHF7
	9y6eDGyOQn67bwGlZx3xEgkoif0zUGvEflmlMdYnunGTLLXnAs6pp0WspVVGiyIeVLoQQFVJfV2
	8zqvLBGsdt1SRHzCUC6o4MixqhhHdDhNakvnd8AC2BpUjQ4eBinwng2kk5cDtqF6YmyDAjvZyAC
	Jl7l0aRmL44IUy+ISbx4c5iVxHbjo/yhDRa+ESNEA+So6TIjHlHPrxAsrzmVbOsdos3TU+bGZpO
	dpg1/6We0dE94K+9lyjHx+eZ2SHDChLTpJvaksiV65S7BPXt2uYQrGTkmeU4t+VCon4SJ7vLS26
	FMihAzJmPi/BkLhExo+unnQ==
X-Received: by 2002:a5d:5f51:0:b0:38b:eb7b:316 with SMTP id ffacd0b85a97d-38bf59eccbamr15367909f8f.47.1737451596896;
        Tue, 21 Jan 2025 01:26:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1YGWQ/myVTZz6NZIjxD3S9whG+HZs8L0xT3L+XauL+Rs1R39z72BwXihfmUS63EBCKHTwjw==
X-Received: by 2002:a5d:5f51:0:b0:38b:eb7b:316 with SMTP id ffacd0b85a97d-38bf59eccbamr15367880f8f.47.1737451596582;
        Tue, 21 Jan 2025 01:26:36 -0800 (PST)
Received: from ?IPV6:2003:cb:c709:6200:16ba:af70:999d:6a1a? (p200300cbc709620016baaf70999d6a1a.dip0.t-ipconnect.de. [2003:cb:c709:6200:16ba:af70:999d:6a1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3278088sm12842925f8f.73.2025.01.21.01.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 01:26:35 -0800 (PST)
Message-ID: <7176db79-cd04-4968-a61a-a753e3668564@redhat.com>
Date: Tue, 21 Jan 2025 10:26:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Chenyi Qiang <chenyi.qiang@intel.com>, Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com> <Z46RT__q02nhz3dc@x1n>
 <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.01.25 10:00, Chenyi Qiang wrote:
> Thanks Peter for your review!
> 
> On 1/21/2025 2:09 AM, Peter Xu wrote:
>> Two trivial comments I spot:
>>
>> On Fri, Dec 13, 2024 at 03:08:44PM +0800, Chenyi Qiang wrote:
>>> +struct GuestMemfdManager {
>>> +    Object parent;
>>> +
>>> +    /* Managed memory region. */
>>> +    MemoryRegion *mr;
>>> +
>>> +    /*
>>> +     * 1-setting of the bit represents the memory is populated (shared).
>>> +     */
>>> +    int32_t bitmap_size;
>>> +    unsigned long *bitmap;
>>
>> Might be clearer to name the bitmap directly as what it represents.  E.g.,
>> shared_bitmap?
> 
> Make sense.
> 

BTW, I was wondering if this information should be stored/linked from 
the RAMBlock, where we already store the guest_memdfd "int guest_memfd;".

For example, having a "struct guest_memfd_state", and either embedding 
it in the RAMBlock or dynamically allocating and linking it.

Alternatively, it would be such an object that we would simply link from 
the RAMBlock. (depending on which object will implement the manager 
interface)

In any case, having all guest_memfd state that belongs to a RAMBlock at 
a single location might be cleanest.

-- 
Cheers,

David / dhildenb


