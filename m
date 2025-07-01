Return-Path: <kvm+bounces-51175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB7FAEF49E
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AF523A9FAE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 10:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBE026CE12;
	Tue,  1 Jul 2025 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K+TTuGHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B2C26B956
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751364694; cv=none; b=sf3SvKQ/KAQgIhF1FqJKTQquskZqbO/0fVQMk48E7TSvnY5auG1ggq4l7uHQhLmYMjuRw1lPPcqvCpHkNok5lkd/xG1RPCLC3TFYYcyeWgZqtB9fPp/WllDmjdDxq64wc7SbBJUyX5cud0m1FNPimbybF6sXF2CtEtjASxAMxiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751364694; c=relaxed/simple;
	bh=sce6EWo6jwwKwJrq0b/sTX0tZNXP6eW/wzHJLQCqS+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jzkL+ujBb5s//TpDTgIKYRNE3mDHgvftNSg4ctMGx9FSwds0NiF9ePY91wAkPohG4pOUp+sBuO6gKMm1TVIxKhd/1oStepCweEQwL5h/9TXCaYzyMsS676l/PLWF1C3bujJjxpVphWkrCEW9Q9kI6tB3eaqrJVIlltLguTGVGHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K+TTuGHt; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4537fdec33bso19576205e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 03:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751364691; x=1751969491; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xukDN3H63LwhhQewlIjnzCHEaos/m6LMLbLr7A6Mjes=;
        b=K+TTuGHtuzP1fqA48zLX/TWURHhF5wWsl3wOlhtUl06s85a+5q+Ku+/5JibTMgxi23
         96/6hspJTgqVfWQP69P+cqTgJjozcWdGp801TL9y/X36luaF19SXZDx/NIVZ3Usz3ztT
         cUnhp47RFUvYY6DcrAe+qQIYTl/A5ogBdTVbYLAKVCBojG11JFlnoZniGT+2lKvS6Ny/
         N5PI1WK6/mFzR8c7DEk8d6WMV5+RXbnRFUfeKY7joOrgMfjK6EO7IwR6havwpMcoBB0h
         isE8MlFYBt/r0otCwwmJN8tXcArblBxqADbxN2WLeAizpr2LMXNyu0AwMaCCC68KDRpu
         Usfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751364691; x=1751969491;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xukDN3H63LwhhQewlIjnzCHEaos/m6LMLbLr7A6Mjes=;
        b=w4tIVh5EvuAX6HpHtuhBGqFvF+eZ7qRGUtxzgaxKHLbHgPIpmg+KUulm6VLTn9+RRg
         nFCK2O66w0khYv0wAIlCg1ccps6Xu0fcEP4+6WmkWotH9kABj54lssw1ssz5QcAkuJkS
         yyDddeX3O+0L5HYFVFmRc3HpxhAyD7YN7LwVuXD8E4NR7vAqFTq9IFfioDjZUyWNMwO7
         JqMtgVn6urYG+39FZi3g7qBDPD2rNhe5ptV4u0dtrLNV1DdV6Qpk8TROz8E9SrMFJx2u
         6Au4FK8Kyz60oMR2NxskGKamdv53GHHDFpuZPIsnaEt4wCvNWmZKd5BpCAZhW8DwO6FR
         dOjg==
X-Forwarded-Encrypted: i=1; AJvYcCUJvQ6jkMch+YPi2QxY6rhLUsoMNDzwxnhJx+jOEDCv4Fr516OreW+Ujqzb8OqFzP0cU2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNHn+b/oXX9FjmdMP49cJ9hCwnzAVY/2s9XiAcmFyWkSAWmA2N
	wtUssG5H1xcdzRHCZGjAkG7i2EpuGbVSYMjQPlp+1PXlmQHlIartswzBb03xcZB4jow=
X-Gm-Gg: ASbGnctQ8z7Ig9S9wwyvsP2D767gzTIHE71SGW66aoRov6FZ1NDgfTLngI1zzvEYL5S
	IHvfrBlhH3ULriL2KmAqbJSVXaQ9BEebAr2uUroaA2AD7reQ+hzlcZ/FoWV8z7fGaZjS1OysBjn
	jZQb7w7bDIq3HghePesS+ujBBwgVZGtNPqWCOPp+KFID0ZaJN0amu8X7B/OnZEVZO/GCGs60kih
	pCzkMJBjSTcWFBu9AWeaYLRnqGfGiD/inJIjtVGIWjN6hntk2KsBCP8DAs4koD2uocleB/3gEgW
	7ok5P2WG/qzX4ms7AszxH9aNWQfAPPE9t0Lix9BcGIXvUGEQmAwZSDC9uOenbwswevJ5i43bb9w
	7uUCX4QY+MtgNwQcwpKa+Zbd/dHofpBdW8ZoKW4yC
X-Google-Smtp-Source: AGHT+IFJ2dzhbA7AS66Am/DJLv0M0N+kubAZsKkWqs3D2gOnCtcFq+eIstRODMqR92FI66ozNZuD7w==
X-Received: by 2002:a05:600c:4594:b0:43d:47b7:b32d with SMTP id 5b1f17b1804b1-4538ee8c45emr157635275e9.25.1751364690947;
        Tue, 01 Jul 2025 03:11:30 -0700 (PDT)
Received: from [192.168.69.166] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538233c05csm191355995e9.5.2025.07.01.03.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 03:11:30 -0700 (PDT)
Message-ID: <8d72bfca-b79d-431b-b9c9-8e21fccd22f4@linaro.org>
Date: Tue, 1 Jul 2025 12:11:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/26] hw/arm/virt: Only require TCG || QTest to use
 TrustZone
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-19-philmd@linaro.org>
 <CAFEAcA_M+nXYL5HaN7QUUwWywJw8VaxU3T54YCMQsVd42PQ+PA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA_M+nXYL5HaN7QUUwWywJw8VaxU3T54YCMQsVd42PQ+PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 12:05, Peter Maydell wrote:
> On Mon, 23 Jun 2025 at 13:20, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> We only need TCG (or QTest) to use TrustZone, whether
>> KVM or HVF are used is not relevant.
>>
>> Reported-by: Alex Bennée <alex.bennee@linaro.org>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> ---
>>   hw/arm/virt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
>> index 99fde5836c9..b49d8579161 100644
>> --- a/hw/arm/virt.c
>> +++ b/hw/arm/virt.c
>> @@ -2203,7 +2203,7 @@ static void machvirt_init(MachineState *machine)
>>           exit(1);
>>       }
>>
>> -    if (vms->secure && (kvm_enabled() || hvf_enabled())) {
>> +    if (vms->secure && !tcg_enabled() && !qtest_enabled()) {
>>           error_report("mach-virt: %s does not support providing "
>>                        "Security extensions (TrustZone) to the guest CPU",
>>                        current_accel_name());
> 
> The change is fine, but the commit message is odd. You
> only get to pick one accelerator. The reason for preferring
> "fail unless accelerator A or B" over "fail if accelerator
> C or D" is that if/when we add a new accelerator type E
> we want the default to be "fail". Then the person implementing
> the new accelerator can add E to the accept-list if they
> implement support for an EL3 guest.
> 
> For the not-yet-implemented case of a hybrid hvf+TCG
> accelerator, it's not clear what to do: in some cases
> where we check the accelerator type you'll want it to
> act like TCG, and sometimes like hvf.

In that case we want to defer to the accelerator, not block
from the machine init.

BTW hybrid hw/sw accelerators *is* implemented, but not yet ready
to be merged:
https://lore.kernel.org/qemu-devel/20250620172751.94231-1-philmd@linaro.org/


> 
> I'll take these patches, with an updated commit message.

Thank you!

