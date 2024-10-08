Return-Path: <kvm+bounces-28094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D95F3993D20
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 04:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6707A1F24994
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 02:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E061B33993;
	Tue,  8 Oct 2024 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/9wsGIQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34DF25762
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 02:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728356212; cv=none; b=ecdvocoTFQO2cqHWlbp/jKWbxQEwnd9xnRBzrBFqUeuej8Er3wny4I1P6WqBkmPFYKQ06So5EF1EB0QGdPziKC/pUJqvV+Gfn2CHrT9WuqvFenJaEgJykllRF39Aukm8DwfmcDFaeTWJ1NllEJql46NdiPZZVdjokX+S5GObGxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728356212; c=relaxed/simple;
	bh=JD5rRprLSwx+mhh0teGCAAawEXaNzQDmovD5hjPdgJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L9TmUxMPxg1T+1l2RxVfVuRt3EYpjlV4dDoe9n03RVsuiq4hvCkKW8Xi70ufwl1FX7C9xv+QqYj9nmkHsyayt3mwT67/CY1uYX3jdeppvPyBUSGvcx8gTPPeECe9oiy9vaoKwSHWQz9ScHdW0OCRBeogff9ubK8UtGWUuOTZt8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/9wsGIQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728356209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KM6xf6sEqcjRtyhQgAbYMNmNaySSsAseblPrEZ4b2lY=;
	b=V/9wsGIQX9j3LcRAZKfA0QZV7UGTYgIYxviKMqCuPs5d7/IrKQI+Ipih/vw9Zkpnj3/DKi
	wcKDxE180T8B6c2G3AVTgdaR1ciL7XLjDBa5sBI+NxEd1FPeM66JttqvQUSKaGLDTmkiV7
	rc0W/rCMyoJlOjBzj7jJoOHj+e7+PS0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-oBkg1w-hMO6hh9ESlQyDFg-1; Mon, 07 Oct 2024 22:56:46 -0400
X-MC-Unique: oBkg1w-hMO6hh9ESlQyDFg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e2859da7c2so191558a91.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 19:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728356205; x=1728961005;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KM6xf6sEqcjRtyhQgAbYMNmNaySSsAseblPrEZ4b2lY=;
        b=edeKU9wfQ4I9Uxg0scY7dVqYM0wuA4Y6N5rQuKkjRPrposEkpiHKzCGAi+em8ucNe6
         zOtg5MZQ8vVc5oAzkDX2rHZwNdqx0aHZCL4alWLj0jpqjhUfu+A9PLTLb1Td7qGZmEzB
         viJm1a1yPsnmBRsfVRTpsH2d8HTVhnhpbKJedk3VsmFCLgBvoJLgOAhlux5lF+ZNpENB
         CV+Xj8sWACpicGyFImCLlMtKk+rrRD2H+PbWZm6fxe/CxYTwP6bMoJvNC9FYzDAqc9rb
         +37u43HWuLfkH67LRe2V2iirb4+AjzHSOAXjiHPVYrsefu3v1Ds4q3+nS1D3CyjObOru
         /XCw==
X-Forwarded-Encrypted: i=1; AJvYcCVM/XFzDKFKRbMb97x9LU+4fmEmmE96DFYJZedEPCMhvVM9xqTXaUsOtQ4P1Eyra5UZyWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTAWsceNomW1yuK3hmCBlYGVO204sPsLOkjqhDxTyqXJwiP3g1
	1a8ILYQzWpuysz9yBJ72o8ps0B91rCLlZS+Za6dUHlRDH9YJqPKSAyKarVqeIhzG/yi2vXNMCbp
	mAHOKpfozd0sSILC5iFZZ+tgn8grAG+9S4d7T19z9QD7wlLJfIg==
X-Received: by 2002:a17:90b:3c87:b0:2da:905a:d893 with SMTP id 98e67ed59e1d1-2e1e636c83dmr16775528a91.31.1728356205262;
        Mon, 07 Oct 2024 19:56:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0LUzICRMByd9uxAUa++9+87v1zVZqbecdEx3xdGyOmYX5ElCHosgfateZaUDyS8uZx+7XTA==
X-Received: by 2002:a17:90b:3c87:b0:2da:905a:d893 with SMTP id 98e67ed59e1d1-2e1e636c83dmr16775512a91.31.1728356204947;
        Mon, 07 Oct 2024 19:56:44 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e85da3f0sm7939061a91.30.2024.10.07.19.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 19:56:44 -0700 (PDT)
Message-ID: <6fda5d7d-4214-460c-a727-9bb3382aa78f@redhat.com>
Date: Tue, 8 Oct 2024 12:56:36 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/11] arm64: Enable memory encrypt for Realms
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-10-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-10-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Use the memory encryption APIs to trigger a RSI call to request a
> transition between protected memory and shared memory (or vice versa)
> and updating the kernel's linear map of modified pages to flip the top
> bit of the IPA. This requires that block mappings are not used in the
> direct map for realm guests.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> Changes since v5:
>   * Added comments and a WARN() in realm_set_memory_{en,de}crypted() to
>     explain that memory is leaked if the transition fails. This means the
>     callers no longer need to provide their own WARN.
> Changed since v4:
>   * Reworked to use the new dispatcher for the mem_encrypt API
> Changes since v3:
>   * Provide pgprot_{de,en}crypted() macros
>   * Rename __set_memory_encrypted() to __set_memory_enc_dec() since it
>     both encrypts and decrypts.
> Changes since v2:
>   * Fix location of set_memory_{en,de}crypted() and export them.
>   * Break-before-make when changing the top bit of the IPA for
>     transitioning to/from shared.
> ---
>   arch/arm64/Kconfig                   |  3 +
>   arch/arm64/include/asm/mem_encrypt.h |  9 +++
>   arch/arm64/include/asm/pgtable.h     |  5 ++
>   arch/arm64/include/asm/set_memory.h  |  3 +
>   arch/arm64/kernel/rsi.c              | 16 +++++
>   arch/arm64/mm/pageattr.c             | 90 +++++++++++++++++++++++++++-
>   6 files changed, 123 insertions(+), 3 deletions(-)
> 
Reviewed-by: Gavin Shan <gshan@redhat.com>


