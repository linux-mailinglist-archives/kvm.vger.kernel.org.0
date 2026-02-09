Return-Path: <kvm+bounces-70583-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id d3zZOgWIiWl1+gQAu9opvQ
	(envelope-from <kvm+bounces-70583-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 08:08:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 64DF410C544
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 08:08:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D91E43008D34
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 07:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AA62E54B6;
	Mon,  9 Feb 2026 07:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KX3zzn0U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9C2450F2
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770620923; cv=none; b=EzNeaspIVrj93xnYe1A1Ws8KGK+e1jE0MQeD/FUys+0spbl0gSlN5owSlqBOMmJtEfmeEjnswabE7HXxR3hXPmnXobK6ArB59uoFwOEVwqCSz/+WRARLFNFIgKY83XfsINxVL2dX4Pp5BfL6juYhQQQK7TxTAr1xR3PtX3AE5vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770620923; c=relaxed/simple;
	bh=EZYUD5+KJqUgR0yt7DOS/mqm8ez6Rb2C05scox1rwMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kuv/zjqkqSVP4+uUJOeHN+MKqxHLL2DXc3PggzG3mn40yAbqwjOSL+NyaGKptIf3wX82sxFampTcByMLtTHuJ7aEYDYQPTml0earDV8PAyX74CMgUN2Ow7DOlUYTuWHBOsgD92otOG94qDE51XjRAnDLFEe/YiA6yYycFi+sN24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KX3zzn0U; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-81f4ba336b4so3326260b3a.1
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 23:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770620923; x=1771225723; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wncuITwrtEChkffVzXmna42OBWtwxX9kHQYFhcI0LHY=;
        b=KX3zzn0UPaNi0abvvQgqFU42EmFPe025tYMIwV9DR2dZSb5Xe8MJSSN8qicLkqZZcP
         memOYElgoz2eADNVodLMVG09aJHzxPc+MhGIYukffIp3lh8f2/GhQjRlwQG/2VzxPOln
         b3uwGcSbXIpY0/A1fPbWSbNz9jSvDL2JiWGzX7JcOLmFGHcD7ZVMUe/7vHKFGLjEBZZA
         TtuM1pA2UvtTOkZK4eTO/mmjwLjFVUukytGi8MwYaWn35OkVsjL4liAGxp/7T0qqdrMq
         MWXBMm8PqnCdGkJ3DRPZtA9JprGQYYxE93xY9LFspmrCRIYwW6fVymuw7ON38IK1VaKQ
         ddkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770620923; x=1771225723;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wncuITwrtEChkffVzXmna42OBWtwxX9kHQYFhcI0LHY=;
        b=tp8n5QvqnfAEUr4b2z6pj89xZ3fYtiqp/kxIfTuolExaZqGa8xRQj258De2FxTByCX
         ODdDS29QP75Fh0KLg2MQCngsfF+A2D7+uswGqQdFmLIhE08T8Z8QXRL+WgupCKvYRejv
         TilovPUq7ajWTcCtgtModVRCh36Gsa2bd70aiMh4VQOSgSqxgdEvQXWKpOHtUIkJ149i
         ghXhsrWntukke0SkEET2PnkOvsnBmh/mkuQyXDLqyFajwHd8brQ7SjdNnyMFQJunQTqZ
         6/Toblm5qJqnkDEnhFYVC4YcOD6luBoSBHCcuwUetyIFxYsxzzpHrImfxrAxfKR8O+Tq
         ++8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUD8EpuPNdYzZNVGqQgW2zoFExcy+VxPlGTWwL+4FpYybsv5kLW5ZPdzHzB3LMiajELb2k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9uLFthSbFI7LcFOilPLu0IIEJqVOdU36O4wNVhMhA3ZSPZDSx
	2NPMBDAuCBdpGxswJdD5nvvRuqftdQKN1NSxy2f1lKeGhLnyvUF38pxZlx9CzoIfQNY=
X-Gm-Gg: AZuq6aLTAak3THFIBh1zKLETYDAwFYe6ppDqI+7aqlzxh09SuW7ENLnStI6bqSnHxqB
	Ep4PotDgPk55ptR1GSsBmunil9lgJLdwMJgfDEiFsfDlUbgWx5tL0Q+3MRPr7ekEzjivWblrjtS
	qLJWmijRU+qVvVtZillSJ/Eze1nq2vgHbTHVuKo7AjFnbDMiXFRTBBPFivMlwhfjXhebwMj5FwN
	vjFU2SilBth0rgQp8TzPKal1A2RSwmGk15VKqTL3GbUPZ8Tc+M9bLXERco6vEXMtEKQnS2orfRT
	moT3+Pr/A2c88Cc1xXixj1fPP4NE06x6mV992JyDsqdDBfq3J67CvlUrxvAOBIwRs8l9Ac5j50T
	T6C6Zfk2iMyTarn7R5EYRYiNHeVK9J5PolWFfCgZ0zWecZFicbaQhhvmP8lh7Z8S+Rbftc5/bny
	wRUr1qxNrWkMLlZegyATZtdQK6iUpwLhJ1tWY5b345uJ5Bjj3bHVw5J+IPn3zKhkqRQ/lJ5nzk4
	A==
X-Received: by 2002:a05:6a00:1253:b0:81f:997e:59a0 with SMTP id d2e1a72fcca58-8244176e218mr9717502b3a.64.1770620922529;
        Sun, 08 Feb 2026 23:08:42 -0800 (PST)
Received: from ?IPV6:2001:8003:e109:dd00:7b35:2dcc:ff07:8193? ([2001:8003:e109:dd00:7b35:2dcc:ff07:8193])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82441695f50sm8737954b3a.22.2026.02.08.23.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Feb 2026 23:08:42 -0800 (PST)
Message-ID: <a6320ab4-7ece-4618-8d73-549df7a34886@linaro.org>
Date: Mon, 9 Feb 2026 17:08:34 +1000
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
From: Richard Henderson <richard.henderson@linaro.org>
Content-Language: en-US
In-Reply-To: <e291f290-a188-4106-8648-48d4c464dfed@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70583-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[richard.henderson@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: 64DF410C544
X-Rspamd-Action: no action

On 2/9/26 15:52, Pierrick Bouvier wrote:
> On 2/8/26 9:00 PM, Richard Henderson wrote:
>> On 2/6/26 14:21, Pierrick Bouvier wrote:
>>> In next commit, we'll apply same helper pattern for base helpers
>>> remaining.
>>>
>>> Our new helper pattern always include helper-*-common.h, which ends up
>>> including include/tcg/tcg.h, which contains one occurrence of
>>> CONFIG_USER_ONLY.
>>> Thus, common files not being duplicated between system and target
>>> relying on helpers will fail to compile. Existing occurrences are:
>>> - target/arm/tcg/arith_helper.c
>>> - target/arm/tcg/crypto_helper.c
>>>
>>> There is a single occurrence of CONFIG_USER_ONLY, for defining variable
>>> tcg_use_softmmu. The fix seemed simple, always define it.
>>> However, it prevents some dead code elimination which ends up triggering:
>>> include/qemu/osdep.h:283:35: error: call to 'qemu_build_not_reached_always' declared 
>>> with attribute error: code path is reachable
>>>     283 | #define qemu_build_not_reached()  qemu_build_not_reached_always()
>>>         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> tcg/x86_64/tcg-target.c.inc:1907:45: note: in expansion of macro 'qemu_build_not_reached'
>>>    1907 | # define x86_guest_base (*(HostAddress *)({ qemu_build_not_reached(); NULL; }))
>>>         |                                             ^~~~~~~~~~~~~~~~~~~~~~
>>> tcg/x86_64/tcg-target.c.inc:1934:14: note: in expansion of macro 'x86_guest_base'
>>>    1934 |         *h = x86_guest_base;
>>>         |              ^~~~~~~~~~~~~~
>>>
>>> So, roll your eyes, then rollback code, and simply duplicate the two
>>> files concerned. We could also do a "special include trick" to prevent
>>> pulling helper-*-common.h but it would be sad since the whole point of
>>> the series up to here is to have something coherent using the exact same
>>> pattern.
>>
>> tcg_use_softmmu is a stub, waiting for softmmu to be enabled for user-only.
>> Which is a long way away.
>>
>> It's also not used outside of tcg/, which means we should move it to tcg/tcg-internal.h.
>>
> 
> Thanks, I didn't think about moving it somewhere else.
> This does the trick indeed.

You can also make it always a #define.  The variable for user-only is never set to true.


r~

