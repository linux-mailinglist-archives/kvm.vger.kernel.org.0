Return-Path: <kvm+bounces-27778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A19398C120
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 17:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A50BE1C218C6
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 15:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D071CB313;
	Tue,  1 Oct 2024 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUgT9lac"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5079B1C9DE6
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727795013; cv=none; b=cUND7KGQDySP8EXW8PStHIjRQ8bMwDOwdtTXztKLVeDIE8qXS1Dem487TGuyhId2Cubtp860/XI9bA3tox4B5wseTXZgn7vQej0FwURHjJcvNQ8szMFNKW9j6cK4y5s6wMFLkmYh906lk1baQfRVeQ9yJvsSi4tP0q32vPsB3W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727795013; c=relaxed/simple;
	bh=a36TtCxZorLJFO8OVamdE/V6wmc28LyfRDlbsngo66o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jc87lTlET1BHLnNgQzZDmAVZ+sewmrKrYo2A6BVY3kiXbYaes7xtkVHXYvxAU2YdAW36TQ9dH/X17jmSVLp1RFxnlyypThRONGpD+/5s26fla39M9DQzCDRSSpiFDqzhk+anfVxc+DvOeZw+Wu5kVvevJ0WA6PNtV4ni6TxI85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GUgT9lac; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727795011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i1QiQvZu3yd3WZD17otycG0go1ri4wQwH1X2A3c/1vc=;
	b=GUgT9lacFfX+XWmAf7JyqE6FP2WH3xBx+rCwGG+g0Wde+69rZMuJIgMVTDMd09DLOHyoUI
	IgjLjETFGo4wsd6tjHDIpIzGadDxcR6Uz3OZ/UN2V0ucDchNUTKOiDeLzMfl/UbLuGYu6Z
	2dpqhhXSBhX6CC3j+EpRACEANocosUk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-g6BN2sDtMmOjATC89z04Mg-1; Tue, 01 Oct 2024 11:03:29 -0400
X-MC-Unique: g6BN2sDtMmOjATC89z04Mg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb940cd67so57101695e9.0
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 08:03:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727795008; x=1728399808;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1QiQvZu3yd3WZD17otycG0go1ri4wQwH1X2A3c/1vc=;
        b=tbnRgaO6FDAW7iT+iWzdc/naGftMfX88eNGpK845Tw6DwK06Jkj1P4BqKFPKfUK17s
         S7vgLYNDj+UZnigjieTk6QCyjgoYY8QnrviJ/fn19kpVwMw6fkomZfPU8VbcXNurZoPB
         0ocpuzsTGm0HuNGQBOw2UOy00OFGeGYlRSQ4Q3LSXGtVtQKaq2wVaM0MZTzRU5qwIl0B
         hMqWg7HPN65ihbkiQF4AZvKeRlbfXSdLw5Z034SlMULlQPczo2aJ3V98E55EFqeGD9Zl
         PrBc2ibzc4ekcg/+KzowVzuYf/UOOoRyuqJuYOXre/ZJmbVb4OPXrFHFgJGbWApR7gKD
         1PKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcWsGBse1C2jfscvuacdWqsde8D10rs7iIDlk4JDaQSk7cK1f351rBEt6gn0HICHMOcog=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4EVb0mdU1L/g6d3DfBrD2B12ITqUv291SAEs6PzhEEbV1uYs1
	JwZDTS5LBkrtNiizKpjM/6/VIWkqfESW46+guW19ibMfk2mfJuBhWCPLA+Hh9vB+r/Y448K9dRf
	+quOe5k7zhv9NBc4Z1gyDmfTS7fnh9A5UbJO3ZQ8WVJOik7Omww==
X-Received: by 2002:a05:600c:3513:b0:42e:8d0d:bc95 with SMTP id 5b1f17b1804b1-42f5840e1c1mr157266145e9.6.1727795008244;
        Tue, 01 Oct 2024 08:03:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpbeiUbZFgHyJUp8ErHvv35QbfHiWCyqtadxVhT0k05mTcQ/tTUZn3WSyxP5hXvfcRP118rg==
X-Received: by 2002:a05:600c:3513:b0:42e:8d0d:bc95 with SMTP id 5b1f17b1804b1-42f5840e1c1mr157265345e9.6.1727795007596;
        Tue, 01 Oct 2024 08:03:27 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.43.71])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42f57e2fb5bsm133701035e9.39.2024.10.01.08.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2024 08:03:27 -0700 (PDT)
Message-ID: <217f17c0-0759-4d6a-a2a2-7d01c63bb887@redhat.com>
Date: Tue, 1 Oct 2024 17:03:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] A couple of KVM dead functions
To: linux@treblig.org
Cc: seanjc@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241001141354.18009-1-linux@treblig.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241001141354.18009-1-linux@treblig.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 16:13, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Hi,
>    Just some deadcode removal; I split it
> because the second one is mentioned in docs
> that I don't know mean if it's still needed or
> how to fix up.

Let's change that to mention gfn_to_pfn_memslot instead - any *_to_pfn 
function will do, and the whole API is going away soon.

I queued the patches, thanks.

Paolo

> Dave
> 
> Dr. David Alan Gilbert (2):
>    KVM: Remove unused kvm_vcpu_gfn_to_pfn
>    KVM: Remove unused kvm_vcpu_gfn_to_pfn_atomic
> 
>   include/linux/kvm_host.h |  2 --
>   virt/kvm/kvm_main.c      | 12 ------------
>   2 files changed, 14 deletions(-)
> 


