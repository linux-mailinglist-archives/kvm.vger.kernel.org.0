Return-Path: <kvm+bounces-26590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 04211975CE0
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A41671F23B40
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1E01B81A1;
	Wed, 11 Sep 2024 22:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hu0hVXWS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D449C158DB1
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726092340; cv=none; b=VdjmjXbdbdYTbbX9k86EnBXS5vu0Fx/oPZ/mA/51DMD5Z1B0XY6n517zYO+8HSqKGMukbYm+4iXOaQRHvVTKmoOhM1IqaYTmni+EjmasNA0QUnbVQ71GXEVdRDOmlKiHZWadULO6+qarLH/ciM9bxyXVvoeLzOnbC6CAUKVvHCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726092340; c=relaxed/simple;
	bh=bUuvrWFSv3BmUrrwJf5eHrL8j4woZvMxGXVhs85lWkk=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Iz9ivdvpnFSCU6SHgSMJXQAVl5PSMRoYMVRjD14lU41lolTdmpaEnett6d//FViybZlK3lkqTdfc3HWzhioL7OH9cSit/Vql+N8tQNGaEFWJgr5UJBvuW0tJ6tZajQ1m0ZhXVMd6ZZEaHv1riz8z7dcfxXBy9NaAQ/BkH4jH4LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hu0hVXWS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0b8fa94718so907805276.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726092337; x=1726697137; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uSnPM7Z73BdDwIKjWD3zfTeRtaq8wKDl6kU6LBNgXKw=;
        b=Hu0hVXWSRNSYV6Z+7qhxnmpnKymV3LpBErD5gWvTSM+VftMZzkGPmGSghCVco5Bq5o
         JdfLbwjO46vMjsLz8/veyQHxKvN2aBG1M65WRtB6AxtLsQCYcMlEGlx55H6mjln0e7Az
         gGwOSuoYiJP4zjQjF+tS00FY4vcSuEr4fLUI8DZNwsFdgGBxx0KOr9jliVbm9wUl/zDa
         4wvMLf+j/+pyJkSdK7WndmWq2NT9JokbLM2UjXQfQokGMGG2mjafO2AMrLQetXWsVGGh
         avMPO54x0TaC+Oiw1uh6EmCE8ilJcLx9Vncz7t/xv6XfighNmF/ErqjKUv9VKQwEBYWA
         D73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726092337; x=1726697137;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSnPM7Z73BdDwIKjWD3zfTeRtaq8wKDl6kU6LBNgXKw=;
        b=O9OOAeM3XSdxpZ9mv5rJc7XSzzqBT1D8K8YTYAMbkS1TRyzhuZfTsEptWYUeVRlGpM
         M+vl55Hi0xed1TI5MYO9RvlDJ16phtCyVAupPGQ+NZSTu9YQ49I+eKk3uKQX/L/NWebO
         MYUS1PeC/CxJW4c0wp+VyfD/yFhFlR5nf/C4Q+yXneqkuLw3QOe12ehnXa6JBegSj8Fb
         2k2KzXxDBjaBsjlEaeOd0rw+OJhIzDk5sjnrOw6p9G4IvAgPXFlyYIVD8ZxYGpMBwdwc
         OpKVBNh3lu78yxRFvATHnW22uMFfbQM9NTsHISSkuF5p/evLGqAnBwBougnKd/5n5+gp
         TAww==
X-Gm-Message-State: AOJu0Yyj4GVyeh21/tlIGdvqQzon1GFmxC4g9oOPLp4moPiw33FpLdJh
	nw+QvZdqoY/3EZ8jv4yn6sJGX4DaFGpxmakwXjGKakW2qyAwuZzond5tpXJAk92KkvEEZffqAQr
	JaiKuwpqdzDt3dPDzigr6tg==
X-Google-Smtp-Source: AGHT+IF9AOcID1tAjXrc0JMac0EDJz+dHtqrQkj3EUSn3vqGuyTbyD2exFl+z4P0Z9sNallPuFjPTF0m9Vi898GeuQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a25:aa87:0:b0:e0b:fe07:1e22 with SMTP
 id 3f1490d57ef6-e1d9db996f3mr4706276.1.1726092336807; Wed, 11 Sep 2024
 15:05:36 -0700 (PDT)
Date: Wed, 11 Sep 2024 22:05:35 +0000
In-Reply-To: <Ztl4TDI98tnCkH0X@gmail.com> (message from Ingo Molnar on Thu, 5
 Sep 2024 11:22:20 +0200)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnto74tdexc.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 4/5] x86: perf: Refactor misc flag assignments
From: Colton Lewis <coltonlewis@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, seanjc@google.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com, 
	will@kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu, 
	naveen@kernel.org, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, 
	tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Ingo Molnar <mingo@kernel.org> writes:

> * Colton Lewis <coltonlewis@google.com> wrote:

>> Break the assignment logic for misc flags into their own respective
>> functions to reduce the complexity of the nested logic.

>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arch/x86/events/core.c            | 31 +++++++++++++++++++++++--------
>>   arch/x86/include/asm/perf_event.h |  2 ++
>>   2 files changed, 25 insertions(+), 8 deletions(-)

>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 760ad067527c..87457e5d7f65 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -2948,16 +2948,34 @@ unsigned long  
>> perf_arch_instruction_pointer(struct pt_regs *regs)
>>   	return regs->ip + code_segment_base(regs);
>>   }

>> +static unsigned long common_misc_flags(struct pt_regs *regs)
>> +{
>> +	if (regs->flags & PERF_EFLAGS_EXACT)
>> +		return PERF_RECORD_MISC_EXACT_IP;
>> +
>> +	return 0;
>> +}
>> +
>> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
>> +{
>> +	unsigned long guest_state = perf_guest_state();
>> +	unsigned long flags = common_misc_flags();
>> +
>> +	if (guest_state & PERF_GUEST_USER)
>> +		flags |= PERF_RECORD_MISC_GUEST_USER;
>> +	else if (guest_state & PERF_GUEST_ACTIVE)
>> +		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
>> +
>> +	return flags;
>> +}
>> +
>>   unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>>   {
>>   	unsigned int guest_state = perf_guest_state();
>> -	int misc = 0;
>> +	unsigned long misc = common_misc_flags();

> So I'm quite sure this won't even build at this point ...

Must have been a wrongly resolved conflict after rebase. I had thought I
rebuilt before sending but something slipped.

It's fixed

> Thanks,

> 	Ingo

