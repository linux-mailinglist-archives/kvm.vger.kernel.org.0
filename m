Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5358348449F
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 16:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiADPbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 10:31:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34349 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234861AbiADPbj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 10:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641310297;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dHb1Dlc/ItOolPMR+Jc0/qUYSK2KoiTzttrdRcxrJcE=;
        b=NMRHHDkBS4jGXjHnpURZIEHZizf6fZuE44U0Vx/VfeFjneNelbpPcFCFPCa3vEcrRj8dDi
        tCJcQE+1ZhSglOqeZQQb7mDowH/MxDNGCjAIj3j2D8XSH6xmywdTrLW4MEQcAxagCC1mS5
        DhoJu0yRDK9Py5lRZIfmxTQ8wjICqpo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-YIiQKQyWNLKuLGfSmyjC6Q-1; Tue, 04 Jan 2022 10:31:36 -0500
X-MC-Unique: YIiQKQyWNLKuLGfSmyjC6Q-1
Received: by mail-wr1-f70.google.com with SMTP id h12-20020adfa4cc000000b001a22dceda69so11821620wrb.16
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 07:31:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=dHb1Dlc/ItOolPMR+Jc0/qUYSK2KoiTzttrdRcxrJcE=;
        b=tK13RszyhhIIgNrnPlOTl5VGEDiu/WgT+BU0cGB1xQqwZNY6OWyc6VXMqZM8tVZc60
         YGIBj9nFKTyk58o76DxbagvwTVJz2Tsa2N5KH0HKC2ejWupcMKjlZFTI3ziwONOQYklp
         1HSGVl6xhbBmfX7zRqhQlbToLaGX5eMi/hmOoQrbg1gfir51+hzTNnUj995eubZXHmb5
         h7TLQ3TVl7xNJa/RCO9BxXjYn2bYWOJ/v3ULSgsRZpVkTVcGFy1WiuHw27CAAjZXWEZx
         zCLTDIfMdNWs/i5MfgOH/c4m61yXgvCocH9wHmw3Xcul+WrTw489bW4FrWnYx/dpM5Ro
         7BFg==
X-Gm-Message-State: AOAM531/2122z2bw81pMlGaSZPlgTSHb4CLwCv7I6spkGsrLhEBa6NCh
        5/x6EaX3NJbpOOB2zCPKU7Ksh+Rhj78wAar1JjNQLTSiftnd0hyzwNIylBtV2mwuvibasfhw1Kl
        FMtMn/AJCH1oS
X-Received: by 2002:a05:600c:4f83:: with SMTP id n3mr41830312wmq.129.1641310295480;
        Tue, 04 Jan 2022 07:31:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwV9IRJ1sEs6RhagLAEfvJinAJ1OWUzplrbq8dl6cI1k7STj6fGh3vl7cyX2z/tYQ7+BP7Pxw==
X-Received: by 2002:a05:600c:4f83:: with SMTP id n3mr41830296wmq.129.1641310295252;
        Tue, 04 Jan 2022 07:31:35 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ay29sm39635325wmb.13.2022.01.04.07.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 07:31:34 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
 <dbe883ca-880e-7f2b-1de7-4b2d3361545d@redhat.com>
 <87pmpiyrfw.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <b9031d40-897e-b8c5-4240-fc2936dcbcb9@redhat.com>
Date:   Tue, 4 Jan 2022 16:31:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87pmpiyrfw.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 12/27/21 4:53 PM, Marc Zyngier wrote:
> Hi Eric,
>
> Picking this up again after a stupidly long time...
>
> On Mon, 04 Oct 2021 13:00:21 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 10/3/21 6:46 PM, Marc Zyngier wrote:
>>> Currently, the highmem PCIe region is oddly keyed on the highmem
>>> attribute instead of highmem_ecam. Move the enablement of this PCIe
>>> region over to highmem_ecam.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  hw/arm/virt-acpi-build.c | 10 ++++------
>>>  hw/arm/virt.c            |  4 ++--
>>>  2 files changed, 6 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
>>> index 037cc1fd82..d7bef0e627 100644
>>> --- a/hw/arm/virt-acpi-build.c
>>> +++ b/hw/arm/virt-acpi-build.c
>>> @@ -157,10 +157,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
>>>  }
>>>  
>>>  static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>> -                              uint32_t irq, bool use_highmem, bool highmem_ecam,
>>> -                              VirtMachineState *vms)
>>> +                              uint32_t irq, VirtMachineState *vms)
>>>  {
>>> -    int ecam_id = VIRT_ECAM_ID(highmem_ecam);
>>> +    int ecam_id = VIRT_ECAM_ID(vms->highmem_ecam);
>>>      struct GPEXConfig cfg = {
>>>          .mmio32 = memmap[VIRT_PCIE_MMIO],
>>>          .pio    = memmap[VIRT_PCIE_PIO],
>>> @@ -169,7 +168,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>>          .bus    = vms->bus,
>>>      };
>>>  
>>> -    if (use_highmem) {
>>> +    if (vms->highmem_ecam) {
>> highmem_ecam is more restrictive than use_highmem:
>> vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
>>
>> If I remember correctly there was a problem using highmem ECAM with 32b
>> AAVMF FW.
>>
>> However 5125f9cd2532 ("hw/arm/virt: Add high MMIO PCI region, 512G in
>> size") introduced high MMIO PCI region without this constraint.
> Then I really don't understand the point of this highmem_ecam. We only
> register the highmem version if highmem_ecam is set (see the use of
> VIRT_ECAM_ID() to pick the right ECAM window).

but aren't we talking about different regions? On one hand the [high]
MMIO region (512GB wide) and the [high] ECAM region (256MB large).
To me you can enable either independently. High MMIO region is used by
some devices likes ivshmem/video cards while high ECAM was introduced to
extend the number of supported buses: 601d626d148a (hw/arm/virt: Add a
new 256MB ECAM region).

with the above change the high MMIO region won't be set with 32b
FW+kernel and LPAE whereas it is currently.

high ECAM was not supported by 32b FW, hence the highmem_ecam.

but maybe I miss your point?

Eric
>
> So keying this on highmem makes it expose a device that may not be
> there the first place since, as you pointed out that highmem_ecam can
> be false in cases where highmem is true.
>
>> So to me we should keep vms->highmem here
> I really must be missing how this is supposed to work.
>
> 	M.
>

