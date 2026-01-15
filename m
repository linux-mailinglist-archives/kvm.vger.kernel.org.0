Return-Path: <kvm+bounces-68217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8D0D2723B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:08:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C12330D66AD
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:01:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466463D3CFC;
	Thu, 15 Jan 2026 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FPzWWIKc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330783BFE37
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499501; cv=none; b=f8Y3ABlGBqLf+OegqIlZJDakvRrqGEXg8Ucrq9Lnm3astpPXnpbRHCZ48mm/t+/HZk0g7NBeByxMcUDbpumxnDQFEEgPob93erpQ5/cM3fyZCgNDMn3xy3IhwBZ7FoE9bbJ+sc+xhtbAB2FdKWYPlD9g95KJZolUAhW62X0JhGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499501; c=relaxed/simple;
	bh=rwhwtL/vZdSfci2C/j6AljUlfCkGvdxX8zWaQP0BXQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=muosyL/BpIT99KP37WYP3BpesOYKwmGbTwf7XOHOIlQXzK05ZITasfkBAlIqSTtLDp80Y1Ub+/B1E9gxn34+XdqJYZ5xIfXO0IJ7Ds7GNOIFWfS8kFT5C+ZeZM3ubR/1PhDIumILcayRPoP5jyxaj/T3KMvoMFp72oRtk3oiYa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FPzWWIKc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768499499;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BiyawKDjYdDN3hhvAQEOzn6Z13gC9C2oLhMaZUIuXYQ=;
	b=FPzWWIKcumaEveFF9G2p0Hn/UIpEM3OmZMgt69GbktJXDeBc+gRDOvlXAW95/lBP8KPxiY
	/19dTA69X9LHp8KliBX4hoJhsOsVev6twB5hDUdcpEY3hYDrCO7H6aSq9HLNVWtdBCBsqe
	AIMLhzycAoLt5kmu8qKg3FDWRSBVGEc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-5f8AQrb0P5W7CwwkCV64nw-1; Thu, 15 Jan 2026 12:51:36 -0500
X-MC-Unique: 5f8AQrb0P5W7CwwkCV64nw-1
X-Mimecast-MFC-AGG-ID: 5f8AQrb0P5W7CwwkCV64nw_1768499496
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43284f60a8aso932876f8f.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:51:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768499496; x=1769104296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BiyawKDjYdDN3hhvAQEOzn6Z13gC9C2oLhMaZUIuXYQ=;
        b=n1VK8q8ZSt6AIGKe8YiX1dVnYyGp7djHjSQ7w+Shnnl+dmH8uxQeMGxleQyjs6avD2
         bSmAJD7VCL4hGJcMsn7Xlkd3hPCk5D4AV/2LtdcWjw45dn78YiyaZ6XRlNHk97h6iA/k
         8CCPhh8SSYkKnxMCtKhuK4shls5cVGrilTRTh3Xl2gEjoTD7KpreAQnyotxiwgxlQi6r
         pM8HxzawqBJseHXjlUcPr8eNYPP9SpvLmXYMMCQCnFKuplsVZC2nXTgYyeYdcFfdUoqA
         wKt1IYUzApPGatL7fc7RIossNZ4CLaTsyc6GxKKbBak/yIjhDu513mBJJCGPjZ1MblUY
         PoAw==
X-Gm-Message-State: AOJu0Yx9k/y/hds0l2yZ1zxq1UVoU2n8lru3L7GS2h20KgnSjNhVvWq0
	qPU7Ykn79df6DDrR3nU1NnAre2B2ldliitQBSp3bXYEx9fwWDBtdT5hqnOsmI0ATRzIRJUNfy3T
	Kjo/5eGS/nx+NB6Nw9DACM6vKzfSs5VkxjtbJuRw9I65/tW8ld0EL4g==
X-Gm-Gg: AY/fxX5g3jcXUHP/1ZJh09VHjKtg+erbNy+RbSYHe571XSq3cbsMS5iF4BMxWikcnon
	WUBdgkIT5lggEXQRrHfahpB7TUq/2xC9TqWc7xbTEaURZkxVwU1/12Ab01HG6hmRBP8w9RrsOLQ
	o98TN2Vr+6j6pnS6sOaU0/Lu6h0TLTOIOTNau5Pxo1ywYQOjjDqcLL2q/0si9GcD5z4JSvcuxOf
	bnD7U64MptYjw27cnYDfNcR5fqY6ZJkt92TVkkQj2cgBwh1sqlWWZCk8PRUojZjt80jv60Ui2rb
	d2sKVKc9rUTTRbHctCaG7+AsQJTDHNJI3lk7sWpo092YH00igNN7vHkY9Ht5nwwP5CcD0LK8g+y
	mIPI8S6ZVFL5EaqZ0kVJGf3k4MrSc/rzPDbsw9o7h/g7TfB10PZuBo7Yd9w==
X-Received: by 2002:a05:6000:1845:b0:432:c0e6:cfcd with SMTP id ffacd0b85a97d-4356998af3emr255077f8f.22.1768499495684;
        Thu, 15 Jan 2026 09:51:35 -0800 (PST)
X-Received: by 2002:a05:6000:1845:b0:432:c0e6:cfcd with SMTP id ffacd0b85a97d-4356998af3emr255043f8f.22.1768499495216;
        Thu, 15 Jan 2026 09:51:35 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569926ffcsm355884f8f.18.2026.01.15.09.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 09:51:34 -0800 (PST)
Message-ID: <2b38fed6-dcd5-4ae7-8e46-4abec54ed82f@redhat.com>
Date: Thu, 15 Jan 2026 18:51:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5 00/11] arm64: EL2 support
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, maz@kernel.org,
 kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <csscff65cagzfgyvsseufdqupde64z5x73llmzgzci7u43pzbs@fv7pfn4jxrdv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/15/26 6:40 PM, Andrew Jones wrote:
> On Wed, Jan 14, 2026 at 11:56:52AM +0000, Joey Gouly wrote:
>> Hi all,
>>
>> This series is for adding support to running the kvm-unit-tests at EL2.
>>
>> Changes since v4[1]:
>> 	- changed env var to support EL2=1,y,Y
>> 	- replaced ifdef in selftest with test_exception_prep()
>>
>> Thanks,
>> Joey
>>
>> [1] https://lore.kernel.org/kvmarm/20251204142338.132483-1-joey.gouly@arm.com/
>>
> Hi Joey,
>
> So this series doesn't appear to regress current tests, but it also
> doesn't seem to completely work. I noticed these issues when running
> with EL2=1 (there could be more):
>
>  - timer test times out
>  - all debug-bp fail
>  - all watchpoint received tests fail for debug-wp
>  - micro-bench hits the assert in gicv3_lpi_alloc_tables()
>    lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?
I tend to agree with Drew. Do we want new tests to be merged if they are
known to be failing?

Thanks

Eric
>
> Thanks,
> drew
>


