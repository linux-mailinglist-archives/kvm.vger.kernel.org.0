Return-Path: <kvm+bounces-26174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 727D1972614
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 02:10:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2863A1F2466C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 00:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEA4748A;
	Tue, 10 Sep 2024 00:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6qyQFOg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7502594
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 00:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725926993; cv=none; b=hXCLtIsjmLHUtqtLhFLb4Km34YDuiLRxrIUgrdNzlhtPBNuIu+w+GX1u4CheCMOF7I1n0lbBLvB12r4ATcLpLtdF1SgFoZhvWlvGEcrLjka2p41GdnpwpEkNdjLM2aGVVvC55Cyvdu/iRzOayCgFLZnv8/bRV34x7Fkz6tDzfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725926993; c=relaxed/simple;
	bh=V+ndQboUKQbl2kpi9ghwnfZz1sbDkngsuOFkFc275Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nh3nIoPs1Xei6p7NNXMeDk9q3CxJVN8o9Fh/SaVdCsrkf4h8/oaKTiFS4Cr3HbVITqt9zryNH9WldlN4ht5FmXLsul42eNBs6mBSG7WMFOgvMvbBSb4AMtAgUbJAhHtVNIAdCt7UGFBKNaMb7QJ8qBOyhufmb3KDrjrjtqfIC8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b6qyQFOg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725926991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMaP86bC+hPhOjPzwPjEKilwC9SBm5gKL8ioVFK2IxE=;
	b=b6qyQFOgnv1t4X1UngXsgxFeYmoxva3+LyY1zbO473HJfx9Zz6qFwBBHeVQok+Lfi5BZLD
	GuPPuhRNQf7rDD2MulUTQLJYDQqsCgK/IUvuLAs1xXs8KivqHo/A7YzeSwSK02oly8RnjJ
	McpBGb0mBShxr6gBWDdzZvaHTrkmhf8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-a6mSjoX8P5aBsQgnfvusfQ-1; Mon, 09 Sep 2024 20:09:49 -0400
X-MC-Unique: a6mSjoX8P5aBsQgnfvusfQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-718e129311aso2943251b3a.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 17:09:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725926988; x=1726531788;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NMaP86bC+hPhOjPzwPjEKilwC9SBm5gKL8ioVFK2IxE=;
        b=FcAmo+fNhYqXsTSv7+nqJL1GO290dH8OQm8xk0oA0W8am5Bq7XrxnUpIT3tWIap/Nj
         sLuPw7wlrw5g3t4IbpYX3ii6o74ac0v7vbB0QwCCcUEzINOxyWk3SVoJJ25Lb36WIoEE
         qT5NXHGQtQLu+1YlgcV5WmM8fRHHFydullRVkqa2Q/pELw1WuXtDpcBdc9xwdYDwCz39
         IMQdR+biRrTg/XMSnY6KGJ0OFsR65VpFEHjTX7Aq6LF+5xImaQJjj5HrLRoaxIYc1LSj
         Xtypu0RIJknqDP0TA6Tyyubj2AUN10tJlEH2nu/wuJcZOdcG2vDjcj8UrK3KBa5CrP84
         QDkw==
X-Gm-Message-State: AOJu0YzOXJjE3l/VbCpsFDCOuoJDWJF31XT9gu+iaJTNBXdXURTGL7Du
	zcOIyzsIHu+hyxxzpMk+EW9q1AH6k9ZP70IHI4ccQKb9/orbqHph2ZvE/ixf+kwWfuV43/tcDLC
	OibBzKKsBjF6Ftw5ycRhZzZgUobiaietBKN/hMKEfEHJkvpYo6w==
X-Received: by 2002:a05:6a00:2ea8:b0:717:9896:fb03 with SMTP id d2e1a72fcca58-71907eb88a7mr1676593b3a.6.1725926988285;
        Mon, 09 Sep 2024 17:09:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOPTJ+MAzzAaW9hu5Sm5LtqVY+qPsIcrMrv6ipiDOnyMneCo1T4P1xJfwBR5Lh/LAWTBHDRg==
X-Received: by 2002:a05:6a00:2ea8:b0:717:9896:fb03 with SMTP id d2e1a72fcca58-71907eb88a7mr1676558b3a.6.1725926987824;
        Mon, 09 Sep 2024 17:09:47 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fe29f6sm283845b3a.67.2024.09.09.17.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 17:09:47 -0700 (PDT)
Message-ID: <bb69bde0-4564-49d6-bbd6-95bcbd4d272e@redhat.com>
Date: Tue, 10 Sep 2024 10:09:38 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
To: Steven Price <steven.price@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com> <ZsxTDBm57ga6MkPu@arm.com>
 <2e8caa91-bf66-4555-87b3-52f469b2c7ef@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <2e8caa91-bf66-4555-87b3-52f469b2c7ef@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/24 1:54 AM, Steven Price wrote:
> On 26/08/2024 11:03, Catalin Marinas wrote:
>> On Mon, Aug 19, 2024 at 02:19:10PM +0100, Steven Price wrote:

[...]

>>> +
>>> +void __init arm64_rsi_setup_memory(void)
>>> +{
>>> +	u64 i;
>>> +	phys_addr_t start, end;
>>> +
>>> +	if (!is_realm_world())
>>> +		return;
>>> +
>>> +	/*
>>> +	 * Iterate over the available memory ranges and convert the state to
>>> +	 * protected memory. We should take extra care to ensure that we DO NOT
>>> +	 * permit any "DESTROYED" pages to be converted to "RAM".
>>> +	 *
>>> +	 * BUG_ON is used because if the attempt to switch the memory to
>>> +	 * protected has failed here, then future accesses to the memory are
>>> +	 * simply going to be reflected as a SEA (Synchronous External Abort)
>>> +	 * which we can't handle.  Bailing out early prevents the guest limping
>>> +	 * on and dying later.
>>> +	 */
>>> +	for_each_mem_range(i, &start, &end) {
>>> +		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
>>> +	}
>>
>> Would it help debugging if we print the memory ranges as well rather
>> than just a BUG_ON()?
>>
> 
> Yes that would probably be useful - I'll fix that.
> 

One potential issue I'm seeing is WARN_ON() followed by BUG_ON(). They're a bit
duplicate. I would suggest to remove the WARN_ON() and print informative messages
in rsi_set_memory_range().

   setup_arch
   arm64_rsi_setup_memory                    // BUG_ON(error)
   rsi_set_memory_range_protected_safe
   rsi_set_memory_range                      // WARN_ON(error)

Thanks,
Gavin


