Return-Path: <kvm+bounces-17122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1F78C115A
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 787CCB23265
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F7E15749D;
	Thu,  9 May 2024 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTo7eWSD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0F439852
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715265430; cv=none; b=c/GTpPF7gEZOev0wB1pOXzOk8TeAztjaIUuYn0Enrsxy+kZcN93qKYd1jmBP2/bNMjcjD/5iG41JFv7D6xZWUFz8hWRT4PrXUTGnI54n0mZurCejLBCzhGPXKNnucXKtR/+3lA7X7k8VPJKY94J/jmJhIEwYZtzt/SK3zcm8Iyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715265430; c=relaxed/simple;
	bh=rX2HhaPr9XjslEz/iELt3o8cY4WdThK1YOL4qhZC7cc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QRAGVXflKo23MXxrT4s0g3rvzk1B1ammXFbwKKf24iKk4djWFb6RQ1RkQm/Hx5xZBCJxiWP5FsBA8xm5FjX43UgC0pcHjJO076wXtGmH7j46arixvQsVKe7FK9HFVd4GPvJeE5Hs7BYwmn0zY5m1Cfa93OjR1mfby0lemdt0JOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTo7eWSD; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7d9d591e660so3001839f.2
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715265427; x=1715870227; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qhunxhR/OF2icvm3HmEsNbbwCxzb74IsXbKxDT8qkPs=;
        b=NTo7eWSDMbAgSOT7CINCmQClTKuqqKFXzf8sF9h8V2D/TL6uzIk6kNIRhOOZdzEMTW
         mJ9+zmh148SCPZPrjx1yCxIGvBo6MHnlbazDh1HqKyqkHbDHYDUog3Z/huvB7M1KruTH
         G4D/ZyTmCb4BjkMlKuDOLN5gYiVRGa28cjD1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715265427; x=1715870227;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qhunxhR/OF2icvm3HmEsNbbwCxzb74IsXbKxDT8qkPs=;
        b=BgVadvgxvnGk0X0RHP9btVA6bwwlysyPHvlunYG+fe1U+NJBMsWbBMsDjGE9qEFu/P
         39hqxZT6pHwxKwk3JaCFc25+MvjfJ7h7nYrApEm3rCxqhw+2rLxOkFqA6waL7IpWPFtz
         x3MPAxK2mAWDDiOfHRRMI5hh3b/ApawaGVh1+ZgS3RvN+lpTw0bIRj74lYMEm5cim77m
         Iq8BW8fvMrooDu8q+cyFVVj4U5xHp09KJMhOIa/s9htH+NiWX3JgK6qDQZkBg0ae6/Z+
         spvptlVeRM34SnuyJnCJAG1G7mIcPP8Y2jvALm2ONHOZEPY4IUkDuWpy7yvRQ8ghKM8c
         sUxw==
X-Forwarded-Encrypted: i=1; AJvYcCU8RvA3GNpNjvV2cYNQD/ZtIc6U5XRtkd2TeoFdKKopoQpJ+nqzHTbN3JYZuZ8a6PY6D6OsrvqnpbgQK4tczaEeRiWa
X-Gm-Message-State: AOJu0Yyb2+17e6qW7dr97LrABBVNt3/bKVqRWbKC/HAsV13VyA3poXvk
	S62VxVXHBt/fent7kevQDYF/+9Yacx1funE1p4vZBQMPvu+hZe78TW7SV/LTrYk=
X-Google-Smtp-Source: AGHT+IFLPV3hTUAqtiZSXFMZ3nZtJrVA8/PdzJcN3v/yjJF832scb22cGE7mYooNXziODVFLnPMOaA==
X-Received: by 2002:a6b:e618:0:b0:7e1:86e1:cd46 with SMTP id ca18e2360f4ac-7e18fd9a35cmr655432839f.2.1715265426750;
        Thu, 09 May 2024 07:37:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4893703c0c8sm386684173.48.2024.05.09.07.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 May 2024 07:37:06 -0700 (PDT)
Message-ID: <946ae22f-a4af-448a-92e1-60afb6ed9261@linuxfoundation.org>
Date: Thu, 9 May 2024 08:37:03 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Define _GNU_SOURCE for sources using
To: Edward Liaw <edliaw@google.com>
Cc: shuah@kernel.org, Mark Brown <broonie@kernel.org>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Christian Brauner <brauner@kernel.org>,
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>,
 Davidlohr Bueso <dave@stgolabs.net>, =?UTF-8?Q?Andr=C3=A9_Almeida?=
 <andrealmeid@igalia.com>, Jiri Kosina <jikos@kernel.org>,
 Benjamin Tissoires <bentiss@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, Andy Lutomirski <luto@amacapital.net>,
 Will Drewry <wad@chromium.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
 <mic@digikod.net>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Seth Forshee
 <sforshee@kernel.org>, Bongsu Jeon <bongsu.jeon@samsung.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, =?UTF-8?Q?Andreas_F=C3=A4rber?=
 <afaerber@suse.de>, Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>, Matthieu Baerts <matttbe@kernel.org>,
 Mat Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Fenghua Yu <fenghua.yu@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Alexandre Belloni <alexandre.belloni@bootlin.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-team@android.com, linux-sound@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-input@vger.kernel.org, iommu@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
 linux-actions@lists.infradead.org, mptcp@lists.linux.dev,
 linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org, bpf@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240507214254.2787305-1-edliaw@google.com>
 <f4e45604-86b0-4be6-9bea-36edf301df33@linuxfoundation.org>
 <CAG4es9XE2D94BNboRSf607NbJVW7OW4xkVq4jZ8pDZ_AZsb3nQ@mail.gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <CAG4es9XE2D94BNboRSf607NbJVW7OW4xkVq4jZ8pDZ_AZsb3nQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/9/24 00:13, Edward Liaw wrote:
> On Wed, May 8, 2024 at 4:10 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 5/7/24 15:38, Edward Liaw wrote:
>>> 809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
>>> asprintf into kselftest_harness.h, which is a GNU extension and needs
>>> _GNU_SOURCE to either be defined prior to including headers or with the
>>> -D_GNU_SOURCE flag passed to the compiler.
>>>
>>> v1: https://lore.kernel.org/linux-kselftest/20240430235057.1351993-1-edliaw@google.com/
>>> v2: add -D_GNU_SOURCE to KHDR_INCLUDES so that it is in a single
>>> location.  Remove #define _GNU_SOURCE from source code to resolve
>>> redefinition warnings.
>>>
>>> Edward Liaw (5):
>>>     selftests: Compile kselftest headers with -D_GNU_SOURCE
>>>     selftests/sgx: Include KHDR_INCLUDES in Makefile
>>
>> I appled patches 1/5 and 2.5 - The rest need to be split up.
>>
>>>     selftests: Include KHDR_INCLUDES in Makefile
>>>     selftests: Drop define _GNU_SOURCE
>>>     selftests: Drop duplicate -D_GNU_SOURCE
>>>
>>
>> Please split these patches pwe test directory. Otherwise it will
>> cause merge conflicts which can be hard to resolve.
> 
> Hi Shuah,
> Sean asked that I rebase the patches on linux-next, and I will need to
> remove additional _GNU_SOURCE defines.  Should I send an unsplit v3 to
> be reviewed, then split it afterwards?  I'm concerned that it will be
> difficult to review with ~70 patches once split.

Please send them split - it will be easier to review and apply. You
might as well wait until the merge window is done. I don't think
anybody would have time to review now since merge window starts
next week.


thanks,
-- Shuah

