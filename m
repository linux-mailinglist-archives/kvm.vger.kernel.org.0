Return-Path: <kvm+bounces-71357-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDpaN1Q7l2l2vwIAu9opvQ
	(envelope-from <kvm+bounces-71357-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 17:33:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45317160B58
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 17:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 198C9302A05A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 16:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9778C34C155;
	Thu, 19 Feb 2026 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fDpVWMqD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD81EB9E1
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771518733; cv=none; b=ItSsCSEN/+XrPqccd6gLfMUdfqNP68AG3p4ajbypIcugoqfYbNJB9Lx90PxmJm1OaqMq5uKRwjphJoTOQRQ0TraZzZqFHuq7OnylryjhoLAUuGVgm5b59Epi2GHvld4ab7dair/2OG6JBiYYzI9iob3ZnTwrvO352siyGIImzI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771518733; c=relaxed/simple;
	bh=JmWWMAp2e5I9ZfHPfaA0ctAwMY6VF+N/tTp0wWP13II=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tX+JUfKHLzvK3glLrLEeW5EyZ3ZvojHPluL9ZOtfIH+CQ38OoNTu6Ab748mGv4Up1WcGuJ9WXf9z+XR4jnNPXWc/VtBB6xFIC1r/f+hH2bboM6HxB7t8HONyQRCm9meK1yujzo2wUtSDMCPm1Mo5MYDGKuEUZJLAoVhgL3xFmi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fDpVWMqD; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82361bcbd8fso591501b3a.0
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 08:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771518732; x=1772123532; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BmTh0jnwm/7Hn5VDO6WKksEgvE6xJqIOQ06tdlnmZ2w=;
        b=fDpVWMqDVJR8Janok4YwPVy6W6tJDf75nukn+UNtXAiiK6wTa9DDVwLfQc4gdNNYrK
         GFhFAHjrPb8Z+VscSiQ8g6Xc8P+cBvCpePFMP+r/wTOLuSlELAb6Q5N1Pqn1FI1q9sK7
         1kK3DoKXJso4BNlg561uM9soUMYduSlC/2DjceWM7OYb2tAzimJN9V24gcTBXuunOjBt
         t1orPIQDkm50mv91+KZUpg5UMqZzq2T/tKJ2VNQbqSoEiR9jIFCV2sEQC1dt3yYXrFMd
         D/v+gZWo7oT9cXr7z1cRygBPdUpNLyRcpGOKuoLnx1h8G4QQODJKok1s8KTizXfi7A86
         VrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771518732; x=1772123532;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BmTh0jnwm/7Hn5VDO6WKksEgvE6xJqIOQ06tdlnmZ2w=;
        b=vA4OFr8d7GYVLVYpL/XouDC+iSmlFnpJ9G7h9cYsIQIxvtQWzBqQYLFHIT7tMbo+m9
         M9y7VbzbhREjDoYy+uYTuLW/umfQ0jiTSTmZWqJ4xlxfQsE+zg3d+ox53ZA1lepFeQHn
         Bm1LOmcZHELMDuqYY8qFl8MO24QiaUSfey8kXcGR+zu0ISFmt+ghc+02YvDDLtkpi63v
         dTD2AOzqgfiCqoBCR065GVInF2+SGg3ffVlQGvoDoJdcPCjvqmCDl2RflfeI4RROvHk1
         NucHTIOK/GT2w79mcJwzAlyf+VxAib55OHiSUl2uEGzBq50LZVf1O681e2ECNJzFrof5
         5RqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1pULvGeQTRh3TyM/tbu9ntuMj5JSjsKpiRoDMKNr+OUhgxMCbYfs6rj+B1rC8MwKx/qQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzznmJzYPRLIDbuDQ3Xc56N6BbJYy2ec2zs7AkqalLiW1fChkHJ
	e3tivSNxXYON3gALFzujw5oeJp05xrrgT0opiexmdIGwZ9N6hI/CakyTn9ZFnX241Rc=
X-Gm-Gg: AZuq6aKzNv3jjtSHYYE4aYH/w9UDm1PcrQgCgm9/8DgPyCCtZb2q2ps5vl4SULhNOBU
	ySNOvx9BT/z/Y+l4OLzUbkIVrh3zx0fEv3VVsp0nv0750B5CMNVODl9EDxv/wpFnY5Z+dRlJVpJ
	P2ZVFGxEPd1N4or7KPP4a4yyHhkPXTXOFTGmPxB4ft5LQ3fC7FREZ7M3fHWBuD7z4INl+8eiY91
	Z5beUKgFKDHQwA9y4qa8JbhpVkl+jMvSfSY0dWthql1NByAkEVn/Nc+W0w9upKFtyBjp7kmMW6h
	X1PHS5mkI/0SlESVpLDk/w6hallqRnGADP9K8Belhj5xuZTK3TC/7ztXLZC4gan9IDajh6kwUCU
	IWloKgqmLaJ0Vp00YBVUv9nYl8A2b9Z7rQ2ckfJeINJC/2M34+CCbyz2OfLqbKvf6RHynbXyz8i
	fkDTtgBcPrfRKwue21kmFE6zDiWBmLtqWqT2KPq4+UA9SLbe2MUBRUiEHpof0POJ+PALTF
X-Received: by 2002:a05:6a00:6c83:b0:824:b1bb:f6b4 with SMTP id d2e1a72fcca58-824d95f49dcmr15511190b3a.39.1771518731964;
        Thu, 19 Feb 2026 08:32:11 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-824c6b69f14sm24859331b3a.35.2026.02.19.08.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 08:32:11 -0800 (PST)
Message-ID: <37acb360-6425-47c8-8452-cd0c610c2fed@linaro.org>
Date: Thu, 19 Feb 2026 08:32:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/14] target/arm: single-binary
Content-Language: en-US
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, anjo@rev.ng,
 Jim MacArthur <jim.macarthur@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
 <CAFEAcA__tnvy9dUUPrEG8jynGGSp9iz0H7Q2MFGdw4--NDH-ng@mail.gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <CAFEAcA__tnvy9dUUPrEG8jynGGSp9iz0H7Q2MFGdw4--NDH-ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
	TAGGED_FROM(0.00)[bounces-71357-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[target-arm.next:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 45317160B58
X-Rspamd-Action: no action

On 2/19/26 1:38 AM, Peter Maydell wrote:
> On Thu, 19 Feb 2026 at 04:02, Pierrick Bouvier
> <pierrick.bouvier@linaro.org> wrote:
>>
>> This series continues cleaning target/arm, especially tcg folder.
>>
>> For now, it contains some cleanups in headers, and it splits helpers per
>> category, thus removing several usage of TARGET_AARCH64.
>> First version was simply splitting 32 vs 64-bit helpers, and Richard asked
>> to split per sub category.
> 
> Thanks, I've applied this to target-arm.next. Patchew says the
> last patch here is the same as it was in v4, so I've copied
> the R-by tags from Richard and Philippe across.
> 
> -- PMM

Thanks.
It's indeed the same, except patch 8 which has changes to accomodate the 
two new patches in prelude.

