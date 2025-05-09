Return-Path: <kvm+bounces-46053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A70AB0FD1
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C7FD4C084A
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E805D28E59A;
	Fri,  9 May 2025 10:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fLUkoKa9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FC9222576
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 10:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746785068; cv=none; b=Fa/jocRNaDyAhKCWhhBRdVlJmZ/oeT4kL0Gxeu7QgSAyl+RRCGirbrRwEMwyzVd4QOd031T5/4ANW7+xi5nqL/awhJulLF8LZdiymXOf9Gz6OQ1GRpPiC03WA3VkQ6FwErGGqFikbxkPGbbVILkuO32MEAuVWRtjs3Ae89Lvkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746785068; c=relaxed/simple;
	bh=YdGWdajXJnO2jUJFgdShCqGe0D3/FFUYMJAE8e2eCPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YpvFMV1zU4zWx9ibuGKOCfp7sS8/a9bBmav9Ytci20HD42eRHZEuTfIDw37+3cqgjOHSLzyjtk/zRhMtr38fhXGUtcV3wwV8LbMNCxQ5vo+BJm7jIFAV6Bgij9Qvb4YDkT5armFe91ryPjVbBFBMuxg+dTSawNkpejMqfN8ocrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fLUkoKa9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746785065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5Kwk95fuora+GIrWiSHPyNGLxMslBv3jG49YqLT5rLo=;
	b=fLUkoKa9xaMy0NZPY0yZw06Gol3ZrnOK2AELpPXNlC0BNyyyiKlADLvkjlh2vm64wXC5u8
	TXu9c7yrGK9Dl52ZtVdlupLJBvwJ6CpdvkGGDVIBfpX1e+hzmg4Vfj4fJ3K2E9Grhr9QYz
	vWhFeS+qnp39C8waKNO6XYydcCX66/w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-8eJwT_XlMry864-rVgJ23w-1; Fri, 09 May 2025 06:04:23 -0400
X-MC-Unique: 8eJwT_XlMry864-rVgJ23w-1
X-Mimecast-MFC-AGG-ID: 8eJwT_XlMry864-rVgJ23w_1746785063
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a0bd786a53so704741f8f.0
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 03:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746785063; x=1747389863;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Kwk95fuora+GIrWiSHPyNGLxMslBv3jG49YqLT5rLo=;
        b=DYuUgzNgD3fvotMtwd2pgqEJVayd+YbRybkCrdgr54y1mG0+tHiM+zUtRujrVhBIhj
         qIF7zaXtLJ4J4/CSReHVqoY/oqpQZwar8zg6ZicWoAmVez8ODfsVG/OYWH5aEnRQLfV9
         ttTef1/VOjCXk+CjCIXDGNQRkpkIyi5AXcdBjrDHDCgUbQafdC/GgrV6SlIHytUVO6qL
         V/q3qnezya7nS2LM+8v21MuaVuxXWRVJnUfKSPN0c1PyH7ae7eOL485nzRxlDQGbWrUx
         NQNR9Anp10M/jKUZTe62dTaY68CnuFy87WxOA7Lv/f4T7x3lbOPSkOmHtpCGH9kNoExi
         7Eyg==
X-Forwarded-Encrypted: i=1; AJvYcCVbEyc8H7/k5k26K/QtZ2zywd0QcEe3rIhPpbDPSjsRGysbbpOnkkkNOMxtkV9x2UyQKgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrIL6g5K4kd4hCYRNr/7kvEzKgOcm4d/F7Hd252KmSNmg7V7av
	Y2x4UCqgYuFw05ny8bOCPy55qkIn/PT1gc6/3m80xcKPhu+jyn/I7wwvZAAl+xwKi4bST2DIDwv
	Jpsyza6/JyPoKWNH6BVcPL0S41r7k7UGoqP4pRgxXdXTt5+EAyQ==
X-Gm-Gg: ASbGncv7ee+texY61SCusG+XYqTAl58GkTN/EIf8XohqOdZULmzxg0Jtq19Gsz5/7mh
	WsscAspH5OJ5+GdLX4l0LQ0RED/EXoh4novzswGEY3g0ZJsBlGpuRmGr207aSYUs8rXes89WqG0
	GCXefN31ZTKFFbo8mujsA8feNQa2hj6qMcpTE63maSD48moPQrM1yXeaSLScgoOkE0wd76nCGyn
	JtnWOJSIEbUx1D47GeGr+VDcfKbRYr9iCjut+rLQTjLRUQeF++j7aUVvOO1Q7v962uFxcarFLX0
	IBFYxF6a1iMEJBNQN3N0cpIbYc/Id/W8uBnm2j6gnzTwVqoP4iEf
X-Received: by 2002:a05:6000:3113:b0:39e:e3fa:a66b with SMTP id ffacd0b85a97d-3a1f6445d7dmr2296762f8f.34.1746785062711;
        Fri, 09 May 2025 03:04:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsw4mQvIe65lYAhxK8Mg5JhWSLdbpVhpDlFo1MDeWJ0PSV5WOqUhh1msYf9oVa/+jtsL1wqw==
X-Received: by 2002:a05:6000:3113:b0:39e:e3fa:a66b with SMTP id ffacd0b85a97d-3a1f6445d7dmr2296709f8f.34.1746785062268;
        Fri, 09 May 2025 03:04:22 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-115-173.pools.arcor-ip.net. [47.64.115.173])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2cee4sm2783959f8f.67.2025.05.09.03.04.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 03:04:21 -0700 (PDT)
Message-ID: <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
Date: Fri, 9 May 2025 12:04:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: How to mark internal properties (was: Re: [PATCH v4 12/27]
 target/i386/cpu: Remove CPUX86State::enable_cpuid_0xb field)
To: Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Markus Armbruster <armbru@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Daniel P. Berrange" <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 kvm@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Yi Liu <yi.l.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
 Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
 Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>,
 Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
 Jason Wang <jasowang@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-13-philmd@linaro.org>
 <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com> <aB2vjuT07EuO6JSQ@intel.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <aB2vjuT07EuO6JSQ@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/05/2025 09.32, Zhao Liu wrote:
> On Fri, May 09, 2025 at 02:49:27PM +0800, Xiaoyao Li wrote:
>> Date: Fri, 9 May 2025 14:49:27 +0800
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>> Subject: Re: [PATCH v4 12/27] target/i386/cpu: Remove
>>   CPUX86State::enable_cpuid_0xb field
>>
>> On 5/8/2025 9:35 PM, Philippe Mathieu-Daudé wrote:
>>> The CPUX86State::enable_cpuid_0xb boolean was only disabled
>>> for the pc-q35-2.6 and pc-i440fx-2.6 machines, which got
>>> removed. Being now always %true, we can remove it and simplify
>>> cpu_x86_cpuid().
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>    target/i386/cpu.h | 3 ---
>>>    target/i386/cpu.c | 6 ------
>>>    2 files changed, 9 deletions(-)
>>>
>>> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
>>> index 0db70a70439..06817a31cf9 100644
>>> --- a/target/i386/cpu.h
>>> +++ b/target/i386/cpu.h
>>> @@ -2241,9 +2241,6 @@ struct ArchCPU {
>>>         */
>>>        bool legacy_multi_node;
>>> -    /* Compatibility bits for old machine types: */
>>> -    bool enable_cpuid_0xb;
>>> -
>>>        /* Enable auto level-increase for all CPUID leaves */
>>>        bool full_cpuid_auto_level;
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 49179f35812..6fe37f71b1e 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -6982,11 +6982,6 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>>>            break;
>>>        case 0xB:
>>>            /* Extended Topology Enumeration Leaf */
>>> -        if (!cpu->enable_cpuid_0xb) {
>>> -                *eax = *ebx = *ecx = *edx = 0;
>>> -                break;
>>> -        }
>>> -
>>>            *ecx = count & 0xff;
>>>            *edx = cpu->apic_id;
>>> @@ -8828,7 +8823,6 @@ static const Property x86_cpu_properties[] = {
>>>        DEFINE_PROP_UINT64("ucode-rev", X86CPU, ucode_rev, 0),
>>>        DEFINE_PROP_BOOL("full-cpuid-auto-level", X86CPU, full_cpuid_auto_level, true),
>>>        DEFINE_PROP_STRING("hv-vendor-id", X86CPU, hyperv_vendor),
>>> -    DEFINE_PROP_BOOL("cpuid-0xb", X86CPU, enable_cpuid_0xb, true),
>>
>> It's deprecating the "cpuid-0xb" property.
>>
>> I think we need go with the standard process to deprecate it.
> 
> Thanks! I got your point.
> 
> Though this property is introduced for compatibility, as its comment
> said "Compatibility bits for old machine types", it is also useful for
> somer users.

Thanks for your clarifications, Zhao! But I think this shows again the 
problem that we have hit a couple of times in the past already: Properties 
are currently used for both, config knobs for the users and internal 
switches for configuration of the machine. We lack a proper way to say "this 
property is usable for the user" and "this property is meant for internal 
configuration only".

I wonder whether we could maybe come up with a naming scheme to better 
distinguish the two sets, e.g. by using a prefix similar to the "x-" prefix 
for experimental properties? We could e.g. say that all properties starting 
with a "q-" are meant for QEMU-internal configuration only or something 
similar (and maybe even hide those from the default help output when running 
"-device xyz,help" ?)? Anybody any opinions or better ideas on this?

  Thomas


> Fo example, in the early development stages of TDX, when there was no
> full support for CPU topology, Intel had disable this property for
> testing and found this bug:
> 
> https://lore.kernel.org/qemu-devel/20250227062523.124601-3-zhao1.liu@intel.com/
> 
> So, I think there may be other similar use cases as well.
> 
> And, if someone wants to emulate ancient x86 CPUs (though I can't
> currently confirm from which generation of CPUs 0xb support started), he
> may want to consider disable this property as well.
> 
> The main problem here is that the "property" mechanism doesn't
> distinguish between internal use/public use, and although it was originally
> intended for internal QEMU use, it also leaks to the user, creating some
> external use cases.
> 
> @Philippe, thank you for cleaning up this case! I think we can keep this
> property, and if you don't mind, I can modify its comment later to
> indicate that it's used to adjust the topology support for the CPU.
> 
> Thanks,
> Zhao
> 
> 


