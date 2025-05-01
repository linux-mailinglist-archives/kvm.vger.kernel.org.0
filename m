Return-Path: <kvm+bounces-45021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23603AA59DF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 05:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C4C59C5D91
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E01230BD2;
	Thu,  1 May 2025 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h8qZTEyT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB7B79C0
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 03:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068778; cv=none; b=e2OWkcl3TeL9rnfHuU0MyNyKLwPuf34Oz0FPjDMMGox9u/KggrQ5JRjLc5NDQczvFORbN5NRNZLXzzxBjZNb7OUEIg3LIVLhnvC7jiRGXn4wz0bGGJBxInJB+MiYlc9nf0ODp9/boWhCHaGYY9wg6OqJdzeqC/PseEMNxs95qlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068778; c=relaxed/simple;
	bh=X/XhkrFmWidZvhk9MnMyADxxQYnJ6LlWfI1v/DRQrcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LhBUHzNRg8xPZvZFmBVG59VBVxGuZwD6ULqMLFmbGjTCIGV9kWMHquRdc3DuQOXVMOL58Fw9/LkReUGaps2V875wABqATAudN+wmH3THk5aLw2Wa07qGxKFF6CZX5Yf5oCCpKo4ixl62VO7TUniCssOWn0pdgdVlivqb474QAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h8qZTEyT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zBUyB0Q8zMsFcB5UcneuetEe4xDQ4aVw4JfTOnTTULU=;
	b=h8qZTEyTzTw+YYY8eslPvuH5rrC4cuty3NrDHRkshHBZBJBjUG7jD3bCtB1m0Aliqn1rrf
	5xyqgjAbf0ueyuOSAj4RHJr2rnI2Aiinv3Zq9aUs6IWGmMzvtfbE//qbyw1AhclVMw0Zid
	ZLcvkCni2fczSvp2ee5tOjwBNGC4pOM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-jKcAj6b6Ol2zmvTiR4AnbQ-1; Wed, 30 Apr 2025 23:06:13 -0400
X-MC-Unique: jKcAj6b6Ol2zmvTiR4AnbQ-1
X-Mimecast-MFC-AGG-ID: jKcAj6b6Ol2zmvTiR4AnbQ_1746068772
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-736fff82264so440557b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068772; x=1746673572;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zBUyB0Q8zMsFcB5UcneuetEe4xDQ4aVw4JfTOnTTULU=;
        b=UYF1p4SiQHIGD7FQ3vw53Qt7iSXMFsOu/r4AfwAkWQM6DsV4i9mQ1LP/9bHt5Vq72o
         19CqEHNBBB+iFk4SJuTKcUqBlibfsagHN/IXutIN3A7BZwDatamZxMWX1NVERW4ARuml
         lbwlw+0Fe4uviM6vf2zu0gT3pAaXmsVyAYz2ExGkCRgN4T+9tj61Dd/YWD1x4Q1+a5qB
         MGHVdrimKujKwAg6032NCmlla0RzXWG3eqf+jhyAke2mD9NHLojT7P5J42Bk6Rtui1yc
         0LupgQiGMQyWP4dJhQvRCOgQE653UVkGerb0MZAPdv46Ag1Tq3h9j9Ss1IBQSYWo5/Ez
         k6qw==
X-Forwarded-Encrypted: i=1; AJvYcCWppQr5ubyN1xtxg5aQEg1RHUXDhKw9CFNiUkPW9iY1YwHCy1SkXPuyToPtwmUkH170G+0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7JV+rruTZB/dt0cj1B9ilyJD8Kg4DvIZuZxyHXnkIazo39ocd
	563wgQWNdfHjJvJh/k1s0A4X4UaIwWr63Kj3PHDddZnL37i8BH46pUybl83d4SAmeRio2zeVx+i
	m0T44s9ft537yhdx5o3Dpkpv3kruSO63gIKkSZshMqX3sdPW1eQ==
X-Gm-Gg: ASbGncvTpdzobmu3npCSdLt0TVqBqsZ7IzeXWWlwap2Fy+Ewf17xJZg2Hm5BHM8NFSv
	SFBQsijf5/NnQVqN7r5iqG+cT2ZF36n2l7BQZ3qiSZK3ZfY1uBbdvNr+JHQ8WNGIgOiAs4ePaWu
	3cKmMadIZMi/yuoBY0cy+9gmaAz0mzmflPtveq6Kfbr4d3O+tfeaPE/+OHM1z2c+nSVsMLuWKDm
	DF3dmQQm8/GveFO3OrRKFRS3/w2NQXLHhb18ZxwE0RuyuYp+W4Lrk2Co8gqCyJpoCf0jSS8ln1x
	JnB4m5NqcsVk
X-Received: by 2002:a05:6a00:35c8:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7404927930fmr1444808b3a.0.1746068772421;
        Wed, 30 Apr 2025 20:06:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqFyaQqRxd5YG/d2aF2wgTwFAOyBR0cwvIicbDZqnls7TSQ0mJMT278uEe4KH0+EWzXzgDGQ==
X-Received: by 2002:a05:6a00:35c8:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7404927930fmr1444772b3a.0.1746068772121;
        Wed, 30 Apr 2025 20:06:12 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a600a7sm2560107b3a.130.2025.04.30.20.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 20:06:11 -0700 (PDT)
Message-ID: <8a21a392-5ae6-4d55-905a-0956f48853ba@redhat.com>
Date: Thu, 1 May 2025 13:06:02 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 43/43] KVM: arm64: Allow activating realms
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
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-44-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-44-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> Add the ioctl to activate a realm and set the static branch to enable
> access to the realm functionality if the RMM is detected.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/rme.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


