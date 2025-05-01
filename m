Return-Path: <kvm+bounces-45024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6256AA5A03
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C2993AB7C1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F0F23182D;
	Thu,  1 May 2025 03:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SufTvMUC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E522F389
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746070861; cv=none; b=ar7jpc6DpyQpirLcVA4rxSUol580F6FzbIQJyiozDC/77JKj16z/aFIV6M4Vjxsh+VI1X/pAQA/uclYWvyc2nTJm+OAFGROGRhNKp/ppalYsjKymOcHWFbHU1DBqrN/rTIUTwUSHT1wVrENv3vxy+m3ij9fFJ4M43a4V75/GNuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746070861; c=relaxed/simple;
	bh=bh50DBjTplxiLTSZLJtA78HDHGJdoYyqa23SgjBMZaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aCBGZGCeQhyKaRaCJ0d/4nE7TOGfC8gNEVTAMsUzQVT1hD1zrjw/snurQtRQC1HEaoqQWd9iQS50IjuFANT4BL4UdN9uzk9Ht+qI9WYLn5irnIU9GBh04N5In4CiSLa5+binq8LyYy1UJhZqgjGI650PzFNxUqpFOGAvl+MezeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SufTvMUC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746070858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TBzfpKZnt5CxAomKzEA1Dj2dpRWqVssdq1NJBzT2e30=;
	b=SufTvMUC5fkhSUfgDrOuMQBlslsL1ARxM9Yfa6RyAy4hTEw7PjU+kt5z6IE04Q4CI3UEap
	/a1YSyGYND5rm2IionnGJtpJwRDaHEAluOnCVwfet/z8mnjrgMAJetsxnY++eDglzMRbjk
	NLm/N8NQP284JBOFDiTzcavyTaluEPc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-yAETzre9POmuez3mj_0_6w-1; Wed, 30 Apr 2025 23:40:55 -0400
X-MC-Unique: yAETzre9POmuez3mj_0_6w-1
X-Mimecast-MFC-AGG-ID: yAETzre9POmuez3mj_0_6w_1746070854
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-af8f28f85a7so337923a12.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746070854; x=1746675654;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBzfpKZnt5CxAomKzEA1Dj2dpRWqVssdq1NJBzT2e30=;
        b=BgiLn8Av4q66JXc0w+7gTn7DcbYHkRjUO51oxL1+VgWmC+QAojTagVKB+h/BJRyRfp
         oj/KBRQlLPle8oXgUDNgl5HuZaICpV0cN89Z4JnxBcutrFZ60CEHlDyX215x8volRnYA
         JXgkDTByjuN7ll66x+Tvcq8PzLURMgt0zliPzMS6W3BkI7EVplRb+BdV++mGY13AVFFN
         V2D1tGcF72IEXFa/VkFhRx1U2bJWRf816WHokBpwWuaPrhlFVIWxILNDFvQo421Xifqx
         NlCdS8RO8eoIPNkPgEIuG7TDpWs+hlPtri5/L5y91NfonrioWxx3LyZ+OghLw9nzG1ng
         +xmg==
X-Forwarded-Encrypted: i=1; AJvYcCWTnxRTfWmkoPrnK1+x5McqjOc4nGf8ntB8+fsgsg6+6+hWsoPRYkKWWy5NhFsIzz94u/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAed0hmleEJM6exNEp7MV+3UzvZ9is8tzojwP1nY0PMZMhxb4Q
	jeba1zhZT7YSqtoWZWFbs+HlnD2YhU7SEzkVxtLLB13m7YynT3EDni6rQXN+0/SAO1XJAW4BAy/
	OHnAb2QOFKk1YMGhkiU7XX8CV0Vkh4JETP/jikxofgzNJfcgIBg==
X-Gm-Gg: ASbGncuvcTw5jdCxlBDOrTcWig6j5pwCGoBxE83VE+/2GYraUx2+9YKL3uwBxBqCDWd
	BRG2auOrpx8hxgIzlyOxujkAaImWjZMsBxlkfxTiNm3H1w2v4Dwgzh/fa8Qv6UVc8ZZLbU7vQmh
	2SUGD1gUvot2aP2qiPYvyR2TQPg89Pd+nX1BkwYIjyBu6WfNMip18v4cmVK6wKO8HzoH6oqL5Ch
	ccqgC9o76/awHQQj3Pxj9CWDOsdn8aXcxf/U/4+AqCTMcrIRmCSi2kWKmwz2kXoLPtlHWnu69/9
	WaOtbQcK9/km
X-Received: by 2002:a05:6a21:1788:b0:201:4061:bd94 with SMTP id adf61e73a8af0-20ba74f9efemr2316701637.19.1746070854028;
        Wed, 30 Apr 2025 20:40:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcdCIV/XU+3thu81d9MiACXjb+DjhRRhcxhdfe4+xkJBBdN6cJ+Wf09/OtaoBNYxBmSezekg==
X-Received: by 2002:a05:6a21:1788:b0:201:4061:bd94 with SMTP id adf61e73a8af0-20ba74f9efemr2316662637.19.1746070853706;
        Wed, 30 Apr 2025 20:40:53 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a2e75fsm2624953b3a.98.2025.04.30.20.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:40:53 -0700 (PDT)
Message-ID: <0be0479c-13d8-4fc9-9128-a3d414392a5b@redhat.com>
Date: Thu, 1 May 2025 13:40:45 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 34/43] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-35-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-35-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


