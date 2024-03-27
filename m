Return-Path: <kvm+bounces-12781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1A488DA3A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B15991C28108
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307A4374EF;
	Wed, 27 Mar 2024 09:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YZTQdfgM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BA63613D
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 09:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711531463; cv=none; b=O4NEut+jilJDPVTCvZbI7Mj7LbZJPQNnMmUEglscdUME+OisN7/ASFltevuxAV5VBr0CL8SY4gwAMoVVcFQs2WCYnu/M5gG8jgzcA4libhv6pVSXzfvQhlHS0vtHGl7jShl23/tH10XaY0A2DSVHftSzLdNJ4Pt8xI/vrgcQFNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711531463; c=relaxed/simple;
	bh=TsJKaXmq3Q8hdETn36BVt94pO/XFN2fI+SgDKr3ut+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kg8me+VRtCL0gumXzMNokPd9LBjv3qzWJl1zylHwbEWhDmtUiFbe3vXRp5V341GQeLOQwjCRa/7QzzHA/TOF3j4nxbfnIgE8/Su2VqmEwrNx+YanQOACuK6NXI1R+txXegpbBSGB4ZPxg7l78gPfKw1/CNe4Mc+11XXNPGrXoSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YZTQdfgM; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6962a97752eso46605156d6.2
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 02:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711531461; x=1712136261; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36vD2IyTv6tfafKn4ObjwXFWKfxmUeiLPKcX3FNqucc=;
        b=YZTQdfgMB+m+YPbombd1QVgMMp/BALcLBGuFJlEM3nAw+fu25O/ELfR3Y9i5FnPZ6G
         8RgWPolISh/LBlMXlYN/qKCKOExPwXcpdNSn7iNJ0aL5OTFKOzRyTPDa1EV8Swwx9sdI
         nUeuuSaM+N0jZjDtu5WkThgE+Cb2Q29wRUyqcG6pNLGkf8PcafWwJ2XktpJKKZaiwGGt
         5FuYQtFW5Q4C4gwrY4D+k2SoZz6Tny0kGN5LxHSe0VUU4YabOaXCc+097/rNx75NMkh0
         yT7xQVW9tN77R1ModKDGQ/+GqHjsReI2BO/RFkddpiJ0a4EBf0WRLiMkcAUSPIzRlbDo
         ZerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711531461; x=1712136261;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36vD2IyTv6tfafKn4ObjwXFWKfxmUeiLPKcX3FNqucc=;
        b=arvAqL3GnWrDn/8KfO4MWcGTK6LvND854R/HRdASqPdDOkG8LBrUukaxpMjpEuVa21
         rMKXbdEeS3tsnzWDpIsSnmvFHHlwxNFh9KuBKg81WIhGKcOi+8R3Va1JfUsFT/Ho8tkK
         bL7SI+O92QxfGfNfP7NpaLqb2Lk4+SkHlr3T2aqtKXxxI1LfHnhSPbDYakQbBMrnnh+R
         3dMuDwu3pFlfxaaFbqZXBQCukWjCEQNeGoNucLw3TD57KW5/FpZFm1vbFDyqwGGENWCy
         pZUc/0T+xHEqJD7hGoDLZU08CxCgw/nGHmKObp+vOIHEOd7TOg3ImS1JmtRt4gelpwzp
         UCKw==
X-Forwarded-Encrypted: i=1; AJvYcCXNr4zRnWmy6Gc8pmsFnmnzY1z/xXLetJO0IQOus9hVhzXShwQLD1E7Sm+HpIdKm6+zk2cQCdFD93M3W7xDmth1XeqE
X-Gm-Message-State: AOJu0YwGvJqU+R5ZFIB1kp+/LbtMc7CLvTPidrsWBHYNVI3Ycr9wLBvz
	qhL0UXklkSnNKF+CUk9ZEVALpZ8eRqSkx8HrEX43CdGAmgdrHS8g0/192PyLcxY=
X-Google-Smtp-Source: AGHT+IHz3j1rLl9eLOJB/vBy+hYIDnfMWrxyoSCDMK1vXHX2DGxehu+UDsaivnOekhXoYZFqpVhn9g==
X-Received: by 2002:a05:6214:1948:b0:696:1fd2:1401 with SMTP id q8-20020a056214194800b006961fd21401mr777135qvk.49.1711531460733;
        Wed, 27 Mar 2024 02:24:20 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.205.175])
        by smtp.gmail.com with ESMTPSA id 4-20020ad45ba4000000b00696ae38c7bfsm437497qvq.35.2024.03.27.02.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 02:24:20 -0700 (PDT)
Message-ID: <4c535b7e-058c-4961-aba5-e4833ea86f33@linaro.org>
Date: Wed, 27 Mar 2024 10:24:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 01/18] hw/i386/pc: Remove deprecated pc-i440fx-2.0
 machine
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-2-philmd@linaro.org>
 <571fb716-2f13-4ad7-b47b-8104ec46d1d3@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <571fb716-2f13-4ad7-b47b-8104ec46d1d3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/24 17:41, Thomas Huth wrote:
> On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
>> The pc-i440fx-2.0 machine was deprecated for the 8.2
>> release (see commit c7437f0ddb "docs/about: Mark the
>> old pc-i440fx-2.0 - 2.3 machine types as deprecated"),
>> time to remove it.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   docs/about/deprecated.rst       |  2 +-
>>   docs/about/removed-features.rst |  2 +-
>>   include/hw/i386/pc.h            |  3 ---
>>   hw/i386/pc.c                    | 15 -------------
>>   hw/i386/pc_piix.c               | 37 ---------------------------------
>>   5 files changed, 2 insertions(+), 57 deletions(-)


>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>> index f5ff970acf..bb7ef31af2 100644
>> --- a/hw/i386/pc.c
>> +++ b/hw/i386/pc.c
>> @@ -311,21 +311,6 @@ GlobalProperty pc_compat_2_1[] = {
>>   };
>>   const size_t pc_compat_2_1_len = G_N_ELEMENTS(pc_compat_2_1);
>> -GlobalProperty pc_compat_2_0[] = {
>> -    PC_CPU_MODEL_IDS("2.0.0")
>> -    { "virtio-scsi-pci", "any_layout", "off" },
>> -    { "PIIX4_PM", "memory-hotplug-support", "off" },
>> -    { "apic", "version", "0x11" },
>> -    { "nec-usb-xhci", "superspeed-ports-first", "off" },
>> -    { "nec-usb-xhci", "force-pcie-endcap", "on" },
>> -    { "pci-serial", "prog_if", "0" },
>> -    { "pci-serial-2x", "prog_if", "0" },
>> -    { "pci-serial-4x", "prog_if", "0" },
>> -    { "virtio-net-pci", "guest_announce", "off" },
>> -    { "ICH9-LPC", "memory-hotplug-support", "off" },
> 
> I think you could clean up memory-hotplug-support for the ICH9-LPC 
> device now, too (in a separate patch).

Great suggestion, thanks!

> 
> For this patch here:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 


