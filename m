Return-Path: <kvm+bounces-41763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B67A6CC8C
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 21:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B3C3B0FEF
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 20:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806DC2343C9;
	Sat, 22 Mar 2025 20:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JMlk8owM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD3A29405
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 20:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742676943; cv=none; b=XBxqz91JO+JVqnc/Pu79YgPThvYXpU17FWumewVM7vACFyFANve9dAK55qz0kuMJ7dmdQbmrz+mzrN9pHAQqr2N2+Bero9LrpNGgImab6ArdD7VwtVIX+ua49LFqTNmOfP4M6/TBC09S+/ftcFksSqib/JD07RA1YmEiPrELGsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742676943; c=relaxed/simple;
	bh=MtskfZeQW4nfvlI8qS1LHIZzJ/KLCdghCrjEztI+WO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bGP/DeaFvn750xSVhddVSBl/D1YcPbk69Ix1Q3kezt9pWY6yj04Csn4ssF4jVL37KTXCF/Fe+Vu4xfiH0SYhvR8cKesK6/yRi9GUR8OEDEiW+OyghafOCC7JGQ9Jkc9DAJKMWBjXkzoHIrqGqDbDlFFoNjljrLhMNE6gzvohZ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JMlk8owM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2264aefc45dso40748065ad.0
        for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 13:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742676941; x=1743281741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kgGmWC6PM5wLnaG1uyNrtF3HfvNjTFidfhpw5ptOU8I=;
        b=JMlk8owMJ72v8SqiljD3Be4nyVE3zoAtvUiJOK1t94CbMspFqhIHzv271CFaTCSvER
         m5jnI2IzRoQhq6Ra5PCxoURRu+Uyl2QfDdJmcjJV+ac4PdFjvI/MBIfEaZ58IU6qPNhk
         oN0wkqwwEWGI4ymo2lSOtiQzGu0zdf44kQGWN2pVwWS090V6SxQQZmQAKFw524zVzAUA
         rhLLOz2s0C5qARSsr52XqRBBEM4ZT30qHW+mSNwOoLPQFDuzAUsOH/z8DGdZgPZub0ZB
         xRw+f/cVfI19mF5E6ASMQhcK914b8kQ/qxWzq9pChGzZZhZAO+MvPYB0lSEz67K/NNqR
         LurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742676941; x=1743281741;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgGmWC6PM5wLnaG1uyNrtF3HfvNjTFidfhpw5ptOU8I=;
        b=DTdll27VDJXSpuTWfjiOsUX+SrUT+Debejr+mldVdVxW8bOyuiUvKfrsFk3nzljdXN
         jTOa/daFzOHRYpZk744r57RpcWJKlKkNKOs5UcGoFWq0HI+DYjCzuO9CI3c2L+QCE4jR
         Mk8DI6XkQxDQOsfdpyIYphMrrDwk3d1fEXASdCpYkimrVYjEAyy7DqMJdPwjWVSFmp9W
         H/hW38B5I3Z+/wRIvsBwDWR3d4gpkiYMQ/J/w4CbyFm5IIdGiRip3NbQbOxZFgm30XaW
         znxZFGUllmyL/k2MVBhTjsjbQh2X+WpUL3YdY4Z7EvJQNWCZqOhAomwwM9MCZARJnYsS
         bzgg==
X-Gm-Message-State: AOJu0YwtU5uGTXWRoEA+1sVdektNjq5cMnWbgvt8OLs5hNnahwi6/yRf
	iczV2TYquBqeQ/Uk7xqJLFsX14W+dJtcE/+mHPGRHxOY4445vaHLuV+V/cZRWEQ=
X-Gm-Gg: ASbGncuVxM5ne4gnRp+dmIboVluRY/uuts04KNuZnVLwmIzNvyB5S4qF9U89OBao5BS
	KCt2VuHbJ5Uqycl8d/zq/Vjfq8/Tqiirb/WfOL9vcfzOVnmUKmjEBu7ITQDR/MtA2R7hRkRYwVZ
	25Q6vFvP0ZeUEFVtCX5psW5xHc/yp466Pb0sNnzsmRQCKrIScWSpUG/exiT5HWe8C4uyUMK+sya
	/nnjjXW3A0Of+zVgj0SETjneKYjApnOxduQVTblFlwqZtNo7g7GaM2z+2OaISDZ//pLM8iGLEGl
	tOFzki6/FmqwHOI+JZS4oUkricaPm2F+npF7t+xy2G/4VK39GfitgM8Net+SC/9JvmZsyxQJLps
	yNEPJt6tx
X-Google-Smtp-Source: AGHT+IF8bW/hQCXsQIR/yUOm9ZATK+QQ55egz4OhUwbr//UE3L/jkw+NaL2jvImzW0JB60ZAK94q9g==
X-Received: by 2002:a17:903:298b:b0:223:5a6e:b16 with SMTP id d9443c01a7336-22780c55886mr145113575ad.5.1742676941062;
        Sat, 22 Mar 2025 13:55:41 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f3b242sm40132835ad.41.2025.03.22.13.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Mar 2025 13:55:40 -0700 (PDT)
Message-ID: <392cd6e5-0c73-4702-8733-d3047db76f77@linaro.org>
Date: Sat, 22 Mar 2025 13:55:38 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
 <2e667bb0-7357-4caf-ab60-4e57aabdceeb@linaro.org>
 <e738b8b8-e06f-48d0-845e-f263adb3dee5@linaro.org>
 <a67d17bb-e0dc-4767-8a43-8f057db70c71@linaro.org>
 <216a39c6-384d-4f9e-b615-05af18c6ef59@linaro.org>
 <c0e338f5-6592-4d83-9f17-120b9c4f039e@linaro.org>
 <ebd25730-1947-4360-af36-cf1131f4155c@linaro.org>
 <c1b7b73e-0a59-46cf-bf33-5712df5d9b75@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <c1b7b73e-0a59-46cf-bf33-5712df5d9b75@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/25 17:20, Pierrick Bouvier wrote:
> On 3/21/25 17:01, Pierrick Bouvier wrote:
>> On 3/21/25 15:19, Richard Henderson wrote:
>>> On 3/21/25 13:11, Pierrick Bouvier wrote:
>>>> On 3/21/25 12:27, Richard Henderson wrote:
>>>>> On 3/21/25 11:09, Pierrick Bouvier wrote:
>>>>>>> Mmm, ok I guess.  Yesterday I would have suggested merging this with page-vary.h, but
>>>>>>> today I'm actively working on making TARGET_PAGE_BITS_MIN a global constant.
>>>>>>>
>>>>>>
>>>>>> When you mention this, do you mean "constant accross all architectures", or a global
>>>>>> (const) variable vs having a function call?
>>>>> The first -- constant across all architectures.
>>>>>
>>>>
>>>> That's great.
>>>> Does choosing the min(set_of(TARGET_PAGE_BITS_MIN)) is what we want there, or is the
>>>> answer more subtle than that?
>>>
>>> It will be, yes.
>>>
>>> This isn't as hard as it seems, because there are exactly two targets with
>>> TARGET_PAGE_BITS < 12: arm and avr.
>>>
>>> Because we still support armv4, TARGET_PAGE_BITS_MIN must be <= 10.
>>>
>>> AVR currently has TARGET_PAGE_BITS == 8, which is a bit of a problem.
>>> My first task is to allow avr to choose TARGET_PAGE_BITS_MIN >= 10.
>>>
>>> Which will leave us with TARGET_PAGE_BITS_MIN == 10.
>>>
>>
>> Ok.
>>
>>   From what I understand, we make sure tlb flags are stored in an
>> immutable position, within virtual addresses related to guest, by using
>> lower bits belonging to address range inside a given page, since page
>> addresses are aligned on page size, leaving those bits free.
>>
>> bits [0..2) are bswap, watchpoint and check_aligned.
>> bits [TARGET_PAGE_BITS_MIN - 5..TARGET_PAGE_BITS_MIN) are slow,
>> discard_write, mmio, notdirty, and invalid mask.
>> And the compile time check we have is to make sure we don't overlap
>> those sets (would happen in TARGET_PAGE_BITS_MIN <= 7).
>>
>> I wonder why we can't use bits [3..8) everywhere, like it's done for
>> AVR, even for bigger page sizes. I noticed the comment about "address
>> alignment bits", but I'm confused why bits [0..2) can be used, and not
>> upper ones.
>>
>> Are we storing something else in the middle on other archs, or did I
>> miss some piece of the puzzle?
>>
> 
> After looking better, TLB_SLOW_FLAGS are not part of address, so we don't use bits [0..2).
> 
> For a given TARGET_PAGE_SIZE, how do we define alignment bits?

Alignment bits are the least significant bits that must be 0 in order to enforce a 
particular alignment.  The specific alignment is requested via MO_ALIGN et al as part of 
the guest memory reference.

I think the piece you're missing is the softmmu fast path test in the generated code.

We begin by indexing the tlb to find an entry.  At that index, the entry may or may not 
match because (1) we have never looked up the page so the entry is empty, (2) we have 
looked up a different page that aliases, or (3) the page is present and (3a) correct, or 
(3b) invalidated, or (3c) some other condition that forces the slow path.

The target address and the comparator have several fields:

   page address   [63 ... TARGET_PAGE_BITS]
   page flags     [TARGET_PAGE_BITS - 1 ... TARGET_PAGE_BITS - 5]
   unused         [TARGET_PAGE_BITS - 6 ... align_bits], or empty.
   alignment      [align_bits - 1 ... 0], or empty

In the comparator, the unused and alignment bits are always zero; the page flags may be 
non-zero in order to force the comparison to fail.

In the target address, we mask the page flags and unused bits; if the alignment bits of 
the address are set, then the address is of course unaligned and so the comparison fails.

In order for all this work, the alignment field cannot overlap the page flags.

The maximum alignment currently used by any guest is 5 bits, for Arm Neon,
which means the minimum value for TARGET_PAGE_BITS_MIN is 10.


r~

