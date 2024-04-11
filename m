Return-Path: <kvm+bounces-14260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D70F08A16DC
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 16:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 920F028D01A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 14:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB6814EC55;
	Thu, 11 Apr 2024 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="R4bXwYUF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3044B14E2DF
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712844784; cv=none; b=cEaR9NdbbV4iStCKCwFjpqW8L+u90Sq8yPoUMr8ciTPZS4m2GNrxmVbvjkIP+5ULdLLxyo91c0FsGntwbM0prOblCyS1REWta3QuRLN7gCbxuTWFSYq9dPGZwTa/RgJW3HqjcrIz70D5vYANjvBGBBidqmxNdssecbS+QFimlfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712844784; c=relaxed/simple;
	bh=o870gL4LJddZ2O4bVnRQSyAqyJgc/qzl+x7k83FTV/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nmGVTc4svrn1hYWSMAV83PQ81LggOz0qeYIvq3nnlFqmL/DvCqxwwzyotQjtnMpnC7X8vTa1lBv1UT4g5Msjcg8PESut6S4y2PxeMWJ1Ipk4G1AqGIi9/QcgBNaH9FF3evxExNtUiBfSK9zvlBpUP24+CPMx6uPOU1oRt3JfnYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=R4bXwYUF; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-417c339d261so9681225e9.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1712844781; x=1713449581; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=o870gL4LJddZ2O4bVnRQSyAqyJgc/qzl+x7k83FTV/U=;
        b=R4bXwYUFnbLzUW6+dme7HjV88Sj9Mt/lKojzTUF5C1dsBwUuniKSfmdjdVbgPAVOjE
         zZ7YcjAHVvF4VVX9xBusBxi83a3KMgPUJdkeSQ2v+biZANo7Q5DACsaeoBOlAZcqylFU
         m6Hh2JVwpaKCHbtRPAok3B+W3qRksGmdV60bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712844781; x=1713449581;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o870gL4LJddZ2O4bVnRQSyAqyJgc/qzl+x7k83FTV/U=;
        b=BKKvnFb6vuNlg/JCm+lRC1zrsaaIIzqzlPXQESly6fiatj40Yccq1zbUtHy4Q/LVZd
         iooM6X4ZPGfIwItAJVc5EjKxz6WP1nqK/6XV1Q+33HPzdwkxnpyKuglqakxHjLE93USO
         QzfNbkvpAWVgRU7F0wHPRaX81iMkt23JFxdQEdQIzwW3RqH7Jvx3k1DvPv2enmYY2hUT
         5ajKuUGLpU1ZhDre7dvU0HJlFkQsBH7XH8q8d3h+ETwtCOG5MdNq5OOndRbwizCT/UpV
         2vCWWYfbjyHQUBTaUWlgmICB1rUKiNynERs++4El71LsGYyiSoo6U/KXGnSKAVhW+nok
         7UiA==
X-Forwarded-Encrypted: i=1; AJvYcCXDKJIRrGEdaEQGBsImafFWYeXGPpDUNBPge1bz4MHwnXM61CoKgntRTmMIvwpl2J9vQPZ5lrpwM1G6nxYp7oGP0B9x
X-Gm-Message-State: AOJu0Yy8S4BVm4SWQ4mo6bcDcW2q8dh4142Bg+6JxuLkPKq/bFfQvkBM
	4mib4it+tIVFoMmXT3jq1XpjELpzeFYiKm26jLWPGedja6b0VPD3Gdu328dGKBU=
X-Google-Smtp-Source: AGHT+IExLkwdYFAf7cwEkMW67SnJNYQT4Okac36nAXqq+vF8+jViBEFWP9B3suKgWyjhAlkG4aQ5vw==
X-Received: by 2002:a05:600c:3c8e:b0:415:6dae:7727 with SMTP id bg14-20020a05600c3c8e00b004156dae7727mr4277828wmb.11.1712844781438;
        Thu, 11 Apr 2024 07:13:01 -0700 (PDT)
Received: from [10.80.67.140] (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id v13-20020a05600c444d00b0041663450a4asm5607826wmn.45.2024.04.11.07.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 07:13:01 -0700 (PDT)
Message-ID: <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
Date: Thu, 11 Apr 2024 15:13:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
 tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
 gregkh@linuxfoundation.org, seanjc@google.com, dave.hansen@linux.intel.com,
 nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com, bp@alien8.de
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/04/2024 2:32 pm, Alexandre Chartre wrote:
>
> On 4/11/24 15:22, Paolo Bonzini wrote:
>> On Thu, Apr 11, 2024 at 11:34 AM Alexandre Chartre
>> <alexandre.chartre@oracle.com> wrote:
>>>
>>> So you mean we can't set ARCH_CAP_BHI_NO for the guest because we
>>> don't know
>>> if the guest will run the (other) existing mitigations which are
>>> believed to
>>> suffice to mitigate BHI?
>>>
>>> The problem is that we can end up with a guest running extra BHI
>>> mitigations
>>> while this is not needed. Could we inform the guest that eIBRS is
>>> not available
>>> on the system so a Linux guest doesn't run with extra BHI mitigations?
>>
>> The (Linux or otherwise) guest will make its own determinations as to
>> whether BHI mitigations are necessary. If the guest uses eIBRS, it
>> will run with mitigations. If you hide bit 1 of
>> MSR_IA32_ARCH_CAPABILITIES from the guest, it may decide to disable
>> it. But if the guest decides to use eIBRS, I think it should use
>> mitigations even if the host doesn't.
>
> The problem is not on servers which have eIBRS, but on servers which
> don't.
>
> If there is no eIBRS on the server, then the guest doesn't know if
> there is
> effectively no eIBRS on the server or if eIBRS is hidden by the
> virtualization
> so it applies the BHI mitigation even when that's not needed (i.e.
> when eIBRS
> is effectively not present the server).
>
>> It's a different story if the host isn't susceptible altogether. The
>> ARCH_CAP_BHI_NO bit *can* be set if the processor doesn't have the bug
>> at all, which would be true if cpu_matches(cpu_vuln_whitelist,
>> NO_BHI). I would apply a patch to do that.
>>
>
> Right. I have just suggested to enumerate cpus which have eIBRS with
> NO_BHI,
> but we need would that precise list of cpus.

Intel stated that there are no current CPUs for which NO_BHI would be true.

What I take this to mean is "no CPUs analysing backwards as far as Intel
cared to go".

~Andrew

