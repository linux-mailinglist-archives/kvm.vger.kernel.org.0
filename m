Return-Path: <kvm+bounces-36745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CB097A20426
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 06:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4B121886AB5
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 05:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312A41D88DB;
	Tue, 28 Jan 2025 05:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1pp2J5o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6681487F8
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 05:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738043238; cv=none; b=X4S87ajME7hEZ2sBlrK/8Nbtp0was4ig7xHCcG1M/c7qjCiZU0mb/atdAk24w1JsGdZxpS14F6VoA7Vuf57EPahPctdrGp3La8pg88AS62Gu2hL0e5ypSFL21BH+uk/BYi53G/ce5v4rEyE9ZZUGU5qB5GVl80OzkJkr+MlxYjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738043238; c=relaxed/simple;
	bh=bSqOpBh9c+WYhpQcPwZJnbX4nNxmGrR1DPwd0RwuTs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bws4KvFYO4+1CSioZD5VFpoebBuvbuSN9D4DJkx5k3+F8U15G2/x8VKra1KDdbG9+UBKhF2Y7/S88MnMwCIHPRCqLU30wGwogQ5P4CtBIwndOpyt2myJbeW2QsnhZxE0QtfyujwASd7BjW5Dfpzgcyq0Opv5KyqD3UBxKvSnbjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h1pp2J5o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738043235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZfRypJrBXY8TUZ/BgiawVGat4WmGQVQwJaXYpw4b6P4=;
	b=h1pp2J5oV2LbLUQ7u8/l/cLg3V7VyVHldNy1UOoiBvQw4rUWk+QfAnDCoozwnZTmM3neUJ
	Q1o1F2U0QySw6yOEqbY2o5NbhlC0e771yUUJuQaXSLD2yT95tfFvIa8bJy0XND+N0pyiMY
	1vseXGZDeyw80Zogrgmc61yJvqHJpdM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-pckq1EbgNeeIIWEUNNF4nQ-1; Tue, 28 Jan 2025 00:47:13 -0500
X-MC-Unique: pckq1EbgNeeIIWEUNNF4nQ-1
X-Mimecast-MFC-AGG-ID: pckq1EbgNeeIIWEUNNF4nQ
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-218cf85639eso158009705ad.3
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738043232; x=1738648032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfRypJrBXY8TUZ/BgiawVGat4WmGQVQwJaXYpw4b6P4=;
        b=eBAiKlw/cTAjXRR8Z/Cawsqw2tV1UdFeBzgPrCJgc5RFecqBbEXgU98zXVZtXwNaQ3
         be1gRn3uR7XflCQiX43WK2UKRTFtvgLvrUrwd4rrwPvQtii0A0xPoCipNcExkO6iScA9
         eVopxyJVYJwOv/TKlUqwsbK9B6Lw9CA+lESjByPdgmMAKo4fzHfLERlrhT02exACxLyt
         fqj8uoOQBuOXWck4uHO97l4HnmWvdTvWsgDA7uyaLRCMH0d5MAGDQKVvrZAebq9DXLZY
         qoobE7gwgC8YQlGlWVps/PNrdxcysf4rBfw3nynMLijPZEL44nRMzPju4zqiIl5ycZ3q
         1UuA==
X-Forwarded-Encrypted: i=1; AJvYcCXtjAT9w9Gvyp4sQHGfLzmO4YAGVXApWBjLmDV3wkyGvSU2j6LwGXbTOwW1z3i2DCbi0Hk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPVsvK/v8k9aWOyzoR0EHptUPpFRaxrhpaBARO3jkj4VaG5g3t
	NpyybJYr1/nkAbjTZ9xqIddBWoujeHmoVmlXquig1Ob6M05YRp6ACl4YpzaoOamIY89WOgUjI7B
	2FH/1zshmKXEvvTrHw0W3436pNaNStm7wSFSI4mfERvEw6/+cBGnpwQ9qeg==
X-Gm-Gg: ASbGncvyBt7fUgVGuu8c92gDytTXEgNEhIaz+FCuTSKRIv0/yM4+WFD512HxlPspVAa
	ifos5cxSDJXUXSYxOzYwgH2LL6flwlFTIDBPdFPEkau13Q7KCE1EtRUqQzmTbXs5d23mSuambhV
	KoGK+kPyCUZq+SiRy6jzpAclTcFGDJvPb8LJ1LqyyRFx1g8ErZza5f893JYjlily2m3QUQeRU9d
	0qpMnl73EvDx2cUdqAcMOaARnG63b2o7vK39gswgH7iSotpRGkOiVW+nwGdUQbNMnr4WiZCBeju
	feGj2g==
X-Received: by 2002:a05:6a20:1591:b0:1e6:5323:58c5 with SMTP id adf61e73a8af0-1eb214a06f0mr63365295637.12.1738043232151;
        Mon, 27 Jan 2025 21:47:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGj7WcMyL/2PjgoUCXeF8pDrIwXJ8iDNSOsLtS1l4yE0zK1FCS82DOSLWaxPfSPcfKWvA2L5w==
X-Received: by 2002:a05:6a20:1591:b0:1e6:5323:58c5 with SMTP id adf61e73a8af0-1eb214a06f0mr63365273637.12.1738043231858;
        Mon, 27 Jan 2025 21:47:11 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72f8a69eb81sm8276685b3a.26.2025.01.27.21.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2025 21:47:10 -0800 (PST)
Message-ID: <1032c158-c5a6-4845-affa-f444e0071e5a@redhat.com>
Date: Tue, 28 Jan 2025 15:47:02 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/43] arm64: RME: Check for RME support at KVM init
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-7-steven.price@arm.com> <yq5amsgsrzva.fsf@kernel.org>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <yq5amsgsrzva.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 3:44 PM, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> +static int rmi_check_version(void)
>> +{
>> +	struct arm_smccc_res res;
>> +	int version_major, version_minor;
>> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +						     RMI_ABI_MINOR_VERSION);
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>> +
>> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +		return -ENXIO;
>> +
>> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +	if (res.a0 != RMI_SUCCESS) {
>> +		kvm_err("Unsupported RMI ABI (v%d.%d) we want v%d.%d\n",
>> +			version_major, version_minor,
>> +			RMI_ABI_MAJOR_VERSION,
>> +			RMI_ABI_MINOR_VERSION);
>> +		return -ENXIO;
>> +	}
>> +
>> +	kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +	return 0;
>> +}
>> +
> 
> Should we include both high and low version numbers in the kvm_err
> message on error? ie,
> 
> 	high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
> 	high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
> 

I think so since a range of supported versions are returned in the failing case.

Besides, 'unsigned short' is more suitable for the local variable version_{major, minor}
since both are 16-bits in width. 'unsigned short' explicitly indicates their
width.

Thanks,
Gavin


