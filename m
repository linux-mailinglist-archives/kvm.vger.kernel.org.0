Return-Path: <kvm+bounces-18054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E678CD66F
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:00:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C7071C21BE0
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11516171A1;
	Thu, 23 May 2024 15:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="LiAF9et4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4277211CA1
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476407; cv=none; b=mTMPJFpMshVIhatpdNIy6lKzAweGC9IT0hHY/4aMR7tnsNSxTQMPiN7q4fFOaVJaknu0HPEXRBITfD0ek/TO/DQOBpLPx19xkGQjzmKY015Vll5H1Ux9xo69Iue4IoZ/pyyCJwPS9wBvwiqtiChAaqc+7UwC7qm3FNvECNOP+e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476407; c=relaxed/simple;
	bh=s2lYMgKhqmOoc2ZsDL1yCZHZwFkT2+ILqBEJ2uaDiAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dhgTLAFeGd+HmfdVDNvZ68AHveQTXAwoSYPwLA+QljLEoXCpL/+pCoG5wIGOpyI6S+ZBlHf3l1NinC6VvsBo+tkbX8auAVxB4M/EHPwu/PzoC7bVBFFpKa6J3/g/mIZ1sOAMZ3PTJHCR4/C2vGqaqBX61uHGfi8ddz0WxEKdUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=LiAF9et4; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-43e4c568e14so12398511cf.3
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 08:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1716476403; x=1717081203; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s2lYMgKhqmOoc2ZsDL1yCZHZwFkT2+ILqBEJ2uaDiAI=;
        b=LiAF9et4e6YqmOY1K4Nm8yJO97KIGfkUcf4SiqVOOEFSFS+SiaH49u/zW/Wm3Bps42
         5Ry0I2FCbrs9YwlnKnuIaZY3JMWZQ4ltGv7K2U3DwSPMHeCxVurwmfU9ZJ8rSTP5Mw+P
         FLxs9qRWuMCG+9PHCNi38Y5/m8T6jA7mYooTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716476403; x=1717081203;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2lYMgKhqmOoc2ZsDL1yCZHZwFkT2+ILqBEJ2uaDiAI=;
        b=jknEXIzgW8NQy3oKZrxTf7Y7LwxAFeyhylV8LuJ3b/6mpopxLse6aKPiAUKA+q9xVC
         pPPx1ZmD1N1n8RwppEdwQnkoFM02HeI7TnqfDtZyhQY9H/IMfsyJyHhAQu14XAf1QfOm
         U3Na+TVYEWF9D0hB8X5gOodXo8aOSaqebV1DsZk6jn+Jw0433cz17Jla0YAC1/cbQ/4c
         KybkQMKyTXy2fQhC9Of7W0C/KYiN3IV+5P9aBmZPTL2/GbnZM1sx1PIgo6j/EZvT18Vk
         ts5u9e0prXg5/rY5Iwy0PWAKJHifatiI4vY9wlJdL+NgCVIzj7iIiAKp9tHMcsQp5sHI
         Nv0A==
X-Forwarded-Encrypted: i=1; AJvYcCUw++WM7P3+iIeDSLj8OSIxdpq5B5isXDFkTjeCjjuxyga2gPffhSbux1fn9dGexK6d8DdqNNPWws9XnwLlOtKI0BxU
X-Gm-Message-State: AOJu0YzwxMJwH7DfI99P9wRREseHbHrwnbv6IpUmZkrRoe0w4d9ye2H+
	DBqSsBCir6+6wuwtslFGtKVLv0RLgOARE1iD/ZBkjqdfy5XFfa2jx7CAtxFE4DI=
X-Google-Smtp-Source: AGHT+IFFne2Xc83fYsFcLXZ3LBNtSJ3tgYmYGJNiUdED+FVyEy1/5AXrTpHr/PEuTUViuJNCQf792g==
X-Received: by 2002:a05:622a:54d:b0:43a:f58b:2e71 with SMTP id d75a77b69052e-43f9e0849fbmr48737101cf.10.1716476403146;
        Thu, 23 May 2024 08:00:03 -0700 (PDT)
Received: from [10.125.231.30] ([217.156.233.157])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43e17a8315csm144060261cf.32.2024.05.23.08.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 08:00:02 -0700 (PDT)
Message-ID: <6fbc9a1e-fc3b-4034-a56d-3e8e64413b2c@citrix.com>
Date: Thu, 23 May 2024 15:59:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com,
 "Kaplan, David" <david.kaplan@amd.com>
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <771bbaa3-0fa5-4b0a-a0a2-6516b4f42867@citrix.com>
 <5f064eb5-cabd-4adc-8c6f-6b2e449e3fe9@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <5f064eb5-cabd-4adc-8c6f-6b2e449e3fe9@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/05/2024 1:59 pm, Alexandre Chartre wrote:
>
>
> On 5/23/24 14:42, Andrew Cooper wrote:
>> On 23/05/2024 1:33 pm, Alexandre Chartre wrote:
>>> diff --git a/arch/x86/entry/entry_64_compat.S
>>> b/arch/x86/entry/entry_64_compat.S
>>> index 11c9b8efdc4c..7fa04edc87e9 100644
>>> --- a/arch/x86/entry/entry_64_compat.S
>>> +++ b/arch/x86/entry/entry_64_compat.S
>>> @@ -91,7 +91,6 @@
>>> SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>>>         IBRS_ENTER
>>>       UNTRAIN_RET
>>> -    CLEAR_BRANCH_HISTORY
>>>         /*
>>>        * SYSENTER doesn't filter flags, so we need to clear NT and AC
>>> @@ -116,6 +115,12 @@
>>> SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>>>       jnz    .Lsysenter_fix_flags
>>>   .Lsysenter_flags_fixed:
>>>   +    /*
>>> +     * CLEAR_BRANCH_HISTORY can call other functions. It should be
>>> invoked
>>> +     * after making sure TF is cleared because single-step is
>>> ignored only
>>> +     * for instructions inside the entry_SYSENTER_compat function.
>>> +     */
>>> +    CLEAR_BRANCH_HISTORY
>>
>> Exactly the same is true of UNTRAIN_RET, although it will only manifest
>> in i386 builds running on AMD hardware (SYSENTER is #UD on AMD hardware
>> in Long mode.)
>>
>> #DB is IST so does handle it's own speculation safety.  It should be
>> safe to move all the speculation safety logic in the sysenter handler to
>> after .Lsysenter_flags_fixed:, I think?
>>
>
> Right, so something like this:
>
> --- a/arch/x86/entry/entry_64_compat.S
> +++ b/arch/x86/entry/entry_64_compat.S
> @@ -89,10 +89,6 @@
> SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>  
>         cld
>  
> -       IBRS_ENTER
> -       UNTRAIN_RET
> -       CLEAR_BRANCH_HISTORY
> -
>         /*
>          * SYSENTER doesn't filter flags, so we need to clear NT and AC
>          * ourselves.  To save a few cycles, we can check whether
> @@ -116,6 +112,15 @@
> SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>         jnz     .Lsysenter_fix_flags
>  .Lsysenter_flags_fixed:
>  
> +       /*
> +        * CPU bugs mitigations mechanisms can call other functions. They
> +        * should be invoked after making sure TF is cleared because
> +        * single-step is ignored only for instructions inside the
> +        * entry_SYSENTER_compat function.
> +        */
> +       IBRS_ENTER
> +       UNTRAIN_RET
> +       CLEAR_BRANCH_HISTORY

Yeah - this looks rather better.

Although I'd suggest a blank line here if you're going to formalise the
patch.

~Andrew

