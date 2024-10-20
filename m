Return-Path: <kvm+bounces-29205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22C559A53BD
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 13:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 814E8B20B6D
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 11:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F96C191F8A;
	Sun, 20 Oct 2024 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMR8eUxP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16192167DB7
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 11:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729423747; cv=none; b=gpGyhwm62tK4tdrpmi+i7KHXoPm5N1o2WcK3ohRozo7qLZiawW1BvDiPeKUgQ6xGWQQNBGtU8JsnPhyXqb+iXzzUaoPI24mvMqP8Iw6+DvZJIjjowrO6p60yrFLV+Fj+JZYfbsFGyzeZRJ6hALxalsDd0Hn6lxjWOeOVUyh1VWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729423747; c=relaxed/simple;
	bh=VKfcWTDd+dTtBceyNJnCC2DoZHcINguq0P9lx/LG4B4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORShQQ0kY0huo0I+Rpxg+mC7cU2T71fuowla45GXwWdvV0COtC9UMMwUMqt+i0upeatrO/0qIawotb/EpccIPj++WR1XuHeGoEc+0w0AP7XNDb83LB7d2sRaAF2z4PkADdwYFlcM89NldPZbjCkkGj0+jr9MFcmYbINlcghXJbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dMR8eUxP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729423743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Kq7cvlDYMQaarVSHp/wE5JYzf3DksplnduexfdAPJiY=;
	b=dMR8eUxPq6bMKQ2jr97iZ9G7Lp/2MQRz7MxrtkxhhABvW5l06tpzGR5TbUv/yZX7bmVhlb
	LEcI7IrEM97OAROMp3YiOsRCjTI758UZVfJpw8p6/5tD2p9WIFX94dy9LQaN0aHMaKPViq
	kKGFoebcalN65qM0zFSwBcpbAgMt488=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-M6InVFiSPyO0q9erohQKXA-1; Sun, 20 Oct 2024 07:29:02 -0400
X-MC-Unique: M6InVFiSPyO0q9erohQKXA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d49887a2cso1945207f8f.0
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 04:29:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729423741; x=1730028541;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kq7cvlDYMQaarVSHp/wE5JYzf3DksplnduexfdAPJiY=;
        b=QRnIc0UUVTLVJfj5JzclZFuTYx+mDCzh8GKGcnynQE9SVNXFNtq2HpdXUPDG0ZifjA
         MjQsxbIRjEn6/HoDEfF2Fprl9SO0M7JuLHzXWjyQHwhhzgSkJLX477bJmbk7s6ixJyWg
         lq+Ox59puGNzWHtQ2nb2Yh9CKyTuBwkM1Takud5LkUoCdlH7tyr7fE4LspznrPjeiBZI
         NZbbCrFOmBV7noth1jmtjQsnymWz+LwD6TRgHEEP5ICuBcCnCnMkGdnkHwOdCTlBpRVB
         /ALZGG1IweZ5giuUxLI04O9DreZFKFyTuFGZ5Z61LQtr4Bv6j+9t+MEqcDZNLUNPkQ4x
         kgRQ==
X-Gm-Message-State: AOJu0YyyDHmFVoKEvq2bfaj6fmGs5KHDtOLE1TTeRD/zjmW5YhWuNZI8
	QMngykz2ctWyiLuY/w5HnMhhJzgL6V9xLYPXTK2rQqUD9PvBlEEaS8mOs42747na8DokD04M0Yo
	fJ9cmZ713wm6CbYqw/KCkKABEkgSmoxxxiyU3QaK13CnmNOnSjQ==
X-Received: by 2002:adf:a18f:0:b0:374:bf6b:1021 with SMTP id ffacd0b85a97d-37d93e4c3a9mr7947168f8f.27.1729423740938;
        Sun, 20 Oct 2024 04:29:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdv8VLALCqLf7T1teKq+x+wMgGgsjBbCY5bys0ljfF1QN1cAaR7fSAhwlbBiXVhhXE7vKpxA==
X-Received: by 2002:adf:a18f:0:b0:374:bf6b:1021 with SMTP id ffacd0b85a97d-37d93e4c3a9mr7947155f8f.27.1729423740543;
        Sun, 20 Oct 2024 04:29:00 -0700 (PDT)
Received: from [192.168.10.3] ([151.95.144.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4316f57fe00sm21138455e9.20.2024.10.20.04.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 04:28:59 -0700 (PDT)
Message-ID: <206dbca3-1dbd-478c-9c3a-85d25f4f4ed6@redhat.com>
Date: Sun, 20 Oct 2024 13:28:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] KVM: selftests: AVX support + fixes
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20241003234337.273364-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241003234337.273364-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 01:43, Sean Christopherson wrote:
> Enable CR4.OSXSAVE and XCR0.AVX by default when creating selftests vCPUs
> in order to play nice with compilers that have been configured to enable
> -march=x86-64-v3 by default.
> 
> While it would be easier to force v2 (or earlier), there are enough tests
> that want XCR0 configured that it will (hopefully) be a net postive to
> enable all XCR0 features by default.
> 
> The only real hiccup is the CR4/CPUID sync test, which disables CR4.OSXSAVE
> to verify KVM toggles the associated CPUID bit.  And if it calls memset()
> while OSXAVE is disabled, kablooie.  Fixing that requires a bit of assembly,
> but overall I think it's worth carrying a few lines of assembly in order to
> gain test coverage for running AVX instructions in guests, and boy are
> compilers good at abusing AVX :-)
> 
> Fix a few bugs/warts found along the way.  Notably, the CPUID test has an
> array out-of-bounds bug that can result in false passes (I only noticed
> because it was getting a false pass on gcc).

I think this is not -rc/stable material, so for now I'm applying 
Vitaly's patch, plus patch 1 from this series.

Paolo

> Sean Christopherson (11):
>    KVM: selftests: Fix out-of-bounds reads in CPUID test's array lookups
>    KVM: selftests: Precisely mask off dynamic fields in CPUID test
>    KVM: selftests: Mask off OSPKE and OSXSAVE when comparing CPUID
>      entries
>    KVM: selftests: Rework OSXSAVE CR4=>CPUID test to play nice with AVX
>      insns
>    KVM: selftests: Configure XCR0 to max supported value by default
>    KVM: selftests: Verify XCR0 can be "downgraded" and "upgraded"
>    KVM: selftests: Drop manual CR4.OSXSAVE enabling from CR4/CPUID sync
>      test
>    KVM: selftests: Drop manual XCR0 configuration from AMX test
>    KVM: selftests: Drop manual XCR0 configuration from state test
>    KVM: selftests: Drop manual XCR0 configuration from SEV smoke test
>    KVM: selftests: Ensure KVM supports AVX for SEV-ES VMSA FPU test
> 
>   .../selftests/kvm/include/x86_64/processor.h  |  5 ++
>   .../selftests/kvm/lib/x86_64/processor.c      | 24 +++++++
>   tools/testing/selftests/kvm/x86_64/amx_test.c | 23 ++-----
>   .../testing/selftests/kvm/x86_64/cpuid_test.c | 67 ++++++++++++-------
>   .../kvm/x86_64/cr4_cpuid_sync_test.c          | 53 +++++++++------
>   .../selftests/kvm/x86_64/sev_smoke_test.c     | 19 ++----
>   .../testing/selftests/kvm/x86_64/state_test.c |  5 --
>   .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 11 ++-
>   8 files changed, 122 insertions(+), 85 deletions(-)
> 
> 
> base-commit: efbc6bd090f48ccf64f7a8dd5daea775821d57ec


