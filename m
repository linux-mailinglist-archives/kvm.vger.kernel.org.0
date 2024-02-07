Return-Path: <kvm+bounces-8222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C444984CAF7
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 13:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80C2928CFF2
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 12:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE8C768F0;
	Wed,  7 Feb 2024 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XwJ9/kVc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AD458AD0
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 12:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707310572; cv=none; b=Dxtl9k9VlIOezfBaLDmT51azkMiO9OrVfqNBc51crm+I1Wc3HN/14BQWYkhLclGvLFRNQmkA4xIuz43Rn42/w+fOvw3cYCOfSVVBRkc0kDT/lO5Ft4b7QjYlw2BOnek3Ke8IUYVFHh9IIWQ7K10g4wmovQBe1/dcsAx/WEGlnaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707310572; c=relaxed/simple;
	bh=4w4s8GAeYati7RUQEBui/SkRd47gbmjGEuufx8ZOtdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D2GwJLYmq2btqnTxlxQ3wKtcMqQqto0FTmaEaTjmbxDQg/HyVop9SbdvJowbebZGymdq7XgRxOcfUoPTHvFPa11sDp5AAYsLTg+yYoUCd4uj3Eles5E12unS5VgKKMbD6ji5JaK87S6eWV1dYj6tFuh4DAeRnDW/xI7XLPgmvnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XwJ9/kVc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707310568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IjLljkcOjmkfh1di8sk/TzvNm0GraGUpgA3hDhsNW28=;
	b=XwJ9/kVcP5ne5Uu/zrUtKroyyeUSkp1SUxaDQNvz7ch6vD1nDxO3xbJ1pucjU5N8HJoick
	+gVzqtEJPju8imvjAFqV2yYK7VfP8M9pmNdO9JeJuA7TCEgAk7dEDSrTIfpFdyDmO1JJOi
	TveDp10MEg9yZ1pAOtuPcP3SiHTMhDI=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-N8kgkNxLOZWlYVHXND2ldA-1; Wed, 07 Feb 2024 07:56:07 -0500
X-MC-Unique: N8kgkNxLOZWlYVHXND2ldA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-603c0e020a6so8362267b3.0
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 04:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707310566; x=1707915366;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjLljkcOjmkfh1di8sk/TzvNm0GraGUpgA3hDhsNW28=;
        b=PMP2PdJift7yzJIKonDmdqpmdOEkv9S0JsLkflXySebOnb8eyxNN6nEzm0l1Dn7aPN
         F2K5YJFBBVDlUmcLhzGrjAdDfGITn05VHVRNupfEQWWSJZBXzPVW5Qp8lA6VHhnHOZ3H
         Fv1GJf++/mWQwVbkyrgaw3oPOHtJy2MVNheOsMx0Zam+a2Ws9rsTqSA1jsvu1PsDnDEg
         3scPyZCI1y6jpK8Xuq1Rjd+CHSWPChmVVbO8/+pSm7Cisams0saFI3ar9dUH1mDFFOyq
         T0Uindjj9pEp+PEr7uz5R+BEl5Q7xk2MkAJ27Re+T/CQMatZAmg31pF0tDxW4HAp8Ftl
         N+JA==
X-Gm-Message-State: AOJu0YxJbAPyJhbVjU53dUi8KP3KZRObMXXRy2aP4vhYNPVLvL2Egm1J
	aIaoQMIJjXYuFTb3IXc5J061ptvw+uh1HcStqTJfrcFo74Fde4ZYP8JwccMbO1nFZ19XPEBmw2c
	e+q8A+4GIkdZaVRsJXAJbaFw6NUH7WRx3byiMNA70mwuc7AUEiA==
X-Received: by 2002:a81:7e07:0:b0:5ef:4a7d:2426 with SMTP id o7-20020a817e07000000b005ef4a7d2426mr4480574ywn.31.1707310566087;
        Wed, 07 Feb 2024 04:56:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYTvpG27MlsryLbPhBMlMIDy/jl5qqx0QN1iCiRJomoklTijNwOrhVPd9T0itjoUQMRMCGJg==
X-Received: by 2002:a81:7e07:0:b0:5ef:4a7d:2426 with SMTP id o7-20020a817e07000000b005ef4a7d2426mr4480558ywn.31.1707310565774;
        Wed, 07 Feb 2024 04:56:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUbvebY0DHLBbpoXm/fnjGZulxd8pCjjhojAGkGAcd7WpnxeWBRBg67IuDeNig/ivTHU5HwTf5TDBpkbJnn8+VMCIme8IfMhsqPH4BQM262p9qwit0mfUit90B4ocwSCyFYuWmusQmjG+/qy30hyRqQPN800MF4
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a10-20020ac844aa000000b0042c22902ca2sm489302qto.81.2024.02.07.04.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 04:56:04 -0800 (PST)
Message-ID: <6fdbeed0-980e-4371-a448-0c215c4bc48e@redhat.com>
Date: Wed, 7 Feb 2024 13:56:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Shaoqin Huang <shahuang@redhat.com>
References: <20240202231831.354848-1-seanjc@google.com>
 <170724566758.385340.17150738546447592707.b4-ty@google.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <170724566758.385340.17150738546447592707.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sean,

On 2/6/24 22:36, Sean Christopherson wrote:
> On Fri, 02 Feb 2024 15:18:31 -0800, Sean Christopherson wrote:
>> When finishing the final iteration of dirty_log_test testcase, set
>> host_quit _before_ the final "continue" so that the vCPU worker doesn't
>> run an extra iteration, and delete the hack-a-fix of an extra "continue"
>> from the dirty ring testcase.  This fixes a bug where the extra post to
>> sem_vcpu_cont may not be consumed, which results in failures in subsequent
>> runs of the testcases.  The bug likely was missed during development as
>> x86 supports only a single "guest mode", i.e. there aren't any subsequent
>> testcases after the dirty ring test, because for_each_guest_mode() only
>> runs a single iteration.
>>
>> [...]
> 
> Applied to kvm-x86 selftests, thanks!
Do you plan to send this branch to Paolo for v6.8?

Thanks

Eric
> 
> [1/1] KVM: selftests: Fix a semaphore imbalance in the dirty ring logging test
>       https://github.com/kvm-x86/linux/commit/ba58f873cdee

> 
> --
> https://github.com/kvm-x86/linux/tree/next
> 


