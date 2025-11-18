Return-Path: <kvm+bounces-63445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A8526C66E20
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 73A4C4E1581
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4843E2FF177;
	Tue, 18 Nov 2025 01:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="gTdxx2pR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03F2676DE
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 01:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763430464; cv=none; b=bw3N69ZTcwkQ3HqCC2StNIrYTY4j0lVcjSZKZpcWPvClrIZfad6ZHp01uKlJF5kzkqsUL0s7Deh2PRdPv7hcaafz1+KwcXlcn/4EpB4aSGLuZsBSLYe6rKOKom6W3FkmFRFXyV/b5RO1QY9fhZXbsKazQ5/cWNjbEesgSdyeBHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763430464; c=relaxed/simple;
	bh=PcFLraAzaSuScHsWdw52NGGkd4NF4SIlfh6tbOQN74g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Q/7d9y/tEQ1GsyNkxls0MIVATjury2n6XJdC5nATpoQtUOGR80T7jp0VAFtPq7mA8HFqFSO8KjokKuDQhDWUQHHLehFYBTQiXfcfjedc6AFP4qQ20cIbu8R+/fjlRHPIGhTRibRTfBtKuD265GhnSUdgPaT45quKuv52zBLVAaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=gTdxx2pR; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b23b6d9f11so491847785a.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 17:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763430462; x=1764035262; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ANmR5R95YIg3oicNxWokN5OI3LFn4zAy1RzaFgznCXk=;
        b=gTdxx2pRRGRThj1IM3B0t99iBlnlmKGPRuG32/wSurp7NJWmY20ZX7W7UCG8Y2zW2u
         V4QONuwkgQe4FIhj76yujPoBh7SsEj4qZVA85jBXR9ZPc460TRwPYOnCZaKEsu9GmJHi
         VBPikesMgkV11gecTswDIe5DqSQ0MvvR9WrDwsg8WTcjeOgm9M5SORR6mkKLpQVKhqGE
         3iJFHrs4CXNMwykHm7Uk79DS+e9nQQdMZAqsdCDEG6OvsXxla+G3/7GzFYR5TYGHW+Ja
         XZx4eC8vPZbKFP+OiB2nB5KCUOa7K5v6hx8qQXH5p3AdKkN7wtCO44LIjiBAlaxNZFeN
         cOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763430462; x=1764035262;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANmR5R95YIg3oicNxWokN5OI3LFn4zAy1RzaFgznCXk=;
        b=dWspi994tAwFVFfyyYcQzRdaeKtR+VrnySZMsaSr6nUyiFo+eeo/WOqaBBzTPsLkwj
         Cwag+R6z0/NbkXbOAhz/TPT7v5AOtvkYkTHWZ4QE6WNPmuUY6/DEbKcWLuJYe32hHWN1
         3VoG/itRGETGFb9JAAcGvWvQ6V2Apy7TbQj9pXZVeVSeiwA9x7UJWQpuSCrtg2/DqdBq
         Adl+zb2RIfZ+6YVZ3/kyioRNlWV9LxvtTIoOMiU0JO03CynC6mhCglBvLj0CHoWMDb27
         ZkE3WMXrhDzWWDNnXTaYoC9tboWEv9lNCofdFxCxxk7A03nljdHX2t3XxPovXUuRpa5J
         zD2A==
X-Gm-Message-State: AOJu0YwiBrmKwaDCQ+YQrbK2Kz/AxZt3MKJEs2B5XDO7LsH/HEi1523C
	3/SFpeDyR0dr0TfnP5f0E1jpDVHRK0+mTryH0fhtTt01/aECS0j8cP0oCY6BWa+rSxQxURhaDW/
	+of3v
X-Gm-Gg: ASbGncuUr+J1LYU3BjVW3Zl3/oUnBJ6HaGY3MH9Jhc/mpxOjpMN+dILOdV58ppuFjSj
	VklYZmDHd6SS8jQQVTip8YXrERfTOWL4bpylHxNWJESAc0QkV/cE4y1+CmDA+54K0S/jljCBBU/
	cpDWmGux2sj1oj+CdWSdiiE9ftpkCjsNho6LjHDa8FHoVA1yxNA0oZInuFPJjfdu5x+DVEZdXRY
	rs5YRNfbVz+sJm8or+4klNwzIWiXDZ/0QK+XRXIt6W2Kuiti3eUYGTkjV+xDcmleT/Ai7wJB0NK
	1sE4zAsYzhTs1R8ISHZLO8zOSXGV95KdL8yHZQGbgYZBOVP+T3ExBaXaAZNR51I9jvzvXvW3oUC
	zUCxCu/SiPTc4nsrelGiSQPc03Yl/YsXXFev/TcGm1oElrv5YwT1tQ2eGsJ9wxPvWLtG7wwPZO2
	epHLUS3W88VtYi6LcyvGmypZ16xNAFUho1+OltWkm3Oa/pXAksKyiguDid2Ol9nCqcQf6p85hOv
	JH+EKeSwjehJLVmNJhyB3hL4896OBa9Nrpytbd5BZlPn0gJX9yvUjV2
X-Google-Smtp-Source: AGHT+IF1rrSKti2yalLsD2GeMGxfpK466BKmI1nDbWTxmkWAWUCzyX85ZbouAm2vMzc+ZtrwHT3LSg==
X-Received: by 2002:a05:620a:700c:b0:8b2:e4f0:74d0 with SMTP id af79cd13be357-8b2e4f0797bmr1161133085a.63.1763430461779;
        Mon, 17 Nov 2025 17:47:41 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2fbc6f264sm192017985a.36.2025.11.17.17.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Nov 2025 17:47:41 -0800 (PST)
Message-ID: <0274322e-e28c-4511-a565-6bb85bfade8b@grsecurity.net>
Date: Tue, 18 Nov 2025 02:47:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
From: Mathias Krause <minipli@grsecurity.net>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andrew Jones <andrew.jones@linux.dev>, Eric Auger <eric.auger@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
 <176314469132.1828515.1099412303366772472.b4-ty@google.com>
 <15788499-87c6-4e57-b3ae-86d3cc61a278@grsecurity.net>
 <aRufV8mPlW3uKMo4@google.com>
 <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
Content-Language: en-US, de-DE
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <083276ef-ff1b-4ac3-af19-3f73b1581d39@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.11.25 02:33, Mathias Krause wrote:
> On 17.11.25 23:19, Sean Christopherson wrote:
>> On Sat, Nov 15, 2025, Mathias Krause wrote:
>>> On 14.11.25 19:25, Sean Christopherson wrote:
>>>> On Mon, 15 Sep 2025 23:54:28 +0200, Mathias Krause wrote:
>>>>> This is v2 of [1], trying to enhance backtraces involving leaf
>>>>> functions.
>>>>>
>>>>> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
>>>>> fails hard for leaf functions lacking a proper stack frame setup, making
>>>>> it dereference invalid pointers. ARM64 just skips frames, much like x86
>>>>> does.
>>>>>
>>>>> [...]
>>>>
>>>> Applied to kvm-x86 next, thanks!
>>>
>>> Thanks a lot, Sean!
>>>
>>>> P.S. This also prompted me to get pretty_print_stacks.py working in my
>>>>      environment, so double thanks!
>>>
>>> Haha, you're welcome! :D
>>>
>>>>
>>>> [1/4] Makefile: Provide a concept of late CFLAGS
>>>>       https://github.com/kvm-x86/kvm-unit-tests/commit/816fe2d45aed
>>>> [2/4] x86: Better backtraces for leaf functions
>>>>       https://github.com/kvm-x86/kvm-unit-tests/commit/f01ea38a385a
>>
>> Spoke too soon :-(
>>
>> The x86 change breaks the realmode test.  I didn't try hard to debug, as that
>> test is brittle, e.g. see https://lore.kernel.org/all/20240604143507.1041901-1-pbonzini@redhat.com.

Bleh, I just noticed, f01ea38a385a ("x86: Better backtraces for leaf
functions") broke vmx_sipi_signal_test too :(

Looking into it!

Mathias

