Return-Path: <kvm+bounces-24492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D85F956878
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 12:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41A161C2199F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 10:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A7D160883;
	Mon, 19 Aug 2024 10:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UfLay9HI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A8B160865
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 10:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724063099; cv=none; b=LuMYh2HtO4zT4y0mmPDFmI9y8+3P+pcLTz12XNFla3otMpZBNHGlnXuQoQqGfQggDY99+H0GVg9j9Zd7fCl/tYR14qEJHoUyxbD3wv+zf6LoVQcZJyvIHEZVKl4xk155eksXm6hDHKt7T41OsNwAfleVbSTnUJVwZM64mWJYz9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724063099; c=relaxed/simple;
	bh=vlGemqzsfU8jHJ8QPcK04ea/pP9wnl2x7ITP8eWXOG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uaLdC5cwY1bX5d9x4HbkQLflW1d3Fq/Km76AXwgehiADCvlnnDJ3kP/H9oRchlIjfw3WMFhQgg9q7N8sBVjknfmIaLVdEKKofkZVuMPxhMVuVK4W3txAE5f74DzICjtKfCjvLAAQsUkNLLTlsKGIiy3y+RlSrSQ0JAv1PYpDtDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UfLay9HI; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f0271b0ae9so52389071fa.1
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 03:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724063095; x=1724667895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAMCWzw60vhdQM6QcI1aISDsDElEXVXB9p9izZXUTlQ=;
        b=UfLay9HIyfyOlaxKat3yra9Rh4R+olUxRdAl5rtWh3wqB8LZ5DNH+muY0BvF7Tm33q
         BBf398+3S20hbFUvTgkIuqgMXK3y/Q7PQvqhVqW49RWBNq3p/tm0cHHVMNNBfZ6dE4ui
         AGKk4DSWvmIPva4dm3SnSDEwLxOaxZxqEf81Uwr09SDDy8Q1KaijCltWxsGj9NEEzFIt
         F9dWIW1Q2jxIu/0apNHmyOy+G++OSaMm3Wow/RwWSd5lxiUqw7bvsLuqOa5U6ZWvYpDa
         /B7gODZAe8kGrUrN6enHCZQDxTK87zj3It1RfOiZJtUGMNY2MyC/HD/HR39mVhLwYYBp
         0qzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724063095; x=1724667895;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAMCWzw60vhdQM6QcI1aISDsDElEXVXB9p9izZXUTlQ=;
        b=Ytmr9VNXTg2HWGOPqJatImZe8sOGSIV9x63z8kUkqKVskETc9NbCqPulnUkTrwN0Ts
         x2LNsVUNbecEw+6WezqbUiyXk2p7gXzxDut/X8RRdsvL2o3pKOdWosjam7YVoCPKBc4n
         fYWsULYhy37mq5LMzZUch09+ihRp/sJqoIDQ6TzBUl8HpRR8JkHm4zo4sDHC4BW9C7es
         yTosTfMDqHUmppdVF1nmIjWOmiocq/OI3fByX1aB7r1azNjvcToS2SSrKNhTO90gtYex
         V6Bka0GusMQCuQQA8rN3Gg9L+hMmxkOS8WAh6jTDlAbUWlUzto3rhb9wWdEcrIkU9OZD
         OWLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpUvAFVTBZwZPOPwOMv5UR1TLrgLaBXxTDrtRpAPv9cM8A2owTEcoS8jI60SXJdgtygW1ac1GLXRiEZVFpeWHAHc8d
X-Gm-Message-State: AOJu0YxiXnuYp6Lw8fL2jlBTYCTQ9QLwpVsBX54sL2j5x9i6jHy4DwJc
	Y97pfyLiPcFoTksRxYVdzC9036r/RlwHvULJf5c0ItuObTDQ/EvyI3K/c5wNzpc=
X-Google-Smtp-Source: AGHT+IF2wdXdu1KfmztZGLqlPneTcOSfrxnJEVygz5UYipbybgJHXJhrqC/84L5GVTtrgbUgXKWybw==
X-Received: by 2002:a05:6512:1087:b0:52c:cc38:592c with SMTP id 2adb3069b0e04-5331c61ced6mr7084552e87.0.1724063094890;
        Mon, 19 Aug 2024 03:24:54 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7717:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383934585sm616209266b.107.2024.08.19.03.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 03:24:54 -0700 (PDT)
Message-ID: <d8cc987e-8007-4820-b493-df2364b31774@suse.com>
Date: Mon, 19 Aug 2024 13:24:53 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/25] KVM: TDX: Report kvm_tdx_caps in
 KVM_TDX_CAPABILITIES
To: Chao Gao <chao.gao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-12-rick.p.edgecombe@intel.com>
 <ZrrUanu3xYZyIshY@chao-email>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <ZrrUanu3xYZyIshY@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 13.08.24 г. 6:35 ч., Chao Gao wrote:
> On Mon, Aug 12, 2024 at 03:48:06PM -0700, Rick Edgecombe wrote:
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Report raw capabilities of TDX module to userspace isn't so useful
>> and incorrect, because some of the capabilities might not be supported
>> by KVM.
>>
>> Instead, report the KVM capp'ed capbilities to userspace.
>>
>> Removed the supported_gpaw field. Because CPUID.0x80000008.EAX[23:16] of
>> KVM_SUPPORTED_CPUID enumerates the 5 level EPT support, i.e., if GPAW52
>> is supported or not. Note, GPAW48 should be always supported. Thus no
>> need for explicit enumeration.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>> ---
>> uAPI breakout v1:
>> - Code change due to previous patches changed to use exported 'struct
>>    tdx_sysinfo' pointer.
>> ---
>> arch/x86/include/uapi/asm/kvm.h | 14 +++----------
>> arch/x86/kvm/vmx/tdx.c          | 36 ++++++++-------------------------
>> 2 files changed, 11 insertions(+), 39 deletions(-)
>>
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>> index c9eb2e2f5559..2e3caa5a58fd 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -961,18 +961,10 @@ struct kvm_tdx_cpuid_config {
>> 	__u32 edx;
>> };
>>
>> -/* supported_gpaw */
>> -#define TDX_CAP_GPAW_48	(1 << 0)
>> -#define TDX_CAP_GPAW_52	(1 << 1)
>> -
>> struct kvm_tdx_capabilities {
>> -	__u64 attrs_fixed0;
>> -	__u64 attrs_fixed1;
>> -	__u64 xfam_fixed0;
>> -	__u64 xfam_fixed1;
>> -	__u32 supported_gpaw;
>> -	__u32 padding;
>> -	__u64 reserved[251];
>> +	__u64 supported_attrs;
>> +	__u64 supported_xfam;
>> +	__u64 reserved[254];
> 
> I wonder why this patch and patch 9 weren't squashed together. Many changes
> added by patch 9 are removed here.

As far as I can see this patch depends on the code in patch 10 
(kvm_tdx_caps) so this patch definitely must come after changes 
introduced in patch 10. However, patch 9 seems completely independent of 
patch 10, so I think patch 10 should become patch 9, and patch 9/11 
should be squashed into one and become patch 10.

<snip>

