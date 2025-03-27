Return-Path: <kvm+bounces-42106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31282A72C36
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 10:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0F821748D3
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 09:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0085D20C46F;
	Thu, 27 Mar 2025 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WNmS/rFu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB4118DB1C
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 09:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743067092; cv=none; b=B+uvGRNXBhgiZjor2R/yJpB2/wRpkb1DXwtIkl4FnNWgDuvm84Fg85t9kK/+zpwELVYc+rYYiAq5CWN6tDlU/zH3XVKja6vVzOyQRjYR4GcHC2qeVTNEH9qFf00swnAyiqmuBXoSpJ+fse53y49sBNlny1N3HWqywa1iK0dJ9Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743067092; c=relaxed/simple;
	bh=Ev6op6sM15VCGysaQs2NpJ70AHSnjZnuHWVUWKJfAlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A+2FoR1ATlKQ7/9ToE9cmg4A2Wi4WIZmhbAYUpsEmwtXjLzqLaSgRc2+dh7yS9qOifr5vOInH8IJmXMBZtCL7ALXhJyMWnM4HD21Md/sB7Lbhywmc5zsP318+N1dMW69qyfu45qdvKmOHzqMKnpzWaxnuoEegpe/ItjJGeDKLpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WNmS/rFu; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39ac9aea656so584171f8f.3
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 02:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743067088; x=1743671888; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AdqOBa0Y+4+hMz6T43UiEMBnLkl2i23ABjw2IJz/f/k=;
        b=WNmS/rFuPq3ghGjZ04iMOGH938UDc2VXEMZyM8EA6ivKplaESLSZkHB7Mz9t0y6m4E
         BQwBmQ1NF9ylh/WBM2EOHEZZjGtAAVcKU32yixZjCYjVDcoBSkkdThHeRJ2X3cLaKdIi
         LAFyiavsdnrJIghyG2ZsejLDdMASvX4P6sIdiu0ICzs1kV3qzwCE7VuthCU30P9+BORW
         nG+95u3ZSgVV3ULKc8or40/7kc5qeJ4D7teDi5Bng/rQluP2LfexKwuUWuMf2RNiHHOv
         MuD6Jxhs1JEy2D/MSj27+fEH85skgVjG4552gVDZBnm0/EC82HN1lQ6alqhrVfKe/kGj
         ukwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743067088; x=1743671888;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AdqOBa0Y+4+hMz6T43UiEMBnLkl2i23ABjw2IJz/f/k=;
        b=Gg7+MZed5mchegqdkp1a9vifqjqv6wOAQrMVBKa2gmfUyJcSNd70raov//l554YjCE
         aFAgMFqUT9B6/f9yEigMC5gf3t8u9H7YBYKtItJrvE/PM9zSmvlszVRvnNGhvseNujeT
         9LZJpW6zV+LLLzdT8HCJuWCVFbA5VASdl2g01Kqr8O2e8WBJR7/Y4JiODLp2bOlnom3l
         cKGAG5CpelDyWZ7elHn6IeF12AsSSSCELK41gxGLiDEvZLfEITyp55nXhTKAZAXPYqxn
         sf1lGnYeRLpbRENqTIXFLE+R54w2bDtHpxj3/yGIKzk9VG2TJ4Nx7UkuwevXaSVGIMBV
         m44Q==
X-Forwarded-Encrypted: i=1; AJvYcCXI5d8YZkXbVJM6Cu6EIwGmkfpojt6tZWoXYlpAvHgy7NfOye8ooqiXI4qmAZ4tg/7nRV0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnlORCdP9HMAXdD+wjADMYoJ3SI9vsP028ISBW4dS2guYUbssT
	cEWd/xGOW2K6CtlEJEauBzyh3TVcM00Dj5akwQPQa8r6fcytH7ZkSeOdyYFXIv4=
X-Gm-Gg: ASbGnct4VdepPr3FfygrMB2Xk6eavyk5eJxXq/H0BtW5YEAbdY9fnhEGPos8tE62oQU
	jOGUYZdkeXbWtyi+0DKQhCHgzbe5yoiFUJHILsISIQsFZTu0zYnOP1p/X0d33L/ZT6I3JYlB5HF
	CBy9IKrC8DqyrtchN2Gsc8iXcYAuAZ0yOG9/D/CqTuX1TpwZM+8blpjIokU6QdE3L7vqOP5ZeaP
	DjMRSJ6a9z4nNCfZPMjqw7yueJBZSKktMH7MkzT3acFJqUiM4U9H4uo0+xEvO4LYLMCr3DKxOgr
	qgSlezaWCF8RNyzEneRylHW5fk0qweYminU83+Yvvxrj+HIGdg==
X-Google-Smtp-Source: AGHT+IF9q6whwwkhqGN2Pk+AEph3LrTbbtoFFPYNJTAshCFIqJMIeQt7KSSkyJwJU5Ap2Rh/HnzcAg==
X-Received: by 2002:a05:6000:2cb:b0:39a:c8a8:4fdc with SMTP id ffacd0b85a97d-39ad175c052mr2069156f8f.16.1743067088494;
        Thu, 27 Mar 2025 02:18:08 -0700 (PDT)
Received: from [192.168.1.247] ([77.81.75.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d7ae6a319sm30665955e9.0.2025.03.27.02.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Mar 2025 02:18:07 -0700 (PDT)
Message-ID: <ba2c38f1-d686-45dc-ae47-924cc11d15f6@linaro.org>
Date: Thu, 27 Mar 2025 09:18:06 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 5/8] KVM: arm64: Introduce module param to
 partition the PMU
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 robh@kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, mark.rutland@arm.com, pbonzini@redhat.com,
 shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <gsnt1pulnepv.fsf@coltonlewis-kvm.c.googlers.com>
 <f7d543f6-2660-460f-88ac-741dd47ed440@linaro.org>
 <Z-RmMLkTuwsea7Uk@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <Z-RmMLkTuwsea7Uk@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 26/03/2025 8:40 pm, Oliver Upton wrote:
> On Wed, Mar 26, 2025 at 05:38:34PM +0000, James Clark wrote:
>> On 25/03/2025 6:32 pm, Colton Lewis wrote:
>>>> I don't know if this is a stupid idea, but instead of having a fixed
>>>> number for the partition, wouldn't it be nice if we could trap and
>>>> increment HPMN on the first guest use of a counter, then decrement it on
>>>> guest exit depending on what's still in use? The host would always
>>>> assign its counters from the top down, and guests go bottom up if they
>>>> want PMU passthrough. Maybe it's too complicated or won't work for
>>>> various reasons, but because of BRBE the counter partitioning changes go
>>>> from an optimization to almost a necessity.
>>>
>>> This is a cool idea that would enable useful things. I can think of a
>>> few potential problems.
>>>
>>> 1. Partitioning will give guests direct access to some PMU counter
>>> registers. There is no reliable way for KVM to determine what is in use
>>> from that state. A counter that is disabled guest at exit might only be
>>> so temporarily, which could lead to a lot of thrashing allocating and
>>> deallocating counters.
> 
> KVM must always have a reliable way to determine if the PMU is in use.
> If there's any counter in the vPMU for which kvm_pmu_counter_is_enabled()
> is true would do the trick...
> 
> Generally speaking, I would like to see the guest/host context switch in
> KVM modeled in a way similar to the debug registers, where the vPMU
> registers are loaded onto hardware lazily if either:
> 
>    1) The above definition of an in-use PMU is satisfied
> 
>    2) The guest accessed a PMU register since the last vcpu_load()
> 
>>> 2. HPMN affects reads of PMCR_EL0.N, which is the standard way to
>>> determine how many counters there are. If HPMN starts as a low number,
>>> guests have no way of knowing there are more counters
>>> available. Dynamically changing the counters available could be
>>> confusing for guests.
>>>
>>
>> Yes I was expecting that PMCR would have to be trapped and N reported to be
>> the number of physical counters rather than how many are in the guest
>> partition.
> 
> I'm not sure this is aligned with the spirit of the feature.
> 
> Colton's aim is to minimize the overheads of trapping the PMU *and*
> relying on the perf subsystem for event scheduling. To do dynamic
> partitioning as you've described, KVM would need to unconditionally trap
> the PMU registers so it can pack the guest counters into the guest
> partition. We cannot assume the VM will allocate counters sequentially.

Yeah I agree, requiring cooperation from the guest probably makes it a 
non starter.

> 
> Dynamic counter allocation can be had with the existing PMU
> implementation. The partitioned PMU is an alternative userspace can
> select, not a replacement for what we already have.
> 
> Thanks,
> Oliver


It's just a shame that it doesn't look like there's a way to make BRBE 
work properly in guests with the existing implementation. Maybe we're 
stuck with only allowing it in a partition for now.

Thanks
James


