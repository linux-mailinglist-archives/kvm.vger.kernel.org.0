Return-Path: <kvm+bounces-70634-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPlFNPUiimnLHQAAu9opvQ
	(envelope-from <kvm+bounces-70634-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:09:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1DA113641
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 19:09:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EB884301CFEA
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 18:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076CF38A705;
	Mon,  9 Feb 2026 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Mz/xlR4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9CE37F8AD
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770660586; cv=none; b=GEqfH5V00eRGOM2Vi5LAezjyhRAT8o9o/ntO+t8wbOmJBbmHo4q8VNlIFvSAR9cb4jroAFGW2RX+DnmBgBFUyZvQo+MNQLnOy/igozyHrP0a/gNLVk2V9wm3uCAYNad8OFWZbn1bJ09YehleB8kGibNczzlDGINZSosPlLzdd9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770660586; c=relaxed/simple;
	bh=mHP9jeGPXy+0pKxv7b3osWtxWBmgwduzm/EGUPrLLI4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ov/FBu7BCMeGYUCykLaLqDQyeHkGJy1PJg8nNOlvDTFWoLqYo67VmexvWfPgGqQKM26yCZRDbYWjMvg858S0vkFbXdgCNGeKHwidOc227k+6/Dr9fK4HvOy8XsLBp/vGQOQ1OnR/b6EgtSipS3A0nx98s9ttPvtovF7NP1PqKRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Mz/xlR4x; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c0c24d0f4ceso1138333a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 10:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770660585; x=1771265385; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4VdLeIrwJMAH8yGmQkTq1zd7aoi6HuCk3sy2WloJSSI=;
        b=Mz/xlR4xeOKBTUcnk05MUCvvO6VixikTIOQcvcJuUiC4YNJDn8GUvuFCQx6meM+L3/
         3O4Wwe1hg96HAqKUy/cJN/2iwR/LDa30uMLLQObn5me4W2jR/WGFsTV/g1NGt4jKWzEW
         NgfG1aMdVWOwKL8ZyDFNAGeCtO5zUexdy9dTyUf4GuH0s6kIlz4rtMbV/FlgQbCzx53A
         h9IaMtNDuRK0FfVpmlwGA6xUbR45gtD9+I/1ELxBH7ubLFfo06zuuqL86b7vzGk2cYFq
         gB7SfepP0Hcar9Pjd+zD94KSEfGOzyuXnprgan/k7lyOI9OQWLm4p2qW22qME80cfGcg
         Dr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770660585; x=1771265385;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VdLeIrwJMAH8yGmQkTq1zd7aoi6HuCk3sy2WloJSSI=;
        b=b6hrctzymiHF1uABxz4vvEVuqXfevGOVSy+vFFiN43BdfjsmQaCynnLWE1QcAnQgak
         XshAHmo4vOfYElWjB3dDjFZfSY4fSqAXYUK18Q64h+qnfwvCqPBdzENfXe0h4G+BVJqJ
         6K99iWLTvGmDFFOCgqsilNQdV2bTH7vNpyujhXBVC57pThisHSmxMCLjmSWIvS6+oLBp
         Ufw+WPJl2EzOZCQMl/QYI94uUdXOjp79w3TENi8NjDnPMWOwsoeVXUo5eLnlX+3l+Dwk
         zmqqW9Ob6Cpl/oU8jPcIxjsMMhWhr9etVFrCBoE0oXrVt24gUFz5xZKxqVY9BgvQz1fB
         eREg==
X-Forwarded-Encrypted: i=1; AJvYcCUR9d2AXoW4c4g9rcXtlI9m3ih6QbNVie4EjhJfdmauBOl68PGwgsm2jltbG+J6VVsJ/q8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq/XkTtMCdqmf2qBatwSybMTXr/FlO8lGT9LGHcyp5va4Yg19D
	W7tcK68vh6porcQq21qIfXSiVjs00ZKu1IJ4P1kEx35L0b7jk/wg/wmFZGVyKrT6C+bLzRn9Lo3
	DUfIY
X-Gm-Gg: AZuq6aJzqlSPaehdxoVlrrA06aqufokhMhBW4VSLPyJ4Gt/DbHo8dGt9/ydGywbkvB/
	oIFSciaxj9hX8XQzhCE/KzeJa3meEol+4Q0IfNKAM/YIxzkNsSAJEXlBbWJCg6kMUORWlBmRvOe
	WdD8rKWRCstB03VjRAihUu7Nh5sv9VQVV4+984W1n+/+paRJCVjqHf+2A2Xf5gvzCrRpPu7SZ4b
	GA9TGMxLkYAizpC7CDnbB+/cQhWxfP2/oK9WipVh4JkYw/6L1Lsd4y7+xoE9aKlHoi0S3dsrgAs
	cvyoJKPvSTv5Ox3R3DPMX0gDft9bRbmMjCxZGh/OZrw54dD4hf54jYEbf50RBxZHpLEXkds6Rs0
	kncwWHsqSrfbCdlHExC8BHDJKNieOqaKEIgAdBZSbLayuR6b5N06sO/XzQ3hSTDg1mq6XCXppoH
	4bKSVTipffz/pDGNVUrQ7hSF1oxTWllnHR+lTjcXCrwW7myKD7dM62FaYc
X-Received: by 2002:a17:903:b4e:b0:2a9:322e:2473 with SMTP id d9443c01a7336-2a951969ef2mr104356885ad.48.1770660585235;
        Mon, 09 Feb 2026 10:09:45 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824490442cfsm10910468b3a.16.2026.02.09.10.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 10:09:44 -0800 (PST)
Message-ID: <b23e5d00-19cd-4eca-9cff-38ec78f87929@linaro.org>
Date: Mon, 9 Feb 2026 10:09:44 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and
 tcg/crypto_helper.c between user/system
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-7-pierrick.bouvier@linaro.org>
 <6c5eb308-56e6-487a-ad7b-8f0da70ab7cd@linaro.org>
 <e291f290-a188-4106-8648-48d4c464dfed@linaro.org>
 <a6320ab4-7ece-4618-8d73-549df7a34886@linaro.org>
 <c0b0691b-3cef-4ec7-8d68-227420167481@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <c0b0691b-3cef-4ec7-8d68-227420167481@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70634-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: 3E1DA113641
X-Rspamd-Action: no action

On 2/9/26 9:57 AM, Pierrick Bouvier wrote:
> On 2/8/26 11:08 PM, Richard Henderson wrote:
>> On 2/9/26 15:52, Pierrick Bouvier wrote:
>>> On 2/8/26 9:00 PM, Richard Henderson wrote:
>>>> On 2/6/26 14:21, Pierrick Bouvier wrote:
>>>>> In next commit, we'll apply same helper pattern for base helpers
>>>>> remaining.
>>>>>
>>>>> Our new helper pattern always include helper-*-common.h, which ends up
>>>>> including include/tcg/tcg.h, which contains one occurrence of
>>>>> CONFIG_USER_ONLY.
>>>>> Thus, common files not being duplicated between system and target
>>>>> relying on helpers will fail to compile. Existing occurrences are:
>>>>> - target/arm/tcg/arith_helper.c
>>>>> - target/arm/tcg/crypto_helper.c
>>>>>
>>>>> There is a single occurrence of CONFIG_USER_ONLY, for defining variable
>>>>> tcg_use_softmmu. The fix seemed simple, always define it.
>>>>> However, it prevents some dead code elimination which ends up triggering:
>>>>> include/qemu/osdep.h:283:35: error: call to 'qemu_build_not_reached_always' declared
>>>>> with attribute error: code path is reachable
>>>>>       283 | #define qemu_build_not_reached()  qemu_build_not_reached_always()
>>>>>           |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>>> tcg/x86_64/tcg-target.c.inc:1907:45: note: in expansion of macro 'qemu_build_not_reached'
>>>>>      1907 | # define x86_guest_base (*(HostAddress *)({ qemu_build_not_reached(); NULL; }))
>>>>>           |                                             ^~~~~~~~~~~~~~~~~~~~~~
>>>>> tcg/x86_64/tcg-target.c.inc:1934:14: note: in expansion of macro 'x86_guest_base'
>>>>>      1934 |         *h = x86_guest_base;
>>>>>           |              ^~~~~~~~~~~~~~
>>>>>
>>>>> So, roll your eyes, then rollback code, and simply duplicate the two
>>>>> files concerned. We could also do a "special include trick" to prevent
>>>>> pulling helper-*-common.h but it would be sad since the whole point of
>>>>> the series up to here is to have something coherent using the exact same
>>>>> pattern.
>>>>
>>>> tcg_use_softmmu is a stub, waiting for softmmu to be enabled for user-only.
>>>> Which is a long way away.
>>>>
>>>> It's also not used outside of tcg/, which means we should move it to tcg/tcg-internal.h.
>>>>
>>>
>>> Thanks, I didn't think about moving it somewhere else.
>>> This does the trick indeed.
>>
>> You can also make it always a #define.  The variable for user-only is never set to true.
>>
>>
>> r~
> 
> Sure, let's go for a define then. :)
> 
> Regards,
> Pierrick

Does a simple #define tcg_use_softmmu false/true is enough for you, or 
do you expect to see proper ifdef blocks in all tcg-target.c.inc?

If that's the latter, I would prefer to do it out of the scope of this 
series, as it's not a priority now.

Regards,
Pierrick

