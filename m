Return-Path: <kvm+bounces-45015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F31AA59CD
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 04:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8244A8370
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 02:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB67F2309BD;
	Thu,  1 May 2025 02:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LgKxJBlV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8422AE6D
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746068115; cv=none; b=rY5n7gcOB3QLi1Wb7Oc5DqqFq2Vr6P17hog8Xhp7wM72MKk/GgZzThT962J75otDJDldyYHTJDXuC5DDebOXYzRajFzoSjZPJh+eAjdUnubtUnMvrSpohLuKTfA/VCESR6L3CalzQzB9IonWv12eiKrLKM3VuhZrDuICTVG7N+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746068115; c=relaxed/simple;
	bh=E58/Ir3nEphDsEt/8roe/A0l6EH+/+K6JbtT6e73W70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oVP7b+aMGsqBC0RPuIPCYGNnHkpbT5/W3isQ4NKjqAN7eNqtOG6A5n+aTMOY9yDNrgeEzlbWAqbV0VVTUos9hVSaN31UE32hIrKK4OX70mTZ0Ptr9xqPxYf7W5xBFbh0NJXCQg2AqC5EJFhoZeRIwHhKxy6G0ME/Lts916uZUDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LgKxJBlV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746068111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0f0P0r46I4wQ1N14Wr4dQIPr/ky0+9o8c+Aikg6Uic=;
	b=LgKxJBlVJEzOSMcyBt3gOG1eYBY3oWbjf9b55cBqgfly6gqec6XPDppZ8GOB62fA4i2i2j
	maqRDc9tjcD/ejF8TI7KSUHD/J4ThTHpWrgogK/2AqEkBSc6FfRUtHgXARXXOqEHBd4f09
	eQ4n6x+hLhw4218IbC9PWyAl4cf4h+A=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-RcQYaTPyMA-dgZtVeq6yEg-1; Wed, 30 Apr 2025 22:55:09 -0400
X-MC-Unique: RcQYaTPyMA-dgZtVeq6yEg-1
X-Mimecast-MFC-AGG-ID: RcQYaTPyMA-dgZtVeq6yEg_1746068109
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-736fff82264so433467b3a.1
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 19:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746068109; x=1746672909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0f0P0r46I4wQ1N14Wr4dQIPr/ky0+9o8c+Aikg6Uic=;
        b=k3tSRKmIZSJoAMZze67B7xAapzwNtBiF/PxPJz6vrqHPBj45XJ34mF6Xdzw7LkMLMo
         r0vWpy/ToAbuzlu4gmZJcet79VqX7/gyC+Ah3IkWtVR+D1f3aaNt2Pb5UO1PaZqzPPF/
         O7Ao86h2jYcrKial/7UkACAsQt/ND2m17+53vPvKNjw/uk3dabCV23WMSdXdjuYr6LNx
         bOSMgEa0Ra+GFn+48anwylCEoDAfQMrAmaQSpmETpHb8wd6ZNJTJB/bRuJZLxZxNo1i/
         JXW4grNDt4Ybsfw6aoHoAe4HB/JtKxv0mGhmejT3XOmMnPsVPxTskgt9RcVdyq8+/NNA
         MTSw==
X-Forwarded-Encrypted: i=1; AJvYcCV5R3/5cxGHksKiyWINBC81bV6WAo7+kZYR5PlZKl4Mnl4U1GteaVla8rg1UeChZIcjBqE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUz8HEapTtXnwc28n+PTXCxi8OkDajnbh+p7uj1McIK4dElV+f
	GKav14zHw13rb/Tg5NXvZmv21GT5qZ32cCzu8fyk+MtIl/bmRjwAZ1brld2gf2ldfzFbh7wspuE
	ziVKXIeAtxL59XBjIwq+9+7k8/AdDgNns/vo4EL4hDgDVKAEJCA==
X-Gm-Gg: ASbGncvC8TiD005VYwGM+W7wYnVD7qTvrDrwi7U//IyeBjm1KWyfjHos/oLNDBoglXw
	Np0jwRSsLrNyjF4gB0vlljI5nVNEkkpc8yPQEwhmxtYyX64bbq3ACrVTzpxaCJf//j8KFS6jthX
	SuVNBcrp/YObUSGB3EfWJNcwKTSvpVs1IQ8/3X+TU9ABxzVoCLXEXmB1/sIabThNwkq7uak9BVh
	JoXHGEjHZJa2fGwjARBZ+13uZ90hVnPpVTCE3JmqC0o1qfUYvaqokkzMKa9+9L9AY4MAEdN9DLA
	tX7ax5aijw/x
X-Received: by 2002:a05:6a00:35c8:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7404927930fmr1396644b3a.0.1746068108750;
        Wed, 30 Apr 2025 19:55:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFylzKnp6diohi3udmCDZ47tP/kvpo9wyUKWLV/9Fl+cS6PnVhqYmglGK+RzeWLQDfWNo9YJQ==
X-Received: by 2002:a05:6a00:35c8:b0:736:bced:f4cf with SMTP id d2e1a72fcca58-7404927930fmr1396611b3a.0.1746068108438;
        Wed, 30 Apr 2025 19:55:08 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a60016sm2536538b3a.133.2025.04.30.19.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 19:55:07 -0700 (PDT)
Message-ID: <770205d5-8c08-497d-b862-1be4852ae665@redhat.com>
Date: Thu, 1 May 2025 12:54:59 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/43] KVM: arm64: Validate register access for a Realm
 VM
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
 <20250416134208.383984-23-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-23-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:41 PM, Steven Price wrote:
> The RMM only allows setting the GPRS (x0-x30) and PC for a realm
> guest. Check this in kvm_arm_set_reg() so that the VMM can receive a
> suitable error return if other registers are written to.
> 
> The RMM makes similar restrictions for reading of the guest's registers
> (this is *confidential* compute after all), however we don't impose the
> restriction here. This allows the VMM to read (stale) values from the
> registers which might be useful to read back the initial values even if
> the RMM doesn't provide the latest version. For migration of a realm VM,
> a new interface will be needed so that the VMM can receive an
> (encrypted) blob of the VM's state.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Upper GPRS can be set as part of a HOST_CALL return, so fix up the
>     test to allow them.
> ---
>   arch/arm64/kvm/guest.c | 40 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


