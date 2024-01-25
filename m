Return-Path: <kvm+bounces-6987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDCC483BBDB
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ABBB28B89F
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4C01B942;
	Thu, 25 Jan 2024 08:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="xzfZrIW1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0D01B80A
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171012; cv=none; b=o2387vBWjgTjHXk163nt/wn3+iwllIKDWdxM8GCvY3iDsP8/IfIlahFkor5oJCjSxUdulB0ECK5naAQ4WH8nOl8EcEZ35XSS2+xogtO2u6aCI+KsOgW+W8yHZvLoFaSTASk5NQK/I93Q3yVppI7kxL5PIgHO2DOyHfPS3PImFxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171012; c=relaxed/simple;
	bh=DTUotWok36hjOgDhIyTa8a7+8fqvIBlccapLUVCFKoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Off1Rg+5y+ZtNHTXjBOyPZa/SfZ+sQ2POH7b7IXsrC8t/Mf8LavrKq4qW5r6hswxK38PrC1qT/X6TgM8+RWGthEgx5ygolnWDKYCwdV+NoxT3EwzeTnQg0kkp3RJWzY6DXFLxr6DKoq4Xr0S937BiXyALtKdpRuNvRjjf7/yGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=xzfZrIW1; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6dddfdc3244so4555672a34.1
        for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 00:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1706171009; x=1706775809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J9lYDlnAE0lJVngPq79SfowaDrB/STSBHiz7p/zSWjI=;
        b=xzfZrIW18RG6oykcpZVBYimQzjpkEd3+/TngWjmL/pNxUQO5Gu2wjD0kDbAt1a6wxO
         iR+xuTCUUGfVfE80hn8YoT568/Tq/Us4KzfQwiYOBPdO4wLatx4THGQFbB5UufIaoIVK
         8JqytUQUM6Ih8rH8sZ58eQgyIWpzXc2sG9ocGPaGaFcf7Q+L5p2WyNwmJ5IT9nrORmOj
         8YYRARGUW9Uypiz61BOjhUAqPBr+G1GTFKWxQIdXJPQLWpIAm4WKsmD7Joo0daVa43rm
         TNGJS5Hf/UynyNN5FDupcYFz9DxwmC75AE6OpWTOm2oDjgGwx0dcBIWsa6JFjifX97LG
         +MIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706171009; x=1706775809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J9lYDlnAE0lJVngPq79SfowaDrB/STSBHiz7p/zSWjI=;
        b=qIMG0EQ2BvqjCuYyU3FcdSGuETmgEjPjb3mM9UKe7DllBPt593suJbE1npb/SaHiDP
         6AtP1QuBm5Z5IJn3p99F4yvvpgqrybDSjDmTC9EoeUrdosfwPGsHux423fzAsicrGwXk
         Hdw48ZKUEiALhM3jIpL1cPJezFG8PyxVW1dGM8UoTyz565dZ/pCTrNmvTQc7oAVqno8K
         DXFbfv0exa7ERXFdkLXNLyMpIZZy/teAr1EPeMOi+3olXBh+9HZNR8K233fFFiN4Yc0Q
         F5B/yDGJL4KxKZdO3l1rHo/ng7tpl5Mg8C1cFCefMBwNj11gaw0vwKLgg3AJjYcbYML6
         H2Mg==
X-Gm-Message-State: AOJu0YxWLydIUz3xIzU62r1yxqyXgc9clfN7rmyzsAOogQXjMYNX56IA
	92x1CcyTgHwM458ytKI1/Lh6jXedPjhXbEn4/OMxp2JHbDDIHl3SE9dYwHgMqsQ=
X-Google-Smtp-Source: AGHT+IECMqWYYJsB6MNOawObFchB6dGaMRCOAPEafdArYh7Hsf1OSjlc6V3+DkvMY59NBK0L25NVnw==
X-Received: by 2002:a05:6830:2053:b0:6dc:3c65:2a7f with SMTP id f19-20020a056830205300b006dc3c652a7fmr559935otp.63.1706171009670;
        Thu, 25 Jan 2024 00:23:29 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:9ac7:6d57:2b16:6932? ([2400:4050:a840:1e00:9ac7:6d57:2b16:6932])
        by smtp.gmail.com with ESMTPSA id w18-20020a639352000000b005d508535001sm2310835pgm.43.2024.01.25.00.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 00:23:29 -0800 (PST)
Message-ID: <246ea370-934e-4666-ba73-b49c3ff6e531@daynix.com>
Date: Thu, 25 Jan 2024 17:23:20 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/21] hw/riscv: Use misa_mxl instead of misa_mxl_max
To: Andrew Jones <ajones@ventanamicro.com>
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Rolnik <mrolnik@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Laurent Vivier
 <laurent@vivier.eu>, Yanan Wang <wangyanan55@huawei.com>,
 qemu-ppc@nongnu.org, Weiwei Li <liwei1518@gmail.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Peter Maydell <peter.maydell@linaro.org>, Alexandre Iooss
 <erdnaxe@crans.org>, John Snow <jsnow@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 David Woodhouse <dwmw2@infradead.org>, Cleber Rosa <crosa@redhat.com>,
 Beraldo Leal <bleal@redhat.com>, Bin Meng <bin.meng@windriver.com>,
 Nicholas Piggin <npiggin@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Eduardo Habkost <eduardo@habkost.net>, Brian Cain <bcain@quicinc.com>,
 Paul Durrant <paul@xen.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
 <20240122145610.413836-2-alex.bennee@linaro.org>
 <20240123-b8d1c55688885bfc9125c42b@orel>
 <15d2f958-a51e-4b87-9a70-28edf3b55491@daynix.com>
 <20240124-3d9bec68bff7ab0057b902b6@orel>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240124-3d9bec68bff7ab0057b902b6@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/01/24 17:16, Andrew Jones wrote:
> On Wed, Jan 24, 2024 at 12:08:33PM +0900, Akihiko Odaki wrote:
>> On 2024/01/23 17:20, Andrew Jones wrote:
>>> On Mon, Jan 22, 2024 at 02:55:50PM +0000, Alex Bennée wrote:
>>>> From: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>>
>>>> The effective MXL value matters when booting.
>>>
>>> I'd prefer this commit message get some elaboration. riscv_is_32bit()
>>> is used in a variety of contexts, some where it should be reporting
>>> the max misa.mxl. However, when used for booting an S-mode kernel it
>>> should indeed report the effective mxl. I think we're fine with the
>>> change, though, because at init and on reset the effective mxl is set
>>> to the max mxl, so, in those contexts, where riscv_is_32bit() should
>>> be reporting the max, it does.
>>>
>>>>
>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>> Message-Id: <20240103173349.398526-23-alex.bennee@linaro.org>
>>>> Message-Id: <20231213-riscv-v7-1-a760156a337f@daynix.com>
>>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>>> ---
>>>>    hw/riscv/boot.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/hw/riscv/boot.c b/hw/riscv/boot.c
>>>> index 0ffca05189f..bc67c0bd189 100644
>>>> --- a/hw/riscv/boot.c
>>>> +++ b/hw/riscv/boot.c
>>>> @@ -36,7 +36,7 @@
>>>>    bool riscv_is_32bit(RISCVHartArrayState *harts)
>>>>    {
>>>> -    return harts->harts[0].env.misa_mxl_max == MXL_RV32;
>>>> +    return harts->harts[0].env.misa_mxl == MXL_RV32;
>>>>    }
>>>
>>> Assuming everyone agrees with what I've written above, then maybe we
>>> should write something similar in a comment above this function.
>>>
>>> Thanks,
>>> drew
>>
>> The corresponding commit in my series has a more elaborated message:
>> https://patchew.org/QEMU/20240115-riscv-v9-0-ff171e1aedc8@daynix.com/20240115-riscv-v9-1-ff171e1aedc8@daynix.com/
> 
> I've pulled the message from that link and quoted it below
> 
>> A later commit requires one extra step to retrieve misa_mxl_max. As
>> misa_mxl is semantically more correct and does not need such a extra
>> step, refer to misa_mxl instead. Below is the explanation why misa_mxl
>> is more semantically correct to refer to than misa_mxl_max in this case.
>>
>> Currently misa_mxl always equals to misa_mxl_max so it does not matter
> 
> That's true, but I think that's due to a bug in write_misa(), which
> shouldn't be masking val with the extension mask until mxl has been
> extracted.

misa.MXL writes are not supported since the MISA write code was 
introduced with commit f18637cd611c ("RISC-V: Add misa runtime write 
support"). It doesn't matter if we allow the guest to write MXL; the 
firmware code is emulated by QEMU when QEMU loads a kernel.

> 
>> which of misa_mxl or misa_mxl_max to refer to. However, it is possible
>> to have different values for misa_mxl and misa_mxl_max if QEMU gains a
>> new feature to load a RV32 kernel on a RV64 system, for example. For
>> such a behavior, the real system will need the firmware to switch MXL to
>> RV32, and if QEMU implements the same behavior, mxl will represent the
>> MXL that corresponds to the kernel being loaded. Therefore, it is more
>> appropriate to refer to mxl instead of misa_mxl_max when
>> misa_mxl != misa_mxl_max.
> 
> Right, but that doesn't say anything more than the original one line,
> "The effective MXL value matters when booting."

What do you think is missing?

> 
> What I'm looking for is a code comment explaining how riscv_is_32bit()
> is always safe to use. Something like
> 
>   /*
>    * Checking the effective mxl is always correct, because the effective
>    * mxl will be equal to the max mxl at initialization and also on reset,
>    * which are the times when it should check the maximum mxl. Later, if
>    * firmware writes misa with a smaller mxl, then that mxl should be
>    * used in checks.

It is misleading to say the maximum MXL should be checked only at 
initialization and on reset. We can refer to the maximum MXL anytime; we 
just don't need it to load a kernel.

Regards,
Akihiko Odaki

