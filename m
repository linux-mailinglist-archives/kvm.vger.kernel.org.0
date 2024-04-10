Return-Path: <kvm+bounces-14076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4592089EBEA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:28:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C775B1F21BF6
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 07:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B6D13D250;
	Wed, 10 Apr 2024 07:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="JPLJR127"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC52D13CF9E
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712734092; cv=none; b=XfzJw2se703lnu/bOssVsQs3fogz9BQltlFppwxR5lCSSgG2gMF5YwQQraJCQvjSF2qsrrZgiIYQC7O7+QV3SWFeCRXxodlJxWQTrMC4eiYmFwPXpirg5NUfBa+A4fnw3a1JY3IT3soItDtfCAyzlpOqYErb99jU+vICW8otRBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712734092; c=relaxed/simple;
	bh=EkKWgtjZ08/3JU/NJqPbGnAGIGRetFZ9LJ/ZTT3RuXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+jFTGz1YlvW8OLA9szRH2QoCr5EMHvpMJNQmHR1SvfR2WXBQxtpY0LZQSymrny6xJYwtgX1K1jYo/tLAGMbu614EGYnHVxynFUsp4DoWDpzT/o6yhQWsD7BNFBvCUf6VRVFJtP3S/auKwXoa8N/Q86zsk2+oiCyXF7r1N7q4n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=JPLJR127; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ed32341906so2447259b3a.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712734090; x=1713338890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Ig32zWmBFLYBqQb21rAU7TmYkM7kXOo2WhlPw8o8aY=;
        b=JPLJR1275hLAJD2IWWdpocerPztq2DVkHEVyO6VRJ9VXg5oAFs3BWUqN6mlt8+vo3r
         1yQpKFnYIMwQqi5p1NhOr1uoQ7H/NI5hr3kDjKuce8gxNmXw489+yKDNi3irlzgyuIZB
         5QlqftdBuwHFAyDGm/zht4ylBb1djXYhJmy4asXe2vi5VjksimZDByHqIqxOncjVYh5D
         NAU1fpjltk6HDoQwhg0dkKq2/SnaWyoCFaWrURGH79qz9RAUkozk9dZ3v5YXkFzUo2BW
         ugi5+ajk3qY7GniqeFcucXPq07GI48C4fuf/de21UztKPV6rHzMj1zYDN0PIrGfWEJtN
         ugzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712734090; x=1713338890;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Ig32zWmBFLYBqQb21rAU7TmYkM7kXOo2WhlPw8o8aY=;
        b=L3yRCnpoZfKnCvVw0EsuocKJTFa+FZO5Ve7KdSvRJuafS4QrytmKaBSpKW2LHRyW+L
         mulN/luIridg/dl/XC4NbcRLFmXy4grNI3qFFBeLMw8JD+T9rNgRPYbcwMSVLNUlW+pq
         dEMov8o8ALhxhem87nFLs60NzaGt7O0GMAjbOX9gPzkMKwViC/s3YdJfznfPEYudfUT3
         4sk+O95wiIJQGiUsEDfZHGyWqcSCY3MUq9dIrUHeqoWGjKKMBHG+w48tTextsiADjHhF
         A9//1YSyIrYw6+r4Zz7ww7HnlkxFGDRb0TWwS5CSM/vmjnzZwXUs9KINAfDFKZDsieWc
         /y0w==
X-Forwarded-Encrypted: i=1; AJvYcCU4nsXYnPx1FBOX8yEqp3xUGxDkCfzaTlXOGQ3DL+GDHVKd7juUbbrYZA93qfTHJlRId01F+i2LmbnkPgDicTtc+WgR
X-Gm-Message-State: AOJu0Yzm6V0oMT/ZJRtlCDQDxGN3VSoh3HqE536v+WDsAf652yIaOxC9
	baZ9IxZS4oo0maY/I0fHnqQnSobXa++ZmIzmF0a5lXtIWXqJVFOq4pwyzN1AXcI=
X-Google-Smtp-Source: AGHT+IGnAZXE/XiGFQ0xzq27+Bwb+2iBqYQega7VKj5SmqFQEmNOu1qpGgpcd92WDjvowGcA4TzlPQ==
X-Received: by 2002:a05:6a20:7488:b0:1a3:53e7:16da with SMTP id p8-20020a056a20748800b001a353e716damr2250861pzd.15.1712734089807;
        Wed, 10 Apr 2024 00:28:09 -0700 (PDT)
Received: from [172.16.0.21] (c-67-188-2-18.hsd1.ca.comcast.net. [67.188.2.18])
        by smtp.gmail.com with ESMTPSA id n15-20020a170903110f00b001e20587b552sm10131456plh.163.2024.04.10.00.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 00:28:09 -0700 (PDT)
Message-ID: <4a428500-4e37-4e7d-968d-3da20dd822af@rivosinc.com>
Date: Wed, 10 Apr 2024 00:28:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/22] KVM: riscv: selftests: Add a test for PMU
 snapshot functionality
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
 Ajay Kaher <akaher@vmware.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Alexey Makhalov <amakhalov@vmware.com>,
 Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>,
 virtualization@lists.linux.dev,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Will Deacon <will@kernel.org>, x86@kernel.org
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-22-atishp@rivosinc.com>
 <20240405-4e840120e8117c286cb593f9@orel>
 <8748dbed-d105-4f26-a808-667c3b56c8ec@rivosinc.com>
 <20240410-2a41e43624596a442d6a95cd@orel>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240410-2a41e43624596a442d6a95cd@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/10/24 00:10, Andrew Jones wrote:
> On Tue, Apr 09, 2024 at 03:52:40PM -0700, Atish Patra wrote:
>> On 4/5/24 06:11, Andrew Jones wrote:
>>> On Wed, Apr 03, 2024 at 01:04:50AM -0700, Atish Patra wrote:
> ...
>>>> +	probe = guest_sbi_probe_extension(SBI_EXT_PMU, &out_val);
>>>> +	GUEST_ASSERT(probe && out_val == 1);
>>>> +
>>>> +	if (get_host_sbi_spec_version() < sbi_mk_version(2, 0))
>>>> +		__GUEST_ASSERT(0, "SBI implementation version doesn't support PMU Snapshot");
>>>> +}
>>> It's a pity we can't check the SBI spec version that KVM is advertising
>>> from KVM userspace. Normally we'd want to check something like this at
>>> the start of the test with TEST_REQUIRE() before running a VCPU in order
>>> to generate a skip exit.
>>>
>> Agreed. I will send a separate series for that as it is an ABI change.
>>
>>> (We probably should allow reading and even writing the SBI spec version
>>> from the VMM in order to better support migration.)
>>>
>> How that would work for SBI spec version write use case ? For migraiton, you
>> can't go back to older SBI versions in the host. Isn't it ?
>>
>> Considering this case your VM is running with PMU snapshot as the host has
>> SBI v2.0. It can't be migrated to v1.0 and expecting it work. Correct ?
>>
> We can start a VM on a host with SBI v2.0, but tell KVM to tell the VM
> that it has v1.0. Then, the guest shouldn't use any features from SBI
> that appear after v1.0 and it should be safe to migrate to a host with
> v1.0.

That depends on when the VMM request to KVM to change the version.
Most of SBI implementation checks the SBI version at the boot and 
enable/disable
feature based on the SBI version available. If the SBI version supported 
by KVM changes
to an older one, the calls from VM will fail unexpectedly.

> A more likely scenario might be this though:
>
>   1. KVM userspace checks and captures the SBI version of the host where
>      the VM is first being launched, e.g. v2.0
>   2. The VM gets migrated to another host which supports something later,
>      e.g. v3.0, but to
>      - avoid possibly confusing the guest we tell the destination host
>        that it should expose v2.0 as the SBI version
>      - allow rollback to the source host without concern that the guest
>        has already seen v3.0 and started to use something that the
>        source can't provide

This makes sense though. As per my understanding, we should not allow 
modifying
the SBI version that is less that the version VM already boot with.
However, we can allow modifying the SBI version that is higher or same 
as the VM booted with.

I can't think of a use case for the higher version though.

> Thanks,
> drew

