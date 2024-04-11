Return-Path: <kvm+bounces-14237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6ACF8A0C8C
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 11:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E1FA1F27A2A
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BA914533C;
	Thu, 11 Apr 2024 09:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="O769IPCy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D526144D30
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 09:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712828296; cv=none; b=f/TAhxpmkRupxsWMJA/6ZQnPzibT/W3ZUsM/SEa0mqpeeSsD2MLb3elPwZuiJYJKU/vhCy8tp5fc7aXOkiVskcwwN62qQeVztFCml2jDog6uT198q8jLJKAFP9pJQSSglItlw357cQDROS0bLqIH/SfoAqAKt+y8dZAYWo1+uV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712828296; c=relaxed/simple;
	bh=f/I9w6sfetJETzwe+/hnnc2vMvlramUWvNgeJvmG5bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IKfLcHn5Ssrd2p1wFQ1YRmDOVT4VGozyBU2J/vdN9WCdKOn+hLNABiUp16c9wAtwVOJQ1zHs1lDVW15uVRqQqb9ZAiYDeJAOQ3Mlji9ZrJ8GNXNfbzM1ujbBuE9SCEhA2K6qnpllC62UJXyMXKZL/oAXXKo12fVIRn3k5CkZm/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=O769IPCy; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dcc7cdb3a98so7156849276.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 02:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1712828294; x=1713433094; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=f/I9w6sfetJETzwe+/hnnc2vMvlramUWvNgeJvmG5bA=;
        b=O769IPCytoq9tq3VZqLV085oGlzJpVdk0GXoD1TZ34aBiRllGx43qsGEJnrrzmPW8s
         5RDYo01j/8WdNEfmCw9DpMr6+vhdkVm31bjYlRABHlVM2huPFOlcwCabEbh8aGjA/cUa
         DG8YQSOgxZaPNcg7jLk6hA9t0ZrjgF8K169bU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712828294; x=1713433094;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/I9w6sfetJETzwe+/hnnc2vMvlramUWvNgeJvmG5bA=;
        b=GV8vOt2/ZRcxrIxRZ4q9DmtQlvu3TJhjFPXopOMS/NplDGh/spWqJIFefVclzkUEUK
         yZfPvQK7VRC4+iZxmtJygitU6VNLsy+fVmWxWxh0oPPHNGPuHCsfvytH9D5Tj7HlcnU2
         8Vhf3Lu+3Q1PbU287/2s2iIBgiwEyHWMS/56vSvSenNLSnZesDx+93HC0j16Q0xVHv4r
         tEFyVT1ODgOIHQqu2aIk0LVkdJq9jvJAGZUXP+wPD+aR0viORMSF8oHOXIES8uA8FaT2
         /ssiY4SGEbIcXmOZfsJ0GGUgLskC2/CA9Q0SXUH+HkQ/crBUhl9Crb+DEZ7aNKsssLxn
         IuSA==
X-Forwarded-Encrypted: i=1; AJvYcCX9urq6J1IIatBRo4AQd315kCqBe/1JTDFymPHVKmlZokGEutDrbFclGxjSahIjrDk/wCg2not6Z/1jYrqFHRBugAbc
X-Gm-Message-State: AOJu0YxH3hMpJsa+n5P4M88FHlOrdyk4ddtmOI2DIprwRsGahsofCE0v
	aNIEDGc9slgB9QPp++sjnibzNUTSr8GyFOIvRs+Nq3tbgTZvdp70ZJrOBYP+HlE=
X-Google-Smtp-Source: AGHT+IG/fTGMXT11lLGkeiN4djWdRSuP6/7o/MFwiKk2QSEWzuhbX6g9A1hYx9sCqfqHL6Tsq3cf4w==
X-Received: by 2002:a5b:5c5:0:b0:dcd:4e54:9420 with SMTP id w5-20020a5b05c5000000b00dcd4e549420mr5647972ybp.5.1712828294250;
        Thu, 11 Apr 2024 02:38:14 -0700 (PDT)
Received: from [10.80.67.140] (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id cz6-20020a056214088600b00696b282f582sm720350qvb.97.2024.04.11.02.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 02:38:13 -0700 (PDT)
Message-ID: <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
Date: Thu, 11 Apr 2024 10:38:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/04/2024 10:33 am, Alexandre Chartre wrote:
>
>
> On 4/11/24 10:43, Andrew Cooper wrote:
>> On 11/04/2024 8:24 am, Alexandre Chartre wrote:
>>> When a system is not affected by the BHI bug then KVM should
>>> configure guests with BHI_NO to ensure they won't enable any
>>> BHI mitigation.
>>>
>>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 984ea2089efc..f43d3c15a6b7 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
>>>       if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
>>>           data |= ARCH_CAP_GDS_NO;
>>>   +    if (!boot_cpu_has_bug(X86_BUG_BHI))
>>> +        data |= ARCH_CAP_BHI_NO;
>>
>> This isn't true or safe.
>>
>> Linux only sets X86_BUG_BHI on a subset of affected parts.
>>
>> Skylake for example *is* affected by BHI.  It's just that existing
>> mitigations are believed to suffice to mitigate BHI too.
>>
>> "you happen to be safe if you're doing something else too" doesn't
>> remotely have the same meaning as "hardware doesn't have a history based
>> predictor".
>>
>
> So you mean we can't set ARCH_CAP_BHI_NO for the guest because we
> don't know
> if the guest will run the (other) existing mitigations which are
> believed to
> suffice to mitigate BHI?

Correct.

Also, when a VM really is migrating between different CPUs, things get
far more complicated.

>
> The problem is that we can end up with a guest running extra BHI
> mitigations
> while this is not needed. Could we inform the guest that eIBRS is not
> available
> on the system so a Linux guest doesn't run with extra BHI mitigations?

Well, that's why Intel specified some MSRs at 0x5000xxxx.

Except I don't know anyone currently interested in implementing them,
and I'm still not sure if they work correctly for some of the more
complicated migration cases.

~Andrew

