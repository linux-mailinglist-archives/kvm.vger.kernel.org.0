Return-Path: <kvm+bounces-53397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3AEB11188
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 21:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C34BB169C12
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 19:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A9F284B25;
	Thu, 24 Jul 2025 19:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="kg5bbb9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578481FB3
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753384865; cv=none; b=XvraTBf9uKKaUqPRoFcSJdBufytJSgLTqenVvVa3R+Tw5xaAB0zGS43QdP4gV+NB5lcSx3rDAbcaEsTG9LHhtZxZYw3Yw+BrE5sMfAsiujnWt0besrY5Qf/GXTUVApl2tQQM81QFHxNi0iaRqlwrKVMcYhshIWuLJR8H+S2AXdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753384865; c=relaxed/simple;
	bh=jKH4WrlJHMmmvFI9GRcCbyu9h62vy+xT0jRCxl/vf/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BalUU+mHQiJMrTkFGToRf/QyIYJolmeMVOECMQEWxpCe60Wb3Cydya3jj5CkDY5UKZNKnZpWseEzVHeU03DZ589u14/nakqlLl9Wb/EhmJtQIFrtOMneuS4DJNeFxF43OxbYI4CzT8BEyAbf87CeOJpDVAKq4d2yhsTd01oylEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=kg5bbb9Q; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a51481a598so742252f8f.3
        for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 12:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1753384861; x=1753989661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kaRVeMq7pLWHIA7qWwBst0OckDzOp/vP4d84uEpDEhc=;
        b=kg5bbb9QpmTRCwkrfEQnuI4RHGeBczjTc/jNvpU4buUoqjK7i9w1uckmQUf2iAfoP7
         NafoQIKovxNg+TeCde/qRxdlhwe7ia+XIwLjDnIdbsQB3xd0ebx7OiKqyr4hlGdghNjq
         Rz5bVMJJzmXlZBV0FFZRvE3YeZgD/z/NFYQDIJtbVaP2pG97/i6GX0xx8LEsoRlN04ja
         gvJ8N5HFkEo/6cjYWtF0R3NPd9l2nmxDACnqhGDKsTwmevv+hT64CG9dOR097k3FTf1n
         cdk9Iy01OkdwHxeJuMd7PGxJNmIg/xJpMrl+NnHkvAXwaWhVIAKAp77/I69W/jw6I90D
         WGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753384861; x=1753989661;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kaRVeMq7pLWHIA7qWwBst0OckDzOp/vP4d84uEpDEhc=;
        b=u/MQ40bQoMo4IQz7XMAgsjgJk3xifYttY0F7Ul9VCSg9gkcws97asXlBSxl5hDTwWU
         KQSaUsib+WcQdfqbqKXCHbiS93ciZMAys1suFlX1mh3uh5Dh0jMSPsWRo8dDtIfFommq
         TOvBPfjpnFavbb9arRsGx7KawZV8WEsO31sK5uvtyqk8vNOiHYlpo8xQ93kIMOGsgopB
         Mxhf//GmFJQ68ZoSIf3YIN8/Mgyy83p9e+oFBqhGnTdbxZKmTmTaq4Fy/yTW6gpxOJhD
         niEvnAk/1W7q1ct+E1U495A7SblUa/U1z+qwUAPgNZ09nztmGD4VXBqAnLFs2+i8qo9U
         IjDg==
X-Forwarded-Encrypted: i=1; AJvYcCWJk4tdjeo/q6Bm1XQhdabif4mlD6mG3bgBA6FHwx9LxVCzTP6zau45x9x+Uhll3hbDxyM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl1DKOvuoWIbgQCmX5lQ5pddTBNrISJqEMkOoigTBYIGEm3KCt
	DYdqHk1bLBB2ZsJZB1GFAjcgrckdjXucQXeTBhiUsHw9ToDgm4F4x2APrLpMChvaFug=
X-Gm-Gg: ASbGnctsMlojdIdX/wic9xtJa2RUENBF4jPGgoA08/dVoGdVJqTwZWvrhi9jFQDb22M
	qWf0VQQHhWHm9vW6c9U65EOyqhIE18Mi+te19BNfFb9GgXakPS/5wOxc9s1nZ8YwIAA394G4wcz
	kChQwVnjNReQyVH/8GyNpsYBxR/FIq9a5e3K/mUexMGVFHJb5J5yWR7zHbeT18WLSG3TeK1kLmU
	iog+Ngp+JS0N8Ob8k1MlVS8u1yDJKipjHUXJ3eWQ3mWFw6ITSED92+IhEnjit/0nubNawojm4xR
	ByE9Ec64Li5qevH1rYFTZuLdVG2NPQkJiHS40FwtE/snqi9FPkDsB61CXVUMPNEXlAGWocXDESD
	0TrWC472lny6ljY9o990UyUTdLj1V0vlDsu0KSkeUyVfIWwgJmD9tBa03MNl1dBpVrZpTo/wIMD
	dCfAd6DmXQB8Wu0G7gDoYLox1dc1qQwwnCqsjwtFzo5lMUWWnZ0iwpenM=
X-Google-Smtp-Source: AGHT+IEjaunwQ1qaC+EQ3PKNVtIHt/6K0qOKkxoQK+HCUV6COwxPQg3KI7Wd6GomKtufpv+bJgFTag==
X-Received: by 2002:a05:6000:1a89:b0:3b4:9721:2b1b with SMTP id ffacd0b85a97d-3b768caa22fmr6793972f8f.9.1753384861431;
        Thu, 24 Jul 2025 12:21:01 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705d42b0sm29233505e9.33.2025.07.24.12.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 12:21:00 -0700 (PDT)
Message-ID: <9ded729d-dc4a-4550-92d1-98beebccb9de@grsecurity.net>
Date: Thu, 24 Jul 2025 21:21:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] i386/kvm: Disable hypercall patching quirk by default
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20250722204316.1186096-1-minipli@grsecurity.net>
 <206a04b9-91cb-41e4-b762-92201c659d78@intel.com>
 <ebbb7c3c-b8cb-49b6-a029-e291105300fd@grsecurity.net>
 <fbd47fb6-838e-47bf-a344-f90be06eed99@intel.com>
 <c787981c-dc21-4b74-b219-03255781f927@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <c787981c-dc21-4b74-b219-03255781f927@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23.07.25 10:50, Xiaoyao Li wrote:
> On 7/23/2025 4:42 PM, Xiaoyao Li wrote:
>> On 7/23/2025 3:53 PM, Mathias Krause wrote:
>>> Bleh, I just noticed that there are KUT tests that actually rely on the
>>> feature[1]. I'll fix these but, looks like, we need to default on for
>>> the feature -- at least for existing machine definitions 🙁
>>
>> You reminds me.
>>
>> There is also even a specific KUT hypercall.c, and default off fails
>> it as well.
>>
>> enabling apic
>> smp: waiting for 0 APs
>> Hypercall via VMCALL: OK
>> Unhandled exception 6 #UD at ip 00000000004003dd
>> error_code=0000      rflags=00010002      cs=00000008
>> rax=00000000ffffffff rcx=00000000000003fd rdx=00000000000003f8
>> rbx=0000000000000001
>> rbp=0000000000710ff0 rsi=00000000007107b1 rdi=000000000000000a
>>   r8=00000000007107b1  r9=00000000000003f8 r10=000000000000000d
>> r11=0000000000000020
>> r12=0000000000000001 r13=0000000000000000 r14=0000000000000000
>> r15=0000000000000000
>> cr0=0000000080000011 cr2=0000000000000000 cr3=000000000040c000
>> cr4=0000000000000020
>> cr8=0000000000000000
>>      STACK: @4003dd 4001ad
> 
>>> Looks like I have to go the compat property route.
> 
> BTW, the compat property doesn't fix KUT issues actually.
> 
> Since KUT doesn't use versioned machine, instead of it always uses the
> latest machine.

KUT should be good with [1]. However, other similar mini-guests probably
still want the patching. :/

Thanks,
Mathias

[1]
https://lore.kernel.org/kvm/20250724191050.1988675-1-minipli@grsecurity.net/

