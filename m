Return-Path: <kvm+bounces-31545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 973C59C4B18
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 01:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA8C5B2ED96
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 00:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BF61F8198;
	Tue, 12 Nov 2024 00:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="mU/W2cMy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324261F80CC
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 00:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731371374; cv=none; b=unmRalZcObDZYr69rU6a2Clr/L3XhtMeaXeJl6rWBVVprhHxmEIgztNmxSFo3HbuFUlEAE0I9TrsOoojxDIl2euZtSwz5aXVz3fG+AYV54pNutmlrfwE1b9MddV6JxtPS0qLQk0sVtRmvuVJgCvtvDfraiRLz7qsfrrN8sle3oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731371374; c=relaxed/simple;
	bh=y+sIlGlK1ot+NL5bRt+3ik7yX/0qUa+/oiTZJS1j8sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fk0hmqDGiGW/v1MmcN2Bt5Kzq3U5Ti+t2M+JZQ1DNkIVsz9RDYHbUoCsIiFuSB4XXpmSFzmvyfPChfLfz/KtapRGqN3tWxhyNExR4/3mdPvVpw3jJJThif9b4uHE8Woc9RT72AOYQA8Jkvzrd9Ovh9qua7cOj/DTxyMvU09Z8rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=mU/W2cMy; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5c9c28c1ecbso6251839a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 16:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1731371370; x=1731976170; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1qlKXme+AbrFb5QeQvTrDduzfdq4287bHR+Jn2oguKE=;
        b=mU/W2cMyL5HV9yn4TiunlrZtxy+/G0LX4Q8SOlIS3C9VqoQtU4hEtmUiaSwkWGmkjT
         ZjYHXEXRmTl1P3YJK8T9SFmXe05zfPGfoU91ihuf62o5ZTIdLPLQKYvF2lQ3l4pq5W0P
         dZi4UjZpNdgIjyLCaS2gVvgzxUUOsrt98Lh3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731371370; x=1731976170;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qlKXme+AbrFb5QeQvTrDduzfdq4287bHR+Jn2oguKE=;
        b=evse/eKLjMB08M22OJmmiTCbhNwiiQuBJ1Ss2tBVJ90VrABg0HieLVO8fpd3z1pP6x
         fBmR/FJV3UoqA2JVvOcXlnc3z/7PMYtrLBpFHwkM9njA2IUXlZ4Lf4FjBBMo1+KV3yXE
         mSa/bDznx31kypxalP9SRgG74MG/dNC30LrYtq58LpqSZPulJ9hJnj7Wmgzye7F5jQyD
         z9OmdccZm4gXxzr6W1GzpLwE8rZ49v8YqXi7SCYdWzsY9JXlicAJG8OAgSECYT/FwiTZ
         0rAjzDyxUg7gbDcKfiYcvgBH9hcZmrjBZXz9DlBXChfiw6nYo9yYqOYtjhJAh61N/bFj
         nUcA==
X-Forwarded-Encrypted: i=1; AJvYcCUThSPSNVBXnOx/EqdB3dppfpUHAXItevnULYx/Ds4SuP9v+WpyrgcdmA7mYlfn1x92zzM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/f95AXnbl05iYI+5mFIsvz7HPR4CRcFNvuZnD+YXBuUTovbzJ
	xoAhJx9YMFOUIH/295BQQgbBlHBtl6IVPMbeZhpPkKascdxw/3U67mXl1KRLTOk=
X-Google-Smtp-Source: AGHT+IFb5jx4LoluBnkScmR+/SpzJlq7p0iJwO44PQYlIFWaCoWA8xIBUCZWk2JqmroLeW5QnN6rdQ==
X-Received: by 2002:a05:6402:5213:b0:5ce:fc3c:3c3 with SMTP id 4fb4d7f45d1cf-5cf0a45c690mr13056306a12.28.1731371370424;
        Mon, 11 Nov 2024 16:29:30 -0800 (PST)
Received: from [192.168.1.10] (host-92-26-98-202.as13285.net. [92.26.98.202])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf03bb5ed3sm5428338a12.38.2024.11.11.16.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 16:29:29 -0800 (PST)
Message-ID: <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
Date: Tue, 12 Nov 2024 00:29:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
To: Josh Poimboeuf <jpoimboe@kernel.org>, Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 linux-doc@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
 bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20241111193304.fjysuttl6lypb6ng@jpoimboe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/11/2024 7:33 pm, Josh Poimboeuf wrote:
> On Mon, Nov 11, 2024 at 05:39:11PM +0100, Amit Shah wrote:
>> From: Amit Shah <amit.shah@amd.com>
>>
>> AMD CPUs do not fall back to the BTB when the RSB underflows for RET
>> address speculation.  AMD CPUs have not needed to stuff the RSB for
>> underflow conditions.
>>
>> The RSB poisoning case is addressed by RSB filling - clean up the FIXME
>> comment about it.
> I'm thinking the comments need more clarification in light of BTC and
> SRSO.
>
> This:
>
>> -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
>> -	 *    regardless of the state of the RSB.
> is still true (mostly: "all" should be "some"), though it doesn't belong
> in the "RSB underflow" section.
>
> Also the RSB stuffing not only mitigates RET, it mitigates any other
> instruction which happen to be predicted as a RET.  Which is presumably
> why it's still needed even when SRSO is enabled.
>
> Something like below?
>
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 47a01d4028f6..e95d3aa14259 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1828,9 +1828,6 @@ static void __init spectre_v2_select_mitigation(void)
>  	 *    speculated return targets may come from the branch predictor,
>  	 *    which could have a user-poisoned BTB or BHB entry.
>  	 *
> -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
> -	 *    regardless of the state of the RSB.
> -	 *
>  	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
>  	 *    scenario is mitigated by the IBRS branch prediction isolation
>  	 *    properties, so the RSB buffer filling wouldn't be necessary to
> @@ -1850,10 +1847,22 @@ static void __init spectre_v2_select_mitigation(void)
>  	 *    The "user -> user" scenario, also known as SpectreBHB, requires
>  	 *    RSB clearing.
>  	 *
> +	 *    AMD Branch Type Confusion (aka "AMD retbleed") adds some
> +	 *    additional wrinkles:
> +	 *
> +	 *      - A RET can be mispredicted as a direct or indirect branch,
> +	 *        causing the CPU to speculatively branch to a BTB target, in
> +	 *        which case the RSB filling obviously doesn't help.  That case
> +	 *        is mitigated by removing all the RETs (SRSO mitigation).
> +	 *
> +	 *      - The RSB is not only used for architectural RET instructions,
> +	 *        it may also be used for other instructions which happen to
> +	 *        get mispredicted as RETs.  Therefore RSB filling is still
> +	 *        needed even when the RETs have all been removed by the SRSO
> +	 *        mitigation.

This is my take.  On AMD CPUs, there are two unrelated issues to take
into account:

1) SRSO

Affects anything which doesn't enumerate SRSO_NO, which is all parts to
date including Zen5.

SRSO ends up overflowing the RAS with arbitrary BTB targets, such that a
subsequent genuine RET follows a prediction which never came from a real
CALL instruction.

Mitigations for SRSO are either safe-ret, or IBPB-on-entry.  Parts
without IBPB_RET using IBPB-on-entry need to manually flush the RAS.

Importantly, SMEP does not protection you against SRSO across the
user->kernel boundary, because the bad RAS entries are arbitrary.  New
in Zen5 is the SRSO_U/S_NO bit which says this case can't occur any
more.  So on Zen5, you can in principle get away without a RAS flush on
entry.


2) BTC

Affects anything which doesn't enumerate BTC_NO, which is Zen2 and older
(Fam17h for AMD, Fam18h for Hygon).

Attacker can forge any branch type prediction, and the most dangerous
one is RET-mispredicted-as-INDIRECT.  This causes a genuine RET
instruction to follow a prediction that was believed to be an indirect
branch.

All CPUs which suffer BTC also suffer SRSO, so while jmp2ret is a
mitigation for BTC, it's utility became 0 when SRSO was discovered. 
(Which as shame, because it's equal parts beautiful and terrifying.) 
Mitigations for BTC are therefore safe-ret or IBPB-on-entry.

Flushing the RAS has no effect on BTC, because the whole problem with
BTC is that the prediction comes from the "wrong" predictor, but you
need to do it for other reasons.

~Andrew

