Return-Path: <kvm+bounces-28098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB9E993DDA
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 06:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E83C6286567
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 04:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835DF5FDA7;
	Tue,  8 Oct 2024 04:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifPkfQT+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2727C3C0C
	for <kvm@vger.kernel.org>; Tue,  8 Oct 2024 04:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728361041; cv=none; b=jU57oaWYYYxo3ShHzEYCdOSVH0JHlrgGspiCVTonq1suG5+xQSQBYgKRkMOZ0fsjCFYGy+A8ewwd+ftMNwZoBnbK6NuklRVCQKDB3lr6oFutultGjaTgGb5eJk9euSXVfg+TJwRvmGk6jyveIXhsCLGuqnWrHzw43/8N2M0HMsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728361041; c=relaxed/simple;
	bh=iMlXn95lsVNsLjKDst9hTcZBOaf6Cfjj7y6Z9vIOTog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mo1EgKZAZdhOB9HG7Uw+ZzgPdKieHr31z0AoapE5eXKEGpf7hFjhtnqyA78Ly5m7pCp+l2O1P8QWZ/XfWSwuWLLcnLTuhgziRRZIm6FqYCNzuDq4YinMTA3tdiUuYvXQZ9kSzZB0p6CjtNIApxtxwKRx1WD1s+pAuRgZdcLreyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ifPkfQT+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728361038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f61bqhCr/dcQZbMurDXm0sPwEi+RQMeAt5XgpaR2Hcw=;
	b=ifPkfQT+mnlKnVddsS17i+2AHQN3wsZt/+TXlXoEu0PNK4V2cnlkDfjtDxw40IPNm+HCkj
	8B6ekNIdOWcK+0iwIBKaf+pMHm4/GauonRWeMWk1qN0eccGVYzk9s0MMh/dewH5bdMkQz5
	rFUHsXuIQgVOssDVKrqHtuAnb3vficE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-94KvbJVYPwyl4RZPfxXgng-1; Tue, 08 Oct 2024 00:17:16 -0400
X-MC-Unique: 94KvbJVYPwyl4RZPfxXgng-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-71e108cc964so583631b3a.3
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 21:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728361034; x=1728965834;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f61bqhCr/dcQZbMurDXm0sPwEi+RQMeAt5XgpaR2Hcw=;
        b=RYpc9gcp4+m4Uk9F4BFakiWAocIq3qebnqVlpaYlyupTCS375tSfXQLSjFewR3FmRq
         M1L3hc0aDqR5IYeW1xQWc5bBVaPEFcdTKVCuVKU2zKKZQ0WfFCKFsNMSuQj4/g7LDbKb
         72t/ZLtRJgggYqxPdQUell7qhZcSkpkd+KYkMHGRq1zg6m3odfVqOTUek4BGXA3oEDcE
         n7iIvaFnQ1WmrPedzRpWvnVHjh61pSgTrO8sjTN4D0KTDmQYh6qNRuD0sNpRjwuWzGSg
         /MpYDAGXHn0JG9dVoR9wgelwCdVoeKaRIS/45gdxkMBQPOe1Mp52ui4Do/aKs29OwsoP
         7R5A==
X-Forwarded-Encrypted: i=1; AJvYcCUcLTh1EKHrvxII52mBIPiNyJ5HoW+sU1hFgppF8LEQHqEdib0lySc5xq0VvFxNmBC9urI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlINM0APjAkpy3qc3TLN5VLnq6z0dJA+bAGWcXf1GEO1HkoIxn
	ZUy1k+D/9KQgu2RKNvmQehABpXS0ezc58e43bHL6Yu9Azmq930mV5tJezv+0WNPYn5Awfikda+h
	hFygj1wtvudQiLVtW0tXq5w0dszsUaRhB+DlEi/PXf6HgOPXvjOFQmoBWQg==
X-Received: by 2002:a05:6a00:a96:b0:714:2dc9:fbaf with SMTP id d2e1a72fcca58-71de24514e3mr21564746b3a.18.1728361034343;
        Mon, 07 Oct 2024 21:17:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpPFYi5/75nkediY8DO4Wu6TCkkIkTn8IxFnQ74JNSHVIEvH9PD/xbYAIthgHX0w8NyyIQ8g==
X-Received: by 2002:a05:6a00:a96:b0:714:2dc9:fbaf with SMTP id d2e1a72fcca58-71de24514e3mr21564704b3a.18.1728361033989;
        Mon, 07 Oct 2024 21:17:13 -0700 (PDT)
Received: from [192.168.68.54] ([103.210.27.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d7ced7sm5196665b3a.191.2024.10.07.21.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2024 21:17:13 -0700 (PDT)
Message-ID: <f0e83860-15a5-48d2-a256-60db70c974a3@redhat.com>
Date: Tue, 8 Oct 2024 14:17:04 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] arm64: Document Arm Confidential Compute
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
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-12-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004144307.66199-12-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 12:43 AM, Steven Price wrote:
> Add some documentation on Arm CCA and the requirements for running Linux
> as a Realm guest. Also update booting.rst to describe the requirement
> for RIPAS RAM.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   Documentation/arch/arm64/arm-cca.rst | 67 ++++++++++++++++++++++++++++
>   Documentation/arch/arm64/booting.rst |  3 ++
>   Documentation/arch/arm64/index.rst   |  1 +
>   3 files changed, 71 insertions(+)
>   create mode 100644 Documentation/arch/arm64/arm-cca.rst
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


