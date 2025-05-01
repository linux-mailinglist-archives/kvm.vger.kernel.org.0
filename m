Return-Path: <kvm+bounces-45027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 084B8AA5A0F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8195E1C03FD6
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E571EB1A9;
	Thu,  1 May 2025 03:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQWibwIc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685E1FCFE9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746071447; cv=none; b=c2l06qro264/eXUeJYAWwqGVh9nsbdiz7ThA6jWnYdipBFbQ03gwx/mZq4Gs3hc8+Uz+YrgFX1k131mi1yROx757mNPgsA1r30N/ON64AwAg8o/VTkJGCSn73h4aUHGbd/jKHwg0ypgFnCCrDBZeUW/r4ZQfOYQ4ddVuJWQpkm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746071447; c=relaxed/simple;
	bh=2dAVFnoSWIkTOqjHfYENLB8pzU1NdvuV0xq8Gvel9G0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gejz3FMwUc2p2UZR71bpqU/CBKKqaT6zjLpC7ulf516MN132iNFaMWxhZSNUHsagWYs/unM7K5c/L+QlmYDdoIkuk2UHL9uQBanug0/MJFRuyidb+kJBBaeFgY1HYc8+Y5pXZl3NN5LpfCiFVTxIfggX5mGRciytZag/KR7ndls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQWibwIc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746071444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xu+Kf0+DFCNXRO2ndZGA8xUx9TD/werA57XUeiFDww0=;
	b=IQWibwIcdfF/tz6XEWtD69Y1E/jrvkb0eq6SmtQgm9vHB40Dx3kTY6bgi/7VmTXnLwLtdX
	O5EnP7FCTnfsFxF38MrkTFgB0XNUmimQMjEia4geXwnjptjzG9yGqQ6ns15Jej8fjhOHhY
	Lagw9xCQvOAg30I/L/5WGh3xgWRkNFU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-EXuCzrW3MbmLzVHZm4qm_A-1; Wed, 30 Apr 2025 23:50:41 -0400
X-MC-Unique: EXuCzrW3MbmLzVHZm4qm_A-1
X-Mimecast-MFC-AGG-ID: EXuCzrW3MbmLzVHZm4qm_A_1746071441
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-736b431ee0dso520534b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746071441; x=1746676241;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xu+Kf0+DFCNXRO2ndZGA8xUx9TD/werA57XUeiFDww0=;
        b=sa6L28f0VJTM5HJNml/ciFa/8jKLT3r0hOLZjVepUckgSgZo3LeyL7v/drTSY8jT0m
         vdy7qCqn7i5u/yz2JfO9IEzlDQ7ZN4qRLoM9f2dajtsFmJS4hjOThhrSVGZp4mWYofDp
         Oj2CLL+OdHt4ybQhgqkG5QVQey8mGpDptaLIKwQnAx46nFMa6amcxDgglHinRavR4aUU
         dfyqWcGlorR0oXHG5KyXypnLSzBHFZfGWeI2lWgB0TqecvvXLDm9lxe+rVipA2TnKZM1
         8UYeR7JVfxgzRCg7CovlUkUnocZI1QUXnAnUSs/7XkzsLIKX7/wFZ70P7bfy01KYyGnm
         TrKA==
X-Forwarded-Encrypted: i=1; AJvYcCVSi7fMTT47Ndl9iWzGIpq8h9LYFB7cJrfKKT5DSHpIpMv5lWV2OFAInFwRxB5qUGijqZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzNgh5nGkao8OFuhZmPJf7v/o5fI1ecEeHYP+/ws+LaE+v5mI4
	41cUf46WX6j+qxgazFTsh9geuE/Wlt0VdLKNKl3EpKgyXXmyhungxoQupk5eu2MxIBBxXHF1bkH
	70vvbSKl9VmxIUZMlni2K3xtl0qOYv1CkOCR48Jd2NuJCErj2oQ==
X-Gm-Gg: ASbGncssAGjBRdQiXqUBElRMG4zlI2rcO5MYgWqAfH+lSeJwRd0QwmvXhFkOrXR3myS
	BY3ZBAIfKyWTa7+X2e9hyZcdSgoVUaFqR9OUOhbmEmpPbeL5Bc0Qnrnh34HKBb6zus5enspcLP5
	0mHLbFXSvVfK10D9xbpbGmUClcOMLE+mLibEki/0kKUcxn3KxZhAsx4mL9e6TZNS73TA5/wlm40
	LGbyI6NVxyFiFSbgg9jbAdSEkNd4aAgJQ7tEhmbhkqvQcjQ7J2jJNaD4SrI8TKpt46E+UORzb2O
	Wb7MOMqPID8j
X-Received: by 2002:a05:6a00:2da3:b0:736:a82a:58ad with SMTP id d2e1a72fcca58-7404923a33dmr1298189b3a.15.1746071440943;
        Wed, 30 Apr 2025 20:50:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+2TUVWiAQRNStfJKlXXyrEy8i+Rkh7KlouLhbtQWVsBfOICdI6sUfx8nwE+QueIaBYA6F7Q==
X-Received: by 2002:a05:6a00:2da3:b0:736:a82a:58ad with SMTP id d2e1a72fcca58-7404923a33dmr1298168b3a.15.1746071440658;
        Wed, 30 Apr 2025 20:50:40 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a2e5ccsm2541439b3a.110.2025.04.30.20.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:50:40 -0700 (PDT)
Message-ID: <87f40de1-dd3b-43e2-aa67-8d7b6288acf8@redhat.com>
Date: Thu, 1 May 2025 13:50:31 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 38/43] arm64: RME: Configure max SVE vector length for
 a Realm
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
 <20250416134208.383984-39-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-39-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Obtain the max vector length configured by userspace on the vCPUs, and
> write it into the Realm parameters. By default the vCPU is configured
> with the max vector length reported by RMM, and userspace can reduce it
> with a write to KVM_REG_ARM64_SVE_VLS.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>   * Rename max_vl/realm_max_vl to vl/last_vl - there is nothing "maximum"
>     about them, we're just checking that all realms have the same vector
>     length
> ---
>   arch/arm64/kvm/guest.c |  3 ++-
>   arch/arm64/kvm/rme.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 44 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


