Return-Path: <kvm+bounces-71877-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EC8ONTJQn2n+ZwQAu9opvQ
	(envelope-from <kvm+bounces-71877-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:40:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7E319CC6D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 20:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDA5F304AA1C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 19:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429D13EF0B5;
	Wed, 25 Feb 2026 19:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="f+aoG11C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641BF395D94
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 19:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772048425; cv=none; b=bljdzGaTt/uwKSvhjjkaAzHyhBAA72va+ojpyfWKQ9JUWA+sD60ZE11dbUcTbvgcRgdUdRVYTV9+XNvU27Yy6h3Rm7C966l826vOW3xZFg51o6fTqn0xhWY9FuZBRNYRZ24p4Z9483yjJR0K1VBhM1Amif5VbsNSyLm+BljiV8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772048425; c=relaxed/simple;
	bh=kwPrsXbqLXi+U2dW2sMxp9nmgs7mKcd6/Sjlv3/jN8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqWdZ5hrgiW6M9oj3jx0sT5ksHT+XkpjIY/cYr+DFVcqVCW/F/i5+sImynk36gRtoZgX2IIWAdOLea6aM88k1d8npbf+exycgS5iGoFELz0cVV+Mj/Lglxoe+L380Q06TVu337xfGZi+ypJHs5MHBcxQYobRdzInT5n1f9vpiU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=f+aoG11C; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-824484dba4dso138365b3a.0
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 11:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1772048424; x=1772653224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QdPCqf+ZgvZyaMYq7z8u2nsVi2kkVmJgqOcGRdKnmy0=;
        b=f+aoG11CcV3Nb1Nz2TYkhjA8tiYLo382q0gIuA0d0JOiiYiSi65/mGStvQS+S4eIfn
         Ew2Cej9A6aIC0uVoD7oKLehNJvQFqlgZOmnaw9duvgD/byn2B2MqkVO/1fflTAEeTD7l
         psllt/5Uq7kGqgjbetk/mbtM0BZaU6t4KqOz+bjcJN+RDQBtVYEKowdpFW7CXu9UdiG4
         dqnGwG7uoXHh4WllB01TaGXDdWmm/3+mEh/C83wwdaXknQpGrx4b56yvzVID4XyfuM8m
         cR3uGTf5t2vGcSpROgyNR25Jdaxyr3/o2VilouRv0pOVuxXB6+ECaRzgPCTVUAxSHR5U
         g6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772048424; x=1772653224;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QdPCqf+ZgvZyaMYq7z8u2nsVi2kkVmJgqOcGRdKnmy0=;
        b=IqwT779uhJK45bR0LioenOkADXASim0dmTWu3xXWrfMXEnMRCgV/qYrvPBNVhg0tEE
         Jg/ft7tFPZFl3y8TDGmz8lC2meceUApB8eYXP/7lPs3ICehL2KXQ9s4s+BHBXtKWYgyg
         7y8Lrq06EiyYKbREvgxGn0Ng5fBhP6x9Jp8LhsIjiwVYSmmpMMtgePu6kePP4Z/bhXDU
         Bo7UaWi8+Xb78qM7U4yenrx8npmims8S2XmqdBsvSSuV9blNaZeJIZnRLpd4dZzpB+3z
         9z/mpy98AWB10l2wXSrfDJyfFw8UHGLXMu1/KgTjuBYJZDj/4AirfisXnV4ZZxUc/jiY
         klVg==
X-Gm-Message-State: AOJu0YxXq0HPWR3eLfU2QAPigbz9sywSstAIk0dG6NC/GxOJWTOWcmf5
	Svc5I5xXZVArwnoN0Oodc/pL09ONQYZOOWiIV+b3QDQ9a+TdL9+9icQ72NJHjO4ieiQ=
X-Gm-Gg: ATEYQzwdfZnOsMdd8G5jAKq5VH4+WUNJ2nz51yqVp9+fXYqoMqwv7sDL/GQa0qmU4Dj
	DUr2Mnojskxb5cibp3MlRFkoqS+aaFndyaXNfzHSs7eWyjK6CePxkfgwjvB5pWeOkyghhPOyz71
	NPmaY3Jeha71f7t1VaQeSZYiyai0K2iI2bAe5QJA9tmwQe5T5FHfc+H1fUHkcRizU0QHohS8eep
	zUN+77c+FhPSIStSpfg+bzSCQx4snDi8OJgdku+DZJ201A7v07XC9oB0n/XRvT2TssWLWLc2yNL
	3W6bNVTfDgA8RIDV8RqJzQ3rvppp5w5eJC3kIf7VucTrvMW7zyOcha25/aR647ErDaQToCo87PG
	u/XUkrfeMwXb/I6s/KRZOzF/R3yxhqkK6oN9xf3pZ3H/7JaeIRY8jOgxTcj181+deEs4QpvDrJT
	LF0++Bp1DGsntueWGcMJHN1YrVZDm0cffmgBxoNcus6VoPAHtvD3OvZsNc948ALK+gwjGU
X-Received: by 2002:a05:6a00:2e11:b0:81f:50ea:5da1 with SMTP id d2e1a72fcca58-826da8bd871mr16961315b3a.2.1772048423601;
        Wed, 25 Feb 2026 11:40:23 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739dabd43sm46995b3a.25.2026.02.25.11.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 11:40:23 -0800 (PST)
Message-ID: <9dab95ec-f4f0-4e5d-bec7-b773edddb3cd@linaro.org>
Date: Wed, 25 Feb 2026 11:40:22 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] accel/mshv: Forward-declare mshv_root_hvcall
 structure
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org,
 Magnus Kulke <magnus.kulke@linux.microsoft.com>, Wei Liu <wei.liu@kernel.org>
References: <20260225051303.91614-1-philmd@linaro.org>
 <20260225051303.91614-3-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Autocrypt: addr=pierrick.bouvier@linaro.org; keydata=
 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
 ZtfdHNZotF092MIH0IQC3poExQpV/WBYFAI=
In-Reply-To: <20260225051303.91614-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71877-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 4E7E319CC6D
X-Rspamd-Action: no action

On 2/24/26 9:13 PM, Philippe Mathieu-Daudé wrote:
> Forward-declare the target-specific mshv_root_hvcall structure
> in order to keep 'system/mshv_int.h' target-agnostic.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/mshv_int.h | 5 ++---
>   accel/mshv/mshv-all.c     | 2 +-
>   2 files changed, 3 insertions(+), 4 deletions(-)
> 

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

