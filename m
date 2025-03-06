Return-Path: <kvm+bounces-40247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A46A54EBF
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:18:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F223E7A65D3
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 15:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7851FCD05;
	Thu,  6 Mar 2025 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ThV/m0mh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E02B8624B
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741274315; cv=none; b=X3ctMFZJjD+W7McRjKSAEkN3UE7lGqddFzozevJg9fIbq/O9d3ZHsSRqgnDWpZIkdhB/1gK0wnF14fghJqIU42bJcizZ9sol/qe+wk21EJKzCTxrw8G/KbiDUEReuoAIzTqOYfiprd3m2uDr5lMcaMpah1KA1KEoCzSMyCr8toE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741274315; c=relaxed/simple;
	bh=wAOiTA+tP/5T263ZZxCvXZJv5v3ESCZNrC/EHFNcUm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VfyAZcfbPisWyswWAjGdRGndtk61duyHQSZLuYT+sMabmAzuLWuLYr1iaXlP56yKrB2p0euZEWqCf3XY9sFiWEGcn1IG1PaImJ7CznjHpkdV6yj0Cgxq+UyzcZ/1jYdQw2/lzJ696YANibeuvpYlXlDe4RJIVsy/zyA5irEPO+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ThV/m0mh; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39129fc51f8so734919f8f.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741274310; x=1741879110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IIXC/E5OlKrDuk9g0mFflx2OTFt9jKupk5/WwhMtXpU=;
        b=ThV/m0mhLSRJACcRGmHyTCPya52PyE7xjUEC3H+w6VT7B7tZFz/Q0xlsC0vP1rtub/
         p+TgUgi/2zuHDxDVPXFk6d+kw2bVhAPATyiPCOBeFcbbCA5dgnSSa2raxeMw82o5s/7k
         DVqDyPyeFjAnrYOhS5xK37ey5KZqXRqXmIMig++ClyXVm5vKIgpWDN2bUees+taura5j
         RZy/OexgxngbdHwkJb978enoQdkl0vlNJY/MSJpVrVBYjNtowwUD3x931gDFyGzZJfwS
         BIannOr+vv6rHU4ru55eULSimakHVhOLKkGBhwdW0DkgndNhoiCWS0PPdpqZ7V7hc4Jj
         hZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741274310; x=1741879110;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIXC/E5OlKrDuk9g0mFflx2OTFt9jKupk5/WwhMtXpU=;
        b=ie9Wzca9+5jM6zls19e641AtID1+qZda9zdv8wdQNLk25YmB3nuNuh7Ss/sVUVWaZy
         wZC+Ins8lJO7WQJqBt2BPhLdIliC7bRfBLrRswhddIi3IUcOra8IQjCa65czZ4Lj/afG
         fHckpdQW1xb8DzCVQwkNwRY6GyWCXnpMmntvPPagQlBakYwdr1z+usoi/ZsxuKYwRJ0t
         E9T27rk/m1iuHKY5tQqyqpIunRZFE1leYYXcJN9T+7Zj390rZyqSbdL8U8NeqJ7n7N4J
         yx5yZtibLNTYOjBnimx8MpDIVUCEWgDhzzO4zX6xhaiEVzgL/yabgmWlT/UQezlPRD3x
         TNDg==
X-Gm-Message-State: AOJu0YwoEJs1DhAl8dtCvHkpxzuuLbephnr02qnlnipyOQYMBkkwAQ17
	0ADWnqNNfxmU/RCuJtgS4zvCmVsD5VRJtJJ6wQ/cVD/8C07C9bvzvmPVCJg+LM4=
X-Gm-Gg: ASbGncvczf+nOLccXpI6tEm99OVaYlVwvkBhmuXOuGLcHcXoDgd51k42yyo03GnCzOm
	WSCHJxy1eZJFVxMGclNJAVp6VzPaABFaq4EbA387YWZS0iMht/lqP0yNLBvARntSo7MTDqP2kgo
	tSSTA1GXdToYccGgWGK1VsucZ1GrmlWiPA1IhZY0z5+W8JFhvzbmIUc5Tzy6p69eFX860uOWAvh
	6TMdpXuEFtJ7JRfOf+NAGm4Qbc+b0LW7VF4EulTwGsguP4C0f67pvpeiq+gKiyPFmoijO5JzoD5
	WkGpFdBH/i/8LAW35S9XD89+ZHrdr07qPOSm/Q4qe+La6KmRlfZwZ3aPuz+YPZKZGX43TTiNQk1
	eG49PE6rfGv1nzQ==
X-Google-Smtp-Source: AGHT+IFCi0fjVLMkviMnUgPgVJ0nwO5mlZi4c0s50RoU2djU+cKhatevNgFUGeCsxJR3YwcKPVFt0A==
X-Received: by 2002:a5d:47ce:0:b0:390:e311:a8c7 with SMTP id ffacd0b85a97d-3911f72769cmr5208010f8f.5.1741274310512;
        Thu, 06 Mar 2025 07:18:30 -0800 (PST)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0193bfsm2348419f8f.55.2025.03.06.07.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 07:18:30 -0800 (PST)
Message-ID: <95a72c57-40ff-417a-a8a2-065554eda5ec@rivosinc.com>
Date: Thu, 6 Mar 2025 16:18:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v7 6/6] riscv: sbi: Add SSE extension tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel
 <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>
References: <20250214114423.1071621-1-cleger@rivosinc.com>
 <20250214114423.1071621-7-cleger@rivosinc.com>
 <20250227-93a15f012d9bda941ef44e38@orel>
 <d37dc38b-ba6d-48cd-8d23-9e2ce9c6581e@rivosinc.com>
 <20250306-5f8b0b45873648fa93beccc7@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250306-5f8b0b45873648fa93beccc7@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 06/03/2025 16:15, Andrew Jones wrote:
> On Thu, Mar 06, 2025 at 03:32:39PM +0100, Clément Léger wrote:
>>
>>
>> On 28/02/2025 18:51, Andrew Jones wrote:
> ...
>>>> +	attr = SBI_SSE_ATTR_INTERRUPTED_FLAGS;
>>>> +	ret = sbi_sse_read_attrs(event_id, attr, 1, &prev_value);
>>>> +	sbiret_report_error(&ret, SBI_SUCCESS, "Save interrupted flags no error");
>>>> +
>>>> +	for (i = 0; i < ARRAY_SIZE(interrupted_flags); i++) {
>>>> +		flags = interrupted_flags[i];
>>>> +		ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>>>> +		sbiret_report_error(&ret, SBI_SUCCESS,
>>>> +				    "Set interrupted flags bit 0x%lx value no error", flags);
>>>> +		ret = sbi_sse_read_attrs(event_id, attr, 1, &value);
>>>> +		sbiret_report_error(&ret, SBI_SUCCESS, "Get interrupted flags after set no error");
>>>> +		report(value == flags, "interrupted flags modified value ok: 0x%lx", value);
>>>
>>> Do we also need to test with more than one flag set at a time?
>>
>> That is already done a few lines above (see /* Restore full saved state */).
> 
> OK
> 
>>
>>>
>>>> +	}
>>>> +
>>>> +	/* Write invalid bit in flag register */
>>>> +	flags = SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SDT << 1;
>>>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>>>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>>>> +			    flags);
>>>> +#if __riscv_xlen > 32
>>>> +	flags = BIT(32);
>>>> +	ret = sbi_sse_write_attrs(event_id, attr, 1, &flags);
>>>> +	sbiret_report_error(&ret, SBI_ERR_INVALID_PARAM, "Set invalid flags bit 0x%lx value error",
>>>
>>> This should have a different report string than the test above.
>>
>> The bit value format does differentiate the printf though.
> 
> OK
> 
> ...
>>>> +	ret = sbi_sse_unregister(event_id);
>>>> +	if (!sbiret_report_error(&ret, SBI_SUCCESS, "SSE unregister no error"))
>>>> +		goto done;
>>>> +
>>>> +	sse_check_state(event_id, SBI_SSE_STATE_UNUSED);
>>>> +
>>>> +done:
>>>
>>> Is it ok to leave this function with an event registered/enabled? If not,
>>> then some of the goto's above should goto other labels which disable and
>>> unregister.
>>
>> No it's not but it's massive pain to keep everything coherent when it
>> fails ;)
>>
> 
> asserts/aborts are fine if we can't recover easily, but then we should
> move the SSE tests out of the main SBI test into its own test so we
> don't short-circuit all other tests that may follow it.

Oh yes I did not though of that. I could as well short circuit the sse
event test themselves. Currently test function returns void but that
could be handled more gracefully so that we don't break all other tests
as well.

> 
> ...
>>>> +		/* Be sure global events are targeting the current hart */
>>>> +		sse_global_event_set_current_hart(event_id);
>>>> +
>>>> +		sbi_sse_register(event_id, event_arg);
>>>> +		value = arg->prio;
>>>> +		sbi_sse_write_attrs(event_id, SBI_SSE_ATTR_PRIORITY, 1, &value);
>>>> +		sbi_sse_enable(event_id);
>>>
>>> No return code checks for these SSE calls? If we're 99% sure they should
>>> succeed, then I'd still check them with asserts.
>>
>> I was a bit lazy here. Since the goal is *not* to check the event state
>> themselve but rather the ordering, I didn't bother checking them. As
>> said before, habndling error and event state properly in case of error
>> seemed like a churn to me *just* for testing. I'll try something better
>> as well though.
>>
> 
> We always want at least asserts() in order to catch the train when it
> first goes off the rails, rather than after it smashed through a village
> or two.

Yeah sure ;) I'll try to do what I said before: short circuit the
remaining SSE test for the event itself rather than aborting or
splitting the tests.

Thanks,

Clément

> 
> Thanks,
> drew


