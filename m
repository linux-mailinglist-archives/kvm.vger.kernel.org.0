Return-Path: <kvm+bounces-11154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A985873BBD
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:09:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A3321C23C61
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDE01361C2;
	Wed,  6 Mar 2024 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BWr1AezA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65137134435
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709741382; cv=none; b=lgtExm3Mv/gwV2ynfyd0DRexUvboCxXsOu2dsof4YcOnzjm4HjdPkYbDruOWkSGIT55Ekt1whay8+ei1VaVJ3qOuzCcvWGS45oQhzcJZQTf82PbQ7Z6zoi3byUhqvIKJp1D8roNkf3M3u5kPt85Ty+SUEoSFXPxYHF4o6MZxUo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709741382; c=relaxed/simple;
	bh=a+9PJToY2cK+YLKdeYy4wE1//BVPAWOjItSSvQGW+aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mT/Vb7UmQI7f4GvTYR9jsOt36+hz90EAEoOgCL8TquqAIICYPJr1y9dOfQzfZo5UsTPipYCGQIedeQpznUOJqAEPZerCpnLIii/9i4cFX+N+OzbX9dkGmCbsguCMj47eRH3uhoLLlXuVshUw1DO1uTqe4T80XfPbhjSetttm1xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BWr1AezA; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d3b93e992aso48640081fa.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709741378; x=1710346178; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MmVJkOBa60r8dmjE4j3/FlIqeLJFuZIPlB7HqkAJG3U=;
        b=BWr1AezAnWiV+xlsLRPKBlndPVIyPwUqgFqPm0hddb8sKMGGrPGXMZW/XQla/ZH5xl
         VeymM0CHmUjTCjLqCd34cwRwxpMHbh28uEuiBVFTyVnVGIFBo7F4xoFlUair4KT79aE1
         TEd5oJHHp9F5kK9mUgml5Ox4y9NVZILXm0pDbUa8+ofUmo72O7Wu80FEN4h9EKn9rMfL
         6CZWp/f++IH/wf1fWo2GCkMGcYJ5HGF/RXqbRafvYElZIOXtX4dN7yIbEz+IGWZsxKQE
         6IkMLQWsOaA3o3HR/PoV7s3XAmLgd+8MML7BsLMDKCyLML01yFeDtWidPX66j0xrIIBW
         f9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709741378; x=1710346178;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MmVJkOBa60r8dmjE4j3/FlIqeLJFuZIPlB7HqkAJG3U=;
        b=niMfhoYlIOgNSd/659cKgd2ix2IywAZweWzYzb+260XvXen44gaR1fs7ItyF0ymYdw
         XYXubRPUQ9/P9hNVDA1k+zFMaqt53jLH6+1ISZ6YB9WwiknWy6oJT/xNGryuDSPvk7EX
         cP6VZjP10mDKAOdrKfF5NJs5i6MVHDOkHmSwvd4nBqMPjo5DV6VlOZuKNrublBRQ2kbT
         U7xnSwojrjekdEdB5Ey2/cXDyxleiHHP9nJkK0FkgtU08vulRCVsAAqiTiS52uWTFPFd
         qUcJwt4nnp3HJzT+FnQWtNY0pPtaB36XphLt+dYdo5prckvvrGKdkdAIPD8Rc69nk0G0
         nE0w==
X-Forwarded-Encrypted: i=1; AJvYcCVyYwihZq/O/rq5pBtCHuqCoxcMUF7na4hypdo31G+1Vl1RoLrHklTRgJmJfppCB1AfgBV0xvW34ElUJ0Q2DuQzCxuZ
X-Gm-Message-State: AOJu0YwpmRc3uDD6S0XkPQ9491TTbQAUiv9n04M/1u9rJ+7zN9OBmbvy
	AB2NmQFF7+wkVdw9+0Kg4Db+rgr3raDsWjyY/8B41tCYAQzizjoIwIx0wdgS+GI=
X-Google-Smtp-Source: AGHT+IG4stqdDxyaCO58ulQvA/V8i8I2EmJqoiv+uo867kaEoCgfjVCTHVOY8GKWq/Q3rUdbVWP5Eg==
X-Received: by 2002:ac2:442d:0:b0:513:685a:8696 with SMTP id w13-20020ac2442d000000b00513685a8696mr887152lfl.10.1709741378413;
        Wed, 06 Mar 2024 08:09:38 -0800 (PST)
Received: from [192.168.69.100] ([176.187.210.193])
        by smtp.gmail.com with ESMTPSA id cx4-20020a170907168400b00a43a5bdd58bsm7259799ejd.211.2024.03.06.08.09.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:09:37 -0800 (PST)
Message-ID: <ea194c20-cf6f-4a7f-8eec-ef2036b82b97@linaro.org>
Date: Wed, 6 Mar 2024 17:09:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 02/18] hw/usb/hcd-xhci: Enumerate xhci_flags
 setting values
Content-Language: en-US
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-3-philmd@linaro.org> <ZehvWi8UhQOl3v8j@intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <ZehvWi8UhQOl3v8j@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Zhao,

On 6/3/24 14:27, Zhao Liu wrote:
> Hi Philippe,
> 
> On Tue, Mar 05, 2024 at 02:42:04PM +0100, Philippe Mathieu-Daudé wrote:
>> Date: Tue,  5 Mar 2024 14:42:04 +0100
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Subject: [PATCH-for-9.1 02/18] hw/usb/hcd-xhci: Enumerate xhci_flags
>>   setting values
>> X-Mailer: git-send-email 2.41.0
>>
>> xhci_flags are used as bits for QOM properties,
>> expected to be somehow stable (external interface).
>>
>> Explicit their values so removing any enum doesn't
>> modify the other ones.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   hw/usb/hcd-xhci.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/usb/hcd-xhci.h b/hw/usb/hcd-xhci.h
>> index 98f598382a..37f0d2e43b 100644
>> --- a/hw/usb/hcd-xhci.h
>> +++ b/hw/usb/hcd-xhci.h
>> @@ -37,8 +37,8 @@ typedef struct XHCIEPContext XHCIEPContext;
>>   
>>   enum xhci_flags {
>>       XHCI_FLAG_SS_FIRST = 1,
>> -    XHCI_FLAG_FORCE_PCIE_ENDCAP,
>> -    XHCI_FLAG_ENABLE_STREAMS,
>> +    XHCI_FLAG_FORCE_PCIE_ENDCAP = 2,
>> +    XHCI_FLAG_ENABLE_STREAMS = 3,
>>   };
>>
> 
>  From the commit 290fd20db6e0 ("usb xhci: change msi/msix property
> type"), the enum values were modified directly.
> 
> So it seems not necessary to bind enum type with specific value,
> right?

Indeed! Let's drop this patch then.

Thanks for referencing the commit,

Phil.

> Thanks,
> Zhao
> 
> 


