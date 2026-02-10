Return-Path: <kvm+bounces-70796-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEw4B7KSi2kVWQAAu9opvQ
	(envelope-from <kvm+bounces-70796-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:18:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7416011EFF3
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:18:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 97C9C304B5C8
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F0A2FE07D;
	Tue, 10 Feb 2026 20:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JS1frftL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2321B23B604
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754730; cv=none; b=KVFjnjWY7CxmtntL1uQfTssNgKPP7s+6w2CEp12ovW0UYe4xs9AuTe7aLxJhg8OlSZQ8jOIKhZvXkyHIv24152f+kbzKNHZ69KzdxIhyWWBbY+wAPRSThSda062NYHWmesD8jxGbl0mbOaB812+5+pf604ECOkzngDG2eTGsr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754730; c=relaxed/simple;
	bh=MGPeLhBGxg/ZF1DpFcOkMREqrd0xbx+gJtkgScgbAqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1Oo7mDcPetfdcYIXmNGsmZ6bpLIwvBpSyjD4bk1XpeeJhCuymVDLCqxI3jNq7Joy6fCrwvCYiifJVGOd7RzrDjCVtbYQ6ZDjBTfg7fV2+UErIHuLQYS8RkQ40QHWcNaeiFz6G3SDMJWEZyPwMFRPH08jQ/JPx/hjp0FuL3ElZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JS1frftL; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso5076874b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754728; x=1771359528; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vk1AQAl1soVZV08bSYmk+fpl1vhx4T7RJvodI5vrQ0g=;
        b=JS1frftLYsWh30Sijn/J2hrIWkRXMX76LcxGfUwZVksB3SMgnk1FdRvHv8Vu8ohIeW
         PJhvC3AYsOB9USL+9fSHB6TyelU6QP0F7fJBQ69hXqHOfnU996/kY0lF+OL7Ch8qq+aO
         jf7s9hmgO7JIb6nSSIRvKr5Ob6306/3pSOIEser02gfwHtO/22H75j2xa/6tCwmT54Kg
         iVyIzD1rqNw7W1/iD8ol36+97lka/3mUCAotSW9EIjojy40D6ldVBAWYoYOsLqJczGR3
         8yY5rYUCnmgVRbB2WZ/N1PZ0wVg4XyY+z+eBVsw4xUdJSO/jTsWHV+IavlJ8Q3hKWkIg
         HPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754728; x=1771359528;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vk1AQAl1soVZV08bSYmk+fpl1vhx4T7RJvodI5vrQ0g=;
        b=ntZOxmAbXHdRlWqpjmr7uBV0cwZWWBF2xTWuthozsbA96+Wnz2PNwwg8EB7xeZd8tQ
         yDQiItd01GFwq+bKA4ZYloMzdOaqwCvUdVZ23Si63XzV+4dr1sVO3R7skV8iVxprlpjQ
         rK2LVZpBWcAD7s79fbayrSMcWJfffZZYVK3tYBpebN3rSpCeov2c7EhHyAbQsm+qhssh
         sAyK5HkPWdCx8JAc44Va8ipNi+w0ROyzI/KDo2xfXNC9/iPUpe19xWT5LcZOnoF2iSML
         N8Y/BsJUK9TvEpAi9QcNx59XIH5zvehcaajglTRuJVE1uY8O9doGuvg1oSbzFwBvx3nQ
         w5mA==
X-Forwarded-Encrypted: i=1; AJvYcCWcDVbTzfbID9+b1V5h34EB4Se3o0Y+pJ+jzbGn4g+02881NiBy7cb//Apau8ozmSeFeHw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUNpVEua5NxuIXurqR07taIt7EV2svo+S0VM7H/3OMTTIYq+4h
	DWW4r6MjNkS4jGWu6E+74WfVqHMYdCagFFU8VkSlMahAM7DvPJ6FRy+1q+N5XPLr7uQ=
X-Gm-Gg: AZuq6aJ84fmhinG8TjCdBQKkKLnS9KRAP5KNfnbCN6k9QCD8PMyIkQWHh0V1FJINCn8
	rU0fC9gBZdXLma31TjeF8MHCaW7ThEx5hgkPdVrIz9jUw6DDgv/QDkqOljsEMqw2Cyyq6Ta5Nqq
	iVdlp7CuIPdOt9gW1xn1ZSbi1A+iWQjh8TCAYCw8p1srEQFrwkbHk0pkqGpfqv4Za55NoI5ks1f
	FUjrTiUf1Y0ffsTpkIuAvLf99AaUsfAWyibzh8xTwOTocW6IaxNUFb4EW2stTPKznVIkJqEGLya
	no+Wp54icPC7i4avqRWmmdRDr1OavlWcjuWRJv6WmyrJu7L2yQNk9DkVggzTid5dalasDyuDatM
	nxCWJh7FXfqafv2UW1uRimalGAxsJuAp+LJRGJpVsXmNiUecvmqqmKmUG5JNO7TKZ5L0uHlUpDV
	75Z6Rq4WcRn5gZ1UwyExvK0/Ow5MO7KafGzNsPXIPf22QLhVTetkPd4emAtnNcaN/Apxsn
X-Received: by 2002:a05:6a00:6b95:10b0:824:93e4:2ddf with SMTP id d2e1a72fcca58-82493e431a0mr884781b3a.13.1770754728379;
        Tue, 10 Feb 2026 12:18:48 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244169804bsm14018650b3a.27.2026.02.10.12.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 12:18:47 -0800 (PST)
Message-ID: <c13897e1-cf21-4131-af74-14153c5fbd0c@linaro.org>
Date: Tue, 10 Feb 2026 12:18:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] target/arm: single-binary
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng, Richard Henderson <richard.henderson@linaro.org>,
 Jim MacArthur <jim.macarthur@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, kvm@vger.kernel.org, qemu-arm@nongnu.org
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
	TAGGED_FROM(0.00)[bounces-70796-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 7416011EFF3
X-Rspamd-Action: no action

On 2/5/26 8:21 PM, Pierrick Bouvier wrote:
> This series continues cleaning target/arm, especially tcg folder.
> 
> For now, it contains some cleanups in headers, and it splits helpers per
> category, thus removing several usage of TARGET_AARCH64.
> First version was simply splitting 32 vs 64-bit helpers, and Richard asked
> to split per sub category.
> 
> v2
> --
> 
> - add missing kvm_enabled() in arm-qmp-cmds.c
> - didn't extract arm_wfi for tcg/psci.c. If that's a hard requirement, I can do
>    it in next version.
> - restricted scope of series to helper headers, so we can validate things one
>    step at a time. Series will keep on growing once all patches are reviewed.
> - translate.h: use vaddr where appropriate, as asked by Richard.
> 
> Pierrick Bouvier (12):
>    target/arm/arm-qmp-cmds.c: make compilation unit common
>    target/arm: extract helper-mve.h from helper.h
>    target/arm: extract helper-a64.h from helper.h
>    target/arm: extract helper-sve.h from helper.h
>    target/arm: extract helper-sme.h from helper.h
>    target/arm/tcg: duplicate tcg/arith_helper.c and tcg/crypto_helper.c
>      between user/system
>    target/arm: move exec/helper-* plumbery to helper.h
>    target/arm/tcg/psci.c: make compilation unit common
>    target/arm/tcg/cpu-v7m.c: make compilation unit common
>    target/arm/tcg/vec_helper.c: make compilation unit common
>    target/arm/tcg/translate.h: replace target_ulong with vaddr
>    target/arm/tcg/translate.h: replace target_long with int64_t
> 
>   target/arm/helper-a64.h                       |  14 ++
>   target/arm/helper-mve.h                       |  14 ++
>   target/arm/helper-sme.h                       |  14 ++
>   target/arm/helper-sve.h                       |  14 ++
>   target/arm/helper.h                           |  17 +-
>   target/arm/kvm_arm.h                          |   3 +
>   .../tcg/{helper-a64.h => helper-a64-defs.h}   |   0
>   target/arm/tcg/{helper.h => helper-defs.h}    |   0
>   .../tcg/{helper-mve.h => helper-mve-defs.h}   |   0
>   .../tcg/{helper-sme.h => helper-sme-defs.h}   |   0
>   .../tcg/{helper-sve.h => helper-sve-defs.h}   |   0
>   target/arm/tcg/translate-a32.h                |   2 +-
>   target/arm/tcg/translate.h                    |  22 +-
>   target/arm/tcg/vec_internal.h                 |  49 ++++
>   target/arm/arm-qmp-cmds.c                     |  27 +--
>   target/arm/debug_helper.c                     |   4 +-
>   target/arm/helper.c                           |   5 +-
>   target/arm/kvm-stub.c                         |   5 +
>   target/arm/kvm.c                              |  21 ++
>   target/arm/tcg/arith_helper.c                 |   4 +-
>   target/arm/tcg/crypto_helper.c                |   4 +-
>   target/arm/tcg/gengvec64.c                    |   3 +-
>   target/arm/tcg/helper-a64.c                   |   6 +-
>   target/arm/tcg/hflags.c                       |   4 +-
>   target/arm/tcg/m_helper.c                     |   2 +-
>   target/arm/tcg/mte_helper.c                   |   3 +-
>   target/arm/tcg/mve_helper.c                   |   6 +-
>   target/arm/tcg/neon_helper.c                  |   4 +-
>   target/arm/tcg/op_helper.c                    |   2 +-
>   target/arm/tcg/pauth_helper.c                 |   3 +-
>   target/arm/tcg/psci.c                         |   4 +-
>   target/arm/tcg/sme_helper.c                   |   5 +-
>   target/arm/tcg/sve_helper.c                   |   6 +-
>   target/arm/tcg/tlb_helper.c                   |   4 +-
>   target/arm/tcg/translate-a64.c                |   3 +
>   target/arm/tcg/translate-mve.c                |   1 +
>   target/arm/tcg/translate-sme.c                |   3 +
>   target/arm/tcg/translate-sve.c                |   3 +
>   target/arm/tcg/translate.c                    |  25 +-
>   target/arm/tcg/vec_helper.c                   | 224 ++----------------
>   target/arm/tcg/vec_helper64.c                 | 142 +++++++++++
>   target/arm/tcg/vfp_helper.c                   |   4 +-
>   target/arm/meson.build                        |   2 +-
>   target/arm/tcg/meson.build                    |  21 +-
>   44 files changed, 391 insertions(+), 308 deletions(-)
>   create mode 100644 target/arm/helper-a64.h
>   create mode 100644 target/arm/helper-mve.h
>   create mode 100644 target/arm/helper-sme.h
>   create mode 100644 target/arm/helper-sve.h
>   rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)
>   rename target/arm/tcg/{helper.h => helper-defs.h} (100%)
>   rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)
>   rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)
>   rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)
>   create mode 100644 target/arm/tcg/vec_helper64.c
> 

v3 sent:
https://lore.kernel.org/qemu-devel/20260210201540.1405424-1-pierrick.bouvier@linaro.org/T/#t

