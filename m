Return-Path: <kvm+bounces-41465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59689A67FFC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFD2C188B865
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB70620765F;
	Tue, 18 Mar 2025 22:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dh8ZgH+K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975002F36
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742338133; cv=none; b=u8g2lx56yx60I/XMipZENePZVrWE+Pm5J7lbEH+36nbHfuqFDLJz5A9vH9ToCHhlH6byYvmPRa+SXLnPLsyLLR6mtxdx9pkOdToMuZiwLgt1LcJliaq/kfHXvSJliVZQSvlPfSNj9D1bKcNrn+TX62c75sCDYvqzq9jiIoGorDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742338133; c=relaxed/simple;
	bh=ZU5CllXWLaV7Y3kuWaXOCpEp2lQCHcbuBrlCd5712z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0d4Ju+7ARu/d0ADgJH2IIW59MxQJ0t+DSPGs1OH2dzUNYXY3iJTfjdODZFCcipYT/RL8/nAv6gY+9iq+JocCCLOQcu6jdNYt80Jg5GQWoDGQTIUH2QO5HQWTeHF4uLqnqE6/ULBMyk1s7bEEk9/LSZnLpbKdzLpQBeg8lFNbbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dh8ZgH+K; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2242ac37caeso28275ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742338131; x=1742942931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yB1FS2DQ8nodIaUEvS+b357Z+ztiw4fbjC4780IRl6w=;
        b=dh8ZgH+KucPRh5uNnrW/pCqTrZhF0QsbvxdtE6E8TZyCvKeFdM3GtxbQxJrkmQNY6v
         65uBayZBpqB8C8y2BK2czb9ER0RDXcLdykG5CT+KyJ2n3roaRMPUarrJwDcdUC3Tq3v1
         tBlECyAhM4ob0udyXMtNb/T5UPxR9Gt02blCjjLdDfAfr67DQcfJsBU18votvh2K6Lfg
         T1TRP015K367pjP15Ej5BxJJs747CVYqZ0XxE1ROZy0/UH4yTXBKcQ7x+KMEPand/v2o
         3AWHaYJeA+/aqsFxUM0zINiEOj/y0yQ6NSv8ALb7Nyffnuf7mtgzKHmPjLPkXzPESq94
         bvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742338131; x=1742942931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yB1FS2DQ8nodIaUEvS+b357Z+ztiw4fbjC4780IRl6w=;
        b=cLsTkO/qwajXgwX3FnPt5M2whyiRobFis+uQYO09JzDEptKs8G6lAsd1j1u5lB9uYT
         HL384bP/b80o5i6CefgJkDVbAb4WiwEWCgh6gWXHkdn2PRx/m7EGr9RIDeQ2tY3H2MBU
         +K29go3Bkjnl1BEfjwG6s4hnVksV07I6eR6X2jYkQHzb2IvD/Uf9dKxLP4Bc3zxbnxqr
         VyMoKpQbRIWAxrBNSTvYha6/8ub9xnbH7fdN4GM1LMGoLJUbsozhUxHqdqRYQ7pd+wLR
         k1A7UhsME9EQ99Buls92a1B/7u8fLzVLztsZ2E/LAsKygVknL9rvKsOUwGsR+adAshQb
         kmVA==
X-Forwarded-Encrypted: i=1; AJvYcCW1AFPO1nRfECvTw0hY3iihiOLmMJmKiTAB0md4QnCAsI0IRM0wPvviXklrnjslVMIDYS4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5a2L3l8IJFxaOe8YBfT8Somc6EVhGiWC2JirXFDOVwc8NY4Qj
	4TQ1dZQj69u8FBKPtt3P6zECuh4WQzzZ4eX8cG8tW72O59T5wxS2GP6XqfKtqg==
X-Gm-Gg: ASbGncsvExOYQ/xbusMcyYQsi1MHG0+DSWq8dWZVzyUOfIHldzYqpdGa2fspF2MeDNP
	00Fpj5zLWsnIh+1nE0orUfXP3m8CojzEnXSQBHlw5uO57gcidfVNicU1Klk4TjZfdqeGY8dYpOS
	yaDogTJvMqsZYl2L8R+qUaNkgGfSFg9W3ERs58cWd8fG2FMgoiZegx7TOp0alHF6tHYLUIXgstZ
	oUjOBTzSvIFDUyrAUbYG/IN65GFX+zkcpOtXsA5s3C3K2j7xcyi5IsAJJ4Sj6TmZx9mdyNVKVMC
	w64FKO2tU67DRkefsKYIekgLI4JUTlPiOOjQDfbmxwvCup4WcHkT+VSXjYg1IfTGcASGzO8QoYX
	lvV6nDyBa9PdgNGPWyA==
X-Google-Smtp-Source: AGHT+IG1WJH2BlKRQrmaKrj1YMWcR4l4t3CfTt4A9By84PeimJAYW3OrDGsda8P7tWwx3COeYJ3mfw==
X-Received: by 2002:a17:902:ce10:b0:21b:b3c4:7e0a with SMTP id d9443c01a7336-22649a3f591mr470575ad.13.1742338130378;
        Tue, 18 Mar 2025 15:48:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55d0:d0ab:d0aa:3b14:767a? ([2600:1700:38d4:55d0:d0ab:d0aa:3b14:767a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9dd388sm9562322a12.20.2025.03.18.15.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:48:49 -0700 (PDT)
Message-ID: <14f9106d-3a34-4f10-ba4e-465c73c94eba@google.com>
Date: Tue, 18 Mar 2025 15:48:47 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
 yosryahmed@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, peterz@infradead.org, seanjc@google.com,
 tglx@linutronix.de, x86@kernel.org
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
 <20250228084355.2061899-1-jackmanb@google.com>
 <20250314131419.GJZ9Qrq8scAtDyBUcg@fat_crate.local>
 <5aa114f7-3efb-4dab-8579-cb9af4abd3c0@google.com>
 <20250315123621.GCZ9V0RWGFapbQNL1w@fat_crate.local>
 <Z9gKLdNm9p6qGACS@google.com>
 <4ce0b11c-d2fd-4dff-b9db-30e50500ee83@google.com>
 <D8JEV1QJHY6E.10X36UUX60ECW@google.com>
Content-Language: en-US
From: Junaid Shahid <junaids@google.com>
In-Reply-To: <D8JEV1QJHY6E.10X36UUX60ECW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 6:03 AM, Brendan Jackman wrote:
> On Tue Mar 18, 2025 at 12:50 AM UTC, Junaid Shahid wrote:
>> On 3/17/25 4:40 AM, Brendan Jackman wrote:
>>>
>>> static inline void asi_start(void)
>>> {
>>> 	/*
>>> 	 * Cannot currently context switch in the restricted adddress
>>> 	 * space.
>>> 	 */
>>> 	lockdep_assert_preemption_disabled();
>>
>> I assume that this limitation is just for the initial version in this RFC,
>> right?
> 
> Well I think we also wanna get ASI in-tree with this limitation,
> otherwise the initial series will be too big and complex. 

Agreed. That is what I meant as well.

> 
>> But even in that case, I think this should be in asi_start_critical()
>> below, not asi_start(), since IIRC the KVM run loop does contain preemptible
>> code as well. And we would need an explicit asi_exit() in the context switch
>> code like we had in an earlier RFC.
> 
> Oh. Yeah. In my proposal below I had totally forgotten we had
> asi_exit() in the context_switch() path (it is there in this patch).
> 
> So we only need the asi_exit() in the KVM code in order to avoid
> actually hitting e.g. exit_to_user_mode() in the restricted address
> space.
> 
> But... we can just put an asi_exit() there explicitly instead of
> dumping all this weirdness into the "core API" and the KVM codebase.
> 
> So... I think all we really need is asi_start_critical() and
> asi_end_critical()? And make everything else happen as part of the
> normal functioning of the entry and context-switching logic. Am I
> forgetting something else?

Yes, I think this should work.


Thanks,
Junaid


