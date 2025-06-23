Return-Path: <kvm+bounces-50375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96189AE4868
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 17:25:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB6661B62403
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 15:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C3528DF34;
	Mon, 23 Jun 2025 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MPe3+Djb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D61628AB07
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 15:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750691911; cv=none; b=NA6tzEEzCo36y1EF1V591ldSepbtNKIiwlw0KVb+QBFkLWWraPU/WZp3v7L995e4EXl52Aiaqr7dY3QZbEu3MRubafOSa51DwCsnb6NTa2FfNMUa3Ix/KKJcspD78c1lOQjnhNKy9rE2aAuEKZY2nYlCVEhGk/foxynpwAt40kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750691911; c=relaxed/simple;
	bh=nHqCOmgexJslCJoUiIe9gXupb5smXIc03iRznbjHuM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nmmGErwlXsw1e4xwgBvtHk7SUFur+2lRLWIiCuL0z6ih50xff+p9rB64LD4AfPmfVsCVMDjpqEet06qN9/1z3A6g9ipATjtAekRKQ0njJJbwk27vKempCxulEN+KmQmT9GmMYz+khaj1a/NOf6mMtR28QwPBr7h1WcU8SRAE+DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MPe3+Djb; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-450dd065828so31548725e9.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 08:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750691908; x=1751296708; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIN+RgRGGCJnokaRdCTi07yk/D+XISYakVoaYJMHles=;
        b=MPe3+DjbhGDKTlGVKNY5iCreDTNzYtizEsgmRGIBNF4letRLu+tI4uM7Kn7AbQUmYW
         aQUW2CHelFY9Stp9mdrtJqRCDDkm1PcuHEzGcD+ODd/HfjR2ytyBjfNd2/gWGGqxHPEt
         yHFfnyhtxLZ5nMTe4JfSz37wvKM2ZRYNcYL+B4k4avPTPg4SytGj9DWx6BtwfhcO2IFi
         a/x7IzSRvUmQs3A7EahQ9eUHEjaC7GgDs/hS39Q4IROsyq1DLcI1UOLvgPzRZaXJr6OZ
         NU7Zz6RwAcuUIaC88rPy9GYfXf9Y4nubaID5Sw5QH4cI6APz9lFPJOzZ08fQ4GprQO9q
         N94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750691908; x=1751296708;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIN+RgRGGCJnokaRdCTi07yk/D+XISYakVoaYJMHles=;
        b=mklzxhXnE3UknnUaPcBmykiteE527TTIr7NYUJaLZJ6EXtY5RENOWU8PWU2WN03/rn
         eQh3Fd+lCRO/Wul7kZ00DrfBM84jWDGdKm2ZPUxktgTvKf3ORjUd7w7/K+8XKN1uuKOG
         9jEjRAcHyrqwjvG0hPn3WLS+esXopW5e60bUCyAFoq0x26eVDDwZ6fgbHlWDOxQSIKJj
         nSBXNde8bW0PwXR32AMadX8tsuDNbGr5zc+JDsJxeSvQbAInhExlgyABlaTLmioKqRiF
         RAZcIfpt2QBbcIZ+5bpZGDlvnyysra4IesDR7VPHaKWA6F07Q4kHgXjtols9bi5h8mEe
         sxfg==
X-Forwarded-Encrypted: i=1; AJvYcCVj9CFMf2r+nrMGSw/jBlD9zjjs5UlV7tDwAGXJWNbvEXwOynsi8E5uPAXzm1cE7IfH6KY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxYTmJK7s0VN2kmLcwRHmZKWReGDgUtgQOwgQ50Uc3jKfM4wJb
	C9Ke1tx8ylVEY9hwb4NEmGAGUMnkUHYmjymBDAfzJnT0SB1p+sSDWIqEY4MBsbpi1cE=
X-Gm-Gg: ASbGncsNIKll48Pxj5l2eYs5gT2PwcPqxaayiZ9kMLmnREPy/ijPfFIwg64u6x+bL/f
	bL8hDSfC9ToB8fYFxt6rUtwBj9S8jXvknKrGxNcM8JvoYZYvhuDw36z6ZHJzMHbXeR7dz5T9UHU
	fI5PqsNOtQeagttxsdy/ZroUOGvmzEsuLgTVlQ94zA2q9T4Hr2hNi4HmjlzwHNz9wXM5aE89tsr
	cp2iFGtHL75t8vzYUB33UXPQfZAMJ0eFCOaOAjW9FvxNWOMRiH51Y/hItnFre/d8QC1jlLbDTuD
	rg3wSBJiv5hiL+rA5sjKxbRmYRoEXI5Ram/2akqhw+TvZse/vzKZsqaqo9+TiOFvjTlpNTiTv29
	AIQh6kCemrl/K9OOtwLmxc9NVx6oMiw==
X-Google-Smtp-Source: AGHT+IH5HwlDfedhxQ2UBOIYP7nsIw3gbY72muiBf9A3OzLSvMyE2iSR+eAsDWo7s2KE6DPTbZIwwQ==
X-Received: by 2002:a05:600c:3f90:b0:442:f4a3:b5ec with SMTP id 5b1f17b1804b1-453653cf3c4mr109783435e9.4.1750691907914;
        Mon, 23 Jun 2025 08:18:27 -0700 (PDT)
Received: from [192.168.69.167] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45363c0f227sm55323695e9.2.2025.06.23.08.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 08:18:27 -0700 (PDT)
Message-ID: <a8a4d2f7-2341-4cdb-8ca9-8deda337434c@linaro.org>
Date: Mon, 23 Jun 2025 17:18:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/26] tests/functional: Expand Aarch64 SMMU tests to
 run on HVF accelerator
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Cameron Esfahani
 <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-27-philmd@linaro.org> <87sejq1otw.fsf@draig.linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <87sejq1otw.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/6/25 17:04, Alex Bennée wrote:
> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
> 
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   tests/functional/test_aarch64_smmu.py | 12 +++++++++---
>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/test_aarch64_smmu.py
>> index c65d0f28178..e0f4a922176 100755
>> --- a/tests/functional/test_aarch64_smmu.py
>> +++ b/tests/functional/test_aarch64_smmu.py
>> @@ -17,7 +17,7 @@
>>   
>>   from qemu_test import LinuxKernelTest, Asset, exec_command_and_wait_for_pattern
>>   from qemu_test import BUILD_DIR
>> -from qemu.utils import kvm_available
>> +from qemu.utils import kvm_available, hvf_available
>>   
>>   
>>   class SMMU(LinuxKernelTest):
>> @@ -45,11 +45,17 @@ def set_up_boot(self, path):
>>           self.vm.add_args('-device', 'virtio-net,netdev=n1' + self.IOMMU_ADDON)
>>   
>>       def common_vm_setup(self, kernel, initrd, disk):
>> -        self.require_accelerator("kvm")
>> +        if hvf_available(self.qemu_bin):
>> +            accel = "hvf"
>> +        elif kvm_available(self.qemu_bin):
>> +            accel = "kvm"
>> +        else:
>> +            self.skipTest("Neither HVF nor KVM accelerator is available")
>> +        self.require_accelerator(accel)
> 
> I think this is fine so:
> 
> Reviewed-by: Alex Bennée <alex.bennee@linaro.org>

Thanks.

> However I wonder if something like:
> 
>          hwaccel = self.require_hw_accelerator()
> 
> Could fetch the appropriate platform accelerator for use in -accel bellow?

Then we'd need to make it per-host arch, and I'm pretty sure hw
accelerators don't support the same features. So I'd expect a
rather painful experience. WDYT?

