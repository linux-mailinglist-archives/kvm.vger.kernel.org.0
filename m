Return-Path: <kvm+bounces-70803-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFNYEP+pi2naYAAAu9opvQ
	(envelope-from <kvm+bounces-70803-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:58:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B472811F91A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D74903047BF9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2A7338585;
	Tue, 10 Feb 2026 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZvmkS5wA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3470E259C80
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 21:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770760695; cv=none; b=pEOerphBMlI4YX4wyPMbkpO4mS3+i2+kusOgJNJq4S8lfJ9EI3X+T/KXNEPdgdntGDrGRBrMftrS81XnXF+FsquX7OEC7Y2RaGAdLmBwkQM0T1wjS3DR8iBmiYiVjdExTKt6iGYE39Lnj+fFNhuDC91vzcFZ78Go1CfFZLlmzWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770760695; c=relaxed/simple;
	bh=6LokGVTMNNlUxqeKsCn4OYYYdvVDkm9tavZV1GR1So0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wgn0zptjRnLLkkOq+ZMM0vEUR3cT3+9wszD1HNdHCkrNa19BjAf7srEMTXkE48+KHeQ3GA99rtkeVtHXxQAaSLPDMa7XNY3zBhLmO5QVhRo9gBb61NryTv2NKUy+nJ4OMBKW74u+PYYnrWnWgzmJJITkwnR3jYJHJd/rztqQfCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZvmkS5wA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47ee0291921so45268935e9.3
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 13:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770760692; x=1771365492; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tcA7sn6CW4GwfOM6ayVN5Eb6f+qLKKiPpfVeslJ3rL0=;
        b=ZvmkS5wAgwsqw/WpjJEXAOzXe0bvpE+79yOIggKwRZwojGEbOAd6nwWAJZQG+WJ5QY
         FVhAWWLQ7puaEgMHjo0vRlQtKXI3if2a1DyIlV6gZziv0fe/HM6O2CnsdbGAmjOKnm3K
         zb8FGyB83N2bwnuVTJEZCDBVkZsWj0zAQlZxq75AnT2n1BB8cH962yBdEhYUcZ0OL+AU
         AUTtvpuk/ob5U/aGSn1yTk6T+n59msWVxbHK+8qtdkoFOqvrVmnciQOYZaLpE34J6z5r
         1ZntLK7RvUJ0KnVBy+5N9wNtwQPIZj9MIbyClB9qpHPCxOOljJjxrf0EeCieo1k1ae/W
         b14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770760692; x=1771365492;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tcA7sn6CW4GwfOM6ayVN5Eb6f+qLKKiPpfVeslJ3rL0=;
        b=VPe/JMPVxrCoWbZhvYJ668TjhvOLx+ilivNxSNnoepJ+AMmYs2CeB5T/2TOGADTU/i
         jGJwLcXKd2FWByXspbNyU+PSIWo7ITROK27+DkmwXzzoKam8TkNY/EEZaWItCyMgGRmN
         fuuzv0ayy1hb8+ZkZuiO92f+DcMYvbP1yrUOXOEUpc18S0q/gkhYMFi6CtXXMzy00+Z+
         tUHas27tg4IIXo8RrmDI0KMIcKeJ7Vji4hxbI1ewIt9CA3ITPhmqOBUyOSXBDRhMugR1
         yeMt68PAOD4ATx0zNY8X6/Fq0Kb7eU6ieVjGxrrrNKqB6prkRE8VHIp/dXdRuRgrKM/o
         Xt4A==
X-Forwarded-Encrypted: i=1; AJvYcCVpU51oye7+W8JAH1VmmGWGwiSxeg6HWm9cIj9nfILnoELAD7txRS+5UjpbcgEG3ejp59w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxXKBKY/2C8klmb9zCKiuf4nQUQj0KNuqb2jD6CJU9tIj4XAAY
	QXsn7y/uVn8Rmee2FWq7TBKPIyxb1Qqt2Jl9eHWrghfVo2LZuMMBsTNo1z0mk0szXo8=
X-Gm-Gg: AZuq6aIhHYfceu4CoksWPdxl4WEaPh6sW/OgD8yK2IcInkGAOw3meBYvwegN0hhussk
	05A80YzYFrCzW6tmVxPalW2uphQKOyBPrHq/D+xPjiv/M0JBdI0uPIkVn7B41kzD+S1dHH91hG+
	M+bsh8B6QW1he56jdbkL4noebsfUICyIwfiAws+fT/EKCZLf1S5BUph70khCtmwZQoKBO4BzgIv
	rQ43UTRKhmWpdvh1CNErtHTYoYqnRA6AaPIVbQMgTxM20iDe5o44+GAhw4zw6wbzJSSJa40iDJa
	/PtT+3QDezgSqpnjn55yIoDIYt40g9N/M9Bgay7fdcQZTb5e1lwFMuQrGx8w5rlTrRSxeYq6tEW
	xpH/dJgSWTQL3//QS5akzKJcv4Ok/njVQkT9WY/1lhhGkaa2BHOPfp6qdZVWB6evVO7OrXWup7Y
	S8PnG7hJouskDGT/xO2LTNhSUlX5Oo2X2JQJt8fZrapeaRsB94sJ8K58fmzTRtxbqrp7XDqcFGd
	guP
X-Received: by 2002:a05:600c:64c9:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-4835b92bfa0mr5400205e9.18.1770760692509;
        Tue, 10 Feb 2026 13:58:12 -0800 (PST)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d7e50casm78313765e9.8.2026.02.10.13.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 13:58:10 -0800 (PST)
Message-ID: <48d6d5df-1a87-4cd4-82ce-5f67d8658e44@linaro.org>
Date: Tue, 10 Feb 2026 22:58:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/12] target/arm/tcg/translate.h: replace target_ulong
 with vaddr
Content-Language: en-US
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: anjo@rev.ng, Jim MacArthur <jim.macarthur@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
 <20260210201540.1405424-11-pierrick.bouvier@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20260210201540.1405424-11-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-70803-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: B472811F91A
X-Rspamd-Action: no action

On 10/2/26 21:15, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/translate.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

