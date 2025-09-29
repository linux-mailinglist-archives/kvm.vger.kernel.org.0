Return-Path: <kvm+bounces-58968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C36BBA8945
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 11:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 479BD1885F65
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 09:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51D7286D40;
	Mon, 29 Sep 2025 09:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkxXBzCq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EF6274659
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759137720; cv=none; b=D/K9wN5wJuSphejYdfBldV6RdR9qMeNMNJ9WZqKTC6dSEM3sCfQLATl9lnUrW8jYAdPcR9+XsCGeYpHF15k6WzJicdTjI4vcFRnD4/WTpl6zEKLAH05h0jAfgWidRwweYJBNL+kksmV0RbQxLsJEGC70Gg6lk9ppb4quInTtBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759137720; c=relaxed/simple;
	bh=1mFtIsxgWL/cDrVYTrGXPefT0SWQMlxAe2lw1SiGW1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MExhTyaKu5jQItmffiIIvYn5FJ7RW/DYcQwx0CvqsUNYH2KlPPMo7nr2a0TeRwFYixzz7p9oKSepPKRIegGMSQ6Lu4ktQ76ezybDAt5npyZ+75ySa+rMRuUX4TnPzOvAzKy3fgWGqg6Z/7/hDEutZJsljv2meZaW28ds/fEJ5w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkxXBzCq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759137718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dgQTpwdj6I19pwH7DxZR1LuGI+OTUqSIq5i+R/eVUzY=;
	b=BkxXBzCqC/TNpuR+e44NgISmzLfIo6Vs43lIRarq0mLSff55KatThu60SrESAtZgF9Eik0
	ptHxO3vEshmrzgtgcaiFAnPiuFlkBqTvAT2d9XpANhWeiwlevJAev+VXiscajNtPjhl6mu
	xjod/LbGHX9VHbKD0bRzGG6tYWpa7qE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-wWUdxZg_Ndmtw53HOAES_w-1; Mon, 29 Sep 2025 05:21:56 -0400
X-MC-Unique: wWUdxZg_Ndmtw53HOAES_w-1
X-Mimecast-MFC-AGG-ID: wWUdxZg_Ndmtw53HOAES_w_1759137715
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso31821655e9.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 02:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759137715; x=1759742515;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dgQTpwdj6I19pwH7DxZR1LuGI+OTUqSIq5i+R/eVUzY=;
        b=TuxhunMyUzqy/WUU+rfrkIAIWHIhvL/r17LQ6hKPKnauUeGcF8SFavV6zxNLIYIjpK
         W26NeRSQA9WXD0GM5zAARYXHMR29frbHGlwLzZGN/qCvh5pbF3uJ9nzVE5iKuSdFP/IU
         GHZewHcaih3SGybRewDbT8QT1bqD5fj/cmuOfoChy0TlBM8BTpnRL+BA1yYQotXocpCF
         HgJRLpYjw0euVFEmt2oNnNYd5ZoaTA3ldmQ/XK+CR02R3JW17HOYZZOa0RvoXYhJE/aW
         SSVg9FxRFNAzmG+kMSKkTMe0L4hpOcSsBYMPeB91pMOaC9sJBY7q4LOMKws9cZ7cjGVE
         jtIw==
X-Gm-Message-State: AOJu0YxhUUAi15Npqm6U+0LRuYV2ZH3eJpqpQBo1cUCqVvrdAQmCB1xr
	aK5zicoa5K7OMHZCuEr2HiZifWvhRlzmw7zAOEqjEFPNo4xM7JjEoalsn1SXYWeQuowwKTBcDU7
	z6xqT3Js/KgXCYhzWKJbAaUxfJNQwzLopFpoP8KzqfaM1iLHiHgiKNQ==
X-Gm-Gg: ASbGnctIVgqAYU8upERA4sMiF+GV89oMkd71rpeR3gQbDG5Hb9DNklnny8w9P010uc7
	6fFvrYIrpKOi+f9B/x4LsYlsyaBs1UVPFZ5uFi9+l1/yEw963csjzy/eseM78jB57u2eU5SCIZO
	5DH+KTVuNREDgB1+QlJ4iGJON4PbSxu2vMzWuWemCCqzrrHYNdQYcR8t0elCLxeKDVmRF7LQdiA
	nb5BitTgEYHp6UplWkEmlwNQ7mV7gGcWjfv6YK1QIgdtxSTD3oSHnn53e3axfexaeiPBYbyo1Ao
	IUsPTYbagSx8OyfzpUOwxidhvL5puxPyljo9IV1hjs5iy19+kHI7zLEtsdChC98QG2pStEY5tTP
	IIbvB7QqjHCwC4WMFyi22qpyd/fVda7RtII88fUUW3dmiyCD4ojrtAyZXT94Z6bLRYQ==
X-Received: by 2002:a05:600c:1986:b0:45d:d8d6:7fcc with SMTP id 5b1f17b1804b1-46e32a057c2mr132123905e9.27.1759137715191;
        Mon, 29 Sep 2025 02:21:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGesYviK8pYyvk4J7HUCmypxt1moyxCjWTm9Bxvu0M1IPcLV+oSkce5n8tX4RYhtCkwU5SCNw==
X-Received: by 2002:a05:600c:1986:b0:45d:d8d6:7fcc with SMTP id 5b1f17b1804b1-46e32a057c2mr132123575e9.27.1759137714726;
        Mon, 29 Sep 2025 02:21:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f65290sm4788855e9.13.2025.09.29.02.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 02:21:54 -0700 (PDT)
Message-ID: <00838b58-06ba-4468-a226-8e20bf1fd773@redhat.com>
Date: Mon, 29 Sep 2025 11:21:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] KVM: selftests: Add test coverage for guest_memfd
 without GUEST_MEMFD_FLAG_MMAP
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>
References: <20250926163114.2626257-1-seanjc@google.com>
 <20250926163114.2626257-5-seanjc@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926163114.2626257-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26.09.25 18:31, Sean Christopherson wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> If a VM type supports KVM_CAP_GUEST_MEMFD_MMAP, the guest_memfd test will
> run all test cases with GUEST_MEMFD_FLAG_MMAP set.  This leaves the code
> path for creating a non-mmap()-able guest_memfd on a VM that supports
> mappable guest memfds untested.
> 
> Refactor the test to run the main test suite with a given set of flags.
> Then, for VM types that support the mappable capability, invoke the test
> suite twice: once with no flags, and once with GUEST_MEMFD_FLAG_MMAP
> set.
> 
> This ensures both creation paths are properly exercised on capable VMs.
> 
> test_guest_memfd_flags() tests valid flags, hence it can be run just once
> per VM type, and valid flag identification can be moved into the test
> function.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> [sean: use double-underscores for the inner helper]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../testing/selftests/kvm/guest_memfd_test.c  | 30 ++++++++++++-------
>   1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 60c6dec63490..5a50a28ce1fa 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -239,11 +239,16 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
>   	close(fd1);
>   }
>   
> -static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
> +static void test_guest_memfd_flags(struct kvm_vm *vm)
>   {
> +	uint64_t valid_flags = 0;
>   	uint64_t flag;
>   	int fd;
>   
> +	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> +		valid_flags |= GUEST_MEMFD_FLAG_MMAP |
> +			       GUEST_MEMFD_FLAG_DEFAULT_SHARED;
> +
>   	for (flag = BIT(0); flag; flag <<= 1) {
>   		fd = __vm_create_guest_memfd(vm, page_size, flag);
>   		if (flag & valid_flags) {
> @@ -267,16 +272,8 @@ do {									\
>   	close(fd);							\
>   } while (0)
>   
> -static void test_guest_memfd(unsigned long vm_type)
> +static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
>   {
> -	uint64_t flags = 0;
> -	struct kvm_vm *vm;
> -
> -	vm = vm_create_barebones_type(vm_type);
> -
> -	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
> -		flags |= GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_DEFAULT_SHARED;
> -
>   	test_create_guest_memfd_multiple(vm);
>   	test_create_guest_memfd_invalid_sizes(vm, flags);
>   
> @@ -292,8 +289,19 @@ static void test_guest_memfd(unsigned long vm_type)
>   	gmem_test(file_size, vm, flags);
>   	gmem_test(fallocate, vm, flags);
>   	gmem_test(invalid_punch_hole, vm, flags);
> +}
>   
> -	test_guest_memfd_flags(vm, flags);
> +static void test_guest_memfd(unsigned long vm_type)
> +{
> +	struct kvm_vm *vm = vm_create_barebones_type(vm_type);
> +
> +	test_guest_memfd_flags(vm);
> +
> +	__test_guest_memfd(vm, 0);

Having a simple test_guest_memfd_noflags() wrapper might make this 
easier to read.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


