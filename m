Return-Path: <kvm+bounces-70581-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SNaqDj12iWlm9gQAu9opvQ
	(envelope-from <kvm+bounces-70581-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:53:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A299310BE59
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DE6603007941
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 05:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146652D9ECA;
	Mon,  9 Feb 2026 05:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ULsObhwm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5562222B2
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 05:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770616377; cv=none; b=tJm0q3Xv7Y/T61EQ0t6vd0b8osUrSdrYRXGoW2ayl11pBTi16WgGQ7SoTohiAer4y+Ut4Ua3bBOgmYNCkmp/BN8RBMKarccx8SSyb79qXvuDgW0ISGULJqpK9Evkjrj3aPj5b9Bi9EqLXNmsLH2OJ2+ZlOurFS5rs+Pp2j/REMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770616377; c=relaxed/simple;
	bh=P/gBjtZPoZynU/uuYnD7F1NKPtES4QDL8stjiZ371KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mizWE547axwJ30KaobjNGdJNMDw/TwZ8bnApnHcczuffN2TpQ/hy/3FbhlHIc7LUtvsjlSTG9GM9xvBzQt2xzgcPK5ZE1wYqHuBa3hP3DVR1Cjh2aiVLPx29Ls8G6QrZ/dUZA/YcPeDyAtX4yCrc2QSs9mDodlYvjb728VBe9kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ULsObhwm; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-81dab89f286so1952036b3a.2
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 21:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770616376; x=1771221176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aX1sQxtYdIMYAlVOMRcTE5905DWAYEmviChFaYJJ7N8=;
        b=ULsObhwmaZYAfl7VAVwMGYekAW/4eW4P97LG+I7WqVmXwsccNi/gbkoX3f9bANVt1y
         Xf/znKEy2ouEoQQPd1XW8JMowk2bD8aKEmlW6BsD9IAA7u8fnHoVAvgRr2T5MsDQf4FE
         unrNY72oGtTF1p8I6GtBPklknIGnPFWU5SpJIAb8TAhdZLK+9W0Y27vAiLLYCjgFWLdJ
         Sk4nGQvDSyKRy+7hsP7nVMupghMntaBD1YpmYS1t3m8xs5cfDPKU1WgiokUC002n+kwT
         v9KCyenlk0kePhjpWGc/zs94mppE27dGszOoQeCnA3aeVt6DG/YYdKuxqJfjllCundJy
         LdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770616376; x=1771221176;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aX1sQxtYdIMYAlVOMRcTE5905DWAYEmviChFaYJJ7N8=;
        b=YZ/yQZXQ/7RCGZtKE/bFUpfBJ61gaJ4pK1Y9vz/7AMMNA7BRxiPVcvB4db4KhwyIk2
         Qvd4ItYLtBTwyKOkNZ1THO4eK5UUR0XKjSba7t18C4MKIJ1FaDx3Y0fR5Gi/nXqI9mew
         UhLI7LA2x34cz8SO42L0oUF0P3Jtinkk1lXGna6zRz8caL6atz9MEy+Hgj+8oepHr00b
         LIUozu1ccIcHb7mCN8vA92rYQhhDJ6aENciu/OWKBHeD58T7cAQh4J/zB2RW39S4n/24
         KnhnhR9Zw9zoOJoTrhAqVYrW4BLniSKDSORSpfDvIV9N59VDVfnx5qI8n54H3ABzS28t
         sTbA==
X-Forwarded-Encrypted: i=1; AJvYcCV/GFgLvlKR6wuvWvYhdvTGMRFbwoxq79rl5dZQ9ktpIr5/N3go1FO3oH0I6g+MOvQOVlY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb5ctnrX8pqodwd8KU4p0Q6NvUFsgBFgwIUpcBMW7igPqj+99F
	N5cQutijZ1Kr8d8AMnFlprS5MJt6E6YPoDmyokYT9JyEzz4hZzWW8HV1KbNemHLYdrqweDppYlz
	rWoVS
X-Gm-Gg: AZuq6aIOHPDcuP16u4KNe5cXbSlYaRVSxUNkUTBui4EXtXtCFnZqlc7T3rENi9RtJ61
	9TdxKEEJgdr7LFQE2Gux7z7ghGvlavrk6TRcyu72hFS2DnD1440m41gaiA/W3pDsH81XGos8Upd
	wC2u4ew/XIQb8Wwf6Qogwv09BWl1av/mB3sq0ax/K6XO1CX7cybsIrMoCcV2Kt0fxKdWxKu+jKE
	X/3e3ChjgEzd/t6H+CLqri+hEFdPWu9o9BCUrlJlsjbFHp23kmktKEGSFLqGF7JxVVfEunnUs7w
	qotN6WA1DAsSwMhIo9iOWRh8pFdKSok2yf/p5YS8gUBqRkrQf373qZ2q0kTgj/QwzUy43fcLWZy
	tIzaKxezbbnMNkgQ+NQz287otTZtDKJE9ixegNlCM0WRKj6HVzWp89VdcAnht36K5+aS09XE7z3
	kLVgm6NEe8MOFUhRnOp0co/fP6IStV5tNVqi/m5YSXzkN9imiEwlk/X40V
X-Received: by 2002:a05:6a00:3989:b0:823:f04:e89b with SMTP id d2e1a72fcca58-824417242admr8351763b3a.48.1770616376277;
        Sun, 08 Feb 2026 21:52:56 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244152456asm9451125b3a.0.2026.02.08.21.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 21:52:55 -0800 (PST)
Message-ID: <e291f290-a188-4106-8648-48d4c464dfed@linaro.org>
Date: Sun, 8 Feb 2026 21:52:54 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and
 tcg/crypto_helper.c between user/system
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
 <20260206042150.912578-7-pierrick.bouvier@linaro.org>
 <6c5eb308-56e6-487a-ad7b-8f0da70ab7cd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Language: en-US
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <6c5eb308-56e6-487a-ad7b-8f0da70ab7cd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70581-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: A299310BE59
X-Rspamd-Action: no action

On 2/8/26 9:00 PM, Richard Henderson wrote:
> On 2/6/26 14:21, Pierrick Bouvier wrote:
>> In next commit, we'll apply same helper pattern for base helpers
>> remaining.
>>
>> Our new helper pattern always include helper-*-common.h, which ends up
>> including include/tcg/tcg.h, which contains one occurrence of
>> CONFIG_USER_ONLY.
>> Thus, common files not being duplicated between system and target
>> relying on helpers will fail to compile. Existing occurrences are:
>> - target/arm/tcg/arith_helper.c
>> - target/arm/tcg/crypto_helper.c
>>
>> There is a single occurrence of CONFIG_USER_ONLY, for defining variable
>> tcg_use_softmmu. The fix seemed simple, always define it.
>> However, it prevents some dead code elimination which ends up triggering:
>> include/qemu/osdep.h:283:35: error: call to 'qemu_build_not_reached_always' declared with attribute error: code path is reachable
>>     283 | #define qemu_build_not_reached()  qemu_build_not_reached_always()
>>         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tcg/x86_64/tcg-target.c.inc:1907:45: note: in expansion of macro 'qemu_build_not_reached'
>>    1907 | # define x86_guest_base (*(HostAddress *)({ qemu_build_not_reached(); NULL; }))
>>         |                                             ^~~~~~~~~~~~~~~~~~~~~~
>> tcg/x86_64/tcg-target.c.inc:1934:14: note: in expansion of macro 'x86_guest_base'
>>    1934 |         *h = x86_guest_base;
>>         |              ^~~~~~~~~~~~~~
>>
>> So, roll your eyes, then rollback code, and simply duplicate the two
>> files concerned. We could also do a "special include trick" to prevent
>> pulling helper-*-common.h but it would be sad since the whole point of
>> the series up to here is to have something coherent using the exact same
>> pattern.
> 
> tcg_use_softmmu is a stub, waiting for softmmu to be enabled for user-only.
> Which is a long way away.
> 
> It's also not used outside of tcg/, which means we should move it to tcg/tcg-internal.h.
>

Thanks, I didn't think about moving it somewhere else.
This does the trick indeed.

> 
> r~

Regards,
Pierrick

