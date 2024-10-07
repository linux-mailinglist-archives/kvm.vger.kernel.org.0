Return-Path: <kvm+bounces-28084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C69993AA9
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 01:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E5051F23771
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 23:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC52190477;
	Mon,  7 Oct 2024 23:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0rFlX9q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0116D4E6
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 23:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728342516; cv=none; b=mhbmpnhZ+VCJh/MGntDlElsz9ws6hax5UXcaRqL1JJyi3ZeFLVrp+vOrS8tzy1YaSKRNdI+WAWMkLLoOw/T6gGioueoHHa4WPPGteChAuGzQOjCTrAdwBdBCyksR38Om6jp0OKnrwfD1qdVSWxjURVdvI3z9fF8PLLDYRDnCcmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728342516; c=relaxed/simple;
	bh=sFKC8oum4eACHS/9pWNfotlCf3EQRPXmA4khW9IqDfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=um/5oa2avYLsthDPFQifT3e8luOt1IPbWnvu7kdLuZKP3radRih4PEt5cR00t44A4q+FZyfEZYFwMwgE/AW4sCuD9/JNrgOvqGOGVQjGf5JjJaS262DL6j2ls28QxHzUWv8CQvBqqykshw+Y1XWL7trc+QtbLM7Jly3FUGk7rB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0rFlX9q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728342512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AfJmONIqkrrRodARYVzXrl8zpLHbhe4TWvVFD3MTZqg=;
	b=M0rFlX9qPVCKtpD3aYSdEJnKpurHFsbSeMVlKyF4tFl0YS061ZInAumB907dP6Doo9CQ87
	Jg4O9wU1os3eMC7d8o0273LfwVaeBIwII5dPr7Ta9NekD4Ws9mfGQenVQfBNnCbV2J4Z7I
	NWWGhFuRQt4GtMgpvH+9ygYaOWT4MGQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-E-StIX_MMzCoHuQ0-qgltg-1; Mon, 07 Oct 2024 19:08:30 -0400
X-MC-Unique: E-StIX_MMzCoHuQ0-qgltg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-20b3b4125a0so47684605ad.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 16:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728342509; x=1728947309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AfJmONIqkrrRodARYVzXrl8zpLHbhe4TWvVFD3MTZqg=;
        b=ajdVv/qnyEvE3S1pn6UTj27l51a03ORI+6C75rIOSmt8Nk77b9Qh2qwzEKl1c2Ye+l
         KHExQg4j7N84vTFLm9II3NmzvnNTfhy/pun2pEAnMrgHcDzi5okG6Tya5jJXQx6I4BMm
         lkD6SYCa6q0R3mQrArpNiqq3k5FT3TR6GuexRz7mqWd7PGM4WlciIU8uzlNadUuHYEFt
         53XdtfQ1SIyW/FDH2LGTMgh8kvOt0MF2IipAOetk2qu/mqiGB9JAGN7WxPUIaZzZxoTu
         8rptbATGOssybICdDWjsadWjF/N9iNJucG/iZZ8apUidE1eOQD/sBbqOXQXXVN0q6hwK
         OqDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV04Mw7UyfDENrEoMD36dGsbzgx9xSR5OsvRsRNIU66VbxnqnRgSU9tv9Z+e0F8xqdYHyI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU+P8QoCB099EnyiS0uoFeM3M7CP7T8G5l+Eb5G3LpBl07Kxqr
	ZMncwXS84WXtnI8o2oJ3bia7Zac+V64OgQ0GqfczZZvlU9G0OIjHqVhLZc6g/MT/iSnQHFEnRx5
	xWdwmFSP0+4fYopFGdMe8GxRtUQUvffmNmGAUILweguKshgC26A==
X-Received: by 2002:a17:903:40d1:b0:205:9220:aa37 with SMTP id d9443c01a7336-20bfdfd31c5mr168800615ad.22.1728342509508;
        Mon, 07 Oct 2024 16:08:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxry6Ql2xA8l+3h1gl4I/L2BZcrkbVPn5b4zTTD+RDz9IJ0w2m9Xz1rJHClf446EHVSuntWw==
X-Received: by 2002:a17:903:40d1:b0:205:9220:aa37 with SMTP id d9443c01a7336-20bfdfd31c5mr168800285ad.22.1728342509084;
        Mon, 07 Oct 2024 16:08:29 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c1393175csm44740705ad.140.2024.10.07.16.08.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 16:08:28 -0700 (PDT)
Message-ID: <2ed92455-b97f-40ba-b5d6-695e885be62f@redhat.com>
Date: Tue, 8 Oct 2024 09:08:18 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/11] arm64: rsi: Add RSI definitions
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Gavin Shan <gshan@redht.com>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-2-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-2-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:42 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by a realm guest through SMC (Realm Services Interface) calls.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0.
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Gavin Shan <gshan@redht.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---

[...]

> +
> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
> +						     phys_addr_t end,
> +						     enum ripas state,
> +						     unsigned long flags,
> +						     phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
> +		      flags, 0, 0, 0, &res);
> +
> +	if (top)
> +		*top = res.a1;
> +
> +	if (res.a2 != RSI_ACCEPT)
> +		return -EPERM;
> +
> +	return res.a0;
> +}
> +

Similar to rsi_attestation_token_init(), the return value type needs to be 'long'
since '-EPERM' can be returned from the function.

> +/**
> + * rsi_attestation_token_init - Initialise the operation to retrieve an
> + * attestation token.
> + *
> + * @challenge:	The challenge data to be used in the attestation token
> + *		generation.
> + * @size:	Size of the challenge data in bytes.
> + *
> + * Initialises the attestation token generation and returns an upper bound
> + * on the attestation token size that can be used to allocate an adequate
> + * buffer. The caller is expected to subsequently call
> + * rsi_attestation_token_continue() to retrieve the attestation token data on
> + * the same CPU.
> + *
> + * Returns:
> + *  On success, returns the upper limit of the attestation report size.
> + *  Otherwise, -EINVAL
> + */
> +static inline long
> +rsi_attestation_token_init(const u8 *challenge, unsigned long size)
> +{
> +	struct arm_smccc_1_2_regs regs = { 0 };
> +
> +	/* The challenge must be at least 32bytes and at most 64bytes */
> +	if (!challenge || size < 32 || size > 64)
> +		return -EINVAL;
> +
> +	regs.a0 = SMC_RSI_ATTESTATION_TOKEN_INIT;
> +	memcpy(&regs.a1, challenge, size);
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	if (regs.a0 == RSI_SUCCESS)
> +		return regs.a1;
> +
> +	return -EINVAL;
> +}
> +
> +/**
> + * rsi_attestation_token_continue - Continue the operation to retrieve an
> + * attestation token.
> + *
> + * @granule: {I}PA of the Granule to which the token will be written.
> + * @offset:  Offset within Granule to start of buffer in bytes.
> + * @size:    The size of the buffer.
> + * @len:     The number of bytes written to the buffer.
> + *
> + * Retrieves up to a RSI_GRANULE_SIZE worth of token data per call. The caller
> + * is expected to call rsi_attestation_token_init() before calling this
> + * function to retrieve the attestation token.
> + *
> + * Return:
> + * * %RSI_SUCCESS     - Attestation token retrieved successfully.
> + * * %RSI_INCOMPLETE  - Token generation is not complete.
> + * * %RSI_ERROR_INPUT - A parameter was not valid.
> + * * %RSI_ERROR_STATE - Attestation not in progress.
> + */
> +static inline int rsi_attestation_token_continue(phys_addr_t granule,
> +						 unsigned long offset,
> +						 unsigned long size,
> +						 unsigned long *len)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RSI_ATTESTATION_TOKEN_CONTINUE,
> +			     granule, offset, size, 0, &res);
> +
> +	if (len)
> +		*len = res.a1;
> +	return res.a0;
> +}
> +

The return value type of this function needs to be 'unsigned long' even it's
converted to 'int' in arm_cca_attestation_continue(). In this way, the wrapper
functions has consistent return value type, which is 'unsigned long' or 'long'.

Thanks,
Gavin


