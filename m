Return-Path: <kvm+bounces-59096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1347BABDD1
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EB503C1965
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:41:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017F829E116;
	Tue, 30 Sep 2025 07:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0lG1OtO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CB7219303
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759218068; cv=none; b=rdPBNthjLcD4OTROgQAudOtrsITfqwBjX78R5xCdE44kxwW/h0PuhOHn4db3CLIc56EehlgSh0pgwWo3wXu/t6/4zmzjyhyR6r6OFYX81Qf6s+q23CFejNWzaKvsKg+iTtDlU96uXlNptWLgm0ixTCXfaRIfee2Wq3h3Dnevp6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759218068; c=relaxed/simple;
	bh=vMyvu0CCSR9R7KlxEtsVi1J1PQBIeYSia0Bn0hLlAoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FQKNNzOV2/afXjiYXEifZC8iTesSjStYN80drmr4JvBODx427VbxvIWMPdvCaQ3LbyTu+yKWm4mywVO21ippO6cI8mR0vcBCSvLGLr1ItqIDdrNHQWnp4CIdTRnqb2Vei62VK4+DuyH7c2AVcZ+/U/VHl87I3aMCwLj179xGfok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0lG1OtO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759218064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j5g55fSIVioaOkOGMYUBzd3ThDPmNzBRB7wmsPOA2xg=;
	b=K0lG1OtOtmcXANzb0lPM1nndAV9ujh7uceqdF/f67McdzE7N5XIPrxjzyIWK38il3vepYN
	8gliWw8/w1cIvq3FPxRyCA0nfaF1glV4HEYpMevZdo638lMwyXjfTc/ADcqT+aZCVBKGV3
	LqZM6EXcVOQPLvMPjX7vQbyAlX2EdWs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-DtrOZfmaNQ-3l6K3NyaRZA-1; Tue, 30 Sep 2025 03:41:00 -0400
X-MC-Unique: DtrOZfmaNQ-3l6K3NyaRZA-1
X-Mimecast-MFC-AGG-ID: DtrOZfmaNQ-3l6K3NyaRZA_1759218059
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece14b9231so3831024f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:41:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759218059; x=1759822859;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j5g55fSIVioaOkOGMYUBzd3ThDPmNzBRB7wmsPOA2xg=;
        b=Rge8LgZBUZXpQX4/1z1VVEzAHqUJ/jI0bBPZ7Th8Qi0X2RWbMNobVg6b+0BgTgFMr8
         Zu2bDVx68ZRDg3mo/9R4C8ax2z7kJ1HNziHNjrxUzIUdoxCGNvnRoMbGY7WDoM23sNhG
         guDE74//U4qUHGENzbhDiVmYZvLxIbb1X4gVDCo4SdCpyWufmo9Mvu+w+ipkarkcGFml
         HMah7+8fGUFM+krFBhEb6aMhOByZu40NqIKxWBzHicUBr3/hKuLEqN/p/Qxud6/p9ZCR
         0gm5leZpHk/3gxd4RJBur3oTo8x2akrNbkRReJc75sMr0B4GGgo39LB2SibK0S+3DnCS
         DrqA==
X-Forwarded-Encrypted: i=1; AJvYcCW69fg83hsiAIkB1WEFUlVZSo+TaIwEF4FuvcflyVvEEs9Tu66QxBpvN564cX55nNCX060=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9nYlnaW/FYeeIP5GRI3kZOTp9Dj54Fd8v5x9Cixf2DmHgSmo5
	FTrdm9kL0bgxvDFZqlkSizfZFkCHm9xWmJ0UoMqUodOGA+NmfOBtTT0PaAPD0KbnSlmT80kHtl5
	IhLV4XxN2LKIT1Dt6OZNLF8wNoWGaCPxUFPkrofaJKi3ztRqBXTF6Ug==
X-Gm-Gg: ASbGncsqiNv9EhUf3GS7jbemiJPpp9K6xlBc203JpUtzDVYxqIKzPuMdJrIqeJ47MqU
	l5oKrvEa5Qw+iV1sGvwgdb+9Z8Yi/vNIkfwqk8cuw9Y/IMmvB1bhTfofczVoXh+zaSGFnmKdA+8
	QjHovfu3dz+tNG5Emhq9bJqxIa13fbxj+GxFJgAPWBGlpbeaxqiXtxSIVMYehvhCds431ljkkzQ
	TFnEaHyuXa9dwKVvSIZ4Z3SAgX+1vPWOTdmgvNYh+db8V6nalHREHHd5T0Un7CkzmgnTXnauAqj
	eFqg93/8ySxdDXH2A7Fdf7zzw/1umW0iCo9CxnmmJXZiCXupY7xXmDXc2q5xUdH2EoczCVvKOrZ
	X8I5+RLMwfg==
X-Received: by 2002:a05:6000:2512:b0:3e7:610b:85f6 with SMTP id ffacd0b85a97d-40e4ece56f9mr18746565f8f.39.1759218059526;
        Tue, 30 Sep 2025 00:40:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtAakQVSr7pX6RBy8gWI/wBsZCTYsWc4ZTAkgkXM7gzrLE/6RH/bVKOjbcCuughEeAm/sEXA==
X-Received: by 2002:a05:6000:2512:b0:3e7:610b:85f6 with SMTP id ffacd0b85a97d-40e4ece56f9mr18746511f8f.39.1759218059101;
        Tue, 30 Sep 2025 00:40:59 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm21596535f8f.8.2025.09.30.00.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 00:40:58 -0700 (PDT)
Message-ID: <b041eb8a-7b2e-41ec-bdfa-1867814dde36@redhat.com>
Date: Tue, 30 Sep 2025 09:40:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/17] system/physmem: Un-inline
 cpu_physical_memory_read/write()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 qemu-s390x@nongnu.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-15-philmd@linaro.org>
 <193cd8a8-2c4c-4c2c-af22-622b74c332ee@redhat.com>
 <61c31076-5330-426a-9c28-b2400bec44f6@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <61c31076-5330-426a-9c28-b2400bec44f6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2025 09.23, Philippe Mathieu-Daudé wrote:
> On 30/9/25 07:02, Thomas Huth wrote:
>> On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
>>> Un-inline cpu_physical_memory_read() and cpu_physical_memory_write().
>>
>> What's the reasoning for this patch?
> 
> Remove cpu_physical_memory_rw() in the next patch without having
> to inline the address_space_read/address_space_write() calls in
> "exec/cpu-common.h".
> 
> Maybe better squashing both together?

Either squash them, or provide a proper patch description here, but just 
repeating the patch title as description without giving a reasoning is just 
confusing for the reviewers.

  Thomas


