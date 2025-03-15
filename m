Return-Path: <kvm+bounces-41129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B768CA62414
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:34:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1835422927
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 01:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663DE176AC5;
	Sat, 15 Mar 2025 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qsipS0Dv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BECF4E2
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742002477; cv=none; b=FNTi2qTR+zQPu2Lu22bl/pgPdTyyTHQpHV6NHLph/thpN+nlVN48ZRKEZlwwduZcXeVTeFC0ywG5s7L+UYa3VGf5ri6GKXcChAs3H/WjYQB3NKVVGAt1vwH/yu4549mIxV0YQlKlcFRvR5GPmCv8R1Nj7B7olE0Kxxc31PfrEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742002477; c=relaxed/simple;
	bh=rqMz50M9H3yFzreuyediMHQhfMZFiLl0qZcUoOUte4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0+1+ebHlvDDGPCVlo3oVNTrgtINGQo0ldMSoQegOzbVygsKRfiPROB6C6bDlJubrksaJ/TcOe0yLMiWxQoCcNTK6QkO/pa6vneZzTW0A9DqKz2LZ634ggYq1g1H2DQnsF5Zz/gqRAIBhxTRVa8jO0/FlEaMHXliI97TKpWnVuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qsipS0Dv; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2240aad70f2so100755ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 18:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742002475; x=1742607275; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hvIL3fKVMU4+5xbZi0gtfEp1oSKzKEUDT0T+fM5EEa8=;
        b=qsipS0DvEm8/HNQ/WmePhcZd1gLMZLCDiKyJU6hYFnteiTpYLo0n1g92EKoZrZ02av
         1+cUOQHCLuBeBWyjBaJBlqaVDKKHrHoX0Mk3luKVeHOBRODiEVKN/Xt5tYwesj35/C4q
         7STmAizNI8gck4VafbavnVhfoow2dkglIR04WWX32ppwGXxfIK0RzsqrzmdRVCHxn+et
         Mvua5F1XodGvyXrrf61Y+IYM2aj31PHUkPuLg95mxddSUcA95zmYNsM0TCP+7cjIQ481
         zu3oh9sCKN8NQDP1WEaFPte4FXIXXk4r59iU+4hcFjnLQj/+ofOkAjNMeApHEr+9w4lM
         zw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742002475; x=1742607275;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hvIL3fKVMU4+5xbZi0gtfEp1oSKzKEUDT0T+fM5EEa8=;
        b=oRfcM/aL+D55FurA7cON2npWgwrvlJtT09YVqJ0604eFvQ+ULjn/7e98DExcVlt/pL
         H+O4jFe1oMBzmR2pm0qKhP9D+KkR7miAPg2BjfMpmZ0iIZoNA0SXrGkL3QCo06tx+Pbr
         mlsHMQ09WLF/o5fIogXeN36Wr1zuIMc6owaB1MttEl2laPULSz9yyuSlIfVb/ms0jrQF
         +8Gvp2Bf1cwrSCE2Zia290PDWVVe4M9D22lmOp8bf1jpzr/+cXA+njqeIinr9SPCGOgS
         5usPQkTy3O4frfUHmNDVnC/xWapeZu3yaEHigKw2mpsohe1u1/zIGi5gXMl9rrulrV/V
         SSqA==
X-Forwarded-Encrypted: i=1; AJvYcCUU7qANoKnq0iLNKPohrlmYYXrI1z1Y+7eb7+3CQyiaKemgJYw1Uo1OrbX9mMDoPqMEznc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNgfdR6nYukqt8tJa4HW/aLjBTl1xwBOAeFd/okQwy7cvz57xq
	AyRYmvTK0D6neZAH2fOl0qiD5jYL/3NvNR8My2ldHx3+QK6orcJ1um9jOPAing==
X-Gm-Gg: ASbGnct2Hl8Dt0yQUw78uX97SDjUS6U5K8X93eW6/G6pvFfQRoXHRTT6xLi3iJA9jR+
	5su1fBmjg5cnv3l0HcfBmKKpe1wgJ6iguRLilecz5GZfpbSqgXhFoGIPhK7ikQhY/q08DYP+NPv
	fRqPYEXXdFuTSX7mlYbtMYGxziHgNqY6Ae4+y2oXBBjvbZPbBeLp3x2raurOIM6+soph/Xae7Rb
	z08c0wb68j0qDItJ1nsJE3ZU78uZPCOgGp8csQHmjQRsBqKh8ADVVeCXzJHTvC9MDSBxmemGfUe
	zC2qAlgwD25j7TUso7WXvH4W8EuADHrhma+B57nCfvdRFV4XBIt9YDDM2YmbwhavVZ3E0cNSABI
	PjdWzMCxW0FMW/U1M7A==
X-Google-Smtp-Source: AGHT+IGtQWEpjfINSgs1H4vMHK6YoCgbTmxFs82ZqbvJLldcI2qhAcTUK9ygq9RBHTYJszRC0D1L4A==
X-Received: by 2002:a17:903:2441:b0:20c:f40e:6ec3 with SMTP id d9443c01a7336-225f3eb1adbmr1168425ad.22.1742002474719;
        Fri, 14 Mar 2025 18:34:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55d0:5a27:ba32:f0cd:cc20? ([2600:1700:38d4:55d0:5a27:ba32:f0cd:cc20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737116b1ed7sm3638401b3a.176.2025.03.14.18.34.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 18:34:33 -0700 (PDT)
Message-ID: <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com>
Date: Fri, 14 Mar 2025 18:34:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
 yosryahmed@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, peterz@infradead.org, seanjc@google.com,
 tglx@linutronix.de, x86@kernel.org
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com>
 <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
Content-Language: en-US
From: Junaid Shahid <junaids@google.com>
In-Reply-To: <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/25 6:14 AM, Borislav Petkov wrote:
> On Fri, Feb 28, 2025 at 08:43:55AM +0000, Brendan Jackman wrote:
>> (otherwise if we get an NMI between asi_enter() and
>> asi_start_critical(), and that causes a #PF, we will start the
>> critical section in the wrong address space and ASI won't do its job).
>> So, we are somewhat forced to mix up a. and b. from above.
> 
> I don't understand: asi_enter() can be interrupted by an NMI at any random
> point. How is the current, imbalanced interface not vulnerable to this
> scenario?
> 

The reason this isn't a problem with the current asi_enter() is because there 
the equivalent of asi_start_critical() happens _before_ the address space 
switch. That ensures that even if an NMI arrives in the middle of asi_enter(), 
the NMI epilog will switch to the restricted address space and there is no 
window where an NMI (or any other interrupt/exception for that matter) would 
result in going into vmenter with an unrestricted address space.

So
	asi_enter();
	asi_start_critical();
	vmenter();
	asi_end_critical();

is broken as there is a problematic window between asi_enter() and 
asi_start_critical() as Brendan pointed out.

However,
	asi_start_critical();
	asi_enter();
	vmenter();
	asi_end_critical();

would work perfectly fine.

Perhaps that might be the way to refactor the API?

Thanks,
Junaid


