Return-Path: <kvm+bounces-15509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC6A8ACE60
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77E621F22152
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0CC150981;
	Mon, 22 Apr 2024 13:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WcFwPDSb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59930746E;
	Mon, 22 Apr 2024 13:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713792964; cv=none; b=KRXtp1Aaio7lT+9RNuMGJzAPpl48as0mzPSrzx0pDIpzcX+k+DH+usmeLCJjLdsTsbQ3/uTb7T9h2oYzdlnQ227lnuyQWzUsCHO2Va8V4LMJWmjY0T7Fte7T9AlULdbISKG03Je6X/DrxunP431/LycQHpJ/z9k9soE7BRZboog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713792964; c=relaxed/simple;
	bh=kMa6cSAh5Y/d/P1SN45wemhSQFT9pfHTDqo3Qn/WhPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FTPuaMVW0H6Ny9PhCcG5rwj15qjd8r4OgvQxqsGi5H/OrQoJ3mo/dHB+Gpg6t5C7dfTvMPoXFUNL358TgJov+PdeNv2Yu2phmOE2/HRisgL8icTOYqLf6Z9uUVyafDEBCYGh3iF1yw1zgU2FhwC4HAY4ineUrmKta+mDcUZePEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WcFwPDSb; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e411e339b8so33305535ad.3;
        Mon, 22 Apr 2024 06:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713792962; x=1714397762; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=KkBtQ14FO+0NGu2+k0AcqXPVmwhs5oyX89ZVVK1/Ay4=;
        b=WcFwPDSbQqsyOcM+eolkD3cWs2sgolbzizSrKPLZ5vrzOcFEb8FA9/a3JoCFwo3qV2
         I9jSG9Z1MZnT/0QpiGK9//qLRBhJSPnnSRmp+vi7akvuaSroCdUw2BlyAU9H+KZ+Xa2W
         iL8nUZqYa64cIPC7/l2XlOYn2ei1y68GA+A11m6oM78Wq/BM45XsKB4dphJ7+U4KEl87
         preE4f+jXhbFZznNj2WiR+ZHAsttcfpFxdPx4ggWm37XeShtFvWvD+jSwg3NalbucTFC
         mIFpyhz7Mi5I25VgwCMO3IaMA4cyCpoDezcb+3UH/17sR1ymvEPChpk9mgoUkKqQnOpL
         aA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713792962; x=1714397762;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkBtQ14FO+0NGu2+k0AcqXPVmwhs5oyX89ZVVK1/Ay4=;
        b=RP5SkfFoGv+4zyz99cicNweh3LBZtLw+slFg6Tgp+VltUiVSEl+QYI6Na+BZDKiu4q
         zOORtiTgt9lRQsnO21b/OJGkWDzrR5+mnzgpmoeaIoESk44/eRap1Dur9YmgVzJj1pNg
         DXYNEDeL1hyWh+cc+l0ZX8s7ypnEZ1BjyoF17dXlZOV9M8+vHDLby1wbfuoAwswf2Ru9
         JYWxbSByYWMDB2PpEdJWtMkmcBGPLglpWkHO9MqGCxJnI+s6K12WGMO3fjfS+acmxCQC
         CumSDi1AmVpgZDKWDJwfkUSr5FekwR1/S3d8CqFswTojspBlDHW2pj81r9QXCw4R1JPV
         dphA==
X-Forwarded-Encrypted: i=1; AJvYcCV8ORev3WhAzH7CES9/LepcywcD3fERO+0OfYv3X7x5N+doqbOZIB6265tSrc1UanTrqDIlTPIVBkOjhklnDpZ31gnhk5d/TBBEUbVZWFFaFHeN8jT8EEZ9yNLzKuig5ji/a/ak3PGcR3Cr5m8/INP79JYjC2RMyoWlktEg1kdDphqx9kGmsAWmso1EB2mutj49HTK2NauBlq9TFwZM3JLP5fwK5g5HNGO+90NBsoA/S5h0LZniQJzyguN42nnnI32BVTqeALTA
X-Gm-Message-State: AOJu0YyoKCAyDsYg7d/VQu9EAhGGv9bUw5ts0OSZF6GjWMRu1jrIdd7g
	fiylpyiRhgOq7rVX7HsMw1u21QYcufAjuP0KEPO+25o1V+IVRbcF
X-Google-Smtp-Source: AGHT+IHkfetYNQjtXgJOGuSH2tF757po7WuioKhZ1WKUmUVhuKFeVc+0OLJzUKRopydwbd5Qo+FIMw==
X-Received: by 2002:a17:902:ccc6:b0:1e2:d4da:6c72 with SMTP id z6-20020a170902ccc600b001e2d4da6c72mr14625676ple.0.1713792962514;
        Mon, 22 Apr 2024 06:36:02 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902684c00b001e284b9b28asm8230382pln.129.2024.04.22.06.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Apr 2024 06:36:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <a0179848-99a2-4169-b7b2-1a8cddb27615@roeck-us.net>
Date: Mon, 22 Apr 2024 06:35:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] kunit: Add tests for fault
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 David Gow <davidgow@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>, Rae Moar <rmoar@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Alan Maguire <alan.maguire@oracle.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Marco Pagani <marpagan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Stephen Boyd <sboyd@kernel.org>,
 Thara Gopinath <tgopinath@microsoft.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-um@lists.infradead.org, x86@kernel.org
References: <20240319104857.70783-1-mic@digikod.net>
 <20240319104857.70783-8-mic@digikod.net>
 <928249cc-e027-4f7f-b43f-502f99a1ea63@roeck-us.net>
 <b70332b0-3e55-4375-935f-35ef3167a151@roeck-us.net>
 <20240422.thesh7quoo0U@digikod.net>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20240422.thesh7quoo0U@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/24 06:08, Mickaël Salaün wrote:
> On Fri, Apr 19, 2024 at 04:38:01PM -0700, Guenter Roeck wrote:
>> On Fri, Apr 19, 2024 at 03:33:49PM -0700, Guenter Roeck wrote:
>>> Hi,
>>>
>>> On Tue, Mar 19, 2024 at 11:48:57AM +0100, Mickaël Salaün wrote:
>>>> Add a test case to check NULL pointer dereference and make sure it would
>>>> result as a failed test.
>>>>
>>>> The full kunit_fault test suite is marked as skipped when run on UML
>>>> because it would result to a kernel panic.
>>>>
>>>> Tested with:
>>>> ./tools/testing/kunit/kunit.py run --arch x86_64 kunit_fault
>>>> ./tools/testing/kunit/kunit.py run --arch arm64 \
>>>>    --cross_compile=aarch64-linux-gnu- kunit_fault
>>>>
>>>
>>> What is the rationale for adding those tests unconditionally whenever
>>> CONFIG_KUNIT_TEST is enabled ? This completely messes up my test system
>>> because it concludes that it is pointless to continue testing
>>> after the "Unable to handle kernel NULL pointer dereference" backtrace.
>>> At the same time, it is all or nothing, meaning I can not disable
>>> it but still run other kunit tests.
>>>
> 
> CONFIG_KUNIT_TEST is to test KUnit itself.  Why does this messes up your
> test system, and what is your test system?  Is it related to the kernel
> warning and then the message you previously sent?

It is not a warning, it is a BUG which terminates the affected kernel thread.
NULL pointer dereferences are normally fatal, which is why I abort tests
if one is encountered. I am not going to start introducing code into my
scripts to ignore such warnings (or BUG messages) on a case by case basis;
this would be unmaintainable.

> https://lore.kernel.org/r/fd604ae0-5630-4745-acf2-1e51c69cf0c0@roeck-us.net
> It seems David has a solution to suppress such warning.
> 

I don't think so. My series tried to suppress warning backtraces, not BUG
messages. BUG messages can not easily be suppressed since the reaction is
architecture specific and typically fatal.

As I said below, never mind, I just disabled CONFIG_KUNIT_TEST in my testing.

Guenter

>>
>> Oh, never mind. I just disabled CONFIG_KUNIT_TEST in my test bed
>> to "solve" the problem. I'll take that as one of those "unintended
>> consequences" items: Instead of more tests, there are fewer.
>>
>> Guenter
>>


