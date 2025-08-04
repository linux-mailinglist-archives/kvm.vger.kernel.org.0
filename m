Return-Path: <kvm+bounces-53889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F089B19E9E
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 11:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90979178766
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 09:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7093A23FC66;
	Mon,  4 Aug 2025 09:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="upcHJXwv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9A2036E9
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 09:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754298989; cv=none; b=F8H+JRIXx26rb3IaIeE/ZqKS0J8kMehm2LkgpIPmmlPMostNjKFuVZyZ48hUdQjMp+wwb5MDSuTVTaSqFoOimBWrl9DuYHwdDWoB74G0CdOb9gAQu6giZpdDQR5PFzR4IdZJdD7PQB2fWvE0PP4L1sPrI8eSMajZVBsFDeyBm7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754298989; c=relaxed/simple;
	bh=6btEnBaLQge5Ota5TiOhwS7x5AH8q2Hq8ygdnvPmMO8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KTcbC8bfOsAKBI/ViTh0EZn/Gb9xrSuPI02cN8dVkEW+JWNoRBJVNosDbSVWkmKRtZ/H87Y2jXi1gOjhZcvywB/xAUfX1grqTz1yjMd5ofY5ZWJ3TJfaDbqoTl+GxycycRSGYuPTJb7DUaPLOyHLxEao0NnW766BBqdxKbPpgCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=upcHJXwv; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7e6696eb4bfso309651585a.2
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 02:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1754298986; x=1754903786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NSPtN0kwWtvNDBd+lpKApr9yaknC2JKVLS9pzdP+iSI=;
        b=upcHJXwviUV2OCnU4ndJ9H35xWC9za1s10cwVECaep6Jl/GllAvO/igw2LgmJPyoOE
         kD8tMjn5v+nr669BFLzGZSwJJB45LuiHQET3s7y++28TAdDJHazrVq7nVI20sXyS1zq1
         8nKEPwf6VZTxkAI+mi/YFdCkk24eg2DQZZwxme4fMPGnfZLHeZjWThR9YnO3awkl0hNH
         crFq18SJVZpX8X5J0jhW8PBhjtJrOlDzcOmD2TRv7Bz7i8SLvBze/5acAS0sqakftWRu
         Tuqb0uPwWHik3BSa/k1g6loyLjJO7YBLKsVSv4T+uwHAOcnmHD9Y1zOc1fQSfe1KxpzO
         mfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754298986; x=1754903786;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSPtN0kwWtvNDBd+lpKApr9yaknC2JKVLS9pzdP+iSI=;
        b=Z6hhc8/iy+Kym4xn9ZdP1eqWmagn//1aBUBUSd9c4FHG5jhdnyHH6HGUdKeY/gkQLH
         ambR+5Pclm8DcJQU4+2jT8pPNIsmkpHzBWlS+4m5e1hs8Q1uJn3Z/I9aJzB1BmtQ2RVC
         8M6gOKzOuBeKNZYpl0mUddBeKUmErTNQMCB9XgHvDz007W5DAxG/jN662BCwJrRMawtL
         1XLEhst31wRMnFQFQa8OnCID2p8rM4Ah2a7vdFdwd2N3mLQykMoF3nJT/zshWFFqaM4G
         96cd8qURlbksHZzGwssHHHl6bHxL0969NBWIPFtSCTBW7o99oM4FeITrkxoBkCneyi1M
         +G/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUk7wgFIhQZ0blS9McWxXEywNFam6B76tMo4trMvLeUXC0BVV/YcKUQ/5h+HfUUQgJsHEc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhlA96bM44GsQONE+z4Ds3Z+rWBfwsvKl5Po3TfgW2ApiobiqQ
	Py5f7gU9iA5lafFaF6moAX5LyCmYn2TM6Lce3F+SE2hSN4o8xXKkBMoorHRrQe6Go1o=
X-Gm-Gg: ASbGnctXNFEiwDiCPEGbbMdRVv2DkoxTgwzTs23w7ZSlVLgmx4k+Lf/5vneOdEWHd+1
	9zxn/vWl58kQVD5EzZXpoK7hUOiY5UnMPM5kp27QhXgfiuV661Efky+MRzQhoa1sZdm/vzW8c1v
	uWSy3Lm2//zmOIUJuwF8ciB4hUWUwtJArCpY3d4JgivXo8sYZK7RZsMVJZThBjeMMNtAUfEyENI
	AhwdID7FuEas/dixhTQiTv8aZZ2OKe2qJeT1rQ2JOEOPxGqnZSmD892TTCvs+PpD410dbEW+siN
	73hLn1z1ndxVeybaAQ4zUnBbGIzxQmEW5gBtY9Mdx/bn9N77FMFJGdtv2jnSqFI8aBAlx3ldT7M
	r9Oqj9P5WxMBTs9d4QQ3rDRNTQ1yeQJFrNtb/h8NAgqV5cMRPtvx56S7groecFEJ5PCrq+bgPuL
	ltEUCv7kAvUMtBIp7M9jqf0MPOU+n6H8Vz2PLxipz/NAaKjItuhUckRAY=
X-Google-Smtp-Source: AGHT+IGTopjFjRqcg4szc6xtYjmVRr/+qF9GoJYZct1NGmlBsIGmn39Z+j/4xEoL90Wd9djgyiYXsQ==
X-Received: by 2002:a05:620a:471f:b0:7e8:48d:85f0 with SMTP id af79cd13be357-7e8048d8bf7mr172974485a.4.1754298986305;
        Mon, 04 Aug 2025 02:16:26 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7f9d4ea94sm142643385a.89.2025.08.04.02.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 02:16:26 -0700 (PDT)
Message-ID: <1bc67fb2-088d-4d6d-838c-d826aa8eb03c@grsecurity.net>
Date: Mon, 4 Aug 2025 11:16:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] i386/kvm: Provide knob to disable hypercall patching
 quirk
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250801131226.2729893-1-minipli@grsecurity.net>
 <6bcf6108-2d0c-44ae-a9f7-2f53ca23af7a@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <6bcf6108-2d0c-44ae-a9f7-2f53ca23af7a@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04.08.25 05:32, Xiaoyao Li wrote:
> On 8/1/2025 9:12 PM, Mathias Krause wrote:
>> [...]
>>
>> For regular operating systems, however, the patching wouldn't be needed,
>> nor work at all. If it would, these systrems would be vulnerable to
>> memory corruption attacks, freely overwriting kernel code as they
>> please.
> 
> For non-coco VMs, the systems are surely vulnerable to memory corruption
> attacks that the host VMM is free to modify the guest memory. It's
> irrelevant to whether hypercall patching is needed or works.

Sure, a VMM could mess with the guest's memory as it pleases. However, I
meant possible attacks from *within* the guest, as in allowing code
modifications to happen by having W+X mappings, allowing possibly
malicious modifications of such.

>> [...]
>> ---
>> Xiaoyao, I left out your Tested-by and Reviewed-by as I changed the code
>> (slightly) and it didn't felt right to pick these up. However, as only
>> the default value changed, the functionality would be the same if you
>> tested both cases explicitly (-accel kvm,hypercall-patching={on,off}).
> 
> No problem, I just re-tested it.
> 
> Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

>> [...]
>> diff --git a/qemu-options.hx b/qemu-options.hx
>> index ab23f14d2178..98af1a91e6e6 100644
>> --- a/qemu-options.hx
>> +++ b/qemu-options.hx
>> @@ -236,6 +236,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>>       "                dirty-ring-size=n (KVM dirty ring GFN count,
>> default 0)\n"
>>       "                eager-split-size=n (KVM Eager Page Split chunk
>> size, default 0, disabled. ARM only)\n"
>>       "                notify-vmexit=run|internal-error|
>> disable,notify-window=n (enable notify VM exit and set notify window,
>> x86 only)\n"
>> +    "                hypercall-patching=on|off (disable KVM's VMCALL/
>> VMMCALL hypercall patching quirk, x86 only)\n"
> 
> I would like to say "(configure KVM's VMCALL/VMCALL hypercall patching
> quirk, x86 only)" instead of "disable"

That would be technically correct. However, as this quirk is enabled by
default in KVM and QEMU, the only sensible configuration toggle is to
disable it. That's why I stated it this way. But I can rephrase it, if
you prefer it this way.

>> [...]
>> @@ -6611,6 +6650,12 @@ static void
>> kvm_arch_set_xen_evtchn_max_pirq(Object *obj, Visitor *v,
>>     void kvm_arch_accel_class_init(ObjectClass *oc)
>>   {
>> +    object_class_property_add_bool(oc, "hypercall-patching",
>> +                                   kvm_arch_get_hypercall_patching,
>> +                                   kvm_arch_set_hypercall_patching);
>> +    object_class_property_set_description(oc, "hypercall-patching",
>> +                                          "Disable hypercall patching
>> quirk");
> 
> Ditto, Could we use "Configure hypercall patching quirk"? It's not only
> to disable it.

Or just "Hypercall patching quirk", as the bool value already reflects
its state.

Thanks,
Mathias

