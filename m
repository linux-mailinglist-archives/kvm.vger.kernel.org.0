Return-Path: <kvm+bounces-42890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E5BA7F5C1
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 09:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06C671898D1B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 07:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9149025F965;
	Tue,  8 Apr 2025 07:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fZaJeQRE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E27D26156D
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 07:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744096527; cv=none; b=k4eiv1NTeWMiphkFmBpja8ZjjKLPdbE0WJSMSz7pkqquiI98McUl7JlVhiQ0TnXQ/hCQFrlWbF8YlMiDu4KVa/peja3dsv0yloWD4MX75PAMkPoOP5cUEz+9dFba7v8I2rjWvn1At3QECLDDtYXPzEJTKkId7fWOYN1ySCFN+DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744096527; c=relaxed/simple;
	bh=2OQmR7mRWtvtKjyh0z/59iR1+/cvbohWxA1sKXFqnDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q4mXxkkJc2aj4JtNxaRchmYs+4kzHYITvCnltcbyr+QNCwwoiUFCGOk7IAizYeTp/8dLBRDzCNNe+/5FnHrPA99Q6xJKddO0CtnbHsEqBDM5Q6HffSTRHGm25nthnTdwTMUU9TodVEt9LKaYko8VSHts4IKarjyRm/hLIYqyKM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fZaJeQRE; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5eb5ecf3217so8965058a12.3
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 00:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744096523; x=1744701323; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O+i2Xik3+39ZL2udNnhfnH82XMLPSIJDczg397VweSM=;
        b=fZaJeQRE32txkkiZfBTljjaK8RFg84IFtPt/Vy7E4bvpt0jLfYuZu+9CdOMQPlV3Hd
         nq0cDJxeKlNe7zfD0S6iAdz0iFFnl7LadJW2eBCYI2QBxBz0rqlKT6pcNeYp8qjuSBvz
         d9idzTHpmPgStRAPbuUqYcRTGDVZGrqnC/8hmIeWMIyOHkrPzNPsek5JmUxbOmGvWv9a
         CP98xiHV007J1o0PaCj7fnJn6RVjLhQOI961Dn5fw1EAh5BZ8uVrwPCIYwQbOZUPPoZm
         DgPPYSHeYuSTK8WgktKYVMg0JuZNyI50OD0BCK4yC5a5l50WTqQIsxK1ZYYyipRYrMMh
         bGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744096523; x=1744701323;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O+i2Xik3+39ZL2udNnhfnH82XMLPSIJDczg397VweSM=;
        b=SYt/YpxTkTaYgzuCgQdXj3nso17VW68Y1rzt90/sewhqQDYZBHpJU5+s2yoJ3gFHgg
         56sN/ruMNv1AicVRUPRHnCerNGMHhMv6QTVXI+ma48Dx1Vr2H7u6DEu/K3ac5Xr6wI40
         s/M0OzBj3K+w6wUDqJI8HG0mVzerIq6ToUJn7Ymr+t0V7C44iu/InDkITQTOIjIQslPp
         KttZiPJX3SRWSaUuk1CzRctd+BFnwn9bJpCnTOMJgamXyMLAMkwGQXPJCz+QEUXKd4TV
         aQ4fSoCBPwps77k1igqdOA41uJipfBVy6sL6/ckZ8g8QMCXjX4iWMRxBOqlUhpySrOQr
         rp3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWA/Iua1ls56gZQ6Ann1ZpMee3E38mMh7pyrg/alcni8F5rbdrjlho02QVn1YJ4hMOkQag=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKUut8+v19pLGvX4xqSo+Yhu75Vs97YSPy8GHd51LdJDk3zODb
	10CivCHVyzDoo21GJp5jzj5Zcfe8FwYMdM4EM1KjvuJIP+VXdbWXF+Pqljqcl6Y=
X-Gm-Gg: ASbGncuYtlNNN+C13JaVtrPaCWpTS1jxT/9jN4IA0X101sJhrXHieZ7LAOfEtBV4R9E
	muHrSV8ax8GGGXe1O3OwxzNSXq5XgMAxYc9CU09YVXKO7xpYG2rc0Mc6qGnBshrdWk0ghk82kYK
	Muk3LeCQaw+1PeVyjo+MGqfPvaGHdTArmwZOxZwUvZdYVe/pMpelaegp4iaQOGeJveLpbK2m9vD
	8bOLkNeRHBNg7AVy/ewRUQhk+CNL5/9KLpmYgbrKS6Z4wtVy7T5xU7K1hs6OrCMBVLeXhTGdZDc
	HvMGTTV8/4Va+Un1eV9b3FuEVsUmTkCvlquvWfpbpQBy0Y1QxA==
X-Google-Smtp-Source: AGHT+IFhUpOqIsWkQdwVxQ7C/6KZC+/pD1emRBUF9cWPtulP0plPyoTTI1Vt9BX41dH3B2vSU/uYIQ==
X-Received: by 2002:a05:6402:3489:b0:5e7:b015:c636 with SMTP id 4fb4d7f45d1cf-5f0b3b65b4cmr10076863a12.6.1744096522642;
        Tue, 08 Apr 2025 00:15:22 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.133.214])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f08771a1c6sm7825812a12.11.2025.04.08.00.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 00:15:22 -0700 (PDT)
Message-ID: <68b2f901-c179-4a53-8464-d9644371ce42@suse.com>
Date: Tue, 8 Apr 2025 10:15:20 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] x86/bugs: Fix RSB clearing in
 indirect_branch_prediction_barrier()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
 kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
 bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <27fe2029a2ef8bc0909e53e7e4c3f5b437242627.1743617897.git.jpoimboe@kernel.org>
 <d5ad36d8-40da-4c13-a6a7-ed8494496577@suse.com>
 <ioxjh7izpnmbutljkbhdqorlpwtm5iwosorltmhkp3t7nyoqlo@tiecv24hnbar>
 <86903805-569a-41d5-93d8-df8169e61cef@suse.com>
 <j75r3jm5sujsn3hhf5prto3vcnl4nitsiqb5fp4rlwgqhlwylu@ofi3g6valzu2>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <j75r3jm5sujsn3hhf5prto3vcnl4nitsiqb5fp4rlwgqhlwylu@ofi3g6valzu2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 5.04.25 г. 3:56 ч., Josh Poimboeuf wrote:
> On Sat, Apr 05, 2025 at 01:56:59AM +0300, Nikolay Borisov wrote:
>> On 4.04.25 г. 18:17 ч., Josh Poimboeuf wrote:
>>> On Fri, Apr 04, 2025 at 05:45:37PM +0300, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
>>>>> IBPB is expected to clear the RSB.  However, if X86_BUG_IBPB_NO_RET is
>>>>> set, that doesn't happen.  Make indirect_branch_prediction_barrier()
>>>>> take that into account by calling __write_ibpb() which already does the
>>>>> right thing.
>>>>
>>>> I find this changelog somewhat dubious. So zen < 4 basically have
>>>> IBPB_NO_RET, your patch 2 in this series makes using SBPB for cores which
>>>> have SRSO_NO or if the mitigation is disabled. So if you have a core which
>>>> is zen <4 and doesn't use SBPB then what happens?
>>>
>>> I'm afraid I don't understand the question.  In that case write_ibpb()
>>> uses IBPB and manually clears the RSB.
>>>
>>
>> Actually isn't this patch a noop. The old code simply wrote the value of
>> x86_pred_cmd to the IA32-PRED_CMD register iff FEATURE_IBPB was set. So
>> x86_pred_cmd might contain either PRED_CMD_IBPB or PRED_CMD_SBPB, meaning
>> the correct value was written.
>>
>> With your change you now call __write_ibpb() which does effectively the same
>> thing.
> 
> Hm, are you getting SBPB and IBPB_NO_RET mixed up?  They're completely
> separate and distinct:
> 
>    - SBPB is an AMD feature which is just like IBPB, except it doesn't
>      flush branch type predictions.  It can be used when the SRSO
>      mitigation isn't needed.  That was fixed by the previous patch.
> 
>    - AMD has a bug on older CPUs where IBPB doesn't flush the RSB.  Such
>      CPUs have X86_BUG_IBPB_NO_RET set.  That's fixed with this patch due
>      to the fact that write_ibpb() has this:
> 
> 	/* Make sure IBPB clears return stack preductions too. */
> 	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
> 
> So you're right in that this patch doesn't change SBPB behavior.  But
> that's not what it intends to do :-)

Fair enough, it just wasn't obvious from the diff context that there is 
the FILL_RETURN_BUFFER , my bad for not looking at __write_ibpb.

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>


