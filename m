Return-Path: <kvm+bounces-41491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B26A68EBC
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 15:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEBC33B2E7B
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD951ACECF;
	Wed, 19 Mar 2025 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O8L9TE97"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643670808
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742393604; cv=none; b=GLZ11II/VhUhwxznCx5gy579gr8TzrGcVLtITkkznQATYaUPEmxvfBkRAcO4tVjoF8y2DFYf9mtEsHl2pGesR5cHBA/bzNixMtBU6UZ85+kCn0Z0UL/wdMXsrgFYmoAZ+WpCcebtR8znydnUds/VPUeye9LFEfzsSi4bUdrPDEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742393604; c=relaxed/simple;
	bh=UI/QPZUQ1RO4lUeq7vGjY4hYcNWaWekUJ8EP1O8QsR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FuXEUykijBqHl7YvsBoYYanwS5Re/PG2TikssNKizS499lyfMN1Oj67AnF17KgF+ULxYaUBEZdJff74CEloazjopl5zBB78lMrWzSJr0LOZIbdOT+nAb2reXAM55hr4zq8F00xDtjsTYR3kCqXDJjnWAMRUfKSTCO1fx/Psq/Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O8L9TE97; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-391324ef4a0so677260f8f.2
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 07:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1742393598; x=1742998398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9OstO30tAo7/9vCHxwbFM6qIshCsZ9zYJBTHim9aHhQ=;
        b=O8L9TE97gLAil3TESkTDH3HNxXkkj57K3rMl2MVIGP7Y6zojGN3DVxz12F5yJwrPFy
         soAIZTYEIcTB8ip7KTT9AdRULzhp6JQCJuoDjCIwqbuyzJjWUGqA/WOQVYBPrGVAiOGX
         r14cIGKZoyIzoLShFR+1Wh5oamHuub3lULeHxQ6wEaoQ95ai6d+IRI6Bn4tDulxUgLII
         yeB2MBng4UT7q/W0URoOvZKTigKEqwxODkWv5bv+IosZZUKdynPZUchujwnpaoCmU4od
         D5CPHQrbL/Qm7B6D9B7VEsseldJXJHfoAgjvdl5ovSpfmINGnxOG7k7Dp9wQBLKOH0s9
         hN7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742393598; x=1742998398;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9OstO30tAo7/9vCHxwbFM6qIshCsZ9zYJBTHim9aHhQ=;
        b=PCQYZAzjeMw065swayxRkDObO+vINaHnqDWf2sR/NNOWFjxAcDqYmq1mD04QgbgpbW
         228wDxGpmW/aBl1a86JTUgwCJ6mrmYL5ROFYCjKe0MBvfUySMSWNPEj6kh/Q/4sFZIfZ
         Yn5zWiJZUI3ffbLCYBndraRH5OuM+pW+JE7er7oXHep8IMmncqhG9CPSu4SiE0ssn9yI
         /S9fgbW2Lc30UoiVHnIKgN+9YsUQbzBpYHjbdQS3eeXvEe+V5AhZfF/wSQpm/C4AWZnj
         kSEJpLphKfdvUb0XZ8q0Iy23zJYatUwELbfn2CyicTVIvgOne28WZS4sKM4GHUpfLtNw
         h1xw==
X-Forwarded-Encrypted: i=1; AJvYcCWETD/uG4DuU1WugMk1Jd7eR1lxgJJrKY3WhM0mvI37gwPe/+ptIkcyf6QBfmNkhOGZC2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYx7MsQB4ZAjpWEGgYRsR+v/wMtv6bYXrleO/flvxx+Fl8xwYC
	ZPO7LEsood84pTpL7zrBnBDQq7NkeGmGyoJknrKSq/5qtxQ7bHbvUqzwCY4N8ik=
X-Gm-Gg: ASbGncv/tBszUcvdS0vVSCcLJopMSab/kfxxBTVUK+Y+fIjP/YY03kzSFFImBLuhXya
	hNYj99H5hwMIPKX4wv/ZDpj6+6iFjwJ9o3RoQF/9x4YAQQPV64VmFAVBsQKisGnsXKWDk2PimpB
	eeerIstwzTqf7M7LfpUG+rG9m0fO0u2YbOzTBIqi7DULtWG3+mEOqCgRSdq5RUO3+vuI7aFuYST
	ESu3f7tTbjTF6z3qKcnQVDneunDQr0JNguFZuLU50o+Bnx52qS95lIIWhU0LG4t7FO5V6hAQXGY
	eaBk/jn+eMojTx67jrqjNUrTCSSbNwapjf9ZO4WOErItTqUwIIg38mLv1g==
X-Google-Smtp-Source: AGHT+IHFxgaYZzxs4YrpiFNRj0Fx2NFb0UkPZ9Vif77efpxRvlTMuWdyMNOWysr1nOYN4sdEHhbzKQ==
X-Received: by 2002:a05:6000:186f:b0:391:2b54:5fb5 with SMTP id ffacd0b85a97d-39973b467b4mr1053746f8f.10.1742393598245;
        Wed, 19 Mar 2025 07:13:18 -0700 (PDT)
Received: from [192.168.178.35] ([37.120.43.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb318a8bsm21553323f8f.66.2025.03.19.07.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 07:13:17 -0700 (PDT)
Message-ID: <2789a91d-3394-4be9-bedf-cfe1759e418d@suse.com>
Date: Wed, 19 Mar 2025 15:09:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/4] Enable Secure TSC for SEV-SNP
To: "Nikunj A. Dadhania" <nikunj@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250317052308.498244-1-nikunj@amd.com>
 <fd404afa-7a42-4fa9-8652-519649482d75@suse.com>
 <8b312f7d-428a-aeab-cf26-412f8d8270e6@amd.com>
 <e8385f73-2c41-4ee9-9350-4f3b9c0b9a19@amd.com>
Content-Language: en-US
From: Vaishali Thakkar <vaishali.thakkar@suse.com>
Autocrypt: addr=vaishali.thakkar@suse.com; keydata=
 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
In-Reply-To: <e8385f73-2c41-4ee9-9350-4f3b9c0b9a19@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/17/25 4:21 PM, Nikunj A. Dadhania wrote:
> Hi Vaishali,
> 
> Thanks for testing the patches.
> 
> On 3/17/2025 8:37 PM, Tom Lendacky wrote:
>> On 3/17/25 07:52, Vaishali Thakkar wrote:
>>> On 3/17/25 6:23 AM, Nikunj A Dadhania wrote:
>>>>
>>>
>>> Hi Nikunj,
>>>
>>> I've been trying to test this patchset with the above QEMU command line
>>> and with the OVMF built from upstream master. But I'm encountering
>>> following errors:
>>>
>>> " !!!!!!!!  Image Section Alignment(0x40) does not match Required Alignment
>>> (0x1000)  !!!!!!!!
>>> ProtectUefiImage failed to create image properties record "
>>
>> I bisected EDK2/OVMF and found that the above messages started appearing
>> with commit 37f63deeefa8 ("MdeModulePkg: MemoryProtection: Use
>> ImageRecordPropertiesLib")
>>
>> It doesn't appear to cause any issues while booting as I'm able to
>> progress to the grub menu and boot the OS. Is it failing for you?
>>
>> Thanks,
>> Tom
>>
>>>
>>> I briefly looked at this[1] branch as well but it appears to be no longer
>>> actively maintained as I ran into some build errors which are fixed in
>>> upstream.
>>>
>>> The build command I'm using to build the OVMF is as follows:
>>> build -a X64 -b DEBUG -t GCC5 -D DEBUG_VERBOSE -p OvmfPkg/OvmfPkgX64.dsc
>>>
>>> So, I was wondering if you've some extra patches on top of upstream OVMF
>>> to test SecureTSC or are there any modifications required in my build
>>> command?
> 
> No, I do not have any Secure TSC related modification in OVMF. If it can boot
> SNP, that should work for Secure TSC guests as well.
> 

Thanks both for confirming that those OVMF messages were a red herring. It 
helped
me uncover an issue unrelated to this patchset. I have been able to test this
patchset successfully now. For the whole patchset, please feel free to add:

Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>

> Regards
> Nikunj
> 
>>>
>>> Thank you!
>>>
>>>
>>> [1] https://github.com/AMDESE/ovmf/tree/snp-latest
>>>


