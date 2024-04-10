Return-Path: <kvm+bounces-14072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0141089EA56
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63AD31F22D34
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE0C20309;
	Wed, 10 Apr 2024 06:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlspgMZL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3C1C129
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 06:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729231; cv=none; b=kkGo/hAEhYY58Yyd4oFbZcrKuXWL9LKv9CZb/nwrAfEYrxYuu6ts6DPOlNyN6XEDj+oE3gkWAIhxPMr5ze4r6KnaBpI6ZfdLjAySGg0yTzWJXFCVOjeekapmu0foXT5BcbZK5VmcCHoq67zCd1K0dush5gV/wrnptd7XwlcuFzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729231; c=relaxed/simple;
	bh=dCOrD45sTf2DX4k0mMnb44L/R61W7OEDmN4/Xay4Mno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oDskFCxqKRw96JmhIDPIIWPuv/eC6ct2afTF8TzloQ0TWp0rDEjb+j/sUyMGlkBNhElaOueT+23a3KF40mJSwDdugfYy0B0amiAvzreF+fkfN2FDKkO5+qooT8pDIeftl6lMkRhr+Tw/E7e9gXhoVzIdxt6AHchdo5E/xwIWt/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlspgMZL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712729228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xi74fM3467BUSg3C5WYuNlW6f4UIb3ICBsBNHeKmim4=;
	b=WlspgMZLfzGWbIql+8mbGliG2Qum/x9b/2nYowAxfzWT8+FPbMpvV2LaBZPW5iqAo1a6/v
	jgi+XlZXqju1z6vbg2FfQuHU0/r7mEXrnNiMcTX1VsZmeWNV7WoQGPwHOklHSacbls1wYZ
	fFjdMrT1LhpeKCSgZ0U5o6B5vu5vPiU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-KUC-Iw4pOoSh_SuY2w1-2w-1; Wed, 10 Apr 2024 02:07:07 -0400
X-MC-Unique: KUC-Iw4pOoSh_SuY2w1-2w-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-56e7187af0fso989066a12.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 23:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712729226; x=1713334026;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xi74fM3467BUSg3C5WYuNlW6f4UIb3ICBsBNHeKmim4=;
        b=m3G6nWzX0Y112UUicVGwRLyrS3Vg61I4Wiwj9tEHH1iuQ8k+heGdcVAWtA+bMQB+qN
         EV0tERXXWLqC6kJCGdgpA9DWm0AGEnwoukzxDOk0qY2kcW9Nsq9YkSTN4ysqrvemewhN
         maYKWECL1VaUd9Itrkr6Od1ywJi7Gb9Uw/n7a1e87iKtoDIA6RA6ZJI7rVGtMU/7IfSa
         XbdCX2sdYEN9tDcZVQDKBCCu8hCBGFrVwvVdZf4N2WFOrCc4MBFZZGKJuUGty1eCaCSu
         2p/1UNBRSrcIG0emg/ulIJfGSRG+WL5IQHA9jZBJOnV+PCB/TaNDrORhajXi2z4+aJFU
         UQvg==
X-Forwarded-Encrypted: i=1; AJvYcCWA1HtgI0GQhuYfVMaoZuj+jn53XqzjgBEpfIuQK/eS8xyiPuTmQHoZFH8i0ho5Y+cCTTzPFb2Oh42XahkOaph+GpkL
X-Gm-Message-State: AOJu0YzTmnhVInURBUn2Dm0R39bYkWJENhq1VIFpIzO/MH1vpQQzDCqt
	kgcyYMhHP3FulEb5Ha7pkWvrUb0VA8OS6Zk7uher0uQ8IqhZiUeaRVnUI7H35QKae4pNbd/cVvd
	TSyg0BsGWwhsPei5m2v0YqIBzrbxDSurIlfaPEXMprMyCyEcJBw==
X-Received: by 2002:a17:906:4c4f:b0:a52:10c9:661f with SMTP id d15-20020a1709064c4f00b00a5210c9661fmr284014ejw.62.1712729226214;
        Tue, 09 Apr 2024 23:07:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECZE9JZc0KsUeTvEKUY5rlZCdRjszbCqNBroEEg+d9sbg++nerNfgbgrwjzBPhLX4bC/3gzw==
X-Received: by 2002:a17:906:4c4f:b0:a52:10c9:661f with SMTP id d15-20020a1709064c4f00b00a5210c9661fmr284002ejw.62.1712729225873;
        Tue, 09 Apr 2024 23:07:05 -0700 (PDT)
Received: from [192.168.42.203] (tmo-067-118.customers.d1-online.com. [80.187.67.118])
        by smtp.gmail.com with ESMTPSA id hx2-20020a170906846200b00a46dd1f7dc1sm6602801ejc.92.2024.04.09.23.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 23:07:05 -0700 (PDT)
Message-ID: <227c96c8-4f17-4f79-9378-a15c9dce8d46@redhat.com>
Date: Wed, 10 Apr 2024 08:07:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: Shaoqin Huang <shahuang@redhat.com>, qemu-arm@nongnu.org
Cc: Eric Auger <eauger@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240409024940.180107-1-shahuang@redhat.com>
 <d1a76e23-e361-46a9-9baf-6ab51db5d7ba@redhat.com>
 <47e0c03b-0a6f-4a58-8dd7-6f1b85bcf71c@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <47e0c03b-0a6f-4a58-8dd7-6f1b85bcf71c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/04/2024 09.47, Shaoqin Huang wrote:
> Hi Thmoas,
> 
> On 4/9/24 13:33, Thomas Huth wrote:
>>> +        assert_has_feature(qts, "host", "kvm-pmu-filter");
>>
>> So you assert here that the feature is available ...
>>
>>>           assert_has_feature(qts, "host", "kvm-steal-time");
>>>           assert_has_feature(qts, "host", "sve");
>>>           resp = do_query_no_props(qts, "host");
>>> +        kvm_supports_pmu_filter = resp_get_feature_str(resp, 
>>> "kvm-pmu-filter");
>>>           kvm_supports_steal_time = resp_get_feature(resp, 
>>> "kvm-steal-time");
>>>           kvm_supports_sve = resp_get_feature(resp, "sve");
>>>           vls = resp_get_sve_vls(resp);
>>>           qobject_unref(resp);
>>> +        if (kvm_supports_pmu_filter) { >
>> ... why do you then need to check for its availability here again?
>> I either don't understand this part of the code, or you could drop the 
>> kvm_supports_pmu_filter variable and simply always execute the code below.
> 
> Thanks for your reviewing. I did so because all other feature like 
> "kvm-steal-time" check its availability again. I don't know the original 
> reason why they did that. I just followed it.
> 
> Do you think we should delete all the checking?

resp_get_feature() seems to return a boolean value, so though these feature 
could be there, they still could be disabled, I assume? Thus we likely need 
to keep the check for those.

  Thomas



