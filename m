Return-Path: <kvm+bounces-29459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E369ABC28
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 05:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2B532845EC
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 03:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CFAA1369AA;
	Wed, 23 Oct 2024 03:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QqF39cjY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A783F9C5
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 03:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729654179; cv=none; b=dH4mMBqC2nU2Ayj5Tu0/gEU7wn3ky0ga49/fYaEB6dn2KRx9tsaiSvS7DrvRuENxN64dh9Lk0QUXp/korEGOP2FKWRBGC1Hmjr6r+iFOF/kZ0S3fUrQKs6TP3wLrKiAukhbnX0ns5CBU571qdslFo1bHu/iNf/d/s0kXJPD97Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729654179; c=relaxed/simple;
	bh=+6Fpco6V5O5W5cKFQk4z7cMXSUa3B3pMKCtFO1yDXmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vc6hCIhD2JqXQszAqrHx16au5G1D1jFVwwPmEdH39Knr4Wm6UkPoS8EDqUzOJV1NLOX7xgI7nh6D/QC4viXslKPg0ODZWJoLknev3G2qK7w9gfEXp+0YG23B4ct2zUTXw5kPwKoQA2+kH/b3Gqo0ZqplxA7KVfp2LW3od0hjRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QqF39cjY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729654175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BxnxAqHSQi/PSdbsWFTBVvnXn1V933dFV5xw+gHP+cE=;
	b=QqF39cjYDzuPfMCsHWiowAs2fW1B3sI6OT/MWbONUNInFzhZIPlwytNpAGEhYnwJQ21Lp5
	W5kGc1+CET6NG5C+2n8/TLYhc5qcFaasRFyKJHhKd9mUqEvF2d05L26Batmpc6aQIdvmK2
	BEDk4EK6lOUodqrOm4iXH72ZvX1RSkY=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-lS6BNkDVNVGsIH5T_Dj1tg-1; Tue, 22 Oct 2024 23:29:33 -0400
X-MC-Unique: lS6BNkDVNVGsIH5T_Dj1tg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-206da734c53so73306375ad.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729654172; x=1730258972;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BxnxAqHSQi/PSdbsWFTBVvnXn1V933dFV5xw+gHP+cE=;
        b=rtHeV5VfIBTWmRoK5wGkMhyUi1fDQMbtDg4gQ4ByLddp9rumpku9B8bywLbHCCLiDO
         RvK1TaQwqlrkSEZhsfoUvKNHsx0BUlraPpr7o11BeGIPllkAo6XN/Qi308U+I6mXXude
         AlleMEgjqJwYQInjnuaePFXzb0AwNgJ0C8T1fV3VfSmGlCNM5C64iTtUnwKTV4gggKNs
         PwlSlgy8NI695TBevfap0ZQUClQkpOdatnHmzkWY6/T67HPAFeCFMuZG94pX+mqAAiCO
         jI5qT5VmLE424ofi3yBDzzP6S4Lv6Y4Br1AKHyo3t3VtOZJnvytB6sZXb221vMpY1jDT
         XSLg==
X-Forwarded-Encrypted: i=1; AJvYcCVtcrMJmJs89Br7rD2zdRmOBGg3NX9XXlNFOoRN0nipk7a6SCZDKTre7xt3aRfka47Ua5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNXBBA+xseYSOkSM+413IKnjohMJyDCRF1FwcZHPjdsnkPuB4a
	1VGNe7bIx6SFBaVY8R2OPX2tf6kHP1M+UJap5C9OO3xRGgQNspe/u8qmbPsJbiXIBvpoBY7j+Zg
	1bkXwWLWvYhkqQwGQcYLb8yk90DxAjRcruWIrEc1q1gi8k0k8Ww==
X-Received: by 2002:a17:903:2341:b0:20b:c17f:9dad with SMTP id d9443c01a7336-20fa9ec370amr16333855ad.53.1729654172467;
        Tue, 22 Oct 2024 20:29:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/KUd89Pt2YvF/xk5+quJmm3qmrZIAqXkpVnz5dgxwgUq57HEfxmUaUue1V2fl4MBr5OEe5A==
X-Received: by 2002:a17:903:2341:b0:20b:c17f:9dad with SMTP id d9443c01a7336-20fa9ec370amr16333565ad.53.1729654172128;
        Tue, 22 Oct 2024 20:29:32 -0700 (PDT)
Received: from [192.168.68.54] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7ef0cf95sm49357305ad.70.2024.10.22.20.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 20:29:31 -0700 (PDT)
Message-ID: <ceda1171-04a3-4e81-86c5-ba5c1ec31c81@redhat.com>
Date: Wed, 23 Oct 2024 13:29:21 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-11-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241017131434.40935-11-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 11:14 PM, Steven Price wrote:
> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> Introduce an arm-cca-guest driver that registers with
> the configfs-tsm module to provide user interfaces for
> retrieving an attestation token.
> 
> When a new report is requested the arm-cca-guest driver
> invokes the appropriate RSI interfaces to query an
> attestation token.
> 
> The steps to retrieve an attestation token are as follows:
>    1. Mount the configfs filesystem if not already mounted
>       mount -t configfs none /sys/kernel/config
>    2. Generate an attestation token
>       report=/sys/kernel/config/tsm/report/report0
>       mkdir $report
>       dd if=/dev/urandom bs=64 count=1 > $report/inblob
>       hexdump -C $report/outblob
>       rmdir $report
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Avoid get_cpu() and instead make the init attestation call using
>     smp_call_function_single(). Improve comments to explain the logic.
>   * Minor code reorgnisation and comment cleanup following Gavin's review
>     (thanks!)
> ---
>   drivers/virt/coco/Kconfig                     |   2 +
>   drivers/virt/coco/Makefile                    |   1 +
>   drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>   drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>   .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 224 ++++++++++++++++++
>   5 files changed, 240 insertions(+)
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>   create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>   create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


