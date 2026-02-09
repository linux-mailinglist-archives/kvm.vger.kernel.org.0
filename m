Return-Path: <kvm+bounces-70673-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KOPHGLRximnPKQAAu9opvQ
	(envelope-from <kvm+bounces-70673-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:45:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7661156FD
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 755A6301CCF5
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 23:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124EF30CDBE;
	Mon,  9 Feb 2026 23:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KnjGZwA3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3A72147F9
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 23:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770680748; cv=none; b=WVF5c+6LaeJ1i7ZNgcyO+3nmpGI3XlJ9fCkteFlB4/B48Z9EbuN0498mZriYmuabKtwtpgNVxl4vMmBRIaItgpComm/cgPDOh6VLcxbEzF7Wm8/Vlq8vltiG0Cz7MF+1Gj+HspKr04hUpz9lqRbmA5lsgaEnllmGOQsq4bss9i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770680748; c=relaxed/simple;
	bh=oOA7Uqttxroww0KU1zdCIqaRH5kB7bgOTGj4Ce2neQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRUuhU095+kMrCar51I/PaddZQCRDee0X88FM+vGnxEihdnT96w5qoybTnSceyH3aDk3PqVeLdj68+wxIhIXWxN3+kexe36SsRhjb+x6tK5iyw96TX7oTMxJVGKyEIW11dOBXWCj7jnPUyfCAClpVFv4GaqSdSgmAbmVlKcm4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KnjGZwA3; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso171012b3a.3
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 15:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770680746; x=1771285546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+uxnFemVoYdAu1YcNSi/SW1k2+9fgdDNw1Nf4DNxbs=;
        b=KnjGZwA3IlVTqeXUgHI8aFeGQV96yIPnfgnM/vY/ujEBVsEd3+2fc2dWfxrHNk4Q5X
         8wDhkiAa0tQPgUhgkzUeMDpa3tefzIJ5gQkuC92KxJH9pz2uoMc2zHrK8KyllJcNY/Rd
         zItvuv/PgLoTVNaxRYmSNlNdGLRAbqgGnigl+IohnosD3iGDpZipyPbd7gIRHpkZF2Kz
         Bb6W9tGjjE6Q4aFvcoYjqJc+TkLb8XhV/kx94kAFjtAZpoCwwpyBYoiEaB6Z8hfhH+X7
         6fmbtJNjjTaOhDsXkqNSmJR8olWvvsWTo9mWUNzKa9ZsnZcT/auO5NQT+LoTdlM1g4lL
         8v2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770680746; x=1771285546;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g+uxnFemVoYdAu1YcNSi/SW1k2+9fgdDNw1Nf4DNxbs=;
        b=XkAsrdJ7o/gzR7MnYfs75LPdrXekvECFfDoBpIoPCI/caPUIXHIOsz4DQZBingfNBL
         Hu1jRGB74WiSbCnCmYFWc1HUfjYFTEgGbqy3c5js3SiZJf+xh4WQGdYWKwbqu/pLzrAX
         e44Tcl3/fBwsePq7KoiPP+emNT7d2yFP8ZXcW8iWTTl60KD3UGO97Oe9HDoZYI8/TrR8
         8uDyrR7fsyJipchZnVjVUqUHv9Y51UP4qaED1IoyeTSEUTSAWFCBK/NwZ+RXtoJ0sGL5
         flUQTSnYxfIIWCBhQ8FwGCIIb1xpIaRS007G/NRUAddh31bOq0aHHD+n7+NIIPE41Ids
         Fbxg==
X-Forwarded-Encrypted: i=1; AJvYcCUhO4DnpO0qupyHcQRZj7fDPDdVO7cPOFZFFTCVBC3lpYU1PJZdRI3COFJy7AJqsOI/msk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFb/Sygied6rgkMBJ5BePgAHFDB7TbAZxtX+WJp2/AV3auJS04
	mq8q/DR3nrOpCsqIBDwD16Ff83nkP1uh+yoLHNSlGDwIkl5/tihgoiVkShT7T2YKpfM=
X-Gm-Gg: AZuq6aLpDPVqgImq6EAyThRBLBsNmpQTrF6kwzT5c3qIEzT3TJ1KjPh9g2iapMePSyS
	VVr+m1QwyqbVeibY8FyGn1Amku4smlaztt7+VDAODUrfCLB+Z4P8zBt4x3hpKnkx0oqrmKmLrs0
	J+iGif1gMPpYqvYEAR9uWOTPXQL0g2E2D63FeLuzZpvEcI1wvZ+YU5GgVbmXlwhixwgz6DvzoGT
	9y7FQtAf3lQfx8qr4DNdOShkURgnf3yAe2pYGAWXWd/Yt2TWe+VpwD+jcWXSTADTZlWTw/rAwxp
	W3+0eD8khEvlFI1FJ1tzjkDcY615Du5ILHvJ1RmpQM51wjXzZeLzpSnePsBzWJZbyDmZIwZRLzj
	b0+j3ft3/s5jQs3MYj4MRvThgo5NkiVnknrqMk9WFimRjSu6cQQtjoo4pdNkVVJO5eEB78zwd6C
	AiBx6UysadWZOde7nAoBFOlfMTylGRuL3kR2q1OqNdfgKFsG7sNeUre/SMYvRbcQqM3RYJtp59f
	YiXhj1HgLsL
X-Received: by 2002:a05:6a20:ac43:b0:36b:e81e:386 with SMTP id adf61e73a8af0-393ad46351emr11070220637.80.1770680746450;
        Mon, 09 Feb 2026 15:45:46 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:bc29:21c6:e150:bc42? ([2001:8003:e109:dd00:bc29:21c6:e150:bc42])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb5249a0sm9921804a12.11.2026.02.09.15.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Feb 2026 15:45:46 -0800 (PST)
Message-ID: <11a09f7d-5274-4ac5-b6f2-90d9490751a4@linaro.org>
Date: Tue, 10 Feb 2026 09:45:31 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and
 tcg/crypto_helper.c between user/system
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
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
 <b23e5d00-19cd-4eca-9cff-38ec78f87929@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <b23e5d00-19cd-4eca-9cff-38ec78f87929@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	TAGGED_FROM(0.00)[bounces-70673-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: BE7661156FD
X-Rspamd-Action: no action

On 2/10/26 04:09, Pierrick Bouvier wrote:
> Does a simple #define tcg_use_softmmu false/true is enough for you, or do you expect to 
> see proper ifdef blocks in all tcg-target.c.inc?

Just the #define, so that both paths are always compiled, even if dead-code eliminated.


r~

