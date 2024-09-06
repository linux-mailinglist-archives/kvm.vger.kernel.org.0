Return-Path: <kvm+bounces-25970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D30896E6A8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 02:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 196C51F23674
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 00:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A77101EE;
	Fri,  6 Sep 2024 00:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fmGug765"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988F3D68
	for <kvm@vger.kernel.org>; Fri,  6 Sep 2024 00:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725581515; cv=none; b=RtmHD7OVCxmeC4roNhaG2cjr9rcHZcezHsgP968fY6nv7UDZt8KhznRn27qaSShVA8nrMyyPgvbpyIV/58RWOa2U80dY5NSwClrX6Fmggxje7IGhJBOOGS0jmz3QTb4XPK+h1NAU9UY2vfYyzViJ5e6SjSYdtl3QnJ4bOKsk0Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725581515; c=relaxed/simple;
	bh=WiXv8hX9YZancIkVdHpHwSwJynH9Vx0kkTy6hfFFNvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NN0fc7hFvt2rUYarOOfcjz+iLfvQd9z5bbo4zoAPOgdMsodDWdRSjk1QCglQ4R/YmAOEClHNpBwHS33Fh3K5JTpArjvMoKHDEB84Z8Pu+GQJ9YEymprCX4/f2cpdcgrb8zNxhApmPJoqPATTdVw3angvqDpTE7bufKPdgSgm45o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fmGug765; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725581511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JCf63UUAEsoVjhHUgMARlZrjCRqgXN/a16VIpsPHI30=;
	b=fmGug765axj+S9OMTSzB66N4PD4oE3/FDgIdWPFqGes9hnAJ74m/XIPlF8mv8W06R+TWB+
	5LVtAOIlha9wAsxIOYWTx7OjnR+c+JHjZ7fEaUp+TaNGH2fllRMKkUwRLH6evTE0VWzrga
	137uteBRMRlNFHkbqr8iDqp/nQR+G7o=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-wjbUoXUwO029p81sMxmQww-1; Thu, 05 Sep 2024 20:11:50 -0400
X-MC-Unique: wjbUoXUwO029p81sMxmQww-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7178f096d62so1656689b3a.2
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2024 17:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725581509; x=1726186309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JCf63UUAEsoVjhHUgMARlZrjCRqgXN/a16VIpsPHI30=;
        b=mZUXr4LJdtlxlfPoejUxt3DNX2iHcpGtqhYn3qdfbiv4IUtW6kK/CRmMSblwz0L/gJ
         JHh5ZIJ6Sj4Mt5FPfX6HQsGr/mZvjrCOED/Amypt2jSGNVQR5+FU4aQ7RAfJskPMEnDA
         J7R/LdBaIaeC0Gp3Yz6ClkDvvPTDc4TqpZw5GtKjyFQZYD7HnKYGtRyKSsYwXkc5J2r1
         XCWJFIQmrKmxrgTQNrnqv/G9LFUTY0pxSlLiXY4+zkGqoCATo+OgJnd0krZjZW+FEfN8
         yep0txDdYB2d3GmWGDA2buWPF06qaUJ53FykdR7lsJNbRTmiYnbr9Wl8zQ9MgfLgLYoK
         N0lA==
X-Forwarded-Encrypted: i=1; AJvYcCW1jlYAI69fYByRoSL4r+ja17Fk/sBgkQkvLZEoJf7ikh+SPlQ9Ew6kwD3sGcHbP/O5AGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTYakvH3DKI/VeBBycU2x8/5UEZcc+sT/LJgtBASz3+WDUKW75
	xXxy6YeBCFkbhll8GVLt4fL0eBB5wwchDPDKqsrIc87zVRV2FhPTdYQLzpVVwMU9jcUYAaKQVqH
	0Je1yerj0cFwyf7qH6PW774dvZ9/jCHP7XJjW8MFnK6Jpkq5LFA==
X-Received: by 2002:a05:6a00:2d89:b0:717:90df:7cbb with SMTP id d2e1a72fcca58-718d5f32a78mr828849b3a.22.1725581509037;
        Thu, 05 Sep 2024 17:11:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQ1mDgKhDpSBr33m3qRjdU1KN0Ixr0d3LiEv3WDkhrTsLXZpCco0dlZ/A1QyM+Jkkdv532Jg==
X-Received: by 2002:a05:6a00:2d89:b0:717:90df:7cbb with SMTP id d2e1a72fcca58-718d5f32a78mr828823b3a.22.1725581508457;
        Thu, 05 Sep 2024 17:11:48 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.31])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718087d92ffsm535625b3a.153.2024.09.05.17.11.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 17:11:46 -0700 (PDT)
Message-ID: <fc168fe2-2b19-4930-85cf-047260aeaef0@redhat.com>
Date: Fri, 6 Sep 2024 10:11:37 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/43] arm64: RME: Add SMC definitions for calling the
 RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-6-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240821153844.60084-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

On 8/22/24 1:38 AM, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1
> 
> [1] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>   * Update to match RMM spec v1.0-rel0-rc1.
> Changes since v2:
>   * Fix specification link.
>   * Rename rec_entry->rec_enter to match spec.
>   * Fix size of pmu_ovf_status to match spec.
> ---
>   arch/arm64/include/asm/rmi_smc.h | 253 +++++++++++++++++++++++++++++++
>   1 file changed, 253 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 

[...]

> +
> +#define RMI_FEATURE_REGISTER_0_S2SZ		GENMASK(7, 0)
> +#define RMI_FEATURE_REGISTER_0_LPA2		BIT(8)
> +#define RMI_FEATURE_REGISTER_0_SVE_EN		BIT(9)
> +#define RMI_FEATURE_REGISTER_0_SVE_VL		GENMASK(13, 10)
> +#define RMI_FEATURE_REGISTER_0_NUM_BPS		GENMASK(19, 14)
> +#define RMI_FEATURE_REGISTER_0_NUM_WPS		GENMASK(25, 20)
> +#define RMI_FEATURE_REGISTER_0_PMU_EN		BIT(26)
> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS	GENMASK(31, 27)
> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_256	BIT(32)
> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_512	BIT(33)
> +#define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS	GENMASK(37, 34)
> +#define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER	GENMASK(41, 38)
> +

Those definitions aren't consistent to tf-rmm at least. For example, the latest tf-rmm
has bit-28 and bit-29 for RMI_FEATURE_REGISTER_0_HASH_SHA_{256, 512}. I didn't check the
specification yet, but they need to be corrected in Linux host or tf-rmm.

   git@github.com:TF-RMM/tf-rmm.git
   head: 258b7952640b Merge "fix(tools/clang-tidy): ignore header include check" into integration

   [gshan@gshan tf-rmm]$ git grep RMI_FEATURE_REGISTER_0_HASH_SHA.*_SHIFT
   lib/smc/include/smc-rmi.h:#define RMI_FEATURE_REGISTER_0_HASH_SHA_256_SHIFT     UL(28)
   lib/smc/include/smc-rmi.h:#define RMI_FEATURE_REGISTER_0_HASH_SHA_512_SHIFT     UL(29)

Due to the inconsistent definitions, I'm unable to start a guest with the following
combination: linux-host/cca-host/v4, linux-guest/cca-guest/v5, kvmtool/cca/v2.

   # ./start_guest.sh
   Info: # lkvm run -k Image -m 256 -c 2 --name guest-152
   [  145.894085] config_realm_hash_algo: unsupported ALGO_SHA256 by rmm_feat_reg0=0x0000000034488e30
   KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) hash_algo: Invalid argument

Thanks,
Gavin


