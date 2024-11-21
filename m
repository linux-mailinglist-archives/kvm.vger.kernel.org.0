Return-Path: <kvm+bounces-32286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A46069D526C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:19:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA101F2398A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E211A0BF2;
	Thu, 21 Nov 2024 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MZHJLhYM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725A1A08A3
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732213181; cv=none; b=SNbt8ErGOFLT7idU6eGaZK4uBJ43PPZe7hSXZ+tBqDcsv8Q6ii+pCZj3/NuROX1FnXhwxYy9ZzWevysf0r0iMLj92KZUtdUCJZO5defRACnYq1EqQMcdUUYv/g+KX4PS/oKuEKZboHNDCbcC1cnyLcMEq0lXXThcj369wkdANbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732213181; c=relaxed/simple;
	bh=EW3bBLGqFZuVOquRcnnHYxrZc3htXZlVYjqsYt+HG3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uz4eEdPfRcWPaBLPZmngSa8YlvupMnLKehDb1vwYiLlkThZGSjKdewE6xVvuGSqTVgOXXQJnhGPjTzTuTtjmw/+NyOhOYzg0IkBO4UuGIokU+6ers3pmNxgAjC8RBNB9fACpVFGdRhokmvsTCMMP/gWdo+OZuNMtImuTCluXdmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MZHJLhYM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732213179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6bSHmUUve5JUe0VVjTwXDvvxVOJ/4Qyk3ST+VWP2lMc=;
	b=MZHJLhYMQKYGytsrs9mdQGoxYJu4Ejh6JTESNHdXu7m7LQsYUGJVRI4pGoqYwQ53MLRStp
	aOdGXfNdC9HL9zk/BNDALJu9EmbdkE2UZyPi4E7vqnKgXi3Fkt4MS4c9GdSLlIu/ojDeoJ
	csJMCcmqTp/E2luuKDuF7YRegzmF7S8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-t2_2AKPuOJ-y4UCj58EU8A-1; Thu, 21 Nov 2024 13:19:37 -0500
X-MC-Unique: t2_2AKPuOJ-y4UCj58EU8A-1
X-Mimecast-MFC-AGG-ID: t2_2AKPuOJ-y4UCj58EU8A
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4314f1e0f2bso8830655e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732213175; x=1732817975;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6bSHmUUve5JUe0VVjTwXDvvxVOJ/4Qyk3ST+VWP2lMc=;
        b=pZaJ0ws5EAgubHCrMy3d8d3Sk6VM4WWXKFt1np4q8LyIIX0ADcepiHvzc7Gtoil3zP
         qZDfqRXYSq4iX0L5YhUGJpjWd18lz6oMib9mJlKtQa8EMIPry4sLbYuAio86NP1CXzmy
         RFFzo2IZJpeVvtZTsJL8t/TrB/loSpK25UInwwC3FiOfDVck34Of0oF//ksrj3aw0Ivo
         xCBwZKDfIKkqJE4jBpLDaaJ4r5s7/xpfwPr4JdQHMgyRexCZKSJ1yDv94K2mc+mpGfYT
         Q16fLqsRu5n3SvYN18nA8k7Y/6p7h7usUUbHw2FqACarZATA+XqDjXt5ZTdKcT82JEIV
         uj6A==
X-Forwarded-Encrypted: i=1; AJvYcCUiAAUbPoFIDmKVRCmXnqLlbZvavjixJ8MZgB9rTes02fbTg4ZeZsRC/+RJ4Y/lzTPkxQ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuFy3rDz3juVF/CTZHz3qcQDlDb7Y+QYwhR0rIAqeMNJP3KSuD
	MHBZV2lfbF7xsCnnTn2yeooURM03vhXBp/mMiLuXIQ00fr5hNYGFYqzn7qM+Y78demv5JGAbn4k
	jEmPaLJTxBYah7Kg38CffcyPJgOF7SqEbQTxSfon6NIsBZYeDu/UfiCmVlw==
X-Gm-Gg: ASbGnctcXcxL3/6JMNlI7boVxGBdIqYLTmAzKv+oAS4RlIVSH7fzQyBSkSAMsNZFdQx
	tFEZEOVYOGat1632jNDORATaHPCPkz3QX/OosL2PmJBGL5Y1gxp3jsxL3qy+rvfUfm0z3Y01lQ1
	NGhaHNR9N9pt/vnpl6s/KQLDmbMufBy0Ow3iiBdPiF16Fp+ap896HF5rpk+1O5u3nl7bkC3htz7
	onDK5KEoG2sCnl05CnBZO4/MctWeyDOFv5m7J4ZQD/dyOpRJz0+5A==
X-Received: by 2002:a05:600c:314b:b0:431:51c0:c90f with SMTP id 5b1f17b1804b1-4334f0202damr63248545e9.21.1732213175444;
        Thu, 21 Nov 2024 10:19:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlbswkPsJ2lZyPxiokUXA1d8lSrr31vnDcP+V8VFKHQkVPt3llt+6wRwlSHdB/BCqQqAboZQ==
X-Received: by 2002:a05:600c:314b:b0:431:51c0:c90f with SMTP id 5b1f17b1804b1-4334f0202damr63248365e9.21.1732213175059;
        Thu, 21 Nov 2024 10:19:35 -0800 (PST)
Received: from [192.168.10.3] ([151.62.196.119])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-433b4643100sm66575945e9.39.2024.11.21.10.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 10:19:34 -0800 (PST)
Message-ID: <d4048dc8-b740-47f6-8e1e-258441eb77d1@redhat.com>
Date: Thu, 21 Nov 2024 19:19:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.13 merge window
To: Sasha Levin <sashal@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, torvalds@linux-foundation.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 "anup@brainfault.org" <anup@brainfault.org>
References: <20241120135842.79625-1-pbonzini@redhat.com>
 <Zz8t95SNFqOjFEHe@sashalap> <20241121132608.GA4113699@thelio-3990X>
 <901c7d58-9ca2-491b-8884-c78c8fb75b37@redhat.com> <Zz9E8lYTsfrMjROi@sashalap>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Zz9E8lYTsfrMjROi@sashalap>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/21/24 15:34, Sasha Levin wrote:
> On Thu, Nov 21, 2024 at 03:07:03PM +0100, Paolo Bonzini wrote:
>> On 11/21/24 14:26, Nathan Chancellor wrote:
>>> On Thu, Nov 21, 2024 at 07:56:23AM -0500, Sasha Levin wrote:
>>>> Hi Paolo,
>>>>
>>>> On Wed, Nov 20, 2024 at 08:58:42AM -0500, Paolo Bonzini wrote:
>>>>>      riscv: perf: add guest vs host distinction
>>>>
>>>> When merging this PR into linus-next, I've started seeing build errors:
>>>>
>>>> Looks like this is due to 2c47e7a74f44 ("perf/core: Correct perf
>>>> sampling with guest VMs") which went in couple of days ago through
>>>> Ingo's perf tree and changed the number of parameters for
>>>> perf_misc_flags().
>>
>> Thanks Sasha. :(  Looks like Stephen does not build for risc-v.
> 
> He does :)
>
> This issue was reported[1] about a week ago in linux-next

Yeah, that's Linaro not Stephen.

> and a fix was
> sent out (the one you linked to be used for conflict resolution), but it
> looks like it wasn't picked up by either the perf tree or the KVM tree.

Yeah, that's not surprising. :(  Neither KVM nor I weren't CC'd on 
either the report or the bugfix; and the perf tree didn't have the code 
at all as Ingo pointed out 
(https://lore.kernel.org/all/ZzxDvLKGz1ouWzgX@gmail.com/).  Anup was 
CC'd on the bugfix but he must have missed too and didn't notify me.

Paolo


