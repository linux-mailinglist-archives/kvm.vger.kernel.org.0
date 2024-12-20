Return-Path: <kvm+bounces-34255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C6B9F97F0
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 18:28:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A04E189E880
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 17:21:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4DA22A1ED;
	Fri, 20 Dec 2024 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JfJwQuyo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3F5229699
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734714754; cv=none; b=MjhZbcBwBrxu9Dr2u0ePGSkJBUA7kd9b+f3gVfn1Jv28pNEwCqgazyl8Cwbh59L08NyMzdeVI+iB5Zrb3ve0paVDWWwcTpPtUQG7iATgLaJPDYc8cYw3hHCR6p2YfgI2D6BTAFYGgFKypKUbszWE/RUYUxsIzsiG55+zVxBk0Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734714754; c=relaxed/simple;
	bh=WifaHMgUN2/PoIP6R85s/mEJenj+ohCwTB9pHBJMD1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uR0bvDvACoOK/Z/b/sZHalVJ4v1wXUwF+6UODCNBIpXCWmlZeKZFgQpmyS3k0gJ2+ob4cUMIHcZqZDfTXrQCMJVorqnkf4gzbAnKbGZCzRBq2aO12GzyfKbHo/VKQ+43cvF9a6WF4T4I/OzW6KCX+ZHNVJP8ymXpZokgbphjDQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JfJwQuyo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734714750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pB8CsvVeMKS/nqIKRfdbuxHB1E+FQyRtAFkg+8gsimE=;
	b=JfJwQuyobM8aArzVVmKCQSqvCa2c+KfdGBmzFaYcEkykMoMLRQEnE2pu4/I1+RmrAM6kyR
	XXeJGDTCoj47rvku+C4DDKT1zpox5iZcuc4Fqjrwgq7aWFx+eLvIFKHnXpvTnzhbAmiAWp
	IFzIeojXdwbLNdKfxjCSFMvNlsDmZ+g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-AlJemwaYMxu3RgftyGxTZQ-1; Fri, 20 Dec 2024 12:12:29 -0500
X-MC-Unique: AlJemwaYMxu3RgftyGxTZQ-1
X-Mimecast-MFC-AGG-ID: AlJemwaYMxu3RgftyGxTZQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e1339790so1332209f8f.2
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 09:12:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734714746; x=1735319546;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pB8CsvVeMKS/nqIKRfdbuxHB1E+FQyRtAFkg+8gsimE=;
        b=YdzYhqAoq/K8jiHihI9yPhllprtdRLgTJcgQi7ebKhE3DwXSUNztWb8/iz/x0PaxS9
         x+k0nBl0vC4nOB9G9P47sz0t4Qwgkbr+QmUcFunKn9yvHavUMHtu+3ev9Xg2U59s03mI
         7LFaPuL4Hc8f32No/dCqzcMTMxJDiDiOiWZpllyEe30KGWslqe2755p/54Mdzw9E/3jM
         Q9TGwEB7NkoIeKu4BzuUt8xjtjjqPh5OfcebCUBjqp0sJ88+JkOAgMVKuhdfqWLfotd0
         PTA/E7KBykvOaaltoDfKgVapTXxFgz6YL2vbO2G8z61hna+h/8S+jxQRqisBygVghBLu
         pxwg==
X-Forwarded-Encrypted: i=1; AJvYcCXZmRf6QwJkBUl0rO0zYPViQOq+1FEdFdn1zR856hzvHu01ZAS+ih0qCxbJ+hZzKW9itiA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU2NTG8F8Cyo7ip04wdCeLhGjLZg5pxDPxC2Naxq34AFCudUjd
	E59/d3+4cN2gbQa8wCrXws5eThoba66FukPxaE6tzmpCxSKJXVHULIYnlctM/KgMEHbbGN0wnY5
	Y1BqKOprWsvGs7JSpKgmkHsfLuGYlLmJDrzFMcpfZRq0O89Lk4vIzzOuNTw==
X-Gm-Gg: ASbGncuf4qx+KjX2lcqZeWjUCsQeA7Grbs0yBq362t6r5hfmZMvTU2Lqon8v8kxfIso
	sRmjVG3J/IcWfZYy1QK39ylyh+XC0UymsKN5UWli67Lo1ZeGz2WcyxdieE1zE/Xyrt91RVTXxer
	9hY7StqBMm44Gb8/CZFfJzvBUCzpGvETV5ZbOS9vZwsV4G5R/5dUiMtvik4gzGqKErIAVze7i3n
	M1JnOmff3X621RD9iAlmT/6zzmvhV7WL3WDf2g5qMESEZzpcDvDqU/Y/yKY
X-Received: by 2002:a05:6000:713:b0:386:3903:86eb with SMTP id ffacd0b85a97d-38a221f1fd1mr3991067f8f.23.1734714745086;
        Fri, 20 Dec 2024 09:12:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4HmYMB9vSO/QPsMq+TOz2m0OwtyvCRzeukUVgsaKeuxv5rKk09sHmeBdZ3AMdhf48y1QTDw==
X-Received: by 2002:a05:6000:713:b0:386:3903:86eb with SMTP id ffacd0b85a97d-38a221f1fd1mr3990901f8f.23.1734714743253;
        Fri, 20 Dec 2024 09:12:23 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c8a8d32sm4518093f8f.99.2024.12.20.09.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 09:12:22 -0800 (PST)
Message-ID: <2f3df741-b24f-4940-bef1-514498b561e1@redhat.com>
Date: Fri, 20 Dec 2024 18:12:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: let it be known that ignore_msrs is a bad idea
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20241219124426.325747-1-pbonzini@redhat.com>
 <Z2WjZAKBOi1x2MVA@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z2WjZAKBOi1x2MVA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/24 18:03, Sean Christopherson wrote:
> On Thu, Dec 19, 2024, Paolo Bonzini wrote:
>> When running KVM with ignore_msrs=1 and report_ignored_msrs=0, the user has
>> no clue that that the guest is being lied to.  This may cause bug reports
>> such as https://gitlab.com/qemu-project/qemu/-/issues/2571, where enabling
>> a CPUID bit in QEMU caused Linux guests to try reading MSR_CU_DEF_ERR; and
>> being lied about the existence of MSR_CU_DEF_ERR caused the guest to assume
>> other things about the local APIC which were not true:
>>
>>    Sep 14 12:02:53 kernel: mce: [Firmware Bug]: Your BIOS is not setting up LVT offset 0x2 for deferred error IRQs correctly.
>>    Sep 14 12:02:53 kernel: unchecked MSR access error: RDMSR from 0x852 at rIP: 0xffffffffb548ffa7 (native_read_msr+0x7/0x40)
>>    Sep 14 12:02:53 kernel: Call Trace:
>>    ...
>>    Sep 14 12:02:53 kernel:  native_apic_msr_read+0x20/0x30
>>    Sep 14 12:02:53 kernel:  setup_APIC_eilvt+0x47/0x110
>>    Sep 14 12:02:53 kernel:  mce_amd_feature_init+0x485/0x4e0
>>    ...
>>    Sep 14 12:02:53 kernel: [Firmware Bug]: cpu 0, try to use APIC520 (LVT offset 2) for vector 0xf4, but the register is already in use for vector 0x0 on this cpu
>>
>> Without reported_ignored_msrs=0 at least the host kernel log will contain
>> enough information to avoid going on a wild goose chase.  But if reports
>> about individual MSR accesses are being silenced too, at least complain
>> loudly the first time a VM is started.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/x86.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c8160baf3838..1b7c8db0cf63 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12724,6 +12724,13 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>   	kvm_hv_init_vm(kvm);
>>   	kvm_xen_init_vm(kvm);
>>   
>> +	if (ignore_msrs && !report_ignored_msrs) {
>> +		pr_warn_once("Running KVM with ignore_msrs=1 and report_ignored_msrs=0 is not a\n");
>> +		pr_warn_once("a supported configuration.  Lying to the guest about the existence of MSRs\n");
> 
> Back-to-back 'a's.
> 
> If we're saying this combo is unsupported, should we taint the host kernel with
> TAINT_USER, e.g. similar to how the force_avic parameter is treated as unsafe?

I don't think so, TAINT_USER seems to be for cases where there can be 
*host* instability.  Even force_avic is a stretch.

>> +		pr_warn_once("may cause the guest operating system to hang or produce errors.  If a guest\n");
>> +		pr_warn_once("does not run without ignore_msrs=1, please report it to kvm@vger.kernel.org.\n");
> 
> This should be a multi-line string that's printed in a single pr_warn_once(),
> otherwise the full message could get split quite weirdly if there is other dmesg
> activity.

Will do, thanks.

Paolo


