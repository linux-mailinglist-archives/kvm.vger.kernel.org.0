Return-Path: <kvm+bounces-41334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC99A66437
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:51:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A152D1895559
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 00:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B0882D91;
	Tue, 18 Mar 2025 00:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yyrlscdI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DFF21348
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 00:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742259023; cv=none; b=P+FPhC5B/xU9HF1cwz1jiWSGJM8E2IpakkD4Yga2INUlTgn1rouxM0I7OGaOb8haCpMjdTj3aGbrB/0Rkow3ft1XmUcyo6/graipneT4q+VzkdJmErLE7SzIBfoTTCzrKPCvORfNYDw8coKskXop4ZEbWG0CJTw8h3049u+soRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742259023; c=relaxed/simple;
	bh=1bC4AZNde0+5vTIjrxOxW8rZtXb6vrr9ApjJTDktajw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XJAMv5qoRUVjXadzpQCqVi+an94BRlRuCaWb3/nQgH+z/CxjZzI5zf4ahpH78C+kOwt/K+UZ8arZ2l1Jdf0ssNqq1rvA2ee2yY7HUmsO2Nkhr5bc1JoZoJwdQk4a/mFTJ5rlyQLQrigfRjMutYab+s0xgxmfCa/Ui7fy5goeK2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yyrlscdI; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2242ac37caeso34375ad.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 17:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742259021; x=1742863821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jyS5rCxr8EQqFWu2KoBKo/0nF0NkexL7fmn9bWW5ufc=;
        b=yyrlscdIWiZSKMq3QXS409sQMBjsz84n9zwd6+4u1CBlg/RQZfK8Ur4vnCb3ijGnBg
         sAAapMVQ3FLztb5XLx4Lql6Goz5tjlsshZHJJQUHSKOQkPuPN+K6++GCOzXMbt6RhyEs
         e6yiPmSKAs7NNifhwqiaq36nTm1/3WPBcGijBWpeGh3qM12YucOw2MsBlHj+roGUTX4H
         URsisSADh89YBCagz+ttJ+jT5U7sXCjMOw/AXHu34540k6xf5PcIyvc9K1ROGIsHXpGM
         cKDHthiT5Q8dEV153aGc8opkA5A0mB3LZYp812GtTNgGwFW1IlVDPVvOKZnw1oXxidWO
         Ah3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742259021; x=1742863821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jyS5rCxr8EQqFWu2KoBKo/0nF0NkexL7fmn9bWW5ufc=;
        b=iXYvZx1ib5o67RwFaKFhfiPcWLc+NTrvGlISfpvAlA3kYC7/SpOjA/oi+IoR9PUbpP
         WLXewy/niQHm7W0akxzXsubOfew2/7GX4+Im9Omt20Bp2AgEdEBYonWUqY+DgD1B6pcp
         pOxVbmo4q/S94gfU3ugH59NqX7lEKfAiPXn2okUSnBxjVzt7rirGXpXVbzbn0xOALbxq
         C+/Yhm/9Ux9M8ugUxr8Di9z4BJe8Y9TgPCzenEEoUxombd0eJ3IwobdNIn1gwTBwf6LK
         oVxpAhW0g4lDAapjfjuJSZmcbyU5AvNS/jlAaaXhUHV89m735/4RJ97C6prHbOPP/Rkr
         DX1w==
X-Forwarded-Encrypted: i=1; AJvYcCXwfqlc82B10lBeScIoF9pUZPE6mC+J9SUOug8gzhkXafRG/YgnDYUKzvxrsQ6cNqPBnsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTsqEpy+Vef0GfcGCy46UqZ6yAFdlg09gUOQNFKhjfQ11GKZJe
	IxBhVTUK5Uj+UJfZFq1/DL/g+fbweCRbTJO/G1ALA3Qkpt6m5vNWaD5jzTyAdQ==
X-Gm-Gg: ASbGnctcIBhqC7fmB4vAmfuRMy+S2jNrbyv2plLAstnxPWzK8pJCJ3hkKLEE0iw9YU8
	I0uh/uoxzitgp9r6x3BrMw6gFb9KhNqrbHpBAV74Zuu1jH0J2OB/VGvkU+qjb4V2Al/KfVBBUTK
	LQz7k0nrxeeS1k8T4Bk5fQkRhukLXbU8hEtuEdG3+ghZLRrnpnCeV6SIvpK5IRL54AEMgWgSHFo
	bIzlC7qUg4oZu96Glj3YHSU8IYC6fmpklgk1AZ60uahhaf3tJZRxZUlcd9Up6TtIFggrgd4iqsl
	S6UB+kL66C0DcTUxcDXAtBVci+A9V1IKMHHBmuJSc/f2bC+W99PQxup/Zc1V796umBEhhTBAW+W
	ErVQ6qo4GpFv10DVVGA==
X-Google-Smtp-Source: AGHT+IHphGAwUXfXr7Mrrbm3vJ5pDrNsyjOLR/aaUMGpU3EUMn5PRxeescEk16cYhxEl8m70XssWNA==
X-Received: by 2002:a17:903:8c4:b0:216:21cb:2e14 with SMTP id d9443c01a7336-226357e0c41mr127135ad.21.1742259021211;
        Mon, 17 Mar 2025 17:50:21 -0700 (PDT)
Received: from ?IPV6:2600:1700:38d4:55d0:4268:be3e:41c6:d4b4? ([2600:1700:38d4:55d0:4268:be3e:41c6:d4b4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301539d3f4bsm6814559a91.5.2025.03.17.17.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 17:50:20 -0700 (PDT)
Message-ID: <4ce0b11c-d2fd-4dff-b9db-30e50500ee83@google.com>
Date: Mon, 17 Mar 2025 17:50:19 -0700
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
Content-Language: en-US
From: Junaid Shahid <junaids@google.com>
In-Reply-To: <Z9gKLdNm9p6qGACS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 4:40 AM, Brendan Jackman wrote:
> 
> I don't understand having both asi_[un]lock() _and_
> asi_{start,enter}_critical_region(). The only reason we need the
> critical section concept is for the purposes of the NMI glue code you
> mentioned in part 1, and that setup must happen before the switch into
> the restricted address space.
> 
> Also, I don't think we want part 5 inside the asi_lock()->asi_unlock()
> region. That seems like the region betwen part 5 and 6, we are in the
> unrestricted address space, but the NMI entry code is still set up to
> return to the restricted address space on exception return. I think
> that would actually be harmless, but it doesn't achieve anything.
> 
> The more I talk about it, the more convinced I am that the proper API
> should only have two elements, one that says "I'm about to run
> untrusted code" and one that says "I've finished running untrusted
> code". But...
> 
>> 1. you can do empty calls to keep the interface balanced and easy to use
>>
>> 2. once you can remove asi_exit(), you should be able to replace all in-tree
>>     users in one atomic change so that they're all switched to the new,
>>     simplified interface
> 
> Then what about if we did this:
> 
> /*
>   * Begin a region where ASI restricted address spaces _may_ be used.
>   *
>   * Preemption must be off throughout this region.
>   */
> static inline void asi_start(void)
> {
> 	/*
> 	 * Cannot currently context switch in the restricted adddress
> 	 * space.
> 	 */
> 	lockdep_assert_preemption_disabled();

I assume that this limitation is just for the initial version in this RFC, 
right? But even in that case, I think this should be in asi_start_critical() 
below, not asi_start(), since IIRC the KVM run loop does contain preemptible 
code as well. And we would need an explicit asi_exit() in the context switch 
code like we had in an earlier RFC.

> 
> 	/*
> 	 * (Actually, this doesn't do anything besides assert, it's
> 	 * just to help the API make sense).
> 	 */
> }
> 
> /*
>   * End a region begun by asi_start(). After this, the CPU cannot be in
>   * the restricted address space until the next asi_start().
>   */
> static inline void asi_end(void)
> {
> 	/* Leave the restricted address space if we're in it. */
> 	...
> }
> 
> /*
>   * About to run untrusted code, begin a region that _must_ run in the
>   * restricted address space.
>   */
> void asi_start_critical(void);
> 
> /* End a region begun by asi_start_critical(). */
> void asi_end_critical(void);
> 
> ioctl(KVM_RUN) {
>      enter_from_user_mode()
>      asi_start()
>      while !need_userspace_handling()
>          asi_start_critical();
>          vmenter();
>          asi_end_critical();
>      }
>      asi_end()
>      exit_to_user_mode()
> }
> 
> Then the API is balanced, and we have a clear migration path towards
> the two-element API, i.e. we need to just remove asi_start() and
> asi_end(). It also better captures the point about the temporary
> simplification: basically the reason why the API is currently
> overcomplicated is: if totally arbitrary parts of the kernel can find
> themselves in the restricted address space, we have more work to do.
> (It's totally possible, but we don't wanna block initial submission on
> that work). The simplification is about demarcating what code is and
> isn't affected by ASI, so having this "region" kinda helps with that.
> Although, because NMIs can also be affected it's a bit of a fuzzy
> demarcation...

Not just NMIs, but other IRQs can also be in the restricted address space even 
in this initial version. But that is of course still significantly less in scope 
than the general case, so the demarcation of process-context code via 
asi_start()/asi_end() does indeed seem useful.

Thanks,
Junaid


