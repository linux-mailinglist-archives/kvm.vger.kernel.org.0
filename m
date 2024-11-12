Return-Path: <kvm+bounces-31680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D70A9C659A
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 00:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9931AB273BC
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C63421A707;
	Tue, 12 Nov 2024 22:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K25k6ToA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A3121B440
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 22:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731449201; cv=none; b=OTZuEptJmuzLkgZzu/A/FFfDKEqqUMIaJ793tbADUUmXIFzCxiDJGsFJCcqndOPv1+sXxuD2KpbBUPoDfp4kBUsuIAVHKjKh82W6hAiNxVlR7YA343NvPt7JRxo8Qpl5oPaZOIq8gxWkRaltdUEqAX2OXLS14smPiFv+Hj1CBKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731449201; c=relaxed/simple;
	bh=vz7qMESYRlq1Sb4MFd2Gx9sSfTee0xWNkhvLD4Ti3UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXpt4+k/DV34Jt2OQL3giATj/PTNNq6PTBqnyjwazSvt2XIruI0Lb+e8sn1trc46eqKxFXMXWljSZuqZPGtcZSBQ/RU8xccto7TzCfQU1eNI27ZSEVRJDSN8Z+WIBI0t8XE42Rwo9nUNB0IRrw7fzgLv9glYL3v2gDpqJIxCiHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K25k6ToA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731449197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ahnn79TADEjKAzoyWfeCGkoaSmp2qpuLj1GWLCV4zsc=;
	b=K25k6ToAa2FnvuFQBm6OtQ1g//h4eCiQnof5PIFGhrRhhcnYr5wcrzQkgRooWmhlCzbVws
	LkVJjSN/5S7Zeo25te+ycXr5nfDHVU3b5F107AQKMT3zyHbmeNTNdOKY5O6WdpkJwK+jzX
	eosvtnUJkC1tcqoyuFhrJnsYvh92XKA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-BQCQI9F_NaKZ5xeUdmpqUw-1; Tue, 12 Nov 2024 17:06:36 -0500
X-MC-Unique: BQCQI9F_NaKZ5xeUdmpqUw-1
X-Mimecast-MFC-AGG-ID: BQCQI9F_NaKZ5xeUdmpqUw
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d432f9f5eso3194086f8f.0
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 14:06:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731449195; x=1732053995;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ahnn79TADEjKAzoyWfeCGkoaSmp2qpuLj1GWLCV4zsc=;
        b=hKbwBm9UI22KlhYwb3qYuZNLjLuJybCTmP7IgUCwdFU201prl8Vp6Y5Uo5t8jaq3z1
         197bcz3I3OTzcPJZHvCj6+A9HOo5zYE5B6UZ7prfQweGEOCuBGXSesjc5eNMKBVHS9qk
         B/aFFh185YADYXGoz9gA4kzhmi+ooipJVwsOdgydCAjV4TqTSPLxFPh15eAVcXFFEhUH
         9MqN6IusP1y9OAw6SAoyENIJmjbzirnQeWef1pR1HsQ9JaZMD562Th4fAaKEiN+9FNI7
         pIPtWzIrQfx4/2JPWdUyPHTa2yrilpNxX2ajfOhuc+CdyIoFVedaoVRAWBq7jj5hkJGv
         XjLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZchdh4Ei4w6oer7jzLl5ybHPIOpWtZzVSqonLEedYET0tGvyhPPWMkqqkhMgSnLT3sZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHk2Un6f9y/HXJ5rM+AwjxuEVFv+5aMYqka5euntf3ssVIc4Jz
	cmf6baziyL9wa8vN0lwiRzG6ntTBmhKjNjP7UDbieHaxGQbhavEnRW6BfJfXPCkeoPwqcG620LR
	XWvA/PS1TkQxwxKBQecm7yjE40IlCEjE5JGHXGtf22OoOMLYT3Q==
X-Received: by 2002:a5d:6d8e:0:b0:37c:d12c:17e5 with SMTP id ffacd0b85a97d-3820811217emr3588740f8f.23.1731449195601;
        Tue, 12 Nov 2024 14:06:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHcbBebpMtner29jbOwvoyZcdoK71kVKtklpF2i0Z+c9Kj4VQT14/d0Qj2MnJAVQiKajPTQIQ==
X-Received: by 2002:a5d:6d8e:0:b0:37c:d12c:17e5 with SMTP id ffacd0b85a97d-3820811217emr3588720f8f.23.1731449195206;
        Tue, 12 Nov 2024 14:06:35 -0800 (PST)
Received: from ?IPV6:2003:cb:c739:8e00:7a46:1b8c:8b13:d3d? (p200300cbc7398e007a461b8c8b130d3d.dip0.t-ipconnect.de. [2003:cb:c739:8e00:7a46:1b8c:8b13:d3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d55417f3sm793925e9.34.2024.11.12.14.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 14:06:33 -0800 (PST)
Message-ID: <fb1529d9-4c92-4bdd-8dae-404a49cfd7b3@redhat.com>
Date: Tue, 12 Nov 2024 23:06:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] system/physmem: poisoned memory discard on reboot
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-3-william.roche@oracle.com>
 <b0e80857-b9cb-4e93-81bd-93e8dc4b1d51@redhat.com>
 <a79a2639-a6f1-4ca1-9b12-d4e125d894d4@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <a79a2639-a6f1-4ca1-9b12-d4e125d894d4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>> For shared memory we really need it.
>>
>> Private file-backed is weird ... because we don't know if the shared or
>> the private page is problematic ... :(
> 
> 
> I agree with you, and we have to decide when should we bail out if
> ram_block_discard_range() doesn't work.
> According to me, if discard doesn't work and we are dealing with
> file-backed largepages (shared or not) we have to exit, because the
> fallocate is mandatory. It is the case with hugetlbfs.
 > > In the non-file-backed case, or the file-backed non-largepage private
> case, according to me we can trust the mmap() method to put everything
> back in place for the VM reset to work as expected.
> Are there aspects I don't see, and for which mmap + the remap handler is
> not sufficient and we should also bail out here ?

mmap() will only zap anonymous pages, no pagecache pages. See below.

>>
>> Maybe we should just do:
>>
>> if (block->fd >= 0) {
>>       /* mmap(MAP_FIXED) cannot reliably zap our problematic page. */
>>       error_report(...);
>>       exit(-1);
>> }
>>
>> Or alternatively
>>
>> if (block->fd >= 0 && qemu_ram_is_shared(block)) {
>>       /* mmap() cannot possibly zap our problematic page. */
>>       error_report(...);
>>       exit(-1);
>> } else if (block->fd >= 0) {
>>       /*
>>        * MAP_PRIVATE file-backed ... mmap() can only zap the private
>>        * page, not the shared one ... we don't know which one is
>>        * problematic.
>>        */
>>       warn_report(...);
>> }
> 
> I also agree that any file-backed/shared case should bail out if discard
> (fallocate) fails, no mater large or standard pages are used.
> 
> In the case of file-backed private standard pages, I think that a poison
> on the private page can be fixed with a new mmap.
> According to me, there are 2 cases to consider: at the moment the poison
> is seen, the page was dirty (so it means that it was a pure private
> page), or the page was not dirty, and in this case the poison could
> replace this non-dirty page with a new copy of the file content.
> In both cases, I'd say that the remap should clean up the poison.

Let's assume we have mmap(MAP_RIVATE, fd). The following scenarios are 
possible:

(a) We only have a pagecache page (never written) that is poisoned
	-> mmap(MAP_FIXED) cannot resolve that

(b) We only have an anonymous page (e.g., pagecache truncated, or if the
     hugetlb file was empty) that is poisoned
	-> mmap(MAP_FIXED) can resolve that

(c) We have an anonymous and a pagecache page (written -> COW).
(c1) Anonymous page is poisoned -> mmap(MAP_FIXED) can resolve that
(c2) Pagecache page is poisoned -> mmap(MAP_FIXED) cannot resolve that


So mmap(MAP_FIXED) cannot sort out all cases. In practice, (a) and (c2) 
are uncommon, but possible.

(b) is common with hugetlb. (a) and (c) are uncommon with hugetlb, just 
because of the nature of hugetlb pages being a scarce resource.

And IIRC, (b) with hugetlb should should be sorted out with 
mmap(MAP_FIXED). Please double-check.

> 
> So the conditions when discard fails, could be something like:
> 
>      if (block->fd >= 0 && (qemu_ram_is_shared(block) ||
>          (length > TARGET_PAGE_SIZE))) {
>          /* punch hole is mandatory, mmap() cannot possibly zap our page*/
>           error_report("%spage recovery failure addr: "
>                        RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>                        (length > TARGET_PAGE_SIZE) ? "large " : "",
>                        length, addr);

I'm not sure if we should be special-casing hugetlb.

If we want to be 100% sure, we will do

if (block->fd >= 0) {
	error_report();
	exit(1);
}

But we could decide to be "nice" to hugetlb and assume (b) for them 
above: that is, we would do

/*
  * mmap() cannot zap pagecache pages, only anonymous pages. As soon as
  * we might have pagecache pages involved (either private or shared
  * mapping), we must be careful. However, MAP_PRIVATE on empty hugetlb
  * files is common, and extremely uncommon on non-empty hugetlb files,
  * so we'll special-case them here.
  */
if (block->fd >= 0 && (qemu_ram_is_shared(block) ||
     length == TARGET_PAGE_SIZE))) {
	...
}

[in practice, we could use /proc/self/pagemap to see if we map an 
anonymous page ... but I'd rather not go down that path just yet]

But, in the end the expectation is that madvise()+fallocate() will 
usually not fail.

-- 
Cheers,

David / dhildenb


