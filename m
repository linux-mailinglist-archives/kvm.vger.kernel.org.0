Return-Path: <kvm+bounces-39040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 25749A42BBA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A713F7A4C93
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9D8266193;
	Mon, 24 Feb 2025 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AQ6oCBKV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038B85B211
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740422389; cv=none; b=pMtu3Gb8wA19gX6v7BeNooCTjDSJkKcelnR/VbqO1jtCubRMYrxZAr4j6j9glD37KfmtWgkciAhz+fHcelY32M2dzqToF7scFy0ckQb7CJLRZoGdwL9+znHPwL1o96mZARd6ttGsEgNwS2GYQTKyT0f4HF7SQviGz0S9oMKZOq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740422389; c=relaxed/simple;
	bh=17WXvve8KQac6zX+R+4Naj7K5+dLJdHWaTN6UDlVQ2Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rWfjpk4nrHJtvA9skuKsx9egiM7R+1MSg/mYWRn/rhKfDya3UbLPqsKBi8JkpNkOteLmzwv4X5YqStaDBvhKlEzUoWsxmHmMit/WKW6BZXPPwMvwN7v4K5kSesr08OwOScIKmPsKboIU/nVu6dIgigPWmI37CdOgEHdg4SUt0hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AQ6oCBKV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740422386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hjEUyHwOXVTWGrdMyVvXac+RzjdIiQNyg6ok0Fq2o54=;
	b=AQ6oCBKVGTPtl/Dm1V/qyTcYKXOK+hrKdsZkebfQ7ry8QXvW9gVUBqLNLeJlP29WOV1fSQ
	T0dd4QEmrWVObWPLs1F1O/cBavkLkqbCQBM5yoQAuOGF+L3FRdynWdnl1Luv8xFmwkxivL
	HUygXPFZTscnDpaLOLfX+fbCuuXZpfo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-OKW7gGrYNLi2tChdmiYv4Q-1; Mon, 24 Feb 2025 13:39:45 -0500
X-MC-Unique: OKW7gGrYNLi2tChdmiYv4Q-1
X-Mimecast-MFC-AGG-ID: OKW7gGrYNLi2tChdmiYv4Q_1740422384
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38f28a4647eso1938344f8f.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:39:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740422384; x=1741027184;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hjEUyHwOXVTWGrdMyVvXac+RzjdIiQNyg6ok0Fq2o54=;
        b=eTM0qIKiFbFdlbqbCcMujcw2zSxA2FaAi+E3NG7ZKYbZvQ3MBX+94ombPrntZHUy5v
         ZfZLyOcAImoZ+M7ZwOFS/HgPVp9MAsMgmyZFZugLPGaAdGomHNUnJ8yQ0hdj/JPybf6D
         4K9gkWKfTVwLH/ZR6nKIt0jhYGVMr9X9theLIixp9cFlNy8bNNGz02jB4Zs2KBpiiFBd
         wC+b0KfW0FHzT2yYzPPCG6FpGYOM5a7ncIDo3lBgUcSfin9aEtyFgxBk8ny+Re0CFXi3
         653g3IDCcdr0c+O6bhCCtsXPGUndBkhVJjmYNJ3jSRIyodzlI30XTjFHLek2FOnVAEe6
         Il7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCIIk7fpZDkdV6wDXmmbrjUsKHEtvnNET3uw3NLGGh0XPoEqsi0AsZ7yLEneXcR2FUYMA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz5gxzYVB8lmwpeH60iWmJkYfo83Xw14p2lNaaFHh9/JLSFXn6
	Vs+IdQgF71l2l5kmdPh9pw/UByBydmrlmXIPlZGcYmVhgbBKHbbPuWlqiUkXFAL6Ln9N8koZunO
	UsD5WHXOh5tY52PsBt4VP4RJ2xog04KYzTHv6gRcWV4/Is8c2mQ==
X-Gm-Gg: ASbGnctnQR/B4W/04DIxhQ2OE9Jpt7BI6s1kxH0jvKBJqPJR4VcQVjXGBH2DD9EWEe/
	sAzRo03USwckiJDfZZrOaqz7MCHHaFSaEJwtIaj8P169X+L/HzzG0lQjYhH9GNnum/ZX0nXDXLe
	NOLl75Eyx9FNSV505fDtpJq5nZHqlnB0azA48jsGt7SXkGDHRtUL0jStVdWT8HdXqlgT8j7mINP
	UwBlc5n7SSYnUoFkuJCJGFSxVwqBkdxW5OLch8IyI3GVjG8/tTvkYU+QnovltRziwi0eS2dU5AK
	mhiLSufhEbUHe5LSZZ+c
X-Received: by 2002:a05:6000:1f88:b0:38f:6697:af93 with SMTP id ffacd0b85a97d-390cc5ef413mr110551f8f.9.1740422384022;
        Mon, 24 Feb 2025 10:39:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF8QBPsKUxM4TvjlFph6t12eGMjkQHjGM7uJzw1fITu60B8CDyiB6RK3SMiLUQxVzwe+zdKVQ==
X-Received: by 2002:a05:6000:1f88:b0:38f:6697:af93 with SMTP id ffacd0b85a97d-390cc5ef413mr110537f8f.9.1740422383696;
        Mon, 24 Feb 2025 10:39:43 -0800 (PST)
Received: from [192.168.10.81] ([176.206.102.52])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38f258f5fb6sm31846189f8f.44.2025.02.24.10.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 10:39:43 -0800 (PST)
Message-ID: <bb9e45ae-11ae-43bb-b53b-cf2e9dede3e5@redhat.com>
Date: Mon, 24 Feb 2025 19:39:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] two KVM MMU fixes for TDX
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com
Cc: rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250220102436.24373-1-yan.y.zhao@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250220102436.24373-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/25 11:24, Yan Zhao wrote:
> Hi,
> 
> There are two fixes to KVM MMU for TDX in response to two hypothetically
> triggered errors:
> (1) errors in tdh_mem_page_add(),
> (2) fatal errors in tdh_mem_sept_add()/tdh_mem_page_aug().
> 
> Patch 1 handles the error in SEPT zap resulting from error (1).
> Patch 2 fixes a possible stuck in the kernel loop introduced by error (2).
> 
> The two errors are not observed in any real workloads yet.
> The series is tested by faking the error in the SEAMCALL wrapper while
> bypassing the real SEAMCALLs.
> 
> v2:
> - Use kvm_check_request(KVM_REQ_VM_DEAD) to detect VM dead in patch 2.
>    (Sean)
> 
> v1: https://lore.kernel.org/all/20250217085535.19614-1-yan.y.zhao@intel.com
> 
> Thanks
> Yan

Applied to kvm-coco-queue, thanks.

Paolo


