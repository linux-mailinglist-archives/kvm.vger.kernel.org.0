Return-Path: <kvm+bounces-12561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF30E88A07A
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB15A2C3B83
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 12:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B48537F6;
	Mon, 25 Mar 2024 07:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4Cdfu9H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7E613A898
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 05:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711344973; cv=none; b=ORFL+mx4N/G8bicyF7/mU0k/J5P32g9Iuew6/t9Tpyy/UyWc7QcReEpCl5GDd/8EtKiOW/2+BIiuhiYJK3yQn1SRkOpe3TVA/WH4CA/QOxA6CNEn5l7LYWAXtU/oKmGD3GO56rMV4pSjT/qOkv+emmeSR9hEIqUr8lOpIxda2DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711344973; c=relaxed/simple;
	bh=EU8rMwSTrTyQnsbvgXpnauDmYsPiuPv39ABTahNuuu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fUmsj7M/ujhYXRX0MZnFsXGFMuvMdH9Yb7Xvvu0vQ8sgRZ+mlWZ5zCM6Dgu6y04idnYMbAJLQ+NecLsWxrECqe9J3jqL0xHEWBabuNPE1cw3g+L34kYAVvx+QYp5tVB51WzddyvIhg048eFcfGmMPNsMVUQTrrw7bnnThkBG/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4Cdfu9H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711344969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8TgtQ+DMtiPQkrYAgbAtmlSjXgOjNaIxWS+xe0Zj6hc=;
	b=F4Cdfu9HDHKtpyIQ9/HtJ5dFtKSytNaetQj7cBY2MYjVXIgksBTTP+2LEI8hOXpqhSxV7L
	ukOPoRggegDpKHHZHN6pPP3hs0reINbsxhpc/yQn8NtDPvrRv/2dEK0Zm6ZuIUw4ewtkoN
	u9GT8KQnnElTAlHecJd5EGZngyKgohM=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-BSpIFEOMOmGROyCGtm8tPQ-1; Mon, 25 Mar 2024 01:36:06 -0400
X-MC-Unique: BSpIFEOMOmGROyCGtm8tPQ-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6dea8b7e74aso1225626a34.1
        for <kvm@vger.kernel.org>; Sun, 24 Mar 2024 22:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711344965; x=1711949765;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8TgtQ+DMtiPQkrYAgbAtmlSjXgOjNaIxWS+xe0Zj6hc=;
        b=HZF1J/KfN7Cc7z+Ser3eR0dPDB3Z3DUJH6h8Ask9O+4yBcPmmMji6l5UcKDakR3gxD
         sngKHXwfBdJILFwuqVRK5r/wuIg9LlqMNuGD7XfH3/PoNB64xjykemA4bkzcHXUhgNIA
         LVEqxcv1lbSihL8mNOD/WYpjtCsBSKyCJoM5eSsTjT1XjDAH9woOJkRWBq0ZdqEbDn38
         Ao3u6egbk1oEVGSFdKBwKkCrZVP6y1kITPqEj6SQIB4lQFANj/h0GZKXlmzHhs2oU1va
         UsYNcj9W1UJwR2drWmu47WkBQx2gBatEt/Pwiw6lGDe7+rglb9wR0HcJBh12WQvFXi/N
         cG/g==
X-Forwarded-Encrypted: i=1; AJvYcCVpV/raYupnSXihEMN9KRFaYYJ9HHn27b0CXoGvjYxnKDFmU+cp6LyF/YrwYU2YxvRLgCK7UxpEFhl8Cr+DEeVEsNHs
X-Gm-Message-State: AOJu0YxCTLCqFRrv+WfZ9CFuhWMiDCPUq4wdH7/YDaoVRb3xZIhW2svt
	CODnYPfdOi7ucw6aLbVNVXrgDY1dG957/5Tqnr/TynytBygqZd22/ESEmHjfDJk2PUs7o5H75nA
	fyghERIl6NzOU6qo+9hUIFvdvDXKGkoKJszVY4hkYGEKJ9KRubQ==
X-Received: by 2002:a05:6808:1588:b0:3c3:cd59:8bca with SMTP id t8-20020a056808158800b003c3cd598bcamr2572138oiw.1.1711344964745;
        Sun, 24 Mar 2024 22:36:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt9oJb2ITIcGjhwp3JVbL956AzSVHe3VrG3isWxPLgundOEN5rJCSjnl5ChB1nirQXPylzVw==
X-Received: by 2002:a05:6808:1588:b0:3c3:cd59:8bca with SMTP id t8-20020a056808158800b003c3cd598bcamr2572113oiw.1.1711344963897;
        Sun, 24 Mar 2024 22:36:03 -0700 (PDT)
Received: from [10.72.116.135] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id z3-20020aa79903000000b006e6b4613de1sm3417819pff.104.2024.03.24.22.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 22:36:03 -0700 (PDT)
Message-ID: <1881554f-9183-4e01-8cda-0934f7829abf@redhat.com>
Date: Mon, 25 Mar 2024 13:35:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
Content-Language: en-US
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
References: <20240312074849.71475-1-shahuang@redhat.com>
 <Zf2bbcpWYMWKZpNy@redhat.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <Zf2bbcpWYMWKZpNy@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Daniel,

Thanks for your reviewing. I see your comments in the v7.

I have some doubts about what you said about the QAPI. Do you want me to 
convert the current design into the QAPI parsing like the 
IOThreadVirtQueueMapping? And we need to add new json definition in the 
qapi/ directory?

Thanks,
Shaoqin

On 3/22/24 22:53, Daniel P. Berrangé wrote:
> On Tue, Mar 12, 2024 at 03:48:49AM -0400, Shaoqin Huang wrote:
>> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
>> which PMU events are provided to the guest. Add a new option
>> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
>> Without the filter, all PMU events are exposed from host to guest by
>> default. The usage of the new sub-option can be found from the updated
>> document (docs/system/arm/cpu-features.rst).
>>
>> Here is an example which shows how to use the PMU Event Filtering, when
>> we launch a guest by use kvm, add such command line:
>>
>>    # qemu-system-aarch64 \
>>          -accel kvm \
>>          -cpu host,kvm-pmu-filter="D:0x11-0x11"
> 
> I mistakenly sent some comments to the older v7 (despite this v8 already
> existing) about the design of this syntax So for linking up the threads:
> 
>   https://lists.nongnu.org/archive/html/qemu-devel/2024-03/msg04703.html
> 
> With regards,
> Daniel

-- 
Shaoqin


