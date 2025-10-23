Return-Path: <kvm+bounces-60875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 417D5C00006
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 10:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0977E4EEBE3
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 08:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C5F303A35;
	Thu, 23 Oct 2025 08:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pvw9KM5I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B333303A28
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 08:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761209277; cv=none; b=IXCnhTTA5mztQUzsTwNIEOcLAAzVztu9JkQjeGgHNbiF/7Yc4Fwduu4eiZoS+8EjFtxPfpLynzOfpHY5OmOJ7le1kI1Ea8rMuJbcAHeUineyJzIW8tQwdbzkQMdZne1ob+d6CGOOfjITVNUKFujfuB3k7KPhT2kY9f7QD02AE4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761209277; c=relaxed/simple;
	bh=aqZYjOkD2ssqAWKXeVc8uqtqREJGmYAZ+wynI8GEZeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mNB6MaY9T5cdL6DmRDaHvxCS8vikABvSJ5T88XHwR/YdcXUlB9v5MKNf5oCXUtTzoitgIqcPVLFWXLFB5/5UoiDDAOR1Scw9DXMENYPLf/ED27ynCFQIsrohe8MD3JbqR6s7Gcy39hvPmyjcDxUyVBNlqPaDLhaupHrzv9elG3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pvw9KM5I; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-426f1574a14so297341f8f.3
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 01:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761209273; x=1761814073; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rz8/K0tEMyMdFk9Zgt2mrSe6G0rqUn802kF8LFl6g/o=;
        b=pvw9KM5Ig+orMj9GgtTdazTvj9kJu5+tpTIzEE67vRF5Ky0b17EgMv1tiaLBuGhS8l
         7oNEDd4PhmXUf6WZKxD1FaIV3gaKqR9xq72eXxsqY+daYUz+pd19mNxKrS6gTX/lyryT
         giuTsExNRgVgABvq01fHGuD/f8t+6SmqVXpMvq4KGm+0fnl0hpsO79AK860baMWQn4vR
         ifwCWzJKN3ibffJEBb+ZEAMhNvncp+lKX46QeRu9SYBN1dpInaTwsVJWHoVfC7jQCOOb
         qEYxc7CtUsoKFE7CD8fwT1CIo7YX/8pV2S4hD954vI2BnQeQGoB6KyDyiGkuiizIqE9i
         1aPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761209273; x=1761814073;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rz8/K0tEMyMdFk9Zgt2mrSe6G0rqUn802kF8LFl6g/o=;
        b=acr4pqtIttGWniqYS6fWEnLBypqKWXfQa17t6KybSB2hdqrf5AGjwd/QzmuskBauVi
         /NDvWl3jxT7+dKV+KVUYtFBiGV8e7x8973/OjAZE/Q7ZbvuSrsATECO5bAUWyWSKnTUt
         Go1M2AYbmOP5habfES1xy2kP9J4dHYkr+X3rILu8Xtly+lzeaKPuXBWzzAtogY0vme/O
         ALAKUDo69VWUQsh6no/G9R7Zwzt9yFoA8hv6kwZRPKhpCVcgbCPP6TRLQLIem0JgoACe
         uMkDkf/qku+l2JlsQuKtFIdAVmcQbSK2mDm8Gx9LJYiPU7Lvbl3XtJNuHxamVPQU2xS8
         S04Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEsUSJ4NnEHSt/TrKVuRfEByDLFNNZG5zTy88qdhEDV8ti945HOE3WCzzh6jz1TQ0Oscg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUWZyvCOYh6+qYGh/9WQup15qlMe6GdFqDybaa6JP2pY4r0Ddl
	FO5bp66xrETPQtlR10cJdyY33zQvT75yn5+UixIdtNz02DUmoVjZpl1jd76VxptFYMc=
X-Gm-Gg: ASbGnct+2C8kxD4DHPoqQsiz1vkK97/KRDtio3bNit+9JLovHKtcRHNl98qsXAJognV
	N3CTRHhdUDAlnWo+Vuha8ZizfFXbbKYxDnBWsH1MuLKMhePH6/uctYb2nmeYf0K92VC06F1ivWZ
	JtLsXQ9liLp0H0h6ypwqeNUF2OVGxghGi++bWnjgwg6MJNwLi0+eCL9W7H9xGxHmUIo016gzJz+
	aGLMdGouu4u86QruqZ8L7b07NCn7f8LmzVClNykCWeC3Axu/B/IGtY8bVU2d9BHbwHEAu+AIy6K
	iqBoR/YhHZWz86VnTCxomDXaPrYVZ9vJLDufq5AHGztnB5j18BJcdZdFaLbIDOeMn+qxhOa6wGD
	kg0h0efgCu7wsId0Z1R0KWhaQVzmDCf1nuV3BtJtzoIsfPpuK2RRr6XrvoLWEFlyo1aJASKmalL
	uxRUMKwaL6vMCyyiqXLARljU94ILP17zoME5DDWwjnm/Ctx4yKezsyBkSfS1ETaQ55TQ==
X-Google-Smtp-Source: AGHT+IFDm4qYEEpbTlOdExTrEq2HLGdn+RSQQuCW6SQSu4OKkkIkvK0iQV/mXC3K8TkmaNLnEhoL1w==
X-Received: by 2002:a5d:5f93:0:b0:427:4b0:b3f9 with SMTP id ffacd0b85a97d-4298a04071bmr981873f8f.3.1761209273145;
        Thu, 23 Oct 2025 01:47:53 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:404:4d10:9f16:e9b1:dc97:28e6? ([2a01:e0a:404:4d10:9f16:e9b1:dc97:28e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898adf78sm3002027f8f.32.2025.10.23.01.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 01:47:52 -0700 (PDT)
Message-ID: <67daa7b7-7411-4207-bae3-0bccf33f77f5@linaro.org>
Date: Thu, 23 Oct 2025 10:47:46 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/24] whpx: apic: use non-deprecated APIs to control
 interrupt controller state
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org,
 Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-25-mohamed@unpredictable.fr>
 <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org>
 <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com>
 <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025-10-23 08:33, Philippe Mathieu-Daudé wrote:
> On 20/10/25 12:27, Bernhard Beschow wrote:
>>
>>
>> Am 16. Oktober 2025 17:15:42 UTC schrieb Pierrick Bouvier <pierrick.bouvier@linaro.org>:
>>> On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
>>>> WHvGetVirtualProcessorInterruptControllerState2 and
>>>> WHvSetVirtualProcessorInterruptControllerState2 are
>>>> deprecated since Windows 10 version 2004.
>>>>
>>>> Use the non-deprecated WHvGetVirtualProcessorState and
>>>> WHvSetVirtualProcessorState when available.
>>>>
>>>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
>>>> ---
>>>>     include/system/whpx-internal.h |  9 +++++++
>>>>     target/i386/whpx/whpx-apic.c   | 46 +++++++++++++++++++++++++---------
>>>>     2 files changed, 43 insertions(+), 12 deletions(-)
>>>
>>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>
>> Couldn't we merge this patch already until the rest of the series is figured out?
> 
> OK if you provide your Tested-by tag (:
> 

I did in the past, but I'm not sure it was reapplied by Mohamed.
In all cases,
Tested-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

