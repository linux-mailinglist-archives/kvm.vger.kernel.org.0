Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACA948503A
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 10:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbiAEJla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 04:41:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbiAEJlZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 04:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641375684;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XoueNQR4kEqT+Matt0jgIO5+7tZ5WzGFoeukEV1ezTI=;
        b=TReuiqi3OCD/3iAu9iqvactv7IqZtRM+/Wucqkdaw7HGLf5Q7oEvrWmVAL94TWM6jrsMxo
        gEkynCEXcv3AQZxA47T7eHMvHeZ1q3p8SWZn1XBEG5MB0PhbiSx5rU6zz0UkxXdMCfQ6lv
        leMkLz5FNcUd2WXC5oNvLUVrZF/c/GU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-f1JhlMfCPh2IdPegetc5XA-1; Wed, 05 Jan 2022 04:41:23 -0500
X-MC-Unique: f1JhlMfCPh2IdPegetc5XA-1
Received: by mail-wr1-f70.google.com with SMTP id f13-20020adfe90d000000b001a15c110077so12312014wrm.8
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 01:41:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=XoueNQR4kEqT+Matt0jgIO5+7tZ5WzGFoeukEV1ezTI=;
        b=5s1g4Li7p26s9J6DEtinTuE6Gh62OWn//d8lqkc0nCaoIVZxjHn+/Vqr+qFOGUTz+j
         sIAf1Vuzn1657PXfPHJBEjqhHAS6KsIU7wYSrVK4XRWqwu7ngQjwmZgqvmxPcAlNGJIN
         a5p7WMnQcIJGdKzaJUUGChvWA4ylaWw/lpeh+hq4OPWRc3i/RRxaDizoI0GBRf0PTrUF
         td2KZaoPQlg8lqx1Efeohd0HgXCEJHZe0h2oD+sq6mO0NqHz07iEcbykZQF16dj/jxXV
         ZMqSXUKczEy8BIpU5A6KCzOqc9H/A32rXSwnnFdaEahifvtURAZy84my/kAuFgSTkRkp
         2lMw==
X-Gm-Message-State: AOAM533jMWwkIbp25oe+yztnrBfGi27+ZE8E3WzQNryxoYqIqQ/C/aRr
        JMXxtNYALIOVS2G18NJ4onqDJh0DlN+m/sWKKykzPUevw3+sbgBhTTsYhi3rIYL6RAkS0XoSMQ0
        IcLpqLLpRG+4s
X-Received: by 2002:adf:ea0d:: with SMTP id q13mr44299138wrm.597.1641375681211;
        Wed, 05 Jan 2022 01:41:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy8VwkzaUkiWk9Ver7jbdWPviFeEGKyfmS9ZKn/BPTA0eFyTMoTynKWTrju9cdQaTpcN6b/EA==
X-Received: by 2002:adf:ea0d:: with SMTP id q13mr44299120wrm.597.1641375680951;
        Wed, 05 Jan 2022 01:41:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 1sm34185991wrb.13.2022.01.05.01.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 01:41:20 -0800 (PST)
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
 <b9031d40-897e-b8c5-4240-fc2936dcbcb9@redhat.com>
 <877dbfywpj.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <cb9f6c39-40f8-eea7-73bf-13df1e5dae9d@redhat.com>
Date:   Wed, 5 Jan 2022 10:41:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <877dbfywpj.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/4/22 11:15 PM, Marc Zyngier wrote:
> Hi Eric,
>
> On Tue, 04 Jan 2022 15:31:33 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> Hi Marc,
>>
>> On 12/27/21 4:53 PM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> Picking this up again after a stupidly long time...
>>>
>>> On Mon, 04 Oct 2021 13:00:21 +0100,
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>> Hi Marc,
>>>>
>>>> On 10/3/21 6:46 PM, Marc Zyngier wrote:
>>>>> Currently, the highmem PCIe region is oddly keyed on the highmem
>>>>> attribute instead of highmem_ecam. Move the enablement of this PCIe
>>>>> region over to highmem_ecam.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>>> ---
>>>>>  hw/arm/virt-acpi-build.c | 10 ++++------
>>>>>  hw/arm/virt.c            |  4 ++--
>>>>>  2 files changed, 6 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
>>>>> index 037cc1fd82..d7bef0e627 100644
>>>>> --- a/hw/arm/virt-acpi-build.c
>>>>> +++ b/hw/arm/virt-acpi-build.c
>>>>> @@ -157,10 +157,9 @@ static void acpi_dsdt_add_virtio(Aml *scope,
>>>>>  }
>>>>>  
>>>>>  static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>>>> -                              uint32_t irq, bool use_highmem, bool highmem_ecam,
>>>>> -                              VirtMachineState *vms)
>>>>> +                              uint32_t irq, VirtMachineState *vms)
>>>>>  {
>>>>> -    int ecam_id = VIRT_ECAM_ID(highmem_ecam);
>>>>> +    int ecam_id = VIRT_ECAM_ID(vms->highmem_ecam);
>>>>>      struct GPEXConfig cfg = {
>>>>>          .mmio32 = memmap[VIRT_PCIE_MMIO],
>>>>>          .pio    = memmap[VIRT_PCIE_PIO],
>>>>> @@ -169,7 +168,7 @@ static void acpi_dsdt_add_pci(Aml *scope, const MemMapEntry *memmap,
>>>>>          .bus    = vms->bus,
>>>>>      };
>>>>>  
>>>>> -    if (use_highmem) {
>>>>> +    if (vms->highmem_ecam) {
>>>> highmem_ecam is more restrictive than use_highmem:
>>>> vms->highmem_ecam &= vms->highmem && (!firmware_loaded || aarch64);
>>>>
>>>> If I remember correctly there was a problem using highmem ECAM with 32b
>>>> AAVMF FW.
>>>>
>>>> However 5125f9cd2532 ("hw/arm/virt: Add high MMIO PCI region, 512G in
>>>> size") introduced high MMIO PCI region without this constraint.
>>> Then I really don't understand the point of this highmem_ecam. We only
>>> register the highmem version if highmem_ecam is set (see the use of
>>> VIRT_ECAM_ID() to pick the right ECAM window).
>> but aren't we talking about different regions? On one hand the [high]
>> MMIO region (512GB wide) and the [high] ECAM region (256MB large).
>> To me you can enable either independently. High MMIO region is used by
>> some devices likes ivshmem/video cards while high ECAM was introduced to
>> extend the number of supported buses: 601d626d148a (hw/arm/virt: Add a
>> new 256MB ECAM region).
>>
>> with the above change the high MMIO region won't be set with 32b
>> FW+kernel and LPAE whereas it is currently.
>>
>> high ECAM was not supported by 32b FW, hence the highmem_ecam.
>>
>> but maybe I miss your point?
> There are two issues.
>
> First, I have been conflating the ECAM and MMIO ranges, and you only
> made me realise that they were supposed to be independent.  I still
> think the keying on highmem is wrong, but the main issue is that the
> highmem* flags don't quite describe the shape of the platform.
>
> All these booleans indicate is whether the feature they describe (the
> high MMIO range, the high ECAM range, and in one of my patches the
> high RD range) are *allowed* to live above 4GB, but do not express
> whether then are actually usable (i.e. fit in the PA range).
>
> Maybe we need to be more thorough in the way we describe the extended
> region in the VirtMachineState structure:
>
> - highmem: overall control for anything that *can* live above 4GB
> - highmem_ecam: Has a PCIe ECAM region above 256GB
> - highmem_mmio: Has a PCIe MMIO region above 256GB
> - highmem_redist: Has 512 RDs above 256GB
>
> Crucially, the last 3 items must fit in the PA range or be disabled.
>
> We have highmem_ecam which is keyed on highmem, but not on the PA
> range.  highmem_mmio doesn't exist at all (we use highmem instead),
"highmem_ecam is keyed on highmem but not on the PA range". True but it
is properly taken into account in highest_gpa computation so eventually
we make sure it does not overflow the IPA limit. Same for the high mmio
region which is keyed on highmem.
> and I'm only introducing highmem_redist.
>
> For these 3 ranges, we should have something like
>
> vms->highmem_xxx &= (vms->highmem &&
> 		     (vms->memmap[XXX].base + vms->vms->memmap[XXX].size) < vms->highest_gpa);

couldn't you simply introduce highmem_redist which is truly missing. You
could set it in virt_set_memmap() in case you skip extended_map overlay
and use it in virt_gicv3_redist_region_count() as you did?
In addition to the device memory top address check against the 4GB limit
if !highmem, we should be fine then?

Eric
>
> and treat them as independent entities.  Unless someone shouts, I'm
> going to go ahead and implement this logic.
>
> Thanks,
>
> 	M.
>

